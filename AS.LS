     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E9CF35                  jmp main
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
   256                                  ;-66 int LabelMaxIx=0;       //actual number of stored labels
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
   277                                  ;-72 char JmpCallNamePtr;    //first free position 
   278                                  
   279 00000E50 00                      JmpCallNamePtr db 0
   280                                  
   281                                  ;-73 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   282                                  
   283 00000E51 <res 000003E8>          JmpCallAddr resw 500
   284                                  
   285                                  ;-74 char JmpCallRelAbs      [JMPCALLMAX];//r8, R16, A16
   286                                  
   287 00001239 <res 000001F4>          JmpCallRelAbs resb 500
   288                                  
   289                                  ;-75 int JmpCallIx;          //actual number of jmp, call
   290                                  
   291 0000142D 0000                    JmpCallIx dw 0
   292                                  
   293                                  ;-76  
   294                                  
   295                                  
   296                                  ;-77 #define FILEBINMAX 2000 //next number - max. oplength
   297                                  
   298                                  
   299                                  ;-78 char FileBin  [FILEBINMAX];//output binary file
   300                                  
   301 0000142F <res 000007D0>          FileBin resb 2000
   302                                  
   303                                  ;-79 unsigned int BinLen=0;  //length of binary file
   304                                  
   305 00001BFF 0000                    BinLen dw 0
   306                                  
   307                                  ;-80 
   308                                  
   309                                  
   310                                  ;-81 char *arglen=0x80;      // for main only
   311                                  
   312 00001C01 8000                    arglen dw 128
   313                                  
   314                                  ;-82 char *argv=0x82;        // for main only
   315                                  
   316 00001C03 8200                    argv dw 130
   317                                  ;Back to main program: AS.C
   318                                  
   319                                  ;-3 #include "OPTABL.C"   
   320                                  
   321                                  ;Use include file: OPTABL.C
   322                                  
   323                                  ;-1 char I_START=0xF1;
   324                                  
   325 00001C05 F1                      I_START db 241
   326                                  
   327                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   328                                  
   329                                  
   330                                  ;-3 //  1:   1 byte opcode
   331                                  
   332                                  
   333                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   334                                  
   335 00001C06 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   336                                  
   337                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   338                                  
   339 00001C0F 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   340                                  
   341                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   342                                  
   343 00001C17 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   344                                  
   345                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   346                                  
   347 00001C1E 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   348                                  
   349                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   350                                  
   351 00001C25 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   352                                  
   353                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   354                                  
   355 00001C2D 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   356                                  
   357                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   358                                  
   359 00001C34 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   360                                  
   361                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   362                                  
   363 00001C3B 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   364                                  
   365                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   366                                  
   367 00001C43 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   368                                  
   369                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   370                                  
   371 00001C4C 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   372                                  
   373                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   374                                  
   375 00001C54 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   376                                  
   377                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   378                                  
   379 00001C5C 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   380                                  
   381                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   382                                  
   383 00001C64 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   384                                  
   385                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   386                                  
   387 00001C6D 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   388                                  
   389                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   390                                  
   391 00001C76 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   392                                  
   393                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   394                                  
   395 00001C7F 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   396                                  
   397                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   398                                  
   399 00001C88 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   400                                  
   401                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   402                                  
   403 00001C91 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   404                                  
   405                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   406                                  
   407 00001C9A 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   408                                  
   409                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   410                                  
   411 00001CA3 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   412                                  
   413                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   414                                  
   415 00001CAC 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   416                                  
   417                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   418                                  
   419 00001CB5 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   420                                  
   421                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   422                                  
   423 00001CBE 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   424                                  
   425                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   426                                  
   427 00001CC7 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   428                                  
   429                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   430                                  
   431 00001CCF 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   432                                  
   433                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   434                                  
   435 00001CD7 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   436                                  
   437                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   438                                  
   439 00001CDF 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   440                                  
   441                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   442                                  
   443 00001CE7 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   444                                  
   445                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   446                                  
   447 00001CEF 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   448                                  
   449                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   450                                  
   451 00001CF8 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   452                                  
   453                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   454                                  
   455 00001D01 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   456                                  
   457                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   458                                  
   459 00001D09 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   460                                  
   461                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   462                                  
   463 00001D11 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   464                                  
   465                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   466                                  
   467 00001D18 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   468                                  
   469                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   470                                  
   471 00001D1F 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   472                                  
   473                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   474                                  
   475 00001D26 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   476                                  
   477                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   478                                  
   479 00001D2D 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   480                                  
   481                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   482                                  
   483 00001D34 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   484                                  
   485                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   486                                  
   487 00001D3B 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   488                                  
   489                                  ;-43 // 2: mem reg 16 bit
   490                                  
   491                                  
   492                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   493                                  
   494 00001D42 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   495                                  
   496                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   497                                  
   498 00001D4B 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   499                                  
   500                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   501                                  
   502 00001D54 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   503                                  
   504                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   505                                  
   506 00001D5C 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   507                                  
   508                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   509                                  
   510 00001D64 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   511                                  
   512                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   513                                  
   514 00001D6C 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   515                                  
   516                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   517                                  
   518 00001D75 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   519                                  
   520                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   521                                  
   522 00001D7D 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   523                                  
   524                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   525                                  
   526                                  
   527                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   528                                  
   529 00001D86 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   530                                  
   531                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   532                                  
   533 00001D8D 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   534                                  
   535                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   536                                  
   537 00001D94 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   538                                  
   539                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   540                                  
   541 00001D9B 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   542                                  
   543                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   544                                  
   545 00001DA3 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   546                                  
   547                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   548                                  
   549 00001DAB 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   550                                  
   551                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   552                                  
   553                                  
   554                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   555                                  
   556 00001DB3 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   557                                  
   558                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   559                                  
   560 00001DBA 4F52000401F1            I_OR db 79,82,0,4,1,241
   561                                  
   562                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   563                                  
   564 00001DC0 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   565                                  
   566                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   567                                  
   568 00001DC7 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   569                                  
   570                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   571                                  
   572 00001DCE 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   573                                  
   574                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   575                                  
   576 00001DD5 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   577                                  
   578                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   579                                  
   580 00001DDC 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   581                                  
   582                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   583                                  
   584 00001DE3 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   585                                  
   586                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   587                                  
   588 00001DEA 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   589 00001DF3 00F1               
   590                                  
   591                                  ;-69 //  5: mov
   592                                  
   593                                  
   594                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   595                                  
   596 00001DF5 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   597                                  
   598                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   599                                  
   600 00001DFB 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   601                                  
   602                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   603                                  
   604 00001E04 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   605                                  
   606                                  ;-73 //  6: single byte relative jump
   607                                  
   608                                  
   609                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   610                                  
   611 00001E0D 4A4F000600F1            I_JO db 74,79,0,6,0,241
   612                                  
   613                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   614                                  
   615 00001E13 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   616                                  
   617                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   618                                  
   619 00001E1A 4A42000602F1            I_JB db 74,66,0,6,2,241
   620                                  
   621                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   622                                  
   623 00001E20 4A43000602F1            I_JC db 74,67,0,6,2,241
   624                                  
   625                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   626                                  
   627 00001E26 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   628                                  
   629                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   630                                  
   631 00001E2D 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   632                                  
   633                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   634                                  
   635 00001E34 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   636                                  
   637                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   638                                  
   639 00001E3B 4A45000604F1            I_JE db 74,69,0,6,4,241
   640                                  
   641                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   642                                  
   643 00001E41 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   644                                  
   645                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   646                                  
   647 00001E47 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   648                                  
   649                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   650                                  
   651 00001E4E 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   652                                  
   653                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   654                                  
   655 00001E55 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   656                                  
   657                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   658                                  
   659 00001E5C 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   660                                  
   661                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   662                                  
   663 00001E63 4A41000607F1            I_JA db 74,65,0,6,7,241
   664                                  
   665                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   666                                  
   667 00001E69 4A53000608F1            I_JS db 74,83,0,6,8,241
   668                                  
   669                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   670                                  
   671 00001E6F 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   672                                  
   673                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   674                                  
   675 00001E76 4A5000060AF1            I_JP db 74,80,0,6,10,241
   676                                  
   677                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   678                                  
   679 00001E7C 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   680                                  
   681                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   682                                  
   683 00001E83 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   684                                  
   685                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   686                                  
   687 00001E8A 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   688                                  
   689                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   690                                  
   691 00001E91 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   692                                  
   693                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   694                                  
   695 00001E97 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   696                                  
   697                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   698                                  
   699 00001E9E 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   700                                  
   701                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   702                                  
   703 00001EA5 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   704                                  
   705                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   706                                  
   707 00001EAC 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   708                                  
   709                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   710                                  
   711 00001EB3 4A4700060FF1            I_JG db 74,71,0,6,15,241
   712                                  
   713                                  ;-100 //  7: jmp, call
   714                                  
   715                                  
   716                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   717                                  
   718 00001EB9 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   719                                  
   720                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   721                                  
   722 00001EC1 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   723                                  
   724                                  ;-103 //  8: ret
   725                                  
   726                                  
   727                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   728                                  
   729 00001ECA 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   730                                  
   731                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   732                                  
   733 00001ED2 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   734                                  
   735                                  ;-106 //  9: seg, r/m
   736                                  
   737                                  
   738                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   739                                  
   740 00001EDB 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   741 00001EE4 06F1               
   742                                  
   743                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   744                                  
   745 00001EE6 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   746 00001EEF F1                 
   747                                  
   748                                  ;-109 //  11: shift, rotates
   749                                  
   750                                  
   751                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   752                                  
   753 00001EF0 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   754                                  
   755                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   756                                  
   757 00001EF7 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   758                                  
   759                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   760                                  
   761 00001EFE 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   762                                  
   763                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   764                                  
   765 00001F05 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   766                                  
   767                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   768                                  
   769 00001F0C 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   770                                  
   771                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   772                                  
   773 00001F13 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   774                                  
   775                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   776                                  
   777 00001F1A 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   778                                  
   779                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   780                                  
   781 00001F21 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   782                                  
   783                                  ;-118 //  12: int
   784                                  
   785                                  
   786                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   787                                  
   788 00001F28 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
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
   822 00001F30 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
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
   853 00001F39 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   854                                  
   855                                  ;-141 // 100: directives
   856                                  
   857                                  
   858                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   859                                  
   860 00001F41 4F52470065F1            I_ORG db 79,82,71,0,101,241
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
   876 00001F47 444200C8F1              I_DB db 68,66,0,200,241
   877                                  
   878                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   879                                  
   880 00001F4C 445700C9F1              I_DW db 68,87,0,201,241
   881                                  
   882                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   883                                  
   884 00001F51 444400CAF1              I_DD db 68,68,0,202,241
   885                                  
   886                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   887                                  
   888 00001F56 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   889                                  
   890                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   891                                  
   892 00001F5D 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   893                                  
   894                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   895                                  
   896 00001F64 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   897                                  
   898                                  ;-153 char I_END=0;// end of table char
   899                                  
   900 00001F6B 00                      I_END db 0
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
   920 00001F6C C8020000                 ENTER  2,0
   921 00001F70 A0[AC01]                 mov al, [Op]
   922 00001F73 8846FE                   mov byte [bp-2], al
   923 00001F76 A0[AD01]                 mov al, [Op2]
   924 00001F79 A2[AC01]                 mov byte [Op], al
   925 00001F7C 8A46FE                   mov al, [bp-2]
   926 00001F7F A2[AD01]                 mov byte [Op2], al
   927                                  
   928                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   929                                  
   930 00001F82 A0[B501]                 mov al, [R1Type]
   931 00001F85 8846FE                   mov byte [bp-2], al
   932 00001F88 A0[B401]                 mov al, [R2Type]
   933 00001F8B A2[B501]                 mov byte [R1Type], al
   934 00001F8E 8A46FE                   mov al, [bp-2]
   935 00001F91 A2[B401]                 mov byte [R2Type], al
   936                                  
   937                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   938                                  
   939 00001F94 A0[B301]                 mov al, [R1No]
   940 00001F97 8846FE                   mov byte [bp-2], al
   941 00001F9A A0[B201]                 mov al, [R2No]
   942 00001F9D A2[B301]                 mov byte [R1No], al
   943 00001FA0 8A46FE                   mov al, [bp-2]
   944 00001FA3 A2[B201]                 mov byte [R2No], al
   945                                  
   946                                  ;-6     dflag=2;     
   947                                  
   948 00001FA6 66B802000000             mov eax, 2
   949 00001FAC A2[B801]                 mov byte [dflag], al
   950                                  
   951                                  ;-7 }
   952                                  
   953                                  
   954                                  ;-8      
   955                                  
   956                                  
   957                                  ;-9 int checkOpL() {
   958 00001FAF C9                       LEAVE
   959 00001FB0 C3                       ret
   960                                  ; ENDP
   961                                  
   962                                  checkOpL:  ; *** PROC ***
   963                                  
   964                                  ;-10     if (Op == ADR) implerror();
   965                                  
   966 00001FB1 A0[AC01]                 mov al, [Op]
   967 00001FB4 3C03                     cmp al, 3
   968 00001FB6 0F850300                 jne @@checkOpL1
   969 00001FBA E8DB14                   call implerror
   970                                  
   971                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   972                                  
   973                                  @@checkOpL1:
   974 00001FBD A0[B501]                 mov al, [R1Type]
   975 00001FC0 3C04                     cmp al, 4
   976 00001FC2 0F850600                 jne @@checkOpL2
   977 00001FC6 E89715                   call segregerror
   978 00001FC9 E93E00                   jmp @@retn
   979                                  
   980                                  ;-12     setwflag();
   981                                  
   982                                  @@checkOpL2:
   983 00001FCC E8CB03                   call setwflag
   984                                  
   985                                  ;-13     if (OpSize == 0) error1("no op size declared");
   986                                  
   987 00001FCF A0[B601]                 mov al, [OpSize]
   988 00001FD2 3C00                     cmp al, 0
   989 00001FD4 0F850900                 jne @@checkOpL3
   990 00001FD8 68[0B20]                 push checkOpL_0
   991 00001FDB E8EA13                   call error1
   992 00001FDE 83C402                   add  sp, 2
   993                                  
   994                                  ;-14     if (OpSize == R1Type) return;
   995                                  
   996                                  @@checkOpL3:
   997 00001FE1 A0[B601]                 mov al, [OpSize]
   998 00001FE4 3A06[B501]               cmp al, [R1Type]
   999 00001FE8 0F850300                 jne @@checkOpL4
  1000 00001FEC E91B00                   jmp @@retn
  1001                                  
  1002                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1003                                  
  1004                                  @@checkOpL4:
  1005 00001FEF A0[AC01]                 mov al, [Op]
  1006 00001FF2 3C02                     cmp al, 2
  1007 00001FF4 0F851200                 jne @@checkOpL5
  1008 00001FF8 A0[B501]                 mov al, [R1Type]
  1009 00001FFB 3C00                     cmp al, 0
  1010 00001FFD 0F850900                 jne @@checkOpL6
  1011 00002001 68[1F20]                 push checkOpL_1
  1012 00002004 E8C113                   call error1
  1013 00002007 83C402                   add  sp, 2
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
  1026 0000200A C3                       ret
  1027                                  ; ENDP
  1028 0000200B 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1029 00002014 65206465636C617265-
  1030 0000201D 6400               
  1031 0000201F 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1032 00002028 657220646566696E65-
  1033 00002031 6400               
  1034                                  
  1035                                  check2Ops:  ; *** PROC ***
  1036                                  
  1037                                  ;-19     get2Ops();
  1038                                  
  1039 00002033 E84900                   call get2Ops
  1040                                  
  1041                                  ;-20     if (Op ==   0) addrerror();
  1042                                  
  1043 00002036 A0[AC01]                 mov al, [Op]
  1044 00002039 3C00                     cmp al, 0
  1045 0000203B 0F850300                 jne @@check2Ops7
  1046 0000203F E81714                   call addrerror
  1047                                  
  1048                                  ;-21     if (Op == ADR) invaloperror(); 
  1049                                  
  1050                                  @@check2Ops7:
  1051 00002042 A0[AC01]                 mov al, [Op]
  1052 00002045 3C03                     cmp al, 3
  1053 00002047 0F850300                 jne @@check2Ops8
  1054 0000204B E88514                   call invaloperror
  1055                                  
  1056                                  ;-22     if (Op == IMM) immeerror();   
  1057                                  
  1058                                  @@check2Ops8:
  1059 0000204E A0[AC01]                 mov al, [Op]
  1060 00002051 3C01                     cmp al, 1
  1061 00002053 0F850300                 jne @@check2Ops9
  1062 00002057 E81914                   call immeerror
  1063                                  
  1064                                  ;-23     if (Op2==   0) addrerror();
  1065                                  
  1066                                  @@check2Ops9:
  1067 0000205A A0[AD01]                 mov al, [Op2]
  1068 0000205D 3C00                     cmp al, 0
  1069 0000205F 0F850300                 jne @@check2Ops10
  1070 00002063 E8F313                   call addrerror
  1071                                  
  1072                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           
  1073                                  
  1074                                  @@check2Ops10:
  1075 00002066 A0[AE01]                 mov al, [CodeType]
  1076 00002069 3C05                     cmp al, 5
  1077 0000206B 0F840C00                 je  @@check2Ops11
  1078 0000206F A0[AD01]                 mov al, [Op2]
  1079 00002072 3C03                     cmp al, 3
  1080 00002074 0F850300                 jne @@check2Ops12
  1081 00002078 E85814                   call invaloperror
  1082                                  
  1083                                  ;-25     setwflag();       
  1084                                  
  1085                                  @@check2Ops12:
  1086                                  @@check2Ops11:
  1087 0000207B E81C03                   call setwflag
  1088                                  
  1089                                  ;-26 }    
  1090                                  
  1091                                  
  1092                                  ;-27 int get2Ops() {
  1093                                  
  1094 0000207E C3                       ret
  1095                                  ; ENDP
  1096                                  
  1097                                  get2Ops:  ; *** PROC ***
  1098                                  
  1099                                  ;-28     getOpL();
  1100                                  
  1101 0000207F E80C00                   call getOpL
  1102                                  
  1103                                  ;-29     need(',');    
  1104                                  
  1105 00002082 6A2C                     push 44
  1106 00002084 E81709                   call need
  1107 00002087 83C402                   add  sp, 2
  1108                                  
  1109                                  ;-30     getOpR();         
  1110                                  
  1111 0000208A E83200                   call getOpR
  1112                                  
  1113                                  ;-31 } 
  1114                                  
  1115                                  
  1116                                  ;-32         
  1117                                  
  1118                                  
  1119                                  ;-33 int getOpL() {
  1120                                  
  1121 0000208D C3                       ret
  1122                                  ; ENDP
  1123                                  
  1124                                  getOpL:  ; *** PROC ***
  1125                                  
  1126                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1127                                  
  1128                                  
  1129                                  ;-35     getOpR();
  1130                                  
  1131 0000208E E82E00                   call getOpR
  1132                                  
  1133                                  ;-36     Op=Op2;         Op2=0;
  1134                                  
  1135 00002091 A0[AD01]                 mov al, [Op2]
  1136 00002094 A2[AC01]                 mov byte [Op], al
  1137 00002097 66B800000000             mov eax, 0
  1138 0000209D A2[AD01]                 mov byte [Op2], al
  1139                                  
  1140                                  ;-37     R1No=R2No;      R2No=0;
  1141                                  
  1142 000020A0 A0[B201]                 mov al, [R2No]
  1143 000020A3 A2[B301]                 mov byte [R1No], al
  1144 000020A6 66B800000000             mov eax, 0
  1145 000020AC A2[B201]                 mov byte [R2No], al
  1146                                  
  1147                                  ;-38     R1Type=R2Type; R2Type=0; 
  1148                                  
  1149 000020AF A0[B401]                 mov al, [R2Type]
  1150 000020B2 A2[B501]                 mov byte [R1Type], al
  1151 000020B5 66B800000000             mov eax, 0
  1152 000020BB A2[B401]                 mov byte [R2Type], al
  1153                                  
  1154                                  ;-39 }  
  1155                                  
  1156                                  
  1157                                  ;-40 
  1158                                  
  1159                                  
  1160                                  ;-41 int getOpR() {
  1161                                  
  1162 000020BE C3                       ret
  1163                                  ; ENDP
  1164                                  
  1165                                  getOpR:  ; *** PROC ***
  1166                                  
  1167                                  ;-42     Op2=getOp1();
  1168                                  
  1169 000020BF E88900                   call getOp1
  1170 000020C2 A2[AD01]                 mov byte [Op2], al
  1171                                  
  1172                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1173                                  
  1174 000020C5 6A5B                     push 91
  1175 000020C7 E8A608                   call isToken
  1176 000020CA 83C402                   add  sp, 2
  1177 000020CD 08C0                     or  al, al
  1178 000020CF 0F840F00                 je @@getOpR13
  1179 000020D3 66B804000000             mov eax, 4
  1180 000020D9 A2[AD01]                 mov byte [Op2], al
  1181 000020DC E8F200                   call getMEM
  1182 000020DF E94F00                   jmp @@retn
  1183                                  
  1184                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1185                                  
  1186                                  @@getOpR13:
  1187 000020E2 A0[AD01]                 mov al, [Op2]
  1188 000020E5 3C00                     cmp al, 0
  1189 000020E7 0F850600                 jne @@getOpR14
  1190 000020EB E8E513                   call invaloperror
  1191 000020EE E94000                   jmp @@retn
  1192                                  
  1193                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1194                                  
  1195                                  @@getOpR14:
  1196 000020F1 A0[AD01]                 mov al, [Op2]
  1197 000020F4 3C01                     cmp al, 1
  1198 000020F6 0F850900                 jne @@getOpR15
  1199 000020FA A1[4D00]                 mov ax, [SymbolInt]
  1200 000020FD A3[BE01]                 mov word [imme], ax
  1201 00002100 E92E00                   jmp @@retn
  1202                                  
  1203                                  ;-46     if (Op2 == REG)                            return;
  1204                                  
  1205                                  @@getOpR15:
  1206 00002103 A0[AD01]                 mov al, [Op2]
  1207 00002106 3C02                     cmp al, 2
  1208 00002108 0F850300                 jne @@getOpR16
  1209 0000210C E92200                   jmp @@retn
  1210                                  
  1211                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1212                                  
  1213                                  @@getOpR16:
  1214 0000210F A0[AD01]                 mov al, [Op2]
  1215 00002112 3C03                     cmp al, 3
  1216 00002114 0F851000                 jne @@getOpR17
  1217 00002118 8B1E[7E06]               mov bx, [LabelIx]
  1218 0000211C D1E3                     shl bx, 1
  1219 0000211E 8B87[B405]               mov ax, [LabelAddr + bx]
  1220 00002122 A3[BC01]                 mov word [disp], ax
  1221 00002125 E90900                   jmp @@retn
  1222                                  
  1223                                  ;-48     error1("Name of operand expected");
  1224                                  
  1225                                  @@getOpR17:
  1226 00002128 68[3221]                 push getOpR_0
  1227 0000212B E89A12                   call error1
  1228 0000212E 83C402                   add  sp, 2
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
  1239 00002131 C3                       ret
  1240                                  ; ENDP
  1241 00002132 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1242 0000213B 706572616E64206578-
  1243 00002144 70656374656400     
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
  1258 0000214B A0[AB01]                 mov al, [TokeType]
  1259 0000214E 3C00                     cmp al, 0
  1260 00002150 0F850900                 jne @@getOp118
  1261 00002154 66B800000000             mov eax, 0
  1262 0000215A E96000                   jmp @@retn
  1263                                  
  1264                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1265                                  
  1266                                  @@getOp118:
  1267 0000215D A0[AB01]                 mov al, [TokeType]
  1268 00002160 3C01                     cmp al, 1
  1269 00002162 0F850900                 jne @@getOp119
  1270 00002166 66B801000000             mov eax, 1
  1271 0000216C E94E00                   jmp @@retn
  1272                                  
  1273                                  ;-57     if (TokeType == ALNUME) {
  1274                                  
  1275                                  @@getOp119:
  1276 0000216F A0[AB01]                 mov al, [TokeType]
  1277 00002172 3C03                     cmp al, 3
  1278 00002174 0F853C00                 jne @@getOp120
  1279                                  
  1280                                  ;-58         R2No=testReg();
  1281                                  
  1282 00002178 E8A20B                   call testReg
  1283 0000217B A2[B201]                 mov byte [R2No], al
  1284                                  
  1285                                  ;-59         if (R2Type)        return REG;
  1286                                  
  1287 0000217E A0[B401]                 mov al, [R2Type]
  1288 00002181 08C0                     or  al, al
  1289 00002183 0F840900                 je @@getOp121
  1290 00002187 66B802000000             mov eax, 2
  1291 0000218D E92D00                   jmp @@retn
  1292                                  
  1293                                  ;-60         LabelIx=searchLabel();
  1294                                  
  1295                                  @@getOp121:
  1296 00002190 E84805                   call searchLabel
  1297 00002193 A3[7E06]                 mov word [LabelIx], ax
  1298                                  
  1299                                  ;-61         if (LabelIx)        return ADR;
  1300                                  
  1301 00002196 A1[7E06]                 mov ax, [LabelIx]
  1302 00002199 08C0                     or  al, al
  1303 0000219B 0F840C00                 je @@getOp122
  1304 0000219F 66B803000000             mov eax, 3
  1305 000021A5 E91500                   jmp @@retn
  1306                                  
  1307                                  ;-62         else error1("variable not found"); 
  1308                                  
  1309 000021A8 E90900                   jmp @@getOp123
  1310                                  @@getOp122:
  1311 000021AB 68[BE21]                 push getOp1_0
  1312 000021AE E81712                   call error1
  1313 000021B1 83C402                   add  sp, 2
  1314                                  
  1315                                  ;-63     }
  1316                                  
  1317                                  @@getOp123:
  1318                                  
  1319                                  ;-64     return 0;
  1320                                  
  1321                                  @@getOp120:
  1322 000021B4 66B800000000             mov eax, 0
  1323 000021BA E90000                   jmp @@retn
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
  1334 000021BD C3                       ret
  1335                                  ; ENDP
  1336 000021BE 7661726961626C6520-     getOp1_0 db "variable not found",0
  1337 000021C7 6E6F7420666F756E64-
  1338 000021D0 00                 
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
  1353 000021D1 C8020000                 ENTER  2,0
  1354 000021D5 66B800000000             mov eax, 0
  1355 000021DB A3[BC01]                 mov word [disp], ax
  1356 000021DE 66B800000000             mov eax, 0
  1357 000021E4 A2[BA01]                 mov byte [rm], al
  1358                                  
  1359                                  ;-71     do {
  1360                                  
  1361                                  @@getMEM24:
  1362                                  
  1363                                  ;-72         getTokeType();
  1364                                  
  1365 000021E7 E8B003                   call getTokeType
  1366                                  
  1367                                  ;-73         c=getOp1();
  1368                                  
  1369 000021EA E85EFF                   call getOp1
  1370 000021ED 8846FE                   mov byte [bp-2], al
  1371                                  
  1372                                  ;-74         if (c ==   0) syntaxerror();
  1373                                  
  1374 000021F0 8A46FE                   mov al, [bp-2]
  1375 000021F3 3C00                     cmp al, 0
  1376 000021F5 0F850300                 jne @@getMEM25
  1377 000021F9 E88B13                   call syntaxerror
  1378                                  
  1379                                  ;-75         if (c == REG) {
  1380                                  
  1381                                  @@getMEM25:
  1382 000021FC 8A46FE                   mov al, [bp-2]
  1383 000021FF 3C02                     cmp al, 2
  1384 00002201 0F851E00                 jne @@getMEM26
  1385                                  
  1386                                  ;-76             isDirect=0;
  1387                                  
  1388 00002205 66B800000000             mov eax, 0
  1389 0000220B A2[BB01]                 mov byte [isDirect], al
  1390                                  
  1391                                  ;-77             if (rm) rm=getIndReg2();
  1392                                  
  1393 0000220E A0[BA01]                 mov al, [rm]
  1394 00002211 08C0                     or  al, al
  1395 00002213 0F840900                 je @@getMEM27
  1396 00002217 E8F300                   call getIndReg2
  1397 0000221A A2[BA01]                 mov byte [rm], al
  1398                                  
  1399                                  ;-78             else getIndReg1();
  1400                                  
  1401 0000221D E90300                   jmp @@getMEM28
  1402                                  @@getMEM27:
  1403 00002220 E88900                   call getIndReg1
  1404                                  
  1405                                  ;-79         }
  1406                                  
  1407                                  @@getMEM28:
  1408                                  
  1409                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1410                                  
  1411                                  @@getMEM26:
  1412 00002223 8A46FE                   mov al, [bp-2]
  1413 00002226 3C03                     cmp al, 3
  1414 00002228 0F851000                 jne @@getMEM29
  1415 0000222C A1[BC01]                 mov ax, [disp]
  1416 0000222F 8B1E[7E06]               mov bx, [LabelIx]
  1417 00002233 D1E3                     shl bx, 1
  1418 00002235 0387[B405]               add ax, [LabelAddr + bx]
  1419 00002239 A3[BC01]                 mov word [disp], ax
  1420                                  
  1421                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1422                                  
  1423                                  @@getMEM29:
  1424 0000223C 8A46FE                   mov al, [bp-2]
  1425 0000223F 3C01                     cmp al, 1
  1426 00002241 0F850A00                 jne @@getMEM30
  1427 00002245 A1[BC01]                 mov ax, [disp]
  1428 00002248 0306[4D00]               add ax, [SymbolInt]
  1429 0000224C A3[BC01]                 mov word [disp], ax
  1430                                  
  1431                                  ;-82         if (isToken('-')) {
  1432                                  
  1433                                  @@getMEM30:
  1434 0000224F 6A2D                     push 45
  1435 00002251 E81C07                   call isToken
  1436 00002254 83C402                   add  sp, 2
  1437 00002257 08C0                     or  al, al
  1438 00002259 0F841900                 je @@getMEM31
  1439                                  
  1440                                  ;-83             getTokeType();
  1441                                  
  1442 0000225D E83A03                   call getTokeType
  1443                                  
  1444                                  ;-84             if (TokeType != DIGIT) numbererror();
  1445                                  
  1446 00002260 A0[AB01]                 mov al, [TokeType]
  1447 00002263 3C01                     cmp al, 1
  1448 00002265 0F840300                 je  @@getMEM32
  1449 00002269 E88812                   call numbererror
  1450                                  
  1451                                  ;-85             disp = disp - SymbolInt;
  1452                                  
  1453                                  @@getMEM32:
  1454 0000226C A1[BC01]                 mov ax, [disp]
  1455 0000226F 2B06[4D00]               sub ax, [SymbolInt]
  1456 00002273 A3[BC01]                 mov word [disp], ax
  1457                                  
  1458                                  ;-86         }
  1459                                  
  1460                                  
  1461                                  ;-87     } while (isToken('+'));
  1462                                  
  1463                                  @@getMEM31:
  1464 00002276 6A2B                     push 43
  1465 00002278 E8F506                   call isToken
  1466 0000227B 83C402                   add  sp, 2
  1467 0000227E 08C0                     or  al, al
  1468 00002280 0F840300                 je @@getMEM33
  1469 00002284 E960FF                   jmp @@getMEM24
  1470                                  @@getMEM33:
  1471                                  
  1472                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1473                                  
  1474 00002287 6A5D                     push 93
  1475 00002289 E8E406                   call isToken
  1476 0000228C 83C402                   add  sp, 2
  1477 0000228F 83F800                   cmp ax, 0
  1478 00002292 0F850900                 jne @@getMEM34
  1479 00002296 68[A122]                 push getMEM_0
  1480 00002299 E88B11                   call errorexit
  1481 0000229C 83C402                   add  sp, 2
  1482                                  
  1483                                  ;-89 }
  1484                                  
  1485                                  @@getMEM34:
  1486                                  
  1487                                  ;-90 int getIndReg1() {
  1488 0000229F C9                       LEAVE
  1489 000022A0 C3                       ret
  1490                                  ; ENDP
  1491 000022A1 5D2065787065637465-     getMEM_0 db "] expected",0
  1492 000022AA 6400               
  1493                                  
  1494                                  getIndReg1:  ; *** PROC ***
  1495                                  
  1496                                  ;-91     if (R2Type !=WORD) indexerror();
  1497                                  
  1498 000022AC A0[B401]                 mov al, [R2Type]
  1499 000022AF 3C02                     cmp al, 2
  1500 000022B1 0F840300                 je  @@getIndReg135
  1501 000022B5 E8FA11                   call indexerror
  1502                                  
  1503                                  ;-92     if (R2No==3) rm=7;//BX
  1504                                  
  1505                                  @@getIndReg135:
  1506 000022B8 A0[B201]                 mov al, [R2No]
  1507 000022BB 3C03                     cmp al, 3
  1508 000022BD 0F850900                 jne @@getIndReg136
  1509 000022C1 66B807000000             mov eax, 7
  1510 000022C7 A2[BA01]                 mov byte [rm], al
  1511                                  
  1512                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1513                                  
  1514                                  @@getIndReg136:
  1515 000022CA A0[B201]                 mov al, [R2No]
  1516 000022CD 3C05                     cmp al, 5
  1517 000022CF 0F850900                 jne @@getIndReg137
  1518 000022D3 66B806000000             mov eax, 6
  1519 000022D9 A2[BA01]                 mov byte [rm], al
  1520                                  
  1521                                  ;-94     if (R2No==7) rm=5;//DI
  1522                                  
  1523                                  @@getIndReg137:
  1524 000022DC A0[B201]                 mov al, [R2No]
  1525 000022DF 3C07                     cmp al, 7
  1526 000022E1 0F850900                 jne @@getIndReg138
  1527 000022E5 66B805000000             mov eax, 5
  1528 000022EB A2[BA01]                 mov byte [rm], al
  1529                                  
  1530                                  ;-95     if (R2No==6) rm=4;//SI
  1531                                  
  1532                                  @@getIndReg138:
  1533 000022EE A0[B201]                 mov al, [R2No]
  1534 000022F1 3C06                     cmp al, 6
  1535 000022F3 0F850900                 jne @@getIndReg139
  1536 000022F7 66B804000000             mov eax, 4
  1537 000022FD A2[BA01]                 mov byte [rm], al
  1538                                  
  1539                                  ;-96     if (rm==0) indexerror();
  1540                                  
  1541                                  @@getIndReg139:
  1542 00002300 A0[BA01]                 mov al, [rm]
  1543 00002303 3C00                     cmp al, 0
  1544 00002305 0F850300                 jne @@getIndReg140
  1545 00002309 E8A611                   call indexerror
  1546                                  
  1547                                  ;-97 }
  1548                                  
  1549                                  @@getIndReg140:
  1550                                  
  1551                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1552                                  
  1553 0000230C C3                       ret
  1554                                  ; ENDP
  1555                                  
  1556                                  getIndReg2:  ; *** PROC ***
  1557                                  ;Function : getIndReg2, Number of local variables: 1
  1558                                  ;   # type sign width line used address name   list of local variables
  1559                                  ;  200 var sign byte    98 NULL bp-2    m;
  1560 0000230D C8020000                 ENTER  2,0
  1561 00002311 66B804000000             mov eax, 4
  1562 00002317 8846FE                   mov byte [bp-2], al
  1563                                  
  1564                                  ;-99     if (R2Type !=WORD) indexerror();
  1565                                  
  1566 0000231A A0[B401]                 mov al, [R2Type]
  1567 0000231D 3C02                     cmp al, 2
  1568 0000231F 0F840300                 je  @@getIndReg241
  1569 00002323 E88C11                   call indexerror
  1570                                  
  1571                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1572                                  
  1573                                  @@getIndReg241:
  1574 00002326 A0[B201]                 mov al, [R2No]
  1575 00002329 3C07                     cmp al, 7
  1576 0000232B 0F852700                 jne @@getIndReg242
  1577 0000232F A0[BA01]                 mov al, [rm]
  1578 00002332 3C06                     cmp al, 6
  1579 00002334 0F850C00                 jne @@getIndReg243
  1580 00002338 66B803000000             mov eax, 3
  1581 0000233E 8846FE                   mov byte [bp-2], al
  1582                                  
  1583                                  ;-101              else if (rm==7) m=1;//BX+DI
  1584                                  
  1585 00002341 E91200                   jmp @@getIndReg244
  1586                                  @@getIndReg243:
  1587 00002344 A0[BA01]                 mov al, [rm]
  1588 00002347 3C07                     cmp al, 7
  1589 00002349 0F850900                 jne @@getIndReg245
  1590 0000234D 66B801000000             mov eax, 1
  1591 00002353 8846FE                   mov byte [bp-2], al
  1592                                  
  1593                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1594                                  
  1595                                  @@getIndReg245:
  1596                                  @@getIndReg244:
  1597                                  @@getIndReg242:
  1598 00002356 A0[B201]                 mov al, [R2No]
  1599 00002359 3C06                     cmp al, 6
  1600 0000235B 0F852700                 jne @@getIndReg246
  1601 0000235F A0[BA01]                 mov al, [rm]
  1602 00002362 3C06                     cmp al, 6
  1603 00002364 0F850C00                 jne @@getIndReg247
  1604 00002368 66B802000000             mov eax, 2
  1605 0000236E 8846FE                   mov byte [bp-2], al
  1606                                  
  1607                                  ;-103              else if (rm==7) m=0;//BX+SI
  1608                                  
  1609 00002371 E91200                   jmp @@getIndReg248
  1610                                  @@getIndReg247:
  1611 00002374 A0[BA01]                 mov al, [rm]
  1612 00002377 3C07                     cmp al, 7
  1613 00002379 0F850900                 jne @@getIndReg249
  1614 0000237D 66B800000000             mov eax, 0
  1615 00002383 8846FE                   mov byte [bp-2], al
  1616                                  
  1617                                  ;-104     if (m > 3) indexerror();
  1618                                  
  1619                                  @@getIndReg249:
  1620                                  @@getIndReg248:
  1621                                  @@getIndReg246:
  1622 00002386 8A46FE                   mov al, [bp-2]
  1623 00002389 3C03                     cmp al, 3
  1624 0000238B 0F8E0300                 jle @@getIndReg250
  1625 0000238F E82011                   call indexerror
  1626                                  
  1627                                  ;-105     return m;
  1628                                  
  1629                                  @@getIndReg250:
  1630 00002392 8A46FE                   mov al, [bp-2]
  1631 00002395 E90000                   jmp @@retn
  1632                                  
  1633                                  ;-106 }
  1634                                  
  1635                                  
  1636                                  ;-107                   
  1637                                  
  1638                                  
  1639                                  ;-108 int setwflag() {//word size, bit 0
  1640                                  
  1641 00002398 C9                      @@retn: LEAVE
  1642 00002399 C3                       ret
  1643                                  ; ENDP
  1644                                  
  1645                                  setwflag:  ; *** PROC ***
  1646                                  
  1647                                  ;-109     wflag=0;
  1648                                  
  1649 0000239A 66B800000000             mov eax, 0
  1650 000023A0 A2[B701]                 mov byte [wflag], al
  1651                                  
  1652                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1653                                  
  1654 000023A3 A0[B601]                 mov al, [OpSize]
  1655 000023A6 3C00                     cmp al, 0
  1656 000023A8 0F854200                 jne @@setwflag51
  1657                                  
  1658                                  ;-111         if (Op == REG) OpSize=R1Type;
  1659                                  
  1660 000023AC A0[AC01]                 mov al, [Op]
  1661 000023AF 3C02                     cmp al, 2
  1662 000023B1 0F850600                 jne @@setwflag52
  1663 000023B5 A0[B501]                 mov al, [R1Type]
  1664 000023B8 A2[B601]                 mov byte [OpSize], al
  1665                                  
  1666                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1667                                  
  1668                                  @@setwflag52:
  1669 000023BB A0[AD01]                 mov al, [Op2]
  1670 000023BE 3C02                     cmp al, 2
  1671 000023C0 0F850600                 jne @@setwflag53
  1672 000023C4 A0[B401]                 mov al, [R2Type]
  1673 000023C7 A2[B601]                 mov byte [OpSize], al
  1674                                  
  1675                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1676                                  
  1677                                  @@setwflag53:
  1678 000023CA A0[B401]                 mov al, [R2Type]
  1679 000023CD 3C04                     cmp al, 4
  1680 000023CF 0F850900                 jne @@setwflag54
  1681 000023D3 66B802000000             mov eax, 2
  1682 000023D9 A2[B601]                 mov byte [OpSize], al
  1683                                  
  1684                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1685                                  
  1686                                  @@setwflag54:
  1687 000023DC A0[B501]                 mov al, [R1Type]
  1688 000023DF 3C04                     cmp al, 4
  1689 000023E1 0F850900                 jne @@setwflag55
  1690 000023E5 66B802000000             mov eax, 2
  1691 000023EB A2[B601]                 mov byte [OpSize], al
  1692                                  
  1693                                  ;-115     }
  1694                                  
  1695                                  @@setwflag55:
  1696                                  
  1697                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1698                                  
  1699                                  @@setwflag51:
  1700 000023EE A0[B601]                 mov al, [OpSize]
  1701 000023F1 3C03                     cmp al, 3
  1702 000023F3 0F850C00                 jne @@setwflag56
  1703 000023F7 E86315                   call gen66h
  1704 000023FA 66B801000000             mov eax, 1
  1705 00002400 A2[B701]                 mov byte [wflag], al
  1706                                  
  1707                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1708                                  
  1709                                  @@setwflag56:
  1710 00002403 A0[B601]                 mov al, [OpSize]
  1711 00002406 3C02                     cmp al, 2
  1712 00002408 0F850900                 jne @@setwflag57
  1713 0000240C 66B801000000             mov eax, 1
  1714 00002412 A2[B701]                 mov byte [wflag], al
  1715                                  
  1716                                  ;-118 }
  1717                                  
  1718                                  @@setwflag57:
  1719                                  
  1720                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1721                                  
  1722 00002415 C3                       ret
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
  1735 00002416 C8020000                 ENTER  2,0
  1736 0000241A 66B802000000             mov eax, 2
  1737 00002420 A2[B901]                 mov byte [sflag], al
  1738                                  
  1739                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1740                                  
  1741 00002423 A1[BE01]                 mov ax, [imme]
  1742 00002426 2580FF                   and ax, 65408
  1743 00002429 8946FE                   mov word [bp-2], ax
  1744                                  
  1745                                  ;-123     if(ui != 0) sflag = 0;
  1746                                  
  1747 0000242C 8B46FE                   mov ax, [bp-2]
  1748 0000242F 83F800                   cmp ax, 0
  1749 00002432 0F840900                 je  @@setsflag58
  1750 00002436 66B800000000             mov eax, 0
  1751 0000243C A2[B901]                 mov byte [sflag], al
  1752                                  
  1753                                  ;-124     if (OpSize == BYTE) {
  1754                                  
  1755                                  @@setsflag58:
  1756 0000243F A0[B601]                 mov al, [OpSize]
  1757 00002442 3C01                     cmp al, 1
  1758 00002444 0F851C00                 jne @@setsflag59
  1759                                  
  1760                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1761                                  
  1762 00002448 A1[BE01]                 mov ax, [imme]
  1763 0000244B 3DFF00                   cmp ax, 255
  1764 0000244E 0F8E0900                 jle @@setsflag60
  1765 00002452 68[6624]                 push setsflag_0
  1766 00002455 E8700F                   call error1
  1767 00002458 83C402                   add  sp, 2
  1768                                  
  1769                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1770                                  
  1771                                  @@setsflag60:
  1772 0000245B 66B800000000             mov eax, 0
  1773 00002461 A2[B901]                 mov byte [sflag], al
  1774                                  
  1775                                  ;-127     }
  1776                                  
  1777                                  
  1778                                  ;-128 }
  1779                                  
  1780                                  @@setsflag59:
  1781                                  
  1782                                  ;-129 int checkConstSize(unsigned int ui) {//vvv    
  1783 00002464 C9                       LEAVE
  1784 00002465 C3                       ret
  1785                                  ; ENDP
  1786 00002466 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1787 0000246F 6F7220627974652072-
  1788 00002478 2F6D00             
  1789                                  
  1790                                  checkConstSize:  ; *** PROC ***
  1791                                  
  1792                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1793                                  
  1794                                  ;Function : checkConstSize, Number of local variables: 1
  1795                                  ;   # type sign width line used address name   list of local variables
  1796                                  ;  200 var unsg word   129 NULL bp+4    ui;
  1797 0000247B C8000000                 ENTER  0,0
  1798 0000247F 8B4604                   mov ax, [bp+4]
  1799 00002482 83F87F                   cmp ax, 127
  1800 00002485 0F8E0900                 jle @@checkConstSize61
  1801 00002489 66B800000000             mov eax, 0
  1802 0000248F E91C00                   jmp @@retn
  1803                                  
  1804                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1805                                  
  1806                                  @@checkConstSize61:
  1807 00002492 8B4604                   mov ax, [bp+4]
  1808 00002495 3D80FF                   cmp ax, 65408
  1809 00002498 0F8D0900                 jge @@checkConstSize62
  1810 0000249C 66B800000000             mov eax, 0
  1811 000024A2 E90900                   jmp @@retn
  1812                                  
  1813                                  ;-132     return 2;// is short        
  1814                                  
  1815                                  @@checkConstSize62:
  1816 000024A5 66B802000000             mov eax, 2
  1817 000024AB E90000                   jmp @@retn
  1818                                  
  1819                                  ;-133 }
  1820                                  
  1821 000024AE C9                      @@retn: LEAVE
  1822 000024AF C3                       ret
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
  1835                                  ;-2   LabelNamePtr= &LabelNames;    
  1836                                  
  1837 000024B0 B8[CA01]                 mov ax, LabelNames
  1838 000024B3 A3[B205]                 mov word [LabelNamePtr], ax
  1839                                  
  1840                                  ;-3   
  1841                                  
  1842                                  
  1843                                  ;-4   do {
  1844                                  
  1845                                  @@parse63:
  1846                                  
  1847                                  ;-5     PCStart=PC; 
  1848                                  
  1849 000024B6 A1[A601]                 mov ax, [PC]
  1850 000024B9 A3[A801]                 mov word [PCStart], ax
  1851                                  
  1852                                  ;-6     OpSize=0;
  1853                                  
  1854 000024BC 66B800000000             mov eax, 0
  1855 000024C2 A2[B601]                 mov byte [OpSize], al
  1856                                  
  1857                                  ;-7     OpPrintIndex=0; 
  1858                                  
  1859 000024C5 66B800000000             mov eax, 0
  1860 000024CB A3[C501]                 mov word [OpPrintIndex], ax
  1861                                  
  1862                                  ;-8     PrintRA=' ';
  1863                                  
  1864 000024CE 66B820000000             mov eax, 32
  1865 000024D4 A2[C901]                 mov byte [PrintRA], al
  1866                                  
  1867                                  ;-9     getLine();
  1868                                  
  1869 000024D7 E82C05                   call getLine
  1870                                  
  1871                                  ;-10     InputPtr = &InputBuf;
  1872                                  
  1873 000024DA B8[4F00]                 mov ax, InputBuf
  1874 000024DD A3[CE00]                 mov word [InputPtr], ax
  1875                                  
  1876                                  ;-11     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1877                                  
  1878 000024E0 E8B700                   call getTokeType
  1879                                  
  1880                                  ;-12     if (TokeType == ALNUME) {
  1881                                  
  1882 000024E3 A0[AB01]                 mov al, [TokeType]
  1883 000024E6 3C03                     cmp al, 3
  1884 000024E8 0F851300                 jne @@parse64
  1885                                  
  1886                                  ;-13       if (isLabel) { //set in getName
  1887                                  
  1888 000024EC A0[AA01]                 mov al, [isLabel]
  1889 000024EF 08C0                     or  al, al
  1890 000024F1 0F840A00                 je @@parse65
  1891                                  
  1892                                  ;-14         storeLabel();
  1893                                  
  1894 000024F5 E84001                   call storeLabel
  1895                                  
  1896                                  ;-15         InputPtr++;//remove :
  1897                                  
  1898 000024F8 FF06[CE00]               inc  word [InputPtr]
  1899                                  
  1900                                  ;-16         getTokeType();
  1901                                  
  1902 000024FC E89B00                   call getTokeType
  1903                                  
  1904                                  ;-17       }
  1905                                  
  1906                                  
  1907                                  ;-18     }
  1908                                  
  1909                                  @@parse65:
  1910                                  
  1911                                  ;-19     if (TokeType == ALNUME) {
  1912                                  
  1913                                  @@parse64:
  1914 000024FF A0[AB01]                 mov al, [TokeType]
  1915 00002502 3C03                     cmp al, 3
  1916 00002504 0F851B00                 jne @@parse66
  1917                                  
  1918                                  ;-20       lookCode();// and OpCodePtr
  1919                                  
  1920 00002508 E86803                   call lookCode
  1921                                  
  1922                                  ;-21       if(CodeType) process();
  1923                                  
  1924 0000250B A0[AE01]                 mov al, [CodeType]
  1925 0000250E 08C0                     or  al, al
  1926 00002510 0F840600                 je @@parse67
  1927 00002514 E83416                   call process
  1928                                  
  1929                                  ;-22       else getVariable();
  1930                                  
  1931 00002517 E90300                   jmp @@parse68
  1932                                  @@parse67:
  1933 0000251A E81E02                   call getVariable
  1934                                  
  1935                                  ;-23       skipRest();
  1936                                  
  1937                                  @@parse68:
  1938 0000251D E8BD04                   call skipRest
  1939                                  
  1940                                  ;-24     }
  1941                                  
  1942                                  
  1943                                  ;-25     else if (TokeType >ALNUME) error1("Label or instruction expected");
  1944                                  
  1945 00002520 E92700                   jmp @@parse69
  1946                                  @@parse66:
  1947 00002523 A0[AB01]                 mov al, [TokeType]
  1948 00002526 3C03                     cmp al, 3
  1949 00002528 0F8E0C00                 jle @@parse70
  1950 0000252C 68[5B25]                 push parse_0
  1951 0000252F E8960E                   call error1
  1952 00002532 83C402                   add  sp, 2
  1953                                  
  1954                                  ;-26     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1955                                  
  1956 00002535 E91200                   jmp @@parse71
  1957                                  @@parse70:
  1958 00002538 A0[AB01]                 mov al, [TokeType]
  1959 0000253B 3C01                     cmp al, 1
  1960 0000253D 0F850900                 jne @@parse72
  1961 00002541 68[7925]                 push parse_1
  1962 00002544 E8810E                   call error1
  1963 00002547 83C402                   add  sp, 2
  1964                                  
  1965                                  ;-27     printLine();
  1966                                  
  1967                                  @@parse72:
  1968                                  @@parse71:
  1969                                  @@parse69:
  1970 0000254A E80C0C                   call printLine
  1971                                  
  1972                                  ;-28   } while (DOS_NoBytes != 0 );
  1973                                  
  1974 0000254D A1[A301]                 mov ax, [DOS_NoBytes]
  1975 00002550 83F800                   cmp ax, 0
  1976 00002553 0F840300                 je  @@parse73
  1977 00002557 E95CFF                   jmp @@parse63
  1978                                  @@parse73:
  1979                                  
  1980                                  ;-29 }
  1981                                  
  1982                                  
  1983                                  ;-30 // scan code .....................................
  1984                                  
  1985                                  
  1986                                  ;-31 int getTokeType() { char c;
  1987                                  
  1988 0000255A C3                       ret
  1989                                  ; ENDP
  1990 0000255B 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1991 00002564 696E73747275637469-
  1992 0000256D 6F6E20657870656374-
  1993 00002576 656400             
  1994 00002579 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1995 00002582 616C6C6F7765642040-
  1996 0000258B 207374617274206F66-
  1997 00002594 206C696E6500       
  1998                                  
  1999                                  getTokeType:  ; *** PROC ***
  2000                                  
  2001                                  ;-32   skipBlank();
  2002                                  
  2003                                  ;Function : getTokeType, Number of local variables: 1
  2004                                  ;   # type sign width line used address name   list of local variables
  2005                                  ;  200 var sign byte    31 NULL bp-2    c;
  2006 0000259A C8020000                 ENTER  2,0
  2007 0000259E E86705                   call skipBlank
  2008                                  
  2009                                  ;-33   c = *InputPtr;
  2010                                  
  2011 000025A1 8B1E[CE00]               mov bx, [InputPtr]
  2012 000025A5 8A07                     mov al, [bx]
  2013 000025A7 B400                     mov ah, 0
  2014 000025A9 8846FE                   mov byte [bp-2], al
  2015                                  
  2016                                  ;-34   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2017                                  
  2018 000025AC 8A46FE                   mov al, [bp-2]
  2019 000025AF 3C00                     cmp al, 0
  2020 000025B1 0F850C00                 jne @@getTokeType74
  2021 000025B5 66B800000000             mov eax, 0
  2022 000025BB A2[AB01]                 mov byte [TokeType], al
  2023 000025BE E97500                   jmp @@retn
  2024                                  
  2025                                  ;-35   if (c == ';') {TokeType=0; return; }//comment
  2026                                  
  2027                                  @@getTokeType74:
  2028 000025C1 8A46FE                   mov al, [bp-2]
  2029 000025C4 3C3B                     cmp al, 59
  2030 000025C6 0F850C00                 jne @@getTokeType75
  2031 000025CA 66B800000000             mov eax, 0
  2032 000025D0 A2[AB01]                 mov byte [TokeType], al
  2033 000025D3 E96000                   jmp @@retn
  2034                                  
  2035                                  ;-36   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2036                                  
  2037                                  @@getTokeType75:
  2038 000025D6 8A46FE                   mov al, byte [bp-2]
  2039 000025D9 B400                     mov ah, 0
  2040 000025DB 50                       push ax
  2041 000025DC E8DF1C                   call digit
  2042 000025DF 83C402                   add  sp, 2
  2043 000025E2 08C0                     or  al, al
  2044 000025E4 0F841800                 je @@getTokeType76
  2045 000025E8 8A46FE                   mov al, byte [bp-2]
  2046 000025EB B400                     mov ah, 0
  2047 000025ED 50                       push ax
  2048 000025EE E81D06                   call getDigit
  2049 000025F1 83C402                   add  sp, 2
  2050 000025F4 66B801000000             mov eax, 1
  2051 000025FA A2[AB01]                 mov byte [TokeType], al
  2052 000025FD E93600                   jmp @@retn
  2053                                  
  2054                                  ;-37   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2055                                  
  2056                                  @@getTokeType76:
  2057 00002600 8A46FE                   mov al, byte [bp-2]
  2058 00002603 B400                     mov ah, 0
  2059 00002605 50                       push ax
  2060 00002606 E82A05                   call letterE
  2061 00002609 83C402                   add  sp, 2
  2062 0000260C 08C0                     or  al, al
  2063 0000260E 0F841800                 je @@getTokeType77
  2064 00002612 8A46FE                   mov al, byte [bp-2]
  2065 00002615 B400                     mov ah, 0
  2066 00002617 50                       push ax
  2067 00002618 E84A06                   call getName
  2068 0000261B 83C402                   add  sp, 2
  2069 0000261E 66B803000000             mov eax, 3
  2070 00002624 A2[AB01]                 mov byte [TokeType], al
  2071 00002627 E90C00                   jmp @@retn
  2072                                  
  2073                                  ;-38   TokeType=NOALNUME; return;
  2074                                  
  2075                                  @@getTokeType77:
  2076 0000262A 66B804000000             mov eax, 4
  2077 00002630 A2[AB01]                 mov byte [TokeType], al
  2078 00002633 E90000                   jmp @@retn
  2079                                  
  2080                                  ;-39 }
  2081                                  
  2082                                  
  2083                                  ;-40 int storeLabel() {unsigned int i;
  2084                                  
  2085 00002636 C9                      @@retn: LEAVE
  2086 00002637 C3                       ret
  2087                                  ; ENDP
  2088                                  
  2089                                  storeLabel:  ; *** PROC ***
  2090                                  
  2091                                  ;-41   if(searchLabel()) error1("duplicate label");
  2092                                  
  2093                                  ;Function : storeLabel, Number of local variables: 1
  2094                                  ;   # type sign width line used address name   list of local variables
  2095                                  ;  200 var unsg word    40 NULL bp-2    i;
  2096 00002638 C8020000                 ENTER  2,0
  2097 0000263C E89C00                   call searchLabel
  2098 0000263F 08C0                     or  al, al
  2099 00002641 0F840900                 je @@storeLabel78
  2100 00002645 68[A626]                 push storeLabel_0
  2101 00002648 E87D0D                   call error1
  2102 0000264B 83C402                   add  sp, 2
  2103                                  
  2104                                  ;-42   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2105                                  
  2106                                  @@storeLabel78:
  2107 0000264E 8D06[0F00]               lea  ax, [Symbol]
  2108 00002652 50                       push ax
  2109 00002653 FF36[B205]               push word [LabelNamePtr]
  2110 00002657 E82B1C                   call strcpy
  2111 0000265A 83C404                   add  sp, 4
  2112 0000265D A3[B205]                 mov word [LabelNamePtr], ax
  2113                                  
  2114                                  ;-43   LabelNamePtr++;
  2115                                  
  2116 00002660 FF06[B205]               inc  word [LabelNamePtr]
  2117                                  
  2118                                  ;-44   i = LabelNamePtr - &LabelNames;//todo
  2119                                  
  2120 00002664 A1[B205]                 mov ax, [LabelNamePtr]
  2121 00002667 2D[CA01]                 sub ax, LabelNames
  2122 0000266A 8946FE                   mov word [bp-2], ax
  2123                                  
  2124                                  ;-45   if (i >= LABELNAMESMAX) errorexit("too long label names");
  2125                                  
  2126 0000266D 8B46FE                   mov ax, [bp-2]
  2127 00002670 3DC903                   cmp ax, 969 ;unsigned : 0
  2128 00002673 0F820900                 jb  @@storeLabel79
  2129 00002677 68[B626]                 push storeLabel_1
  2130 0000267A E8AA0D                   call errorexit
  2131 0000267D 83C402                   add  sp, 2
  2132                                  
  2133                                  ;-46   LabelMaxIx++;
  2134                                  
  2135                                  @@storeLabel79:
  2136 00002680 FF06[7C06]               inc  word [LabelMaxIx]
  2137                                  
  2138                                  ;-47   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2139                                  
  2140 00002684 A1[7C06]                 mov ax, [LabelMaxIx]
  2141 00002687 83F864                   cmp ax, 100 ;unsigned : 1
  2142 0000268A 0F8C0900                 jl  @@storeLabel80
  2143 0000268E 68[CB26]                 push storeLabel_2
  2144 00002691 E8930D                   call errorexit
  2145 00002694 83C402                   add  sp, 2
  2146                                  
  2147                                  ;-48   LabelAddr[LabelMaxIx] = PC;
  2148                                  
  2149                                  @@storeLabel80:
  2150 00002697 A1[A601]                 mov ax, [PC]
  2151 0000269A 8B1E[7C06]               mov bx, [LabelMaxIx]
  2152 0000269E D1E3                     shl bx, 1
  2153 000026A0 8987[B405]               mov [LabelAddr+bx], ax
  2154                                  
  2155                                  ;-49 }
  2156                                  
  2157                                  
  2158                                  ;-50 int searchLabel() {
  2159 000026A4 C9                       LEAVE
  2160 000026A5 C3                       ret
  2161                                  ; ENDP
  2162 000026A6 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2163 000026AF 206C6162656C00     
  2164 000026B6 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  2165 000026BF 6C6162656C206E616D-
  2166 000026C8 657300             
  2167 000026CB 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  2168 000026D4 6C6162656C7300     
  2169                                  
  2170                                  searchLabel:  ; *** PROC ***
  2171                                  
  2172                                  ;-51   int LIx; char *p; int j;
  2173                                  
  2174                                  
  2175                                  ;-52   p = &LabelNames;
  2176                                  
  2177                                  ;Function : searchLabel, Number of local variables: 3
  2178                                  ;   # type sign width line used address name   list of local variables
  2179                                  ;  200 var sign word    51 NULL bp-2    LIx
  2180                                  ;  201 ptr sign byte    51 NULL bp-4    p
  2181                                  ;  202 var sign word    51 NULL bp-6    j;
  2182 000026DB C8060000                 ENTER  6,0
  2183 000026DF B8[CA01]                 mov ax, LabelNames
  2184 000026E2 8946FC                   mov word [bp-4], ax
  2185                                  
  2186                                  ;-53   LIx=1;
  2187                                  
  2188 000026E5 66B801000000             mov eax, 1
  2189 000026EB 8946FE                   mov word [bp-2], ax
  2190                                  
  2191                                  ;-54   while (LIx <= LabelMaxIx) {
  2192                                  
  2193                                  @@searchLabel81:
  2194 000026EE 8B46FE                   mov ax, [bp-2]
  2195 000026F1 3B06[7C06]               cmp ax, [LabelMaxIx]
  2196 000026F5 0F8F3700                 jg  @@searchLabel82
  2197                                  
  2198                                  ;-55     if (eqstr(p, Symbol)) return LIx;//pos of label
  2199                                  
  2200 000026F9 8D06[0F00]               lea  ax, [Symbol]
  2201 000026FD 50                       push ax
  2202 000026FE FF76FC                   push word [bp-4]
  2203 00002701 E8ED1B                   call eqstr
  2204 00002704 83C404                   add  sp, 4
  2205 00002707 08C0                     or  al, al
  2206 00002709 0F840600                 je @@searchLabel83
  2207 0000270D 8B46FE                   mov ax, [bp-2]
  2208 00002710 E92600                   jmp @@retn
  2209                                  
  2210                                  ;-56     j=strlen(p);
  2211                                  
  2212                                  @@searchLabel83:
  2213 00002713 FF76FC                   push word [bp-4]
  2214 00002716 E8411B                   call strlen
  2215 00002719 83C402                   add  sp, 2
  2216 0000271C 8946FA                   mov word [bp-6], ax
  2217                                  
  2218                                  ;-57     p=p+j; p++; LIx++;
  2219                                  
  2220 0000271F 8B46FC                   mov ax, [bp-4]
  2221 00002722 0346FA                   add ax, [bp-6]
  2222 00002725 8946FC                   mov word [bp-4], ax
  2223 00002728 FF46FC                   inc  word [bp-4]
  2224 0000272B FF46FE                   inc  word [bp-2]
  2225                                  
  2226                                  ;-58   }
  2227                                  
  2228                                  
  2229                                  ;-59   return 0;
  2230                                  
  2231 0000272E EBBE                     jmp @@searchLabel81
  2232                                  @@searchLabel82:
  2233 00002730 66B800000000             mov eax, 0
  2234 00002736 E90000                   jmp @@retn
  2235                                  
  2236                                  ;-60 }
  2237                                  
  2238                                  
  2239                                  ;-61 int getVariable() { char c;
  2240                                  
  2241 00002739 C9                      @@retn: LEAVE
  2242 0000273A C3                       ret
  2243                                  ; ENDP
  2244                                  
  2245                                  getVariable:  ; *** PROC ***
  2246                                  
  2247                                  ;-62   storeLabel();
  2248                                  
  2249                                  ;Function : getVariable, Number of local variables: 1
  2250                                  ;   # type sign width line used address name   list of local variables
  2251                                  ;  200 var sign byte    61 NULL bp-2    c;
  2252 0000273B C8020000                 ENTER  2,0
  2253 0000273F E8F6FE                   call storeLabel
  2254                                  
  2255                                  ;-63   getTokeType(); if(TokeType==ALNUME) {// getName
  2256                                  
  2257 00002742 E855FE                   call getTokeType
  2258 00002745 A0[AB01]                 mov al, [TokeType]
  2259 00002748 3C03                     cmp al, 3
  2260 0000274A 0F85CC00                 jne @@getVariable84
  2261                                  
  2262                                  ;-64     lookCode();
  2263                                  
  2264 0000274E E82201                   call lookCode
  2265                                  
  2266                                  ;-65     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2267                                  
  2268 00002751 A0[AE01]                 mov al, [CodeType]
  2269 00002754 3CC8                     cmp al, 200
  2270 00002756 0F8D0900                 jge @@getVariable85
  2271 0000275A 68[2528]                 push getVariable_0
  2272 0000275D E8C70C                   call errorexit
  2273 00002760 83C402                   add  sp, 2
  2274                                  
  2275                                  ;-66     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2276                                  
  2277                                  @@getVariable85:
  2278 00002763 A0[AE01]                 mov al, [CodeType]
  2279 00002766 3CCF                     cmp al, 207
  2280 00002768 0F8E0900                 jle @@getVariable86
  2281 0000276C 68[3D28]                 push getVariable_1
  2282 0000276F E8B50C                   call errorexit
  2283 00002772 83C402                   add  sp, 2
  2284                                  
  2285                                  ;-67     if (CodeType== 200) {// DB
  2286                                  
  2287                                  @@getVariable86:
  2288 00002775 A0[AE01]                 mov al, [CodeType]
  2289 00002778 3CC8                     cmp al, 200
  2290 0000277A 0F856A00                 jne @@getVariable87
  2291                                  
  2292                                  ;-68       do { getTokeType();
  2293                                  
  2294                                  @@getVariable88:
  2295 0000277E E819FE                   call getTokeType
  2296                                  
  2297                                  ;-69         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2298                                  
  2299 00002781 A0[AB01]                 mov al, [TokeType]
  2300 00002784 3C01                     cmp al, 1
  2301 00002786 0F850D00                 jne @@getVariable89
  2302 0000278A FF36[4D00]               push word [SymbolInt]
  2303 0000278E E80C12                   call genCode8
  2304 00002791 83C402                   add  sp, 2
  2305                                  
  2306                                  ;-70         else {
  2307                                  
  2308 00002794 E94100                   jmp @@getVariable90
  2309                                  @@getVariable89:
  2310                                  
  2311                                  ;-71           skipBlank();
  2312                                  
  2313 00002797 E86E03                   call skipBlank
  2314                                  
  2315                                  ;-72           if (isToken('"')) {
  2316                                  
  2317 0000279A 6A22                     push 34
  2318 0000279C E8D101                   call isToken
  2319 0000279F 83C402                   add  sp, 2
  2320 000027A2 08C0                     or  al, al
  2321 000027A4 0F843000                 je @@getVariable91
  2322                                  
  2323                                  ;-73             do { c= *InputPtr;
  2324                                  
  2325                                  @@getVariable92:
  2326 000027A8 8B1E[CE00]               mov bx, [InputPtr]
  2327 000027AC 8A07                     mov al, [bx]
  2328 000027AE B400                     mov ah, 0
  2329 000027B0 8846FE                   mov byte [bp-2], al
  2330                                  
  2331                                  ;-74               genCode8(c);
  2332                                  
  2333 000027B3 8A46FE                   mov al, byte [bp-2]
  2334 000027B6 B400                     mov ah, 0
  2335 000027B8 50                       push ax
  2336 000027B9 E8E111                   call genCode8
  2337 000027BC 83C402                   add  sp, 2
  2338                                  
  2339                                  ;-75               InputPtr++;
  2340                                  
  2341 000027BF FF06[CE00]               inc  word [InputPtr]
  2342                                  
  2343                                  ;-76             } while (*InputPtr != '"' );
  2344                                  
  2345 000027C3 8B1E[CE00]               mov bx, [InputPtr]
  2346 000027C7 8A07                     mov al, [bx]
  2347 000027C9 B400                     mov ah, 0
  2348 000027CB 83F822                   cmp ax, 34
  2349 000027CE 0F840200                 je  @@getVariable93
  2350 000027D2 EBD4                     jmp @@getVariable92
  2351                                  @@getVariable93:
  2352                                  
  2353                                  ;-77             InputPtr++;
  2354                                  
  2355 000027D4 FF06[CE00]               inc  word [InputPtr]
  2356                                  
  2357                                  ;-78           }
  2358                                  
  2359                                  
  2360                                  ;-79         }
  2361                                  
  2362                                  @@getVariable91:
  2363                                  
  2364                                  ;-80       } while (isToken(','));
  2365                                  
  2366                                  @@getVariable90:
  2367 000027D8 6A2C                     push 44
  2368 000027DA E89301                   call isToken
  2369 000027DD 83C402                   add  sp, 2
  2370 000027E0 08C0                     or  al, al
  2371 000027E2 0F840200                 je @@getVariable94
  2372 000027E6 EB96                     jmp @@getVariable88
  2373                                  @@getVariable94:
  2374                                  
  2375                                  ;-81     }
  2376                                  
  2377                                  
  2378                                  ;-82     if (CodeType== 201) {// DW
  2379                                  
  2380                                  @@getVariable87:
  2381 000027E8 A0[AE01]                 mov al, [CodeType]
  2382 000027EB 3CC9                     cmp al, 201
  2383 000027ED 0F852600                 jne @@getVariable95
  2384                                  
  2385                                  ;-83       do { getTokeType();
  2386                                  
  2387                                  @@getVariable96:
  2388 000027F1 E8A6FD                   call getTokeType
  2389                                  
  2390                                  ;-84         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2391                                  
  2392 000027F4 A0[AB01]                 mov al, [TokeType]
  2393 000027F7 3C01                     cmp al, 1
  2394 000027F9 0F850A00                 jne @@getVariable97
  2395 000027FD FF36[4D00]               push word [SymbolInt]
  2396 00002801 E8F011                   call genCode16
  2397 00002804 83C402                   add  sp, 2
  2398                                  
  2399                                  ;-85       } while (isToken(','));
  2400                                  
  2401                                  @@getVariable97:
  2402 00002807 6A2C                     push 44
  2403 00002809 E86401                   call isToken
  2404 0000280C 83C402                   add  sp, 2
  2405 0000280F 08C0                     or  al, al
  2406 00002811 0F840200                 je @@getVariable98
  2407 00002815 EBDA                     jmp @@getVariable96
  2408                                  @@getVariable98:
  2409                                  
  2410                                  ;-86     }
  2411                                  
  2412                                  
  2413                                  ;-87   }
  2414                                  
  2415                                  @@getVariable95:
  2416                                  
  2417                                  ;-88   else errorexit("DB,DW,DD or RESB,W,D expected");
  2418                                  
  2419 00002817 E90900                   jmp @@getVariable99
  2420                                  @@getVariable84:
  2421 0000281A 68[5528]                 push getVariable_2
  2422 0000281D E8070C                   call errorexit
  2423 00002820 83C402                   add  sp, 2
  2424                                  
  2425                                  ;-89 }
  2426                                  
  2427                                  @@getVariable99:
  2428                                  
  2429                                  ;-90 int lookCode() { // ret: CodeType, *OpCodePtr
  2430 00002823 C9                       LEAVE
  2431 00002824 C3                       ret
  2432                                  ; ENDP
  2433 00002825 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2434 0000282E 422C572C4420657870-
  2435 00002837 656374656400       
  2436 0000283D 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2437 00002846 422C572C4420657870-
  2438 0000284F 656374656400       
  2439 00002855 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2440 0000285E 6F7220524553422C57-
  2441 00002867 2C4420657870656374-
  2442 00002870 656400             
  2443                                  
  2444                                  lookCode:  ; *** PROC ***
  2445                                  
  2446                                  ;-91   CodeType=0;
  2447                                  
  2448 00002873 66B800000000             mov eax, 0
  2449 00002879 A2[AE01]                 mov byte [CodeType], al
  2450                                  
  2451                                  ;-92   OpCodePtr= &I_START;
  2452                                  
  2453 0000287C B8[051C]                 mov ax, I_START
  2454 0000287F A3[C701]                 mov word [OpCodePtr], ax
  2455                                  
  2456                                  ;-93   OpCodePtr++;
  2457                                  
  2458 00002882 FF06[C701]               inc  word [OpCodePtr]
  2459                                  
  2460                                  ;-94   do  {
  2461                                  
  2462                                  @@lookCode100:
  2463                                  
  2464                                  ;-95     if (eqstr(SymbolUpper, OpCodePtr))  {
  2465                                  
  2466 00002886 FF36[C701]               push word [OpCodePtr]
  2467 0000288A 8D06[2E00]               lea  ax, [SymbolUpper]
  2468 0000288E 50                       push ax
  2469 0000288F E85F1A                   call eqstr
  2470 00002892 83C404                   add  sp, 4
  2471 00002895 08C0                     or  al, al
  2472 00002897 0F842700                 je @@lookCode101
  2473                                  
  2474                                  ;-96       while(*OpCodePtr!=0) OpCodePtr++;
  2475                                  
  2476                                  @@lookCode102:
  2477 0000289B 8B1E[C701]               mov bx, [OpCodePtr]
  2478 0000289F 8A07                     mov al, [bx]
  2479 000028A1 B400                     mov ah, 0
  2480 000028A3 83F800                   cmp ax, 0
  2481 000028A6 0F840600                 je  @@lookCode103
  2482 000028AA FF06[C701]               inc  word [OpCodePtr]
  2483                                  
  2484                                  ;-97       OpCodePtr++; CodeType =*OpCodePtr;
  2485                                  
  2486 000028AE EBEB                     jmp @@lookCode102
  2487                                  @@lookCode103:
  2488 000028B0 FF06[C701]               inc  word [OpCodePtr]
  2489 000028B4 8B1E[C701]               mov bx, [OpCodePtr]
  2490 000028B8 8A07                     mov al, [bx]
  2491 000028BA B400                     mov ah, 0
  2492 000028BC A2[AE01]                 mov byte [CodeType], al
  2493                                  
  2494                                  ;-98       return;
  2495                                  
  2496 000028BF E92A00                   jmp @@retn
  2497                                  
  2498                                  ;-99     }
  2499                                  
  2500                                  
  2501                                  ;-100   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2502                                  
  2503                                  @@lookCode101:
  2504                                  @@lookCode104:
  2505 000028C2 8B1E[C701]               mov bx, [OpCodePtr]
  2506 000028C6 8A07                     mov al, [bx]
  2507 000028C8 B400                     mov ah, 0
  2508 000028CA 3DF100                   cmp ax, 241
  2509 000028CD 0F840600                 je  @@lookCode105
  2510 000028D1 FF06[C701]               inc  word [OpCodePtr]
  2511                                  
  2512                                  ;-101   OpCodePtr++;
  2513                                  
  2514 000028D5 EBEB                     jmp @@lookCode104
  2515                                  @@lookCode105:
  2516 000028D7 FF06[C701]               inc  word [OpCodePtr]
  2517                                  
  2518                                  ;-102   } while(*OpCodePtr!=0);
  2519                                  
  2520 000028DB 8B1E[C701]               mov bx, [OpCodePtr]
  2521 000028DF 8A07                     mov al, [bx]
  2522 000028E1 B400                     mov ah, 0
  2523 000028E3 83F800                   cmp ax, 0
  2524 000028E6 0F840200                 je  @@lookCode106
  2525 000028EA EB9A                     jmp @@lookCode100
  2526                                  @@lookCode106:
  2527                                  
  2528                                  ;-103 }
  2529                                  
  2530                                  
  2531                                  ;-104 
  2532                                  
  2533                                  
  2534                                  ;-105 int getCodeSize() {
  2535                                  
  2536                                  @@retn:
  2537 000028EC C3                       ret
  2538                                  ; ENDP
  2539                                  
  2540                                  getCodeSize:  ; *** PROC ***
  2541                                  
  2542                                  ;-106   if (TokeType ==ALNUME) {
  2543                                  
  2544 000028ED A0[AB01]                 mov al, [TokeType]
  2545 000028F0 3C03                     cmp al, 3
  2546 000028F2 0F856000                 jne @@getCodeSize107
  2547                                  
  2548                                  ;-107     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2549                                  
  2550 000028F6 68[6029]                 push getCodeSize_0
  2551 000028F9 8D06[2E00]               lea  ax, [SymbolUpper]
  2552 000028FD 50                       push ax
  2553 000028FE E8F019                   call eqstr
  2554 00002901 83C404                   add  sp, 4
  2555 00002904 08C0                     or  al, al
  2556 00002906 0F840C00                 je @@getCodeSize108
  2557 0000290A E88DFC                   call getTokeType
  2558 0000290D 66B801000000             mov eax, 1
  2559 00002913 E94900                   jmp @@retn
  2560                                  
  2561                                  ;-108     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2562                                  
  2563                                  @@getCodeSize108:
  2564 00002916 68[6529]                 push getCodeSize_1
  2565 00002919 8D06[2E00]               lea  ax, [SymbolUpper]
  2566 0000291D 50                       push ax
  2567 0000291E E8D019                   call eqstr
  2568 00002921 83C404                   add  sp, 4
  2569 00002924 08C0                     or  al, al
  2570 00002926 0F840C00                 je @@getCodeSize109
  2571 0000292A E86DFC                   call getTokeType
  2572 0000292D 66B802000000             mov eax, 2
  2573 00002933 E92900                   jmp @@retn
  2574                                  
  2575                                  ;-109     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2576                                  
  2577                                  @@getCodeSize109:
  2578 00002936 68[6A29]                 push getCodeSize_2
  2579 00002939 8D06[2E00]               lea  ax, [SymbolUpper]
  2580 0000293D 50                       push ax
  2581 0000293E E8B019                   call eqstr
  2582 00002941 83C404                   add  sp, 4
  2583 00002944 08C0                     or  al, al
  2584 00002946 0F840C00                 je @@getCodeSize110
  2585 0000294A E84DFC                   call getTokeType
  2586 0000294D 66B803000000             mov eax, 3
  2587 00002953 E90900                   jmp @@retn
  2588                                  
  2589                                  ;-110   } return 0;
  2590                                  
  2591                                  @@getCodeSize110:
  2592                                  @@getCodeSize107:
  2593 00002956 66B800000000             mov eax, 0
  2594 0000295C E90000                   jmp @@retn
  2595                                  
  2596                                  ;-111 }
  2597                                  
  2598                                  
  2599                                  ;-112 int isToken(char c) {
  2600                                  
  2601                                  @@retn:
  2602 0000295F C3                       ret
  2603                                  ; ENDP
  2604 00002960 4259544500              getCodeSize_0 db "BYTE",0
  2605 00002965 574F524400              getCodeSize_1 db "WORD",0
  2606 0000296A 44574F524400            getCodeSize_2 db "DWORD",0
  2607                                  
  2608                                  isToken:  ; *** PROC ***
  2609                                  
  2610                                  ;-113   skipBlank();
  2611                                  
  2612                                  ;Function : isToken, Number of local variables: 1
  2613                                  ;   # type sign width line used address name   list of local variables
  2614                                  ;  200 var sign byte   112 NULL bp+4    c;
  2615 00002970 C8000000                 ENTER  0,0
  2616 00002974 E89101                   call skipBlank
  2617                                  
  2618                                  ;-114   if (*InputPtr == c) {
  2619                                  
  2620 00002977 8B1E[CE00]               mov bx, [InputPtr]
  2621 0000297B 8A07                     mov al, [bx]
  2622 0000297D B400                     mov ah, 0
  2623 0000297F 3A4604                   cmp al, [bp+4]
  2624 00002982 0F850D00                 jne @@isToken111
  2625                                  
  2626                                  ;-115     InputPtr++; return 1;} return 0;
  2627                                  
  2628 00002986 FF06[CE00]               inc  word [InputPtr]
  2629 0000298A 66B801000000             mov eax, 1
  2630 00002990 E90900                   jmp @@retn
  2631                                  @@isToken111:
  2632 00002993 66B800000000             mov eax, 0
  2633 00002999 E90000                   jmp @@retn
  2634                                  
  2635                                  ;-116 }
  2636                                  
  2637                                  
  2638                                  ;-117 int need(char c) {
  2639                                  
  2640 0000299C C9                      @@retn: LEAVE
  2641 0000299D C3                       ret
  2642                                  ; ENDP
  2643                                  
  2644                                  need:  ; *** PROC ***
  2645                                  
  2646                                  ;-118   if (isToken(c)) {
  2647                                  
  2648                                  ;Function : need, Number of local variables: 1
  2649                                  ;   # type sign width line used address name   list of local variables
  2650                                  ;  200 var sign byte   117 NULL bp+4    c;
  2651 0000299E C8000000                 ENTER  0,0
  2652 000029A2 8A4604                   mov al, byte [bp+4]
  2653 000029A5 B400                     mov ah, 0
  2654 000029A7 50                       push ax
  2655 000029A8 E8C5FF                   call isToken
  2656 000029AB 83C402                   add  sp, 2
  2657 000029AE 08C0                     or  al, al
  2658 000029B0 0F840600                 je @@need112
  2659                                  
  2660                                  ;-119       getTokeType();
  2661                                  
  2662 000029B4 E8E3FB                   call getTokeType
  2663                                  
  2664                                  ;-120       return;
  2665                                  
  2666 000029B7 E91800                   jmp @@retn
  2667                                  
  2668                                  ;-121       }
  2669                                  
  2670                                  
  2671                                  ;-122   error1();
  2672                                  
  2673                                  @@need112:
  2674 000029BA E80B0A                   call error1
  2675                                  
  2676                                  ;-123   prs(". need: ");
  2677                                  
  2678 000029BD 68[D429]                 push need_0
  2679 000029C0 E8A408                   call prs
  2680 000029C3 83C402                   add  sp, 2
  2681                                  
  2682                                  ;-124   prc(c);
  2683                                  
  2684 000029C6 8A4604                   mov al, byte [bp+4]
  2685 000029C9 B400                     mov ah, 0
  2686 000029CB 50                       push ax
  2687 000029CC E83708                   call prc
  2688 000029CF 83C402                   add  sp, 2
  2689                                  
  2690                                  ;-125 }
  2691                                  
  2692                                  
  2693                                  ;-126 
  2694                                  
  2695                                  
  2696                                  ;-127 int skipRest() {
  2697                                  
  2698 000029D2 C9                      @@retn: LEAVE
  2699 000029D3 C3                       ret
  2700                                  ; ENDP
  2701 000029D4 2E206E6565643A2000      need_0 db ". need: ",0
  2702                                  
  2703                                  skipRest:  ; *** PROC ***
  2704                                  
  2705                                  ;-128   getTokeType(); 
  2706                                  
  2707 000029DD E8BAFB                   call getTokeType
  2708                                  
  2709                                  ;-129   if(TokeType)error1("extra char ignored");
  2710                                  
  2711 000029E0 A0[AB01]                 mov al, [TokeType]
  2712 000029E3 08C0                     or  al, al
  2713 000029E5 0F840900                 je @@skipRest113
  2714 000029E9 68[F329]                 push skipRest_0
  2715 000029EC E8D909                   call error1
  2716 000029EF 83C402                   add  sp, 2
  2717                                  
  2718                                  ;-130 }
  2719                                  
  2720                                  @@skipRest113:
  2721 000029F2 C3                       ret
  2722                                  ; ENDP
  2723 000029F3 657874726120636861-     skipRest_0 db "extra char ignored",0
  2724 000029FC 722069676E6F726564-
  2725 00002A05 00                 
  2726                                  ;Back to main program: AS.C
  2727                                  
  2728                                  ;-6 #include "HELPER.C"
  2729                                  
  2730                                  ;Use include file: HELPER.C
  2731                                  
  2732                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2733                                  
  2734                                  
  2735                                  getLine:  ; *** PROC ***
  2736                                  
  2737                                  ;-2   unsigned int i;
  2738                                  
  2739                                  
  2740                                  ;-3   InputPtr= &InputBuf;
  2741                                  
  2742                                  ;Function : getLine, Number of local variables: 1
  2743                                  ;   # type sign width line used address name   list of local variables
  2744                                  ;  200 var unsg word     2 NULL bp-2    i;
  2745 00002A06 C8020000                 ENTER  2,0
  2746 00002A0A B8[4F00]                 mov ax, InputBuf
  2747 00002A0D A3[CE00]                 mov word [InputPtr], ax
  2748                                  
  2749                                  ;-4   *InputPtr=0;//if last line is empty
  2750                                  
  2751 00002A10 66B800000000             mov eax, 0
  2752 00002A16 8B1E[CE00]               mov  bx, [InputPtr]
  2753 00002A1A 8807                     mov  [bx], al
  2754                                  
  2755                                  ;-5   do {
  2756                                  
  2757                                  @@getLine114:
  2758                                  
  2759                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2760                                  
  2761 00002A1C 6A01                     push 1
  2762 00002A1E FF36[9901]               push word [asm_fd]
  2763 00002A22 8D06[A501]               lea  ax, [DOS_ByteRead]
  2764 00002A26 50                       push ax
  2765 00002A27 E86219                   call readRL
  2766 00002A2A 83C406                   add  sp, 6
  2767 00002A2D A3[A301]                 mov word [DOS_NoBytes], ax
  2768                                  
  2769                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2770                                  
  2771 00002A30 A1[9F01]                 mov ax, [DOS_ERR]
  2772 00002A33 08C0                     or  al, al
  2773 00002A35 0F840900                 je @@getLine115
  2774 00002A39 68[9E2A]                 push getLine_0
  2775 00002A3C E8E809                   call errorexit
  2776 00002A3F 83C402                   add  sp, 2
  2777                                  
  2778                                  ;-8     if (DOS_NoBytes == 0) return;
  2779                                  
  2780                                  @@getLine115:
  2781 00002A42 A1[A301]                 mov ax, [DOS_NoBytes]
  2782 00002A45 83F800                   cmp ax, 0
  2783 00002A48 0F850300                 jne @@getLine116
  2784 00002A4C E94D00                   jmp @@retn
  2785                                  
  2786                                  ;-9     *InputPtr = DOS_ByteRead;
  2787                                  
  2788                                  @@getLine116:
  2789 00002A4F A0[A501]                 mov al, [DOS_ByteRead]
  2790 00002A52 8B1E[CE00]               mov  bx, [InputPtr]
  2791 00002A56 8807                     mov  [bx], al
  2792                                  
  2793                                  ;-10     InputPtr++;
  2794                                  
  2795 00002A58 FF06[CE00]               inc  word [InputPtr]
  2796                                  
  2797                                  ;-11     i = InputPtr - &InputBuf;
  2798                                  
  2799 00002A5C A1[CE00]                 mov ax, [InputPtr]
  2800 00002A5F 2D[4F00]                 sub ax, InputBuf
  2801 00002A62 8946FE                   mov word [bp-2], ax
  2802                                  
  2803                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2804                                  
  2805 00002A65 8B46FE                   mov ax, [bp-2]
  2806 00002A68 83F87F                   cmp ax, 127 ;unsigned : 0
  2807 00002A6B 0F820900                 jb  @@getLine117
  2808 00002A6F 68[AD2A]                 push getLine_1
  2809 00002A72 E8B209                   call errorexit
  2810 00002A75 83C402                   add  sp, 2
  2811                                  
  2812                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2813                                  
  2814                                  @@getLine117:
  2815 00002A78 A0[A501]                 mov al, byte [DOS_ByteRead]
  2816 00002A7B B400                     mov ah, 0
  2817 00002A7D 50                       push ax
  2818 00002A7E E84000                   call ifEOL
  2819 00002A81 83C402                   add  sp, 2
  2820 00002A84 3C00                     cmp al, 0
  2821 00002A86 0F850200                 jne @@getLine118
  2822 00002A8A EB90                     jmp @@getLine114
  2823                                  @@getLine118:
  2824                                  
  2825                                  ;-14   InputPtr--;
  2826                                  
  2827 00002A8C FF0E[CE00]               dec  word [InputPtr]
  2828                                  
  2829                                  ;-15   *InputPtr=0;
  2830                                  
  2831 00002A90 66B800000000             mov eax, 0
  2832 00002A96 8B1E[CE00]               mov  bx, [InputPtr]
  2833 00002A9A 8807                     mov  [bx], al
  2834                                  
  2835                                  ;-16 }
  2836                                  
  2837                                  
  2838                                  ;-17 int ifEOL(char c) {
  2839                                  
  2840 00002A9C C9                      @@retn: LEAVE
  2841 00002A9D C3                       ret
  2842                                  ; ENDP
  2843 00002A9E 52656164696E672053-     getLine_0 db "Reading Source",0
  2844 00002AA7 6F7572636500       
  2845 00002AAD 696E707574206C696E-     getLine_1 db "input line too long",0
  2846 00002AB6 6520746F6F206C6F6E-
  2847 00002ABF 6700               
  2848                                  
  2849                                  ifEOL:  ; *** PROC ***
  2850                                  
  2851                                  ;-18   if (c == 10) return 1;
  2852                                  
  2853                                  ;Function : ifEOL, Number of local variables: 1
  2854                                  ;   # type sign width line used address name   list of local variables
  2855                                  ;  200 var sign byte    17 NULL bp+4    c;
  2856 00002AC1 C8000000                 ENTER  0,0
  2857 00002AC5 8A4604                   mov al, [bp+4]
  2858 00002AC8 3C0A                     cmp al, 10
  2859 00002ACA 0F850900                 jne @@ifEOL119
  2860 00002ACE 66B801000000             mov eax, 1
  2861 00002AD4 E92F00                   jmp @@retn
  2862                                  
  2863                                  ;-19   if (c == 13) {
  2864                                  
  2865                                  @@ifEOL119:
  2866 00002AD7 8A4604                   mov al, [bp+4]
  2867 00002ADA 3C0D                     cmp al, 13
  2868 00002ADC 0F851D00                 jne @@ifEOL120
  2869                                  
  2870                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2871                                  
  2872 00002AE0 6A01                     push 1
  2873 00002AE2 FF36[9901]               push word [asm_fd]
  2874 00002AE6 8D06[A501]               lea  ax, [DOS_ByteRead]
  2875 00002AEA 50                       push ax
  2876 00002AEB E89E18                   call readRL
  2877 00002AEE 83C406                   add  sp, 6
  2878 00002AF1 A3[A301]                 mov word [DOS_NoBytes], ax
  2879                                  
  2880                                  ;-21     return 1;}
  2881                                  
  2882 00002AF4 66B801000000             mov eax, 1
  2883 00002AFA E90900                   jmp @@retn
  2884                                  
  2885                                  ;-22   return 0;
  2886                                  
  2887                                  @@ifEOL120:
  2888 00002AFD 66B800000000             mov eax, 0
  2889 00002B03 E90000                   jmp @@retn
  2890                                  
  2891                                  ;-23 }
  2892                                  
  2893                                  
  2894                                  ;-24 int skipBlank() {
  2895                                  
  2896 00002B06 C9                      @@retn: LEAVE
  2897 00002B07 C3                       ret
  2898                                  ; ENDP
  2899                                  
  2900                                  skipBlank:  ; *** PROC ***
  2901                                  
  2902                                  ;-25   skipblank1:
  2903                                  
  2904                                  @@skipblank1:
  2905                                  
  2906                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2907                                  
  2908 00002B08 8B1E[CE00]               mov bx, [InputPtr]
  2909 00002B0C 8A07                     mov al, [bx]
  2910 00002B0E B400                     mov ah, 0
  2911 00002B10 83F820                   cmp ax, 32
  2912 00002B13 0F850600                 jne @@skipBlank121
  2913 00002B17 FF06[CE00]               inc  word [InputPtr]
  2914 00002B1B EBEB                     jmp @@skipblank1
  2915                                  
  2916                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2917                                  
  2918                                  @@skipBlank121:
  2919 00002B1D 8B1E[CE00]               mov bx, [InputPtr]
  2920 00002B21 8A07                     mov al, [bx]
  2921 00002B23 B400                     mov ah, 0
  2922 00002B25 83F809                   cmp ax, 9
  2923 00002B28 0F850600                 jne @@skipBlank122
  2924 00002B2C FF06[CE00]               inc  word [InputPtr]
  2925 00002B30 EBD6                     jmp @@skipblank1
  2926                                  
  2927                                  ;-28 }
  2928                                  
  2929                                  @@skipBlank122:
  2930                                  
  2931                                  ;-29 int letterE(char c) {
  2932                                  
  2933 00002B32 C3                       ret
  2934                                  ; ENDP
  2935                                  
  2936                                  letterE:  ; *** PROC ***
  2937                                  
  2938                                  ;-30   if (c=='_') return 1;
  2939                                  
  2940                                  ;Function : letterE, Number of local variables: 1
  2941                                  ;   # type sign width line used address name   list of local variables
  2942                                  ;  200 var sign byte    29 NULL bp+4    c;
  2943 00002B33 C8000000                 ENTER  0,0
  2944 00002B37 8A4604                   mov al, [bp+4]
  2945 00002B3A 3C5F                     cmp al, 95
  2946 00002B3C 0F850900                 jne @@letterE123
  2947 00002B40 66B801000000             mov eax, 1
  2948 00002B46 E97E00                   jmp @@retn
  2949                                  
  2950                                  ;-31   if (c=='.') return 1;
  2951                                  
  2952                                  @@letterE123:
  2953 00002B49 8A4604                   mov al, [bp+4]
  2954 00002B4C 3C2E                     cmp al, 46
  2955 00002B4E 0F850900                 jne @@letterE124
  2956 00002B52 66B801000000             mov eax, 1
  2957 00002B58 E96C00                   jmp @@retn
  2958                                  
  2959                                  ;-32   if (c=='?') return 1;
  2960                                  
  2961                                  @@letterE124:
  2962 00002B5B 8A4604                   mov al, [bp+4]
  2963 00002B5E 3C3F                     cmp al, 63
  2964 00002B60 0F850900                 jne @@letterE125
  2965 00002B64 66B801000000             mov eax, 1
  2966 00002B6A E95A00                   jmp @@retn
  2967                                  
  2968                                  ;-33   if (c=='$') return 1;
  2969                                  
  2970                                  @@letterE125:
  2971 00002B6D 8A4604                   mov al, [bp+4]
  2972 00002B70 3C24                     cmp al, 36
  2973 00002B72 0F850900                 jne @@letterE126
  2974 00002B76 66B801000000             mov eax, 1
  2975 00002B7C E94800                   jmp @@retn
  2976                                  
  2977                                  ;-34   if (c> 'z') return 0;
  2978                                  
  2979                                  @@letterE126:
  2980 00002B7F 8A4604                   mov al, [bp+4]
  2981 00002B82 3C7A                     cmp al, 122
  2982 00002B84 0F8E0900                 jle @@letterE127
  2983 00002B88 66B800000000             mov eax, 0
  2984 00002B8E E93600                   jmp @@retn
  2985                                  
  2986                                  ;-35   if (c< '@') return 0; // at included
  2987                                  
  2988                                  @@letterE127:
  2989 00002B91 8A4604                   mov al, [bp+4]
  2990 00002B94 3C40                     cmp al, 64
  2991 00002B96 0F8D0900                 jge @@letterE128
  2992 00002B9A 66B800000000             mov eax, 0
  2993 00002BA0 E92400                   jmp @@retn
  2994                                  
  2995                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2996                                  
  2997                                  @@letterE128:
  2998 00002BA3 8A4604                   mov al, [bp+4]
  2999 00002BA6 3C5A                     cmp al, 90
  3000 00002BA8 0F8E1200                 jle @@letterE129
  3001 00002BAC 8A4604                   mov al, [bp+4]
  3002 00002BAF 3C61                     cmp al, 97
  3003 00002BB1 0F8D0900                 jge @@letterE130
  3004 00002BB5 66B800000000             mov eax, 0
  3005 00002BBB E90900                   jmp @@retn
  3006                                  @@letterE130:
  3007                                  
  3008                                  ;-37   return 1;
  3009                                  
  3010                                  @@letterE129:
  3011 00002BBE 66B801000000             mov eax, 1
  3012 00002BC4 E90000                   jmp @@retn
  3013                                  
  3014                                  ;-38 }
  3015                                  
  3016                                  
  3017                                  ;-39 int alnumE(char c) {
  3018                                  
  3019 00002BC7 C9                      @@retn: LEAVE
  3020 00002BC8 C3                       ret
  3021                                  ; ENDP
  3022                                  
  3023                                  alnumE:  ; *** PROC ***
  3024                                  
  3025                                  ;-40   if (digit(c)) return 1;
  3026                                  
  3027                                  ;Function : alnumE, Number of local variables: 1
  3028                                  ;   # type sign width line used address name   list of local variables
  3029                                  ;  200 var sign byte    39 NULL bp+4    c;
  3030 00002BC9 C8000000                 ENTER  0,0
  3031 00002BCD 8A4604                   mov al, byte [bp+4]
  3032 00002BD0 B400                     mov ah, 0
  3033 00002BD2 50                       push ax
  3034 00002BD3 E8E816                   call digit
  3035 00002BD6 83C402                   add  sp, 2
  3036 00002BD9 08C0                     or  al, al
  3037 00002BDB 0F840900                 je @@alnumE131
  3038 00002BDF 66B801000000             mov eax, 1
  3039 00002BE5 E92400                   jmp @@retn
  3040                                  
  3041                                  ;-41   if (letterE(c)) return 1;
  3042                                  
  3043                                  @@alnumE131:
  3044 00002BE8 8A4604                   mov al, byte [bp+4]
  3045 00002BEB B400                     mov ah, 0
  3046 00002BED 50                       push ax
  3047 00002BEE E842FF                   call letterE
  3048 00002BF1 83C402                   add  sp, 2
  3049 00002BF4 08C0                     or  al, al
  3050 00002BF6 0F840900                 je @@alnumE132
  3051 00002BFA 66B801000000             mov eax, 1
  3052 00002C00 E90900                   jmp @@retn
  3053                                  
  3054                                  ;-42   return 0;
  3055                                  
  3056                                  @@alnumE132:
  3057 00002C03 66B800000000             mov eax, 0
  3058 00002C09 E90000                   jmp @@retn
  3059                                  
  3060                                  ;-43 }
  3061                                  
  3062                                  
  3063                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3064                                  
  3065 00002C0C C9                      @@retn: LEAVE
  3066 00002C0D C3                       ret
  3067                                  ; ENDP
  3068                                  
  3069                                  getDigit:  ; *** PROC ***
  3070                                  
  3071                                  ;-45   unsigned int CastInt;
  3072                                  
  3073                                  
  3074                                  ;-46   SymbolInt=0;
  3075                                  
  3076                                  ;Function : getDigit, Number of local variables: 2
  3077                                  ;   # type sign width line used address name   list of local variables
  3078                                  ;  200 var unsg byte    44 NULL bp+4    c
  3079                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3080 00002C0E C8020000                 ENTER  2,0
  3081 00002C12 66B800000000             mov eax, 0
  3082 00002C18 A3[4D00]                 mov word [SymbolInt], ax
  3083                                  
  3084                                  ;-47   do {
  3085                                  
  3086                                  @@getDigit133:
  3087                                  
  3088                                  ;-48     c-='0';
  3089                                  
  3090 00002C1B 806E0430                 sub  byte [bp+4], 48
  3091                                  
  3092                                  ;-49     SymbolInt=SymbolInt*10;
  3093                                  
  3094 00002C1F A1[4D00]                 mov ax, [SymbolInt]
  3095 00002C22 66BB0A000000             mov ebx, 10
  3096 00002C28 66F7E3                   mul ebx
  3097 00002C2B A3[4D00]                 mov word [SymbolInt], ax
  3098                                  
  3099                                  ;-50     ax=0; CastInt=c; //cast b2w
  3100                                  
  3101 00002C2E B80000                   mov  ax, 0
  3102 00002C31 8A4604                   mov al, [bp+4]
  3103 00002C34 8946FE                   mov word [bp-2], ax
  3104                                  
  3105                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3106                                  
  3107 00002C37 A1[4D00]                 mov ax, [SymbolInt]
  3108 00002C3A 0346FE                   add ax, [bp-2]
  3109 00002C3D A3[4D00]                 mov word [SymbolInt], ax
  3110                                  
  3111                                  ;-52     InputPtr++;
  3112                                  
  3113 00002C40 FF06[CE00]               inc  word [InputPtr]
  3114                                  
  3115                                  ;-53     c = *InputPtr;
  3116                                  
  3117 00002C44 8B1E[CE00]               mov bx, [InputPtr]
  3118 00002C48 8A07                     mov al, [bx]
  3119 00002C4A B400                     mov ah, 0
  3120 00002C4C 884604                   mov byte [bp+4], al
  3121                                  
  3122                                  ;-54   } while(digit(c));
  3123                                  
  3124 00002C4F 8A4604                   mov al, byte [bp+4]
  3125 00002C52 B400                     mov ah, 0
  3126 00002C54 50                       push ax
  3127 00002C55 E86616                   call digit
  3128 00002C58 83C402                   add  sp, 2
  3129 00002C5B 08C0                     or  al, al
  3130 00002C5D 0F840200                 je @@getDigit134
  3131 00002C61 EBB8                     jmp @@getDigit133
  3132                                  @@getDigit134:
  3133                                  
  3134                                  ;-55 }
  3135                                  
  3136                                  
  3137                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3138 00002C63 C9                       LEAVE
  3139 00002C64 C3                       ret
  3140                                  ; ENDP
  3141                                  
  3142                                  getName:  ; *** PROC ***
  3143                                  
  3144                                  ;-57   char *p; unsigned int i;
  3145                                  
  3146                                  
  3147                                  ;-58   p = &Symbol;
  3148                                  
  3149                                  ;Function : getName, Number of local variables: 3
  3150                                  ;   # type sign width line used address name   list of local variables
  3151                                  ;  200 var unsg byte    56 NULL bp+4    c
  3152                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3153                                  ;  202 var unsg word    57 NULL bp-4    i;
  3154 00002C65 C8040000                 ENTER  4,0
  3155 00002C69 B8[0F00]                 mov ax, Symbol
  3156 00002C6C 8946FE                   mov word [bp-2], ax
  3157                                  
  3158                                  ;-59   *p = c;
  3159                                  
  3160 00002C6F 8A4604                   mov al, [bp+4]
  3161 00002C72 8B5EFE                   mov  bx, [bp-2]
  3162 00002C75 8807                     mov  [bx], al
  3163                                  
  3164                                  ;-60   p++;
  3165                                  
  3166 00002C77 FF46FE                   inc  word [bp-2]
  3167                                  
  3168                                  ;-61   while (alnumE(c)) {
  3169                                  
  3170                                  @@getName135:
  3171 00002C7A 8A4604                   mov al, byte [bp+4]
  3172 00002C7D B400                     mov ah, 0
  3173 00002C7F 50                       push ax
  3174 00002C80 E846FF                   call alnumE
  3175 00002C83 83C402                   add  sp, 2
  3176 00002C86 08C0                     or  al, al
  3177 00002C88 0F843800                 je @@getName136
  3178                                  
  3179                                  ;-62     InputPtr++;
  3180                                  
  3181 00002C8C FF06[CE00]               inc  word [InputPtr]
  3182                                  
  3183                                  ;-63     c = *InputPtr;
  3184                                  
  3185 00002C90 8B1E[CE00]               mov bx, [InputPtr]
  3186 00002C94 8A07                     mov al, [bx]
  3187 00002C96 B400                     mov ah, 0
  3188 00002C98 884604                   mov byte [bp+4], al
  3189                                  
  3190                                  ;-64     *p = c;
  3191                                  
  3192 00002C9B 8A4604                   mov al, [bp+4]
  3193 00002C9E 8B5EFE                   mov  bx, [bp-2]
  3194 00002CA1 8807                     mov  [bx], al
  3195                                  
  3196                                  ;-65     p++;
  3197                                  
  3198 00002CA3 FF46FE                   inc  word [bp-2]
  3199                                  
  3200                                  ;-66     i = p - &Symbol;
  3201                                  
  3202 00002CA6 8B46FE                   mov ax, [bp-2]
  3203 00002CA9 2D[0F00]                 sub ax, Symbol
  3204 00002CAC 8946FC                   mov word [bp-4], ax
  3205                                  
  3206                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3207                                  
  3208 00002CAF 8B46FC                   mov ax, [bp-4]
  3209 00002CB2 83F81F                   cmp ax, 31 ;unsigned : 0
  3210 00002CB5 0F820900                 jb  @@getName137
  3211 00002CB9 68[0D2D]                 push getName_0
  3212 00002CBC E86807                   call errorexit
  3213 00002CBF 83C402                   add  sp, 2
  3214                                  
  3215                                  ;-68   }
  3216                                  
  3217                                  @@getName137:
  3218                                  
  3219                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3220                                  
  3221 00002CC2 EBB6                     jmp @@getName135
  3222                                  @@getName136:
  3223 00002CC4 8A4604                   mov al, [bp+4]
  3224 00002CC7 3C3A                     cmp al, 58
  3225 00002CC9 0F850C00                 jne @@getName138
  3226 00002CCD 66B801000000             mov eax, 1
  3227 00002CD3 A2[AA01]                 mov byte [isLabel], al
  3228 00002CD6 E90900                   jmp @@getName139
  3229                                  @@getName138:
  3230 00002CD9 66B800000000             mov eax, 0
  3231 00002CDF A2[AA01]                 mov byte [isLabel], al
  3232                                  
  3233                                  ;-70   p--;
  3234                                  
  3235                                  @@getName139:
  3236 00002CE2 FF4EFE                   dec  word [bp-2]
  3237                                  
  3238                                  ;-71   *p = 0;
  3239                                  
  3240 00002CE5 66B800000000             mov eax, 0
  3241 00002CEB 8B5EFE                   mov  bx, [bp-2]
  3242 00002CEE 8807                     mov  [bx], al
  3243                                  
  3244                                  ;-72   strcpy(SymbolUpper, Symbol);
  3245                                  
  3246 00002CF0 8D06[0F00]               lea  ax, [Symbol]
  3247 00002CF4 50                       push ax
  3248 00002CF5 8D06[2E00]               lea  ax, [SymbolUpper]
  3249 00002CF9 50                       push ax
  3250 00002CFA E88815                   call strcpy
  3251 00002CFD 83C404                   add  sp, 4
  3252                                  
  3253                                  ;-73   toupper(SymbolUpper);
  3254                                  
  3255 00002D00 8D06[2E00]               lea  ax, [SymbolUpper]
  3256 00002D04 50                       push ax
  3257 00002D05 E80F15                   call toupper
  3258 00002D08 83C402                   add  sp, 2
  3259                                  
  3260                                  ;-74 }
  3261                                  
  3262                                  
  3263                                  ;-75 int testReg() {
  3264 00002D0B C9                       LEAVE
  3265 00002D0C C3                       ret
  3266                                  ; ENDP
  3267 00002D0D 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3268 00002D16 6F206C6F6E6700     
  3269                                  
  3270                                  testReg:  ; *** PROC ***
  3271                                  
  3272                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3273                                  
  3274                                  
  3275                                  ;-77   R2Type=0;
  3276                                  
  3277 00002D1D 66B800000000             mov eax, 0
  3278 00002D23 A2[B401]                 mov byte [R2Type], al
  3279                                  
  3280                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3281                                  
  3282 00002D26 8D06[0F00]               lea  ax, [Symbol]
  3283 00002D2A 50                       push ax
  3284 00002D2B E82C15                   call strlen
  3285 00002D2E 83C402                   add  sp, 2
  3286 00002D31 3C02                     cmp al, 2
  3287 00002D33 0F8D0900                 jge @@testReg140
  3288 00002D37 66B800000000             mov eax, 0
  3289 00002D3D E9B603                   jmp @@retn
  3290                                  
  3291                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3292                                  
  3293                                  @@testReg140:
  3294 00002D40 8D06[0F00]               lea  ax, [Symbol]
  3295 00002D44 50                       push ax
  3296 00002D45 E81215                   call strlen
  3297 00002D48 83C402                   add  sp, 2
  3298 00002D4B 3C03                     cmp al, 3
  3299 00002D4D 0F8E0900                 jle @@testReg141
  3300 00002D51 66B800000000             mov eax, 0
  3301 00002D57 E99C03                   jmp @@retn
  3302                                  
  3303                                  ;-80   R2Type=BYTE;
  3304                                  
  3305                                  @@testReg141:
  3306 00002D5A 66B801000000             mov eax, 1
  3307 00002D60 A2[B401]                 mov byte [R2Type], al
  3308                                  
  3309                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3310                                  
  3311 00002D63 68[F730]                 push testReg_0
  3312 00002D66 8D06[2E00]               lea  ax, [SymbolUpper]
  3313 00002D6A 50                       push ax
  3314 00002D6B E88315                   call eqstr
  3315 00002D6E 83C404                   add  sp, 4
  3316 00002D71 08C0                     or  al, al
  3317 00002D73 0F840900                 je @@testReg142
  3318 00002D77 66B800000000             mov eax, 0
  3319 00002D7D E97603                   jmp @@retn
  3320                                  
  3321                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3322                                  
  3323                                  @@testReg142:
  3324 00002D80 68[FA30]                 push testReg_1
  3325 00002D83 8D06[2E00]               lea  ax, [SymbolUpper]
  3326 00002D87 50                       push ax
  3327 00002D88 E86615                   call eqstr
  3328 00002D8B 83C404                   add  sp, 4
  3329 00002D8E 08C0                     or  al, al
  3330 00002D90 0F840900                 je @@testReg143
  3331 00002D94 66B801000000             mov eax, 1
  3332 00002D9A E95903                   jmp @@retn
  3333                                  
  3334                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3335                                  
  3336                                  @@testReg143:
  3337 00002D9D 68[FD30]                 push testReg_2
  3338 00002DA0 8D06[2E00]               lea  ax, [SymbolUpper]
  3339 00002DA4 50                       push ax
  3340 00002DA5 E84915                   call eqstr
  3341 00002DA8 83C404                   add  sp, 4
  3342 00002DAB 08C0                     or  al, al
  3343 00002DAD 0F840900                 je @@testReg144
  3344 00002DB1 66B802000000             mov eax, 2
  3345 00002DB7 E93C03                   jmp @@retn
  3346                                  
  3347                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3348                                  
  3349                                  @@testReg144:
  3350 00002DBA 68[0031]                 push testReg_3
  3351 00002DBD 8D06[2E00]               lea  ax, [SymbolUpper]
  3352 00002DC1 50                       push ax
  3353 00002DC2 E82C15                   call eqstr
  3354 00002DC5 83C404                   add  sp, 4
  3355 00002DC8 08C0                     or  al, al
  3356 00002DCA 0F840900                 je @@testReg145
  3357 00002DCE 66B803000000             mov eax, 3
  3358 00002DD4 E91F03                   jmp @@retn
  3359                                  
  3360                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3361                                  
  3362                                  @@testReg145:
  3363 00002DD7 68[0331]                 push testReg_4
  3364 00002DDA 8D06[2E00]               lea  ax, [SymbolUpper]
  3365 00002DDE 50                       push ax
  3366 00002DDF E80F15                   call eqstr
  3367 00002DE2 83C404                   add  sp, 4
  3368 00002DE5 08C0                     or  al, al
  3369 00002DE7 0F840900                 je @@testReg146
  3370 00002DEB 66B804000000             mov eax, 4
  3371 00002DF1 E90203                   jmp @@retn
  3372                                  
  3373                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3374                                  
  3375                                  @@testReg146:
  3376 00002DF4 68[0631]                 push testReg_5
  3377 00002DF7 8D06[2E00]               lea  ax, [SymbolUpper]
  3378 00002DFB 50                       push ax
  3379 00002DFC E8F214                   call eqstr
  3380 00002DFF 83C404                   add  sp, 4
  3381 00002E02 08C0                     or  al, al
  3382 00002E04 0F840900                 je @@testReg147
  3383 00002E08 66B805000000             mov eax, 5
  3384 00002E0E E9E502                   jmp @@retn
  3385                                  
  3386                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3387                                  
  3388                                  @@testReg147:
  3389 00002E11 68[0931]                 push testReg_6
  3390 00002E14 8D06[2E00]               lea  ax, [SymbolUpper]
  3391 00002E18 50                       push ax
  3392 00002E19 E8D514                   call eqstr
  3393 00002E1C 83C404                   add  sp, 4
  3394 00002E1F 08C0                     or  al, al
  3395 00002E21 0F840900                 je @@testReg148
  3396 00002E25 66B806000000             mov eax, 6
  3397 00002E2B E9C802                   jmp @@retn
  3398                                  
  3399                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3400                                  
  3401                                  @@testReg148:
  3402 00002E2E 68[0C31]                 push testReg_7
  3403 00002E31 8D06[2E00]               lea  ax, [SymbolUpper]
  3404 00002E35 50                       push ax
  3405 00002E36 E8B814                   call eqstr
  3406 00002E39 83C404                   add  sp, 4
  3407 00002E3C 08C0                     or  al, al
  3408 00002E3E 0F840900                 je @@testReg149
  3409 00002E42 66B807000000             mov eax, 7
  3410 00002E48 E9AB02                   jmp @@retn
  3411                                  
  3412                                  ;-89   R2Type=WORD;
  3413                                  
  3414                                  @@testReg149:
  3415 00002E4B 66B802000000             mov eax, 2
  3416 00002E51 A2[B401]                 mov byte [R2Type], al
  3417                                  
  3418                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3419                                  
  3420 00002E54 68[0F31]                 push testReg_8
  3421 00002E57 8D06[2E00]               lea  ax, [SymbolUpper]
  3422 00002E5B 50                       push ax
  3423 00002E5C E89214                   call eqstr
  3424 00002E5F 83C404                   add  sp, 4
  3425 00002E62 08C0                     or  al, al
  3426 00002E64 0F840900                 je @@testReg150
  3427 00002E68 66B800000000             mov eax, 0
  3428 00002E6E E98502                   jmp @@retn
  3429                                  
  3430                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3431                                  
  3432                                  @@testReg150:
  3433 00002E71 68[1231]                 push testReg_9
  3434 00002E74 8D06[2E00]               lea  ax, [SymbolUpper]
  3435 00002E78 50                       push ax
  3436 00002E79 E87514                   call eqstr
  3437 00002E7C 83C404                   add  sp, 4
  3438 00002E7F 08C0                     or  al, al
  3439 00002E81 0F840900                 je @@testReg151
  3440 00002E85 66B801000000             mov eax, 1
  3441 00002E8B E96802                   jmp @@retn
  3442                                  
  3443                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3444                                  
  3445                                  @@testReg151:
  3446 00002E8E 68[1531]                 push testReg_10
  3447 00002E91 8D06[2E00]               lea  ax, [SymbolUpper]
  3448 00002E95 50                       push ax
  3449 00002E96 E85814                   call eqstr
  3450 00002E99 83C404                   add  sp, 4
  3451 00002E9C 08C0                     or  al, al
  3452 00002E9E 0F840900                 je @@testReg152
  3453 00002EA2 66B802000000             mov eax, 2
  3454 00002EA8 E94B02                   jmp @@retn
  3455                                  
  3456                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3457                                  
  3458                                  @@testReg152:
  3459 00002EAB 68[1831]                 push testReg_11
  3460 00002EAE 8D06[2E00]               lea  ax, [SymbolUpper]
  3461 00002EB2 50                       push ax
  3462 00002EB3 E83B14                   call eqstr
  3463 00002EB6 83C404                   add  sp, 4
  3464 00002EB9 08C0                     or  al, al
  3465 00002EBB 0F840900                 je @@testReg153
  3466 00002EBF 66B803000000             mov eax, 3
  3467 00002EC5 E92E02                   jmp @@retn
  3468                                  
  3469                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3470                                  
  3471                                  @@testReg153:
  3472 00002EC8 68[1B31]                 push testReg_12
  3473 00002ECB 8D06[2E00]               lea  ax, [SymbolUpper]
  3474 00002ECF 50                       push ax
  3475 00002ED0 E81E14                   call eqstr
  3476 00002ED3 83C404                   add  sp, 4
  3477 00002ED6 08C0                     or  al, al
  3478 00002ED8 0F840900                 je @@testReg154
  3479 00002EDC 66B804000000             mov eax, 4
  3480 00002EE2 E91102                   jmp @@retn
  3481                                  
  3482                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3483                                  
  3484                                  @@testReg154:
  3485 00002EE5 68[1E31]                 push testReg_13
  3486 00002EE8 8D06[2E00]               lea  ax, [SymbolUpper]
  3487 00002EEC 50                       push ax
  3488 00002EED E80114                   call eqstr
  3489 00002EF0 83C404                   add  sp, 4
  3490 00002EF3 08C0                     or  al, al
  3491 00002EF5 0F840900                 je @@testReg155
  3492 00002EF9 66B805000000             mov eax, 5
  3493 00002EFF E9F401                   jmp @@retn
  3494                                  
  3495                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3496                                  
  3497                                  @@testReg155:
  3498 00002F02 68[2131]                 push testReg_14
  3499 00002F05 8D06[2E00]               lea  ax, [SymbolUpper]
  3500 00002F09 50                       push ax
  3501 00002F0A E8E413                   call eqstr
  3502 00002F0D 83C404                   add  sp, 4
  3503 00002F10 08C0                     or  al, al
  3504 00002F12 0F840900                 je @@testReg156
  3505 00002F16 66B806000000             mov eax, 6
  3506 00002F1C E9D701                   jmp @@retn
  3507                                  
  3508                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3509                                  
  3510                                  @@testReg156:
  3511 00002F1F 68[2431]                 push testReg_15
  3512 00002F22 8D06[2E00]               lea  ax, [SymbolUpper]
  3513 00002F26 50                       push ax
  3514 00002F27 E8C713                   call eqstr
  3515 00002F2A 83C404                   add  sp, 4
  3516 00002F2D 08C0                     or  al, al
  3517 00002F2F 0F840900                 je @@testReg157
  3518 00002F33 66B807000000             mov eax, 7
  3519 00002F39 E9BA01                   jmp @@retn
  3520                                  
  3521                                  ;-98   R2Type=SEGREG;
  3522                                  
  3523                                  @@testReg157:
  3524 00002F3C 66B804000000             mov eax, 4
  3525 00002F42 A2[B401]                 mov byte [R2Type], al
  3526                                  
  3527                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3528                                  
  3529 00002F45 68[2731]                 push testReg_16
  3530 00002F48 8D06[2E00]               lea  ax, [SymbolUpper]
  3531 00002F4C 50                       push ax
  3532 00002F4D E8A113                   call eqstr
  3533 00002F50 83C404                   add  sp, 4
  3534 00002F53 08C0                     or  al, al
  3535 00002F55 0F840900                 je @@testReg158
  3536 00002F59 66B800000000             mov eax, 0
  3537 00002F5F E99401                   jmp @@retn
  3538                                  
  3539                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3540                                  
  3541                                  @@testReg158:
  3542 00002F62 68[2A31]                 push testReg_17
  3543 00002F65 8D06[2E00]               lea  ax, [SymbolUpper]
  3544 00002F69 50                       push ax
  3545 00002F6A E88413                   call eqstr
  3546 00002F6D 83C404                   add  sp, 4
  3547 00002F70 08C0                     or  al, al
  3548 00002F72 0F840900                 je @@testReg159
  3549 00002F76 66B801000000             mov eax, 1
  3550 00002F7C E97701                   jmp @@retn
  3551                                  
  3552                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3553                                  
  3554                                  @@testReg159:
  3555 00002F7F 68[2D31]                 push testReg_18
  3556 00002F82 8D06[2E00]               lea  ax, [SymbolUpper]
  3557 00002F86 50                       push ax
  3558 00002F87 E86713                   call eqstr
  3559 00002F8A 83C404                   add  sp, 4
  3560 00002F8D 08C0                     or  al, al
  3561 00002F8F 0F840900                 je @@testReg160
  3562 00002F93 66B802000000             mov eax, 2
  3563 00002F99 E95A01                   jmp @@retn
  3564                                  
  3565                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3566                                  
  3567                                  @@testReg160:
  3568 00002F9C 68[3031]                 push testReg_19
  3569 00002F9F 8D06[2E00]               lea  ax, [SymbolUpper]
  3570 00002FA3 50                       push ax
  3571 00002FA4 E84A13                   call eqstr
  3572 00002FA7 83C404                   add  sp, 4
  3573 00002FAA 08C0                     or  al, al
  3574 00002FAC 0F840900                 je @@testReg161
  3575 00002FB0 66B803000000             mov eax, 3
  3576 00002FB6 E93D01                   jmp @@retn
  3577                                  
  3578                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3579                                  
  3580                                  @@testReg161:
  3581 00002FB9 68[3331]                 push testReg_20
  3582 00002FBC 8D06[2E00]               lea  ax, [SymbolUpper]
  3583 00002FC0 50                       push ax
  3584 00002FC1 E82D13                   call eqstr
  3585 00002FC4 83C404                   add  sp, 4
  3586 00002FC7 08C0                     or  al, al
  3587 00002FC9 0F840900                 je @@testReg162
  3588 00002FCD 66B804000000             mov eax, 4
  3589 00002FD3 E92001                   jmp @@retn
  3590                                  
  3591                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3592                                  
  3593                                  @@testReg162:
  3594 00002FD6 68[3631]                 push testReg_21
  3595 00002FD9 8D06[2E00]               lea  ax, [SymbolUpper]
  3596 00002FDD 50                       push ax
  3597 00002FDE E81013                   call eqstr
  3598 00002FE1 83C404                   add  sp, 4
  3599 00002FE4 08C0                     or  al, al
  3600 00002FE6 0F840900                 je @@testReg163
  3601 00002FEA 66B805000000             mov eax, 5
  3602 00002FF0 E90301                   jmp @@retn
  3603                                  
  3604                                  ;-105   R2Type=DWORD;                         
  3605                                  
  3606                                  @@testReg163:
  3607 00002FF3 66B803000000             mov eax, 3
  3608 00002FF9 A2[B401]                 mov byte [R2Type], al
  3609                                  
  3610                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3611                                  
  3612 00002FFC 68[3931]                 push testReg_22
  3613 00002FFF 8D06[2E00]               lea  ax, [SymbolUpper]
  3614 00003003 50                       push ax
  3615 00003004 E8EA12                   call eqstr
  3616 00003007 83C404                   add  sp, 4
  3617 0000300A 08C0                     or  al, al
  3618 0000300C 0F840900                 je @@testReg164
  3619 00003010 66B800000000             mov eax, 0
  3620 00003016 E9DD00                   jmp @@retn
  3621                                  
  3622                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3623                                  
  3624                                  @@testReg164:
  3625 00003019 68[3D31]                 push testReg_23
  3626 0000301C 8D06[2E00]               lea  ax, [SymbolUpper]
  3627 00003020 50                       push ax
  3628 00003021 E8CD12                   call eqstr
  3629 00003024 83C404                   add  sp, 4
  3630 00003027 08C0                     or  al, al
  3631 00003029 0F840900                 je @@testReg165
  3632 0000302D 66B801000000             mov eax, 1
  3633 00003033 E9C000                   jmp @@retn
  3634                                  
  3635                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3636                                  
  3637                                  @@testReg165:
  3638 00003036 68[4131]                 push testReg_24
  3639 00003039 8D06[2E00]               lea  ax, [SymbolUpper]
  3640 0000303D 50                       push ax
  3641 0000303E E8B012                   call eqstr
  3642 00003041 83C404                   add  sp, 4
  3643 00003044 08C0                     or  al, al
  3644 00003046 0F840900                 je @@testReg166
  3645 0000304A 66B802000000             mov eax, 2
  3646 00003050 E9A300                   jmp @@retn
  3647                                  
  3648                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3649                                  
  3650                                  @@testReg166:
  3651 00003053 68[4531]                 push testReg_25
  3652 00003056 8D06[2E00]               lea  ax, [SymbolUpper]
  3653 0000305A 50                       push ax
  3654 0000305B E89312                   call eqstr
  3655 0000305E 83C404                   add  sp, 4
  3656 00003061 08C0                     or  al, al
  3657 00003063 0F840900                 je @@testReg167
  3658 00003067 66B803000000             mov eax, 3
  3659 0000306D E98600                   jmp @@retn
  3660                                  
  3661                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3662                                  
  3663                                  @@testReg167:
  3664 00003070 68[4931]                 push testReg_26
  3665 00003073 8D06[2E00]               lea  ax, [SymbolUpper]
  3666 00003077 50                       push ax
  3667 00003078 E87612                   call eqstr
  3668 0000307B 83C404                   add  sp, 4
  3669 0000307E 08C0                     or  al, al
  3670 00003080 0F840900                 je @@testReg168
  3671 00003084 66B804000000             mov eax, 4
  3672 0000308A E96900                   jmp @@retn
  3673                                  
  3674                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3675                                  
  3676                                  @@testReg168:
  3677 0000308D 68[4D31]                 push testReg_27
  3678 00003090 8D06[2E00]               lea  ax, [SymbolUpper]
  3679 00003094 50                       push ax
  3680 00003095 E85912                   call eqstr
  3681 00003098 83C404                   add  sp, 4
  3682 0000309B 08C0                     or  al, al
  3683 0000309D 0F840900                 je @@testReg169
  3684 000030A1 66B805000000             mov eax, 5
  3685 000030A7 E94C00                   jmp @@retn
  3686                                  
  3687                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3688                                  
  3689                                  @@testReg169:
  3690 000030AA 68[5131]                 push testReg_28
  3691 000030AD 8D06[2E00]               lea  ax, [SymbolUpper]
  3692 000030B1 50                       push ax
  3693 000030B2 E83C12                   call eqstr
  3694 000030B5 83C404                   add  sp, 4
  3695 000030B8 08C0                     or  al, al
  3696 000030BA 0F840900                 je @@testReg170
  3697 000030BE 66B806000000             mov eax, 6
  3698 000030C4 E92F00                   jmp @@retn
  3699                                  
  3700                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3701                                  
  3702                                  @@testReg170:
  3703 000030C7 68[5531]                 push testReg_29
  3704 000030CA 8D06[2E00]               lea  ax, [SymbolUpper]
  3705 000030CE 50                       push ax
  3706 000030CF E81F12                   call eqstr
  3707 000030D2 83C404                   add  sp, 4
  3708 000030D5 08C0                     or  al, al
  3709 000030D7 0F840900                 je @@testReg171
  3710 000030DB 66B807000000             mov eax, 7
  3711 000030E1 E91200                   jmp @@retn
  3712                                  
  3713                                  ;-114   R2Type=0; return 0;
  3714                                  
  3715                                  @@testReg171:
  3716 000030E4 66B800000000             mov eax, 0
  3717 000030EA A2[B401]                 mov byte [R2Type], al
  3718 000030ED 66B800000000             mov eax, 0
  3719 000030F3 E90000                   jmp @@retn
  3720                                  
  3721                                  ;-115 }
  3722                                  
  3723                                  @@retn:
  3724 000030F6 C3                       ret
  3725                                  ; ENDP
  3726 000030F7 414C00                  testReg_0 db "AL",0
  3727 000030FA 434C00                  testReg_1 db "CL",0
  3728 000030FD 444C00                  testReg_2 db "DL",0
  3729 00003100 424C00                  testReg_3 db "BL",0
  3730 00003103 414800                  testReg_4 db "AH",0
  3731 00003106 434800                  testReg_5 db "CH",0
  3732 00003109 444800                  testReg_6 db "DH",0
  3733 0000310C 424800                  testReg_7 db "BH",0
  3734 0000310F 415800                  testReg_8 db "AX",0
  3735 00003112 435800                  testReg_9 db "CX",0
  3736 00003115 445800                  testReg_10 db "DX",0
  3737 00003118 425800                  testReg_11 db "BX",0
  3738 0000311B 535000                  testReg_12 db "SP",0
  3739 0000311E 425000                  testReg_13 db "BP",0
  3740 00003121 534900                  testReg_14 db "SI",0
  3741 00003124 444900                  testReg_15 db "DI",0
  3742 00003127 455300                  testReg_16 db "ES",0
  3743 0000312A 435300                  testReg_17 db "CS",0
  3744 0000312D 535300                  testReg_18 db "SS",0
  3745 00003130 445300                  testReg_19 db "DS",0
  3746 00003133 465300                  testReg_20 db "FS",0
  3747 00003136 475300                  testReg_21 db "GS",0
  3748 00003139 45415800                testReg_22 db "EAX",0
  3749 0000313D 45435800                testReg_23 db "ECX",0
  3750 00003141 45445800                testReg_24 db "EDX",0
  3751 00003145 45425800                testReg_25 db "EBX",0
  3752 00003149 45535000                testReg_26 db "ESP",0
  3753 0000314D 45425000                testReg_27 db "EBP",0
  3754 00003151 45534900                testReg_28 db "ESI",0
  3755 00003155 45444900                testReg_29 db "EDI",0
  3756                                  ;Back to main program: AS.C
  3757                                  
  3758                                  ;-7 #include "OUTPUT.C"
  3759                                  
  3760                                  ;Use include file: OUTPUT.C
  3761                                  
  3762                                  ;-1 int printLine() { 
  3763                                  
  3764                                  
  3765                                  printLine:  ; *** PROC ***
  3766                                  
  3767                                  ;-2     int i; char c;
  3768                                  
  3769                                  
  3770                                  ;-3     prs("\n"); 
  3771                                  
  3772                                  ;Function : printLine, Number of local variables: 2
  3773                                  ;   # type sign width line used address name   list of local variables
  3774                                  ;  200 var sign word     2 NULL bp-2    i
  3775                                  ;  201 var sign byte     2 NULL bp-4    c;
  3776 00003159 C8040000                 ENTER  4,0
  3777 0000315D 68[EE31]                 push printLine_0
  3778 00003160 E80401                   call prs
  3779 00003163 83C402                   add  sp, 2
  3780                                  
  3781                                  ;-4     printhex16(PCStart);
  3782                                  
  3783 00003166 FF36[A801]               push word [PCStart]
  3784 0000316A E8EF01                   call printhex16
  3785 0000316D 83C402                   add  sp, 2
  3786                                  
  3787                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  3788                                  
  3789 00003170 A1[C501]                 mov ax, [OpPrintIndex]
  3790 00003173 83F800                   cmp ax, 0
  3791 00003176 0F850C00                 jne @@printLine172
  3792 0000317A 68[F131]                 push printLine_1
  3793 0000317D E8E700                   call prs
  3794 00003180 83C402                   add  sp, 2
  3795                                  
  3796                                  ;-6     else {
  3797                                  
  3798 00003183 E94F00                   jmp @@printLine173
  3799                                  @@printLine172:
  3800                                  
  3801                                  ;-7 //        prc(' ');
  3802                                  
  3803                                  
  3804                                  ;-8         i=0;
  3805                                  
  3806 00003186 66B800000000             mov eax, 0
  3807 0000318C 8946FE                   mov word [bp-2], ax
  3808                                  
  3809                                  ;-9         do {
  3810                                  
  3811                                  @@printLine174:
  3812                                  
  3813                                  ;-10             c=OpPos[i];
  3814                                  
  3815 0000318F 8B5EFE                   mov bx, [bp-2]
  3816 00003192 8A87[C001]               mov al, [OpPos + bx]
  3817 00003196 8846FC                   mov byte [bp-4], al
  3818                                  
  3819                                  ;-11             prc(' ');
  3820                                  
  3821 00003199 6A20                     push 32
  3822 0000319B E86800                   call prc
  3823 0000319E 83C402                   add  sp, 2
  3824                                  
  3825                                  ;-12             printhex8a(c); 
  3826                                  
  3827 000031A1 8A46FC                   mov al, byte [bp-4]
  3828 000031A4 B400                     mov ah, 0
  3829 000031A6 50                       push ax
  3830 000031A7 E86001                   call printhex8a
  3831 000031AA 83C402                   add  sp, 2
  3832                                  
  3833                                  ;-13             i++;
  3834                                  
  3835 000031AD FF46FE                   inc  word [bp-2]
  3836                                  
  3837                                  ;-14         } while (i < OpPrintIndex);
  3838                                  
  3839 000031B0 8B46FE                   mov ax, [bp-2]
  3840 000031B3 3B06[C501]               cmp ax, [OpPrintIndex]
  3841 000031B7 0F8D0200                 jge @@printLine175
  3842 000031BB EBD2                     jmp @@printLine174
  3843                                  @@printLine175:
  3844                                  
  3845                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  3846                                  
  3847                                  @@printLine176:
  3848 000031BD 8B46FE                   mov ax, [bp-2]
  3849 000031C0 83F805                   cmp ax, 5
  3850 000031C3 0F8D0E00                 jge @@printLine177
  3851                                  
  3852                                  ;-16             prs("   ");
  3853                                  
  3854 000031C7 68[0232]                 push printLine_2
  3855 000031CA E89A00                   call prs
  3856 000031CD 83C402                   add  sp, 2
  3857                                  
  3858                                  ;-17             i++;
  3859                                  
  3860 000031D0 FF46FE                   inc  word [bp-2]
  3861                                  
  3862                                  ;-18         }
  3863                                  
  3864                                  
  3865                                  ;-19     }
  3866                                  
  3867 000031D3 EBE8                     jmp @@printLine176
  3868                                  @@printLine177:
  3869                                  
  3870                                  ;-20     prc(PrintRA);
  3871                                  
  3872                                  @@printLine173:
  3873 000031D5 A0[C901]                 mov al, byte [PrintRA]
  3874 000031D8 B400                     mov ah, 0
  3875 000031DA 50                       push ax
  3876 000031DB E82800                   call prc
  3877 000031DE 83C402                   add  sp, 2
  3878                                  
  3879                                  ;-21     prscomment(InputBuf);
  3880                                  
  3881 000031E1 8D06[4F00]               lea  ax, [InputBuf]
  3882 000031E5 50                       push ax
  3883 000031E6 E85000                   call prscomment
  3884 000031E9 83C402                   add  sp, 2
  3885                                  
  3886                                  ;-22 }
  3887                                  
  3888                                  
  3889                                  ;-23 int prc(unsigned char c) {//print char 
  3890 000031EC C9                       LEAVE
  3891 000031ED C3                       ret
  3892                                  ; ENDP
  3893 000031EE 5C6E00                  printLine_0 db "\n",0
  3894 000031F1 202020202020202020-     printLine_1 db "                ",0
  3895 000031FA 2020202020202000   
  3896 00003202 20202000                printLine_2 db "   ",0
  3897                                  
  3898                                  prc:  ; *** PROC ***
  3899                                  
  3900                                  ;-24     if (LIST) { 
  3901                                  
  3902                                  ;Function : prc, Number of local variables: 1
  3903                                  ;   # type sign width line used address name   list of local variables
  3904                                  ;  200 var unsg byte    23 NULL bp+4    c;
  3905 00003206 C8000000                 ENTER  0,0
  3906 0000320A A0[0E00]                 mov al, [LIST]
  3907 0000320D 08C0                     or  al, al
  3908 0000320F 0F841400                 je @@prc178
  3909                                  
  3910                                  ;-25         if ( _ c==10) {
  3911                                  
  3912 00003213 807E040A                cmp byte [bp+4], 10
  3913 00003217 0F850600                 jne @@prc179
  3914                                  
  3915                                  ;-26             ax=13; 
  3916                                  
  3917 0000321B B80D00                   mov  ax, 13
  3918                                  
  3919                                  ;-27             writetty(); 
  3920                                  
  3921 0000321E E8C00F                   call writetty
  3922                                  
  3923                                  ;-28             }
  3924                                  
  3925                                  
  3926                                  ;-29         al=c; 
  3927                                  
  3928                                  @@prc179:
  3929 00003221 8A4604                   mov  al, [bp+4]
  3930                                  
  3931                                  ;-30         writetty(); 
  3932                                  
  3933 00003224 E8BA0F                   call writetty
  3934                                  
  3935                                  ;-31         }
  3936                                  
  3937                                  
  3938                                  ;-32     fputcR(c,lst_fd); 
  3939                                  
  3940                                  @@prc178:
  3941 00003227 FF36[9B01]               push word [lst_fd]
  3942 0000322B 8A4604                   mov al, byte [bp+4]
  3943 0000322E B400                     mov ah, 0
  3944 00003230 50                       push ax
  3945 00003231 E86D11                   call fputcR
  3946 00003234 83C404                   add  sp, 4
  3947                                  
  3948                                  ;-33 }
  3949                                  
  3950                                  
  3951                                  ;-34 
  3952                                  
  3953                                  
  3954                                  ;-35 int prscomment(unsigned char *s) {
  3955 00003237 C9                       LEAVE
  3956 00003238 C3                       ret
  3957                                  ; ENDP
  3958                                  
  3959                                  prscomment:  ; *** PROC ***
  3960                                  
  3961                                  ;-36     unsigned char c;
  3962                                  
  3963                                  
  3964                                  ;-37     while (*s){
  3965                                  
  3966                                  ;Function : prscomment, Number of local variables: 2
  3967                                  ;   # type sign width line used address name   list of local variables
  3968                                  ;  200 ptr unsg byte    35 NULL bp+4    s
  3969                                  ;  201 var unsg byte    36 NULL bp-2    c;
  3970 00003239 C8020000                 ENTER  2,0
  3971                                  @@prscomment180:
  3972 0000323D 8B5E04                   mov bx, [bp+4]
  3973 00003240 8A07                     mov al, [bx]
  3974 00003242 B400                     mov ah, 0
  3975 00003244 08C0                     or  al, al
  3976 00003246 0F841B00                 je @@prscomment181
  3977                                  
  3978                                  ;-38         c=*s;
  3979                                  
  3980 0000324A 8B5E04                   mov bx, [bp+4]
  3981 0000324D 8A07                     mov al, [bx]
  3982 0000324F B400                     mov ah, 0
  3983 00003251 8846FE                   mov byte [bp-2], al
  3984                                  
  3985                                  ;-39         prc(c);
  3986                                  
  3987 00003254 8A46FE                   mov al, byte [bp-2]
  3988 00003257 B400                     mov ah, 0
  3989 00003259 50                       push ax
  3990 0000325A E8A9FF                   call prc
  3991 0000325D 83C402                   add  sp, 2
  3992                                  
  3993                                  ;-40         s++;
  3994                                  
  3995 00003260 FF4604                   inc  word [bp+4]
  3996                                  
  3997                                  ;-41     }
  3998                                  
  3999                                  
  4000                                  ;-42 }
  4001                                  
  4002 00003263 EBD8                     jmp @@prscomment180
  4003                                  @@prscomment181:
  4004                                  
  4005                                  ;-43 int prs(unsigned char *s) {
  4006 00003265 C9                       LEAVE
  4007 00003266 C3                       ret
  4008                                  ; ENDP
  4009                                  
  4010                                  prs:  ; *** PROC ***
  4011                                  
  4012                                  ;-44     unsigned char c; 
  4013                                  
  4014                                  
  4015                                  ;-45     int com; 
  4016                                  
  4017                                  
  4018                                  ;-46     com=0;
  4019                                  
  4020                                  ;Function : prs, Number of local variables: 3
  4021                                  ;   # type sign width line used address name   list of local variables
  4022                                  ;  200 ptr unsg byte    43 NULL bp+4    s
  4023                                  ;  201 var unsg byte    44 NULL bp-2    c
  4024                                  ;  202 var sign word    45 NULL bp-4    com;
  4025 00003267 C8040000                 ENTER  4,0
  4026 0000326B 66B800000000             mov eax, 0
  4027 00003271 8946FC                   mov word [bp-4], ax
  4028                                  
  4029                                  ;-47     while (*s) { 
  4030                                  
  4031                                  @@prs182:
  4032 00003274 8B5E04                   mov bx, [bp+4]
  4033 00003277 8A07                     mov al, [bx]
  4034 00003279 B400                     mov ah, 0
  4035 0000327B 08C0                     or  al, al
  4036 0000327D 0F848700                 je @@prs183
  4037                                  
  4038                                  ;-48         c=*s; 
  4039                                  
  4040 00003281 8B5E04                   mov bx, [bp+4]
  4041 00003284 8A07                     mov al, [bx]
  4042 00003286 B400                     mov ah, 0
  4043 00003288 8846FE                   mov byte [bp-2], al
  4044                                  
  4045                                  ;-49         if (c==34) {
  4046                                  
  4047 0000328B 8A46FE                   mov al, [bp-2]
  4048 0000328E 3C22                     cmp al, 34
  4049 00003290 0F851E00                 jne @@prs184
  4050                                  
  4051                                  ;-50             if (com) com=0; 
  4052                                  
  4053 00003294 8B46FC                   mov ax, [bp-4]
  4054 00003297 08C0                     or  al, al
  4055 00003299 0F840C00                 je @@prs185
  4056 0000329D 66B800000000             mov eax, 0
  4057 000032A3 8946FC                   mov word [bp-4], ax
  4058                                  
  4059                                  ;-51                 else com=1;  
  4060                                  
  4061 000032A6 E90900                   jmp @@prs186
  4062                                  @@prs185:
  4063 000032A9 66B801000000             mov eax, 1
  4064 000032AF 8946FC                   mov word [bp-4], ax
  4065                                  
  4066                                  ;-52         }
  4067                                  
  4068                                  @@prs186:
  4069                                  
  4070                                  ;-53         if (c==92) { 
  4071                                  
  4072                                  @@prs184:
  4073 000032B2 8A46FE                   mov al, [bp-2]
  4074 000032B5 3C5C                     cmp al, 92
  4075 000032B7 0F853B00                 jne @@prs187
  4076                                  
  4077                                  ;-54             if (com==0) { 
  4078                                  
  4079 000032BB 8B46FC                   mov ax, [bp-4]
  4080 000032BE 83F800                   cmp ax, 0
  4081 000032C1 0F853100                 jne @@prs188
  4082                                  
  4083                                  ;-55                 s++; 
  4084                                  
  4085 000032C5 FF4604                   inc  word [bp+4]
  4086                                  
  4087                                  ;-56                 c=*s;
  4088                                  
  4089 000032C8 8B5E04                   mov bx, [bp+4]
  4090 000032CB 8A07                     mov al, [bx]
  4091 000032CD B400                     mov ah, 0
  4092 000032CF 8846FE                   mov byte [bp-2], al
  4093                                  
  4094                                  ;-57                 if (c=='n') c=10; 
  4095                                  
  4096 000032D2 8A46FE                   mov al, [bp-2]
  4097 000032D5 3C6E                     cmp al, 110
  4098 000032D7 0F850900                 jne @@prs189
  4099 000032DB 66B80A000000             mov eax, 10
  4100 000032E1 8846FE                   mov byte [bp-2], al
  4101                                  
  4102                                  ;-58                 if (c=='t') c= 9; 
  4103                                  
  4104                                  @@prs189:
  4105 000032E4 8A46FE                   mov al, [bp-2]
  4106 000032E7 3C74                     cmp al, 116
  4107 000032E9 0F850900                 jne @@prs190
  4108 000032ED 66B809000000             mov eax, 9
  4109 000032F3 8846FE                   mov byte [bp-2], al
  4110                                  
  4111                                  ;-59             } 
  4112                                  
  4113                                  @@prs190:
  4114                                  
  4115                                  ;-60         } 
  4116                                  
  4117                                  @@prs188:
  4118                                  
  4119                                  ;-61         prc(c); 
  4120                                  
  4121                                  @@prs187:
  4122 000032F6 8A46FE                   mov al, byte [bp-2]
  4123 000032F9 B400                     mov ah, 0
  4124 000032FB 50                       push ax
  4125 000032FC E807FF                   call prc
  4126 000032FF 83C402                   add  sp, 2
  4127                                  
  4128                                  ;-62         s++;  
  4129                                  
  4130 00003302 FF4604                   inc  word [bp+4]
  4131                                  
  4132                                  ;-63     }
  4133                                  
  4134                                  
  4135                                  ;-64 }
  4136                                  
  4137 00003305 E96CFF                   jmp @@prs182
  4138                                  @@prs183:
  4139                                  
  4140                                  ;-65 int printhex8a(unsigned char c) { 
  4141 00003308 C9                       LEAVE
  4142 00003309 C3                       ret
  4143                                  ; ENDP
  4144                                  
  4145                                  printhex8a:  ; *** PROC ***
  4146                                  
  4147                                  ;-66     unsigned char nib;
  4148                                  
  4149                                  
  4150                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4151                                  
  4152                                  ;Function : printhex8a, Number of local variables: 2
  4153                                  ;   # type sign width line used address name   list of local variables
  4154                                  ;  200 var unsg byte    65 NULL bp+4    c
  4155                                  ;  201 var unsg byte    66 NULL bp-2    nib;
  4156 0000330A C8020000                 ENTER  2,0
  4157 0000330E 8A4604                   mov al, [bp+4]
  4158 00003311 C0E804                   shr al, 4
  4159 00003314 8846FE                   mov byte [bp-2], al
  4160 00003317 8A46FE                   mov al, byte [bp-2]
  4161 0000331A B400                     mov ah, 0
  4162 0000331C 50                       push ax
  4163 0000331D E81900                   call printhex4
  4164 00003320 83C402                   add  sp, 2
  4165                                  
  4166                                  ;-68     nib = c & 15; printhex4(nib);                    
  4167                                  
  4168 00003323 8A4604                   mov al, [bp+4]
  4169 00003326 240F                     and al, 15
  4170 00003328 8846FE                   mov byte [bp-2], al
  4171 0000332B 8A46FE                   mov al, byte [bp-2]
  4172 0000332E B400                     mov ah, 0
  4173 00003330 50                       push ax
  4174 00003331 E80500                   call printhex4
  4175 00003334 83C402                   add  sp, 2
  4176                                  
  4177                                  ;-69 } 
  4178                                  
  4179                                  
  4180                                  ;-70 int printhex4(unsigned char c) {
  4181 00003337 C9                       LEAVE
  4182 00003338 C3                       ret
  4183                                  ; ENDP
  4184                                  
  4185                                  printhex4:  ; *** PROC ***
  4186                                  
  4187                                  ;-71     c += 48; 
  4188                                  
  4189                                  ;Function : printhex4, Number of local variables: 1
  4190                                  ;   # type sign width line used address name   list of local variables
  4191                                  ;  200 var unsg byte    70 NULL bp+4    c;
  4192 00003339 C8000000                 ENTER  0,0
  4193 0000333D 80460430                 add  byte [bp+4], 48
  4194                                  
  4195                                  ;-72     if (c > 57) c += 7; 
  4196                                  
  4197 00003341 8A4604                   mov al, [bp+4]
  4198 00003344 3C39                     cmp al, 57
  4199 00003346 0F8E0400                 jle @@printhex4191
  4200 0000334A 80460407                 add  byte [bp+4], 7
  4201                                  
  4202                                  ;-73     prc(c);      
  4203                                  
  4204                                  @@printhex4191:
  4205 0000334E 8A4604                   mov al, byte [bp+4]
  4206 00003351 B400                     mov ah, 0
  4207 00003353 50                       push ax
  4208 00003354 E8AFFE                   call prc
  4209 00003357 83C402                   add  sp, 2
  4210                                  
  4211                                  ;-74 }
  4212                                  
  4213                                  
  4214                                  ;-75 int printhex16(unsigned int i) {
  4215 0000335A C9                       LEAVE
  4216 0000335B C3                       ret
  4217                                  ; ENDP
  4218                                  
  4219                                  printhex16:  ; *** PROC ***
  4220                                  
  4221                                  ;-76     unsigned int half;
  4222                                  
  4223                                  
  4224                                  ;-77     half = i >>  8; printhex8a(half); 
  4225                                  
  4226                                  ;Function : printhex16, Number of local variables: 2
  4227                                  ;   # type sign width line used address name   list of local variables
  4228                                  ;  200 var unsg word    75 NULL bp+4    i
  4229                                  ;  201 var unsg word    76 NULL bp-2    half;
  4230 0000335C C8020000                 ENTER  2,0
  4231 00003360 8B4604                   mov ax, [bp+4]
  4232 00003363 C1E808                   shr ax, 8
  4233 00003366 8946FE                   mov word [bp-2], ax
  4234 00003369 FF76FE                   push word [bp-2]
  4235 0000336C E89BFF                   call printhex8a
  4236 0000336F 83C402                   add  sp, 2
  4237                                  
  4238                                  ;-78     half = i & 255; printhex8a(half);
  4239                                  
  4240 00003372 8B4604                   mov ax, [bp+4]
  4241 00003375 25FF00                   and ax, 255
  4242 00003378 8946FE                   mov word [bp-2], ax
  4243 0000337B FF76FE                   push word [bp-2]
  4244 0000337E E889FF                   call printhex8a
  4245 00003381 83C402                   add  sp, 2
  4246                                  
  4247                                  ;-79 }
  4248                                  
  4249                                  
  4250                                  ;-80 int printIntU(unsigned int n) { 
  4251 00003384 C9                       LEAVE
  4252 00003385 C3                       ret
  4253                                  ; ENDP
  4254                                  
  4255                                  printIntU:  ; *** PROC ***
  4256                                  
  4257                                  ;-81     unsigned int e;
  4258                                  
  4259                                  
  4260                                  ;-82     if ( _ n >= 10) {  
  4261                                  
  4262                                  ;Function : printIntU, Number of local variables: 2
  4263                                  ;   # type sign width line used address name   list of local variables
  4264                                  ;  200 var unsg word    80 NULL bp+4    n
  4265                                  ;  201 var unsg word    81 NULL bp-2    e;
  4266 00003386 C8020000                 ENTER  2,0
  4267 0000338A 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4268 0000338E 0F821700                 jb  @@printIntU192
  4269                                  
  4270                                  ;-83         e=n/10; //DIV
  4271                                  
  4272 00003392 8B4604                   mov ax, [bp+4]
  4273 00003395 BB0A00                   mov bx, 10
  4274 00003398 BA0000                   mov dx, 0
  4275 0000339B F7F3                     div bx
  4276 0000339D 8946FE                   mov word [bp-2], ax
  4277                                  
  4278                                  ;-84         printIntU(e); 
  4279                                  
  4280 000033A0 FF76FE                   push word [bp-2]
  4281 000033A3 E8E0FF                   call printIntU
  4282 000033A6 83C402                   add  sp, 2
  4283                                  
  4284                                  ;-85     }
  4285                                  
  4286                                  
  4287                                  ;-86     n = n % 10; //unsigned mod
  4288                                  
  4289                                  @@printIntU192:
  4290 000033A9 8B4604                   mov ax, [bp+4]
  4291 000033AC BB0A00                   mov bx, 10
  4292 000033AF BA0000                   mov dx, 0
  4293 000033B2 F7F3                     div bx
  4294 000033B4 89D0                     mov ax, dx
  4295 000033B6 894604                   mov word [bp+4], ax
  4296                                  
  4297                                  ;-87     n += '0'; 
  4298                                  
  4299 000033B9 83460430                 add  word [bp+4], 48
  4300                                  
  4301                                  ;-88     prc(n);
  4302                                  
  4303 000033BD FF7604                   push word [bp+4]
  4304 000033C0 E843FE                   call prc
  4305 000033C3 83C402                   add  sp, 2
  4306                                  
  4307                                  ;-89 }
  4308                                  
  4309                                  
  4310                                  ;-90 
  4311                                  
  4312                                  
  4313                                  ;-91 int error1(char *s) { 
  4314 000033C6 C9                       LEAVE
  4315 000033C7 C3                       ret
  4316                                  ; ENDP
  4317                                  
  4318                                  error1:  ; *** PROC ***
  4319                                  
  4320                                  ;-92     LIST=1; 
  4321                                  
  4322                                  ;Function : error1, Number of local variables: 1
  4323                                  ;   # type sign width line used address name   list of local variables
  4324                                  ;  200 ptr sign byte    91 NULL bp+4    s;
  4325 000033C8 C8000000                 ENTER  0,0
  4326 000033CC 66B801000000             mov eax, 1
  4327 000033D2 A2[0E00]                 mov byte [LIST], al
  4328                                  
  4329                                  ;-93     ErrorCount++;
  4330                                  
  4331 000033D5 FF06[A101]               inc  word [ErrorCount]
  4332                                  
  4333                                  ;-94     prs("\n;***** next line ERROR: "); 
  4334                                  
  4335 000033D9 68[0134]                 push error1_0
  4336 000033DC E888FE                   call prs
  4337 000033DF 83C402                   add  sp, 2
  4338                                  
  4339                                  ;-95     prs(s);
  4340                                  
  4341 000033E2 FF7604                   push word [bp+4]
  4342 000033E5 E87FFE                   call prs
  4343 000033E8 83C402                   add  sp, 2
  4344                                  
  4345                                  ;-96     prs(", Symbol: "); 
  4346                                  
  4347 000033EB 68[1C34]                 push error1_1
  4348 000033EE E876FE                   call prs
  4349 000033F1 83C402                   add  sp, 2
  4350                                  
  4351                                  ;-97     prs(Symbol);
  4352                                  
  4353 000033F4 8D06[0F00]               lea  ax, [Symbol]
  4354 000033F8 50                       push ax
  4355 000033F9 E86BFE                   call prs
  4356 000033FC 83C402                   add  sp, 2
  4357                                  
  4358                                  ;-98 }
  4359                                  
  4360                                  
  4361                                  ;-99 int errorexit(char *s) { 
  4362 000033FF C9                       LEAVE
  4363 00003400 C3                       ret
  4364                                  ; ENDP
  4365 00003401 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4366 0000340A 6E657874206C696E65-
  4367 00003413 204552524F523A2000 
  4368 0000341C 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4369 00003425 2000               
  4370                                  
  4371                                  errorexit:  ; *** PROC ***
  4372                                  
  4373                                  ;-100     error1(s); 
  4374                                  
  4375                                  ;Function : errorexit, Number of local variables: 1
  4376                                  ;   # type sign width line used address name   list of local variables
  4377                                  ;  200 ptr sign byte    99 NULL bp+4    s;
  4378 00003427 C8000000                 ENTER  0,0
  4379 0000342B FF7604                   push word [bp+4]
  4380 0000342E E897FF                   call error1
  4381 00003431 83C402                   add  sp, 2
  4382                                  
  4383                                  ;-101     end1(1);
  4384                                  
  4385 00003434 6A01                     push 1
  4386 00003436 E8C904                   call end1
  4387 00003439 83C402                   add  sp, 2
  4388                                  
  4389                                  ;-102 }
  4390                                  
  4391                                  
  4392                                  ;-103 int allowederror() {error1("not allowed here"); }
  4393 0000343C C9                       LEAVE
  4394 0000343D C3                       ret
  4395                                  ; ENDP
  4396                                  
  4397                                  allowederror:  ; *** PROC ***
  4398 0000343E 68[4834]                 push allowederror_0
  4399 00003441 E884FF                   call error1
  4400 00003444 83C402                   add  sp, 2
  4401                                  
  4402                                  ;-104 int addrerror()    {error1("address missing");} 
  4403                                  
  4404 00003447 C3                       ret
  4405                                  ; ENDP
  4406 00003448 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4407 00003451 6564206865726500   
  4408                                  
  4409                                  addrerror:  ; *** PROC ***
  4410 00003459 68[6334]                 push addrerror_0
  4411 0000345C E869FF                   call error1
  4412 0000345F 83C402                   add  sp, 2
  4413                                  
  4414                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4415                                  
  4416 00003462 C3                       ret
  4417                                  ; ENDP
  4418 00003463 61646472657373206D-     addrerror_0 db "address missing",0
  4419 0000346C 697373696E6700     
  4420                                  
  4421                                  immeerror:  ; *** PROC ***
  4422 00003473 68[7D34]                 push immeerror_0
  4423 00003476 E84FFF                   call error1
  4424 00003479 83C402                   add  sp, 2
  4425                                  
  4426                                  ;-106 int implerror()    {error1("not implemented");}
  4427                                  
  4428 0000347C C3                       ret
  4429                                  ; ENDP
  4430 0000347D 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4431 00003486 206E6F7420616C6C6F-
  4432 0000348F 776564206865726500 
  4433                                  
  4434                                  implerror:  ; *** PROC ***
  4435 00003498 68[A234]                 push implerror_0
  4436 0000349B E82AFF                   call error1
  4437 0000349E 83C402                   add  sp, 2
  4438                                  
  4439                                  ;-107 int indexerror()   {error1("invalid index register");}
  4440                                  
  4441 000034A1 C3                       ret
  4442                                  ; ENDP
  4443 000034A2 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4444 000034AB 6D656E74656400     
  4445                                  
  4446                                  indexerror:  ; *** PROC ***
  4447 000034B2 68[BC34]                 push indexerror_0
  4448 000034B5 E810FF                   call error1
  4449 000034B8 83C402                   add  sp, 2
  4450                                  
  4451                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4452                                  
  4453 000034BB C3                       ret
  4454                                  ; ENDP
  4455 000034BC 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4456 000034C5 6E6465782072656769-
  4457 000034CE 7374657200         
  4458                                  
  4459                                  invaloperror:  ; *** PROC ***
  4460 000034D3 68[DD34]                 push invaloperror_0
  4461 000034D6 E8EFFE                   call error1
  4462 000034D9 83C402                   add  sp, 2
  4463                                  
  4464                                  ;-109 int numbererror()  {error1("number expected");}
  4465                                  
  4466 000034DC C3                       ret
  4467                                  ; ENDP
  4468 000034DD 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4469 000034E6 72206E6F206F706572-
  4470 000034EF 616E647300         
  4471                                  
  4472                                  numbererror:  ; *** PROC ***
  4473 000034F4 68[FE34]                 push numbererror_0
  4474 000034F7 E8CEFE                   call error1
  4475 000034FA 83C402                   add  sp, 2
  4476                                  
  4477                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4478                                  
  4479 000034FD C3                       ret
  4480                                  ; ENDP
  4481 000034FE 6E756D626572206578-     numbererror_0 db "number expected",0
  4482 00003507 70656374656400     
  4483                                  
  4484                                  regmemerror:  ; *** PROC ***
  4485 0000350E 68[1835]                 push regmemerror_0
  4486 00003511 E8B4FE                   call error1
  4487 00003514 83C402                   add  sp, 2
  4488                                  
  4489                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4490                                  
  4491 00003517 C3                       ret
  4492                                  ; ENDP
  4493 00003518 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4494 00003521 73746572206F72206D-
  4495 0000352A 656D6F727920616C6C-
  4496 00003533 6F77656400         
  4497                                  
  4498                                  reg16error:  ; *** PROC ***
  4499 00003538 68[4235]                 push reg16error_0
  4500 0000353B E88AFE                   call error1
  4501 0000353E 83C402                   add  sp, 2
  4502                                  
  4503                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4504                                  
  4505 00003541 C3                       ret
  4506                                  ; ENDP
  4507 00003542 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4508 0000354B 362C206E6F20736567-
  4509 00003554 72656720616C6C6F77-
  4510 0000355D 656400             
  4511                                  
  4512                                  segregerror:  ; *** PROC ***
  4513 00003560 68[6A35]                 push segregerror_0
  4514 00003563 E862FE                   call error1
  4515 00003566 83C402                   add  sp, 2
  4516                                  
  4517                                  ;-113 int syntaxerror()  {error1("syntax");}
  4518                                  
  4519 00003569 C3                       ret
  4520                                  ; ENDP
  4521 0000356A 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4522 00003573 65676973746572206E-
  4523 0000357C 6F7420616C6C6F7765-
  4524 00003585 6400               
  4525                                  
  4526                                  syntaxerror:  ; *** PROC ***
  4527 00003587 68[9135]                 push syntaxerror_0
  4528 0000358A E83BFE                   call error1
  4529 0000358D 83C402                   add  sp, 2
  4530                                  
  4531                                  ;-114          
  4532                                  
  4533                                  
  4534                                  ;-115 int addrexit()     {errorexit("illegal address");}
  4535                                  
  4536 00003590 C3                       ret
  4537                                  ; ENDP
  4538 00003591 73796E74617800          syntaxerror_0 db "syntax",0
  4539                                  
  4540                                  addrexit:  ; *** PROC ***
  4541 00003598 68[A235]                 push addrexit_0
  4542 0000359B E889FE                   call errorexit
  4543 0000359E 83C402                   add  sp, 2
  4544                                  
  4545                                  ;-116 int internexit()   {errorexit("intern compiler error");}
  4546                                  
  4547 000035A1 C3                       ret
  4548                                  ; ENDP
  4549 000035A2 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4550 000035AB 64647265737300     
  4551                                  
  4552                                  internexit:  ; *** PROC ***
  4553 000035B2 68[BC35]                 push internexit_0
  4554 000035B5 E86FFE                   call errorexit
  4555 000035B8 83C402                   add  sp, 2
  4556 000035BB C3                       ret
  4557                                  ; ENDP
  4558 000035BC 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4559 000035C5 6D70696C6572206572-
  4560 000035CE 726F7200           
  4561                                  ;Back to main program: AS.C
  4562                                  
  4563                                  ;-8 #include "MAIN.C"
  4564                                  
  4565                                  ;Use include file: MAIN.C
  4566                                  
  4567                                  ;-1 int main() {
  4568                                  
  4569                                  
  4570                                  main:  ; *** PROC ***
  4571                                  
  4572                                  ;-2     getarg(); 
  4573                                  
  4574 000035D2 E80A00                   call getarg
  4575                                  
  4576                                  ;-3     parse(); 
  4577                                  
  4578 000035D5 E8D8EE                   call parse
  4579                                  
  4580                                  ;-4     epilog(); 
  4581                                  
  4582 000035D8 E85C02                   call epilog
  4583                                  
  4584                                  ;-5     end1();
  4585                                  
  4586 000035DB E82403                   call end1
  4587                                  
  4588                                  ;-6 }
  4589                                  
  4590                                  
  4591                                  ;-7 
  4592                                  
  4593                                  
  4594                                  ;-8 int getarg() { 
  4595                                  
  4596 000035DE C3                       ret
  4597                                  ; ENDP
  4598                                  
  4599                                  getarg:  ; *** PROC ***
  4600                                  
  4601                                  ;-9     int arglen1; int i; char *c;
  4602                                  
  4603                                  
  4604                                  ;-10     arglen1=*arglen;
  4605                                  
  4606                                  ;Function : getarg, Number of local variables: 3
  4607                                  ;   # type sign width line used address name   list of local variables
  4608                                  ;  200 var sign word     9 NULL bp-2    arglen1
  4609                                  ;  201 var sign word     9 NULL bp-4    i
  4610                                  ;  202 ptr sign byte     9 NULL bp-6    c;
  4611 000035DF C8060000                 ENTER  6,0
  4612 000035E3 8B1E[011C]               mov bx, [arglen]
  4613 000035E7 8A07                     mov al, [bx]
  4614 000035E9 B400                     mov ah, 0
  4615 000035EB 8946FE                   mov word [bp-2], ax
  4616                                  
  4617                                  ;-11     if (arglen1==0) {
  4618                                  
  4619 000035EE 8B46FE                   mov ax, [bp-2]
  4620 000035F1 83F800                   cmp ax, 0
  4621 000035F4 0F851C00                 jne @@getarg193
  4622                                  
  4623                                  ;-12         cputs(Version1);
  4624                                  
  4625 000035F8 8D06[0300]               lea  ax, [Version1]
  4626 000035FC 50                       push ax
  4627 000035FD E8E90B                   call cputs
  4628 00003600 83C402                   add  sp, 2
  4629                                  
  4630                                  ;-13         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4631                                  
  4632 00003603 68[A437]                 push getarg_0
  4633 00003606 E8E00B                   call cputs
  4634 00003609 83C402                   add  sp, 2
  4635                                  
  4636                                  ;-14         exitR(3);
  4637                                  
  4638 0000360C 6A03                     push 3
  4639 0000360E E8B30D                   call exitR
  4640 00003611 83C402                   add  sp, 2
  4641                                  
  4642                                  ;-15     }
  4643                                  
  4644                                  
  4645                                  ;-16     i=arglen1+129; 
  4646                                  
  4647                                  @@getarg193:
  4648 00003614 8B46FE                   mov ax, [bp-2]
  4649 00003617 058100                   add ax, 129
  4650 0000361A 8946FC                   mov word [bp-4], ax
  4651                                  
  4652                                  ;-17     *i=0;  
  4653                                  
  4654 0000361D 66B800000000             mov eax, 0
  4655 00003623 8B5EFC                   mov  bx, [bp-4]
  4656 00003626 8907                     mov  [bx], ax
  4657                                  
  4658                                  ;-18     arglen1--;
  4659                                  
  4660 00003628 FF4EFE                   dec  word [bp-2]
  4661                                  
  4662                                  ;-19     toupper(argv);
  4663                                  
  4664 0000362B FF36[031C]               push word [argv]
  4665 0000362F E8E50B                   call toupper
  4666 00003632 83C402                   add  sp, 2
  4667                                  
  4668                                  ;-20   
  4669                                  
  4670                                  
  4671                                  ;-21     strcpy(namein, argv); strcat1(namein, ".S");
  4672                                  
  4673 00003635 FF36[031C]               push word [argv]
  4674 00003639 8D06[D000]               lea  ax, [namein]
  4675 0000363D 50                       push ax
  4676 0000363E E8440C                   call strcpy
  4677 00003641 83C404                   add  sp, 4
  4678 00003644 68[C937]                 push getarg_1
  4679 00003647 8D06[D000]               lea  ax, [namein]
  4680 0000364B 50                       push ax
  4681 0000364C E8F70C                   call strcat1
  4682 0000364F 83C404                   add  sp, 4
  4683                                  
  4684                                  ;-22     strcpy(namelst,argv); strcat1(namelst,".LST");
  4685                                  
  4686 00003652 FF36[031C]               push word [argv]
  4687 00003656 8D06[1301]               lea  ax, [namelst]
  4688 0000365A 50                       push ax
  4689 0000365B E8270C                   call strcpy
  4690 0000365E 83C404                   add  sp, 4
  4691 00003661 68[CC37]                 push getarg_2
  4692 00003664 8D06[1301]               lea  ax, [namelst]
  4693 00003668 50                       push ax
  4694 00003669 E8DA0C                   call strcat1
  4695 0000366C 83C404                   add  sp, 4
  4696                                  
  4697                                  ;-23     strcpy(namebin,argv); strcat1(namebin,".COM");
  4698                                  
  4699 0000366F FF36[031C]               push word [argv]
  4700 00003673 8D06[5601]               lea  ax, [namebin]
  4701 00003677 50                       push ax
  4702 00003678 E80A0C                   call strcpy
  4703 0000367B 83C404                   add  sp, 4
  4704 0000367E 68[D137]                 push getarg_3
  4705 00003681 8D06[5601]               lea  ax, [namebin]
  4706 00003685 50                       push ax
  4707 00003686 E8BD0C                   call strcat1
  4708 00003689 83C404                   add  sp, 4
  4709                                  
  4710                                  ;-24 
  4711                                  
  4712                                  
  4713                                  ;-25     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4714                                  
  4715 0000368C 66B801000000             mov eax, 1
  4716 00003692 A2[0E00]                 mov byte [LIST], al
  4717 00003695 66B800000000             mov eax, 0
  4718 0000369B A3[9F01]                 mov word [DOS_ERR], ax
  4719 0000369E 66B800000000             mov eax, 0
  4720 000036A4 A3[A601]                 mov word [PC], ax
  4721 000036A7 66B800000000             mov eax, 0
  4722 000036AD A3[A101]                 mov word [ErrorCount], ax
  4723                                  
  4724                                  ;-26   
  4725                                  
  4726                                  
  4727                                  ;-27     asm_fd=openR (namein);
  4728                                  
  4729 000036B0 8D06[D000]               lea  ax, [namein]
  4730 000036B4 50                       push ax
  4731 000036B5 E8B30C                   call openR
  4732 000036B8 83C402                   add  sp, 2
  4733 000036BB A3[9901]                 mov word [asm_fd], ax
  4734                                  
  4735                                  ;-28     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4736                                  
  4737 000036BE A1[9F01]                 mov ax, [DOS_ERR]
  4738 000036C1 08C0                     or  al, al
  4739 000036C3 0F841C00                 je @@getarg194
  4740 000036C7 68[D637]                 push getarg_4
  4741 000036CA E81C0B                   call cputs
  4742 000036CD 83C402                   add  sp, 2
  4743 000036D0 8D06[D000]               lea  ax, [namein]
  4744 000036D4 50                       push ax
  4745 000036D5 E8110B                   call cputs
  4746 000036D8 83C402                   add  sp, 2
  4747 000036DB 6A01                     push 1
  4748 000036DD E8E40C                   call exitR
  4749 000036E0 83C402                   add  sp, 2
  4750                                  
  4751                                  ;-29     lst_fd=creatR(namelst);
  4752                                  
  4753                                  @@getarg194:
  4754 000036E3 8D06[1301]               lea  ax, [namelst]
  4755 000036E7 50                       push ax
  4756 000036E8 E88F0C                   call creatR
  4757 000036EB 83C402                   add  sp, 2
  4758 000036EE A3[9B01]                 mov word [lst_fd], ax
  4759                                  
  4760                                  ;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4761                                  
  4762 000036F1 A1[9F01]                 mov ax, [DOS_ERR]
  4763 000036F4 08C0                     or  al, al
  4764 000036F6 0F841C00                 je @@getarg195
  4765 000036FA 68[EC37]                 push getarg_5
  4766 000036FD E8E90A                   call cputs
  4767 00003700 83C402                   add  sp, 2
  4768 00003703 8D06[1301]               lea  ax, [namelst]
  4769 00003707 50                       push ax
  4770 00003708 E8DE0A                   call cputs
  4771 0000370B 83C402                   add  sp, 2
  4772 0000370E 6A02                     push 2
  4773 00003710 E8B10C                   call exitR
  4774 00003713 83C402                   add  sp, 2
  4775                                  
  4776                                  ;-31     bin_fd=creatR(namebin);
  4777                                  
  4778                                  @@getarg195:
  4779 00003716 8D06[5601]               lea  ax, [namebin]
  4780 0000371A 50                       push ax
  4781 0000371B E85C0C                   call creatR
  4782 0000371E 83C402                   add  sp, 2
  4783 00003721 A3[9D01]                 mov word [bin_fd], ax
  4784                                  
  4785                                  ;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4786                                  
  4787 00003724 A1[9F01]                 mov ax, [DOS_ERR]
  4788 00003727 08C0                     or  al, al
  4789 00003729 0F841C00                 je @@getarg196
  4790 0000372D 68[0338]                 push getarg_6
  4791 00003730 E8B60A                   call cputs
  4792 00003733 83C402                   add  sp, 2
  4793 00003736 8D06[5601]               lea  ax, [namebin]
  4794 0000373A 50                       push ax
  4795 0000373B E8AB0A                   call cputs
  4796 0000373E 83C402                   add  sp, 2
  4797 00003741 6A02                     push 2
  4798 00003743 E87E0C                   call exitR
  4799 00003746 83C402                   add  sp, 2
  4800                                  
  4801                                  ;-33   
  4802                                  
  4803                                  
  4804                                  ;-34     prs(";"); 
  4805                                  
  4806                                  @@getarg196:
  4807 00003749 68[1938]                 push getarg_7
  4808 0000374C E818FB                   call prs
  4809 0000374F 83C402                   add  sp, 2
  4810                                  
  4811                                  ;-35     prs(Version1);
  4812                                  
  4813 00003752 8D06[0300]               lea  ax, [Version1]
  4814 00003756 50                       push ax
  4815 00003757 E80DFB                   call prs
  4816 0000375A 83C402                   add  sp, 2
  4817                                  
  4818                                  ;-36     prs(", Source: "); prs(namein);  
  4819                                  
  4820 0000375D 68[1B38]                 push getarg_8
  4821 00003760 E804FB                   call prs
  4822 00003763 83C402                   add  sp, 2
  4823 00003766 8D06[D000]               lea  ax, [namein]
  4824 0000376A 50                       push ax
  4825 0000376B E8F9FA                   call prs
  4826 0000376E 83C402                   add  sp, 2
  4827                                  
  4828                                  ;-37     prs(", Output: "); prs(namelst);
  4829                                  
  4830 00003771 68[2638]                 push getarg_9
  4831 00003774 E8F0FA                   call prs
  4832 00003777 83C402                   add  sp, 2
  4833 0000377A 8D06[1301]               lea  ax, [namelst]
  4834 0000377E 50                       push ax
  4835 0000377F E8E5FA                   call prs
  4836 00003782 83C402                   add  sp, 2
  4837                                  
  4838                                  ;-38     prs(", "); prs(namebin);
  4839                                  
  4840 00003785 68[3138]                 push getarg_10
  4841 00003788 E8DCFA                   call prs
  4842 0000378B 83C402                   add  sp, 2
  4843 0000378E 8D06[5601]               lea  ax, [namebin]
  4844 00003792 50                       push ax
  4845 00003793 E8D1FA                   call prs
  4846 00003796 83C402                   add  sp, 2
  4847                                  
  4848                                  ;-39     prs("\n");
  4849                                  
  4850 00003799 68[3438]                 push getarg_11
  4851 0000379C E8C8FA                   call prs
  4852 0000379F 83C402                   add  sp, 2
  4853                                  
  4854                                  ;-40 }
  4855                                  
  4856                                  
  4857                                  ;-41 
  4858                                  
  4859                                  
  4860                                  ;-42 int epilog() { 
  4861 000037A2 C9                       LEAVE
  4862 000037A3 C3                       ret
  4863                                  ; ENDP
  4864 000037A4 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4865 000037AD 41532E434F4D206669-
  4866 000037B6 6C656E616D65205B77-
  4867 000037BF 2F6F202E535D203A20-
  4868 000037C8 00                 
  4869 000037C9 2E5300                  getarg_1 db ".S",0
  4870 000037CC 2E4C535400              getarg_2 db ".LST",0
  4871 000037D1 2E434F4D00              getarg_3 db ".COM",0
  4872 000037D6 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4873 000037DF 6C65206D697373696E-
  4874 000037E8 673A2000           
  4875 000037EC 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4876 000037F5 206E6F742063726561-
  4877 000037FE 74653A2000         
  4878 00003803 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4879 0000380C 6E6F74206372656174-
  4880 00003815 653A2000           
  4881 00003819 3B00                    getarg_7 db ";",0
  4882 0000381B 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4883 00003824 2000               
  4884 00003826 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4885 0000382F 2000               
  4886 00003831 2C2000                  getarg_10 db ", ",0
  4887 00003834 5C6E00                  getarg_11 db "\n",0
  4888                                  
  4889                                  epilog:  ; *** PROC ***
  4890                                  
  4891                                  ;-43     int i; int j; char c;
  4892                                  
  4893                                  
  4894                                  ;-44     prs("\n;END Errors: "); 
  4895                                  
  4896                                  ;Function : epilog, Number of local variables: 3
  4897                                  ;   # type sign width line used address name   list of local variables
  4898                                  ;  200 var sign word    43 NULL bp-2    i
  4899                                  ;  201 var sign word    43 NULL bp-4    j
  4900                                  ;  202 var sign byte    43 NULL bp-6    c;
  4901 00003837 C8060000                 ENTER  6,0
  4902 0000383B 68[C538]                 push epilog_0
  4903 0000383E E826FA                   call prs
  4904 00003841 83C402                   add  sp, 2
  4905                                  
  4906                                  ;-45     printIntU(ErrorCount);
  4907                                  
  4908 00003844 FF36[A101]               push word [ErrorCount]
  4909 00003848 E83BFB                   call printIntU
  4910 0000384B 83C402                   add  sp, 2
  4911                                  
  4912                                  ;-46     if (ErrorCount) prs(" ***ERROR*** ");
  4913                                  
  4914 0000384E A1[A101]                 mov ax, [ErrorCount]
  4915 00003851 08C0                     or  al, al
  4916 00003853 0F840900                 je @@epilog197
  4917 00003857 68[D538]                 push epilog_1
  4918 0000385A E80AFA                   call prs
  4919 0000385D 83C402                   add  sp, 2
  4920                                  
  4921                                  ;-47     prs(", Output: "); prs(namelst);
  4922                                  
  4923                                  @@epilog197:
  4924 00003860 68[E338]                 push epilog_2
  4925 00003863 E801FA                   call prs
  4926 00003866 83C402                   add  sp, 2
  4927 00003869 8D06[1301]               lea  ax, [namelst]
  4928 0000386D 50                       push ax
  4929 0000386E E8F6F9                   call prs
  4930 00003871 83C402                   add  sp, 2
  4931                                  
  4932                                  ;-48     prs(", COM file "); 
  4933                                  
  4934 00003874 68[EE38]                 push epilog_3
  4935 00003877 E8EDF9                   call prs
  4936 0000387A 83C402                   add  sp, 2
  4937                                  
  4938                                  ;-49     printIntU(BinLen); 
  4939                                  
  4940 0000387D FF36[FF1B]               push word [BinLen]
  4941 00003881 E802FB                   call printIntU
  4942 00003884 83C402                   add  sp, 2
  4943                                  
  4944                                  ;-50     prs(" bytes.");
  4945                                  
  4946 00003887 68[FA38]                 push epilog_4
  4947 0000388A E8DAF9                   call prs
  4948 0000388D 83C402                   add  sp, 2
  4949                                  
  4950                                  ;-51 
  4951                                  
  4952                                  
  4953                                  ;-52     i=0;
  4954                                  
  4955 00003890 66B800000000             mov eax, 0
  4956 00003896 8946FE                   mov word [bp-2], ax
  4957                                  
  4958                                  ;-53     do {
  4959                                  
  4960                                  @@epilog198:
  4961                                  
  4962                                  ;-54         c = FileBin[i];
  4963                                  
  4964 00003899 8B5EFE                   mov bx, [bp-2]
  4965 0000389C 8A87[2F14]               mov al, [FileBin + bx]
  4966 000038A0 8846FA                   mov byte [bp-6], al
  4967                                  
  4968                                  ;-55         fputcR(c, bin_fd);
  4969                                  
  4970 000038A3 FF36[9D01]               push word [bin_fd]
  4971 000038A7 8A46FA                   mov al, byte [bp-6]
  4972 000038AA B400                     mov ah, 0
  4973 000038AC 50                       push ax
  4974 000038AD E8F10A                   call fputcR
  4975 000038B0 83C404                   add  sp, 4
  4976                                  
  4977                                  ;-56         i++;
  4978                                  
  4979 000038B3 FF46FE                   inc  word [bp-2]
  4980                                  
  4981                                  ;-57     } while (i < BinLen);
  4982                                  
  4983 000038B6 8B46FE                   mov ax, [bp-2]
  4984 000038B9 3B06[FF1B]               cmp ax, [BinLen]
  4985 000038BD 0F8D0200                 jge @@epilog199
  4986 000038C1 EBD6                     jmp @@epilog198
  4987                                  @@epilog199:
  4988                                  
  4989                                  ;-58 }
  4990                                  
  4991                                  
  4992                                  ;-59 
  4993                                  
  4994                                  
  4995                                  ;-60 int end1(int n) {
  4996 000038C3 C9                       LEAVE
  4997 000038C4 C3                       ret
  4998                                  ; ENDP
  4999 000038C5 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5000 000038CE 726F72733A2000     
  5001 000038D5 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5002 000038DE 2A2A2A2000         
  5003 000038E3 2C204F75747075743A-     epilog_2 db ", Output: ",0
  5004 000038EC 2000               
  5005 000038EE 2C20434F4D2066696C-     epilog_3 db ", COM file ",0
  5006 000038F7 652000             
  5007 000038FA 2062797465732E00        epilog_4 db " bytes.",0
  5008                                  
  5009                                  end1:  ; *** PROC ***
  5010                                  
  5011                                  ;-61   fcloseR(asm_fd);
  5012                                  
  5013                                  ;Function : end1, Number of local variables: 1
  5014                                  ;   # type sign width line used address name   list of local variables
  5015                                  ;  200 var sign word    60 NULL bp+4    n;
  5016 00003902 C8000000                 ENTER  0,0
  5017 00003906 FF36[9901]               push word [asm_fd]
  5018 0000390A E8A90A                   call fcloseR
  5019 0000390D 83C402                   add  sp, 2
  5020                                  
  5021                                  ;-62   fcloseR(lst_fd);
  5022                                  
  5023 00003910 FF36[9B01]               push word [lst_fd]
  5024 00003914 E89F0A                   call fcloseR
  5025 00003917 83C402                   add  sp, 2
  5026                                  
  5027                                  ;-63   fcloseR(bin_fd);
  5028                                  
  5029 0000391A FF36[9D01]               push word [bin_fd]
  5030 0000391E E8950A                   call fcloseR
  5031 00003921 83C402                   add  sp, 2
  5032                                  
  5033                                  ;-64   exitR(n);
  5034                                  
  5035 00003924 FF7604                   push word [bp+4]
  5036 00003927 E89A0A                   call exitR
  5037 0000392A 83C402                   add  sp, 2
  5038                                  
  5039                                  ;-65 }
  5040 0000392D C9                       LEAVE
  5041 0000392E C3                       ret
  5042                                  ; ENDP
  5043                                  ;Back to main program: AS.C
  5044                                  
  5045                                  ;-9 #include "GENCODE.C"
  5046                                  
  5047                                  ;Use include file: GENCODE.C
  5048                                  
  5049                                  ;-1 // generate code
  5050                                  
  5051                                  
  5052                                  ;-2 int getCodes() {
  5053                                  
  5054                                  
  5055                                  getCodes:  ; *** PROC ***
  5056                                  
  5057                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5058                                  
  5059 0000392F FF06[C701]               inc  word [OpCodePtr]
  5060 00003933 8B1E[C701]               mov bx, [OpCodePtr]
  5061 00003937 8A07                     mov al, [bx]
  5062 00003939 B400                     mov ah, 0
  5063 0000393B A2[AF01]                 mov byte [Code1], al
  5064                                  
  5065                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5066                                  
  5067 0000393E FF06[C701]               inc  word [OpCodePtr]
  5068 00003942 8B1E[C701]               mov bx, [OpCodePtr]
  5069 00003946 8A07                     mov al, [bx]
  5070 00003948 B400                     mov ah, 0
  5071 0000394A A2[B001]                 mov byte [Code2], al
  5072                                  
  5073                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5074                                  
  5075 0000394D FF06[C701]               inc  word [OpCodePtr]
  5076 00003951 8B1E[C701]               mov bx, [OpCodePtr]
  5077 00003955 8A07                     mov al, [bx]
  5078 00003957 B400                     mov ah, 0
  5079 00003959 A2[B101]                 mov byte [Code3], al
  5080                                  
  5081                                  ;-6 }
  5082                                  
  5083                                  
  5084                                  ;-7 int gen66h() {genCode8(0x66);
  5085                                  
  5086 0000395C C3                       ret
  5087                                  ; ENDP
  5088                                  
  5089                                  gen66h:  ; *** PROC ***
  5090 0000395D 6A66                     push 102
  5091 0000395F E83B00                   call genCode8
  5092 00003962 83C402                   add  sp, 2
  5093                                  
  5094                                  ;-8 }
  5095                                  
  5096                                  
  5097                                  ;-9 int genCode2(char c, char d) {
  5098                                  
  5099 00003965 C3                       ret
  5100                                  ; ENDP
  5101                                  
  5102                                  genCode2:  ; *** PROC ***
  5103                                  
  5104                                  ;-10     c = c + d;
  5105                                  
  5106                                  ;Function : genCode2, Number of local variables: 2
  5107                                  ;   # type sign width line used address name   list of local variables
  5108                                  ;  200 var sign byte     9 NULL bp+4    c
  5109                                  ;  201 var sign byte     9 NULL bp+6    d;
  5110 00003966 C8000000                 ENTER  0,0
  5111 0000396A 8A4604                   mov al, [bp+4]
  5112 0000396D 024606                   add al, [bp+6]
  5113 00003970 884604                   mov byte [bp+4], al
  5114                                  
  5115                                  ;-11     genCode8(c);
  5116                                  
  5117 00003973 8A4604                   mov al, byte [bp+4]
  5118 00003976 B400                     mov ah, 0
  5119 00003978 50                       push ax
  5120 00003979 E82100                   call genCode8
  5121 0000397C 83C402                   add  sp, 2
  5122                                  
  5123                                  ;-12 }                             
  5124                                  
  5125                                  
  5126                                  ;-13 int genCodeW(char c) {
  5127 0000397F C9                       LEAVE
  5128 00003980 C3                       ret
  5129                                  ; ENDP
  5130                                  
  5131                                  genCodeW:  ; *** PROC ***
  5132                                  
  5133                                  ;-14     c = c + wflag;  
  5134                                  
  5135                                  ;Function : genCodeW, Number of local variables: 1
  5136                                  ;   # type sign width line used address name   list of local variables
  5137                                  ;  200 var sign byte    13 NULL bp+4    c;
  5138 00003981 C8000000                 ENTER  0,0
  5139 00003985 8A4604                   mov al, [bp+4]
  5140 00003988 0206[B701]               add al, [wflag]
  5141 0000398C 884604                   mov byte [bp+4], al
  5142                                  
  5143                                  ;-15     genCode8(c);
  5144                                  
  5145 0000398F 8A4604                   mov al, byte [bp+4]
  5146 00003992 B400                     mov ah, 0
  5147 00003994 50                       push ax
  5148 00003995 E80500                   call genCode8
  5149 00003998 83C402                   add  sp, 2
  5150                                  
  5151                                  ;-16 }   
  5152                                  
  5153                                  
  5154                                  ;-17 int genCode8(char c) {
  5155 0000399B C9                       LEAVE
  5156 0000399C C3                       ret
  5157                                  ; ENDP
  5158                                  
  5159                                  genCode8:  ; *** PROC ***
  5160                                  
  5161                                  ;-18 //set: BinLen++, OpPrintIndex++
  5162                                  
  5163                                  
  5164                                  ;-19     FileBin[BinLen]=c;
  5165                                  
  5166                                  ;Function : genCode8, Number of local variables: 1
  5167                                  ;   # type sign width line used address name   list of local variables
  5168                                  ;  200 var sign byte    17 NULL bp+4    c;
  5169 0000399D C8000000                 ENTER  0,0
  5170 000039A1 8A4604                   mov al, [bp+4]
  5171 000039A4 8B1E[FF1B]               mov bx, [BinLen]
  5172 000039A8 8887[2F14]               mov [FileBin+bx], al
  5173                                  
  5174                                  ;-20     BinLen++;
  5175                                  
  5176 000039AC FF06[FF1B]               inc  word [BinLen]
  5177                                  
  5178                                  ;-21     PC++;
  5179                                  
  5180 000039B0 FF06[A601]               inc  word [PC]
  5181                                  
  5182                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5183                                  
  5184 000039B4 A1[FF1B]                 mov ax, [BinLen]
  5185 000039B7 3DD007                   cmp ax, 2000 ;unsigned : 0
  5186 000039BA 0F820900                 jb  @@genCode8200
  5187 000039BE 68[E239]                 push genCode8_0
  5188 000039C1 E863FA                   call errorexit
  5189 000039C4 83C402                   add  sp, 2
  5190                                  
  5191                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5192                                  
  5193                                  @@genCode8200:
  5194 000039C7 A1[C501]                 mov ax, [OpPrintIndex]
  5195 000039CA 83F805                   cmp ax, 5
  5196 000039CD 0F8D0F00                 jge @@genCode8201
  5197                                  
  5198                                  ;-24         OpPos[OpPrintIndex]=c;
  5199                                  
  5200 000039D1 8A4604                   mov al, [bp+4]
  5201 000039D4 8B1E[C501]               mov bx, [OpPrintIndex]
  5202 000039D8 8887[C001]               mov [OpPos+bx], al
  5203                                  
  5204                                  ;-25         OpPrintIndex++;
  5205                                  
  5206 000039DC FF06[C501]               inc  word [OpPrintIndex]
  5207                                  
  5208                                  ;-26     }
  5209                                  
  5210                                  
  5211                                  ;-27 }
  5212                                  
  5213                                  @@genCode8201:
  5214                                  
  5215                                  ;-28 int genCode16(unsigned int i) {
  5216 000039E0 C9                       LEAVE
  5217 000039E1 C3                       ret
  5218                                  ; ENDP
  5219 000039E2 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5220 000039EB 746F6F206C6F6E6700 
  5221                                  
  5222                                  genCode16:  ; *** PROC ***
  5223                                  
  5224                                  ;-29     genCode8(i); i=i >> 8;
  5225                                  
  5226                                  ;Function : genCode16, Number of local variables: 1
  5227                                  ;   # type sign width line used address name   list of local variables
  5228                                  ;  200 var unsg word    28 NULL bp+4    i;
  5229 000039F4 C8000000                 ENTER  0,0
  5230 000039F8 FF7604                   push word [bp+4]
  5231 000039FB E89FFF                   call genCode8
  5232 000039FE 83C402                   add  sp, 2
  5233 00003A01 8B4604                   mov ax, [bp+4]
  5234 00003A04 C1E808                   shr ax, 8
  5235 00003A07 894604                   mov word [bp+4], ax
  5236                                  
  5237                                  ;-30     genCode8(i);
  5238                                  
  5239 00003A0A FF7604                   push word [bp+4]
  5240 00003A0D E88DFF                   call genCode8
  5241 00003A10 83C402                   add  sp, 2
  5242                                  
  5243                                  ;-31 }
  5244                                  
  5245                                  
  5246                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5247 00003A13 C9                       LEAVE
  5248 00003A14 C3                       ret
  5249                                  ; ENDP
  5250                                  
  5251                                  writeEA:  ; *** PROC ***
  5252                                  
  5253                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5254                                  
  5255                                  
  5256                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5257                                  
  5258                                  
  5259                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5260                                  
  5261                                  
  5262                                  ;-36     char len;
  5263                                  
  5264                                  
  5265                                  ;-37     len=0;   
  5266                                  
  5267                                  ;Function : writeEA, Number of local variables: 2
  5268                                  ;   # type sign width line used address name   list of local variables
  5269                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5270                                  ;  201 var sign byte    36 NULL bp-2    len;
  5271 00003A15 C8020000                 ENTER  2,0
  5272 00003A19 66B800000000             mov eax, 0
  5273 00003A1F 8846FE                   mov byte [bp-2], al
  5274                                  
  5275                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5276                                  
  5277 00003A22 8A4604                   mov al, [bp+4]
  5278 00003A25 C0E003                   shl al, 3
  5279 00003A28 884604                   mov byte [bp+4], al
  5280                                  
  5281                                  ;-39     if (Op == REG) {
  5282                                  
  5283 00003A2B A0[AC01]                 mov al, [Op]
  5284 00003A2E 3C02                     cmp al, 2
  5285 00003A30 0F853A00                 jne @@writeEA202
  5286                                  
  5287                                  ;-40         xxx |= 0xC0;     
  5288                                  
  5289 00003A34 804E04C0                 or  byte [bp+4], 192
  5290                                  
  5291                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5292                                  
  5293 00003A38 A0[AD01]                 mov al, [Op2]
  5294 00003A3B 3C01                     cmp al, 1
  5295 00003A3D 0F8F0D00                 jg  @@writeEA203
  5296 00003A41 8A4604                   mov al, [bp+4]
  5297 00003A44 0206[B301]               add al, [R1No]
  5298 00003A48 884604                   mov byte [bp+4], al
  5299                                  
  5300                                  ;-42             else {
  5301                                  
  5302 00003A4B E92000                   jmp @@writeEA204
  5303                                  @@writeEA203:
  5304                                  
  5305                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5306                                  
  5307 00003A4E A0[AD01]                 mov al, [Op2]
  5308 00003A51 3C02                     cmp al, 2
  5309 00003A53 0F850D00                 jne @@writeEA205
  5310 00003A57 8A4604                   mov al, [bp+4]
  5311 00003A5A 0206[B301]               add al, [R1No]
  5312 00003A5E 884604                   mov byte [bp+4], al
  5313                                  
  5314                                  ;-44                 else            xxx = xxx + R2No;  
  5315                                  
  5316 00003A61 E90A00                   jmp @@writeEA206
  5317                                  @@writeEA205:
  5318 00003A64 8A4604                   mov al, [bp+4]
  5319 00003A67 0206[B201]               add al, [R2No]
  5320 00003A6B 884604                   mov byte [bp+4], al
  5321                                  
  5322                                  ;-45             }
  5323                                  
  5324                                  @@writeEA206:
  5325                                  
  5326                                  ;-46         } 
  5327                                  
  5328                                  @@writeEA204:
  5329                                  
  5330                                  ;-47     if (Op == MEM) {
  5331                                  
  5332                                  @@writeEA202:
  5333 00003A6E A0[AC01]                 mov al, [Op]
  5334 00003A71 3C04                     cmp al, 4
  5335 00003A73 0F857F00                 jne @@writeEA207
  5336                                  
  5337                                  ;-48         if (isDirect) {
  5338                                  
  5339 00003A77 A0[BB01]                 mov al, [isDirect]
  5340 00003A7A 08C0                     or  al, al
  5341 00003A7C 0F841000                 je @@writeEA208
  5342                                  
  5343                                  ;-49             xxx |= 6;
  5344                                  
  5345 00003A80 804E0406                 or  byte [bp+4], 6
  5346                                  
  5347                                  ;-50             len = 2;
  5348                                  
  5349 00003A84 66B802000000             mov eax, 2
  5350 00003A8A 8846FE                   mov byte [bp-2], al
  5351                                  
  5352                                  ;-51         }
  5353                                  
  5354                                  
  5355                                  ;-52         else { 
  5356                                  
  5357 00003A8D E96600                   jmp @@writeEA209
  5358                                  @@writeEA208:
  5359                                  
  5360                                  ;-53             xxx = xxx + rm;   
  5361                                  
  5362 00003A90 8A4604                   mov al, [bp+4]
  5363 00003A93 0206[BA01]               add al, [rm]
  5364 00003A97 884604                   mov byte [bp+4], al
  5365                                  
  5366                                  ;-54             if (rm == 6) {//make [BP+00]
  5367                                  
  5368 00003A9A A0[BA01]                 mov al, [rm]
  5369 00003A9D 3C06                     cmp al, 6
  5370 00003A9F 0F851700                 jne @@writeEA210
  5371                                  
  5372                                  ;-55                 len=1;
  5373                                  
  5374 00003AA3 66B801000000             mov eax, 1
  5375 00003AA9 8846FE                   mov byte [bp-2], al
  5376                                  
  5377                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5378                                  
  5379 00003AAC A1[BC01]                 mov ax, [disp]
  5380 00003AAF 83F800                   cmp ax, 0
  5381 00003AB2 0F850400                 jne @@writeEA211
  5382 00003AB6 804E0440                 or  byte [bp+4], 64
  5383                                  
  5384                                  ;-57             }
  5385                                  
  5386                                  @@writeEA211:
  5387                                  
  5388                                  ;-58 
  5389                                  
  5390                                  
  5391                                  ;-59             if (disp) {
  5392                                  
  5393                                  @@writeEA210:
  5394 00003ABA A1[BC01]                 mov ax, [disp]
  5395 00003ABD 08C0                     or  al, al
  5396 00003ABF 0F843300                 je @@writeEA212
  5397                                  
  5398                                  ;-60                 ax = disp;
  5399                                  
  5400 00003AC3 A1[BC01]                 mov  ax, [disp]
  5401                                  
  5402                                  ;-61                 if(ax > 127) len=2;
  5403                                  
  5404 00003AC6 83F87F                   cmp  ax, 127
  5405 00003AC9 0F8E0C00                 jle @@writeEA213
  5406 00003ACD 66B802000000             mov eax, 2
  5407 00003AD3 8846FE                   mov byte [bp-2], al
  5408                                  
  5409                                  ;-62                 else len=1;
  5410                                  
  5411 00003AD6 E90900                   jmp @@writeEA214
  5412                                  @@writeEA213:
  5413 00003AD9 66B801000000             mov eax, 1
  5414 00003ADF 8846FE                   mov byte [bp-2], al
  5415                                  
  5416                                  ;-63                 if (len == 1) xxx |= 0x40;
  5417                                  
  5418                                  @@writeEA214:
  5419 00003AE2 8A46FE                   mov al, [bp-2]
  5420 00003AE5 3C01                     cmp al, 1
  5421 00003AE7 0F850700                 jne @@writeEA215
  5422 00003AEB 804E0440                 or  byte [bp+4], 64
  5423                                  
  5424                                  ;-64                 else xxx |= 0x80;
  5425                                  
  5426 00003AEF E90400                   jmp @@writeEA216
  5427                                  @@writeEA215:
  5428 00003AF2 804E0480                 or  byte [bp+4], 128
  5429                                  
  5430                                  ;-65             }
  5431                                  
  5432                                  @@writeEA216:
  5433                                  
  5434                                  ;-66         }
  5435                                  
  5436                                  @@writeEA212:
  5437                                  
  5438                                  ;-67     }  
  5439                                  
  5440                                  @@writeEA209:
  5441                                  
  5442                                  ;-68     
  5443                                  
  5444                                  
  5445                                  ;-69     genCode8(xxx);// gen second byte
  5446                                  
  5447                                  @@writeEA207:
  5448 00003AF6 8A4604                   mov al, byte [bp+4]
  5449 00003AF9 B400                     mov ah, 0
  5450 00003AFB 50                       push ax
  5451 00003AFC E89EFE                   call genCode8
  5452 00003AFF 83C402                   add  sp, 2
  5453                                  
  5454                                  ;-70     if (len == 1) genCode8 (disp);
  5455                                  
  5456 00003B02 8A46FE                   mov al, [bp-2]
  5457 00003B05 3C01                     cmp al, 1
  5458 00003B07 0F850A00                 jne @@writeEA217
  5459 00003B0B FF36[BC01]               push word [disp]
  5460 00003B0F E88BFE                   call genCode8
  5461 00003B12 83C402                   add  sp, 2
  5462                                  
  5463                                  ;-71     if (len == 2) genCode16(disp);
  5464                                  
  5465                                  @@writeEA217:
  5466 00003B15 8A46FE                   mov al, [bp-2]
  5467 00003B18 3C02                     cmp al, 2
  5468 00003B1A 0F850A00                 jne @@writeEA218
  5469 00003B1E FF36[BC01]               push word [disp]
  5470 00003B22 E8CFFE                   call genCode16
  5471 00003B25 83C402                   add  sp, 2
  5472                                  
  5473                                  ;-72 }
  5474                                  
  5475                                  @@writeEA218:
  5476                                  
  5477                                  ;-73 
  5478                                  
  5479                                  
  5480                                  ;-74 int genImmediate() { 
  5481 00003B28 C9                       LEAVE
  5482 00003B29 C3                       ret
  5483                                  ; ENDP
  5484                                  
  5485                                  genImmediate:  ; *** PROC ***
  5486                                  
  5487                                  ;-75     if (wflag) genCode16(imme);
  5488                                  
  5489 00003B2A A0[B701]                 mov al, [wflag]
  5490 00003B2D 08C0                     or  al, al
  5491 00003B2F 0F840D00                 je @@genImmediate219
  5492 00003B33 FF36[BE01]               push word [imme]
  5493 00003B37 E8BAFE                   call genCode16
  5494 00003B3A 83C402                   add  sp, 2
  5495                                  
  5496                                  ;-76     else       genCode8 (imme);  
  5497                                  
  5498 00003B3D E90A00                   jmp @@genImmediate220
  5499                                  @@genImmediate219:
  5500 00003B40 FF36[BE01]               push word [imme]
  5501 00003B44 E856FE                   call genCode8
  5502 00003B47 83C402                   add  sp, 2
  5503                                  
  5504                                  ;-77 }    
  5505                                  
  5506                                  @@genImmediate220:
  5507 00003B4A C3                       ret
  5508                                  ; ENDP
  5509                                  ;Back to main program: AS.C
  5510                                  
  5511                                  ;-10 
  5512                                  
  5513                                  
  5514                                  ;-11 int process() { 
  5515                                  
  5516                                  
  5517                                  process:  ; *** PROC ***
  5518                                  
  5519                                  ;-12     char c;           
  5520                                  
  5521                                  
  5522                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  5523                                  
  5524                                  ;Function : process, Number of local variables: 1
  5525                                  ;   # type sign width line used address name   list of local variables
  5526                                  ;  200 var sign byte    12 NULL bp-2    c;
  5527 00003B4B C8020000                 ENTER  2,0
  5528 00003B4F 66B800000000             mov eax, 0
  5529 00003B55 A2[BA01]                 mov byte [rm], al
  5530 00003B58 A2[B701]                 mov byte [wflag], al
  5531 00003B5B A2[B801]                 mov byte [dflag], al
  5532 00003B5E A2[B201]                 mov byte [R2No], al
  5533 00003B61 A2[B301]                 mov byte [R1No], al
  5534 00003B64 A2[B401]                 mov byte [R2Type], al
  5535 00003B67 A2[B501]                 mov byte [R1Type], al
  5536 00003B6A A2[AD01]                 mov byte [Op2], al
  5537 00003B6D A2[AC01]                 mov byte [Op], al
  5538                                  
  5539                                  ;-14     disp=imme=0;//int
  5540                                  
  5541 00003B70 66B800000000             mov eax, 0
  5542 00003B76 A3[BE01]                 mov word [imme], ax
  5543 00003B79 A3[BC01]                 mov word [disp], ax
  5544                                  
  5545                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  5546                                  
  5547 00003B7C 66B801000000             mov eax, 1
  5548 00003B82 A2[BB01]                 mov byte [isDirect], al
  5549                                  
  5550                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  5551                                  
  5552 00003B85 E812EA                   call getTokeType
  5553                                  
  5554                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  5555                                  
  5556 00003B88 E862ED                   call getCodeSize
  5557 00003B8B A2[B601]                 mov byte [OpSize], al
  5558                                  
  5559                                  ;-18     getCodes();//set: Code1, Code2, Code3
  5560                                  
  5561 00003B8E E89EFD                   call getCodes
  5562                                  
  5563                                  ;-19 
  5564                                  
  5565                                  
  5566                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  5567                                  
  5568 00003B91 A0[AE01]                 mov al, [CodeType]
  5569 00003B94 3C01                     cmp al, 1
  5570 00003B96 0F850F00                 jne @@process221
  5571                                  
  5572                                  ;-21         genCode8(Code1);
  5573                                  
  5574 00003B9A A0[AF01]                 mov al, byte [Code1]
  5575 00003B9D B400                     mov ah, 0
  5576 00003B9F 50                       push ax
  5577 00003BA0 E8FAFD                   call genCode8
  5578 00003BA3 83C402                   add  sp, 2
  5579                                  
  5580                                  ;-22         return;
  5581                                  
  5582 00003BA6 E9FB05                   jmp @@retn
  5583                                  
  5584                                  ;-23     }
  5585                                  
  5586                                  
  5587                                  ;-24   
  5588                                  
  5589                                  
  5590                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  5591                                  
  5592                                  @@process221:
  5593 00003BA9 A0[AE01]                 mov al, [CodeType]
  5594 00003BAC 3C02                     cmp al, 2
  5595 00003BAE 0F856900                 jne @@process222
  5596                                  
  5597                                  ;-26         getOpL();    
  5598                                  
  5599 00003BB2 E8D9E4                   call getOpL
  5600                                  
  5601                                  ;-27         checkOpL();        
  5602                                  
  5603 00003BB5 E8F9E3                   call checkOpL
  5604                                  
  5605                                  ;-28         if (Code2 <= 1) {//inc,dec
  5606                                  
  5607 00003BB8 A0[B001]                 mov al, [Code2]
  5608 00003BBB 3C01                     cmp al, 1
  5609 00003BBD 0F8F2700                 jg  @@process223
  5610                                  
  5611                                  ;-29   	        if (Op == REG) {//short
  5612                                  
  5613 00003BC1 A0[AC01]                 mov al, [Op]
  5614 00003BC4 3C02                     cmp al, 2
  5615 00003BC6 0F851E00                 jne @@process224
  5616                                  
  5617                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  5618                                  
  5619 00003BCA A0[B701]                 mov al, [wflag]
  5620 00003BCD 08C0                     or  al, al
  5621 00003BCF 0F841500                 je @@process225
  5622 00003BD3 A0[B301]                 mov al, byte [R1No]
  5623 00003BD6 B400                     mov ah, 0
  5624 00003BD8 50                       push ax
  5625 00003BD9 A0[B101]                 mov al, byte [Code3]
  5626 00003BDC B400                     mov ah, 0
  5627 00003BDE 50                       push ax
  5628 00003BDF E884FD                   call genCode2
  5629 00003BE2 83C404                   add  sp, 4
  5630 00003BE5 E9BC05                   jmp @@retn
  5631                                  
  5632                                  ;-31             }
  5633                                  
  5634                                  @@process225:
  5635                                  
  5636                                  ;-32         }
  5637                                  
  5638                                  @@process224:
  5639                                  
  5640                                  ;-33         if (Code2 == 5) {//imul extension?
  5641                                  
  5642                                  @@process223:
  5643 00003BE8 A0[B001]                 mov al, [Code2]
  5644 00003BEB 3C05                     cmp al, 5
  5645 00003BED 0F850F00                 jne @@process226
  5646                                  
  5647                                  ;-34             getTokeType();
  5648                                  
  5649 00003BF1 E8A6E9                   call getTokeType
  5650                                  
  5651                                  ;-35             if (TokeType) implerror();
  5652                                  
  5653 00003BF4 A0[AB01]                 mov al, [TokeType]
  5654 00003BF7 08C0                     or  al, al
  5655 00003BF9 0F840300                 je @@process227
  5656 00003BFD E898F8                   call implerror
  5657                                  
  5658                                  ;-36         }
  5659                                  
  5660                                  @@process227:
  5661                                  
  5662                                  ;-37         genCodeW(Code1);           
  5663                                  
  5664                                  @@process226:
  5665 00003C00 A0[AF01]                 mov al, byte [Code1]
  5666 00003C03 B400                     mov ah, 0
  5667 00003C05 50                       push ax
  5668 00003C06 E878FD                   call genCodeW
  5669 00003C09 83C402                   add  sp, 2
  5670                                  
  5671                                  ;-38         writeEA(Code2);
  5672                                  
  5673 00003C0C A0[B001]                 mov al, byte [Code2]
  5674 00003C0F B400                     mov ah, 0
  5675 00003C11 50                       push ax
  5676 00003C12 E800FE                   call writeEA
  5677 00003C15 83C402                   add  sp, 2
  5678                                  
  5679                                  ;-39         return;
  5680                                  
  5681 00003C18 E98905                   jmp @@retn
  5682                                  
  5683                                  ;-40     }
  5684                                  
  5685                                  
  5686                                  ;-41   
  5687                                  
  5688                                  
  5689                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  5690                                  
  5691                                  @@process222:
  5692 00003C1B A0[AE01]                 mov al, [CodeType]
  5693 00003C1E 3C03                     cmp al, 3
  5694 00003C20 0F855100                 jne @@process228
  5695                                  
  5696                                  ;-43         check2Ops();    //setwflag not applicable
  5697                                  
  5698 00003C24 E80CE4                   call check2Ops
  5699                                  
  5700                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  5701                                  
  5702 00003C27 A0[B501]                 mov al, [R1Type]
  5703 00003C2A 3C02                     cmp al, 2
  5704 00003C2C 0F840300                 je  @@process229
  5705 00003C30 E805F9                   call reg16error
  5706                                  
  5707                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  5708                                  
  5709                                  @@process229:
  5710 00003C33 A0[AD01]                 mov al, [Op2]
  5711 00003C36 3C04                     cmp al, 4
  5712 00003C38 0F840300                 je  @@process230
  5713 00003C3C E81AF8                   call addrerror
  5714                                  
  5715                                  ;-46         
  5716                                  
  5717                                  
  5718                                  ;-47         genCode8(Code1);//les,lds,lea
  5719                                  
  5720                                  @@process230:
  5721 00003C3F A0[AF01]                 mov al, byte [Code1]
  5722 00003C42 B400                     mov ah, 0
  5723 00003C44 50                       push ax
  5724 00003C45 E855FD                   call genCode8
  5725 00003C48 83C402                   add  sp, 2
  5726                                  
  5727                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  5728                                  
  5729 00003C4B A0[AF01]                 mov al, [Code1]
  5730 00003C4E 3C0F                     cmp al, 15
  5731 00003C50 0F850C00                 jne @@process231
  5732 00003C54 A0[B001]                 mov al, byte [Code2]
  5733 00003C57 B400                     mov ah, 0
  5734 00003C59 50                       push ax
  5735 00003C5A E840FD                   call genCode8
  5736 00003C5D 83C402                   add  sp, 2
  5737                                  
  5738                                  ;-49         Op=Op2;//set MEM for writeEA
  5739                                  
  5740                                  @@process231:
  5741 00003C60 A0[AD01]                 mov al, [Op2]
  5742 00003C63 A2[AC01]                 mov byte [Op], al
  5743                                  
  5744                                  ;-50         writeEA(R1No);           
  5745                                  
  5746 00003C66 A0[B301]                 mov al, byte [R1No]
  5747 00003C69 B400                     mov ah, 0
  5748 00003C6B 50                       push ax
  5749 00003C6C E8A6FD                   call writeEA
  5750 00003C6F 83C402                   add  sp, 2
  5751                                  
  5752                                  ;-51         return;
  5753                                  
  5754 00003C72 E92F05                   jmp @@retn
  5755                                  
  5756                                  ;-52     }
  5757                                  
  5758                                  
  5759                                  ;-53 
  5760                                  
  5761                                  
  5762                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  5763                                  
  5764                                  @@process228:
  5765 00003C75 A0[AE01]                 mov al, [CodeType]
  5766 00003C78 3C04                     cmp al, 4
  5767 00003C7A 0F85EF00                 jne @@process232
  5768                                  
  5769                                  ;-55         check2Ops();    
  5770                                  
  5771 00003C7E E8B2E3                   call check2Ops
  5772                                  
  5773                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  5774                                  
  5775 00003C81 A0[AD01]                 mov al, [Op2]
  5776 00003C84 3C01                     cmp al, 1
  5777 00003C86 0F857900                 jne @@process233
  5778                                  
  5779                                  ;-57             setsflag();   
  5780                                  
  5781 00003C8A E889E7                   call setsflag
  5782                                  
  5783                                  ;-58             if (Op == REG) {                
  5784                                  
  5785 00003C8D A0[AC01]                 mov al, [Op]
  5786 00003C90 3C02                     cmp al, 2
  5787 00003C92 0F853100                 jne @@process234
  5788                                  
  5789                                  ;-59                 if (R1No == 0) {// acc,imm   
  5790                                  
  5791 00003C96 A0[B301]                 mov al, [R1No]
  5792 00003C99 3C00                     cmp al, 0
  5793 00003C9B 0F852800                 jne @@process235
  5794                                  
  5795                                  ;-60                     if (sflag == 0) {                        
  5796                                  
  5797 00003C9F A0[B901]                 mov al, [sflag]
  5798 00003CA2 3C00                     cmp al, 0
  5799 00003CA4 0F851F00                 jne @@process236
  5800                                  
  5801                                  ;-61                         c = Code1 << 3;
  5802                                  
  5803 00003CA8 A0[AF01]                 mov al, [Code1]
  5804 00003CAB C0E003                   shl al, 3
  5805 00003CAE 8846FE                   mov byte [bp-2], al
  5806                                  
  5807                                  ;-62                         c += 4;    
  5808                                  
  5809 00003CB1 8046FE04                 add  byte [bp-2], 4
  5810                                  
  5811                                  ;-63                         genCodeW(c);
  5812                                  
  5813 00003CB5 8A46FE                   mov al, byte [bp-2]
  5814 00003CB8 B400                     mov ah, 0
  5815 00003CBA 50                       push ax
  5816 00003CBB E8C3FC                   call genCodeW
  5817 00003CBE 83C402                   add  sp, 2
  5818                                  
  5819                                  ;-64                         genImmediate();
  5820                                  
  5821 00003CC1 E866FE                   call genImmediate
  5822                                  
  5823                                  ;-65                         return;
  5824                                  
  5825 00003CC4 E9DD04                   jmp @@retn
  5826                                  
  5827                                  ;-66                     }
  5828                                  
  5829                                  
  5830                                  ;-67                 }
  5831                                  
  5832                                  @@process236:
  5833                                  
  5834                                  ;-68             }
  5835                                  
  5836                                  @@process235:
  5837                                  
  5838                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  5839                                  
  5840                                  
  5841                                  ;-70             c = sflag + 0x80;   
  5842                                  
  5843                                  @@process234:
  5844 00003CC7 A0[B901]                 mov al, [sflag]
  5845 00003CCA 0480                     add al, 128
  5846 00003CCC 8846FE                   mov byte [bp-2], al
  5847                                  
  5848                                  ;-71             genCodeW(c); 
  5849                                  
  5850 00003CCF 8A46FE                   mov al, byte [bp-2]
  5851 00003CD2 B400                     mov ah, 0
  5852 00003CD4 50                       push ax
  5853 00003CD5 E8A9FC                   call genCodeW
  5854 00003CD8 83C402                   add  sp, 2
  5855                                  
  5856                                  ;-72             writeEA(Code1);  
  5857                                  
  5858 00003CDB A0[AF01]                 mov al, byte [Code1]
  5859 00003CDE B400                     mov ah, 0
  5860 00003CE0 50                       push ax
  5861 00003CE1 E831FD                   call writeEA
  5862 00003CE4 83C402                   add  sp, 2
  5863                                  
  5864                                  ;-73             if (sflag) genCode8(imme);
  5865                                  
  5866 00003CE7 A0[B901]                 mov al, [sflag]
  5867 00003CEA 08C0                     or  al, al
  5868 00003CEC 0F840D00                 je @@process237
  5869 00003CF0 FF36[BE01]               push word [imme]
  5870 00003CF4 E8A6FC                   call genCode8
  5871 00003CF7 83C402                   add  sp, 2
  5872                                  
  5873                                  ;-74             else genImmediate();    
  5874                                  
  5875 00003CFA E90300                   jmp @@process238
  5876                                  @@process237:
  5877 00003CFD E82AFE                   call genImmediate
  5878                                  
  5879                                  ;-75             return;     
  5880                                  
  5881                                  @@process238:
  5882 00003D00 E9A104                   jmp @@retn
  5883                                  
  5884                                  ;-76         }  
  5885                                  
  5886                                  
  5887                                  ;-77         c = Code1 << 3;//r/m, r/r  
  5888                                  
  5889                                  @@process233:
  5890 00003D03 A0[AF01]                 mov al, [Code1]
  5891 00003D06 C0E003                   shl al, 3
  5892 00003D09 8846FE                   mov byte [bp-2], al
  5893                                  
  5894                                  ;-78         if (Op == REG) {
  5895                                  
  5896 00003D0C A0[AC01]                 mov al, [Op]
  5897 00003D0F 3C02                     cmp al, 2
  5898 00003D11 0F852E00                 jne @@process239
  5899                                  
  5900                                  ;-79             if (Op2 == MEM) {//reg, mem      
  5901                                  
  5902 00003D15 A0[AD01]                 mov al, [Op2]
  5903 00003D18 3C04                     cmp al, 4
  5904 00003D1A 0F852500                 jne @@process240
  5905                                  
  5906                                  ;-80                 c += 2;//add direction flag
  5907                                  
  5908 00003D1E 8046FE02                 add  byte [bp-2], 2
  5909                                  
  5910                                  ;-81                 genCodeW(c);
  5911                                  
  5912 00003D22 8A46FE                   mov al, byte [bp-2]
  5913 00003D25 B400                     mov ah, 0
  5914 00003D27 50                       push ax
  5915 00003D28 E856FC                   call genCodeW
  5916 00003D2B 83C402                   add  sp, 2
  5917                                  
  5918                                  ;-82                 Op=Op2;//set MEM for writeEA                
  5919                                  
  5920 00003D2E A0[AD01]                 mov al, [Op2]
  5921 00003D31 A2[AC01]                 mov byte [Op], al
  5922                                  
  5923                                  ;-83                 writeEA(R1No);
  5924                                  
  5925 00003D34 A0[B301]                 mov al, byte [R1No]
  5926 00003D37 B400                     mov ah, 0
  5927 00003D39 50                       push ax
  5928 00003D3A E8D8FC                   call writeEA
  5929 00003D3D 83C402                   add  sp, 2
  5930                                  
  5931                                  ;-84                 return;    
  5932                                  
  5933 00003D40 E96104                   jmp @@retn
  5934                                  
  5935                                  ;-85             }
  5936                                  
  5937                                  
  5938                                  ;-86         }
  5939                                  
  5940                                  @@process240:
  5941                                  
  5942                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  5943                                  
  5944                                  @@process239:
  5945 00003D43 A0[AD01]                 mov al, [Op2]
  5946 00003D46 3C02                     cmp al, 2
  5947 00003D48 0F851B00                 jne @@process241
  5948                                  
  5949                                  ;-88             genCodeW(c);
  5950                                  
  5951 00003D4C 8A46FE                   mov al, byte [bp-2]
  5952 00003D4F B400                     mov ah, 0
  5953 00003D51 50                       push ax
  5954 00003D52 E82CFC                   call genCodeW
  5955 00003D55 83C402                   add  sp, 2
  5956                                  
  5957                                  ;-89             writeEA(R2No);//2. Op in reg-field
  5958                                  
  5959 00003D58 A0[B201]                 mov al, byte [R2No]
  5960 00003D5B B400                     mov ah, 0
  5961 00003D5D 50                       push ax
  5962 00003D5E E8B4FC                   call writeEA
  5963 00003D61 83C402                   add  sp, 2
  5964                                  
  5965                                  ;-90             return;            
  5966                                  
  5967 00003D64 E93D04                   jmp @@retn
  5968                                  
  5969                                  ;-91         }          
  5970                                  
  5971                                  
  5972                                  ;-92         syntaxerror();        
  5973                                  
  5974                                  @@process241:
  5975 00003D67 E81DF8                   call syntaxerror
  5976                                  
  5977                                  ;-93         return;
  5978                                  
  5979 00003D6A E93704                   jmp @@retn
  5980                                  
  5981                                  ;-94     }
  5982                                  
  5983                                  
  5984                                  ;-95  
  5985                                  
  5986                                  
  5987                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  5988                                  
  5989                                  @@process232:
  5990 00003D6D A0[AE01]                 mov al, [CodeType]
  5991 00003D70 3C05                     cmp al, 5
  5992 00003D72 0F857F01                 jne @@process242
  5993                                  
  5994                                  ;-97         check2Ops();    
  5995                                  
  5996 00003D76 E8BAE2                   call check2Ops
  5997                                  
  5998                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  5999                                  
  6000                                  
  6001                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6002                                  
  6003                                  
  6004                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6005                                  
  6006                                  
  6007                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6008                                  
  6009                                  
  6010                                  ;-102         if (Op2 == ADR) {
  6011                                  
  6012 00003D79 A0[AD01]                 mov al, [Op2]
  6013 00003D7C 3C03                     cmp al, 3
  6014 00003D7E 0F850F00                 jne @@process243
  6015                                  
  6016                                  ;-103             imme=disp;
  6017                                  
  6018 00003D82 A1[BC01]                 mov ax, [disp]
  6019 00003D85 A3[BE01]                 mov word [imme], ax
  6020                                  
  6021                                  ;-104             Op2=IMM;//continue with IMM    
  6022                                  
  6023 00003D88 66B801000000             mov eax, 1
  6024 00003D8E A2[AD01]                 mov byte [Op2], al
  6025                                  
  6026                                  ;-105         }  
  6027                                  
  6028                                  
  6029                                  ;-106         if (Op2 == IMM) {// r,i     
  6030                                  
  6031                                  @@process243:
  6032 00003D91 A0[AD01]                 mov al, [Op2]
  6033 00003D94 3C01                     cmp al, 1
  6034 00003D96 0F855400                 jne @@process244
  6035                                  
  6036                                  ;-107             if (Op == REG) {               
  6037                                  
  6038 00003D9A A0[AC01]                 mov al, [Op]
  6039 00003D9D 3C02                     cmp al, 2
  6040 00003D9F 0F852500                 jne @@process245
  6041                                  
  6042                                  ;-108                 c = wflag << 3;   
  6043                                  
  6044 00003DA3 A0[B701]                 mov al, [wflag]
  6045 00003DA6 C0E003                   shl al, 3
  6046 00003DA9 8846FE                   mov byte [bp-2], al
  6047                                  
  6048                                  ;-109                 c += 0xB0;                                     
  6049                                  
  6050 00003DAC 8046FEB0                 add  byte [bp-2], 176
  6051                                  
  6052                                  ;-110                 genCode2(c, R1No);   
  6053                                  
  6054 00003DB0 A0[B301]                 mov al, byte [R1No]
  6055 00003DB3 B400                     mov ah, 0
  6056 00003DB5 50                       push ax
  6057 00003DB6 8A46FE                   mov al, byte [bp-2]
  6058 00003DB9 B400                     mov ah, 0
  6059 00003DBB 50                       push ax
  6060 00003DBC E8A7FB                   call genCode2
  6061 00003DBF 83C404                   add  sp, 4
  6062                                  
  6063                                  ;-111                 genImmediate();
  6064                                  
  6065 00003DC2 E865FD                   call genImmediate
  6066                                  
  6067                                  ;-112                 return; 
  6068                                  
  6069 00003DC5 E9DC03                   jmp @@retn
  6070                                  
  6071                                  ;-113             }
  6072                                  
  6073                                  
  6074                                  ;-114             if (Op == MEM) {// m,i  
  6075                                  
  6076                                  @@process245:
  6077 00003DC8 A0[AC01]                 mov al, [Op]
  6078 00003DCB 3C04                     cmp al, 4
  6079 00003DCD 0F851700                 jne @@process246
  6080                                  
  6081                                  ;-115                 genCodeW(0xC6);
  6082                                  
  6083 00003DD1 68C600                   push 198
  6084 00003DD4 E8AAFB                   call genCodeW
  6085 00003DD7 83C402                   add  sp, 2
  6086                                  
  6087                                  ;-116                 writeEA( 0 );
  6088                                  
  6089 00003DDA 6A00                     push 0
  6090 00003DDC E836FC                   call writeEA
  6091 00003DDF 83C402                   add  sp, 2
  6092                                  
  6093                                  ;-117                 genImmediate();
  6094                                  
  6095 00003DE2 E845FD                   call genImmediate
  6096                                  
  6097                                  ;-118                 return;  
  6098                                  
  6099 00003DE5 E9BC03                   jmp @@retn
  6100                                  
  6101                                  ;-119             }
  6102                                  
  6103                                  
  6104                                  ;-120             regmemerror();
  6105                                  
  6106                                  @@process246:
  6107 00003DE8 E823F7                   call regmemerror
  6108                                  
  6109                                  ;-121             return;
  6110                                  
  6111 00003DEB E9B603                   jmp @@retn
  6112                                  
  6113                                  ;-122         }      
  6114                                  
  6115                                  
  6116                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6117                                  
  6118                                  @@process244:
  6119 00003DEE A0[B501]                 mov al, [R1Type]
  6120 00003DF1 3C04                     cmp al, 4
  6121 00003DF3 0F850300                 jne @@process247
  6122 00003DF7 E872E1                   call ChangeDirection
  6123                                  
  6124                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6125                                  
  6126                                  @@process247:
  6127 00003DFA A0[B401]                 mov al, [R2Type]
  6128 00003DFD 3C04                     cmp al, 4
  6129 00003DFF 0F852A00                 jne @@process248
  6130                                  
  6131                                  ;-125             if (OpSize != WORD) reg16error();
  6132                                  
  6133 00003E03 A0[B601]                 mov al, [OpSize]
  6134 00003E06 3C02                     cmp al, 2
  6135 00003E08 0F840300                 je  @@process249
  6136 00003E0C E829F7                   call reg16error
  6137                                  
  6138                                  ;-126                 genCode2(0x8C, dflag);
  6139                                  
  6140                                  @@process249:
  6141 00003E0F A0[B801]                 mov al, byte [dflag]
  6142 00003E12 B400                     mov ah, 0
  6143 00003E14 50                       push ax
  6144 00003E15 688C00                   push 140
  6145 00003E18 E84BFB                   call genCode2
  6146 00003E1B 83C404                   add  sp, 4
  6147                                  
  6148                                  ;-127                 writeEA(R2No);
  6149                                  
  6150 00003E1E A0[B201]                 mov al, byte [R2No]
  6151 00003E21 B400                     mov ah, 0
  6152 00003E23 50                       push ax
  6153 00003E24 E8EEFB                   call writeEA
  6154 00003E27 83C402                   add  sp, 2
  6155                                  
  6156                                  ;-128                 return;   
  6157                                  
  6158 00003E2A E97703                   jmp @@retn
  6159                                  
  6160                                  ;-129         }          
  6161                                  
  6162                                  
  6163                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6164                                  
  6165                                  @@process248:
  6166 00003E2D A0[AD01]                 mov al, [Op2]
  6167 00003E30 3C04                     cmp al, 4
  6168 00003E32 0F853100                 jne @@process250
  6169                                  
  6170                                  ;-131             if (Op == REG) {
  6171                                  
  6172 00003E36 A0[AC01]                 mov al, [Op]
  6173 00003E39 3C02                     cmp al, 2
  6174 00003E3B 0F852800                 jne @@process251
  6175                                  
  6176                                  ;-132                 if (R1No == 0) {
  6177                                  
  6178 00003E3F A0[B301]                 mov al, [R1No]
  6179 00003E42 3C00                     cmp al, 0
  6180 00003E44 0F851F00                 jne @@process252
  6181                                  
  6182                                  ;-133                     if (isDirect) {
  6183                                  
  6184 00003E48 A0[BB01]                 mov al, [isDirect]
  6185 00003E4B 08C0                     or  al, al
  6186 00003E4D 0F841600                 je @@process253
  6187                                  
  6188                                  ;-134                         genCodeW(0xA0);
  6189                                  
  6190 00003E51 68A000                   push 160
  6191 00003E54 E82AFB                   call genCodeW
  6192 00003E57 83C402                   add  sp, 2
  6193                                  
  6194                                  ;-135                         genCode16(disp);
  6195                                  
  6196 00003E5A FF36[BC01]               push word [disp]
  6197 00003E5E E893FB                   call genCode16
  6198 00003E61 83C402                   add  sp, 2
  6199                                  
  6200                                  ;-136                         return;   
  6201                                  
  6202 00003E64 E93D03                   jmp @@retn
  6203                                  
  6204                                  ;-137                     }   
  6205                                  
  6206                                  
  6207                                  ;-138                 }   
  6208                                  
  6209                                  @@process253:
  6210                                  
  6211                                  ;-139             }   
  6212                                  
  6213                                  @@process252:
  6214                                  
  6215                                  ;-140         } 
  6216                                  
  6217                                  @@process251:
  6218                                  
  6219                                  ;-141         if (Op == MEM) {//moffs16, acc
  6220                                  
  6221                                  @@process250:
  6222 00003E67 A0[AC01]                 mov al, [Op]
  6223 00003E6A 3C04                     cmp al, 4
  6224 00003E6C 0F853100                 jne @@process254
  6225                                  
  6226                                  ;-142             if (Op2 == REG) {
  6227                                  
  6228 00003E70 A0[AD01]                 mov al, [Op2]
  6229 00003E73 3C02                     cmp al, 2
  6230 00003E75 0F852800                 jne @@process255
  6231                                  
  6232                                  ;-143                 if (R2No == 0) {
  6233                                  
  6234 00003E79 A0[B201]                 mov al, [R2No]
  6235 00003E7C 3C00                     cmp al, 0
  6236 00003E7E 0F851F00                 jne @@process256
  6237                                  
  6238                                  ;-144                     if (isDirect) {
  6239                                  
  6240 00003E82 A0[BB01]                 mov al, [isDirect]
  6241 00003E85 08C0                     or  al, al
  6242 00003E87 0F841600                 je @@process257
  6243                                  
  6244                                  ;-145                         genCodeW(0xA2);
  6245                                  
  6246 00003E8B 68A200                   push 162
  6247 00003E8E E8F0FA                   call genCodeW
  6248 00003E91 83C402                   add  sp, 2
  6249                                  
  6250                                  ;-146                         genCode16(disp);
  6251                                  
  6252 00003E94 FF36[BC01]               push word [disp]
  6253 00003E98 E859FB                   call genCode16
  6254 00003E9B 83C402                   add  sp, 2
  6255                                  
  6256                                  ;-147                         return;   
  6257                                  
  6258 00003E9E E90303                   jmp @@retn
  6259                                  
  6260                                  ;-148                     }   
  6261                                  
  6262                                  
  6263                                  ;-149                 }   
  6264                                  
  6265                                  @@process257:
  6266                                  
  6267                                  ;-150             }
  6268                                  
  6269                                  @@process256:
  6270                                  
  6271                                  ;-151         
  6272                                  
  6273                                  
  6274                                  ;-152         }
  6275                                  
  6276                                  @@process255:
  6277                                  
  6278                                  ;-153         if (Op2 == REG) {//rm, r
  6279                                  
  6280                                  @@process254:
  6281 00003EA1 A0[AD01]                 mov al, [Op2]
  6282 00003EA4 3C02                     cmp al, 2
  6283 00003EA6 0F851800                 jne @@process258
  6284                                  
  6285                                  ;-154             genCodeW(0x88);     
  6286                                  
  6287 00003EAA 688800                   push 136
  6288 00003EAD E8D1FA                   call genCodeW
  6289 00003EB0 83C402                   add  sp, 2
  6290                                  
  6291                                  ;-155             writeEA(R2No);
  6292                                  
  6293 00003EB3 A0[B201]                 mov al, byte [R2No]
  6294 00003EB6 B400                     mov ah, 0
  6295 00003EB8 50                       push ax
  6296 00003EB9 E859FB                   call writeEA
  6297 00003EBC 83C402                   add  sp, 2
  6298                                  
  6299                                  ;-156             return;
  6300                                  
  6301 00003EBF E9E202                   jmp @@retn
  6302                                  
  6303                                  ;-157         }
  6304                                  
  6305                                  
  6306                                  ;-158         if (Op2 == MEM) {//r, m
  6307                                  
  6308                                  @@process258:
  6309 00003EC2 A0[AD01]                 mov al, [Op2]
  6310 00003EC5 3C04                     cmp al, 4
  6311 00003EC7 0F852400                 jne @@process259
  6312                                  
  6313                                  ;-159             if (Op == REG) {
  6314                                  
  6315 00003ECB A0[AC01]                 mov al, [Op]
  6316 00003ECE 3C02                     cmp al, 2
  6317 00003ED0 0F851B00                 jne @@process260
  6318                                  
  6319                                  ;-160                 ChangeDirection();
  6320                                  
  6321 00003ED4 E895E0                   call ChangeDirection
  6322                                  
  6323                                  ;-161                 genCodeW(0x8A);
  6324                                  
  6325 00003ED7 688A00                   push 138
  6326 00003EDA E8A4FA                   call genCodeW
  6327 00003EDD 83C402                   add  sp, 2
  6328                                  
  6329                                  ;-162                 writeEA(R2No);
  6330                                  
  6331 00003EE0 A0[B201]                 mov al, byte [R2No]
  6332 00003EE3 B400                     mov ah, 0
  6333 00003EE5 50                       push ax
  6334 00003EE6 E82CFB                   call writeEA
  6335 00003EE9 83C402                   add  sp, 2
  6336                                  
  6337                                  ;-163                 return;   
  6338                                  
  6339 00003EEC E9B502                   jmp @@retn
  6340                                  
  6341                                  ;-164             }   
  6342                                  
  6343                                  
  6344                                  ;-165         }         
  6345                                  
  6346                                  @@process260:
  6347                                  
  6348                                  ;-166         syntaxerror();
  6349                                  
  6350                                  @@process259:
  6351 00003EEF E895F6                   call syntaxerror
  6352                                  
  6353                                  ;-167         return;
  6354                                  
  6355 00003EF2 E9AF02                   jmp @@retn
  6356                                  
  6357                                  ;-168     }    
  6358                                  
  6359                                  
  6360                                  ;-169     
  6361                                  
  6362                                  
  6363                                  ;-170     if (CodeType == 6) {//Jcc short jumps       
  6364                                  
  6365                                  @@process242:
  6366 00003EF5 A0[AE01]                 mov al, [CodeType]
  6367 00003EF8 3C06                     cmp al, 6
  6368 00003EFA 0F85B300                 jne @@process261
  6369                                  
  6370                                  ;-171 
  6371                                  
  6372                                  
  6373                                  ;-172 
  6374                                  
  6375                                  
  6376                                  ;-173         if (TokeType == ALNUME) {
  6377                                  
  6378 00003EFE A0[AB01]                 mov al, [TokeType]
  6379 00003F01 3C03                     cmp al, 3
  6380 00003F03 0F85A700                 jne @@process262
  6381                                  
  6382                                  ;-174             LabelIx=searchLabel();
  6383                                  
  6384 00003F07 E8D1E7                   call searchLabel
  6385 00003F0A A3[7E06]                 mov word [LabelIx], ax
  6386                                  
  6387                                  ;-175             if (LabelIx) {
  6388                                  
  6389 00003F0D A1[7E06]                 mov ax, [LabelIx]
  6390 00003F10 08C0                     or  al, al
  6391 00003F12 0F847000                 je @@process263
  6392                                  
  6393                                  ;-176                 disp=LabelAddr[LabelIx];
  6394                                  
  6395 00003F16 8B1E[7E06]               mov bx, [LabelIx]
  6396 00003F1A D1E3                     shl bx, 1
  6397 00003F1C 8B87[B405]               mov ax, [LabelAddr + bx]
  6398 00003F20 A3[BC01]                 mov word [disp], ax
  6399                                  
  6400                                  ;-177                 disp = disp - PC;
  6401                                  
  6402 00003F23 A1[BC01]                 mov ax, [disp]
  6403 00003F26 2B06[A601]               sub ax, [PC]
  6404 00003F2A A3[BC01]                 mov word [disp], ax
  6405                                  
  6406                                  ;-178                 if (checkConstSize(disp) ) {
  6407                                  
  6408 00003F2D FF36[BC01]               push word [disp]
  6409 00003F31 E847E5                   call checkConstSize
  6410 00003F34 83C402                   add  sp, 2
  6411 00003F37 08C0                     or  al, al
  6412 00003F39 0F842000                 je @@process264
  6413                                  
  6414                                  ;-179                     genCode2(Code1, 0x70);       
  6415                                  
  6416 00003F3D 6A70                     push 112
  6417 00003F3F A0[AF01]                 mov al, byte [Code1]
  6418 00003F42 B400                     mov ah, 0
  6419 00003F44 50                       push ax
  6420 00003F45 E81EFA                   call genCode2
  6421 00003F48 83C404                   add  sp, 4
  6422                                  
  6423                                  ;-180                     disp -= 2; 
  6424                                  
  6425 00003F4B 832E[BC01]02             sub  word [disp], 2
  6426                                  
  6427                                  ;-181                     genCode8(disp);   
  6428                                  
  6429 00003F50 FF36[BC01]               push word [disp]
  6430 00003F54 E846FA                   call genCode8
  6431 00003F57 83C402                   add  sp, 2
  6432                                  
  6433                                  ;-182                 } else {     
  6434                                  
  6435 00003F5A E92600                   jmp @@process265
  6436                                  @@process264:
  6437                                  
  6438                                  ;-183                     genCode8(0x0F);
  6439                                  
  6440 00003F5D 6A0F                     push 15
  6441 00003F5F E83BFA                   call genCode8
  6442 00003F62 83C402                   add  sp, 2
  6443                                  
  6444                                  ;-184                     genCode2(Code1, 0x80);       
  6445                                  
  6446 00003F65 688000                   push 128
  6447 00003F68 A0[AF01]                 mov al, byte [Code1]
  6448 00003F6B B400                     mov ah, 0
  6449 00003F6D 50                       push ax
  6450 00003F6E E8F5F9                   call genCode2
  6451 00003F71 83C404                   add  sp, 4
  6452                                  
  6453                                  ;-185                     disp -= 4; 
  6454                                  
  6455 00003F74 832E[BC01]04             sub  word [disp], 4
  6456                                  
  6457                                  ;-186                     genCode16(disp);                       
  6458                                  
  6459 00003F79 FF36[BC01]               push word [disp]
  6460 00003F7D E874FA                   call genCode16
  6461 00003F80 83C402                   add  sp, 2
  6462                                  
  6463                                  ;-187                 }    
  6464                                  
  6465                                  
  6466                                  ;-188             }
  6467                                  
  6468                                  @@process265:
  6469                                  
  6470                                  ;-189             else {//jump forward
  6471                                  
  6472 00003F83 E92800                   jmp @@process266
  6473                                  @@process263:
  6474                                  
  6475                                  ;-190                 genCode8(0x0F);
  6476                                  
  6477 00003F86 6A0F                     push 15
  6478 00003F88 E812FA                   call genCode8
  6479 00003F8B 83C402                   add  sp, 2
  6480                                  
  6481                                  ;-191                 genCode2(Code1, 0x80);
  6482                                  
  6483 00003F8E 688000                   push 128
  6484 00003F91 A0[AF01]                 mov al, byte [Code1]
  6485 00003F94 B400                     mov ah, 0
  6486 00003F96 50                       push ax
  6487 00003F97 E8CCF9                   call genCode2
  6488 00003F9A 83C404                   add  sp, 4
  6489                                  
  6490                                  ;-192                 genCode16(0);
  6491                                  
  6492 00003F9D 6A00                     push 0
  6493 00003F9F E852FA                   call genCode16
  6494 00003FA2 83C402                   add  sp, 2
  6495                                  
  6496                                  ;-193                 PrintRA='R';
  6497                                  
  6498 00003FA5 66B852000000             mov eax, 82
  6499 00003FAB A2[C901]                 mov byte [PrintRA], al
  6500                                  
  6501                                  ;-194                 
  6502                                  
  6503                                  
  6504                                  ;-195             }   
  6505                                  
  6506                                  
  6507                                  ;-196         }
  6508                                  
  6509                                  @@process266:
  6510                                  
  6511                                  ;-197         return;   
  6512                                  
  6513                                  @@process262:
  6514 00003FAE E9F301                   jmp @@retn
  6515                                  
  6516                                  ;-198     }
  6517                                  
  6518                                  
  6519                                  ;-199     
  6520                                  
  6521                                  
  6522                                  ;-200     if (CodeType ==  8) {//ret,retf
  6523                                  
  6524                                  @@process261:
  6525 00003FB1 A0[AE01]                 mov al, [CodeType]
  6526 00003FB4 3C08                     cmp al, 8
  6527 00003FB6 0F853100                 jne @@process267
  6528                                  
  6529                                  ;-201         if (TokeType == DIGIT) {
  6530                                  
  6531 00003FBA A0[AB01]                 mov al, [TokeType]
  6532 00003FBD 3C01                     cmp al, 1
  6533 00003FBF 0F851900                 jne @@process268
  6534                                  
  6535                                  ;-202             genCode8(Code2);
  6536                                  
  6537 00003FC3 A0[B001]                 mov al, byte [Code2]
  6538 00003FC6 B400                     mov ah, 0
  6539 00003FC8 50                       push ax
  6540 00003FC9 E8D1F9                   call genCode8
  6541 00003FCC 83C402                   add  sp, 2
  6542                                  
  6543                                  ;-203             genCode16(SymbolInt);
  6544                                  
  6545 00003FCF FF36[4D00]               push word [SymbolInt]
  6546 00003FD3 E81EFA                   call genCode16
  6547 00003FD6 83C402                   add  sp, 2
  6548                                  
  6549                                  ;-204             return;
  6550                                  
  6551 00003FD9 E9C801                   jmp @@retn
  6552                                  
  6553                                  ;-205         }
  6554                                  
  6555                                  
  6556                                  ;-206         genCode8(Code1); 
  6557                                  
  6558                                  @@process268:
  6559 00003FDC A0[AF01]                 mov al, byte [Code1]
  6560 00003FDF B400                     mov ah, 0
  6561 00003FE1 50                       push ax
  6562 00003FE2 E8B8F9                   call genCode8
  6563 00003FE5 83C402                   add  sp, 2
  6564                                  
  6565                                  ;-207         return;
  6566                                  
  6567 00003FE8 E9B901                   jmp @@retn
  6568                                  
  6569                                  ;-208     }
  6570                                  
  6571                                  
  6572                                  ;-209        
  6573                                  
  6574                                  
  6575                                  ;-210     if (CodeType == 9) {//push, pop  
  6576                                  
  6577                                  @@process267:
  6578 00003FEB A0[AE01]                 mov al, [CodeType]
  6579 00003FEE 3C09                     cmp al, 9
  6580 00003FF0 0F850301                 jne @@process269
  6581                                  
  6582                                  ;-211         getOpL();
  6583                                  
  6584 00003FF4 E897E0                   call getOpL
  6585                                  
  6586                                  ;-212         if (Code1 == 0x50) {//push only
  6587                                  
  6588 00003FF7 A0[AF01]                 mov al, [Code1]
  6589 00003FFA 3C50                     cmp al, 80
  6590 00003FFC 0F853D00                 jne @@process270
  6591                                  
  6592                                  ;-213             if (Op == IMM) {//push imm8,16
  6593                                  
  6594 00004000 A0[AC01]                 mov al, [Op]
  6595 00004003 3C01                     cmp al, 1
  6596 00004005 0F853400                 jne @@process271
  6597                                  
  6598                                  ;-214                 setsflag();
  6599                                  
  6600 00004009 E80AE4                   call setsflag
  6601                                  
  6602                                  ;-215                 genCode2(0x68, sflag);     
  6603                                  
  6604 0000400C A0[B901]                 mov al, byte [sflag]
  6605 0000400F B400                     mov ah, 0
  6606 00004011 50                       push ax
  6607 00004012 6A68                     push 104
  6608 00004014 E84FF9                   call genCode2
  6609 00004017 83C404                   add  sp, 4
  6610                                  
  6611                                  ;-216                 if (sflag) genCode8 (imme);
  6612                                  
  6613 0000401A A0[B901]                 mov al, [sflag]
  6614 0000401D 08C0                     or  al, al
  6615 0000401F 0F840D00                 je @@process272
  6616 00004023 FF36[BE01]               push word [imme]
  6617 00004027 E873F9                   call genCode8
  6618 0000402A 83C402                   add  sp, 2
  6619                                  
  6620                                  ;-217                 else       genCode16(imme);    
  6621                                  
  6622 0000402D E90A00                   jmp @@process273
  6623                                  @@process272:
  6624 00004030 FF36[BE01]               push word [imme]
  6625 00004034 E8BDF9                   call genCode16
  6626 00004037 83C402                   add  sp, 2
  6627                                  
  6628                                  ;-218                 return;   
  6629                                  
  6630                                  @@process273:
  6631 0000403A E96701                   jmp @@retn
  6632                                  
  6633                                  ;-219             }   
  6634                                  
  6635                                  
  6636                                  ;-220         }
  6637                                  
  6638                                  @@process271:
  6639                                  
  6640                                  ;-221         if (R1Type == SEGREG) {
  6641                                  
  6642                                  @@process270:
  6643 0000403D A0[B501]                 mov al, [R1Type]
  6644 00004040 3C04                     cmp al, 4
  6645 00004042 0F855A00                 jne @@process274
  6646                                  
  6647                                  ;-222             if (Code1 == 0x58) {
  6648                                  
  6649 00004046 A0[AF01]                 mov al, [Code1]
  6650 00004049 3C58                     cmp al, 88
  6651 0000404B 0F851200                 jne @@process275
  6652                                  
  6653                                  ;-223                 if (R1No == 1) error1("pop cs not allowed");   
  6654                                  
  6655 0000404F A0[B301]                 mov al, [R1No]
  6656 00004052 3C01                     cmp al, 1
  6657 00004054 0F850900                 jne @@process276
  6658 00004058 68[A641]                 push process_0
  6659 0000405B E86AF3                   call error1
  6660 0000405E 83C402                   add  sp, 2
  6661                                  
  6662                                  ;-224             }
  6663                                  
  6664                                  @@process276:
  6665                                  
  6666                                  ;-225             c = R1No <<3;
  6667                                  
  6668                                  @@process275:
  6669 00004061 A0[B301]                 mov al, [R1No]
  6670 00004064 C0E003                   shl al, 3
  6671 00004067 8846FE                   mov byte [bp-2], al
  6672                                  
  6673                                  ;-226             if (R1No > 3) {//FS, GS
  6674                                  
  6675 0000406A A0[B301]                 mov al, [R1No]
  6676 0000406D 3C03                     cmp al, 3
  6677 0000406F 0F8E0C00                 jle @@process277
  6678                                  
  6679                                  ;-227                 c += 122;
  6680                                  
  6681 00004073 8046FE7A                 add  byte [bp-2], 122
  6682                                  
  6683                                  ;-228                 genCode8(0x0F);
  6684                                  
  6685 00004077 6A0F                     push 15
  6686 00004079 E821F9                   call genCode8
  6687 0000407C 83C402                   add  sp, 2
  6688                                  
  6689                                  ;-229             }
  6690                                  
  6691                                  
  6692                                  ;-230             OpCodePtr++;
  6693                                  
  6694                                  @@process277:
  6695 0000407F FF06[C701]               inc  word [OpCodePtr]
  6696                                  
  6697                                  ;-231             c = c + *OpCodePtr;//is Code4   
  6698                                  
  6699 00004083 8A46FE                   mov al, [bp-2]
  6700 00004086 8B1E[C701]               mov bx, [OpCodePtr]
  6701 0000408A 0207                     add al, [bx]
  6702 0000408C B400                     mov ah, 0
  6703 0000408E 8846FE                   mov byte [bp-2], al
  6704                                  
  6705                                  ;-232             genCode8(c);  
  6706                                  
  6707 00004091 8A46FE                   mov al, byte [bp-2]
  6708 00004094 B400                     mov ah, 0
  6709 00004096 50                       push ax
  6710 00004097 E803F9                   call genCode8
  6711 0000409A 83C402                   add  sp, 2
  6712                                  
  6713                                  ;-233             return; 
  6714                                  
  6715 0000409D E90401                   jmp @@retn
  6716                                  
  6717                                  ;-234         }  
  6718                                  
  6719                                  
  6720                                  ;-235         checkOpL();    
  6721                                  
  6722                                  @@process274:
  6723 000040A0 E80EDF                   call checkOpL
  6724                                  
  6725                                  ;-236         if (R1Type == BYTE) reg16error();
  6726                                  
  6727 000040A3 A0[B501]                 mov al, [R1Type]
  6728 000040A6 3C01                     cmp al, 1
  6729 000040A8 0F850300                 jne @@process278
  6730 000040AC E889F4                   call reg16error
  6731                                  
  6732                                  ;-237         if (R1Type == WORD) {
  6733                                  
  6734                                  @@process278:
  6735 000040AF A0[B501]                 mov al, [R1Type]
  6736 000040B2 3C02                     cmp al, 2
  6737 000040B4 0F851500                 jne @@process279
  6738                                  
  6739                                  ;-238             genCode2(Code1, R1No);
  6740                                  
  6741 000040B8 A0[B301]                 mov al, byte [R1No]
  6742 000040BB B400                     mov ah, 0
  6743 000040BD 50                       push ax
  6744 000040BE A0[AF01]                 mov al, byte [Code1]
  6745 000040C1 B400                     mov ah, 0
  6746 000040C3 50                       push ax
  6747 000040C4 E89FF8                   call genCode2
  6748 000040C7 83C404                   add  sp, 4
  6749                                  
  6750                                  ;-239             return;   
  6751                                  
  6752 000040CA E9D700                   jmp @@retn
  6753                                  
  6754                                  ;-240         }                
  6755                                  
  6756                                  
  6757                                  ;-241         if (Op == MEM) {
  6758                                  
  6759                                  @@process279:
  6760 000040CD A0[AC01]                 mov al, [Op]
  6761 000040D0 3C04                     cmp al, 4
  6762 000040D2 0F851B00                 jne @@process280
  6763                                  
  6764                                  ;-242             genCode8(Code2);
  6765                                  
  6766 000040D6 A0[B001]                 mov al, byte [Code2]
  6767 000040D9 B400                     mov ah, 0
  6768 000040DB 50                       push ax
  6769 000040DC E8BEF8                   call genCode8
  6770 000040DF 83C402                   add  sp, 2
  6771                                  
  6772                                  ;-243             writeEA(Code3);
  6773                                  
  6774 000040E2 A0[B101]                 mov al, byte [Code3]
  6775 000040E5 B400                     mov ah, 0
  6776 000040E7 50                       push ax
  6777 000040E8 E82AF9                   call writeEA
  6778 000040EB 83C402                   add  sp, 2
  6779                                  
  6780                                  ;-244             return;   
  6781                                  
  6782 000040EE E9B300                   jmp @@retn
  6783                                  
  6784                                  ;-245         }
  6785                                  
  6786                                  
  6787                                  ;-246         syntaxerror();
  6788                                  
  6789                                  @@process280:
  6790 000040F1 E893F4                   call syntaxerror
  6791                                  
  6792                                  ;-247         return;        
  6793                                  
  6794 000040F4 E9AD00                   jmp @@retn
  6795                                  
  6796                                  ;-248     }
  6797                                  
  6798                                  
  6799                                  ;-249     
  6800                                  
  6801                                  
  6802                                  ;-250     if (CodeType == 12) {//int
  6803                                  
  6804                                  @@process269:
  6805 000040F7 A0[AE01]                 mov al, [CodeType]
  6806 000040FA 3C0C                     cmp al, 12
  6807 000040FC 0F852200                 jne @@process281
  6808                                  
  6809                                  ;-251         if (TokeType == DIGIT) {            
  6810                                  
  6811 00004100 A0[AB01]                 mov al, [TokeType]
  6812 00004103 3C01                     cmp al, 1
  6813 00004105 0F851900                 jne @@process282
  6814                                  
  6815                                  ;-252             genCode8(Code1);
  6816                                  
  6817 00004109 A0[AF01]                 mov al, byte [Code1]
  6818 0000410C B400                     mov ah, 0
  6819 0000410E 50                       push ax
  6820 0000410F E88BF8                   call genCode8
  6821 00004112 83C402                   add  sp, 2
  6822                                  
  6823                                  ;-253             genCode8(SymbolInt);
  6824                                  
  6825 00004115 FF36[4D00]               push word [SymbolInt]
  6826 00004119 E881F8                   call genCode8
  6827 0000411C 83C402                   add  sp, 2
  6828                                  
  6829                                  ;-254             return;   
  6830                                  
  6831 0000411F E98200                   jmp @@retn
  6832                                  
  6833                                  ;-255         }
  6834                                  
  6835                                  
  6836                                  ;-256     }
  6837                                  
  6838                                  @@process282:
  6839                                  
  6840                                  ;-257     
  6841                                  
  6842                                  
  6843                                  ;-258     if (CodeType == 30) {//enter i18,i8
  6844                                  
  6845                                  @@process281:
  6846 00004122 A0[AE01]                 mov al, [CodeType]
  6847 00004125 3C1E                     cmp al, 30
  6848 00004127 0F855200                 jne @@process283
  6849                                  
  6850                                  ;-259         genCode8(0xC8);
  6851                                  
  6852 0000412B 68C800                   push 200
  6853 0000412E E86CF8                   call genCode8
  6854 00004131 83C402                   add  sp, 2
  6855                                  
  6856                                  ;-260         Op=getOp1();
  6857                                  
  6858 00004134 E814E0                   call getOp1
  6859 00004137 A2[AC01]                 mov byte [Op], al
  6860                                  
  6861                                  ;-261         if (Op == IMM) genCode16(SymbolInt);
  6862                                  
  6863 0000413A A0[AC01]                 mov al, [Op]
  6864 0000413D 3C01                     cmp al, 1
  6865 0000413F 0F850D00                 jne @@process284
  6866 00004143 FF36[4D00]               push word [SymbolInt]
  6867 00004147 E8AAF8                   call genCode16
  6868 0000414A 83C402                   add  sp, 2
  6869                                  
  6870                                  ;-262         else numbererror();
  6871                                  
  6872 0000414D E90300                   jmp @@process285
  6873                                  @@process284:
  6874 00004150 E8A1F3                   call numbererror
  6875                                  
  6876                                  ;-263         need(',');
  6877                                  
  6878                                  @@process285:
  6879 00004153 6A2C                     push 44
  6880 00004155 E846E8                   call need
  6881 00004158 83C402                   add  sp, 2
  6882                                  
  6883                                  ;-264         Op=getOp1();
  6884                                  
  6885 0000415B E8EDDF                   call getOp1
  6886 0000415E A2[AC01]                 mov byte [Op], al
  6887                                  
  6888                                  ;-265         if (Op == IMM) genCode8 (SymbolInt);
  6889                                  
  6890 00004161 A0[AC01]                 mov al, [Op]
  6891 00004164 3C01                     cmp al, 1
  6892 00004166 0F850D00                 jne @@process286
  6893 0000416A FF36[4D00]               push word [SymbolInt]
  6894 0000416E E82CF8                   call genCode8
  6895 00004171 83C402                   add  sp, 2
  6896                                  
  6897                                  ;-266         else numbererror();           
  6898                                  
  6899 00004174 E90300                   jmp @@process287
  6900                                  @@process286:
  6901 00004177 E87AF3                   call numbererror
  6902                                  
  6903                                  ;-267         return;
  6904                                  
  6905                                  @@process287:
  6906 0000417A E92700                   jmp @@retn
  6907                                  
  6908                                  ;-268     }
  6909                                  
  6910                                  
  6911                                  ;-269        
  6912                                  
  6913                                  
  6914                                  ;-270     if (CodeType==101) {// ORG nn
  6915                                  
  6916                                  @@process283:
  6917 0000417D A0[AE01]                 mov al, [CodeType]
  6918 00004180 3C65                     cmp al, 101
  6919 00004182 0F851500                 jne @@process288
  6920                                  
  6921                                  ;-271         if (TokeType != DIGIT) numbererror();
  6922                                  
  6923 00004186 A0[AB01]                 mov al, [TokeType]
  6924 00004189 3C01                     cmp al, 1
  6925 0000418B 0F840300                 je  @@process289
  6926 0000418F E862F3                   call numbererror
  6927                                  
  6928                                  ;-272         PC=SymbolInt;
  6929                                  
  6930                                  @@process289:
  6931 00004192 A1[4D00]                 mov ax, [SymbolInt]
  6932 00004195 A3[A601]                 mov word [PC], ax
  6933                                  
  6934                                  ;-273         return;
  6935                                  
  6936 00004198 E90900                   jmp @@retn
  6937                                  
  6938                                  ;-274     }
  6939                                  
  6940                                  
  6941                                  ;-275     error1("Command not implemented or syntax error");
  6942                                  
  6943                                  @@process288:
  6944 0000419B 68[B941]                 push process_1
  6945 0000419E E827F2                   call error1
  6946 000041A1 83C402                   add  sp, 2
  6947                                  
  6948                                  ;-276 }    
  6949                                  
  6950 000041A4 C9                      @@retn: LEAVE
  6951 000041A5 C3                       ret
  6952                                  ; ENDP
  6953 000041A6 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  6954 000041AF 7420616C6C6F776564-
  6955 000041B8 00                 
  6956 000041B9 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  6957 000041C2 6F7420696D706C656D-
  6958 000041CB 656E746564206F7220-
  6959 000041D4 73796E746178206572-
  6960 000041DD 726F7200           
  6961                                   
  6962                                  ; missing functions: 
  6963                                  ; digit
  6964                                  ; strcpy
  6965                                  ; eqstr
  6966                                  ; strlen
  6967                                  ; eqstr
  6968                                  ; eqstr
  6969                                  ; eqstr
  6970                                  ; eqstr
  6971                                  ; readRL
  6972                                  ; readRL
  6973                                  ; digit
  6974                                  ; digit
  6975                                  ; strcpy
  6976                                  ; toupper
  6977                                  ; strlen
  6978                                  ; strlen
  6979                                  ; eqstr
  6980                                  ; eqstr
  6981                                  ; eqstr
  6982                                  ; eqstr
  6983                                  ; eqstr
  6984                                  ; eqstr
  6985                                  ; eqstr
  6986                                  ; eqstr
  6987                                  ; eqstr
  6988                                  ; eqstr
  6989                                  ; eqstr
  6990                                  ; eqstr
  6991                                  ; eqstr
  6992                                  ; eqstr
  6993                                  ; eqstr
  6994                                  ; eqstr
  6995                                  ; eqstr
  6996                                  ; eqstr
  6997                                  ; eqstr
  6998                                  ; eqstr
  6999                                  ; eqstr
  7000                                  ; eqstr
  7001                                  ; eqstr
  7002                                  ; eqstr
  7003                                  ; eqstr
  7004                                  ; eqstr
  7005                                  ; eqstr
  7006                                  ; eqstr
  7007                                  ; eqstr
  7008                                  ; eqstr
  7009                                  ; writetty
  7010                                  ; writetty
  7011                                  ; fputcR
  7012                                  ; cputs
  7013                                  ; cputs
  7014                                  ; exitR
  7015                                  ; toupper
  7016                                  ; strcpy
  7017                                  ; strcat1
  7018                                  ; strcpy
  7019                                  ; strcat1
  7020                                  ; strcpy
  7021                                  ; strcat1
  7022                                  ; openR
  7023                                  ; cputs
  7024                                  ; cputs
  7025                                  ; exitR
  7026                                  ; creatR
  7027                                  ; cputs
  7028                                  ; cputs
  7029                                  ; exitR
  7030                                  ; creatR
  7031                                  ; cputs
  7032                                  ; cputs
  7033                                  ; exitR
  7034                                  ; fputcR
  7035                                  ; fcloseR
  7036                                  ; fcloseR
  7037                                  ; fcloseR
  7038                                  ; exitR
  7039                                  ; Number of unresolved CALLs :   76
  7040                                  ;use archive file: AR.C
  7041                                  
  7042                                  ;-277 // AR.C Archive
  7043                                  
  7044                                  ;Number of CALLs:    2 : writetty
  7045                                  
  7046                                  writetty:  ; *** PROC ***
  7047 000041E1 B40E                     mov  ah, 14
  7048 000041E3 BB0000                   mov  bx, 0
  7049 000041E6 CD10                     int  16
  7050                                  
  7051                                  ;-278 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  7052                                  
  7053 000041E8 C3                       ret
  7054                                  ; ENDP
  7055                                  ;Number of CALLs:    8 : cputs
  7056                                  
  7057                                  cputs:  ; *** PROC ***
  7058                                  ;Function : cputs, Number of local variables: 2
  7059                                  ;   # type sign width line used address name   list of local variables
  7060                                  ;  200 ptr sign byte   278 NULL bp+4    s
  7061                                  ;  201 var sign byte   278 NULL bp-2    c;
  7062 000041E9 C8020000                 ENTER  2,0
  7063                                  @@cputs290:
  7064 000041ED 8B5E04                   mov bx, [bp+4]
  7065 000041F0 8A07                     mov al, [bx]
  7066 000041F2 B400                     mov ah, 0
  7067 000041F4 08C0                     or  al, al
  7068 000041F6 0F841B00                 je @@cputs291
  7069 000041FA 8B5E04                   mov bx, [bp+4]
  7070 000041FD 8A07                     mov al, [bx]
  7071 000041FF B400                     mov ah, 0
  7072 00004201 8846FE                   mov byte [bp-2], al
  7073 00004204 8A46FE                   mov al, byte [bp-2]
  7074 00004207 B400                     mov ah, 0
  7075 00004209 50                       push ax
  7076 0000420A E8C401                   call putch
  7077 0000420D 83C402                   add  sp, 2
  7078 00004210 FF4604                   inc  word [bp+4]
  7079 00004213 EBD8                     jmp @@cputs290
  7080                                  @@cputs291:
  7081                                  
  7082                                  ;-279 int mkneg(int n) { n; __asm {neg ax} }
  7083 00004215 C9                       LEAVE
  7084 00004216 C3                       ret
  7085                                  ; ENDP
  7086                                  ;Number of CALLs:    2 : toupper
  7087                                  
  7088                                  toupper:  ; *** PROC ***
  7089                                  ;Function : toupper, Number of local variables: 1
  7090                                  ;   # type sign width line used address name   list of local variables
  7091                                  ;  200 ptr sign byte   279 NULL bp+4    s;
  7092 00004217 C8000000                 ENTER  0,0
  7093                                  @@toupper292:
  7094 0000421B 8B5E04                   mov bx, [bp+4]
  7095 0000421E 8A07                     mov al, [bx]
  7096 00004220 B400                     mov ah, 0
  7097 00004222 08C0                     or  al, al
  7098 00004224 0F843000                 je @@toupper293
  7099 00004228 8B5E04                   mov bx, [bp+4]
  7100 0000422B 8A07                     mov al, [bx]
  7101 0000422D B400                     mov ah, 0
  7102 0000422F 83F861                   cmp ax, 97 ;unsigned : 1
  7103 00004232 0F8C1D00                 jl  @@toupper294
  7104 00004236 8B5E04                   mov bx, [bp+4]
  7105 00004239 8A07                     mov al, [bx]
  7106 0000423B B400                     mov ah, 0
  7107 0000423D 83F87A                   cmp ax, 122
  7108 00004240 0F8F0F00                 jg  @@toupper295
  7109 00004244 8B5E04                   mov bx, [bp+4]
  7110 00004247 8A07                     mov al, [bx]
  7111 00004249 B400                     mov ah, 0
  7112 0000424B 83E820                   sub ax, 32
  7113 0000424E 8B5E04                   mov  bx, [bp+4]
  7114 00004251 8807                     mov  [bx], al
  7115                                  @@toupper295:
  7116                                  @@toupper294:
  7117 00004253 FF4604                   inc  word [bp+4]
  7118 00004256 EBC3                     jmp @@toupper292
  7119                                  @@toupper293:
  7120                                  
  7121                                  ;-280 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  7122                                  
  7123                                  
  7124                                  ;-281 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  7125 00004258 C9                       LEAVE
  7126 00004259 C3                       ret
  7127                                  ; ENDP
  7128                                  ;Number of CALLs:    3 : strlen
  7129                                  
  7130                                  strlen:  ; *** PROC ***
  7131                                  ;Function : strlen, Number of local variables: 2
  7132                                  ;   # type sign width line used address name   list of local variables
  7133                                  ;  200 ptr sign byte   281 NULL bp+4    s
  7134                                  ;  201 var sign word   281 NULL bp-2    c;
  7135 0000425A C8020000                 ENTER  2,0
  7136 0000425E 66B800000000             mov eax, 0
  7137 00004264 8946FE                   mov word [bp-2], ax
  7138                                  @@strlen296:
  7139 00004267 8B5E04                   mov bx, [bp+4]
  7140 0000426A 8A07                     mov al, [bx]
  7141 0000426C B400                     mov ah, 0
  7142 0000426E 83F800                   cmp ax, 0
  7143 00004271 0F840800                 je  @@strlen297
  7144 00004275 FF4604                   inc  word [bp+4]
  7145 00004278 FF46FE                   inc  word [bp-2]
  7146 0000427B EBEA                     jmp @@strlen296
  7147                                  @@strlen297:
  7148 0000427D 8B46FE                   mov ax, [bp-2]
  7149 00004280 E90000                   jmp @@retn
  7150                                  
  7151                                  ;-282 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  7152                                  
  7153 00004283 C9                      @@retn: LEAVE
  7154 00004284 C3                       ret
  7155                                  ; ENDP
  7156                                  ;Number of CALLs:    5 : strcpy
  7157                                  
  7158                                  strcpy:  ; *** PROC ***
  7159                                  ;Function : strcpy, Number of local variables: 2
  7160                                  ;   # type sign width line used address name   list of local variables
  7161                                  ;  200 ptr sign byte   282 NULL bp+4    s
  7162                                  ;  201 ptr sign byte   282 NULL bp+6    t;
  7163 00004285 C8000000                 ENTER  0,0
  7164                                  @@strcpy298:
  7165 00004289 8B5E06                   mov bx, [bp+6]
  7166 0000428C 8A07                     mov al, [bx]
  7167 0000428E B400                     mov ah, 0
  7168 00004290 8B5E04                   mov  bx, [bp+4]
  7169 00004293 8807                     mov  [bx], al
  7170 00004295 FF4604                   inc  word [bp+4]
  7171 00004298 FF4606                   inc  word [bp+6]
  7172                                  
  7173                                  ;-283   while (*t!=0); *s=0; return s; }
  7174                                  
  7175 0000429B 8B5E06                   mov bx, [bp+6]
  7176 0000429E 8A07                     mov al, [bx]
  7177 000042A0 B400                     mov ah, 0
  7178 000042A2 83F800                   cmp ax, 0
  7179 000042A5 0F840200                 je  @@strcpy299
  7180 000042A9 EBDE                     jmp @@strcpy298
  7181                                  @@strcpy299:
  7182 000042AB 66B800000000             mov eax, 0
  7183 000042B1 8B5E04                   mov  bx, [bp+4]
  7184 000042B4 8807                     mov  [bx], al
  7185 000042B6 8B4604                   mov ax, [bp+4]
  7186 000042B9 E90000                   jmp @@retn
  7187                                  
  7188                                  ;-284 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  7189                                  
  7190 000042BC C9                      @@retn: LEAVE
  7191 000042BD C3                       ret
  7192                                  ; ENDP
  7193                                  ;Number of CALLs:    3 : digit
  7194                                  
  7195                                  digit:  ; *** PROC ***
  7196                                  ;Function : digit, Number of local variables: 1
  7197                                  ;   # type sign width line used address name   list of local variables
  7198                                  ;  200 var sign byte   284 NULL bp+4    c;
  7199 000042BE C8000000                 ENTER  0,0
  7200 000042C2 8A4604                   mov al, [bp+4]
  7201 000042C5 3C30                     cmp al, 48
  7202 000042C7 0F8D0900                 jge @@digit300
  7203 000042CB 66B800000000             mov eax, 0
  7204 000042D1 E91B00                   jmp @@retn
  7205                                  @@digit300:
  7206 000042D4 8A4604                   mov al, [bp+4]
  7207 000042D7 3C39                     cmp al, 57
  7208 000042D9 0F8E0900                 jle @@digit301
  7209 000042DD 66B800000000             mov eax, 0
  7210 000042E3 E90900                   jmp @@retn
  7211                                  @@digit301:
  7212 000042E6 66B801000000             mov eax, 1
  7213 000042EC E90000                   jmp @@retn
  7214                                  
  7215                                  ;-285 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  7216                                  
  7217 000042EF C9                      @@retn: LEAVE
  7218 000042F0 C3                       ret
  7219                                  ; ENDP
  7220                                  ;Number of CALLs:   35 : eqstr
  7221                                  
  7222                                  eqstr:  ; *** PROC ***
  7223                                  ;Function : eqstr, Number of local variables: 2
  7224                                  ;   # type sign width line used address name   list of local variables
  7225                                  ;  200 ptr sign byte   285 NULL bp+4    p
  7226                                  ;  201 ptr sign byte   285 NULL bp+6    q;
  7227 000042F1 C8000000                 ENTER  0,0
  7228                                  @@eqstr302:
  7229 000042F5 8B5E04                   mov bx, [bp+4]
  7230 000042F8 8A07                     mov al, [bx]
  7231 000042FA B400                     mov ah, 0
  7232 000042FC 08C0                     or  al, al
  7233 000042FE 0F842300                 je @@eqstr303
  7234                                  
  7235                                  ;-286     if (*p != *q) return 0; p++; q++; }
  7236                                  
  7237 00004302 8B5E04                   mov bx, [bp+4]
  7238 00004305 8A07                     mov al, [bx]
  7239 00004307 B400                     mov ah, 0
  7240 00004309 8B5E06                   mov bx, [bp+6]
  7241 0000430C 3A07                     cmp al, [bx]
  7242 0000430E B400                     mov ah, 0
  7243 00004310 0F840900                 je  @@eqstr304
  7244 00004314 66B800000000             mov eax, 0
  7245 0000431A E92700                   jmp @@retn
  7246                                  @@eqstr304:
  7247 0000431D FF4604                   inc  word [bp+4]
  7248 00004320 FF4606                   inc  word [bp+6]
  7249                                  
  7250                                  ;-287     if(*q) return 0; return 1; }
  7251                                  
  7252 00004323 EBD0                     jmp @@eqstr302
  7253                                  @@eqstr303:
  7254 00004325 8B5E06                   mov bx, [bp+6]
  7255 00004328 8A07                     mov al, [bx]
  7256 0000432A B400                     mov ah, 0
  7257 0000432C 08C0                     or  al, al
  7258 0000432E 0F840900                 je @@eqstr305
  7259 00004332 66B800000000             mov eax, 0
  7260 00004338 E90900                   jmp @@retn
  7261                                  @@eqstr305:
  7262 0000433B 66B801000000             mov eax, 1
  7263 00004341 E90000                   jmp @@retn
  7264                                  
  7265                                  ;-288 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  7266                                  
  7267 00004344 C9                      @@retn: LEAVE
  7268 00004345 C3                       ret
  7269                                  ; ENDP
  7270                                  ;Number of CALLs:    3 : strcat1
  7271                                  
  7272                                  strcat1:  ; *** PROC ***
  7273                                  ;Function : strcat1, Number of local variables: 2
  7274                                  ;   # type sign width line used address name   list of local variables
  7275                                  ;  200 ptr sign byte   288 NULL bp+4    s
  7276                                  ;  201 ptr sign byte   288 NULL bp+6    t;
  7277 00004346 C8000000                 ENTER  0,0
  7278                                  @@strcat1306:
  7279 0000434A 8B5E04                   mov bx, [bp+4]
  7280 0000434D 8A07                     mov al, [bx]
  7281 0000434F B400                     mov ah, 0
  7282 00004351 83F800                   cmp ax, 0
  7283 00004354 0F840500                 je  @@strcat1307
  7284 00004358 FF4604                   inc  word [bp+4]
  7285 0000435B EBED                     jmp @@strcat1306
  7286                                  @@strcat1307:
  7287 0000435D FF7606                   push word [bp+6]
  7288 00004360 FF7604                   push word [bp+4]
  7289 00004363 E81FFF                   call strcpy
  7290 00004366 83C404                   add  sp, 4
  7291                                  
  7292                                  ;-289 int basename(char *s) { char *p; p=0;
  7293 00004369 C9                       LEAVE
  7294 0000436A C3                       ret
  7295                                  ; ENDP
  7296                                  ;Number of CALLs:    1 : openR
  7297                                  
  7298                                  openR:  ; *** PROC ***
  7299                                  ;Function : openR, Number of local variables: 1
  7300                                  ;   # type sign width line used address name   list of local variables
  7301                                  ;  200 ptr sign byte   289 NULL bp+4    s;
  7302 0000436B C8000000                 ENTER  0,0
  7303 0000436F 8B5604                   mov  dx, [bp+4]
  7304 00004372 B8023D                   mov  ax, 15618
  7305 00004375 E87200                   call DosInt
  7306                                  
  7307                                  ;-290 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  7308 00004378 C9                       LEAVE
  7309 00004379 C3                       ret
  7310                                  ; ENDP
  7311                                  ;Number of CALLs:    2 : creatR
  7312                                  
  7313                                  creatR:  ; *** PROC ***
  7314                                  ;Function : creatR, Number of local variables: 1
  7315                                  ;   # type sign width line used address name   list of local variables
  7316                                  ;  200 ptr sign byte   290 NULL bp+4    s;
  7317 0000437A C8000000                 ENTER  0,0
  7318 0000437E 8B5604                   mov  dx, [bp+4]
  7319 00004381 B90000                   mov  cx, 0
  7320 00004384 B8003C                   mov  ax, 15360
  7321 00004387 E86000                   call DosInt
  7322                                  
  7323                                  ;-291 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  7324 0000438A C9                       LEAVE
  7325 0000438B C3                       ret
  7326                                  ; ENDP
  7327                                  ;Number of CALLs:    2 : readRL
  7328                                  
  7329                                  readRL:  ; *** PROC ***
  7330                                  ;Function : readRL, Number of local variables: 3
  7331                                  ;   # type sign width line used address name   list of local variables
  7332                                  ;  200 ptr sign byte   291 NULL bp+4    s
  7333                                  ;  201 var sign word   291 NULL bp+6    fd
  7334                                  ;  202 var sign word   291 NULL bp+8    len;
  7335 0000438C C8000000                 ENTER  0,0
  7336 00004390 8B5604                   mov  dx, [bp+4]
  7337 00004393 8B4E08                   mov  cx, [bp+8]
  7338 00004396 8B5E06                   mov  bx, [bp+6]
  7339 00004399 B8003F                   mov  ax, 16128
  7340 0000439C E84B00                   call DosInt
  7341                                  
  7342                                  ;-292 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  7343 0000439F C9                       LEAVE
  7344 000043A0 C3                       ret
  7345                                  ; ENDP
  7346                                  ;Number of CALLs:    2 : fputcR
  7347                                  
  7348                                  fputcR:  ; *** PROC ***
  7349                                  ;Function : fputcR, Number of local variables: 2
  7350                                  ;   # type sign width line used address name   list of local variables
  7351                                  ;  200 ptr sign byte   292 NULL bp+4    n
  7352                                  ;  201 var sign word   292 NULL bp+6    fd;
  7353 000043A1 C8000000                 ENTER  0,0
  7354 000043A5 8D5604                  lea dx, [bp+4]
  7355                                  
  7356                                  ;-293   cx=1; bx=fd; ax=0x4000; DosInt(); }
  7357                                  
  7358 000043A8 B90100                   mov  cx, 1
  7359 000043AB 8B5E06                   mov  bx, [bp+6]
  7360 000043AE B80040                   mov  ax, 16384
  7361 000043B1 E83600                   call DosInt
  7362                                  
  7363                                  ;-294 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  7364 000043B4 C9                       LEAVE
  7365 000043B5 C3                       ret
  7366                                  ; ENDP
  7367                                  ;Number of CALLs:    3 : fcloseR
  7368                                  
  7369                                  fcloseR:  ; *** PROC ***
  7370                                  ;Function : fcloseR, Number of local variables: 1
  7371                                  ;   # type sign width line used address name   list of local variables
  7372                                  ;  200 var sign word   294 NULL bp+4    fd;
  7373 000043B6 C8000000                 ENTER  0,0
  7374 000043BA 8B5E04                   mov  bx, [bp+4]
  7375 000043BD B8003E                   mov  ax, 15872
  7376 000043C0 CD21                     int  33
  7377                                  
  7378                                  ;-295 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  7379 000043C2 C9                       LEAVE
  7380 000043C3 C3                       ret
  7381                                  ; ENDP
  7382                                  ;Number of CALLs:    5 : exitR
  7383                                  
  7384                                  exitR:  ; *** PROC ***
  7385                                  ;Function : exitR, Number of local variables: 1
  7386                                  ;   # type sign width line used address name   list of local variables
  7387                                  ;  200 var sign byte   295 NULL bp+4    c;
  7388 000043C4 C8000000                 ENTER  0,0
  7389 000043C8 B44C                     mov  ah, 76
  7390 000043CA 8A4604                   mov  al, [bp+4]
  7391 000043CD CD21                     int  33
  7392                                  
  7393                                  ;-296 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  7394 000043CF C9                       LEAVE
  7395 000043D0 C3                       ret
  7396                                  ; ENDP
  7397                                  ;End of archive file. 
  7398                                   
  7399                                  ; missing functions: 
  7400                                  ; putch
  7401                                  ; DosInt
  7402                                  ; DosInt
  7403                                  ; DosInt
  7404                                  ; DosInt
  7405                                  ; Number of unresolved CALLs :    5
  7406                                  ;use archive file: AR.C
  7407                                  
  7408                                  ;-297 // AR.C Archive
  7409                                  
  7410                                  ;Number of CALLs:    1 : putch
  7411                                  
  7412                                  putch:  ; *** PROC ***
  7413                                  ;Function : putch, Number of local variables: 1
  7414                                  ;   # type sign width line used address name   list of local variables
  7415                                  ;  200 var sign byte   297 NULL bp+4    c;
  7416 000043D1 C8000000                 ENTER  0,0
  7417 000043D5 807E040A                cmp byte [bp+4], 10
  7418 000043D9 0F850500                 jne @@putch308
  7419 000043DD B00D                     mov  al, 13
  7420 000043DF E8FFFD                   call writetty
  7421                                  @@putch308:
  7422 000043E2 8A4604                   mov  al, [bp+4]
  7423 000043E5 E8F9FD                   call writetty
  7424                                  
  7425                                  ;-298 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  7426 000043E8 C9                       LEAVE
  7427 000043E9 C3                       ret
  7428                                  ; ENDP
  7429                                  ;Number of CALLs:    4 : DosInt
  7430                                  
  7431                                  DosInt:  ; *** PROC ***
  7432 000043EA CD21                     int  33
  7433 000043EC 7304                     jae short @@DosInt309
  7434 000043EE FF06[9F01]               inc  word [DOS_ERR]
  7435                                  @@DosInt309:
  7436                                  
  7437                                  ;-299 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  7438                                  
  7439 000043F2 C3                       ret
  7440                                  ; ENDP
  7441                                  ;End of archive file. 
  7442                                   
  7443                                  ; missing functions:  All FUNCTIONs in place
  7444 000043F3 E80000                  LastFunctionByt:db 0E8h, 0, 0
  7445 000043F6 58                      pop ax
  7446 000043F7 C3                      ret
  7447                                   
  7448                                  ;   # type sign width line used  address name   list of global variables
  7449                                  
  7450                                  ;    1 arr sign byte     1    2        0 Version1[10]
  7451                                  ;    2 var sign byte     1    3        0 LIST
  7452                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  7453                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  7454                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  7455                                  ;    6 var unsg word     5   15        0 SymbolInt
  7456                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  7457                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  7458                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  7459                                  ;   10 arr sign byte     9    5        0 namein[67]
  7460                                  ;   11 arr sign byte    10    6        0 namelst[67]
  7461                                  ;   12 arr sign byte    11    5        0 namebin[67]
  7462                                  ;   13 var sign word    12    4        0 asm_fd
  7463                                  ;   14 var sign word    13    3        0 lst_fd
  7464                                  ;   15 var sign word    14    3        0 bin_fd
  7465                                  ;   16 var sign word    15    6        0 DOS_ERR
  7466                                  ;   17 var sign word    16    4        0 ErrorCount
  7467                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  7468                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  7469                                  ;   20 var unsg word    20    6        0 PC
  7470                                  ;   21 var unsg word    21    2        0 PCStart
  7471                                  ;   22 var sign byte    22    3        0 isLabel
  7472                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  7473                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  7474                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  7475                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  7476                                  ;   27 var sign byte    27   23        0 TokeType
  7477                                  ;   28 def unsg byte    28    -        0 BYTE=1
  7478                                  ;   29 def unsg byte    29    -        0 WORD=2
  7479                                  ;   30 def unsg byte    30    -        0 DWORD=3
  7480                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  7481                                  ;   32 def unsg byte    32    -        0 IMM=1
  7482                                  ;   33 def unsg byte    33    -        0 REG=2
  7483                                  ;   34 def unsg byte    34    -        0 ADR=3
  7484                                  ;   35 def unsg byte    35    -        0 MEM=4
  7485                                  ;   36 var sign byte    36   28        0 Op
  7486                                  ;   37 var sign byte    37   29        0 Op2
  7487                                  ;   38 var sign byte    38   19        0 CodeType
  7488                                  ;   39 var sign byte    39   16        0 Code1
  7489                                  ;   40 var sign byte    40    7        0 Code2
  7490                                  ;   41 var sign byte    41    3        0 Code3
  7491                                  ;   42 var sign byte    42   18        0 R2No
  7492                                  ;   43 var sign byte    43   16        0 R1No
  7493                                  ;   44 var sign byte    44   17        0 R2Type
  7494                                  ;   45 var sign byte    45   14        0 R1Type
  7495                                  ;   46 var sign byte    46   13        0 OpSize
  7496                                  ;   47 var sign byte    47    8        0 wflag
  7497                                  ;   48 var sign byte    48    3        0 dflag
  7498                                  ;   49 var sign byte    49    8        0 sflag
  7499                                  ;   50 var sign byte    50   15        0 rm
  7500                                  ;   51 var sign byte    51    5        0 isDirect
  7501                                  ;   52 var sign word    52   25        0 disp
  7502                                  ;   53 var unsg word    53   10        0 imme
  7503                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  7504                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  7505                                  ;   56 var sign word    57    6        0 OpPrintIndex
  7506                                  ;   57 ptr sign byte    58   19        0 OpCodePtr
  7507                                  ;   58 var sign byte    59    3        0 PrintRA
  7508                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  7509                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  7510                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  7511                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  7512                                  ;   63 arr unsg word    65    4        0 LabelAddr[100]
  7513                                  ;   64 var sign word    66    4        0 LabelMaxIx
  7514                                  ;   65 var sign word    67    7        0 LabelIx
  7515                                  ;   66 def unsg byte    69    -        0 JMPCALLMAX=500
  7516                                  ;   67 def unsg byte    70    -        0 JMPCALLNAMESMAX=1969
  7517                                  ;   68 arr sign byte    71 NULL        0 JmpCallNames[2000]
  7518                                  ;   69 var sign byte    72 NULL        0 JmpCallNamePtr
  7519                                  ;   70 arr unsg word    73 NULL        0 JmpCallAddr[500]
  7520                                  ;   71 arr sign byte    74 NULL        0 JmpCallRelAbs[500]
  7521                                  ;   72 var sign word    75 NULL        0 JmpCallIx
  7522                                  ;   73 def unsg byte    77    -        0 FILEBINMAX=2000
  7523                                  ;   74 arr sign byte    78    2        0 FileBin[2000]
  7524                                  ;   75 var unsg word    79    5        0 BinLen
  7525                                  ;   76 ptr sign byte    81    1        0 arglen
  7526                                  ;   77 ptr sign byte    82    4        0 argv
  7527                                  ;   78 var sign byte     1    1        0 I_START
  7528                                  ;   79 arr sign byte     4 NULL        0 I_PUSHA[9]
  7529                                  ;   80 arr sign byte     5 NULL        0 I_POPA[8]
  7530                                  ;   81 arr sign byte     6 NULL        0 I_NOP[7]
  7531                                  ;   82 arr sign byte     7 NULL        0 I_CBW[7]
  7532                                  ;   83 arr sign byte     8 NULL        0 I_CWDE[8]
  7533                                  ;   84 arr sign byte     9 NULL        0 I_CWD[7]
  7534                                  ;   85 arr sign byte    10 NULL        0 I_CDQ[7]
  7535                                  ;   86 arr sign byte    11 NULL        0 I_WAIT[8]
  7536                                  ;   87 arr sign byte    12 NULL        0 I_PUSHF[9]
  7537                                  ;   88 arr sign byte    13 NULL        0 I_POPF[8]
  7538                                  ;   89 arr sign byte    14 NULL        0 I_SAHF[8]
  7539                                  ;   90 arr sign byte    15 NULL        0 I_LAHF[8]
  7540                                  ;   91 arr sign byte    16 NULL        0 I_MOVSB[9]
  7541                                  ;   92 arr sign byte    17 NULL        0 I_MOVSW[9]
  7542                                  ;   93 arr sign byte    18 NULL        0 I_CMPSB[9]
  7543                                  ;   94 arr sign byte    19 NULL        0 I_CMPSW[9]
  7544                                  ;   95 arr sign byte    20 NULL        0 I_STOSB[9]
  7545                                  ;   96 arr sign byte    21 NULL        0 I_STOSW[9]
  7546                                  ;   97 arr sign byte    22 NULL        0 I_LODSB[9]
  7547                                  ;   98 arr sign byte    23 NULL        0 I_LODSW[9]
  7548                                  ;   99 arr sign byte    24 NULL        0 I_SCASB[9]
  7549                                  ;  100 arr sign byte    25 NULL        0 I_SCASW[9]
  7550                                  ;  101 arr sign byte    26 NULL        0 I_LEAVE[9]
  7551                                  ;  102 arr sign byte    27 NULL        0 I_INT3[8]
  7552                                  ;  103 arr sign byte    28 NULL        0 I_INTO[8]
  7553                                  ;  104 arr sign byte    29 NULL        0 I_IRET[8]
  7554                                  ;  105 arr sign byte    30 NULL        0 I_XLAT[8]
  7555                                  ;  106 arr sign byte    31 NULL        0 I_LOCK[8]
  7556                                  ;  107 arr sign byte    32 NULL        0 I_REPNE[9]
  7557                                  ;  108 arr sign byte    33 NULL        0 I_REPNZ[9]
  7558                                  ;  109 arr sign byte    34 NULL        0 I_REPE[8]
  7559                                  ;  110 arr sign byte    35 NULL        0 I_REPZ[8]
  7560                                  ;  111 arr sign byte    36 NULL        0 I_HLT[7]
  7561                                  ;  112 arr sign byte    37 NULL        0 I_CLC[7]
  7562                                  ;  113 arr sign byte    38 NULL        0 I_STC[7]
  7563                                  ;  114 arr sign byte    39 NULL        0 I_CLI[7]
  7564                                  ;  115 arr sign byte    40 NULL        0 I_STI[7]
  7565                                  ;  116 arr sign byte    41 NULL        0 I_CLD[7]
  7566                                  ;  117 arr sign byte    42 NULL        0 I_STD[7]
  7567                                  ;  118 arr sign byte    44 NULL        0 I_INC[9]
  7568                                  ;  119 arr sign byte    45 NULL        0 I_DEC[9]
  7569                                  ;  120 arr sign byte    46 NULL        0 I_NOT[8]
  7570                                  ;  121 arr sign byte    47 NULL        0 I_NEG[8]
  7571                                  ;  122 arr sign byte    48 NULL        0 I_MUL[8]
  7572                                  ;  123 arr sign byte    49 NULL        0 I_IMUL[9]
  7573                                  ;  124 arr sign byte    50 NULL        0 I_DIV[8]
  7574                                  ;  125 arr sign byte    51 NULL        0 I_IDIV[9]
  7575                                  ;  126 arr sign byte    53 NULL        0 I_LES[7]
  7576                                  ;  127 arr sign byte    54 NULL        0 I_LDS[7]
  7577                                  ;  128 arr sign byte    55 NULL        0 I_LEA[7]
  7578                                  ;  129 arr sign byte    56 NULL        0 I_LSS[8]
  7579                                  ;  130 arr sign byte    57 NULL        0 I_LFS[8]
  7580                                  ;  131 arr sign byte    58 NULL        0 I_LGS[8]
  7581                                  ;  132 arr sign byte    60 NULL        0 I_ADD[7]
  7582                                  ;  133 arr sign byte    61 NULL        0 I_OR[6]
  7583                                  ;  134 arr sign byte    62 NULL        0 I_ADC[7]
  7584                                  ;  135 arr sign byte    63 NULL        0 I_SBB[7]
  7585                                  ;  136 arr sign byte    64 NULL        0 I_AND[7]
  7586                                  ;  137 arr sign byte    65 NULL        0 I_SUB[7]
  7587                                  ;  138 arr sign byte    66 NULL        0 I_XOR[7]
  7588                                  ;  139 arr sign byte    67 NULL        0 I_CMP[7]
  7589                                  ;  140 arr sign byte    68 NULL        0 I_TEST[11]
  7590                                  ;  141 arr sign byte    70 NULL        0 I_MOV[6]
  7591                                  ;  142 arr sign byte    71 NULL        0 I_MOVSX[9]
  7592                                  ;  143 arr sign byte    72 NULL        0 I_MOVZX[9]
  7593                                  ;  144 arr sign byte    74 NULL        0 I_JO[6]
  7594                                  ;  145 arr sign byte    75 NULL        0 I_JNO[7]
  7595                                  ;  146 arr sign byte    76 NULL        0 I_JB[6]
  7596                                  ;  147 arr sign byte    77 NULL        0 I_JC[6]
  7597                                  ;  148 arr sign byte    78 NULL        0 I_JNB[7]
  7598                                  ;  149 arr sign byte    79 NULL        0 I_JAE[7]
  7599                                  ;  150 arr sign byte    80 NULL        0 I_JNC[7]
  7600                                  ;  151 arr sign byte    81 NULL        0 I_JE[6]
  7601                                  ;  152 arr sign byte    82 NULL        0 I_JZ[6]
  7602                                  ;  153 arr sign byte    83 NULL        0 I_JNE[7]
  7603                                  ;  154 arr sign byte    84 NULL        0 I_JNZ[7]
  7604                                  ;  155 arr sign byte    85 NULL        0 I_JBE[7]
  7605                                  ;  156 arr sign byte    86 NULL        0 I_JNA[7]
  7606                                  ;  157 arr sign byte    87 NULL        0 I_JA[6]
  7607                                  ;  158 arr sign byte    88 NULL        0 I_JS[6]
  7608                                  ;  159 arr sign byte    89 NULL        0 I_JNS[7]
  7609                                  ;  160 arr sign byte    90 NULL        0 I_JP[6]
  7610                                  ;  161 arr sign byte    91 NULL        0 I_JPE[7]
  7611                                  ;  162 arr sign byte    92 NULL        0 I_JNP[7]
  7612                                  ;  163 arr sign byte    93 NULL        0 I_JPO[7]
  7613                                  ;  164 arr sign byte    94 NULL        0 I_JL[6]
  7614                                  ;  165 arr sign byte    95 NULL        0 I_JNL[7]
  7615                                  ;  166 arr sign byte    96 NULL        0 I_JGE[7]
  7616                                  ;  167 arr sign byte    97 NULL        0 I_JLE[7]
  7617                                  ;  168 arr sign byte    98 NULL        0 I_JNG[7]
  7618                                  ;  169 arr sign byte    99 NULL        0 I_JG[6]
  7619                                  ;  170 arr sign byte   101 NULL        0 I_JMP[8]
  7620                                  ;  171 arr sign byte   102 NULL        0 I_CALL[9]
  7621                                  ;  172 arr sign byte   104 NULL        0 I_RET[8]
  7622                                  ;  173 arr sign byte   105 NULL        0 I_RETF[9]
  7623                                  ;  174 arr sign byte   107 NULL        0 I_PUSH[11]
  7624                                  ;  175 arr sign byte   108 NULL        0 I_POP[10]
  7625                                  ;  176 arr sign byte   110 NULL        0 I_ROL[7]
  7626                                  ;  177 arr sign byte   111 NULL        0 I_ROR[7]
  7627                                  ;  178 arr sign byte   112 NULL        0 I_RCL[7]
  7628                                  ;  179 arr sign byte   113 NULL        0 I_RCR[7]
  7629                                  ;  180 arr sign byte   114 NULL        0 I_SHL[7]
  7630                                  ;  181 arr sign byte   115 NULL        0 I_SAL[7]
  7631                                  ;  182 arr sign byte   116 NULL        0 I_SHR[7]
  7632                                  ;  183 arr sign byte   117 NULL        0 I_SAR[7]
  7633                                  ;  184 arr sign byte   119 NULL        0 I_INT[8]
  7634                                  ;  185 arr sign byte   130 NULL        0 I_XCHG[9]
  7635                                  ;  186 arr sign byte   140 NULL        0 I_ENTER[8]
  7636                                  ;  187 arr sign byte   142 NULL        0 I_ORG[6]
  7637                                  ;  188 arr sign byte   147 NULL        0 I_DB[5]
  7638                                  ;  189 arr sign byte   148 NULL        0 I_DW[5]
  7639                                  ;  190 arr sign byte   149 NULL        0 I_DD[5]
  7640                                  ;  191 arr sign byte   150 NULL        0 I_RESB[7]
  7641                                  ;  192 arr sign byte   151 NULL        0 I_RESW[7]
  7642                                  ;  193 arr sign byte   152 NULL        0 I_RESD[7]
  7643                                  ;  194 var sign byte   153 NULL        0 I_END
  7644                                  
  7645                                  
  7646                                  ;   # Calls Line Width  Name   list of functions
  7647                                  
  7648                                  ;    0    2    1 word   ChangeDirection
  7649                                  ;    1    2    9 word   checkOpL
  7650                                  ;    2    3   18 word   check2Ops
  7651                                  ;    3    1   27 word   get2Ops
  7652                                  ;    4    3   33 word   getOpL
  7653                                  ;    5    2   41 word   getOpR
  7654                                  ;    6    4   51 word   getOp1
  7655                                  ;    7    1   67 word   getMEM
  7656                                  ;    8    1   90 word   getIndReg1
  7657                                  ;    9    1   98 word   getIndReg2
  7658                                  ;   10    2  108 word   setwflag
  7659                                  ;   11    2  119 word   setsflag
  7660                                  ;   12    1  129 word   checkConstSize
  7661                                  ;   13    1    1 word   parse
  7662                                  ;   14   14   31 word   getTokeType
  7663                                  ;   15    2   40 word   storeLabel
  7664                                  ;   16    3   50 word   searchLabel
  7665                                  ;   17    1   61 word   getVariable
  7666                                  ;   18    2   90 word   lookCode
  7667                                  ;   19    1  105 word   getCodeSize
  7668                                  ;   20    8  112 word   isToken
  7669                                  ;   21    2  117 word   need
  7670                                  ;   22    1  127 word   skipRest
  7671                                  ;   23    1    1 word   getLine
  7672                                  ;   24    1   17 word   ifEOL
  7673                                  ;   25    3   24 word   skipBlank
  7674                                  ;   26    2   29 word   letterE
  7675                                  ;   27    1   39 word   alnumE
  7676                                  ;   28    1   44 word   getDigit
  7677                                  ;   29    1   56 word   getName
  7678                                  ;   30    1   75 word   testReg
  7679                                  ;   31    1    1 word   printLine
  7680                                  ;   32    7   23 word   prc
  7681                                  ;   33    1   35 word   prscomment
  7682                                  ;   34   23   43 word   prs
  7683                                  ;   35    3   65 word   printhex8a
  7684                                  ;   36    2   70 word   printhex4
  7685                                  ;   37    1   75 word   printhex16
  7686                                  ;   38    3   80 word   printIntU
  7687                                  ;   39   24   91 word   error1
  7688                                  ;   40   12   99 word   errorexit
  7689                                  ;   41 NULL  103 word   allowederror
  7690                                  ;   42    3  104 word   addrerror
  7691                                  ;   43    1  105 word   immeerror
  7692                                  ;   44    2  106 word   implerror
  7693                                  ;   45    4  107 word   indexerror
  7694                                  ;   46    3  108 word   invaloperror
  7695                                  ;   47    4  109 word   numbererror
  7696                                  ;   48    1  110 word   regmemerror
  7697                                  ;   49    3  111 word   reg16error
  7698                                  ;   50    1  112 word   segregerror
  7699                                  ;   51    4  113 word   syntaxerror
  7700                                  ;   52 NULL  115 word   addrexit
  7701                                  ;   53 NULL  116 word   internexit
  7702                                  ;   54 NULL    1 word   main
  7703                                  ;   55    1    8 word   getarg
  7704                                  ;   56    1   42 word   epilog
  7705                                  ;   57    2   60 word   end1
  7706                                  ;   58    1    2 word   getCodes
  7707                                  ;   59    1    7 word   gen66h
  7708                                  ;   60    8    9 word   genCode2
  7709                                  ;   61   10   13 word   genCodeW
  7710                                  ;   62   27   17 word   genCode8
  7711                                  ;   63   10   28 word   genCode16
  7712                                  ;   64   10   32 word   writeEA
  7713                                  ;   65    4   74 word   genImmediate
  7714                                  ;   66    1   11 word   process
  7715                                  ;   67    4  277 word   writetty
  7716                                  ;   68    8  278 word   cputs
  7717                                  ;   69    2  279 word   toupper
  7718                                  ;   70    3  281 word   strlen
  7719                                  ;   71    6  282 word   strcpy
  7720                                  ;   72    3  284 word   digit
  7721                                  ;   73   35  285 word   eqstr
  7722                                  ;   74    3  288 word   strcat1
  7723                                  ;   75    1  289 word   openR
  7724                                  ;   76    2  290 word   creatR
  7725                                  ;   77    2  291 word   readRL
  7726                                  ;   78    2  292 word   fputcR
  7727                                  ;   79    3  294 word   fcloseR
  7728                                  ;   80    5  295 word   exitR
  7729                                  ;   81    1  297 word   putch
  7730                                  ;   82    4  298 word   DosInt
  7731                                  ;   83 NULL  299 word   LastFunctionByt
  7732                                  
  7733                                  ;    #  addr name   list of CALLs
  7734                                  
  7735                                  ;    0  1403 implerror
  7736                                  ;    1  1413 segregerror
  7737                                  ;    2  1425 setwflag
  7738                                  ;    3  1434 error1
  7739                                  ;    4  1441 error1
  7740                                  ;    5  1458 get2Ops
  7741                                  ;    6  1466 addrerror
  7742                                  ;    7  1476 invaloperror
  7743                                  ;    8  1489 immeerror
  7744                                  ;    9  1499 addrerror
  7745                                  ;   10  1509 invaloperror
  7746                                  ;   11  1522 setwflag
  7747                                  ;   12  1539 getOpL
  7748                                  ;   13  1546 need
  7749                                  ;   14  1551 getOpR
  7750                                  ;   15  1565 getOpR
  7751                                  ;   16  1579 getOp1
  7752                                  ;   17  1586 isToken
  7753                                  ;   18  1594 getMEM
  7754                                  ;   19  1601 invaloperror
  7755                                  ;   20  1614 error1
  7756                                  ;   21  1628 testReg
  7757                                  ;   22  1636 searchLabel
  7758                                  ;   23  1648 error1
  7759                                  ;   24  1664 getTokeType
  7760                                  ;   25  1676 getOp1
  7761                                  ;   26  1683 syntaxerror
  7762                                  ;   27  1695 getIndReg2
  7763                                  ;   28  1706 getIndReg1
  7764                                  ;   29  1717 isToken
  7765                                  ;   30  1725 getTokeType
  7766                                  ;   31  1737 numbererror
  7767                                  ;   32  1749 isToken
  7768                                  ;   33  1757 isToken
  7769                                  ;   34  1765 errorexit
  7770                                  ;   35  1786 indexerror
  7771                                  ;   36  1797 indexerror
  7772                                  ;   37  1821 indexerror
  7773                                  ;   38  1832 indexerror
  7774                                  ;   39  1852 gen66h
  7775                                  ;   40  1871 error1
  7776                                  ;   41  1902 getLine
  7777                                  ;   42  1910 getTokeType
  7778                                  ;   43  1922 storeLabel
  7779                                  ;   44  1933 getTokeType
  7780                                  ;   45  1945 lookCode
  7781                                  ;   46  1954 process
  7782                                  ;   47  1962 getVariable
  7783                                  ;   48  1974 skipRest
  7784                                  ;   49  1983 error1
  7785                                  ;   50  1990 error1
  7786                                  ;   51  1997 printLine
  7787                                  ;   52  2021 skipBlank
  7788                                  ;   53  2031 digit
  7789                                  ;   54  2037 getDigit
  7790                                  ;   55  2046 letterE
  7791                                  ;   56  2054 getName
  7792                                  ;   57  2075 searchLabel
  7793                                  ;   58  2087 error1
  7794                                  ;   59  2094 strcpy
  7795                                  ;   60  2101 errorexit
  7796                                  ;   61  2111 errorexit
  7797                                  ;   62  2141 eqstr
  7798                                  ;   63  2147 strlen
  7799                                  ;   64  2168 storeLabel
  7800                                  ;   65  2179 getTokeType
  7801                                  ;   66  2191 lookCode
  7802                                  ;   67  2200 errorexit
  7803                                  ;   68  2210 errorexit
  7804                                  ;   69  2220 getTokeType
  7805                                  ;   70  2232 genCode8
  7806                                  ;   71  2241 skipBlank
  7807                                  ;   72  2251 isToken
  7808                                  ;   73  2259 genCode8
  7809                                  ;   74  2268 isToken
  7810                                  ;   75  2276 getTokeType
  7811                                  ;   76  2288 genCode16
  7812                                  ;   77  2298 isToken
  7813                                  ;   78  2306 errorexit
  7814                                  ;   79  2325 eqstr
  7815                                  ;   80  2343 eqstr
  7816                                  ;   81  2349 getTokeType
  7817                                  ;   82  2361 eqstr
  7818                                  ;   83  2367 getTokeType
  7819                                  ;   84  2379 eqstr
  7820                                  ;   85  2385 getTokeType
  7821                                  ;   86  2407 skipBlank
  7822                                  ;   87  2424 isToken
  7823                                  ;   88  2432 getTokeType
  7824                                  ;   89  2444 error1
  7825                                  ;   90  2451 prs
  7826                                  ;   91  2455 prc
  7827                                  ;   92  2468 getTokeType
  7828                                  ;   93  2480 error1
  7829                                  ;   94  2497 readRL
  7830                                  ;   95  2504 errorexit
  7831                                  ;   96  2514 errorexit
  7832                                  ;   97  2524 ifEOL
  7833                                  ;   98  2538 readRL
  7834                                  ;   99  2574 digit
  7835                                  ;  100  2580 letterE
  7836                                  ;  101  2607 digit
  7837                                  ;  102  2627 alnumE
  7838                                  ;  103  2634 errorexit
  7839                                  ;  104  2644 strcpy
  7840                                  ;  105  2651 toupper
  7841                                  ;  106  2667 strlen
  7842                                  ;  107  2674 strlen
  7843                                  ;  108  2681 eqstr
  7844                                  ;  109  2687 eqstr
  7845                                  ;  110  2693 eqstr
  7846                                  ;  111  2699 eqstr
  7847                                  ;  112  2705 eqstr
  7848                                  ;  113  2711 eqstr
  7849                                  ;  114  2717 eqstr
  7850                                  ;  115  2723 eqstr
  7851                                  ;  116  2729 eqstr
  7852                                  ;  117  2735 eqstr
  7853                                  ;  118  2741 eqstr
  7854                                  ;  119  2747 eqstr
  7855                                  ;  120  2753 eqstr
  7856                                  ;  121  2759 eqstr
  7857                                  ;  122  2765 eqstr
  7858                                  ;  123  2771 eqstr
  7859                                  ;  124  2777 eqstr
  7860                                  ;  125  2783 eqstr
  7861                                  ;  126  2789 eqstr
  7862                                  ;  127  2795 eqstr
  7863                                  ;  128  2801 eqstr
  7864                                  ;  129  2807 eqstr
  7865                                  ;  130  2813 eqstr
  7866                                  ;  131  2819 eqstr
  7867                                  ;  132  2825 eqstr
  7868                                  ;  133  2831 eqstr
  7869                                  ;  134  2837 eqstr
  7870                                  ;  135  2843 eqstr
  7871                                  ;  136  2849 eqstr
  7872                                  ;  137  2855 eqstr
  7873                                  ;  138  2875 prs
  7874                                  ;  139  2879 printhex16
  7875                                  ;  140  2890 prs
  7876                                  ;  141  2894 prc
  7877                                  ;  142  2898 printhex8a
  7878                                  ;  143  2909 prs
  7879                                  ;  144  2913 prc
  7880                                  ;  145  2917 prscomment
  7881                                  ;  146  2934 writetty
  7882                                  ;  147  2943 writetty
  7883                                  ;  148  2952 fputcR
  7884                                  ;  149  2974 prc
  7885                                  ;  150  2990 prc
  7886                                  ;  151  3011 printhex4
  7887                                  ;  152  3021 printhex4
  7888                                  ;  153  3043 prc
  7889                                  ;  154  3065 printhex8a
  7890                                  ;  155  3076 printhex8a
  7891                                  ;  156  3101 printIntU
  7892                                  ;  157  3111 prc
  7893                                  ;  158  3124 prs
  7894                                  ;  159  3128 prs
  7895                                  ;  160  3132 prs
  7896                                  ;  161  3136 prs
  7897                                  ;  162  3152 error1
  7898                                  ;  163  3159 end1
  7899                                  ;  164  3177 error1
  7900                                  ;  165  3194 error1
  7901                                  ;  166  3211 error1
  7902                                  ;  167  3228 error1
  7903                                  ;  168  3246 error1
  7904                                  ;  169  3266 error1
  7905                                  ;  170  3285 error1
  7906                                  ;  171  3304 error1
  7907                                  ;  172  3322 error1
  7908                                  ;  173  3341 error1
  7909                                  ;  174  3360 error1
  7910                                  ;  175  3376 errorexit
  7911                                  ;  176  3397 errorexit
  7912                                  ;  177  3412 getarg
  7913                                  ;  178  3419 parse
  7914                                  ;  179  3425 epilog
  7915                                  ;  180  3432 end1
  7916                                  ;  181  3456 cputs
  7917                                  ;  182  3462 cputs
  7918                                  ;  183  3468 exitR
  7919                                  ;  184  3474 toupper
  7920                                  ;  185  3482 strcpy
  7921                                  ;  186  3489 strcat1
  7922                                  ;  187  3497 strcpy
  7923                                  ;  188  3504 strcat1
  7924                                  ;  189  3512 strcpy
  7925                                  ;  190  3519 strcat1
  7926                                  ;  191  3527 openR
  7927                                  ;  192  3533 cputs
  7928                                  ;  193  3539 cputs
  7929                                  ;  194  3545 exitR
  7930                                  ;  195  3551 creatR
  7931                                  ;  196  3558 cputs
  7932                                  ;  197  3564 cputs
  7933                                  ;  198  3570 exitR
  7934                                  ;  199  3576 creatR
  7935                                  ;  200  3583 cputs
  7936                                  ;  201  3589 cputs
  7937                                  ;  202  3595 exitR
  7938                                  ;  203  3601 prs
  7939                                  ;  204  3605 prs
  7940                                  ;  205  3609 prs
  7941                                  ;  206  3613 prs
  7942                                  ;  207  3617 prs
  7943                                  ;  208  3621 prs
  7944                                  ;  209  3625 prs
  7945                                  ;  210  3629 prs
  7946                                  ;  211  3633 prs
  7947                                  ;  212  3650 prs
  7948                                  ;  213  3654 printIntU
  7949                                  ;  214  3664 prs
  7950                                  ;  215  3668 prs
  7951                                  ;  216  3672 prs
  7952                                  ;  217  3676 prs
  7953                                  ;  218  3680 printIntU
  7954                                  ;  219  3690 prs
  7955                                  ;  220  3694 fputcR
  7956                                  ;  221  3708 fcloseR
  7957                                  ;  222  3716 fcloseR
  7958                                  ;  223  3724 fcloseR
  7959                                  ;  224  3732 exitR
  7960                                  ;  225  3754 genCode8
  7961                                  ;  226  3776 genCode8
  7962                                  ;  227  3796 genCode8
  7963                                  ;  228  3816 errorexit
  7964                                  ;  229  3838 genCode8
  7965                                  ;  230  3847 genCode8
  7966                                  ;  231  3872 genCode8
  7967                                  ;  232  3881 genCode8
  7968                                  ;  233  3890 genCode16
  7969                                  ;  234  3913 genCode16
  7970                                  ;  235  3923 genCode8
  7971                                  ;  236  3942 getTokeType
  7972                                  ;  237  3954 getCodeSize
  7973                                  ;  238  3966 getCodes
  7974                                  ;  239  3975 genCode8
  7975                                  ;  240  3984 getOpL
  7976                                  ;  241  3991 checkOpL
  7977                                  ;  242  4000 genCode2
  7978                                  ;  243  4009 getTokeType
  7979                                  ;  244  4021 implerror
  7980                                  ;  245  4031 genCodeW
  7981                                  ;  246  4040 writeEA
  7982                                  ;  247  4048 check2Ops
  7983                                  ;  248  4058 reg16error
  7984                                  ;  249  4069 addrerror
  7985                                  ;  250  4079 genCode8
  7986                                  ;  251  4088 genCode8
  7987                                  ;  252  4097 writeEA
  7988                                  ;  253  4105 check2Ops
  7989                                  ;  254  4115 setsflag
  7990                                  ;  255  4124 genCodeW
  7991                                  ;  256  4133 genImmediate
  7992                                  ;  257  4146 genCodeW
  7993                                  ;  258  4155 writeEA
  7994                                  ;  259  4163 genCode8
  7995                                  ;  260  4172 genImmediate
  7996                                  ;  261  4185 genCodeW
  7997                                  ;  262  4194 writeEA
  7998                                  ;  263  4202 genCodeW
  7999                                  ;  264  4211 writeEA
  8000                                  ;  265  4219 syntaxerror
  8001                                  ;  266  4231 check2Ops
  8002                                  ;  267  4241 genCode2
  8003                                  ;  268  4250 genImmediate
  8004                                  ;  269  4263 genCodeW
  8005                                  ;  270  4272 writeEA
  8006                                  ;  271  4280 genImmediate
  8007                                  ;  272  4293 regmemerror
  8008                                  ;  273  4305 ChangeDirection
  8009                                  ;  274  4321 reg16error
  8010                                  ;  275  4332 genCode2
  8011                                  ;  276  4341 writeEA
  8012                                  ;  277  4349 genCodeW
  8013                                  ;  278  4358 genCode16
  8014                                  ;  279  4368 genCodeW
  8015                                  ;  280  4377 genCode16
  8016                                  ;  281  4387 genCodeW
  8017                                  ;  282  4396 writeEA
  8018                                  ;  283  4404 ChangeDirection
  8019                                  ;  284  4420 genCodeW
  8020                                  ;  285  4429 writeEA
  8021                                  ;  286  4437 syntaxerror
  8022                                  ;  287  4449 searchLabel
  8023                                  ;  288  4461 checkConstSize
  8024                                  ;  289  4476 genCode2
  8025                                  ;  290  4485 genCode8
  8026                                  ;  291  4494 genCode8
  8027                                  ;  292  4503 genCode2
  8028                                  ;  293  4512 genCode16
  8029                                  ;  294  4522 genCode8
  8030                                  ;  295  4531 genCode2
  8031                                  ;  296  4540 genCode16
  8032                                  ;  297  4550 genCode8
  8033                                  ;  298  4559 genCode16
  8034                                  ;  299  4569 genCode8
  8035                                  ;  300  4578 getOpL
  8036                                  ;  301  4585 setsflag
  8037                                  ;  302  4594 genCode2
  8038                                  ;  303  4603 genCode8
  8039                                  ;  304  4612 genCode16
  8040                                  ;  305  4622 error1
  8041                                  ;  306  4629 genCode8
  8042                                  ;  307  4638 genCode8
  8043                                  ;  308  4647 checkOpL
  8044                                  ;  309  4656 reg16error
  8045                                  ;  310  4667 genCode2
  8046                                  ;  311  4676 genCode8
  8047                                  ;  312  4685 writeEA
  8048                                  ;  313  4693 syntaxerror
  8049                                  ;  314  4705 genCode8
  8050                                  ;  315  4714 genCode8
  8051                                  ;  316  4723 genCode8
  8052                                  ;  317  4732 getOp1
  8053                                  ;  318  4739 genCode16
  8054                                  ;  319  4749 numbererror
  8055                                  ;  320  4761 need
  8056                                  ;  321  4766 getOp1
  8057                                  ;  322  4773 genCode8
  8058                                  ;  323  4782 numbererror
  8059                                  ;  324  4794 numbererror
  8060                                  ;  325  4806 error1
  8061                                  ;  326  4832 putch
  8062                                  ;  327  4900 strcpy
  8063                                  ;  328  4915 DosInt
  8064                                  ;  329  4931 DosInt
  8065                                  ;  330  4954 DosInt
  8066                                  ;  331  4973 DosInt
  8067                                  ;  332  5007 writetty
  8068                                  ;  333  5016 writetty
  8069                                  ;Input: AS.C, List: AS.S,  Lines:  300
  8070                                  ;Glob. variables:  194 max.:  200
  8071                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  8072                                  ;Functions      :   84 max.:  300
  8073                                  ;Calls          :  334 max.: 2000, NameField: 5048 max.:    65535
  8074                                  ;Code until     :25998 max.: 30000, free: 4002
  8075                                  ;Data (HeapEnd) :37095, resting stacksize: 28440
  8076                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
