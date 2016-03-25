     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E9DD8A                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.1";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E31-     Version1 db "AS.C V0.1",0
    10 0000000C 00                 
    11                                  
    12                                  ;-2 #include "DECL.C"
    13                                  
    14                                  ;Use include file: DECL.C
    15                                  
    16                                  ;-1 char LIST;              //listing on/off     
    17                                  
    18 0000000D 00                      LIST db 0
    19                                  
    20                                  ;-2 #define SYMBOLMAX    31
    21                                  
    22                                  
    23                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    24                                  
    25 0000000E <res 0000001F>          Symbol resb 31
    26                                  
    27                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    28                                  
    29 0000002D <res 0000001F>          SymbolUpper resb 31
    30                                  
    31                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    32                                  
    33 0000004C 0000                    SymbolInt dw 0
    34                                  
    35                                  ;-6 #define INPUTBUFMAX 127
    36                                  
    37                                  
    38                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    39                                  
    40 0000004E <res 0000007F>          InputBuf resb 127
    41                                  
    42                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    43                                  
    44 000000CD 0000                    InputPtr dw 0
    45                                  
    46                                  ;-9 char namein [67];       //input file name  .S
    47                                  
    48 000000CF <res 00000043>          namein resb 67
    49                                  
    50                                  ;-10 char namelst[67];       //list file name   .LST
    51                                  
    52 00000112 <res 00000043>          namelst resb 67
    53                                  
    54                                  ;-11 char namebin[67];       //output file name .COM
    55                                  
    56 00000155 <res 00000043>          namebin resb 67
    57                                  
    58                                  ;-12 int  asm_fd;            //input file descriptor
    59                                  
    60 00000198 0000                    asm_fd dw 0
    61                                  
    62                                  ;-13 int lst_fd;             //list file descriptor
    63                                  
    64 0000019A 0000                    lst_fd dw 0
    65                                  
    66                                  ;-14 int bin_fd;             //output file descriptor
    67                                  
    68 0000019C 0000                    bin_fd dw 0
    69                                  
    70                                  ;-15 int DOS_ERR=0;          //global var
    71                                  
    72 0000019E 0000                    DOS_ERR dw 0
    73                                  
    74                                  ;-16 int ErrorCount=0;       //number of errors
    75                                  
    76 000001A0 0000                    ErrorCount dw 0
    77                                  
    78                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
    79                                  
    80 000001A2 0000                    DOS_NoBytes dw 0
    81                                  
    82                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
    83                                  
    84 000001A4 00                      DOS_ByteRead db 0
    85                                  
    86                                  ;-19 
    87                                  
    88                                  
    89                                  ;-20 unsigned int PC=0;      //program counter
    90                                  
    91 000001A5 0000                    PC dw 0
    92                                  
    93                                  ;-21 unsigned int Origin=0;  //ORG nn
    94                                  
    95 000001A7 0000                    Origin dw 0
    96                                  
    97                                  ;-22 unsigned int PCStart;   //PC at start of line by PrintLine()
    98                                  
    99 000001A9 0000                    PCStart dw 0
   100                                  
   101                                  ;-23 char isLabel;           //by getName()
   102                                  
   103 000001AB 00                      isLabel db 0
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
   119 000001AC 00                      TokeType db 0
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
   147 000001AD 00                      Op db 0
   148                                  
   149                                  ;-38 char Op2;               //2. operand
   150                                  
   151 000001AE 00                      Op2 db 0
   152                                  
   153                                  ;-39 char CodeType;          //1-207 by searchSymbol(), must be byte size
   154                                  
   155 000001AF 00                      CodeType db 0
   156                                  
   157                                  ;-40 char Code1;             //1. Opcode
   158                                  
   159 000001B0 00                      Code1 db 0
   160                                  
   161                                  ;-41 char Code2;             //2. Opcode
   162                                  
   163 000001B1 00                      Code2 db 0
   164                                  
   165                                  ;-42 char Code3;             //3. Opcode
   166                                  
   167 000001B2 00                      Code3 db 0
   168                                  
   169                                  ;-43 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  
   170                                  
   171 000001B3 00                      R2No db 0
   172                                  
   173                                  ;-44 char R1No;              //temp for 1. register
   174                                  
   175 000001B4 00                      R1No db 0
   176                                  
   177                                  ;-45 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   178                                  
   179 000001B5 00                      R2Type db 0
   180                                  
   181                                  ;-46 char R1Type;            //temp for 1. register 
   182                                  
   183 000001B6 00                      R1Type db 0
   184                                  
   185                                  ;-47 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   186                                  
   187 000001B7 00                      OpSize db 0
   188                                  
   189                                  ;-48 char wflag;             //wordflag: 0=byte, 1=word/dword
   190                                  
   191 000001B8 00                      wflag db 0
   192                                  
   193                                  ;-49 char dflag;             //directionflag: 1=to reg MOV,ALU    
   194                                  
   195 000001B9 00                      dflag db 0
   196                                  
   197                                  ;-50 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   198                                  
   199 000001BA 00                      sflag db 0
   200                                  
   201                                  ;-51 char rm;                //combination of index and base reg
   202                                  
   203 000001BB 00                      rm db 0
   204                                  
   205                                  ;-52 char isDirect;          //set in process and getMeM, need in WriteEA
   206                                  
   207 000001BC 00                      isDirect db 0
   208                                  
   209                                  ;-53 int disp;               //displacement      0-8 bytes
   210                                  
   211 000001BD 0000                    disp dw 0
   212                                  
   213                                  ;-54 unsigned int imme;      //immediate         0-8 bytes
   214                                  
   215 000001BF 0000                    imme dw 0
   216                                  
   217                                  ;-55 
   218                                  
   219                                  
   220                                  ;-56 #define OPMAXLEN 5
   221                                  
   222                                  
   223                                  ;-57 char OpPos[OPMAXLEN];   //array for one opcode to list
   224                                  
   225 000001C1 <res 00000005>          OpPos resb 5
   226                                  
   227                                  ;-58 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   228                                  
   229 000001C6 0000                    OpPrintIndex dw 0
   230                                  
   231                                  ;-59 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   232                                  
   233 000001C8 0000                    OpCodePtr dw 0
   234                                  
   235                                  ;-60 char PrintRA;           //print * for forward relocative jmp
   236                                  
   237 000001CA 00                      PrintRA db 0
   238                                  
   239                                  ;-61 
   240                                  
   241                                  
   242                                  ;-62 #define LABELNAMESMAX 3969//next number - SYMBOLMAX
   243                                  
   244                                  
   245                                  ;-63 char LabelNames[4000];  //space for names of all labels
   246                                  
   247 000001CB <res 00000FA0>          LabelNames resb 4000
   248                                  
   249                                  ;-64 char *LabelNamePtr;     //first free position
   250                                  
   251 0000116B 0000                    LabelNamePtr dw 0
   252                                  
   253                                  ;-65 #define LABELADRMAX 600
   254                                  
   255                                  
   256                                  ;-66 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   257                                  
   258 0000116D <res 000004B0>          LabelAddr resw 600
   259                                  
   260                                  ;-67 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   261                                  
   262 0000161D 0000                    LabelMaxIx dw 0
   263                                  
   264                                  ;-68 int LabelIx;            //actual # of just searched label
   265                                  
   266 0000161F 0000                    LabelIx dw 0
   267                                  
   268                                  ;-69 
   269                                  
   270                                  
   271                                  ;-70 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX
   272                                  
   273                                  
   274                                  ;-71 char JmpCallNames[2000];//space for names of jmp, call
   275                                  
   276 00001621 <res 000007D0>          JmpCallNames resb 2000
   277                                  
   278                                  ;-72 char *JmpCallNamePtr;   //first free position 
   279                                  
   280 00001DF1 0000                    JmpCallNamePtr dw 0
   281                                  
   282                                  ;-73 #define JMPCALLMAX 500  //max. jmp and call
   283                                  
   284                                  
   285                                  ;-74 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   286                                  
   287 00001DF3 <res 000003E8>          JmpCallAddr resw 500
   288                                  
   289                                  ;-75 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   290                                  
   291 000021DB 0000                    JmpCallMaxIx dw 0
   292                                  
   293                                  ;-76  
   294                                  
   295                                  
   296                                  ;-77 #define FILEBINMAX 20000 
   297                                  
   298                                  
   299                                  ;-78 char FileBin  [FILEBINMAX];//output binary file
   300                                  
   301 000021DD <res 00004E20>          FileBin resb 20000
   302                                  
   303                                  ;-79 unsigned int BinLen=0;  //length of binary file
   304                                  
   305 00006FFD 0000                    BinLen dw 0
   306                                  
   307                                  ;-80 
   308                                  
   309                                  
   310                                  ;-81 char *arglen=0x80;      // for main only
   311                                  
   312 00006FFF 8000                    arglen dw 128
   313                                  
   314                                  ;-82 char *argv=0x82;        // for main only
   315                                  
   316 00007001 8200                    argv dw 130
   317                                  ;Back to main program: AS.C
   318                                  
   319                                  ;-3 #include "OPTABL.C"   
   320                                  
   321                                  ;Use include file: OPTABL.C
   322                                  
   323                                  ;-1 char I_START=0xF1;
   324                                  
   325 00007003 F1                      I_START db 241
   326                                  
   327                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   328                                  
   329                                  
   330                                  ;-3 //  1:   1 byte opcode
   331                                  
   332                                  
   333                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   334                                  
   335 00007004 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   336                                  
   337                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   338                                  
   339 0000700D 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   340                                  
   341                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   342                                  
   343 00007015 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   344                                  
   345                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   346                                  
   347 0000701C 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   348                                  
   349                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   350                                  
   351 00007023 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   352                                  
   353                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   354                                  
   355 0000702B 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   356                                  
   357                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   358                                  
   359 00007032 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   360                                  
   361                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   362                                  
   363 00007039 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   364                                  
   365                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   366                                  
   367 00007041 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   368                                  
   369                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   370                                  
   371 0000704A 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   372                                  
   373                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   374                                  
   375 00007052 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   376                                  
   377                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   378                                  
   379 0000705A 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   380                                  
   381                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   382                                  
   383 00007062 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   384                                  
   385                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   386                                  
   387 0000706B 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   388                                  
   389                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   390                                  
   391 00007074 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   392                                  
   393                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   394                                  
   395 0000707D 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   396                                  
   397                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   398                                  
   399 00007086 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   400                                  
   401                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   402                                  
   403 0000708F 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   404                                  
   405                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   406                                  
   407 00007098 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   408                                  
   409                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   410                                  
   411 000070A1 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   412                                  
   413                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   414                                  
   415 000070AA 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   416                                  
   417                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   418                                  
   419 000070B3 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   420                                  
   421                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   422                                  
   423 000070BC 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   424                                  
   425                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   426                                  
   427 000070C5 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   428                                  
   429                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   430                                  
   431 000070CD 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   432                                  
   433                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   434                                  
   435 000070D5 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   436                                  
   437                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   438                                  
   439 000070DD 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   440                                  
   441                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   442                                  
   443 000070E5 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   444                                  
   445                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   446                                  
   447 000070ED 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   448                                  
   449                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   450                                  
   451 000070F6 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   452                                  
   453                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   454                                  
   455 000070FF 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   456                                  
   457                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   458                                  
   459 00007107 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   460                                  
   461                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   462                                  
   463 0000710F 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   464                                  
   465                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   466                                  
   467 00007116 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   468                                  
   469                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   470                                  
   471 0000711D 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   472                                  
   473                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   474                                  
   475 00007124 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   476                                  
   477                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   478                                  
   479 0000712B 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   480                                  
   481                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   482                                  
   483 00007132 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   484                                  
   485                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   486                                  
   487 00007139 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   488                                  
   489                                  ;-43 // 2: mem reg 16 bit
   490                                  
   491                                  
   492                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   493                                  
   494 00007140 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   495                                  
   496                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   497                                  
   498 00007149 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   499                                  
   500                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   501                                  
   502 00007152 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   503                                  
   504                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   505                                  
   506 0000715A 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   507                                  
   508                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   509                                  
   510 00007162 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   511                                  
   512                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   513                                  
   514 0000716A 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   515                                  
   516                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   517                                  
   518 00007173 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   519                                  
   520                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   521                                  
   522 0000717B 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   523                                  
   524                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   525                                  
   526                                  
   527                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   528                                  
   529 00007184 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   530                                  
   531                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   532                                  
   533 0000718B 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   534                                  
   535                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   536                                  
   537 00007192 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   538                                  
   539                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   540                                  
   541 00007199 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   542                                  
   543                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   544                                  
   545 000071A1 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   546                                  
   547                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   548                                  
   549 000071A9 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   550                                  
   551                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   552                                  
   553                                  
   554                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   555                                  
   556 000071B1 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   557                                  
   558                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   559                                  
   560 000071B8 4F52000401F1            I_OR db 79,82,0,4,1,241
   561                                  
   562                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   563                                  
   564 000071BE 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   565                                  
   566                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   567                                  
   568 000071C5 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   569                                  
   570                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   571                                  
   572 000071CC 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   573                                  
   574                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   575                                  
   576 000071D3 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   577                                  
   578                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   579                                  
   580 000071DA 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   581                                  
   582                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   583                                  
   584 000071E1 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   585                                  
   586                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   587                                  
   588 000071E8 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   589 000071F1 00F1               
   590                                  
   591                                  ;-69 //  5: mov
   592                                  
   593                                  
   594                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   595                                  
   596 000071F3 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   597                                  
   598                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   599                                  
   600 000071F9 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   601                                  
   602                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   603                                  
   604 00007202 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   605                                  
   606                                  ;-73 //  6: single byte relative jump
   607                                  
   608                                  
   609                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   610                                  
   611 0000720B 4A4F000600F1            I_JO db 74,79,0,6,0,241
   612                                  
   613                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   614                                  
   615 00007211 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   616                                  
   617                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   618                                  
   619 00007218 4A42000602F1            I_JB db 74,66,0,6,2,241
   620                                  
   621                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   622                                  
   623 0000721E 4A43000602F1            I_JC db 74,67,0,6,2,241
   624                                  
   625                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   626                                  
   627 00007224 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   628                                  
   629                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   630                                  
   631 0000722B 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   632                                  
   633                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   634                                  
   635 00007232 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   636                                  
   637                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   638                                  
   639 00007239 4A45000604F1            I_JE db 74,69,0,6,4,241
   640                                  
   641                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   642                                  
   643 0000723F 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   644                                  
   645                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   646                                  
   647 00007245 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   648                                  
   649                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   650                                  
   651 0000724C 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   652                                  
   653                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   654                                  
   655 00007253 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   656                                  
   657                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   658                                  
   659 0000725A 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   660                                  
   661                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   662                                  
   663 00007261 4A41000607F1            I_JA db 74,65,0,6,7,241
   664                                  
   665                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   666                                  
   667 00007267 4A53000608F1            I_JS db 74,83,0,6,8,241
   668                                  
   669                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   670                                  
   671 0000726D 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   672                                  
   673                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   674                                  
   675 00007274 4A5000060AF1            I_JP db 74,80,0,6,10,241
   676                                  
   677                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   678                                  
   679 0000727A 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   680                                  
   681                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   682                                  
   683 00007281 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   684                                  
   685                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   686                                  
   687 00007288 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   688                                  
   689                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   690                                  
   691 0000728F 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   692                                  
   693                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   694                                  
   695 00007295 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   696                                  
   697                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   698                                  
   699 0000729C 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   700                                  
   701                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   702                                  
   703 000072A3 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   704                                  
   705                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   706                                  
   707 000072AA 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   708                                  
   709                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   710                                  
   711 000072B1 4A4700060FF1            I_JG db 74,71,0,6,15,241
   712                                  
   713                                  ;-100 //  7: jmp, call
   714                                  
   715                                  
   716                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   717                                  
   718 000072B7 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   719                                  
   720                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   721                                  
   722 000072BF 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   723                                  
   724                                  ;-103 //  8: ret
   725                                  
   726                                  
   727                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   728                                  
   729 000072C8 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   730                                  
   731                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   732                                  
   733 000072D0 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   734                                  
   735                                  ;-106 //  9: seg, r/m
   736                                  
   737                                  
   738                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   739                                  
   740 000072D9 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   741 000072E2 06F1               
   742                                  
   743                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   744                                  
   745 000072E4 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   746 000072ED F1                 
   747                                  
   748                                  ;-109 //  11: shift, rotates
   749                                  
   750                                  
   751                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   752                                  
   753 000072EE 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   754                                  
   755                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   756                                  
   757 000072F5 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   758                                  
   759                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   760                                  
   761 000072FC 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   762                                  
   763                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   764                                  
   765 00007303 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   766                                  
   767                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   768                                  
   769 0000730A 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   770                                  
   771                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 4,    0xF1};
   772                                  
   773 00007311 53414C000B04F1          I_SAL db 83,65,76,0,11,4,241
   774                                  
   775                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 5,    0xF1};
   776                                  
   777 00007318 534852000B05F1          I_SHR db 83,72,82,0,11,5,241
   778                                  
   779                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   780                                  
   781 0000731F 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   782                                  
   783                                  ;-118 //  12: int
   784                                  
   785                                  
   786                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   787                                  
   788 00007326 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
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
   822 0000732E 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
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
   853 00007337 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   854                                  
   855                                  ;-141 // 100: directives
   856                                  
   857                                  
   858                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   859                                  
   860 0000733F 4F52470065F1            I_ORG db 79,82,71,0,101,241
   861                                  
   862                                  ;-143 // section, segment .TEXT .DATA .BSS
   863                                  
   864                                  
   865                                  ;-144 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   866                                  
   867 00007345 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   868 0000734E F1                 
   869                                  
   870                                  ;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   871                                  
   872 0000734F 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   873 00007358 F1                 
   874                                  
   875                                  ;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   876                                  
   877 00007359 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   878 00007362 6EF1               
   879                                  
   880                                  ;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};
   881                                  
   882 00007364 444200C8F1              I_DB db 68,66,0,200,241
   883                                  
   884                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   885                                  
   886 00007369 445700C9F1              I_DW db 68,87,0,201,241
   887                                  
   888                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   889                                  
   890 0000736E 444400CAF1              I_DD db 68,68,0,202,241
   891                                  
   892                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   893                                  
   894 00007373 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   895                                  
   896                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   897                                  
   898 0000737A 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   899                                  
   900                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   901                                  
   902 00007381 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   903                                  
   904                                  ;-153 char I_END=0;// end of table char
   905                                  
   906 00007388 00                      I_END db 0
   907                                  ;Back to main program: AS.C
   908                                  
   909                                  ;-4 #include "OPS.C"
   910                                  
   911                                  ;Use include file: OPS.C
   912                                  
   913                                  ;-1 int ChangeDirection() {
   914                                  
   915                                  
   916                                  ChangeDirection:  ; *** PROC ***
   917                                  
   918                                  ;-2     char c;
   919                                  
   920                                  
   921                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   922                                  
   923                                  ;Function : ChangeDirection, Number of local variables: 1
   924                                  ;   # type sign width line used address name   list of local variables
   925                                  ;  200 var sign byte     2 NULL bp-2    c;
   926 00007389 C8020000                 ENTER  2,0
   927 0000738D A0[AD01]                 mov al, [Op]
   928 00007390 8846FE                   mov byte [bp-2], al
   929 00007393 A0[AE01]                 mov al, [Op2]
   930 00007396 A2[AD01]                 mov byte [Op], al
   931 00007399 8A46FE                   mov al, [bp-2]
   932 0000739C A2[AE01]                 mov byte [Op2], al
   933                                  
   934                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   935                                  
   936 0000739F A0[B601]                 mov al, [R1Type]
   937 000073A2 8846FE                   mov byte [bp-2], al
   938 000073A5 A0[B501]                 mov al, [R2Type]
   939 000073A8 A2[B601]                 mov byte [R1Type], al
   940 000073AB 8A46FE                   mov al, [bp-2]
   941 000073AE A2[B501]                 mov byte [R2Type], al
   942                                  
   943                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   944                                  
   945 000073B1 A0[B401]                 mov al, [R1No]
   946 000073B4 8846FE                   mov byte [bp-2], al
   947 000073B7 A0[B301]                 mov al, [R2No]
   948 000073BA A2[B401]                 mov byte [R1No], al
   949 000073BD 8A46FE                   mov al, [bp-2]
   950 000073C0 A2[B301]                 mov byte [R2No], al
   951                                  
   952                                  ;-6     dflag=2;     
   953                                  
   954 000073C3 66B802000000             mov eax, 2
   955 000073C9 A2[B901]                 mov byte [dflag], al
   956                                  
   957                                  ;-7 }
   958                                  
   959                                  
   960                                  ;-8      
   961                                  
   962                                  
   963                                  ;-9 int checkOpL() {
   964 000073CC C9                       LEAVE
   965 000073CD C3                       ret
   966                                  ; ENDP
   967                                  
   968                                  checkOpL:  ; *** PROC ***
   969                                  
   970                                  ;-10     if (Op == ADR) implerror();
   971                                  
   972 000073CE A0[AD01]                 mov al, [Op]
   973 000073D1 3C03                     cmp al, 3
   974 000073D3 0F850300                 jne @@checkOpL1
   975 000073D7 E8A415                   call implerror
   976                                  
   977                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   978                                  
   979                                  @@checkOpL1:
   980 000073DA A0[B601]                 mov al, [R1Type]
   981 000073DD 3C04                     cmp al, 4
   982 000073DF 0F850600                 jne @@checkOpL2
   983 000073E3 E86016                   call segregerror
   984 000073E6 E93E00                   jmp @@retn
   985                                  
   986                                  ;-12     setwflag();
   987                                  
   988                                  @@checkOpL2:
   989 000073E9 E8CB03                   call setwflag
   990                                  
   991                                  ;-13     if (OpSize == 0) error1("no op size declared");
   992                                  
   993 000073EC A0[B701]                 mov al, [OpSize]
   994 000073EF 3C00                     cmp al, 0
   995 000073F1 0F850900                 jne @@checkOpL3
   996 000073F5 68[2874]                 push checkOpL_0
   997 000073F8 E8B314                   call error1
   998 000073FB 83C402                   add  sp, 2
   999                                  
  1000                                  ;-14     if (OpSize == R1Type) return;
  1001                                  
  1002                                  @@checkOpL3:
  1003 000073FE A0[B701]                 mov al, [OpSize]
  1004 00007401 3A06[B601]               cmp al, [R1Type]
  1005 00007405 0F850300                 jne @@checkOpL4
  1006 00007409 E91B00                   jmp @@retn
  1007                                  
  1008                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1009                                  
  1010                                  @@checkOpL4:
  1011 0000740C A0[AD01]                 mov al, [Op]
  1012 0000740F 3C02                     cmp al, 2
  1013 00007411 0F851200                 jne @@checkOpL5
  1014 00007415 A0[B601]                 mov al, [R1Type]
  1015 00007418 3C00                     cmp al, 0
  1016 0000741A 0F850900                 jne @@checkOpL6
  1017 0000741E 68[3C74]                 push checkOpL_1
  1018 00007421 E88A14                   call error1
  1019 00007424 83C402                   add  sp, 2
  1020                                  
  1021                                  ;-16 }
  1022                                  
  1023                                  @@checkOpL6:
  1024                                  @@checkOpL5:
  1025                                  
  1026                                  ;-17     
  1027                                  
  1028                                  
  1029                                  ;-18 int check2Ops() {
  1030                                  
  1031                                  @@retn:
  1032 00007427 C3                       ret
  1033                                  ; ENDP
  1034 00007428 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1035 00007431 65206465636C617265-
  1036 0000743A 6400               
  1037 0000743C 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1038 00007445 657220646566696E65-
  1039 0000744E 6400               
  1040                                  
  1041                                  check2Ops:  ; *** PROC ***
  1042                                  
  1043                                  ;-19     get2Ops();
  1044                                  
  1045 00007450 E84900                   call get2Ops
  1046                                  
  1047                                  ;-20     if (Op ==   0) addrerror();
  1048                                  
  1049 00007453 A0[AD01]                 mov al, [Op]
  1050 00007456 3C00                     cmp al, 0
  1051 00007458 0F850300                 jne @@check2Ops7
  1052 0000745C E8E014                   call addrerror
  1053                                  
  1054                                  ;-21     if (Op == ADR) invaloperror(); 
  1055                                  
  1056                                  @@check2Ops7:
  1057 0000745F A0[AD01]                 mov al, [Op]
  1058 00007462 3C03                     cmp al, 3
  1059 00007464 0F850300                 jne @@check2Ops8
  1060 00007468 E84E15                   call invaloperror
  1061                                  
  1062                                  ;-22     if (Op == IMM) immeerror();   
  1063                                  
  1064                                  @@check2Ops8:
  1065 0000746B A0[AD01]                 mov al, [Op]
  1066 0000746E 3C01                     cmp al, 1
  1067 00007470 0F850300                 jne @@check2Ops9
  1068 00007474 E8E214                   call immeerror
  1069                                  
  1070                                  ;-23     if (Op2==   0) addrerror();
  1071                                  
  1072                                  @@check2Ops9:
  1073 00007477 A0[AE01]                 mov al, [Op2]
  1074 0000747A 3C00                     cmp al, 0
  1075 0000747C 0F850300                 jne @@check2Ops10
  1076 00007480 E8BC14                   call addrerror
  1077                                  
  1078                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov           
  1079                                  
  1080                                  @@check2Ops10:
  1081 00007483 A0[AF01]                 mov al, [CodeType]
  1082 00007486 3C05                     cmp al, 5
  1083 00007488 0F840C00                 je  @@check2Ops11
  1084 0000748C A0[AE01]                 mov al, [Op2]
  1085 0000748F 3C03                     cmp al, 3
  1086 00007491 0F850300                 jne @@check2Ops12
  1087 00007495 E82115                   call invaloperror
  1088                                  
  1089                                  ;-25     setwflag();       
  1090                                  
  1091                                  @@check2Ops12:
  1092                                  @@check2Ops11:
  1093 00007498 E81C03                   call setwflag
  1094                                  
  1095                                  ;-26 }    
  1096                                  
  1097                                  
  1098                                  ;-27 int get2Ops() {
  1099                                  
  1100 0000749B C3                       ret
  1101                                  ; ENDP
  1102                                  
  1103                                  get2Ops:  ; *** PROC ***
  1104                                  
  1105                                  ;-28     getOpL();
  1106                                  
  1107 0000749C E80C00                   call getOpL
  1108                                  
  1109                                  ;-29     need(',');    
  1110                                  
  1111 0000749F 6A2C                     push 44
  1112 000074A1 E8E109                   call need
  1113 000074A4 83C402                   add  sp, 2
  1114                                  
  1115                                  ;-30     getOpR();         
  1116                                  
  1117 000074A7 E83200                   call getOpR
  1118                                  
  1119                                  ;-31 } 
  1120                                  
  1121                                  
  1122                                  ;-32         
  1123                                  
  1124                                  
  1125                                  ;-33 int getOpL() {
  1126                                  
  1127 000074AA C3                       ret
  1128                                  ; ENDP
  1129                                  
  1130                                  getOpL:  ; *** PROC ***
  1131                                  
  1132                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1133                                  
  1134                                  
  1135                                  ;-35     getOpR();
  1136                                  
  1137 000074AB E82E00                   call getOpR
  1138                                  
  1139                                  ;-36     Op=Op2;         Op2=0;
  1140                                  
  1141 000074AE A0[AE01]                 mov al, [Op2]
  1142 000074B1 A2[AD01]                 mov byte [Op], al
  1143 000074B4 66B800000000             mov eax, 0
  1144 000074BA A2[AE01]                 mov byte [Op2], al
  1145                                  
  1146                                  ;-37     R1No=R2No;      R2No=0;
  1147                                  
  1148 000074BD A0[B301]                 mov al, [R2No]
  1149 000074C0 A2[B401]                 mov byte [R1No], al
  1150 000074C3 66B800000000             mov eax, 0
  1151 000074C9 A2[B301]                 mov byte [R2No], al
  1152                                  
  1153                                  ;-38     R1Type=R2Type; R2Type=0; 
  1154                                  
  1155 000074CC A0[B501]                 mov al, [R2Type]
  1156 000074CF A2[B601]                 mov byte [R1Type], al
  1157 000074D2 66B800000000             mov eax, 0
  1158 000074D8 A2[B501]                 mov byte [R2Type], al
  1159                                  
  1160                                  ;-39 }  
  1161                                  
  1162                                  
  1163                                  ;-40 
  1164                                  
  1165                                  
  1166                                  ;-41 int getOpR() {
  1167                                  
  1168 000074DB C3                       ret
  1169                                  ; ENDP
  1170                                  
  1171                                  getOpR:  ; *** PROC ***
  1172                                  
  1173                                  ;-42     Op2=getOp1();
  1174                                  
  1175 000074DC E88900                   call getOp1
  1176 000074DF A2[AE01]                 mov byte [Op2], al
  1177                                  
  1178                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1179                                  
  1180 000074E2 6A5B                     push 91
  1181 000074E4 E87009                   call isToken
  1182 000074E7 83C402                   add  sp, 2
  1183 000074EA 08C0                     or  al, al
  1184 000074EC 0F840F00                 je @@getOpR13
  1185 000074F0 66B804000000             mov eax, 4
  1186 000074F6 A2[AE01]                 mov byte [Op2], al
  1187 000074F9 E8F200                   call getMEM
  1188 000074FC E94F00                   jmp @@retn
  1189                                  
  1190                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1191                                  
  1192                                  @@getOpR13:
  1193 000074FF A0[AE01]                 mov al, [Op2]
  1194 00007502 3C00                     cmp al, 0
  1195 00007504 0F850600                 jne @@getOpR14
  1196 00007508 E8AE14                   call invaloperror
  1197 0000750B E94000                   jmp @@retn
  1198                                  
  1199                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1200                                  
  1201                                  @@getOpR14:
  1202 0000750E A0[AE01]                 mov al, [Op2]
  1203 00007511 3C01                     cmp al, 1
  1204 00007513 0F850900                 jne @@getOpR15
  1205 00007517 A1[4C00]                 mov ax, [SymbolInt]
  1206 0000751A A3[BF01]                 mov word [imme], ax
  1207 0000751D E92E00                   jmp @@retn
  1208                                  
  1209                                  ;-46     if (Op2 == REG)                            return;
  1210                                  
  1211                                  @@getOpR15:
  1212 00007520 A0[AE01]                 mov al, [Op2]
  1213 00007523 3C02                     cmp al, 2
  1214 00007525 0F850300                 jne @@getOpR16
  1215 00007529 E92200                   jmp @@retn
  1216                                  
  1217                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1218                                  
  1219                                  @@getOpR16:
  1220 0000752C A0[AE01]                 mov al, [Op2]
  1221 0000752F 3C03                     cmp al, 3
  1222 00007531 0F851000                 jne @@getOpR17
  1223 00007535 8B1E[1F16]               mov bx, [LabelIx]
  1224 00007539 D1E3                     shl bx, 1
  1225 0000753B 8B87[6D11]               mov ax, [LabelAddr + bx]
  1226 0000753F A3[BD01]                 mov word [disp], ax
  1227 00007542 E90900                   jmp @@retn
  1228                                  
  1229                                  ;-48     error1("Name of operand expected");
  1230                                  
  1231                                  @@getOpR17:
  1232 00007545 68[4F75]                 push getOpR_0
  1233 00007548 E86313                   call error1
  1234 0000754B 83C402                   add  sp, 2
  1235                                  
  1236                                  ;-49 }
  1237                                  
  1238                                  
  1239                                  ;-50 
  1240                                  
  1241                                  
  1242                                  ;-51 int getOp1() {//scan for a single operand
  1243                                  
  1244                                  @@retn:
  1245 0000754E C3                       ret
  1246                                  ; ENDP
  1247 0000754F 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1248 00007558 706572616E64206578-
  1249 00007561 70656374656400     
  1250                                  
  1251                                  getOp1:  ; *** PROC ***
  1252                                  
  1253                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1254                                  
  1255                                  
  1256                                  ;-53 //set   :R2Type, R2No by testReg
  1257                                  
  1258                                  
  1259                                  ;-54 //set   :LabelIx by searchLabel
  1260                                  
  1261                                  
  1262                                  ;-55     if (TokeType == 0)      return 0;
  1263                                  
  1264 00007568 A0[AC01]                 mov al, [TokeType]
  1265 0000756B 3C00                     cmp al, 0
  1266 0000756D 0F850900                 jne @@getOp118
  1267 00007571 66B800000000             mov eax, 0
  1268 00007577 E96000                   jmp @@retn
  1269                                  
  1270                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1271                                  
  1272                                  @@getOp118:
  1273 0000757A A0[AC01]                 mov al, [TokeType]
  1274 0000757D 3C01                     cmp al, 1
  1275 0000757F 0F850900                 jne @@getOp119
  1276 00007583 66B801000000             mov eax, 1
  1277 00007589 E94E00                   jmp @@retn
  1278                                  
  1279                                  ;-57     if (TokeType == ALNUME) {
  1280                                  
  1281                                  @@getOp119:
  1282 0000758C A0[AC01]                 mov al, [TokeType]
  1283 0000758F 3C03                     cmp al, 3
  1284 00007591 0F853C00                 jne @@getOp120
  1285                                  
  1286                                  ;-58         R2No=testReg();
  1287                                  
  1288 00007595 E86C0C                   call testReg
  1289 00007598 A2[B301]                 mov byte [R2No], al
  1290                                  
  1291                                  ;-59         if (R2Type)        return REG;
  1292                                  
  1293 0000759B A0[B501]                 mov al, [R2Type]
  1294 0000759E 08C0                     or  al, al
  1295 000075A0 0F840900                 je @@getOp121
  1296 000075A4 66B802000000             mov eax, 2
  1297 000075AA E92D00                   jmp @@retn
  1298                                  
  1299                                  ;-60         LabelIx=searchLabel();
  1300                                  
  1301                                  @@getOp121:
  1302 000075AD E8F005                   call searchLabel
  1303 000075B0 A3[1F16]                 mov word [LabelIx], ax
  1304                                  
  1305                                  ;-61         if (LabelIx)        return ADR;
  1306                                  
  1307 000075B3 A1[1F16]                 mov ax, [LabelIx]
  1308 000075B6 08C0                     or  al, al
  1309 000075B8 0F840C00                 je @@getOp122
  1310 000075BC 66B803000000             mov eax, 3
  1311 000075C2 E91500                   jmp @@retn
  1312                                  
  1313                                  ;-62         else error1("variable not found"); 
  1314                                  
  1315 000075C5 E90900                   jmp @@getOp123
  1316                                  @@getOp122:
  1317 000075C8 68[DB75]                 push getOp1_0
  1318 000075CB E8E012                   call error1
  1319 000075CE 83C402                   add  sp, 2
  1320                                  
  1321                                  ;-63     }
  1322                                  
  1323                                  @@getOp123:
  1324                                  
  1325                                  ;-64     return 0;
  1326                                  
  1327                                  @@getOp120:
  1328 000075D1 66B800000000             mov eax, 0
  1329 000075D7 E90000                   jmp @@retn
  1330                                  
  1331                                  ;-65 }
  1332                                  
  1333                                  
  1334                                  ;-66 
  1335                                  
  1336                                  
  1337                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1338                                  
  1339                                  @@retn:
  1340 000075DA C3                       ret
  1341                                  ; ENDP
  1342 000075DB 7661726961626C6520-     getOp1_0 db "variable not found",0
  1343 000075E4 6E6F7420666F756E64-
  1344 000075ED 00                 
  1345                                  
  1346                                  getMEM:  ; *** PROC ***
  1347                                  
  1348                                  ;-68 //set: disp, rm, R2Type
  1349                                  
  1350                                  
  1351                                  ;-69     char c;
  1352                                  
  1353                                  
  1354                                  ;-70     disp=0; rm=0;
  1355                                  
  1356                                  ;Function : getMEM, Number of local variables: 1
  1357                                  ;   # type sign width line used address name   list of local variables
  1358                                  ;  200 var sign byte    69 NULL bp-2    c;
  1359 000075EE C8020000                 ENTER  2,0
  1360 000075F2 66B800000000             mov eax, 0
  1361 000075F8 A3[BD01]                 mov word [disp], ax
  1362 000075FB 66B800000000             mov eax, 0
  1363 00007601 A2[BB01]                 mov byte [rm], al
  1364                                  
  1365                                  ;-71     do {
  1366                                  
  1367                                  @@getMEM24:
  1368                                  
  1369                                  ;-72         getTokeType();
  1370                                  
  1371 00007604 E8D203                   call getTokeType
  1372                                  
  1373                                  ;-73         c=getOp1();
  1374                                  
  1375 00007607 E85EFF                   call getOp1
  1376 0000760A 8846FE                   mov byte [bp-2], al
  1377                                  
  1378                                  ;-74         if (c ==   0) syntaxerror();
  1379                                  
  1380 0000760D 8A46FE                   mov al, [bp-2]
  1381 00007610 3C00                     cmp al, 0
  1382 00007612 0F850300                 jne @@getMEM25
  1383 00007616 E85414                   call syntaxerror
  1384                                  
  1385                                  ;-75         if (c == REG) {
  1386                                  
  1387                                  @@getMEM25:
  1388 00007619 8A46FE                   mov al, [bp-2]
  1389 0000761C 3C02                     cmp al, 2
  1390 0000761E 0F851E00                 jne @@getMEM26
  1391                                  
  1392                                  ;-76             isDirect=0;
  1393                                  
  1394 00007622 66B800000000             mov eax, 0
  1395 00007628 A2[BC01]                 mov byte [isDirect], al
  1396                                  
  1397                                  ;-77             if (rm) rm=getIndReg2();
  1398                                  
  1399 0000762B A0[BB01]                 mov al, [rm]
  1400 0000762E 08C0                     or  al, al
  1401 00007630 0F840900                 je @@getMEM27
  1402 00007634 E8F300                   call getIndReg2
  1403 00007637 A2[BB01]                 mov byte [rm], al
  1404                                  
  1405                                  ;-78             else getIndReg1();
  1406                                  
  1407 0000763A E90300                   jmp @@getMEM28
  1408                                  @@getMEM27:
  1409 0000763D E88900                   call getIndReg1
  1410                                  
  1411                                  ;-79         }
  1412                                  
  1413                                  @@getMEM28:
  1414                                  
  1415                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1416                                  
  1417                                  @@getMEM26:
  1418 00007640 8A46FE                   mov al, [bp-2]
  1419 00007643 3C03                     cmp al, 3
  1420 00007645 0F851000                 jne @@getMEM29
  1421 00007649 A1[BD01]                 mov ax, [disp]
  1422 0000764C 8B1E[1F16]               mov bx, [LabelIx]
  1423 00007650 D1E3                     shl bx, 1
  1424 00007652 0387[6D11]               add ax, [LabelAddr + bx]
  1425 00007656 A3[BD01]                 mov word [disp], ax
  1426                                  
  1427                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1428                                  
  1429                                  @@getMEM29:
  1430 00007659 8A46FE                   mov al, [bp-2]
  1431 0000765C 3C01                     cmp al, 1
  1432 0000765E 0F850A00                 jne @@getMEM30
  1433 00007662 A1[BD01]                 mov ax, [disp]
  1434 00007665 0306[4C00]               add ax, [SymbolInt]
  1435 00007669 A3[BD01]                 mov word [disp], ax
  1436                                  
  1437                                  ;-82         if (isToken('-')) {
  1438                                  
  1439                                  @@getMEM30:
  1440 0000766C 6A2D                     push 45
  1441 0000766E E8E607                   call isToken
  1442 00007671 83C402                   add  sp, 2
  1443 00007674 08C0                     or  al, al
  1444 00007676 0F841900                 je @@getMEM31
  1445                                  
  1446                                  ;-83             getTokeType();
  1447                                  
  1448 0000767A E85C03                   call getTokeType
  1449                                  
  1450                                  ;-84             if (TokeType != DIGIT) numbererror();
  1451                                  
  1452 0000767D A0[AC01]                 mov al, [TokeType]
  1453 00007680 3C01                     cmp al, 1
  1454 00007682 0F840300                 je  @@getMEM32
  1455 00007686 E85113                   call numbererror
  1456                                  
  1457                                  ;-85             disp = disp - SymbolInt;
  1458                                  
  1459                                  @@getMEM32:
  1460 00007689 A1[BD01]                 mov ax, [disp]
  1461 0000768C 2B06[4C00]               sub ax, [SymbolInt]
  1462 00007690 A3[BD01]                 mov word [disp], ax
  1463                                  
  1464                                  ;-86         }
  1465                                  
  1466                                  
  1467                                  ;-87     } while (isToken('+'));
  1468                                  
  1469                                  @@getMEM31:
  1470 00007693 6A2B                     push 43
  1471 00007695 E8BF07                   call isToken
  1472 00007698 83C402                   add  sp, 2
  1473 0000769B 08C0                     or  al, al
  1474 0000769D 0F840300                 je @@getMEM33
  1475 000076A1 E960FF                   jmp @@getMEM24
  1476                                  @@getMEM33:
  1477                                  
  1478                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1479                                  
  1480 000076A4 6A5D                     push 93
  1481 000076A6 E8AE07                   call isToken
  1482 000076A9 83C402                   add  sp, 2
  1483 000076AC 83F800                   cmp ax, 0
  1484 000076AF 0F850900                 jne @@getMEM34
  1485 000076B3 68[BE76]                 push getMEM_0
  1486 000076B6 E85412                   call errorexit
  1487 000076B9 83C402                   add  sp, 2
  1488                                  
  1489                                  ;-89 }
  1490                                  
  1491                                  @@getMEM34:
  1492                                  
  1493                                  ;-90 int getIndReg1() {
  1494 000076BC C9                       LEAVE
  1495 000076BD C3                       ret
  1496                                  ; ENDP
  1497 000076BE 5D2065787065637465-     getMEM_0 db "] expected",0
  1498 000076C7 6400               
  1499                                  
  1500                                  getIndReg1:  ; *** PROC ***
  1501                                  
  1502                                  ;-91     if (R2Type !=WORD) indexerror();
  1503                                  
  1504 000076C9 A0[B501]                 mov al, [R2Type]
  1505 000076CC 3C02                     cmp al, 2
  1506 000076CE 0F840300                 je  @@getIndReg135
  1507 000076D2 E8C312                   call indexerror
  1508                                  
  1509                                  ;-92     if (R2No==3) rm=7;//BX
  1510                                  
  1511                                  @@getIndReg135:
  1512 000076D5 A0[B301]                 mov al, [R2No]
  1513 000076D8 3C03                     cmp al, 3
  1514 000076DA 0F850900                 jne @@getIndReg136
  1515 000076DE 66B807000000             mov eax, 7
  1516 000076E4 A2[BB01]                 mov byte [rm], al
  1517                                  
  1518                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1519                                  
  1520                                  @@getIndReg136:
  1521 000076E7 A0[B301]                 mov al, [R2No]
  1522 000076EA 3C05                     cmp al, 5
  1523 000076EC 0F850900                 jne @@getIndReg137
  1524 000076F0 66B806000000             mov eax, 6
  1525 000076F6 A2[BB01]                 mov byte [rm], al
  1526                                  
  1527                                  ;-94     if (R2No==7) rm=5;//DI
  1528                                  
  1529                                  @@getIndReg137:
  1530 000076F9 A0[B301]                 mov al, [R2No]
  1531 000076FC 3C07                     cmp al, 7
  1532 000076FE 0F850900                 jne @@getIndReg138
  1533 00007702 66B805000000             mov eax, 5
  1534 00007708 A2[BB01]                 mov byte [rm], al
  1535                                  
  1536                                  ;-95     if (R2No==6) rm=4;//SI
  1537                                  
  1538                                  @@getIndReg138:
  1539 0000770B A0[B301]                 mov al, [R2No]
  1540 0000770E 3C06                     cmp al, 6
  1541 00007710 0F850900                 jne @@getIndReg139
  1542 00007714 66B804000000             mov eax, 4
  1543 0000771A A2[BB01]                 mov byte [rm], al
  1544                                  
  1545                                  ;-96     if (rm==0) indexerror();
  1546                                  
  1547                                  @@getIndReg139:
  1548 0000771D A0[BB01]                 mov al, [rm]
  1549 00007720 3C00                     cmp al, 0
  1550 00007722 0F850300                 jne @@getIndReg140
  1551 00007726 E86F12                   call indexerror
  1552                                  
  1553                                  ;-97 }
  1554                                  
  1555                                  @@getIndReg140:
  1556                                  
  1557                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1558                                  
  1559 00007729 C3                       ret
  1560                                  ; ENDP
  1561                                  
  1562                                  getIndReg2:  ; *** PROC ***
  1563                                  ;Function : getIndReg2, Number of local variables: 1
  1564                                  ;   # type sign width line used address name   list of local variables
  1565                                  ;  200 var sign byte    98 NULL bp-2    m;
  1566 0000772A C8020000                 ENTER  2,0
  1567 0000772E 66B804000000             mov eax, 4
  1568 00007734 8846FE                   mov byte [bp-2], al
  1569                                  
  1570                                  ;-99     if (R2Type !=WORD) indexerror();
  1571                                  
  1572 00007737 A0[B501]                 mov al, [R2Type]
  1573 0000773A 3C02                     cmp al, 2
  1574 0000773C 0F840300                 je  @@getIndReg241
  1575 00007740 E85512                   call indexerror
  1576                                  
  1577                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1578                                  
  1579                                  @@getIndReg241:
  1580 00007743 A0[B301]                 mov al, [R2No]
  1581 00007746 3C07                     cmp al, 7
  1582 00007748 0F852700                 jne @@getIndReg242
  1583 0000774C A0[BB01]                 mov al, [rm]
  1584 0000774F 3C06                     cmp al, 6
  1585 00007751 0F850C00                 jne @@getIndReg243
  1586 00007755 66B803000000             mov eax, 3
  1587 0000775B 8846FE                   mov byte [bp-2], al
  1588                                  
  1589                                  ;-101              else if (rm==7) m=1;//BX+DI
  1590                                  
  1591 0000775E E91200                   jmp @@getIndReg244
  1592                                  @@getIndReg243:
  1593 00007761 A0[BB01]                 mov al, [rm]
  1594 00007764 3C07                     cmp al, 7
  1595 00007766 0F850900                 jne @@getIndReg245
  1596 0000776A 66B801000000             mov eax, 1
  1597 00007770 8846FE                   mov byte [bp-2], al
  1598                                  
  1599                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1600                                  
  1601                                  @@getIndReg245:
  1602                                  @@getIndReg244:
  1603                                  @@getIndReg242:
  1604 00007773 A0[B301]                 mov al, [R2No]
  1605 00007776 3C06                     cmp al, 6
  1606 00007778 0F852700                 jne @@getIndReg246
  1607 0000777C A0[BB01]                 mov al, [rm]
  1608 0000777F 3C06                     cmp al, 6
  1609 00007781 0F850C00                 jne @@getIndReg247
  1610 00007785 66B802000000             mov eax, 2
  1611 0000778B 8846FE                   mov byte [bp-2], al
  1612                                  
  1613                                  ;-103              else if (rm==7) m=0;//BX+SI
  1614                                  
  1615 0000778E E91200                   jmp @@getIndReg248
  1616                                  @@getIndReg247:
  1617 00007791 A0[BB01]                 mov al, [rm]
  1618 00007794 3C07                     cmp al, 7
  1619 00007796 0F850900                 jne @@getIndReg249
  1620 0000779A 66B800000000             mov eax, 0
  1621 000077A0 8846FE                   mov byte [bp-2], al
  1622                                  
  1623                                  ;-104     if (m > 3) indexerror();
  1624                                  
  1625                                  @@getIndReg249:
  1626                                  @@getIndReg248:
  1627                                  @@getIndReg246:
  1628 000077A3 8A46FE                   mov al, [bp-2]
  1629 000077A6 3C03                     cmp al, 3
  1630 000077A8 0F8E0300                 jle @@getIndReg250
  1631 000077AC E8E911                   call indexerror
  1632                                  
  1633                                  ;-105     return m;
  1634                                  
  1635                                  @@getIndReg250:
  1636 000077AF 8A46FE                   mov al, [bp-2]
  1637 000077B2 E90000                   jmp @@retn
  1638                                  
  1639                                  ;-106 }
  1640                                  
  1641                                  
  1642                                  ;-107                   
  1643                                  
  1644                                  
  1645                                  ;-108 int setwflag() {//word size, bit 0
  1646                                  
  1647 000077B5 C9                      @@retn: LEAVE
  1648 000077B6 C3                       ret
  1649                                  ; ENDP
  1650                                  
  1651                                  setwflag:  ; *** PROC ***
  1652                                  
  1653                                  ;-109     wflag=0;
  1654                                  
  1655 000077B7 66B800000000             mov eax, 0
  1656 000077BD A2[B801]                 mov byte [wflag], al
  1657                                  
  1658                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1659                                  
  1660 000077C0 A0[B701]                 mov al, [OpSize]
  1661 000077C3 3C00                     cmp al, 0
  1662 000077C5 0F854200                 jne @@setwflag51
  1663                                  
  1664                                  ;-111         if (Op == REG) OpSize=R1Type;
  1665                                  
  1666 000077C9 A0[AD01]                 mov al, [Op]
  1667 000077CC 3C02                     cmp al, 2
  1668 000077CE 0F850600                 jne @@setwflag52
  1669 000077D2 A0[B601]                 mov al, [R1Type]
  1670 000077D5 A2[B701]                 mov byte [OpSize], al
  1671                                  
  1672                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1673                                  
  1674                                  @@setwflag52:
  1675 000077D8 A0[AE01]                 mov al, [Op2]
  1676 000077DB 3C02                     cmp al, 2
  1677 000077DD 0F850600                 jne @@setwflag53
  1678 000077E1 A0[B501]                 mov al, [R2Type]
  1679 000077E4 A2[B701]                 mov byte [OpSize], al
  1680                                  
  1681                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1682                                  
  1683                                  @@setwflag53:
  1684 000077E7 A0[B501]                 mov al, [R2Type]
  1685 000077EA 3C04                     cmp al, 4
  1686 000077EC 0F850900                 jne @@setwflag54
  1687 000077F0 66B802000000             mov eax, 2
  1688 000077F6 A2[B701]                 mov byte [OpSize], al
  1689                                  
  1690                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1691                                  
  1692                                  @@setwflag54:
  1693 000077F9 A0[B601]                 mov al, [R1Type]
  1694 000077FC 3C04                     cmp al, 4
  1695 000077FE 0F850900                 jne @@setwflag55
  1696 00007802 66B802000000             mov eax, 2
  1697 00007808 A2[B701]                 mov byte [OpSize], al
  1698                                  
  1699                                  ;-115     }
  1700                                  
  1701                                  @@setwflag55:
  1702                                  
  1703                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1704                                  
  1705                                  @@setwflag51:
  1706 0000780B A0[B701]                 mov al, [OpSize]
  1707 0000780E 3C03                     cmp al, 3
  1708 00007810 0F850C00                 jne @@setwflag56
  1709 00007814 E87717                   call gen66h
  1710 00007817 66B801000000             mov eax, 1
  1711 0000781D A2[B801]                 mov byte [wflag], al
  1712                                  
  1713                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1714                                  
  1715                                  @@setwflag56:
  1716 00007820 A0[B701]                 mov al, [OpSize]
  1717 00007823 3C02                     cmp al, 2
  1718 00007825 0F850900                 jne @@setwflag57
  1719 00007829 66B801000000             mov eax, 1
  1720 0000782F A2[B801]                 mov byte [wflag], al
  1721                                  
  1722                                  ;-118 }
  1723                                  
  1724                                  @@setwflag57:
  1725                                  
  1726                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1727                                  
  1728 00007832 C3                       ret
  1729                                  ; ENDP
  1730                                  
  1731                                  setsflag:  ; *** PROC ***
  1732                                  
  1733                                  ;-120     unsigned int ui;    
  1734                                  
  1735                                  
  1736                                  ;-121     sflag=2;   
  1737                                  
  1738                                  ;Function : setsflag, Number of local variables: 1
  1739                                  ;   # type sign width line used address name   list of local variables
  1740                                  ;  200 var unsg word   120 NULL bp-2    ui;
  1741 00007833 C8020000                 ENTER  2,0
  1742 00007837 66B802000000             mov eax, 2
  1743 0000783D A2[BA01]                 mov byte [sflag], al
  1744                                  
  1745                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1746                                  
  1747 00007840 A1[BF01]                 mov ax, [imme]
  1748 00007843 2580FF                   and ax, 65408
  1749 00007846 8946FE                   mov word [bp-2], ax
  1750                                  
  1751                                  ;-123     if(ui != 0) sflag = 0;
  1752                                  
  1753 00007849 8B46FE                   mov ax, [bp-2]
  1754 0000784C 83F800                   cmp ax, 0
  1755 0000784F 0F840900                 je  @@setsflag58
  1756 00007853 66B800000000             mov eax, 0
  1757 00007859 A2[BA01]                 mov byte [sflag], al
  1758                                  
  1759                                  ;-124     if (OpSize == BYTE) {
  1760                                  
  1761                                  @@setsflag58:
  1762 0000785C A0[B701]                 mov al, [OpSize]
  1763 0000785F 3C01                     cmp al, 1
  1764 00007861 0F851C00                 jne @@setsflag59
  1765                                  
  1766                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1767                                  
  1768 00007865 A1[BF01]                 mov ax, [imme]
  1769 00007868 3DFF00                   cmp ax, 255
  1770 0000786B 0F8E0900                 jle @@setsflag60
  1771 0000786F 68[8378]                 push setsflag_0
  1772 00007872 E83910                   call error1
  1773 00007875 83C402                   add  sp, 2
  1774                                  
  1775                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1776                                  
  1777                                  @@setsflag60:
  1778 00007878 66B800000000             mov eax, 0
  1779 0000787E A2[BA01]                 mov byte [sflag], al
  1780                                  
  1781                                  ;-127     }
  1782                                  
  1783                                  
  1784                                  ;-128 }
  1785                                  
  1786                                  @@setsflag59:
  1787                                  
  1788                                  ;-129 int checkConstSize(unsigned int ui) {    
  1789 00007881 C9                       LEAVE
  1790 00007882 C3                       ret
  1791                                  ; ENDP
  1792 00007883 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1793 0000788C 6F7220627974652072-
  1794 00007895 2F6D00             
  1795                                  
  1796                                  checkConstSize:  ; *** PROC ***
  1797                                  
  1798                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1799                                  
  1800                                  ;Function : checkConstSize, Number of local variables: 1
  1801                                  ;   # type sign width line used address name   list of local variables
  1802                                  ;  200 var unsg word   129 NULL bp+4    ui;
  1803 00007898 C8000000                 ENTER  0,0
  1804 0000789C 8B4604                   mov ax, [bp+4]
  1805 0000789F 83F87F                   cmp ax, 127
  1806 000078A2 0F8E0900                 jle @@checkConstSize61
  1807 000078A6 66B800000000             mov eax, 0
  1808 000078AC E91C00                   jmp @@retn
  1809                                  
  1810                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1811                                  
  1812                                  @@checkConstSize61:
  1813 000078AF 8B4604                   mov ax, [bp+4]
  1814 000078B2 3D80FF                   cmp ax, 65408
  1815 000078B5 0F8D0900                 jge @@checkConstSize62
  1816 000078B9 66B800000000             mov eax, 0
  1817 000078BF E90900                   jmp @@retn
  1818                                  
  1819                                  ;-132     return 2;// is short        
  1820                                  
  1821                                  @@checkConstSize62:
  1822 000078C2 66B802000000             mov eax, 2
  1823 000078C8 E90000                   jmp @@retn
  1824                                  
  1825                                  ;-133 }
  1826                                  
  1827 000078CB C9                      @@retn: LEAVE
  1828 000078CC C3                       ret
  1829                                  ; ENDP
  1830                                  ;Back to main program: AS.C
  1831                                  
  1832                                  ;-5 #include "PARSE.C"
  1833                                  
  1834                                  ;Use include file: PARSE.C
  1835                                  
  1836                                  ;-1 int parse() {
  1837                                  
  1838                                  
  1839                                  parse:  ; *** PROC ***
  1840                                  
  1841                                  ;-2     LabelNamePtr  = &LabelNames;    
  1842                                  
  1843 000078CD B8[CB01]                 mov ax, LabelNames
  1844 000078D0 A3[6B11]                 mov word [LabelNamePtr], ax
  1845                                  
  1846                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1847                                  
  1848 000078D3 B8[2116]                 mov ax, JmpCallNames
  1849 000078D6 A3[F11D]                 mov word [JmpCallNamePtr], ax
  1850                                  
  1851                                  ;-4     LabelMaxIx=0;    
  1852                                  
  1853 000078D9 66B800000000             mov eax, 0
  1854 000078DF A3[1D16]                 mov word [LabelMaxIx], ax
  1855                                  
  1856                                  ;-5     JmpCallMaxIx=0;  
  1857                                  
  1858 000078E2 66B800000000             mov eax, 0
  1859 000078E8 A3[DB21]                 mov word [JmpCallMaxIx], ax
  1860                                  
  1861                                  ;-6     BinLen=0;
  1862                                  
  1863 000078EB 66B800000000             mov eax, 0
  1864 000078F1 A3[FD6F]                 mov word [BinLen], ax
  1865                                  
  1866                                  ;-7     
  1867                                  
  1868                                  
  1869                                  ;-8     do {//process a new line
  1870                                  
  1871                                  @@parse63:
  1872                                  
  1873                                  ;-9         PCStart=PC; 
  1874                                  
  1875 000078F4 A1[A501]                 mov ax, [PC]
  1876 000078F7 A3[A901]                 mov word [PCStart], ax
  1877                                  
  1878                                  ;-10         OpSize=0;
  1879                                  
  1880 000078FA 66B800000000             mov eax, 0
  1881 00007900 A2[B701]                 mov byte [OpSize], al
  1882                                  
  1883                                  ;-11         OpPrintIndex=0; 
  1884                                  
  1885 00007903 66B800000000             mov eax, 0
  1886 00007909 A3[C601]                 mov word [OpPrintIndex], ax
  1887                                  
  1888                                  ;-12         PrintRA=' ';
  1889                                  
  1890 0000790C 66B820000000             mov eax, 32
  1891 00007912 A2[CA01]                 mov byte [PrintRA], al
  1892                                  
  1893                                  ;-13         getLine();
  1894                                  
  1895 00007915 E8D505                   call getLine
  1896                                  
  1897                                  ;-14         InputPtr = &InputBuf;
  1898                                  
  1899 00007918 B8[4E00]                 mov ax, InputBuf
  1900 0000791B A3[CD00]                 mov word [InputPtr], ax
  1901                                  
  1902                                  ;-15         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1903                                  
  1904 0000791E E8B800                   call getTokeType
  1905                                  
  1906                                  ;-16         if (TokeType == ALNUME) {
  1907                                  
  1908 00007921 A0[AC01]                 mov al, [TokeType]
  1909 00007924 3C03                     cmp al, 3
  1910 00007926 0F851300                 jne @@parse64
  1911                                  
  1912                                  ;-17             if (isLabel) {//set in getName
  1913                                  
  1914 0000792A A0[AB01]                 mov al, [isLabel]
  1915 0000792D 08C0                     or  al, al
  1916 0000792F 0F840A00                 je @@parse65
  1917                                  
  1918                                  ;-18                 storeLabel();
  1919                                  
  1920 00007933 E8C301                   call storeLabel
  1921                                  
  1922                                  ;-19                 InputPtr++;//remove :
  1923                                  
  1924 00007936 FF06[CD00]               inc  word [InputPtr]
  1925                                  
  1926                                  ;-20                 getTokeType();
  1927                                  
  1928 0000793A E89C00                   call getTokeType
  1929                                  
  1930                                  ;-21             }
  1931                                  
  1932                                  
  1933                                  ;-22         }
  1934                                  
  1935                                  @@parse65:
  1936                                  
  1937                                  ;-23         if (TokeType == ALNUME) {
  1938                                  
  1939                                  @@parse64:
  1940 0000793D A0[AC01]                 mov al, [TokeType]
  1941 00007940 3C03                     cmp al, 3
  1942 00007942 0F851B00                 jne @@parse66
  1943                                  
  1944                                  ;-24             lookCode();// and OpCodePtr
  1945                                  
  1946 00007946 E81104                   call lookCode
  1947                                  
  1948                                  ;-25             if(CodeType) process();
  1949                                  
  1950 00007949 A0[AF01]                 mov al, [CodeType]
  1951 0000794C 08C0                     or  al, al
  1952 0000794E 0F840600                 je @@parse67
  1953 00007952 E82718                   call process
  1954                                  
  1955                                  ;-26             else getVariable();
  1956                                  
  1957 00007955 E90300                   jmp @@parse68
  1958                                  @@parse67:
  1959 00007958 E89F02                   call getVariable
  1960                                  
  1961                                  ;-27             skipRest();
  1962                                  
  1963                                  @@parse68:
  1964 0000795B E86605                   call skipRest
  1965                                  
  1966                                  ;-28         }
  1967                                  
  1968                                  
  1969                                  ;-29         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1970                                  
  1971 0000795E E92700                   jmp @@parse69
  1972                                  @@parse66:
  1973 00007961 A0[AC01]                 mov al, [TokeType]
  1974 00007964 3C03                     cmp al, 3
  1975 00007966 0F8E0C00                 jle @@parse70
  1976 0000796A 68[9979]                 push parse_0
  1977 0000796D E83E0F                   call error1
  1978 00007970 83C402                   add  sp, 2
  1979                                  
  1980                                  ;-30         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1981                                  
  1982 00007973 E91200                   jmp @@parse71
  1983                                  @@parse70:
  1984 00007976 A0[AC01]                 mov al, [TokeType]
  1985 00007979 3C01                     cmp al, 1
  1986 0000797B 0F850900                 jne @@parse72
  1987 0000797F 68[B779]                 push parse_1
  1988 00007982 E8290F                   call error1
  1989 00007985 83C402                   add  sp, 2
  1990                                  
  1991                                  ;-31         printLine();
  1992                                  
  1993                                  @@parse72:
  1994                                  @@parse71:
  1995                                  @@parse69:
  1996 00007988 E8B50C                   call printLine
  1997                                  
  1998                                  ;-32     } while (DOS_NoBytes != 0 );
  1999                                  
  2000 0000798B A1[A201]                 mov ax, [DOS_NoBytes]
  2001 0000798E 83F800                   cmp ax, 0
  2002 00007991 0F840300                 je  @@parse73
  2003 00007995 E95CFF                   jmp @@parse63
  2004                                  @@parse73:
  2005                                  
  2006                                  ;-33 }
  2007                                  
  2008                                  
  2009                                  ;-34 
  2010                                  
  2011                                  
  2012                                  ;-35 int getTokeType() { 
  2013                                  
  2014 00007998 C3                       ret
  2015                                  ; ENDP
  2016 00007999 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2017 000079A2 696E73747275637469-
  2018 000079AB 6F6E20657870656374-
  2019 000079B4 656400             
  2020 000079B7 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2021 000079C0 616C6C6F7765642061-
  2022 000079C9 74207374617274206F-
  2023 000079D2 66206C696E6500     
  2024                                  
  2025                                  getTokeType:  ; *** PROC ***
  2026                                  
  2027                                  ;-36     char c;
  2028                                  
  2029                                  
  2030                                  ;-37     skipBlank();
  2031                                  
  2032                                  ;Function : getTokeType, Number of local variables: 1
  2033                                  ;   # type sign width line used address name   list of local variables
  2034                                  ;  200 var sign byte    36 NULL bp-2    c;
  2035 000079D9 C8020000                 ENTER  2,0
  2036 000079DD E80F06                   call skipBlank
  2037                                  
  2038                                  ;-38     c = *InputPtr;
  2039                                  
  2040 000079E0 8B1E[CD00]               mov bx, [InputPtr]
  2041 000079E4 8A07                     mov al, [bx]
  2042 000079E6 B400                     mov ah, 0
  2043 000079E8 8846FE                   mov byte [bp-2], al
  2044                                  
  2045                                  ;-39     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2046                                  
  2047 000079EB 8A46FE                   mov al, [bp-2]
  2048 000079EE 3C00                     cmp al, 0
  2049 000079F0 0F850C00                 jne @@getTokeType74
  2050 000079F4 66B800000000             mov eax, 0
  2051 000079FA A2[AC01]                 mov byte [TokeType], al
  2052 000079FD E97200                   jmp @@retn
  2053                                  
  2054                                  ;-40     if (c == ';') {TokeType=0; return; }//comment
  2055                                  
  2056                                  @@getTokeType74:
  2057 00007A00 8A46FE                   mov al, [bp-2]
  2058 00007A03 3C3B                     cmp al, 59
  2059 00007A05 0F850C00                 jne @@getTokeType75
  2060 00007A09 66B800000000             mov eax, 0
  2061 00007A0F A2[AC01]                 mov byte [TokeType], al
  2062 00007A12 E95D00                   jmp @@retn
  2063                                  
  2064                                  ;-41     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2065                                  
  2066                                  @@getTokeType75:
  2067 00007A15 8A46FE                   mov al, byte [bp-2]
  2068 00007A18 B400                     mov ah, 0
  2069 00007A1A 50                       push ax
  2070 00007A1B E85320                   call digit
  2071 00007A1E 83C402                   add  sp, 2
  2072 00007A21 08C0                     or  al, al
  2073 00007A23 0F841800                 je @@getTokeType76
  2074 00007A27 8A46FE                   mov al, byte [bp-2]
  2075 00007A2A B400                     mov ah, 0
  2076 00007A2C 50                       push ax
  2077 00007A2D E8C506                   call getDigit
  2078 00007A30 83C402                   add  sp, 2
  2079 00007A33 66B801000000             mov eax, 1
  2080 00007A39 A2[AC01]                 mov byte [TokeType], al
  2081 00007A3C E93300                   jmp @@retn
  2082                                  
  2083                                  ;-42     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2084                                  
  2085                                  @@getTokeType76:
  2086 00007A3F 8A46FE                   mov al, byte [bp-2]
  2087 00007A42 B400                     mov ah, 0
  2088 00007A44 50                       push ax
  2089 00007A45 E8D205                   call letterE
  2090 00007A48 83C402                   add  sp, 2
  2091 00007A4B 08C0                     or  al, al
  2092 00007A4D 0F841800                 je @@getTokeType77
  2093 00007A51 8A46FE                   mov al, byte [bp-2]
  2094 00007A54 B400                     mov ah, 0
  2095 00007A56 50                       push ax
  2096 00007A57 E8F206                   call getName
  2097 00007A5A 83C402                   add  sp, 2
  2098 00007A5D 66B803000000             mov eax, 3
  2099 00007A63 A2[AC01]                 mov byte [TokeType], al
  2100 00007A66 E90900                   jmp @@retn
  2101                                  
  2102                                  ;-43     TokeType=NOALNUME;
  2103                                  
  2104                                  @@getTokeType77:
  2105 00007A69 66B804000000             mov eax, 4
  2106 00007A6F A2[AC01]                 mov byte [TokeType], al
  2107                                  
  2108                                  ;-44 }                     
  2109                                  
  2110                                  
  2111                                  ;-45 
  2112                                  
  2113                                  
  2114                                  ;-46 int storeJmpCall() {
  2115                                  
  2116 00007A72 C9                      @@retn: LEAVE
  2117 00007A73 C3                       ret
  2118                                  ; ENDP
  2119                                  
  2120                                  storeJmpCall:  ; *** PROC ***
  2121                                  
  2122                                  ;-47     unsigned int i;
  2123                                  
  2124                                  
  2125                                  ;-48     JmpCallMaxIx++;
  2126                                  
  2127                                  ;Function : storeJmpCall, Number of local variables: 1
  2128                                  ;   # type sign width line used address name   list of local variables
  2129                                  ;  200 var unsg word    47 NULL bp-2    i;
  2130 00007A74 C8020000                 ENTER  2,0
  2131 00007A78 FF06[DB21]               inc  word [JmpCallMaxIx]
  2132                                  
  2133                                  ;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2134                                  
  2135 00007A7C A1[DB21]                 mov ax, [JmpCallMaxIx]
  2136 00007A7F 3DF401                   cmp ax, 500 ;unsigned : 1
  2137 00007A82 0F8C0900                 jl  @@storeJmpCall78
  2138 00007A86 68[D07A]                 push storeJmpCall_0
  2139 00007A89 E8810E                   call errorexit
  2140 00007A8C 83C402                   add  sp, 2
  2141                                  
  2142                                  ;-50     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2143                                  
  2144                                  @@storeJmpCall78:
  2145 00007A8F 8D06[0E00]               lea  ax, [Symbol]
  2146 00007A93 50                       push ax
  2147 00007A94 FF36[F11D]               push word [JmpCallNamePtr]
  2148 00007A98 E89D1F                   call strcpy
  2149 00007A9B 83C404                   add  sp, 4
  2150 00007A9E A3[F11D]                 mov word [JmpCallNamePtr], ax
  2151                                  
  2152                                  ;-51     JmpCallNamePtr++;
  2153                                  
  2154 00007AA1 FF06[F11D]               inc  word [JmpCallNamePtr]
  2155                                  
  2156                                  ;-52     i = JmpCallNamePtr - &JmpCallNames;    
  2157                                  
  2158 00007AA5 A1[F11D]                 mov ax, [JmpCallNamePtr]
  2159 00007AA8 2D[2116]                 sub ax, JmpCallNames
  2160 00007AAB 8946FE                   mov word [bp-2], ax
  2161                                  
  2162                                  ;-53     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2163                                  
  2164 00007AAE 8B46FE                   mov ax, [bp-2]
  2165 00007AB1 3DB107                   cmp ax, 1969 ;unsigned : 0
  2166 00007AB4 0F820900                 jb  @@storeJmpCall79
  2167 00007AB8 68[E27A]                 push storeJmpCall_1
  2168 00007ABB E84F0E                   call errorexit
  2169 00007ABE 83C402                   add  sp, 2
  2170                                  
  2171                                  ;-54     JmpCallAddr[JmpCallMaxIx] = PC;   
  2172                                  
  2173                                  @@storeJmpCall79:
  2174 00007AC1 A1[A501]                 mov ax, [PC]
  2175 00007AC4 8B1E[DB21]               mov bx, [JmpCallMaxIx]
  2176 00007AC8 D1E3                     shl bx, 1
  2177 00007ACA 8987[F31D]               mov [JmpCallAddr+bx], ax
  2178                                  
  2179                                  ;-55 }
  2180                                  
  2181                                  
  2182                                  ;-56 
  2183                                  
  2184                                  
  2185                                  ;-57 int storeLabel() {
  2186 00007ACE C9                       LEAVE
  2187 00007ACF C3                       ret
  2188                                  ; ENDP
  2189 00007AD0 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2190 00007AD9 4A6D7043616C6C7300 
  2191 00007AE2 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2192 00007AEB 4A6D7043616C6C206E-
  2193 00007AF4 616D657300         
  2194                                  
  2195                                  storeLabel:  ; *** PROC ***
  2196                                  
  2197                                  ;-58     unsigned int i;
  2198                                  
  2199                                  
  2200                                  ;-59     LabelMaxIx++;
  2201                                  
  2202                                  ;Function : storeLabel, Number of local variables: 1
  2203                                  ;   # type sign width line used address name   list of local variables
  2204                                  ;  200 var unsg word    58 NULL bp-2    i;
  2205 00007AF9 C8020000                 ENTER  2,0
  2206 00007AFD FF06[1D16]               inc  word [LabelMaxIx]
  2207                                  
  2208                                  ;-60     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2209                                  
  2210 00007B01 A1[1D16]                 mov ax, [LabelMaxIx]
  2211 00007B04 3D5802                   cmp ax, 600 ;unsigned : 1
  2212 00007B07 0F8C0900                 jl  @@storeLabel80
  2213 00007B0B 68[6B7B]                 push storeLabel_0
  2214 00007B0E E8FC0D                   call errorexit
  2215 00007B11 83C402                   add  sp, 2
  2216                                  
  2217                                  ;-61     if(searchLabel()) error1("duplicate label");
  2218                                  
  2219                                  @@storeLabel80:
  2220 00007B14 E88900                   call searchLabel
  2221 00007B17 08C0                     or  al, al
  2222 00007B19 0F840900                 je @@storeLabel81
  2223 00007B1D 68[7B7B]                 push storeLabel_1
  2224 00007B20 E88B0D                   call error1
  2225 00007B23 83C402                   add  sp, 2
  2226                                  
  2227                                  ;-62     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2228                                  
  2229                                  @@storeLabel81:
  2230 00007B26 8D06[0E00]               lea  ax, [Symbol]
  2231 00007B2A 50                       push ax
  2232 00007B2B FF36[6B11]               push word [LabelNamePtr]
  2233 00007B2F E8061F                   call strcpy
  2234 00007B32 83C404                   add  sp, 4
  2235 00007B35 A3[6B11]                 mov word [LabelNamePtr], ax
  2236                                  
  2237                                  ;-63     LabelNamePtr++;
  2238                                  
  2239 00007B38 FF06[6B11]               inc  word [LabelNamePtr]
  2240                                  
  2241                                  ;-64     i = LabelNamePtr - &LabelNames;
  2242                                  
  2243 00007B3C A1[6B11]                 mov ax, [LabelNamePtr]
  2244 00007B3F 2D[CB01]                 sub ax, LabelNames
  2245 00007B42 8946FE                   mov word [bp-2], ax
  2246                                  
  2247                                  ;-65     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2248                                  
  2249 00007B45 8B46FE                   mov ax, [bp-2]
  2250 00007B48 3D810F                   cmp ax, 3969 ;unsigned : 0
  2251 00007B4B 0F820900                 jb  @@storeLabel82
  2252 00007B4F 68[8B7B]                 push storeLabel_2
  2253 00007B52 E8B80D                   call errorexit
  2254 00007B55 83C402                   add  sp, 2
  2255                                  
  2256                                  ;-66     LabelAddr[LabelMaxIx] = PC + Origin;
  2257                                  
  2258                                  @@storeLabel82:
  2259 00007B58 A1[A501]                 mov ax, [PC]
  2260 00007B5B 0306[A701]               add ax, [Origin]
  2261 00007B5F 8B1E[1D16]               mov bx, [LabelMaxIx]
  2262 00007B63 D1E3                     shl bx, 1
  2263 00007B65 8987[6D11]               mov [LabelAddr+bx], ax
  2264                                  
  2265                                  ;-67 }   
  2266                                  
  2267                                  
  2268                                  ;-68 
  2269                                  
  2270                                  
  2271                                  ;-69 int searchLabel() {
  2272 00007B69 C9                       LEAVE
  2273 00007B6A C3                       ret
  2274                                  ; ENDP
  2275 00007B6B 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2276 00007B74 6C6162656C7300     
  2277 00007B7B 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2278 00007B84 206C6162656C00     
  2279 00007B8B 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2280 00007B94 6C6162656C206E616D-
  2281 00007B9D 657300             
  2282                                  
  2283                                  searchLabel:  ; *** PROC ***
  2284                                  
  2285                                  ;-70     int LIx; char *p;
  2286                                  
  2287                                  
  2288                                  ;-71     p = &LabelNames;
  2289                                  
  2290                                  ;Function : searchLabel, Number of local variables: 2
  2291                                  ;   # type sign width line used address name   list of local variables
  2292                                  ;  200 var sign word    70 NULL bp-2    LIx
  2293                                  ;  201 ptr sign byte    70 NULL bp-4    p;
  2294 00007BA0 C8040000                 ENTER  4,0
  2295 00007BA4 B8[CB01]                 mov ax, LabelNames
  2296 00007BA7 8946FC                   mov word [bp-4], ax
  2297                                  
  2298                                  ;-72     LIx = 1;
  2299                                  
  2300 00007BAA 66B801000000             mov eax, 1
  2301 00007BB0 8946FE                   mov word [bp-2], ax
  2302                                  
  2303                                  ;-73     while (LIx <= LabelMaxIx) {
  2304                                  
  2305                                  @@searchLabel83:
  2306 00007BB3 8B46FE                   mov ax, [bp-2]
  2307 00007BB6 3B06[1D16]               cmp ax, [LabelMaxIx]
  2308 00007BBA 0F8F3100                 jg  @@searchLabel84
  2309                                  
  2310                                  ;-74         if (eqstr(p, Symbol)) return LIx;//pos of label                    
  2311                                  
  2312 00007BBE 8D06[0E00]               lea  ax, [Symbol]
  2313 00007BC2 50                       push ax
  2314 00007BC3 FF76FC                   push word [bp-4]
  2315 00007BC6 E8DB1E                   call eqstr
  2316 00007BC9 83C404                   add  sp, 4
  2317 00007BCC 08C0                     or  al, al
  2318 00007BCE 0F840600                 je @@searchLabel85
  2319 00007BD2 8B46FE                   mov ax, [bp-2]
  2320 00007BD5 E92000                   jmp @@retn
  2321                                  
  2322                                  ;-75         p=strlen(p) + p;                  
  2323                                  
  2324                                  @@searchLabel85:
  2325 00007BD8 FF76FC                   push word [bp-4]
  2326 00007BDB E82F1E                   call strlen
  2327 00007BDE 83C402                   add  sp, 2
  2328 00007BE1 0346FC                   add ax, [bp-4]
  2329 00007BE4 8946FC                   mov word [bp-4], ax
  2330                                  
  2331                                  ;-76         p++; 
  2332                                  
  2333 00007BE7 FF46FC                   inc  word [bp-4]
  2334                                  
  2335                                  ;-77         LIx++;
  2336                                  
  2337 00007BEA FF46FE                   inc  word [bp-2]
  2338                                  
  2339                                  ;-78     }
  2340                                  
  2341                                  
  2342                                  ;-79     return 0;
  2343                                  
  2344 00007BED EBC4                     jmp @@searchLabel83
  2345                                  @@searchLabel84:
  2346 00007BEF 66B800000000             mov eax, 0
  2347 00007BF5 E90000                   jmp @@retn
  2348                                  
  2349                                  ;-80 }   
  2350                                  
  2351                                  
  2352                                  ;-81 
  2353                                  
  2354                                  
  2355                                  ;-82 int getVariable() { 
  2356                                  
  2357 00007BF8 C9                      @@retn: LEAVE
  2358 00007BF9 C3                       ret
  2359                                  ; ENDP
  2360                                  
  2361                                  getVariable:  ; *** PROC ***
  2362                                  
  2363                                  ;-83     char c; unsigned int i;
  2364                                  
  2365                                  
  2366                                  ;-84     storeLabel();
  2367                                  
  2368                                  ;Function : getVariable, Number of local variables: 2
  2369                                  ;   # type sign width line used address name   list of local variables
  2370                                  ;  200 var sign byte    83 NULL bp-2    c
  2371                                  ;  201 var unsg word    83 NULL bp-4    i;
  2372 00007BFA C8040000                 ENTER  4,0
  2373 00007BFE E8F8FE                   call storeLabel
  2374                                  
  2375                                  ;-85     getTokeType(); 
  2376                                  
  2377 00007C01 E8D5FD                   call getTokeType
  2378                                  
  2379                                  ;-86     if(TokeType==ALNUME) {//getName
  2380                                  
  2381 00007C04 A0[AC01]                 mov al, [TokeType]
  2382 00007C07 3C03                     cmp al, 3
  2383 00007C09 0F854801                 jne @@getVariable86
  2384                                  
  2385                                  ;-87         lookCode();
  2386                                  
  2387 00007C0D E84A01                   call lookCode
  2388                                  
  2389                                  ;-88         if (CodeType < 200) dataexit();
  2390                                  
  2391 00007C10 A0[AF01]                 mov al, [CodeType]
  2392 00007C13 3CC8                     cmp al, 200
  2393 00007C15 0F8D0300                 jge @@getVariable87
  2394 00007C19 E87C0E                   call dataexit
  2395                                  
  2396                                  ;-89         if (CodeType > 205) dataexit();
  2397                                  
  2398                                  @@getVariable87:
  2399 00007C1C A0[AF01]                 mov al, [CodeType]
  2400 00007C1F 3CCD                     cmp al, 205
  2401 00007C21 0F8E0300                 jle @@getVariable88
  2402 00007C25 E8700E                   call dataexit
  2403                                  
  2404                                  ;-90         if (CodeType== 200) {//DB
  2405                                  
  2406                                  @@getVariable88:
  2407 00007C28 A0[AF01]                 mov al, [CodeType]
  2408 00007C2B 3CC8                     cmp al, 200
  2409 00007C2D 0F856A00                 jne @@getVariable89
  2410                                  
  2411                                  ;-91             do { 
  2412                                  
  2413                                  @@getVariable90:
  2414                                  
  2415                                  ;-92                 getTokeType();
  2416                                  
  2417 00007C31 E8A5FD                   call getTokeType
  2418                                  
  2419                                  ;-93                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2420                                  
  2421 00007C34 A0[AC01]                 mov al, [TokeType]
  2422 00007C37 3C01                     cmp al, 1
  2423 00007C39 0F850D00                 jne @@getVariable91
  2424 00007C3D FF36[4C00]               push word [SymbolInt]
  2425 00007C41 E88A13                   call genCode8
  2426 00007C44 83C402                   add  sp, 2
  2427                                  
  2428                                  ;-94                 else {
  2429                                  
  2430 00007C47 E94100                   jmp @@getVariable92
  2431                                  @@getVariable91:
  2432                                  
  2433                                  ;-95                     skipBlank();
  2434                                  
  2435 00007C4A E8A203                   call skipBlank
  2436                                  
  2437                                  ;-96                     if (isToken('"')) {
  2438                                  
  2439 00007C4D 6A22                     push 34
  2440 00007C4F E80502                   call isToken
  2441 00007C52 83C402                   add  sp, 2
  2442 00007C55 08C0                     or  al, al
  2443 00007C57 0F843000                 je @@getVariable93
  2444                                  
  2445                                  ;-97                         do { 
  2446                                  
  2447                                  @@getVariable94:
  2448                                  
  2449                                  ;-98                             c= *InputPtr;
  2450                                  
  2451 00007C5B 8B1E[CD00]               mov bx, [InputPtr]
  2452 00007C5F 8A07                     mov al, [bx]
  2453 00007C61 B400                     mov ah, 0
  2454 00007C63 8846FE                   mov byte [bp-2], al
  2455                                  
  2456                                  ;-99                             genCode8(c);
  2457                                  
  2458 00007C66 8A46FE                   mov al, byte [bp-2]
  2459 00007C69 B400                     mov ah, 0
  2460 00007C6B 50                       push ax
  2461 00007C6C E85F13                   call genCode8
  2462 00007C6F 83C402                   add  sp, 2
  2463                                  
  2464                                  ;-100                             InputPtr++;
  2465                                  
  2466 00007C72 FF06[CD00]               inc  word [InputPtr]
  2467                                  
  2468                                  ;-101                         } while (*InputPtr != '"' );
  2469                                  
  2470 00007C76 8B1E[CD00]               mov bx, [InputPtr]
  2471 00007C7A 8A07                     mov al, [bx]
  2472 00007C7C B400                     mov ah, 0
  2473 00007C7E 83F822                   cmp ax, 34
  2474 00007C81 0F840200                 je  @@getVariable95
  2475 00007C85 EBD4                     jmp @@getVariable94
  2476                                  @@getVariable95:
  2477                                  
  2478                                  ;-102                         InputPtr++;
  2479                                  
  2480 00007C87 FF06[CD00]               inc  word [InputPtr]
  2481                                  
  2482                                  ;-103                     }
  2483                                  
  2484                                  
  2485                                  ;-104                 }
  2486                                  
  2487                                  @@getVariable93:
  2488                                  
  2489                                  ;-105             } while (isToken(','));
  2490                                  
  2491                                  @@getVariable92:
  2492 00007C8B 6A2C                     push 44
  2493 00007C8D E8C701                   call isToken
  2494 00007C90 83C402                   add  sp, 2
  2495 00007C93 08C0                     or  al, al
  2496 00007C95 0F840200                 je @@getVariable96
  2497 00007C99 EB96                     jmp @@getVariable90
  2498                                  @@getVariable96:
  2499                                  
  2500                                  ;-106         }
  2501                                  
  2502                                  
  2503                                  ;-107         if (CodeType== 201) {//DW
  2504                                  
  2505                                  @@getVariable89:
  2506 00007C9B A0[AF01]                 mov al, [CodeType]
  2507 00007C9E 3CC9                     cmp al, 201
  2508 00007CA0 0F852600                 jne @@getVariable97
  2509                                  
  2510                                  ;-108             do { 
  2511                                  
  2512                                  @@getVariable98:
  2513                                  
  2514                                  ;-109                 getTokeType();
  2515                                  
  2516 00007CA4 E832FD                   call getTokeType
  2517                                  
  2518                                  ;-110                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2519                                  
  2520 00007CA7 A0[AC01]                 mov al, [TokeType]
  2521 00007CAA 3C01                     cmp al, 1
  2522 00007CAC 0F850A00                 jne @@getVariable99
  2523 00007CB0 FF36[4C00]               push word [SymbolInt]
  2524 00007CB4 E86E13                   call genCode16
  2525 00007CB7 83C402                   add  sp, 2
  2526                                  
  2527                                  ;-111             } while (isToken(','));
  2528                                  
  2529                                  @@getVariable99:
  2530 00007CBA 6A2C                     push 44
  2531 00007CBC E89801                   call isToken
  2532 00007CBF 83C402                   add  sp, 2
  2533 00007CC2 08C0                     or  al, al
  2534 00007CC4 0F840200                 je @@getVariable100
  2535 00007CC8 EBDA                     jmp @@getVariable98
  2536                                  @@getVariable100:
  2537                                  
  2538                                  ;-112         } 
  2539                                  
  2540                                  
  2541                                  ;-113         if (CodeType == 202) implerror();
  2542                                  
  2543                                  @@getVariable97:
  2544 00007CCA A0[AF01]                 mov al, [CodeType]
  2545 00007CCD 3CCA                     cmp al, 202
  2546 00007CCF 0F850300                 jne @@getVariable101
  2547 00007CD3 E8A80C                   call implerror
  2548                                  
  2549                                  ;-114         if (CodeType >= 203) {//resb, resw, resd
  2550                                  
  2551                                  @@getVariable101:
  2552 00007CD6 A0[AF01]                 mov al, [CodeType]
  2553 00007CD9 3CCB                     cmp al, 203 ;unsigned : 1
  2554 00007CDB 0F8C7300                 jl  @@getVariable102
  2555                                  
  2556                                  ;-115             getTokeType();
  2557                                  
  2558 00007CDF E8F7FC                   call getTokeType
  2559                                  
  2560                                  ;-116             if (TokeType == DIGIT) {
  2561                                  
  2562 00007CE2 A0[AC01]                 mov al, [TokeType]
  2563 00007CE5 3C01                     cmp al, 1
  2564 00007CE7 0F856400                 jne @@getVariable103
  2565                                  
  2566                                  ;-117                 i=0;  
  2567                                  
  2568 00007CEB 66B800000000             mov eax, 0
  2569 00007CF1 8946FC                   mov word [bp-4], ax
  2570                                  
  2571                                  ;-118                 if (SymbolInt <= 0) syntaxerror();
  2572                                  
  2573 00007CF4 A1[4C00]                 mov ax, [SymbolInt]
  2574 00007CF7 83F800                   cmp ax, 0
  2575 00007CFA 0F870300                 ja  @@getVariable104
  2576 00007CFE E86C0D                   call syntaxerror
  2577                                  
  2578                                  ;-119                 do {
  2579                                  
  2580                                  @@getVariable104:
  2581                                  @@getVariable105:
  2582                                  
  2583                                  ;-120                     if (CodeType == 203) genCode8(0);
  2584                                  
  2585 00007D01 A0[AF01]                 mov al, [CodeType]
  2586 00007D04 3CCB                     cmp al, 203
  2587 00007D06 0F850800                 jne @@getVariable106
  2588 00007D0A 6A00                     push 0
  2589 00007D0C E8BF12                   call genCode8
  2590 00007D0F 83C402                   add  sp, 2
  2591                                  
  2592                                  ;-121                     if (CodeType == 204) genCode16(0);
  2593                                  
  2594                                  @@getVariable106:
  2595 00007D12 A0[AF01]                 mov al, [CodeType]
  2596 00007D15 3CCC                     cmp al, 204
  2597 00007D17 0F850800                 jne @@getVariable107
  2598 00007D1B 6A00                     push 0
  2599 00007D1D E80513                   call genCode16
  2600 00007D20 83C402                   add  sp, 2
  2601                                  
  2602                                  ;-122                     if (CodeType == 205) {genCode16(0);genCode16(0);}    
  2603                                  
  2604                                  @@getVariable107:
  2605 00007D23 A0[AF01]                 mov al, [CodeType]
  2606 00007D26 3CCD                     cmp al, 205
  2607 00007D28 0F851000                 jne @@getVariable108
  2608 00007D2C 6A00                     push 0
  2609 00007D2E E8F412                   call genCode16
  2610 00007D31 83C402                   add  sp, 2
  2611 00007D34 6A00                     push 0
  2612 00007D36 E8EC12                   call genCode16
  2613 00007D39 83C402                   add  sp, 2
  2614                                  
  2615                                  ;-123                     i++;
  2616                                  
  2617                                  @@getVariable108:
  2618 00007D3C FF46FC                   inc  word [bp-4]
  2619                                  
  2620                                  ;-124                 } while (i < SymbolInt);   
  2621                                  
  2622 00007D3F 8B46FC                   mov ax, [bp-4]
  2623 00007D42 3B06[4C00]               cmp ax, [SymbolInt]
  2624 00007D46 0F8D0200                 jge @@getVariable109
  2625 00007D4A EBB5                     jmp @@getVariable105
  2626                                  @@getVariable109:
  2627                                  
  2628                                  ;-125             } else numbererror();  
  2629                                  
  2630 00007D4C E90300                   jmp @@getVariable110
  2631                                  @@getVariable103:
  2632 00007D4F E8880C                   call numbererror
  2633                                  
  2634                                  ;-126         }    
  2635                                  
  2636                                  @@getVariable110:
  2637                                  
  2638                                  ;-127     }
  2639                                  
  2640                                  @@getVariable102:
  2641                                  
  2642                                  ;-128     else dataexit();
  2643                                  
  2644 00007D52 E90300                   jmp @@getVariable111
  2645                                  @@getVariable86:
  2646 00007D55 E8400D                   call dataexit
  2647                                  
  2648                                  ;-129 }
  2649                                  
  2650                                  @@getVariable111:
  2651                                  
  2652                                  ;-130 
  2653                                  
  2654                                  
  2655                                  ;-131 int lookCode() {//ret: CodeType, *OpCodePtr
  2656 00007D58 C9                       LEAVE
  2657 00007D59 C3                       ret
  2658                                  ; ENDP
  2659                                  
  2660                                  lookCode:  ; *** PROC ***
  2661                                  
  2662                                  ;-132     CodeType=0;
  2663                                  
  2664 00007D5A 66B800000000             mov eax, 0
  2665 00007D60 A2[AF01]                 mov byte [CodeType], al
  2666                                  
  2667                                  ;-133     OpCodePtr= &I_START;
  2668                                  
  2669 00007D63 B8[0370]                 mov ax, I_START
  2670 00007D66 A3[C801]                 mov word [OpCodePtr], ax
  2671                                  
  2672                                  ;-134     OpCodePtr++;
  2673                                  
  2674 00007D69 FF06[C801]               inc  word [OpCodePtr]
  2675                                  
  2676                                  ;-135     do  {
  2677                                  
  2678                                  @@lookCode112:
  2679                                  
  2680                                  ;-136         if (eqstr(SymbolUpper, OpCodePtr))  {
  2681                                  
  2682 00007D6D FF36[C801]               push word [OpCodePtr]
  2683 00007D71 8D06[2D00]               lea  ax, [SymbolUpper]
  2684 00007D75 50                       push ax
  2685 00007D76 E82B1D                   call eqstr
  2686 00007D79 83C404                   add  sp, 4
  2687 00007D7C 08C0                     or  al, al
  2688 00007D7E 0F842700                 je @@lookCode113
  2689                                  
  2690                                  ;-137             while(*OpCodePtr!=0) OpCodePtr++;
  2691                                  
  2692                                  @@lookCode114:
  2693 00007D82 8B1E[C801]               mov bx, [OpCodePtr]
  2694 00007D86 8A07                     mov al, [bx]
  2695 00007D88 B400                     mov ah, 0
  2696 00007D8A 83F800                   cmp ax, 0
  2697 00007D8D 0F840600                 je  @@lookCode115
  2698 00007D91 FF06[C801]               inc  word [OpCodePtr]
  2699                                  
  2700                                  ;-138             OpCodePtr++; 
  2701                                  
  2702 00007D95 EBEB                     jmp @@lookCode114
  2703                                  @@lookCode115:
  2704 00007D97 FF06[C801]               inc  word [OpCodePtr]
  2705                                  
  2706                                  ;-139             CodeType =*OpCodePtr;
  2707                                  
  2708 00007D9B 8B1E[C801]               mov bx, [OpCodePtr]
  2709 00007D9F 8A07                     mov al, [bx]
  2710 00007DA1 B400                     mov ah, 0
  2711 00007DA3 A2[AF01]                 mov byte [CodeType], al
  2712                                  
  2713                                  ;-140             return;
  2714                                  
  2715 00007DA6 E92A00                   jmp @@retn
  2716                                  
  2717                                  ;-141         }
  2718                                  
  2719                                  
  2720                                  ;-142     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2721                                  
  2722                                  @@lookCode113:
  2723                                  @@lookCode116:
  2724 00007DA9 8B1E[C801]               mov bx, [OpCodePtr]
  2725 00007DAD 8A07                     mov al, [bx]
  2726 00007DAF B400                     mov ah, 0
  2727 00007DB1 3DF100                   cmp ax, 241
  2728 00007DB4 0F840600                 je  @@lookCode117
  2729 00007DB8 FF06[C801]               inc  word [OpCodePtr]
  2730                                  
  2731                                  ;-143     OpCodePtr++;
  2732                                  
  2733 00007DBC EBEB                     jmp @@lookCode116
  2734                                  @@lookCode117:
  2735 00007DBE FF06[C801]               inc  word [OpCodePtr]
  2736                                  
  2737                                  ;-144     } while(*OpCodePtr!=0);
  2738                                  
  2739 00007DC2 8B1E[C801]               mov bx, [OpCodePtr]
  2740 00007DC6 8A07                     mov al, [bx]
  2741 00007DC8 B400                     mov ah, 0
  2742 00007DCA 83F800                   cmp ax, 0
  2743 00007DCD 0F840200                 je  @@lookCode118
  2744 00007DD1 EB9A                     jmp @@lookCode112
  2745                                  @@lookCode118:
  2746                                  
  2747                                  ;-145 }
  2748                                  
  2749                                  
  2750                                  ;-146 
  2751                                  
  2752                                  
  2753                                  ;-147 int getCodeSize() {
  2754                                  
  2755                                  @@retn:
  2756 00007DD3 C3                       ret
  2757                                  ; ENDP
  2758                                  
  2759                                  getCodeSize:  ; *** PROC ***
  2760                                  
  2761                                  ;-148     if (TokeType ==ALNUME) {
  2762                                  
  2763 00007DD4 A0[AC01]                 mov al, [TokeType]
  2764 00007DD7 3C03                     cmp al, 3
  2765 00007DD9 0F856000                 jne @@getCodeSize119
  2766                                  
  2767                                  ;-149         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2768                                  
  2769 00007DDD 68[477E]                 push getCodeSize_0
  2770 00007DE0 8D06[2D00]               lea  ax, [SymbolUpper]
  2771 00007DE4 50                       push ax
  2772 00007DE5 E8BC1C                   call eqstr
  2773 00007DE8 83C404                   add  sp, 4
  2774 00007DEB 08C0                     or  al, al
  2775 00007DED 0F840C00                 je @@getCodeSize120
  2776 00007DF1 E8E5FB                   call getTokeType
  2777 00007DF4 66B801000000             mov eax, 1
  2778 00007DFA E94900                   jmp @@retn
  2779                                  
  2780                                  ;-150         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2781                                  
  2782                                  @@getCodeSize120:
  2783 00007DFD 68[4C7E]                 push getCodeSize_1
  2784 00007E00 8D06[2D00]               lea  ax, [SymbolUpper]
  2785 00007E04 50                       push ax
  2786 00007E05 E89C1C                   call eqstr
  2787 00007E08 83C404                   add  sp, 4
  2788 00007E0B 08C0                     or  al, al
  2789 00007E0D 0F840C00                 je @@getCodeSize121
  2790 00007E11 E8C5FB                   call getTokeType
  2791 00007E14 66B802000000             mov eax, 2
  2792 00007E1A E92900                   jmp @@retn
  2793                                  
  2794                                  ;-151         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2795                                  
  2796                                  @@getCodeSize121:
  2797 00007E1D 68[517E]                 push getCodeSize_2
  2798 00007E20 8D06[2D00]               lea  ax, [SymbolUpper]
  2799 00007E24 50                       push ax
  2800 00007E25 E87C1C                   call eqstr
  2801 00007E28 83C404                   add  sp, 4
  2802 00007E2B 08C0                     or  al, al
  2803 00007E2D 0F840C00                 je @@getCodeSize122
  2804 00007E31 E8A5FB                   call getTokeType
  2805 00007E34 66B803000000             mov eax, 3
  2806 00007E3A E90900                   jmp @@retn
  2807                                  
  2808                                  ;-152     } 
  2809                                  
  2810                                  @@getCodeSize122:
  2811                                  
  2812                                  ;-153     return 0;
  2813                                  
  2814                                  @@getCodeSize119:
  2815 00007E3D 66B800000000             mov eax, 0
  2816 00007E43 E90000                   jmp @@retn
  2817                                  
  2818                                  ;-154 }
  2819                                  
  2820                                  
  2821                                  ;-155 int isToken(char c) {
  2822                                  
  2823                                  @@retn:
  2824 00007E46 C3                       ret
  2825                                  ; ENDP
  2826 00007E47 4259544500              getCodeSize_0 db "BYTE",0
  2827 00007E4C 574F524400              getCodeSize_1 db "WORD",0
  2828 00007E51 44574F524400            getCodeSize_2 db "DWORD",0
  2829                                  
  2830                                  isToken:  ; *** PROC ***
  2831                                  
  2832                                  ;-156     skipBlank();
  2833                                  
  2834                                  ;Function : isToken, Number of local variables: 1
  2835                                  ;   # type sign width line used address name   list of local variables
  2836                                  ;  200 var sign byte   155 NULL bp+4    c;
  2837 00007E57 C8000000                 ENTER  0,0
  2838 00007E5B E89101                   call skipBlank
  2839                                  
  2840                                  ;-157     if (*InputPtr == c) {
  2841                                  
  2842 00007E5E 8B1E[CD00]               mov bx, [InputPtr]
  2843 00007E62 8A07                     mov al, [bx]
  2844 00007E64 B400                     mov ah, 0
  2845 00007E66 3A4604                   cmp al, [bp+4]
  2846 00007E69 0F850D00                 jne @@isToken123
  2847                                  
  2848                                  ;-158         InputPtr++; 
  2849                                  
  2850 00007E6D FF06[CD00]               inc  word [InputPtr]
  2851                                  
  2852                                  ;-159         return 1;
  2853                                  
  2854 00007E71 66B801000000             mov eax, 1
  2855 00007E77 E90900                   jmp @@retn
  2856                                  
  2857                                  ;-160         } 
  2858                                  
  2859                                  
  2860                                  ;-161     return 0;
  2861                                  
  2862                                  @@isToken123:
  2863 00007E7A 66B800000000             mov eax, 0
  2864 00007E80 E90000                   jmp @@retn
  2865                                  
  2866                                  ;-162 }
  2867                                  
  2868                                  
  2869                                  ;-163 int need(char c) {
  2870                                  
  2871 00007E83 C9                      @@retn: LEAVE
  2872 00007E84 C3                       ret
  2873                                  ; ENDP
  2874                                  
  2875                                  need:  ; *** PROC ***
  2876                                  
  2877                                  ;-164     if (isToken(c)) {
  2878                                  
  2879                                  ;Function : need, Number of local variables: 1
  2880                                  ;   # type sign width line used address name   list of local variables
  2881                                  ;  200 var sign byte   163 NULL bp+4    c;
  2882 00007E85 C8000000                 ENTER  0,0
  2883 00007E89 8A4604                   mov al, byte [bp+4]
  2884 00007E8C B400                     mov ah, 0
  2885 00007E8E 50                       push ax
  2886 00007E8F E8C5FF                   call isToken
  2887 00007E92 83C402                   add  sp, 2
  2888 00007E95 08C0                     or  al, al
  2889 00007E97 0F840600                 je @@need124
  2890                                  
  2891                                  ;-165         getTokeType();
  2892                                  
  2893 00007E9B E83BFB                   call getTokeType
  2894                                  
  2895                                  ;-166         return;
  2896                                  
  2897 00007E9E E91800                   jmp @@retn
  2898                                  
  2899                                  ;-167         }
  2900                                  
  2901                                  
  2902                                  ;-168     error1();
  2903                                  
  2904                                  @@need124:
  2905 00007EA1 E80A0A                   call error1
  2906                                  
  2907                                  ;-169     prs(". need: ");
  2908                                  
  2909 00007EA4 68[BB7E]                 push need_0
  2910 00007EA7 E8A308                   call prs
  2911 00007EAA 83C402                   add  sp, 2
  2912                                  
  2913                                  ;-170     prc(c);
  2914                                  
  2915 00007EAD 8A4604                   mov al, byte [bp+4]
  2916 00007EB0 B400                     mov ah, 0
  2917 00007EB2 50                       push ax
  2918 00007EB3 E83608                   call prc
  2919 00007EB6 83C402                   add  sp, 2
  2920                                  
  2921                                  ;-171 }
  2922                                  
  2923                                  
  2924                                  ;-172 int skipRest() {
  2925                                  
  2926 00007EB9 C9                      @@retn: LEAVE
  2927 00007EBA C3                       ret
  2928                                  ; ENDP
  2929 00007EBB 2E206E6565643A2000      need_0 db ". need: ",0
  2930                                  
  2931                                  skipRest:  ; *** PROC ***
  2932                                  
  2933                                  ;-173     getTokeType(); 
  2934                                  
  2935 00007EC4 E812FB                   call getTokeType
  2936                                  
  2937                                  ;-174     if(TokeType)error1("extra char ignored");
  2938                                  
  2939 00007EC7 A0[AC01]                 mov al, [TokeType]
  2940 00007ECA 08C0                     or  al, al
  2941 00007ECC 0F840900                 je @@skipRest125
  2942 00007ED0 68[DA7E]                 push skipRest_0
  2943 00007ED3 E8D809                   call error1
  2944 00007ED6 83C402                   add  sp, 2
  2945                                  
  2946                                  ;-175 }
  2947                                  
  2948                                  @@skipRest125:
  2949 00007ED9 C3                       ret
  2950                                  ; ENDP
  2951 00007EDA 657874726120636861-     skipRest_0 db "extra char ignored",0
  2952 00007EE3 722069676E6F726564-
  2953 00007EEC 00                 
  2954                                  ;Back to main program: AS.C
  2955                                  
  2956                                  ;-6 #include "HELPER.C"
  2957                                  
  2958                                  ;Use include file: HELPER.C
  2959                                  
  2960                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2961                                  
  2962                                  
  2963                                  getLine:  ; *** PROC ***
  2964                                  
  2965                                  ;-2   unsigned int i;
  2966                                  
  2967                                  
  2968                                  ;-3   InputPtr= &InputBuf;
  2969                                  
  2970                                  ;Function : getLine, Number of local variables: 1
  2971                                  ;   # type sign width line used address name   list of local variables
  2972                                  ;  200 var unsg word     2 NULL bp-2    i;
  2973 00007EED C8020000                 ENTER  2,0
  2974 00007EF1 B8[4E00]                 mov ax, InputBuf
  2975 00007EF4 A3[CD00]                 mov word [InputPtr], ax
  2976                                  
  2977                                  ;-4   *InputPtr=0;//if last line is empty
  2978                                  
  2979 00007EF7 66B800000000             mov eax, 0
  2980 00007EFD 8B1E[CD00]               mov  bx, [InputPtr]
  2981 00007F01 8807                     mov  [bx], al
  2982                                  
  2983                                  ;-5   do {
  2984                                  
  2985                                  @@getLine126:
  2986                                  
  2987                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2988                                  
  2989 00007F03 6A01                     push 1
  2990 00007F05 FF36[9801]               push word [asm_fd]
  2991 00007F09 8D06[A401]               lea  ax, [DOS_ByteRead]
  2992 00007F0D 50                       push ax
  2993 00007F0E E82E1C                   call readRL
  2994 00007F11 83C406                   add  sp, 6
  2995 00007F14 A3[A201]                 mov word [DOS_NoBytes], ax
  2996                                  
  2997                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2998                                  
  2999 00007F17 A1[9E01]                 mov ax, [DOS_ERR]
  3000 00007F1A 08C0                     or  al, al
  3001 00007F1C 0F840900                 je @@getLine127
  3002 00007F20 68[857F]                 push getLine_0
  3003 00007F23 E8E709                   call errorexit
  3004 00007F26 83C402                   add  sp, 2
  3005                                  
  3006                                  ;-8     if (DOS_NoBytes == 0) return;
  3007                                  
  3008                                  @@getLine127:
  3009 00007F29 A1[A201]                 mov ax, [DOS_NoBytes]
  3010 00007F2C 83F800                   cmp ax, 0
  3011 00007F2F 0F850300                 jne @@getLine128
  3012 00007F33 E94D00                   jmp @@retn
  3013                                  
  3014                                  ;-9     *InputPtr = DOS_ByteRead;
  3015                                  
  3016                                  @@getLine128:
  3017 00007F36 A0[A401]                 mov al, [DOS_ByteRead]
  3018 00007F39 8B1E[CD00]               mov  bx, [InputPtr]
  3019 00007F3D 8807                     mov  [bx], al
  3020                                  
  3021                                  ;-10     InputPtr++;
  3022                                  
  3023 00007F3F FF06[CD00]               inc  word [InputPtr]
  3024                                  
  3025                                  ;-11     i = InputPtr - &InputBuf;
  3026                                  
  3027 00007F43 A1[CD00]                 mov ax, [InputPtr]
  3028 00007F46 2D[4E00]                 sub ax, InputBuf
  3029 00007F49 8946FE                   mov word [bp-2], ax
  3030                                  
  3031                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3032                                  
  3033 00007F4C 8B46FE                   mov ax, [bp-2]
  3034 00007F4F 83F87F                   cmp ax, 127 ;unsigned : 0
  3035 00007F52 0F820900                 jb  @@getLine129
  3036 00007F56 68[947F]                 push getLine_1
  3037 00007F59 E8B109                   call errorexit
  3038 00007F5C 83C402                   add  sp, 2
  3039                                  
  3040                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  3041                                  
  3042                                  @@getLine129:
  3043 00007F5F A0[A401]                 mov al, byte [DOS_ByteRead]
  3044 00007F62 B400                     mov ah, 0
  3045 00007F64 50                       push ax
  3046 00007F65 E84000                   call ifEOL
  3047 00007F68 83C402                   add  sp, 2
  3048 00007F6B 3C00                     cmp al, 0
  3049 00007F6D 0F850200                 jne @@getLine130
  3050 00007F71 EB90                     jmp @@getLine126
  3051                                  @@getLine130:
  3052                                  
  3053                                  ;-14   InputPtr--;
  3054                                  
  3055 00007F73 FF0E[CD00]               dec  word [InputPtr]
  3056                                  
  3057                                  ;-15   *InputPtr=0;
  3058                                  
  3059 00007F77 66B800000000             mov eax, 0
  3060 00007F7D 8B1E[CD00]               mov  bx, [InputPtr]
  3061 00007F81 8807                     mov  [bx], al
  3062                                  
  3063                                  ;-16 }
  3064                                  
  3065                                  
  3066                                  ;-17 int ifEOL(char c) {
  3067                                  
  3068 00007F83 C9                      @@retn: LEAVE
  3069 00007F84 C3                       ret
  3070                                  ; ENDP
  3071 00007F85 52656164696E672053-     getLine_0 db "Reading Source",0
  3072 00007F8E 6F7572636500       
  3073 00007F94 696E707574206C696E-     getLine_1 db "input line too long",0
  3074 00007F9D 6520746F6F206C6F6E-
  3075 00007FA6 6700               
  3076                                  
  3077                                  ifEOL:  ; *** PROC ***
  3078                                  
  3079                                  ;-18   if (c == 10) return 1;
  3080                                  
  3081                                  ;Function : ifEOL, Number of local variables: 1
  3082                                  ;   # type sign width line used address name   list of local variables
  3083                                  ;  200 var sign byte    17 NULL bp+4    c;
  3084 00007FA8 C8000000                 ENTER  0,0
  3085 00007FAC 8A4604                   mov al, [bp+4]
  3086 00007FAF 3C0A                     cmp al, 10
  3087 00007FB1 0F850900                 jne @@ifEOL131
  3088 00007FB5 66B801000000             mov eax, 1
  3089 00007FBB E92F00                   jmp @@retn
  3090                                  
  3091                                  ;-19   if (c == 13) {
  3092                                  
  3093                                  @@ifEOL131:
  3094 00007FBE 8A4604                   mov al, [bp+4]
  3095 00007FC1 3C0D                     cmp al, 13
  3096 00007FC3 0F851D00                 jne @@ifEOL132
  3097                                  
  3098                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3099                                  
  3100 00007FC7 6A01                     push 1
  3101 00007FC9 FF36[9801]               push word [asm_fd]
  3102 00007FCD 8D06[A401]               lea  ax, [DOS_ByteRead]
  3103 00007FD1 50                       push ax
  3104 00007FD2 E86A1B                   call readRL
  3105 00007FD5 83C406                   add  sp, 6
  3106 00007FD8 A3[A201]                 mov word [DOS_NoBytes], ax
  3107                                  
  3108                                  ;-21     return 1;}
  3109                                  
  3110 00007FDB 66B801000000             mov eax, 1
  3111 00007FE1 E90900                   jmp @@retn
  3112                                  
  3113                                  ;-22   return 0;
  3114                                  
  3115                                  @@ifEOL132:
  3116 00007FE4 66B800000000             mov eax, 0
  3117 00007FEA E90000                   jmp @@retn
  3118                                  
  3119                                  ;-23 }
  3120                                  
  3121                                  
  3122                                  ;-24 int skipBlank() {
  3123                                  
  3124 00007FED C9                      @@retn: LEAVE
  3125 00007FEE C3                       ret
  3126                                  ; ENDP
  3127                                  
  3128                                  skipBlank:  ; *** PROC ***
  3129                                  
  3130                                  ;-25   skipblank1:
  3131                                  
  3132                                  @@skipblank1:
  3133                                  
  3134                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3135                                  
  3136 00007FEF 8B1E[CD00]               mov bx, [InputPtr]
  3137 00007FF3 8A07                     mov al, [bx]
  3138 00007FF5 B400                     mov ah, 0
  3139 00007FF7 83F820                   cmp ax, 32
  3140 00007FFA 0F850600                 jne @@skipBlank133
  3141 00007FFE FF06[CD00]               inc  word [InputPtr]
  3142 00008002 EBEB                     jmp @@skipblank1
  3143                                  
  3144                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3145                                  
  3146                                  @@skipBlank133:
  3147 00008004 8B1E[CD00]               mov bx, [InputPtr]
  3148 00008008 8A07                     mov al, [bx]
  3149 0000800A B400                     mov ah, 0
  3150 0000800C 83F809                   cmp ax, 9
  3151 0000800F 0F850600                 jne @@skipBlank134
  3152 00008013 FF06[CD00]               inc  word [InputPtr]
  3153 00008017 EBD6                     jmp @@skipblank1
  3154                                  
  3155                                  ;-28 }
  3156                                  
  3157                                  @@skipBlank134:
  3158                                  
  3159                                  ;-29 int letterE(char c) {
  3160                                  
  3161 00008019 C3                       ret
  3162                                  ; ENDP
  3163                                  
  3164                                  letterE:  ; *** PROC ***
  3165                                  
  3166                                  ;-30   if (c=='_') return 1;
  3167                                  
  3168                                  ;Function : letterE, Number of local variables: 1
  3169                                  ;   # type sign width line used address name   list of local variables
  3170                                  ;  200 var sign byte    29 NULL bp+4    c;
  3171 0000801A C8000000                 ENTER  0,0
  3172 0000801E 8A4604                   mov al, [bp+4]
  3173 00008021 3C5F                     cmp al, 95
  3174 00008023 0F850900                 jne @@letterE135
  3175 00008027 66B801000000             mov eax, 1
  3176 0000802D E97E00                   jmp @@retn
  3177                                  
  3178                                  ;-31   if (c=='.') return 1;
  3179                                  
  3180                                  @@letterE135:
  3181 00008030 8A4604                   mov al, [bp+4]
  3182 00008033 3C2E                     cmp al, 46
  3183 00008035 0F850900                 jne @@letterE136
  3184 00008039 66B801000000             mov eax, 1
  3185 0000803F E96C00                   jmp @@retn
  3186                                  
  3187                                  ;-32   if (c=='?') return 1;
  3188                                  
  3189                                  @@letterE136:
  3190 00008042 8A4604                   mov al, [bp+4]
  3191 00008045 3C3F                     cmp al, 63
  3192 00008047 0F850900                 jne @@letterE137
  3193 0000804B 66B801000000             mov eax, 1
  3194 00008051 E95A00                   jmp @@retn
  3195                                  
  3196                                  ;-33   if (c=='$') return 1;
  3197                                  
  3198                                  @@letterE137:
  3199 00008054 8A4604                   mov al, [bp+4]
  3200 00008057 3C24                     cmp al, 36
  3201 00008059 0F850900                 jne @@letterE138
  3202 0000805D 66B801000000             mov eax, 1
  3203 00008063 E94800                   jmp @@retn
  3204                                  
  3205                                  ;-34   if (c> 'z') return 0;
  3206                                  
  3207                                  @@letterE138:
  3208 00008066 8A4604                   mov al, [bp+4]
  3209 00008069 3C7A                     cmp al, 122
  3210 0000806B 0F8E0900                 jle @@letterE139
  3211 0000806F 66B800000000             mov eax, 0
  3212 00008075 E93600                   jmp @@retn
  3213                                  
  3214                                  ;-35   if (c< '@') return 0; // at included
  3215                                  
  3216                                  @@letterE139:
  3217 00008078 8A4604                   mov al, [bp+4]
  3218 0000807B 3C40                     cmp al, 64
  3219 0000807D 0F8D0900                 jge @@letterE140
  3220 00008081 66B800000000             mov eax, 0
  3221 00008087 E92400                   jmp @@retn
  3222                                  
  3223                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  3224                                  
  3225                                  @@letterE140:
  3226 0000808A 8A4604                   mov al, [bp+4]
  3227 0000808D 3C5A                     cmp al, 90
  3228 0000808F 0F8E1200                 jle @@letterE141
  3229 00008093 8A4604                   mov al, [bp+4]
  3230 00008096 3C61                     cmp al, 97
  3231 00008098 0F8D0900                 jge @@letterE142
  3232 0000809C 66B800000000             mov eax, 0
  3233 000080A2 E90900                   jmp @@retn
  3234                                  @@letterE142:
  3235                                  
  3236                                  ;-37   return 1;
  3237                                  
  3238                                  @@letterE141:
  3239 000080A5 66B801000000             mov eax, 1
  3240 000080AB E90000                   jmp @@retn
  3241                                  
  3242                                  ;-38 }
  3243                                  
  3244                                  
  3245                                  ;-39 int alnumE(char c) {
  3246                                  
  3247 000080AE C9                      @@retn: LEAVE
  3248 000080AF C3                       ret
  3249                                  ; ENDP
  3250                                  
  3251                                  alnumE:  ; *** PROC ***
  3252                                  
  3253                                  ;-40   if (digit(c)) return 1;
  3254                                  
  3255                                  ;Function : alnumE, Number of local variables: 1
  3256                                  ;   # type sign width line used address name   list of local variables
  3257                                  ;  200 var sign byte    39 NULL bp+4    c;
  3258 000080B0 C8000000                 ENTER  0,0
  3259 000080B4 8A4604                   mov al, byte [bp+4]
  3260 000080B7 B400                     mov ah, 0
  3261 000080B9 50                       push ax
  3262 000080BA E8B419                   call digit
  3263 000080BD 83C402                   add  sp, 2
  3264 000080C0 08C0                     or  al, al
  3265 000080C2 0F840900                 je @@alnumE143
  3266 000080C6 66B801000000             mov eax, 1
  3267 000080CC E92400                   jmp @@retn
  3268                                  
  3269                                  ;-41   if (letterE(c)) return 1;
  3270                                  
  3271                                  @@alnumE143:
  3272 000080CF 8A4604                   mov al, byte [bp+4]
  3273 000080D2 B400                     mov ah, 0
  3274 000080D4 50                       push ax
  3275 000080D5 E842FF                   call letterE
  3276 000080D8 83C402                   add  sp, 2
  3277 000080DB 08C0                     or  al, al
  3278 000080DD 0F840900                 je @@alnumE144
  3279 000080E1 66B801000000             mov eax, 1
  3280 000080E7 E90900                   jmp @@retn
  3281                                  
  3282                                  ;-42   return 0;
  3283                                  
  3284                                  @@alnumE144:
  3285 000080EA 66B800000000             mov eax, 0
  3286 000080F0 E90000                   jmp @@retn
  3287                                  
  3288                                  ;-43 }
  3289                                  
  3290                                  
  3291                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3292                                  
  3293 000080F3 C9                      @@retn: LEAVE
  3294 000080F4 C3                       ret
  3295                                  ; ENDP
  3296                                  
  3297                                  getDigit:  ; *** PROC ***
  3298                                  
  3299                                  ;-45   unsigned int CastInt;
  3300                                  
  3301                                  
  3302                                  ;-46   SymbolInt=0;
  3303                                  
  3304                                  ;Function : getDigit, Number of local variables: 2
  3305                                  ;   # type sign width line used address name   list of local variables
  3306                                  ;  200 var unsg byte    44 NULL bp+4    c
  3307                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3308 000080F5 C8020000                 ENTER  2,0
  3309 000080F9 66B800000000             mov eax, 0
  3310 000080FF A3[4C00]                 mov word [SymbolInt], ax
  3311                                  
  3312                                  ;-47   do {
  3313                                  
  3314                                  @@getDigit145:
  3315                                  
  3316                                  ;-48     c-='0';
  3317                                  
  3318 00008102 806E0430                 sub  byte [bp+4], 48
  3319                                  
  3320                                  ;-49     SymbolInt=SymbolInt*10;
  3321                                  
  3322 00008106 A1[4C00]                 mov ax, [SymbolInt]
  3323 00008109 66BB0A000000             mov ebx, 10
  3324 0000810F 66F7E3                   mul ebx
  3325 00008112 A3[4C00]                 mov word [SymbolInt], ax
  3326                                  
  3327                                  ;-50     ax=0; CastInt=c; //cast b2w
  3328                                  
  3329 00008115 B80000                   mov  ax, 0
  3330 00008118 8A4604                   mov al, [bp+4]
  3331 0000811B 8946FE                   mov word [bp-2], ax
  3332                                  
  3333                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3334                                  
  3335 0000811E A1[4C00]                 mov ax, [SymbolInt]
  3336 00008121 0346FE                   add ax, [bp-2]
  3337 00008124 A3[4C00]                 mov word [SymbolInt], ax
  3338                                  
  3339                                  ;-52     InputPtr++;
  3340                                  
  3341 00008127 FF06[CD00]               inc  word [InputPtr]
  3342                                  
  3343                                  ;-53     c = *InputPtr;
  3344                                  
  3345 0000812B 8B1E[CD00]               mov bx, [InputPtr]
  3346 0000812F 8A07                     mov al, [bx]
  3347 00008131 B400                     mov ah, 0
  3348 00008133 884604                   mov byte [bp+4], al
  3349                                  
  3350                                  ;-54   } while(digit(c));
  3351                                  
  3352 00008136 8A4604                   mov al, byte [bp+4]
  3353 00008139 B400                     mov ah, 0
  3354 0000813B 50                       push ax
  3355 0000813C E83219                   call digit
  3356 0000813F 83C402                   add  sp, 2
  3357 00008142 08C0                     or  al, al
  3358 00008144 0F840200                 je @@getDigit146
  3359 00008148 EBB8                     jmp @@getDigit145
  3360                                  @@getDigit146:
  3361                                  
  3362                                  ;-55 }
  3363                                  
  3364                                  
  3365                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3366 0000814A C9                       LEAVE
  3367 0000814B C3                       ret
  3368                                  ; ENDP
  3369                                  
  3370                                  getName:  ; *** PROC ***
  3371                                  
  3372                                  ;-57   char *p; unsigned int i;
  3373                                  
  3374                                  
  3375                                  ;-58   p = &Symbol;
  3376                                  
  3377                                  ;Function : getName, Number of local variables: 3
  3378                                  ;   # type sign width line used address name   list of local variables
  3379                                  ;  200 var unsg byte    56 NULL bp+4    c
  3380                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3381                                  ;  202 var unsg word    57 NULL bp-4    i;
  3382 0000814C C8040000                 ENTER  4,0
  3383 00008150 B8[0E00]                 mov ax, Symbol
  3384 00008153 8946FE                   mov word [bp-2], ax
  3385                                  
  3386                                  ;-59   *p = c;
  3387                                  
  3388 00008156 8A4604                   mov al, [bp+4]
  3389 00008159 8B5EFE                   mov  bx, [bp-2]
  3390 0000815C 8807                     mov  [bx], al
  3391                                  
  3392                                  ;-60   p++;
  3393                                  
  3394 0000815E FF46FE                   inc  word [bp-2]
  3395                                  
  3396                                  ;-61   while (alnumE(c)) {
  3397                                  
  3398                                  @@getName147:
  3399 00008161 8A4604                   mov al, byte [bp+4]
  3400 00008164 B400                     mov ah, 0
  3401 00008166 50                       push ax
  3402 00008167 E846FF                   call alnumE
  3403 0000816A 83C402                   add  sp, 2
  3404 0000816D 08C0                     or  al, al
  3405 0000816F 0F843800                 je @@getName148
  3406                                  
  3407                                  ;-62     InputPtr++;
  3408                                  
  3409 00008173 FF06[CD00]               inc  word [InputPtr]
  3410                                  
  3411                                  ;-63     c = *InputPtr;
  3412                                  
  3413 00008177 8B1E[CD00]               mov bx, [InputPtr]
  3414 0000817B 8A07                     mov al, [bx]
  3415 0000817D B400                     mov ah, 0
  3416 0000817F 884604                   mov byte [bp+4], al
  3417                                  
  3418                                  ;-64     *p = c;
  3419                                  
  3420 00008182 8A4604                   mov al, [bp+4]
  3421 00008185 8B5EFE                   mov  bx, [bp-2]
  3422 00008188 8807                     mov  [bx], al
  3423                                  
  3424                                  ;-65     p++;
  3425                                  
  3426 0000818A FF46FE                   inc  word [bp-2]
  3427                                  
  3428                                  ;-66     i = p - &Symbol;
  3429                                  
  3430 0000818D 8B46FE                   mov ax, [bp-2]
  3431 00008190 2D[0E00]                 sub ax, Symbol
  3432 00008193 8946FC                   mov word [bp-4], ax
  3433                                  
  3434                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3435                                  
  3436 00008196 8B46FC                   mov ax, [bp-4]
  3437 00008199 83F81F                   cmp ax, 31 ;unsigned : 0
  3438 0000819C 0F820900                 jb  @@getName149
  3439 000081A0 68[F481]                 push getName_0
  3440 000081A3 E86707                   call errorexit
  3441 000081A6 83C402                   add  sp, 2
  3442                                  
  3443                                  ;-68   }
  3444                                  
  3445                                  @@getName149:
  3446                                  
  3447                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3448                                  
  3449 000081A9 EBB6                     jmp @@getName147
  3450                                  @@getName148:
  3451 000081AB 8A4604                   mov al, [bp+4]
  3452 000081AE 3C3A                     cmp al, 58
  3453 000081B0 0F850C00                 jne @@getName150
  3454 000081B4 66B801000000             mov eax, 1
  3455 000081BA A2[AB01]                 mov byte [isLabel], al
  3456 000081BD E90900                   jmp @@getName151
  3457                                  @@getName150:
  3458 000081C0 66B800000000             mov eax, 0
  3459 000081C6 A2[AB01]                 mov byte [isLabel], al
  3460                                  
  3461                                  ;-70   p--;
  3462                                  
  3463                                  @@getName151:
  3464 000081C9 FF4EFE                   dec  word [bp-2]
  3465                                  
  3466                                  ;-71   *p = 0;
  3467                                  
  3468 000081CC 66B800000000             mov eax, 0
  3469 000081D2 8B5EFE                   mov  bx, [bp-2]
  3470 000081D5 8807                     mov  [bx], al
  3471                                  
  3472                                  ;-72   strcpy(SymbolUpper, Symbol);
  3473                                  
  3474 000081D7 8D06[0E00]               lea  ax, [Symbol]
  3475 000081DB 50                       push ax
  3476 000081DC 8D06[2D00]               lea  ax, [SymbolUpper]
  3477 000081E0 50                       push ax
  3478 000081E1 E85418                   call strcpy
  3479 000081E4 83C404                   add  sp, 4
  3480                                  
  3481                                  ;-73   toupper(SymbolUpper);
  3482                                  
  3483 000081E7 8D06[2D00]               lea  ax, [SymbolUpper]
  3484 000081EB 50                       push ax
  3485 000081EC E8DB17                   call toupper
  3486 000081EF 83C402                   add  sp, 2
  3487                                  
  3488                                  ;-74 }
  3489                                  
  3490                                  
  3491                                  ;-75 int testReg() {
  3492 000081F2 C9                       LEAVE
  3493 000081F3 C3                       ret
  3494                                  ; ENDP
  3495 000081F4 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3496 000081FD 6F206C6F6E6700     
  3497                                  
  3498                                  testReg:  ; *** PROC ***
  3499                                  
  3500                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3501                                  
  3502                                  
  3503                                  ;-77   R2Type=0;
  3504                                  
  3505 00008204 66B800000000             mov eax, 0
  3506 0000820A A2[B501]                 mov byte [R2Type], al
  3507                                  
  3508                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3509                                  
  3510 0000820D 8D06[0E00]               lea  ax, [Symbol]
  3511 00008211 50                       push ax
  3512 00008212 E8F817                   call strlen
  3513 00008215 83C402                   add  sp, 2
  3514 00008218 3C02                     cmp al, 2
  3515 0000821A 0F8D0900                 jge @@testReg152
  3516 0000821E 66B800000000             mov eax, 0
  3517 00008224 E9B603                   jmp @@retn
  3518                                  
  3519                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3520                                  
  3521                                  @@testReg152:
  3522 00008227 8D06[0E00]               lea  ax, [Symbol]
  3523 0000822B 50                       push ax
  3524 0000822C E8DE17                   call strlen
  3525 0000822F 83C402                   add  sp, 2
  3526 00008232 3C03                     cmp al, 3
  3527 00008234 0F8E0900                 jle @@testReg153
  3528 00008238 66B800000000             mov eax, 0
  3529 0000823E E99C03                   jmp @@retn
  3530                                  
  3531                                  ;-80   R2Type=BYTE;
  3532                                  
  3533                                  @@testReg153:
  3534 00008241 66B801000000             mov eax, 1
  3535 00008247 A2[B501]                 mov byte [R2Type], al
  3536                                  
  3537                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3538                                  
  3539 0000824A 68[DE85]                 push testReg_0
  3540 0000824D 8D06[2D00]               lea  ax, [SymbolUpper]
  3541 00008251 50                       push ax
  3542 00008252 E84F18                   call eqstr
  3543 00008255 83C404                   add  sp, 4
  3544 00008258 08C0                     or  al, al
  3545 0000825A 0F840900                 je @@testReg154
  3546 0000825E 66B800000000             mov eax, 0
  3547 00008264 E97603                   jmp @@retn
  3548                                  
  3549                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3550                                  
  3551                                  @@testReg154:
  3552 00008267 68[E185]                 push testReg_1
  3553 0000826A 8D06[2D00]               lea  ax, [SymbolUpper]
  3554 0000826E 50                       push ax
  3555 0000826F E83218                   call eqstr
  3556 00008272 83C404                   add  sp, 4
  3557 00008275 08C0                     or  al, al
  3558 00008277 0F840900                 je @@testReg155
  3559 0000827B 66B801000000             mov eax, 1
  3560 00008281 E95903                   jmp @@retn
  3561                                  
  3562                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3563                                  
  3564                                  @@testReg155:
  3565 00008284 68[E485]                 push testReg_2
  3566 00008287 8D06[2D00]               lea  ax, [SymbolUpper]
  3567 0000828B 50                       push ax
  3568 0000828C E81518                   call eqstr
  3569 0000828F 83C404                   add  sp, 4
  3570 00008292 08C0                     or  al, al
  3571 00008294 0F840900                 je @@testReg156
  3572 00008298 66B802000000             mov eax, 2
  3573 0000829E E93C03                   jmp @@retn
  3574                                  
  3575                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3576                                  
  3577                                  @@testReg156:
  3578 000082A1 68[E785]                 push testReg_3
  3579 000082A4 8D06[2D00]               lea  ax, [SymbolUpper]
  3580 000082A8 50                       push ax
  3581 000082A9 E8F817                   call eqstr
  3582 000082AC 83C404                   add  sp, 4
  3583 000082AF 08C0                     or  al, al
  3584 000082B1 0F840900                 je @@testReg157
  3585 000082B5 66B803000000             mov eax, 3
  3586 000082BB E91F03                   jmp @@retn
  3587                                  
  3588                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3589                                  
  3590                                  @@testReg157:
  3591 000082BE 68[EA85]                 push testReg_4
  3592 000082C1 8D06[2D00]               lea  ax, [SymbolUpper]
  3593 000082C5 50                       push ax
  3594 000082C6 E8DB17                   call eqstr
  3595 000082C9 83C404                   add  sp, 4
  3596 000082CC 08C0                     or  al, al
  3597 000082CE 0F840900                 je @@testReg158
  3598 000082D2 66B804000000             mov eax, 4
  3599 000082D8 E90203                   jmp @@retn
  3600                                  
  3601                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3602                                  
  3603                                  @@testReg158:
  3604 000082DB 68[ED85]                 push testReg_5
  3605 000082DE 8D06[2D00]               lea  ax, [SymbolUpper]
  3606 000082E2 50                       push ax
  3607 000082E3 E8BE17                   call eqstr
  3608 000082E6 83C404                   add  sp, 4
  3609 000082E9 08C0                     or  al, al
  3610 000082EB 0F840900                 je @@testReg159
  3611 000082EF 66B805000000             mov eax, 5
  3612 000082F5 E9E502                   jmp @@retn
  3613                                  
  3614                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3615                                  
  3616                                  @@testReg159:
  3617 000082F8 68[F085]                 push testReg_6
  3618 000082FB 8D06[2D00]               lea  ax, [SymbolUpper]
  3619 000082FF 50                       push ax
  3620 00008300 E8A117                   call eqstr
  3621 00008303 83C404                   add  sp, 4
  3622 00008306 08C0                     or  al, al
  3623 00008308 0F840900                 je @@testReg160
  3624 0000830C 66B806000000             mov eax, 6
  3625 00008312 E9C802                   jmp @@retn
  3626                                  
  3627                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3628                                  
  3629                                  @@testReg160:
  3630 00008315 68[F385]                 push testReg_7
  3631 00008318 8D06[2D00]               lea  ax, [SymbolUpper]
  3632 0000831C 50                       push ax
  3633 0000831D E88417                   call eqstr
  3634 00008320 83C404                   add  sp, 4
  3635 00008323 08C0                     or  al, al
  3636 00008325 0F840900                 je @@testReg161
  3637 00008329 66B807000000             mov eax, 7
  3638 0000832F E9AB02                   jmp @@retn
  3639                                  
  3640                                  ;-89   R2Type=WORD;
  3641                                  
  3642                                  @@testReg161:
  3643 00008332 66B802000000             mov eax, 2
  3644 00008338 A2[B501]                 mov byte [R2Type], al
  3645                                  
  3646                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3647                                  
  3648 0000833B 68[F685]                 push testReg_8
  3649 0000833E 8D06[2D00]               lea  ax, [SymbolUpper]
  3650 00008342 50                       push ax
  3651 00008343 E85E17                   call eqstr
  3652 00008346 83C404                   add  sp, 4
  3653 00008349 08C0                     or  al, al
  3654 0000834B 0F840900                 je @@testReg162
  3655 0000834F 66B800000000             mov eax, 0
  3656 00008355 E98502                   jmp @@retn
  3657                                  
  3658                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3659                                  
  3660                                  @@testReg162:
  3661 00008358 68[F985]                 push testReg_9
  3662 0000835B 8D06[2D00]               lea  ax, [SymbolUpper]
  3663 0000835F 50                       push ax
  3664 00008360 E84117                   call eqstr
  3665 00008363 83C404                   add  sp, 4
  3666 00008366 08C0                     or  al, al
  3667 00008368 0F840900                 je @@testReg163
  3668 0000836C 66B801000000             mov eax, 1
  3669 00008372 E96802                   jmp @@retn
  3670                                  
  3671                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3672                                  
  3673                                  @@testReg163:
  3674 00008375 68[FC85]                 push testReg_10
  3675 00008378 8D06[2D00]               lea  ax, [SymbolUpper]
  3676 0000837C 50                       push ax
  3677 0000837D E82417                   call eqstr
  3678 00008380 83C404                   add  sp, 4
  3679 00008383 08C0                     or  al, al
  3680 00008385 0F840900                 je @@testReg164
  3681 00008389 66B802000000             mov eax, 2
  3682 0000838F E94B02                   jmp @@retn
  3683                                  
  3684                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3685                                  
  3686                                  @@testReg164:
  3687 00008392 68[FF85]                 push testReg_11
  3688 00008395 8D06[2D00]               lea  ax, [SymbolUpper]
  3689 00008399 50                       push ax
  3690 0000839A E80717                   call eqstr
  3691 0000839D 83C404                   add  sp, 4
  3692 000083A0 08C0                     or  al, al
  3693 000083A2 0F840900                 je @@testReg165
  3694 000083A6 66B803000000             mov eax, 3
  3695 000083AC E92E02                   jmp @@retn
  3696                                  
  3697                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3698                                  
  3699                                  @@testReg165:
  3700 000083AF 68[0286]                 push testReg_12
  3701 000083B2 8D06[2D00]               lea  ax, [SymbolUpper]
  3702 000083B6 50                       push ax
  3703 000083B7 E8EA16                   call eqstr
  3704 000083BA 83C404                   add  sp, 4
  3705 000083BD 08C0                     or  al, al
  3706 000083BF 0F840900                 je @@testReg166
  3707 000083C3 66B804000000             mov eax, 4
  3708 000083C9 E91102                   jmp @@retn
  3709                                  
  3710                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3711                                  
  3712                                  @@testReg166:
  3713 000083CC 68[0586]                 push testReg_13
  3714 000083CF 8D06[2D00]               lea  ax, [SymbolUpper]
  3715 000083D3 50                       push ax
  3716 000083D4 E8CD16                   call eqstr
  3717 000083D7 83C404                   add  sp, 4
  3718 000083DA 08C0                     or  al, al
  3719 000083DC 0F840900                 je @@testReg167
  3720 000083E0 66B805000000             mov eax, 5
  3721 000083E6 E9F401                   jmp @@retn
  3722                                  
  3723                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3724                                  
  3725                                  @@testReg167:
  3726 000083E9 68[0886]                 push testReg_14
  3727 000083EC 8D06[2D00]               lea  ax, [SymbolUpper]
  3728 000083F0 50                       push ax
  3729 000083F1 E8B016                   call eqstr
  3730 000083F4 83C404                   add  sp, 4
  3731 000083F7 08C0                     or  al, al
  3732 000083F9 0F840900                 je @@testReg168
  3733 000083FD 66B806000000             mov eax, 6
  3734 00008403 E9D701                   jmp @@retn
  3735                                  
  3736                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3737                                  
  3738                                  @@testReg168:
  3739 00008406 68[0B86]                 push testReg_15
  3740 00008409 8D06[2D00]               lea  ax, [SymbolUpper]
  3741 0000840D 50                       push ax
  3742 0000840E E89316                   call eqstr
  3743 00008411 83C404                   add  sp, 4
  3744 00008414 08C0                     or  al, al
  3745 00008416 0F840900                 je @@testReg169
  3746 0000841A 66B807000000             mov eax, 7
  3747 00008420 E9BA01                   jmp @@retn
  3748                                  
  3749                                  ;-98   R2Type=SEGREG;
  3750                                  
  3751                                  @@testReg169:
  3752 00008423 66B804000000             mov eax, 4
  3753 00008429 A2[B501]                 mov byte [R2Type], al
  3754                                  
  3755                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3756                                  
  3757 0000842C 68[0E86]                 push testReg_16
  3758 0000842F 8D06[2D00]               lea  ax, [SymbolUpper]
  3759 00008433 50                       push ax
  3760 00008434 E86D16                   call eqstr
  3761 00008437 83C404                   add  sp, 4
  3762 0000843A 08C0                     or  al, al
  3763 0000843C 0F840900                 je @@testReg170
  3764 00008440 66B800000000             mov eax, 0
  3765 00008446 E99401                   jmp @@retn
  3766                                  
  3767                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3768                                  
  3769                                  @@testReg170:
  3770 00008449 68[1186]                 push testReg_17
  3771 0000844C 8D06[2D00]               lea  ax, [SymbolUpper]
  3772 00008450 50                       push ax
  3773 00008451 E85016                   call eqstr
  3774 00008454 83C404                   add  sp, 4
  3775 00008457 08C0                     or  al, al
  3776 00008459 0F840900                 je @@testReg171
  3777 0000845D 66B801000000             mov eax, 1
  3778 00008463 E97701                   jmp @@retn
  3779                                  
  3780                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3781                                  
  3782                                  @@testReg171:
  3783 00008466 68[1486]                 push testReg_18
  3784 00008469 8D06[2D00]               lea  ax, [SymbolUpper]
  3785 0000846D 50                       push ax
  3786 0000846E E83316                   call eqstr
  3787 00008471 83C404                   add  sp, 4
  3788 00008474 08C0                     or  al, al
  3789 00008476 0F840900                 je @@testReg172
  3790 0000847A 66B802000000             mov eax, 2
  3791 00008480 E95A01                   jmp @@retn
  3792                                  
  3793                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3794                                  
  3795                                  @@testReg172:
  3796 00008483 68[1786]                 push testReg_19
  3797 00008486 8D06[2D00]               lea  ax, [SymbolUpper]
  3798 0000848A 50                       push ax
  3799 0000848B E81616                   call eqstr
  3800 0000848E 83C404                   add  sp, 4
  3801 00008491 08C0                     or  al, al
  3802 00008493 0F840900                 je @@testReg173
  3803 00008497 66B803000000             mov eax, 3
  3804 0000849D E93D01                   jmp @@retn
  3805                                  
  3806                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3807                                  
  3808                                  @@testReg173:
  3809 000084A0 68[1A86]                 push testReg_20
  3810 000084A3 8D06[2D00]               lea  ax, [SymbolUpper]
  3811 000084A7 50                       push ax
  3812 000084A8 E8F915                   call eqstr
  3813 000084AB 83C404                   add  sp, 4
  3814 000084AE 08C0                     or  al, al
  3815 000084B0 0F840900                 je @@testReg174
  3816 000084B4 66B804000000             mov eax, 4
  3817 000084BA E92001                   jmp @@retn
  3818                                  
  3819                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3820                                  
  3821                                  @@testReg174:
  3822 000084BD 68[1D86]                 push testReg_21
  3823 000084C0 8D06[2D00]               lea  ax, [SymbolUpper]
  3824 000084C4 50                       push ax
  3825 000084C5 E8DC15                   call eqstr
  3826 000084C8 83C404                   add  sp, 4
  3827 000084CB 08C0                     or  al, al
  3828 000084CD 0F840900                 je @@testReg175
  3829 000084D1 66B805000000             mov eax, 5
  3830 000084D7 E90301                   jmp @@retn
  3831                                  
  3832                                  ;-105   R2Type=DWORD;                         
  3833                                  
  3834                                  @@testReg175:
  3835 000084DA 66B803000000             mov eax, 3
  3836 000084E0 A2[B501]                 mov byte [R2Type], al
  3837                                  
  3838                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3839                                  
  3840 000084E3 68[2086]                 push testReg_22
  3841 000084E6 8D06[2D00]               lea  ax, [SymbolUpper]
  3842 000084EA 50                       push ax
  3843 000084EB E8B615                   call eqstr
  3844 000084EE 83C404                   add  sp, 4
  3845 000084F1 08C0                     or  al, al
  3846 000084F3 0F840900                 je @@testReg176
  3847 000084F7 66B800000000             mov eax, 0
  3848 000084FD E9DD00                   jmp @@retn
  3849                                  
  3850                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3851                                  
  3852                                  @@testReg176:
  3853 00008500 68[2486]                 push testReg_23
  3854 00008503 8D06[2D00]               lea  ax, [SymbolUpper]
  3855 00008507 50                       push ax
  3856 00008508 E89915                   call eqstr
  3857 0000850B 83C404                   add  sp, 4
  3858 0000850E 08C0                     or  al, al
  3859 00008510 0F840900                 je @@testReg177
  3860 00008514 66B801000000             mov eax, 1
  3861 0000851A E9C000                   jmp @@retn
  3862                                  
  3863                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3864                                  
  3865                                  @@testReg177:
  3866 0000851D 68[2886]                 push testReg_24
  3867 00008520 8D06[2D00]               lea  ax, [SymbolUpper]
  3868 00008524 50                       push ax
  3869 00008525 E87C15                   call eqstr
  3870 00008528 83C404                   add  sp, 4
  3871 0000852B 08C0                     or  al, al
  3872 0000852D 0F840900                 je @@testReg178
  3873 00008531 66B802000000             mov eax, 2
  3874 00008537 E9A300                   jmp @@retn
  3875                                  
  3876                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3877                                  
  3878                                  @@testReg178:
  3879 0000853A 68[2C86]                 push testReg_25
  3880 0000853D 8D06[2D00]               lea  ax, [SymbolUpper]
  3881 00008541 50                       push ax
  3882 00008542 E85F15                   call eqstr
  3883 00008545 83C404                   add  sp, 4
  3884 00008548 08C0                     or  al, al
  3885 0000854A 0F840900                 je @@testReg179
  3886 0000854E 66B803000000             mov eax, 3
  3887 00008554 E98600                   jmp @@retn
  3888                                  
  3889                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3890                                  
  3891                                  @@testReg179:
  3892 00008557 68[3086]                 push testReg_26
  3893 0000855A 8D06[2D00]               lea  ax, [SymbolUpper]
  3894 0000855E 50                       push ax
  3895 0000855F E84215                   call eqstr
  3896 00008562 83C404                   add  sp, 4
  3897 00008565 08C0                     or  al, al
  3898 00008567 0F840900                 je @@testReg180
  3899 0000856B 66B804000000             mov eax, 4
  3900 00008571 E96900                   jmp @@retn
  3901                                  
  3902                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3903                                  
  3904                                  @@testReg180:
  3905 00008574 68[3486]                 push testReg_27
  3906 00008577 8D06[2D00]               lea  ax, [SymbolUpper]
  3907 0000857B 50                       push ax
  3908 0000857C E82515                   call eqstr
  3909 0000857F 83C404                   add  sp, 4
  3910 00008582 08C0                     or  al, al
  3911 00008584 0F840900                 je @@testReg181
  3912 00008588 66B805000000             mov eax, 5
  3913 0000858E E94C00                   jmp @@retn
  3914                                  
  3915                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3916                                  
  3917                                  @@testReg181:
  3918 00008591 68[3886]                 push testReg_28
  3919 00008594 8D06[2D00]               lea  ax, [SymbolUpper]
  3920 00008598 50                       push ax
  3921 00008599 E80815                   call eqstr
  3922 0000859C 83C404                   add  sp, 4
  3923 0000859F 08C0                     or  al, al
  3924 000085A1 0F840900                 je @@testReg182
  3925 000085A5 66B806000000             mov eax, 6
  3926 000085AB E92F00                   jmp @@retn
  3927                                  
  3928                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3929                                  
  3930                                  @@testReg182:
  3931 000085AE 68[3C86]                 push testReg_29
  3932 000085B1 8D06[2D00]               lea  ax, [SymbolUpper]
  3933 000085B5 50                       push ax
  3934 000085B6 E8EB14                   call eqstr
  3935 000085B9 83C404                   add  sp, 4
  3936 000085BC 08C0                     or  al, al
  3937 000085BE 0F840900                 je @@testReg183
  3938 000085C2 66B807000000             mov eax, 7
  3939 000085C8 E91200                   jmp @@retn
  3940                                  
  3941                                  ;-114   R2Type=0; return 0;
  3942                                  
  3943                                  @@testReg183:
  3944 000085CB 66B800000000             mov eax, 0
  3945 000085D1 A2[B501]                 mov byte [R2Type], al
  3946 000085D4 66B800000000             mov eax, 0
  3947 000085DA E90000                   jmp @@retn
  3948                                  
  3949                                  ;-115 }
  3950                                  
  3951                                  @@retn:
  3952 000085DD C3                       ret
  3953                                  ; ENDP
  3954 000085DE 414C00                  testReg_0 db "AL",0
  3955 000085E1 434C00                  testReg_1 db "CL",0
  3956 000085E4 444C00                  testReg_2 db "DL",0
  3957 000085E7 424C00                  testReg_3 db "BL",0
  3958 000085EA 414800                  testReg_4 db "AH",0
  3959 000085ED 434800                  testReg_5 db "CH",0
  3960 000085F0 444800                  testReg_6 db "DH",0
  3961 000085F3 424800                  testReg_7 db "BH",0
  3962 000085F6 415800                  testReg_8 db "AX",0
  3963 000085F9 435800                  testReg_9 db "CX",0
  3964 000085FC 445800                  testReg_10 db "DX",0
  3965 000085FF 425800                  testReg_11 db "BX",0
  3966 00008602 535000                  testReg_12 db "SP",0
  3967 00008605 425000                  testReg_13 db "BP",0
  3968 00008608 534900                  testReg_14 db "SI",0
  3969 0000860B 444900                  testReg_15 db "DI",0
  3970 0000860E 455300                  testReg_16 db "ES",0
  3971 00008611 435300                  testReg_17 db "CS",0
  3972 00008614 535300                  testReg_18 db "SS",0
  3973 00008617 445300                  testReg_19 db "DS",0
  3974 0000861A 465300                  testReg_20 db "FS",0
  3975 0000861D 475300                  testReg_21 db "GS",0
  3976 00008620 45415800                testReg_22 db "EAX",0
  3977 00008624 45435800                testReg_23 db "ECX",0
  3978 00008628 45445800                testReg_24 db "EDX",0
  3979 0000862C 45425800                testReg_25 db "EBX",0
  3980 00008630 45535000                testReg_26 db "ESP",0
  3981 00008634 45425000                testReg_27 db "EBP",0
  3982 00008638 45534900                testReg_28 db "ESI",0
  3983 0000863C 45444900                testReg_29 db "EDI",0
  3984                                  ;Back to main program: AS.C
  3985                                  
  3986                                  ;-7 #include "OUTPUT.C"
  3987                                  
  3988                                  ;Use include file: OUTPUT.C
  3989                                  
  3990                                  ;-1 int printLine() { 
  3991                                  
  3992                                  
  3993                                  printLine:  ; *** PROC ***
  3994                                  
  3995                                  ;-2     int i; char c;
  3996                                  
  3997                                  
  3998                                  ;-3     prs("\n"); 
  3999                                  
  4000                                  ;Function : printLine, Number of local variables: 2
  4001                                  ;   # type sign width line used address name   list of local variables
  4002                                  ;  200 var sign word     2 NULL bp-2    i
  4003                                  ;  201 var sign byte     2 NULL bp-4    c;
  4004 00008640 C8040000                 ENTER  4,0
  4005 00008644 68[D586]                 push printLine_0
  4006 00008647 E80301                   call prs
  4007 0000864A 83C402                   add  sp, 2
  4008                                  
  4009                                  ;-4     printhex16(PCStart);
  4010                                  
  4011 0000864D FF36[A901]               push word [PCStart]
  4012 00008651 E8EE01                   call printhex16
  4013 00008654 83C402                   add  sp, 2
  4014                                  
  4015                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  4016                                  
  4017 00008657 A1[C601]                 mov ax, [OpPrintIndex]
  4018 0000865A 83F800                   cmp ax, 0
  4019 0000865D 0F850C00                 jne @@printLine184
  4020 00008661 68[D886]                 push printLine_1
  4021 00008664 E8E600                   call prs
  4022 00008667 83C402                   add  sp, 2
  4023                                  
  4024                                  ;-6     else {
  4025                                  
  4026 0000866A E94F00                   jmp @@printLine185
  4027                                  @@printLine184:
  4028                                  
  4029                                  ;-7 //        prc(' ');
  4030                                  
  4031                                  
  4032                                  ;-8         i=0;
  4033                                  
  4034 0000866D 66B800000000             mov eax, 0
  4035 00008673 8946FE                   mov word [bp-2], ax
  4036                                  
  4037                                  ;-9         do {
  4038                                  
  4039                                  @@printLine186:
  4040                                  
  4041                                  ;-10             c=OpPos[i];
  4042                                  
  4043 00008676 8B5EFE                   mov bx, [bp-2]
  4044 00008679 8A87[C101]               mov al, [OpPos + bx]
  4045 0000867D 8846FC                   mov byte [bp-4], al
  4046                                  
  4047                                  ;-11             prc(' ');
  4048                                  
  4049 00008680 6A20                     push 32
  4050 00008682 E86700                   call prc
  4051 00008685 83C402                   add  sp, 2
  4052                                  
  4053                                  ;-12             printhex8a(c); 
  4054                                  
  4055 00008688 8A46FC                   mov al, byte [bp-4]
  4056 0000868B B400                     mov ah, 0
  4057 0000868D 50                       push ax
  4058 0000868E E85F01                   call printhex8a
  4059 00008691 83C402                   add  sp, 2
  4060                                  
  4061                                  ;-13             i++;
  4062                                  
  4063 00008694 FF46FE                   inc  word [bp-2]
  4064                                  
  4065                                  ;-14         } while (i < OpPrintIndex);
  4066                                  
  4067 00008697 8B46FE                   mov ax, [bp-2]
  4068 0000869A 3B06[C601]               cmp ax, [OpPrintIndex]
  4069 0000869E 0F8D0200                 jge @@printLine187
  4070 000086A2 EBD2                     jmp @@printLine186
  4071                                  @@printLine187:
  4072                                  
  4073                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  4074                                  
  4075                                  @@printLine188:
  4076 000086A4 8B46FE                   mov ax, [bp-2]
  4077 000086A7 83F805                   cmp ax, 5
  4078 000086AA 0F8D0E00                 jge @@printLine189
  4079                                  
  4080                                  ;-16             prs("   ");
  4081                                  
  4082 000086AE 68[E886]                 push printLine_2
  4083 000086B1 E89900                   call prs
  4084 000086B4 83C402                   add  sp, 2
  4085                                  
  4086                                  ;-17             i++;
  4087                                  
  4088 000086B7 FF46FE                   inc  word [bp-2]
  4089                                  
  4090                                  ;-18         }
  4091                                  
  4092                                  
  4093                                  ;-19     }
  4094                                  
  4095 000086BA EBE8                     jmp @@printLine188
  4096                                  @@printLine189:
  4097                                  
  4098                                  ;-20     prc(PrintRA);
  4099                                  
  4100                                  @@printLine185:
  4101 000086BC A0[CA01]                 mov al, byte [PrintRA]
  4102 000086BF B400                     mov ah, 0
  4103 000086C1 50                       push ax
  4104 000086C2 E82700                   call prc
  4105 000086C5 83C402                   add  sp, 2
  4106                                  
  4107                                  ;-21     prscomment(InputBuf);
  4108                                  
  4109 000086C8 8D06[4E00]               lea  ax, [InputBuf]
  4110 000086CC 50                       push ax
  4111 000086CD E84F00                   call prscomment
  4112 000086D0 83C402                   add  sp, 2
  4113                                  
  4114                                  ;-22 }
  4115                                  
  4116                                  
  4117                                  ;-23 int prc(unsigned char c) {//print char 
  4118 000086D3 C9                       LEAVE
  4119 000086D4 C3                       ret
  4120                                  ; ENDP
  4121 000086D5 5C6E00                  printLine_0 db "\n",0
  4122 000086D8 202020202020202020-     printLine_1 db "               ",0
  4123 000086E1 20202020202000     
  4124 000086E8 20202000                printLine_2 db "   ",0
  4125                                  
  4126                                  prc:  ; *** PROC ***
  4127                                  
  4128                                  ;-24     if (LIST) { 
  4129                                  
  4130                                  ;Function : prc, Number of local variables: 1
  4131                                  ;   # type sign width line used address name   list of local variables
  4132                                  ;  200 var unsg byte    23 NULL bp+4    c;
  4133 000086EC C8000000                 ENTER  0,0
  4134 000086F0 A0[0D00]                 mov al, [LIST]
  4135 000086F3 08C0                     or  al, al
  4136 000086F5 0F841400                 je @@prc190
  4137                                  
  4138                                  ;-25         if ( _ c==10) {
  4139                                  
  4140 000086F9 807E040A                cmp byte [bp+4], 10
  4141 000086FD 0F850600                 jne @@prc191
  4142                                  
  4143                                  ;-26             ax=13; 
  4144                                  
  4145 00008701 B80D00                   mov  ax, 13
  4146                                  
  4147                                  ;-27             writetty(); 
  4148                                  
  4149 00008704 E88D12                   call writetty
  4150                                  
  4151                                  ;-28             }
  4152                                  
  4153                                  
  4154                                  ;-29         al=c; 
  4155                                  
  4156                                  @@prc191:
  4157 00008707 8A4604                   mov  al, [bp+4]
  4158                                  
  4159                                  ;-30         writetty(); 
  4160                                  
  4161 0000870A E88712                   call writetty
  4162                                  
  4163                                  ;-31         }
  4164                                  
  4165                                  
  4166                                  ;-32     fputcR(c,lst_fd); 
  4167                                  
  4168                                  @@prc190:
  4169 0000870D FF36[9A01]               push word [lst_fd]
  4170 00008711 8A4604                   mov al, byte [bp+4]
  4171 00008714 B400                     mov ah, 0
  4172 00008716 50                       push ax
  4173 00008717 E83A14                   call fputcR
  4174 0000871A 83C404                   add  sp, 4
  4175                                  
  4176                                  ;-33 }
  4177                                  
  4178                                  
  4179                                  ;-34 
  4180                                  
  4181                                  
  4182                                  ;-35 int prscomment(unsigned char *s) {
  4183 0000871D C9                       LEAVE
  4184 0000871E C3                       ret
  4185                                  ; ENDP
  4186                                  
  4187                                  prscomment:  ; *** PROC ***
  4188                                  
  4189                                  ;-36     unsigned char c;
  4190                                  
  4191                                  
  4192                                  ;-37     while (*s){
  4193                                  
  4194                                  ;Function : prscomment, Number of local variables: 2
  4195                                  ;   # type sign width line used address name   list of local variables
  4196                                  ;  200 ptr unsg byte    35 NULL bp+4    s
  4197                                  ;  201 var unsg byte    36 NULL bp-2    c;
  4198 0000871F C8020000                 ENTER  2,0
  4199                                  @@prscomment192:
  4200 00008723 8B5E04                   mov bx, [bp+4]
  4201 00008726 8A07                     mov al, [bx]
  4202 00008728 B400                     mov ah, 0
  4203 0000872A 08C0                     or  al, al
  4204 0000872C 0F841B00                 je @@prscomment193
  4205                                  
  4206                                  ;-38         c=*s;
  4207                                  
  4208 00008730 8B5E04                   mov bx, [bp+4]
  4209 00008733 8A07                     mov al, [bx]
  4210 00008735 B400                     mov ah, 0
  4211 00008737 8846FE                   mov byte [bp-2], al
  4212                                  
  4213                                  ;-39         prc(c);
  4214                                  
  4215 0000873A 8A46FE                   mov al, byte [bp-2]
  4216 0000873D B400                     mov ah, 0
  4217 0000873F 50                       push ax
  4218 00008740 E8A9FF                   call prc
  4219 00008743 83C402                   add  sp, 2
  4220                                  
  4221                                  ;-40         s++;
  4222                                  
  4223 00008746 FF4604                   inc  word [bp+4]
  4224                                  
  4225                                  ;-41     }
  4226                                  
  4227                                  
  4228                                  ;-42 }
  4229                                  
  4230 00008749 EBD8                     jmp @@prscomment192
  4231                                  @@prscomment193:
  4232                                  
  4233                                  ;-43 int prs(unsigned char *s) {
  4234 0000874B C9                       LEAVE
  4235 0000874C C3                       ret
  4236                                  ; ENDP
  4237                                  
  4238                                  prs:  ; *** PROC ***
  4239                                  
  4240                                  ;-44     unsigned char c; 
  4241                                  
  4242                                  
  4243                                  ;-45     int com; 
  4244                                  
  4245                                  
  4246                                  ;-46     com=0;
  4247                                  
  4248                                  ;Function : prs, Number of local variables: 3
  4249                                  ;   # type sign width line used address name   list of local variables
  4250                                  ;  200 ptr unsg byte    43 NULL bp+4    s
  4251                                  ;  201 var unsg byte    44 NULL bp-2    c
  4252                                  ;  202 var sign word    45 NULL bp-4    com;
  4253 0000874D C8040000                 ENTER  4,0
  4254 00008751 66B800000000             mov eax, 0
  4255 00008757 8946FC                   mov word [bp-4], ax
  4256                                  
  4257                                  ;-47     while (*s) { 
  4258                                  
  4259                                  @@prs194:
  4260 0000875A 8B5E04                   mov bx, [bp+4]
  4261 0000875D 8A07                     mov al, [bx]
  4262 0000875F B400                     mov ah, 0
  4263 00008761 08C0                     or  al, al
  4264 00008763 0F848700                 je @@prs195
  4265                                  
  4266                                  ;-48         c=*s; 
  4267                                  
  4268 00008767 8B5E04                   mov bx, [bp+4]
  4269 0000876A 8A07                     mov al, [bx]
  4270 0000876C B400                     mov ah, 0
  4271 0000876E 8846FE                   mov byte [bp-2], al
  4272                                  
  4273                                  ;-49         if (c==34) {
  4274                                  
  4275 00008771 8A46FE                   mov al, [bp-2]
  4276 00008774 3C22                     cmp al, 34
  4277 00008776 0F851E00                 jne @@prs196
  4278                                  
  4279                                  ;-50             if (com) com=0; 
  4280                                  
  4281 0000877A 8B46FC                   mov ax, [bp-4]
  4282 0000877D 08C0                     or  al, al
  4283 0000877F 0F840C00                 je @@prs197
  4284 00008783 66B800000000             mov eax, 0
  4285 00008789 8946FC                   mov word [bp-4], ax
  4286                                  
  4287                                  ;-51                 else com=1;  
  4288                                  
  4289 0000878C E90900                   jmp @@prs198
  4290                                  @@prs197:
  4291 0000878F 66B801000000             mov eax, 1
  4292 00008795 8946FC                   mov word [bp-4], ax
  4293                                  
  4294                                  ;-52         }
  4295                                  
  4296                                  @@prs198:
  4297                                  
  4298                                  ;-53         if (c==92) { 
  4299                                  
  4300                                  @@prs196:
  4301 00008798 8A46FE                   mov al, [bp-2]
  4302 0000879B 3C5C                     cmp al, 92
  4303 0000879D 0F853B00                 jne @@prs199
  4304                                  
  4305                                  ;-54             if (com==0) { 
  4306                                  
  4307 000087A1 8B46FC                   mov ax, [bp-4]
  4308 000087A4 83F800                   cmp ax, 0
  4309 000087A7 0F853100                 jne @@prs200
  4310                                  
  4311                                  ;-55                 s++; 
  4312                                  
  4313 000087AB FF4604                   inc  word [bp+4]
  4314                                  
  4315                                  ;-56                 c=*s;
  4316                                  
  4317 000087AE 8B5E04                   mov bx, [bp+4]
  4318 000087B1 8A07                     mov al, [bx]
  4319 000087B3 B400                     mov ah, 0
  4320 000087B5 8846FE                   mov byte [bp-2], al
  4321                                  
  4322                                  ;-57                 if (c=='n') c=10; 
  4323                                  
  4324 000087B8 8A46FE                   mov al, [bp-2]
  4325 000087BB 3C6E                     cmp al, 110
  4326 000087BD 0F850900                 jne @@prs201
  4327 000087C1 66B80A000000             mov eax, 10
  4328 000087C7 8846FE                   mov byte [bp-2], al
  4329                                  
  4330                                  ;-58                 if (c=='t') c= 9; 
  4331                                  
  4332                                  @@prs201:
  4333 000087CA 8A46FE                   mov al, [bp-2]
  4334 000087CD 3C74                     cmp al, 116
  4335 000087CF 0F850900                 jne @@prs202
  4336 000087D3 66B809000000             mov eax, 9
  4337 000087D9 8846FE                   mov byte [bp-2], al
  4338                                  
  4339                                  ;-59             } 
  4340                                  
  4341                                  @@prs202:
  4342                                  
  4343                                  ;-60         } 
  4344                                  
  4345                                  @@prs200:
  4346                                  
  4347                                  ;-61         prc(c); 
  4348                                  
  4349                                  @@prs199:
  4350 000087DC 8A46FE                   mov al, byte [bp-2]
  4351 000087DF B400                     mov ah, 0
  4352 000087E1 50                       push ax
  4353 000087E2 E807FF                   call prc
  4354 000087E5 83C402                   add  sp, 2
  4355                                  
  4356                                  ;-62         s++;  
  4357                                  
  4358 000087E8 FF4604                   inc  word [bp+4]
  4359                                  
  4360                                  ;-63     }
  4361                                  
  4362                                  
  4363                                  ;-64 }
  4364                                  
  4365 000087EB E96CFF                   jmp @@prs194
  4366                                  @@prs195:
  4367                                  
  4368                                  ;-65 int printhex8a(unsigned char c) { 
  4369 000087EE C9                       LEAVE
  4370 000087EF C3                       ret
  4371                                  ; ENDP
  4372                                  
  4373                                  printhex8a:  ; *** PROC ***
  4374                                  
  4375                                  ;-66     unsigned char nib;
  4376                                  
  4377                                  
  4378                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4379                                  
  4380                                  ;Function : printhex8a, Number of local variables: 2
  4381                                  ;   # type sign width line used address name   list of local variables
  4382                                  ;  200 var unsg byte    65 NULL bp+4    c
  4383                                  ;  201 var unsg byte    66 NULL bp-2    nib;
  4384 000087F0 C8020000                 ENTER  2,0
  4385 000087F4 8A4604                   mov al, [bp+4]
  4386 000087F7 C0E804                   shr al, 4
  4387 000087FA 8846FE                   mov byte [bp-2], al
  4388 000087FD 8A46FE                   mov al, byte [bp-2]
  4389 00008800 B400                     mov ah, 0
  4390 00008802 50                       push ax
  4391 00008803 E81900                   call printhex4
  4392 00008806 83C402                   add  sp, 2
  4393                                  
  4394                                  ;-68     nib = c & 15; printhex4(nib);                    
  4395                                  
  4396 00008809 8A4604                   mov al, [bp+4]
  4397 0000880C 240F                     and al, 15
  4398 0000880E 8846FE                   mov byte [bp-2], al
  4399 00008811 8A46FE                   mov al, byte [bp-2]
  4400 00008814 B400                     mov ah, 0
  4401 00008816 50                       push ax
  4402 00008817 E80500                   call printhex4
  4403 0000881A 83C402                   add  sp, 2
  4404                                  
  4405                                  ;-69 } 
  4406                                  
  4407                                  
  4408                                  ;-70 int printhex4(unsigned char c) {
  4409 0000881D C9                       LEAVE
  4410 0000881E C3                       ret
  4411                                  ; ENDP
  4412                                  
  4413                                  printhex4:  ; *** PROC ***
  4414                                  
  4415                                  ;-71     c += 48; 
  4416                                  
  4417                                  ;Function : printhex4, Number of local variables: 1
  4418                                  ;   # type sign width line used address name   list of local variables
  4419                                  ;  200 var unsg byte    70 NULL bp+4    c;
  4420 0000881F C8000000                 ENTER  0,0
  4421 00008823 80460430                 add  byte [bp+4], 48
  4422                                  
  4423                                  ;-72     if (c > 57) c += 7; 
  4424                                  
  4425 00008827 8A4604                   mov al, [bp+4]
  4426 0000882A 3C39                     cmp al, 57
  4427 0000882C 0F8E0400                 jle @@printhex4203
  4428 00008830 80460407                 add  byte [bp+4], 7
  4429                                  
  4430                                  ;-73     prc(c);      
  4431                                  
  4432                                  @@printhex4203:
  4433 00008834 8A4604                   mov al, byte [bp+4]
  4434 00008837 B400                     mov ah, 0
  4435 00008839 50                       push ax
  4436 0000883A E8AFFE                   call prc
  4437 0000883D 83C402                   add  sp, 2
  4438                                  
  4439                                  ;-74 }
  4440                                  
  4441                                  
  4442                                  ;-75 int printhex16(unsigned int i) {
  4443 00008840 C9                       LEAVE
  4444 00008841 C3                       ret
  4445                                  ; ENDP
  4446                                  
  4447                                  printhex16:  ; *** PROC ***
  4448                                  
  4449                                  ;-76     unsigned int half;
  4450                                  
  4451                                  
  4452                                  ;-77     half = i >>  8; printhex8a(half); 
  4453                                  
  4454                                  ;Function : printhex16, Number of local variables: 2
  4455                                  ;   # type sign width line used address name   list of local variables
  4456                                  ;  200 var unsg word    75 NULL bp+4    i
  4457                                  ;  201 var unsg word    76 NULL bp-2    half;
  4458 00008842 C8020000                 ENTER  2,0
  4459 00008846 8B4604                   mov ax, [bp+4]
  4460 00008849 C1E808                   shr ax, 8
  4461 0000884C 8946FE                   mov word [bp-2], ax
  4462 0000884F FF76FE                   push word [bp-2]
  4463 00008852 E89BFF                   call printhex8a
  4464 00008855 83C402                   add  sp, 2
  4465                                  
  4466                                  ;-78     half = i & 255; printhex8a(half);
  4467                                  
  4468 00008858 8B4604                   mov ax, [bp+4]
  4469 0000885B 25FF00                   and ax, 255
  4470 0000885E 8946FE                   mov word [bp-2], ax
  4471 00008861 FF76FE                   push word [bp-2]
  4472 00008864 E889FF                   call printhex8a
  4473 00008867 83C402                   add  sp, 2
  4474                                  
  4475                                  ;-79 }
  4476                                  
  4477                                  
  4478                                  ;-80 int printIntU(unsigned int n) { 
  4479 0000886A C9                       LEAVE
  4480 0000886B C3                       ret
  4481                                  ; ENDP
  4482                                  
  4483                                  printIntU:  ; *** PROC ***
  4484                                  
  4485                                  ;-81     unsigned int e;
  4486                                  
  4487                                  
  4488                                  ;-82     if ( _ n >= 10) {  
  4489                                  
  4490                                  ;Function : printIntU, Number of local variables: 2
  4491                                  ;   # type sign width line used address name   list of local variables
  4492                                  ;  200 var unsg word    80 NULL bp+4    n
  4493                                  ;  201 var unsg word    81 NULL bp-2    e;
  4494 0000886C C8020000                 ENTER  2,0
  4495 00008870 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4496 00008874 0F821700                 jb  @@printIntU204
  4497                                  
  4498                                  ;-83         e=n/10; //DIV
  4499                                  
  4500 00008878 8B4604                   mov ax, [bp+4]
  4501 0000887B BB0A00                   mov bx, 10
  4502 0000887E BA0000                   mov dx, 0
  4503 00008881 F7F3                     div bx
  4504 00008883 8946FE                   mov word [bp-2], ax
  4505                                  
  4506                                  ;-84         printIntU(e); 
  4507                                  
  4508 00008886 FF76FE                   push word [bp-2]
  4509 00008889 E8E0FF                   call printIntU
  4510 0000888C 83C402                   add  sp, 2
  4511                                  
  4512                                  ;-85     }
  4513                                  
  4514                                  
  4515                                  ;-86     n = n % 10; //unsigned mod
  4516                                  
  4517                                  @@printIntU204:
  4518 0000888F 8B4604                   mov ax, [bp+4]
  4519 00008892 BB0A00                   mov bx, 10
  4520 00008895 BA0000                   mov dx, 0
  4521 00008898 F7F3                     div bx
  4522 0000889A 89D0                     mov ax, dx
  4523 0000889C 894604                   mov word [bp+4], ax
  4524                                  
  4525                                  ;-87     n += '0'; 
  4526                                  
  4527 0000889F 83460430                 add  word [bp+4], 48
  4528                                  
  4529                                  ;-88     prc(n);
  4530                                  
  4531 000088A3 FF7604                   push word [bp+4]
  4532 000088A6 E843FE                   call prc
  4533 000088A9 83C402                   add  sp, 2
  4534                                  
  4535                                  ;-89 }
  4536                                  
  4537                                  
  4538                                  ;-90 
  4539                                  
  4540                                  
  4541                                  ;-91 int error1(char *s) { 
  4542 000088AC C9                       LEAVE
  4543 000088AD C3                       ret
  4544                                  ; ENDP
  4545                                  
  4546                                  error1:  ; *** PROC ***
  4547                                  
  4548                                  ;-92     LIST=1; 
  4549                                  
  4550                                  ;Function : error1, Number of local variables: 1
  4551                                  ;   # type sign width line used address name   list of local variables
  4552                                  ;  200 ptr sign byte    91 NULL bp+4    s;
  4553 000088AE C8000000                 ENTER  0,0
  4554 000088B2 66B801000000             mov eax, 1
  4555 000088B8 A2[0D00]                 mov byte [LIST], al
  4556                                  
  4557                                  ;-93     ErrorCount++;
  4558                                  
  4559 000088BB FF06[A001]               inc  word [ErrorCount]
  4560                                  
  4561                                  ;-94     prs("\n;***** next line ERROR: "); 
  4562                                  
  4563 000088BF 68[E788]                 push error1_0
  4564 000088C2 E888FE                   call prs
  4565 000088C5 83C402                   add  sp, 2
  4566                                  
  4567                                  ;-95     prs(s);
  4568                                  
  4569 000088C8 FF7604                   push word [bp+4]
  4570 000088CB E87FFE                   call prs
  4571 000088CE 83C402                   add  sp, 2
  4572                                  
  4573                                  ;-96     prs(", Symbol: "); 
  4574                                  
  4575 000088D1 68[0289]                 push error1_1
  4576 000088D4 E876FE                   call prs
  4577 000088D7 83C402                   add  sp, 2
  4578                                  
  4579                                  ;-97     prs(Symbol);
  4580                                  
  4581 000088DA 8D06[0E00]               lea  ax, [Symbol]
  4582 000088DE 50                       push ax
  4583 000088DF E86BFE                   call prs
  4584 000088E2 83C402                   add  sp, 2
  4585                                  
  4586                                  ;-98 }
  4587                                  
  4588                                  
  4589                                  ;-99 int errorexit(char *s) { 
  4590 000088E5 C9                       LEAVE
  4591 000088E6 C3                       ret
  4592                                  ; ENDP
  4593 000088E7 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4594 000088F0 6E657874206C696E65-
  4595 000088F9 204552524F523A2000 
  4596 00008902 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4597 0000890B 2000               
  4598                                  
  4599                                  errorexit:  ; *** PROC ***
  4600                                  
  4601                                  ;-100     error1(s); 
  4602                                  
  4603                                  ;Function : errorexit, Number of local variables: 1
  4604                                  ;   # type sign width line used address name   list of local variables
  4605                                  ;  200 ptr sign byte    99 NULL bp+4    s;
  4606 0000890D C8000000                 ENTER  0,0
  4607 00008911 FF7604                   push word [bp+4]
  4608 00008914 E897FF                   call error1
  4609 00008917 83C402                   add  sp, 2
  4610                                  
  4611                                  ;-101     end1(1);
  4612                                  
  4613 0000891A 6A01                     push 1
  4614 0000891C E81406                   call end1
  4615 0000891F 83C402                   add  sp, 2
  4616                                  
  4617                                  ;-102 }
  4618                                  
  4619                                  
  4620                                  ;-103 int allowederror() {error1("not allowed here"); }
  4621 00008922 C9                       LEAVE
  4622 00008923 C3                       ret
  4623                                  ; ENDP
  4624                                  
  4625                                  allowederror:  ; *** PROC ***
  4626 00008924 68[2E89]                 push allowederror_0
  4627 00008927 E884FF                   call error1
  4628 0000892A 83C402                   add  sp, 2
  4629                                  
  4630                                  ;-104 int addrerror()    {error1("address missing");} 
  4631                                  
  4632 0000892D C3                       ret
  4633                                  ; ENDP
  4634 0000892E 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4635 00008937 6564206865726500   
  4636                                  
  4637                                  addrerror:  ; *** PROC ***
  4638 0000893F 68[4989]                 push addrerror_0
  4639 00008942 E869FF                   call error1
  4640 00008945 83C402                   add  sp, 2
  4641                                  
  4642                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4643                                  
  4644 00008948 C3                       ret
  4645                                  ; ENDP
  4646 00008949 61646472657373206D-     addrerror_0 db "address missing",0
  4647 00008952 697373696E6700     
  4648                                  
  4649                                  immeerror:  ; *** PROC ***
  4650 00008959 68[6389]                 push immeerror_0
  4651 0000895C E84FFF                   call error1
  4652 0000895F 83C402                   add  sp, 2
  4653                                  
  4654                                  ;-106 int implerror()    {error1("not implemented");}
  4655                                  
  4656 00008962 C3                       ret
  4657                                  ; ENDP
  4658 00008963 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4659 0000896C 206E6F7420616C6C6F-
  4660 00008975 776564206865726500 
  4661                                  
  4662                                  implerror:  ; *** PROC ***
  4663 0000897E 68[8889]                 push implerror_0
  4664 00008981 E82AFF                   call error1
  4665 00008984 83C402                   add  sp, 2
  4666                                  
  4667                                  ;-107 int indexerror()   {error1("invalid index register");}
  4668                                  
  4669 00008987 C3                       ret
  4670                                  ; ENDP
  4671 00008988 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4672 00008991 6D656E74656400     
  4673                                  
  4674                                  indexerror:  ; *** PROC ***
  4675 00008998 68[A289]                 push indexerror_0
  4676 0000899B E810FF                   call error1
  4677 0000899E 83C402                   add  sp, 2
  4678                                  
  4679                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4680                                  
  4681 000089A1 C3                       ret
  4682                                  ; ENDP
  4683 000089A2 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4684 000089AB 6E6465782072656769-
  4685 000089B4 7374657200         
  4686                                  
  4687                                  invaloperror:  ; *** PROC ***
  4688 000089B9 68[C389]                 push invaloperror_0
  4689 000089BC E8EFFE                   call error1
  4690 000089BF 83C402                   add  sp, 2
  4691                                  
  4692                                  ;-109 int numbererror()  {error1("number expected");}
  4693                                  
  4694 000089C2 C3                       ret
  4695                                  ; ENDP
  4696 000089C3 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4697 000089CC 72206E6F206F706572-
  4698 000089D5 616E647300         
  4699                                  
  4700                                  numbererror:  ; *** PROC ***
  4701 000089DA 68[E489]                 push numbererror_0
  4702 000089DD E8CEFE                   call error1
  4703 000089E0 83C402                   add  sp, 2
  4704                                  
  4705                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4706                                  
  4707 000089E3 C3                       ret
  4708                                  ; ENDP
  4709 000089E4 6E756D626572206578-     numbererror_0 db "number expected",0
  4710 000089ED 70656374656400     
  4711                                  
  4712                                  regmemerror:  ; *** PROC ***
  4713 000089F4 68[FE89]                 push regmemerror_0
  4714 000089F7 E8B4FE                   call error1
  4715 000089FA 83C402                   add  sp, 2
  4716                                  
  4717                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4718                                  
  4719 000089FD C3                       ret
  4720                                  ; ENDP
  4721 000089FE 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4722 00008A07 73746572206F72206D-
  4723 00008A10 656D6F727920616C6C-
  4724 00008A19 6F77656400         
  4725                                  
  4726                                  reg16error:  ; *** PROC ***
  4727 00008A1E 68[288A]                 push reg16error_0
  4728 00008A21 E88AFE                   call error1
  4729 00008A24 83C402                   add  sp, 2
  4730                                  
  4731                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4732                                  
  4733 00008A27 C3                       ret
  4734                                  ; ENDP
  4735 00008A28 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4736 00008A31 362C206E6F20736567-
  4737 00008A3A 72656720616C6C6F77-
  4738 00008A43 656400             
  4739                                  
  4740                                  segregerror:  ; *** PROC ***
  4741 00008A46 68[508A]                 push segregerror_0
  4742 00008A49 E862FE                   call error1
  4743 00008A4C 83C402                   add  sp, 2
  4744                                  
  4745                                  ;-113 int syntaxerror()  {error1("syntax");}
  4746                                  
  4747 00008A4F C3                       ret
  4748                                  ; ENDP
  4749 00008A50 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4750 00008A59 65676973746572206E-
  4751 00008A62 6F7420616C6C6F7765-
  4752 00008A6B 6400               
  4753                                  
  4754                                  syntaxerror:  ; *** PROC ***
  4755 00008A6D 68[778A]                 push syntaxerror_0
  4756 00008A70 E83BFE                   call error1
  4757 00008A73 83C402                   add  sp, 2
  4758                                  
  4759                                  ;-114          
  4760                                  
  4761                                  
  4762                                  ;-115 int addrexit()     {errorexit("illegal address");}   
  4763                                  
  4764 00008A76 C3                       ret
  4765                                  ; ENDP
  4766 00008A77 73796E74617800          syntaxerror_0 db "syntax",0
  4767                                  
  4768                                  addrexit:  ; *** PROC ***
  4769 00008A7E 68[888A]                 push addrexit_0
  4770 00008A81 E889FE                   call errorexit
  4771 00008A84 83C402                   add  sp, 2
  4772                                  
  4773                                  ;-116 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  4774                                  
  4775 00008A87 C3                       ret
  4776                                  ; ENDP
  4777 00008A88 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4778 00008A91 64647265737300     
  4779                                  
  4780                                  dataexit:  ; *** PROC ***
  4781 00008A98 68[A28A]                 push dataexit_0
  4782 00008A9B E86FFE                   call errorexit
  4783 00008A9E 83C402                   add  sp, 2
  4784                                  
  4785                                  ;-117 int internexit()   {errorexit("intern compiler error");}
  4786                                  
  4787 00008AA1 C3                       ret
  4788                                  ; ENDP
  4789 00008AA2 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  4790 00008AAB 6F7220524553422C57-
  4791 00008AB4 2C4420657870656374-
  4792 00008ABD 656400             
  4793                                  
  4794                                  internexit:  ; *** PROC ***
  4795 00008AC0 68[CA8A]                 push internexit_0
  4796 00008AC3 E847FE                   call errorexit
  4797 00008AC6 83C402                   add  sp, 2
  4798 00008AC9 C3                       ret
  4799                                  ; ENDP
  4800 00008ACA 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4801 00008AD3 6D70696C6572206572-
  4802 00008ADC 726F7200           
  4803                                  ;Back to main program: AS.C
  4804                                  
  4805                                  ;-8 #include "MAIN.C"
  4806                                  
  4807                                  ;Use include file: MAIN.C
  4808                                  
  4809                                  ;-1 int main() {
  4810                                  
  4811                                  
  4812                                  main:  ; *** PROC ***
  4813                                  
  4814                                  ;-2     getarg(); 
  4815                                  
  4816 00008AE0 E80D00                   call getarg
  4817                                  
  4818                                  ;-3     parse(); 
  4819                                  
  4820 00008AE3 E8E7ED                   call parse
  4821                                  
  4822                                  ;-4     fixJmpCall();
  4823                                  
  4824 00008AE6 E85F02                   call fixJmpCall
  4825                                  
  4826                                  ;-5     epilog(); 
  4827                                  
  4828 00008AE9 E84B03                   call epilog
  4829                                  
  4830                                  ;-6     end1();
  4831                                  
  4832 00008AEC E84404                   call end1
  4833                                  
  4834                                  ;-7 }
  4835                                  
  4836                                  
  4837                                  ;-8 
  4838                                  
  4839                                  
  4840                                  ;-9 int getarg() { 
  4841                                  
  4842 00008AEF C3                       ret
  4843                                  ; ENDP
  4844                                  
  4845                                  getarg:  ; *** PROC ***
  4846                                  
  4847                                  ;-10     int arglen1; int i; char *c;
  4848                                  
  4849                                  
  4850                                  ;-11     arglen1=*arglen;
  4851                                  
  4852                                  ;Function : getarg, Number of local variables: 3
  4853                                  ;   # type sign width line used address name   list of local variables
  4854                                  ;  200 var sign word    10 NULL bp-2    arglen1
  4855                                  ;  201 var sign word    10 NULL bp-4    i
  4856                                  ;  202 ptr sign byte    10 NULL bp-6    c;
  4857 00008AF0 C8060000                 ENTER  6,0
  4858 00008AF4 8B1E[FF6F]               mov bx, [arglen]
  4859 00008AF8 8A07                     mov al, [bx]
  4860 00008AFA B400                     mov ah, 0
  4861 00008AFC 8946FE                   mov word [bp-2], ax
  4862                                  
  4863                                  ;-12     if (arglen1==0) {
  4864                                  
  4865 00008AFF 8B46FE                   mov ax, [bp-2]
  4866 00008B02 83F800                   cmp ax, 0
  4867 00008B05 0F851C00                 jne @@getarg205
  4868                                  
  4869                                  ;-13         cputs(Version1);
  4870                                  
  4871 00008B09 8D06[0300]               lea  ax, [Version1]
  4872 00008B0D 50                       push ax
  4873 00008B0E E88B0E                   call cputs
  4874 00008B11 83C402                   add  sp, 2
  4875                                  
  4876                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4877                                  
  4878 00008B14 68[B58C]                 push getarg_0
  4879 00008B17 E8820E                   call cputs
  4880 00008B1A 83C402                   add  sp, 2
  4881                                  
  4882                                  ;-15         exitR(3);
  4883                                  
  4884 00008B1D 6A03                     push 3
  4885 00008B1F E85510                   call exitR
  4886 00008B22 83C402                   add  sp, 2
  4887                                  
  4888                                  ;-16     }
  4889                                  
  4890                                  
  4891                                  ;-17     i=arglen1+129; 
  4892                                  
  4893                                  @@getarg205:
  4894 00008B25 8B46FE                   mov ax, [bp-2]
  4895 00008B28 058100                   add ax, 129
  4896 00008B2B 8946FC                   mov word [bp-4], ax
  4897                                  
  4898                                  ;-18     *i=0;  
  4899                                  
  4900 00008B2E 66B800000000             mov eax, 0
  4901 00008B34 8B5EFC                   mov  bx, [bp-4]
  4902 00008B37 8907                     mov  [bx], ax
  4903                                  
  4904                                  ;-19     arglen1--;
  4905                                  
  4906 00008B39 FF4EFE                   dec  word [bp-2]
  4907                                  
  4908                                  ;-20     toupper(argv);
  4909                                  
  4910 00008B3C FF36[0170]               push word [argv]
  4911 00008B40 E8870E                   call toupper
  4912 00008B43 83C402                   add  sp, 2
  4913                                  
  4914                                  ;-21   
  4915                                  
  4916                                  
  4917                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  4918                                  
  4919 00008B46 FF36[0170]               push word [argv]
  4920 00008B4A 8D06[CF00]               lea  ax, [namein]
  4921 00008B4E 50                       push ax
  4922 00008B4F E8E60E                   call strcpy
  4923 00008B52 83C404                   add  sp, 4
  4924 00008B55 68[DA8C]                 push getarg_1
  4925 00008B58 8D06[CF00]               lea  ax, [namein]
  4926 00008B5C 50                       push ax
  4927 00008B5D E8990F                   call strcat1
  4928 00008B60 83C404                   add  sp, 4
  4929                                  
  4930                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  4931                                  
  4932 00008B63 FF36[0170]               push word [argv]
  4933 00008B67 8D06[1201]               lea  ax, [namelst]
  4934 00008B6B 50                       push ax
  4935 00008B6C E8C90E                   call strcpy
  4936 00008B6F 83C404                   add  sp, 4
  4937 00008B72 68[DD8C]                 push getarg_2
  4938 00008B75 8D06[1201]               lea  ax, [namelst]
  4939 00008B79 50                       push ax
  4940 00008B7A E87C0F                   call strcat1
  4941 00008B7D 83C404                   add  sp, 4
  4942                                  
  4943                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  4944                                  
  4945 00008B80 FF36[0170]               push word [argv]
  4946 00008B84 8D06[5501]               lea  ax, [namebin]
  4947 00008B88 50                       push ax
  4948 00008B89 E8AC0E                   call strcpy
  4949 00008B8C 83C404                   add  sp, 4
  4950 00008B8F 68[E28C]                 push getarg_3
  4951 00008B92 8D06[5501]               lea  ax, [namebin]
  4952 00008B96 50                       push ax
  4953 00008B97 E85F0F                   call strcat1
  4954 00008B9A 83C404                   add  sp, 4
  4955                                  
  4956                                  ;-25 
  4957                                  
  4958                                  
  4959                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4960                                  
  4961 00008B9D 66B801000000             mov eax, 1
  4962 00008BA3 A2[0D00]                 mov byte [LIST], al
  4963 00008BA6 66B800000000             mov eax, 0
  4964 00008BAC A3[9E01]                 mov word [DOS_ERR], ax
  4965 00008BAF 66B800000000             mov eax, 0
  4966 00008BB5 A3[A501]                 mov word [PC], ax
  4967 00008BB8 66B800000000             mov eax, 0
  4968 00008BBE A3[A001]                 mov word [ErrorCount], ax
  4969                                  
  4970                                  ;-27   
  4971                                  
  4972                                  
  4973                                  ;-28     asm_fd=openR (namein);
  4974                                  
  4975 00008BC1 8D06[CF00]               lea  ax, [namein]
  4976 00008BC5 50                       push ax
  4977 00008BC6 E8550F                   call openR
  4978 00008BC9 83C402                   add  sp, 2
  4979 00008BCC A3[9801]                 mov word [asm_fd], ax
  4980                                  
  4981                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4982                                  
  4983 00008BCF A1[9E01]                 mov ax, [DOS_ERR]
  4984 00008BD2 08C0                     or  al, al
  4985 00008BD4 0F841C00                 je @@getarg206
  4986 00008BD8 68[E78C]                 push getarg_4
  4987 00008BDB E8BE0D                   call cputs
  4988 00008BDE 83C402                   add  sp, 2
  4989 00008BE1 8D06[CF00]               lea  ax, [namein]
  4990 00008BE5 50                       push ax
  4991 00008BE6 E8B30D                   call cputs
  4992 00008BE9 83C402                   add  sp, 2
  4993 00008BEC 6A01                     push 1
  4994 00008BEE E8860F                   call exitR
  4995 00008BF1 83C402                   add  sp, 2
  4996                                  
  4997                                  ;-30     lst_fd=creatR(namelst);
  4998                                  
  4999                                  @@getarg206:
  5000 00008BF4 8D06[1201]               lea  ax, [namelst]
  5001 00008BF8 50                       push ax
  5002 00008BF9 E8310F                   call creatR
  5003 00008BFC 83C402                   add  sp, 2
  5004 00008BFF A3[9A01]                 mov word [lst_fd], ax
  5005                                  
  5006                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5007                                  
  5008 00008C02 A1[9E01]                 mov ax, [DOS_ERR]
  5009 00008C05 08C0                     or  al, al
  5010 00008C07 0F841C00                 je @@getarg207
  5011 00008C0B 68[FD8C]                 push getarg_5
  5012 00008C0E E88B0D                   call cputs
  5013 00008C11 83C402                   add  sp, 2
  5014 00008C14 8D06[1201]               lea  ax, [namelst]
  5015 00008C18 50                       push ax
  5016 00008C19 E8800D                   call cputs
  5017 00008C1C 83C402                   add  sp, 2
  5018 00008C1F 6A02                     push 2
  5019 00008C21 E8530F                   call exitR
  5020 00008C24 83C402                   add  sp, 2
  5021                                  
  5022                                  ;-32     bin_fd=creatR(namebin);
  5023                                  
  5024                                  @@getarg207:
  5025 00008C27 8D06[5501]               lea  ax, [namebin]
  5026 00008C2B 50                       push ax
  5027 00008C2C E8FE0E                   call creatR
  5028 00008C2F 83C402                   add  sp, 2
  5029 00008C32 A3[9C01]                 mov word [bin_fd], ax
  5030                                  
  5031                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5032                                  
  5033 00008C35 A1[9E01]                 mov ax, [DOS_ERR]
  5034 00008C38 08C0                     or  al, al
  5035 00008C3A 0F841C00                 je @@getarg208
  5036 00008C3E 68[148D]                 push getarg_6
  5037 00008C41 E8580D                   call cputs
  5038 00008C44 83C402                   add  sp, 2
  5039 00008C47 8D06[5501]               lea  ax, [namebin]
  5040 00008C4B 50                       push ax
  5041 00008C4C E84D0D                   call cputs
  5042 00008C4F 83C402                   add  sp, 2
  5043 00008C52 6A02                     push 2
  5044 00008C54 E8200F                   call exitR
  5045 00008C57 83C402                   add  sp, 2
  5046                                  
  5047                                  ;-34   
  5048                                  
  5049                                  
  5050                                  ;-35     prs(";"); 
  5051                                  
  5052                                  @@getarg208:
  5053 00008C5A 68[2A8D]                 push getarg_7
  5054 00008C5D E8EDFA                   call prs
  5055 00008C60 83C402                   add  sp, 2
  5056                                  
  5057                                  ;-36     prs(Version1);
  5058                                  
  5059 00008C63 8D06[0300]               lea  ax, [Version1]
  5060 00008C67 50                       push ax
  5061 00008C68 E8E2FA                   call prs
  5062 00008C6B 83C402                   add  sp, 2
  5063                                  
  5064                                  ;-37     prs(", Source: "); prs(namein);  
  5065                                  
  5066 00008C6E 68[2C8D]                 push getarg_8
  5067 00008C71 E8D9FA                   call prs
  5068 00008C74 83C402                   add  sp, 2
  5069 00008C77 8D06[CF00]               lea  ax, [namein]
  5070 00008C7B 50                       push ax
  5071 00008C7C E8CEFA                   call prs
  5072 00008C7F 83C402                   add  sp, 2
  5073                                  
  5074                                  ;-38     prs(", Output: "); prs(namelst);
  5075                                  
  5076 00008C82 68[378D]                 push getarg_9
  5077 00008C85 E8C5FA                   call prs
  5078 00008C88 83C402                   add  sp, 2
  5079 00008C8B 8D06[1201]               lea  ax, [namelst]
  5080 00008C8F 50                       push ax
  5081 00008C90 E8BAFA                   call prs
  5082 00008C93 83C402                   add  sp, 2
  5083                                  
  5084                                  ;-39     prs(", "); prs(namebin);
  5085                                  
  5086 00008C96 68[428D]                 push getarg_10
  5087 00008C99 E8B1FA                   call prs
  5088 00008C9C 83C402                   add  sp, 2
  5089 00008C9F 8D06[5501]               lea  ax, [namebin]
  5090 00008CA3 50                       push ax
  5091 00008CA4 E8A6FA                   call prs
  5092 00008CA7 83C402                   add  sp, 2
  5093                                  
  5094                                  ;-40     prs("\n");
  5095                                  
  5096 00008CAA 68[458D]                 push getarg_11
  5097 00008CAD E89DFA                   call prs
  5098 00008CB0 83C402                   add  sp, 2
  5099                                  
  5100                                  ;-41 }
  5101                                  
  5102                                  
  5103                                  ;-42 
  5104                                  
  5105                                  
  5106                                  ;-43 int fixJmpCall() {
  5107 00008CB3 C9                       LEAVE
  5108 00008CB4 C3                       ret
  5109                                  ; ENDP
  5110 00008CB5 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5111 00008CBE 41532E434F4D206669-
  5112 00008CC7 6C656E616D65205B77-
  5113 00008CD0 2F6F202E535D203A20-
  5114 00008CD9 00                 
  5115 00008CDA 2E5300                  getarg_1 db ".S",0
  5116 00008CDD 2E4C535400              getarg_2 db ".LST",0
  5117 00008CE2 2E434F4D00              getarg_3 db ".COM",0
  5118 00008CE7 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5119 00008CF0 6C65206D697373696E-
  5120 00008CF9 673A2000           
  5121 00008CFD 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5122 00008D06 206E6F742063726561-
  5123 00008D0F 74653A2000         
  5124 00008D14 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5125 00008D1D 6E6F74206372656174-
  5126 00008D26 653A2000           
  5127 00008D2A 3B00                    getarg_7 db ";",0
  5128 00008D2C 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5129 00008D35 2000               
  5130 00008D37 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5131 00008D40 2000               
  5132 00008D42 2C2000                  getarg_10 db ", ",0
  5133 00008D45 5C6E00                  getarg_11 db "\n",0
  5134                                  
  5135                                  fixJmpCall:  ; *** PROC ***
  5136                                  
  5137                                  ;-44     int i;  unsigned int hex;  char *p; int Ix; char c;
  5138                                  
  5139                                  
  5140                                  ;-45     i=1;     
  5141                                  
  5142                                  ;Function : fixJmpCall, Number of local variables: 5
  5143                                  ;   # type sign width line used address name   list of local variables
  5144                                  ;  200 var sign word    44 NULL bp-2    i
  5145                                  ;  201 var unsg word    44 NULL bp-4    hex
  5146                                  ;  202 ptr sign byte    44 NULL bp-6    p
  5147                                  ;  203 var sign word    44 NULL bp-8    Ix
  5148                                  ;  204 var sign byte    44 NULL bp-10    c;
  5149 00008D48 C80A0000                 ENTER  10,0
  5150 00008D4C 66B801000000             mov eax, 1
  5151 00008D52 8946FE                   mov word [bp-2], ax
  5152                                  
  5153                                  ;-46     prs("\n;END open jmp/call: "); 
  5154                                  
  5155 00008D55 68[108E]                 push fixJmpCall_0
  5156 00008D58 E8F2F9                   call prs
  5157 00008D5B 83C402                   add  sp, 2
  5158                                  
  5159                                  ;-47     printIntU(JmpCallMaxIx);      
  5160                                  
  5161 00008D5E FF36[DB21]               push word [JmpCallMaxIx]
  5162 00008D62 E807FB                   call printIntU
  5163 00008D65 83C402                   add  sp, 2
  5164                                  
  5165                                  ;-48     p = &JmpCallNames;   
  5166                                  
  5167 00008D68 B8[2116]                 mov ax, JmpCallNames
  5168 00008D6B 8946FA                   mov word [bp-6], ax
  5169                                  
  5170                                  ;-49     while (i <= JmpCallMaxIx) {
  5171                                  
  5172                                  @@fixJmpCall209:
  5173 00008D6E 8B46FE                   mov ax, [bp-2]
  5174 00008D71 3B06[DB21]               cmp ax, [JmpCallMaxIx]
  5175 00008D75 0F8F9500                 jg  @@fixJmpCall210
  5176                                  
  5177                                  ;-50         strcpy(Symbol, p);
  5178                                  
  5179 00008D79 FF76FA                   push word [bp-6]
  5180 00008D7C 8D06[0E00]               lea  ax, [Symbol]
  5181 00008D80 50                       push ax
  5182 00008D81 E8B40C                   call strcpy
  5183 00008D84 83C404                   add  sp, 4
  5184                                  
  5185                                  ;-51         p = strlen(Symbol) + p;
  5186                                  
  5187 00008D87 8D06[0E00]               lea  ax, [Symbol]
  5188 00008D8B 50                       push ax
  5189 00008D8C E87E0C                   call strlen
  5190 00008D8F 83C402                   add  sp, 2
  5191 00008D92 0346FA                   add ax, [bp-6]
  5192 00008D95 8946FA                   mov word [bp-6], ax
  5193                                  
  5194                                  ;-52         p++;
  5195                                  
  5196 00008D98 FF46FA                   inc  word [bp-6]
  5197                                  
  5198                                  ;-53 //        prs(Symbol);
  5199                                  
  5200                                  
  5201                                  ;-54 //        prc(' ');  
  5202                                  
  5203                                  
  5204                                  ;-55         hex = JmpCallAddr[i];
  5205                                  
  5206 00008D9B 8B5EFE                   mov bx, [bp-2]
  5207 00008D9E D1E3                     shl bx, 1
  5208 00008DA0 8B87[F31D]               mov ax, [JmpCallAddr + bx]
  5209 00008DA4 8946FC                   mov word [bp-4], ax
  5210                                  
  5211                                  ;-56 //        printhex16(hex);
  5212                                  
  5213                                  
  5214                                  ;-57             
  5215                                  
  5216                                  
  5217                                  ;-58         Ix=searchLabel();
  5218                                  
  5219 00008DA7 E8F6ED                   call searchLabel
  5220 00008DAA 8946F8                   mov word [bp-8], ax
  5221                                  
  5222                                  ;-59         if (Ix == 0) error1("Label not found");
  5223                                  
  5224 00008DAD 8B46F8                   mov ax, [bp-8]
  5225 00008DB0 83F800                   cmp ax, 0
  5226 00008DB3 0F850900                 jne @@fixJmpCall211
  5227 00008DB7 68[278E]                 push fixJmpCall_1
  5228 00008DBA E8F1FA                   call error1
  5229 00008DBD 83C402                   add  sp, 2
  5230                                  
  5231                                  ;-60         disp = LabelAddr[Ix];
  5232                                  
  5233                                  @@fixJmpCall211:
  5234 00008DC0 8B5EF8                   mov bx, [bp-8]
  5235 00008DC3 D1E3                     shl bx, 1
  5236 00008DC5 8B87[6D11]               mov ax, [LabelAddr + bx]
  5237 00008DC9 A3[BD01]                 mov word [disp], ax
  5238                                  
  5239                                  ;-61         disp = disp - hex;
  5240                                  
  5241 00008DCC A1[BD01]                 mov ax, [disp]
  5242 00008DCF 2B46FC                   sub ax, [bp-4]
  5243 00008DD2 A3[BD01]                 mov word [disp], ax
  5244                                  
  5245                                  ;-62         disp = disp - Origin;
  5246                                  
  5247 00008DD5 A1[BD01]                 mov ax, [disp]
  5248 00008DD8 2B06[A701]               sub ax, [Origin]
  5249 00008DDC A3[BD01]                 mov word [disp], ax
  5250                                  
  5251                                  ;-63 //        prs(", ");    
  5252                                  
  5253                                  
  5254                                  ;-64         
  5255                                  
  5256                                  
  5257                                  ;-65             hex = hex - 2;//fix at start of word              
  5258                                  
  5259 00008DDF 8B46FC                   mov ax, [bp-4]
  5260 00008DE2 83E802                   sub ax, 2
  5261 00008DE5 8946FC                   mov word [bp-4], ax
  5262                                  
  5263                                  ;-66             FileBin[hex] = disp;//fix low byte    
  5264                                  
  5265 00008DE8 A1[BD01]                 mov ax, [disp]
  5266 00008DEB 8B5EFC                   mov bx, [bp-4]
  5267 00008DEE 8887[DD21]               mov [FileBin+bx], al
  5268                                  
  5269                                  ;-67             hex++;
  5270                                  
  5271 00008DF2 FF46FC                   inc  word [bp-4]
  5272                                  
  5273                                  ;-68             disp = disp >> 8;
  5274                                  
  5275 00008DF5 A1[BD01]                 mov ax, [disp]
  5276 00008DF8 C1E808                   shr ax, 8
  5277 00008DFB A3[BD01]                 mov word [disp], ax
  5278                                  
  5279                                  ;-69             FileBin[hex] = disp;            
  5280                                  
  5281 00008DFE A1[BD01]                 mov ax, [disp]
  5282 00008E01 8B5EFC                   mov bx, [bp-4]
  5283 00008E04 8887[DD21]               mov [FileBin+bx], al
  5284                                  
  5285                                  ;-70         i++;
  5286                                  
  5287 00008E08 FF46FE                   inc  word [bp-2]
  5288                                  
  5289                                  ;-71     }
  5290                                  
  5291                                  
  5292                                  ;-72 }
  5293                                  
  5294 00008E0B E960FF                   jmp @@fixJmpCall209
  5295                                  @@fixJmpCall210:
  5296                                  
  5297                                  ;-73 
  5298                                  
  5299                                  
  5300                                  ;-74 int epilog() { 
  5301 00008E0E C9                       LEAVE
  5302 00008E0F C3                       ret
  5303                                  ; ENDP
  5304 00008E10 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5305 00008E19 656E206A6D702F6361-
  5306 00008E22 6C6C3A2000         
  5307 00008E27 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5308 00008E30 20666F756E6400     
  5309                                  
  5310                                  epilog:  ; *** PROC ***
  5311                                  
  5312                                  ;-75     unsigned int i; char c;     int j;
  5313                                  
  5314                                  
  5315                                  ;-76     prs("\n Errors: "); 
  5316                                  
  5317                                  ;Function : epilog, Number of local variables: 3
  5318                                  ;   # type sign width line used address name   list of local variables
  5319                                  ;  200 var unsg word    75 NULL bp-2    i
  5320                                  ;  201 var sign byte    75 NULL bp-4    c
  5321                                  ;  202 var sign word    75 NULL bp-6    j;
  5322 00008E37 C8060000                 ENTER  6,0
  5323 00008E3B 68[F58E]                 push epilog_0
  5324 00008E3E E80CF9                   call prs
  5325 00008E41 83C402                   add  sp, 2
  5326                                  
  5327                                  ;-77     printIntU(ErrorCount);
  5328                                  
  5329 00008E44 FF36[A001]               push word [ErrorCount]
  5330 00008E48 E821FA                   call printIntU
  5331 00008E4B 83C402                   add  sp, 2
  5332                                  
  5333                                  ;-78     if (ErrorCount) prs(" ***ERROR*** ");
  5334                                  
  5335 00008E4E A1[A001]                 mov ax, [ErrorCount]
  5336 00008E51 08C0                     or  al, al
  5337 00008E53 0F840900                 je @@epilog212
  5338 00008E57 68[018F]                 push epilog_1
  5339 00008E5A E8F0F8                   call prs
  5340 00008E5D 83C402                   add  sp, 2
  5341                                  
  5342                                  ;-79     prs(", Out: "); 
  5343                                  
  5344                                  @@epilog212:
  5345 00008E60 68[0F8F]                 push epilog_2
  5346 00008E63 E8E7F8                   call prs
  5347 00008E66 83C402                   add  sp, 2
  5348                                  
  5349                                  ;-80     prs(namelst);
  5350                                  
  5351 00008E69 8D06[1201]               lea  ax, [namelst]
  5352 00008E6D 50                       push ax
  5353 00008E6E E8DCF8                   call prs
  5354 00008E71 83C402                   add  sp, 2
  5355                                  
  5356                                  ;-81     prs(", ");
  5357                                  
  5358 00008E74 68[178F]                 push epilog_3
  5359 00008E77 E8D3F8                   call prs
  5360 00008E7A 83C402                   add  sp, 2
  5361                                  
  5362                                  ;-82     prs(namebin); 
  5363                                  
  5364 00008E7D 8D06[5501]               lea  ax, [namebin]
  5365 00008E81 50                       push ax
  5366 00008E82 E8C8F8                   call prs
  5367 00008E85 83C402                   add  sp, 2
  5368                                  
  5369                                  ;-83     prs("= ");
  5370                                  
  5371 00008E88 68[1A8F]                 push epilog_4
  5372 00008E8B E8BFF8                   call prs
  5373 00008E8E 83C402                   add  sp, 2
  5374                                  
  5375                                  ;-84     printIntU(BinLen); 
  5376                                  
  5377 00008E91 FF36[FD6F]               push word [BinLen]
  5378 00008E95 E8D4F9                   call printIntU
  5379 00008E98 83C402                   add  sp, 2
  5380                                  
  5381                                  ;-85     prs(" bytes.");
  5382                                  
  5383 00008E9B 68[1D8F]                 push epilog_5
  5384 00008E9E E8ACF8                   call prs
  5385 00008EA1 83C402                   add  sp, 2
  5386                                  
  5387                                  ;-86 
  5388                                  
  5389                                  
  5390                                  ;-87     i=0;
  5391                                  
  5392 00008EA4 66B800000000             mov eax, 0
  5393 00008EAA 8946FE                   mov word [bp-2], ax
  5394                                  
  5395                                  ;-88     do {
  5396                                  
  5397                                  @@epilog213:
  5398                                  
  5399                                  ;-89         c = FileBin[i];
  5400                                  
  5401 00008EAD 8B5EFE                   mov bx, [bp-2]
  5402 00008EB0 8A87[DD21]               mov al, [FileBin + bx]
  5403 00008EB4 8846FC                   mov byte [bp-4], al
  5404                                  
  5405                                  ;-90         fputcR(c, bin_fd);  
  5406                                  
  5407 00008EB7 FF36[9C01]               push word [bin_fd]
  5408 00008EBB 8A46FC                   mov al, byte [bp-4]
  5409 00008EBE B400                     mov ah, 0
  5410 00008EC0 50                       push ax
  5411 00008EC1 E8900C                   call fputcR
  5412 00008EC4 83C404                   add  sp, 4
  5413                                  
  5414                                  ;-91 //printhex8a(c); prc(' ');      
  5415                                  
  5416                                  
  5417                                  ;-92         i++;
  5418                                  
  5419 00008EC7 FF46FE                   inc  word [bp-2]
  5420                                  
  5421                                  ;-93     } while (i < BinLen);
  5422                                  
  5423 00008ECA 8B46FE                   mov ax, [bp-2]
  5424 00008ECD 3B06[FD6F]               cmp ax, [BinLen]
  5425 00008ED1 0F8D0200                 jge @@epilog214
  5426 00008ED5 EBD6                     jmp @@epilog213
  5427                                  @@epilog214:
  5428                                  
  5429                                  ;-94 
  5430                                  
  5431                                  
  5432                                  ;-95   prs("\ Labels: "); 
  5433                                  
  5434 00008ED7 68[258F]                 push epilog_6
  5435 00008EDA E870F8                   call prs
  5436 00008EDD 83C402                   add  sp, 2
  5437                                  
  5438                                  ;-96   printIntU(LabelMaxIx); 
  5439                                  
  5440 00008EE0 FF36[1D16]               push word [LabelMaxIx]
  5441 00008EE4 E885F9                   call printIntU
  5442 00008EE7 83C402                   add  sp, 2
  5443                                  
  5444                                  ;-97   prs(". ");     
  5445                                  
  5446 00008EEA 68[308F]                 push epilog_7
  5447 00008EED E85DF8                   call prs
  5448 00008EF0 83C402                   add  sp, 2
  5449                                  
  5450                                  ;-98 /*  prs("size: ");
  5451                                  
  5452                                  
  5453                                  ;-99   i= &LabelNames; i=LabelNamePtr-i; printIntU(i); 
  5454                                  
  5455                                  
  5456                                  ;-100   prs(". >>");
  5457                                  
  5458                                  
  5459                                  ;-101   i= &LabelNames;
  5460                                  
  5461                                  
  5462                                  ;-102   do { c=*i; if (c==0) c=' '; prc(c); i++;
  5463                                  
  5464                                  
  5465                                  ;-103   } while (i < LabelNamePtr); prs("<< \n");  */
  5466                                  
  5467                                  
  5468                                  ;-104 /*    i = 1;
  5469                                  
  5470                                  
  5471                                  ;-105     LabelNamePtr= &LabelNames;
  5472                                  
  5473                                  
  5474                                  ;-106     do {
  5475                                  
  5476                                  
  5477                                  ;-107       prs(LabelNamePtr); prc(' ');
  5478                                  
  5479                                  
  5480                                  ;-108       j=LabelAddr[i]; printhex16(j); prs(", ");
  5481                                  
  5482                                  
  5483                                  ;-109       j=strlen(LabelNamePtr);//get end of actual name
  5484                                  
  5485                                  
  5486                                  ;-110       LabelNamePtr=LabelNamePtr+j;
  5487                                  
  5488                                  
  5489                                  ;-111       LabelNamePtr++;
  5490                                  
  5491                                  
  5492                                  ;-112       i++;
  5493                                  
  5494                                  
  5495                                  ;-113     } while (i <= LabelMaxIx);
  5496                                  
  5497                                  
  5498                                  ;-114 */
  5499                                  
  5500                                  
  5501                                  ;-115 }
  5502                                  
  5503                                  
  5504                                  ;-116 
  5505                                  
  5506                                  
  5507                                  ;-117 int end1(int n) {
  5508 00008EF3 C9                       LEAVE
  5509 00008EF4 C3                       ret
  5510                                  ; ENDP
  5511 00008EF5 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  5512 00008EFE 3A2000             
  5513 00008F01 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5514 00008F0A 2A2A2A2000         
  5515 00008F0F 2C204F75743A2000        epilog_2 db ", Out: ",0
  5516 00008F17 2C2000                  epilog_3 db ", ",0
  5517 00008F1A 3D2000                  epilog_4 db "= ",0
  5518 00008F1D 2062797465732E00        epilog_5 db " bytes.",0
  5519 00008F25 5C204C6162656C733A-     epilog_6 db "\ Labels: ",0
  5520 00008F2E 2000               
  5521 00008F30 2E2000                  epilog_7 db ". ",0
  5522                                  
  5523                                  end1:  ; *** PROC ***
  5524                                  
  5525                                  ;-118     fcloseR(asm_fd);
  5526                                  
  5527                                  ;Function : end1, Number of local variables: 1
  5528                                  ;   # type sign width line used address name   list of local variables
  5529                                  ;  200 var sign word   117 NULL bp+4    n;
  5530 00008F33 C8000000                 ENTER  0,0
  5531 00008F37 FF36[9801]               push word [asm_fd]
  5532 00008F3B E82B0C                   call fcloseR
  5533 00008F3E 83C402                   add  sp, 2
  5534                                  
  5535                                  ;-119     fcloseR(lst_fd);
  5536                                  
  5537 00008F41 FF36[9A01]               push word [lst_fd]
  5538 00008F45 E8210C                   call fcloseR
  5539 00008F48 83C402                   add  sp, 2
  5540                                  
  5541                                  ;-120     fcloseR(bin_fd);
  5542                                  
  5543 00008F4B FF36[9C01]               push word [bin_fd]
  5544 00008F4F E8170C                   call fcloseR
  5545 00008F52 83C402                   add  sp, 2
  5546                                  
  5547                                  ;-121     exitR(n);
  5548                                  
  5549 00008F55 FF7604                   push word [bp+4]
  5550 00008F58 E81C0C                   call exitR
  5551 00008F5B 83C402                   add  sp, 2
  5552                                  
  5553                                  ;-122 }
  5554 00008F5E C9                       LEAVE
  5555 00008F5F C3                       ret
  5556                                  ; ENDP
  5557                                  ;Back to main program: AS.C
  5558                                  
  5559                                  ;-9 #include "GENCODE.C"
  5560                                  
  5561                                  ;Use include file: GENCODE.C
  5562                                  
  5563                                  ;-1 // generate code
  5564                                  
  5565                                  
  5566                                  ;-2 int getCodes() {
  5567                                  
  5568                                  
  5569                                  getCodes:  ; *** PROC ***
  5570                                  
  5571                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5572                                  
  5573 00008F60 FF06[C801]               inc  word [OpCodePtr]
  5574 00008F64 8B1E[C801]               mov bx, [OpCodePtr]
  5575 00008F68 8A07                     mov al, [bx]
  5576 00008F6A B400                     mov ah, 0
  5577 00008F6C A2[B001]                 mov byte [Code1], al
  5578                                  
  5579                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5580                                  
  5581 00008F6F FF06[C801]               inc  word [OpCodePtr]
  5582 00008F73 8B1E[C801]               mov bx, [OpCodePtr]
  5583 00008F77 8A07                     mov al, [bx]
  5584 00008F79 B400                     mov ah, 0
  5585 00008F7B A2[B101]                 mov byte [Code2], al
  5586                                  
  5587                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5588                                  
  5589 00008F7E FF06[C801]               inc  word [OpCodePtr]
  5590 00008F82 8B1E[C801]               mov bx, [OpCodePtr]
  5591 00008F86 8A07                     mov al, [bx]
  5592 00008F88 B400                     mov ah, 0
  5593 00008F8A A2[B201]                 mov byte [Code3], al
  5594                                  
  5595                                  ;-6 }
  5596                                  
  5597                                  
  5598                                  ;-7 int gen66h() {genCode8(0x66);
  5599                                  
  5600 00008F8D C3                       ret
  5601                                  ; ENDP
  5602                                  
  5603                                  gen66h:  ; *** PROC ***
  5604 00008F8E 6A66                     push 102
  5605 00008F90 E83B00                   call genCode8
  5606 00008F93 83C402                   add  sp, 2
  5607                                  
  5608                                  ;-8 }
  5609                                  
  5610                                  
  5611                                  ;-9 int genCode2(char c, char d) {
  5612                                  
  5613 00008F96 C3                       ret
  5614                                  ; ENDP
  5615                                  
  5616                                  genCode2:  ; *** PROC ***
  5617                                  
  5618                                  ;-10     c = c + d;
  5619                                  
  5620                                  ;Function : genCode2, Number of local variables: 2
  5621                                  ;   # type sign width line used address name   list of local variables
  5622                                  ;  200 var sign byte     9 NULL bp+4    c
  5623                                  ;  201 var sign byte     9 NULL bp+6    d;
  5624 00008F97 C8000000                 ENTER  0,0
  5625 00008F9B 8A4604                   mov al, [bp+4]
  5626 00008F9E 024606                   add al, [bp+6]
  5627 00008FA1 884604                   mov byte [bp+4], al
  5628                                  
  5629                                  ;-11     genCode8(c);
  5630                                  
  5631 00008FA4 8A4604                   mov al, byte [bp+4]
  5632 00008FA7 B400                     mov ah, 0
  5633 00008FA9 50                       push ax
  5634 00008FAA E82100                   call genCode8
  5635 00008FAD 83C402                   add  sp, 2
  5636                                  
  5637                                  ;-12 }                             
  5638                                  
  5639                                  
  5640                                  ;-13 int genCodeW(char c) {
  5641 00008FB0 C9                       LEAVE
  5642 00008FB1 C3                       ret
  5643                                  ; ENDP
  5644                                  
  5645                                  genCodeW:  ; *** PROC ***
  5646                                  
  5647                                  ;-14     c = c + wflag;  
  5648                                  
  5649                                  ;Function : genCodeW, Number of local variables: 1
  5650                                  ;   # type sign width line used address name   list of local variables
  5651                                  ;  200 var sign byte    13 NULL bp+4    c;
  5652 00008FB2 C8000000                 ENTER  0,0
  5653 00008FB6 8A4604                   mov al, [bp+4]
  5654 00008FB9 0206[B801]               add al, [wflag]
  5655 00008FBD 884604                   mov byte [bp+4], al
  5656                                  
  5657                                  ;-15     genCode8(c);
  5658                                  
  5659 00008FC0 8A4604                   mov al, byte [bp+4]
  5660 00008FC3 B400                     mov ah, 0
  5661 00008FC5 50                       push ax
  5662 00008FC6 E80500                   call genCode8
  5663 00008FC9 83C402                   add  sp, 2
  5664                                  
  5665                                  ;-16 }   
  5666                                  
  5667                                  
  5668                                  ;-17 int genCode8(char c) {
  5669 00008FCC C9                       LEAVE
  5670 00008FCD C3                       ret
  5671                                  ; ENDP
  5672                                  
  5673                                  genCode8:  ; *** PROC ***
  5674                                  
  5675                                  ;-18 //set: BinLen++, OpPrintIndex++
  5676                                  
  5677                                  
  5678                                  ;-19     FileBin[BinLen]=c;
  5679                                  
  5680                                  ;Function : genCode8, Number of local variables: 1
  5681                                  ;   # type sign width line used address name   list of local variables
  5682                                  ;  200 var sign byte    17 NULL bp+4    c;
  5683 00008FCE C8000000                 ENTER  0,0
  5684 00008FD2 8A4604                   mov al, [bp+4]
  5685 00008FD5 8B1E[FD6F]               mov bx, [BinLen]
  5686 00008FD9 8887[DD21]               mov [FileBin+bx], al
  5687                                  
  5688                                  ;-20     BinLen++;
  5689                                  
  5690 00008FDD FF06[FD6F]               inc  word [BinLen]
  5691                                  
  5692                                  ;-21     PC++;
  5693                                  
  5694 00008FE1 FF06[A501]               inc  word [PC]
  5695                                  
  5696                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5697                                  
  5698 00008FE5 A1[FD6F]                 mov ax, [BinLen]
  5699 00008FE8 3D204E                   cmp ax, 20000 ;unsigned : 0
  5700 00008FEB 0F820900                 jb  @@genCode8215
  5701 00008FEF 68[1390]                 push genCode8_0
  5702 00008FF2 E818F9                   call errorexit
  5703 00008FF5 83C402                   add  sp, 2
  5704                                  
  5705                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5706                                  
  5707                                  @@genCode8215:
  5708 00008FF8 A1[C601]                 mov ax, [OpPrintIndex]
  5709 00008FFB 83F805                   cmp ax, 5
  5710 00008FFE 0F8D0F00                 jge @@genCode8216
  5711                                  
  5712                                  ;-24         OpPos[OpPrintIndex]=c;
  5713                                  
  5714 00009002 8A4604                   mov al, [bp+4]
  5715 00009005 8B1E[C601]               mov bx, [OpPrintIndex]
  5716 00009009 8887[C101]               mov [OpPos+bx], al
  5717                                  
  5718                                  ;-25         OpPrintIndex++;
  5719                                  
  5720 0000900D FF06[C601]               inc  word [OpPrintIndex]
  5721                                  
  5722                                  ;-26     }
  5723                                  
  5724                                  
  5725                                  ;-27 }
  5726                                  
  5727                                  @@genCode8216:
  5728                                  
  5729                                  ;-28 int genCode16(unsigned int i) {
  5730 00009011 C9                       LEAVE
  5731 00009012 C3                       ret
  5732                                  ; ENDP
  5733 00009013 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5734 0000901C 746F6F206C6F6E6700 
  5735                                  
  5736                                  genCode16:  ; *** PROC ***
  5737                                  
  5738                                  ;-29     genCode8(i); i=i >> 8;
  5739                                  
  5740                                  ;Function : genCode16, Number of local variables: 1
  5741                                  ;   # type sign width line used address name   list of local variables
  5742                                  ;  200 var unsg word    28 NULL bp+4    i;
  5743 00009025 C8000000                 ENTER  0,0
  5744 00009029 FF7604                   push word [bp+4]
  5745 0000902C E89FFF                   call genCode8
  5746 0000902F 83C402                   add  sp, 2
  5747 00009032 8B4604                   mov ax, [bp+4]
  5748 00009035 C1E808                   shr ax, 8
  5749 00009038 894604                   mov word [bp+4], ax
  5750                                  
  5751                                  ;-30     genCode8(i);
  5752                                  
  5753 0000903B FF7604                   push word [bp+4]
  5754 0000903E E88DFF                   call genCode8
  5755 00009041 83C402                   add  sp, 2
  5756                                  
  5757                                  ;-31 }
  5758                                  
  5759                                  
  5760                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5761 00009044 C9                       LEAVE
  5762 00009045 C3                       ret
  5763                                  ; ENDP
  5764                                  
  5765                                  writeEA:  ; *** PROC ***
  5766                                  
  5767                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5768                                  
  5769                                  
  5770                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5771                                  
  5772                                  
  5773                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5774                                  
  5775                                  
  5776                                  ;-36     char len;
  5777                                  
  5778                                  
  5779                                  ;-37     len=0;   
  5780                                  
  5781                                  ;Function : writeEA, Number of local variables: 2
  5782                                  ;   # type sign width line used address name   list of local variables
  5783                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5784                                  ;  201 var sign byte    36 NULL bp-2    len;
  5785 00009046 C8020000                 ENTER  2,0
  5786 0000904A 66B800000000             mov eax, 0
  5787 00009050 8846FE                   mov byte [bp-2], al
  5788                                  
  5789                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5790                                  
  5791 00009053 8A4604                   mov al, [bp+4]
  5792 00009056 C0E003                   shl al, 3
  5793 00009059 884604                   mov byte [bp+4], al
  5794                                  
  5795                                  ;-39     if (Op == REG) {
  5796                                  
  5797 0000905C A0[AD01]                 mov al, [Op]
  5798 0000905F 3C02                     cmp al, 2
  5799 00009061 0F853A00                 jne @@writeEA217
  5800                                  
  5801                                  ;-40         xxx |= 0xC0;     
  5802                                  
  5803 00009065 804E04C0                 or  byte [bp+4], 192
  5804                                  
  5805                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5806                                  
  5807 00009069 A0[AE01]                 mov al, [Op2]
  5808 0000906C 3C01                     cmp al, 1
  5809 0000906E 0F8F0D00                 jg  @@writeEA218
  5810 00009072 8A4604                   mov al, [bp+4]
  5811 00009075 0206[B401]               add al, [R1No]
  5812 00009079 884604                   mov byte [bp+4], al
  5813                                  
  5814                                  ;-42             else {
  5815                                  
  5816 0000907C E92000                   jmp @@writeEA219
  5817                                  @@writeEA218:
  5818                                  
  5819                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5820                                  
  5821 0000907F A0[AE01]                 mov al, [Op2]
  5822 00009082 3C02                     cmp al, 2
  5823 00009084 0F850D00                 jne @@writeEA220
  5824 00009088 8A4604                   mov al, [bp+4]
  5825 0000908B 0206[B401]               add al, [R1No]
  5826 0000908F 884604                   mov byte [bp+4], al
  5827                                  
  5828                                  ;-44                 else            xxx = xxx + R2No;  
  5829                                  
  5830 00009092 E90A00                   jmp @@writeEA221
  5831                                  @@writeEA220:
  5832 00009095 8A4604                   mov al, [bp+4]
  5833 00009098 0206[B301]               add al, [R2No]
  5834 0000909C 884604                   mov byte [bp+4], al
  5835                                  
  5836                                  ;-45             }
  5837                                  
  5838                                  @@writeEA221:
  5839                                  
  5840                                  ;-46         } 
  5841                                  
  5842                                  @@writeEA219:
  5843                                  
  5844                                  ;-47     if (Op == MEM) {
  5845                                  
  5846                                  @@writeEA217:
  5847 0000909F A0[AD01]                 mov al, [Op]
  5848 000090A2 3C04                     cmp al, 4
  5849 000090A4 0F857F00                 jne @@writeEA222
  5850                                  
  5851                                  ;-48         if (isDirect) {
  5852                                  
  5853 000090A8 A0[BC01]                 mov al, [isDirect]
  5854 000090AB 08C0                     or  al, al
  5855 000090AD 0F841000                 je @@writeEA223
  5856                                  
  5857                                  ;-49             xxx |= 6;
  5858                                  
  5859 000090B1 804E0406                 or  byte [bp+4], 6
  5860                                  
  5861                                  ;-50             len = 2;
  5862                                  
  5863 000090B5 66B802000000             mov eax, 2
  5864 000090BB 8846FE                   mov byte [bp-2], al
  5865                                  
  5866                                  ;-51         }
  5867                                  
  5868                                  
  5869                                  ;-52         else { 
  5870                                  
  5871 000090BE E96600                   jmp @@writeEA224
  5872                                  @@writeEA223:
  5873                                  
  5874                                  ;-53             xxx = xxx + rm;   
  5875                                  
  5876 000090C1 8A4604                   mov al, [bp+4]
  5877 000090C4 0206[BB01]               add al, [rm]
  5878 000090C8 884604                   mov byte [bp+4], al
  5879                                  
  5880                                  ;-54             if (rm == 6) {//make [BP+00]
  5881                                  
  5882 000090CB A0[BB01]                 mov al, [rm]
  5883 000090CE 3C06                     cmp al, 6
  5884 000090D0 0F851700                 jne @@writeEA225
  5885                                  
  5886                                  ;-55                 len=1;
  5887                                  
  5888 000090D4 66B801000000             mov eax, 1
  5889 000090DA 8846FE                   mov byte [bp-2], al
  5890                                  
  5891                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5892                                  
  5893 000090DD A1[BD01]                 mov ax, [disp]
  5894 000090E0 83F800                   cmp ax, 0
  5895 000090E3 0F850400                 jne @@writeEA226
  5896 000090E7 804E0440                 or  byte [bp+4], 64
  5897                                  
  5898                                  ;-57             }
  5899                                  
  5900                                  @@writeEA226:
  5901                                  
  5902                                  ;-58 
  5903                                  
  5904                                  
  5905                                  ;-59             if (disp) {
  5906                                  
  5907                                  @@writeEA225:
  5908 000090EB A1[BD01]                 mov ax, [disp]
  5909 000090EE 08C0                     or  al, al
  5910 000090F0 0F843300                 je @@writeEA227
  5911                                  
  5912                                  ;-60                 ax = disp;
  5913                                  
  5914 000090F4 A1[BD01]                 mov  ax, [disp]
  5915                                  
  5916                                  ;-61                 if(ax > 127) len=2;
  5917                                  
  5918 000090F7 83F87F                   cmp  ax, 127
  5919 000090FA 0F8E0C00                 jle @@writeEA228
  5920 000090FE 66B802000000             mov eax, 2
  5921 00009104 8846FE                   mov byte [bp-2], al
  5922                                  
  5923                                  ;-62                 else len=1;
  5924                                  
  5925 00009107 E90900                   jmp @@writeEA229
  5926                                  @@writeEA228:
  5927 0000910A 66B801000000             mov eax, 1
  5928 00009110 8846FE                   mov byte [bp-2], al
  5929                                  
  5930                                  ;-63                 if (len == 1) xxx |= 0x40;
  5931                                  
  5932                                  @@writeEA229:
  5933 00009113 8A46FE                   mov al, [bp-2]
  5934 00009116 3C01                     cmp al, 1
  5935 00009118 0F850700                 jne @@writeEA230
  5936 0000911C 804E0440                 or  byte [bp+4], 64
  5937                                  
  5938                                  ;-64                 else xxx |= 0x80;
  5939                                  
  5940 00009120 E90400                   jmp @@writeEA231
  5941                                  @@writeEA230:
  5942 00009123 804E0480                 or  byte [bp+4], 128
  5943                                  
  5944                                  ;-65             }
  5945                                  
  5946                                  @@writeEA231:
  5947                                  
  5948                                  ;-66         }
  5949                                  
  5950                                  @@writeEA227:
  5951                                  
  5952                                  ;-67     }  
  5953                                  
  5954                                  @@writeEA224:
  5955                                  
  5956                                  ;-68     
  5957                                  
  5958                                  
  5959                                  ;-69     genCode8(xxx);// gen second byte
  5960                                  
  5961                                  @@writeEA222:
  5962 00009127 8A4604                   mov al, byte [bp+4]
  5963 0000912A B400                     mov ah, 0
  5964 0000912C 50                       push ax
  5965 0000912D E89EFE                   call genCode8
  5966 00009130 83C402                   add  sp, 2
  5967                                  
  5968                                  ;-70     if (len == 1) genCode8 (disp);
  5969                                  
  5970 00009133 8A46FE                   mov al, [bp-2]
  5971 00009136 3C01                     cmp al, 1
  5972 00009138 0F850A00                 jne @@writeEA232
  5973 0000913C FF36[BD01]               push word [disp]
  5974 00009140 E88BFE                   call genCode8
  5975 00009143 83C402                   add  sp, 2
  5976                                  
  5977                                  ;-71     if (len == 2) genCode16(disp);
  5978                                  
  5979                                  @@writeEA232:
  5980 00009146 8A46FE                   mov al, [bp-2]
  5981 00009149 3C02                     cmp al, 2
  5982 0000914B 0F850A00                 jne @@writeEA233
  5983 0000914F FF36[BD01]               push word [disp]
  5984 00009153 E8CFFE                   call genCode16
  5985 00009156 83C402                   add  sp, 2
  5986                                  
  5987                                  ;-72 }
  5988                                  
  5989                                  @@writeEA233:
  5990                                  
  5991                                  ;-73 
  5992                                  
  5993                                  
  5994                                  ;-74 int genImmediate() { 
  5995 00009159 C9                       LEAVE
  5996 0000915A C3                       ret
  5997                                  ; ENDP
  5998                                  
  5999                                  genImmediate:  ; *** PROC ***
  6000                                  
  6001                                  ;-75     if (wflag) genCode16(imme);
  6002                                  
  6003 0000915B A0[B801]                 mov al, [wflag]
  6004 0000915E 08C0                     or  al, al
  6005 00009160 0F840D00                 je @@genImmediate234
  6006 00009164 FF36[BF01]               push word [imme]
  6007 00009168 E8BAFE                   call genCode16
  6008 0000916B 83C402                   add  sp, 2
  6009                                  
  6010                                  ;-76     else       genCode8 (imme);  
  6011                                  
  6012 0000916E E90A00                   jmp @@genImmediate235
  6013                                  @@genImmediate234:
  6014 00009171 FF36[BF01]               push word [imme]
  6015 00009175 E856FE                   call genCode8
  6016 00009178 83C402                   add  sp, 2
  6017                                  
  6018                                  ;-77 }    
  6019                                  
  6020                                  @@genImmediate235:
  6021 0000917B C3                       ret
  6022                                  ; ENDP
  6023                                  ;Back to main program: AS.C
  6024                                  
  6025                                  ;-10 
  6026                                  
  6027                                  
  6028                                  ;-11 int process() { 
  6029                                  
  6030                                  
  6031                                  process:  ; *** PROC ***
  6032                                  
  6033                                  ;-12     char c;           
  6034                                  
  6035                                  
  6036                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6037                                  
  6038                                  ;Function : process, Number of local variables: 1
  6039                                  ;   # type sign width line used address name   list of local variables
  6040                                  ;  200 var sign byte    12 NULL bp-2    c;
  6041 0000917C C8020000                 ENTER  2,0
  6042 00009180 66B800000000             mov eax, 0
  6043 00009186 A2[BB01]                 mov byte [rm], al
  6044 00009189 A2[B801]                 mov byte [wflag], al
  6045 0000918C A2[B901]                 mov byte [dflag], al
  6046 0000918F A2[B301]                 mov byte [R2No], al
  6047 00009192 A2[B401]                 mov byte [R1No], al
  6048 00009195 A2[B501]                 mov byte [R2Type], al
  6049 00009198 A2[B601]                 mov byte [R1Type], al
  6050 0000919B A2[AE01]                 mov byte [Op2], al
  6051 0000919E A2[AD01]                 mov byte [Op], al
  6052                                  
  6053                                  ;-14     disp=imme=0;//int
  6054                                  
  6055 000091A1 66B800000000             mov eax, 0
  6056 000091A7 A3[BF01]                 mov word [imme], ax
  6057 000091AA A3[BD01]                 mov word [disp], ax
  6058                                  
  6059                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  6060                                  
  6061 000091AD 66B801000000             mov eax, 1
  6062 000091B3 A2[BC01]                 mov byte [isDirect], al
  6063                                  
  6064                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6065                                  
  6066 000091B6 E820E8                   call getTokeType
  6067                                  
  6068                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6069                                  
  6070 000091B9 E818EC                   call getCodeSize
  6071 000091BC A2[B701]                 mov byte [OpSize], al
  6072                                  
  6073                                  ;-18     getCodes();//set: Code1, Code2, Code3
  6074                                  
  6075 000091BF E89EFD                   call getCodes
  6076                                  
  6077                                  ;-19 
  6078                                  
  6079                                  
  6080                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  6081                                  
  6082 000091C2 A0[AF01]                 mov al, [CodeType]
  6083 000091C5 3C01                     cmp al, 1
  6084 000091C7 0F850F00                 jne @@process236
  6085                                  
  6086                                  ;-21         genCode8(Code1);
  6087                                  
  6088 000091CB A0[B001]                 mov al, byte [Code1]
  6089 000091CE B400                     mov ah, 0
  6090 000091D0 50                       push ax
  6091 000091D1 E8FAFD                   call genCode8
  6092 000091D4 83C402                   add  sp, 2
  6093                                  
  6094                                  ;-22         return;
  6095                                  
  6096 000091D7 E97D07                   jmp @@retn
  6097                                  
  6098                                  ;-23     }
  6099                                  
  6100                                  
  6101                                  ;-24   
  6102                                  
  6103                                  
  6104                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  6105                                  
  6106                                  @@process236:
  6107 000091DA A0[AF01]                 mov al, [CodeType]
  6108 000091DD 3C02                     cmp al, 2
  6109 000091DF 0F856900                 jne @@process237
  6110                                  
  6111                                  ;-26         getOpL();    
  6112                                  
  6113 000091E3 E8C5E2                   call getOpL
  6114                                  
  6115                                  ;-27         checkOpL();        
  6116                                  
  6117 000091E6 E8E5E1                   call checkOpL
  6118                                  
  6119                                  ;-28         if (Code2 <= 1) {//inc,dec
  6120                                  
  6121 000091E9 A0[B101]                 mov al, [Code2]
  6122 000091EC 3C01                     cmp al, 1
  6123 000091EE 0F8F2700                 jg  @@process238
  6124                                  
  6125                                  ;-29   	        if (Op == REG) {//short
  6126                                  
  6127 000091F2 A0[AD01]                 mov al, [Op]
  6128 000091F5 3C02                     cmp al, 2
  6129 000091F7 0F851E00                 jne @@process239
  6130                                  
  6131                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  6132                                  
  6133 000091FB A0[B801]                 mov al, [wflag]
  6134 000091FE 08C0                     or  al, al
  6135 00009200 0F841500                 je @@process240
  6136 00009204 A0[B401]                 mov al, byte [R1No]
  6137 00009207 B400                     mov ah, 0
  6138 00009209 50                       push ax
  6139 0000920A A0[B201]                 mov al, byte [Code3]
  6140 0000920D B400                     mov ah, 0
  6141 0000920F 50                       push ax
  6142 00009210 E884FD                   call genCode2
  6143 00009213 83C404                   add  sp, 4
  6144 00009216 E93E07                   jmp @@retn
  6145                                  
  6146                                  ;-31             }
  6147                                  
  6148                                  @@process240:
  6149                                  
  6150                                  ;-32         }
  6151                                  
  6152                                  @@process239:
  6153                                  
  6154                                  ;-33         if (Code2 == 5) {//imul extension?
  6155                                  
  6156                                  @@process238:
  6157 00009219 A0[B101]                 mov al, [Code2]
  6158 0000921C 3C05                     cmp al, 5
  6159 0000921E 0F850F00                 jne @@process241
  6160                                  
  6161                                  ;-34             getTokeType();
  6162                                  
  6163 00009222 E8B4E7                   call getTokeType
  6164                                  
  6165                                  ;-35             if (TokeType) implerror();
  6166                                  
  6167 00009225 A0[AC01]                 mov al, [TokeType]
  6168 00009228 08C0                     or  al, al
  6169 0000922A 0F840300                 je @@process242
  6170 0000922E E84DF7                   call implerror
  6171                                  
  6172                                  ;-36         }
  6173                                  
  6174                                  @@process242:
  6175                                  
  6176                                  ;-37         genCodeW(Code1);           
  6177                                  
  6178                                  @@process241:
  6179 00009231 A0[B001]                 mov al, byte [Code1]
  6180 00009234 B400                     mov ah, 0
  6181 00009236 50                       push ax
  6182 00009237 E878FD                   call genCodeW
  6183 0000923A 83C402                   add  sp, 2
  6184                                  
  6185                                  ;-38         writeEA(Code2);
  6186                                  
  6187 0000923D A0[B101]                 mov al, byte [Code2]
  6188 00009240 B400                     mov ah, 0
  6189 00009242 50                       push ax
  6190 00009243 E800FE                   call writeEA
  6191 00009246 83C402                   add  sp, 2
  6192                                  
  6193                                  ;-39         return;
  6194                                  
  6195 00009249 E90B07                   jmp @@retn
  6196                                  
  6197                                  ;-40     }
  6198                                  
  6199                                  
  6200                                  ;-41   
  6201                                  
  6202                                  
  6203                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6204                                  
  6205                                  @@process237:
  6206 0000924C A0[AF01]                 mov al, [CodeType]
  6207 0000924F 3C03                     cmp al, 3
  6208 00009251 0F855100                 jne @@process243
  6209                                  
  6210                                  ;-43         check2Ops();    //setwflag not applicable
  6211                                  
  6212 00009255 E8F8E1                   call check2Ops
  6213                                  
  6214                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  6215                                  
  6216 00009258 A0[B601]                 mov al, [R1Type]
  6217 0000925B 3C02                     cmp al, 2
  6218 0000925D 0F840300                 je  @@process244
  6219 00009261 E8BAF7                   call reg16error
  6220                                  
  6221                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  6222                                  
  6223                                  @@process244:
  6224 00009264 A0[AE01]                 mov al, [Op2]
  6225 00009267 3C04                     cmp al, 4
  6226 00009269 0F840300                 je  @@process245
  6227 0000926D E8CFF6                   call addrerror
  6228                                  
  6229                                  ;-46         
  6230                                  
  6231                                  
  6232                                  ;-47         genCode8(Code1);//les,lds,lea
  6233                                  
  6234                                  @@process245:
  6235 00009270 A0[B001]                 mov al, byte [Code1]
  6236 00009273 B400                     mov ah, 0
  6237 00009275 50                       push ax
  6238 00009276 E855FD                   call genCode8
  6239 00009279 83C402                   add  sp, 2
  6240                                  
  6241                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  6242                                  
  6243 0000927C A0[B001]                 mov al, [Code1]
  6244 0000927F 3C0F                     cmp al, 15
  6245 00009281 0F850C00                 jne @@process246
  6246 00009285 A0[B101]                 mov al, byte [Code2]
  6247 00009288 B400                     mov ah, 0
  6248 0000928A 50                       push ax
  6249 0000928B E840FD                   call genCode8
  6250 0000928E 83C402                   add  sp, 2
  6251                                  
  6252                                  ;-49         Op=Op2;//set MEM for writeEA
  6253                                  
  6254                                  @@process246:
  6255 00009291 A0[AE01]                 mov al, [Op2]
  6256 00009294 A2[AD01]                 mov byte [Op], al
  6257                                  
  6258                                  ;-50         writeEA(R1No);           
  6259                                  
  6260 00009297 A0[B401]                 mov al, byte [R1No]
  6261 0000929A B400                     mov ah, 0
  6262 0000929C 50                       push ax
  6263 0000929D E8A6FD                   call writeEA
  6264 000092A0 83C402                   add  sp, 2
  6265                                  
  6266                                  ;-51         return;
  6267                                  
  6268 000092A3 E9B106                   jmp @@retn
  6269                                  
  6270                                  ;-52     }
  6271                                  
  6272                                  
  6273                                  ;-53 
  6274                                  
  6275                                  
  6276                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6277                                  
  6278                                  @@process243:
  6279 000092A6 A0[AF01]                 mov al, [CodeType]
  6280 000092A9 3C04                     cmp al, 4
  6281 000092AB 0F85EF00                 jne @@process247
  6282                                  
  6283                                  ;-55         check2Ops();    
  6284                                  
  6285 000092AF E89EE1                   call check2Ops
  6286                                  
  6287                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  6288                                  
  6289 000092B2 A0[AE01]                 mov al, [Op2]
  6290 000092B5 3C01                     cmp al, 1
  6291 000092B7 0F857900                 jne @@process248
  6292                                  
  6293                                  ;-57             setsflag();   
  6294                                  
  6295 000092BB E875E5                   call setsflag
  6296                                  
  6297                                  ;-58             if (Op == REG) {                
  6298                                  
  6299 000092BE A0[AD01]                 mov al, [Op]
  6300 000092C1 3C02                     cmp al, 2
  6301 000092C3 0F853100                 jne @@process249
  6302                                  
  6303                                  ;-59                 if (R1No == 0) {// acc,imm   
  6304                                  
  6305 000092C7 A0[B401]                 mov al, [R1No]
  6306 000092CA 3C00                     cmp al, 0
  6307 000092CC 0F852800                 jne @@process250
  6308                                  
  6309                                  ;-60                     if (sflag == 0) {                        
  6310                                  
  6311 000092D0 A0[BA01]                 mov al, [sflag]
  6312 000092D3 3C00                     cmp al, 0
  6313 000092D5 0F851F00                 jne @@process251
  6314                                  
  6315                                  ;-61                         c = Code1 << 3;
  6316                                  
  6317 000092D9 A0[B001]                 mov al, [Code1]
  6318 000092DC C0E003                   shl al, 3
  6319 000092DF 8846FE                   mov byte [bp-2], al
  6320                                  
  6321                                  ;-62                         c += 4;    
  6322                                  
  6323 000092E2 8046FE04                 add  byte [bp-2], 4
  6324                                  
  6325                                  ;-63                         genCodeW(c);
  6326                                  
  6327 000092E6 8A46FE                   mov al, byte [bp-2]
  6328 000092E9 B400                     mov ah, 0
  6329 000092EB 50                       push ax
  6330 000092EC E8C3FC                   call genCodeW
  6331 000092EF 83C402                   add  sp, 2
  6332                                  
  6333                                  ;-64                         genImmediate();
  6334                                  
  6335 000092F2 E866FE                   call genImmediate
  6336                                  
  6337                                  ;-65                         return;
  6338                                  
  6339 000092F5 E95F06                   jmp @@retn
  6340                                  
  6341                                  ;-66                     }
  6342                                  
  6343                                  
  6344                                  ;-67                 }
  6345                                  
  6346                                  @@process251:
  6347                                  
  6348                                  ;-68             }
  6349                                  
  6350                                  @@process250:
  6351                                  
  6352                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6353                                  
  6354                                  
  6355                                  ;-70             c = sflag + 0x80;   
  6356                                  
  6357                                  @@process249:
  6358 000092F8 A0[BA01]                 mov al, [sflag]
  6359 000092FB 0480                     add al, 128
  6360 000092FD 8846FE                   mov byte [bp-2], al
  6361                                  
  6362                                  ;-71             genCodeW(c); 
  6363                                  
  6364 00009300 8A46FE                   mov al, byte [bp-2]
  6365 00009303 B400                     mov ah, 0
  6366 00009305 50                       push ax
  6367 00009306 E8A9FC                   call genCodeW
  6368 00009309 83C402                   add  sp, 2
  6369                                  
  6370                                  ;-72             writeEA(Code1);  
  6371                                  
  6372 0000930C A0[B001]                 mov al, byte [Code1]
  6373 0000930F B400                     mov ah, 0
  6374 00009311 50                       push ax
  6375 00009312 E831FD                   call writeEA
  6376 00009315 83C402                   add  sp, 2
  6377                                  
  6378                                  ;-73             if (sflag) genCode8(imme);
  6379                                  
  6380 00009318 A0[BA01]                 mov al, [sflag]
  6381 0000931B 08C0                     or  al, al
  6382 0000931D 0F840D00                 je @@process252
  6383 00009321 FF36[BF01]               push word [imme]
  6384 00009325 E8A6FC                   call genCode8
  6385 00009328 83C402                   add  sp, 2
  6386                                  
  6387                                  ;-74             else genImmediate();    
  6388                                  
  6389 0000932B E90300                   jmp @@process253
  6390                                  @@process252:
  6391 0000932E E82AFE                   call genImmediate
  6392                                  
  6393                                  ;-75             return;     
  6394                                  
  6395                                  @@process253:
  6396 00009331 E92306                   jmp @@retn
  6397                                  
  6398                                  ;-76         }  
  6399                                  
  6400                                  
  6401                                  ;-77         c = Code1 << 3;//r/m, r/r  
  6402                                  
  6403                                  @@process248:
  6404 00009334 A0[B001]                 mov al, [Code1]
  6405 00009337 C0E003                   shl al, 3
  6406 0000933A 8846FE                   mov byte [bp-2], al
  6407                                  
  6408                                  ;-78         if (Op == REG) {
  6409                                  
  6410 0000933D A0[AD01]                 mov al, [Op]
  6411 00009340 3C02                     cmp al, 2
  6412 00009342 0F852E00                 jne @@process254
  6413                                  
  6414                                  ;-79             if (Op2 == MEM) {//reg, mem      
  6415                                  
  6416 00009346 A0[AE01]                 mov al, [Op2]
  6417 00009349 3C04                     cmp al, 4
  6418 0000934B 0F852500                 jne @@process255
  6419                                  
  6420                                  ;-80                 c += 2;//add direction flag
  6421                                  
  6422 0000934F 8046FE02                 add  byte [bp-2], 2
  6423                                  
  6424                                  ;-81                 genCodeW(c);
  6425                                  
  6426 00009353 8A46FE                   mov al, byte [bp-2]
  6427 00009356 B400                     mov ah, 0
  6428 00009358 50                       push ax
  6429 00009359 E856FC                   call genCodeW
  6430 0000935C 83C402                   add  sp, 2
  6431                                  
  6432                                  ;-82                 Op=Op2;//set MEM for writeEA                
  6433                                  
  6434 0000935F A0[AE01]                 mov al, [Op2]
  6435 00009362 A2[AD01]                 mov byte [Op], al
  6436                                  
  6437                                  ;-83                 writeEA(R1No);
  6438                                  
  6439 00009365 A0[B401]                 mov al, byte [R1No]
  6440 00009368 B400                     mov ah, 0
  6441 0000936A 50                       push ax
  6442 0000936B E8D8FC                   call writeEA
  6443 0000936E 83C402                   add  sp, 2
  6444                                  
  6445                                  ;-84                 return;    
  6446                                  
  6447 00009371 E9E305                   jmp @@retn
  6448                                  
  6449                                  ;-85             }
  6450                                  
  6451                                  
  6452                                  ;-86         }
  6453                                  
  6454                                  @@process255:
  6455                                  
  6456                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  6457                                  
  6458                                  @@process254:
  6459 00009374 A0[AE01]                 mov al, [Op2]
  6460 00009377 3C02                     cmp al, 2
  6461 00009379 0F851B00                 jne @@process256
  6462                                  
  6463                                  ;-88             genCodeW(c);
  6464                                  
  6465 0000937D 8A46FE                   mov al, byte [bp-2]
  6466 00009380 B400                     mov ah, 0
  6467 00009382 50                       push ax
  6468 00009383 E82CFC                   call genCodeW
  6469 00009386 83C402                   add  sp, 2
  6470                                  
  6471                                  ;-89             writeEA(R2No);//2. Op in reg-field
  6472                                  
  6473 00009389 A0[B301]                 mov al, byte [R2No]
  6474 0000938C B400                     mov ah, 0
  6475 0000938E 50                       push ax
  6476 0000938F E8B4FC                   call writeEA
  6477 00009392 83C402                   add  sp, 2
  6478                                  
  6479                                  ;-90             return;            
  6480                                  
  6481 00009395 E9BF05                   jmp @@retn
  6482                                  
  6483                                  ;-91         }          
  6484                                  
  6485                                  
  6486                                  ;-92         syntaxerror();        
  6487                                  
  6488                                  @@process256:
  6489 00009398 E8D2F6                   call syntaxerror
  6490                                  
  6491                                  ;-93         return;
  6492                                  
  6493 0000939B E9B905                   jmp @@retn
  6494                                  
  6495                                  ;-94     }
  6496                                  
  6497                                  
  6498                                  ;-95  
  6499                                  
  6500                                  
  6501                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  6502                                  
  6503                                  @@process247:
  6504 0000939E A0[AF01]                 mov al, [CodeType]
  6505 000093A1 3C05                     cmp al, 5
  6506 000093A3 0F857F01                 jne @@process257
  6507                                  
  6508                                  ;-97         check2Ops();    
  6509                                  
  6510 000093A7 E8A6E0                   call check2Ops
  6511                                  
  6512                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  6513                                  
  6514                                  
  6515                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6516                                  
  6517                                  
  6518                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6519                                  
  6520                                  
  6521                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6522                                  
  6523                                  
  6524                                  ;-102         if (Op2 == ADR) {
  6525                                  
  6526 000093AA A0[AE01]                 mov al, [Op2]
  6527 000093AD 3C03                     cmp al, 3
  6528 000093AF 0F850F00                 jne @@process258
  6529                                  
  6530                                  ;-103             imme=disp;
  6531                                  
  6532 000093B3 A1[BD01]                 mov ax, [disp]
  6533 000093B6 A3[BF01]                 mov word [imme], ax
  6534                                  
  6535                                  ;-104             Op2=IMM;//continue with IMM    
  6536                                  
  6537 000093B9 66B801000000             mov eax, 1
  6538 000093BF A2[AE01]                 mov byte [Op2], al
  6539                                  
  6540                                  ;-105         }  
  6541                                  
  6542                                  
  6543                                  ;-106         if (Op2 == IMM) {// r,i     
  6544                                  
  6545                                  @@process258:
  6546 000093C2 A0[AE01]                 mov al, [Op2]
  6547 000093C5 3C01                     cmp al, 1
  6548 000093C7 0F855400                 jne @@process259
  6549                                  
  6550                                  ;-107             if (Op == REG) {               
  6551                                  
  6552 000093CB A0[AD01]                 mov al, [Op]
  6553 000093CE 3C02                     cmp al, 2
  6554 000093D0 0F852500                 jne @@process260
  6555                                  
  6556                                  ;-108                 c = wflag << 3;   
  6557                                  
  6558 000093D4 A0[B801]                 mov al, [wflag]
  6559 000093D7 C0E003                   shl al, 3
  6560 000093DA 8846FE                   mov byte [bp-2], al
  6561                                  
  6562                                  ;-109                 c += 0xB0;                                     
  6563                                  
  6564 000093DD 8046FEB0                 add  byte [bp-2], 176
  6565                                  
  6566                                  ;-110                 genCode2(c, R1No);   
  6567                                  
  6568 000093E1 A0[B401]                 mov al, byte [R1No]
  6569 000093E4 B400                     mov ah, 0
  6570 000093E6 50                       push ax
  6571 000093E7 8A46FE                   mov al, byte [bp-2]
  6572 000093EA B400                     mov ah, 0
  6573 000093EC 50                       push ax
  6574 000093ED E8A7FB                   call genCode2
  6575 000093F0 83C404                   add  sp, 4
  6576                                  
  6577                                  ;-111                 genImmediate();
  6578                                  
  6579 000093F3 E865FD                   call genImmediate
  6580                                  
  6581                                  ;-112                 return; 
  6582                                  
  6583 000093F6 E95E05                   jmp @@retn
  6584                                  
  6585                                  ;-113             }
  6586                                  
  6587                                  
  6588                                  ;-114             if (Op == MEM) {// m,i  
  6589                                  
  6590                                  @@process260:
  6591 000093F9 A0[AD01]                 mov al, [Op]
  6592 000093FC 3C04                     cmp al, 4
  6593 000093FE 0F851700                 jne @@process261
  6594                                  
  6595                                  ;-115                 genCodeW(0xC6);
  6596                                  
  6597 00009402 68C600                   push 198
  6598 00009405 E8AAFB                   call genCodeW
  6599 00009408 83C402                   add  sp, 2
  6600                                  
  6601                                  ;-116                 writeEA( 0 );
  6602                                  
  6603 0000940B 6A00                     push 0
  6604 0000940D E836FC                   call writeEA
  6605 00009410 83C402                   add  sp, 2
  6606                                  
  6607                                  ;-117                 genImmediate();
  6608                                  
  6609 00009413 E845FD                   call genImmediate
  6610                                  
  6611                                  ;-118                 return;  
  6612                                  
  6613 00009416 E93E05                   jmp @@retn
  6614                                  
  6615                                  ;-119             }
  6616                                  
  6617                                  
  6618                                  ;-120             regmemerror();
  6619                                  
  6620                                  @@process261:
  6621 00009419 E8D8F5                   call regmemerror
  6622                                  
  6623                                  ;-121             return;
  6624                                  
  6625 0000941C E93805                   jmp @@retn
  6626                                  
  6627                                  ;-122         }      
  6628                                  
  6629                                  
  6630                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6631                                  
  6632                                  @@process259:
  6633 0000941F A0[B601]                 mov al, [R1Type]
  6634 00009422 3C04                     cmp al, 4
  6635 00009424 0F850300                 jne @@process262
  6636 00009428 E85EDF                   call ChangeDirection
  6637                                  
  6638                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6639                                  
  6640                                  @@process262:
  6641 0000942B A0[B501]                 mov al, [R2Type]
  6642 0000942E 3C04                     cmp al, 4
  6643 00009430 0F852A00                 jne @@process263
  6644                                  
  6645                                  ;-125             if (OpSize != WORD) reg16error();
  6646                                  
  6647 00009434 A0[B701]                 mov al, [OpSize]
  6648 00009437 3C02                     cmp al, 2
  6649 00009439 0F840300                 je  @@process264
  6650 0000943D E8DEF5                   call reg16error
  6651                                  
  6652                                  ;-126                 genCode2(0x8C, dflag);
  6653                                  
  6654                                  @@process264:
  6655 00009440 A0[B901]                 mov al, byte [dflag]
  6656 00009443 B400                     mov ah, 0
  6657 00009445 50                       push ax
  6658 00009446 688C00                   push 140
  6659 00009449 E84BFB                   call genCode2
  6660 0000944C 83C404                   add  sp, 4
  6661                                  
  6662                                  ;-127                 writeEA(R2No);
  6663                                  
  6664 0000944F A0[B301]                 mov al, byte [R2No]
  6665 00009452 B400                     mov ah, 0
  6666 00009454 50                       push ax
  6667 00009455 E8EEFB                   call writeEA
  6668 00009458 83C402                   add  sp, 2
  6669                                  
  6670                                  ;-128                 return;   
  6671                                  
  6672 0000945B E9F904                   jmp @@retn
  6673                                  
  6674                                  ;-129         }          
  6675                                  
  6676                                  
  6677                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6678                                  
  6679                                  @@process263:
  6680 0000945E A0[AE01]                 mov al, [Op2]
  6681 00009461 3C04                     cmp al, 4
  6682 00009463 0F853100                 jne @@process265
  6683                                  
  6684                                  ;-131             if (Op == REG) {
  6685                                  
  6686 00009467 A0[AD01]                 mov al, [Op]
  6687 0000946A 3C02                     cmp al, 2
  6688 0000946C 0F852800                 jne @@process266
  6689                                  
  6690                                  ;-132                 if (R1No == 0) {
  6691                                  
  6692 00009470 A0[B401]                 mov al, [R1No]
  6693 00009473 3C00                     cmp al, 0
  6694 00009475 0F851F00                 jne @@process267
  6695                                  
  6696                                  ;-133                     if (isDirect) {
  6697                                  
  6698 00009479 A0[BC01]                 mov al, [isDirect]
  6699 0000947C 08C0                     or  al, al
  6700 0000947E 0F841600                 je @@process268
  6701                                  
  6702                                  ;-134                         genCodeW(0xA0);
  6703                                  
  6704 00009482 68A000                   push 160
  6705 00009485 E82AFB                   call genCodeW
  6706 00009488 83C402                   add  sp, 2
  6707                                  
  6708                                  ;-135                         genCode16(disp);
  6709                                  
  6710 0000948B FF36[BD01]               push word [disp]
  6711 0000948F E893FB                   call genCode16
  6712 00009492 83C402                   add  sp, 2
  6713                                  
  6714                                  ;-136                         return;   
  6715                                  
  6716 00009495 E9BF04                   jmp @@retn
  6717                                  
  6718                                  ;-137                     }   
  6719                                  
  6720                                  
  6721                                  ;-138                 }   
  6722                                  
  6723                                  @@process268:
  6724                                  
  6725                                  ;-139             }   
  6726                                  
  6727                                  @@process267:
  6728                                  
  6729                                  ;-140         } 
  6730                                  
  6731                                  @@process266:
  6732                                  
  6733                                  ;-141         if (Op == MEM) {//moffs16, acc
  6734                                  
  6735                                  @@process265:
  6736 00009498 A0[AD01]                 mov al, [Op]
  6737 0000949B 3C04                     cmp al, 4
  6738 0000949D 0F853100                 jne @@process269
  6739                                  
  6740                                  ;-142             if (Op2 == REG) {
  6741                                  
  6742 000094A1 A0[AE01]                 mov al, [Op2]
  6743 000094A4 3C02                     cmp al, 2
  6744 000094A6 0F852800                 jne @@process270
  6745                                  
  6746                                  ;-143                 if (R2No == 0) {
  6747                                  
  6748 000094AA A0[B301]                 mov al, [R2No]
  6749 000094AD 3C00                     cmp al, 0
  6750 000094AF 0F851F00                 jne @@process271
  6751                                  
  6752                                  ;-144                     if (isDirect) {
  6753                                  
  6754 000094B3 A0[BC01]                 mov al, [isDirect]
  6755 000094B6 08C0                     or  al, al
  6756 000094B8 0F841600                 je @@process272
  6757                                  
  6758                                  ;-145                         genCodeW(0xA2);
  6759                                  
  6760 000094BC 68A200                   push 162
  6761 000094BF E8F0FA                   call genCodeW
  6762 000094C2 83C402                   add  sp, 2
  6763                                  
  6764                                  ;-146                         genCode16(disp);
  6765                                  
  6766 000094C5 FF36[BD01]               push word [disp]
  6767 000094C9 E859FB                   call genCode16
  6768 000094CC 83C402                   add  sp, 2
  6769                                  
  6770                                  ;-147                         return;   
  6771                                  
  6772 000094CF E98504                   jmp @@retn
  6773                                  
  6774                                  ;-148                     }   
  6775                                  
  6776                                  
  6777                                  ;-149                 }   
  6778                                  
  6779                                  @@process272:
  6780                                  
  6781                                  ;-150             }
  6782                                  
  6783                                  @@process271:
  6784                                  
  6785                                  ;-151         
  6786                                  
  6787                                  
  6788                                  ;-152         }
  6789                                  
  6790                                  @@process270:
  6791                                  
  6792                                  ;-153         if (Op2 == REG) {//rm, r
  6793                                  
  6794                                  @@process269:
  6795 000094D2 A0[AE01]                 mov al, [Op2]
  6796 000094D5 3C02                     cmp al, 2
  6797 000094D7 0F851800                 jne @@process273
  6798                                  
  6799                                  ;-154             genCodeW(0x88);     
  6800                                  
  6801 000094DB 688800                   push 136
  6802 000094DE E8D1FA                   call genCodeW
  6803 000094E1 83C402                   add  sp, 2
  6804                                  
  6805                                  ;-155             writeEA(R2No);
  6806                                  
  6807 000094E4 A0[B301]                 mov al, byte [R2No]
  6808 000094E7 B400                     mov ah, 0
  6809 000094E9 50                       push ax
  6810 000094EA E859FB                   call writeEA
  6811 000094ED 83C402                   add  sp, 2
  6812                                  
  6813                                  ;-156             return;
  6814                                  
  6815 000094F0 E96404                   jmp @@retn
  6816                                  
  6817                                  ;-157         }
  6818                                  
  6819                                  
  6820                                  ;-158         if (Op2 == MEM) {//r, m
  6821                                  
  6822                                  @@process273:
  6823 000094F3 A0[AE01]                 mov al, [Op2]
  6824 000094F6 3C04                     cmp al, 4
  6825 000094F8 0F852400                 jne @@process274
  6826                                  
  6827                                  ;-159             if (Op == REG) {
  6828                                  
  6829 000094FC A0[AD01]                 mov al, [Op]
  6830 000094FF 3C02                     cmp al, 2
  6831 00009501 0F851B00                 jne @@process275
  6832                                  
  6833                                  ;-160                 ChangeDirection();
  6834                                  
  6835 00009505 E881DE                   call ChangeDirection
  6836                                  
  6837                                  ;-161                 genCodeW(0x8A);
  6838                                  
  6839 00009508 688A00                   push 138
  6840 0000950B E8A4FA                   call genCodeW
  6841 0000950E 83C402                   add  sp, 2
  6842                                  
  6843                                  ;-162                 writeEA(R2No);
  6844                                  
  6845 00009511 A0[B301]                 mov al, byte [R2No]
  6846 00009514 B400                     mov ah, 0
  6847 00009516 50                       push ax
  6848 00009517 E82CFB                   call writeEA
  6849 0000951A 83C402                   add  sp, 2
  6850                                  
  6851                                  ;-163                 return;   
  6852                                  
  6853 0000951D E93704                   jmp @@retn
  6854                                  
  6855                                  ;-164             }   
  6856                                  
  6857                                  
  6858                                  ;-165         }         
  6859                                  
  6860                                  @@process275:
  6861                                  
  6862                                  ;-166         syntaxerror();
  6863                                  
  6864                                  @@process274:
  6865 00009520 E84AF5                   call syntaxerror
  6866                                  
  6867                                  ;-167         return;
  6868                                  
  6869 00009523 E93104                   jmp @@retn
  6870                                  
  6871                                  ;-168     }    
  6872                                  
  6873                                  
  6874                                  ;-169     
  6875                                  
  6876                                  
  6877                                  ;-170     if (CodeType == 6) {//Jcc       
  6878                                  
  6879                                  @@process257:
  6880 00009526 A0[AF01]                 mov al, [CodeType]
  6881 00009529 3C06                     cmp al, 6
  6882 0000952B 0F85C100                 jne @@process276
  6883                                  
  6884                                  ;-171         if (TokeType == ALNUME) {
  6885                                  
  6886 0000952F A0[AC01]                 mov al, [TokeType]
  6887 00009532 3C03                     cmp al, 3
  6888 00009534 0F85B800                 jne @@process277
  6889                                  
  6890                                  ;-172             LabelIx=searchLabel();
  6891                                  
  6892 00009538 E865E6                   call searchLabel
  6893 0000953B A3[1F16]                 mov word [LabelIx], ax
  6894                                  
  6895                                  ;-173             if (LabelIx > 0) {
  6896                                  
  6897 0000953E A1[1F16]                 mov ax, [LabelIx]
  6898 00009541 83F800                   cmp ax, 0
  6899 00009544 0F8E7A00                 jle @@process278
  6900                                  
  6901                                  ;-174                 disp=LabelAddr[LabelIx];
  6902                                  
  6903 00009548 8B1E[1F16]               mov bx, [LabelIx]
  6904 0000954C D1E3                     shl bx, 1
  6905 0000954E 8B87[6D11]               mov ax, [LabelAddr + bx]
  6906 00009552 A3[BD01]                 mov word [disp], ax
  6907                                  
  6908                                  ;-175                 disp = disp - PC;   
  6909                                  
  6910 00009555 A1[BD01]                 mov ax, [disp]
  6911 00009558 2B06[A501]               sub ax, [PC]
  6912 0000955C A3[BD01]                 mov word [disp], ax
  6913                                  
  6914                                  ;-176                 disp = disp - Origin;
  6915                                  
  6916 0000955F A1[BD01]                 mov ax, [disp]
  6917 00009562 2B06[A701]               sub ax, [Origin]
  6918 00009566 A3[BD01]                 mov word [disp], ax
  6919                                  
  6920                                  ;-177                 if (checkConstSize(disp) ) {
  6921                                  
  6922 00009569 FF36[BD01]               push word [disp]
  6923 0000956D E828E3                   call checkConstSize
  6924 00009570 83C402                   add  sp, 2
  6925 00009573 08C0                     or  al, al
  6926 00009575 0F842000                 je @@process279
  6927                                  
  6928                                  ;-178                     genCode2(Code1, 0x70);//short       
  6929                                  
  6930 00009579 6A70                     push 112
  6931 0000957B A0[B001]                 mov al, byte [Code1]
  6932 0000957E B400                     mov ah, 0
  6933 00009580 50                       push ax
  6934 00009581 E813FA                   call genCode2
  6935 00009584 83C404                   add  sp, 4
  6936                                  
  6937                                  ;-179                     disp -= 2; 
  6938                                  
  6939 00009587 832E[BD01]02             sub  word [disp], 2
  6940                                  
  6941                                  ;-180                     genCode8(disp);   
  6942                                  
  6943 0000958C FF36[BD01]               push word [disp]
  6944 00009590 E83BFA                   call genCode8
  6945 00009593 83C402                   add  sp, 2
  6946                                  
  6947                                  ;-181                 } else {     
  6948                                  
  6949 00009596 E92600                   jmp @@process280
  6950                                  @@process279:
  6951                                  
  6952                                  ;-182                     genCode8(0x0F);
  6953                                  
  6954 00009599 6A0F                     push 15
  6955 0000959B E830FA                   call genCode8
  6956 0000959E 83C402                   add  sp, 2
  6957                                  
  6958                                  ;-183                     genCode2(Code1, 0x80);//near       
  6959                                  
  6960 000095A1 688000                   push 128
  6961 000095A4 A0[B001]                 mov al, byte [Code1]
  6962 000095A7 B400                     mov ah, 0
  6963 000095A9 50                       push ax
  6964 000095AA E8EAF9                   call genCode2
  6965 000095AD 83C404                   add  sp, 4
  6966                                  
  6967                                  ;-184                     disp -= 4; 
  6968                                  
  6969 000095B0 832E[BD01]04             sub  word [disp], 4
  6970                                  
  6971                                  ;-185                     genCode16(disp);                       
  6972                                  
  6973 000095B5 FF36[BD01]               push word [disp]
  6974 000095B9 E869FA                   call genCode16
  6975 000095BC 83C402                   add  sp, 2
  6976                                  
  6977                                  ;-186                 }    
  6978                                  
  6979                                  
  6980                                  ;-187             }
  6981                                  
  6982                                  @@process280:
  6983                                  
  6984                                  ;-188             else {//jump forward, near only
  6985                                  
  6986 000095BF E92B00                   jmp @@process281
  6987                                  @@process278:
  6988                                  
  6989                                  ;-189                 genCode8(0x0F);
  6990                                  
  6991 000095C2 6A0F                     push 15
  6992 000095C4 E807FA                   call genCode8
  6993 000095C7 83C402                   add  sp, 2
  6994                                  
  6995                                  ;-190                 genCode2(Code1, 0x80);
  6996                                  
  6997 000095CA 688000                   push 128
  6998 000095CD A0[B001]                 mov al, byte [Code1]
  6999 000095D0 B400                     mov ah, 0
  7000 000095D2 50                       push ax
  7001 000095D3 E8C1F9                   call genCode2
  7002 000095D6 83C404                   add  sp, 4
  7003                                  
  7004                                  ;-191                 genCode16(0);
  7005                                  
  7006 000095D9 6A00                     push 0
  7007 000095DB E847FA                   call genCode16
  7008 000095DE 83C402                   add  sp, 2
  7009                                  
  7010                                  ;-192                 PrintRA='*';
  7011                                  
  7012 000095E1 66B82A000000             mov eax, 42
  7013 000095E7 A2[CA01]                 mov byte [PrintRA], al
  7014                                  
  7015                                  ;-193                 storeJmpCall();
  7016                                  
  7017 000095EA E887E4                   call storeJmpCall
  7018                                  
  7019                                  ;-194             }   
  7020                                  
  7021                                  
  7022                                  ;-195         return; 
  7023                                  
  7024                                  @@process281:
  7025 000095ED E96703                   jmp @@retn
  7026                                  
  7027                                  ;-196         }  
  7028                                  
  7029                                  
  7030                                  ;-197     }
  7031                                  
  7032                                  @@process277:
  7033                                  
  7034                                  ;-198 
  7035                                  
  7036                                  
  7037                                  ;-199     if (CodeType == 7) {//jmp, call
  7038                                  
  7039                                  @@process276:
  7040 000095F0 A0[AF01]                 mov al, [CodeType]
  7041 000095F3 3C07                     cmp al, 7
  7042 000095F5 0F85CD00                 jne @@process282
  7043                                  
  7044                                  ;-200         if (TokeType == ALNUME) {
  7045                                  
  7046 000095F9 A0[AC01]                 mov al, [TokeType]
  7047 000095FC 3C03                     cmp al, 3
  7048 000095FE 0F85C400                 jne @@process283
  7049                                  
  7050                                  ;-201             LabelIx=searchLabel();
  7051                                  
  7052 00009602 E89BE5                   call searchLabel
  7053 00009605 A3[1F16]                 mov word [LabelIx], ax
  7054                                  
  7055                                  ;-202             if (LabelIx > 0) {
  7056                                  
  7057 00009608 A1[1F16]                 mov ax, [LabelIx]
  7058 0000960B 83F800                   cmp ax, 0
  7059 0000960E 0F8E9100                 jle @@process284
  7060                                  
  7061                                  ;-203                 disp=LabelAddr[LabelIx];
  7062                                  
  7063 00009612 8B1E[1F16]               mov bx, [LabelIx]
  7064 00009616 D1E3                     shl bx, 1
  7065 00009618 8B87[6D11]               mov ax, [LabelAddr + bx]
  7066 0000961C A3[BD01]                 mov word [disp], ax
  7067                                  
  7068                                  ;-204                 disp = disp - PC;   
  7069                                  
  7070 0000961F A1[BD01]                 mov ax, [disp]
  7071 00009622 2B06[A501]               sub ax, [PC]
  7072 00009626 A3[BD01]                 mov word [disp], ax
  7073                                  
  7074                                  ;-205                 disp = disp - Origin;
  7075                                  
  7076 00009629 A1[BD01]                 mov ax, [disp]
  7077 0000962C 2B06[A701]               sub ax, [Origin]
  7078 00009630 A3[BD01]                 mov word [disp], ax
  7079                                  
  7080                                  ;-206                 if (checkConstSize(disp) ) {
  7081                                  
  7082 00009633 FF36[BD01]               push word [disp]
  7083 00009637 E85EE2                   call checkConstSize
  7084 0000963A 83C402                   add  sp, 2
  7085 0000963D 08C0                     or  al, al
  7086 0000963F 0F844200                 je @@process285
  7087                                  
  7088                                  ;-207                     if (Code1 == 0xE9) {//jmp only
  7089                                  
  7090 00009643 A0[B001]                 mov al, [Code1]
  7091 00009646 3CE9                     cmp al, 233
  7092 00009648 0F851B00                 jne @@process286
  7093                                  
  7094                                  ;-208                         genCode8(0xEB);//short       
  7095                                  
  7096 0000964C 68EB00                   push 235
  7097 0000964F E87CF9                   call genCode8
  7098 00009652 83C402                   add  sp, 2
  7099                                  
  7100                                  ;-209                         disp -= 2; 
  7101                                  
  7102 00009655 832E[BD01]02             sub  word [disp], 2
  7103                                  
  7104                                  ;-210                         genCode8(disp);
  7105                                  
  7106 0000965A FF36[BD01]               push word [disp]
  7107 0000965E E86DF9                   call genCode8
  7108 00009661 83C402                   add  sp, 2
  7109                                  
  7110                                  ;-211                     } 
  7111                                  
  7112                                  
  7113                                  ;-212                     else {     
  7114                                  
  7115 00009664 E91B00                   jmp @@process287
  7116                                  @@process286:
  7117                                  
  7118                                  ;-213                         genCode8(Code1);//near    
  7119                                  
  7120 00009667 A0[B001]                 mov al, byte [Code1]
  7121 0000966A B400                     mov ah, 0
  7122 0000966C 50                       push ax
  7123 0000966D E85EF9                   call genCode8
  7124 00009670 83C402                   add  sp, 2
  7125                                  
  7126                                  ;-214                         disp -= 3; 
  7127                                  
  7128 00009673 832E[BD01]03             sub  word [disp], 3
  7129                                  
  7130                                  ;-215                         genCode16(disp);                       
  7131                                  
  7132 00009678 FF36[BD01]               push word [disp]
  7133 0000967C E8A6F9                   call genCode16
  7134 0000967F 83C402                   add  sp, 2
  7135                                  
  7136                                  ;-216                     }    
  7137                                  
  7138                                  
  7139                                  ;-217                 } 
  7140                                  
  7141                                  @@process287:
  7142                                  
  7143                                  ;-218                 else {     
  7144                                  
  7145 00009682 E91B00                   jmp @@process288
  7146                                  @@process285:
  7147                                  
  7148                                  ;-219                     genCode8(Code1);//near    
  7149                                  
  7150 00009685 A0[B001]                 mov al, byte [Code1]
  7151 00009688 B400                     mov ah, 0
  7152 0000968A 50                       push ax
  7153 0000968B E840F9                   call genCode8
  7154 0000968E 83C402                   add  sp, 2
  7155                                  
  7156                                  ;-220                     disp -= 3; 
  7157                                  
  7158 00009691 832E[BD01]03             sub  word [disp], 3
  7159                                  
  7160                                  ;-221                     genCode16(disp);                       
  7161                                  
  7162 00009696 FF36[BD01]               push word [disp]
  7163 0000969A E888F9                   call genCode16
  7164 0000969D 83C402                   add  sp, 2
  7165                                  
  7166                                  ;-222                 }    
  7167                                  
  7168                                  
  7169                                  ;-223             }
  7170                                  
  7171                                  @@process288:
  7172                                  
  7173                                  ;-224             else {//jump forward, near only
  7174                                  
  7175 000096A0 E92000                   jmp @@process289
  7176                                  @@process284:
  7177                                  
  7178                                  ;-225                 genCode8(Code1);
  7179                                  
  7180 000096A3 A0[B001]                 mov al, byte [Code1]
  7181 000096A6 B400                     mov ah, 0
  7182 000096A8 50                       push ax
  7183 000096A9 E822F9                   call genCode8
  7184 000096AC 83C402                   add  sp, 2
  7185                                  
  7186                                  ;-226                 genCode16(0);
  7187                                  
  7188 000096AF 6A00                     push 0
  7189 000096B1 E871F9                   call genCode16
  7190 000096B4 83C402                   add  sp, 2
  7191                                  
  7192                                  ;-227                 PrintRA='*';
  7193                                  
  7194 000096B7 66B82A000000             mov eax, 42
  7195 000096BD A2[CA01]                 mov byte [PrintRA], al
  7196                                  
  7197                                  ;-228                 storeJmpCall();
  7198                                  
  7199 000096C0 E8B1E3                   call storeJmpCall
  7200                                  
  7201                                  ;-229             }   
  7202                                  
  7203                                  
  7204                                  ;-230         return; 
  7205                                  
  7206                                  @@process289:
  7207 000096C3 E99102                   jmp @@retn
  7208                                  
  7209                                  ;-231         }
  7210                                  
  7211                                  
  7212                                  ;-232     }
  7213                                  
  7214                                  @@process283:
  7215                                  
  7216                                  ;-233     
  7217                                  
  7218                                  
  7219                                  ;-234     if (CodeType ==  8) {//ret,retf
  7220                                  
  7221                                  @@process282:
  7222 000096C6 A0[AF01]                 mov al, [CodeType]
  7223 000096C9 3C08                     cmp al, 8
  7224 000096CB 0F853100                 jne @@process290
  7225                                  
  7226                                  ;-235         if (TokeType == DIGIT) {
  7227                                  
  7228 000096CF A0[AC01]                 mov al, [TokeType]
  7229 000096D2 3C01                     cmp al, 1
  7230 000096D4 0F851900                 jne @@process291
  7231                                  
  7232                                  ;-236             genCode8(Code2);
  7233                                  
  7234 000096D8 A0[B101]                 mov al, byte [Code2]
  7235 000096DB B400                     mov ah, 0
  7236 000096DD 50                       push ax
  7237 000096DE E8EDF8                   call genCode8
  7238 000096E1 83C402                   add  sp, 2
  7239                                  
  7240                                  ;-237             genCode16(SymbolInt);
  7241                                  
  7242 000096E4 FF36[4C00]               push word [SymbolInt]
  7243 000096E8 E83AF9                   call genCode16
  7244 000096EB 83C402                   add  sp, 2
  7245                                  
  7246                                  ;-238             return;
  7247                                  
  7248 000096EE E96602                   jmp @@retn
  7249                                  
  7250                                  ;-239         }
  7251                                  
  7252                                  
  7253                                  ;-240         genCode8(Code1); 
  7254                                  
  7255                                  @@process291:
  7256 000096F1 A0[B001]                 mov al, byte [Code1]
  7257 000096F4 B400                     mov ah, 0
  7258 000096F6 50                       push ax
  7259 000096F7 E8D4F8                   call genCode8
  7260 000096FA 83C402                   add  sp, 2
  7261                                  
  7262                                  ;-241         return;
  7263                                  
  7264 000096FD E95702                   jmp @@retn
  7265                                  
  7266                                  ;-242     }
  7267                                  
  7268                                  
  7269                                  ;-243        
  7270                                  
  7271                                  
  7272                                  ;-244     if (CodeType == 9) {//push, pop  
  7273                                  
  7274                                  @@process290:
  7275 00009700 A0[AF01]                 mov al, [CodeType]
  7276 00009703 3C09                     cmp al, 9
  7277 00009705 0F850301                 jne @@process292
  7278                                  
  7279                                  ;-245         getOpL();
  7280                                  
  7281 00009709 E89FDD                   call getOpL
  7282                                  
  7283                                  ;-246         if (Code1 == 0x50) {//push only
  7284                                  
  7285 0000970C A0[B001]                 mov al, [Code1]
  7286 0000970F 3C50                     cmp al, 80
  7287 00009711 0F853D00                 jne @@process293
  7288                                  
  7289                                  ;-247             if (Op == IMM) {//push imm8,16
  7290                                  
  7291 00009715 A0[AD01]                 mov al, [Op]
  7292 00009718 3C01                     cmp al, 1
  7293 0000971A 0F853400                 jne @@process294
  7294                                  
  7295                                  ;-248                 setsflag();
  7296                                  
  7297 0000971E E812E1                   call setsflag
  7298                                  
  7299                                  ;-249                 genCode2(0x68, sflag);     
  7300                                  
  7301 00009721 A0[BA01]                 mov al, byte [sflag]
  7302 00009724 B400                     mov ah, 0
  7303 00009726 50                       push ax
  7304 00009727 6A68                     push 104
  7305 00009729 E86BF8                   call genCode2
  7306 0000972C 83C404                   add  sp, 4
  7307                                  
  7308                                  ;-250                 if (sflag) genCode8 (imme);
  7309                                  
  7310 0000972F A0[BA01]                 mov al, [sflag]
  7311 00009732 08C0                     or  al, al
  7312 00009734 0F840D00                 je @@process295
  7313 00009738 FF36[BF01]               push word [imme]
  7314 0000973C E88FF8                   call genCode8
  7315 0000973F 83C402                   add  sp, 2
  7316                                  
  7317                                  ;-251                 else       genCode16(imme);    
  7318                                  
  7319 00009742 E90A00                   jmp @@process296
  7320                                  @@process295:
  7321 00009745 FF36[BF01]               push word [imme]
  7322 00009749 E8D9F8                   call genCode16
  7323 0000974C 83C402                   add  sp, 2
  7324                                  
  7325                                  ;-252                 return;   
  7326                                  
  7327                                  @@process296:
  7328 0000974F E90502                   jmp @@retn
  7329                                  
  7330                                  ;-253             }   
  7331                                  
  7332                                  
  7333                                  ;-254         }
  7334                                  
  7335                                  @@process294:
  7336                                  
  7337                                  ;-255         if (R1Type == SEGREG) {
  7338                                  
  7339                                  @@process293:
  7340 00009752 A0[B601]                 mov al, [R1Type]
  7341 00009755 3C04                     cmp al, 4
  7342 00009757 0F855A00                 jne @@process297
  7343                                  
  7344                                  ;-256             if (Code1 == 0x58) {
  7345                                  
  7346 0000975B A0[B001]                 mov al, [Code1]
  7347 0000975E 3C58                     cmp al, 88
  7348 00009760 0F851200                 jne @@process298
  7349                                  
  7350                                  ;-257                 if (R1No == 1) error1("pop cs not allowed");   
  7351                                  
  7352 00009764 A0[B401]                 mov al, [R1No]
  7353 00009767 3C01                     cmp al, 1
  7354 00009769 0F850900                 jne @@process299
  7355 0000976D 68[5999]                 push process_0
  7356 00009770 E83BF1                   call error1
  7357 00009773 83C402                   add  sp, 2
  7358                                  
  7359                                  ;-258             }
  7360                                  
  7361                                  @@process299:
  7362                                  
  7363                                  ;-259             c = R1No <<3;
  7364                                  
  7365                                  @@process298:
  7366 00009776 A0[B401]                 mov al, [R1No]
  7367 00009779 C0E003                   shl al, 3
  7368 0000977C 8846FE                   mov byte [bp-2], al
  7369                                  
  7370                                  ;-260             if (R1No > 3) {//FS, GS
  7371                                  
  7372 0000977F A0[B401]                 mov al, [R1No]
  7373 00009782 3C03                     cmp al, 3
  7374 00009784 0F8E0C00                 jle @@process300
  7375                                  
  7376                                  ;-261                 c += 122;
  7377                                  
  7378 00009788 8046FE7A                 add  byte [bp-2], 122
  7379                                  
  7380                                  ;-262                 genCode8(0x0F);
  7381                                  
  7382 0000978C 6A0F                     push 15
  7383 0000978E E83DF8                   call genCode8
  7384 00009791 83C402                   add  sp, 2
  7385                                  
  7386                                  ;-263             }
  7387                                  
  7388                                  
  7389                                  ;-264             OpCodePtr++;
  7390                                  
  7391                                  @@process300:
  7392 00009794 FF06[C801]               inc  word [OpCodePtr]
  7393                                  
  7394                                  ;-265             c = c + *OpCodePtr;//is Code4   
  7395                                  
  7396 00009798 8A46FE                   mov al, [bp-2]
  7397 0000979B 8B1E[C801]               mov bx, [OpCodePtr]
  7398 0000979F 0207                     add al, [bx]
  7399 000097A1 B400                     mov ah, 0
  7400 000097A3 8846FE                   mov byte [bp-2], al
  7401                                  
  7402                                  ;-266             genCode8(c);  
  7403                                  
  7404 000097A6 8A46FE                   mov al, byte [bp-2]
  7405 000097A9 B400                     mov ah, 0
  7406 000097AB 50                       push ax
  7407 000097AC E81FF8                   call genCode8
  7408 000097AF 83C402                   add  sp, 2
  7409                                  
  7410                                  ;-267             return; 
  7411                                  
  7412 000097B2 E9A201                   jmp @@retn
  7413                                  
  7414                                  ;-268         }  
  7415                                  
  7416                                  
  7417                                  ;-269         checkOpL();    
  7418                                  
  7419                                  @@process297:
  7420 000097B5 E816DC                   call checkOpL
  7421                                  
  7422                                  ;-270         if (R1Type == BYTE) reg16error();
  7423                                  
  7424 000097B8 A0[B601]                 mov al, [R1Type]
  7425 000097BB 3C01                     cmp al, 1
  7426 000097BD 0F850300                 jne @@process301
  7427 000097C1 E85AF2                   call reg16error
  7428                                  
  7429                                  ;-271         if (R1Type == WORD) {
  7430                                  
  7431                                  @@process301:
  7432 000097C4 A0[B601]                 mov al, [R1Type]
  7433 000097C7 3C02                     cmp al, 2
  7434 000097C9 0F851500                 jne @@process302
  7435                                  
  7436                                  ;-272             genCode2(Code1, R1No);
  7437                                  
  7438 000097CD A0[B401]                 mov al, byte [R1No]
  7439 000097D0 B400                     mov ah, 0
  7440 000097D2 50                       push ax
  7441 000097D3 A0[B001]                 mov al, byte [Code1]
  7442 000097D6 B400                     mov ah, 0
  7443 000097D8 50                       push ax
  7444 000097D9 E8BBF7                   call genCode2
  7445 000097DC 83C404                   add  sp, 4
  7446                                  
  7447                                  ;-273             return;   
  7448                                  
  7449 000097DF E97501                   jmp @@retn
  7450                                  
  7451                                  ;-274         }                
  7452                                  
  7453                                  
  7454                                  ;-275         if (Op == MEM) {
  7455                                  
  7456                                  @@process302:
  7457 000097E2 A0[AD01]                 mov al, [Op]
  7458 000097E5 3C04                     cmp al, 4
  7459 000097E7 0F851B00                 jne @@process303
  7460                                  
  7461                                  ;-276             genCode8(Code2);
  7462                                  
  7463 000097EB A0[B101]                 mov al, byte [Code2]
  7464 000097EE B400                     mov ah, 0
  7465 000097F0 50                       push ax
  7466 000097F1 E8DAF7                   call genCode8
  7467 000097F4 83C402                   add  sp, 2
  7468                                  
  7469                                  ;-277             writeEA(Code3);
  7470                                  
  7471 000097F7 A0[B201]                 mov al, byte [Code3]
  7472 000097FA B400                     mov ah, 0
  7473 000097FC 50                       push ax
  7474 000097FD E846F8                   call writeEA
  7475 00009800 83C402                   add  sp, 2
  7476                                  
  7477                                  ;-278             return;   
  7478                                  
  7479 00009803 E95101                   jmp @@retn
  7480                                  
  7481                                  ;-279         }
  7482                                  
  7483                                  
  7484                                  ;-280         syntaxerror();
  7485                                  
  7486                                  @@process303:
  7487 00009806 E864F2                   call syntaxerror
  7488                                  
  7489                                  ;-281         return;        
  7490                                  
  7491 00009809 E94B01                   jmp @@retn
  7492                                  
  7493                                  ;-282     }
  7494                                  
  7495                                  
  7496                                  ;-283     
  7497                                  
  7498                                  
  7499                                  ;-284     if (CodeType == 11) {//shift, rotate
  7500                                  
  7501                                  @@process292:
  7502 0000980C A0[AF01]                 mov al, [CodeType]
  7503 0000980F 3C0B                     cmp al, 11
  7504 00009811 0F859500                 jne @@process304
  7505                                  
  7506                                  ;-285         check2Ops();
  7507                                  
  7508 00009815 E838DC                   call check2Ops
  7509                                  
  7510                                  ;-286         if (Op2 == IMM) {
  7511                                  
  7512 00009818 A0[AE01]                 mov al, [Op2]
  7513 0000981B 3C01                     cmp al, 1
  7514 0000981D 0F854400                 jne @@process305
  7515                                  
  7516                                  ;-287             if (imme == 1) {
  7517                                  
  7518 00009821 A1[BF01]                 mov ax, [imme]
  7519 00009824 83F801                   cmp ax, 1
  7520 00009827 0F851800                 jne @@process306
  7521                                  
  7522                                  ;-288                 genCodeW(0xD0);
  7523                                  
  7524 0000982B 68D000                   push 208
  7525 0000982E E881F7                   call genCodeW
  7526 00009831 83C402                   add  sp, 2
  7527                                  
  7528                                  ;-289                 writeEA(Code1);
  7529                                  
  7530 00009834 A0[B001]                 mov al, byte [Code1]
  7531 00009837 B400                     mov ah, 0
  7532 00009839 50                       push ax
  7533 0000983A E809F8                   call writeEA
  7534 0000983D 83C402                   add  sp, 2
  7535                                  
  7536                                  ;-290                 return;
  7537                                  
  7538 00009840 E91401                   jmp @@retn
  7539                                  
  7540                                  ;-291             }
  7541                                  
  7542                                  
  7543                                  ;-292             genCodeW(0xC0);//80186
  7544                                  
  7545                                  @@process306:
  7546 00009843 68C000                   push 192
  7547 00009846 E869F7                   call genCodeW
  7548 00009849 83C402                   add  sp, 2
  7549                                  
  7550                                  ;-293             writeEA(Code1);
  7551                                  
  7552 0000984C A0[B001]                 mov al, byte [Code1]
  7553 0000984F B400                     mov ah, 0
  7554 00009851 50                       push ax
  7555 00009852 E8F1F7                   call writeEA
  7556 00009855 83C402                   add  sp, 2
  7557                                  
  7558                                  ;-294             genCode8(imme);
  7559                                  
  7560 00009858 FF36[BF01]               push word [imme]
  7561 0000985C E86FF7                   call genCode8
  7562 0000985F 83C402                   add  sp, 2
  7563                                  
  7564                                  ;-295             return;    
  7565                                  
  7566 00009862 E9F200                   jmp @@retn
  7567                                  
  7568                                  ;-296         }
  7569                                  
  7570                                  
  7571                                  ;-297         if (Op2 == REG) {
  7572                                  
  7573                                  @@process305:
  7574 00009865 A0[AE01]                 mov al, [Op2]
  7575 00009868 3C02                     cmp al, 2
  7576 0000986A 0F853C00                 jne @@process307
  7577                                  
  7578                                  ;-298             if (R2Type == BYTE) {
  7579                                  
  7580 0000986E A0[B501]                 mov al, [R2Type]
  7581 00009871 3C01                     cmp al, 1
  7582 00009873 0F853300                 jne @@process308
  7583                                  
  7584                                  ;-299                 if (R2No == 1) {//CL-REG 
  7585                                  
  7586 00009877 A0[B301]                 mov al, [R2No]
  7587 0000987A 3C01                     cmp al, 1
  7588 0000987C 0F852A00                 jne @@process309
  7589                                  
  7590                                  ;-300                     if (R1Type == WORD) wflag=1;//hack
  7591                                  
  7592 00009880 A0[B601]                 mov al, [R1Type]
  7593 00009883 3C02                     cmp al, 2
  7594 00009885 0F850900                 jne @@process310
  7595 00009889 66B801000000             mov eax, 1
  7596 0000988F A2[B801]                 mov byte [wflag], al
  7597                                  
  7598                                  ;-301                     genCodeW(0xD2);
  7599                                  
  7600                                  @@process310:
  7601 00009892 68D200                   push 210
  7602 00009895 E81AF7                   call genCodeW
  7603 00009898 83C402                   add  sp, 2
  7604                                  
  7605                                  ;-302                     writeEA(Code1);
  7606                                  
  7607 0000989B A0[B001]                 mov al, byte [Code1]
  7608 0000989E B400                     mov ah, 0
  7609 000098A0 50                       push ax
  7610 000098A1 E8A2F7                   call writeEA
  7611 000098A4 83C402                   add  sp, 2
  7612                                  
  7613                                  ;-303                     return;   
  7614                                  
  7615 000098A7 E9AD00                   jmp @@retn
  7616                                  
  7617                                  ;-304                 }   
  7618                                  
  7619                                  
  7620                                  ;-305             }
  7621                                  
  7622                                  @@process309:
  7623                                  
  7624                                  ;-306         }    
  7625                                  
  7626                                  @@process308:
  7627                                  
  7628                                  ;-307     }     
  7629                                  
  7630                                  @@process307:
  7631                                  
  7632                                  ;-308     
  7633                                  
  7634                                  
  7635                                  ;-309     if (CodeType == 12) {//int
  7636                                  
  7637                                  @@process304:
  7638 000098AA A0[AF01]                 mov al, [CodeType]
  7639 000098AD 3C0C                     cmp al, 12
  7640 000098AF 0F852200                 jne @@process311
  7641                                  
  7642                                  ;-310         if (TokeType == DIGIT) {            
  7643                                  
  7644 000098B3 A0[AC01]                 mov al, [TokeType]
  7645 000098B6 3C01                     cmp al, 1
  7646 000098B8 0F851900                 jne @@process312
  7647                                  
  7648                                  ;-311             genCode8(Code1);
  7649                                  
  7650 000098BC A0[B001]                 mov al, byte [Code1]
  7651 000098BF B400                     mov ah, 0
  7652 000098C1 50                       push ax
  7653 000098C2 E809F7                   call genCode8
  7654 000098C5 83C402                   add  sp, 2
  7655                                  
  7656                                  ;-312             genCode8(SymbolInt);
  7657                                  
  7658 000098C8 FF36[4C00]               push word [SymbolInt]
  7659 000098CC E8FFF6                   call genCode8
  7660 000098CF 83C402                   add  sp, 2
  7661                                  
  7662                                  ;-313             return;   
  7663                                  
  7664 000098D2 E98200                   jmp @@retn
  7665                                  
  7666                                  ;-314         }
  7667                                  
  7668                                  
  7669                                  ;-315     }
  7670                                  
  7671                                  @@process312:
  7672                                  
  7673                                  ;-316     
  7674                                  
  7675                                  
  7676                                  ;-317     if (CodeType == 30) {//enter i18,i8
  7677                                  
  7678                                  @@process311:
  7679 000098D5 A0[AF01]                 mov al, [CodeType]
  7680 000098D8 3C1E                     cmp al, 30
  7681 000098DA 0F855200                 jne @@process313
  7682                                  
  7683                                  ;-318         genCode8(0xC8);
  7684                                  
  7685 000098DE 68C800                   push 200
  7686 000098E1 E8EAF6                   call genCode8
  7687 000098E4 83C402                   add  sp, 2
  7688                                  
  7689                                  ;-319         Op=getOp1();
  7690                                  
  7691 000098E7 E87EDC                   call getOp1
  7692 000098EA A2[AD01]                 mov byte [Op], al
  7693                                  
  7694                                  ;-320         if (Op == IMM) genCode16(SymbolInt);
  7695                                  
  7696 000098ED A0[AD01]                 mov al, [Op]
  7697 000098F0 3C01                     cmp al, 1
  7698 000098F2 0F850D00                 jne @@process314
  7699 000098F6 FF36[4C00]               push word [SymbolInt]
  7700 000098FA E828F7                   call genCode16
  7701 000098FD 83C402                   add  sp, 2
  7702                                  
  7703                                  ;-321         else numbererror();
  7704                                  
  7705 00009900 E90300                   jmp @@process315
  7706                                  @@process314:
  7707 00009903 E8D4F0                   call numbererror
  7708                                  
  7709                                  ;-322         need(',');
  7710                                  
  7711                                  @@process315:
  7712 00009906 6A2C                     push 44
  7713 00009908 E87AE5                   call need
  7714 0000990B 83C402                   add  sp, 2
  7715                                  
  7716                                  ;-323         Op=getOp1();
  7717                                  
  7718 0000990E E857DC                   call getOp1
  7719 00009911 A2[AD01]                 mov byte [Op], al
  7720                                  
  7721                                  ;-324         if (Op == IMM) genCode8 (SymbolInt);
  7722                                  
  7723 00009914 A0[AD01]                 mov al, [Op]
  7724 00009917 3C01                     cmp al, 1
  7725 00009919 0F850D00                 jne @@process316
  7726 0000991D FF36[4C00]               push word [SymbolInt]
  7727 00009921 E8AAF6                   call genCode8
  7728 00009924 83C402                   add  sp, 2
  7729                                  
  7730                                  ;-325         else numbererror();           
  7731                                  
  7732 00009927 E90300                   jmp @@process317
  7733                                  @@process316:
  7734 0000992A E8ADF0                   call numbererror
  7735                                  
  7736                                  ;-326         return;
  7737                                  
  7738                                  @@process317:
  7739 0000992D E92700                   jmp @@retn
  7740                                  
  7741                                  ;-327     }
  7742                                  
  7743                                  
  7744                                  ;-328        
  7745                                  
  7746                                  
  7747                                  ;-329     if (CodeType==101) {// ORG nn
  7748                                  
  7749                                  @@process313:
  7750 00009930 A0[AF01]                 mov al, [CodeType]
  7751 00009933 3C65                     cmp al, 101
  7752 00009935 0F851500                 jne @@process318
  7753                                  
  7754                                  ;-330         if (TokeType != DIGIT) numbererror();
  7755                                  
  7756 00009939 A0[AC01]                 mov al, [TokeType]
  7757 0000993C 3C01                     cmp al, 1
  7758 0000993E 0F840300                 je  @@process319
  7759 00009942 E895F0                   call numbererror
  7760                                  
  7761                                  ;-331         Origin=SymbolInt;
  7762                                  
  7763                                  @@process319:
  7764 00009945 A1[4C00]                 mov ax, [SymbolInt]
  7765 00009948 A3[A701]                 mov word [Origin], ax
  7766                                  
  7767                                  ;-332         return;
  7768                                  
  7769 0000994B E90900                   jmp @@retn
  7770                                  
  7771                                  ;-333     }
  7772                                  
  7773                                  
  7774                                  ;-334     error1("Command not implemented or syntax error");
  7775                                  
  7776                                  @@process318:
  7777 0000994E 68[6C99]                 push process_1
  7778 00009951 E85AEF                   call error1
  7779 00009954 83C402                   add  sp, 2
  7780                                  
  7781                                  ;-335 }    
  7782                                  
  7783 00009957 C9                      @@retn: LEAVE
  7784 00009958 C3                       ret
  7785                                  ; ENDP
  7786 00009959 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  7787 00009962 7420616C6C6F776564-
  7788 0000996B 00                 
  7789 0000996C 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  7790 00009975 6F7420696D706C656D-
  7791 0000997E 656E746564206F7220-
  7792 00009987 73796E746178206572-
  7793 00009990 726F7200           
  7794                                   
  7795                                  ; missing functions: 
  7796                                  ; digit
  7797                                  ; strcpy
  7798                                  ; strcpy
  7799                                  ; eqstr
  7800                                  ; strlen
  7801                                  ; eqstr
  7802                                  ; eqstr
  7803                                  ; eqstr
  7804                                  ; eqstr
  7805                                  ; readRL
  7806                                  ; readRL
  7807                                  ; digit
  7808                                  ; digit
  7809                                  ; strcpy
  7810                                  ; toupper
  7811                                  ; strlen
  7812                                  ; strlen
  7813                                  ; eqstr
  7814                                  ; eqstr
  7815                                  ; eqstr
  7816                                  ; eqstr
  7817                                  ; eqstr
  7818                                  ; eqstr
  7819                                  ; eqstr
  7820                                  ; eqstr
  7821                                  ; eqstr
  7822                                  ; eqstr
  7823                                  ; eqstr
  7824                                  ; eqstr
  7825                                  ; eqstr
  7826                                  ; eqstr
  7827                                  ; eqstr
  7828                                  ; eqstr
  7829                                  ; eqstr
  7830                                  ; eqstr
  7831                                  ; eqstr
  7832                                  ; eqstr
  7833                                  ; eqstr
  7834                                  ; eqstr
  7835                                  ; eqstr
  7836                                  ; eqstr
  7837                                  ; eqstr
  7838                                  ; eqstr
  7839                                  ; eqstr
  7840                                  ; eqstr
  7841                                  ; eqstr
  7842                                  ; eqstr
  7843                                  ; writetty
  7844                                  ; writetty
  7845                                  ; fputcR
  7846                                  ; cputs
  7847                                  ; cputs
  7848                                  ; exitR
  7849                                  ; toupper
  7850                                  ; strcpy
  7851                                  ; strcat1
  7852                                  ; strcpy
  7853                                  ; strcat1
  7854                                  ; strcpy
  7855                                  ; strcat1
  7856                                  ; openR
  7857                                  ; cputs
  7858                                  ; cputs
  7859                                  ; exitR
  7860                                  ; creatR
  7861                                  ; cputs
  7862                                  ; cputs
  7863                                  ; exitR
  7864                                  ; creatR
  7865                                  ; cputs
  7866                                  ; cputs
  7867                                  ; exitR
  7868                                  ; strcpy
  7869                                  ; strlen
  7870                                  ; fputcR
  7871                                  ; fcloseR
  7872                                  ; fcloseR
  7873                                  ; fcloseR
  7874                                  ; exitR
  7875                                  ; Number of unresolved CALLs :   79
  7876                                  ;use archive file: AR.C
  7877                                  
  7878                                  ;-336 // AR.C Archive
  7879                                  
  7880                                  ;Number of CALLs:    2 : writetty
  7881                                  
  7882                                  writetty:  ; *** PROC ***
  7883 00009994 B40E                     mov  ah, 14
  7884 00009996 BB0000                   mov  bx, 0
  7885 00009999 CD10                     int  16
  7886                                  
  7887                                  ;-337 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  7888                                  
  7889 0000999B C3                       ret
  7890                                  ; ENDP
  7891                                  ;Number of CALLs:    8 : cputs
  7892                                  
  7893                                  cputs:  ; *** PROC ***
  7894                                  ;Function : cputs, Number of local variables: 2
  7895                                  ;   # type sign width line used address name   list of local variables
  7896                                  ;  200 ptr sign byte   337 NULL bp+4    s
  7897                                  ;  201 var sign byte   337 NULL bp-2    c;
  7898 0000999C C8020000                 ENTER  2,0
  7899                                  @@cputs320:
  7900 000099A0 8B5E04                   mov bx, [bp+4]
  7901 000099A3 8A07                     mov al, [bx]
  7902 000099A5 B400                     mov ah, 0
  7903 000099A7 08C0                     or  al, al
  7904 000099A9 0F841B00                 je @@cputs321
  7905 000099AD 8B5E04                   mov bx, [bp+4]
  7906 000099B0 8A07                     mov al, [bx]
  7907 000099B2 B400                     mov ah, 0
  7908 000099B4 8846FE                   mov byte [bp-2], al
  7909 000099B7 8A46FE                   mov al, byte [bp-2]
  7910 000099BA B400                     mov ah, 0
  7911 000099BC 50                       push ax
  7912 000099BD E8C401                   call putch
  7913 000099C0 83C402                   add  sp, 2
  7914 000099C3 FF4604                   inc  word [bp+4]
  7915 000099C6 EBD8                     jmp @@cputs320
  7916                                  @@cputs321:
  7917                                  
  7918                                  ;-338 int mkneg(int n) { n; __asm {neg ax} }
  7919 000099C8 C9                       LEAVE
  7920 000099C9 C3                       ret
  7921                                  ; ENDP
  7922                                  ;Number of CALLs:    2 : toupper
  7923                                  
  7924                                  toupper:  ; *** PROC ***
  7925                                  ;Function : toupper, Number of local variables: 1
  7926                                  ;   # type sign width line used address name   list of local variables
  7927                                  ;  200 ptr sign byte   338 NULL bp+4    s;
  7928 000099CA C8000000                 ENTER  0,0
  7929                                  @@toupper322:
  7930 000099CE 8B5E04                   mov bx, [bp+4]
  7931 000099D1 8A07                     mov al, [bx]
  7932 000099D3 B400                     mov ah, 0
  7933 000099D5 08C0                     or  al, al
  7934 000099D7 0F843000                 je @@toupper323
  7935 000099DB 8B5E04                   mov bx, [bp+4]
  7936 000099DE 8A07                     mov al, [bx]
  7937 000099E0 B400                     mov ah, 0
  7938 000099E2 83F861                   cmp ax, 97 ;unsigned : 1
  7939 000099E5 0F8C1D00                 jl  @@toupper324
  7940 000099E9 8B5E04                   mov bx, [bp+4]
  7941 000099EC 8A07                     mov al, [bx]
  7942 000099EE B400                     mov ah, 0
  7943 000099F0 83F87A                   cmp ax, 122
  7944 000099F3 0F8F0F00                 jg  @@toupper325
  7945 000099F7 8B5E04                   mov bx, [bp+4]
  7946 000099FA 8A07                     mov al, [bx]
  7947 000099FC B400                     mov ah, 0
  7948 000099FE 83E820                   sub ax, 32
  7949 00009A01 8B5E04                   mov  bx, [bp+4]
  7950 00009A04 8807                     mov  [bx], al
  7951                                  @@toupper325:
  7952                                  @@toupper324:
  7953 00009A06 FF4604                   inc  word [bp+4]
  7954 00009A09 EBC3                     jmp @@toupper322
  7955                                  @@toupper323:
  7956                                  
  7957                                  ;-339 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  7958                                  
  7959                                  
  7960                                  ;-340 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  7961 00009A0B C9                       LEAVE
  7962 00009A0C C3                       ret
  7963                                  ; ENDP
  7964                                  ;Number of CALLs:    4 : strlen
  7965                                  
  7966                                  strlen:  ; *** PROC ***
  7967                                  ;Function : strlen, Number of local variables: 2
  7968                                  ;   # type sign width line used address name   list of local variables
  7969                                  ;  200 ptr sign byte   340 NULL bp+4    s
  7970                                  ;  201 var sign word   340 NULL bp-2    c;
  7971 00009A0D C8020000                 ENTER  2,0
  7972 00009A11 66B800000000             mov eax, 0
  7973 00009A17 8946FE                   mov word [bp-2], ax
  7974                                  @@strlen326:
  7975 00009A1A 8B5E04                   mov bx, [bp+4]
  7976 00009A1D 8A07                     mov al, [bx]
  7977 00009A1F B400                     mov ah, 0
  7978 00009A21 83F800                   cmp ax, 0
  7979 00009A24 0F840800                 je  @@strlen327
  7980 00009A28 FF4604                   inc  word [bp+4]
  7981 00009A2B FF46FE                   inc  word [bp-2]
  7982 00009A2E EBEA                     jmp @@strlen326
  7983                                  @@strlen327:
  7984 00009A30 8B46FE                   mov ax, [bp-2]
  7985 00009A33 E90000                   jmp @@retn
  7986                                  
  7987                                  ;-341 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  7988                                  
  7989 00009A36 C9                      @@retn: LEAVE
  7990 00009A37 C3                       ret
  7991                                  ; ENDP
  7992                                  ;Number of CALLs:    7 : strcpy
  7993                                  
  7994                                  strcpy:  ; *** PROC ***
  7995                                  ;Function : strcpy, Number of local variables: 2
  7996                                  ;   # type sign width line used address name   list of local variables
  7997                                  ;  200 ptr sign byte   341 NULL bp+4    s
  7998                                  ;  201 ptr sign byte   341 NULL bp+6    t;
  7999 00009A38 C8000000                 ENTER  0,0
  8000                                  @@strcpy328:
  8001 00009A3C 8B5E06                   mov bx, [bp+6]
  8002 00009A3F 8A07                     mov al, [bx]
  8003 00009A41 B400                     mov ah, 0
  8004 00009A43 8B5E04                   mov  bx, [bp+4]
  8005 00009A46 8807                     mov  [bx], al
  8006 00009A48 FF4604                   inc  word [bp+4]
  8007 00009A4B FF4606                   inc  word [bp+6]
  8008                                  
  8009                                  ;-342   while (*t!=0); *s=0; return s; }
  8010                                  
  8011 00009A4E 8B5E06                   mov bx, [bp+6]
  8012 00009A51 8A07                     mov al, [bx]
  8013 00009A53 B400                     mov ah, 0
  8014 00009A55 83F800                   cmp ax, 0
  8015 00009A58 0F840200                 je  @@strcpy329
  8016 00009A5C EBDE                     jmp @@strcpy328
  8017                                  @@strcpy329:
  8018 00009A5E 66B800000000             mov eax, 0
  8019 00009A64 8B5E04                   mov  bx, [bp+4]
  8020 00009A67 8807                     mov  [bx], al
  8021 00009A69 8B4604                   mov ax, [bp+4]
  8022 00009A6C E90000                   jmp @@retn
  8023                                  
  8024                                  ;-343 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  8025                                  
  8026 00009A6F C9                      @@retn: LEAVE
  8027 00009A70 C3                       ret
  8028                                  ; ENDP
  8029                                  ;Number of CALLs:    3 : digit
  8030                                  
  8031                                  digit:  ; *** PROC ***
  8032                                  ;Function : digit, Number of local variables: 1
  8033                                  ;   # type sign width line used address name   list of local variables
  8034                                  ;  200 var sign byte   343 NULL bp+4    c;
  8035 00009A71 C8000000                 ENTER  0,0
  8036 00009A75 8A4604                   mov al, [bp+4]
  8037 00009A78 3C30                     cmp al, 48
  8038 00009A7A 0F8D0900                 jge @@digit330
  8039 00009A7E 66B800000000             mov eax, 0
  8040 00009A84 E91B00                   jmp @@retn
  8041                                  @@digit330:
  8042 00009A87 8A4604                   mov al, [bp+4]
  8043 00009A8A 3C39                     cmp al, 57
  8044 00009A8C 0F8E0900                 jle @@digit331
  8045 00009A90 66B800000000             mov eax, 0
  8046 00009A96 E90900                   jmp @@retn
  8047                                  @@digit331:
  8048 00009A99 66B801000000             mov eax, 1
  8049 00009A9F E90000                   jmp @@retn
  8050                                  
  8051                                  ;-344 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  8052                                  
  8053 00009AA2 C9                      @@retn: LEAVE
  8054 00009AA3 C3                       ret
  8055                                  ; ENDP
  8056                                  ;Number of CALLs:   35 : eqstr
  8057                                  
  8058                                  eqstr:  ; *** PROC ***
  8059                                  ;Function : eqstr, Number of local variables: 2
  8060                                  ;   # type sign width line used address name   list of local variables
  8061                                  ;  200 ptr sign byte   344 NULL bp+4    p
  8062                                  ;  201 ptr sign byte   344 NULL bp+6    q;
  8063 00009AA4 C8000000                 ENTER  0,0
  8064                                  @@eqstr332:
  8065 00009AA8 8B5E04                   mov bx, [bp+4]
  8066 00009AAB 8A07                     mov al, [bx]
  8067 00009AAD B400                     mov ah, 0
  8068 00009AAF 08C0                     or  al, al
  8069 00009AB1 0F842300                 je @@eqstr333
  8070                                  
  8071                                  ;-345     if (*p != *q) return 0; p++; q++; }
  8072                                  
  8073 00009AB5 8B5E04                   mov bx, [bp+4]
  8074 00009AB8 8A07                     mov al, [bx]
  8075 00009ABA B400                     mov ah, 0
  8076 00009ABC 8B5E06                   mov bx, [bp+6]
  8077 00009ABF 3A07                     cmp al, [bx]
  8078 00009AC1 B400                     mov ah, 0
  8079 00009AC3 0F840900                 je  @@eqstr334
  8080 00009AC7 66B800000000             mov eax, 0
  8081 00009ACD E92700                   jmp @@retn
  8082                                  @@eqstr334:
  8083 00009AD0 FF4604                   inc  word [bp+4]
  8084 00009AD3 FF4606                   inc  word [bp+6]
  8085                                  
  8086                                  ;-346     if(*q) return 0; return 1; }
  8087                                  
  8088 00009AD6 EBD0                     jmp @@eqstr332
  8089                                  @@eqstr333:
  8090 00009AD8 8B5E06                   mov bx, [bp+6]
  8091 00009ADB 8A07                     mov al, [bx]
  8092 00009ADD B400                     mov ah, 0
  8093 00009ADF 08C0                     or  al, al
  8094 00009AE1 0F840900                 je @@eqstr335
  8095 00009AE5 66B800000000             mov eax, 0
  8096 00009AEB E90900                   jmp @@retn
  8097                                  @@eqstr335:
  8098 00009AEE 66B801000000             mov eax, 1
  8099 00009AF4 E90000                   jmp @@retn
  8100                                  
  8101                                  ;-347 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  8102                                  
  8103 00009AF7 C9                      @@retn: LEAVE
  8104 00009AF8 C3                       ret
  8105                                  ; ENDP
  8106                                  ;Number of CALLs:    3 : strcat1
  8107                                  
  8108                                  strcat1:  ; *** PROC ***
  8109                                  ;Function : strcat1, Number of local variables: 2
  8110                                  ;   # type sign width line used address name   list of local variables
  8111                                  ;  200 ptr sign byte   347 NULL bp+4    s
  8112                                  ;  201 ptr sign byte   347 NULL bp+6    t;
  8113 00009AF9 C8000000                 ENTER  0,0
  8114                                  @@strcat1336:
  8115 00009AFD 8B5E04                   mov bx, [bp+4]
  8116 00009B00 8A07                     mov al, [bx]
  8117 00009B02 B400                     mov ah, 0
  8118 00009B04 83F800                   cmp ax, 0
  8119 00009B07 0F840500                 je  @@strcat1337
  8120 00009B0B FF4604                   inc  word [bp+4]
  8121 00009B0E EBED                     jmp @@strcat1336
  8122                                  @@strcat1337:
  8123 00009B10 FF7606                   push word [bp+6]
  8124 00009B13 FF7604                   push word [bp+4]
  8125 00009B16 E81FFF                   call strcpy
  8126 00009B19 83C404                   add  sp, 4
  8127                                  
  8128                                  ;-348 int basename(char *s) { char *p; p=0;
  8129 00009B1C C9                       LEAVE
  8130 00009B1D C3                       ret
  8131                                  ; ENDP
  8132                                  ;Number of CALLs:    1 : openR
  8133                                  
  8134                                  openR:  ; *** PROC ***
  8135                                  ;Function : openR, Number of local variables: 1
  8136                                  ;   # type sign width line used address name   list of local variables
  8137                                  ;  200 ptr sign byte   348 NULL bp+4    s;
  8138 00009B1E C8000000                 ENTER  0,0
  8139 00009B22 8B5604                   mov  dx, [bp+4]
  8140 00009B25 B8023D                   mov  ax, 15618
  8141 00009B28 E87200                   call DosInt
  8142                                  
  8143                                  ;-349 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  8144 00009B2B C9                       LEAVE
  8145 00009B2C C3                       ret
  8146                                  ; ENDP
  8147                                  ;Number of CALLs:    2 : creatR
  8148                                  
  8149                                  creatR:  ; *** PROC ***
  8150                                  ;Function : creatR, Number of local variables: 1
  8151                                  ;   # type sign width line used address name   list of local variables
  8152                                  ;  200 ptr sign byte   349 NULL bp+4    s;
  8153 00009B2D C8000000                 ENTER  0,0
  8154 00009B31 8B5604                   mov  dx, [bp+4]
  8155 00009B34 B90000                   mov  cx, 0
  8156 00009B37 B8003C                   mov  ax, 15360
  8157 00009B3A E86000                   call DosInt
  8158                                  
  8159                                  ;-350 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  8160 00009B3D C9                       LEAVE
  8161 00009B3E C3                       ret
  8162                                  ; ENDP
  8163                                  ;Number of CALLs:    2 : readRL
  8164                                  
  8165                                  readRL:  ; *** PROC ***
  8166                                  ;Function : readRL, Number of local variables: 3
  8167                                  ;   # type sign width line used address name   list of local variables
  8168                                  ;  200 ptr sign byte   350 NULL bp+4    s
  8169                                  ;  201 var sign word   350 NULL bp+6    fd
  8170                                  ;  202 var sign word   350 NULL bp+8    len;
  8171 00009B3F C8000000                 ENTER  0,0
  8172 00009B43 8B5604                   mov  dx, [bp+4]
  8173 00009B46 8B4E08                   mov  cx, [bp+8]
  8174 00009B49 8B5E06                   mov  bx, [bp+6]
  8175 00009B4C B8003F                   mov  ax, 16128
  8176 00009B4F E84B00                   call DosInt
  8177                                  
  8178                                  ;-351 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  8179 00009B52 C9                       LEAVE
  8180 00009B53 C3                       ret
  8181                                  ; ENDP
  8182                                  ;Number of CALLs:    2 : fputcR
  8183                                  
  8184                                  fputcR:  ; *** PROC ***
  8185                                  ;Function : fputcR, Number of local variables: 2
  8186                                  ;   # type sign width line used address name   list of local variables
  8187                                  ;  200 ptr sign byte   351 NULL bp+4    n
  8188                                  ;  201 var sign word   351 NULL bp+6    fd;
  8189 00009B54 C8000000                 ENTER  0,0
  8190 00009B58 8D5604                  lea dx, [bp+4]
  8191                                  
  8192                                  ;-352   cx=1; bx=fd; ax=0x4000; DosInt(); }
  8193                                  
  8194 00009B5B B90100                   mov  cx, 1
  8195 00009B5E 8B5E06                   mov  bx, [bp+6]
  8196 00009B61 B80040                   mov  ax, 16384
  8197 00009B64 E83600                   call DosInt
  8198                                  
  8199                                  ;-353 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  8200 00009B67 C9                       LEAVE
  8201 00009B68 C3                       ret
  8202                                  ; ENDP
  8203                                  ;Number of CALLs:    3 : fcloseR
  8204                                  
  8205                                  fcloseR:  ; *** PROC ***
  8206                                  ;Function : fcloseR, Number of local variables: 1
  8207                                  ;   # type sign width line used address name   list of local variables
  8208                                  ;  200 var sign word   353 NULL bp+4    fd;
  8209 00009B69 C8000000                 ENTER  0,0
  8210 00009B6D 8B5E04                   mov  bx, [bp+4]
  8211 00009B70 B8003E                   mov  ax, 15872
  8212 00009B73 CD21                     int  33
  8213                                  
  8214                                  ;-354 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  8215 00009B75 C9                       LEAVE
  8216 00009B76 C3                       ret
  8217                                  ; ENDP
  8218                                  ;Number of CALLs:    5 : exitR
  8219                                  
  8220                                  exitR:  ; *** PROC ***
  8221                                  ;Function : exitR, Number of local variables: 1
  8222                                  ;   # type sign width line used address name   list of local variables
  8223                                  ;  200 var sign byte   354 NULL bp+4    c;
  8224 00009B77 C8000000                 ENTER  0,0
  8225 00009B7B B44C                     mov  ah, 76
  8226 00009B7D 8A4604                   mov  al, [bp+4]
  8227 00009B80 CD21                     int  33
  8228                                  
  8229                                  ;-355 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  8230 00009B82 C9                       LEAVE
  8231 00009B83 C3                       ret
  8232                                  ; ENDP
  8233                                  ;End of archive file. 
  8234                                   
  8235                                  ; missing functions: 
  8236                                  ; putch
  8237                                  ; DosInt
  8238                                  ; DosInt
  8239                                  ; DosInt
  8240                                  ; DosInt
  8241                                  ; Number of unresolved CALLs :    5
  8242                                  ;use archive file: AR.C
  8243                                  
  8244                                  ;-356 // AR.C Archive
  8245                                  
  8246                                  ;Number of CALLs:    1 : putch
  8247                                  
  8248                                  putch:  ; *** PROC ***
  8249                                  ;Function : putch, Number of local variables: 1
  8250                                  ;   # type sign width line used address name   list of local variables
  8251                                  ;  200 var sign byte   356 NULL bp+4    c;
  8252 00009B84 C8000000                 ENTER  0,0
  8253 00009B88 807E040A                cmp byte [bp+4], 10
  8254 00009B8C 0F850500                 jne @@putch338
  8255 00009B90 B00D                     mov  al, 13
  8256 00009B92 E8FFFD                   call writetty
  8257                                  @@putch338:
  8258 00009B95 8A4604                   mov  al, [bp+4]
  8259 00009B98 E8F9FD                   call writetty
  8260                                  
  8261                                  ;-357 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  8262 00009B9B C9                       LEAVE
  8263 00009B9C C3                       ret
  8264                                  ; ENDP
  8265                                  ;Number of CALLs:    4 : DosInt
  8266                                  
  8267                                  DosInt:  ; *** PROC ***
  8268 00009B9D CD21                     int  33
  8269 00009B9F 7304                     jae short @@DosInt339
  8270 00009BA1 FF06[9E01]               inc  word [DOS_ERR]
  8271                                  @@DosInt339:
  8272                                  
  8273                                  ;-358 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  8274                                  
  8275 00009BA5 C3                       ret
  8276                                  ; ENDP
  8277                                  ;End of archive file. 
  8278                                   
  8279                                  ; missing functions:  All FUNCTIONs in place
  8280 00009BA6 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8281 00009BA9 58                      pop ax
  8282 00009BAA C3                      ret
  8283                                   
  8284                                  ;   # type sign width line used  address name   list of global variables
  8285                                  
  8286                                  ;    1 arr sign byte     1    2        0 Version1[9]
  8287                                  ;    2 var sign byte     1    3        0 LIST
  8288                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  8289                                  ;    4 arr sign byte     3   11        0 Symbol[31]
  8290                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  8291                                  ;    6 var unsg word     5   17        0 SymbolInt
  8292                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  8293                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  8294                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  8295                                  ;   10 arr sign byte     9    5        0 namein[67]
  8296                                  ;   11 arr sign byte    10    6        0 namelst[67]
  8297                                  ;   12 arr sign byte    11    6        0 namebin[67]
  8298                                  ;   13 var sign word    12    4        0 asm_fd
  8299                                  ;   14 var sign word    13    3        0 lst_fd
  8300                                  ;   15 var sign word    14    3        0 bin_fd
  8301                                  ;   16 var sign word    15    6        0 DOS_ERR
  8302                                  ;   17 var sign word    16    4        0 ErrorCount
  8303                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  8304                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  8305                                  ;   20 var unsg word    20    7        0 PC
  8306                                  ;   21 var unsg word    21    5        0 Origin
  8307                                  ;   22 var unsg word    22    2        0 PCStart
  8308                                  ;   23 var sign byte    23    3        0 isLabel
  8309                                  ;   24 def unsg byte    24    -        0 DIGIT=1
  8310                                  ;   25 def unsg byte    25    -        0 LETTERE=2
  8311                                  ;   26 def unsg byte    26    -        0 ALNUME=3
  8312                                  ;   27 def unsg byte    27    -        0 NOALNUME=4
  8313                                  ;   28 var sign byte    28   25        0 TokeType
  8314                                  ;   29 def unsg byte    29    -        0 BYTE=1
  8315                                  ;   30 def unsg byte    30    -        0 WORD=2
  8316                                  ;   31 def unsg byte    31    -        0 DWORD=3
  8317                                  ;   32 def unsg byte    32    -        0 SEGREG=4
  8318                                  ;   33 def unsg byte    33    -        0 IMM=1
  8319                                  ;   34 def unsg byte    34    -        0 REG=2
  8320                                  ;   35 def unsg byte    35    -        0 ADR=3
  8321                                  ;   36 def unsg byte    36    -        0 MEM=4
  8322                                  ;   37 var sign byte    37   28        0 Op
  8323                                  ;   38 var sign byte    38   31        0 Op2
  8324                                  ;   39 var sign byte    39   26        0 CodeType
  8325                                  ;   40 var sign byte    40   23        0 Code1
  8326                                  ;   41 var sign byte    41    7        0 Code2
  8327                                  ;   42 var sign byte    42    3        0 Code3
  8328                                  ;   43 var sign byte    43   19        0 R2No
  8329                                  ;   44 var sign byte    44   16        0 R1No
  8330                                  ;   45 var sign byte    45   18        0 R2Type
  8331                                  ;   46 var sign byte    46   15        0 R1Type
  8332                                  ;   47 var sign byte    47   13        0 OpSize
  8333                                  ;   48 var sign byte    48    9        0 wflag
  8334                                  ;   49 var sign byte    49    3        0 dflag
  8335                                  ;   50 var sign byte    50    8        0 sflag
  8336                                  ;   51 var sign byte    51   15        0 rm
  8337                                  ;   52 var sign byte    52    5        0 isDirect
  8338                                  ;   53 var sign word    53   48        0 disp
  8339                                  ;   54 var unsg word    54   12        0 imme
  8340                                  ;   55 def unsg byte    56    -        0 OPMAXLEN=5
  8341                                  ;   56 arr sign byte    57    2        0 OpPos[5]
  8342                                  ;   57 var sign word    58    6        0 OpPrintIndex
  8343                                  ;   58 ptr sign byte    59   19        0 OpCodePtr
  8344                                  ;   59 var sign byte    60    4        0 PrintRA
  8345                                  ;   60 def unsg byte    62    -        0 LABELNAMESMAX=3969
  8346                                  ;   61 arr sign byte    63    3        0 LabelNames[4000]
  8347                                  ;   62 ptr sign byte    64    5        0 LabelNamePtr
  8348                                  ;   63 def unsg byte    65    -        0 LABELADRMAX=600
  8349                                  ;   64 arr unsg word    66    6        0 LabelAddr[600]
  8350                                  ;   65 var sign word    67    6        0 LabelMaxIx
  8351                                  ;   66 var sign word    68   10        0 LabelIx
  8352                                  ;   67 def unsg byte    70    -        0 JMPCALLNAMESMAX=1969
  8353                                  ;   68 arr sign byte    71    3        0 JmpCallNames[2000]
  8354                                  ;   69 ptr sign byte    72    5        0 JmpCallNamePtr
  8355                                  ;   70 def unsg byte    73    -        0 JMPCALLMAX=500
  8356                                  ;   71 arr unsg word    74    2        0 JmpCallAddr[500]
  8357                                  ;   72 var sign word    75    6        0 JmpCallMaxIx
  8358                                  ;   73 def unsg byte    77    -        0 FILEBINMAX=20000
  8359                                  ;   74 arr sign byte    78    4        0 FileBin[20000]
  8360                                  ;   75 var unsg word    79    6        0 BinLen
  8361                                  ;   76 ptr sign byte    81    1        0 arglen
  8362                                  ;   77 ptr sign byte    82    4        0 argv
  8363                                  ;   78 var sign byte     1    1        0 I_START
  8364                                  ;   79 arr sign byte     4 NULL        0 I_PUSHA[9]
  8365                                  ;   80 arr sign byte     5 NULL        0 I_POPA[8]
  8366                                  ;   81 arr sign byte     6 NULL        0 I_NOP[7]
  8367                                  ;   82 arr sign byte     7 NULL        0 I_CBW[7]
  8368                                  ;   83 arr sign byte     8 NULL        0 I_CWDE[8]
  8369                                  ;   84 arr sign byte     9 NULL        0 I_CWD[7]
  8370                                  ;   85 arr sign byte    10 NULL        0 I_CDQ[7]
  8371                                  ;   86 arr sign byte    11 NULL        0 I_WAIT[8]
  8372                                  ;   87 arr sign byte    12 NULL        0 I_PUSHF[9]
  8373                                  ;   88 arr sign byte    13 NULL        0 I_POPF[8]
  8374                                  ;   89 arr sign byte    14 NULL        0 I_SAHF[8]
  8375                                  ;   90 arr sign byte    15 NULL        0 I_LAHF[8]
  8376                                  ;   91 arr sign byte    16 NULL        0 I_MOVSB[9]
  8377                                  ;   92 arr sign byte    17 NULL        0 I_MOVSW[9]
  8378                                  ;   93 arr sign byte    18 NULL        0 I_CMPSB[9]
  8379                                  ;   94 arr sign byte    19 NULL        0 I_CMPSW[9]
  8380                                  ;   95 arr sign byte    20 NULL        0 I_STOSB[9]
  8381                                  ;   96 arr sign byte    21 NULL        0 I_STOSW[9]
  8382                                  ;   97 arr sign byte    22 NULL        0 I_LODSB[9]
  8383                                  ;   98 arr sign byte    23 NULL        0 I_LODSW[9]
  8384                                  ;   99 arr sign byte    24 NULL        0 I_SCASB[9]
  8385                                  ;  100 arr sign byte    25 NULL        0 I_SCASW[9]
  8386                                  ;  101 arr sign byte    26 NULL        0 I_LEAVE[9]
  8387                                  ;  102 arr sign byte    27 NULL        0 I_INT3[8]
  8388                                  ;  103 arr sign byte    28 NULL        0 I_INTO[8]
  8389                                  ;  104 arr sign byte    29 NULL        0 I_IRET[8]
  8390                                  ;  105 arr sign byte    30 NULL        0 I_XLAT[8]
  8391                                  ;  106 arr sign byte    31 NULL        0 I_LOCK[8]
  8392                                  ;  107 arr sign byte    32 NULL        0 I_REPNE[9]
  8393                                  ;  108 arr sign byte    33 NULL        0 I_REPNZ[9]
  8394                                  ;  109 arr sign byte    34 NULL        0 I_REPE[8]
  8395                                  ;  110 arr sign byte    35 NULL        0 I_REPZ[8]
  8396                                  ;  111 arr sign byte    36 NULL        0 I_HLT[7]
  8397                                  ;  112 arr sign byte    37 NULL        0 I_CLC[7]
  8398                                  ;  113 arr sign byte    38 NULL        0 I_STC[7]
  8399                                  ;  114 arr sign byte    39 NULL        0 I_CLI[7]
  8400                                  ;  115 arr sign byte    40 NULL        0 I_STI[7]
  8401                                  ;  116 arr sign byte    41 NULL        0 I_CLD[7]
  8402                                  ;  117 arr sign byte    42 NULL        0 I_STD[7]
  8403                                  ;  118 arr sign byte    44 NULL        0 I_INC[9]
  8404                                  ;  119 arr sign byte    45 NULL        0 I_DEC[9]
  8405                                  ;  120 arr sign byte    46 NULL        0 I_NOT[8]
  8406                                  ;  121 arr sign byte    47 NULL        0 I_NEG[8]
  8407                                  ;  122 arr sign byte    48 NULL        0 I_MUL[8]
  8408                                  ;  123 arr sign byte    49 NULL        0 I_IMUL[9]
  8409                                  ;  124 arr sign byte    50 NULL        0 I_DIV[8]
  8410                                  ;  125 arr sign byte    51 NULL        0 I_IDIV[9]
  8411                                  ;  126 arr sign byte    53 NULL        0 I_LES[7]
  8412                                  ;  127 arr sign byte    54 NULL        0 I_LDS[7]
  8413                                  ;  128 arr sign byte    55 NULL        0 I_LEA[7]
  8414                                  ;  129 arr sign byte    56 NULL        0 I_LSS[8]
  8415                                  ;  130 arr sign byte    57 NULL        0 I_LFS[8]
  8416                                  ;  131 arr sign byte    58 NULL        0 I_LGS[8]
  8417                                  ;  132 arr sign byte    60 NULL        0 I_ADD[7]
  8418                                  ;  133 arr sign byte    61 NULL        0 I_OR[6]
  8419                                  ;  134 arr sign byte    62 NULL        0 I_ADC[7]
  8420                                  ;  135 arr sign byte    63 NULL        0 I_SBB[7]
  8421                                  ;  136 arr sign byte    64 NULL        0 I_AND[7]
  8422                                  ;  137 arr sign byte    65 NULL        0 I_SUB[7]
  8423                                  ;  138 arr sign byte    66 NULL        0 I_XOR[7]
  8424                                  ;  139 arr sign byte    67 NULL        0 I_CMP[7]
  8425                                  ;  140 arr sign byte    68 NULL        0 I_TEST[11]
  8426                                  ;  141 arr sign byte    70 NULL        0 I_MOV[6]
  8427                                  ;  142 arr sign byte    71 NULL        0 I_MOVSX[9]
  8428                                  ;  143 arr sign byte    72 NULL        0 I_MOVZX[9]
  8429                                  ;  144 arr sign byte    74 NULL        0 I_JO[6]
  8430                                  ;  145 arr sign byte    75 NULL        0 I_JNO[7]
  8431                                  ;  146 arr sign byte    76 NULL        0 I_JB[6]
  8432                                  ;  147 arr sign byte    77 NULL        0 I_JC[6]
  8433                                  ;  148 arr sign byte    78 NULL        0 I_JNB[7]
  8434                                  ;  149 arr sign byte    79 NULL        0 I_JAE[7]
  8435                                  ;  150 arr sign byte    80 NULL        0 I_JNC[7]
  8436                                  ;  151 arr sign byte    81 NULL        0 I_JE[6]
  8437                                  ;  152 arr sign byte    82 NULL        0 I_JZ[6]
  8438                                  ;  153 arr sign byte    83 NULL        0 I_JNE[7]
  8439                                  ;  154 arr sign byte    84 NULL        0 I_JNZ[7]
  8440                                  ;  155 arr sign byte    85 NULL        0 I_JBE[7]
  8441                                  ;  156 arr sign byte    86 NULL        0 I_JNA[7]
  8442                                  ;  157 arr sign byte    87 NULL        0 I_JA[6]
  8443                                  ;  158 arr sign byte    88 NULL        0 I_JS[6]
  8444                                  ;  159 arr sign byte    89 NULL        0 I_JNS[7]
  8445                                  ;  160 arr sign byte    90 NULL        0 I_JP[6]
  8446                                  ;  161 arr sign byte    91 NULL        0 I_JPE[7]
  8447                                  ;  162 arr sign byte    92 NULL        0 I_JNP[7]
  8448                                  ;  163 arr sign byte    93 NULL        0 I_JPO[7]
  8449                                  ;  164 arr sign byte    94 NULL        0 I_JL[6]
  8450                                  ;  165 arr sign byte    95 NULL        0 I_JNL[7]
  8451                                  ;  166 arr sign byte    96 NULL        0 I_JGE[7]
  8452                                  ;  167 arr sign byte    97 NULL        0 I_JLE[7]
  8453                                  ;  168 arr sign byte    98 NULL        0 I_JNG[7]
  8454                                  ;  169 arr sign byte    99 NULL        0 I_JG[6]
  8455                                  ;  170 arr sign byte   101 NULL        0 I_JMP[8]
  8456                                  ;  171 arr sign byte   102 NULL        0 I_CALL[9]
  8457                                  ;  172 arr sign byte   104 NULL        0 I_RET[8]
  8458                                  ;  173 arr sign byte   105 NULL        0 I_RETF[9]
  8459                                  ;  174 arr sign byte   107 NULL        0 I_PUSH[11]
  8460                                  ;  175 arr sign byte   108 NULL        0 I_POP[10]
  8461                                  ;  176 arr sign byte   110 NULL        0 I_ROL[7]
  8462                                  ;  177 arr sign byte   111 NULL        0 I_ROR[7]
  8463                                  ;  178 arr sign byte   112 NULL        0 I_RCL[7]
  8464                                  ;  179 arr sign byte   113 NULL        0 I_RCR[7]
  8465                                  ;  180 arr sign byte   114 NULL        0 I_SHL[7]
  8466                                  ;  181 arr sign byte   115 NULL        0 I_SAL[7]
  8467                                  ;  182 arr sign byte   116 NULL        0 I_SHR[7]
  8468                                  ;  183 arr sign byte   117 NULL        0 I_SAR[7]
  8469                                  ;  184 arr sign byte   119 NULL        0 I_INT[8]
  8470                                  ;  185 arr sign byte   130 NULL        0 I_XCHG[9]
  8471                                  ;  186 arr sign byte   140 NULL        0 I_ENTER[8]
  8472                                  ;  187 arr sign byte   142 NULL        0 I_ORG[6]
  8473                                  ;  188 arr sign byte   144 NULL        0 I_SECTION[10]
  8474                                  ;  189 arr sign byte   145 NULL        0 I_SEGMENT[10]
  8475                                  ;  190 arr sign byte   146 NULL        0 I_ABSOLUTE[11]
  8476                                  ;  191 arr sign byte   147 NULL        0 I_DB[5]
  8477                                  ;  192 arr sign byte   148 NULL        0 I_DW[5]
  8478                                  ;  193 arr sign byte   149 NULL        0 I_DD[5]
  8479                                  ;  194 arr sign byte   150 NULL        0 I_RESB[7]
  8480                                  ;  195 arr sign byte   151 NULL        0 I_RESW[7]
  8481                                  ;  196 arr sign byte   152 NULL        0 I_RESD[7]
  8482                                  ;  197 var sign byte   153 NULL        0 I_END
  8483                                  
  8484                                  
  8485                                  ;   # Calls Line Width  Name   list of functions
  8486                                  
  8487                                  ;    0    2    1 word   ChangeDirection
  8488                                  ;    1    2    9 word   checkOpL
  8489                                  ;    2    4   18 word   check2Ops
  8490                                  ;    3    1   27 word   get2Ops
  8491                                  ;    4    3   33 word   getOpL
  8492                                  ;    5    2   41 word   getOpR
  8493                                  ;    6    4   51 word   getOp1
  8494                                  ;    7    1   67 word   getMEM
  8495                                  ;    8    1   90 word   getIndReg1
  8496                                  ;    9    1   98 word   getIndReg2
  8497                                  ;   10    2  108 word   setwflag
  8498                                  ;   11    2  119 word   setsflag
  8499                                  ;   12    2  129 word   checkConstSize
  8500                                  ;   13    1    1 word   parse
  8501                                  ;   14   15   35 word   getTokeType
  8502                                  ;   15    2   46 word   storeJmpCall
  8503                                  ;   16    2   57 word   storeLabel
  8504                                  ;   17    5   69 word   searchLabel
  8505                                  ;   18    1   82 word   getVariable
  8506                                  ;   19    2  131 word   lookCode
  8507                                  ;   20    1  147 word   getCodeSize
  8508                                  ;   21    8  155 word   isToken
  8509                                  ;   22    2  163 word   need
  8510                                  ;   23    1  172 word   skipRest
  8511                                  ;   24    1    1 word   getLine
  8512                                  ;   25    1   17 word   ifEOL
  8513                                  ;   26    3   24 word   skipBlank
  8514                                  ;   27    2   29 word   letterE
  8515                                  ;   28    1   39 word   alnumE
  8516                                  ;   29    1   44 word   getDigit
  8517                                  ;   30    1   56 word   getName
  8518                                  ;   31    1   75 word   testReg
  8519                                  ;   32    1    1 word   printLine
  8520                                  ;   33    7   23 word   prc
  8521                                  ;   34    1   35 word   prscomment
  8522                                  ;   35   28   43 word   prs
  8523                                  ;   36    3   65 word   printhex8a
  8524                                  ;   37    2   70 word   printhex4
  8525                                  ;   38    1   75 word   printhex16
  8526                                  ;   39    5   80 word   printIntU
  8527                                  ;   40   25   91 word   error1
  8528                                  ;   41   12   99 word   errorexit
  8529                                  ;   42 NULL  103 word   allowederror
  8530                                  ;   43    3  104 word   addrerror
  8531                                  ;   44    1  105 word   immeerror
  8532                                  ;   45    3  106 word   implerror
  8533                                  ;   46    4  107 word   indexerror
  8534                                  ;   47    3  108 word   invaloperror
  8535                                  ;   48    5  109 word   numbererror
  8536                                  ;   49    1  110 word   regmemerror
  8537                                  ;   50    3  111 word   reg16error
  8538                                  ;   51    1  112 word   segregerror
  8539                                  ;   52    5  113 word   syntaxerror
  8540                                  ;   53 NULL  115 word   addrexit
  8541                                  ;   54    3  116 word   dataexit
  8542                                  ;   55 NULL  117 word   internexit
  8543                                  ;   56 NULL    1 word   main
  8544                                  ;   57    1    9 word   getarg
  8545                                  ;   58    1   43 word   fixJmpCall
  8546                                  ;   59    1   74 word   epilog
  8547                                  ;   60    2  117 word   end1
  8548                                  ;   61    1    2 word   getCodes
  8549                                  ;   62    1    7 word   gen66h
  8550                                  ;   63    8    9 word   genCode2
  8551                                  ;   64   13   13 word   genCodeW
  8552                                  ;   65   34   17 word   genCode8
  8553                                  ;   66   16   28 word   genCode16
  8554                                  ;   67   13   32 word   writeEA
  8555                                  ;   68    4   74 word   genImmediate
  8556                                  ;   69    1   11 word   process
  8557                                  ;   70    4  336 word   writetty
  8558                                  ;   71    8  337 word   cputs
  8559                                  ;   72    2  338 word   toupper
  8560                                  ;   73    4  340 word   strlen
  8561                                  ;   74    8  341 word   strcpy
  8562                                  ;   75    3  343 word   digit
  8563                                  ;   76   35  344 word   eqstr
  8564                                  ;   77    3  347 word   strcat1
  8565                                  ;   78    1  348 word   openR
  8566                                  ;   79    2  349 word   creatR
  8567                                  ;   80    2  350 word   readRL
  8568                                  ;   81    2  351 word   fputcR
  8569                                  ;   82    3  353 word   fcloseR
  8570                                  ;   83    5  354 word   exitR
  8571                                  ;   84    1  356 word   putch
  8572                                  ;   85    4  357 word   DosInt
  8573                                  ;   86 NULL  358 word   LastFunctionByt
  8574                                  
  8575                                  ;    #  addr name   list of CALLs
  8576                                  
  8577                                  ;    0  1430 implerror
  8578                                  ;    1  1440 segregerror
  8579                                  ;    2  1452 setwflag
  8580                                  ;    3  1461 error1
  8581                                  ;    4  1468 error1
  8582                                  ;    5  1485 get2Ops
  8583                                  ;    6  1493 addrerror
  8584                                  ;    7  1503 invaloperror
  8585                                  ;    8  1516 immeerror
  8586                                  ;    9  1526 addrerror
  8587                                  ;   10  1536 invaloperror
  8588                                  ;   11  1549 setwflag
  8589                                  ;   12  1566 getOpL
  8590                                  ;   13  1573 need
  8591                                  ;   14  1578 getOpR
  8592                                  ;   15  1592 getOpR
  8593                                  ;   16  1606 getOp1
  8594                                  ;   17  1613 isToken
  8595                                  ;   18  1621 getMEM
  8596                                  ;   19  1628 invaloperror
  8597                                  ;   20  1641 error1
  8598                                  ;   21  1655 testReg
  8599                                  ;   22  1663 searchLabel
  8600                                  ;   23  1675 error1
  8601                                  ;   24  1691 getTokeType
  8602                                  ;   25  1703 getOp1
  8603                                  ;   26  1710 syntaxerror
  8604                                  ;   27  1722 getIndReg2
  8605                                  ;   28  1733 getIndReg1
  8606                                  ;   29  1744 isToken
  8607                                  ;   30  1752 getTokeType
  8608                                  ;   31  1764 numbererror
  8609                                  ;   32  1776 isToken
  8610                                  ;   33  1784 isToken
  8611                                  ;   34  1792 errorexit
  8612                                  ;   35  1813 indexerror
  8613                                  ;   36  1824 indexerror
  8614                                  ;   37  1848 indexerror
  8615                                  ;   38  1859 indexerror
  8616                                  ;   39  1879 gen66h
  8617                                  ;   40  1898 error1
  8618                                  ;   41  1929 getLine
  8619                                  ;   42  1937 getTokeType
  8620                                  ;   43  1949 storeLabel
  8621                                  ;   44  1960 getTokeType
  8622                                  ;   45  1972 lookCode
  8623                                  ;   46  1981 process
  8624                                  ;   47  1989 getVariable
  8625                                  ;   48  2001 skipRest
  8626                                  ;   49  2010 error1
  8627                                  ;   50  2017 error1
  8628                                  ;   51  2024 printLine
  8629                                  ;   52  2048 skipBlank
  8630                                  ;   53  2058 digit
  8631                                  ;   54  2064 getDigit
  8632                                  ;   55  2073 letterE
  8633                                  ;   56  2081 getName
  8634                                  ;   57  2104 errorexit
  8635                                  ;   58  2114 strcpy
  8636                                  ;   59  2121 errorexit
  8637                                  ;   60  2144 errorexit
  8638                                  ;   61  2154 searchLabel
  8639                                  ;   62  2166 error1
  8640                                  ;   63  2173 strcpy
  8641                                  ;   64  2180 errorexit
  8642                                  ;   65  2208 eqstr
  8643                                  ;   66  2214 strlen
  8644                                  ;   67  2237 storeLabel
  8645                                  ;   68  2248 getTokeType
  8646                                  ;   69  2260 lookCode
  8647                                  ;   70  2269 dataexit
  8648                                  ;   71  2278 dataexit
  8649                                  ;   72  2287 getTokeType
  8650                                  ;   73  2299 genCode8
  8651                                  ;   74  2308 skipBlank
  8652                                  ;   75  2318 isToken
  8653                                  ;   76  2326 genCode8
  8654                                  ;   77  2335 isToken
  8655                                  ;   78  2343 getTokeType
  8656                                  ;   79  2355 genCode16
  8657                                  ;   80  2365 isToken
  8658                                  ;   81  2373 implerror
  8659                                  ;   82  2383 getTokeType
  8660                                  ;   83  2395 syntaxerror
  8661                                  ;   84  2407 genCode8
  8662                                  ;   85  2416 genCode16
  8663                                  ;   86  2426 genCode16
  8664                                  ;   87  2436 genCode16
  8665                                  ;   88  2446 numbererror
  8666                                  ;   89  2458 dataexit
  8667                                  ;   90  2476 eqstr
  8668                                  ;   91  2494 eqstr
  8669                                  ;   92  2500 getTokeType
  8670                                  ;   93  2512 eqstr
  8671                                  ;   94  2518 getTokeType
  8672                                  ;   95  2530 eqstr
  8673                                  ;   96  2536 getTokeType
  8674                                  ;   97  2558 skipBlank
  8675                                  ;   98  2575 isToken
  8676                                  ;   99  2583 getTokeType
  8677                                  ;  100  2595 error1
  8678                                  ;  101  2602 prs
  8679                                  ;  102  2606 prc
  8680                                  ;  103  2619 getTokeType
  8681                                  ;  104  2631 error1
  8682                                  ;  105  2648 readRL
  8683                                  ;  106  2655 errorexit
  8684                                  ;  107  2665 errorexit
  8685                                  ;  108  2675 ifEOL
  8686                                  ;  109  2689 readRL
  8687                                  ;  110  2725 digit
  8688                                  ;  111  2731 letterE
  8689                                  ;  112  2758 digit
  8690                                  ;  113  2778 alnumE
  8691                                  ;  114  2785 errorexit
  8692                                  ;  115  2795 strcpy
  8693                                  ;  116  2802 toupper
  8694                                  ;  117  2818 strlen
  8695                                  ;  118  2825 strlen
  8696                                  ;  119  2832 eqstr
  8697                                  ;  120  2838 eqstr
  8698                                  ;  121  2844 eqstr
  8699                                  ;  122  2850 eqstr
  8700                                  ;  123  2856 eqstr
  8701                                  ;  124  2862 eqstr
  8702                                  ;  125  2868 eqstr
  8703                                  ;  126  2874 eqstr
  8704                                  ;  127  2880 eqstr
  8705                                  ;  128  2886 eqstr
  8706                                  ;  129  2892 eqstr
  8707                                  ;  130  2898 eqstr
  8708                                  ;  131  2904 eqstr
  8709                                  ;  132  2910 eqstr
  8710                                  ;  133  2916 eqstr
  8711                                  ;  134  2922 eqstr
  8712                                  ;  135  2928 eqstr
  8713                                  ;  136  2934 eqstr
  8714                                  ;  137  2940 eqstr
  8715                                  ;  138  2946 eqstr
  8716                                  ;  139  2952 eqstr
  8717                                  ;  140  2958 eqstr
  8718                                  ;  141  2964 eqstr
  8719                                  ;  142  2970 eqstr
  8720                                  ;  143  2976 eqstr
  8721                                  ;  144  2982 eqstr
  8722                                  ;  145  2988 eqstr
  8723                                  ;  146  2994 eqstr
  8724                                  ;  147  3000 eqstr
  8725                                  ;  148  3006 eqstr
  8726                                  ;  149  3026 prs
  8727                                  ;  150  3030 printhex16
  8728                                  ;  151  3041 prs
  8729                                  ;  152  3045 prc
  8730                                  ;  153  3049 printhex8a
  8731                                  ;  154  3060 prs
  8732                                  ;  155  3064 prc
  8733                                  ;  156  3068 prscomment
  8734                                  ;  157  3085 writetty
  8735                                  ;  158  3094 writetty
  8736                                  ;  159  3103 fputcR
  8737                                  ;  160  3125 prc
  8738                                  ;  161  3141 prc
  8739                                  ;  162  3162 printhex4
  8740                                  ;  163  3172 printhex4
  8741                                  ;  164  3194 prc
  8742                                  ;  165  3216 printhex8a
  8743                                  ;  166  3227 printhex8a
  8744                                  ;  167  3252 printIntU
  8745                                  ;  168  3262 prc
  8746                                  ;  169  3275 prs
  8747                                  ;  170  3279 prs
  8748                                  ;  171  3283 prs
  8749                                  ;  172  3287 prs
  8750                                  ;  173  3303 error1
  8751                                  ;  174  3310 end1
  8752                                  ;  175  3328 error1
  8753                                  ;  176  3345 error1
  8754                                  ;  177  3362 error1
  8755                                  ;  178  3379 error1
  8756                                  ;  179  3397 error1
  8757                                  ;  180  3417 error1
  8758                                  ;  181  3436 error1
  8759                                  ;  182  3455 error1
  8760                                  ;  183  3473 error1
  8761                                  ;  184  3492 error1
  8762                                  ;  185  3511 error1
  8763                                  ;  186  3527 errorexit
  8764                                  ;  187  3546 errorexit
  8765                                  ;  188  3567 errorexit
  8766                                  ;  189  3582 getarg
  8767                                  ;  190  3589 parse
  8768                                  ;  191  3595 fixJmpCall
  8769                                  ;  192  3606 epilog
  8770                                  ;  193  3613 end1
  8771                                  ;  194  3637 cputs
  8772                                  ;  195  3643 cputs
  8773                                  ;  196  3649 exitR
  8774                                  ;  197  3655 toupper
  8775                                  ;  198  3663 strcpy
  8776                                  ;  199  3670 strcat1
  8777                                  ;  200  3678 strcpy
  8778                                  ;  201  3685 strcat1
  8779                                  ;  202  3693 strcpy
  8780                                  ;  203  3700 strcat1
  8781                                  ;  204  3708 openR
  8782                                  ;  205  3714 cputs
  8783                                  ;  206  3720 cputs
  8784                                  ;  207  3726 exitR
  8785                                  ;  208  3732 creatR
  8786                                  ;  209  3739 cputs
  8787                                  ;  210  3745 cputs
  8788                                  ;  211  3751 exitR
  8789                                  ;  212  3757 creatR
  8790                                  ;  213  3764 cputs
  8791                                  ;  214  3770 cputs
  8792                                  ;  215  3776 exitR
  8793                                  ;  216  3782 prs
  8794                                  ;  217  3786 prs
  8795                                  ;  218  3790 prs
  8796                                  ;  219  3794 prs
  8797                                  ;  220  3798 prs
  8798                                  ;  221  3802 prs
  8799                                  ;  222  3806 prs
  8800                                  ;  223  3810 prs
  8801                                  ;  224  3814 prs
  8802                                  ;  225  3842 prs
  8803                                  ;  226  3846 printIntU
  8804                                  ;  227  3856 strcpy
  8805                                  ;  228  3863 strlen
  8806                                  ;  229  3870 searchLabel
  8807                                  ;  230  3882 error1
  8808                                  ;  231  3902 prs
  8809                                  ;  232  3906 printIntU
  8810                                  ;  233  3916 prs
  8811                                  ;  234  3920 prs
  8812                                  ;  235  3924 prs
  8813                                  ;  236  3928 prs
  8814                                  ;  237  3932 prs
  8815                                  ;  238  3936 prs
  8816                                  ;  239  3940 printIntU
  8817                                  ;  240  3950 prs
  8818                                  ;  241  3954 fputcR
  8819                                  ;  242  3961 prs
  8820                                  ;  243  3965 printIntU
  8821                                  ;  244  3975 prs
  8822                                  ;  245  3986 fcloseR
  8823                                  ;  246  3994 fcloseR
  8824                                  ;  247  4002 fcloseR
  8825                                  ;  248  4010 exitR
  8826                                  ;  249  4032 genCode8
  8827                                  ;  250  4054 genCode8
  8828                                  ;  251  4074 genCode8
  8829                                  ;  252  4094 errorexit
  8830                                  ;  253  4116 genCode8
  8831                                  ;  254  4125 genCode8
  8832                                  ;  255  4150 genCode8
  8833                                  ;  256  4159 genCode8
  8834                                  ;  257  4168 genCode16
  8835                                  ;  258  4191 genCode16
  8836                                  ;  259  4201 genCode8
  8837                                  ;  260  4220 getTokeType
  8838                                  ;  261  4232 getCodeSize
  8839                                  ;  262  4244 getCodes
  8840                                  ;  263  4253 genCode8
  8841                                  ;  264  4262 getOpL
  8842                                  ;  265  4269 checkOpL
  8843                                  ;  266  4278 genCode2
  8844                                  ;  267  4287 getTokeType
  8845                                  ;  268  4299 implerror
  8846                                  ;  269  4309 genCodeW
  8847                                  ;  270  4318 writeEA
  8848                                  ;  271  4326 check2Ops
  8849                                  ;  272  4336 reg16error
  8850                                  ;  273  4347 addrerror
  8851                                  ;  274  4357 genCode8
  8852                                  ;  275  4366 genCode8
  8853                                  ;  276  4375 writeEA
  8854                                  ;  277  4383 check2Ops
  8855                                  ;  278  4393 setsflag
  8856                                  ;  279  4402 genCodeW
  8857                                  ;  280  4411 genImmediate
  8858                                  ;  281  4424 genCodeW
  8859                                  ;  282  4433 writeEA
  8860                                  ;  283  4441 genCode8
  8861                                  ;  284  4450 genImmediate
  8862                                  ;  285  4463 genCodeW
  8863                                  ;  286  4472 writeEA
  8864                                  ;  287  4480 genCodeW
  8865                                  ;  288  4489 writeEA
  8866                                  ;  289  4497 syntaxerror
  8867                                  ;  290  4509 check2Ops
  8868                                  ;  291  4519 genCode2
  8869                                  ;  292  4528 genImmediate
  8870                                  ;  293  4541 genCodeW
  8871                                  ;  294  4550 writeEA
  8872                                  ;  295  4558 genImmediate
  8873                                  ;  296  4571 regmemerror
  8874                                  ;  297  4583 ChangeDirection
  8875                                  ;  298  4599 reg16error
  8876                                  ;  299  4610 genCode2
  8877                                  ;  300  4619 writeEA
  8878                                  ;  301  4627 genCodeW
  8879                                  ;  302  4636 genCode16
  8880                                  ;  303  4646 genCodeW
  8881                                  ;  304  4655 genCode16
  8882                                  ;  305  4665 genCodeW
  8883                                  ;  306  4674 writeEA
  8884                                  ;  307  4682 ChangeDirection
  8885                                  ;  308  4698 genCodeW
  8886                                  ;  309  4707 writeEA
  8887                                  ;  310  4715 syntaxerror
  8888                                  ;  311  4727 searchLabel
  8889                                  ;  312  4739 checkConstSize
  8890                                  ;  313  4754 genCode2
  8891                                  ;  314  4763 genCode8
  8892                                  ;  315  4772 genCode8
  8893                                  ;  316  4781 genCode2
  8894                                  ;  317  4790 genCode16
  8895                                  ;  318  4800 genCode8
  8896                                  ;  319  4809 genCode2
  8897                                  ;  320  4818 genCode16
  8898                                  ;  321  4828 storeJmpCall
  8899                                  ;  322  4841 searchLabel
  8900                                  ;  323  4853 checkConstSize
  8901                                  ;  324  4868 genCode8
  8902                                  ;  325  4877 genCode8
  8903                                  ;  326  4886 genCode8
  8904                                  ;  327  4895 genCode16
  8905                                  ;  328  4905 genCode8
  8906                                  ;  329  4914 genCode16
  8907                                  ;  330  4924 genCode8
  8908                                  ;  331  4933 genCode16
  8909                                  ;  332  4943 storeJmpCall
  8910                                  ;  333  4956 genCode8
  8911                                  ;  334  4965 genCode16
  8912                                  ;  335  4975 genCode8
  8913                                  ;  336  4984 getOpL
  8914                                  ;  337  4991 setsflag
  8915                                  ;  338  5000 genCode2
  8916                                  ;  339  5009 genCode8
  8917                                  ;  340  5018 genCode16
  8918                                  ;  341  5028 error1
  8919                                  ;  342  5035 genCode8
  8920                                  ;  343  5044 genCode8
  8921                                  ;  344  5053 checkOpL
  8922                                  ;  345  5062 reg16error
  8923                                  ;  346  5073 genCode2
  8924                                  ;  347  5082 genCode8
  8925                                  ;  348  5091 writeEA
  8926                                  ;  349  5099 syntaxerror
  8927                                  ;  350  5111 check2Ops
  8928                                  ;  351  5121 genCodeW
  8929                                  ;  352  5130 writeEA
  8930                                  ;  353  5138 genCodeW
  8931                                  ;  354  5147 writeEA
  8932                                  ;  355  5155 genCode8
  8933                                  ;  356  5164 genCodeW
  8934                                  ;  357  5173 writeEA
  8935                                  ;  358  5181 genCode8
  8936                                  ;  359  5190 genCode8
  8937                                  ;  360  5199 genCode8
  8938                                  ;  361  5208 getOp1
  8939                                  ;  362  5215 genCode16
  8940                                  ;  363  5225 numbererror
  8941                                  ;  364  5237 need
  8942                                  ;  365  5242 getOp1
  8943                                  ;  366  5249 genCode8
  8944                                  ;  367  5258 numbererror
  8945                                  ;  368  5270 numbererror
  8946                                  ;  369  5282 error1
  8947                                  ;  370  5308 putch
  8948                                  ;  371  5376 strcpy
  8949                                  ;  372  5391 DosInt
  8950                                  ;  373  5407 DosInt
  8951                                  ;  374  5430 DosInt
  8952                                  ;  375  5449 DosInt
  8953                                  ;  376  5483 writetty
  8954                                  ;  377  5492 writetty
  8955                                  ;Input: AS.C, List: AS.S,  Lines:  359
  8956                                  ;Glob. variables:  197 max.:  200
  8957                                  ;Local variables:    5 max.:  100, in 'fixJmpCall'
  8958                                  ;Functions      :   87 max.:  300
  8959                                  ;Calls          :  378 max.: 2000, NameField: 5524 max.:    65535
  8960                                  ;Code until     :25998 max.: 30000, free: 4002
  8961                                  ;Data (HeapEnd) :58595, resting stacksize:  6940
  8962                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
