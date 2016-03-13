     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E96736                  jmp main
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
   289                                  ;-75 int JmpCallMaxIx;       //actual number of jmp, call
   290                                  
   291 0000142D 0000                    JmpCallMaxIx dw 0
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
   969 00001FBA E87315                   call implerror
   970                                  
   971                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   972                                  
   973                                  @@checkOpL1:
   974 00001FBD A0[B501]                 mov al, [R1Type]
   975 00001FC0 3C04                     cmp al, 4
   976 00001FC2 0F850600                 jne @@checkOpL2
   977 00001FC6 E82F16                   call segregerror
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
   991 00001FDB E88214                   call error1
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
  1012 00002004 E85914                   call error1
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
  1046 0000203F E8AF14                   call addrerror
  1047                                  
  1048                                  ;-21     if (Op == ADR) invaloperror(); 
  1049                                  
  1050                                  @@check2Ops7:
  1051 00002042 A0[AC01]                 mov al, [Op]
  1052 00002045 3C03                     cmp al, 3
  1053 00002047 0F850300                 jne @@check2Ops8
  1054 0000204B E81D15                   call invaloperror
  1055                                  
  1056                                  ;-22     if (Op == IMM) immeerror();   
  1057                                  
  1058                                  @@check2Ops8:
  1059 0000204E A0[AC01]                 mov al, [Op]
  1060 00002051 3C01                     cmp al, 1
  1061 00002053 0F850300                 jne @@check2Ops9
  1062 00002057 E8B114                   call immeerror
  1063                                  
  1064                                  ;-23     if (Op2==   0) addrerror();
  1065                                  
  1066                                  @@check2Ops9:
  1067 0000205A A0[AD01]                 mov al, [Op2]
  1068 0000205D 3C00                     cmp al, 0
  1069 0000205F 0F850300                 jne @@check2Ops10
  1070 00002063 E88B14                   call addrerror
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
  1081 00002078 E8F014                   call invaloperror
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
  1106 00002084 E8AF09                   call need
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
  1175 000020C7 E83E09                   call isToken
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
  1190 000020EB E87D14                   call invaloperror
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
  1227 0000212B E83213                   call error1
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
  1282 00002178 E83A0C                   call testReg
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
  1296 00002190 E8E005                   call searchLabel
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
  1312 000021AE E8AF12                   call error1
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
  1365 000021E7 E8B603                   call getTokeType
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
  1377 000021F9 E82314                   call syntaxerror
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
  1435 00002251 E8B407                   call isToken
  1436 00002254 83C402                   add  sp, 2
  1437 00002257 08C0                     or  al, al
  1438 00002259 0F841900                 je @@getMEM31
  1439                                  
  1440                                  ;-83             getTokeType();
  1441                                  
  1442 0000225D E84003                   call getTokeType
  1443                                  
  1444                                  ;-84             if (TokeType != DIGIT) numbererror();
  1445                                  
  1446 00002260 A0[AB01]                 mov al, [TokeType]
  1447 00002263 3C01                     cmp al, 1
  1448 00002265 0F840300                 je  @@getMEM32
  1449 00002269 E82013                   call numbererror
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
  1465 00002278 E88D07                   call isToken
  1466 0000227B 83C402                   add  sp, 2
  1467 0000227E 08C0                     or  al, al
  1468 00002280 0F840300                 je @@getMEM33
  1469 00002284 E960FF                   jmp @@getMEM24
  1470                                  @@getMEM33:
  1471                                  
  1472                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1473                                  
  1474 00002287 6A5D                     push 93
  1475 00002289 E87C07                   call isToken
  1476 0000228C 83C402                   add  sp, 2
  1477 0000228F 83F800                   cmp ax, 0
  1478 00002292 0F850900                 jne @@getMEM34
  1479 00002296 68[A122]                 push getMEM_0
  1480 00002299 E82312                   call errorexit
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
  1501 000022B5 E89212                   call indexerror
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
  1545 00002309 E83E12                   call indexerror
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
  1569 00002323 E82412                   call indexerror
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
  1625 0000238F E8B811                   call indexerror
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
  1703 000023F7 E8FB15                   call gen66h
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
  1766 00002455 E80810                   call error1
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
  1835                                  ;-2     LabelNamePtr  = &LabelNames;    
  1836                                  
  1837 000024B0 B8[CA01]                 mov ax, LabelNames
  1838 000024B3 A3[B205]                 mov word [LabelNamePtr], ax
  1839                                  
  1840                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1841                                  
  1842 000024B6 B8[8006]                 mov ax, JmpCallNames
  1843 000024B9 A2[500E]                 mov byte [JmpCallNamePtr], al
  1844                                  
  1845                                  ;-4     do {
  1846                                  
  1847                                  @@parse63:
  1848                                  
  1849                                  ;-5         PCStart=PC; 
  1850                                  
  1851 000024BC A1[A601]                 mov ax, [PC]
  1852 000024BF A3[A801]                 mov word [PCStart], ax
  1853                                  
  1854                                  ;-6         OpSize=0;
  1855                                  
  1856 000024C2 66B800000000             mov eax, 0
  1857 000024C8 A2[B601]                 mov byte [OpSize], al
  1858                                  
  1859                                  ;-7         OpPrintIndex=0; 
  1860                                  
  1861 000024CB 66B800000000             mov eax, 0
  1862 000024D1 A3[C501]                 mov word [OpPrintIndex], ax
  1863                                  
  1864                                  ;-8         PrintRA=' ';
  1865                                  
  1866 000024D4 66B820000000             mov eax, 32
  1867 000024DA A2[C901]                 mov byte [PrintRA], al
  1868                                  
  1869                                  ;-9         getLine();
  1870                                  
  1871 000024DD E8BE05                   call getLine
  1872                                  
  1873                                  ;-10         InputPtr = &InputBuf;
  1874                                  
  1875 000024E0 B8[4F00]                 mov ax, InputBuf
  1876 000024E3 A3[CE00]                 mov word [InputPtr], ax
  1877                                  
  1878                                  ;-11         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1879                                  
  1880 000024E6 E8B700                   call getTokeType
  1881                                  
  1882                                  ;-12         if (TokeType == ALNUME) {
  1883                                  
  1884 000024E9 A0[AB01]                 mov al, [TokeType]
  1885 000024EC 3C03                     cmp al, 3
  1886 000024EE 0F851300                 jne @@parse64
  1887                                  
  1888                                  ;-13             if (isLabel) {//set in getName
  1889                                  
  1890 000024F2 A0[AA01]                 mov al, [isLabel]
  1891 000024F5 08C0                     or  al, al
  1892 000024F7 0F840A00                 je @@parse65
  1893                                  
  1894                                  ;-14                 storeLabel();
  1895                                  
  1896 000024FB E8D201                   call storeLabel
  1897                                  
  1898                                  ;-15                 InputPtr++;//remove :
  1899                                  
  1900 000024FE FF06[CE00]               inc  word [InputPtr]
  1901                                  
  1902                                  ;-16                 getTokeType();
  1903                                  
  1904 00002502 E89B00                   call getTokeType
  1905                                  
  1906                                  ;-17             }
  1907                                  
  1908                                  
  1909                                  ;-18         }
  1910                                  
  1911                                  @@parse65:
  1912                                  
  1913                                  ;-19         if (TokeType == ALNUME) {
  1914                                  
  1915                                  @@parse64:
  1916 00002505 A0[AB01]                 mov al, [TokeType]
  1917 00002508 3C03                     cmp al, 3
  1918 0000250A 0F851B00                 jne @@parse66
  1919                                  
  1920                                  ;-20             lookCode();// and OpCodePtr
  1921                                  
  1922 0000250E E8FA03                   call lookCode
  1923                                  
  1924                                  ;-21             if(CodeType) process();
  1925                                  
  1926 00002511 A0[AE01]                 mov al, [CodeType]
  1927 00002514 08C0                     or  al, al
  1928 00002516 0F840600                 je @@parse67
  1929 0000251A E8C616                   call process
  1930                                  
  1931                                  ;-22             else getVariable();
  1932                                  
  1933 0000251D E90300                   jmp @@parse68
  1934                                  @@parse67:
  1935 00002520 E8B002                   call getVariable
  1936                                  
  1937                                  ;-23             skipRest();
  1938                                  
  1939                                  @@parse68:
  1940 00002523 E84F05                   call skipRest
  1941                                  
  1942                                  ;-24         }
  1943                                  
  1944                                  
  1945                                  ;-25         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1946                                  
  1947 00002526 E92700                   jmp @@parse69
  1948                                  @@parse66:
  1949 00002529 A0[AB01]                 mov al, [TokeType]
  1950 0000252C 3C03                     cmp al, 3
  1951 0000252E 0F8E0C00                 jle @@parse70
  1952 00002532 68[6125]                 push parse_0
  1953 00002535 E8280F                   call error1
  1954 00002538 83C402                   add  sp, 2
  1955                                  
  1956                                  ;-26         else if (TokeType==DIGIT ) error1("No digit allowed @ start of line");
  1957                                  
  1958 0000253B E91200                   jmp @@parse71
  1959                                  @@parse70:
  1960 0000253E A0[AB01]                 mov al, [TokeType]
  1961 00002541 3C01                     cmp al, 1
  1962 00002543 0F850900                 jne @@parse72
  1963 00002547 68[7F25]                 push parse_1
  1964 0000254A E8130F                   call error1
  1965 0000254D 83C402                   add  sp, 2
  1966                                  
  1967                                  ;-27         printLine();
  1968                                  
  1969                                  @@parse72:
  1970                                  @@parse71:
  1971                                  @@parse69:
  1972 00002550 E89E0C                   call printLine
  1973                                  
  1974                                  ;-28     } while (DOS_NoBytes != 0 );
  1975                                  
  1976 00002553 A1[A301]                 mov ax, [DOS_NoBytes]
  1977 00002556 83F800                   cmp ax, 0
  1978 00002559 0F840300                 je  @@parse73
  1979 0000255D E95CFF                   jmp @@parse63
  1980                                  @@parse73:
  1981                                  
  1982                                  ;-29 }
  1983                                  
  1984                                  
  1985                                  ;-30 
  1986                                  
  1987                                  
  1988                                  ;-31 int getTokeType() { 
  1989                                  
  1990 00002560 C3                       ret
  1991                                  ; ENDP
  1992 00002561 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1993 0000256A 696E73747275637469-
  1994 00002573 6F6E20657870656374-
  1995 0000257C 656400             
  1996 0000257F 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1997 00002588 616C6C6F7765642040-
  1998 00002591 207374617274206F66-
  1999 0000259A 206C696E6500       
  2000                                  
  2001                                  getTokeType:  ; *** PROC ***
  2002                                  
  2003                                  ;-32     char c;
  2004                                  
  2005                                  
  2006                                  ;-33     skipBlank();
  2007                                  
  2008                                  ;Function : getTokeType, Number of local variables: 1
  2009                                  ;   # type sign width line used address name   list of local variables
  2010                                  ;  200 var sign byte    32 NULL bp-2    c;
  2011 000025A0 C8020000                 ENTER  2,0
  2012 000025A4 E8F905                   call skipBlank
  2013                                  
  2014                                  ;-34     c = *InputPtr;
  2015                                  
  2016 000025A7 8B1E[CE00]               mov bx, [InputPtr]
  2017 000025AB 8A07                     mov al, [bx]
  2018 000025AD B400                     mov ah, 0
  2019 000025AF 8846FE                   mov byte [bp-2], al
  2020                                  
  2021                                  ;-35     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2022                                  
  2023 000025B2 8A46FE                   mov al, [bp-2]
  2024 000025B5 3C00                     cmp al, 0
  2025 000025B7 0F850C00                 jne @@getTokeType74
  2026 000025BB 66B800000000             mov eax, 0
  2027 000025C1 A2[AB01]                 mov byte [TokeType], al
  2028 000025C4 E97200                   jmp @@retn
  2029                                  
  2030                                  ;-36     if (c == ';') {TokeType=0; return; }//comment
  2031                                  
  2032                                  @@getTokeType74:
  2033 000025C7 8A46FE                   mov al, [bp-2]
  2034 000025CA 3C3B                     cmp al, 59
  2035 000025CC 0F850C00                 jne @@getTokeType75
  2036 000025D0 66B800000000             mov eax, 0
  2037 000025D6 A2[AB01]                 mov byte [TokeType], al
  2038 000025D9 E95D00                   jmp @@retn
  2039                                  
  2040                                  ;-37     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2041                                  
  2042                                  @@getTokeType75:
  2043 000025DC 8A46FE                   mov al, byte [bp-2]
  2044 000025DF B400                     mov ah, 0
  2045 000025E1 50                       push ax
  2046 000025E2 E8711D                   call digit
  2047 000025E5 83C402                   add  sp, 2
  2048 000025E8 08C0                     or  al, al
  2049 000025EA 0F841800                 je @@getTokeType76
  2050 000025EE 8A46FE                   mov al, byte [bp-2]
  2051 000025F1 B400                     mov ah, 0
  2052 000025F3 50                       push ax
  2053 000025F4 E8AF06                   call getDigit
  2054 000025F7 83C402                   add  sp, 2
  2055 000025FA 66B801000000             mov eax, 1
  2056 00002600 A2[AB01]                 mov byte [TokeType], al
  2057 00002603 E93300                   jmp @@retn
  2058                                  
  2059                                  ;-38     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2060                                  
  2061                                  @@getTokeType76:
  2062 00002606 8A46FE                   mov al, byte [bp-2]
  2063 00002609 B400                     mov ah, 0
  2064 0000260B 50                       push ax
  2065 0000260C E8BC05                   call letterE
  2066 0000260F 83C402                   add  sp, 2
  2067 00002612 08C0                     or  al, al
  2068 00002614 0F841800                 je @@getTokeType77
  2069 00002618 8A46FE                   mov al, byte [bp-2]
  2070 0000261B B400                     mov ah, 0
  2071 0000261D 50                       push ax
  2072 0000261E E8DC06                   call getName
  2073 00002621 83C402                   add  sp, 2
  2074 00002624 66B803000000             mov eax, 3
  2075 0000262A A2[AB01]                 mov byte [TokeType], al
  2076 0000262D E90900                   jmp @@retn
  2077                                  
  2078                                  ;-39     TokeType=NOALNUME;
  2079                                  
  2080                                  @@getTokeType77:
  2081 00002630 66B804000000             mov eax, 4
  2082 00002636 A2[AB01]                 mov byte [TokeType], al
  2083                                  
  2084                                  ;-40 }                     
  2085                                  
  2086                                  
  2087                                  ;-41 
  2088                                  
  2089                                  
  2090                                  ;-42 int storeJmpCall() {
  2091                                  
  2092 00002639 C9                      @@retn: LEAVE
  2093 0000263A C3                       ret
  2094                                  ; ENDP
  2095                                  
  2096                                  storeJmpCall:  ; *** PROC ***
  2097                                  
  2098                                  ;-43     unsigned int i;
  2099                                  
  2100                                  
  2101                                  ;-44     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2102                                  
  2103                                  ;Function : storeJmpCall, Number of local variables: 1
  2104                                  ;   # type sign width line used address name   list of local variables
  2105                                  ;  200 var unsg word    43 NULL bp-2    i;
  2106 0000263B C8020000                 ENTER  2,0
  2107 0000263F 8D06[0F00]               lea  ax, [Symbol]
  2108 00002643 50                       push ax
  2109 00002644 A0[500E]                 mov al, byte [JmpCallNamePtr]
  2110 00002647 B400                     mov ah, 0
  2111 00002649 50                       push ax
  2112 0000264A E8D01C                   call strcpy
  2113 0000264D 83C404                   add  sp, 4
  2114 00002650 A2[500E]                 mov byte [JmpCallNamePtr], al
  2115                                  
  2116                                  ;-45     JmpCallNamePtr++;
  2117                                  
  2118 00002653 FE06[500E]               inc  byte [JmpCallNamePtr]
  2119                                  
  2120                                  ;-46     i = JmpCallNamePtr - &JmpCallNames;
  2121                                  
  2122 00002657 A0[500E]                 mov al, [JmpCallNamePtr]
  2123 0000265A 2D[8006]                 sub ax, JmpCallNames
  2124 0000265D 8946FE                   mov word [bp-2], ax
  2125                                  
  2126                                  ;-47     if ( i >= JMPCALLNAMESMAX) errorexit("too long JmpCall names");
  2127                                  
  2128 00002660 8B46FE                   mov ax, [bp-2]
  2129 00002663 3DB107                   cmp ax, 1969 ;unsigned : 0
  2130 00002666 0F820900                 jb  @@storeJmpCall78
  2131 0000266A 68[A726]                 push storeJmpCall_0
  2132 0000266D E84F0E                   call errorexit
  2133 00002670 83C402                   add  sp, 2
  2134                                  
  2135                                  ;-48     JmpCallMaxIx++;
  2136                                  
  2137                                  @@storeJmpCall78:
  2138 00002673 FF06[2D14]               inc  word [JmpCallMaxIx]
  2139                                  
  2140                                  ;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2141                                  
  2142 00002677 A1[2D14]                 mov ax, [JmpCallMaxIx]
  2143 0000267A 3DF401                   cmp ax, 500 ;unsigned : 1
  2144 0000267D 0F8C0900                 jl  @@storeJmpCall79
  2145 00002681 68[BE26]                 push storeJmpCall_1
  2146 00002684 E8380E                   call errorexit
  2147 00002687 83C402                   add  sp, 2
  2148                                  
  2149                                  ;-50     JmpCallAddr[JmpCallMaxIx] = PC;   
  2150                                  
  2151                                  @@storeJmpCall79:
  2152 0000268A A1[A601]                 mov ax, [PC]
  2153 0000268D 8B1E[2D14]               mov bx, [JmpCallMaxIx]
  2154 00002691 D1E3                     shl bx, 1
  2155 00002693 8987[510E]               mov [JmpCallAddr+bx], ax
  2156                                  
  2157                                  ;-51     JmpCallRelAbs[JmpCallMaxIx] = '*';//set correct value r,R,A in CodeType 6+7             
  2158                                  
  2159 00002697 66B82A000000             mov eax, 42
  2160 0000269D 8B1E[2D14]               mov bx, [JmpCallMaxIx]
  2161 000026A1 8887[3912]               mov [JmpCallRelAbs+bx], al
  2162                                  
  2163                                  ;-52 }
  2164                                  
  2165                                  
  2166                                  ;-53 
  2167                                  
  2168                                  
  2169                                  ;-54 int storeLabel() {
  2170 000026A5 C9                       LEAVE
  2171 000026A6 C3                       ret
  2172                                  ; ENDP
  2173 000026A7 746F6F206C6F6E6720-     storeJmpCall_0 db "too long JmpCall names",0
  2174 000026B0 4A6D7043616C6C206E-
  2175 000026B9 616D657300         
  2176 000026BE 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCalls",0
  2177 000026C7 4A6D7043616C6C7300 
  2178                                  
  2179                                  storeLabel:  ; *** PROC ***
  2180                                  
  2181                                  ;-55     unsigned int i;
  2182                                  
  2183                                  
  2184                                  ;-56     if(searchLabel()) error1("duplicate label");
  2185                                  
  2186                                  ;Function : storeLabel, Number of local variables: 1
  2187                                  ;   # type sign width line used address name   list of local variables
  2188                                  ;  200 var unsg word    55 NULL bp-2    i;
  2189 000026D0 C8020000                 ENTER  2,0
  2190 000026D4 E89C00                   call searchLabel
  2191 000026D7 08C0                     or  al, al
  2192 000026D9 0F840900                 je @@storeLabel80
  2193 000026DD 68[3E27]                 push storeLabel_0
  2194 000026E0 E87D0D                   call error1
  2195 000026E3 83C402                   add  sp, 2
  2196                                  
  2197                                  ;-57     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2198                                  
  2199                                  @@storeLabel80:
  2200 000026E6 8D06[0F00]               lea  ax, [Symbol]
  2201 000026EA 50                       push ax
  2202 000026EB FF36[B205]               push word [LabelNamePtr]
  2203 000026EF E82B1C                   call strcpy
  2204 000026F2 83C404                   add  sp, 4
  2205 000026F5 A3[B205]                 mov word [LabelNamePtr], ax
  2206                                  
  2207                                  ;-58     LabelNamePtr++;
  2208                                  
  2209 000026F8 FF06[B205]               inc  word [LabelNamePtr]
  2210                                  
  2211                                  ;-59     i = LabelNamePtr - &LabelNames;
  2212                                  
  2213 000026FC A1[B205]                 mov ax, [LabelNamePtr]
  2214 000026FF 2D[CA01]                 sub ax, LabelNames
  2215 00002702 8946FE                   mov word [bp-2], ax
  2216                                  
  2217                                  ;-60     if (i >= LABELNAMESMAX) errorexit("too long label names");
  2218                                  
  2219 00002705 8B46FE                   mov ax, [bp-2]
  2220 00002708 3DC903                   cmp ax, 969 ;unsigned : 0
  2221 0000270B 0F820900                 jb  @@storeLabel81
  2222 0000270F 68[4E27]                 push storeLabel_1
  2223 00002712 E8AA0D                   call errorexit
  2224 00002715 83C402                   add  sp, 2
  2225                                  
  2226                                  ;-61     LabelMaxIx++;
  2227                                  
  2228                                  @@storeLabel81:
  2229 00002718 FF06[7C06]               inc  word [LabelMaxIx]
  2230                                  
  2231                                  ;-62     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2232                                  
  2233 0000271C A1[7C06]                 mov ax, [LabelMaxIx]
  2234 0000271F 83F864                   cmp ax, 100 ;unsigned : 1
  2235 00002722 0F8C0900                 jl  @@storeLabel82
  2236 00002726 68[6327]                 push storeLabel_2
  2237 00002729 E8930D                   call errorexit
  2238 0000272C 83C402                   add  sp, 2
  2239                                  
  2240                                  ;-63     LabelAddr[LabelMaxIx] = PC;
  2241                                  
  2242                                  @@storeLabel82:
  2243 0000272F A1[A601]                 mov ax, [PC]
  2244 00002732 8B1E[7C06]               mov bx, [LabelMaxIx]
  2245 00002736 D1E3                     shl bx, 1
  2246 00002738 8987[B405]               mov [LabelAddr+bx], ax
  2247                                  
  2248                                  ;-64 }   
  2249                                  
  2250                                  
  2251                                  ;-65 
  2252                                  
  2253                                  
  2254                                  ;-66 int searchLabel() {
  2255 0000273C C9                       LEAVE
  2256 0000273D C3                       ret
  2257                                  ; ENDP
  2258 0000273E 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2259 00002747 206C6162656C00     
  2260 0000274E 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  2261 00002757 6C6162656C206E616D-
  2262 00002760 657300             
  2263 00002763 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  2264 0000276C 6C6162656C7300     
  2265                                  
  2266                                  searchLabel:  ; *** PROC ***
  2267                                  
  2268                                  ;-67     int LIx; char *p; int j;
  2269                                  
  2270                                  
  2271                                  ;-68     p = &LabelNames;
  2272                                  
  2273                                  ;Function : searchLabel, Number of local variables: 3
  2274                                  ;   # type sign width line used address name   list of local variables
  2275                                  ;  200 var sign word    67 NULL bp-2    LIx
  2276                                  ;  201 ptr sign byte    67 NULL bp-4    p
  2277                                  ;  202 var sign word    67 NULL bp-6    j;
  2278 00002773 C8060000                 ENTER  6,0
  2279 00002777 B8[CA01]                 mov ax, LabelNames
  2280 0000277A 8946FC                   mov word [bp-4], ax
  2281                                  
  2282                                  ;-69     LIx = 1;
  2283                                  
  2284 0000277D 66B801000000             mov eax, 1
  2285 00002783 8946FE                   mov word [bp-2], ax
  2286                                  
  2287                                  ;-70     while (LIx <= LabelMaxIx) {
  2288                                  
  2289                                  @@searchLabel83:
  2290 00002786 8B46FE                   mov ax, [bp-2]
  2291 00002789 3B06[7C06]               cmp ax, [LabelMaxIx]
  2292 0000278D 0F8F3700                 jg  @@searchLabel84
  2293                                  
  2294                                  ;-71         if (eqstr(p, Symbol)) return LIx;//pos of label
  2295                                  
  2296 00002791 8D06[0F00]               lea  ax, [Symbol]
  2297 00002795 50                       push ax
  2298 00002796 FF76FC                   push word [bp-4]
  2299 00002799 E8ED1B                   call eqstr
  2300 0000279C 83C404                   add  sp, 4
  2301 0000279F 08C0                     or  al, al
  2302 000027A1 0F840600                 je @@searchLabel85
  2303 000027A5 8B46FE                   mov ax, [bp-2]
  2304 000027A8 E92600                   jmp @@retn
  2305                                  
  2306                                  ;-72         j=strlen(p);
  2307                                  
  2308                                  @@searchLabel85:
  2309 000027AB FF76FC                   push word [bp-4]
  2310 000027AE E8411B                   call strlen
  2311 000027B1 83C402                   add  sp, 2
  2312 000027B4 8946FA                   mov word [bp-6], ax
  2313                                  
  2314                                  ;-73         p=p+j; 
  2315                                  
  2316 000027B7 8B46FC                   mov ax, [bp-4]
  2317 000027BA 0346FA                   add ax, [bp-6]
  2318 000027BD 8946FC                   mov word [bp-4], ax
  2319                                  
  2320                                  ;-74         p++; 
  2321                                  
  2322 000027C0 FF46FC                   inc  word [bp-4]
  2323                                  
  2324                                  ;-75         LIx++;
  2325                                  
  2326 000027C3 FF46FE                   inc  word [bp-2]
  2327                                  
  2328                                  ;-76     }
  2329                                  
  2330                                  
  2331                                  ;-77     return 0;
  2332                                  
  2333 000027C6 EBBE                     jmp @@searchLabel83
  2334                                  @@searchLabel84:
  2335 000027C8 66B800000000             mov eax, 0
  2336 000027CE E90000                   jmp @@retn
  2337                                  
  2338                                  ;-78 }   
  2339                                  
  2340                                  
  2341                                  ;-79 
  2342                                  
  2343                                  
  2344                                  ;-80 int getVariable() { 
  2345                                  
  2346 000027D1 C9                      @@retn: LEAVE
  2347 000027D2 C3                       ret
  2348                                  ; ENDP
  2349                                  
  2350                                  getVariable:  ; *** PROC ***
  2351                                  
  2352                                  ;-81     char c;
  2353                                  
  2354                                  
  2355                                  ;-82     storeLabel();
  2356                                  
  2357                                  ;Function : getVariable, Number of local variables: 1
  2358                                  ;   # type sign width line used address name   list of local variables
  2359                                  ;  200 var sign byte    81 NULL bp-2    c;
  2360 000027D3 C8020000                 ENTER  2,0
  2361 000027D7 E8F6FE                   call storeLabel
  2362                                  
  2363                                  ;-83     getTokeType(); 
  2364                                  
  2365 000027DA E8C3FD                   call getTokeType
  2366                                  
  2367                                  ;-84     if(TokeType==ALNUME) {// getName
  2368                                  
  2369 000027DD A0[AB01]                 mov al, [TokeType]
  2370 000027E0 3C03                     cmp al, 3
  2371 000027E2 0F85CC00                 jne @@getVariable86
  2372                                  
  2373                                  ;-85         lookCode();
  2374                                  
  2375 000027E6 E82201                   call lookCode
  2376                                  
  2377                                  ;-86         if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2378                                  
  2379 000027E9 A0[AE01]                 mov al, [CodeType]
  2380 000027EC 3CC8                     cmp al, 200
  2381 000027EE 0F8D0900                 jge @@getVariable87
  2382 000027F2 68[BD28]                 push getVariable_0
  2383 000027F5 E8C70C                   call errorexit
  2384 000027F8 83C402                   add  sp, 2
  2385                                  
  2386                                  ;-87         if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2387                                  
  2388                                  @@getVariable87:
  2389 000027FB A0[AE01]                 mov al, [CodeType]
  2390 000027FE 3CCF                     cmp al, 207
  2391 00002800 0F8E0900                 jle @@getVariable88
  2392 00002804 68[D528]                 push getVariable_1
  2393 00002807 E8B50C                   call errorexit
  2394 0000280A 83C402                   add  sp, 2
  2395                                  
  2396                                  ;-88         if (CodeType== 200) {// DB
  2397                                  
  2398                                  @@getVariable88:
  2399 0000280D A0[AE01]                 mov al, [CodeType]
  2400 00002810 3CC8                     cmp al, 200
  2401 00002812 0F856A00                 jne @@getVariable89
  2402                                  
  2403                                  ;-89             do { 
  2404                                  
  2405                                  @@getVariable90:
  2406                                  
  2407                                  ;-90                 getTokeType();
  2408                                  
  2409 00002816 E887FD                   call getTokeType
  2410                                  
  2411                                  ;-91                 if (TokeType ==DIGIT) genCode8(SymbolInt);
  2412                                  
  2413 00002819 A0[AB01]                 mov al, [TokeType]
  2414 0000281C 3C01                     cmp al, 1
  2415 0000281E 0F850D00                 jne @@getVariable91
  2416 00002822 FF36[4D00]               push word [SymbolInt]
  2417 00002826 E80C12                   call genCode8
  2418 00002829 83C402                   add  sp, 2
  2419                                  
  2420                                  ;-92                 else {
  2421                                  
  2422 0000282C E94100                   jmp @@getVariable92
  2423                                  @@getVariable91:
  2424                                  
  2425                                  ;-93                     skipBlank();
  2426                                  
  2427 0000282F E86E03                   call skipBlank
  2428                                  
  2429                                  ;-94                     if (isToken('"')) {
  2430                                  
  2431 00002832 6A22                     push 34
  2432 00002834 E8D101                   call isToken
  2433 00002837 83C402                   add  sp, 2
  2434 0000283A 08C0                     or  al, al
  2435 0000283C 0F843000                 je @@getVariable93
  2436                                  
  2437                                  ;-95                         do { 
  2438                                  
  2439                                  @@getVariable94:
  2440                                  
  2441                                  ;-96                             c= *InputPtr;
  2442                                  
  2443 00002840 8B1E[CE00]               mov bx, [InputPtr]
  2444 00002844 8A07                     mov al, [bx]
  2445 00002846 B400                     mov ah, 0
  2446 00002848 8846FE                   mov byte [bp-2], al
  2447                                  
  2448                                  ;-97                             genCode8(c);
  2449                                  
  2450 0000284B 8A46FE                   mov al, byte [bp-2]
  2451 0000284E B400                     mov ah, 0
  2452 00002850 50                       push ax
  2453 00002851 E8E111                   call genCode8
  2454 00002854 83C402                   add  sp, 2
  2455                                  
  2456                                  ;-98                             InputPtr++;
  2457                                  
  2458 00002857 FF06[CE00]               inc  word [InputPtr]
  2459                                  
  2460                                  ;-99                         } while (*InputPtr != '"' );
  2461                                  
  2462 0000285B 8B1E[CE00]               mov bx, [InputPtr]
  2463 0000285F 8A07                     mov al, [bx]
  2464 00002861 B400                     mov ah, 0
  2465 00002863 83F822                   cmp ax, 34
  2466 00002866 0F840200                 je  @@getVariable95
  2467 0000286A EBD4                     jmp @@getVariable94
  2468                                  @@getVariable95:
  2469                                  
  2470                                  ;-100                         InputPtr++;
  2471                                  
  2472 0000286C FF06[CE00]               inc  word [InputPtr]
  2473                                  
  2474                                  ;-101                     }
  2475                                  
  2476                                  
  2477                                  ;-102                 }
  2478                                  
  2479                                  @@getVariable93:
  2480                                  
  2481                                  ;-103             } while (isToken(','));
  2482                                  
  2483                                  @@getVariable92:
  2484 00002870 6A2C                     push 44
  2485 00002872 E89301                   call isToken
  2486 00002875 83C402                   add  sp, 2
  2487 00002878 08C0                     or  al, al
  2488 0000287A 0F840200                 je @@getVariable96
  2489 0000287E EB96                     jmp @@getVariable90
  2490                                  @@getVariable96:
  2491                                  
  2492                                  ;-104         }
  2493                                  
  2494                                  
  2495                                  ;-105         if (CodeType== 201) {// DW
  2496                                  
  2497                                  @@getVariable89:
  2498 00002880 A0[AE01]                 mov al, [CodeType]
  2499 00002883 3CC9                     cmp al, 201
  2500 00002885 0F852600                 jne @@getVariable97
  2501                                  
  2502                                  ;-106             do { 
  2503                                  
  2504                                  @@getVariable98:
  2505                                  
  2506                                  ;-107                 getTokeType();
  2507                                  
  2508 00002889 E814FD                   call getTokeType
  2509                                  
  2510                                  ;-108                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2511                                  
  2512 0000288C A0[AB01]                 mov al, [TokeType]
  2513 0000288F 3C01                     cmp al, 1
  2514 00002891 0F850A00                 jne @@getVariable99
  2515 00002895 FF36[4D00]               push word [SymbolInt]
  2516 00002899 E8F011                   call genCode16
  2517 0000289C 83C402                   add  sp, 2
  2518                                  
  2519                                  ;-109             } while (isToken(','));
  2520                                  
  2521                                  @@getVariable99:
  2522 0000289F 6A2C                     push 44
  2523 000028A1 E86401                   call isToken
  2524 000028A4 83C402                   add  sp, 2
  2525 000028A7 08C0                     or  al, al
  2526 000028A9 0F840200                 je @@getVariable100
  2527 000028AD EBDA                     jmp @@getVariable98
  2528                                  @@getVariable100:
  2529                                  
  2530                                  ;-110         }
  2531                                  
  2532                                  
  2533                                  ;-111     }
  2534                                  
  2535                                  @@getVariable97:
  2536                                  
  2537                                  ;-112     else errorexit("DB,DW,DD or RESB,W,D expected");
  2538                                  
  2539 000028AF E90900                   jmp @@getVariable101
  2540                                  @@getVariable86:
  2541 000028B2 68[ED28]                 push getVariable_2
  2542 000028B5 E8070C                   call errorexit
  2543 000028B8 83C402                   add  sp, 2
  2544                                  
  2545                                  ;-113 }
  2546                                  
  2547                                  @@getVariable101:
  2548                                  
  2549                                  ;-114 
  2550                                  
  2551                                  
  2552                                  ;-115 int lookCode() {// ret: CodeType, *OpCodePtr
  2553 000028BB C9                       LEAVE
  2554 000028BC C3                       ret
  2555                                  ; ENDP
  2556 000028BD 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2557 000028C6 422C572C4420657870-
  2558 000028CF 656374656400       
  2559 000028D5 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2560 000028DE 422C572C4420657870-
  2561 000028E7 656374656400       
  2562 000028ED 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2563 000028F6 6F7220524553422C57-
  2564 000028FF 2C4420657870656374-
  2565 00002908 656400             
  2566                                  
  2567                                  lookCode:  ; *** PROC ***
  2568                                  
  2569                                  ;-116     CodeType=0;
  2570                                  
  2571 0000290B 66B800000000             mov eax, 0
  2572 00002911 A2[AE01]                 mov byte [CodeType], al
  2573                                  
  2574                                  ;-117     OpCodePtr= &I_START;
  2575                                  
  2576 00002914 B8[051C]                 mov ax, I_START
  2577 00002917 A3[C701]                 mov word [OpCodePtr], ax
  2578                                  
  2579                                  ;-118     OpCodePtr++;
  2580                                  
  2581 0000291A FF06[C701]               inc  word [OpCodePtr]
  2582                                  
  2583                                  ;-119     do  {
  2584                                  
  2585                                  @@lookCode102:
  2586                                  
  2587                                  ;-120         if (eqstr(SymbolUpper, OpCodePtr))  {
  2588                                  
  2589 0000291E FF36[C701]               push word [OpCodePtr]
  2590 00002922 8D06[2E00]               lea  ax, [SymbolUpper]
  2591 00002926 50                       push ax
  2592 00002927 E85F1A                   call eqstr
  2593 0000292A 83C404                   add  sp, 4
  2594 0000292D 08C0                     or  al, al
  2595 0000292F 0F842700                 je @@lookCode103
  2596                                  
  2597                                  ;-121             while(*OpCodePtr!=0) OpCodePtr++;
  2598                                  
  2599                                  @@lookCode104:
  2600 00002933 8B1E[C701]               mov bx, [OpCodePtr]
  2601 00002937 8A07                     mov al, [bx]
  2602 00002939 B400                     mov ah, 0
  2603 0000293B 83F800                   cmp ax, 0
  2604 0000293E 0F840600                 je  @@lookCode105
  2605 00002942 FF06[C701]               inc  word [OpCodePtr]
  2606                                  
  2607                                  ;-122             OpCodePtr++; 
  2608                                  
  2609 00002946 EBEB                     jmp @@lookCode104
  2610                                  @@lookCode105:
  2611 00002948 FF06[C701]               inc  word [OpCodePtr]
  2612                                  
  2613                                  ;-123             CodeType =*OpCodePtr;
  2614                                  
  2615 0000294C 8B1E[C701]               mov bx, [OpCodePtr]
  2616 00002950 8A07                     mov al, [bx]
  2617 00002952 B400                     mov ah, 0
  2618 00002954 A2[AE01]                 mov byte [CodeType], al
  2619                                  
  2620                                  ;-124             return;
  2621                                  
  2622 00002957 E92A00                   jmp @@retn
  2623                                  
  2624                                  ;-125         }
  2625                                  
  2626                                  
  2627                                  ;-126     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2628                                  
  2629                                  @@lookCode103:
  2630                                  @@lookCode106:
  2631 0000295A 8B1E[C701]               mov bx, [OpCodePtr]
  2632 0000295E 8A07                     mov al, [bx]
  2633 00002960 B400                     mov ah, 0
  2634 00002962 3DF100                   cmp ax, 241
  2635 00002965 0F840600                 je  @@lookCode107
  2636 00002969 FF06[C701]               inc  word [OpCodePtr]
  2637                                  
  2638                                  ;-127     OpCodePtr++;
  2639                                  
  2640 0000296D EBEB                     jmp @@lookCode106
  2641                                  @@lookCode107:
  2642 0000296F FF06[C701]               inc  word [OpCodePtr]
  2643                                  
  2644                                  ;-128     } while(*OpCodePtr!=0);
  2645                                  
  2646 00002973 8B1E[C701]               mov bx, [OpCodePtr]
  2647 00002977 8A07                     mov al, [bx]
  2648 00002979 B400                     mov ah, 0
  2649 0000297B 83F800                   cmp ax, 0
  2650 0000297E 0F840200                 je  @@lookCode108
  2651 00002982 EB9A                     jmp @@lookCode102
  2652                                  @@lookCode108:
  2653                                  
  2654                                  ;-129 }
  2655                                  
  2656                                  
  2657                                  ;-130 
  2658                                  
  2659                                  
  2660                                  ;-131 int getCodeSize() {
  2661                                  
  2662                                  @@retn:
  2663 00002984 C3                       ret
  2664                                  ; ENDP
  2665                                  
  2666                                  getCodeSize:  ; *** PROC ***
  2667                                  
  2668                                  ;-132     if (TokeType ==ALNUME) {
  2669                                  
  2670 00002985 A0[AB01]                 mov al, [TokeType]
  2671 00002988 3C03                     cmp al, 3
  2672 0000298A 0F856000                 jne @@getCodeSize109
  2673                                  
  2674                                  ;-133         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2675                                  
  2676 0000298E 68[F829]                 push getCodeSize_0
  2677 00002991 8D06[2E00]               lea  ax, [SymbolUpper]
  2678 00002995 50                       push ax
  2679 00002996 E8F019                   call eqstr
  2680 00002999 83C404                   add  sp, 4
  2681 0000299C 08C0                     or  al, al
  2682 0000299E 0F840C00                 je @@getCodeSize110
  2683 000029A2 E8FBFB                   call getTokeType
  2684 000029A5 66B801000000             mov eax, 1
  2685 000029AB E94900                   jmp @@retn
  2686                                  
  2687                                  ;-134         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2688                                  
  2689                                  @@getCodeSize110:
  2690 000029AE 68[FD29]                 push getCodeSize_1
  2691 000029B1 8D06[2E00]               lea  ax, [SymbolUpper]
  2692 000029B5 50                       push ax
  2693 000029B6 E8D019                   call eqstr
  2694 000029B9 83C404                   add  sp, 4
  2695 000029BC 08C0                     or  al, al
  2696 000029BE 0F840C00                 je @@getCodeSize111
  2697 000029C2 E8DBFB                   call getTokeType
  2698 000029C5 66B802000000             mov eax, 2
  2699 000029CB E92900                   jmp @@retn
  2700                                  
  2701                                  ;-135         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2702                                  
  2703                                  @@getCodeSize111:
  2704 000029CE 68[022A]                 push getCodeSize_2
  2705 000029D1 8D06[2E00]               lea  ax, [SymbolUpper]
  2706 000029D5 50                       push ax
  2707 000029D6 E8B019                   call eqstr
  2708 000029D9 83C404                   add  sp, 4
  2709 000029DC 08C0                     or  al, al
  2710 000029DE 0F840C00                 je @@getCodeSize112
  2711 000029E2 E8BBFB                   call getTokeType
  2712 000029E5 66B803000000             mov eax, 3
  2713 000029EB E90900                   jmp @@retn
  2714                                  
  2715                                  ;-136     } 
  2716                                  
  2717                                  @@getCodeSize112:
  2718                                  
  2719                                  ;-137     return 0;
  2720                                  
  2721                                  @@getCodeSize109:
  2722 000029EE 66B800000000             mov eax, 0
  2723 000029F4 E90000                   jmp @@retn
  2724                                  
  2725                                  ;-138 }
  2726                                  
  2727                                  
  2728                                  ;-139 int isToken(char c) {
  2729                                  
  2730                                  @@retn:
  2731 000029F7 C3                       ret
  2732                                  ; ENDP
  2733 000029F8 4259544500              getCodeSize_0 db "BYTE",0
  2734 000029FD 574F524400              getCodeSize_1 db "WORD",0
  2735 00002A02 44574F524400            getCodeSize_2 db "DWORD",0
  2736                                  
  2737                                  isToken:  ; *** PROC ***
  2738                                  
  2739                                  ;-140     skipBlank();
  2740                                  
  2741                                  ;Function : isToken, Number of local variables: 1
  2742                                  ;   # type sign width line used address name   list of local variables
  2743                                  ;  200 var sign byte   139 NULL bp+4    c;
  2744 00002A08 C8000000                 ENTER  0,0
  2745 00002A0C E89101                   call skipBlank
  2746                                  
  2747                                  ;-141     if (*InputPtr == c) {
  2748                                  
  2749 00002A0F 8B1E[CE00]               mov bx, [InputPtr]
  2750 00002A13 8A07                     mov al, [bx]
  2751 00002A15 B400                     mov ah, 0
  2752 00002A17 3A4604                   cmp al, [bp+4]
  2753 00002A1A 0F850D00                 jne @@isToken113
  2754                                  
  2755                                  ;-142         InputPtr++; 
  2756                                  
  2757 00002A1E FF06[CE00]               inc  word [InputPtr]
  2758                                  
  2759                                  ;-143         return 1;
  2760                                  
  2761 00002A22 66B801000000             mov eax, 1
  2762 00002A28 E90900                   jmp @@retn
  2763                                  
  2764                                  ;-144         } 
  2765                                  
  2766                                  
  2767                                  ;-145     return 0;
  2768                                  
  2769                                  @@isToken113:
  2770 00002A2B 66B800000000             mov eax, 0
  2771 00002A31 E90000                   jmp @@retn
  2772                                  
  2773                                  ;-146 }
  2774                                  
  2775                                  
  2776                                  ;-147 int need(char c) {
  2777                                  
  2778 00002A34 C9                      @@retn: LEAVE
  2779 00002A35 C3                       ret
  2780                                  ; ENDP
  2781                                  
  2782                                  need:  ; *** PROC ***
  2783                                  
  2784                                  ;-148     if (isToken(c)) {
  2785                                  
  2786                                  ;Function : need, Number of local variables: 1
  2787                                  ;   # type sign width line used address name   list of local variables
  2788                                  ;  200 var sign byte   147 NULL bp+4    c;
  2789 00002A36 C8000000                 ENTER  0,0
  2790 00002A3A 8A4604                   mov al, byte [bp+4]
  2791 00002A3D B400                     mov ah, 0
  2792 00002A3F 50                       push ax
  2793 00002A40 E8C5FF                   call isToken
  2794 00002A43 83C402                   add  sp, 2
  2795 00002A46 08C0                     or  al, al
  2796 00002A48 0F840600                 je @@need114
  2797                                  
  2798                                  ;-149         getTokeType();
  2799                                  
  2800 00002A4C E851FB                   call getTokeType
  2801                                  
  2802                                  ;-150         return;
  2803                                  
  2804 00002A4F E91800                   jmp @@retn
  2805                                  
  2806                                  ;-151         }
  2807                                  
  2808                                  
  2809                                  ;-152     error1();
  2810                                  
  2811                                  @@need114:
  2812 00002A52 E80B0A                   call error1
  2813                                  
  2814                                  ;-153     prs(". need: ");
  2815                                  
  2816 00002A55 68[6C2A]                 push need_0
  2817 00002A58 E8A408                   call prs
  2818 00002A5B 83C402                   add  sp, 2
  2819                                  
  2820                                  ;-154     prc(c);
  2821                                  
  2822 00002A5E 8A4604                   mov al, byte [bp+4]
  2823 00002A61 B400                     mov ah, 0
  2824 00002A63 50                       push ax
  2825 00002A64 E83708                   call prc
  2826 00002A67 83C402                   add  sp, 2
  2827                                  
  2828                                  ;-155 }
  2829                                  
  2830                                  
  2831                                  ;-156 int skipRest() {
  2832                                  
  2833 00002A6A C9                      @@retn: LEAVE
  2834 00002A6B C3                       ret
  2835                                  ; ENDP
  2836 00002A6C 2E206E6565643A2000      need_0 db ". need: ",0
  2837                                  
  2838                                  skipRest:  ; *** PROC ***
  2839                                  
  2840                                  ;-157     getTokeType(); 
  2841                                  
  2842 00002A75 E828FB                   call getTokeType
  2843                                  
  2844                                  ;-158     if(TokeType)error1("extra char ignored");
  2845                                  
  2846 00002A78 A0[AB01]                 mov al, [TokeType]
  2847 00002A7B 08C0                     or  al, al
  2848 00002A7D 0F840900                 je @@skipRest115
  2849 00002A81 68[8B2A]                 push skipRest_0
  2850 00002A84 E8D909                   call error1
  2851 00002A87 83C402                   add  sp, 2
  2852                                  
  2853                                  ;-159 }
  2854                                  
  2855                                  @@skipRest115:
  2856 00002A8A C3                       ret
  2857                                  ; ENDP
  2858 00002A8B 657874726120636861-     skipRest_0 db "extra char ignored",0
  2859 00002A94 722069676E6F726564-
  2860 00002A9D 00                 
  2861                                  ;Back to main program: AS.C
  2862                                  
  2863                                  ;-6 #include "HELPER.C"
  2864                                  
  2865                                  ;Use include file: HELPER.C
  2866                                  
  2867                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2868                                  
  2869                                  
  2870                                  getLine:  ; *** PROC ***
  2871                                  
  2872                                  ;-2   unsigned int i;
  2873                                  
  2874                                  
  2875                                  ;-3   InputPtr= &InputBuf;
  2876                                  
  2877                                  ;Function : getLine, Number of local variables: 1
  2878                                  ;   # type sign width line used address name   list of local variables
  2879                                  ;  200 var unsg word     2 NULL bp-2    i;
  2880 00002A9E C8020000                 ENTER  2,0
  2881 00002AA2 B8[4F00]                 mov ax, InputBuf
  2882 00002AA5 A3[CE00]                 mov word [InputPtr], ax
  2883                                  
  2884                                  ;-4   *InputPtr=0;//if last line is empty
  2885                                  
  2886 00002AA8 66B800000000             mov eax, 0
  2887 00002AAE 8B1E[CE00]               mov  bx, [InputPtr]
  2888 00002AB2 8807                     mov  [bx], al
  2889                                  
  2890                                  ;-5   do {
  2891                                  
  2892                                  @@getLine116:
  2893                                  
  2894                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2895                                  
  2896 00002AB4 6A01                     push 1
  2897 00002AB6 FF36[9901]               push word [asm_fd]
  2898 00002ABA 8D06[A501]               lea  ax, [DOS_ByteRead]
  2899 00002ABE 50                       push ax
  2900 00002ABF E86219                   call readRL
  2901 00002AC2 83C406                   add  sp, 6
  2902 00002AC5 A3[A301]                 mov word [DOS_NoBytes], ax
  2903                                  
  2904                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2905                                  
  2906 00002AC8 A1[9F01]                 mov ax, [DOS_ERR]
  2907 00002ACB 08C0                     or  al, al
  2908 00002ACD 0F840900                 je @@getLine117
  2909 00002AD1 68[362B]                 push getLine_0
  2910 00002AD4 E8E809                   call errorexit
  2911 00002AD7 83C402                   add  sp, 2
  2912                                  
  2913                                  ;-8     if (DOS_NoBytes == 0) return;
  2914                                  
  2915                                  @@getLine117:
  2916 00002ADA A1[A301]                 mov ax, [DOS_NoBytes]
  2917 00002ADD 83F800                   cmp ax, 0
  2918 00002AE0 0F850300                 jne @@getLine118
  2919 00002AE4 E94D00                   jmp @@retn
  2920                                  
  2921                                  ;-9     *InputPtr = DOS_ByteRead;
  2922                                  
  2923                                  @@getLine118:
  2924 00002AE7 A0[A501]                 mov al, [DOS_ByteRead]
  2925 00002AEA 8B1E[CE00]               mov  bx, [InputPtr]
  2926 00002AEE 8807                     mov  [bx], al
  2927                                  
  2928                                  ;-10     InputPtr++;
  2929                                  
  2930 00002AF0 FF06[CE00]               inc  word [InputPtr]
  2931                                  
  2932                                  ;-11     i = InputPtr - &InputBuf;
  2933                                  
  2934 00002AF4 A1[CE00]                 mov ax, [InputPtr]
  2935 00002AF7 2D[4F00]                 sub ax, InputBuf
  2936 00002AFA 8946FE                   mov word [bp-2], ax
  2937                                  
  2938                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2939                                  
  2940 00002AFD 8B46FE                   mov ax, [bp-2]
  2941 00002B00 83F87F                   cmp ax, 127 ;unsigned : 0
  2942 00002B03 0F820900                 jb  @@getLine119
  2943 00002B07 68[452B]                 push getLine_1
  2944 00002B0A E8B209                   call errorexit
  2945 00002B0D 83C402                   add  sp, 2
  2946                                  
  2947                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2948                                  
  2949                                  @@getLine119:
  2950 00002B10 A0[A501]                 mov al, byte [DOS_ByteRead]
  2951 00002B13 B400                     mov ah, 0
  2952 00002B15 50                       push ax
  2953 00002B16 E84000                   call ifEOL
  2954 00002B19 83C402                   add  sp, 2
  2955 00002B1C 3C00                     cmp al, 0
  2956 00002B1E 0F850200                 jne @@getLine120
  2957 00002B22 EB90                     jmp @@getLine116
  2958                                  @@getLine120:
  2959                                  
  2960                                  ;-14   InputPtr--;
  2961                                  
  2962 00002B24 FF0E[CE00]               dec  word [InputPtr]
  2963                                  
  2964                                  ;-15   *InputPtr=0;
  2965                                  
  2966 00002B28 66B800000000             mov eax, 0
  2967 00002B2E 8B1E[CE00]               mov  bx, [InputPtr]
  2968 00002B32 8807                     mov  [bx], al
  2969                                  
  2970                                  ;-16 }
  2971                                  
  2972                                  
  2973                                  ;-17 int ifEOL(char c) {
  2974                                  
  2975 00002B34 C9                      @@retn: LEAVE
  2976 00002B35 C3                       ret
  2977                                  ; ENDP
  2978 00002B36 52656164696E672053-     getLine_0 db "Reading Source",0
  2979 00002B3F 6F7572636500       
  2980 00002B45 696E707574206C696E-     getLine_1 db "input line too long",0
  2981 00002B4E 6520746F6F206C6F6E-
  2982 00002B57 6700               
  2983                                  
  2984                                  ifEOL:  ; *** PROC ***
  2985                                  
  2986                                  ;-18   if (c == 10) return 1;
  2987                                  
  2988                                  ;Function : ifEOL, Number of local variables: 1
  2989                                  ;   # type sign width line used address name   list of local variables
  2990                                  ;  200 var sign byte    17 NULL bp+4    c;
  2991 00002B59 C8000000                 ENTER  0,0
  2992 00002B5D 8A4604                   mov al, [bp+4]
  2993 00002B60 3C0A                     cmp al, 10
  2994 00002B62 0F850900                 jne @@ifEOL121
  2995 00002B66 66B801000000             mov eax, 1
  2996 00002B6C E92F00                   jmp @@retn
  2997                                  
  2998                                  ;-19   if (c == 13) {
  2999                                  
  3000                                  @@ifEOL121:
  3001 00002B6F 8A4604                   mov al, [bp+4]
  3002 00002B72 3C0D                     cmp al, 13
  3003 00002B74 0F851D00                 jne @@ifEOL122
  3004                                  
  3005                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3006                                  
  3007 00002B78 6A01                     push 1
  3008 00002B7A FF36[9901]               push word [asm_fd]
  3009 00002B7E 8D06[A501]               lea  ax, [DOS_ByteRead]
  3010 00002B82 50                       push ax
  3011 00002B83 E89E18                   call readRL
  3012 00002B86 83C406                   add  sp, 6
  3013 00002B89 A3[A301]                 mov word [DOS_NoBytes], ax
  3014                                  
  3015                                  ;-21     return 1;}
  3016                                  
  3017 00002B8C 66B801000000             mov eax, 1
  3018 00002B92 E90900                   jmp @@retn
  3019                                  
  3020                                  ;-22   return 0;
  3021                                  
  3022                                  @@ifEOL122:
  3023 00002B95 66B800000000             mov eax, 0
  3024 00002B9B E90000                   jmp @@retn
  3025                                  
  3026                                  ;-23 }
  3027                                  
  3028                                  
  3029                                  ;-24 int skipBlank() {
  3030                                  
  3031 00002B9E C9                      @@retn: LEAVE
  3032 00002B9F C3                       ret
  3033                                  ; ENDP
  3034                                  
  3035                                  skipBlank:  ; *** PROC ***
  3036                                  
  3037                                  ;-25   skipblank1:
  3038                                  
  3039                                  @@skipblank1:
  3040                                  
  3041                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3042                                  
  3043 00002BA0 8B1E[CE00]               mov bx, [InputPtr]
  3044 00002BA4 8A07                     mov al, [bx]
  3045 00002BA6 B400                     mov ah, 0
  3046 00002BA8 83F820                   cmp ax, 32
  3047 00002BAB 0F850600                 jne @@skipBlank123
  3048 00002BAF FF06[CE00]               inc  word [InputPtr]
  3049 00002BB3 EBEB                     jmp @@skipblank1
  3050                                  
  3051                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3052                                  
  3053                                  @@skipBlank123:
  3054 00002BB5 8B1E[CE00]               mov bx, [InputPtr]
  3055 00002BB9 8A07                     mov al, [bx]
  3056 00002BBB B400                     mov ah, 0
  3057 00002BBD 83F809                   cmp ax, 9
  3058 00002BC0 0F850600                 jne @@skipBlank124
  3059 00002BC4 FF06[CE00]               inc  word [InputPtr]
  3060 00002BC8 EBD6                     jmp @@skipblank1
  3061                                  
  3062                                  ;-28 }
  3063                                  
  3064                                  @@skipBlank124:
  3065                                  
  3066                                  ;-29 int letterE(char c) {
  3067                                  
  3068 00002BCA C3                       ret
  3069                                  ; ENDP
  3070                                  
  3071                                  letterE:  ; *** PROC ***
  3072                                  
  3073                                  ;-30   if (c=='_') return 1;
  3074                                  
  3075                                  ;Function : letterE, Number of local variables: 1
  3076                                  ;   # type sign width line used address name   list of local variables
  3077                                  ;  200 var sign byte    29 NULL bp+4    c;
  3078 00002BCB C8000000                 ENTER  0,0
  3079 00002BCF 8A4604                   mov al, [bp+4]
  3080 00002BD2 3C5F                     cmp al, 95
  3081 00002BD4 0F850900                 jne @@letterE125
  3082 00002BD8 66B801000000             mov eax, 1
  3083 00002BDE E97E00                   jmp @@retn
  3084                                  
  3085                                  ;-31   if (c=='.') return 1;
  3086                                  
  3087                                  @@letterE125:
  3088 00002BE1 8A4604                   mov al, [bp+4]
  3089 00002BE4 3C2E                     cmp al, 46
  3090 00002BE6 0F850900                 jne @@letterE126
  3091 00002BEA 66B801000000             mov eax, 1
  3092 00002BF0 E96C00                   jmp @@retn
  3093                                  
  3094                                  ;-32   if (c=='?') return 1;
  3095                                  
  3096                                  @@letterE126:
  3097 00002BF3 8A4604                   mov al, [bp+4]
  3098 00002BF6 3C3F                     cmp al, 63
  3099 00002BF8 0F850900                 jne @@letterE127
  3100 00002BFC 66B801000000             mov eax, 1
  3101 00002C02 E95A00                   jmp @@retn
  3102                                  
  3103                                  ;-33   if (c=='$') return 1;
  3104                                  
  3105                                  @@letterE127:
  3106 00002C05 8A4604                   mov al, [bp+4]
  3107 00002C08 3C24                     cmp al, 36
  3108 00002C0A 0F850900                 jne @@letterE128
  3109 00002C0E 66B801000000             mov eax, 1
  3110 00002C14 E94800                   jmp @@retn
  3111                                  
  3112                                  ;-34   if (c> 'z') return 0;
  3113                                  
  3114                                  @@letterE128:
  3115 00002C17 8A4604                   mov al, [bp+4]
  3116 00002C1A 3C7A                     cmp al, 122
  3117 00002C1C 0F8E0900                 jle @@letterE129
  3118 00002C20 66B800000000             mov eax, 0
  3119 00002C26 E93600                   jmp @@retn
  3120                                  
  3121                                  ;-35   if (c< '@') return 0; // at included
  3122                                  
  3123                                  @@letterE129:
  3124 00002C29 8A4604                   mov al, [bp+4]
  3125 00002C2C 3C40                     cmp al, 64
  3126 00002C2E 0F8D0900                 jge @@letterE130
  3127 00002C32 66B800000000             mov eax, 0
  3128 00002C38 E92400                   jmp @@retn
  3129                                  
  3130                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  3131                                  
  3132                                  @@letterE130:
  3133 00002C3B 8A4604                   mov al, [bp+4]
  3134 00002C3E 3C5A                     cmp al, 90
  3135 00002C40 0F8E1200                 jle @@letterE131
  3136 00002C44 8A4604                   mov al, [bp+4]
  3137 00002C47 3C61                     cmp al, 97
  3138 00002C49 0F8D0900                 jge @@letterE132
  3139 00002C4D 66B800000000             mov eax, 0
  3140 00002C53 E90900                   jmp @@retn
  3141                                  @@letterE132:
  3142                                  
  3143                                  ;-37   return 1;
  3144                                  
  3145                                  @@letterE131:
  3146 00002C56 66B801000000             mov eax, 1
  3147 00002C5C E90000                   jmp @@retn
  3148                                  
  3149                                  ;-38 }
  3150                                  
  3151                                  
  3152                                  ;-39 int alnumE(char c) {
  3153                                  
  3154 00002C5F C9                      @@retn: LEAVE
  3155 00002C60 C3                       ret
  3156                                  ; ENDP
  3157                                  
  3158                                  alnumE:  ; *** PROC ***
  3159                                  
  3160                                  ;-40   if (digit(c)) return 1;
  3161                                  
  3162                                  ;Function : alnumE, Number of local variables: 1
  3163                                  ;   # type sign width line used address name   list of local variables
  3164                                  ;  200 var sign byte    39 NULL bp+4    c;
  3165 00002C61 C8000000                 ENTER  0,0
  3166 00002C65 8A4604                   mov al, byte [bp+4]
  3167 00002C68 B400                     mov ah, 0
  3168 00002C6A 50                       push ax
  3169 00002C6B E8E816                   call digit
  3170 00002C6E 83C402                   add  sp, 2
  3171 00002C71 08C0                     or  al, al
  3172 00002C73 0F840900                 je @@alnumE133
  3173 00002C77 66B801000000             mov eax, 1
  3174 00002C7D E92400                   jmp @@retn
  3175                                  
  3176                                  ;-41   if (letterE(c)) return 1;
  3177                                  
  3178                                  @@alnumE133:
  3179 00002C80 8A4604                   mov al, byte [bp+4]
  3180 00002C83 B400                     mov ah, 0
  3181 00002C85 50                       push ax
  3182 00002C86 E842FF                   call letterE
  3183 00002C89 83C402                   add  sp, 2
  3184 00002C8C 08C0                     or  al, al
  3185 00002C8E 0F840900                 je @@alnumE134
  3186 00002C92 66B801000000             mov eax, 1
  3187 00002C98 E90900                   jmp @@retn
  3188                                  
  3189                                  ;-42   return 0;
  3190                                  
  3191                                  @@alnumE134:
  3192 00002C9B 66B800000000             mov eax, 0
  3193 00002CA1 E90000                   jmp @@retn
  3194                                  
  3195                                  ;-43 }
  3196                                  
  3197                                  
  3198                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3199                                  
  3200 00002CA4 C9                      @@retn: LEAVE
  3201 00002CA5 C3                       ret
  3202                                  ; ENDP
  3203                                  
  3204                                  getDigit:  ; *** PROC ***
  3205                                  
  3206                                  ;-45   unsigned int CastInt;
  3207                                  
  3208                                  
  3209                                  ;-46   SymbolInt=0;
  3210                                  
  3211                                  ;Function : getDigit, Number of local variables: 2
  3212                                  ;   # type sign width line used address name   list of local variables
  3213                                  ;  200 var unsg byte    44 NULL bp+4    c
  3214                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3215 00002CA6 C8020000                 ENTER  2,0
  3216 00002CAA 66B800000000             mov eax, 0
  3217 00002CB0 A3[4D00]                 mov word [SymbolInt], ax
  3218                                  
  3219                                  ;-47   do {
  3220                                  
  3221                                  @@getDigit135:
  3222                                  
  3223                                  ;-48     c-='0';
  3224                                  
  3225 00002CB3 806E0430                 sub  byte [bp+4], 48
  3226                                  
  3227                                  ;-49     SymbolInt=SymbolInt*10;
  3228                                  
  3229 00002CB7 A1[4D00]                 mov ax, [SymbolInt]
  3230 00002CBA 66BB0A000000             mov ebx, 10
  3231 00002CC0 66F7E3                   mul ebx
  3232 00002CC3 A3[4D00]                 mov word [SymbolInt], ax
  3233                                  
  3234                                  ;-50     ax=0; CastInt=c; //cast b2w
  3235                                  
  3236 00002CC6 B80000                   mov  ax, 0
  3237 00002CC9 8A4604                   mov al, [bp+4]
  3238 00002CCC 8946FE                   mov word [bp-2], ax
  3239                                  
  3240                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3241                                  
  3242 00002CCF A1[4D00]                 mov ax, [SymbolInt]
  3243 00002CD2 0346FE                   add ax, [bp-2]
  3244 00002CD5 A3[4D00]                 mov word [SymbolInt], ax
  3245                                  
  3246                                  ;-52     InputPtr++;
  3247                                  
  3248 00002CD8 FF06[CE00]               inc  word [InputPtr]
  3249                                  
  3250                                  ;-53     c = *InputPtr;
  3251                                  
  3252 00002CDC 8B1E[CE00]               mov bx, [InputPtr]
  3253 00002CE0 8A07                     mov al, [bx]
  3254 00002CE2 B400                     mov ah, 0
  3255 00002CE4 884604                   mov byte [bp+4], al
  3256                                  
  3257                                  ;-54   } while(digit(c));
  3258                                  
  3259 00002CE7 8A4604                   mov al, byte [bp+4]
  3260 00002CEA B400                     mov ah, 0
  3261 00002CEC 50                       push ax
  3262 00002CED E86616                   call digit
  3263 00002CF0 83C402                   add  sp, 2
  3264 00002CF3 08C0                     or  al, al
  3265 00002CF5 0F840200                 je @@getDigit136
  3266 00002CF9 EBB8                     jmp @@getDigit135
  3267                                  @@getDigit136:
  3268                                  
  3269                                  ;-55 }
  3270                                  
  3271                                  
  3272                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3273 00002CFB C9                       LEAVE
  3274 00002CFC C3                       ret
  3275                                  ; ENDP
  3276                                  
  3277                                  getName:  ; *** PROC ***
  3278                                  
  3279                                  ;-57   char *p; unsigned int i;
  3280                                  
  3281                                  
  3282                                  ;-58   p = &Symbol;
  3283                                  
  3284                                  ;Function : getName, Number of local variables: 3
  3285                                  ;   # type sign width line used address name   list of local variables
  3286                                  ;  200 var unsg byte    56 NULL bp+4    c
  3287                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3288                                  ;  202 var unsg word    57 NULL bp-4    i;
  3289 00002CFD C8040000                 ENTER  4,0
  3290 00002D01 B8[0F00]                 mov ax, Symbol
  3291 00002D04 8946FE                   mov word [bp-2], ax
  3292                                  
  3293                                  ;-59   *p = c;
  3294                                  
  3295 00002D07 8A4604                   mov al, [bp+4]
  3296 00002D0A 8B5EFE                   mov  bx, [bp-2]
  3297 00002D0D 8807                     mov  [bx], al
  3298                                  
  3299                                  ;-60   p++;
  3300                                  
  3301 00002D0F FF46FE                   inc  word [bp-2]
  3302                                  
  3303                                  ;-61   while (alnumE(c)) {
  3304                                  
  3305                                  @@getName137:
  3306 00002D12 8A4604                   mov al, byte [bp+4]
  3307 00002D15 B400                     mov ah, 0
  3308 00002D17 50                       push ax
  3309 00002D18 E846FF                   call alnumE
  3310 00002D1B 83C402                   add  sp, 2
  3311 00002D1E 08C0                     or  al, al
  3312 00002D20 0F843800                 je @@getName138
  3313                                  
  3314                                  ;-62     InputPtr++;
  3315                                  
  3316 00002D24 FF06[CE00]               inc  word [InputPtr]
  3317                                  
  3318                                  ;-63     c = *InputPtr;
  3319                                  
  3320 00002D28 8B1E[CE00]               mov bx, [InputPtr]
  3321 00002D2C 8A07                     mov al, [bx]
  3322 00002D2E B400                     mov ah, 0
  3323 00002D30 884604                   mov byte [bp+4], al
  3324                                  
  3325                                  ;-64     *p = c;
  3326                                  
  3327 00002D33 8A4604                   mov al, [bp+4]
  3328 00002D36 8B5EFE                   mov  bx, [bp-2]
  3329 00002D39 8807                     mov  [bx], al
  3330                                  
  3331                                  ;-65     p++;
  3332                                  
  3333 00002D3B FF46FE                   inc  word [bp-2]
  3334                                  
  3335                                  ;-66     i = p - &Symbol;
  3336                                  
  3337 00002D3E 8B46FE                   mov ax, [bp-2]
  3338 00002D41 2D[0F00]                 sub ax, Symbol
  3339 00002D44 8946FC                   mov word [bp-4], ax
  3340                                  
  3341                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3342                                  
  3343 00002D47 8B46FC                   mov ax, [bp-4]
  3344 00002D4A 83F81F                   cmp ax, 31 ;unsigned : 0
  3345 00002D4D 0F820900                 jb  @@getName139
  3346 00002D51 68[A52D]                 push getName_0
  3347 00002D54 E86807                   call errorexit
  3348 00002D57 83C402                   add  sp, 2
  3349                                  
  3350                                  ;-68   }
  3351                                  
  3352                                  @@getName139:
  3353                                  
  3354                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3355                                  
  3356 00002D5A EBB6                     jmp @@getName137
  3357                                  @@getName138:
  3358 00002D5C 8A4604                   mov al, [bp+4]
  3359 00002D5F 3C3A                     cmp al, 58
  3360 00002D61 0F850C00                 jne @@getName140
  3361 00002D65 66B801000000             mov eax, 1
  3362 00002D6B A2[AA01]                 mov byte [isLabel], al
  3363 00002D6E E90900                   jmp @@getName141
  3364                                  @@getName140:
  3365 00002D71 66B800000000             mov eax, 0
  3366 00002D77 A2[AA01]                 mov byte [isLabel], al
  3367                                  
  3368                                  ;-70   p--;
  3369                                  
  3370                                  @@getName141:
  3371 00002D7A FF4EFE                   dec  word [bp-2]
  3372                                  
  3373                                  ;-71   *p = 0;
  3374                                  
  3375 00002D7D 66B800000000             mov eax, 0
  3376 00002D83 8B5EFE                   mov  bx, [bp-2]
  3377 00002D86 8807                     mov  [bx], al
  3378                                  
  3379                                  ;-72   strcpy(SymbolUpper, Symbol);
  3380                                  
  3381 00002D88 8D06[0F00]               lea  ax, [Symbol]
  3382 00002D8C 50                       push ax
  3383 00002D8D 8D06[2E00]               lea  ax, [SymbolUpper]
  3384 00002D91 50                       push ax
  3385 00002D92 E88815                   call strcpy
  3386 00002D95 83C404                   add  sp, 4
  3387                                  
  3388                                  ;-73   toupper(SymbolUpper);
  3389                                  
  3390 00002D98 8D06[2E00]               lea  ax, [SymbolUpper]
  3391 00002D9C 50                       push ax
  3392 00002D9D E80F15                   call toupper
  3393 00002DA0 83C402                   add  sp, 2
  3394                                  
  3395                                  ;-74 }
  3396                                  
  3397                                  
  3398                                  ;-75 int testReg() {
  3399 00002DA3 C9                       LEAVE
  3400 00002DA4 C3                       ret
  3401                                  ; ENDP
  3402 00002DA5 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3403 00002DAE 6F206C6F6E6700     
  3404                                  
  3405                                  testReg:  ; *** PROC ***
  3406                                  
  3407                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3408                                  
  3409                                  
  3410                                  ;-77   R2Type=0;
  3411                                  
  3412 00002DB5 66B800000000             mov eax, 0
  3413 00002DBB A2[B401]                 mov byte [R2Type], al
  3414                                  
  3415                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3416                                  
  3417 00002DBE 8D06[0F00]               lea  ax, [Symbol]
  3418 00002DC2 50                       push ax
  3419 00002DC3 E82C15                   call strlen
  3420 00002DC6 83C402                   add  sp, 2
  3421 00002DC9 3C02                     cmp al, 2
  3422 00002DCB 0F8D0900                 jge @@testReg142
  3423 00002DCF 66B800000000             mov eax, 0
  3424 00002DD5 E9B603                   jmp @@retn
  3425                                  
  3426                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3427                                  
  3428                                  @@testReg142:
  3429 00002DD8 8D06[0F00]               lea  ax, [Symbol]
  3430 00002DDC 50                       push ax
  3431 00002DDD E81215                   call strlen
  3432 00002DE0 83C402                   add  sp, 2
  3433 00002DE3 3C03                     cmp al, 3
  3434 00002DE5 0F8E0900                 jle @@testReg143
  3435 00002DE9 66B800000000             mov eax, 0
  3436 00002DEF E99C03                   jmp @@retn
  3437                                  
  3438                                  ;-80   R2Type=BYTE;
  3439                                  
  3440                                  @@testReg143:
  3441 00002DF2 66B801000000             mov eax, 1
  3442 00002DF8 A2[B401]                 mov byte [R2Type], al
  3443                                  
  3444                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3445                                  
  3446 00002DFB 68[8F31]                 push testReg_0
  3447 00002DFE 8D06[2E00]               lea  ax, [SymbolUpper]
  3448 00002E02 50                       push ax
  3449 00002E03 E88315                   call eqstr
  3450 00002E06 83C404                   add  sp, 4
  3451 00002E09 08C0                     or  al, al
  3452 00002E0B 0F840900                 je @@testReg144
  3453 00002E0F 66B800000000             mov eax, 0
  3454 00002E15 E97603                   jmp @@retn
  3455                                  
  3456                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3457                                  
  3458                                  @@testReg144:
  3459 00002E18 68[9231]                 push testReg_1
  3460 00002E1B 8D06[2E00]               lea  ax, [SymbolUpper]
  3461 00002E1F 50                       push ax
  3462 00002E20 E86615                   call eqstr
  3463 00002E23 83C404                   add  sp, 4
  3464 00002E26 08C0                     or  al, al
  3465 00002E28 0F840900                 je @@testReg145
  3466 00002E2C 66B801000000             mov eax, 1
  3467 00002E32 E95903                   jmp @@retn
  3468                                  
  3469                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3470                                  
  3471                                  @@testReg145:
  3472 00002E35 68[9531]                 push testReg_2
  3473 00002E38 8D06[2E00]               lea  ax, [SymbolUpper]
  3474 00002E3C 50                       push ax
  3475 00002E3D E84915                   call eqstr
  3476 00002E40 83C404                   add  sp, 4
  3477 00002E43 08C0                     or  al, al
  3478 00002E45 0F840900                 je @@testReg146
  3479 00002E49 66B802000000             mov eax, 2
  3480 00002E4F E93C03                   jmp @@retn
  3481                                  
  3482                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3483                                  
  3484                                  @@testReg146:
  3485 00002E52 68[9831]                 push testReg_3
  3486 00002E55 8D06[2E00]               lea  ax, [SymbolUpper]
  3487 00002E59 50                       push ax
  3488 00002E5A E82C15                   call eqstr
  3489 00002E5D 83C404                   add  sp, 4
  3490 00002E60 08C0                     or  al, al
  3491 00002E62 0F840900                 je @@testReg147
  3492 00002E66 66B803000000             mov eax, 3
  3493 00002E6C E91F03                   jmp @@retn
  3494                                  
  3495                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3496                                  
  3497                                  @@testReg147:
  3498 00002E6F 68[9B31]                 push testReg_4
  3499 00002E72 8D06[2E00]               lea  ax, [SymbolUpper]
  3500 00002E76 50                       push ax
  3501 00002E77 E80F15                   call eqstr
  3502 00002E7A 83C404                   add  sp, 4
  3503 00002E7D 08C0                     or  al, al
  3504 00002E7F 0F840900                 je @@testReg148
  3505 00002E83 66B804000000             mov eax, 4
  3506 00002E89 E90203                   jmp @@retn
  3507                                  
  3508                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3509                                  
  3510                                  @@testReg148:
  3511 00002E8C 68[9E31]                 push testReg_5
  3512 00002E8F 8D06[2E00]               lea  ax, [SymbolUpper]
  3513 00002E93 50                       push ax
  3514 00002E94 E8F214                   call eqstr
  3515 00002E97 83C404                   add  sp, 4
  3516 00002E9A 08C0                     or  al, al
  3517 00002E9C 0F840900                 je @@testReg149
  3518 00002EA0 66B805000000             mov eax, 5
  3519 00002EA6 E9E502                   jmp @@retn
  3520                                  
  3521                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3522                                  
  3523                                  @@testReg149:
  3524 00002EA9 68[A131]                 push testReg_6
  3525 00002EAC 8D06[2E00]               lea  ax, [SymbolUpper]
  3526 00002EB0 50                       push ax
  3527 00002EB1 E8D514                   call eqstr
  3528 00002EB4 83C404                   add  sp, 4
  3529 00002EB7 08C0                     or  al, al
  3530 00002EB9 0F840900                 je @@testReg150
  3531 00002EBD 66B806000000             mov eax, 6
  3532 00002EC3 E9C802                   jmp @@retn
  3533                                  
  3534                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3535                                  
  3536                                  @@testReg150:
  3537 00002EC6 68[A431]                 push testReg_7
  3538 00002EC9 8D06[2E00]               lea  ax, [SymbolUpper]
  3539 00002ECD 50                       push ax
  3540 00002ECE E8B814                   call eqstr
  3541 00002ED1 83C404                   add  sp, 4
  3542 00002ED4 08C0                     or  al, al
  3543 00002ED6 0F840900                 je @@testReg151
  3544 00002EDA 66B807000000             mov eax, 7
  3545 00002EE0 E9AB02                   jmp @@retn
  3546                                  
  3547                                  ;-89   R2Type=WORD;
  3548                                  
  3549                                  @@testReg151:
  3550 00002EE3 66B802000000             mov eax, 2
  3551 00002EE9 A2[B401]                 mov byte [R2Type], al
  3552                                  
  3553                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3554                                  
  3555 00002EEC 68[A731]                 push testReg_8
  3556 00002EEF 8D06[2E00]               lea  ax, [SymbolUpper]
  3557 00002EF3 50                       push ax
  3558 00002EF4 E89214                   call eqstr
  3559 00002EF7 83C404                   add  sp, 4
  3560 00002EFA 08C0                     or  al, al
  3561 00002EFC 0F840900                 je @@testReg152
  3562 00002F00 66B800000000             mov eax, 0
  3563 00002F06 E98502                   jmp @@retn
  3564                                  
  3565                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3566                                  
  3567                                  @@testReg152:
  3568 00002F09 68[AA31]                 push testReg_9
  3569 00002F0C 8D06[2E00]               lea  ax, [SymbolUpper]
  3570 00002F10 50                       push ax
  3571 00002F11 E87514                   call eqstr
  3572 00002F14 83C404                   add  sp, 4
  3573 00002F17 08C0                     or  al, al
  3574 00002F19 0F840900                 je @@testReg153
  3575 00002F1D 66B801000000             mov eax, 1
  3576 00002F23 E96802                   jmp @@retn
  3577                                  
  3578                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3579                                  
  3580                                  @@testReg153:
  3581 00002F26 68[AD31]                 push testReg_10
  3582 00002F29 8D06[2E00]               lea  ax, [SymbolUpper]
  3583 00002F2D 50                       push ax
  3584 00002F2E E85814                   call eqstr
  3585 00002F31 83C404                   add  sp, 4
  3586 00002F34 08C0                     or  al, al
  3587 00002F36 0F840900                 je @@testReg154
  3588 00002F3A 66B802000000             mov eax, 2
  3589 00002F40 E94B02                   jmp @@retn
  3590                                  
  3591                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3592                                  
  3593                                  @@testReg154:
  3594 00002F43 68[B031]                 push testReg_11
  3595 00002F46 8D06[2E00]               lea  ax, [SymbolUpper]
  3596 00002F4A 50                       push ax
  3597 00002F4B E83B14                   call eqstr
  3598 00002F4E 83C404                   add  sp, 4
  3599 00002F51 08C0                     or  al, al
  3600 00002F53 0F840900                 je @@testReg155
  3601 00002F57 66B803000000             mov eax, 3
  3602 00002F5D E92E02                   jmp @@retn
  3603                                  
  3604                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3605                                  
  3606                                  @@testReg155:
  3607 00002F60 68[B331]                 push testReg_12
  3608 00002F63 8D06[2E00]               lea  ax, [SymbolUpper]
  3609 00002F67 50                       push ax
  3610 00002F68 E81E14                   call eqstr
  3611 00002F6B 83C404                   add  sp, 4
  3612 00002F6E 08C0                     or  al, al
  3613 00002F70 0F840900                 je @@testReg156
  3614 00002F74 66B804000000             mov eax, 4
  3615 00002F7A E91102                   jmp @@retn
  3616                                  
  3617                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3618                                  
  3619                                  @@testReg156:
  3620 00002F7D 68[B631]                 push testReg_13
  3621 00002F80 8D06[2E00]               lea  ax, [SymbolUpper]
  3622 00002F84 50                       push ax
  3623 00002F85 E80114                   call eqstr
  3624 00002F88 83C404                   add  sp, 4
  3625 00002F8B 08C0                     or  al, al
  3626 00002F8D 0F840900                 je @@testReg157
  3627 00002F91 66B805000000             mov eax, 5
  3628 00002F97 E9F401                   jmp @@retn
  3629                                  
  3630                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3631                                  
  3632                                  @@testReg157:
  3633 00002F9A 68[B931]                 push testReg_14
  3634 00002F9D 8D06[2E00]               lea  ax, [SymbolUpper]
  3635 00002FA1 50                       push ax
  3636 00002FA2 E8E413                   call eqstr
  3637 00002FA5 83C404                   add  sp, 4
  3638 00002FA8 08C0                     or  al, al
  3639 00002FAA 0F840900                 je @@testReg158
  3640 00002FAE 66B806000000             mov eax, 6
  3641 00002FB4 E9D701                   jmp @@retn
  3642                                  
  3643                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3644                                  
  3645                                  @@testReg158:
  3646 00002FB7 68[BC31]                 push testReg_15
  3647 00002FBA 8D06[2E00]               lea  ax, [SymbolUpper]
  3648 00002FBE 50                       push ax
  3649 00002FBF E8C713                   call eqstr
  3650 00002FC2 83C404                   add  sp, 4
  3651 00002FC5 08C0                     or  al, al
  3652 00002FC7 0F840900                 je @@testReg159
  3653 00002FCB 66B807000000             mov eax, 7
  3654 00002FD1 E9BA01                   jmp @@retn
  3655                                  
  3656                                  ;-98   R2Type=SEGREG;
  3657                                  
  3658                                  @@testReg159:
  3659 00002FD4 66B804000000             mov eax, 4
  3660 00002FDA A2[B401]                 mov byte [R2Type], al
  3661                                  
  3662                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3663                                  
  3664 00002FDD 68[BF31]                 push testReg_16
  3665 00002FE0 8D06[2E00]               lea  ax, [SymbolUpper]
  3666 00002FE4 50                       push ax
  3667 00002FE5 E8A113                   call eqstr
  3668 00002FE8 83C404                   add  sp, 4
  3669 00002FEB 08C0                     or  al, al
  3670 00002FED 0F840900                 je @@testReg160
  3671 00002FF1 66B800000000             mov eax, 0
  3672 00002FF7 E99401                   jmp @@retn
  3673                                  
  3674                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3675                                  
  3676                                  @@testReg160:
  3677 00002FFA 68[C231]                 push testReg_17
  3678 00002FFD 8D06[2E00]               lea  ax, [SymbolUpper]
  3679 00003001 50                       push ax
  3680 00003002 E88413                   call eqstr
  3681 00003005 83C404                   add  sp, 4
  3682 00003008 08C0                     or  al, al
  3683 0000300A 0F840900                 je @@testReg161
  3684 0000300E 66B801000000             mov eax, 1
  3685 00003014 E97701                   jmp @@retn
  3686                                  
  3687                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3688                                  
  3689                                  @@testReg161:
  3690 00003017 68[C531]                 push testReg_18
  3691 0000301A 8D06[2E00]               lea  ax, [SymbolUpper]
  3692 0000301E 50                       push ax
  3693 0000301F E86713                   call eqstr
  3694 00003022 83C404                   add  sp, 4
  3695 00003025 08C0                     or  al, al
  3696 00003027 0F840900                 je @@testReg162
  3697 0000302B 66B802000000             mov eax, 2
  3698 00003031 E95A01                   jmp @@retn
  3699                                  
  3700                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3701                                  
  3702                                  @@testReg162:
  3703 00003034 68[C831]                 push testReg_19
  3704 00003037 8D06[2E00]               lea  ax, [SymbolUpper]
  3705 0000303B 50                       push ax
  3706 0000303C E84A13                   call eqstr
  3707 0000303F 83C404                   add  sp, 4
  3708 00003042 08C0                     or  al, al
  3709 00003044 0F840900                 je @@testReg163
  3710 00003048 66B803000000             mov eax, 3
  3711 0000304E E93D01                   jmp @@retn
  3712                                  
  3713                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3714                                  
  3715                                  @@testReg163:
  3716 00003051 68[CB31]                 push testReg_20
  3717 00003054 8D06[2E00]               lea  ax, [SymbolUpper]
  3718 00003058 50                       push ax
  3719 00003059 E82D13                   call eqstr
  3720 0000305C 83C404                   add  sp, 4
  3721 0000305F 08C0                     or  al, al
  3722 00003061 0F840900                 je @@testReg164
  3723 00003065 66B804000000             mov eax, 4
  3724 0000306B E92001                   jmp @@retn
  3725                                  
  3726                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3727                                  
  3728                                  @@testReg164:
  3729 0000306E 68[CE31]                 push testReg_21
  3730 00003071 8D06[2E00]               lea  ax, [SymbolUpper]
  3731 00003075 50                       push ax
  3732 00003076 E81013                   call eqstr
  3733 00003079 83C404                   add  sp, 4
  3734 0000307C 08C0                     or  al, al
  3735 0000307E 0F840900                 je @@testReg165
  3736 00003082 66B805000000             mov eax, 5
  3737 00003088 E90301                   jmp @@retn
  3738                                  
  3739                                  ;-105   R2Type=DWORD;                         
  3740                                  
  3741                                  @@testReg165:
  3742 0000308B 66B803000000             mov eax, 3
  3743 00003091 A2[B401]                 mov byte [R2Type], al
  3744                                  
  3745                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3746                                  
  3747 00003094 68[D131]                 push testReg_22
  3748 00003097 8D06[2E00]               lea  ax, [SymbolUpper]
  3749 0000309B 50                       push ax
  3750 0000309C E8EA12                   call eqstr
  3751 0000309F 83C404                   add  sp, 4
  3752 000030A2 08C0                     or  al, al
  3753 000030A4 0F840900                 je @@testReg166
  3754 000030A8 66B800000000             mov eax, 0
  3755 000030AE E9DD00                   jmp @@retn
  3756                                  
  3757                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3758                                  
  3759                                  @@testReg166:
  3760 000030B1 68[D531]                 push testReg_23
  3761 000030B4 8D06[2E00]               lea  ax, [SymbolUpper]
  3762 000030B8 50                       push ax
  3763 000030B9 E8CD12                   call eqstr
  3764 000030BC 83C404                   add  sp, 4
  3765 000030BF 08C0                     or  al, al
  3766 000030C1 0F840900                 je @@testReg167
  3767 000030C5 66B801000000             mov eax, 1
  3768 000030CB E9C000                   jmp @@retn
  3769                                  
  3770                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3771                                  
  3772                                  @@testReg167:
  3773 000030CE 68[D931]                 push testReg_24
  3774 000030D1 8D06[2E00]               lea  ax, [SymbolUpper]
  3775 000030D5 50                       push ax
  3776 000030D6 E8B012                   call eqstr
  3777 000030D9 83C404                   add  sp, 4
  3778 000030DC 08C0                     or  al, al
  3779 000030DE 0F840900                 je @@testReg168
  3780 000030E2 66B802000000             mov eax, 2
  3781 000030E8 E9A300                   jmp @@retn
  3782                                  
  3783                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3784                                  
  3785                                  @@testReg168:
  3786 000030EB 68[DD31]                 push testReg_25
  3787 000030EE 8D06[2E00]               lea  ax, [SymbolUpper]
  3788 000030F2 50                       push ax
  3789 000030F3 E89312                   call eqstr
  3790 000030F6 83C404                   add  sp, 4
  3791 000030F9 08C0                     or  al, al
  3792 000030FB 0F840900                 je @@testReg169
  3793 000030FF 66B803000000             mov eax, 3
  3794 00003105 E98600                   jmp @@retn
  3795                                  
  3796                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3797                                  
  3798                                  @@testReg169:
  3799 00003108 68[E131]                 push testReg_26
  3800 0000310B 8D06[2E00]               lea  ax, [SymbolUpper]
  3801 0000310F 50                       push ax
  3802 00003110 E87612                   call eqstr
  3803 00003113 83C404                   add  sp, 4
  3804 00003116 08C0                     or  al, al
  3805 00003118 0F840900                 je @@testReg170
  3806 0000311C 66B804000000             mov eax, 4
  3807 00003122 E96900                   jmp @@retn
  3808                                  
  3809                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3810                                  
  3811                                  @@testReg170:
  3812 00003125 68[E531]                 push testReg_27
  3813 00003128 8D06[2E00]               lea  ax, [SymbolUpper]
  3814 0000312C 50                       push ax
  3815 0000312D E85912                   call eqstr
  3816 00003130 83C404                   add  sp, 4
  3817 00003133 08C0                     or  al, al
  3818 00003135 0F840900                 je @@testReg171
  3819 00003139 66B805000000             mov eax, 5
  3820 0000313F E94C00                   jmp @@retn
  3821                                  
  3822                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3823                                  
  3824                                  @@testReg171:
  3825 00003142 68[E931]                 push testReg_28
  3826 00003145 8D06[2E00]               lea  ax, [SymbolUpper]
  3827 00003149 50                       push ax
  3828 0000314A E83C12                   call eqstr
  3829 0000314D 83C404                   add  sp, 4
  3830 00003150 08C0                     or  al, al
  3831 00003152 0F840900                 je @@testReg172
  3832 00003156 66B806000000             mov eax, 6
  3833 0000315C E92F00                   jmp @@retn
  3834                                  
  3835                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3836                                  
  3837                                  @@testReg172:
  3838 0000315F 68[ED31]                 push testReg_29
  3839 00003162 8D06[2E00]               lea  ax, [SymbolUpper]
  3840 00003166 50                       push ax
  3841 00003167 E81F12                   call eqstr
  3842 0000316A 83C404                   add  sp, 4
  3843 0000316D 08C0                     or  al, al
  3844 0000316F 0F840900                 je @@testReg173
  3845 00003173 66B807000000             mov eax, 7
  3846 00003179 E91200                   jmp @@retn
  3847                                  
  3848                                  ;-114   R2Type=0; return 0;
  3849                                  
  3850                                  @@testReg173:
  3851 0000317C 66B800000000             mov eax, 0
  3852 00003182 A2[B401]                 mov byte [R2Type], al
  3853 00003185 66B800000000             mov eax, 0
  3854 0000318B E90000                   jmp @@retn
  3855                                  
  3856                                  ;-115 }
  3857                                  
  3858                                  @@retn:
  3859 0000318E C3                       ret
  3860                                  ; ENDP
  3861 0000318F 414C00                  testReg_0 db "AL",0
  3862 00003192 434C00                  testReg_1 db "CL",0
  3863 00003195 444C00                  testReg_2 db "DL",0
  3864 00003198 424C00                  testReg_3 db "BL",0
  3865 0000319B 414800                  testReg_4 db "AH",0
  3866 0000319E 434800                  testReg_5 db "CH",0
  3867 000031A1 444800                  testReg_6 db "DH",0
  3868 000031A4 424800                  testReg_7 db "BH",0
  3869 000031A7 415800                  testReg_8 db "AX",0
  3870 000031AA 435800                  testReg_9 db "CX",0
  3871 000031AD 445800                  testReg_10 db "DX",0
  3872 000031B0 425800                  testReg_11 db "BX",0
  3873 000031B3 535000                  testReg_12 db "SP",0
  3874 000031B6 425000                  testReg_13 db "BP",0
  3875 000031B9 534900                  testReg_14 db "SI",0
  3876 000031BC 444900                  testReg_15 db "DI",0
  3877 000031BF 455300                  testReg_16 db "ES",0
  3878 000031C2 435300                  testReg_17 db "CS",0
  3879 000031C5 535300                  testReg_18 db "SS",0
  3880 000031C8 445300                  testReg_19 db "DS",0
  3881 000031CB 465300                  testReg_20 db "FS",0
  3882 000031CE 475300                  testReg_21 db "GS",0
  3883 000031D1 45415800                testReg_22 db "EAX",0
  3884 000031D5 45435800                testReg_23 db "ECX",0
  3885 000031D9 45445800                testReg_24 db "EDX",0
  3886 000031DD 45425800                testReg_25 db "EBX",0
  3887 000031E1 45535000                testReg_26 db "ESP",0
  3888 000031E5 45425000                testReg_27 db "EBP",0
  3889 000031E9 45534900                testReg_28 db "ESI",0
  3890 000031ED 45444900                testReg_29 db "EDI",0
  3891                                  ;Back to main program: AS.C
  3892                                  
  3893                                  ;-7 #include "OUTPUT.C"
  3894                                  
  3895                                  ;Use include file: OUTPUT.C
  3896                                  
  3897                                  ;-1 int printLine() { 
  3898                                  
  3899                                  
  3900                                  printLine:  ; *** PROC ***
  3901                                  
  3902                                  ;-2     int i; char c;
  3903                                  
  3904                                  
  3905                                  ;-3     prs("\n"); 
  3906                                  
  3907                                  ;Function : printLine, Number of local variables: 2
  3908                                  ;   # type sign width line used address name   list of local variables
  3909                                  ;  200 var sign word     2 NULL bp-2    i
  3910                                  ;  201 var sign byte     2 NULL bp-4    c;
  3911 000031F1 C8040000                 ENTER  4,0
  3912 000031F5 68[8632]                 push printLine_0
  3913 000031F8 E80401                   call prs
  3914 000031FB 83C402                   add  sp, 2
  3915                                  
  3916                                  ;-4     printhex16(PCStart);
  3917                                  
  3918 000031FE FF36[A801]               push word [PCStart]
  3919 00003202 E8EF01                   call printhex16
  3920 00003205 83C402                   add  sp, 2
  3921                                  
  3922                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  3923                                  
  3924 00003208 A1[C501]                 mov ax, [OpPrintIndex]
  3925 0000320B 83F800                   cmp ax, 0
  3926 0000320E 0F850C00                 jne @@printLine174
  3927 00003212 68[8932]                 push printLine_1
  3928 00003215 E8E700                   call prs
  3929 00003218 83C402                   add  sp, 2
  3930                                  
  3931                                  ;-6     else {
  3932                                  
  3933 0000321B E94F00                   jmp @@printLine175
  3934                                  @@printLine174:
  3935                                  
  3936                                  ;-7 //        prc(' ');
  3937                                  
  3938                                  
  3939                                  ;-8         i=0;
  3940                                  
  3941 0000321E 66B800000000             mov eax, 0
  3942 00003224 8946FE                   mov word [bp-2], ax
  3943                                  
  3944                                  ;-9         do {
  3945                                  
  3946                                  @@printLine176:
  3947                                  
  3948                                  ;-10             c=OpPos[i];
  3949                                  
  3950 00003227 8B5EFE                   mov bx, [bp-2]
  3951 0000322A 8A87[C001]               mov al, [OpPos + bx]
  3952 0000322E 8846FC                   mov byte [bp-4], al
  3953                                  
  3954                                  ;-11             prc(' ');
  3955                                  
  3956 00003231 6A20                     push 32
  3957 00003233 E86800                   call prc
  3958 00003236 83C402                   add  sp, 2
  3959                                  
  3960                                  ;-12             printhex8a(c); 
  3961                                  
  3962 00003239 8A46FC                   mov al, byte [bp-4]
  3963 0000323C B400                     mov ah, 0
  3964 0000323E 50                       push ax
  3965 0000323F E86001                   call printhex8a
  3966 00003242 83C402                   add  sp, 2
  3967                                  
  3968                                  ;-13             i++;
  3969                                  
  3970 00003245 FF46FE                   inc  word [bp-2]
  3971                                  
  3972                                  ;-14         } while (i < OpPrintIndex);
  3973                                  
  3974 00003248 8B46FE                   mov ax, [bp-2]
  3975 0000324B 3B06[C501]               cmp ax, [OpPrintIndex]
  3976 0000324F 0F8D0200                 jge @@printLine177
  3977 00003253 EBD2                     jmp @@printLine176
  3978                                  @@printLine177:
  3979                                  
  3980                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  3981                                  
  3982                                  @@printLine178:
  3983 00003255 8B46FE                   mov ax, [bp-2]
  3984 00003258 83F805                   cmp ax, 5
  3985 0000325B 0F8D0E00                 jge @@printLine179
  3986                                  
  3987                                  ;-16             prs("   ");
  3988                                  
  3989 0000325F 68[9A32]                 push printLine_2
  3990 00003262 E89A00                   call prs
  3991 00003265 83C402                   add  sp, 2
  3992                                  
  3993                                  ;-17             i++;
  3994                                  
  3995 00003268 FF46FE                   inc  word [bp-2]
  3996                                  
  3997                                  ;-18         }
  3998                                  
  3999                                  
  4000                                  ;-19     }
  4001                                  
  4002 0000326B EBE8                     jmp @@printLine178
  4003                                  @@printLine179:
  4004                                  
  4005                                  ;-20     prc(PrintRA);
  4006                                  
  4007                                  @@printLine175:
  4008 0000326D A0[C901]                 mov al, byte [PrintRA]
  4009 00003270 B400                     mov ah, 0
  4010 00003272 50                       push ax
  4011 00003273 E82800                   call prc
  4012 00003276 83C402                   add  sp, 2
  4013                                  
  4014                                  ;-21     prscomment(InputBuf);
  4015                                  
  4016 00003279 8D06[4F00]               lea  ax, [InputBuf]
  4017 0000327D 50                       push ax
  4018 0000327E E85000                   call prscomment
  4019 00003281 83C402                   add  sp, 2
  4020                                  
  4021                                  ;-22 }
  4022                                  
  4023                                  
  4024                                  ;-23 int prc(unsigned char c) {//print char 
  4025 00003284 C9                       LEAVE
  4026 00003285 C3                       ret
  4027                                  ; ENDP
  4028 00003286 5C6E00                  printLine_0 db "\n",0
  4029 00003289 202020202020202020-     printLine_1 db "                ",0
  4030 00003292 2020202020202000   
  4031 0000329A 20202000                printLine_2 db "   ",0
  4032                                  
  4033                                  prc:  ; *** PROC ***
  4034                                  
  4035                                  ;-24     if (LIST) { 
  4036                                  
  4037                                  ;Function : prc, Number of local variables: 1
  4038                                  ;   # type sign width line used address name   list of local variables
  4039                                  ;  200 var unsg byte    23 NULL bp+4    c;
  4040 0000329E C8000000                 ENTER  0,0
  4041 000032A2 A0[0E00]                 mov al, [LIST]
  4042 000032A5 08C0                     or  al, al
  4043 000032A7 0F841400                 je @@prc180
  4044                                  
  4045                                  ;-25         if ( _ c==10) {
  4046                                  
  4047 000032AB 807E040A                cmp byte [bp+4], 10
  4048 000032AF 0F850600                 jne @@prc181
  4049                                  
  4050                                  ;-26             ax=13; 
  4051                                  
  4052 000032B3 B80D00                   mov  ax, 13
  4053                                  
  4054                                  ;-27             writetty(); 
  4055                                  
  4056 000032B6 E8C00F                   call writetty
  4057                                  
  4058                                  ;-28             }
  4059                                  
  4060                                  
  4061                                  ;-29         al=c; 
  4062                                  
  4063                                  @@prc181:
  4064 000032B9 8A4604                   mov  al, [bp+4]
  4065                                  
  4066                                  ;-30         writetty(); 
  4067                                  
  4068 000032BC E8BA0F                   call writetty
  4069                                  
  4070                                  ;-31         }
  4071                                  
  4072                                  
  4073                                  ;-32     fputcR(c,lst_fd); 
  4074                                  
  4075                                  @@prc180:
  4076 000032BF FF36[9B01]               push word [lst_fd]
  4077 000032C3 8A4604                   mov al, byte [bp+4]
  4078 000032C6 B400                     mov ah, 0
  4079 000032C8 50                       push ax
  4080 000032C9 E86D11                   call fputcR
  4081 000032CC 83C404                   add  sp, 4
  4082                                  
  4083                                  ;-33 }
  4084                                  
  4085                                  
  4086                                  ;-34 
  4087                                  
  4088                                  
  4089                                  ;-35 int prscomment(unsigned char *s) {
  4090 000032CF C9                       LEAVE
  4091 000032D0 C3                       ret
  4092                                  ; ENDP
  4093                                  
  4094                                  prscomment:  ; *** PROC ***
  4095                                  
  4096                                  ;-36     unsigned char c;
  4097                                  
  4098                                  
  4099                                  ;-37     while (*s){
  4100                                  
  4101                                  ;Function : prscomment, Number of local variables: 2
  4102                                  ;   # type sign width line used address name   list of local variables
  4103                                  ;  200 ptr unsg byte    35 NULL bp+4    s
  4104                                  ;  201 var unsg byte    36 NULL bp-2    c;
  4105 000032D1 C8020000                 ENTER  2,0
  4106                                  @@prscomment182:
  4107 000032D5 8B5E04                   mov bx, [bp+4]
  4108 000032D8 8A07                     mov al, [bx]
  4109 000032DA B400                     mov ah, 0
  4110 000032DC 08C0                     or  al, al
  4111 000032DE 0F841B00                 je @@prscomment183
  4112                                  
  4113                                  ;-38         c=*s;
  4114                                  
  4115 000032E2 8B5E04                   mov bx, [bp+4]
  4116 000032E5 8A07                     mov al, [bx]
  4117 000032E7 B400                     mov ah, 0
  4118 000032E9 8846FE                   mov byte [bp-2], al
  4119                                  
  4120                                  ;-39         prc(c);
  4121                                  
  4122 000032EC 8A46FE                   mov al, byte [bp-2]
  4123 000032EF B400                     mov ah, 0
  4124 000032F1 50                       push ax
  4125 000032F2 E8A9FF                   call prc
  4126 000032F5 83C402                   add  sp, 2
  4127                                  
  4128                                  ;-40         s++;
  4129                                  
  4130 000032F8 FF4604                   inc  word [bp+4]
  4131                                  
  4132                                  ;-41     }
  4133                                  
  4134                                  
  4135                                  ;-42 }
  4136                                  
  4137 000032FB EBD8                     jmp @@prscomment182
  4138                                  @@prscomment183:
  4139                                  
  4140                                  ;-43 int prs(unsigned char *s) {
  4141 000032FD C9                       LEAVE
  4142 000032FE C3                       ret
  4143                                  ; ENDP
  4144                                  
  4145                                  prs:  ; *** PROC ***
  4146                                  
  4147                                  ;-44     unsigned char c; 
  4148                                  
  4149                                  
  4150                                  ;-45     int com; 
  4151                                  
  4152                                  
  4153                                  ;-46     com=0;
  4154                                  
  4155                                  ;Function : prs, Number of local variables: 3
  4156                                  ;   # type sign width line used address name   list of local variables
  4157                                  ;  200 ptr unsg byte    43 NULL bp+4    s
  4158                                  ;  201 var unsg byte    44 NULL bp-2    c
  4159                                  ;  202 var sign word    45 NULL bp-4    com;
  4160 000032FF C8040000                 ENTER  4,0
  4161 00003303 66B800000000             mov eax, 0
  4162 00003309 8946FC                   mov word [bp-4], ax
  4163                                  
  4164                                  ;-47     while (*s) { 
  4165                                  
  4166                                  @@prs184:
  4167 0000330C 8B5E04                   mov bx, [bp+4]
  4168 0000330F 8A07                     mov al, [bx]
  4169 00003311 B400                     mov ah, 0
  4170 00003313 08C0                     or  al, al
  4171 00003315 0F848700                 je @@prs185
  4172                                  
  4173                                  ;-48         c=*s; 
  4174                                  
  4175 00003319 8B5E04                   mov bx, [bp+4]
  4176 0000331C 8A07                     mov al, [bx]
  4177 0000331E B400                     mov ah, 0
  4178 00003320 8846FE                   mov byte [bp-2], al
  4179                                  
  4180                                  ;-49         if (c==34) {
  4181                                  
  4182 00003323 8A46FE                   mov al, [bp-2]
  4183 00003326 3C22                     cmp al, 34
  4184 00003328 0F851E00                 jne @@prs186
  4185                                  
  4186                                  ;-50             if (com) com=0; 
  4187                                  
  4188 0000332C 8B46FC                   mov ax, [bp-4]
  4189 0000332F 08C0                     or  al, al
  4190 00003331 0F840C00                 je @@prs187
  4191 00003335 66B800000000             mov eax, 0
  4192 0000333B 8946FC                   mov word [bp-4], ax
  4193                                  
  4194                                  ;-51                 else com=1;  
  4195                                  
  4196 0000333E E90900                   jmp @@prs188
  4197                                  @@prs187:
  4198 00003341 66B801000000             mov eax, 1
  4199 00003347 8946FC                   mov word [bp-4], ax
  4200                                  
  4201                                  ;-52         }
  4202                                  
  4203                                  @@prs188:
  4204                                  
  4205                                  ;-53         if (c==92) { 
  4206                                  
  4207                                  @@prs186:
  4208 0000334A 8A46FE                   mov al, [bp-2]
  4209 0000334D 3C5C                     cmp al, 92
  4210 0000334F 0F853B00                 jne @@prs189
  4211                                  
  4212                                  ;-54             if (com==0) { 
  4213                                  
  4214 00003353 8B46FC                   mov ax, [bp-4]
  4215 00003356 83F800                   cmp ax, 0
  4216 00003359 0F853100                 jne @@prs190
  4217                                  
  4218                                  ;-55                 s++; 
  4219                                  
  4220 0000335D FF4604                   inc  word [bp+4]
  4221                                  
  4222                                  ;-56                 c=*s;
  4223                                  
  4224 00003360 8B5E04                   mov bx, [bp+4]
  4225 00003363 8A07                     mov al, [bx]
  4226 00003365 B400                     mov ah, 0
  4227 00003367 8846FE                   mov byte [bp-2], al
  4228                                  
  4229                                  ;-57                 if (c=='n') c=10; 
  4230                                  
  4231 0000336A 8A46FE                   mov al, [bp-2]
  4232 0000336D 3C6E                     cmp al, 110
  4233 0000336F 0F850900                 jne @@prs191
  4234 00003373 66B80A000000             mov eax, 10
  4235 00003379 8846FE                   mov byte [bp-2], al
  4236                                  
  4237                                  ;-58                 if (c=='t') c= 9; 
  4238                                  
  4239                                  @@prs191:
  4240 0000337C 8A46FE                   mov al, [bp-2]
  4241 0000337F 3C74                     cmp al, 116
  4242 00003381 0F850900                 jne @@prs192
  4243 00003385 66B809000000             mov eax, 9
  4244 0000338B 8846FE                   mov byte [bp-2], al
  4245                                  
  4246                                  ;-59             } 
  4247                                  
  4248                                  @@prs192:
  4249                                  
  4250                                  ;-60         } 
  4251                                  
  4252                                  @@prs190:
  4253                                  
  4254                                  ;-61         prc(c); 
  4255                                  
  4256                                  @@prs189:
  4257 0000338E 8A46FE                   mov al, byte [bp-2]
  4258 00003391 B400                     mov ah, 0
  4259 00003393 50                       push ax
  4260 00003394 E807FF                   call prc
  4261 00003397 83C402                   add  sp, 2
  4262                                  
  4263                                  ;-62         s++;  
  4264                                  
  4265 0000339A FF4604                   inc  word [bp+4]
  4266                                  
  4267                                  ;-63     }
  4268                                  
  4269                                  
  4270                                  ;-64 }
  4271                                  
  4272 0000339D E96CFF                   jmp @@prs184
  4273                                  @@prs185:
  4274                                  
  4275                                  ;-65 int printhex8a(unsigned char c) { 
  4276 000033A0 C9                       LEAVE
  4277 000033A1 C3                       ret
  4278                                  ; ENDP
  4279                                  
  4280                                  printhex8a:  ; *** PROC ***
  4281                                  
  4282                                  ;-66     unsigned char nib;
  4283                                  
  4284                                  
  4285                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4286                                  
  4287                                  ;Function : printhex8a, Number of local variables: 2
  4288                                  ;   # type sign width line used address name   list of local variables
  4289                                  ;  200 var unsg byte    65 NULL bp+4    c
  4290                                  ;  201 var unsg byte    66 NULL bp-2    nib;
  4291 000033A2 C8020000                 ENTER  2,0
  4292 000033A6 8A4604                   mov al, [bp+4]
  4293 000033A9 C0E804                   shr al, 4
  4294 000033AC 8846FE                   mov byte [bp-2], al
  4295 000033AF 8A46FE                   mov al, byte [bp-2]
  4296 000033B2 B400                     mov ah, 0
  4297 000033B4 50                       push ax
  4298 000033B5 E81900                   call printhex4
  4299 000033B8 83C402                   add  sp, 2
  4300                                  
  4301                                  ;-68     nib = c & 15; printhex4(nib);                    
  4302                                  
  4303 000033BB 8A4604                   mov al, [bp+4]
  4304 000033BE 240F                     and al, 15
  4305 000033C0 8846FE                   mov byte [bp-2], al
  4306 000033C3 8A46FE                   mov al, byte [bp-2]
  4307 000033C6 B400                     mov ah, 0
  4308 000033C8 50                       push ax
  4309 000033C9 E80500                   call printhex4
  4310 000033CC 83C402                   add  sp, 2
  4311                                  
  4312                                  ;-69 } 
  4313                                  
  4314                                  
  4315                                  ;-70 int printhex4(unsigned char c) {
  4316 000033CF C9                       LEAVE
  4317 000033D0 C3                       ret
  4318                                  ; ENDP
  4319                                  
  4320                                  printhex4:  ; *** PROC ***
  4321                                  
  4322                                  ;-71     c += 48; 
  4323                                  
  4324                                  ;Function : printhex4, Number of local variables: 1
  4325                                  ;   # type sign width line used address name   list of local variables
  4326                                  ;  200 var unsg byte    70 NULL bp+4    c;
  4327 000033D1 C8000000                 ENTER  0,0
  4328 000033D5 80460430                 add  byte [bp+4], 48
  4329                                  
  4330                                  ;-72     if (c > 57) c += 7; 
  4331                                  
  4332 000033D9 8A4604                   mov al, [bp+4]
  4333 000033DC 3C39                     cmp al, 57
  4334 000033DE 0F8E0400                 jle @@printhex4193
  4335 000033E2 80460407                 add  byte [bp+4], 7
  4336                                  
  4337                                  ;-73     prc(c);      
  4338                                  
  4339                                  @@printhex4193:
  4340 000033E6 8A4604                   mov al, byte [bp+4]
  4341 000033E9 B400                     mov ah, 0
  4342 000033EB 50                       push ax
  4343 000033EC E8AFFE                   call prc
  4344 000033EF 83C402                   add  sp, 2
  4345                                  
  4346                                  ;-74 }
  4347                                  
  4348                                  
  4349                                  ;-75 int printhex16(unsigned int i) {
  4350 000033F2 C9                       LEAVE
  4351 000033F3 C3                       ret
  4352                                  ; ENDP
  4353                                  
  4354                                  printhex16:  ; *** PROC ***
  4355                                  
  4356                                  ;-76     unsigned int half;
  4357                                  
  4358                                  
  4359                                  ;-77     half = i >>  8; printhex8a(half); 
  4360                                  
  4361                                  ;Function : printhex16, Number of local variables: 2
  4362                                  ;   # type sign width line used address name   list of local variables
  4363                                  ;  200 var unsg word    75 NULL bp+4    i
  4364                                  ;  201 var unsg word    76 NULL bp-2    half;
  4365 000033F4 C8020000                 ENTER  2,0
  4366 000033F8 8B4604                   mov ax, [bp+4]
  4367 000033FB C1E808                   shr ax, 8
  4368 000033FE 8946FE                   mov word [bp-2], ax
  4369 00003401 FF76FE                   push word [bp-2]
  4370 00003404 E89BFF                   call printhex8a
  4371 00003407 83C402                   add  sp, 2
  4372                                  
  4373                                  ;-78     half = i & 255; printhex8a(half);
  4374                                  
  4375 0000340A 8B4604                   mov ax, [bp+4]
  4376 0000340D 25FF00                   and ax, 255
  4377 00003410 8946FE                   mov word [bp-2], ax
  4378 00003413 FF76FE                   push word [bp-2]
  4379 00003416 E889FF                   call printhex8a
  4380 00003419 83C402                   add  sp, 2
  4381                                  
  4382                                  ;-79 }
  4383                                  
  4384                                  
  4385                                  ;-80 int printIntU(unsigned int n) { 
  4386 0000341C C9                       LEAVE
  4387 0000341D C3                       ret
  4388                                  ; ENDP
  4389                                  
  4390                                  printIntU:  ; *** PROC ***
  4391                                  
  4392                                  ;-81     unsigned int e;
  4393                                  
  4394                                  
  4395                                  ;-82     if ( _ n >= 10) {  
  4396                                  
  4397                                  ;Function : printIntU, Number of local variables: 2
  4398                                  ;   # type sign width line used address name   list of local variables
  4399                                  ;  200 var unsg word    80 NULL bp+4    n
  4400                                  ;  201 var unsg word    81 NULL bp-2    e;
  4401 0000341E C8020000                 ENTER  2,0
  4402 00003422 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4403 00003426 0F821700                 jb  @@printIntU194
  4404                                  
  4405                                  ;-83         e=n/10; //DIV
  4406                                  
  4407 0000342A 8B4604                   mov ax, [bp+4]
  4408 0000342D BB0A00                   mov bx, 10
  4409 00003430 BA0000                   mov dx, 0
  4410 00003433 F7F3                     div bx
  4411 00003435 8946FE                   mov word [bp-2], ax
  4412                                  
  4413                                  ;-84         printIntU(e); 
  4414                                  
  4415 00003438 FF76FE                   push word [bp-2]
  4416 0000343B E8E0FF                   call printIntU
  4417 0000343E 83C402                   add  sp, 2
  4418                                  
  4419                                  ;-85     }
  4420                                  
  4421                                  
  4422                                  ;-86     n = n % 10; //unsigned mod
  4423                                  
  4424                                  @@printIntU194:
  4425 00003441 8B4604                   mov ax, [bp+4]
  4426 00003444 BB0A00                   mov bx, 10
  4427 00003447 BA0000                   mov dx, 0
  4428 0000344A F7F3                     div bx
  4429 0000344C 89D0                     mov ax, dx
  4430 0000344E 894604                   mov word [bp+4], ax
  4431                                  
  4432                                  ;-87     n += '0'; 
  4433                                  
  4434 00003451 83460430                 add  word [bp+4], 48
  4435                                  
  4436                                  ;-88     prc(n);
  4437                                  
  4438 00003455 FF7604                   push word [bp+4]
  4439 00003458 E843FE                   call prc
  4440 0000345B 83C402                   add  sp, 2
  4441                                  
  4442                                  ;-89 }
  4443                                  
  4444                                  
  4445                                  ;-90 
  4446                                  
  4447                                  
  4448                                  ;-91 int error1(char *s) { 
  4449 0000345E C9                       LEAVE
  4450 0000345F C3                       ret
  4451                                  ; ENDP
  4452                                  
  4453                                  error1:  ; *** PROC ***
  4454                                  
  4455                                  ;-92     LIST=1; 
  4456                                  
  4457                                  ;Function : error1, Number of local variables: 1
  4458                                  ;   # type sign width line used address name   list of local variables
  4459                                  ;  200 ptr sign byte    91 NULL bp+4    s;
  4460 00003460 C8000000                 ENTER  0,0
  4461 00003464 66B801000000             mov eax, 1
  4462 0000346A A2[0E00]                 mov byte [LIST], al
  4463                                  
  4464                                  ;-93     ErrorCount++;
  4465                                  
  4466 0000346D FF06[A101]               inc  word [ErrorCount]
  4467                                  
  4468                                  ;-94     prs("\n;***** next line ERROR: "); 
  4469                                  
  4470 00003471 68[9934]                 push error1_0
  4471 00003474 E888FE                   call prs
  4472 00003477 83C402                   add  sp, 2
  4473                                  
  4474                                  ;-95     prs(s);
  4475                                  
  4476 0000347A FF7604                   push word [bp+4]
  4477 0000347D E87FFE                   call prs
  4478 00003480 83C402                   add  sp, 2
  4479                                  
  4480                                  ;-96     prs(", Symbol: "); 
  4481                                  
  4482 00003483 68[B434]                 push error1_1
  4483 00003486 E876FE                   call prs
  4484 00003489 83C402                   add  sp, 2
  4485                                  
  4486                                  ;-97     prs(Symbol);
  4487                                  
  4488 0000348C 8D06[0F00]               lea  ax, [Symbol]
  4489 00003490 50                       push ax
  4490 00003491 E86BFE                   call prs
  4491 00003494 83C402                   add  sp, 2
  4492                                  
  4493                                  ;-98 }
  4494                                  
  4495                                  
  4496                                  ;-99 int errorexit(char *s) { 
  4497 00003497 C9                       LEAVE
  4498 00003498 C3                       ret
  4499                                  ; ENDP
  4500 00003499 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4501 000034A2 6E657874206C696E65-
  4502 000034AB 204552524F523A2000 
  4503 000034B4 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4504 000034BD 2000               
  4505                                  
  4506                                  errorexit:  ; *** PROC ***
  4507                                  
  4508                                  ;-100     error1(s); 
  4509                                  
  4510                                  ;Function : errorexit, Number of local variables: 1
  4511                                  ;   # type sign width line used address name   list of local variables
  4512                                  ;  200 ptr sign byte    99 NULL bp+4    s;
  4513 000034BF C8000000                 ENTER  0,0
  4514 000034C3 FF7604                   push word [bp+4]
  4515 000034C6 E897FF                   call error1
  4516 000034C9 83C402                   add  sp, 2
  4517                                  
  4518                                  ;-101     end1(1);
  4519                                  
  4520 000034CC 6A01                     push 1
  4521 000034CE E8C904                   call end1
  4522 000034D1 83C402                   add  sp, 2
  4523                                  
  4524                                  ;-102 }
  4525                                  
  4526                                  
  4527                                  ;-103 int allowederror() {error1("not allowed here"); }
  4528 000034D4 C9                       LEAVE
  4529 000034D5 C3                       ret
  4530                                  ; ENDP
  4531                                  
  4532                                  allowederror:  ; *** PROC ***
  4533 000034D6 68[E034]                 push allowederror_0
  4534 000034D9 E884FF                   call error1
  4535 000034DC 83C402                   add  sp, 2
  4536                                  
  4537                                  ;-104 int addrerror()    {error1("address missing");} 
  4538                                  
  4539 000034DF C3                       ret
  4540                                  ; ENDP
  4541 000034E0 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4542 000034E9 6564206865726500   
  4543                                  
  4544                                  addrerror:  ; *** PROC ***
  4545 000034F1 68[FB34]                 push addrerror_0
  4546 000034F4 E869FF                   call error1
  4547 000034F7 83C402                   add  sp, 2
  4548                                  
  4549                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4550                                  
  4551 000034FA C3                       ret
  4552                                  ; ENDP
  4553 000034FB 61646472657373206D-     addrerror_0 db "address missing",0
  4554 00003504 697373696E6700     
  4555                                  
  4556                                  immeerror:  ; *** PROC ***
  4557 0000350B 68[1535]                 push immeerror_0
  4558 0000350E E84FFF                   call error1
  4559 00003511 83C402                   add  sp, 2
  4560                                  
  4561                                  ;-106 int implerror()    {error1("not implemented");}
  4562                                  
  4563 00003514 C3                       ret
  4564                                  ; ENDP
  4565 00003515 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4566 0000351E 206E6F7420616C6C6F-
  4567 00003527 776564206865726500 
  4568                                  
  4569                                  implerror:  ; *** PROC ***
  4570 00003530 68[3A35]                 push implerror_0
  4571 00003533 E82AFF                   call error1
  4572 00003536 83C402                   add  sp, 2
  4573                                  
  4574                                  ;-107 int indexerror()   {error1("invalid index register");}
  4575                                  
  4576 00003539 C3                       ret
  4577                                  ; ENDP
  4578 0000353A 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4579 00003543 6D656E74656400     
  4580                                  
  4581                                  indexerror:  ; *** PROC ***
  4582 0000354A 68[5435]                 push indexerror_0
  4583 0000354D E810FF                   call error1
  4584 00003550 83C402                   add  sp, 2
  4585                                  
  4586                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4587                                  
  4588 00003553 C3                       ret
  4589                                  ; ENDP
  4590 00003554 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4591 0000355D 6E6465782072656769-
  4592 00003566 7374657200         
  4593                                  
  4594                                  invaloperror:  ; *** PROC ***
  4595 0000356B 68[7535]                 push invaloperror_0
  4596 0000356E E8EFFE                   call error1
  4597 00003571 83C402                   add  sp, 2
  4598                                  
  4599                                  ;-109 int numbererror()  {error1("number expected");}
  4600                                  
  4601 00003574 C3                       ret
  4602                                  ; ENDP
  4603 00003575 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4604 0000357E 72206E6F206F706572-
  4605 00003587 616E647300         
  4606                                  
  4607                                  numbererror:  ; *** PROC ***
  4608 0000358C 68[9635]                 push numbererror_0
  4609 0000358F E8CEFE                   call error1
  4610 00003592 83C402                   add  sp, 2
  4611                                  
  4612                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4613                                  
  4614 00003595 C3                       ret
  4615                                  ; ENDP
  4616 00003596 6E756D626572206578-     numbererror_0 db "number expected",0
  4617 0000359F 70656374656400     
  4618                                  
  4619                                  regmemerror:  ; *** PROC ***
  4620 000035A6 68[B035]                 push regmemerror_0
  4621 000035A9 E8B4FE                   call error1
  4622 000035AC 83C402                   add  sp, 2
  4623                                  
  4624                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4625                                  
  4626 000035AF C3                       ret
  4627                                  ; ENDP
  4628 000035B0 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4629 000035B9 73746572206F72206D-
  4630 000035C2 656D6F727920616C6C-
  4631 000035CB 6F77656400         
  4632                                  
  4633                                  reg16error:  ; *** PROC ***
  4634 000035D0 68[DA35]                 push reg16error_0
  4635 000035D3 E88AFE                   call error1
  4636 000035D6 83C402                   add  sp, 2
  4637                                  
  4638                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4639                                  
  4640 000035D9 C3                       ret
  4641                                  ; ENDP
  4642 000035DA 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4643 000035E3 362C206E6F20736567-
  4644 000035EC 72656720616C6C6F77-
  4645 000035F5 656400             
  4646                                  
  4647                                  segregerror:  ; *** PROC ***
  4648 000035F8 68[0236]                 push segregerror_0
  4649 000035FB E862FE                   call error1
  4650 000035FE 83C402                   add  sp, 2
  4651                                  
  4652                                  ;-113 int syntaxerror()  {error1("syntax");}
  4653                                  
  4654 00003601 C3                       ret
  4655                                  ; ENDP
  4656 00003602 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4657 0000360B 65676973746572206E-
  4658 00003614 6F7420616C6C6F7765-
  4659 0000361D 6400               
  4660                                  
  4661                                  syntaxerror:  ; *** PROC ***
  4662 0000361F 68[2936]                 push syntaxerror_0
  4663 00003622 E83BFE                   call error1
  4664 00003625 83C402                   add  sp, 2
  4665                                  
  4666                                  ;-114          
  4667                                  
  4668                                  
  4669                                  ;-115 int addrexit()     {errorexit("illegal address");}
  4670                                  
  4671 00003628 C3                       ret
  4672                                  ; ENDP
  4673 00003629 73796E74617800          syntaxerror_0 db "syntax",0
  4674                                  
  4675                                  addrexit:  ; *** PROC ***
  4676 00003630 68[3A36]                 push addrexit_0
  4677 00003633 E889FE                   call errorexit
  4678 00003636 83C402                   add  sp, 2
  4679                                  
  4680                                  ;-116 int internexit()   {errorexit("intern compiler error");}
  4681                                  
  4682 00003639 C3                       ret
  4683                                  ; ENDP
  4684 0000363A 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4685 00003643 64647265737300     
  4686                                  
  4687                                  internexit:  ; *** PROC ***
  4688 0000364A 68[5436]                 push internexit_0
  4689 0000364D E86FFE                   call errorexit
  4690 00003650 83C402                   add  sp, 2
  4691 00003653 C3                       ret
  4692                                  ; ENDP
  4693 00003654 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4694 0000365D 6D70696C6572206572-
  4695 00003666 726F7200           
  4696                                  ;Back to main program: AS.C
  4697                                  
  4698                                  ;-8 #include "MAIN.C"
  4699                                  
  4700                                  ;Use include file: MAIN.C
  4701                                  
  4702                                  ;-1 int main() {
  4703                                  
  4704                                  
  4705                                  main:  ; *** PROC ***
  4706                                  
  4707                                  ;-2     getarg(); 
  4708                                  
  4709 0000366A E80A00                   call getarg
  4710                                  
  4711                                  ;-3     parse(); 
  4712                                  
  4713 0000366D E840EE                   call parse
  4714                                  
  4715                                  ;-4     epilog(); 
  4716                                  
  4717 00003670 E85C02                   call epilog
  4718                                  
  4719                                  ;-5     end1();
  4720                                  
  4721 00003673 E82403                   call end1
  4722                                  
  4723                                  ;-6 }
  4724                                  
  4725                                  
  4726                                  ;-7 
  4727                                  
  4728                                  
  4729                                  ;-8 int getarg() { 
  4730                                  
  4731 00003676 C3                       ret
  4732                                  ; ENDP
  4733                                  
  4734                                  getarg:  ; *** PROC ***
  4735                                  
  4736                                  ;-9     int arglen1; int i; char *c;
  4737                                  
  4738                                  
  4739                                  ;-10     arglen1=*arglen;
  4740                                  
  4741                                  ;Function : getarg, Number of local variables: 3
  4742                                  ;   # type sign width line used address name   list of local variables
  4743                                  ;  200 var sign word     9 NULL bp-2    arglen1
  4744                                  ;  201 var sign word     9 NULL bp-4    i
  4745                                  ;  202 ptr sign byte     9 NULL bp-6    c;
  4746 00003677 C8060000                 ENTER  6,0
  4747 0000367B 8B1E[011C]               mov bx, [arglen]
  4748 0000367F 8A07                     mov al, [bx]
  4749 00003681 B400                     mov ah, 0
  4750 00003683 8946FE                   mov word [bp-2], ax
  4751                                  
  4752                                  ;-11     if (arglen1==0) {
  4753                                  
  4754 00003686 8B46FE                   mov ax, [bp-2]
  4755 00003689 83F800                   cmp ax, 0
  4756 0000368C 0F851C00                 jne @@getarg195
  4757                                  
  4758                                  ;-12         cputs(Version1);
  4759                                  
  4760 00003690 8D06[0300]               lea  ax, [Version1]
  4761 00003694 50                       push ax
  4762 00003695 E8E90B                   call cputs
  4763 00003698 83C402                   add  sp, 2
  4764                                  
  4765                                  ;-13         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4766                                  
  4767 0000369B 68[3C38]                 push getarg_0
  4768 0000369E E8E00B                   call cputs
  4769 000036A1 83C402                   add  sp, 2
  4770                                  
  4771                                  ;-14         exitR(3);
  4772                                  
  4773 000036A4 6A03                     push 3
  4774 000036A6 E8B30D                   call exitR
  4775 000036A9 83C402                   add  sp, 2
  4776                                  
  4777                                  ;-15     }
  4778                                  
  4779                                  
  4780                                  ;-16     i=arglen1+129; 
  4781                                  
  4782                                  @@getarg195:
  4783 000036AC 8B46FE                   mov ax, [bp-2]
  4784 000036AF 058100                   add ax, 129
  4785 000036B2 8946FC                   mov word [bp-4], ax
  4786                                  
  4787                                  ;-17     *i=0;  
  4788                                  
  4789 000036B5 66B800000000             mov eax, 0
  4790 000036BB 8B5EFC                   mov  bx, [bp-4]
  4791 000036BE 8907                     mov  [bx], ax
  4792                                  
  4793                                  ;-18     arglen1--;
  4794                                  
  4795 000036C0 FF4EFE                   dec  word [bp-2]
  4796                                  
  4797                                  ;-19     toupper(argv);
  4798                                  
  4799 000036C3 FF36[031C]               push word [argv]
  4800 000036C7 E8E50B                   call toupper
  4801 000036CA 83C402                   add  sp, 2
  4802                                  
  4803                                  ;-20   
  4804                                  
  4805                                  
  4806                                  ;-21     strcpy(namein, argv); strcat1(namein, ".S");
  4807                                  
  4808 000036CD FF36[031C]               push word [argv]
  4809 000036D1 8D06[D000]               lea  ax, [namein]
  4810 000036D5 50                       push ax
  4811 000036D6 E8440C                   call strcpy
  4812 000036D9 83C404                   add  sp, 4
  4813 000036DC 68[6138]                 push getarg_1
  4814 000036DF 8D06[D000]               lea  ax, [namein]
  4815 000036E3 50                       push ax
  4816 000036E4 E8F70C                   call strcat1
  4817 000036E7 83C404                   add  sp, 4
  4818                                  
  4819                                  ;-22     strcpy(namelst,argv); strcat1(namelst,".LST");
  4820                                  
  4821 000036EA FF36[031C]               push word [argv]
  4822 000036EE 8D06[1301]               lea  ax, [namelst]
  4823 000036F2 50                       push ax
  4824 000036F3 E8270C                   call strcpy
  4825 000036F6 83C404                   add  sp, 4
  4826 000036F9 68[6438]                 push getarg_2
  4827 000036FC 8D06[1301]               lea  ax, [namelst]
  4828 00003700 50                       push ax
  4829 00003701 E8DA0C                   call strcat1
  4830 00003704 83C404                   add  sp, 4
  4831                                  
  4832                                  ;-23     strcpy(namebin,argv); strcat1(namebin,".COM");
  4833                                  
  4834 00003707 FF36[031C]               push word [argv]
  4835 0000370B 8D06[5601]               lea  ax, [namebin]
  4836 0000370F 50                       push ax
  4837 00003710 E80A0C                   call strcpy
  4838 00003713 83C404                   add  sp, 4
  4839 00003716 68[6938]                 push getarg_3
  4840 00003719 8D06[5601]               lea  ax, [namebin]
  4841 0000371D 50                       push ax
  4842 0000371E E8BD0C                   call strcat1
  4843 00003721 83C404                   add  sp, 4
  4844                                  
  4845                                  ;-24 
  4846                                  
  4847                                  
  4848                                  ;-25     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4849                                  
  4850 00003724 66B801000000             mov eax, 1
  4851 0000372A A2[0E00]                 mov byte [LIST], al
  4852 0000372D 66B800000000             mov eax, 0
  4853 00003733 A3[9F01]                 mov word [DOS_ERR], ax
  4854 00003736 66B800000000             mov eax, 0
  4855 0000373C A3[A601]                 mov word [PC], ax
  4856 0000373F 66B800000000             mov eax, 0
  4857 00003745 A3[A101]                 mov word [ErrorCount], ax
  4858                                  
  4859                                  ;-26   
  4860                                  
  4861                                  
  4862                                  ;-27     asm_fd=openR (namein);
  4863                                  
  4864 00003748 8D06[D000]               lea  ax, [namein]
  4865 0000374C 50                       push ax
  4866 0000374D E8B30C                   call openR
  4867 00003750 83C402                   add  sp, 2
  4868 00003753 A3[9901]                 mov word [asm_fd], ax
  4869                                  
  4870                                  ;-28     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4871                                  
  4872 00003756 A1[9F01]                 mov ax, [DOS_ERR]
  4873 00003759 08C0                     or  al, al
  4874 0000375B 0F841C00                 je @@getarg196
  4875 0000375F 68[6E38]                 push getarg_4
  4876 00003762 E81C0B                   call cputs
  4877 00003765 83C402                   add  sp, 2
  4878 00003768 8D06[D000]               lea  ax, [namein]
  4879 0000376C 50                       push ax
  4880 0000376D E8110B                   call cputs
  4881 00003770 83C402                   add  sp, 2
  4882 00003773 6A01                     push 1
  4883 00003775 E8E40C                   call exitR
  4884 00003778 83C402                   add  sp, 2
  4885                                  
  4886                                  ;-29     lst_fd=creatR(namelst);
  4887                                  
  4888                                  @@getarg196:
  4889 0000377B 8D06[1301]               lea  ax, [namelst]
  4890 0000377F 50                       push ax
  4891 00003780 E88F0C                   call creatR
  4892 00003783 83C402                   add  sp, 2
  4893 00003786 A3[9B01]                 mov word [lst_fd], ax
  4894                                  
  4895                                  ;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4896                                  
  4897 00003789 A1[9F01]                 mov ax, [DOS_ERR]
  4898 0000378C 08C0                     or  al, al
  4899 0000378E 0F841C00                 je @@getarg197
  4900 00003792 68[8438]                 push getarg_5
  4901 00003795 E8E90A                   call cputs
  4902 00003798 83C402                   add  sp, 2
  4903 0000379B 8D06[1301]               lea  ax, [namelst]
  4904 0000379F 50                       push ax
  4905 000037A0 E8DE0A                   call cputs
  4906 000037A3 83C402                   add  sp, 2
  4907 000037A6 6A02                     push 2
  4908 000037A8 E8B10C                   call exitR
  4909 000037AB 83C402                   add  sp, 2
  4910                                  
  4911                                  ;-31     bin_fd=creatR(namebin);
  4912                                  
  4913                                  @@getarg197:
  4914 000037AE 8D06[5601]               lea  ax, [namebin]
  4915 000037B2 50                       push ax
  4916 000037B3 E85C0C                   call creatR
  4917 000037B6 83C402                   add  sp, 2
  4918 000037B9 A3[9D01]                 mov word [bin_fd], ax
  4919                                  
  4920                                  ;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4921                                  
  4922 000037BC A1[9F01]                 mov ax, [DOS_ERR]
  4923 000037BF 08C0                     or  al, al
  4924 000037C1 0F841C00                 je @@getarg198
  4925 000037C5 68[9B38]                 push getarg_6
  4926 000037C8 E8B60A                   call cputs
  4927 000037CB 83C402                   add  sp, 2
  4928 000037CE 8D06[5601]               lea  ax, [namebin]
  4929 000037D2 50                       push ax
  4930 000037D3 E8AB0A                   call cputs
  4931 000037D6 83C402                   add  sp, 2
  4932 000037D9 6A02                     push 2
  4933 000037DB E87E0C                   call exitR
  4934 000037DE 83C402                   add  sp, 2
  4935                                  
  4936                                  ;-33   
  4937                                  
  4938                                  
  4939                                  ;-34     prs(";"); 
  4940                                  
  4941                                  @@getarg198:
  4942 000037E1 68[B138]                 push getarg_7
  4943 000037E4 E818FB                   call prs
  4944 000037E7 83C402                   add  sp, 2
  4945                                  
  4946                                  ;-35     prs(Version1);
  4947                                  
  4948 000037EA 8D06[0300]               lea  ax, [Version1]
  4949 000037EE 50                       push ax
  4950 000037EF E80DFB                   call prs
  4951 000037F2 83C402                   add  sp, 2
  4952                                  
  4953                                  ;-36     prs(", Source: "); prs(namein);  
  4954                                  
  4955 000037F5 68[B338]                 push getarg_8
  4956 000037F8 E804FB                   call prs
  4957 000037FB 83C402                   add  sp, 2
  4958 000037FE 8D06[D000]               lea  ax, [namein]
  4959 00003802 50                       push ax
  4960 00003803 E8F9FA                   call prs
  4961 00003806 83C402                   add  sp, 2
  4962                                  
  4963                                  ;-37     prs(", Output: "); prs(namelst);
  4964                                  
  4965 00003809 68[BE38]                 push getarg_9
  4966 0000380C E8F0FA                   call prs
  4967 0000380F 83C402                   add  sp, 2
  4968 00003812 8D06[1301]               lea  ax, [namelst]
  4969 00003816 50                       push ax
  4970 00003817 E8E5FA                   call prs
  4971 0000381A 83C402                   add  sp, 2
  4972                                  
  4973                                  ;-38     prs(", "); prs(namebin);
  4974                                  
  4975 0000381D 68[C938]                 push getarg_10
  4976 00003820 E8DCFA                   call prs
  4977 00003823 83C402                   add  sp, 2
  4978 00003826 8D06[5601]               lea  ax, [namebin]
  4979 0000382A 50                       push ax
  4980 0000382B E8D1FA                   call prs
  4981 0000382E 83C402                   add  sp, 2
  4982                                  
  4983                                  ;-39     prs("\n");
  4984                                  
  4985 00003831 68[CC38]                 push getarg_11
  4986 00003834 E8C8FA                   call prs
  4987 00003837 83C402                   add  sp, 2
  4988                                  
  4989                                  ;-40 }
  4990                                  
  4991                                  
  4992                                  ;-41 
  4993                                  
  4994                                  
  4995                                  ;-42 int epilog() { 
  4996 0000383A C9                       LEAVE
  4997 0000383B C3                       ret
  4998                                  ; ENDP
  4999 0000383C 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5000 00003845 41532E434F4D206669-
  5001 0000384E 6C656E616D65205B77-
  5002 00003857 2F6F202E535D203A20-
  5003 00003860 00                 
  5004 00003861 2E5300                  getarg_1 db ".S",0
  5005 00003864 2E4C535400              getarg_2 db ".LST",0
  5006 00003869 2E434F4D00              getarg_3 db ".COM",0
  5007 0000386E 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5008 00003877 6C65206D697373696E-
  5009 00003880 673A2000           
  5010 00003884 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5011 0000388D 206E6F742063726561-
  5012 00003896 74653A2000         
  5013 0000389B 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5014 000038A4 6E6F74206372656174-
  5015 000038AD 653A2000           
  5016 000038B1 3B00                    getarg_7 db ";",0
  5017 000038B3 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5018 000038BC 2000               
  5019 000038BE 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5020 000038C7 2000               
  5021 000038C9 2C2000                  getarg_10 db ", ",0
  5022 000038CC 5C6E00                  getarg_11 db "\n",0
  5023                                  
  5024                                  epilog:  ; *** PROC ***
  5025                                  
  5026                                  ;-43     int i; int j; char c;
  5027                                  
  5028                                  
  5029                                  ;-44     prs("\n;END Errors: "); 
  5030                                  
  5031                                  ;Function : epilog, Number of local variables: 3
  5032                                  ;   # type sign width line used address name   list of local variables
  5033                                  ;  200 var sign word    43 NULL bp-2    i
  5034                                  ;  201 var sign word    43 NULL bp-4    j
  5035                                  ;  202 var sign byte    43 NULL bp-6    c;
  5036 000038CF C8060000                 ENTER  6,0
  5037 000038D3 68[5D39]                 push epilog_0
  5038 000038D6 E826FA                   call prs
  5039 000038D9 83C402                   add  sp, 2
  5040                                  
  5041                                  ;-45     printIntU(ErrorCount);
  5042                                  
  5043 000038DC FF36[A101]               push word [ErrorCount]
  5044 000038E0 E83BFB                   call printIntU
  5045 000038E3 83C402                   add  sp, 2
  5046                                  
  5047                                  ;-46     if (ErrorCount) prs(" ***ERROR*** ");
  5048                                  
  5049 000038E6 A1[A101]                 mov ax, [ErrorCount]
  5050 000038E9 08C0                     or  al, al
  5051 000038EB 0F840900                 je @@epilog199
  5052 000038EF 68[6D39]                 push epilog_1
  5053 000038F2 E80AFA                   call prs
  5054 000038F5 83C402                   add  sp, 2
  5055                                  
  5056                                  ;-47     prs(", Output: "); prs(namelst);
  5057                                  
  5058                                  @@epilog199:
  5059 000038F8 68[7B39]                 push epilog_2
  5060 000038FB E801FA                   call prs
  5061 000038FE 83C402                   add  sp, 2
  5062 00003901 8D06[1301]               lea  ax, [namelst]
  5063 00003905 50                       push ax
  5064 00003906 E8F6F9                   call prs
  5065 00003909 83C402                   add  sp, 2
  5066                                  
  5067                                  ;-48     prs(", COM file "); 
  5068                                  
  5069 0000390C 68[8639]                 push epilog_3
  5070 0000390F E8EDF9                   call prs
  5071 00003912 83C402                   add  sp, 2
  5072                                  
  5073                                  ;-49     printIntU(BinLen); 
  5074                                  
  5075 00003915 FF36[FF1B]               push word [BinLen]
  5076 00003919 E802FB                   call printIntU
  5077 0000391C 83C402                   add  sp, 2
  5078                                  
  5079                                  ;-50     prs(" bytes.");
  5080                                  
  5081 0000391F 68[9239]                 push epilog_4
  5082 00003922 E8DAF9                   call prs
  5083 00003925 83C402                   add  sp, 2
  5084                                  
  5085                                  ;-51 
  5086                                  
  5087                                  
  5088                                  ;-52     i=0;
  5089                                  
  5090 00003928 66B800000000             mov eax, 0
  5091 0000392E 8946FE                   mov word [bp-2], ax
  5092                                  
  5093                                  ;-53     do {
  5094                                  
  5095                                  @@epilog200:
  5096                                  
  5097                                  ;-54         c = FileBin[i];
  5098                                  
  5099 00003931 8B5EFE                   mov bx, [bp-2]
  5100 00003934 8A87[2F14]               mov al, [FileBin + bx]
  5101 00003938 8846FA                   mov byte [bp-6], al
  5102                                  
  5103                                  ;-55         fputcR(c, bin_fd);
  5104                                  
  5105 0000393B FF36[9D01]               push word [bin_fd]
  5106 0000393F 8A46FA                   mov al, byte [bp-6]
  5107 00003942 B400                     mov ah, 0
  5108 00003944 50                       push ax
  5109 00003945 E8F10A                   call fputcR
  5110 00003948 83C404                   add  sp, 4
  5111                                  
  5112                                  ;-56         i++;
  5113                                  
  5114 0000394B FF46FE                   inc  word [bp-2]
  5115                                  
  5116                                  ;-57     } while (i < BinLen);
  5117                                  
  5118 0000394E 8B46FE                   mov ax, [bp-2]
  5119 00003951 3B06[FF1B]               cmp ax, [BinLen]
  5120 00003955 0F8D0200                 jge @@epilog201
  5121 00003959 EBD6                     jmp @@epilog200
  5122                                  @@epilog201:
  5123                                  
  5124                                  ;-58 }
  5125                                  
  5126                                  
  5127                                  ;-59 
  5128                                  
  5129                                  
  5130                                  ;-60 int end1(int n) {
  5131 0000395B C9                       LEAVE
  5132 0000395C C3                       ret
  5133                                  ; ENDP
  5134 0000395D 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5135 00003966 726F72733A2000     
  5136 0000396D 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5137 00003976 2A2A2A2000         
  5138 0000397B 2C204F75747075743A-     epilog_2 db ", Output: ",0
  5139 00003984 2000               
  5140 00003986 2C20434F4D2066696C-     epilog_3 db ", COM file ",0
  5141 0000398F 652000             
  5142 00003992 2062797465732E00        epilog_4 db " bytes.",0
  5143                                  
  5144                                  end1:  ; *** PROC ***
  5145                                  
  5146                                  ;-61   fcloseR(asm_fd);
  5147                                  
  5148                                  ;Function : end1, Number of local variables: 1
  5149                                  ;   # type sign width line used address name   list of local variables
  5150                                  ;  200 var sign word    60 NULL bp+4    n;
  5151 0000399A C8000000                 ENTER  0,0
  5152 0000399E FF36[9901]               push word [asm_fd]
  5153 000039A2 E8A90A                   call fcloseR
  5154 000039A5 83C402                   add  sp, 2
  5155                                  
  5156                                  ;-62   fcloseR(lst_fd);
  5157                                  
  5158 000039A8 FF36[9B01]               push word [lst_fd]
  5159 000039AC E89F0A                   call fcloseR
  5160 000039AF 83C402                   add  sp, 2
  5161                                  
  5162                                  ;-63   fcloseR(bin_fd);
  5163                                  
  5164 000039B2 FF36[9D01]               push word [bin_fd]
  5165 000039B6 E8950A                   call fcloseR
  5166 000039B9 83C402                   add  sp, 2
  5167                                  
  5168                                  ;-64   exitR(n);
  5169                                  
  5170 000039BC FF7604                   push word [bp+4]
  5171 000039BF E89A0A                   call exitR
  5172 000039C2 83C402                   add  sp, 2
  5173                                  
  5174                                  ;-65 }
  5175 000039C5 C9                       LEAVE
  5176 000039C6 C3                       ret
  5177                                  ; ENDP
  5178                                  ;Back to main program: AS.C
  5179                                  
  5180                                  ;-9 #include "GENCODE.C"
  5181                                  
  5182                                  ;Use include file: GENCODE.C
  5183                                  
  5184                                  ;-1 // generate code
  5185                                  
  5186                                  
  5187                                  ;-2 int getCodes() {
  5188                                  
  5189                                  
  5190                                  getCodes:  ; *** PROC ***
  5191                                  
  5192                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5193                                  
  5194 000039C7 FF06[C701]               inc  word [OpCodePtr]
  5195 000039CB 8B1E[C701]               mov bx, [OpCodePtr]
  5196 000039CF 8A07                     mov al, [bx]
  5197 000039D1 B400                     mov ah, 0
  5198 000039D3 A2[AF01]                 mov byte [Code1], al
  5199                                  
  5200                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5201                                  
  5202 000039D6 FF06[C701]               inc  word [OpCodePtr]
  5203 000039DA 8B1E[C701]               mov bx, [OpCodePtr]
  5204 000039DE 8A07                     mov al, [bx]
  5205 000039E0 B400                     mov ah, 0
  5206 000039E2 A2[B001]                 mov byte [Code2], al
  5207                                  
  5208                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5209                                  
  5210 000039E5 FF06[C701]               inc  word [OpCodePtr]
  5211 000039E9 8B1E[C701]               mov bx, [OpCodePtr]
  5212 000039ED 8A07                     mov al, [bx]
  5213 000039EF B400                     mov ah, 0
  5214 000039F1 A2[B101]                 mov byte [Code3], al
  5215                                  
  5216                                  ;-6 }
  5217                                  
  5218                                  
  5219                                  ;-7 int gen66h() {genCode8(0x66);
  5220                                  
  5221 000039F4 C3                       ret
  5222                                  ; ENDP
  5223                                  
  5224                                  gen66h:  ; *** PROC ***
  5225 000039F5 6A66                     push 102
  5226 000039F7 E83B00                   call genCode8
  5227 000039FA 83C402                   add  sp, 2
  5228                                  
  5229                                  ;-8 }
  5230                                  
  5231                                  
  5232                                  ;-9 int genCode2(char c, char d) {
  5233                                  
  5234 000039FD C3                       ret
  5235                                  ; ENDP
  5236                                  
  5237                                  genCode2:  ; *** PROC ***
  5238                                  
  5239                                  ;-10     c = c + d;
  5240                                  
  5241                                  ;Function : genCode2, Number of local variables: 2
  5242                                  ;   # type sign width line used address name   list of local variables
  5243                                  ;  200 var sign byte     9 NULL bp+4    c
  5244                                  ;  201 var sign byte     9 NULL bp+6    d;
  5245 000039FE C8000000                 ENTER  0,0
  5246 00003A02 8A4604                   mov al, [bp+4]
  5247 00003A05 024606                   add al, [bp+6]
  5248 00003A08 884604                   mov byte [bp+4], al
  5249                                  
  5250                                  ;-11     genCode8(c);
  5251                                  
  5252 00003A0B 8A4604                   mov al, byte [bp+4]
  5253 00003A0E B400                     mov ah, 0
  5254 00003A10 50                       push ax
  5255 00003A11 E82100                   call genCode8
  5256 00003A14 83C402                   add  sp, 2
  5257                                  
  5258                                  ;-12 }                             
  5259                                  
  5260                                  
  5261                                  ;-13 int genCodeW(char c) {
  5262 00003A17 C9                       LEAVE
  5263 00003A18 C3                       ret
  5264                                  ; ENDP
  5265                                  
  5266                                  genCodeW:  ; *** PROC ***
  5267                                  
  5268                                  ;-14     c = c + wflag;  
  5269                                  
  5270                                  ;Function : genCodeW, Number of local variables: 1
  5271                                  ;   # type sign width line used address name   list of local variables
  5272                                  ;  200 var sign byte    13 NULL bp+4    c;
  5273 00003A19 C8000000                 ENTER  0,0
  5274 00003A1D 8A4604                   mov al, [bp+4]
  5275 00003A20 0206[B701]               add al, [wflag]
  5276 00003A24 884604                   mov byte [bp+4], al
  5277                                  
  5278                                  ;-15     genCode8(c);
  5279                                  
  5280 00003A27 8A4604                   mov al, byte [bp+4]
  5281 00003A2A B400                     mov ah, 0
  5282 00003A2C 50                       push ax
  5283 00003A2D E80500                   call genCode8
  5284 00003A30 83C402                   add  sp, 2
  5285                                  
  5286                                  ;-16 }   
  5287                                  
  5288                                  
  5289                                  ;-17 int genCode8(char c) {
  5290 00003A33 C9                       LEAVE
  5291 00003A34 C3                       ret
  5292                                  ; ENDP
  5293                                  
  5294                                  genCode8:  ; *** PROC ***
  5295                                  
  5296                                  ;-18 //set: BinLen++, OpPrintIndex++
  5297                                  
  5298                                  
  5299                                  ;-19     FileBin[BinLen]=c;
  5300                                  
  5301                                  ;Function : genCode8, Number of local variables: 1
  5302                                  ;   # type sign width line used address name   list of local variables
  5303                                  ;  200 var sign byte    17 NULL bp+4    c;
  5304 00003A35 C8000000                 ENTER  0,0
  5305 00003A39 8A4604                   mov al, [bp+4]
  5306 00003A3C 8B1E[FF1B]               mov bx, [BinLen]
  5307 00003A40 8887[2F14]               mov [FileBin+bx], al
  5308                                  
  5309                                  ;-20     BinLen++;
  5310                                  
  5311 00003A44 FF06[FF1B]               inc  word [BinLen]
  5312                                  
  5313                                  ;-21     PC++;
  5314                                  
  5315 00003A48 FF06[A601]               inc  word [PC]
  5316                                  
  5317                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5318                                  
  5319 00003A4C A1[FF1B]                 mov ax, [BinLen]
  5320 00003A4F 3DD007                   cmp ax, 2000 ;unsigned : 0
  5321 00003A52 0F820900                 jb  @@genCode8202
  5322 00003A56 68[7A3A]                 push genCode8_0
  5323 00003A59 E863FA                   call errorexit
  5324 00003A5C 83C402                   add  sp, 2
  5325                                  
  5326                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5327                                  
  5328                                  @@genCode8202:
  5329 00003A5F A1[C501]                 mov ax, [OpPrintIndex]
  5330 00003A62 83F805                   cmp ax, 5
  5331 00003A65 0F8D0F00                 jge @@genCode8203
  5332                                  
  5333                                  ;-24         OpPos[OpPrintIndex]=c;
  5334                                  
  5335 00003A69 8A4604                   mov al, [bp+4]
  5336 00003A6C 8B1E[C501]               mov bx, [OpPrintIndex]
  5337 00003A70 8887[C001]               mov [OpPos+bx], al
  5338                                  
  5339                                  ;-25         OpPrintIndex++;
  5340                                  
  5341 00003A74 FF06[C501]               inc  word [OpPrintIndex]
  5342                                  
  5343                                  ;-26     }
  5344                                  
  5345                                  
  5346                                  ;-27 }
  5347                                  
  5348                                  @@genCode8203:
  5349                                  
  5350                                  ;-28 int genCode16(unsigned int i) {
  5351 00003A78 C9                       LEAVE
  5352 00003A79 C3                       ret
  5353                                  ; ENDP
  5354 00003A7A 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5355 00003A83 746F6F206C6F6E6700 
  5356                                  
  5357                                  genCode16:  ; *** PROC ***
  5358                                  
  5359                                  ;-29     genCode8(i); i=i >> 8;
  5360                                  
  5361                                  ;Function : genCode16, Number of local variables: 1
  5362                                  ;   # type sign width line used address name   list of local variables
  5363                                  ;  200 var unsg word    28 NULL bp+4    i;
  5364 00003A8C C8000000                 ENTER  0,0
  5365 00003A90 FF7604                   push word [bp+4]
  5366 00003A93 E89FFF                   call genCode8
  5367 00003A96 83C402                   add  sp, 2
  5368 00003A99 8B4604                   mov ax, [bp+4]
  5369 00003A9C C1E808                   shr ax, 8
  5370 00003A9F 894604                   mov word [bp+4], ax
  5371                                  
  5372                                  ;-30     genCode8(i);
  5373                                  
  5374 00003AA2 FF7604                   push word [bp+4]
  5375 00003AA5 E88DFF                   call genCode8
  5376 00003AA8 83C402                   add  sp, 2
  5377                                  
  5378                                  ;-31 }
  5379                                  
  5380                                  
  5381                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5382 00003AAB C9                       LEAVE
  5383 00003AAC C3                       ret
  5384                                  ; ENDP
  5385                                  
  5386                                  writeEA:  ; *** PROC ***
  5387                                  
  5388                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5389                                  
  5390                                  
  5391                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5392                                  
  5393                                  
  5394                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5395                                  
  5396                                  
  5397                                  ;-36     char len;
  5398                                  
  5399                                  
  5400                                  ;-37     len=0;   
  5401                                  
  5402                                  ;Function : writeEA, Number of local variables: 2
  5403                                  ;   # type sign width line used address name   list of local variables
  5404                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5405                                  ;  201 var sign byte    36 NULL bp-2    len;
  5406 00003AAD C8020000                 ENTER  2,0
  5407 00003AB1 66B800000000             mov eax, 0
  5408 00003AB7 8846FE                   mov byte [bp-2], al
  5409                                  
  5410                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5411                                  
  5412 00003ABA 8A4604                   mov al, [bp+4]
  5413 00003ABD C0E003                   shl al, 3
  5414 00003AC0 884604                   mov byte [bp+4], al
  5415                                  
  5416                                  ;-39     if (Op == REG) {
  5417                                  
  5418 00003AC3 A0[AC01]                 mov al, [Op]
  5419 00003AC6 3C02                     cmp al, 2
  5420 00003AC8 0F853A00                 jne @@writeEA204
  5421                                  
  5422                                  ;-40         xxx |= 0xC0;     
  5423                                  
  5424 00003ACC 804E04C0                 or  byte [bp+4], 192
  5425                                  
  5426                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5427                                  
  5428 00003AD0 A0[AD01]                 mov al, [Op2]
  5429 00003AD3 3C01                     cmp al, 1
  5430 00003AD5 0F8F0D00                 jg  @@writeEA205
  5431 00003AD9 8A4604                   mov al, [bp+4]
  5432 00003ADC 0206[B301]               add al, [R1No]
  5433 00003AE0 884604                   mov byte [bp+4], al
  5434                                  
  5435                                  ;-42             else {
  5436                                  
  5437 00003AE3 E92000                   jmp @@writeEA206
  5438                                  @@writeEA205:
  5439                                  
  5440                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5441                                  
  5442 00003AE6 A0[AD01]                 mov al, [Op2]
  5443 00003AE9 3C02                     cmp al, 2
  5444 00003AEB 0F850D00                 jne @@writeEA207
  5445 00003AEF 8A4604                   mov al, [bp+4]
  5446 00003AF2 0206[B301]               add al, [R1No]
  5447 00003AF6 884604                   mov byte [bp+4], al
  5448                                  
  5449                                  ;-44                 else            xxx = xxx + R2No;  
  5450                                  
  5451 00003AF9 E90A00                   jmp @@writeEA208
  5452                                  @@writeEA207:
  5453 00003AFC 8A4604                   mov al, [bp+4]
  5454 00003AFF 0206[B201]               add al, [R2No]
  5455 00003B03 884604                   mov byte [bp+4], al
  5456                                  
  5457                                  ;-45             }
  5458                                  
  5459                                  @@writeEA208:
  5460                                  
  5461                                  ;-46         } 
  5462                                  
  5463                                  @@writeEA206:
  5464                                  
  5465                                  ;-47     if (Op == MEM) {
  5466                                  
  5467                                  @@writeEA204:
  5468 00003B06 A0[AC01]                 mov al, [Op]
  5469 00003B09 3C04                     cmp al, 4
  5470 00003B0B 0F857F00                 jne @@writeEA209
  5471                                  
  5472                                  ;-48         if (isDirect) {
  5473                                  
  5474 00003B0F A0[BB01]                 mov al, [isDirect]
  5475 00003B12 08C0                     or  al, al
  5476 00003B14 0F841000                 je @@writeEA210
  5477                                  
  5478                                  ;-49             xxx |= 6;
  5479                                  
  5480 00003B18 804E0406                 or  byte [bp+4], 6
  5481                                  
  5482                                  ;-50             len = 2;
  5483                                  
  5484 00003B1C 66B802000000             mov eax, 2
  5485 00003B22 8846FE                   mov byte [bp-2], al
  5486                                  
  5487                                  ;-51         }
  5488                                  
  5489                                  
  5490                                  ;-52         else { 
  5491                                  
  5492 00003B25 E96600                   jmp @@writeEA211
  5493                                  @@writeEA210:
  5494                                  
  5495                                  ;-53             xxx = xxx + rm;   
  5496                                  
  5497 00003B28 8A4604                   mov al, [bp+4]
  5498 00003B2B 0206[BA01]               add al, [rm]
  5499 00003B2F 884604                   mov byte [bp+4], al
  5500                                  
  5501                                  ;-54             if (rm == 6) {//make [BP+00]
  5502                                  
  5503 00003B32 A0[BA01]                 mov al, [rm]
  5504 00003B35 3C06                     cmp al, 6
  5505 00003B37 0F851700                 jne @@writeEA212
  5506                                  
  5507                                  ;-55                 len=1;
  5508                                  
  5509 00003B3B 66B801000000             mov eax, 1
  5510 00003B41 8846FE                   mov byte [bp-2], al
  5511                                  
  5512                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5513                                  
  5514 00003B44 A1[BC01]                 mov ax, [disp]
  5515 00003B47 83F800                   cmp ax, 0
  5516 00003B4A 0F850400                 jne @@writeEA213
  5517 00003B4E 804E0440                 or  byte [bp+4], 64
  5518                                  
  5519                                  ;-57             }
  5520                                  
  5521                                  @@writeEA213:
  5522                                  
  5523                                  ;-58 
  5524                                  
  5525                                  
  5526                                  ;-59             if (disp) {
  5527                                  
  5528                                  @@writeEA212:
  5529 00003B52 A1[BC01]                 mov ax, [disp]
  5530 00003B55 08C0                     or  al, al
  5531 00003B57 0F843300                 je @@writeEA214
  5532                                  
  5533                                  ;-60                 ax = disp;
  5534                                  
  5535 00003B5B A1[BC01]                 mov  ax, [disp]
  5536                                  
  5537                                  ;-61                 if(ax > 127) len=2;
  5538                                  
  5539 00003B5E 83F87F                   cmp  ax, 127
  5540 00003B61 0F8E0C00                 jle @@writeEA215
  5541 00003B65 66B802000000             mov eax, 2
  5542 00003B6B 8846FE                   mov byte [bp-2], al
  5543                                  
  5544                                  ;-62                 else len=1;
  5545                                  
  5546 00003B6E E90900                   jmp @@writeEA216
  5547                                  @@writeEA215:
  5548 00003B71 66B801000000             mov eax, 1
  5549 00003B77 8846FE                   mov byte [bp-2], al
  5550                                  
  5551                                  ;-63                 if (len == 1) xxx |= 0x40;
  5552                                  
  5553                                  @@writeEA216:
  5554 00003B7A 8A46FE                   mov al, [bp-2]
  5555 00003B7D 3C01                     cmp al, 1
  5556 00003B7F 0F850700                 jne @@writeEA217
  5557 00003B83 804E0440                 or  byte [bp+4], 64
  5558                                  
  5559                                  ;-64                 else xxx |= 0x80;
  5560                                  
  5561 00003B87 E90400                   jmp @@writeEA218
  5562                                  @@writeEA217:
  5563 00003B8A 804E0480                 or  byte [bp+4], 128
  5564                                  
  5565                                  ;-65             }
  5566                                  
  5567                                  @@writeEA218:
  5568                                  
  5569                                  ;-66         }
  5570                                  
  5571                                  @@writeEA214:
  5572                                  
  5573                                  ;-67     }  
  5574                                  
  5575                                  @@writeEA211:
  5576                                  
  5577                                  ;-68     
  5578                                  
  5579                                  
  5580                                  ;-69     genCode8(xxx);// gen second byte
  5581                                  
  5582                                  @@writeEA209:
  5583 00003B8E 8A4604                   mov al, byte [bp+4]
  5584 00003B91 B400                     mov ah, 0
  5585 00003B93 50                       push ax
  5586 00003B94 E89EFE                   call genCode8
  5587 00003B97 83C402                   add  sp, 2
  5588                                  
  5589                                  ;-70     if (len == 1) genCode8 (disp);
  5590                                  
  5591 00003B9A 8A46FE                   mov al, [bp-2]
  5592 00003B9D 3C01                     cmp al, 1
  5593 00003B9F 0F850A00                 jne @@writeEA219
  5594 00003BA3 FF36[BC01]               push word [disp]
  5595 00003BA7 E88BFE                   call genCode8
  5596 00003BAA 83C402                   add  sp, 2
  5597                                  
  5598                                  ;-71     if (len == 2) genCode16(disp);
  5599                                  
  5600                                  @@writeEA219:
  5601 00003BAD 8A46FE                   mov al, [bp-2]
  5602 00003BB0 3C02                     cmp al, 2
  5603 00003BB2 0F850A00                 jne @@writeEA220
  5604 00003BB6 FF36[BC01]               push word [disp]
  5605 00003BBA E8CFFE                   call genCode16
  5606 00003BBD 83C402                   add  sp, 2
  5607                                  
  5608                                  ;-72 }
  5609                                  
  5610                                  @@writeEA220:
  5611                                  
  5612                                  ;-73 
  5613                                  
  5614                                  
  5615                                  ;-74 int genImmediate() { 
  5616 00003BC0 C9                       LEAVE
  5617 00003BC1 C3                       ret
  5618                                  ; ENDP
  5619                                  
  5620                                  genImmediate:  ; *** PROC ***
  5621                                  
  5622                                  ;-75     if (wflag) genCode16(imme);
  5623                                  
  5624 00003BC2 A0[B701]                 mov al, [wflag]
  5625 00003BC5 08C0                     or  al, al
  5626 00003BC7 0F840D00                 je @@genImmediate221
  5627 00003BCB FF36[BE01]               push word [imme]
  5628 00003BCF E8BAFE                   call genCode16
  5629 00003BD2 83C402                   add  sp, 2
  5630                                  
  5631                                  ;-76     else       genCode8 (imme);  
  5632                                  
  5633 00003BD5 E90A00                   jmp @@genImmediate222
  5634                                  @@genImmediate221:
  5635 00003BD8 FF36[BE01]               push word [imme]
  5636 00003BDC E856FE                   call genCode8
  5637 00003BDF 83C402                   add  sp, 2
  5638                                  
  5639                                  ;-77 }    
  5640                                  
  5641                                  @@genImmediate222:
  5642 00003BE2 C3                       ret
  5643                                  ; ENDP
  5644                                  ;Back to main program: AS.C
  5645                                  
  5646                                  ;-10 
  5647                                  
  5648                                  
  5649                                  ;-11 int process() { 
  5650                                  
  5651                                  
  5652                                  process:  ; *** PROC ***
  5653                                  
  5654                                  ;-12     char c;           
  5655                                  
  5656                                  
  5657                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  5658                                  
  5659                                  ;Function : process, Number of local variables: 1
  5660                                  ;   # type sign width line used address name   list of local variables
  5661                                  ;  200 var sign byte    12 NULL bp-2    c;
  5662 00003BE3 C8020000                 ENTER  2,0
  5663 00003BE7 66B800000000             mov eax, 0
  5664 00003BED A2[BA01]                 mov byte [rm], al
  5665 00003BF0 A2[B701]                 mov byte [wflag], al
  5666 00003BF3 A2[B801]                 mov byte [dflag], al
  5667 00003BF6 A2[B201]                 mov byte [R2No], al
  5668 00003BF9 A2[B301]                 mov byte [R1No], al
  5669 00003BFC A2[B401]                 mov byte [R2Type], al
  5670 00003BFF A2[B501]                 mov byte [R1Type], al
  5671 00003C02 A2[AD01]                 mov byte [Op2], al
  5672 00003C05 A2[AC01]                 mov byte [Op], al
  5673                                  
  5674                                  ;-14     disp=imme=0;//int
  5675                                  
  5676 00003C08 66B800000000             mov eax, 0
  5677 00003C0E A3[BE01]                 mov word [imme], ax
  5678 00003C11 A3[BC01]                 mov word [disp], ax
  5679                                  
  5680                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  5681                                  
  5682 00003C14 66B801000000             mov eax, 1
  5683 00003C1A A2[BB01]                 mov byte [isDirect], al
  5684                                  
  5685                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  5686                                  
  5687 00003C1D E880E9                   call getTokeType
  5688                                  
  5689                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  5690                                  
  5691 00003C20 E862ED                   call getCodeSize
  5692 00003C23 A2[B601]                 mov byte [OpSize], al
  5693                                  
  5694                                  ;-18     getCodes();//set: Code1, Code2, Code3
  5695                                  
  5696 00003C26 E89EFD                   call getCodes
  5697                                  
  5698                                  ;-19 
  5699                                  
  5700                                  
  5701                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  5702                                  
  5703 00003C29 A0[AE01]                 mov al, [CodeType]
  5704 00003C2C 3C01                     cmp al, 1
  5705 00003C2E 0F850F00                 jne @@process223
  5706                                  
  5707                                  ;-21         genCode8(Code1);
  5708                                  
  5709 00003C32 A0[AF01]                 mov al, byte [Code1]
  5710 00003C35 B400                     mov ah, 0
  5711 00003C37 50                       push ax
  5712 00003C38 E8FAFD                   call genCode8
  5713 00003C3B 83C402                   add  sp, 2
  5714                                  
  5715                                  ;-22         return;
  5716                                  
  5717 00003C3E E9FB05                   jmp @@retn
  5718                                  
  5719                                  ;-23     }
  5720                                  
  5721                                  
  5722                                  ;-24   
  5723                                  
  5724                                  
  5725                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  5726                                  
  5727                                  @@process223:
  5728 00003C41 A0[AE01]                 mov al, [CodeType]
  5729 00003C44 3C02                     cmp al, 2
  5730 00003C46 0F856900                 jne @@process224
  5731                                  
  5732                                  ;-26         getOpL();    
  5733                                  
  5734 00003C4A E841E4                   call getOpL
  5735                                  
  5736                                  ;-27         checkOpL();        
  5737                                  
  5738 00003C4D E861E3                   call checkOpL
  5739                                  
  5740                                  ;-28         if (Code2 <= 1) {//inc,dec
  5741                                  
  5742 00003C50 A0[B001]                 mov al, [Code2]
  5743 00003C53 3C01                     cmp al, 1
  5744 00003C55 0F8F2700                 jg  @@process225
  5745                                  
  5746                                  ;-29   	        if (Op == REG) {//short
  5747                                  
  5748 00003C59 A0[AC01]                 mov al, [Op]
  5749 00003C5C 3C02                     cmp al, 2
  5750 00003C5E 0F851E00                 jne @@process226
  5751                                  
  5752                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  5753                                  
  5754 00003C62 A0[B701]                 mov al, [wflag]
  5755 00003C65 08C0                     or  al, al
  5756 00003C67 0F841500                 je @@process227
  5757 00003C6B A0[B301]                 mov al, byte [R1No]
  5758 00003C6E B400                     mov ah, 0
  5759 00003C70 50                       push ax
  5760 00003C71 A0[B101]                 mov al, byte [Code3]
  5761 00003C74 B400                     mov ah, 0
  5762 00003C76 50                       push ax
  5763 00003C77 E884FD                   call genCode2
  5764 00003C7A 83C404                   add  sp, 4
  5765 00003C7D E9BC05                   jmp @@retn
  5766                                  
  5767                                  ;-31             }
  5768                                  
  5769                                  @@process227:
  5770                                  
  5771                                  ;-32         }
  5772                                  
  5773                                  @@process226:
  5774                                  
  5775                                  ;-33         if (Code2 == 5) {//imul extension?
  5776                                  
  5777                                  @@process225:
  5778 00003C80 A0[B001]                 mov al, [Code2]
  5779 00003C83 3C05                     cmp al, 5
  5780 00003C85 0F850F00                 jne @@process228
  5781                                  
  5782                                  ;-34             getTokeType();
  5783                                  
  5784 00003C89 E814E9                   call getTokeType
  5785                                  
  5786                                  ;-35             if (TokeType) implerror();
  5787                                  
  5788 00003C8C A0[AB01]                 mov al, [TokeType]
  5789 00003C8F 08C0                     or  al, al
  5790 00003C91 0F840300                 je @@process229
  5791 00003C95 E898F8                   call implerror
  5792                                  
  5793                                  ;-36         }
  5794                                  
  5795                                  @@process229:
  5796                                  
  5797                                  ;-37         genCodeW(Code1);           
  5798                                  
  5799                                  @@process228:
  5800 00003C98 A0[AF01]                 mov al, byte [Code1]
  5801 00003C9B B400                     mov ah, 0
  5802 00003C9D 50                       push ax
  5803 00003C9E E878FD                   call genCodeW
  5804 00003CA1 83C402                   add  sp, 2
  5805                                  
  5806                                  ;-38         writeEA(Code2);
  5807                                  
  5808 00003CA4 A0[B001]                 mov al, byte [Code2]
  5809 00003CA7 B400                     mov ah, 0
  5810 00003CA9 50                       push ax
  5811 00003CAA E800FE                   call writeEA
  5812 00003CAD 83C402                   add  sp, 2
  5813                                  
  5814                                  ;-39         return;
  5815                                  
  5816 00003CB0 E98905                   jmp @@retn
  5817                                  
  5818                                  ;-40     }
  5819                                  
  5820                                  
  5821                                  ;-41   
  5822                                  
  5823                                  
  5824                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  5825                                  
  5826                                  @@process224:
  5827 00003CB3 A0[AE01]                 mov al, [CodeType]
  5828 00003CB6 3C03                     cmp al, 3
  5829 00003CB8 0F855100                 jne @@process230
  5830                                  
  5831                                  ;-43         check2Ops();    //setwflag not applicable
  5832                                  
  5833 00003CBC E874E3                   call check2Ops
  5834                                  
  5835                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  5836                                  
  5837 00003CBF A0[B501]                 mov al, [R1Type]
  5838 00003CC2 3C02                     cmp al, 2
  5839 00003CC4 0F840300                 je  @@process231
  5840 00003CC8 E805F9                   call reg16error
  5841                                  
  5842                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  5843                                  
  5844                                  @@process231:
  5845 00003CCB A0[AD01]                 mov al, [Op2]
  5846 00003CCE 3C04                     cmp al, 4
  5847 00003CD0 0F840300                 je  @@process232
  5848 00003CD4 E81AF8                   call addrerror
  5849                                  
  5850                                  ;-46         
  5851                                  
  5852                                  
  5853                                  ;-47         genCode8(Code1);//les,lds,lea
  5854                                  
  5855                                  @@process232:
  5856 00003CD7 A0[AF01]                 mov al, byte [Code1]
  5857 00003CDA B400                     mov ah, 0
  5858 00003CDC 50                       push ax
  5859 00003CDD E855FD                   call genCode8
  5860 00003CE0 83C402                   add  sp, 2
  5861                                  
  5862                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  5863                                  
  5864 00003CE3 A0[AF01]                 mov al, [Code1]
  5865 00003CE6 3C0F                     cmp al, 15
  5866 00003CE8 0F850C00                 jne @@process233
  5867 00003CEC A0[B001]                 mov al, byte [Code2]
  5868 00003CEF B400                     mov ah, 0
  5869 00003CF1 50                       push ax
  5870 00003CF2 E840FD                   call genCode8
  5871 00003CF5 83C402                   add  sp, 2
  5872                                  
  5873                                  ;-49         Op=Op2;//set MEM for writeEA
  5874                                  
  5875                                  @@process233:
  5876 00003CF8 A0[AD01]                 mov al, [Op2]
  5877 00003CFB A2[AC01]                 mov byte [Op], al
  5878                                  
  5879                                  ;-50         writeEA(R1No);           
  5880                                  
  5881 00003CFE A0[B301]                 mov al, byte [R1No]
  5882 00003D01 B400                     mov ah, 0
  5883 00003D03 50                       push ax
  5884 00003D04 E8A6FD                   call writeEA
  5885 00003D07 83C402                   add  sp, 2
  5886                                  
  5887                                  ;-51         return;
  5888                                  
  5889 00003D0A E92F05                   jmp @@retn
  5890                                  
  5891                                  ;-52     }
  5892                                  
  5893                                  
  5894                                  ;-53 
  5895                                  
  5896                                  
  5897                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  5898                                  
  5899                                  @@process230:
  5900 00003D0D A0[AE01]                 mov al, [CodeType]
  5901 00003D10 3C04                     cmp al, 4
  5902 00003D12 0F85EF00                 jne @@process234
  5903                                  
  5904                                  ;-55         check2Ops();    
  5905                                  
  5906 00003D16 E81AE3                   call check2Ops
  5907                                  
  5908                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  5909                                  
  5910 00003D19 A0[AD01]                 mov al, [Op2]
  5911 00003D1C 3C01                     cmp al, 1
  5912 00003D1E 0F857900                 jne @@process235
  5913                                  
  5914                                  ;-57             setsflag();   
  5915                                  
  5916 00003D22 E8F1E6                   call setsflag
  5917                                  
  5918                                  ;-58             if (Op == REG) {                
  5919                                  
  5920 00003D25 A0[AC01]                 mov al, [Op]
  5921 00003D28 3C02                     cmp al, 2
  5922 00003D2A 0F853100                 jne @@process236
  5923                                  
  5924                                  ;-59                 if (R1No == 0) {// acc,imm   
  5925                                  
  5926 00003D2E A0[B301]                 mov al, [R1No]
  5927 00003D31 3C00                     cmp al, 0
  5928 00003D33 0F852800                 jne @@process237
  5929                                  
  5930                                  ;-60                     if (sflag == 0) {                        
  5931                                  
  5932 00003D37 A0[B901]                 mov al, [sflag]
  5933 00003D3A 3C00                     cmp al, 0
  5934 00003D3C 0F851F00                 jne @@process238
  5935                                  
  5936                                  ;-61                         c = Code1 << 3;
  5937                                  
  5938 00003D40 A0[AF01]                 mov al, [Code1]
  5939 00003D43 C0E003                   shl al, 3
  5940 00003D46 8846FE                   mov byte [bp-2], al
  5941                                  
  5942                                  ;-62                         c += 4;    
  5943                                  
  5944 00003D49 8046FE04                 add  byte [bp-2], 4
  5945                                  
  5946                                  ;-63                         genCodeW(c);
  5947                                  
  5948 00003D4D 8A46FE                   mov al, byte [bp-2]
  5949 00003D50 B400                     mov ah, 0
  5950 00003D52 50                       push ax
  5951 00003D53 E8C3FC                   call genCodeW
  5952 00003D56 83C402                   add  sp, 2
  5953                                  
  5954                                  ;-64                         genImmediate();
  5955                                  
  5956 00003D59 E866FE                   call genImmediate
  5957                                  
  5958                                  ;-65                         return;
  5959                                  
  5960 00003D5C E9DD04                   jmp @@retn
  5961                                  
  5962                                  ;-66                     }
  5963                                  
  5964                                  
  5965                                  ;-67                 }
  5966                                  
  5967                                  @@process238:
  5968                                  
  5969                                  ;-68             }
  5970                                  
  5971                                  @@process237:
  5972                                  
  5973                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  5974                                  
  5975                                  
  5976                                  ;-70             c = sflag + 0x80;   
  5977                                  
  5978                                  @@process236:
  5979 00003D5F A0[B901]                 mov al, [sflag]
  5980 00003D62 0480                     add al, 128
  5981 00003D64 8846FE                   mov byte [bp-2], al
  5982                                  
  5983                                  ;-71             genCodeW(c); 
  5984                                  
  5985 00003D67 8A46FE                   mov al, byte [bp-2]
  5986 00003D6A B400                     mov ah, 0
  5987 00003D6C 50                       push ax
  5988 00003D6D E8A9FC                   call genCodeW
  5989 00003D70 83C402                   add  sp, 2
  5990                                  
  5991                                  ;-72             writeEA(Code1);  
  5992                                  
  5993 00003D73 A0[AF01]                 mov al, byte [Code1]
  5994 00003D76 B400                     mov ah, 0
  5995 00003D78 50                       push ax
  5996 00003D79 E831FD                   call writeEA
  5997 00003D7C 83C402                   add  sp, 2
  5998                                  
  5999                                  ;-73             if (sflag) genCode8(imme);
  6000                                  
  6001 00003D7F A0[B901]                 mov al, [sflag]
  6002 00003D82 08C0                     or  al, al
  6003 00003D84 0F840D00                 je @@process239
  6004 00003D88 FF36[BE01]               push word [imme]
  6005 00003D8C E8A6FC                   call genCode8
  6006 00003D8F 83C402                   add  sp, 2
  6007                                  
  6008                                  ;-74             else genImmediate();    
  6009                                  
  6010 00003D92 E90300                   jmp @@process240
  6011                                  @@process239:
  6012 00003D95 E82AFE                   call genImmediate
  6013                                  
  6014                                  ;-75             return;     
  6015                                  
  6016                                  @@process240:
  6017 00003D98 E9A104                   jmp @@retn
  6018                                  
  6019                                  ;-76         }  
  6020                                  
  6021                                  
  6022                                  ;-77         c = Code1 << 3;//r/m, r/r  
  6023                                  
  6024                                  @@process235:
  6025 00003D9B A0[AF01]                 mov al, [Code1]
  6026 00003D9E C0E003                   shl al, 3
  6027 00003DA1 8846FE                   mov byte [bp-2], al
  6028                                  
  6029                                  ;-78         if (Op == REG) {
  6030                                  
  6031 00003DA4 A0[AC01]                 mov al, [Op]
  6032 00003DA7 3C02                     cmp al, 2
  6033 00003DA9 0F852E00                 jne @@process241
  6034                                  
  6035                                  ;-79             if (Op2 == MEM) {//reg, mem      
  6036                                  
  6037 00003DAD A0[AD01]                 mov al, [Op2]
  6038 00003DB0 3C04                     cmp al, 4
  6039 00003DB2 0F852500                 jne @@process242
  6040                                  
  6041                                  ;-80                 c += 2;//add direction flag
  6042                                  
  6043 00003DB6 8046FE02                 add  byte [bp-2], 2
  6044                                  
  6045                                  ;-81                 genCodeW(c);
  6046                                  
  6047 00003DBA 8A46FE                   mov al, byte [bp-2]
  6048 00003DBD B400                     mov ah, 0
  6049 00003DBF 50                       push ax
  6050 00003DC0 E856FC                   call genCodeW
  6051 00003DC3 83C402                   add  sp, 2
  6052                                  
  6053                                  ;-82                 Op=Op2;//set MEM for writeEA                
  6054                                  
  6055 00003DC6 A0[AD01]                 mov al, [Op2]
  6056 00003DC9 A2[AC01]                 mov byte [Op], al
  6057                                  
  6058                                  ;-83                 writeEA(R1No);
  6059                                  
  6060 00003DCC A0[B301]                 mov al, byte [R1No]
  6061 00003DCF B400                     mov ah, 0
  6062 00003DD1 50                       push ax
  6063 00003DD2 E8D8FC                   call writeEA
  6064 00003DD5 83C402                   add  sp, 2
  6065                                  
  6066                                  ;-84                 return;    
  6067                                  
  6068 00003DD8 E96104                   jmp @@retn
  6069                                  
  6070                                  ;-85             }
  6071                                  
  6072                                  
  6073                                  ;-86         }
  6074                                  
  6075                                  @@process242:
  6076                                  
  6077                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  6078                                  
  6079                                  @@process241:
  6080 00003DDB A0[AD01]                 mov al, [Op2]
  6081 00003DDE 3C02                     cmp al, 2
  6082 00003DE0 0F851B00                 jne @@process243
  6083                                  
  6084                                  ;-88             genCodeW(c);
  6085                                  
  6086 00003DE4 8A46FE                   mov al, byte [bp-2]
  6087 00003DE7 B400                     mov ah, 0
  6088 00003DE9 50                       push ax
  6089 00003DEA E82CFC                   call genCodeW
  6090 00003DED 83C402                   add  sp, 2
  6091                                  
  6092                                  ;-89             writeEA(R2No);//2. Op in reg-field
  6093                                  
  6094 00003DF0 A0[B201]                 mov al, byte [R2No]
  6095 00003DF3 B400                     mov ah, 0
  6096 00003DF5 50                       push ax
  6097 00003DF6 E8B4FC                   call writeEA
  6098 00003DF9 83C402                   add  sp, 2
  6099                                  
  6100                                  ;-90             return;            
  6101                                  
  6102 00003DFC E93D04                   jmp @@retn
  6103                                  
  6104                                  ;-91         }          
  6105                                  
  6106                                  
  6107                                  ;-92         syntaxerror();        
  6108                                  
  6109                                  @@process243:
  6110 00003DFF E81DF8                   call syntaxerror
  6111                                  
  6112                                  ;-93         return;
  6113                                  
  6114 00003E02 E93704                   jmp @@retn
  6115                                  
  6116                                  ;-94     }
  6117                                  
  6118                                  
  6119                                  ;-95  
  6120                                  
  6121                                  
  6122                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  6123                                  
  6124                                  @@process234:
  6125 00003E05 A0[AE01]                 mov al, [CodeType]
  6126 00003E08 3C05                     cmp al, 5
  6127 00003E0A 0F857F01                 jne @@process244
  6128                                  
  6129                                  ;-97         check2Ops();    
  6130                                  
  6131 00003E0E E822E2                   call check2Ops
  6132                                  
  6133                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  6134                                  
  6135                                  
  6136                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6137                                  
  6138                                  
  6139                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6140                                  
  6141                                  
  6142                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6143                                  
  6144                                  
  6145                                  ;-102         if (Op2 == ADR) {
  6146                                  
  6147 00003E11 A0[AD01]                 mov al, [Op2]
  6148 00003E14 3C03                     cmp al, 3
  6149 00003E16 0F850F00                 jne @@process245
  6150                                  
  6151                                  ;-103             imme=disp;
  6152                                  
  6153 00003E1A A1[BC01]                 mov ax, [disp]
  6154 00003E1D A3[BE01]                 mov word [imme], ax
  6155                                  
  6156                                  ;-104             Op2=IMM;//continue with IMM    
  6157                                  
  6158 00003E20 66B801000000             mov eax, 1
  6159 00003E26 A2[AD01]                 mov byte [Op2], al
  6160                                  
  6161                                  ;-105         }  
  6162                                  
  6163                                  
  6164                                  ;-106         if (Op2 == IMM) {// r,i     
  6165                                  
  6166                                  @@process245:
  6167 00003E29 A0[AD01]                 mov al, [Op2]
  6168 00003E2C 3C01                     cmp al, 1
  6169 00003E2E 0F855400                 jne @@process246
  6170                                  
  6171                                  ;-107             if (Op == REG) {               
  6172                                  
  6173 00003E32 A0[AC01]                 mov al, [Op]
  6174 00003E35 3C02                     cmp al, 2
  6175 00003E37 0F852500                 jne @@process247
  6176                                  
  6177                                  ;-108                 c = wflag << 3;   
  6178                                  
  6179 00003E3B A0[B701]                 mov al, [wflag]
  6180 00003E3E C0E003                   shl al, 3
  6181 00003E41 8846FE                   mov byte [bp-2], al
  6182                                  
  6183                                  ;-109                 c += 0xB0;                                     
  6184                                  
  6185 00003E44 8046FEB0                 add  byte [bp-2], 176
  6186                                  
  6187                                  ;-110                 genCode2(c, R1No);   
  6188                                  
  6189 00003E48 A0[B301]                 mov al, byte [R1No]
  6190 00003E4B B400                     mov ah, 0
  6191 00003E4D 50                       push ax
  6192 00003E4E 8A46FE                   mov al, byte [bp-2]
  6193 00003E51 B400                     mov ah, 0
  6194 00003E53 50                       push ax
  6195 00003E54 E8A7FB                   call genCode2
  6196 00003E57 83C404                   add  sp, 4
  6197                                  
  6198                                  ;-111                 genImmediate();
  6199                                  
  6200 00003E5A E865FD                   call genImmediate
  6201                                  
  6202                                  ;-112                 return; 
  6203                                  
  6204 00003E5D E9DC03                   jmp @@retn
  6205                                  
  6206                                  ;-113             }
  6207                                  
  6208                                  
  6209                                  ;-114             if (Op == MEM) {// m,i  
  6210                                  
  6211                                  @@process247:
  6212 00003E60 A0[AC01]                 mov al, [Op]
  6213 00003E63 3C04                     cmp al, 4
  6214 00003E65 0F851700                 jne @@process248
  6215                                  
  6216                                  ;-115                 genCodeW(0xC6);
  6217                                  
  6218 00003E69 68C600                   push 198
  6219 00003E6C E8AAFB                   call genCodeW
  6220 00003E6F 83C402                   add  sp, 2
  6221                                  
  6222                                  ;-116                 writeEA( 0 );
  6223                                  
  6224 00003E72 6A00                     push 0
  6225 00003E74 E836FC                   call writeEA
  6226 00003E77 83C402                   add  sp, 2
  6227                                  
  6228                                  ;-117                 genImmediate();
  6229                                  
  6230 00003E7A E845FD                   call genImmediate
  6231                                  
  6232                                  ;-118                 return;  
  6233                                  
  6234 00003E7D E9BC03                   jmp @@retn
  6235                                  
  6236                                  ;-119             }
  6237                                  
  6238                                  
  6239                                  ;-120             regmemerror();
  6240                                  
  6241                                  @@process248:
  6242 00003E80 E823F7                   call regmemerror
  6243                                  
  6244                                  ;-121             return;
  6245                                  
  6246 00003E83 E9B603                   jmp @@retn
  6247                                  
  6248                                  ;-122         }      
  6249                                  
  6250                                  
  6251                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6252                                  
  6253                                  @@process246:
  6254 00003E86 A0[B501]                 mov al, [R1Type]
  6255 00003E89 3C04                     cmp al, 4
  6256 00003E8B 0F850300                 jne @@process249
  6257 00003E8F E8DAE0                   call ChangeDirection
  6258                                  
  6259                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6260                                  
  6261                                  @@process249:
  6262 00003E92 A0[B401]                 mov al, [R2Type]
  6263 00003E95 3C04                     cmp al, 4
  6264 00003E97 0F852A00                 jne @@process250
  6265                                  
  6266                                  ;-125             if (OpSize != WORD) reg16error();
  6267                                  
  6268 00003E9B A0[B601]                 mov al, [OpSize]
  6269 00003E9E 3C02                     cmp al, 2
  6270 00003EA0 0F840300                 je  @@process251
  6271 00003EA4 E829F7                   call reg16error
  6272                                  
  6273                                  ;-126                 genCode2(0x8C, dflag);
  6274                                  
  6275                                  @@process251:
  6276 00003EA7 A0[B801]                 mov al, byte [dflag]
  6277 00003EAA B400                     mov ah, 0
  6278 00003EAC 50                       push ax
  6279 00003EAD 688C00                   push 140
  6280 00003EB0 E84BFB                   call genCode2
  6281 00003EB3 83C404                   add  sp, 4
  6282                                  
  6283                                  ;-127                 writeEA(R2No);
  6284                                  
  6285 00003EB6 A0[B201]                 mov al, byte [R2No]
  6286 00003EB9 B400                     mov ah, 0
  6287 00003EBB 50                       push ax
  6288 00003EBC E8EEFB                   call writeEA
  6289 00003EBF 83C402                   add  sp, 2
  6290                                  
  6291                                  ;-128                 return;   
  6292                                  
  6293 00003EC2 E97703                   jmp @@retn
  6294                                  
  6295                                  ;-129         }          
  6296                                  
  6297                                  
  6298                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6299                                  
  6300                                  @@process250:
  6301 00003EC5 A0[AD01]                 mov al, [Op2]
  6302 00003EC8 3C04                     cmp al, 4
  6303 00003ECA 0F853100                 jne @@process252
  6304                                  
  6305                                  ;-131             if (Op == REG) {
  6306                                  
  6307 00003ECE A0[AC01]                 mov al, [Op]
  6308 00003ED1 3C02                     cmp al, 2
  6309 00003ED3 0F852800                 jne @@process253
  6310                                  
  6311                                  ;-132                 if (R1No == 0) {
  6312                                  
  6313 00003ED7 A0[B301]                 mov al, [R1No]
  6314 00003EDA 3C00                     cmp al, 0
  6315 00003EDC 0F851F00                 jne @@process254
  6316                                  
  6317                                  ;-133                     if (isDirect) {
  6318                                  
  6319 00003EE0 A0[BB01]                 mov al, [isDirect]
  6320 00003EE3 08C0                     or  al, al
  6321 00003EE5 0F841600                 je @@process255
  6322                                  
  6323                                  ;-134                         genCodeW(0xA0);
  6324                                  
  6325 00003EE9 68A000                   push 160
  6326 00003EEC E82AFB                   call genCodeW
  6327 00003EEF 83C402                   add  sp, 2
  6328                                  
  6329                                  ;-135                         genCode16(disp);
  6330                                  
  6331 00003EF2 FF36[BC01]               push word [disp]
  6332 00003EF6 E893FB                   call genCode16
  6333 00003EF9 83C402                   add  sp, 2
  6334                                  
  6335                                  ;-136                         return;   
  6336                                  
  6337 00003EFC E93D03                   jmp @@retn
  6338                                  
  6339                                  ;-137                     }   
  6340                                  
  6341                                  
  6342                                  ;-138                 }   
  6343                                  
  6344                                  @@process255:
  6345                                  
  6346                                  ;-139             }   
  6347                                  
  6348                                  @@process254:
  6349                                  
  6350                                  ;-140         } 
  6351                                  
  6352                                  @@process253:
  6353                                  
  6354                                  ;-141         if (Op == MEM) {//moffs16, acc
  6355                                  
  6356                                  @@process252:
  6357 00003EFF A0[AC01]                 mov al, [Op]
  6358 00003F02 3C04                     cmp al, 4
  6359 00003F04 0F853100                 jne @@process256
  6360                                  
  6361                                  ;-142             if (Op2 == REG) {
  6362                                  
  6363 00003F08 A0[AD01]                 mov al, [Op2]
  6364 00003F0B 3C02                     cmp al, 2
  6365 00003F0D 0F852800                 jne @@process257
  6366                                  
  6367                                  ;-143                 if (R2No == 0) {
  6368                                  
  6369 00003F11 A0[B201]                 mov al, [R2No]
  6370 00003F14 3C00                     cmp al, 0
  6371 00003F16 0F851F00                 jne @@process258
  6372                                  
  6373                                  ;-144                     if (isDirect) {
  6374                                  
  6375 00003F1A A0[BB01]                 mov al, [isDirect]
  6376 00003F1D 08C0                     or  al, al
  6377 00003F1F 0F841600                 je @@process259
  6378                                  
  6379                                  ;-145                         genCodeW(0xA2);
  6380                                  
  6381 00003F23 68A200                   push 162
  6382 00003F26 E8F0FA                   call genCodeW
  6383 00003F29 83C402                   add  sp, 2
  6384                                  
  6385                                  ;-146                         genCode16(disp);
  6386                                  
  6387 00003F2C FF36[BC01]               push word [disp]
  6388 00003F30 E859FB                   call genCode16
  6389 00003F33 83C402                   add  sp, 2
  6390                                  
  6391                                  ;-147                         return;   
  6392                                  
  6393 00003F36 E90303                   jmp @@retn
  6394                                  
  6395                                  ;-148                     }   
  6396                                  
  6397                                  
  6398                                  ;-149                 }   
  6399                                  
  6400                                  @@process259:
  6401                                  
  6402                                  ;-150             }
  6403                                  
  6404                                  @@process258:
  6405                                  
  6406                                  ;-151         
  6407                                  
  6408                                  
  6409                                  ;-152         }
  6410                                  
  6411                                  @@process257:
  6412                                  
  6413                                  ;-153         if (Op2 == REG) {//rm, r
  6414                                  
  6415                                  @@process256:
  6416 00003F39 A0[AD01]                 mov al, [Op2]
  6417 00003F3C 3C02                     cmp al, 2
  6418 00003F3E 0F851800                 jne @@process260
  6419                                  
  6420                                  ;-154             genCodeW(0x88);     
  6421                                  
  6422 00003F42 688800                   push 136
  6423 00003F45 E8D1FA                   call genCodeW
  6424 00003F48 83C402                   add  sp, 2
  6425                                  
  6426                                  ;-155             writeEA(R2No);
  6427                                  
  6428 00003F4B A0[B201]                 mov al, byte [R2No]
  6429 00003F4E B400                     mov ah, 0
  6430 00003F50 50                       push ax
  6431 00003F51 E859FB                   call writeEA
  6432 00003F54 83C402                   add  sp, 2
  6433                                  
  6434                                  ;-156             return;
  6435                                  
  6436 00003F57 E9E202                   jmp @@retn
  6437                                  
  6438                                  ;-157         }
  6439                                  
  6440                                  
  6441                                  ;-158         if (Op2 == MEM) {//r, m
  6442                                  
  6443                                  @@process260:
  6444 00003F5A A0[AD01]                 mov al, [Op2]
  6445 00003F5D 3C04                     cmp al, 4
  6446 00003F5F 0F852400                 jne @@process261
  6447                                  
  6448                                  ;-159             if (Op == REG) {
  6449                                  
  6450 00003F63 A0[AC01]                 mov al, [Op]
  6451 00003F66 3C02                     cmp al, 2
  6452 00003F68 0F851B00                 jne @@process262
  6453                                  
  6454                                  ;-160                 ChangeDirection();
  6455                                  
  6456 00003F6C E8FDDF                   call ChangeDirection
  6457                                  
  6458                                  ;-161                 genCodeW(0x8A);
  6459                                  
  6460 00003F6F 688A00                   push 138
  6461 00003F72 E8A4FA                   call genCodeW
  6462 00003F75 83C402                   add  sp, 2
  6463                                  
  6464                                  ;-162                 writeEA(R2No);
  6465                                  
  6466 00003F78 A0[B201]                 mov al, byte [R2No]
  6467 00003F7B B400                     mov ah, 0
  6468 00003F7D 50                       push ax
  6469 00003F7E E82CFB                   call writeEA
  6470 00003F81 83C402                   add  sp, 2
  6471                                  
  6472                                  ;-163                 return;   
  6473                                  
  6474 00003F84 E9B502                   jmp @@retn
  6475                                  
  6476                                  ;-164             }   
  6477                                  
  6478                                  
  6479                                  ;-165         }         
  6480                                  
  6481                                  @@process262:
  6482                                  
  6483                                  ;-166         syntaxerror();
  6484                                  
  6485                                  @@process261:
  6486 00003F87 E895F6                   call syntaxerror
  6487                                  
  6488                                  ;-167         return;
  6489                                  
  6490 00003F8A E9AF02                   jmp @@retn
  6491                                  
  6492                                  ;-168     }    
  6493                                  
  6494                                  
  6495                                  ;-169     
  6496                                  
  6497                                  
  6498                                  ;-170     if (CodeType == 6) {//Jcc short jumps       
  6499                                  
  6500                                  @@process244:
  6501 00003F8D A0[AE01]                 mov al, [CodeType]
  6502 00003F90 3C06                     cmp al, 6
  6503 00003F92 0F85B300                 jne @@process263
  6504                                  
  6505                                  ;-171 
  6506                                  
  6507                                  
  6508                                  ;-172 
  6509                                  
  6510                                  
  6511                                  ;-173         if (TokeType == ALNUME) {
  6512                                  
  6513 00003F96 A0[AB01]                 mov al, [TokeType]
  6514 00003F99 3C03                     cmp al, 3
  6515 00003F9B 0F85A700                 jne @@process264
  6516                                  
  6517                                  ;-174             LabelIx=searchLabel();
  6518                                  
  6519 00003F9F E8D1E7                   call searchLabel
  6520 00003FA2 A3[7E06]                 mov word [LabelIx], ax
  6521                                  
  6522                                  ;-175             if (LabelIx) {
  6523                                  
  6524 00003FA5 A1[7E06]                 mov ax, [LabelIx]
  6525 00003FA8 08C0                     or  al, al
  6526 00003FAA 0F847000                 je @@process265
  6527                                  
  6528                                  ;-176                 disp=LabelAddr[LabelIx];
  6529                                  
  6530 00003FAE 8B1E[7E06]               mov bx, [LabelIx]
  6531 00003FB2 D1E3                     shl bx, 1
  6532 00003FB4 8B87[B405]               mov ax, [LabelAddr + bx]
  6533 00003FB8 A3[BC01]                 mov word [disp], ax
  6534                                  
  6535                                  ;-177                 disp = disp - PC;
  6536                                  
  6537 00003FBB A1[BC01]                 mov ax, [disp]
  6538 00003FBE 2B06[A601]               sub ax, [PC]
  6539 00003FC2 A3[BC01]                 mov word [disp], ax
  6540                                  
  6541                                  ;-178                 if (checkConstSize(disp) ) {
  6542                                  
  6543 00003FC5 FF36[BC01]               push word [disp]
  6544 00003FC9 E8AFE4                   call checkConstSize
  6545 00003FCC 83C402                   add  sp, 2
  6546 00003FCF 08C0                     or  al, al
  6547 00003FD1 0F842000                 je @@process266
  6548                                  
  6549                                  ;-179                     genCode2(Code1, 0x70);       
  6550                                  
  6551 00003FD5 6A70                     push 112
  6552 00003FD7 A0[AF01]                 mov al, byte [Code1]
  6553 00003FDA B400                     mov ah, 0
  6554 00003FDC 50                       push ax
  6555 00003FDD E81EFA                   call genCode2
  6556 00003FE0 83C404                   add  sp, 4
  6557                                  
  6558                                  ;-180                     disp -= 2; 
  6559                                  
  6560 00003FE3 832E[BC01]02             sub  word [disp], 2
  6561                                  
  6562                                  ;-181                     genCode8(disp);   
  6563                                  
  6564 00003FE8 FF36[BC01]               push word [disp]
  6565 00003FEC E846FA                   call genCode8
  6566 00003FEF 83C402                   add  sp, 2
  6567                                  
  6568                                  ;-182                 } else {     
  6569                                  
  6570 00003FF2 E92600                   jmp @@process267
  6571                                  @@process266:
  6572                                  
  6573                                  ;-183                     genCode8(0x0F);
  6574                                  
  6575 00003FF5 6A0F                     push 15
  6576 00003FF7 E83BFA                   call genCode8
  6577 00003FFA 83C402                   add  sp, 2
  6578                                  
  6579                                  ;-184                     genCode2(Code1, 0x80);       
  6580                                  
  6581 00003FFD 688000                   push 128
  6582 00004000 A0[AF01]                 mov al, byte [Code1]
  6583 00004003 B400                     mov ah, 0
  6584 00004005 50                       push ax
  6585 00004006 E8F5F9                   call genCode2
  6586 00004009 83C404                   add  sp, 4
  6587                                  
  6588                                  ;-185                     disp -= 4; 
  6589                                  
  6590 0000400C 832E[BC01]04             sub  word [disp], 4
  6591                                  
  6592                                  ;-186                     genCode16(disp);                       
  6593                                  
  6594 00004011 FF36[BC01]               push word [disp]
  6595 00004015 E874FA                   call genCode16
  6596 00004018 83C402                   add  sp, 2
  6597                                  
  6598                                  ;-187                 }    
  6599                                  
  6600                                  
  6601                                  ;-188             }
  6602                                  
  6603                                  @@process267:
  6604                                  
  6605                                  ;-189             else {//jump forward
  6606                                  
  6607 0000401B E92800                   jmp @@process268
  6608                                  @@process265:
  6609                                  
  6610                                  ;-190                 genCode8(0x0F);
  6611                                  
  6612 0000401E 6A0F                     push 15
  6613 00004020 E812FA                   call genCode8
  6614 00004023 83C402                   add  sp, 2
  6615                                  
  6616                                  ;-191                 genCode2(Code1, 0x80);
  6617                                  
  6618 00004026 688000                   push 128
  6619 00004029 A0[AF01]                 mov al, byte [Code1]
  6620 0000402C B400                     mov ah, 0
  6621 0000402E 50                       push ax
  6622 0000402F E8CCF9                   call genCode2
  6623 00004032 83C404                   add  sp, 4
  6624                                  
  6625                                  ;-192                 genCode16(0);
  6626                                  
  6627 00004035 6A00                     push 0
  6628 00004037 E852FA                   call genCode16
  6629 0000403A 83C402                   add  sp, 2
  6630                                  
  6631                                  ;-193                 PrintRA='R';
  6632                                  
  6633 0000403D 66B852000000             mov eax, 82
  6634 00004043 A2[C901]                 mov byte [PrintRA], al
  6635                                  
  6636                                  ;-194                 
  6637                                  
  6638                                  
  6639                                  ;-195             }   
  6640                                  
  6641                                  
  6642                                  ;-196         }
  6643                                  
  6644                                  @@process268:
  6645                                  
  6646                                  ;-197         return;   
  6647                                  
  6648                                  @@process264:
  6649 00004046 E9F301                   jmp @@retn
  6650                                  
  6651                                  ;-198     }
  6652                                  
  6653                                  
  6654                                  ;-199     
  6655                                  
  6656                                  
  6657                                  ;-200     if (CodeType ==  8) {//ret,retf
  6658                                  
  6659                                  @@process263:
  6660 00004049 A0[AE01]                 mov al, [CodeType]
  6661 0000404C 3C08                     cmp al, 8
  6662 0000404E 0F853100                 jne @@process269
  6663                                  
  6664                                  ;-201         if (TokeType == DIGIT) {
  6665                                  
  6666 00004052 A0[AB01]                 mov al, [TokeType]
  6667 00004055 3C01                     cmp al, 1
  6668 00004057 0F851900                 jne @@process270
  6669                                  
  6670                                  ;-202             genCode8(Code2);
  6671                                  
  6672 0000405B A0[B001]                 mov al, byte [Code2]
  6673 0000405E B400                     mov ah, 0
  6674 00004060 50                       push ax
  6675 00004061 E8D1F9                   call genCode8
  6676 00004064 83C402                   add  sp, 2
  6677                                  
  6678                                  ;-203             genCode16(SymbolInt);
  6679                                  
  6680 00004067 FF36[4D00]               push word [SymbolInt]
  6681 0000406B E81EFA                   call genCode16
  6682 0000406E 83C402                   add  sp, 2
  6683                                  
  6684                                  ;-204             return;
  6685                                  
  6686 00004071 E9C801                   jmp @@retn
  6687                                  
  6688                                  ;-205         }
  6689                                  
  6690                                  
  6691                                  ;-206         genCode8(Code1); 
  6692                                  
  6693                                  @@process270:
  6694 00004074 A0[AF01]                 mov al, byte [Code1]
  6695 00004077 B400                     mov ah, 0
  6696 00004079 50                       push ax
  6697 0000407A E8B8F9                   call genCode8
  6698 0000407D 83C402                   add  sp, 2
  6699                                  
  6700                                  ;-207         return;
  6701                                  
  6702 00004080 E9B901                   jmp @@retn
  6703                                  
  6704                                  ;-208     }
  6705                                  
  6706                                  
  6707                                  ;-209        
  6708                                  
  6709                                  
  6710                                  ;-210     if (CodeType == 9) {//push, pop  
  6711                                  
  6712                                  @@process269:
  6713 00004083 A0[AE01]                 mov al, [CodeType]
  6714 00004086 3C09                     cmp al, 9
  6715 00004088 0F850301                 jne @@process271
  6716                                  
  6717                                  ;-211         getOpL();
  6718                                  
  6719 0000408C E8FFDF                   call getOpL
  6720                                  
  6721                                  ;-212         if (Code1 == 0x50) {//push only
  6722                                  
  6723 0000408F A0[AF01]                 mov al, [Code1]
  6724 00004092 3C50                     cmp al, 80
  6725 00004094 0F853D00                 jne @@process272
  6726                                  
  6727                                  ;-213             if (Op == IMM) {//push imm8,16
  6728                                  
  6729 00004098 A0[AC01]                 mov al, [Op]
  6730 0000409B 3C01                     cmp al, 1
  6731 0000409D 0F853400                 jne @@process273
  6732                                  
  6733                                  ;-214                 setsflag();
  6734                                  
  6735 000040A1 E872E3                   call setsflag
  6736                                  
  6737                                  ;-215                 genCode2(0x68, sflag);     
  6738                                  
  6739 000040A4 A0[B901]                 mov al, byte [sflag]
  6740 000040A7 B400                     mov ah, 0
  6741 000040A9 50                       push ax
  6742 000040AA 6A68                     push 104
  6743 000040AC E84FF9                   call genCode2
  6744 000040AF 83C404                   add  sp, 4
  6745                                  
  6746                                  ;-216                 if (sflag) genCode8 (imme);
  6747                                  
  6748 000040B2 A0[B901]                 mov al, [sflag]
  6749 000040B5 08C0                     or  al, al
  6750 000040B7 0F840D00                 je @@process274
  6751 000040BB FF36[BE01]               push word [imme]
  6752 000040BF E873F9                   call genCode8
  6753 000040C2 83C402                   add  sp, 2
  6754                                  
  6755                                  ;-217                 else       genCode16(imme);    
  6756                                  
  6757 000040C5 E90A00                   jmp @@process275
  6758                                  @@process274:
  6759 000040C8 FF36[BE01]               push word [imme]
  6760 000040CC E8BDF9                   call genCode16
  6761 000040CF 83C402                   add  sp, 2
  6762                                  
  6763                                  ;-218                 return;   
  6764                                  
  6765                                  @@process275:
  6766 000040D2 E96701                   jmp @@retn
  6767                                  
  6768                                  ;-219             }   
  6769                                  
  6770                                  
  6771                                  ;-220         }
  6772                                  
  6773                                  @@process273:
  6774                                  
  6775                                  ;-221         if (R1Type == SEGREG) {
  6776                                  
  6777                                  @@process272:
  6778 000040D5 A0[B501]                 mov al, [R1Type]
  6779 000040D8 3C04                     cmp al, 4
  6780 000040DA 0F855A00                 jne @@process276
  6781                                  
  6782                                  ;-222             if (Code1 == 0x58) {
  6783                                  
  6784 000040DE A0[AF01]                 mov al, [Code1]
  6785 000040E1 3C58                     cmp al, 88
  6786 000040E3 0F851200                 jne @@process277
  6787                                  
  6788                                  ;-223                 if (R1No == 1) error1("pop cs not allowed");   
  6789                                  
  6790 000040E7 A0[B301]                 mov al, [R1No]
  6791 000040EA 3C01                     cmp al, 1
  6792 000040EC 0F850900                 jne @@process278
  6793 000040F0 68[3E42]                 push process_0
  6794 000040F3 E86AF3                   call error1
  6795 000040F6 83C402                   add  sp, 2
  6796                                  
  6797                                  ;-224             }
  6798                                  
  6799                                  @@process278:
  6800                                  
  6801                                  ;-225             c = R1No <<3;
  6802                                  
  6803                                  @@process277:
  6804 000040F9 A0[B301]                 mov al, [R1No]
  6805 000040FC C0E003                   shl al, 3
  6806 000040FF 8846FE                   mov byte [bp-2], al
  6807                                  
  6808                                  ;-226             if (R1No > 3) {//FS, GS
  6809                                  
  6810 00004102 A0[B301]                 mov al, [R1No]
  6811 00004105 3C03                     cmp al, 3
  6812 00004107 0F8E0C00                 jle @@process279
  6813                                  
  6814                                  ;-227                 c += 122;
  6815                                  
  6816 0000410B 8046FE7A                 add  byte [bp-2], 122
  6817                                  
  6818                                  ;-228                 genCode8(0x0F);
  6819                                  
  6820 0000410F 6A0F                     push 15
  6821 00004111 E821F9                   call genCode8
  6822 00004114 83C402                   add  sp, 2
  6823                                  
  6824                                  ;-229             }
  6825                                  
  6826                                  
  6827                                  ;-230             OpCodePtr++;
  6828                                  
  6829                                  @@process279:
  6830 00004117 FF06[C701]               inc  word [OpCodePtr]
  6831                                  
  6832                                  ;-231             c = c + *OpCodePtr;//is Code4   
  6833                                  
  6834 0000411B 8A46FE                   mov al, [bp-2]
  6835 0000411E 8B1E[C701]               mov bx, [OpCodePtr]
  6836 00004122 0207                     add al, [bx]
  6837 00004124 B400                     mov ah, 0
  6838 00004126 8846FE                   mov byte [bp-2], al
  6839                                  
  6840                                  ;-232             genCode8(c);  
  6841                                  
  6842 00004129 8A46FE                   mov al, byte [bp-2]
  6843 0000412C B400                     mov ah, 0
  6844 0000412E 50                       push ax
  6845 0000412F E803F9                   call genCode8
  6846 00004132 83C402                   add  sp, 2
  6847                                  
  6848                                  ;-233             return; 
  6849                                  
  6850 00004135 E90401                   jmp @@retn
  6851                                  
  6852                                  ;-234         }  
  6853                                  
  6854                                  
  6855                                  ;-235         checkOpL();    
  6856                                  
  6857                                  @@process276:
  6858 00004138 E876DE                   call checkOpL
  6859                                  
  6860                                  ;-236         if (R1Type == BYTE) reg16error();
  6861                                  
  6862 0000413B A0[B501]                 mov al, [R1Type]
  6863 0000413E 3C01                     cmp al, 1
  6864 00004140 0F850300                 jne @@process280
  6865 00004144 E889F4                   call reg16error
  6866                                  
  6867                                  ;-237         if (R1Type == WORD) {
  6868                                  
  6869                                  @@process280:
  6870 00004147 A0[B501]                 mov al, [R1Type]
  6871 0000414A 3C02                     cmp al, 2
  6872 0000414C 0F851500                 jne @@process281
  6873                                  
  6874                                  ;-238             genCode2(Code1, R1No);
  6875                                  
  6876 00004150 A0[B301]                 mov al, byte [R1No]
  6877 00004153 B400                     mov ah, 0
  6878 00004155 50                       push ax
  6879 00004156 A0[AF01]                 mov al, byte [Code1]
  6880 00004159 B400                     mov ah, 0
  6881 0000415B 50                       push ax
  6882 0000415C E89FF8                   call genCode2
  6883 0000415F 83C404                   add  sp, 4
  6884                                  
  6885                                  ;-239             return;   
  6886                                  
  6887 00004162 E9D700                   jmp @@retn
  6888                                  
  6889                                  ;-240         }                
  6890                                  
  6891                                  
  6892                                  ;-241         if (Op == MEM) {
  6893                                  
  6894                                  @@process281:
  6895 00004165 A0[AC01]                 mov al, [Op]
  6896 00004168 3C04                     cmp al, 4
  6897 0000416A 0F851B00                 jne @@process282
  6898                                  
  6899                                  ;-242             genCode8(Code2);
  6900                                  
  6901 0000416E A0[B001]                 mov al, byte [Code2]
  6902 00004171 B400                     mov ah, 0
  6903 00004173 50                       push ax
  6904 00004174 E8BEF8                   call genCode8
  6905 00004177 83C402                   add  sp, 2
  6906                                  
  6907                                  ;-243             writeEA(Code3);
  6908                                  
  6909 0000417A A0[B101]                 mov al, byte [Code3]
  6910 0000417D B400                     mov ah, 0
  6911 0000417F 50                       push ax
  6912 00004180 E82AF9                   call writeEA
  6913 00004183 83C402                   add  sp, 2
  6914                                  
  6915                                  ;-244             return;   
  6916                                  
  6917 00004186 E9B300                   jmp @@retn
  6918                                  
  6919                                  ;-245         }
  6920                                  
  6921                                  
  6922                                  ;-246         syntaxerror();
  6923                                  
  6924                                  @@process282:
  6925 00004189 E893F4                   call syntaxerror
  6926                                  
  6927                                  ;-247         return;        
  6928                                  
  6929 0000418C E9AD00                   jmp @@retn
  6930                                  
  6931                                  ;-248     }
  6932                                  
  6933                                  
  6934                                  ;-249     
  6935                                  
  6936                                  
  6937                                  ;-250     if (CodeType == 12) {//int
  6938                                  
  6939                                  @@process271:
  6940 0000418F A0[AE01]                 mov al, [CodeType]
  6941 00004192 3C0C                     cmp al, 12
  6942 00004194 0F852200                 jne @@process283
  6943                                  
  6944                                  ;-251         if (TokeType == DIGIT) {            
  6945                                  
  6946 00004198 A0[AB01]                 mov al, [TokeType]
  6947 0000419B 3C01                     cmp al, 1
  6948 0000419D 0F851900                 jne @@process284
  6949                                  
  6950                                  ;-252             genCode8(Code1);
  6951                                  
  6952 000041A1 A0[AF01]                 mov al, byte [Code1]
  6953 000041A4 B400                     mov ah, 0
  6954 000041A6 50                       push ax
  6955 000041A7 E88BF8                   call genCode8
  6956 000041AA 83C402                   add  sp, 2
  6957                                  
  6958                                  ;-253             genCode8(SymbolInt);
  6959                                  
  6960 000041AD FF36[4D00]               push word [SymbolInt]
  6961 000041B1 E881F8                   call genCode8
  6962 000041B4 83C402                   add  sp, 2
  6963                                  
  6964                                  ;-254             return;   
  6965                                  
  6966 000041B7 E98200                   jmp @@retn
  6967                                  
  6968                                  ;-255         }
  6969                                  
  6970                                  
  6971                                  ;-256     }
  6972                                  
  6973                                  @@process284:
  6974                                  
  6975                                  ;-257     
  6976                                  
  6977                                  
  6978                                  ;-258     if (CodeType == 30) {//enter i18,i8
  6979                                  
  6980                                  @@process283:
  6981 000041BA A0[AE01]                 mov al, [CodeType]
  6982 000041BD 3C1E                     cmp al, 30
  6983 000041BF 0F855200                 jne @@process285
  6984                                  
  6985                                  ;-259         genCode8(0xC8);
  6986                                  
  6987 000041C3 68C800                   push 200
  6988 000041C6 E86CF8                   call genCode8
  6989 000041C9 83C402                   add  sp, 2
  6990                                  
  6991                                  ;-260         Op=getOp1();
  6992                                  
  6993 000041CC E87CDF                   call getOp1
  6994 000041CF A2[AC01]                 mov byte [Op], al
  6995                                  
  6996                                  ;-261         if (Op == IMM) genCode16(SymbolInt);
  6997                                  
  6998 000041D2 A0[AC01]                 mov al, [Op]
  6999 000041D5 3C01                     cmp al, 1
  7000 000041D7 0F850D00                 jne @@process286
  7001 000041DB FF36[4D00]               push word [SymbolInt]
  7002 000041DF E8AAF8                   call genCode16
  7003 000041E2 83C402                   add  sp, 2
  7004                                  
  7005                                  ;-262         else numbererror();
  7006                                  
  7007 000041E5 E90300                   jmp @@process287
  7008                                  @@process286:
  7009 000041E8 E8A1F3                   call numbererror
  7010                                  
  7011                                  ;-263         need(',');
  7012                                  
  7013                                  @@process287:
  7014 000041EB 6A2C                     push 44
  7015 000041ED E846E8                   call need
  7016 000041F0 83C402                   add  sp, 2
  7017                                  
  7018                                  ;-264         Op=getOp1();
  7019                                  
  7020 000041F3 E855DF                   call getOp1
  7021 000041F6 A2[AC01]                 mov byte [Op], al
  7022                                  
  7023                                  ;-265         if (Op == IMM) genCode8 (SymbolInt);
  7024                                  
  7025 000041F9 A0[AC01]                 mov al, [Op]
  7026 000041FC 3C01                     cmp al, 1
  7027 000041FE 0F850D00                 jne @@process288
  7028 00004202 FF36[4D00]               push word [SymbolInt]
  7029 00004206 E82CF8                   call genCode8
  7030 00004209 83C402                   add  sp, 2
  7031                                  
  7032                                  ;-266         else numbererror();           
  7033                                  
  7034 0000420C E90300                   jmp @@process289
  7035                                  @@process288:
  7036 0000420F E87AF3                   call numbererror
  7037                                  
  7038                                  ;-267         return;
  7039                                  
  7040                                  @@process289:
  7041 00004212 E92700                   jmp @@retn
  7042                                  
  7043                                  ;-268     }
  7044                                  
  7045                                  
  7046                                  ;-269        
  7047                                  
  7048                                  
  7049                                  ;-270     if (CodeType==101) {// ORG nn
  7050                                  
  7051                                  @@process285:
  7052 00004215 A0[AE01]                 mov al, [CodeType]
  7053 00004218 3C65                     cmp al, 101
  7054 0000421A 0F851500                 jne @@process290
  7055                                  
  7056                                  ;-271         if (TokeType != DIGIT) numbererror();
  7057                                  
  7058 0000421E A0[AB01]                 mov al, [TokeType]
  7059 00004221 3C01                     cmp al, 1
  7060 00004223 0F840300                 je  @@process291
  7061 00004227 E862F3                   call numbererror
  7062                                  
  7063                                  ;-272         PC=SymbolInt;
  7064                                  
  7065                                  @@process291:
  7066 0000422A A1[4D00]                 mov ax, [SymbolInt]
  7067 0000422D A3[A601]                 mov word [PC], ax
  7068                                  
  7069                                  ;-273         return;
  7070                                  
  7071 00004230 E90900                   jmp @@retn
  7072                                  
  7073                                  ;-274     }
  7074                                  
  7075                                  
  7076                                  ;-275     error1("Command not implemented or syntax error");
  7077                                  
  7078                                  @@process290:
  7079 00004233 68[5142]                 push process_1
  7080 00004236 E827F2                   call error1
  7081 00004239 83C402                   add  sp, 2
  7082                                  
  7083                                  ;-276 }    
  7084                                  
  7085 0000423C C9                      @@retn: LEAVE
  7086 0000423D C3                       ret
  7087                                  ; ENDP
  7088 0000423E 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  7089 00004247 7420616C6C6F776564-
  7090 00004250 00                 
  7091 00004251 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  7092 0000425A 6F7420696D706C656D-
  7093 00004263 656E746564206F7220-
  7094 0000426C 73796E746178206572-
  7095 00004275 726F7200           
  7096                                   
  7097                                  ; missing functions: 
  7098                                  ; digit
  7099                                  ; strcpy
  7100                                  ; strcpy
  7101                                  ; eqstr
  7102                                  ; strlen
  7103                                  ; eqstr
  7104                                  ; eqstr
  7105                                  ; eqstr
  7106                                  ; eqstr
  7107                                  ; readRL
  7108                                  ; readRL
  7109                                  ; digit
  7110                                  ; digit
  7111                                  ; strcpy
  7112                                  ; toupper
  7113                                  ; strlen
  7114                                  ; strlen
  7115                                  ; eqstr
  7116                                  ; eqstr
  7117                                  ; eqstr
  7118                                  ; eqstr
  7119                                  ; eqstr
  7120                                  ; eqstr
  7121                                  ; eqstr
  7122                                  ; eqstr
  7123                                  ; eqstr
  7124                                  ; eqstr
  7125                                  ; eqstr
  7126                                  ; eqstr
  7127                                  ; eqstr
  7128                                  ; eqstr
  7129                                  ; eqstr
  7130                                  ; eqstr
  7131                                  ; eqstr
  7132                                  ; eqstr
  7133                                  ; eqstr
  7134                                  ; eqstr
  7135                                  ; eqstr
  7136                                  ; eqstr
  7137                                  ; eqstr
  7138                                  ; eqstr
  7139                                  ; eqstr
  7140                                  ; eqstr
  7141                                  ; eqstr
  7142                                  ; eqstr
  7143                                  ; eqstr
  7144                                  ; eqstr
  7145                                  ; writetty
  7146                                  ; writetty
  7147                                  ; fputcR
  7148                                  ; cputs
  7149                                  ; cputs
  7150                                  ; exitR
  7151                                  ; toupper
  7152                                  ; strcpy
  7153                                  ; strcat1
  7154                                  ; strcpy
  7155                                  ; strcat1
  7156                                  ; strcpy
  7157                                  ; strcat1
  7158                                  ; openR
  7159                                  ; cputs
  7160                                  ; cputs
  7161                                  ; exitR
  7162                                  ; creatR
  7163                                  ; cputs
  7164                                  ; cputs
  7165                                  ; exitR
  7166                                  ; creatR
  7167                                  ; cputs
  7168                                  ; cputs
  7169                                  ; exitR
  7170                                  ; fputcR
  7171                                  ; fcloseR
  7172                                  ; fcloseR
  7173                                  ; fcloseR
  7174                                  ; exitR
  7175                                  ; Number of unresolved CALLs :   77
  7176                                  ;use archive file: AR.C
  7177                                  
  7178                                  ;-277 // AR.C Archive
  7179                                  
  7180                                  ;Number of CALLs:    2 : writetty
  7181                                  
  7182                                  writetty:  ; *** PROC ***
  7183 00004279 B40E                     mov  ah, 14
  7184 0000427B BB0000                   mov  bx, 0
  7185 0000427E CD10                     int  16
  7186                                  
  7187                                  ;-278 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  7188                                  
  7189 00004280 C3                       ret
  7190                                  ; ENDP
  7191                                  ;Number of CALLs:    8 : cputs
  7192                                  
  7193                                  cputs:  ; *** PROC ***
  7194                                  ;Function : cputs, Number of local variables: 2
  7195                                  ;   # type sign width line used address name   list of local variables
  7196                                  ;  200 ptr sign byte   278 NULL bp+4    s
  7197                                  ;  201 var sign byte   278 NULL bp-2    c;
  7198 00004281 C8020000                 ENTER  2,0
  7199                                  @@cputs292:
  7200 00004285 8B5E04                   mov bx, [bp+4]
  7201 00004288 8A07                     mov al, [bx]
  7202 0000428A B400                     mov ah, 0
  7203 0000428C 08C0                     or  al, al
  7204 0000428E 0F841B00                 je @@cputs293
  7205 00004292 8B5E04                   mov bx, [bp+4]
  7206 00004295 8A07                     mov al, [bx]
  7207 00004297 B400                     mov ah, 0
  7208 00004299 8846FE                   mov byte [bp-2], al
  7209 0000429C 8A46FE                   mov al, byte [bp-2]
  7210 0000429F B400                     mov ah, 0
  7211 000042A1 50                       push ax
  7212 000042A2 E8C401                   call putch
  7213 000042A5 83C402                   add  sp, 2
  7214 000042A8 FF4604                   inc  word [bp+4]
  7215 000042AB EBD8                     jmp @@cputs292
  7216                                  @@cputs293:
  7217                                  
  7218                                  ;-279 int mkneg(int n) { n; __asm {neg ax} }
  7219 000042AD C9                       LEAVE
  7220 000042AE C3                       ret
  7221                                  ; ENDP
  7222                                  ;Number of CALLs:    2 : toupper
  7223                                  
  7224                                  toupper:  ; *** PROC ***
  7225                                  ;Function : toupper, Number of local variables: 1
  7226                                  ;   # type sign width line used address name   list of local variables
  7227                                  ;  200 ptr sign byte   279 NULL bp+4    s;
  7228 000042AF C8000000                 ENTER  0,0
  7229                                  @@toupper294:
  7230 000042B3 8B5E04                   mov bx, [bp+4]
  7231 000042B6 8A07                     mov al, [bx]
  7232 000042B8 B400                     mov ah, 0
  7233 000042BA 08C0                     or  al, al
  7234 000042BC 0F843000                 je @@toupper295
  7235 000042C0 8B5E04                   mov bx, [bp+4]
  7236 000042C3 8A07                     mov al, [bx]
  7237 000042C5 B400                     mov ah, 0
  7238 000042C7 83F861                   cmp ax, 97 ;unsigned : 1
  7239 000042CA 0F8C1D00                 jl  @@toupper296
  7240 000042CE 8B5E04                   mov bx, [bp+4]
  7241 000042D1 8A07                     mov al, [bx]
  7242 000042D3 B400                     mov ah, 0
  7243 000042D5 83F87A                   cmp ax, 122
  7244 000042D8 0F8F0F00                 jg  @@toupper297
  7245 000042DC 8B5E04                   mov bx, [bp+4]
  7246 000042DF 8A07                     mov al, [bx]
  7247 000042E1 B400                     mov ah, 0
  7248 000042E3 83E820                   sub ax, 32
  7249 000042E6 8B5E04                   mov  bx, [bp+4]
  7250 000042E9 8807                     mov  [bx], al
  7251                                  @@toupper297:
  7252                                  @@toupper296:
  7253 000042EB FF4604                   inc  word [bp+4]
  7254 000042EE EBC3                     jmp @@toupper294
  7255                                  @@toupper295:
  7256                                  
  7257                                  ;-280 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  7258                                  
  7259                                  
  7260                                  ;-281 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  7261 000042F0 C9                       LEAVE
  7262 000042F1 C3                       ret
  7263                                  ; ENDP
  7264                                  ;Number of CALLs:    3 : strlen
  7265                                  
  7266                                  strlen:  ; *** PROC ***
  7267                                  ;Function : strlen, Number of local variables: 2
  7268                                  ;   # type sign width line used address name   list of local variables
  7269                                  ;  200 ptr sign byte   281 NULL bp+4    s
  7270                                  ;  201 var sign word   281 NULL bp-2    c;
  7271 000042F2 C8020000                 ENTER  2,0
  7272 000042F6 66B800000000             mov eax, 0
  7273 000042FC 8946FE                   mov word [bp-2], ax
  7274                                  @@strlen298:
  7275 000042FF 8B5E04                   mov bx, [bp+4]
  7276 00004302 8A07                     mov al, [bx]
  7277 00004304 B400                     mov ah, 0
  7278 00004306 83F800                   cmp ax, 0
  7279 00004309 0F840800                 je  @@strlen299
  7280 0000430D FF4604                   inc  word [bp+4]
  7281 00004310 FF46FE                   inc  word [bp-2]
  7282 00004313 EBEA                     jmp @@strlen298
  7283                                  @@strlen299:
  7284 00004315 8B46FE                   mov ax, [bp-2]
  7285 00004318 E90000                   jmp @@retn
  7286                                  
  7287                                  ;-282 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  7288                                  
  7289 0000431B C9                      @@retn: LEAVE
  7290 0000431C C3                       ret
  7291                                  ; ENDP
  7292                                  ;Number of CALLs:    6 : strcpy
  7293                                  
  7294                                  strcpy:  ; *** PROC ***
  7295                                  ;Function : strcpy, Number of local variables: 2
  7296                                  ;   # type sign width line used address name   list of local variables
  7297                                  ;  200 ptr sign byte   282 NULL bp+4    s
  7298                                  ;  201 ptr sign byte   282 NULL bp+6    t;
  7299 0000431D C8000000                 ENTER  0,0
  7300                                  @@strcpy300:
  7301 00004321 8B5E06                   mov bx, [bp+6]
  7302 00004324 8A07                     mov al, [bx]
  7303 00004326 B400                     mov ah, 0
  7304 00004328 8B5E04                   mov  bx, [bp+4]
  7305 0000432B 8807                     mov  [bx], al
  7306 0000432D FF4604                   inc  word [bp+4]
  7307 00004330 FF4606                   inc  word [bp+6]
  7308                                  
  7309                                  ;-283   while (*t!=0); *s=0; return s; }
  7310                                  
  7311 00004333 8B5E06                   mov bx, [bp+6]
  7312 00004336 8A07                     mov al, [bx]
  7313 00004338 B400                     mov ah, 0
  7314 0000433A 83F800                   cmp ax, 0
  7315 0000433D 0F840200                 je  @@strcpy301
  7316 00004341 EBDE                     jmp @@strcpy300
  7317                                  @@strcpy301:
  7318 00004343 66B800000000             mov eax, 0
  7319 00004349 8B5E04                   mov  bx, [bp+4]
  7320 0000434C 8807                     mov  [bx], al
  7321 0000434E 8B4604                   mov ax, [bp+4]
  7322 00004351 E90000                   jmp @@retn
  7323                                  
  7324                                  ;-284 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  7325                                  
  7326 00004354 C9                      @@retn: LEAVE
  7327 00004355 C3                       ret
  7328                                  ; ENDP
  7329                                  ;Number of CALLs:    3 : digit
  7330                                  
  7331                                  digit:  ; *** PROC ***
  7332                                  ;Function : digit, Number of local variables: 1
  7333                                  ;   # type sign width line used address name   list of local variables
  7334                                  ;  200 var sign byte   284 NULL bp+4    c;
  7335 00004356 C8000000                 ENTER  0,0
  7336 0000435A 8A4604                   mov al, [bp+4]
  7337 0000435D 3C30                     cmp al, 48
  7338 0000435F 0F8D0900                 jge @@digit302
  7339 00004363 66B800000000             mov eax, 0
  7340 00004369 E91B00                   jmp @@retn
  7341                                  @@digit302:
  7342 0000436C 8A4604                   mov al, [bp+4]
  7343 0000436F 3C39                     cmp al, 57
  7344 00004371 0F8E0900                 jle @@digit303
  7345 00004375 66B800000000             mov eax, 0
  7346 0000437B E90900                   jmp @@retn
  7347                                  @@digit303:
  7348 0000437E 66B801000000             mov eax, 1
  7349 00004384 E90000                   jmp @@retn
  7350                                  
  7351                                  ;-285 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  7352                                  
  7353 00004387 C9                      @@retn: LEAVE
  7354 00004388 C3                       ret
  7355                                  ; ENDP
  7356                                  ;Number of CALLs:   35 : eqstr
  7357                                  
  7358                                  eqstr:  ; *** PROC ***
  7359                                  ;Function : eqstr, Number of local variables: 2
  7360                                  ;   # type sign width line used address name   list of local variables
  7361                                  ;  200 ptr sign byte   285 NULL bp+4    p
  7362                                  ;  201 ptr sign byte   285 NULL bp+6    q;
  7363 00004389 C8000000                 ENTER  0,0
  7364                                  @@eqstr304:
  7365 0000438D 8B5E04                   mov bx, [bp+4]
  7366 00004390 8A07                     mov al, [bx]
  7367 00004392 B400                     mov ah, 0
  7368 00004394 08C0                     or  al, al
  7369 00004396 0F842300                 je @@eqstr305
  7370                                  
  7371                                  ;-286     if (*p != *q) return 0; p++; q++; }
  7372                                  
  7373 0000439A 8B5E04                   mov bx, [bp+4]
  7374 0000439D 8A07                     mov al, [bx]
  7375 0000439F B400                     mov ah, 0
  7376 000043A1 8B5E06                   mov bx, [bp+6]
  7377 000043A4 3A07                     cmp al, [bx]
  7378 000043A6 B400                     mov ah, 0
  7379 000043A8 0F840900                 je  @@eqstr306
  7380 000043AC 66B800000000             mov eax, 0
  7381 000043B2 E92700                   jmp @@retn
  7382                                  @@eqstr306:
  7383 000043B5 FF4604                   inc  word [bp+4]
  7384 000043B8 FF4606                   inc  word [bp+6]
  7385                                  
  7386                                  ;-287     if(*q) return 0; return 1; }
  7387                                  
  7388 000043BB EBD0                     jmp @@eqstr304
  7389                                  @@eqstr305:
  7390 000043BD 8B5E06                   mov bx, [bp+6]
  7391 000043C0 8A07                     mov al, [bx]
  7392 000043C2 B400                     mov ah, 0
  7393 000043C4 08C0                     or  al, al
  7394 000043C6 0F840900                 je @@eqstr307
  7395 000043CA 66B800000000             mov eax, 0
  7396 000043D0 E90900                   jmp @@retn
  7397                                  @@eqstr307:
  7398 000043D3 66B801000000             mov eax, 1
  7399 000043D9 E90000                   jmp @@retn
  7400                                  
  7401                                  ;-288 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  7402                                  
  7403 000043DC C9                      @@retn: LEAVE
  7404 000043DD C3                       ret
  7405                                  ; ENDP
  7406                                  ;Number of CALLs:    3 : strcat1
  7407                                  
  7408                                  strcat1:  ; *** PROC ***
  7409                                  ;Function : strcat1, Number of local variables: 2
  7410                                  ;   # type sign width line used address name   list of local variables
  7411                                  ;  200 ptr sign byte   288 NULL bp+4    s
  7412                                  ;  201 ptr sign byte   288 NULL bp+6    t;
  7413 000043DE C8000000                 ENTER  0,0
  7414                                  @@strcat1308:
  7415 000043E2 8B5E04                   mov bx, [bp+4]
  7416 000043E5 8A07                     mov al, [bx]
  7417 000043E7 B400                     mov ah, 0
  7418 000043E9 83F800                   cmp ax, 0
  7419 000043EC 0F840500                 je  @@strcat1309
  7420 000043F0 FF4604                   inc  word [bp+4]
  7421 000043F3 EBED                     jmp @@strcat1308
  7422                                  @@strcat1309:
  7423 000043F5 FF7606                   push word [bp+6]
  7424 000043F8 FF7604                   push word [bp+4]
  7425 000043FB E81FFF                   call strcpy
  7426 000043FE 83C404                   add  sp, 4
  7427                                  
  7428                                  ;-289 int basename(char *s) { char *p; p=0;
  7429 00004401 C9                       LEAVE
  7430 00004402 C3                       ret
  7431                                  ; ENDP
  7432                                  ;Number of CALLs:    1 : openR
  7433                                  
  7434                                  openR:  ; *** PROC ***
  7435                                  ;Function : openR, Number of local variables: 1
  7436                                  ;   # type sign width line used address name   list of local variables
  7437                                  ;  200 ptr sign byte   289 NULL bp+4    s;
  7438 00004403 C8000000                 ENTER  0,0
  7439 00004407 8B5604                   mov  dx, [bp+4]
  7440 0000440A B8023D                   mov  ax, 15618
  7441 0000440D E87200                   call DosInt
  7442                                  
  7443                                  ;-290 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  7444 00004410 C9                       LEAVE
  7445 00004411 C3                       ret
  7446                                  ; ENDP
  7447                                  ;Number of CALLs:    2 : creatR
  7448                                  
  7449                                  creatR:  ; *** PROC ***
  7450                                  ;Function : creatR, Number of local variables: 1
  7451                                  ;   # type sign width line used address name   list of local variables
  7452                                  ;  200 ptr sign byte   290 NULL bp+4    s;
  7453 00004412 C8000000                 ENTER  0,0
  7454 00004416 8B5604                   mov  dx, [bp+4]
  7455 00004419 B90000                   mov  cx, 0
  7456 0000441C B8003C                   mov  ax, 15360
  7457 0000441F E86000                   call DosInt
  7458                                  
  7459                                  ;-291 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  7460 00004422 C9                       LEAVE
  7461 00004423 C3                       ret
  7462                                  ; ENDP
  7463                                  ;Number of CALLs:    2 : readRL
  7464                                  
  7465                                  readRL:  ; *** PROC ***
  7466                                  ;Function : readRL, Number of local variables: 3
  7467                                  ;   # type sign width line used address name   list of local variables
  7468                                  ;  200 ptr sign byte   291 NULL bp+4    s
  7469                                  ;  201 var sign word   291 NULL bp+6    fd
  7470                                  ;  202 var sign word   291 NULL bp+8    len;
  7471 00004424 C8000000                 ENTER  0,0
  7472 00004428 8B5604                   mov  dx, [bp+4]
  7473 0000442B 8B4E08                   mov  cx, [bp+8]
  7474 0000442E 8B5E06                   mov  bx, [bp+6]
  7475 00004431 B8003F                   mov  ax, 16128
  7476 00004434 E84B00                   call DosInt
  7477                                  
  7478                                  ;-292 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  7479 00004437 C9                       LEAVE
  7480 00004438 C3                       ret
  7481                                  ; ENDP
  7482                                  ;Number of CALLs:    2 : fputcR
  7483                                  
  7484                                  fputcR:  ; *** PROC ***
  7485                                  ;Function : fputcR, Number of local variables: 2
  7486                                  ;   # type sign width line used address name   list of local variables
  7487                                  ;  200 ptr sign byte   292 NULL bp+4    n
  7488                                  ;  201 var sign word   292 NULL bp+6    fd;
  7489 00004439 C8000000                 ENTER  0,0
  7490 0000443D 8D5604                  lea dx, [bp+4]
  7491                                  
  7492                                  ;-293   cx=1; bx=fd; ax=0x4000; DosInt(); }
  7493                                  
  7494 00004440 B90100                   mov  cx, 1
  7495 00004443 8B5E06                   mov  bx, [bp+6]
  7496 00004446 B80040                   mov  ax, 16384
  7497 00004449 E83600                   call DosInt
  7498                                  
  7499                                  ;-294 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  7500 0000444C C9                       LEAVE
  7501 0000444D C3                       ret
  7502                                  ; ENDP
  7503                                  ;Number of CALLs:    3 : fcloseR
  7504                                  
  7505                                  fcloseR:  ; *** PROC ***
  7506                                  ;Function : fcloseR, Number of local variables: 1
  7507                                  ;   # type sign width line used address name   list of local variables
  7508                                  ;  200 var sign word   294 NULL bp+4    fd;
  7509 0000444E C8000000                 ENTER  0,0
  7510 00004452 8B5E04                   mov  bx, [bp+4]
  7511 00004455 B8003E                   mov  ax, 15872
  7512 00004458 CD21                     int  33
  7513                                  
  7514                                  ;-295 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  7515 0000445A C9                       LEAVE
  7516 0000445B C3                       ret
  7517                                  ; ENDP
  7518                                  ;Number of CALLs:    5 : exitR
  7519                                  
  7520                                  exitR:  ; *** PROC ***
  7521                                  ;Function : exitR, Number of local variables: 1
  7522                                  ;   # type sign width line used address name   list of local variables
  7523                                  ;  200 var sign byte   295 NULL bp+4    c;
  7524 0000445C C8000000                 ENTER  0,0
  7525 00004460 B44C                     mov  ah, 76
  7526 00004462 8A4604                   mov  al, [bp+4]
  7527 00004465 CD21                     int  33
  7528                                  
  7529                                  ;-296 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  7530 00004467 C9                       LEAVE
  7531 00004468 C3                       ret
  7532                                  ; ENDP
  7533                                  ;End of archive file. 
  7534                                   
  7535                                  ; missing functions: 
  7536                                  ; putch
  7537                                  ; DosInt
  7538                                  ; DosInt
  7539                                  ; DosInt
  7540                                  ; DosInt
  7541                                  ; Number of unresolved CALLs :    5
  7542                                  ;use archive file: AR.C
  7543                                  
  7544                                  ;-297 // AR.C Archive
  7545                                  
  7546                                  ;Number of CALLs:    1 : putch
  7547                                  
  7548                                  putch:  ; *** PROC ***
  7549                                  ;Function : putch, Number of local variables: 1
  7550                                  ;   # type sign width line used address name   list of local variables
  7551                                  ;  200 var sign byte   297 NULL bp+4    c;
  7552 00004469 C8000000                 ENTER  0,0
  7553 0000446D 807E040A                cmp byte [bp+4], 10
  7554 00004471 0F850500                 jne @@putch310
  7555 00004475 B00D                     mov  al, 13
  7556 00004477 E8FFFD                   call writetty
  7557                                  @@putch310:
  7558 0000447A 8A4604                   mov  al, [bp+4]
  7559 0000447D E8F9FD                   call writetty
  7560                                  
  7561                                  ;-298 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  7562 00004480 C9                       LEAVE
  7563 00004481 C3                       ret
  7564                                  ; ENDP
  7565                                  ;Number of CALLs:    4 : DosInt
  7566                                  
  7567                                  DosInt:  ; *** PROC ***
  7568 00004482 CD21                     int  33
  7569 00004484 7304                     jae short @@DosInt311
  7570 00004486 FF06[9F01]               inc  word [DOS_ERR]
  7571                                  @@DosInt311:
  7572                                  
  7573                                  ;-299 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  7574                                  
  7575 0000448A C3                       ret
  7576                                  ; ENDP
  7577                                  ;End of archive file. 
  7578                                   
  7579                                  ; missing functions:  All FUNCTIONs in place
  7580 0000448B E80000                  LastFunctionByt:db 0E8h, 0, 0
  7581 0000448E 58                      pop ax
  7582 0000448F C3                      ret
  7583                                   
  7584                                  ;   # type sign width line used  address name   list of global variables
  7585                                  
  7586                                  ;    1 arr sign byte     1    2        0 Version1[10]
  7587                                  ;    2 var sign byte     1    3        0 LIST
  7588                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  7589                                  ;    4 arr sign byte     3    9        0 Symbol[31]
  7590                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  7591                                  ;    6 var unsg word     5   15        0 SymbolInt
  7592                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  7593                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  7594                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  7595                                  ;   10 arr sign byte     9    5        0 namein[67]
  7596                                  ;   11 arr sign byte    10    6        0 namelst[67]
  7597                                  ;   12 arr sign byte    11    5        0 namebin[67]
  7598                                  ;   13 var sign word    12    4        0 asm_fd
  7599                                  ;   14 var sign word    13    3        0 lst_fd
  7600                                  ;   15 var sign word    14    3        0 bin_fd
  7601                                  ;   16 var sign word    15    6        0 DOS_ERR
  7602                                  ;   17 var sign word    16    4        0 ErrorCount
  7603                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  7604                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  7605                                  ;   20 var unsg word    20    7        0 PC
  7606                                  ;   21 var unsg word    21    2        0 PCStart
  7607                                  ;   22 var sign byte    22    3        0 isLabel
  7608                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  7609                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  7610                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  7611                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  7612                                  ;   27 var sign byte    27   23        0 TokeType
  7613                                  ;   28 def unsg byte    28    -        0 BYTE=1
  7614                                  ;   29 def unsg byte    29    -        0 WORD=2
  7615                                  ;   30 def unsg byte    30    -        0 DWORD=3
  7616                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  7617                                  ;   32 def unsg byte    32    -        0 IMM=1
  7618                                  ;   33 def unsg byte    33    -        0 REG=2
  7619                                  ;   34 def unsg byte    34    -        0 ADR=3
  7620                                  ;   35 def unsg byte    35    -        0 MEM=4
  7621                                  ;   36 var sign byte    36   28        0 Op
  7622                                  ;   37 var sign byte    37   29        0 Op2
  7623                                  ;   38 var sign byte    38   19        0 CodeType
  7624                                  ;   39 var sign byte    39   16        0 Code1
  7625                                  ;   40 var sign byte    40    7        0 Code2
  7626                                  ;   41 var sign byte    41    3        0 Code3
  7627                                  ;   42 var sign byte    42   18        0 R2No
  7628                                  ;   43 var sign byte    43   16        0 R1No
  7629                                  ;   44 var sign byte    44   17        0 R2Type
  7630                                  ;   45 var sign byte    45   14        0 R1Type
  7631                                  ;   46 var sign byte    46   13        0 OpSize
  7632                                  ;   47 var sign byte    47    8        0 wflag
  7633                                  ;   48 var sign byte    48    3        0 dflag
  7634                                  ;   49 var sign byte    49    8        0 sflag
  7635                                  ;   50 var sign byte    50   15        0 rm
  7636                                  ;   51 var sign byte    51    5        0 isDirect
  7637                                  ;   52 var sign word    52   25        0 disp
  7638                                  ;   53 var unsg word    53   10        0 imme
  7639                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  7640                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  7641                                  ;   56 var sign word    57    6        0 OpPrintIndex
  7642                                  ;   57 ptr sign byte    58   19        0 OpCodePtr
  7643                                  ;   58 var sign byte    59    3        0 PrintRA
  7644                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  7645                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  7646                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  7647                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  7648                                  ;   63 arr unsg word    65    4        0 LabelAddr[100]
  7649                                  ;   64 var sign word    66    4        0 LabelMaxIx
  7650                                  ;   65 var sign word    67    7        0 LabelIx
  7651                                  ;   66 def unsg byte    69    -        0 JMPCALLMAX=500
  7652                                  ;   67 def unsg byte    70    -        0 JMPCALLNAMESMAX=1969
  7653                                  ;   68 arr sign byte    71    2        0 JmpCallNames[2000]
  7654                                  ;   69 var sign byte    72    5        0 JmpCallNamePtr
  7655                                  ;   70 arr unsg word    73    1        0 JmpCallAddr[500]
  7656                                  ;   71 arr sign byte    74    1        0 JmpCallRelAbs[500]
  7657                                  ;   72 var sign word    75    4        0 JmpCallMaxIx
  7658                                  ;   73 def unsg byte    77    -        0 FILEBINMAX=2000
  7659                                  ;   74 arr sign byte    78    2        0 FileBin[2000]
  7660                                  ;   75 var unsg word    79    5        0 BinLen
  7661                                  ;   76 ptr sign byte    81    1        0 arglen
  7662                                  ;   77 ptr sign byte    82    4        0 argv
  7663                                  ;   78 var sign byte     1    1        0 I_START
  7664                                  ;   79 arr sign byte     4 NULL        0 I_PUSHA[9]
  7665                                  ;   80 arr sign byte     5 NULL        0 I_POPA[8]
  7666                                  ;   81 arr sign byte     6 NULL        0 I_NOP[7]
  7667                                  ;   82 arr sign byte     7 NULL        0 I_CBW[7]
  7668                                  ;   83 arr sign byte     8 NULL        0 I_CWDE[8]
  7669                                  ;   84 arr sign byte     9 NULL        0 I_CWD[7]
  7670                                  ;   85 arr sign byte    10 NULL        0 I_CDQ[7]
  7671                                  ;   86 arr sign byte    11 NULL        0 I_WAIT[8]
  7672                                  ;   87 arr sign byte    12 NULL        0 I_PUSHF[9]
  7673                                  ;   88 arr sign byte    13 NULL        0 I_POPF[8]
  7674                                  ;   89 arr sign byte    14 NULL        0 I_SAHF[8]
  7675                                  ;   90 arr sign byte    15 NULL        0 I_LAHF[8]
  7676                                  ;   91 arr sign byte    16 NULL        0 I_MOVSB[9]
  7677                                  ;   92 arr sign byte    17 NULL        0 I_MOVSW[9]
  7678                                  ;   93 arr sign byte    18 NULL        0 I_CMPSB[9]
  7679                                  ;   94 arr sign byte    19 NULL        0 I_CMPSW[9]
  7680                                  ;   95 arr sign byte    20 NULL        0 I_STOSB[9]
  7681                                  ;   96 arr sign byte    21 NULL        0 I_STOSW[9]
  7682                                  ;   97 arr sign byte    22 NULL        0 I_LODSB[9]
  7683                                  ;   98 arr sign byte    23 NULL        0 I_LODSW[9]
  7684                                  ;   99 arr sign byte    24 NULL        0 I_SCASB[9]
  7685                                  ;  100 arr sign byte    25 NULL        0 I_SCASW[9]
  7686                                  ;  101 arr sign byte    26 NULL        0 I_LEAVE[9]
  7687                                  ;  102 arr sign byte    27 NULL        0 I_INT3[8]
  7688                                  ;  103 arr sign byte    28 NULL        0 I_INTO[8]
  7689                                  ;  104 arr sign byte    29 NULL        0 I_IRET[8]
  7690                                  ;  105 arr sign byte    30 NULL        0 I_XLAT[8]
  7691                                  ;  106 arr sign byte    31 NULL        0 I_LOCK[8]
  7692                                  ;  107 arr sign byte    32 NULL        0 I_REPNE[9]
  7693                                  ;  108 arr sign byte    33 NULL        0 I_REPNZ[9]
  7694                                  ;  109 arr sign byte    34 NULL        0 I_REPE[8]
  7695                                  ;  110 arr sign byte    35 NULL        0 I_REPZ[8]
  7696                                  ;  111 arr sign byte    36 NULL        0 I_HLT[7]
  7697                                  ;  112 arr sign byte    37 NULL        0 I_CLC[7]
  7698                                  ;  113 arr sign byte    38 NULL        0 I_STC[7]
  7699                                  ;  114 arr sign byte    39 NULL        0 I_CLI[7]
  7700                                  ;  115 arr sign byte    40 NULL        0 I_STI[7]
  7701                                  ;  116 arr sign byte    41 NULL        0 I_CLD[7]
  7702                                  ;  117 arr sign byte    42 NULL        0 I_STD[7]
  7703                                  ;  118 arr sign byte    44 NULL        0 I_INC[9]
  7704                                  ;  119 arr sign byte    45 NULL        0 I_DEC[9]
  7705                                  ;  120 arr sign byte    46 NULL        0 I_NOT[8]
  7706                                  ;  121 arr sign byte    47 NULL        0 I_NEG[8]
  7707                                  ;  122 arr sign byte    48 NULL        0 I_MUL[8]
  7708                                  ;  123 arr sign byte    49 NULL        0 I_IMUL[9]
  7709                                  ;  124 arr sign byte    50 NULL        0 I_DIV[8]
  7710                                  ;  125 arr sign byte    51 NULL        0 I_IDIV[9]
  7711                                  ;  126 arr sign byte    53 NULL        0 I_LES[7]
  7712                                  ;  127 arr sign byte    54 NULL        0 I_LDS[7]
  7713                                  ;  128 arr sign byte    55 NULL        0 I_LEA[7]
  7714                                  ;  129 arr sign byte    56 NULL        0 I_LSS[8]
  7715                                  ;  130 arr sign byte    57 NULL        0 I_LFS[8]
  7716                                  ;  131 arr sign byte    58 NULL        0 I_LGS[8]
  7717                                  ;  132 arr sign byte    60 NULL        0 I_ADD[7]
  7718                                  ;  133 arr sign byte    61 NULL        0 I_OR[6]
  7719                                  ;  134 arr sign byte    62 NULL        0 I_ADC[7]
  7720                                  ;  135 arr sign byte    63 NULL        0 I_SBB[7]
  7721                                  ;  136 arr sign byte    64 NULL        0 I_AND[7]
  7722                                  ;  137 arr sign byte    65 NULL        0 I_SUB[7]
  7723                                  ;  138 arr sign byte    66 NULL        0 I_XOR[7]
  7724                                  ;  139 arr sign byte    67 NULL        0 I_CMP[7]
  7725                                  ;  140 arr sign byte    68 NULL        0 I_TEST[11]
  7726                                  ;  141 arr sign byte    70 NULL        0 I_MOV[6]
  7727                                  ;  142 arr sign byte    71 NULL        0 I_MOVSX[9]
  7728                                  ;  143 arr sign byte    72 NULL        0 I_MOVZX[9]
  7729                                  ;  144 arr sign byte    74 NULL        0 I_JO[6]
  7730                                  ;  145 arr sign byte    75 NULL        0 I_JNO[7]
  7731                                  ;  146 arr sign byte    76 NULL        0 I_JB[6]
  7732                                  ;  147 arr sign byte    77 NULL        0 I_JC[6]
  7733                                  ;  148 arr sign byte    78 NULL        0 I_JNB[7]
  7734                                  ;  149 arr sign byte    79 NULL        0 I_JAE[7]
  7735                                  ;  150 arr sign byte    80 NULL        0 I_JNC[7]
  7736                                  ;  151 arr sign byte    81 NULL        0 I_JE[6]
  7737                                  ;  152 arr sign byte    82 NULL        0 I_JZ[6]
  7738                                  ;  153 arr sign byte    83 NULL        0 I_JNE[7]
  7739                                  ;  154 arr sign byte    84 NULL        0 I_JNZ[7]
  7740                                  ;  155 arr sign byte    85 NULL        0 I_JBE[7]
  7741                                  ;  156 arr sign byte    86 NULL        0 I_JNA[7]
  7742                                  ;  157 arr sign byte    87 NULL        0 I_JA[6]
  7743                                  ;  158 arr sign byte    88 NULL        0 I_JS[6]
  7744                                  ;  159 arr sign byte    89 NULL        0 I_JNS[7]
  7745                                  ;  160 arr sign byte    90 NULL        0 I_JP[6]
  7746                                  ;  161 arr sign byte    91 NULL        0 I_JPE[7]
  7747                                  ;  162 arr sign byte    92 NULL        0 I_JNP[7]
  7748                                  ;  163 arr sign byte    93 NULL        0 I_JPO[7]
  7749                                  ;  164 arr sign byte    94 NULL        0 I_JL[6]
  7750                                  ;  165 arr sign byte    95 NULL        0 I_JNL[7]
  7751                                  ;  166 arr sign byte    96 NULL        0 I_JGE[7]
  7752                                  ;  167 arr sign byte    97 NULL        0 I_JLE[7]
  7753                                  ;  168 arr sign byte    98 NULL        0 I_JNG[7]
  7754                                  ;  169 arr sign byte    99 NULL        0 I_JG[6]
  7755                                  ;  170 arr sign byte   101 NULL        0 I_JMP[8]
  7756                                  ;  171 arr sign byte   102 NULL        0 I_CALL[9]
  7757                                  ;  172 arr sign byte   104 NULL        0 I_RET[8]
  7758                                  ;  173 arr sign byte   105 NULL        0 I_RETF[9]
  7759                                  ;  174 arr sign byte   107 NULL        0 I_PUSH[11]
  7760                                  ;  175 arr sign byte   108 NULL        0 I_POP[10]
  7761                                  ;  176 arr sign byte   110 NULL        0 I_ROL[7]
  7762                                  ;  177 arr sign byte   111 NULL        0 I_ROR[7]
  7763                                  ;  178 arr sign byte   112 NULL        0 I_RCL[7]
  7764                                  ;  179 arr sign byte   113 NULL        0 I_RCR[7]
  7765                                  ;  180 arr sign byte   114 NULL        0 I_SHL[7]
  7766                                  ;  181 arr sign byte   115 NULL        0 I_SAL[7]
  7767                                  ;  182 arr sign byte   116 NULL        0 I_SHR[7]
  7768                                  ;  183 arr sign byte   117 NULL        0 I_SAR[7]
  7769                                  ;  184 arr sign byte   119 NULL        0 I_INT[8]
  7770                                  ;  185 arr sign byte   130 NULL        0 I_XCHG[9]
  7771                                  ;  186 arr sign byte   140 NULL        0 I_ENTER[8]
  7772                                  ;  187 arr sign byte   142 NULL        0 I_ORG[6]
  7773                                  ;  188 arr sign byte   147 NULL        0 I_DB[5]
  7774                                  ;  189 arr sign byte   148 NULL        0 I_DW[5]
  7775                                  ;  190 arr sign byte   149 NULL        0 I_DD[5]
  7776                                  ;  191 arr sign byte   150 NULL        0 I_RESB[7]
  7777                                  ;  192 arr sign byte   151 NULL        0 I_RESW[7]
  7778                                  ;  193 arr sign byte   152 NULL        0 I_RESD[7]
  7779                                  ;  194 var sign byte   153 NULL        0 I_END
  7780                                  
  7781                                  
  7782                                  ;   # Calls Line Width  Name   list of functions
  7783                                  
  7784                                  ;    0    2    1 word   ChangeDirection
  7785                                  ;    1    2    9 word   checkOpL
  7786                                  ;    2    3   18 word   check2Ops
  7787                                  ;    3    1   27 word   get2Ops
  7788                                  ;    4    3   33 word   getOpL
  7789                                  ;    5    2   41 word   getOpR
  7790                                  ;    6    4   51 word   getOp1
  7791                                  ;    7    1   67 word   getMEM
  7792                                  ;    8    1   90 word   getIndReg1
  7793                                  ;    9    1   98 word   getIndReg2
  7794                                  ;   10    2  108 word   setwflag
  7795                                  ;   11    2  119 word   setsflag
  7796                                  ;   12    1  129 word   checkConstSize
  7797                                  ;   13    1    1 word   parse
  7798                                  ;   14   14   31 word   getTokeType
  7799                                  ;   15 NULL   42 word   storeJmpCall
  7800                                  ;   16    2   54 word   storeLabel
  7801                                  ;   17    3   66 word   searchLabel
  7802                                  ;   18    1   80 word   getVariable
  7803                                  ;   19    2  115 word   lookCode
  7804                                  ;   20    1  131 word   getCodeSize
  7805                                  ;   21    8  139 word   isToken
  7806                                  ;   22    2  147 word   need
  7807                                  ;   23    1  156 word   skipRest
  7808                                  ;   24    1    1 word   getLine
  7809                                  ;   25    1   17 word   ifEOL
  7810                                  ;   26    3   24 word   skipBlank
  7811                                  ;   27    2   29 word   letterE
  7812                                  ;   28    1   39 word   alnumE
  7813                                  ;   29    1   44 word   getDigit
  7814                                  ;   30    1   56 word   getName
  7815                                  ;   31    1   75 word   testReg
  7816                                  ;   32    1    1 word   printLine
  7817                                  ;   33    7   23 word   prc
  7818                                  ;   34    1   35 word   prscomment
  7819                                  ;   35   23   43 word   prs
  7820                                  ;   36    3   65 word   printhex8a
  7821                                  ;   37    2   70 word   printhex4
  7822                                  ;   38    1   75 word   printhex16
  7823                                  ;   39    3   80 word   printIntU
  7824                                  ;   40   24   91 word   error1
  7825                                  ;   41   14   99 word   errorexit
  7826                                  ;   42 NULL  103 word   allowederror
  7827                                  ;   43    3  104 word   addrerror
  7828                                  ;   44    1  105 word   immeerror
  7829                                  ;   45    2  106 word   implerror
  7830                                  ;   46    4  107 word   indexerror
  7831                                  ;   47    3  108 word   invaloperror
  7832                                  ;   48    4  109 word   numbererror
  7833                                  ;   49    1  110 word   regmemerror
  7834                                  ;   50    3  111 word   reg16error
  7835                                  ;   51    1  112 word   segregerror
  7836                                  ;   52    4  113 word   syntaxerror
  7837                                  ;   53 NULL  115 word   addrexit
  7838                                  ;   54 NULL  116 word   internexit
  7839                                  ;   55 NULL    1 word   main
  7840                                  ;   56    1    8 word   getarg
  7841                                  ;   57    1   42 word   epilog
  7842                                  ;   58    2   60 word   end1
  7843                                  ;   59    1    2 word   getCodes
  7844                                  ;   60    1    7 word   gen66h
  7845                                  ;   61    8    9 word   genCode2
  7846                                  ;   62   10   13 word   genCodeW
  7847                                  ;   63   27   17 word   genCode8
  7848                                  ;   64   10   28 word   genCode16
  7849                                  ;   65   10   32 word   writeEA
  7850                                  ;   66    4   74 word   genImmediate
  7851                                  ;   67    1   11 word   process
  7852                                  ;   68    4  277 word   writetty
  7853                                  ;   69    8  278 word   cputs
  7854                                  ;   70    2  279 word   toupper
  7855                                  ;   71    3  281 word   strlen
  7856                                  ;   72    7  282 word   strcpy
  7857                                  ;   73    3  284 word   digit
  7858                                  ;   74   35  285 word   eqstr
  7859                                  ;   75    3  288 word   strcat1
  7860                                  ;   76    1  289 word   openR
  7861                                  ;   77    2  290 word   creatR
  7862                                  ;   78    2  291 word   readRL
  7863                                  ;   79    2  292 word   fputcR
  7864                                  ;   80    3  294 word   fcloseR
  7865                                  ;   81    5  295 word   exitR
  7866                                  ;   82    1  297 word   putch
  7867                                  ;   83    4  298 word   DosInt
  7868                                  ;   84 NULL  299 word   LastFunctionByt
  7869                                  
  7870                                  ;    #  addr name   list of CALLs
  7871                                  
  7872                                  ;    0  1406 implerror
  7873                                  ;    1  1416 segregerror
  7874                                  ;    2  1428 setwflag
  7875                                  ;    3  1437 error1
  7876                                  ;    4  1444 error1
  7877                                  ;    5  1461 get2Ops
  7878                                  ;    6  1469 addrerror
  7879                                  ;    7  1479 invaloperror
  7880                                  ;    8  1492 immeerror
  7881                                  ;    9  1502 addrerror
  7882                                  ;   10  1512 invaloperror
  7883                                  ;   11  1525 setwflag
  7884                                  ;   12  1542 getOpL
  7885                                  ;   13  1549 need
  7886                                  ;   14  1554 getOpR
  7887                                  ;   15  1568 getOpR
  7888                                  ;   16  1582 getOp1
  7889                                  ;   17  1589 isToken
  7890                                  ;   18  1597 getMEM
  7891                                  ;   19  1604 invaloperror
  7892                                  ;   20  1617 error1
  7893                                  ;   21  1631 testReg
  7894                                  ;   22  1639 searchLabel
  7895                                  ;   23  1651 error1
  7896                                  ;   24  1667 getTokeType
  7897                                  ;   25  1679 getOp1
  7898                                  ;   26  1686 syntaxerror
  7899                                  ;   27  1698 getIndReg2
  7900                                  ;   28  1709 getIndReg1
  7901                                  ;   29  1720 isToken
  7902                                  ;   30  1728 getTokeType
  7903                                  ;   31  1740 numbererror
  7904                                  ;   32  1752 isToken
  7905                                  ;   33  1760 isToken
  7906                                  ;   34  1768 errorexit
  7907                                  ;   35  1789 indexerror
  7908                                  ;   36  1800 indexerror
  7909                                  ;   37  1824 indexerror
  7910                                  ;   38  1835 indexerror
  7911                                  ;   39  1855 gen66h
  7912                                  ;   40  1874 error1
  7913                                  ;   41  1905 getLine
  7914                                  ;   42  1913 getTokeType
  7915                                  ;   43  1925 storeLabel
  7916                                  ;   44  1936 getTokeType
  7917                                  ;   45  1948 lookCode
  7918                                  ;   46  1957 process
  7919                                  ;   47  1965 getVariable
  7920                                  ;   48  1977 skipRest
  7921                                  ;   49  1986 error1
  7922                                  ;   50  1993 error1
  7923                                  ;   51  2000 printLine
  7924                                  ;   52  2024 skipBlank
  7925                                  ;   53  2034 digit
  7926                                  ;   54  2040 getDigit
  7927                                  ;   55  2049 letterE
  7928                                  ;   56  2057 getName
  7929                                  ;   57  2080 strcpy
  7930                                  ;   58  2087 errorexit
  7931                                  ;   59  2097 errorexit
  7932                                  ;   60  2120 searchLabel
  7933                                  ;   61  2132 error1
  7934                                  ;   62  2139 strcpy
  7935                                  ;   63  2146 errorexit
  7936                                  ;   64  2156 errorexit
  7937                                  ;   65  2186 eqstr
  7938                                  ;   66  2192 strlen
  7939                                  ;   67  2213 storeLabel
  7940                                  ;   68  2224 getTokeType
  7941                                  ;   69  2236 lookCode
  7942                                  ;   70  2245 errorexit
  7943                                  ;   71  2255 errorexit
  7944                                  ;   72  2265 getTokeType
  7945                                  ;   73  2277 genCode8
  7946                                  ;   74  2286 skipBlank
  7947                                  ;   75  2296 isToken
  7948                                  ;   76  2304 genCode8
  7949                                  ;   77  2313 isToken
  7950                                  ;   78  2321 getTokeType
  7951                                  ;   79  2333 genCode16
  7952                                  ;   80  2343 isToken
  7953                                  ;   81  2351 errorexit
  7954                                  ;   82  2370 eqstr
  7955                                  ;   83  2388 eqstr
  7956                                  ;   84  2394 getTokeType
  7957                                  ;   85  2406 eqstr
  7958                                  ;   86  2412 getTokeType
  7959                                  ;   87  2424 eqstr
  7960                                  ;   88  2430 getTokeType
  7961                                  ;   89  2452 skipBlank
  7962                                  ;   90  2469 isToken
  7963                                  ;   91  2477 getTokeType
  7964                                  ;   92  2489 error1
  7965                                  ;   93  2496 prs
  7966                                  ;   94  2500 prc
  7967                                  ;   95  2513 getTokeType
  7968                                  ;   96  2525 error1
  7969                                  ;   97  2542 readRL
  7970                                  ;   98  2549 errorexit
  7971                                  ;   99  2559 errorexit
  7972                                  ;  100  2569 ifEOL
  7973                                  ;  101  2583 readRL
  7974                                  ;  102  2619 digit
  7975                                  ;  103  2625 letterE
  7976                                  ;  104  2652 digit
  7977                                  ;  105  2672 alnumE
  7978                                  ;  106  2679 errorexit
  7979                                  ;  107  2689 strcpy
  7980                                  ;  108  2696 toupper
  7981                                  ;  109  2712 strlen
  7982                                  ;  110  2719 strlen
  7983                                  ;  111  2726 eqstr
  7984                                  ;  112  2732 eqstr
  7985                                  ;  113  2738 eqstr
  7986                                  ;  114  2744 eqstr
  7987                                  ;  115  2750 eqstr
  7988                                  ;  116  2756 eqstr
  7989                                  ;  117  2762 eqstr
  7990                                  ;  118  2768 eqstr
  7991                                  ;  119  2774 eqstr
  7992                                  ;  120  2780 eqstr
  7993                                  ;  121  2786 eqstr
  7994                                  ;  122  2792 eqstr
  7995                                  ;  123  2798 eqstr
  7996                                  ;  124  2804 eqstr
  7997                                  ;  125  2810 eqstr
  7998                                  ;  126  2816 eqstr
  7999                                  ;  127  2822 eqstr
  8000                                  ;  128  2828 eqstr
  8001                                  ;  129  2834 eqstr
  8002                                  ;  130  2840 eqstr
  8003                                  ;  131  2846 eqstr
  8004                                  ;  132  2852 eqstr
  8005                                  ;  133  2858 eqstr
  8006                                  ;  134  2864 eqstr
  8007                                  ;  135  2870 eqstr
  8008                                  ;  136  2876 eqstr
  8009                                  ;  137  2882 eqstr
  8010                                  ;  138  2888 eqstr
  8011                                  ;  139  2894 eqstr
  8012                                  ;  140  2900 eqstr
  8013                                  ;  141  2920 prs
  8014                                  ;  142  2924 printhex16
  8015                                  ;  143  2935 prs
  8016                                  ;  144  2939 prc
  8017                                  ;  145  2943 printhex8a
  8018                                  ;  146  2954 prs
  8019                                  ;  147  2958 prc
  8020                                  ;  148  2962 prscomment
  8021                                  ;  149  2979 writetty
  8022                                  ;  150  2988 writetty
  8023                                  ;  151  2997 fputcR
  8024                                  ;  152  3019 prc
  8025                                  ;  153  3035 prc
  8026                                  ;  154  3056 printhex4
  8027                                  ;  155  3066 printhex4
  8028                                  ;  156  3088 prc
  8029                                  ;  157  3110 printhex8a
  8030                                  ;  158  3121 printhex8a
  8031                                  ;  159  3146 printIntU
  8032                                  ;  160  3156 prc
  8033                                  ;  161  3169 prs
  8034                                  ;  162  3173 prs
  8035                                  ;  163  3177 prs
  8036                                  ;  164  3181 prs
  8037                                  ;  165  3197 error1
  8038                                  ;  166  3204 end1
  8039                                  ;  167  3222 error1
  8040                                  ;  168  3239 error1
  8041                                  ;  169  3256 error1
  8042                                  ;  170  3273 error1
  8043                                  ;  171  3291 error1
  8044                                  ;  172  3311 error1
  8045                                  ;  173  3330 error1
  8046                                  ;  174  3349 error1
  8047                                  ;  175  3367 error1
  8048                                  ;  176  3386 error1
  8049                                  ;  177  3405 error1
  8050                                  ;  178  3421 errorexit
  8051                                  ;  179  3442 errorexit
  8052                                  ;  180  3457 getarg
  8053                                  ;  181  3464 parse
  8054                                  ;  182  3470 epilog
  8055                                  ;  183  3477 end1
  8056                                  ;  184  3501 cputs
  8057                                  ;  185  3507 cputs
  8058                                  ;  186  3513 exitR
  8059                                  ;  187  3519 toupper
  8060                                  ;  188  3527 strcpy
  8061                                  ;  189  3534 strcat1
  8062                                  ;  190  3542 strcpy
  8063                                  ;  191  3549 strcat1
  8064                                  ;  192  3557 strcpy
  8065                                  ;  193  3564 strcat1
  8066                                  ;  194  3572 openR
  8067                                  ;  195  3578 cputs
  8068                                  ;  196  3584 cputs
  8069                                  ;  197  3590 exitR
  8070                                  ;  198  3596 creatR
  8071                                  ;  199  3603 cputs
  8072                                  ;  200  3609 cputs
  8073                                  ;  201  3615 exitR
  8074                                  ;  202  3621 creatR
  8075                                  ;  203  3628 cputs
  8076                                  ;  204  3634 cputs
  8077                                  ;  205  3640 exitR
  8078                                  ;  206  3646 prs
  8079                                  ;  207  3650 prs
  8080                                  ;  208  3654 prs
  8081                                  ;  209  3658 prs
  8082                                  ;  210  3662 prs
  8083                                  ;  211  3666 prs
  8084                                  ;  212  3670 prs
  8085                                  ;  213  3674 prs
  8086                                  ;  214  3678 prs
  8087                                  ;  215  3695 prs
  8088                                  ;  216  3699 printIntU
  8089                                  ;  217  3709 prs
  8090                                  ;  218  3713 prs
  8091                                  ;  219  3717 prs
  8092                                  ;  220  3721 prs
  8093                                  ;  221  3725 printIntU
  8094                                  ;  222  3735 prs
  8095                                  ;  223  3739 fputcR
  8096                                  ;  224  3753 fcloseR
  8097                                  ;  225  3761 fcloseR
  8098                                  ;  226  3769 fcloseR
  8099                                  ;  227  3777 exitR
  8100                                  ;  228  3799 genCode8
  8101                                  ;  229  3821 genCode8
  8102                                  ;  230  3841 genCode8
  8103                                  ;  231  3861 errorexit
  8104                                  ;  232  3883 genCode8
  8105                                  ;  233  3892 genCode8
  8106                                  ;  234  3917 genCode8
  8107                                  ;  235  3926 genCode8
  8108                                  ;  236  3935 genCode16
  8109                                  ;  237  3958 genCode16
  8110                                  ;  238  3968 genCode8
  8111                                  ;  239  3987 getTokeType
  8112                                  ;  240  3999 getCodeSize
  8113                                  ;  241  4011 getCodes
  8114                                  ;  242  4020 genCode8
  8115                                  ;  243  4029 getOpL
  8116                                  ;  244  4036 checkOpL
  8117                                  ;  245  4045 genCode2
  8118                                  ;  246  4054 getTokeType
  8119                                  ;  247  4066 implerror
  8120                                  ;  248  4076 genCodeW
  8121                                  ;  249  4085 writeEA
  8122                                  ;  250  4093 check2Ops
  8123                                  ;  251  4103 reg16error
  8124                                  ;  252  4114 addrerror
  8125                                  ;  253  4124 genCode8
  8126                                  ;  254  4133 genCode8
  8127                                  ;  255  4142 writeEA
  8128                                  ;  256  4150 check2Ops
  8129                                  ;  257  4160 setsflag
  8130                                  ;  258  4169 genCodeW
  8131                                  ;  259  4178 genImmediate
  8132                                  ;  260  4191 genCodeW
  8133                                  ;  261  4200 writeEA
  8134                                  ;  262  4208 genCode8
  8135                                  ;  263  4217 genImmediate
  8136                                  ;  264  4230 genCodeW
  8137                                  ;  265  4239 writeEA
  8138                                  ;  266  4247 genCodeW
  8139                                  ;  267  4256 writeEA
  8140                                  ;  268  4264 syntaxerror
  8141                                  ;  269  4276 check2Ops
  8142                                  ;  270  4286 genCode2
  8143                                  ;  271  4295 genImmediate
  8144                                  ;  272  4308 genCodeW
  8145                                  ;  273  4317 writeEA
  8146                                  ;  274  4325 genImmediate
  8147                                  ;  275  4338 regmemerror
  8148                                  ;  276  4350 ChangeDirection
  8149                                  ;  277  4366 reg16error
  8150                                  ;  278  4377 genCode2
  8151                                  ;  279  4386 writeEA
  8152                                  ;  280  4394 genCodeW
  8153                                  ;  281  4403 genCode16
  8154                                  ;  282  4413 genCodeW
  8155                                  ;  283  4422 genCode16
  8156                                  ;  284  4432 genCodeW
  8157                                  ;  285  4441 writeEA
  8158                                  ;  286  4449 ChangeDirection
  8159                                  ;  287  4465 genCodeW
  8160                                  ;  288  4474 writeEA
  8161                                  ;  289  4482 syntaxerror
  8162                                  ;  290  4494 searchLabel
  8163                                  ;  291  4506 checkConstSize
  8164                                  ;  292  4521 genCode2
  8165                                  ;  293  4530 genCode8
  8166                                  ;  294  4539 genCode8
  8167                                  ;  295  4548 genCode2
  8168                                  ;  296  4557 genCode16
  8169                                  ;  297  4567 genCode8
  8170                                  ;  298  4576 genCode2
  8171                                  ;  299  4585 genCode16
  8172                                  ;  300  4595 genCode8
  8173                                  ;  301  4604 genCode16
  8174                                  ;  302  4614 genCode8
  8175                                  ;  303  4623 getOpL
  8176                                  ;  304  4630 setsflag
  8177                                  ;  305  4639 genCode2
  8178                                  ;  306  4648 genCode8
  8179                                  ;  307  4657 genCode16
  8180                                  ;  308  4667 error1
  8181                                  ;  309  4674 genCode8
  8182                                  ;  310  4683 genCode8
  8183                                  ;  311  4692 checkOpL
  8184                                  ;  312  4701 reg16error
  8185                                  ;  313  4712 genCode2
  8186                                  ;  314  4721 genCode8
  8187                                  ;  315  4730 writeEA
  8188                                  ;  316  4738 syntaxerror
  8189                                  ;  317  4750 genCode8
  8190                                  ;  318  4759 genCode8
  8191                                  ;  319  4768 genCode8
  8192                                  ;  320  4777 getOp1
  8193                                  ;  321  4784 genCode16
  8194                                  ;  322  4794 numbererror
  8195                                  ;  323  4806 need
  8196                                  ;  324  4811 getOp1
  8197                                  ;  325  4818 genCode8
  8198                                  ;  326  4827 numbererror
  8199                                  ;  327  4839 numbererror
  8200                                  ;  328  4851 error1
  8201                                  ;  329  4877 putch
  8202                                  ;  330  4945 strcpy
  8203                                  ;  331  4960 DosInt
  8204                                  ;  332  4976 DosInt
  8205                                  ;  333  4999 DosInt
  8206                                  ;  334  5018 DosInt
  8207                                  ;  335  5052 writetty
  8208                                  ;  336  5061 writetty
  8209                                  ;Input: AS.C, List: AS.S,  Lines:  300
  8210                                  ;Glob. variables:  194 max.:  200
  8211                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  8212                                  ;Functions      :   85 max.:  300
  8213                                  ;Calls          :  337 max.: 2000, NameField: 5093 max.:    65535
  8214                                  ;Code until     :25998 max.: 30000, free: 4002
  8215                                  ;Data (HeapEnd) :37095, resting stacksize: 28440
  8216                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
