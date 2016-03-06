     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E90E23                  jmp main
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
   201                                  ;-51 char isDirect;          //set in getOpL and getMeM, need in WriteEA
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
   231                                  ;-59 char PrintR;            //print 'R' if relocative
   232                                  
   233 000001C9 00                      PrintR db 0
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
   245                                  ;-63 char *LabelNamePtr;     // first free position
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
   267                                  ;-69 #define FILEBINMAX 2000 //next number - max. oplength
   268                                  
   269                                  
   270                                  ;-70 char FileBin  [FILEBINMAX];//output binary file
   271                                  
   272 00000680 <res 000007D0>          FileBin resb 2000
   273                                  
   274                                  ;-71 unsigned int BinLen=0;  //length of binary file
   275                                  
   276 00000E50 0000                    BinLen dw 0
   277                                  
   278                                  ;-72 
   279                                  
   280                                  
   281                                  ;-73 char *arglen=0x80;      // for main only
   282                                  
   283 00000E52 8000                    arglen dw 128
   284                                  
   285                                  ;-74 char *argv=0x82;        // for main only
   286                                  
   287 00000E54 8200                    argv dw 130
   288                                  ;Back to main program: AS.C
   289                                  
   290                                  ;-3 #include "OPTABL.C"
   291                                  
   292                                  ;Use include file: OPTABL.C
   293                                  
   294                                  ;-1 char I_START=0xF1;
   295                                  
   296 00000E56 F1                      I_START db 241
   297                                  
   298                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   299                                  
   300                                  
   301                                  ;-3 //  1:   1 byte opcode
   302                                  
   303                                  
   304                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   305                                  
   306 00000E57 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   307                                  
   308                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   309                                  
   310 00000E60 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   311                                  
   312                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   313                                  
   314 00000E68 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   315                                  
   316                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   317                                  
   318 00000E6F 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   319                                  
   320                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   321                                  
   322 00000E76 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   323                                  
   324                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   325                                  
   326 00000E7E 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   327                                  
   328                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   329                                  
   330 00000E85 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   331                                  
   332                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   333                                  
   334 00000E8C 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   335                                  
   336                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   337                                  
   338 00000E94 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   339                                  
   340                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   341                                  
   342 00000E9D 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   343                                  
   344                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   345                                  
   346 00000EA5 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   347                                  
   348                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   349                                  
   350 00000EAD 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   351                                  
   352                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   353                                  
   354 00000EB5 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   355                                  
   356                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   357                                  
   358 00000EBE 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   359                                  
   360                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   361                                  
   362 00000EC7 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   363                                  
   364                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   365                                  
   366 00000ED0 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   367                                  
   368                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   369                                  
   370 00000ED9 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   371                                  
   372                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   373                                  
   374 00000EE2 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   375                                  
   376                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   377                                  
   378 00000EEB 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   379                                  
   380                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   381                                  
   382 00000EF4 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   383                                  
   384                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   385                                  
   386 00000EFD 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   387                                  
   388                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   389                                  
   390 00000F06 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   391                                  
   392                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   393                                  
   394 00000F0F 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   395                                  
   396                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   397                                  
   398 00000F18 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   399                                  
   400                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   401                                  
   402 00000F20 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   403                                  
   404                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   405                                  
   406 00000F28 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   407                                  
   408                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   409                                  
   410 00000F30 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   411                                  
   412                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   413                                  
   414 00000F39 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   415                                  
   416                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   417                                  
   418 00000F42 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   419                                  
   420                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   421                                  
   422 00000F4A 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   423                                  
   424                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   425                                  
   426 00000F52 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   427                                  
   428                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   429                                  
   430 00000F59 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   431                                  
   432                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   433                                  
   434 00000F60 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   435                                  
   436                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   437                                  
   438 00000F67 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   439                                  
   440                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   441                                  
   442 00000F6E 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   443                                  
   444                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   445                                  
   446 00000F75 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   447                                  
   448                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   449                                  
   450 00000F7C 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   451                                  
   452                                  ;-41 // 2: mem reg 16 bit
   453                                  
   454                                  
   455                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   456                                  
   457 00000F83 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   458                                  
   459                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   460                                  
   461 00000F8C 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   462                                  
   463                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   464                                  
   465 00000F95 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   466                                  
   467                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   468                                  
   469 00000F9D 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   470                                  
   471                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   472                                  
   473 00000FA5 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   474                                  
   475                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   476                                  
   477 00000FAD 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   478                                  
   479                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   480                                  
   481 00000FB6 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   482                                  
   483                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   484                                  
   485 00000FBE 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   486                                  
   487                                  ;-50 //  3: les, lda, lea, lss, lfs, lgs
   488                                  
   489                                  
   490                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   491                                  
   492 00000FC7 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   493                                  
   494                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   495                                  
   496 00000FCE 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   497                                  
   498                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   499                                  
   500 00000FD5 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   501                                  
   502                                  ;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   503                                  
   504 00000FDC 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   505                                  
   506                                  ;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   507                                  
   508 00000FE4 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   509                                  
   510                                  ;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   511                                  
   512 00000FEC 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   513                                  
   514                                  ;-57 //  4: acc,imm  reg,imm  index,reg
   515                                  
   516                                  
   517                                  ;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   518                                  
   519 00000FF4 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   520                                  
   521                                  ;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   522                                  
   523 00000FFB 4F52000401F1            I_OR db 79,82,0,4,1,241
   524                                  
   525                                  ;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   526                                  
   527 00001001 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   528                                  
   529                                  ;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   530                                  
   531 00001008 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   532                                  
   533                                  ;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   534                                  
   535 0000100F 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   536                                  
   537                                  ;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   538                                  
   539 00001016 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   540                                  
   541                                  ;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   542                                  
   543 0000101D 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   544                                  
   545                                  ;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   546                                  
   547 00001024 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   548                                  
   549                                  ;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   550                                  
   551 0000102B 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   552 00001034 00F1               
   553                                  
   554                                  ;-67 //  5: mov
   555                                  
   556                                  
   557                                  ;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   558                                  
   559 00001036 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   560                                  
   561                                  ;-69 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   562                                  
   563 0000103C 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   564                                  
   565                                  ;-70 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   566                                  
   567 00001045 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   568                                  
   569                                  ;-71 //  6: single byte relative jump
   570                                  
   571                                  
   572                                  ;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   573                                  
   574 0000104E 4A4F000600F1            I_JO db 74,79,0,6,0,241
   575                                  
   576                                  ;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   577                                  
   578 00001054 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   579                                  
   580                                  ;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   581                                  
   582 0000105B 4A42000602F1            I_JB db 74,66,0,6,2,241
   583                                  
   584                                  ;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   585                                  
   586 00001061 4A43000602F1            I_JC db 74,67,0,6,2,241
   587                                  
   588                                  ;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   589                                  
   590 00001067 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   591                                  
   592                                  ;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   593                                  
   594 0000106E 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   595                                  
   596                                  ;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   597                                  
   598 00001075 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   599                                  
   600                                  ;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   601                                  
   602 0000107C 4A45000604F1            I_JE db 74,69,0,6,4,241
   603                                  
   604                                  ;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   605                                  
   606 00001082 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   607                                  
   608                                  ;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   609                                  
   610 00001088 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   611                                  
   612                                  ;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   613                                  
   614 0000108F 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   615                                  
   616                                  ;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   617                                  
   618 00001096 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   619                                  
   620                                  ;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   621                                  
   622 0000109D 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   623                                  
   624                                  ;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   625                                  
   626 000010A4 4A41000607F1            I_JA db 74,65,0,6,7,241
   627                                  
   628                                  ;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   629                                  
   630 000010AA 4A53000608F1            I_JS db 74,83,0,6,8,241
   631                                  
   632                                  ;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   633                                  
   634 000010B0 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   635                                  
   636                                  ;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   637                                  
   638 000010B7 4A5000060AF1            I_JP db 74,80,0,6,10,241
   639                                  
   640                                  ;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   641                                  
   642 000010BD 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   643                                  
   644                                  ;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   645                                  
   646 000010C4 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   647                                  
   648                                  ;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   649                                  
   650 000010CB 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   651                                  
   652                                  ;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   653                                  
   654 000010D2 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   655                                  
   656                                  ;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   657                                  
   658 000010D8 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   659                                  
   660                                  ;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   661                                  
   662 000010DF 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   663                                  
   664                                  ;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   665                                  
   666 000010E6 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   667                                  
   668                                  ;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   669                                  
   670 000010ED 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   671                                  
   672                                  ;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   673                                  
   674 000010F4 4A4700060FF1            I_JG db 74,71,0,6,15,241
   675                                  
   676                                  ;-98 //  7: jmp, call
   677                                  
   678                                  
   679                                  ;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   680                                  
   681 000010FA 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   682                                  
   683                                  ;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   684                                  
   685 00001102 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   686                                  
   687                                  ;-101 //  8: ret
   688                                  
   689                                  
   690                                  ;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   691                                  
   692 0000110B 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   693                                  
   694                                  ;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   695                                  
   696 00001113 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   697                                  
   698                                  ;-104 //  9: seg, r/m
   699                                  
   700                                  
   701                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   702                                  
   703 0000111C 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   704                                  
   705                                  ;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   706                                  
   707 00001124 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   708                                  
   709                                  ;-107 //  11: shift, rotates
   710                                  
   711                                  
   712                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   713                                  
   714 0000112B 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   715                                  
   716                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   717                                  
   718 00001132 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   719                                  
   720                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   721                                  
   722 00001139 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   723                                  
   724                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   725                                  
   726 00001140 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   727                                  
   728                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   729                                  
   730 00001147 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   731                                  
   732                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   733                                  
   734 0000114E 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   735                                  
   736                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   737                                  
   738 00001155 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   739                                  
   740                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   741                                  
   742 0000115C 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   743                                  
   744                                  ;-116 //  12: int
   745                                  
   746                                  
   747                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   748                                  
   749 00001163 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   750                                  
   751                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   752                                  
   753 0000116B 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   754                                  
   755                                  ;-119 //  14: in/out
   756                                  
   757                                  
   758                                  ;-120 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   759                                  
   760                                  
   761                                  ;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   762                                  
   763                                  
   764                                  ;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   765                                  
   766                                  
   767                                  ;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   768                                  
   769                                  
   770                                  ;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   771                                  
   772                                  
   773                                  ;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   774                                  
   775                                  
   776                                  ;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   777                                  
   778                                  
   779                                  ;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   780                                  
   781                                  
   782                                  ;-128 //  15: xchg
   783                                  
   784                                  
   785                                  ;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   786                                  
   787 00001173 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   788                                  
   789                                  ;-130 //  16: loop, jcxz
   790                                  
   791                                  
   792                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   793                                  
   794 0000117C 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   795 00001185 F1                 
   796                                  
   797                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   798                                  
   799 00001186 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   800 0000118F F1                 
   801                                  
   802                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   803                                  
   804 00001190 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   805                                  
   806                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   807                                  
   808 00001199 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   809                                  
   810                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   811                                  
   812 000011A2 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   813                                  
   814                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   815                                  
   816 000011AA 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   817                                  
   818                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   819                                  
   820 000011B2 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   821                                  
   822                                  ;-138 //  30: enter
   823                                  
   824                                  
   825                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   826                                  
   827 000011BB 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   828                                  
   829                                  ;-140 // 100: directives
   830                                  
   831                                  
   832                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   833                                  
   834 000011C4 4F52470065F1            I_ORG db 79,82,71,0,101,241
   835                                  
   836                                  ;-142 // section, segment .TEXT .DATA .BSS
   837                                  
   838                                  
   839                                  ;-143 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   840                                  
   841                                  
   842                                  ;-144 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   843                                  
   844                                  
   845                                  ;-145 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   846                                  
   847                                  
   848                                  ;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};
   849                                  
   850 000011CA 444200C8F1              I_DB db 68,66,0,200,241
   851                                  
   852                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   853                                  
   854 000011CF 445700C9F1              I_DW db 68,87,0,201,241
   855                                  
   856                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   857                                  
   858 000011D4 444400CAF1              I_DD db 68,68,0,202,241
   859                                  
   860                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   861                                  
   862 000011D9 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   863                                  
   864                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   865                                  
   866 000011E0 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   867                                  
   868                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   869                                  
   870 000011E7 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   871                                  
   872                                  ;-152 char I_END=0;// end of table char
   873                                  
   874 000011EE 00                      I_END db 0
   875                                  ;Back to main program: AS.C
   876                                  
   877                                  ;-4 #include "PARSE.C"
   878                                  
   879                                  ;Use include file: PARSE.C
   880                                  
   881                                  ;-1 int parse() {
   882                                  
   883                                  
   884                                  parse:  ; *** PROC ***
   885                                  
   886                                  ;-2   LabelNamePtr= &LabelNames;
   887                                  
   888 000011EF B8[CA01]                 mov ax, LabelNames
   889 000011F2 A3[B205]                 mov word [LabelNamePtr], ax
   890                                  
   891                                  ;-3   do {
   892                                  
   893                                  @@parse1:
   894                                  
   895                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
   896                                  
   897 000011F5 A1[A601]                 mov ax, [PC]
   898 000011F8 A3[A801]                 mov word [PCStart], ax
   899 000011FB 66B800000000             mov eax, 0
   900 00001201 A2[B601]                 mov byte [OpSize], al
   901 00001204 66B800000000             mov eax, 0
   902 0000120A A3[C501]                 mov word [OpPrintIndex], ax
   903 0000120D 66B820000000             mov eax, 32
   904 00001213 A2[C901]                 mov byte [PrintR], al
   905                                  
   906                                  ;-5     getLine();
   907                                  
   908 00001216 E82C05                   call getLine
   909                                  
   910                                  ;-6     InputPtr = &InputBuf;
   911                                  
   912 00001219 B8[4F00]                 mov ax, InputBuf
   913 0000121C A3[CE00]                 mov word [InputPtr], ax
   914                                  
   915                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
   916                                  
   917 0000121F E8B700                   call getTokeType
   918                                  
   919                                  ;-8     if (TokeType == ALNUME) {
   920                                  
   921 00001222 A0[AB01]                 mov al, [TokeType]
   922 00001225 3C03                     cmp al, 3
   923 00001227 0F851300                 jne @@parse2
   924                                  
   925                                  ;-9       if (isLabel) { //set in getName
   926                                  
   927 0000122B A0[AA01]                 mov al, [isLabel]
   928 0000122E 08C0                     or  al, al
   929 00001230 0F840A00                 je @@parse3
   930                                  
   931                                  ;-10         storeLabel();
   932                                  
   933 00001234 E84001                   call storeLabel
   934                                  
   935                                  ;-11         InputPtr++;//remove :
   936                                  
   937 00001237 FF06[CE00]               inc  word [InputPtr]
   938                                  
   939                                  ;-12         getTokeType();
   940                                  
   941 0000123B E89B00                   call getTokeType
   942                                  
   943                                  ;-13       }
   944                                  
   945                                  
   946                                  ;-14     }
   947                                  
   948                                  @@parse3:
   949                                  
   950                                  ;-15     if (TokeType == ALNUME) {
   951                                  
   952                                  @@parse2:
   953 0000123E A0[AB01]                 mov al, [TokeType]
   954 00001241 3C03                     cmp al, 3
   955 00001243 0F851B00                 jne @@parse4
   956                                  
   957                                  ;-16       lookCode();// and OpCodePtr
   958                                  
   959 00001247 E86803                   call lookCode
   960                                  
   961                                  ;-17       if(CodeType) process();
   962                                  
   963 0000124A A0[AE01]                 mov al, [CodeType]
   964 0000124D 08C0                     or  al, al
   965 0000124F 0F840600                 je @@parse5
   966 00001253 E82F16                   call process
   967                                  
   968                                  ;-18       else getVariable();
   969                                  
   970 00001256 E90300                   jmp @@parse6
   971                                  @@parse5:
   972 00001259 E81E02                   call getVariable
   973                                  
   974                                  ;-19       skipRest();
   975                                  
   976                                  @@parse6:
   977 0000125C E8BD04                   call skipRest
   978                                  
   979                                  ;-20     }
   980                                  
   981                                  
   982                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
   983                                  
   984 0000125F E92700                   jmp @@parse7
   985                                  @@parse4:
   986 00001262 A0[AB01]                 mov al, [TokeType]
   987 00001265 3C03                     cmp al, 3
   988 00001267 0F8E0C00                 jle @@parse8
   989 0000126B 68[9A12]                 push parse_0
   990 0000126E E8960E                   call error1
   991 00001271 83C402                   add  sp, 2
   992                                  
   993                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
   994                                  
   995 00001274 E91200                   jmp @@parse9
   996                                  @@parse8:
   997 00001277 A0[AB01]                 mov al, [TokeType]
   998 0000127A 3C01                     cmp al, 1
   999 0000127C 0F850900                 jne @@parse10
  1000 00001280 68[B812]                 push parse_1
  1001 00001283 E8810E                   call error1
  1002 00001286 83C402                   add  sp, 2
  1003                                  
  1004                                  ;-23     printLine();
  1005                                  
  1006                                  @@parse10:
  1007                                  @@parse9:
  1008                                  @@parse7:
  1009 00001289 E80C0C                   call printLine
  1010                                  
  1011                                  ;-24   } while (DOS_NoBytes != 0 );
  1012                                  
  1013 0000128C A1[A301]                 mov ax, [DOS_NoBytes]
  1014 0000128F 83F800                   cmp ax, 0
  1015 00001292 0F840300                 je  @@parse11
  1016 00001296 E95CFF                   jmp @@parse1
  1017                                  @@parse11:
  1018                                  
  1019                                  ;-25 }
  1020                                  
  1021                                  
  1022                                  ;-26 // scan code .....................................
  1023                                  
  1024                                  
  1025                                  ;-27 int getTokeType() { char c;
  1026                                  
  1027 00001299 C3                       ret
  1028                                  ; ENDP
  1029 0000129A 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1030 000012A3 696E73747275637469-
  1031 000012AC 6F6E20657870656374-
  1032 000012B5 656400             
  1033 000012B8 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1034 000012C1 616C6C6F7765642040-
  1035 000012CA 207374617274206F66-
  1036 000012D3 206C696E6500       
  1037                                  
  1038                                  getTokeType:  ; *** PROC ***
  1039                                  
  1040                                  ;-28   skipBlank();
  1041                                  
  1042                                  ;Function : getTokeType, Number of local variables: 1
  1043                                  ;   # type sign width line used address name   list of local variables
  1044                                  ;  200 var sign byte    27 NULL bp-2    c;
  1045 000012D9 C8020000                 ENTER  2,0
  1046 000012DD E86705                   call skipBlank
  1047                                  
  1048                                  ;-29   c = *InputPtr;
  1049                                  
  1050 000012E0 8B1E[CE00]               mov bx, [InputPtr]
  1051 000012E4 8A07                     mov al, [bx]
  1052 000012E6 B400                     mov ah, 0
  1053 000012E8 8846FE                   mov byte [bp-2], al
  1054                                  
  1055                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1056                                  
  1057 000012EB 8A46FE                   mov al, [bp-2]
  1058 000012EE 3C00                     cmp al, 0
  1059 000012F0 0F850C00                 jne @@getTokeType12
  1060 000012F4 66B800000000             mov eax, 0
  1061 000012FA A2[AB01]                 mov byte [TokeType], al
  1062 000012FD E97500                   jmp @@retn
  1063                                  
  1064                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1065                                  
  1066                                  @@getTokeType12:
  1067 00001300 8A46FE                   mov al, [bp-2]
  1068 00001303 3C3B                     cmp al, 59
  1069 00001305 0F850C00                 jne @@getTokeType13
  1070 00001309 66B800000000             mov eax, 0
  1071 0000130F A2[AB01]                 mov byte [TokeType], al
  1072 00001312 E96000                   jmp @@retn
  1073                                  
  1074                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1075                                  
  1076                                  @@getTokeType13:
  1077 00001315 8A46FE                   mov al, byte [bp-2]
  1078 00001318 B400                     mov ah, 0
  1079 0000131A 50                       push ax
  1080 0000131B E8B51E                   call digit
  1081 0000131E 83C402                   add  sp, 2
  1082 00001321 08C0                     or  al, al
  1083 00001323 0F841800                 je @@getTokeType14
  1084 00001327 8A46FE                   mov al, byte [bp-2]
  1085 0000132A B400                     mov ah, 0
  1086 0000132C 50                       push ax
  1087 0000132D E81D06                   call getDigit
  1088 00001330 83C402                   add  sp, 2
  1089 00001333 66B801000000             mov eax, 1
  1090 00001339 A2[AB01]                 mov byte [TokeType], al
  1091 0000133C E93600                   jmp @@retn
  1092                                  
  1093                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1094                                  
  1095                                  @@getTokeType14:
  1096 0000133F 8A46FE                   mov al, byte [bp-2]
  1097 00001342 B400                     mov ah, 0
  1098 00001344 50                       push ax
  1099 00001345 E82A05                   call letterE
  1100 00001348 83C402                   add  sp, 2
  1101 0000134B 08C0                     or  al, al
  1102 0000134D 0F841800                 je @@getTokeType15
  1103 00001351 8A46FE                   mov al, byte [bp-2]
  1104 00001354 B400                     mov ah, 0
  1105 00001356 50                       push ax
  1106 00001357 E84A06                   call getName
  1107 0000135A 83C402                   add  sp, 2
  1108 0000135D 66B803000000             mov eax, 3
  1109 00001363 A2[AB01]                 mov byte [TokeType], al
  1110 00001366 E90C00                   jmp @@retn
  1111                                  
  1112                                  ;-34   TokeType=NOALNUME; return;
  1113                                  
  1114                                  @@getTokeType15:
  1115 00001369 66B804000000             mov eax, 4
  1116 0000136F A2[AB01]                 mov byte [TokeType], al
  1117 00001372 E90000                   jmp @@retn
  1118                                  
  1119                                  ;-35 }
  1120                                  
  1121                                  
  1122                                  ;-36 int storeLabel() {unsigned int i;
  1123                                  
  1124 00001375 C9                      @@retn: LEAVE
  1125 00001376 C3                       ret
  1126                                  ; ENDP
  1127                                  
  1128                                  storeLabel:  ; *** PROC ***
  1129                                  
  1130                                  ;-37   if(searchLabel()) error1("duplicate label");
  1131                                  
  1132                                  ;Function : storeLabel, Number of local variables: 1
  1133                                  ;   # type sign width line used address name   list of local variables
  1134                                  ;  200 var unsg word    36 NULL bp-2    i;
  1135 00001377 C8020000                 ENTER  2,0
  1136 0000137B E89C00                   call searchLabel
  1137 0000137E 08C0                     or  al, al
  1138 00001380 0F840900                 je @@storeLabel16
  1139 00001384 68[E513]                 push storeLabel_0
  1140 00001387 E87D0D                   call error1
  1141 0000138A 83C402                   add  sp, 2
  1142                                  
  1143                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1144                                  
  1145                                  @@storeLabel16:
  1146 0000138D 8D06[0F00]               lea  ax, [Symbol]
  1147 00001391 50                       push ax
  1148 00001392 FF36[B205]               push word [LabelNamePtr]
  1149 00001396 E8011E                   call strcpy
  1150 00001399 83C404                   add  sp, 4
  1151 0000139C A3[B205]                 mov word [LabelNamePtr], ax
  1152                                  
  1153                                  ;-39   LabelNamePtr++;
  1154                                  
  1155 0000139F FF06[B205]               inc  word [LabelNamePtr]
  1156                                  
  1157                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  1158                                  
  1159 000013A3 A1[B205]                 mov ax, [LabelNamePtr]
  1160 000013A6 2D[CA01]                 sub ax, LabelNames
  1161 000013A9 8946FE                   mov word [bp-2], ax
  1162                                  
  1163                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  1164                                  
  1165 000013AC 8B46FE                   mov ax, [bp-2]
  1166 000013AF 3DC903                   cmp ax, 969 ;unsigned : 0
  1167 000013B2 0F820900                 jb  @@storeLabel17
  1168 000013B6 68[F513]                 push storeLabel_1
  1169 000013B9 E8AA0D                   call errorexit
  1170 000013BC 83C402                   add  sp, 2
  1171                                  
  1172                                  ;-42   LabelMaxIx++;
  1173                                  
  1174                                  @@storeLabel17:
  1175 000013BF FF06[7C06]               inc  word [LabelMaxIx]
  1176                                  
  1177                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  1178                                  
  1179 000013C3 A1[7C06]                 mov ax, [LabelMaxIx]
  1180 000013C6 83F864                   cmp ax, 100 ;unsigned : 1
  1181 000013C9 0F8C0900                 jl  @@storeLabel18
  1182 000013CD 68[0A14]                 push storeLabel_2
  1183 000013D0 E8930D                   call errorexit
  1184 000013D3 83C402                   add  sp, 2
  1185                                  
  1186                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  1187                                  
  1188                                  @@storeLabel18:
  1189 000013D6 A1[A601]                 mov ax, [PC]
  1190 000013D9 8B1E[7C06]               mov bx, [LabelMaxIx]
  1191 000013DD D1E3                     shl bx, 1
  1192 000013DF 8987[B405]               mov [LabelAddr+bx], ax
  1193                                  
  1194                                  ;-45 }
  1195                                  
  1196                                  
  1197                                  ;-46 int searchLabel() {
  1198 000013E3 C9                       LEAVE
  1199 000013E4 C3                       ret
  1200                                  ; ENDP
  1201 000013E5 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  1202 000013EE 206C6162656C00     
  1203 000013F5 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  1204 000013FE 6C6162656C206E616D-
  1205 00001407 657300             
  1206 0000140A 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  1207 00001413 6C6162656C7300     
  1208                                  
  1209                                  searchLabel:  ; *** PROC ***
  1210                                  
  1211                                  ;-47   int LIx; char *p; int j;
  1212                                  
  1213                                  
  1214                                  ;-48   p = &LabelNames;
  1215                                  
  1216                                  ;Function : searchLabel, Number of local variables: 3
  1217                                  ;   # type sign width line used address name   list of local variables
  1218                                  ;  200 var sign word    47 NULL bp-2    LIx
  1219                                  ;  201 ptr sign byte    47 NULL bp-4    p
  1220                                  ;  202 var sign word    47 NULL bp-6    j;
  1221 0000141A C8060000                 ENTER  6,0
  1222 0000141E B8[CA01]                 mov ax, LabelNames
  1223 00001421 8946FC                   mov word [bp-4], ax
  1224                                  
  1225                                  ;-49   LIx=1;
  1226                                  
  1227 00001424 66B801000000             mov eax, 1
  1228 0000142A 8946FE                   mov word [bp-2], ax
  1229                                  
  1230                                  ;-50   while (LIx <= LabelMaxIx) {
  1231                                  
  1232                                  @@searchLabel19:
  1233 0000142D 8B46FE                   mov ax, [bp-2]
  1234 00001430 3B06[7C06]               cmp ax, [LabelMaxIx]
  1235 00001434 0F8F3700                 jg  @@searchLabel20
  1236                                  
  1237                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  1238                                  
  1239 00001438 8D06[0F00]               lea  ax, [Symbol]
  1240 0000143C 50                       push ax
  1241 0000143D FF76FC                   push word [bp-4]
  1242 00001440 E8C31D                   call eqstr
  1243 00001443 83C404                   add  sp, 4
  1244 00001446 08C0                     or  al, al
  1245 00001448 0F840600                 je @@searchLabel21
  1246 0000144C 8B46FE                   mov ax, [bp-2]
  1247 0000144F E92600                   jmp @@retn
  1248                                  
  1249                                  ;-52     j=strlen(p);
  1250                                  
  1251                                  @@searchLabel21:
  1252 00001452 FF76FC                   push word [bp-4]
  1253 00001455 E8171D                   call strlen
  1254 00001458 83C402                   add  sp, 2
  1255 0000145B 8946FA                   mov word [bp-6], ax
  1256                                  
  1257                                  ;-53     p=p+j; p++; LIx++;
  1258                                  
  1259 0000145E 8B46FC                   mov ax, [bp-4]
  1260 00001461 0346FA                   add ax, [bp-6]
  1261 00001464 8946FC                   mov word [bp-4], ax
  1262 00001467 FF46FC                   inc  word [bp-4]
  1263 0000146A FF46FE                   inc  word [bp-2]
  1264                                  
  1265                                  ;-54   }
  1266                                  
  1267                                  
  1268                                  ;-55   return 0;
  1269                                  
  1270 0000146D EBBE                     jmp @@searchLabel19
  1271                                  @@searchLabel20:
  1272 0000146F 66B800000000             mov eax, 0
  1273 00001475 E90000                   jmp @@retn
  1274                                  
  1275                                  ;-56 }
  1276                                  
  1277                                  
  1278                                  ;-57 int getVariable() { char c;
  1279                                  
  1280 00001478 C9                      @@retn: LEAVE
  1281 00001479 C3                       ret
  1282                                  ; ENDP
  1283                                  
  1284                                  getVariable:  ; *** PROC ***
  1285                                  
  1286                                  ;-58   storeLabel();
  1287                                  
  1288                                  ;Function : getVariable, Number of local variables: 1
  1289                                  ;   # type sign width line used address name   list of local variables
  1290                                  ;  200 var sign byte    57 NULL bp-2    c;
  1291 0000147A C8020000                 ENTER  2,0
  1292 0000147E E8F6FE                   call storeLabel
  1293                                  
  1294                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  1295                                  
  1296 00001481 E855FE                   call getTokeType
  1297 00001484 A0[AB01]                 mov al, [TokeType]
  1298 00001487 3C03                     cmp al, 3
  1299 00001489 0F85CC00                 jne @@getVariable22
  1300                                  
  1301                                  ;-60     lookCode();
  1302                                  
  1303 0000148D E82201                   call lookCode
  1304                                  
  1305                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  1306                                  
  1307 00001490 A0[AE01]                 mov al, [CodeType]
  1308 00001493 3CC8                     cmp al, 200
  1309 00001495 0F8D0900                 jge @@getVariable23
  1310 00001499 68[6415]                 push getVariable_0
  1311 0000149C E8C70C                   call errorexit
  1312 0000149F 83C402                   add  sp, 2
  1313                                  
  1314                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1315                                  
  1316                                  @@getVariable23:
  1317 000014A2 A0[AE01]                 mov al, [CodeType]
  1318 000014A5 3CCF                     cmp al, 207
  1319 000014A7 0F8E0900                 jle @@getVariable24
  1320 000014AB 68[7C15]                 push getVariable_1
  1321 000014AE E8B50C                   call errorexit
  1322 000014B1 83C402                   add  sp, 2
  1323                                  
  1324                                  ;-63     if (CodeType== 200) {// DB
  1325                                  
  1326                                  @@getVariable24:
  1327 000014B4 A0[AE01]                 mov al, [CodeType]
  1328 000014B7 3CC8                     cmp al, 200
  1329 000014B9 0F856A00                 jne @@getVariable25
  1330                                  
  1331                                  ;-64       do { getTokeType();
  1332                                  
  1333                                  @@getVariable26:
  1334 000014BD E819FE                   call getTokeType
  1335                                  
  1336                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  1337                                  
  1338 000014C0 A0[AB01]                 mov al, [TokeType]
  1339 000014C3 3C01                     cmp al, 1
  1340 000014C5 0F850D00                 jne @@getVariable27
  1341 000014C9 FF36[4D00]               push word [SymbolInt]
  1342 000014CD E8ED11                   call genCode8
  1343 000014D0 83C402                   add  sp, 2
  1344                                  
  1345                                  ;-66         else {
  1346                                  
  1347 000014D3 E94100                   jmp @@getVariable28
  1348                                  @@getVariable27:
  1349                                  
  1350                                  ;-67           skipBlank();
  1351                                  
  1352 000014D6 E86E03                   call skipBlank
  1353                                  
  1354                                  ;-68           if (isToken('"')) {
  1355                                  
  1356 000014D9 6A22                     push 34
  1357 000014DB E8D101                   call isToken
  1358 000014DE 83C402                   add  sp, 2
  1359 000014E1 08C0                     or  al, al
  1360 000014E3 0F843000                 je @@getVariable29
  1361                                  
  1362                                  ;-69             do { c= *InputPtr;
  1363                                  
  1364                                  @@getVariable30:
  1365 000014E7 8B1E[CE00]               mov bx, [InputPtr]
  1366 000014EB 8A07                     mov al, [bx]
  1367 000014ED B400                     mov ah, 0
  1368 000014EF 8846FE                   mov byte [bp-2], al
  1369                                  
  1370                                  ;-70               genCode8(c);
  1371                                  
  1372 000014F2 8A46FE                   mov al, byte [bp-2]
  1373 000014F5 B400                     mov ah, 0
  1374 000014F7 50                       push ax
  1375 000014F8 E8C211                   call genCode8
  1376 000014FB 83C402                   add  sp, 2
  1377                                  
  1378                                  ;-71               InputPtr++;
  1379                                  
  1380 000014FE FF06[CE00]               inc  word [InputPtr]
  1381                                  
  1382                                  ;-72             } while (*InputPtr != '"' );
  1383                                  
  1384 00001502 8B1E[CE00]               mov bx, [InputPtr]
  1385 00001506 8A07                     mov al, [bx]
  1386 00001508 B400                     mov ah, 0
  1387 0000150A 83F822                   cmp ax, 34
  1388 0000150D 0F840200                 je  @@getVariable31
  1389 00001511 EBD4                     jmp @@getVariable30
  1390                                  @@getVariable31:
  1391                                  
  1392                                  ;-73             InputPtr++;
  1393                                  
  1394 00001513 FF06[CE00]               inc  word [InputPtr]
  1395                                  
  1396                                  ;-74           }
  1397                                  
  1398                                  
  1399                                  ;-75         }
  1400                                  
  1401                                  @@getVariable29:
  1402                                  
  1403                                  ;-76       } while (isToken(','));
  1404                                  
  1405                                  @@getVariable28:
  1406 00001517 6A2C                     push 44
  1407 00001519 E89301                   call isToken
  1408 0000151C 83C402                   add  sp, 2
  1409 0000151F 08C0                     or  al, al
  1410 00001521 0F840200                 je @@getVariable32
  1411 00001525 EB96                     jmp @@getVariable26
  1412                                  @@getVariable32:
  1413                                  
  1414                                  ;-77     }
  1415                                  
  1416                                  
  1417                                  ;-78     if (CodeType== 201) {// DW
  1418                                  
  1419                                  @@getVariable25:
  1420 00001527 A0[AE01]                 mov al, [CodeType]
  1421 0000152A 3CC9                     cmp al, 201
  1422 0000152C 0F852600                 jne @@getVariable33
  1423                                  
  1424                                  ;-79       do { getTokeType();
  1425                                  
  1426                                  @@getVariable34:
  1427 00001530 E8A6FD                   call getTokeType
  1428                                  
  1429                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  1430                                  
  1431 00001533 A0[AB01]                 mov al, [TokeType]
  1432 00001536 3C01                     cmp al, 1
  1433 00001538 0F850A00                 jne @@getVariable35
  1434 0000153C FF36[4D00]               push word [SymbolInt]
  1435 00001540 E8D111                   call genCode16
  1436 00001543 83C402                   add  sp, 2
  1437                                  
  1438                                  ;-81       } while (isToken(','));
  1439                                  
  1440                                  @@getVariable35:
  1441 00001546 6A2C                     push 44
  1442 00001548 E86401                   call isToken
  1443 0000154B 83C402                   add  sp, 2
  1444 0000154E 08C0                     or  al, al
  1445 00001550 0F840200                 je @@getVariable36
  1446 00001554 EBDA                     jmp @@getVariable34
  1447                                  @@getVariable36:
  1448                                  
  1449                                  ;-82     }
  1450                                  
  1451                                  
  1452                                  ;-83   }
  1453                                  
  1454                                  @@getVariable33:
  1455                                  
  1456                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  1457                                  
  1458 00001556 E90900                   jmp @@getVariable37
  1459                                  @@getVariable22:
  1460 00001559 68[9415]                 push getVariable_2
  1461 0000155C E8070C                   call errorexit
  1462 0000155F 83C402                   add  sp, 2
  1463                                  
  1464                                  ;-85 }
  1465                                  
  1466                                  @@getVariable37:
  1467                                  
  1468                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  1469 00001562 C9                       LEAVE
  1470 00001563 C3                       ret
  1471                                  ; ENDP
  1472 00001564 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  1473 0000156D 422C572C4420657870-
  1474 00001576 656374656400       
  1475 0000157C 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  1476 00001585 422C572C4420657870-
  1477 0000158E 656374656400       
  1478 00001594 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  1479 0000159D 6F7220524553422C57-
  1480 000015A6 2C4420657870656374-
  1481 000015AF 656400             
  1482                                  
  1483                                  lookCode:  ; *** PROC ***
  1484                                  
  1485                                  ;-87   CodeType=0;
  1486                                  
  1487 000015B2 66B800000000             mov eax, 0
  1488 000015B8 A2[AE01]                 mov byte [CodeType], al
  1489                                  
  1490                                  ;-88   OpCodePtr= &I_START;
  1491                                  
  1492 000015BB B8[560E]                 mov ax, I_START
  1493 000015BE A3[C701]                 mov word [OpCodePtr], ax
  1494                                  
  1495                                  ;-89   OpCodePtr++;
  1496                                  
  1497 000015C1 FF06[C701]               inc  word [OpCodePtr]
  1498                                  
  1499                                  ;-90   do  {
  1500                                  
  1501                                  @@lookCode38:
  1502                                  
  1503                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  1504                                  
  1505 000015C5 FF36[C701]               push word [OpCodePtr]
  1506 000015C9 8D06[2E00]               lea  ax, [SymbolUpper]
  1507 000015CD 50                       push ax
  1508 000015CE E8351C                   call eqstr
  1509 000015D1 83C404                   add  sp, 4
  1510 000015D4 08C0                     or  al, al
  1511 000015D6 0F842700                 je @@lookCode39
  1512                                  
  1513                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  1514                                  
  1515                                  @@lookCode40:
  1516 000015DA 8B1E[C701]               mov bx, [OpCodePtr]
  1517 000015DE 8A07                     mov al, [bx]
  1518 000015E0 B400                     mov ah, 0
  1519 000015E2 83F800                   cmp ax, 0
  1520 000015E5 0F840600                 je  @@lookCode41
  1521 000015E9 FF06[C701]               inc  word [OpCodePtr]
  1522                                  
  1523                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  1524                                  
  1525 000015ED EBEB                     jmp @@lookCode40
  1526                                  @@lookCode41:
  1527 000015EF FF06[C701]               inc  word [OpCodePtr]
  1528 000015F3 8B1E[C701]               mov bx, [OpCodePtr]
  1529 000015F7 8A07                     mov al, [bx]
  1530 000015F9 B400                     mov ah, 0
  1531 000015FB A2[AE01]                 mov byte [CodeType], al
  1532                                  
  1533                                  ;-94       return;
  1534                                  
  1535 000015FE E92A00                   jmp @@retn
  1536                                  
  1537                                  ;-95     }
  1538                                  
  1539                                  
  1540                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  1541                                  
  1542                                  @@lookCode39:
  1543                                  @@lookCode42:
  1544 00001601 8B1E[C701]               mov bx, [OpCodePtr]
  1545 00001605 8A07                     mov al, [bx]
  1546 00001607 B400                     mov ah, 0
  1547 00001609 3DF100                   cmp ax, 241
  1548 0000160C 0F840600                 je  @@lookCode43
  1549 00001610 FF06[C701]               inc  word [OpCodePtr]
  1550                                  
  1551                                  ;-97   OpCodePtr++;
  1552                                  
  1553 00001614 EBEB                     jmp @@lookCode42
  1554                                  @@lookCode43:
  1555 00001616 FF06[C701]               inc  word [OpCodePtr]
  1556                                  
  1557                                  ;-98   } while(*OpCodePtr!=0);
  1558                                  
  1559 0000161A 8B1E[C701]               mov bx, [OpCodePtr]
  1560 0000161E 8A07                     mov al, [bx]
  1561 00001620 B400                     mov ah, 0
  1562 00001622 83F800                   cmp ax, 0
  1563 00001625 0F840200                 je  @@lookCode44
  1564 00001629 EB9A                     jmp @@lookCode38
  1565                                  @@lookCode44:
  1566                                  
  1567                                  ;-99 }
  1568                                  
  1569                                  
  1570                                  ;-100 
  1571                                  
  1572                                  
  1573                                  ;-101 int getCodeSize() {
  1574                                  
  1575                                  @@retn:
  1576 0000162B C3                       ret
  1577                                  ; ENDP
  1578                                  
  1579                                  getCodeSize:  ; *** PROC ***
  1580                                  
  1581                                  ;-102   if (TokeType ==ALNUME) {
  1582                                  
  1583 0000162C A0[AB01]                 mov al, [TokeType]
  1584 0000162F 3C03                     cmp al, 3
  1585 00001631 0F856000                 jne @@getCodeSize45
  1586                                  
  1587                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1588                                  
  1589 00001635 68[9F16]                 push getCodeSize_0
  1590 00001638 8D06[2E00]               lea  ax, [SymbolUpper]
  1591 0000163C 50                       push ax
  1592 0000163D E8C61B                   call eqstr
  1593 00001640 83C404                   add  sp, 4
  1594 00001643 08C0                     or  al, al
  1595 00001645 0F840C00                 je @@getCodeSize46
  1596 00001649 E88DFC                   call getTokeType
  1597 0000164C 66B801000000             mov eax, 1
  1598 00001652 E94900                   jmp @@retn
  1599                                  
  1600                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1601                                  
  1602                                  @@getCodeSize46:
  1603 00001655 68[A416]                 push getCodeSize_1
  1604 00001658 8D06[2E00]               lea  ax, [SymbolUpper]
  1605 0000165C 50                       push ax
  1606 0000165D E8A61B                   call eqstr
  1607 00001660 83C404                   add  sp, 4
  1608 00001663 08C0                     or  al, al
  1609 00001665 0F840C00                 je @@getCodeSize47
  1610 00001669 E86DFC                   call getTokeType
  1611 0000166C 66B802000000             mov eax, 2
  1612 00001672 E92900                   jmp @@retn
  1613                                  
  1614                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1615                                  
  1616                                  @@getCodeSize47:
  1617 00001675 68[A916]                 push getCodeSize_2
  1618 00001678 8D06[2E00]               lea  ax, [SymbolUpper]
  1619 0000167C 50                       push ax
  1620 0000167D E8861B                   call eqstr
  1621 00001680 83C404                   add  sp, 4
  1622 00001683 08C0                     or  al, al
  1623 00001685 0F840C00                 je @@getCodeSize48
  1624 00001689 E84DFC                   call getTokeType
  1625 0000168C 66B803000000             mov eax, 3
  1626 00001692 E90900                   jmp @@retn
  1627                                  
  1628                                  ;-106   } return 0;
  1629                                  
  1630                                  @@getCodeSize48:
  1631                                  @@getCodeSize45:
  1632 00001695 66B800000000             mov eax, 0
  1633 0000169B E90000                   jmp @@retn
  1634                                  
  1635                                  ;-107 }
  1636                                  
  1637                                  
  1638                                  ;-108 int isToken(char c) {
  1639                                  
  1640                                  @@retn:
  1641 0000169E C3                       ret
  1642                                  ; ENDP
  1643 0000169F 4259544500              getCodeSize_0 db "BYTE",0
  1644 000016A4 574F524400              getCodeSize_1 db "WORD",0
  1645 000016A9 44574F524400            getCodeSize_2 db "DWORD",0
  1646                                  
  1647                                  isToken:  ; *** PROC ***
  1648                                  
  1649                                  ;-109   skipBlank();
  1650                                  
  1651                                  ;Function : isToken, Number of local variables: 1
  1652                                  ;   # type sign width line used address name   list of local variables
  1653                                  ;  200 var sign byte   108 NULL bp+4    c;
  1654 000016AF C8000000                 ENTER  0,0
  1655 000016B3 E89101                   call skipBlank
  1656                                  
  1657                                  ;-110   if (*InputPtr == c) {
  1658                                  
  1659 000016B6 8B1E[CE00]               mov bx, [InputPtr]
  1660 000016BA 8A07                     mov al, [bx]
  1661 000016BC B400                     mov ah, 0
  1662 000016BE 3A4604                   cmp al, [bp+4]
  1663 000016C1 0F850D00                 jne @@isToken49
  1664                                  
  1665                                  ;-111     InputPtr++; return 1;} return 0;
  1666                                  
  1667 000016C5 FF06[CE00]               inc  word [InputPtr]
  1668 000016C9 66B801000000             mov eax, 1
  1669 000016CF E90900                   jmp @@retn
  1670                                  @@isToken49:
  1671 000016D2 66B800000000             mov eax, 0
  1672 000016D8 E90000                   jmp @@retn
  1673                                  
  1674                                  ;-112 }
  1675                                  
  1676                                  
  1677                                  ;-113 int need(char c) {
  1678                                  
  1679 000016DB C9                      @@retn: LEAVE
  1680 000016DC C3                       ret
  1681                                  ; ENDP
  1682                                  
  1683                                  need:  ; *** PROC ***
  1684                                  
  1685                                  ;-114   if (isToken(c)) {
  1686                                  
  1687                                  ;Function : need, Number of local variables: 1
  1688                                  ;   # type sign width line used address name   list of local variables
  1689                                  ;  200 var sign byte   113 NULL bp+4    c;
  1690 000016DD C8000000                 ENTER  0,0
  1691 000016E1 8A4604                   mov al, byte [bp+4]
  1692 000016E4 B400                     mov ah, 0
  1693 000016E6 50                       push ax
  1694 000016E7 E8C5FF                   call isToken
  1695 000016EA 83C402                   add  sp, 2
  1696 000016ED 08C0                     or  al, al
  1697 000016EF 0F840600                 je @@need50
  1698                                  
  1699                                  ;-115       getTokeType();
  1700                                  
  1701 000016F3 E8E3FB                   call getTokeType
  1702                                  
  1703                                  ;-116       return;
  1704                                  
  1705 000016F6 E91800                   jmp @@retn
  1706                                  
  1707                                  ;-117       }
  1708                                  
  1709                                  
  1710                                  ;-118   error1();
  1711                                  
  1712                                  @@need50:
  1713 000016F9 E80B0A                   call error1
  1714                                  
  1715                                  ;-119   prs(". need: ");
  1716                                  
  1717 000016FC 68[1317]                 push need_0
  1718 000016FF E8A408                   call prs
  1719 00001702 83C402                   add  sp, 2
  1720                                  
  1721                                  ;-120   prc(c);
  1722                                  
  1723 00001705 8A4604                   mov al, byte [bp+4]
  1724 00001708 B400                     mov ah, 0
  1725 0000170A 50                       push ax
  1726 0000170B E83708                   call prc
  1727 0000170E 83C402                   add  sp, 2
  1728                                  
  1729                                  ;-121 }
  1730                                  
  1731                                  
  1732                                  ;-122 
  1733                                  
  1734                                  
  1735                                  ;-123 int skipRest() {
  1736                                  
  1737 00001711 C9                      @@retn: LEAVE
  1738 00001712 C3                       ret
  1739                                  ; ENDP
  1740 00001713 2E206E6565643A2000      need_0 db ". need: ",0
  1741                                  
  1742                                  skipRest:  ; *** PROC ***
  1743                                  
  1744                                  ;-124   getTokeType(); 
  1745                                  
  1746 0000171C E8BAFB                   call getTokeType
  1747                                  
  1748                                  ;-125   if(TokeType)error1("extra char ignored");
  1749                                  
  1750 0000171F A0[AB01]                 mov al, [TokeType]
  1751 00001722 08C0                     or  al, al
  1752 00001724 0F840900                 je @@skipRest51
  1753 00001728 68[3217]                 push skipRest_0
  1754 0000172B E8D909                   call error1
  1755 0000172E 83C402                   add  sp, 2
  1756                                  
  1757                                  ;-126 }
  1758                                  
  1759                                  @@skipRest51:
  1760 00001731 C3                       ret
  1761                                  ; ENDP
  1762 00001732 657874726120636861-     skipRest_0 db "extra char ignored",0
  1763 0000173B 722069676E6F726564-
  1764 00001744 00                 
  1765                                  ;Back to main program: AS.C
  1766                                  
  1767                                  ;-5 #include "HELPER.C"
  1768                                  
  1769                                  ;Use include file: HELPER.C
  1770                                  
  1771                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  1772                                  
  1773                                  
  1774                                  getLine:  ; *** PROC ***
  1775                                  
  1776                                  ;-2   unsigned int i;
  1777                                  
  1778                                  
  1779                                  ;-3   InputPtr= &InputBuf;
  1780                                  
  1781                                  ;Function : getLine, Number of local variables: 1
  1782                                  ;   # type sign width line used address name   list of local variables
  1783                                  ;  200 var unsg word     2 NULL bp-2    i;
  1784 00001745 C8020000                 ENTER  2,0
  1785 00001749 B8[4F00]                 mov ax, InputBuf
  1786 0000174C A3[CE00]                 mov word [InputPtr], ax
  1787                                  
  1788                                  ;-4   *InputPtr=0;//if last line is empty
  1789                                  
  1790 0000174F 66B800000000             mov eax, 0
  1791 00001755 8B1E[CE00]               mov  bx, [InputPtr]
  1792 00001759 8807                     mov  [bx], al
  1793                                  
  1794                                  ;-5   do {
  1795                                  
  1796                                  @@getLine52:
  1797                                  
  1798                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1799                                  
  1800 0000175B 6A01                     push 1
  1801 0000175D FF36[9901]               push word [asm_fd]
  1802 00001761 8D06[A501]               lea  ax, [DOS_ByteRead]
  1803 00001765 50                       push ax
  1804 00001766 E8381B                   call readRL
  1805 00001769 83C406                   add  sp, 6
  1806 0000176C A3[A301]                 mov word [DOS_NoBytes], ax
  1807                                  
  1808                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  1809                                  
  1810 0000176F A1[9F01]                 mov ax, [DOS_ERR]
  1811 00001772 08C0                     or  al, al
  1812 00001774 0F840900                 je @@getLine53
  1813 00001778 68[DD17]                 push getLine_0
  1814 0000177B E8E809                   call errorexit
  1815 0000177E 83C402                   add  sp, 2
  1816                                  
  1817                                  ;-8     if (DOS_NoBytes == 0) return;
  1818                                  
  1819                                  @@getLine53:
  1820 00001781 A1[A301]                 mov ax, [DOS_NoBytes]
  1821 00001784 83F800                   cmp ax, 0
  1822 00001787 0F850300                 jne @@getLine54
  1823 0000178B E94D00                   jmp @@retn
  1824                                  
  1825                                  ;-9     *InputPtr = DOS_ByteRead;
  1826                                  
  1827                                  @@getLine54:
  1828 0000178E A0[A501]                 mov al, [DOS_ByteRead]
  1829 00001791 8B1E[CE00]               mov  bx, [InputPtr]
  1830 00001795 8807                     mov  [bx], al
  1831                                  
  1832                                  ;-10     InputPtr++;
  1833                                  
  1834 00001797 FF06[CE00]               inc  word [InputPtr]
  1835                                  
  1836                                  ;-11     i = InputPtr - &InputBuf;
  1837                                  
  1838 0000179B A1[CE00]                 mov ax, [InputPtr]
  1839 0000179E 2D[4F00]                 sub ax, InputBuf
  1840 000017A1 8946FE                   mov word [bp-2], ax
  1841                                  
  1842                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  1843                                  
  1844 000017A4 8B46FE                   mov ax, [bp-2]
  1845 000017A7 83F87F                   cmp ax, 127 ;unsigned : 0
  1846 000017AA 0F820900                 jb  @@getLine55
  1847 000017AE 68[EC17]                 push getLine_1
  1848 000017B1 E8B209                   call errorexit
  1849 000017B4 83C402                   add  sp, 2
  1850                                  
  1851                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  1852                                  
  1853                                  @@getLine55:
  1854 000017B7 A0[A501]                 mov al, byte [DOS_ByteRead]
  1855 000017BA B400                     mov ah, 0
  1856 000017BC 50                       push ax
  1857 000017BD E84000                   call ifEOL
  1858 000017C0 83C402                   add  sp, 2
  1859 000017C3 3C00                     cmp al, 0
  1860 000017C5 0F850200                 jne @@getLine56
  1861 000017C9 EB90                     jmp @@getLine52
  1862                                  @@getLine56:
  1863                                  
  1864                                  ;-14   InputPtr--;
  1865                                  
  1866 000017CB FF0E[CE00]               dec  word [InputPtr]
  1867                                  
  1868                                  ;-15   *InputPtr=0;
  1869                                  
  1870 000017CF 66B800000000             mov eax, 0
  1871 000017D5 8B1E[CE00]               mov  bx, [InputPtr]
  1872 000017D9 8807                     mov  [bx], al
  1873                                  
  1874                                  ;-16 }
  1875                                  
  1876                                  
  1877                                  ;-17 int ifEOL(char c) {
  1878                                  
  1879 000017DB C9                      @@retn: LEAVE
  1880 000017DC C3                       ret
  1881                                  ; ENDP
  1882 000017DD 52656164696E672053-     getLine_0 db "Reading Source",0
  1883 000017E6 6F7572636500       
  1884 000017EC 696E707574206C696E-     getLine_1 db "input line too long",0
  1885 000017F5 6520746F6F206C6F6E-
  1886 000017FE 6700               
  1887                                  
  1888                                  ifEOL:  ; *** PROC ***
  1889                                  
  1890                                  ;-18   if (c == 10) return 1;
  1891                                  
  1892                                  ;Function : ifEOL, Number of local variables: 1
  1893                                  ;   # type sign width line used address name   list of local variables
  1894                                  ;  200 var sign byte    17 NULL bp+4    c;
  1895 00001800 C8000000                 ENTER  0,0
  1896 00001804 8A4604                   mov al, [bp+4]
  1897 00001807 3C0A                     cmp al, 10
  1898 00001809 0F850900                 jne @@ifEOL57
  1899 0000180D 66B801000000             mov eax, 1
  1900 00001813 E92F00                   jmp @@retn
  1901                                  
  1902                                  ;-19   if (c == 13) {
  1903                                  
  1904                                  @@ifEOL57:
  1905 00001816 8A4604                   mov al, [bp+4]
  1906 00001819 3C0D                     cmp al, 13
  1907 0000181B 0F851D00                 jne @@ifEOL58
  1908                                  
  1909                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1910                                  
  1911 0000181F 6A01                     push 1
  1912 00001821 FF36[9901]               push word [asm_fd]
  1913 00001825 8D06[A501]               lea  ax, [DOS_ByteRead]
  1914 00001829 50                       push ax
  1915 0000182A E8741A                   call readRL
  1916 0000182D 83C406                   add  sp, 6
  1917 00001830 A3[A301]                 mov word [DOS_NoBytes], ax
  1918                                  
  1919                                  ;-21     return 1;}
  1920                                  
  1921 00001833 66B801000000             mov eax, 1
  1922 00001839 E90900                   jmp @@retn
  1923                                  
  1924                                  ;-22   return 0;
  1925                                  
  1926                                  @@ifEOL58:
  1927 0000183C 66B800000000             mov eax, 0
  1928 00001842 E90000                   jmp @@retn
  1929                                  
  1930                                  ;-23 }
  1931                                  
  1932                                  
  1933                                  ;-24 int skipBlank() {
  1934                                  
  1935 00001845 C9                      @@retn: LEAVE
  1936 00001846 C3                       ret
  1937                                  ; ENDP
  1938                                  
  1939                                  skipBlank:  ; *** PROC ***
  1940                                  
  1941                                  ;-25   skipblank1:
  1942                                  
  1943                                  @@skipblank1:
  1944                                  
  1945                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  1946                                  
  1947 00001847 8B1E[CE00]               mov bx, [InputPtr]
  1948 0000184B 8A07                     mov al, [bx]
  1949 0000184D B400                     mov ah, 0
  1950 0000184F 83F820                   cmp ax, 32
  1951 00001852 0F850600                 jne @@skipBlank59
  1952 00001856 FF06[CE00]               inc  word [InputPtr]
  1953 0000185A EBEB                     jmp @@skipblank1
  1954                                  
  1955                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  1956                                  
  1957                                  @@skipBlank59:
  1958 0000185C 8B1E[CE00]               mov bx, [InputPtr]
  1959 00001860 8A07                     mov al, [bx]
  1960 00001862 B400                     mov ah, 0
  1961 00001864 83F809                   cmp ax, 9
  1962 00001867 0F850600                 jne @@skipBlank60
  1963 0000186B FF06[CE00]               inc  word [InputPtr]
  1964 0000186F EBD6                     jmp @@skipblank1
  1965                                  
  1966                                  ;-28 }
  1967                                  
  1968                                  @@skipBlank60:
  1969                                  
  1970                                  ;-29 int letterE(char c) {
  1971                                  
  1972 00001871 C3                       ret
  1973                                  ; ENDP
  1974                                  
  1975                                  letterE:  ; *** PROC ***
  1976                                  
  1977                                  ;-30   if (c=='_') return 1;
  1978                                  
  1979                                  ;Function : letterE, Number of local variables: 1
  1980                                  ;   # type sign width line used address name   list of local variables
  1981                                  ;  200 var sign byte    29 NULL bp+4    c;
  1982 00001872 C8000000                 ENTER  0,0
  1983 00001876 8A4604                   mov al, [bp+4]
  1984 00001879 3C5F                     cmp al, 95
  1985 0000187B 0F850900                 jne @@letterE61
  1986 0000187F 66B801000000             mov eax, 1
  1987 00001885 E97E00                   jmp @@retn
  1988                                  
  1989                                  ;-31   if (c=='.') return 1;
  1990                                  
  1991                                  @@letterE61:
  1992 00001888 8A4604                   mov al, [bp+4]
  1993 0000188B 3C2E                     cmp al, 46
  1994 0000188D 0F850900                 jne @@letterE62
  1995 00001891 66B801000000             mov eax, 1
  1996 00001897 E96C00                   jmp @@retn
  1997                                  
  1998                                  ;-32   if (c=='?') return 1;
  1999                                  
  2000                                  @@letterE62:
  2001 0000189A 8A4604                   mov al, [bp+4]
  2002 0000189D 3C3F                     cmp al, 63
  2003 0000189F 0F850900                 jne @@letterE63
  2004 000018A3 66B801000000             mov eax, 1
  2005 000018A9 E95A00                   jmp @@retn
  2006                                  
  2007                                  ;-33   if (c=='$') return 1;
  2008                                  
  2009                                  @@letterE63:
  2010 000018AC 8A4604                   mov al, [bp+4]
  2011 000018AF 3C24                     cmp al, 36
  2012 000018B1 0F850900                 jne @@letterE64
  2013 000018B5 66B801000000             mov eax, 1
  2014 000018BB E94800                   jmp @@retn
  2015                                  
  2016                                  ;-34   if (c> 'z') return 0;
  2017                                  
  2018                                  @@letterE64:
  2019 000018BE 8A4604                   mov al, [bp+4]
  2020 000018C1 3C7A                     cmp al, 122
  2021 000018C3 0F8E0900                 jle @@letterE65
  2022 000018C7 66B800000000             mov eax, 0
  2023 000018CD E93600                   jmp @@retn
  2024                                  
  2025                                  ;-35   if (c< '@') return 0; // at included
  2026                                  
  2027                                  @@letterE65:
  2028 000018D0 8A4604                   mov al, [bp+4]
  2029 000018D3 3C40                     cmp al, 64
  2030 000018D5 0F8D0900                 jge @@letterE66
  2031 000018D9 66B800000000             mov eax, 0
  2032 000018DF E92400                   jmp @@retn
  2033                                  
  2034                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2035                                  
  2036                                  @@letterE66:
  2037 000018E2 8A4604                   mov al, [bp+4]
  2038 000018E5 3C5A                     cmp al, 90
  2039 000018E7 0F8E1200                 jle @@letterE67
  2040 000018EB 8A4604                   mov al, [bp+4]
  2041 000018EE 3C61                     cmp al, 97
  2042 000018F0 0F8D0900                 jge @@letterE68
  2043 000018F4 66B800000000             mov eax, 0
  2044 000018FA E90900                   jmp @@retn
  2045                                  @@letterE68:
  2046                                  
  2047                                  ;-37   return 1;
  2048                                  
  2049                                  @@letterE67:
  2050 000018FD 66B801000000             mov eax, 1
  2051 00001903 E90000                   jmp @@retn
  2052                                  
  2053                                  ;-38 }
  2054                                  
  2055                                  
  2056                                  ;-39 int alnumE(char c) {
  2057                                  
  2058 00001906 C9                      @@retn: LEAVE
  2059 00001907 C3                       ret
  2060                                  ; ENDP
  2061                                  
  2062                                  alnumE:  ; *** PROC ***
  2063                                  
  2064                                  ;-40   if (digit(c)) return 1;
  2065                                  
  2066                                  ;Function : alnumE, Number of local variables: 1
  2067                                  ;   # type sign width line used address name   list of local variables
  2068                                  ;  200 var sign byte    39 NULL bp+4    c;
  2069 00001908 C8000000                 ENTER  0,0
  2070 0000190C 8A4604                   mov al, byte [bp+4]
  2071 0000190F B400                     mov ah, 0
  2072 00001911 50                       push ax
  2073 00001912 E8BE18                   call digit
  2074 00001915 83C402                   add  sp, 2
  2075 00001918 08C0                     or  al, al
  2076 0000191A 0F840900                 je @@alnumE69
  2077 0000191E 66B801000000             mov eax, 1
  2078 00001924 E92400                   jmp @@retn
  2079                                  
  2080                                  ;-41   if (letterE(c)) return 1;
  2081                                  
  2082                                  @@alnumE69:
  2083 00001927 8A4604                   mov al, byte [bp+4]
  2084 0000192A B400                     mov ah, 0
  2085 0000192C 50                       push ax
  2086 0000192D E842FF                   call letterE
  2087 00001930 83C402                   add  sp, 2
  2088 00001933 08C0                     or  al, al
  2089 00001935 0F840900                 je @@alnumE70
  2090 00001939 66B801000000             mov eax, 1
  2091 0000193F E90900                   jmp @@retn
  2092                                  
  2093                                  ;-42   return 0;
  2094                                  
  2095                                  @@alnumE70:
  2096 00001942 66B800000000             mov eax, 0
  2097 00001948 E90000                   jmp @@retn
  2098                                  
  2099                                  ;-43 }
  2100                                  
  2101                                  
  2102                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2103                                  
  2104 0000194B C9                      @@retn: LEAVE
  2105 0000194C C3                       ret
  2106                                  ; ENDP
  2107                                  
  2108                                  getDigit:  ; *** PROC ***
  2109                                  
  2110                                  ;-45   unsigned int CastInt;
  2111                                  
  2112                                  
  2113                                  ;-46   SymbolInt=0;
  2114                                  
  2115                                  ;Function : getDigit, Number of local variables: 2
  2116                                  ;   # type sign width line used address name   list of local variables
  2117                                  ;  200 var unsg byte    44 NULL bp+4    c
  2118                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  2119 0000194D C8020000                 ENTER  2,0
  2120 00001951 66B800000000             mov eax, 0
  2121 00001957 A3[4D00]                 mov word [SymbolInt], ax
  2122                                  
  2123                                  ;-47   do {
  2124                                  
  2125                                  @@getDigit71:
  2126                                  
  2127                                  ;-48     c-='0';
  2128                                  
  2129 0000195A 806E0430                 sub  byte [bp+4], 48
  2130                                  
  2131                                  ;-49     SymbolInt=SymbolInt*10;
  2132                                  
  2133 0000195E A1[4D00]                 mov ax, [SymbolInt]
  2134 00001961 66BB0A000000             mov ebx, 10
  2135 00001967 66F7E3                   mul ebx
  2136 0000196A A3[4D00]                 mov word [SymbolInt], ax
  2137                                  
  2138                                  ;-50     ax=0; CastInt=c; //cast b2w
  2139                                  
  2140 0000196D B80000                   mov  ax, 0
  2141 00001970 8A4604                   mov al, [bp+4]
  2142 00001973 8946FE                   mov word [bp-2], ax
  2143                                  
  2144                                  ;-51     SymbolInt=SymbolInt+CastInt;
  2145                                  
  2146 00001976 A1[4D00]                 mov ax, [SymbolInt]
  2147 00001979 0346FE                   add ax, [bp-2]
  2148 0000197C A3[4D00]                 mov word [SymbolInt], ax
  2149                                  
  2150                                  ;-52     InputPtr++;
  2151                                  
  2152 0000197F FF06[CE00]               inc  word [InputPtr]
  2153                                  
  2154                                  ;-53     c = *InputPtr;
  2155                                  
  2156 00001983 8B1E[CE00]               mov bx, [InputPtr]
  2157 00001987 8A07                     mov al, [bx]
  2158 00001989 B400                     mov ah, 0
  2159 0000198B 884604                   mov byte [bp+4], al
  2160                                  
  2161                                  ;-54   } while(digit(c));
  2162                                  
  2163 0000198E 8A4604                   mov al, byte [bp+4]
  2164 00001991 B400                     mov ah, 0
  2165 00001993 50                       push ax
  2166 00001994 E83C18                   call digit
  2167 00001997 83C402                   add  sp, 2
  2168 0000199A 08C0                     or  al, al
  2169 0000199C 0F840200                 je @@getDigit72
  2170 000019A0 EBB8                     jmp @@getDigit71
  2171                                  @@getDigit72:
  2172                                  
  2173                                  ;-55 }
  2174                                  
  2175                                  
  2176                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2177 000019A2 C9                       LEAVE
  2178 000019A3 C3                       ret
  2179                                  ; ENDP
  2180                                  
  2181                                  getName:  ; *** PROC ***
  2182                                  
  2183                                  ;-57   char *p; unsigned int i;
  2184                                  
  2185                                  
  2186                                  ;-58   p = &Symbol;
  2187                                  
  2188                                  ;Function : getName, Number of local variables: 3
  2189                                  ;   # type sign width line used address name   list of local variables
  2190                                  ;  200 var unsg byte    56 NULL bp+4    c
  2191                                  ;  201 ptr sign byte    57 NULL bp-2    p
  2192                                  ;  202 var unsg word    57 NULL bp-4    i;
  2193 000019A4 C8040000                 ENTER  4,0
  2194 000019A8 B8[0F00]                 mov ax, Symbol
  2195 000019AB 8946FE                   mov word [bp-2], ax
  2196                                  
  2197                                  ;-59   *p = c;
  2198                                  
  2199 000019AE 8A4604                   mov al, [bp+4]
  2200 000019B1 8B5EFE                   mov  bx, [bp-2]
  2201 000019B4 8807                     mov  [bx], al
  2202                                  
  2203                                  ;-60   p++;
  2204                                  
  2205 000019B6 FF46FE                   inc  word [bp-2]
  2206                                  
  2207                                  ;-61   while (alnumE(c)) {
  2208                                  
  2209                                  @@getName73:
  2210 000019B9 8A4604                   mov al, byte [bp+4]
  2211 000019BC B400                     mov ah, 0
  2212 000019BE 50                       push ax
  2213 000019BF E846FF                   call alnumE
  2214 000019C2 83C402                   add  sp, 2
  2215 000019C5 08C0                     or  al, al
  2216 000019C7 0F843800                 je @@getName74
  2217                                  
  2218                                  ;-62     InputPtr++;
  2219                                  
  2220 000019CB FF06[CE00]               inc  word [InputPtr]
  2221                                  
  2222                                  ;-63     c = *InputPtr;
  2223                                  
  2224 000019CF 8B1E[CE00]               mov bx, [InputPtr]
  2225 000019D3 8A07                     mov al, [bx]
  2226 000019D5 B400                     mov ah, 0
  2227 000019D7 884604                   mov byte [bp+4], al
  2228                                  
  2229                                  ;-64     *p = c;
  2230                                  
  2231 000019DA 8A4604                   mov al, [bp+4]
  2232 000019DD 8B5EFE                   mov  bx, [bp-2]
  2233 000019E0 8807                     mov  [bx], al
  2234                                  
  2235                                  ;-65     p++;
  2236                                  
  2237 000019E2 FF46FE                   inc  word [bp-2]
  2238                                  
  2239                                  ;-66     i = p - &Symbol;
  2240                                  
  2241 000019E5 8B46FE                   mov ax, [bp-2]
  2242 000019E8 2D[0F00]                 sub ax, Symbol
  2243 000019EB 8946FC                   mov word [bp-4], ax
  2244                                  
  2245                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  2246                                  
  2247 000019EE 8B46FC                   mov ax, [bp-4]
  2248 000019F1 83F81F                   cmp ax, 31 ;unsigned : 0
  2249 000019F4 0F820900                 jb  @@getName75
  2250 000019F8 68[4C1A]                 push getName_0
  2251 000019FB E86807                   call errorexit
  2252 000019FE 83C402                   add  sp, 2
  2253                                  
  2254                                  ;-68   }
  2255                                  
  2256                                  @@getName75:
  2257                                  
  2258                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  2259                                  
  2260 00001A01 EBB6                     jmp @@getName73
  2261                                  @@getName74:
  2262 00001A03 8A4604                   mov al, [bp+4]
  2263 00001A06 3C3A                     cmp al, 58
  2264 00001A08 0F850C00                 jne @@getName76
  2265 00001A0C 66B801000000             mov eax, 1
  2266 00001A12 A2[AA01]                 mov byte [isLabel], al
  2267 00001A15 E90900                   jmp @@getName77
  2268                                  @@getName76:
  2269 00001A18 66B800000000             mov eax, 0
  2270 00001A1E A2[AA01]                 mov byte [isLabel], al
  2271                                  
  2272                                  ;-70   p--;
  2273                                  
  2274                                  @@getName77:
  2275 00001A21 FF4EFE                   dec  word [bp-2]
  2276                                  
  2277                                  ;-71   *p = 0;
  2278                                  
  2279 00001A24 66B800000000             mov eax, 0
  2280 00001A2A 8B5EFE                   mov  bx, [bp-2]
  2281 00001A2D 8807                     mov  [bx], al
  2282                                  
  2283                                  ;-72   strcpy(SymbolUpper, Symbol);
  2284                                  
  2285 00001A2F 8D06[0F00]               lea  ax, [Symbol]
  2286 00001A33 50                       push ax
  2287 00001A34 8D06[2E00]               lea  ax, [SymbolUpper]
  2288 00001A38 50                       push ax
  2289 00001A39 E85E17                   call strcpy
  2290 00001A3C 83C404                   add  sp, 4
  2291                                  
  2292                                  ;-73   toupper(SymbolUpper);
  2293                                  
  2294 00001A3F 8D06[2E00]               lea  ax, [SymbolUpper]
  2295 00001A43 50                       push ax
  2296 00001A44 E8E516                   call toupper
  2297 00001A47 83C402                   add  sp, 2
  2298                                  
  2299                                  ;-74 }
  2300                                  
  2301                                  
  2302                                  ;-75 int testReg() {
  2303 00001A4A C9                       LEAVE
  2304 00001A4B C3                       ret
  2305                                  ; ENDP
  2306 00001A4C 73796D626F6C20746F-     getName_0 db "symbol too long",0
  2307 00001A55 6F206C6F6E6700     
  2308                                  
  2309                                  testReg:  ; *** PROC ***
  2310                                  
  2311                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2312                                  
  2313                                  
  2314                                  ;-77   R2Type=0;
  2315                                  
  2316 00001A5C 66B800000000             mov eax, 0
  2317 00001A62 A2[B401]                 mov byte [R2Type], al
  2318                                  
  2319                                  ;-78   if (strlen(Symbol) < 2) return 0;
  2320                                  
  2321 00001A65 8D06[0F00]               lea  ax, [Symbol]
  2322 00001A69 50                       push ax
  2323 00001A6A E80217                   call strlen
  2324 00001A6D 83C402                   add  sp, 2
  2325 00001A70 3C02                     cmp al, 2
  2326 00001A72 0F8D0900                 jge @@testReg78
  2327 00001A76 66B800000000             mov eax, 0
  2328 00001A7C E9B603                   jmp @@retn
  2329                                  
  2330                                  ;-79   if (strlen(Symbol) > 3) return 0;
  2331                                  
  2332                                  @@testReg78:
  2333 00001A7F 8D06[0F00]               lea  ax, [Symbol]
  2334 00001A83 50                       push ax
  2335 00001A84 E8E816                   call strlen
  2336 00001A87 83C402                   add  sp, 2
  2337 00001A8A 3C03                     cmp al, 3
  2338 00001A8C 0F8E0900                 jle @@testReg79
  2339 00001A90 66B800000000             mov eax, 0
  2340 00001A96 E99C03                   jmp @@retn
  2341                                  
  2342                                  ;-80   R2Type=BYTE;
  2343                                  
  2344                                  @@testReg79:
  2345 00001A99 66B801000000             mov eax, 1
  2346 00001A9F A2[B401]                 mov byte [R2Type], al
  2347                                  
  2348                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  2349                                  
  2350 00001AA2 68[361E]                 push testReg_0
  2351 00001AA5 8D06[2E00]               lea  ax, [SymbolUpper]
  2352 00001AA9 50                       push ax
  2353 00001AAA E85917                   call eqstr
  2354 00001AAD 83C404                   add  sp, 4
  2355 00001AB0 08C0                     or  al, al
  2356 00001AB2 0F840900                 je @@testReg80
  2357 00001AB6 66B800000000             mov eax, 0
  2358 00001ABC E97603                   jmp @@retn
  2359                                  
  2360                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  2361                                  
  2362                                  @@testReg80:
  2363 00001ABF 68[391E]                 push testReg_1
  2364 00001AC2 8D06[2E00]               lea  ax, [SymbolUpper]
  2365 00001AC6 50                       push ax
  2366 00001AC7 E83C17                   call eqstr
  2367 00001ACA 83C404                   add  sp, 4
  2368 00001ACD 08C0                     or  al, al
  2369 00001ACF 0F840900                 je @@testReg81
  2370 00001AD3 66B801000000             mov eax, 1
  2371 00001AD9 E95903                   jmp @@retn
  2372                                  
  2373                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  2374                                  
  2375                                  @@testReg81:
  2376 00001ADC 68[3C1E]                 push testReg_2
  2377 00001ADF 8D06[2E00]               lea  ax, [SymbolUpper]
  2378 00001AE3 50                       push ax
  2379 00001AE4 E81F17                   call eqstr
  2380 00001AE7 83C404                   add  sp, 4
  2381 00001AEA 08C0                     or  al, al
  2382 00001AEC 0F840900                 je @@testReg82
  2383 00001AF0 66B802000000             mov eax, 2
  2384 00001AF6 E93C03                   jmp @@retn
  2385                                  
  2386                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  2387                                  
  2388                                  @@testReg82:
  2389 00001AF9 68[3F1E]                 push testReg_3
  2390 00001AFC 8D06[2E00]               lea  ax, [SymbolUpper]
  2391 00001B00 50                       push ax
  2392 00001B01 E80217                   call eqstr
  2393 00001B04 83C404                   add  sp, 4
  2394 00001B07 08C0                     or  al, al
  2395 00001B09 0F840900                 je @@testReg83
  2396 00001B0D 66B803000000             mov eax, 3
  2397 00001B13 E91F03                   jmp @@retn
  2398                                  
  2399                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  2400                                  
  2401                                  @@testReg83:
  2402 00001B16 68[421E]                 push testReg_4
  2403 00001B19 8D06[2E00]               lea  ax, [SymbolUpper]
  2404 00001B1D 50                       push ax
  2405 00001B1E E8E516                   call eqstr
  2406 00001B21 83C404                   add  sp, 4
  2407 00001B24 08C0                     or  al, al
  2408 00001B26 0F840900                 je @@testReg84
  2409 00001B2A 66B804000000             mov eax, 4
  2410 00001B30 E90203                   jmp @@retn
  2411                                  
  2412                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  2413                                  
  2414                                  @@testReg84:
  2415 00001B33 68[451E]                 push testReg_5
  2416 00001B36 8D06[2E00]               lea  ax, [SymbolUpper]
  2417 00001B3A 50                       push ax
  2418 00001B3B E8C816                   call eqstr
  2419 00001B3E 83C404                   add  sp, 4
  2420 00001B41 08C0                     or  al, al
  2421 00001B43 0F840900                 je @@testReg85
  2422 00001B47 66B805000000             mov eax, 5
  2423 00001B4D E9E502                   jmp @@retn
  2424                                  
  2425                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  2426                                  
  2427                                  @@testReg85:
  2428 00001B50 68[481E]                 push testReg_6
  2429 00001B53 8D06[2E00]               lea  ax, [SymbolUpper]
  2430 00001B57 50                       push ax
  2431 00001B58 E8AB16                   call eqstr
  2432 00001B5B 83C404                   add  sp, 4
  2433 00001B5E 08C0                     or  al, al
  2434 00001B60 0F840900                 je @@testReg86
  2435 00001B64 66B806000000             mov eax, 6
  2436 00001B6A E9C802                   jmp @@retn
  2437                                  
  2438                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  2439                                  
  2440                                  @@testReg86:
  2441 00001B6D 68[4B1E]                 push testReg_7
  2442 00001B70 8D06[2E00]               lea  ax, [SymbolUpper]
  2443 00001B74 50                       push ax
  2444 00001B75 E88E16                   call eqstr
  2445 00001B78 83C404                   add  sp, 4
  2446 00001B7B 08C0                     or  al, al
  2447 00001B7D 0F840900                 je @@testReg87
  2448 00001B81 66B807000000             mov eax, 7
  2449 00001B87 E9AB02                   jmp @@retn
  2450                                  
  2451                                  ;-89   R2Type=WORD;
  2452                                  
  2453                                  @@testReg87:
  2454 00001B8A 66B802000000             mov eax, 2
  2455 00001B90 A2[B401]                 mov byte [R2Type], al
  2456                                  
  2457                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  2458                                  
  2459 00001B93 68[4E1E]                 push testReg_8
  2460 00001B96 8D06[2E00]               lea  ax, [SymbolUpper]
  2461 00001B9A 50                       push ax
  2462 00001B9B E86816                   call eqstr
  2463 00001B9E 83C404                   add  sp, 4
  2464 00001BA1 08C0                     or  al, al
  2465 00001BA3 0F840900                 je @@testReg88
  2466 00001BA7 66B800000000             mov eax, 0
  2467 00001BAD E98502                   jmp @@retn
  2468                                  
  2469                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  2470                                  
  2471                                  @@testReg88:
  2472 00001BB0 68[511E]                 push testReg_9
  2473 00001BB3 8D06[2E00]               lea  ax, [SymbolUpper]
  2474 00001BB7 50                       push ax
  2475 00001BB8 E84B16                   call eqstr
  2476 00001BBB 83C404                   add  sp, 4
  2477 00001BBE 08C0                     or  al, al
  2478 00001BC0 0F840900                 je @@testReg89
  2479 00001BC4 66B801000000             mov eax, 1
  2480 00001BCA E96802                   jmp @@retn
  2481                                  
  2482                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  2483                                  
  2484                                  @@testReg89:
  2485 00001BCD 68[541E]                 push testReg_10
  2486 00001BD0 8D06[2E00]               lea  ax, [SymbolUpper]
  2487 00001BD4 50                       push ax
  2488 00001BD5 E82E16                   call eqstr
  2489 00001BD8 83C404                   add  sp, 4
  2490 00001BDB 08C0                     or  al, al
  2491 00001BDD 0F840900                 je @@testReg90
  2492 00001BE1 66B802000000             mov eax, 2
  2493 00001BE7 E94B02                   jmp @@retn
  2494                                  
  2495                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  2496                                  
  2497                                  @@testReg90:
  2498 00001BEA 68[571E]                 push testReg_11
  2499 00001BED 8D06[2E00]               lea  ax, [SymbolUpper]
  2500 00001BF1 50                       push ax
  2501 00001BF2 E81116                   call eqstr
  2502 00001BF5 83C404                   add  sp, 4
  2503 00001BF8 08C0                     or  al, al
  2504 00001BFA 0F840900                 je @@testReg91
  2505 00001BFE 66B803000000             mov eax, 3
  2506 00001C04 E92E02                   jmp @@retn
  2507                                  
  2508                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  2509                                  
  2510                                  @@testReg91:
  2511 00001C07 68[5A1E]                 push testReg_12
  2512 00001C0A 8D06[2E00]               lea  ax, [SymbolUpper]
  2513 00001C0E 50                       push ax
  2514 00001C0F E8F415                   call eqstr
  2515 00001C12 83C404                   add  sp, 4
  2516 00001C15 08C0                     or  al, al
  2517 00001C17 0F840900                 je @@testReg92
  2518 00001C1B 66B804000000             mov eax, 4
  2519 00001C21 E91102                   jmp @@retn
  2520                                  
  2521                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  2522                                  
  2523                                  @@testReg92:
  2524 00001C24 68[5D1E]                 push testReg_13
  2525 00001C27 8D06[2E00]               lea  ax, [SymbolUpper]
  2526 00001C2B 50                       push ax
  2527 00001C2C E8D715                   call eqstr
  2528 00001C2F 83C404                   add  sp, 4
  2529 00001C32 08C0                     or  al, al
  2530 00001C34 0F840900                 je @@testReg93
  2531 00001C38 66B805000000             mov eax, 5
  2532 00001C3E E9F401                   jmp @@retn
  2533                                  
  2534                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  2535                                  
  2536                                  @@testReg93:
  2537 00001C41 68[601E]                 push testReg_14
  2538 00001C44 8D06[2E00]               lea  ax, [SymbolUpper]
  2539 00001C48 50                       push ax
  2540 00001C49 E8BA15                   call eqstr
  2541 00001C4C 83C404                   add  sp, 4
  2542 00001C4F 08C0                     or  al, al
  2543 00001C51 0F840900                 je @@testReg94
  2544 00001C55 66B806000000             mov eax, 6
  2545 00001C5B E9D701                   jmp @@retn
  2546                                  
  2547                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  2548                                  
  2549                                  @@testReg94:
  2550 00001C5E 68[631E]                 push testReg_15
  2551 00001C61 8D06[2E00]               lea  ax, [SymbolUpper]
  2552 00001C65 50                       push ax
  2553 00001C66 E89D15                   call eqstr
  2554 00001C69 83C404                   add  sp, 4
  2555 00001C6C 08C0                     or  al, al
  2556 00001C6E 0F840900                 je @@testReg95
  2557 00001C72 66B807000000             mov eax, 7
  2558 00001C78 E9BA01                   jmp @@retn
  2559                                  
  2560                                  ;-98   R2Type=SEGREG;
  2561                                  
  2562                                  @@testReg95:
  2563 00001C7B 66B804000000             mov eax, 4
  2564 00001C81 A2[B401]                 mov byte [R2Type], al
  2565                                  
  2566                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  2567                                  
  2568 00001C84 68[661E]                 push testReg_16
  2569 00001C87 8D06[2E00]               lea  ax, [SymbolUpper]
  2570 00001C8B 50                       push ax
  2571 00001C8C E87715                   call eqstr
  2572 00001C8F 83C404                   add  sp, 4
  2573 00001C92 08C0                     or  al, al
  2574 00001C94 0F840900                 je @@testReg96
  2575 00001C98 66B800000000             mov eax, 0
  2576 00001C9E E99401                   jmp @@retn
  2577                                  
  2578                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  2579                                  
  2580                                  @@testReg96:
  2581 00001CA1 68[691E]                 push testReg_17
  2582 00001CA4 8D06[2E00]               lea  ax, [SymbolUpper]
  2583 00001CA8 50                       push ax
  2584 00001CA9 E85A15                   call eqstr
  2585 00001CAC 83C404                   add  sp, 4
  2586 00001CAF 08C0                     or  al, al
  2587 00001CB1 0F840900                 je @@testReg97
  2588 00001CB5 66B801000000             mov eax, 1
  2589 00001CBB E97701                   jmp @@retn
  2590                                  
  2591                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  2592                                  
  2593                                  @@testReg97:
  2594 00001CBE 68[6C1E]                 push testReg_18
  2595 00001CC1 8D06[2E00]               lea  ax, [SymbolUpper]
  2596 00001CC5 50                       push ax
  2597 00001CC6 E83D15                   call eqstr
  2598 00001CC9 83C404                   add  sp, 4
  2599 00001CCC 08C0                     or  al, al
  2600 00001CCE 0F840900                 je @@testReg98
  2601 00001CD2 66B802000000             mov eax, 2
  2602 00001CD8 E95A01                   jmp @@retn
  2603                                  
  2604                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  2605                                  
  2606                                  @@testReg98:
  2607 00001CDB 68[6F1E]                 push testReg_19
  2608 00001CDE 8D06[2E00]               lea  ax, [SymbolUpper]
  2609 00001CE2 50                       push ax
  2610 00001CE3 E82015                   call eqstr
  2611 00001CE6 83C404                   add  sp, 4
  2612 00001CE9 08C0                     or  al, al
  2613 00001CEB 0F840900                 je @@testReg99
  2614 00001CEF 66B803000000             mov eax, 3
  2615 00001CF5 E93D01                   jmp @@retn
  2616                                  
  2617                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  2618                                  
  2619                                  @@testReg99:
  2620 00001CF8 68[721E]                 push testReg_20
  2621 00001CFB 8D06[2E00]               lea  ax, [SymbolUpper]
  2622 00001CFF 50                       push ax
  2623 00001D00 E80315                   call eqstr
  2624 00001D03 83C404                   add  sp, 4
  2625 00001D06 08C0                     or  al, al
  2626 00001D08 0F840900                 je @@testReg100
  2627 00001D0C 66B804000000             mov eax, 4
  2628 00001D12 E92001                   jmp @@retn
  2629                                  
  2630                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  2631                                  
  2632                                  @@testReg100:
  2633 00001D15 68[751E]                 push testReg_21
  2634 00001D18 8D06[2E00]               lea  ax, [SymbolUpper]
  2635 00001D1C 50                       push ax
  2636 00001D1D E8E614                   call eqstr
  2637 00001D20 83C404                   add  sp, 4
  2638 00001D23 08C0                     or  al, al
  2639 00001D25 0F840900                 je @@testReg101
  2640 00001D29 66B805000000             mov eax, 5
  2641 00001D2F E90301                   jmp @@retn
  2642                                  
  2643                                  ;-105   R2Type=DWORD;                         
  2644                                  
  2645                                  @@testReg101:
  2646 00001D32 66B803000000             mov eax, 3
  2647 00001D38 A2[B401]                 mov byte [R2Type], al
  2648                                  
  2649                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  2650                                  
  2651 00001D3B 68[781E]                 push testReg_22
  2652 00001D3E 8D06[2E00]               lea  ax, [SymbolUpper]
  2653 00001D42 50                       push ax
  2654 00001D43 E8C014                   call eqstr
  2655 00001D46 83C404                   add  sp, 4
  2656 00001D49 08C0                     or  al, al
  2657 00001D4B 0F840900                 je @@testReg102
  2658 00001D4F 66B800000000             mov eax, 0
  2659 00001D55 E9DD00                   jmp @@retn
  2660                                  
  2661                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  2662                                  
  2663                                  @@testReg102:
  2664 00001D58 68[7C1E]                 push testReg_23
  2665 00001D5B 8D06[2E00]               lea  ax, [SymbolUpper]
  2666 00001D5F 50                       push ax
  2667 00001D60 E8A314                   call eqstr
  2668 00001D63 83C404                   add  sp, 4
  2669 00001D66 08C0                     or  al, al
  2670 00001D68 0F840900                 je @@testReg103
  2671 00001D6C 66B801000000             mov eax, 1
  2672 00001D72 E9C000                   jmp @@retn
  2673                                  
  2674                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  2675                                  
  2676                                  @@testReg103:
  2677 00001D75 68[801E]                 push testReg_24
  2678 00001D78 8D06[2E00]               lea  ax, [SymbolUpper]
  2679 00001D7C 50                       push ax
  2680 00001D7D E88614                   call eqstr
  2681 00001D80 83C404                   add  sp, 4
  2682 00001D83 08C0                     or  al, al
  2683 00001D85 0F840900                 je @@testReg104
  2684 00001D89 66B802000000             mov eax, 2
  2685 00001D8F E9A300                   jmp @@retn
  2686                                  
  2687                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  2688                                  
  2689                                  @@testReg104:
  2690 00001D92 68[841E]                 push testReg_25
  2691 00001D95 8D06[2E00]               lea  ax, [SymbolUpper]
  2692 00001D99 50                       push ax
  2693 00001D9A E86914                   call eqstr
  2694 00001D9D 83C404                   add  sp, 4
  2695 00001DA0 08C0                     or  al, al
  2696 00001DA2 0F840900                 je @@testReg105
  2697 00001DA6 66B803000000             mov eax, 3
  2698 00001DAC E98600                   jmp @@retn
  2699                                  
  2700                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  2701                                  
  2702                                  @@testReg105:
  2703 00001DAF 68[881E]                 push testReg_26
  2704 00001DB2 8D06[2E00]               lea  ax, [SymbolUpper]
  2705 00001DB6 50                       push ax
  2706 00001DB7 E84C14                   call eqstr
  2707 00001DBA 83C404                   add  sp, 4
  2708 00001DBD 08C0                     or  al, al
  2709 00001DBF 0F840900                 je @@testReg106
  2710 00001DC3 66B804000000             mov eax, 4
  2711 00001DC9 E96900                   jmp @@retn
  2712                                  
  2713                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  2714                                  
  2715                                  @@testReg106:
  2716 00001DCC 68[8C1E]                 push testReg_27
  2717 00001DCF 8D06[2E00]               lea  ax, [SymbolUpper]
  2718 00001DD3 50                       push ax
  2719 00001DD4 E82F14                   call eqstr
  2720 00001DD7 83C404                   add  sp, 4
  2721 00001DDA 08C0                     or  al, al
  2722 00001DDC 0F840900                 je @@testReg107
  2723 00001DE0 66B805000000             mov eax, 5
  2724 00001DE6 E94C00                   jmp @@retn
  2725                                  
  2726                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  2727                                  
  2728                                  @@testReg107:
  2729 00001DE9 68[901E]                 push testReg_28
  2730 00001DEC 8D06[2E00]               lea  ax, [SymbolUpper]
  2731 00001DF0 50                       push ax
  2732 00001DF1 E81214                   call eqstr
  2733 00001DF4 83C404                   add  sp, 4
  2734 00001DF7 08C0                     or  al, al
  2735 00001DF9 0F840900                 je @@testReg108
  2736 00001DFD 66B806000000             mov eax, 6
  2737 00001E03 E92F00                   jmp @@retn
  2738                                  
  2739                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  2740                                  
  2741                                  @@testReg108:
  2742 00001E06 68[941E]                 push testReg_29
  2743 00001E09 8D06[2E00]               lea  ax, [SymbolUpper]
  2744 00001E0D 50                       push ax
  2745 00001E0E E8F513                   call eqstr
  2746 00001E11 83C404                   add  sp, 4
  2747 00001E14 08C0                     or  al, al
  2748 00001E16 0F840900                 je @@testReg109
  2749 00001E1A 66B807000000             mov eax, 7
  2750 00001E20 E91200                   jmp @@retn
  2751                                  
  2752                                  ;-114   R2Type=0; return 0;
  2753                                  
  2754                                  @@testReg109:
  2755 00001E23 66B800000000             mov eax, 0
  2756 00001E29 A2[B401]                 mov byte [R2Type], al
  2757 00001E2C 66B800000000             mov eax, 0
  2758 00001E32 E90000                   jmp @@retn
  2759                                  
  2760                                  ;-115 }
  2761                                  
  2762                                  @@retn:
  2763 00001E35 C3                       ret
  2764                                  ; ENDP
  2765 00001E36 414C00                  testReg_0 db "AL",0
  2766 00001E39 434C00                  testReg_1 db "CL",0
  2767 00001E3C 444C00                  testReg_2 db "DL",0
  2768 00001E3F 424C00                  testReg_3 db "BL",0
  2769 00001E42 414800                  testReg_4 db "AH",0
  2770 00001E45 434800                  testReg_5 db "CH",0
  2771 00001E48 444800                  testReg_6 db "DH",0
  2772 00001E4B 424800                  testReg_7 db "BH",0
  2773 00001E4E 415800                  testReg_8 db "AX",0
  2774 00001E51 435800                  testReg_9 db "CX",0
  2775 00001E54 445800                  testReg_10 db "DX",0
  2776 00001E57 425800                  testReg_11 db "BX",0
  2777 00001E5A 535000                  testReg_12 db "SP",0
  2778 00001E5D 425000                  testReg_13 db "BP",0
  2779 00001E60 534900                  testReg_14 db "SI",0
  2780 00001E63 444900                  testReg_15 db "DI",0
  2781 00001E66 455300                  testReg_16 db "ES",0
  2782 00001E69 435300                  testReg_17 db "CS",0
  2783 00001E6C 535300                  testReg_18 db "SS",0
  2784 00001E6F 445300                  testReg_19 db "DS",0
  2785 00001E72 465300                  testReg_20 db "FS",0
  2786 00001E75 475300                  testReg_21 db "GS",0
  2787 00001E78 45415800                testReg_22 db "EAX",0
  2788 00001E7C 45435800                testReg_23 db "ECX",0
  2789 00001E80 45445800                testReg_24 db "EDX",0
  2790 00001E84 45425800                testReg_25 db "EBX",0
  2791 00001E88 45535000                testReg_26 db "ESP",0
  2792 00001E8C 45425000                testReg_27 db "EBP",0
  2793 00001E90 45534900                testReg_28 db "ESI",0
  2794 00001E94 45444900                testReg_29 db "EDI",0
  2795                                  ;Back to main program: AS.C
  2796                                  
  2797                                  ;-6 #include "OUTPUT.C"
  2798                                  
  2799                                  ;Use include file: OUTPUT.C
  2800                                  
  2801                                  ;-1 int printLine() { 
  2802                                  
  2803                                  
  2804                                  printLine:  ; *** PROC ***
  2805                                  
  2806                                  ;-2     int i; char c;
  2807                                  
  2808                                  
  2809                                  ;-3     prs("\n"); 
  2810                                  
  2811                                  ;Function : printLine, Number of local variables: 2
  2812                                  ;   # type sign width line used address name   list of local variables
  2813                                  ;  200 var sign word     2 NULL bp-2    i
  2814                                  ;  201 var sign byte     2 NULL bp-4    c;
  2815 00001E98 C8040000                 ENTER  4,0
  2816 00001E9C 68[2D1F]                 push printLine_0
  2817 00001E9F E80401                   call prs
  2818 00001EA2 83C402                   add  sp, 2
  2819                                  
  2820                                  ;-4     printhex16(PCStart);
  2821                                  
  2822 00001EA5 FF36[A801]               push word [PCStart]
  2823 00001EA9 E8EF01                   call printhex16
  2824 00001EAC 83C402                   add  sp, 2
  2825                                  
  2826                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  2827                                  
  2828 00001EAF A1[C501]                 mov ax, [OpPrintIndex]
  2829 00001EB2 83F800                   cmp ax, 0
  2830 00001EB5 0F850C00                 jne @@printLine110
  2831 00001EB9 68[301F]                 push printLine_1
  2832 00001EBC E8E700                   call prs
  2833 00001EBF 83C402                   add  sp, 2
  2834                                  
  2835                                  ;-6     else {
  2836                                  
  2837 00001EC2 E95B00                   jmp @@printLine111
  2838                                  @@printLine110:
  2839                                  
  2840                                  ;-7         prc(PrintR);
  2841                                  
  2842 00001EC5 A0[C901]                 mov al, byte [PrintR]
  2843 00001EC8 B400                     mov ah, 0
  2844 00001ECA 50                       push ax
  2845 00001ECB E87700                   call prc
  2846 00001ECE 83C402                   add  sp, 2
  2847                                  
  2848                                  ;-8         i=0;
  2849                                  
  2850 00001ED1 66B800000000             mov eax, 0
  2851 00001ED7 8946FE                   mov word [bp-2], ax
  2852                                  
  2853                                  ;-9         do {
  2854                                  
  2855                                  @@printLine112:
  2856                                  
  2857                                  ;-10             c=OpPos[i];
  2858                                  
  2859 00001EDA 8B5EFE                   mov bx, [bp-2]
  2860 00001EDD 8A87[C001]               mov al, [OpPos + bx]
  2861 00001EE1 8846FC                   mov byte [bp-4], al
  2862                                  
  2863                                  ;-11             printhex8a(c); 
  2864                                  
  2865 00001EE4 8A46FC                   mov al, byte [bp-4]
  2866 00001EE7 B400                     mov ah, 0
  2867 00001EE9 50                       push ax
  2868 00001EEA E85C01                   call printhex8a
  2869 00001EED 83C402                   add  sp, 2
  2870                                  
  2871                                  ;-12             prc(' ');
  2872                                  
  2873 00001EF0 6A20                     push 32
  2874 00001EF2 E85000                   call prc
  2875 00001EF5 83C402                   add  sp, 2
  2876                                  
  2877                                  ;-13             i++;
  2878                                  
  2879 00001EF8 FF46FE                   inc  word [bp-2]
  2880                                  
  2881                                  ;-14         } while (i < OpPrintIndex);
  2882                                  
  2883 00001EFB 8B46FE                   mov ax, [bp-2]
  2884 00001EFE 3B06[C501]               cmp ax, [OpPrintIndex]
  2885 00001F02 0F8D0200                 jge @@printLine113
  2886 00001F06 EBD2                     jmp @@printLine112
  2887                                  @@printLine113:
  2888                                  
  2889                                  ;-15         do {// fill rest with blank
  2890                                  
  2891                                  @@printLine114:
  2892                                  
  2893                                  ;-16             prs("   ");
  2894                                  
  2895 00001F08 68[411F]                 push printLine_2
  2896 00001F0B E89800                   call prs
  2897 00001F0E 83C402                   add  sp, 2
  2898                                  
  2899                                  ;-17             i++;
  2900                                  
  2901 00001F11 FF46FE                   inc  word [bp-2]
  2902                                  
  2903                                  ;-18         } while (i < OPMAXLEN);
  2904                                  
  2905 00001F14 8B46FE                   mov ax, [bp-2]
  2906 00001F17 83F805                   cmp ax, 5
  2907 00001F1A 0F8D0200                 jge @@printLine115
  2908 00001F1E EBE8                     jmp @@printLine114
  2909                                  @@printLine115:
  2910                                  
  2911                                  ;-19     }
  2912                                  
  2913                                  
  2914                                  ;-20     prscomment(InputBuf);
  2915                                  
  2916                                  @@printLine111:
  2917 00001F20 8D06[4F00]               lea  ax, [InputBuf]
  2918 00001F24 50                       push ax
  2919 00001F25 E85000                   call prscomment
  2920 00001F28 83C402                   add  sp, 2
  2921                                  
  2922                                  ;-21 }
  2923                                  
  2924                                  
  2925                                  ;-22 int prc(unsigned char c) {//print char 
  2926 00001F2B C9                       LEAVE
  2927 00001F2C C3                       ret
  2928                                  ; ENDP
  2929 00001F2D 5C6E00                  printLine_0 db "\n",0
  2930 00001F30 202020202020202020-     printLine_1 db "                ",0
  2931 00001F39 2020202020202000   
  2932 00001F41 20202000                printLine_2 db "   ",0
  2933                                  
  2934                                  prc:  ; *** PROC ***
  2935                                  
  2936                                  ;-23     if (LIST) { 
  2937                                  
  2938                                  ;Function : prc, Number of local variables: 1
  2939                                  ;   # type sign width line used address name   list of local variables
  2940                                  ;  200 var unsg byte    22 NULL bp+4    c;
  2941 00001F45 C8000000                 ENTER  0,0
  2942 00001F49 A0[0E00]                 mov al, [LIST]
  2943 00001F4C 08C0                     or  al, al
  2944 00001F4E 0F841400                 je @@prc116
  2945                                  
  2946                                  ;-24         if ( _ c==10) {
  2947                                  
  2948 00001F52 807E040A                cmp byte [bp+4], 10
  2949 00001F56 0F850600                 jne @@prc117
  2950                                  
  2951                                  ;-25             ax=13; 
  2952                                  
  2953 00001F5A B80D00                   mov  ax, 13
  2954                                  
  2955                                  ;-26             writetty(); 
  2956                                  
  2957 00001F5D E89611                   call writetty
  2958                                  
  2959                                  ;-27             }
  2960                                  
  2961                                  
  2962                                  ;-28         al=c; 
  2963                                  
  2964                                  @@prc117:
  2965 00001F60 8A4604                   mov  al, [bp+4]
  2966                                  
  2967                                  ;-29         writetty(); 
  2968                                  
  2969 00001F63 E89011                   call writetty
  2970                                  
  2971                                  ;-30         }
  2972                                  
  2973                                  
  2974                                  ;-31     fputcR(c,lst_fd); 
  2975                                  
  2976                                  @@prc116:
  2977 00001F66 FF36[9B01]               push word [lst_fd]
  2978 00001F6A 8A4604                   mov al, byte [bp+4]
  2979 00001F6D B400                     mov ah, 0
  2980 00001F6F 50                       push ax
  2981 00001F70 E84313                   call fputcR
  2982 00001F73 83C404                   add  sp, 4
  2983                                  
  2984                                  ;-32 }
  2985                                  
  2986                                  
  2987                                  ;-33 
  2988                                  
  2989                                  
  2990                                  ;-34 int prscomment(unsigned char *s) {
  2991 00001F76 C9                       LEAVE
  2992 00001F77 C3                       ret
  2993                                  ; ENDP
  2994                                  
  2995                                  prscomment:  ; *** PROC ***
  2996                                  
  2997                                  ;-35     unsigned char c;
  2998                                  
  2999                                  
  3000                                  ;-36     while (*s){
  3001                                  
  3002                                  ;Function : prscomment, Number of local variables: 2
  3003                                  ;   # type sign width line used address name   list of local variables
  3004                                  ;  200 ptr unsg byte    34 NULL bp+4    s
  3005                                  ;  201 var unsg byte    35 NULL bp-2    c;
  3006 00001F78 C8020000                 ENTER  2,0
  3007                                  @@prscomment118:
  3008 00001F7C 8B5E04                   mov bx, [bp+4]
  3009 00001F7F 8A07                     mov al, [bx]
  3010 00001F81 B400                     mov ah, 0
  3011 00001F83 08C0                     or  al, al
  3012 00001F85 0F841B00                 je @@prscomment119
  3013                                  
  3014                                  ;-37         c=*s;
  3015                                  
  3016 00001F89 8B5E04                   mov bx, [bp+4]
  3017 00001F8C 8A07                     mov al, [bx]
  3018 00001F8E B400                     mov ah, 0
  3019 00001F90 8846FE                   mov byte [bp-2], al
  3020                                  
  3021                                  ;-38         prc(c);
  3022                                  
  3023 00001F93 8A46FE                   mov al, byte [bp-2]
  3024 00001F96 B400                     mov ah, 0
  3025 00001F98 50                       push ax
  3026 00001F99 E8A9FF                   call prc
  3027 00001F9C 83C402                   add  sp, 2
  3028                                  
  3029                                  ;-39         s++;
  3030                                  
  3031 00001F9F FF4604                   inc  word [bp+4]
  3032                                  
  3033                                  ;-40     }
  3034                                  
  3035                                  
  3036                                  ;-41 }
  3037                                  
  3038 00001FA2 EBD8                     jmp @@prscomment118
  3039                                  @@prscomment119:
  3040                                  
  3041                                  ;-42 int prs(unsigned char *s) {
  3042 00001FA4 C9                       LEAVE
  3043 00001FA5 C3                       ret
  3044                                  ; ENDP
  3045                                  
  3046                                  prs:  ; *** PROC ***
  3047                                  
  3048                                  ;-43     unsigned char c; 
  3049                                  
  3050                                  
  3051                                  ;-44     int com; 
  3052                                  
  3053                                  
  3054                                  ;-45     com=0;
  3055                                  
  3056                                  ;Function : prs, Number of local variables: 3
  3057                                  ;   # type sign width line used address name   list of local variables
  3058                                  ;  200 ptr unsg byte    42 NULL bp+4    s
  3059                                  ;  201 var unsg byte    43 NULL bp-2    c
  3060                                  ;  202 var sign word    44 NULL bp-4    com;
  3061 00001FA6 C8040000                 ENTER  4,0
  3062 00001FAA 66B800000000             mov eax, 0
  3063 00001FB0 8946FC                   mov word [bp-4], ax
  3064                                  
  3065                                  ;-46     while (*s) { 
  3066                                  
  3067                                  @@prs120:
  3068 00001FB3 8B5E04                   mov bx, [bp+4]
  3069 00001FB6 8A07                     mov al, [bx]
  3070 00001FB8 B400                     mov ah, 0
  3071 00001FBA 08C0                     or  al, al
  3072 00001FBC 0F848700                 je @@prs121
  3073                                  
  3074                                  ;-47         c=*s; 
  3075                                  
  3076 00001FC0 8B5E04                   mov bx, [bp+4]
  3077 00001FC3 8A07                     mov al, [bx]
  3078 00001FC5 B400                     mov ah, 0
  3079 00001FC7 8846FE                   mov byte [bp-2], al
  3080                                  
  3081                                  ;-48         if (c==34) {
  3082                                  
  3083 00001FCA 8A46FE                   mov al, [bp-2]
  3084 00001FCD 3C22                     cmp al, 34
  3085 00001FCF 0F851E00                 jne @@prs122
  3086                                  
  3087                                  ;-49             if (com) com=0; 
  3088                                  
  3089 00001FD3 8B46FC                   mov ax, [bp-4]
  3090 00001FD6 08C0                     or  al, al
  3091 00001FD8 0F840C00                 je @@prs123
  3092 00001FDC 66B800000000             mov eax, 0
  3093 00001FE2 8946FC                   mov word [bp-4], ax
  3094                                  
  3095                                  ;-50                 else com=1;  
  3096                                  
  3097 00001FE5 E90900                   jmp @@prs124
  3098                                  @@prs123:
  3099 00001FE8 66B801000000             mov eax, 1
  3100 00001FEE 8946FC                   mov word [bp-4], ax
  3101                                  
  3102                                  ;-51         }
  3103                                  
  3104                                  @@prs124:
  3105                                  
  3106                                  ;-52         if (c==92) { 
  3107                                  
  3108                                  @@prs122:
  3109 00001FF1 8A46FE                   mov al, [bp-2]
  3110 00001FF4 3C5C                     cmp al, 92
  3111 00001FF6 0F853B00                 jne @@prs125
  3112                                  
  3113                                  ;-53             if (com==0) { 
  3114                                  
  3115 00001FFA 8B46FC                   mov ax, [bp-4]
  3116 00001FFD 83F800                   cmp ax, 0
  3117 00002000 0F853100                 jne @@prs126
  3118                                  
  3119                                  ;-54                 s++; 
  3120                                  
  3121 00002004 FF4604                   inc  word [bp+4]
  3122                                  
  3123                                  ;-55                 c=*s;
  3124                                  
  3125 00002007 8B5E04                   mov bx, [bp+4]
  3126 0000200A 8A07                     mov al, [bx]
  3127 0000200C B400                     mov ah, 0
  3128 0000200E 8846FE                   mov byte [bp-2], al
  3129                                  
  3130                                  ;-56                 if (c=='n') c=10; 
  3131                                  
  3132 00002011 8A46FE                   mov al, [bp-2]
  3133 00002014 3C6E                     cmp al, 110
  3134 00002016 0F850900                 jne @@prs127
  3135 0000201A 66B80A000000             mov eax, 10
  3136 00002020 8846FE                   mov byte [bp-2], al
  3137                                  
  3138                                  ;-57                 if (c=='t') c= 9; 
  3139                                  
  3140                                  @@prs127:
  3141 00002023 8A46FE                   mov al, [bp-2]
  3142 00002026 3C74                     cmp al, 116
  3143 00002028 0F850900                 jne @@prs128
  3144 0000202C 66B809000000             mov eax, 9
  3145 00002032 8846FE                   mov byte [bp-2], al
  3146                                  
  3147                                  ;-58             } 
  3148                                  
  3149                                  @@prs128:
  3150                                  
  3151                                  ;-59         } 
  3152                                  
  3153                                  @@prs126:
  3154                                  
  3155                                  ;-60         prc(c); 
  3156                                  
  3157                                  @@prs125:
  3158 00002035 8A46FE                   mov al, byte [bp-2]
  3159 00002038 B400                     mov ah, 0
  3160 0000203A 50                       push ax
  3161 0000203B E807FF                   call prc
  3162 0000203E 83C402                   add  sp, 2
  3163                                  
  3164                                  ;-61         s++;  
  3165                                  
  3166 00002041 FF4604                   inc  word [bp+4]
  3167                                  
  3168                                  ;-62     }
  3169                                  
  3170                                  
  3171                                  ;-63 }
  3172                                  
  3173 00002044 E96CFF                   jmp @@prs120
  3174                                  @@prs121:
  3175                                  
  3176                                  ;-64 int printhex8a(unsigned char c) { 
  3177 00002047 C9                       LEAVE
  3178 00002048 C3                       ret
  3179                                  ; ENDP
  3180                                  
  3181                                  printhex8a:  ; *** PROC ***
  3182                                  
  3183                                  ;-65     unsigned char nib;
  3184                                  
  3185                                  
  3186                                  ;-66     nib = c >> 4; printhex4(nib);                    
  3187                                  
  3188                                  ;Function : printhex8a, Number of local variables: 2
  3189                                  ;   # type sign width line used address name   list of local variables
  3190                                  ;  200 var unsg byte    64 NULL bp+4    c
  3191                                  ;  201 var unsg byte    65 NULL bp-2    nib;
  3192 00002049 C8020000                 ENTER  2,0
  3193 0000204D 8A4604                   mov al, [bp+4]
  3194 00002050 C0E804                   shr al, 4
  3195 00002053 8846FE                   mov byte [bp-2], al
  3196 00002056 8A46FE                   mov al, byte [bp-2]
  3197 00002059 B400                     mov ah, 0
  3198 0000205B 50                       push ax
  3199 0000205C E81900                   call printhex4
  3200 0000205F 83C402                   add  sp, 2
  3201                                  
  3202                                  ;-67     nib = c & 15; printhex4(nib);                    
  3203                                  
  3204 00002062 8A4604                   mov al, [bp+4]
  3205 00002065 240F                     and al, 15
  3206 00002067 8846FE                   mov byte [bp-2], al
  3207 0000206A 8A46FE                   mov al, byte [bp-2]
  3208 0000206D B400                     mov ah, 0
  3209 0000206F 50                       push ax
  3210 00002070 E80500                   call printhex4
  3211 00002073 83C402                   add  sp, 2
  3212                                  
  3213                                  ;-68 } 
  3214                                  
  3215                                  
  3216                                  ;-69 int printhex4(unsigned char c) {
  3217 00002076 C9                       LEAVE
  3218 00002077 C3                       ret
  3219                                  ; ENDP
  3220                                  
  3221                                  printhex4:  ; *** PROC ***
  3222                                  
  3223                                  ;-70     c += 48; 
  3224                                  
  3225                                  ;Function : printhex4, Number of local variables: 1
  3226                                  ;   # type sign width line used address name   list of local variables
  3227                                  ;  200 var unsg byte    69 NULL bp+4    c;
  3228 00002078 C8000000                 ENTER  0,0
  3229 0000207C 80460430                 add  byte [bp+4], 48
  3230                                  
  3231                                  ;-71     if (c > 57) c += 7; 
  3232                                  
  3233 00002080 8A4604                   mov al, [bp+4]
  3234 00002083 3C39                     cmp al, 57
  3235 00002085 0F8E0400                 jle @@printhex4129
  3236 00002089 80460407                 add  byte [bp+4], 7
  3237                                  
  3238                                  ;-72     prc(c);      
  3239                                  
  3240                                  @@printhex4129:
  3241 0000208D 8A4604                   mov al, byte [bp+4]
  3242 00002090 B400                     mov ah, 0
  3243 00002092 50                       push ax
  3244 00002093 E8AFFE                   call prc
  3245 00002096 83C402                   add  sp, 2
  3246                                  
  3247                                  ;-73 }
  3248                                  
  3249                                  
  3250                                  ;-74 int printhex16(unsigned int i) {
  3251 00002099 C9                       LEAVE
  3252 0000209A C3                       ret
  3253                                  ; ENDP
  3254                                  
  3255                                  printhex16:  ; *** PROC ***
  3256                                  
  3257                                  ;-75     unsigned int half;
  3258                                  
  3259                                  
  3260                                  ;-76     half = i >>  8; printhex8a(half); 
  3261                                  
  3262                                  ;Function : printhex16, Number of local variables: 2
  3263                                  ;   # type sign width line used address name   list of local variables
  3264                                  ;  200 var unsg word    74 NULL bp+4    i
  3265                                  ;  201 var unsg word    75 NULL bp-2    half;
  3266 0000209B C8020000                 ENTER  2,0
  3267 0000209F 8B4604                   mov ax, [bp+4]
  3268 000020A2 C1E808                   shr ax, 8
  3269 000020A5 8946FE                   mov word [bp-2], ax
  3270 000020A8 FF76FE                   push word [bp-2]
  3271 000020AB E89BFF                   call printhex8a
  3272 000020AE 83C402                   add  sp, 2
  3273                                  
  3274                                  ;-77     half = i & 255; printhex8a(half);
  3275                                  
  3276 000020B1 8B4604                   mov ax, [bp+4]
  3277 000020B4 25FF00                   and ax, 255
  3278 000020B7 8946FE                   mov word [bp-2], ax
  3279 000020BA FF76FE                   push word [bp-2]
  3280 000020BD E889FF                   call printhex8a
  3281 000020C0 83C402                   add  sp, 2
  3282                                  
  3283                                  ;-78 }
  3284                                  
  3285                                  
  3286                                  ;-79 int printIntU(unsigned int n) { 
  3287 000020C3 C9                       LEAVE
  3288 000020C4 C3                       ret
  3289                                  ; ENDP
  3290                                  
  3291                                  printIntU:  ; *** PROC ***
  3292                                  
  3293                                  ;-80     unsigned int e;
  3294                                  
  3295                                  
  3296                                  ;-81     if ( _ n >= 10) {  
  3297                                  
  3298                                  ;Function : printIntU, Number of local variables: 2
  3299                                  ;   # type sign width line used address name   list of local variables
  3300                                  ;  200 var unsg word    79 NULL bp+4    n
  3301                                  ;  201 var unsg word    80 NULL bp-2    e;
  3302 000020C5 C8020000                 ENTER  2,0
  3303 000020C9 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3304 000020CD 0F821700                 jb  @@printIntU130
  3305                                  
  3306                                  ;-82         e=n/10; //DIV
  3307                                  
  3308 000020D1 8B4604                   mov ax, [bp+4]
  3309 000020D4 BB0A00                   mov bx, 10
  3310 000020D7 BA0000                   mov dx, 0
  3311 000020DA F7F3                     div bx
  3312 000020DC 8946FE                   mov word [bp-2], ax
  3313                                  
  3314                                  ;-83         printIntU(e); 
  3315                                  
  3316 000020DF FF76FE                   push word [bp-2]
  3317 000020E2 E8E0FF                   call printIntU
  3318 000020E5 83C402                   add  sp, 2
  3319                                  
  3320                                  ;-84     }
  3321                                  
  3322                                  
  3323                                  ;-85     n = n % 10; //unsigned mod
  3324                                  
  3325                                  @@printIntU130:
  3326 000020E8 8B4604                   mov ax, [bp+4]
  3327 000020EB BB0A00                   mov bx, 10
  3328 000020EE BA0000                   mov dx, 0
  3329 000020F1 F7F3                     div bx
  3330 000020F3 89D0                     mov ax, dx
  3331 000020F5 894604                   mov word [bp+4], ax
  3332                                  
  3333                                  ;-86     n += '0'; 
  3334                                  
  3335 000020F8 83460430                 add  word [bp+4], 48
  3336                                  
  3337                                  ;-87     prc(n);
  3338                                  
  3339 000020FC FF7604                   push word [bp+4]
  3340 000020FF E843FE                   call prc
  3341 00002102 83C402                   add  sp, 2
  3342                                  
  3343                                  ;-88 }
  3344                                  
  3345                                  
  3346                                  ;-89 
  3347                                  
  3348                                  
  3349                                  ;-90 int error1(char *s) { 
  3350 00002105 C9                       LEAVE
  3351 00002106 C3                       ret
  3352                                  ; ENDP
  3353                                  
  3354                                  error1:  ; *** PROC ***
  3355                                  
  3356                                  ;-91     LIST=1; 
  3357                                  
  3358                                  ;Function : error1, Number of local variables: 1
  3359                                  ;   # type sign width line used address name   list of local variables
  3360                                  ;  200 ptr sign byte    90 NULL bp+4    s;
  3361 00002107 C8000000                 ENTER  0,0
  3362 0000210B 66B801000000             mov eax, 1
  3363 00002111 A2[0E00]                 mov byte [LIST], al
  3364                                  
  3365                                  ;-92     ErrorCount++;
  3366                                  
  3367 00002114 FF06[A101]               inc  word [ErrorCount]
  3368                                  
  3369                                  ;-93     prs("\n;***** next line ERROR: "); 
  3370                                  
  3371 00002118 68[4021]                 push error1_0
  3372 0000211B E888FE                   call prs
  3373 0000211E 83C402                   add  sp, 2
  3374                                  
  3375                                  ;-94     prs(s);
  3376                                  
  3377 00002121 FF7604                   push word [bp+4]
  3378 00002124 E87FFE                   call prs
  3379 00002127 83C402                   add  sp, 2
  3380                                  
  3381                                  ;-95     prs(", Symbol: "); 
  3382                                  
  3383 0000212A 68[5B21]                 push error1_1
  3384 0000212D E876FE                   call prs
  3385 00002130 83C402                   add  sp, 2
  3386                                  
  3387                                  ;-96     prs(Symbol);
  3388                                  
  3389 00002133 8D06[0F00]               lea  ax, [Symbol]
  3390 00002137 50                       push ax
  3391 00002138 E86BFE                   call prs
  3392 0000213B 83C402                   add  sp, 2
  3393                                  
  3394                                  ;-97 }
  3395                                  
  3396                                  
  3397                                  ;-98 int errorexit(char *s) { 
  3398 0000213E C9                       LEAVE
  3399 0000213F C3                       ret
  3400                                  ; ENDP
  3401 00002140 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3402 00002149 6E657874206C696E65-
  3403 00002152 204552524F523A2000 
  3404 0000215B 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3405 00002164 2000               
  3406                                  
  3407                                  errorexit:  ; *** PROC ***
  3408                                  
  3409                                  ;-99     error1(s); 
  3410                                  
  3411                                  ;Function : errorexit, Number of local variables: 1
  3412                                  ;   # type sign width line used address name   list of local variables
  3413                                  ;  200 ptr sign byte    98 NULL bp+4    s;
  3414 00002166 C8000000                 ENTER  0,0
  3415 0000216A FF7604                   push word [bp+4]
  3416 0000216D E897FF                   call error1
  3417 00002170 83C402                   add  sp, 2
  3418                                  
  3419                                  ;-100     end1(1);
  3420                                  
  3421 00002173 6A01                     push 1
  3422 00002175 E8AA04                   call end1
  3423 00002178 83C402                   add  sp, 2
  3424                                  
  3425                                  ;-101 }
  3426                                  
  3427                                  
  3428                                  ;-102 int allowederror() {error1("not allowed here"); }
  3429 0000217B C9                       LEAVE
  3430 0000217C C3                       ret
  3431                                  ; ENDP
  3432                                  
  3433                                  allowederror:  ; *** PROC ***
  3434 0000217D 68[8721]                 push allowederror_0
  3435 00002180 E884FF                   call error1
  3436 00002183 83C402                   add  sp, 2
  3437                                  
  3438                                  ;-103 int addrerror()    {error1("address missing");} 
  3439                                  
  3440 00002186 C3                       ret
  3441                                  ; ENDP
  3442 00002187 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3443 00002190 6564206865726500   
  3444                                  
  3445                                  addrerror:  ; *** PROC ***
  3446 00002198 68[A221]                 push addrerror_0
  3447 0000219B E869FF                   call error1
  3448 0000219E 83C402                   add  sp, 2
  3449                                  
  3450                                  ;-104 int immeerror()    {error1("immediate not allowed here");}
  3451                                  
  3452 000021A1 C3                       ret
  3453                                  ; ENDP
  3454 000021A2 61646472657373206D-     addrerror_0 db "address missing",0
  3455 000021AB 697373696E6700     
  3456                                  
  3457                                  immeerror:  ; *** PROC ***
  3458 000021B2 68[BC21]                 push immeerror_0
  3459 000021B5 E84FFF                   call error1
  3460 000021B8 83C402                   add  sp, 2
  3461                                  
  3462                                  ;-105 int implerror()    {error1("not implemented");}
  3463                                  
  3464 000021BB C3                       ret
  3465                                  ; ENDP
  3466 000021BC 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  3467 000021C5 206E6F7420616C6C6F-
  3468 000021CE 776564206865726500 
  3469                                  
  3470                                  implerror:  ; *** PROC ***
  3471 000021D7 68[E121]                 push implerror_0
  3472 000021DA E82AFF                   call error1
  3473 000021DD 83C402                   add  sp, 2
  3474                                  
  3475                                  ;-106 int indexerror()   {error1("invalid index register");}
  3476                                  
  3477 000021E0 C3                       ret
  3478                                  ; ENDP
  3479 000021E1 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3480 000021EA 6D656E74656400     
  3481                                  
  3482                                  indexerror:  ; *** PROC ***
  3483 000021F1 68[FB21]                 push indexerror_0
  3484 000021F4 E810FF                   call error1
  3485 000021F7 83C402                   add  sp, 2
  3486                                  
  3487                                  ;-107 int invaloperror() {error1("invalid or no operands");}
  3488                                  
  3489 000021FA C3                       ret
  3490                                  ; ENDP
  3491 000021FB 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3492 00002204 6E6465782072656769-
  3493 0000220D 7374657200         
  3494                                  
  3495                                  invaloperror:  ; *** PROC ***
  3496 00002212 68[1C22]                 push invaloperror_0
  3497 00002215 E8EFFE                   call error1
  3498 00002218 83C402                   add  sp, 2
  3499                                  
  3500                                  ;-108 int numbererror()  {error1("number expected");}
  3501                                  
  3502 0000221B C3                       ret
  3503                                  ; ENDP
  3504 0000221C 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3505 00002225 72206E6F206F706572-
  3506 0000222E 616E647300         
  3507                                  
  3508                                  numbererror:  ; *** PROC ***
  3509 00002233 68[3D22]                 push numbererror_0
  3510 00002236 E8CEFE                   call error1
  3511 00002239 83C402                   add  sp, 2
  3512                                  
  3513                                  ;-109 int regmemerror()  {error1("only register or memory allowed");}
  3514                                  
  3515 0000223C C3                       ret
  3516                                  ; ENDP
  3517 0000223D 6E756D626572206578-     numbererror_0 db "number expected",0
  3518 00002246 70656374656400     
  3519                                  
  3520                                  regmemerror:  ; *** PROC ***
  3521 0000224D 68[5722]                 push regmemerror_0
  3522 00002250 E8B4FE                   call error1
  3523 00002253 83C402                   add  sp, 2
  3524                                  
  3525                                  ;-110 int reg16error()   {error1("only reg16, no segreg allowed");}
  3526                                  
  3527 00002256 C3                       ret
  3528                                  ; ENDP
  3529 00002257 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3530 00002260 73746572206F72206D-
  3531 00002269 656D6F727920616C6C-
  3532 00002272 6F77656400         
  3533                                  
  3534                                  reg16error:  ; *** PROC ***
  3535 00002277 68[8122]                 push reg16error_0
  3536 0000227A E88AFE                   call error1
  3537 0000227D 83C402                   add  sp, 2
  3538                                  
  3539                                  ;-111 int segregerror()  {error1("segment register not allowed");}
  3540                                  
  3541 00002280 C3                       ret
  3542                                  ; ENDP
  3543 00002281 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3544 0000228A 362C206E6F20736567-
  3545 00002293 72656720616C6C6F77-
  3546 0000229C 656400             
  3547                                  
  3548                                  segregerror:  ; *** PROC ***
  3549 0000229F 68[A922]                 push segregerror_0
  3550 000022A2 E862FE                   call error1
  3551 000022A5 83C402                   add  sp, 2
  3552                                  
  3553                                  ;-112 int syntaxerror()  {error1("syntax");}
  3554                                  
  3555 000022A8 C3                       ret
  3556                                  ; ENDP
  3557 000022A9 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3558 000022B2 65676973746572206E-
  3559 000022BB 6F7420616C6C6F7765-
  3560 000022C4 6400               
  3561                                  
  3562                                  syntaxerror:  ; *** PROC ***
  3563 000022C6 68[D022]                 push syntaxerror_0
  3564 000022C9 E83BFE                   call error1
  3565 000022CC 83C402                   add  sp, 2
  3566                                  
  3567                                  ;-113          
  3568                                  
  3569                                  
  3570                                  ;-114 int addrexit()     {errorexit("illegal address");}
  3571                                  
  3572 000022CF C3                       ret
  3573                                  ; ENDP
  3574 000022D0 73796E74617800          syntaxerror_0 db "syntax",0
  3575                                  
  3576                                  addrexit:  ; *** PROC ***
  3577 000022D7 68[E122]                 push addrexit_0
  3578 000022DA E889FE                   call errorexit
  3579 000022DD 83C402                   add  sp, 2
  3580                                  
  3581                                  ;-115 int internexit()   {errorexit("intern compiler error");}
  3582                                  
  3583 000022E0 C3                       ret
  3584                                  ; ENDP
  3585 000022E1 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3586 000022EA 64647265737300     
  3587                                  
  3588                                  internexit:  ; *** PROC ***
  3589 000022F1 68[FB22]                 push internexit_0
  3590 000022F4 E86FFE                   call errorexit
  3591 000022F7 83C402                   add  sp, 2
  3592 000022FA C3                       ret
  3593                                  ; ENDP
  3594 000022FB 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3595 00002304 6D70696C6572206572-
  3596 0000230D 726F7200           
  3597                                  ;Back to main program: AS.C
  3598                                  
  3599                                  ;-7 #include "MAIN.C"
  3600                                  
  3601                                  ;Use include file: MAIN.C
  3602                                  
  3603                                  ;-1 int main() {
  3604                                  
  3605                                  
  3606                                  main:  ; *** PROC ***
  3607                                  
  3608                                  ;-2   getarg(); 
  3609                                  
  3610 00002311 E80A00                   call getarg
  3611                                  
  3612                                  ;-3   parse(); 
  3613                                  
  3614 00002314 E8D8EE                   call parse
  3615                                  
  3616                                  ;-4   epilog(); 
  3617                                  
  3618 00002317 E85C02                   call epilog
  3619                                  
  3620                                  ;-5   end1();
  3621                                  
  3622 0000231A E80503                   call end1
  3623                                  
  3624                                  ;-6 }
  3625                                  
  3626                                  
  3627                                  ;-7 
  3628                                  
  3629                                  
  3630                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3631                                  
  3632 0000231D C3                       ret
  3633                                  ; ENDP
  3634                                  
  3635                                  getarg:  ; *** PROC ***
  3636                                  
  3637                                  ;-9   arglen1=*arglen;
  3638                                  
  3639                                  ;Function : getarg, Number of local variables: 3
  3640                                  ;   # type sign width line used address name   list of local variables
  3641                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3642                                  ;  201 var sign word     8 NULL bp-4    i
  3643                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3644 0000231E C8060000                 ENTER  6,0
  3645 00002322 8B1E[520E]               mov bx, [arglen]
  3646 00002326 8A07                     mov al, [bx]
  3647 00002328 B400                     mov ah, 0
  3648 0000232A 8946FE                   mov word [bp-2], ax
  3649                                  
  3650                                  ;-10   if (arglen1==0) {
  3651                                  
  3652 0000232D 8B46FE                   mov ax, [bp-2]
  3653 00002330 83F800                   cmp ax, 0
  3654 00002333 0F851C00                 jne @@getarg131
  3655                                  
  3656                                  ;-11     cputs(Version1);
  3657                                  
  3658 00002337 8D06[0300]               lea  ax, [Version1]
  3659 0000233B 50                       push ax
  3660 0000233C E8BF0D                   call cputs
  3661 0000233F 83C402                   add  sp, 2
  3662                                  
  3663                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3664                                  
  3665 00002342 68[E324]                 push getarg_0
  3666 00002345 E8B60D                   call cputs
  3667 00002348 83C402                   add  sp, 2
  3668                                  
  3669                                  ;-13     exitR(3);
  3670                                  
  3671 0000234B 6A03                     push 3
  3672 0000234D E8890F                   call exitR
  3673 00002350 83C402                   add  sp, 2
  3674                                  
  3675                                  ;-14   }
  3676                                  
  3677                                  
  3678                                  ;-15   i=arglen1+129; 
  3679                                  
  3680                                  @@getarg131:
  3681 00002353 8B46FE                   mov ax, [bp-2]
  3682 00002356 058100                   add ax, 129
  3683 00002359 8946FC                   mov word [bp-4], ax
  3684                                  
  3685                                  ;-16   *i=0;  
  3686                                  
  3687 0000235C 66B800000000             mov eax, 0
  3688 00002362 8B5EFC                   mov  bx, [bp-4]
  3689 00002365 8907                     mov  [bx], ax
  3690                                  
  3691                                  ;-17   arglen1--;
  3692                                  
  3693 00002367 FF4EFE                   dec  word [bp-2]
  3694                                  
  3695                                  ;-18   toupper(argv);
  3696                                  
  3697 0000236A FF36[540E]               push word [argv]
  3698 0000236E E8BB0D                   call toupper
  3699 00002371 83C402                   add  sp, 2
  3700                                  
  3701                                  ;-19   
  3702                                  
  3703                                  
  3704                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3705                                  
  3706 00002374 FF36[540E]               push word [argv]
  3707 00002378 8D06[D000]               lea  ax, [namein]
  3708 0000237C 50                       push ax
  3709 0000237D E81A0E                   call strcpy
  3710 00002380 83C404                   add  sp, 4
  3711 00002383 68[0825]                 push getarg_1
  3712 00002386 8D06[D000]               lea  ax, [namein]
  3713 0000238A 50                       push ax
  3714 0000238B E8CD0E                   call strcat1
  3715 0000238E 83C404                   add  sp, 4
  3716                                  
  3717                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3718                                  
  3719 00002391 FF36[540E]               push word [argv]
  3720 00002395 8D06[1301]               lea  ax, [namelst]
  3721 00002399 50                       push ax
  3722 0000239A E8FD0D                   call strcpy
  3723 0000239D 83C404                   add  sp, 4
  3724 000023A0 68[0B25]                 push getarg_2
  3725 000023A3 8D06[1301]               lea  ax, [namelst]
  3726 000023A7 50                       push ax
  3727 000023A8 E8B00E                   call strcat1
  3728 000023AB 83C404                   add  sp, 4
  3729                                  
  3730                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3731                                  
  3732 000023AE FF36[540E]               push word [argv]
  3733 000023B2 8D06[5601]               lea  ax, [namebin]
  3734 000023B6 50                       push ax
  3735 000023B7 E8E00D                   call strcpy
  3736 000023BA 83C404                   add  sp, 4
  3737 000023BD 68[1025]                 push getarg_3
  3738 000023C0 8D06[5601]               lea  ax, [namebin]
  3739 000023C4 50                       push ax
  3740 000023C5 E8930E                   call strcat1
  3741 000023C8 83C404                   add  sp, 4
  3742                                  
  3743                                  ;-23 
  3744                                  
  3745                                  
  3746                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3747                                  
  3748 000023CB 66B801000000             mov eax, 1
  3749 000023D1 A2[0E00]                 mov byte [LIST], al
  3750 000023D4 66B800000000             mov eax, 0
  3751 000023DA A3[9F01]                 mov word [DOS_ERR], ax
  3752 000023DD 66B800000000             mov eax, 0
  3753 000023E3 A3[A601]                 mov word [PC], ax
  3754 000023E6 66B800000000             mov eax, 0
  3755 000023EC A3[A101]                 mov word [ErrorCount], ax
  3756                                  
  3757                                  ;-25   
  3758                                  
  3759                                  
  3760                                  ;-26   asm_fd=openR (namein);
  3761                                  
  3762 000023EF 8D06[D000]               lea  ax, [namein]
  3763 000023F3 50                       push ax
  3764 000023F4 E8890E                   call openR
  3765 000023F7 83C402                   add  sp, 2
  3766 000023FA A3[9901]                 mov word [asm_fd], ax
  3767                                  
  3768                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3769                                  
  3770 000023FD A1[9F01]                 mov ax, [DOS_ERR]
  3771 00002400 08C0                     or  al, al
  3772 00002402 0F841C00                 je @@getarg132
  3773 00002406 68[1525]                 push getarg_4
  3774 00002409 E8F20C                   call cputs
  3775 0000240C 83C402                   add  sp, 2
  3776 0000240F 8D06[D000]               lea  ax, [namein]
  3777 00002413 50                       push ax
  3778 00002414 E8E70C                   call cputs
  3779 00002417 83C402                   add  sp, 2
  3780 0000241A 6A01                     push 1
  3781 0000241C E8BA0E                   call exitR
  3782 0000241F 83C402                   add  sp, 2
  3783                                  
  3784                                  ;-28   lst_fd=creatR(namelst);
  3785                                  
  3786                                  @@getarg132:
  3787 00002422 8D06[1301]               lea  ax, [namelst]
  3788 00002426 50                       push ax
  3789 00002427 E8650E                   call creatR
  3790 0000242A 83C402                   add  sp, 2
  3791 0000242D A3[9B01]                 mov word [lst_fd], ax
  3792                                  
  3793                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3794                                  
  3795 00002430 A1[9F01]                 mov ax, [DOS_ERR]
  3796 00002433 08C0                     or  al, al
  3797 00002435 0F841C00                 je @@getarg133
  3798 00002439 68[2B25]                 push getarg_5
  3799 0000243C E8BF0C                   call cputs
  3800 0000243F 83C402                   add  sp, 2
  3801 00002442 8D06[1301]               lea  ax, [namelst]
  3802 00002446 50                       push ax
  3803 00002447 E8B40C                   call cputs
  3804 0000244A 83C402                   add  sp, 2
  3805 0000244D 6A02                     push 2
  3806 0000244F E8870E                   call exitR
  3807 00002452 83C402                   add  sp, 2
  3808                                  
  3809                                  ;-30   bin_fd=creatR(namebin);
  3810                                  
  3811                                  @@getarg133:
  3812 00002455 8D06[5601]               lea  ax, [namebin]
  3813 00002459 50                       push ax
  3814 0000245A E8320E                   call creatR
  3815 0000245D 83C402                   add  sp, 2
  3816 00002460 A3[9D01]                 mov word [bin_fd], ax
  3817                                  
  3818                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3819                                  
  3820 00002463 A1[9F01]                 mov ax, [DOS_ERR]
  3821 00002466 08C0                     or  al, al
  3822 00002468 0F841C00                 je @@getarg134
  3823 0000246C 68[4225]                 push getarg_6
  3824 0000246F E88C0C                   call cputs
  3825 00002472 83C402                   add  sp, 2
  3826 00002475 8D06[5601]               lea  ax, [namebin]
  3827 00002479 50                       push ax
  3828 0000247A E8810C                   call cputs
  3829 0000247D 83C402                   add  sp, 2
  3830 00002480 6A02                     push 2
  3831 00002482 E8540E                   call exitR
  3832 00002485 83C402                   add  sp, 2
  3833                                  
  3834                                  ;-32   
  3835                                  
  3836                                  
  3837                                  ;-33   prs(";");prs(Version1);
  3838                                  
  3839                                  @@getarg134:
  3840 00002488 68[5825]                 push getarg_7
  3841 0000248B E818FB                   call prs
  3842 0000248E 83C402                   add  sp, 2
  3843 00002491 8D06[0300]               lea  ax, [Version1]
  3844 00002495 50                       push ax
  3845 00002496 E80DFB                   call prs
  3846 00002499 83C402                   add  sp, 2
  3847                                  
  3848                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3849                                  
  3850 0000249C 68[5A25]                 push getarg_8
  3851 0000249F E804FB                   call prs
  3852 000024A2 83C402                   add  sp, 2
  3853 000024A5 8D06[D000]               lea  ax, [namein]
  3854 000024A9 50                       push ax
  3855 000024AA E8F9FA                   call prs
  3856 000024AD 83C402                   add  sp, 2
  3857 000024B0 68[6525]                 push getarg_9
  3858 000024B3 E8F0FA                   call prs
  3859 000024B6 83C402                   add  sp, 2
  3860 000024B9 8D06[1301]               lea  ax, [namelst]
  3861 000024BD 50                       push ax
  3862 000024BE E8E5FA                   call prs
  3863 000024C1 83C402                   add  sp, 2
  3864                                  
  3865                                  ;-35   prs(", "); prs(namebin);
  3866                                  
  3867 000024C4 68[7025]                 push getarg_10
  3868 000024C7 E8DCFA                   call prs
  3869 000024CA 83C402                   add  sp, 2
  3870 000024CD 8D06[5601]               lea  ax, [namebin]
  3871 000024D1 50                       push ax
  3872 000024D2 E8D1FA                   call prs
  3873 000024D5 83C402                   add  sp, 2
  3874                                  
  3875                                  ;-36   prs("\n");
  3876                                  
  3877 000024D8 68[7325]                 push getarg_11
  3878 000024DB E8C8FA                   call prs
  3879 000024DE 83C402                   add  sp, 2
  3880                                  
  3881                                  ;-37 }
  3882                                  
  3883                                  
  3884                                  ;-38 int epilog() { int i; int j; char c;
  3885 000024E1 C9                       LEAVE
  3886 000024E2 C3                       ret
  3887                                  ; ENDP
  3888 000024E3 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3889 000024EC 41532E434F4D206669-
  3890 000024F5 6C656E616D65205B77-
  3891 000024FE 2F6F202E535D203A20-
  3892 00002507 00                 
  3893 00002508 2E5300                  getarg_1 db ".S",0
  3894 0000250B 2E4C535400              getarg_2 db ".LST",0
  3895 00002510 2E434F4D00              getarg_3 db ".COM",0
  3896 00002515 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3897 0000251E 6C65206D697373696E-
  3898 00002527 673A2000           
  3899 0000252B 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3900 00002534 206E6F742063726561-
  3901 0000253D 74653A2000         
  3902 00002542 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3903 0000254B 6E6F74206372656174-
  3904 00002554 653A2000           
  3905 00002558 3B00                    getarg_7 db ";",0
  3906 0000255A 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3907 00002563 2000               
  3908 00002565 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3909 0000256E 2000               
  3910 00002570 2C2000                  getarg_10 db ", ",0
  3911 00002573 5C6E00                  getarg_11 db "\n",0
  3912                                  
  3913                                  epilog:  ; *** PROC ***
  3914                                  
  3915                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3916                                  
  3917                                  ;Function : epilog, Number of local variables: 3
  3918                                  ;   # type sign width line used address name   list of local variables
  3919                                  ;  200 var sign word    38 NULL bp-2    i
  3920                                  ;  201 var sign word    38 NULL bp-4    j
  3921                                  ;  202 var sign byte    38 NULL bp-6    c;
  3922 00002576 C8060000                 ENTER  6,0
  3923 0000257A 68[F025]                 push epilog_0
  3924 0000257D E826FA                   call prs
  3925 00002580 83C402                   add  sp, 2
  3926 00002583 FF36[A101]               push word [ErrorCount]
  3927 00002587 E83BFB                   call printIntU
  3928 0000258A 83C402                   add  sp, 2
  3929                                  
  3930                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3931                                  
  3932 0000258D A1[A101]                 mov ax, [ErrorCount]
  3933 00002590 08C0                     or  al, al
  3934 00002592 0F840900                 je @@epilog135
  3935 00002596 68[0026]                 push epilog_1
  3936 00002599 E80AFA                   call prs
  3937 0000259C 83C402                   add  sp, 2
  3938                                  
  3939                                  ;-41 /*    
  3940                                  
  3941                                  
  3942                                  ;-42   prs(", Label & Var: ");
  3943                                  
  3944                                  
  3945                                  ;-43   if (LabelMaxIx) {
  3946                                  
  3947                                  
  3948                                  ;-44     i = 1;
  3949                                  
  3950                                  
  3951                                  ;-45     LabelNamePtr= &LabelNames;
  3952                                  
  3953                                  
  3954                                  ;-46     do {
  3955                                  
  3956                                  
  3957                                  ;-47       prs(LabelNamePtr); prc(' ');
  3958                                  
  3959                                  
  3960                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3961                                  
  3962                                  
  3963                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3964                                  
  3965                                  
  3966                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3967                                  
  3968                                  
  3969                                  ;-51       LabelNamePtr++;
  3970                                  
  3971                                  
  3972                                  ;-52       i++;
  3973                                  
  3974                                  
  3975                                  ;-53     } while (i <= LabelMaxIx);
  3976                                  
  3977                                  
  3978                                  ;-54   }
  3979                                  
  3980                                  
  3981                                  ;-55 */  
  3982                                  
  3983                                  
  3984                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3985                                  
  3986                                  @@epilog135:
  3987 0000259F 68[0E26]                 push epilog_2
  3988 000025A2 E801FA                   call prs
  3989 000025A5 83C402                   add  sp, 2
  3990 000025A8 FF36[500E]               push word [BinLen]
  3991 000025AC E816FB                   call printIntU
  3992 000025AF 83C402                   add  sp, 2
  3993 000025B2 68[1A26]                 push epilog_3
  3994 000025B5 E8EEF9                   call prs
  3995 000025B8 83C402                   add  sp, 2
  3996                                  
  3997                                  ;-57 //  i=0;
  3998                                  
  3999                                  
  4000                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4001                                  
  4002                                  
  4003                                  ;-59 //  } while (i < BinLen);
  4004                                  
  4005                                  
  4006                                  ;-60   i=0;
  4007                                  
  4008 000025BB 66B800000000             mov eax, 0
  4009 000025C1 8946FE                   mov word [bp-2], ax
  4010                                  
  4011                                  ;-61   do {
  4012                                  
  4013                                  @@epilog136:
  4014                                  
  4015                                  ;-62     c = FileBin[i];
  4016                                  
  4017 000025C4 8B5EFE                   mov bx, [bp-2]
  4018 000025C7 8A87[8006]               mov al, [FileBin + bx]
  4019 000025CB 8846FA                   mov byte [bp-6], al
  4020                                  
  4021                                  ;-63     fputcR(c, bin_fd);
  4022                                  
  4023 000025CE FF36[9D01]               push word [bin_fd]
  4024 000025D2 8A46FA                   mov al, byte [bp-6]
  4025 000025D5 B400                     mov ah, 0
  4026 000025D7 50                       push ax
  4027 000025D8 E8DB0C                   call fputcR
  4028 000025DB 83C404                   add  sp, 4
  4029                                  
  4030                                  ;-64     i++;
  4031                                  
  4032 000025DE FF46FE                   inc  word [bp-2]
  4033                                  
  4034                                  ;-65   } while (i < BinLen);
  4035                                  
  4036 000025E1 8B46FE                   mov ax, [bp-2]
  4037 000025E4 3B06[500E]               cmp ax, [BinLen]
  4038 000025E8 0F8D0200                 jge @@epilog137
  4039 000025EC EBD6                     jmp @@epilog136
  4040                                  @@epilog137:
  4041                                  
  4042                                  ;-66 }
  4043                                  
  4044                                  
  4045                                  ;-67 int end1(int n) {
  4046 000025EE C9                       LEAVE
  4047 000025EF C3                       ret
  4048                                  ; ENDP
  4049 000025F0 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4050 000025F9 726F72733A2000     
  4051 00002600 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4052 00002609 2A2A2A2000         
  4053 0000260E 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  4054 00002617 652000             
  4055 0000261A 2062797465732E00        epilog_3 db " bytes.",0
  4056                                  
  4057                                  end1:  ; *** PROC ***
  4058                                  
  4059                                  ;-68   fcloseR(asm_fd);
  4060                                  
  4061                                  ;Function : end1, Number of local variables: 1
  4062                                  ;   # type sign width line used address name   list of local variables
  4063                                  ;  200 var sign word    67 NULL bp+4    n;
  4064 00002622 C8000000                 ENTER  0,0
  4065 00002626 FF36[9901]               push word [asm_fd]
  4066 0000262A E89E0C                   call fcloseR
  4067 0000262D 83C402                   add  sp, 2
  4068                                  
  4069                                  ;-69   fcloseR(lst_fd);
  4070                                  
  4071 00002630 FF36[9B01]               push word [lst_fd]
  4072 00002634 E8940C                   call fcloseR
  4073 00002637 83C402                   add  sp, 2
  4074                                  
  4075                                  ;-70   fcloseR(bin_fd);
  4076                                  
  4077 0000263A FF36[9D01]               push word [bin_fd]
  4078 0000263E E88A0C                   call fcloseR
  4079 00002641 83C402                   add  sp, 2
  4080                                  
  4081                                  ;-71   exitR(n);
  4082                                  
  4083 00002644 FF7604                   push word [bp+4]
  4084 00002647 E88F0C                   call exitR
  4085 0000264A 83C402                   add  sp, 2
  4086                                  
  4087                                  ;-72 }
  4088 0000264D C9                       LEAVE
  4089 0000264E C3                       ret
  4090                                  ; ENDP
  4091                                  ;Back to main program: AS.C
  4092                                  
  4093                                  ;-8 #include "GENCODE.C"
  4094                                  
  4095                                  ;Use include file: GENCODE.C
  4096                                  
  4097                                  ;-1 // generate code
  4098                                  
  4099                                  
  4100                                  ;-2 int getCodes() {
  4101                                  
  4102                                  
  4103                                  getCodes:  ; *** PROC ***
  4104                                  
  4105                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  4106                                  
  4107 0000264F FF06[C701]               inc  word [OpCodePtr]
  4108 00002653 8B1E[C701]               mov bx, [OpCodePtr]
  4109 00002657 8A07                     mov al, [bx]
  4110 00002659 B400                     mov ah, 0
  4111 0000265B A2[AF01]                 mov byte [Code1], al
  4112                                  
  4113                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  4114                                  
  4115 0000265E FF06[C701]               inc  word [OpCodePtr]
  4116 00002662 8B1E[C701]               mov bx, [OpCodePtr]
  4117 00002666 8A07                     mov al, [bx]
  4118 00002668 B400                     mov ah, 0
  4119 0000266A A2[B001]                 mov byte [Code2], al
  4120                                  
  4121                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  4122                                  
  4123 0000266D FF06[C701]               inc  word [OpCodePtr]
  4124 00002671 8B1E[C701]               mov bx, [OpCodePtr]
  4125 00002675 8A07                     mov al, [bx]
  4126 00002677 B400                     mov ah, 0
  4127 00002679 A2[B101]                 mov byte [Code3], al
  4128                                  
  4129                                  ;-6 }
  4130                                  
  4131                                  
  4132                                  ;-7 int gen66h() {genCode8(0x66);
  4133                                  
  4134 0000267C C3                       ret
  4135                                  ; ENDP
  4136                                  
  4137                                  gen66h:  ; *** PROC ***
  4138 0000267D 6A66                     push 102
  4139 0000267F E83B00                   call genCode8
  4140 00002682 83C402                   add  sp, 2
  4141                                  
  4142                                  ;-8 }
  4143                                  
  4144                                  
  4145                                  ;-9 int genCode2(char c, char d) {
  4146                                  
  4147 00002685 C3                       ret
  4148                                  ; ENDP
  4149                                  
  4150                                  genCode2:  ; *** PROC ***
  4151                                  
  4152                                  ;-10     c = c + d;
  4153                                  
  4154                                  ;Function : genCode2, Number of local variables: 2
  4155                                  ;   # type sign width line used address name   list of local variables
  4156                                  ;  200 var sign byte     9 NULL bp+4    c
  4157                                  ;  201 var sign byte     9 NULL bp+6    d;
  4158 00002686 C8000000                 ENTER  0,0
  4159 0000268A 8A4604                   mov al, [bp+4]
  4160 0000268D 024606                   add al, [bp+6]
  4161 00002690 884604                   mov byte [bp+4], al
  4162                                  
  4163                                  ;-11     genCode8(c);
  4164                                  
  4165 00002693 8A4604                   mov al, byte [bp+4]
  4166 00002696 B400                     mov ah, 0
  4167 00002698 50                       push ax
  4168 00002699 E82100                   call genCode8
  4169 0000269C 83C402                   add  sp, 2
  4170                                  
  4171                                  ;-12 }                             
  4172                                  
  4173                                  
  4174                                  ;-13 int genCodeW(char c) {
  4175 0000269F C9                       LEAVE
  4176 000026A0 C3                       ret
  4177                                  ; ENDP
  4178                                  
  4179                                  genCodeW:  ; *** PROC ***
  4180                                  
  4181                                  ;-14     c = c + wflag;  
  4182                                  
  4183                                  ;Function : genCodeW, Number of local variables: 1
  4184                                  ;   # type sign width line used address name   list of local variables
  4185                                  ;  200 var sign byte    13 NULL bp+4    c;
  4186 000026A1 C8000000                 ENTER  0,0
  4187 000026A5 8A4604                   mov al, [bp+4]
  4188 000026A8 0206[B701]               add al, [wflag]
  4189 000026AC 884604                   mov byte [bp+4], al
  4190                                  
  4191                                  ;-15     genCode8(c);
  4192                                  
  4193 000026AF 8A4604                   mov al, byte [bp+4]
  4194 000026B2 B400                     mov ah, 0
  4195 000026B4 50                       push ax
  4196 000026B5 E80500                   call genCode8
  4197 000026B8 83C402                   add  sp, 2
  4198                                  
  4199                                  ;-16 }   
  4200                                  
  4201                                  
  4202                                  ;-17 int genCode8(char c) {
  4203 000026BB C9                       LEAVE
  4204 000026BC C3                       ret
  4205                                  ; ENDP
  4206                                  
  4207                                  genCode8:  ; *** PROC ***
  4208                                  
  4209                                  ;-18 //set: BinLen++, OpPrintIndex++
  4210                                  
  4211                                  
  4212                                  ;-19     FileBin[BinLen]=c;
  4213                                  
  4214                                  ;Function : genCode8, Number of local variables: 1
  4215                                  ;   # type sign width line used address name   list of local variables
  4216                                  ;  200 var sign byte    17 NULL bp+4    c;
  4217 000026BD C8000000                 ENTER  0,0
  4218 000026C1 8A4604                   mov al, [bp+4]
  4219 000026C4 8B1E[500E]               mov bx, [BinLen]
  4220 000026C8 8887[8006]               mov [FileBin+bx], al
  4221                                  
  4222                                  ;-20     BinLen++;
  4223                                  
  4224 000026CC FF06[500E]               inc  word [BinLen]
  4225                                  
  4226                                  ;-21     PC++;
  4227                                  
  4228 000026D0 FF06[A601]               inc  word [PC]
  4229                                  
  4230                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  4231                                  
  4232 000026D4 A1[500E]                 mov ax, [BinLen]
  4233 000026D7 3DD007                   cmp ax, 2000 ;unsigned : 0
  4234 000026DA 0F820900                 jb  @@genCode8138
  4235 000026DE 68[0227]                 push genCode8_0
  4236 000026E1 E882FA                   call errorexit
  4237 000026E4 83C402                   add  sp, 2
  4238                                  
  4239                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  4240                                  
  4241                                  @@genCode8138:
  4242 000026E7 A1[C501]                 mov ax, [OpPrintIndex]
  4243 000026EA 83F805                   cmp ax, 5
  4244 000026ED 0F8D0F00                 jge @@genCode8139
  4245                                  
  4246                                  ;-24         OpPos[OpPrintIndex]=c;
  4247                                  
  4248 000026F1 8A4604                   mov al, [bp+4]
  4249 000026F4 8B1E[C501]               mov bx, [OpPrintIndex]
  4250 000026F8 8887[C001]               mov [OpPos+bx], al
  4251                                  
  4252                                  ;-25         OpPrintIndex++;
  4253                                  
  4254 000026FC FF06[C501]               inc  word [OpPrintIndex]
  4255                                  
  4256                                  ;-26     }
  4257                                  
  4258                                  
  4259                                  ;-27 }
  4260                                  
  4261                                  @@genCode8139:
  4262                                  
  4263                                  ;-28 int genCode16(unsigned int i) {
  4264 00002700 C9                       LEAVE
  4265 00002701 C3                       ret
  4266                                  ; ENDP
  4267 00002702 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  4268 0000270B 746F6F206C6F6E6700 
  4269                                  
  4270                                  genCode16:  ; *** PROC ***
  4271                                  
  4272                                  ;-29     genCode8(i); i=i >> 8;
  4273                                  
  4274                                  ;Function : genCode16, Number of local variables: 1
  4275                                  ;   # type sign width line used address name   list of local variables
  4276                                  ;  200 var unsg word    28 NULL bp+4    i;
  4277 00002714 C8000000                 ENTER  0,0
  4278 00002718 FF7604                   push word [bp+4]
  4279 0000271B E89FFF                   call genCode8
  4280 0000271E 83C402                   add  sp, 2
  4281 00002721 8B4604                   mov ax, [bp+4]
  4282 00002724 C1E808                   shr ax, 8
  4283 00002727 894604                   mov word [bp+4], ax
  4284                                  
  4285                                  ;-30     genCode8(i);
  4286                                  
  4287 0000272A FF7604                   push word [bp+4]
  4288 0000272D E88DFF                   call genCode8
  4289 00002730 83C402                   add  sp, 2
  4290                                  
  4291                                  ;-31 }
  4292                                  
  4293                                  
  4294                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  4295 00002733 C9                       LEAVE
  4296 00002734 C3                       ret
  4297                                  ; ENDP
  4298                                  
  4299                                  writeEA:  ; *** PROC ***
  4300                                  
  4301                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  4302                                  
  4303                                  
  4304                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  4305                                  
  4306                                  
  4307                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  4308                                  
  4309                                  
  4310                                  ;-36     char len;
  4311                                  
  4312                                  
  4313                                  ;-37     len=0;   
  4314                                  
  4315                                  ;Function : writeEA, Number of local variables: 2
  4316                                  ;   # type sign width line used address name   list of local variables
  4317                                  ;  200 var sign byte    32 NULL bp+4    xxx
  4318                                  ;  201 var sign byte    36 NULL bp-2    len;
  4319 00002735 C8020000                 ENTER  2,0
  4320 00002739 66B800000000             mov eax, 0
  4321 0000273F 8846FE                   mov byte [bp-2], al
  4322                                  
  4323                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  4324                                  
  4325 00002742 8A4604                   mov al, [bp+4]
  4326 00002745 C0E003                   shl al, 3
  4327 00002748 884604                   mov byte [bp+4], al
  4328                                  
  4329                                  ;-39     if (Op == REG) {
  4330                                  
  4331 0000274B A0[AC01]                 mov al, [Op]
  4332 0000274E 3C02                     cmp al, 2
  4333 00002750 0F853A00                 jne @@writeEA140
  4334                                  
  4335                                  ;-40         xxx |= 0xC0;     
  4336                                  
  4337 00002754 804E04C0                 or  byte [bp+4], 192
  4338                                  
  4339                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  4340                                  
  4341 00002758 A0[AD01]                 mov al, [Op2]
  4342 0000275B 3C01                     cmp al, 1
  4343 0000275D 0F8F0D00                 jg  @@writeEA141
  4344 00002761 8A4604                   mov al, [bp+4]
  4345 00002764 0206[B301]               add al, [R1No]
  4346 00002768 884604                   mov byte [bp+4], al
  4347                                  
  4348                                  ;-42             else {
  4349                                  
  4350 0000276B E92000                   jmp @@writeEA142
  4351                                  @@writeEA141:
  4352                                  
  4353                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  4354                                  
  4355 0000276E A0[AD01]                 mov al, [Op2]
  4356 00002771 3C02                     cmp al, 2
  4357 00002773 0F850D00                 jne @@writeEA143
  4358 00002777 8A4604                   mov al, [bp+4]
  4359 0000277A 0206[B301]               add al, [R1No]
  4360 0000277E 884604                   mov byte [bp+4], al
  4361                                  
  4362                                  ;-44                 else            xxx = xxx + R2No;  
  4363                                  
  4364 00002781 E90A00                   jmp @@writeEA144
  4365                                  @@writeEA143:
  4366 00002784 8A4604                   mov al, [bp+4]
  4367 00002787 0206[B201]               add al, [R2No]
  4368 0000278B 884604                   mov byte [bp+4], al
  4369                                  
  4370                                  ;-45             }
  4371                                  
  4372                                  @@writeEA144:
  4373                                  
  4374                                  ;-46         } 
  4375                                  
  4376                                  @@writeEA142:
  4377                                  
  4378                                  ;-47     if (Op == MEM) {
  4379                                  
  4380                                  @@writeEA140:
  4381 0000278E A0[AC01]                 mov al, [Op]
  4382 00002791 3C04                     cmp al, 4
  4383 00002793 0F857F00                 jne @@writeEA145
  4384                                  
  4385                                  ;-48         if (isDirect) {
  4386                                  
  4387 00002797 A0[BB01]                 mov al, [isDirect]
  4388 0000279A 08C0                     or  al, al
  4389 0000279C 0F841000                 je @@writeEA146
  4390                                  
  4391                                  ;-49             xxx |= 6;
  4392                                  
  4393 000027A0 804E0406                 or  byte [bp+4], 6
  4394                                  
  4395                                  ;-50             len = 2;
  4396                                  
  4397 000027A4 66B802000000             mov eax, 2
  4398 000027AA 8846FE                   mov byte [bp-2], al
  4399                                  
  4400                                  ;-51         }
  4401                                  
  4402                                  
  4403                                  ;-52         else { 
  4404                                  
  4405 000027AD E96600                   jmp @@writeEA147
  4406                                  @@writeEA146:
  4407                                  
  4408                                  ;-53             xxx = xxx + rm;   
  4409                                  
  4410 000027B0 8A4604                   mov al, [bp+4]
  4411 000027B3 0206[BA01]               add al, [rm]
  4412 000027B7 884604                   mov byte [bp+4], al
  4413                                  
  4414                                  ;-54             if (rm == 6) {//make [BP+00]
  4415                                  
  4416 000027BA A0[BA01]                 mov al, [rm]
  4417 000027BD 3C06                     cmp al, 6
  4418 000027BF 0F851700                 jne @@writeEA148
  4419                                  
  4420                                  ;-55                 len=1;
  4421                                  
  4422 000027C3 66B801000000             mov eax, 1
  4423 000027C9 8846FE                   mov byte [bp-2], al
  4424                                  
  4425                                  ;-56                 if (disp == 0) xxx |= 0x40;
  4426                                  
  4427 000027CC A1[BC01]                 mov ax, [disp]
  4428 000027CF 83F800                   cmp ax, 0
  4429 000027D2 0F850400                 jne @@writeEA149
  4430 000027D6 804E0440                 or  byte [bp+4], 64
  4431                                  
  4432                                  ;-57             }
  4433                                  
  4434                                  @@writeEA149:
  4435                                  
  4436                                  ;-58 
  4437                                  
  4438                                  
  4439                                  ;-59             if (disp) {
  4440                                  
  4441                                  @@writeEA148:
  4442 000027DA A1[BC01]                 mov ax, [disp]
  4443 000027DD 08C0                     or  al, al
  4444 000027DF 0F843300                 je @@writeEA150
  4445                                  
  4446                                  ;-60                 ax = disp;
  4447                                  
  4448 000027E3 A1[BC01]                 mov  ax, [disp]
  4449                                  
  4450                                  ;-61                 if(ax > 127) len=2;
  4451                                  
  4452 000027E6 83F87F                   cmp  ax, 127
  4453 000027E9 0F8E0C00                 jle @@writeEA151
  4454 000027ED 66B802000000             mov eax, 2
  4455 000027F3 8846FE                   mov byte [bp-2], al
  4456                                  
  4457                                  ;-62                 else len=1;
  4458                                  
  4459 000027F6 E90900                   jmp @@writeEA152
  4460                                  @@writeEA151:
  4461 000027F9 66B801000000             mov eax, 1
  4462 000027FF 8846FE                   mov byte [bp-2], al
  4463                                  
  4464                                  ;-63                 if (len == 1) xxx |= 0x40;
  4465                                  
  4466                                  @@writeEA152:
  4467 00002802 8A46FE                   mov al, [bp-2]
  4468 00002805 3C01                     cmp al, 1
  4469 00002807 0F850700                 jne @@writeEA153
  4470 0000280B 804E0440                 or  byte [bp+4], 64
  4471                                  
  4472                                  ;-64                 else xxx |= 0x80;
  4473                                  
  4474 0000280F E90400                   jmp @@writeEA154
  4475                                  @@writeEA153:
  4476 00002812 804E0480                 or  byte [bp+4], 128
  4477                                  
  4478                                  ;-65             }
  4479                                  
  4480                                  @@writeEA154:
  4481                                  
  4482                                  ;-66         }
  4483                                  
  4484                                  @@writeEA150:
  4485                                  
  4486                                  ;-67     }  
  4487                                  
  4488                                  @@writeEA147:
  4489                                  
  4490                                  ;-68     
  4491                                  
  4492                                  
  4493                                  ;-69     genCode8(xxx);// gen second byte
  4494                                  
  4495                                  @@writeEA145:
  4496 00002816 8A4604                   mov al, byte [bp+4]
  4497 00002819 B400                     mov ah, 0
  4498 0000281B 50                       push ax
  4499 0000281C E89EFE                   call genCode8
  4500 0000281F 83C402                   add  sp, 2
  4501                                  
  4502                                  ;-70     if (len == 1) genCode8 (disp);
  4503                                  
  4504 00002822 8A46FE                   mov al, [bp-2]
  4505 00002825 3C01                     cmp al, 1
  4506 00002827 0F850A00                 jne @@writeEA155
  4507 0000282B FF36[BC01]               push word [disp]
  4508 0000282F E88BFE                   call genCode8
  4509 00002832 83C402                   add  sp, 2
  4510                                  
  4511                                  ;-71     if (len == 2) genCode16(disp);
  4512                                  
  4513                                  @@writeEA155:
  4514 00002835 8A46FE                   mov al, [bp-2]
  4515 00002838 3C02                     cmp al, 2
  4516 0000283A 0F850A00                 jne @@writeEA156
  4517 0000283E FF36[BC01]               push word [disp]
  4518 00002842 E8CFFE                   call genCode16
  4519 00002845 83C402                   add  sp, 2
  4520                                  
  4521                                  ;-72 }
  4522                                  
  4523                                  @@writeEA156:
  4524                                  
  4525                                  ;-73 
  4526                                  
  4527                                  
  4528                                  ;-74 int genImmediateSE() {
  4529 00002848 C9                       LEAVE
  4530 00002849 C3                       ret
  4531                                  ; ENDP
  4532                                  
  4533                                  genImmediateSE:  ; *** PROC ***
  4534                                  
  4535                                  ;-75     if (sflag) genCode8(imme);
  4536                                  
  4537 0000284A A0[B901]                 mov al, [sflag]
  4538 0000284D 08C0                     or  al, al
  4539 0000284F 0F840D00                 je @@genImmediateSE157
  4540 00002853 FF36[BE01]               push word [imme]
  4541 00002857 E863FE                   call genCode8
  4542 0000285A 83C402                   add  sp, 2
  4543                                  
  4544                                  ;-76     else genImmediate();    
  4545                                  
  4546 0000285D E90300                   jmp @@genImmediateSE158
  4547                                  @@genImmediateSE157:
  4548 00002860 E80100                   call genImmediate
  4549                                  
  4550                                  ;-77 }
  4551                                  
  4552                                  @@genImmediateSE158:
  4553                                  
  4554                                  ;-78 int genImmediate() { 
  4555                                  
  4556 00002863 C3                       ret
  4557                                  ; ENDP
  4558                                  
  4559                                  genImmediate:  ; *** PROC ***
  4560                                  
  4561                                  ;-79     if (wflag) genCode16(imme);
  4562                                  
  4563 00002864 A0[B701]                 mov al, [wflag]
  4564 00002867 08C0                     or  al, al
  4565 00002869 0F840D00                 je @@genImmediate159
  4566 0000286D FF36[BE01]               push word [imme]
  4567 00002871 E8A0FE                   call genCode16
  4568 00002874 83C402                   add  sp, 2
  4569                                  
  4570                                  ;-80     else       genCode8 (imme);  
  4571                                  
  4572 00002877 E90A00                   jmp @@genImmediate160
  4573                                  @@genImmediate159:
  4574 0000287A FF36[BE01]               push word [imme]
  4575 0000287E E83CFE                   call genCode8
  4576 00002881 83C402                   add  sp, 2
  4577                                  
  4578                                  ;-81 }    
  4579                                  
  4580                                  @@genImmediate160:
  4581 00002884 C3                       ret
  4582                                  ; ENDP
  4583                                  ;Back to main program: AS.C
  4584                                  
  4585                                  ;-9 
  4586                                  
  4587                                  
  4588                                  ;-10 int process() { 
  4589                                  
  4590                                  
  4591                                  process:  ; *** PROC ***
  4592                                  
  4593                                  ;-11     char c;
  4594                                  
  4595                                  
  4596                                  ;-12     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4597                                  
  4598                                  ;Function : process, Number of local variables: 1
  4599                                  ;   # type sign width line used address name   list of local variables
  4600                                  ;  200 var sign byte    11 NULL bp-2    c;
  4601 00002885 C8020000                 ENTER  2,0
  4602 00002889 E84DEA                   call getTokeType
  4603                                  
  4604                                  ;-13     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4605                                  
  4606 0000288C E89DED                   call getCodeSize
  4607 0000288F A2[B601]                 mov byte [OpSize], al
  4608                                  
  4609                                  ;-14     getCodes();//set: Code1, Code2, Code3
  4610                                  
  4611 00002892 E8BAFD                   call getCodes
  4612                                  
  4613                                  ;-15 
  4614                                  
  4615                                  
  4616                                  ;-16     if (CodeType ==  1) {//1 byte opcode
  4617                                  
  4618 00002895 A0[AE01]                 mov al, [CodeType]
  4619 00002898 3C01                     cmp al, 1
  4620 0000289A 0F850F00                 jne @@process161
  4621                                  
  4622                                  ;-17         genCode8(Code1);
  4623                                  
  4624 0000289E A0[AF01]                 mov al, byte [Code1]
  4625 000028A1 B400                     mov ah, 0
  4626 000028A3 50                       push ax
  4627 000028A4 E816FE                   call genCode8
  4628 000028A7 83C402                   add  sp, 2
  4629                                  
  4630                                  ;-18         return;
  4631                                  
  4632 000028AA E9E402                   jmp @@retn
  4633                                  
  4634                                  ;-19     }
  4635                                  
  4636                                  
  4637                                  ;-20   
  4638                                  
  4639                                  
  4640                                  ;-21     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4641                                  
  4642                                  @@process161:
  4643 000028AD A0[AE01]                 mov al, [CodeType]
  4644 000028B0 3C02                     cmp al, 2
  4645 000028B2 0F856900                 jne @@process162
  4646                                  
  4647                                  ;-22         getOpL();
  4648                                  
  4649 000028B6 E84304                   call getOpL
  4650                                  
  4651                                  ;-23         checkOpL();        
  4652                                  
  4653 000028B9 E84703                   call checkOpL
  4654                                  
  4655                                  ;-24         if (Code2 <= 1) {//inc,dec
  4656                                  
  4657 000028BC A0[B001]                 mov al, [Code2]
  4658 000028BF 3C01                     cmp al, 1
  4659 000028C1 0F8F2700                 jg  @@process163
  4660                                  
  4661                                  ;-25   	        if (Op == REG) {//short
  4662                                  
  4663 000028C5 A0[AC01]                 mov al, [Op]
  4664 000028C8 3C02                     cmp al, 2
  4665 000028CA 0F851E00                 jne @@process164
  4666                                  
  4667                                  ;-26                 if (wflag) {genCode2(Code3, R1No); return; }
  4668                                  
  4669 000028CE A0[B701]                 mov al, [wflag]
  4670 000028D1 08C0                     or  al, al
  4671 000028D3 0F841500                 je @@process165
  4672 000028D7 A0[B301]                 mov al, byte [R1No]
  4673 000028DA B400                     mov ah, 0
  4674 000028DC 50                       push ax
  4675 000028DD A0[B101]                 mov al, byte [Code3]
  4676 000028E0 B400                     mov ah, 0
  4677 000028E2 50                       push ax
  4678 000028E3 E8A0FD                   call genCode2
  4679 000028E6 83C404                   add  sp, 4
  4680 000028E9 E9A502                   jmp @@retn
  4681                                  
  4682                                  ;-27             }
  4683                                  
  4684                                  @@process165:
  4685                                  
  4686                                  ;-28         }
  4687                                  
  4688                                  @@process164:
  4689                                  
  4690                                  ;-29         if (Code2 == 5) {//imul extension?
  4691                                  
  4692                                  @@process163:
  4693 000028EC A0[B001]                 mov al, [Code2]
  4694 000028EF 3C05                     cmp al, 5
  4695 000028F1 0F850F00                 jne @@process166
  4696                                  
  4697                                  ;-30             getTokeType();
  4698                                  
  4699 000028F5 E8E1E9                   call getTokeType
  4700                                  
  4701                                  ;-31             if (TokeType) implerror();
  4702                                  
  4703 000028F8 A0[AB01]                 mov al, [TokeType]
  4704 000028FB 08C0                     or  al, al
  4705 000028FD 0F840300                 je @@process167
  4706 00002901 E8D3F8                   call implerror
  4707                                  
  4708                                  ;-32         }
  4709                                  
  4710                                  @@process167:
  4711                                  
  4712                                  ;-33         genCodeW(Code1);           
  4713                                  
  4714                                  @@process166:
  4715 00002904 A0[AF01]                 mov al, byte [Code1]
  4716 00002907 B400                     mov ah, 0
  4717 00002909 50                       push ax
  4718 0000290A E894FD                   call genCodeW
  4719 0000290D 83C402                   add  sp, 2
  4720                                  
  4721                                  ;-34         writeEA(Code2);
  4722                                  
  4723 00002910 A0[B001]                 mov al, byte [Code2]
  4724 00002913 B400                     mov ah, 0
  4725 00002915 50                       push ax
  4726 00002916 E81CFE                   call writeEA
  4727 00002919 83C402                   add  sp, 2
  4728                                  
  4729                                  ;-35         return;
  4730                                  
  4731 0000291C E97202                   jmp @@retn
  4732                                  
  4733                                  ;-36     }
  4734                                  
  4735                                  
  4736                                  ;-37   
  4737                                  
  4738                                  
  4739                                  ;-38     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4740                                  
  4741                                  @@process162:
  4742 0000291F A0[AE01]                 mov al, [CodeType]
  4743 00002922 3C03                     cmp al, 3
  4744 00002924 0F855100                 jne @@process168
  4745                                  
  4746                                  ;-39         check2Ops();    //setwflag not applicable
  4747                                  
  4748 00002928 E88B03                   call check2Ops
  4749                                  
  4750                                  ;-40         if (R1Type != WORD) reg16error();//only r16
  4751                                  
  4752 0000292B A0[B501]                 mov al, [R1Type]
  4753 0000292E 3C02                     cmp al, 2
  4754 00002930 0F840300                 je  @@process169
  4755 00002934 E840F9                   call reg16error
  4756                                  
  4757                                  ;-41         if (Op2 != MEM) addrerror();//only m16 
  4758                                  
  4759                                  @@process169:
  4760 00002937 A0[AD01]                 mov al, [Op2]
  4761 0000293A 3C04                     cmp al, 4
  4762 0000293C 0F840300                 je  @@process170
  4763 00002940 E855F8                   call addrerror
  4764                                  
  4765                                  ;-42         
  4766                                  
  4767                                  
  4768                                  ;-43         genCode8(Code1);//les,lds,lea
  4769                                  
  4770                                  @@process170:
  4771 00002943 A0[AF01]                 mov al, byte [Code1]
  4772 00002946 B400                     mov ah, 0
  4773 00002948 50                       push ax
  4774 00002949 E871FD                   call genCode8
  4775 0000294C 83C402                   add  sp, 2
  4776                                  
  4777                                  ;-44         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  4778                                  
  4779 0000294F A0[AF01]                 mov al, [Code1]
  4780 00002952 3C0F                     cmp al, 15
  4781 00002954 0F850C00                 jne @@process171
  4782 00002958 A0[B001]                 mov al, byte [Code2]
  4783 0000295B B400                     mov ah, 0
  4784 0000295D 50                       push ax
  4785 0000295E E85CFD                   call genCode8
  4786 00002961 83C402                   add  sp, 2
  4787                                  
  4788                                  ;-45         Op=Op2;//set MEM for writeEA
  4789                                  
  4790                                  @@process171:
  4791 00002964 A0[AD01]                 mov al, [Op2]
  4792 00002967 A2[AC01]                 mov byte [Op], al
  4793                                  
  4794                                  ;-46         writeEA(R1No);           
  4795                                  
  4796 0000296A A0[B301]                 mov al, byte [R1No]
  4797 0000296D B400                     mov ah, 0
  4798 0000296F 50                       push ax
  4799 00002970 E8C2FD                   call writeEA
  4800 00002973 83C402                   add  sp, 2
  4801                                  
  4802                                  ;-47         return;
  4803                                  
  4804 00002976 E91802                   jmp @@retn
  4805                                  
  4806                                  ;-48     }
  4807                                  
  4808                                  
  4809                                  ;-49 
  4810                                  
  4811                                  
  4812                                  ;-50     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  4813                                  
  4814                                  @@process168:
  4815 00002979 A0[AE01]                 mov al, [CodeType]
  4816 0000297C 3C04                     cmp al, 4
  4817 0000297E 0F85D900                 jne @@process172
  4818                                  
  4819                                  ;-51         check2Ops();    
  4820                                  
  4821 00002982 E83103                   call check2Ops
  4822                                  
  4823                                  ;-52         if (Op2 == IMM) {//second operand is imm     
  4824                                  
  4825 00002985 A0[AD01]                 mov al, [Op2]
  4826 00002988 3C01                     cmp al, 1
  4827 0000298A 0F856300                 jne @@process173
  4828                                  
  4829                                  ;-53             setsflag();   
  4830                                  
  4831 0000298E E80E07                   call setsflag
  4832                                  
  4833                                  ;-54             if (Op == REG) {                
  4834                                  
  4835 00002991 A0[AC01]                 mov al, [Op]
  4836 00002994 3C02                     cmp al, 2
  4837 00002996 0F853100                 jne @@process174
  4838                                  
  4839                                  ;-55                 if (R1No == 0) {// acc,imm   
  4840                                  
  4841 0000299A A0[B301]                 mov al, [R1No]
  4842 0000299D 3C00                     cmp al, 0
  4843 0000299F 0F852800                 jne @@process175
  4844                                  
  4845                                  ;-56                     if (sflag == 0) {                        
  4846                                  
  4847 000029A3 A0[B901]                 mov al, [sflag]
  4848 000029A6 3C00                     cmp al, 0
  4849 000029A8 0F851F00                 jne @@process176
  4850                                  
  4851                                  ;-57                         c = Code1 << 3;
  4852                                  
  4853 000029AC A0[AF01]                 mov al, [Code1]
  4854 000029AF C0E003                   shl al, 3
  4855 000029B2 8846FE                   mov byte [bp-2], al
  4856                                  
  4857                                  ;-58                         c += 4;    
  4858                                  
  4859 000029B5 8046FE04                 add  byte [bp-2], 4
  4860                                  
  4861                                  ;-59                         genCodeW(c);
  4862                                  
  4863 000029B9 8A46FE                   mov al, byte [bp-2]
  4864 000029BC B400                     mov ah, 0
  4865 000029BE 50                       push ax
  4866 000029BF E8DFFC                   call genCodeW
  4867 000029C2 83C402                   add  sp, 2
  4868                                  
  4869                                  ;-60                         genImmediate();
  4870                                  
  4871 000029C5 E89CFE                   call genImmediate
  4872                                  
  4873                                  ;-61                         return;
  4874                                  
  4875 000029C8 E9C601                   jmp @@retn
  4876                                  
  4877                                  ;-62                     }
  4878                                  
  4879                                  
  4880                                  ;-63                 }
  4881                                  
  4882                                  @@process176:
  4883                                  
  4884                                  ;-64             }
  4885                                  
  4886                                  @@process175:
  4887                                  
  4888                                  ;-65             //r/m, imm: 80 sign-extended,TTT,imm
  4889                                  
  4890                                  
  4891                                  ;-66             c = sflag + 0x80;   
  4892                                  
  4893                                  @@process174:
  4894 000029CB A0[B901]                 mov al, [sflag]
  4895 000029CE 0480                     add al, 128
  4896 000029D0 8846FE                   mov byte [bp-2], al
  4897                                  
  4898                                  ;-67             genCodeW(c); 
  4899                                  
  4900 000029D3 8A46FE                   mov al, byte [bp-2]
  4901 000029D6 B400                     mov ah, 0
  4902 000029D8 50                       push ax
  4903 000029D9 E8C5FC                   call genCodeW
  4904 000029DC 83C402                   add  sp, 2
  4905                                  
  4906                                  ;-68             writeEA(Code1);  
  4907                                  
  4908 000029DF A0[AF01]                 mov al, byte [Code1]
  4909 000029E2 B400                     mov ah, 0
  4910 000029E4 50                       push ax
  4911 000029E5 E84DFD                   call writeEA
  4912 000029E8 83C402                   add  sp, 2
  4913                                  
  4914                                  ;-69             genImmediateSE();
  4915                                  
  4916 000029EB E85CFE                   call genImmediateSE
  4917                                  
  4918                                  ;-70             return;     
  4919                                  
  4920 000029EE E9A001                   jmp @@retn
  4921                                  
  4922                                  ;-71         }  
  4923                                  
  4924                                  
  4925                                  ;-72         c = Code1 << 3;//r/m, r/r  
  4926                                  
  4927                                  @@process173:
  4928 000029F1 A0[AF01]                 mov al, [Code1]
  4929 000029F4 C0E003                   shl al, 3
  4930 000029F7 8846FE                   mov byte [bp-2], al
  4931                                  
  4932                                  ;-73         if (Op == REG) {
  4933                                  
  4934 000029FA A0[AC01]                 mov al, [Op]
  4935 000029FD 3C02                     cmp al, 2
  4936 000029FF 0F852E00                 jne @@process177
  4937                                  
  4938                                  ;-74             if (Op2 == MEM) {//reg, mem      
  4939                                  
  4940 00002A03 A0[AD01]                 mov al, [Op2]
  4941 00002A06 3C04                     cmp al, 4
  4942 00002A08 0F852500                 jne @@process178
  4943                                  
  4944                                  ;-75                 c += 2;//add direction flag
  4945                                  
  4946 00002A0C 8046FE02                 add  byte [bp-2], 2
  4947                                  
  4948                                  ;-76                 genCodeW(c);
  4949                                  
  4950 00002A10 8A46FE                   mov al, byte [bp-2]
  4951 00002A13 B400                     mov ah, 0
  4952 00002A15 50                       push ax
  4953 00002A16 E888FC                   call genCodeW
  4954 00002A19 83C402                   add  sp, 2
  4955                                  
  4956                                  ;-77                 Op=Op2;//set MEM for writeEA                
  4957                                  
  4958 00002A1C A0[AD01]                 mov al, [Op2]
  4959 00002A1F A2[AC01]                 mov byte [Op], al
  4960                                  
  4961                                  ;-78                 writeEA(R1No);
  4962                                  
  4963 00002A22 A0[B301]                 mov al, byte [R1No]
  4964 00002A25 B400                     mov ah, 0
  4965 00002A27 50                       push ax
  4966 00002A28 E80AFD                   call writeEA
  4967 00002A2B 83C402                   add  sp, 2
  4968                                  
  4969                                  ;-79                 return;    
  4970                                  
  4971 00002A2E E96001                   jmp @@retn
  4972                                  
  4973                                  ;-80             }
  4974                                  
  4975                                  
  4976                                  ;-81         }
  4977                                  
  4978                                  @@process178:
  4979                                  
  4980                                  ;-82         if (Op2 == REG) {//mem,reg    reg,reg
  4981                                  
  4982                                  @@process177:
  4983 00002A31 A0[AD01]                 mov al, [Op2]
  4984 00002A34 3C02                     cmp al, 2
  4985 00002A36 0F851B00                 jne @@process179
  4986                                  
  4987                                  ;-83             genCodeW(c);
  4988                                  
  4989 00002A3A 8A46FE                   mov al, byte [bp-2]
  4990 00002A3D B400                     mov ah, 0
  4991 00002A3F 50                       push ax
  4992 00002A40 E85EFC                   call genCodeW
  4993 00002A43 83C402                   add  sp, 2
  4994                                  
  4995                                  ;-84             writeEA(R2No);//2. Op in reg-field
  4996                                  
  4997 00002A46 A0[B201]                 mov al, byte [R2No]
  4998 00002A49 B400                     mov ah, 0
  4999 00002A4B 50                       push ax
  5000 00002A4C E8E6FC                   call writeEA
  5001 00002A4F 83C402                   add  sp, 2
  5002                                  
  5003                                  ;-85             return;            
  5004                                  
  5005 00002A52 E93C01                   jmp @@retn
  5006                                  
  5007                                  ;-86         }          
  5008                                  
  5009                                  
  5010                                  ;-87         syntaxerror();        
  5011                                  
  5012                                  @@process179:
  5013 00002A55 E86EF8                   call syntaxerror
  5014                                  
  5015                                  ;-88         return;
  5016                                  
  5017 00002A58 E93601                   jmp @@retn
  5018                                  
  5019                                  ;-89     }
  5020                                  
  5021                                  
  5022                                  ;-90  
  5023                                  
  5024                                  
  5025                                  ;-91     if (CodeType == 5) {//mov (movsx, movzx=51)
  5026                                  
  5027                                  @@process172:
  5028 00002A5B A0[AE01]                 mov al, [CodeType]
  5029 00002A5E 3C05                     cmp al, 5
  5030 00002A60 0F85C600                 jne @@process180
  5031                                  
  5032                                  ;-92         dflag=0;
  5033                                  
  5034 00002A64 66B800000000             mov eax, 0
  5035 00002A6A A2[B801]                 mov byte [dflag], al
  5036                                  
  5037                                  ;-93         check2Ops();    
  5038                                  
  5039 00002A6D E84602                   call check2Ops
  5040                                  
  5041                                  ;-94 /*    prs("\n Op:"); printhex8a(Op);
  5042                                  
  5043                                  
  5044                                  ;-95     prs(", Op2:"); printhex8a(Op2);
  5045                                  
  5046                                  
  5047                                  ;-96     prs(", R1No:"); printhex8a(R1No);
  5048                                  
  5049                                  
  5050                                  ;-97     prs(", R2No:"); printhex8a(R2No);   */  
  5051                                  
  5052                                  
  5053                                  ;-98         if (Op2 == ADR) {
  5054                                  
  5055 00002A70 A0[AD01]                 mov al, [Op2]
  5056 00002A73 3C03                     cmp al, 3
  5057 00002A75 0F850F00                 jne @@process181
  5058                                  
  5059                                  ;-99             imme=disp;
  5060                                  
  5061 00002A79 A1[BC01]                 mov ax, [disp]
  5062 00002A7C A3[BE01]                 mov word [imme], ax
  5063                                  
  5064                                  ;-100             Op2=IMM;//continue with IMM    
  5065                                  
  5066 00002A7F 66B801000000             mov eax, 1
  5067 00002A85 A2[AD01]                 mov byte [Op2], al
  5068                                  
  5069                                  ;-101         }  
  5070                                  
  5071                                  
  5072                                  ;-102         if (Op2 == IMM) {// r,i     
  5073                                  
  5074                                  @@process181:
  5075 00002A88 A0[AD01]                 mov al, [Op2]
  5076 00002A8B 3C01                     cmp al, 1
  5077 00002A8D 0F855400                 jne @@process182
  5078                                  
  5079                                  ;-103             if (Op == REG) {               
  5080                                  
  5081 00002A91 A0[AC01]                 mov al, [Op]
  5082 00002A94 3C02                     cmp al, 2
  5083 00002A96 0F852500                 jne @@process183
  5084                                  
  5085                                  ;-104                 c = wflag << 3;   
  5086                                  
  5087 00002A9A A0[B701]                 mov al, [wflag]
  5088 00002A9D C0E003                   shl al, 3
  5089 00002AA0 8846FE                   mov byte [bp-2], al
  5090                                  
  5091                                  ;-105                 c += 0xB0;                                     
  5092                                  
  5093 00002AA3 8046FEB0                 add  byte [bp-2], 176
  5094                                  
  5095                                  ;-106                 genCode2(c, R1No);   
  5096                                  
  5097 00002AA7 A0[B301]                 mov al, byte [R1No]
  5098 00002AAA B400                     mov ah, 0
  5099 00002AAC 50                       push ax
  5100 00002AAD 8A46FE                   mov al, byte [bp-2]
  5101 00002AB0 B400                     mov ah, 0
  5102 00002AB2 50                       push ax
  5103 00002AB3 E8D0FB                   call genCode2
  5104 00002AB6 83C404                   add  sp, 4
  5105                                  
  5106                                  ;-107                 genImmediate();
  5107                                  
  5108 00002AB9 E8A8FD                   call genImmediate
  5109                                  
  5110                                  ;-108                 return; 
  5111                                  
  5112 00002ABC E9D200                   jmp @@retn
  5113                                  
  5114                                  ;-109             }
  5115                                  
  5116                                  
  5117                                  ;-110             if (Op == MEM) {// m,i  
  5118                                  
  5119                                  @@process183:
  5120 00002ABF A0[AC01]                 mov al, [Op]
  5121 00002AC2 3C04                     cmp al, 4
  5122 00002AC4 0F851700                 jne @@process184
  5123                                  
  5124                                  ;-111                 genCodeW(0xC6);
  5125                                  
  5126 00002AC8 68C600                   push 198
  5127 00002ACB E8D3FB                   call genCodeW
  5128 00002ACE 83C402                   add  sp, 2
  5129                                  
  5130                                  ;-112                 writeEA( 0 );
  5131                                  
  5132 00002AD1 6A00                     push 0
  5133 00002AD3 E85FFC                   call writeEA
  5134 00002AD6 83C402                   add  sp, 2
  5135                                  
  5136                                  ;-113                 genImmediate();
  5137                                  
  5138 00002AD9 E888FD                   call genImmediate
  5139                                  
  5140                                  ;-114                 return;  
  5141                                  
  5142 00002ADC E9B200                   jmp @@retn
  5143                                  
  5144                                  ;-115             }
  5145                                  
  5146                                  
  5147                                  ;-116             regmemerror();
  5148                                  
  5149                                  @@process184:
  5150 00002ADF E86BF7                   call regmemerror
  5151                                  
  5152                                  ;-117             return;
  5153                                  
  5154 00002AE2 E9AC00                   jmp @@retn
  5155                                  
  5156                                  ;-118         }      
  5157                                  
  5158                                  
  5159                                  ;-119         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  5160                                  
  5161                                  @@process182:
  5162 00002AE5 A0[B501]                 mov al, [R1Type]
  5163 00002AE8 3C04                     cmp al, 4
  5164 00002AEA 0F850300                 jne @@process185
  5165 00002AEE E8CD00                   call ChangeDirection
  5166                                  
  5167                                  ;-120         if (R2Type == SEGREG) {//rm,sreg
  5168                                  
  5169                                  @@process185:
  5170 00002AF1 A0[B401]                 mov al, [R2Type]
  5171 00002AF4 3C04                     cmp al, 4
  5172 00002AF6 0F852A00                 jne @@process186
  5173                                  
  5174                                  ;-121             if (OpSize != WORD) reg16error();
  5175                                  
  5176 00002AFA A0[B601]                 mov al, [OpSize]
  5177 00002AFD 3C02                     cmp al, 2
  5178 00002AFF 0F840300                 je  @@process187
  5179 00002B03 E871F7                   call reg16error
  5180                                  
  5181                                  ;-122                 genCode2(0x8C, dflag);
  5182                                  
  5183                                  @@process187:
  5184 00002B06 A0[B801]                 mov al, byte [dflag]
  5185 00002B09 B400                     mov ah, 0
  5186 00002B0B 50                       push ax
  5187 00002B0C 688C00                   push 140
  5188 00002B0F E874FB                   call genCode2
  5189 00002B12 83C404                   add  sp, 4
  5190                                  
  5191                                  ;-123                 writeEA(R2No);
  5192                                  
  5193 00002B15 A0[B201]                 mov al, byte [R2No]
  5194 00002B18 B400                     mov ah, 0
  5195 00002B1A 50                       push ax
  5196 00002B1B E817FC                   call writeEA
  5197 00002B1E 83C402                   add  sp, 2
  5198                                  
  5199                                  ;-124                 return;   
  5200                                  
  5201 00002B21 E96D00                   jmp @@retn
  5202                                  
  5203                                  ;-125         }          
  5204                                  
  5205                                  
  5206                                  ;-126          
  5207                                  
  5208                                  
  5209                                  ;-127          
  5210                                  
  5211                                  
  5212                                  ;-128         syntaxerror();
  5213                                  
  5214                                  @@process186:
  5215 00002B24 E89FF7                   call syntaxerror
  5216                                  
  5217                                  ;-129         return;
  5218                                  
  5219 00002B27 E96700                   jmp @@retn
  5220                                  
  5221                                  ;-130     }    
  5222                                  
  5223                                  
  5224                                  ;-131     
  5225                                  
  5226                                  
  5227                                  ;-132     if (CodeType ==  8) {//ret,retf
  5228                                  
  5229                                  @@process180:
  5230 00002B2A A0[AE01]                 mov al, [CodeType]
  5231 00002B2D 3C08                     cmp al, 8
  5232 00002B2F 0F853100                 jne @@process188
  5233                                  
  5234                                  ;-133         if (TokeType == DIGIT) {
  5235                                  
  5236 00002B33 A0[AB01]                 mov al, [TokeType]
  5237 00002B36 3C01                     cmp al, 1
  5238 00002B38 0F851900                 jne @@process189
  5239                                  
  5240                                  ;-134             genCode8(Code2);
  5241                                  
  5242 00002B3C A0[B001]                 mov al, byte [Code2]
  5243 00002B3F B400                     mov ah, 0
  5244 00002B41 50                       push ax
  5245 00002B42 E878FB                   call genCode8
  5246 00002B45 83C402                   add  sp, 2
  5247                                  
  5248                                  ;-135             genCode16(SymbolInt);
  5249                                  
  5250 00002B48 FF36[4D00]               push word [SymbolInt]
  5251 00002B4C E8C5FB                   call genCode16
  5252 00002B4F 83C402                   add  sp, 2
  5253                                  
  5254                                  ;-136             return;
  5255                                  
  5256 00002B52 E93C00                   jmp @@retn
  5257                                  
  5258                                  ;-137         }
  5259                                  
  5260                                  
  5261                                  ;-138         genCode8(Code1); 
  5262                                  
  5263                                  @@process189:
  5264 00002B55 A0[AF01]                 mov al, byte [Code1]
  5265 00002B58 B400                     mov ah, 0
  5266 00002B5A 50                       push ax
  5267 00002B5B E85FFB                   call genCode8
  5268 00002B5E 83C402                   add  sp, 2
  5269                                  
  5270                                  ;-139         return;
  5271                                  
  5272 00002B61 E92D00                   jmp @@retn
  5273                                  
  5274                                  ;-140     }
  5275                                  
  5276                                  
  5277                                  ;-141 
  5278                                  
  5279                                  
  5280                                  ;-142     if (CodeType==101) {// ORG nn
  5281                                  
  5282                                  @@process188:
  5283 00002B64 A0[AE01]                 mov al, [CodeType]
  5284 00002B67 3C65                     cmp al, 101
  5285 00002B69 0F851B00                 jne @@process190
  5286                                  
  5287                                  ;-143         if (TokeType != DIGIT) error1("only digit allowed");
  5288                                  
  5289 00002B6D A0[AB01]                 mov al, [TokeType]
  5290 00002B70 3C01                     cmp al, 1
  5291 00002B72 0F840900                 je  @@process191
  5292 00002B76 68[932B]                 push process_0
  5293 00002B79 E88BF5                   call error1
  5294 00002B7C 83C402                   add  sp, 2
  5295                                  
  5296                                  ;-144         PC=SymbolInt;
  5297                                  
  5298                                  @@process191:
  5299 00002B7F A1[4D00]                 mov ax, [SymbolInt]
  5300 00002B82 A3[A601]                 mov word [PC], ax
  5301                                  
  5302                                  ;-145         return;
  5303                                  
  5304 00002B85 E90900                   jmp @@retn
  5305                                  
  5306                                  ;-146     }
  5307                                  
  5308                                  
  5309                                  ;-147     error1("Command not implemented");
  5310                                  
  5311                                  @@process190:
  5312 00002B88 68[A62B]                 push process_1
  5313 00002B8B E879F5                   call error1
  5314 00002B8E 83C402                   add  sp, 2
  5315                                  
  5316                                  ;-148 }    
  5317                                  
  5318                                  
  5319                                  ;-149      
  5320                                  
  5321                                  
  5322                                  ;-150 int ChangeDirection() {
  5323                                  
  5324 00002B91 C9                      @@retn: LEAVE
  5325 00002B92 C3                       ret
  5326                                  ; ENDP
  5327 00002B93 6F6E6C792064696769-     process_0 db "only digit allowed",0
  5328 00002B9C 7420616C6C6F776564-
  5329 00002BA5 00                 
  5330 00002BA6 436F6D6D616E64206E-     process_1 db "Command not implemented",0
  5331 00002BAF 6F7420696D706C656D-
  5332 00002BB8 656E74656400       
  5333                                  
  5334                                  ChangeDirection:  ; *** PROC ***
  5335                                  
  5336                                  ;-151     char c;
  5337                                  
  5338                                  
  5339                                  ;-152     c=Op;     Op    =Op2;    Op2   =c;
  5340                                  
  5341                                  ;Function : ChangeDirection, Number of local variables: 1
  5342                                  ;   # type sign width line used address name   list of local variables
  5343                                  ;  200 var sign byte   151 NULL bp-2    c;
  5344 00002BBE C8020000                 ENTER  2,0
  5345 00002BC2 A0[AC01]                 mov al, [Op]
  5346 00002BC5 8846FE                   mov byte [bp-2], al
  5347 00002BC8 A0[AD01]                 mov al, [Op2]
  5348 00002BCB A2[AC01]                 mov byte [Op], al
  5349 00002BCE 8A46FE                   mov al, [bp-2]
  5350 00002BD1 A2[AD01]                 mov byte [Op2], al
  5351                                  
  5352                                  ;-153     c=R1Type; R1Type=R2Type; R2Type=c;
  5353                                  
  5354 00002BD4 A0[B501]                 mov al, [R1Type]
  5355 00002BD7 8846FE                   mov byte [bp-2], al
  5356 00002BDA A0[B401]                 mov al, [R2Type]
  5357 00002BDD A2[B501]                 mov byte [R1Type], al
  5358 00002BE0 8A46FE                   mov al, [bp-2]
  5359 00002BE3 A2[B401]                 mov byte [R2Type], al
  5360                                  
  5361                                  ;-154     c=R1No;   R1No  =R2No;   R2No  =c;
  5362                                  
  5363 00002BE6 A0[B301]                 mov al, [R1No]
  5364 00002BE9 8846FE                   mov byte [bp-2], al
  5365 00002BEC A0[B201]                 mov al, [R2No]
  5366 00002BEF A2[B301]                 mov byte [R1No], al
  5367 00002BF2 8A46FE                   mov al, [bp-2]
  5368 00002BF5 A2[B201]                 mov byte [R2No], al
  5369                                  
  5370                                  ;-155     dflag=2;     
  5371                                  
  5372 00002BF8 66B802000000             mov eax, 2
  5373 00002BFE A2[B801]                 mov byte [dflag], al
  5374                                  
  5375                                  ;-156 }
  5376                                  
  5377                                  
  5378                                  ;-157      
  5379                                  
  5380                                  
  5381                                  ;-158 int checkOpL() {
  5382 00002C01 C9                       LEAVE
  5383 00002C02 C3                       ret
  5384                                  ; ENDP
  5385                                  
  5386                                  checkOpL:  ; *** PROC ***
  5387                                  
  5388                                  ;-159     if (Op == ADR) implerror();
  5389                                  
  5390 00002C03 A0[AC01]                 mov al, [Op]
  5391 00002C06 3C03                     cmp al, 3
  5392 00002C08 0F850300                 jne @@checkOpL192
  5393 00002C0C E8C8F5                   call implerror
  5394                                  
  5395                                  ;-160     if (R2Type == SEGREG) {segregerror(); return;}//only move,push,pop
  5396                                  
  5397                                  @@checkOpL192:
  5398 00002C0F A0[B401]                 mov al, [R2Type]
  5399 00002C12 3C04                     cmp al, 4
  5400 00002C14 0F850600                 jne @@checkOpL193
  5401 00002C18 E884F6                   call segregerror
  5402 00002C1B E95300                   jmp @@retn
  5403                                  
  5404                                  ;-161     setwflag();
  5405                                  
  5406                                  @@checkOpL193:
  5407 00002C1E E80204                   call setwflag
  5408                                  
  5409                                  ;-162     if (OpSize == 0) error1("no op size declared");
  5410                                  
  5411 00002C21 A0[B601]                 mov al, [OpSize]
  5412 00002C24 3C00                     cmp al, 0
  5413 00002C26 0F850900                 jne @@checkOpL194
  5414 00002C2A 68[722C]                 push checkOpL_0
  5415 00002C2D E8D7F4                   call error1
  5416 00002C30 83C402                   add  sp, 2
  5417                                  
  5418                                  ;-163     if (OpSize == R1Type) return;
  5419                                  
  5420                                  @@checkOpL194:
  5421 00002C33 A0[B601]                 mov al, [OpSize]
  5422 00002C36 3A06[B501]               cmp al, [R1Type]
  5423 00002C3A 0F850300                 jne @@checkOpL195
  5424 00002C3E E93000                   jmp @@retn
  5425                                  
  5426                                  ;-164     if (OpSize){
  5427                                  
  5428                                  @@checkOpL195:
  5429 00002C41 A0[B601]                 mov al, [OpSize]
  5430 00002C44 08C0                     or  al, al
  5431 00002C46 0F841500                 je @@checkOpL196
  5432                                  
  5433                                  ;-165         if (Op == MEM) return;
  5434                                  
  5435 00002C4A A0[AC01]                 mov al, [Op]
  5436 00002C4D 3C04                     cmp al, 4
  5437 00002C4F 0F850300                 jne @@checkOpL197
  5438 00002C53 E91B00                   jmp @@retn
  5439                                  
  5440                                  ;-166         error1("Conflict OpSize and RegSize"); 
  5441                                  
  5442                                  @@checkOpL197:
  5443 00002C56 68[862C]                 push checkOpL_1
  5444 00002C59 E8ABF4                   call error1
  5445 00002C5C 83C402                   add  sp, 2
  5446                                  
  5447                                  ;-167         }
  5448                                  
  5449                                  
  5450                                  ;-168     if (R1Type==0) error1("no register defined");
  5451                                  
  5452                                  @@checkOpL196:
  5453 00002C5F A0[B501]                 mov al, [R1Type]
  5454 00002C62 3C00                     cmp al, 0
  5455 00002C64 0F850900                 jne @@checkOpL198
  5456 00002C68 68[A22C]                 push checkOpL_2
  5457 00002C6B E899F4                   call error1
  5458 00002C6E 83C402                   add  sp, 2
  5459                                  
  5460                                  ;-169 }
  5461                                  
  5462                                  @@checkOpL198:
  5463                                  
  5464                                  ;-170     
  5465                                  
  5466                                  
  5467                                  ;-171 int check2Ops() {
  5468                                  
  5469                                  @@retn:
  5470 00002C71 C3                       ret
  5471                                  ; ENDP
  5472 00002C72 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  5473 00002C7B 65206465636C617265-
  5474 00002C84 6400               
  5475 00002C86 436F6E666C69637420-     checkOpL_1 db "Conflict OpSize and RegSize",0
  5476 00002C8F 4F7053697A6520616E-
  5477 00002C98 642052656753697A65-
  5478 00002CA1 00                 
  5479 00002CA2 6E6F20726567697374-     checkOpL_2 db "no register defined",0
  5480 00002CAB 657220646566696E65-
  5481 00002CB4 6400               
  5482                                  
  5483                                  check2Ops:  ; *** PROC ***
  5484                                  
  5485                                  ;-172     get2Ops();
  5486                                  
  5487 00002CB6 E83400                   call get2Ops
  5488                                  
  5489                                  ;-173     if (Op ==   0) addrerror();
  5490                                  
  5491 00002CB9 A0[AC01]                 mov al, [Op]
  5492 00002CBC 3C00                     cmp al, 0
  5493 00002CBE 0F850300                 jne @@check2Ops199
  5494 00002CC2 E8D3F4                   call addrerror
  5495                                  
  5496                                  ;-174     if (Op == ADR) invaloperror(); 
  5497                                  
  5498                                  @@check2Ops199:
  5499 00002CC5 A0[AC01]                 mov al, [Op]
  5500 00002CC8 3C03                     cmp al, 3
  5501 00002CCA 0F850300                 jne @@check2Ops200
  5502 00002CCE E841F5                   call invaloperror
  5503                                  
  5504                                  ;-175     if (Op == IMM) immeerror();   
  5505                                  
  5506                                  @@check2Ops200:
  5507 00002CD1 A0[AC01]                 mov al, [Op]
  5508 00002CD4 3C01                     cmp al, 1
  5509 00002CD6 0F850300                 jne @@check2Ops201
  5510 00002CDA E8D5F4                   call immeerror
  5511                                  
  5512                                  ;-176     if (Op2==   0) addrerror();
  5513                                  
  5514                                  @@check2Ops201:
  5515 00002CDD A0[AD01]                 mov al, [Op2]
  5516 00002CE0 3C00                     cmp al, 0
  5517 00002CE2 0F850300                 jne @@check2Ops202
  5518 00002CE6 E8AFF4                   call addrerror
  5519                                  
  5520                                  ;-177 //    if (Op2== ADR) invaloperror();//allowed in mov           
  5521                                  
  5522                                  
  5523                                  ;-178     setwflag();       
  5524                                  
  5525                                  @@check2Ops202:
  5526 00002CE9 E83703                   call setwflag
  5527                                  
  5528                                  ;-179 }    
  5529                                  
  5530                                  
  5531                                  ;-180 int get2Ops() {
  5532                                  
  5533 00002CEC C3                       ret
  5534                                  ; ENDP
  5535                                  
  5536                                  get2Ops:  ; *** PROC ***
  5537                                  
  5538                                  ;-181     getOpL();
  5539                                  
  5540 00002CED E80C00                   call getOpL
  5541                                  
  5542                                  ;-182     need(',');    
  5543                                  
  5544 00002CF0 6A2C                     push 44
  5545 00002CF2 E8E8E9                   call need
  5546 00002CF5 83C402                   add  sp, 2
  5547                                  
  5548                                  ;-183     getOpR();         
  5549                                  
  5550 00002CF8 E84D00                   call getOpR
  5551                                  
  5552                                  ;-184 } 
  5553                                  
  5554                                  
  5555                                  ;-185         
  5556                                  
  5557                                  
  5558                                  ;-186 int getOpL() {
  5559                                  
  5560 00002CFB C3                       ret
  5561                                  ; ENDP
  5562                                  
  5563                                  getOpL:  ; *** PROC ***
  5564                                  
  5565                                  ;-187 //set: op=0,IMM,REG,ADR,MEM
  5566                                  
  5567                                  
  5568                                  ;-188     disp=0; imme=0; isDirect=1; 
  5569                                  
  5570 00002CFC 66B800000000             mov eax, 0
  5571 00002D02 A3[BC01]                 mov word [disp], ax
  5572 00002D05 66B800000000             mov eax, 0
  5573 00002D0B A3[BE01]                 mov word [imme], ax
  5574 00002D0E 66B801000000             mov eax, 1
  5575 00002D14 A2[BB01]                 mov byte [isDirect], al
  5576                                  
  5577                                  ;-189     getOpR();
  5578                                  
  5579 00002D17 E82E00                   call getOpR
  5580                                  
  5581                                  ;-190     Op=Op2;         Op2=0;
  5582                                  
  5583 00002D1A A0[AD01]                 mov al, [Op2]
  5584 00002D1D A2[AC01]                 mov byte [Op], al
  5585 00002D20 66B800000000             mov eax, 0
  5586 00002D26 A2[AD01]                 mov byte [Op2], al
  5587                                  
  5588                                  ;-191     R1No=R2No;      R2No=0;
  5589                                  
  5590 00002D29 A0[B201]                 mov al, [R2No]
  5591 00002D2C A2[B301]                 mov byte [R1No], al
  5592 00002D2F 66B800000000             mov eax, 0
  5593 00002D35 A2[B201]                 mov byte [R2No], al
  5594                                  
  5595                                  ;-192     R1Type=R2Type; R2Type=0; 
  5596                                  
  5597 00002D38 A0[B401]                 mov al, [R2Type]
  5598 00002D3B A2[B501]                 mov byte [R1Type], al
  5599 00002D3E 66B800000000             mov eax, 0
  5600 00002D44 A2[B401]                 mov byte [R2Type], al
  5601                                  
  5602                                  ;-193 }  
  5603                                  
  5604                                  
  5605                                  ;-194 
  5606                                  
  5607                                  
  5608                                  ;-195 int getOpR() {
  5609                                  
  5610 00002D47 C3                       ret
  5611                                  ; ENDP
  5612                                  
  5613                                  getOpR:  ; *** PROC ***
  5614                                  
  5615                                  ;-196     Op2=getOp1();
  5616                                  
  5617 00002D48 E88900                   call getOp1
  5618 00002D4B A2[AD01]                 mov byte [Op2], al
  5619                                  
  5620                                  ;-197     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  5621                                  
  5622 00002D4E 6A5B                     push 91
  5623 00002D50 E85CE9                   call isToken
  5624 00002D53 83C402                   add  sp, 2
  5625 00002D56 08C0                     or  al, al
  5626 00002D58 0F840F00                 je @@getOpR203
  5627 00002D5C 66B804000000             mov eax, 4
  5628 00002D62 A2[AD01]                 mov byte [Op2], al
  5629 00002D65 E8F200                   call getMEM
  5630 00002D68 E94F00                   jmp @@retn
  5631                                  
  5632                                  ;-198     if (Op2 == 0)     {invaloperror();         return;}
  5633                                  
  5634                                  @@getOpR203:
  5635 00002D6B A0[AD01]                 mov al, [Op2]
  5636 00002D6E 3C00                     cmp al, 0
  5637 00002D70 0F850600                 jne @@getOpR204
  5638 00002D74 E89BF4                   call invaloperror
  5639 00002D77 E94000                   jmp @@retn
  5640                                  
  5641                                  ;-199     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  5642                                  
  5643                                  @@getOpR204:
  5644 00002D7A A0[AD01]                 mov al, [Op2]
  5645 00002D7D 3C01                     cmp al, 1
  5646 00002D7F 0F850900                 jne @@getOpR205
  5647 00002D83 A1[4D00]                 mov ax, [SymbolInt]
  5648 00002D86 A3[BE01]                 mov word [imme], ax
  5649 00002D89 E92E00                   jmp @@retn
  5650                                  
  5651                                  ;-200     if (Op2 == REG)                            return;
  5652                                  
  5653                                  @@getOpR205:
  5654 00002D8C A0[AD01]                 mov al, [Op2]
  5655 00002D8F 3C02                     cmp al, 2
  5656 00002D91 0F850300                 jne @@getOpR206
  5657 00002D95 E92200                   jmp @@retn
  5658                                  
  5659                                  ;-201     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  5660                                  
  5661                                  @@getOpR206:
  5662 00002D98 A0[AD01]                 mov al, [Op2]
  5663 00002D9B 3C03                     cmp al, 3
  5664 00002D9D 0F851000                 jne @@getOpR207
  5665 00002DA1 8B1E[7E06]               mov bx, [LabelIx]
  5666 00002DA5 D1E3                     shl bx, 1
  5667 00002DA7 8B87[B405]               mov ax, [LabelAddr + bx]
  5668 00002DAB A3[BC01]                 mov word [disp], ax
  5669 00002DAE E90900                   jmp @@retn
  5670                                  
  5671                                  ;-202     error1("Name of operand expected");
  5672                                  
  5673                                  @@getOpR207:
  5674 00002DB1 68[BB2D]                 push getOpR_0
  5675 00002DB4 E850F3                   call error1
  5676 00002DB7 83C402                   add  sp, 2
  5677                                  
  5678                                  ;-203 }
  5679                                  
  5680                                  
  5681                                  ;-204 
  5682                                  
  5683                                  
  5684                                  ;-205 int getOp1() {//scan for a single operand
  5685                                  
  5686                                  @@retn:
  5687 00002DBA C3                       ret
  5688                                  ; ENDP
  5689 00002DBB 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  5690 00002DC4 706572616E64206578-
  5691 00002DCD 70656374656400     
  5692                                  
  5693                                  getOp1:  ; *** PROC ***
  5694                                  
  5695                                  ;-206 //return:0, IMM, REG, ADR (not MEM)
  5696                                  
  5697                                  
  5698                                  ;-207 //set   :R2Type, R2No by testReg
  5699                                  
  5700                                  
  5701                                  ;-208 //set   :LabelIx by searchLabel
  5702                                  
  5703                                  
  5704                                  ;-209     if (TokeType == 0)      return 0;
  5705                                  
  5706 00002DD4 A0[AB01]                 mov al, [TokeType]
  5707 00002DD7 3C00                     cmp al, 0
  5708 00002DD9 0F850900                 jne @@getOp1208
  5709 00002DDD 66B800000000             mov eax, 0
  5710 00002DE3 E96000                   jmp @@retn
  5711                                  
  5712                                  ;-210     if (TokeType == DIGIT)  return IMM;
  5713                                  
  5714                                  @@getOp1208:
  5715 00002DE6 A0[AB01]                 mov al, [TokeType]
  5716 00002DE9 3C01                     cmp al, 1
  5717 00002DEB 0F850900                 jne @@getOp1209
  5718 00002DEF 66B801000000             mov eax, 1
  5719 00002DF5 E94E00                   jmp @@retn
  5720                                  
  5721                                  ;-211     if (TokeType == ALNUME) {
  5722                                  
  5723                                  @@getOp1209:
  5724 00002DF8 A0[AB01]                 mov al, [TokeType]
  5725 00002DFB 3C03                     cmp al, 3
  5726 00002DFD 0F853C00                 jne @@getOp1210
  5727                                  
  5728                                  ;-212         R2No=testReg();
  5729                                  
  5730 00002E01 E858EC                   call testReg
  5731 00002E04 A2[B201]                 mov byte [R2No], al
  5732                                  
  5733                                  ;-213         if (R2Type)        return REG;
  5734                                  
  5735 00002E07 A0[B401]                 mov al, [R2Type]
  5736 00002E0A 08C0                     or  al, al
  5737 00002E0C 0F840900                 je @@getOp1211
  5738 00002E10 66B802000000             mov eax, 2
  5739 00002E16 E92D00                   jmp @@retn
  5740                                  
  5741                                  ;-214         LabelIx=searchLabel();
  5742                                  
  5743                                  @@getOp1211:
  5744 00002E19 E8FEE5                   call searchLabel
  5745 00002E1C A3[7E06]                 mov word [LabelIx], ax
  5746                                  
  5747                                  ;-215         if (LabelIx)        return ADR;
  5748                                  
  5749 00002E1F A1[7E06]                 mov ax, [LabelIx]
  5750 00002E22 08C0                     or  al, al
  5751 00002E24 0F840C00                 je @@getOp1212
  5752 00002E28 66B803000000             mov eax, 3
  5753 00002E2E E91500                   jmp @@retn
  5754                                  
  5755                                  ;-216         else error1("variable not found"); 
  5756                                  
  5757 00002E31 E90900                   jmp @@getOp1213
  5758                                  @@getOp1212:
  5759 00002E34 68[472E]                 push getOp1_0
  5760 00002E37 E8CDF2                   call error1
  5761 00002E3A 83C402                   add  sp, 2
  5762                                  
  5763                                  ;-217     }
  5764                                  
  5765                                  @@getOp1213:
  5766                                  
  5767                                  ;-218     return 0;
  5768                                  
  5769                                  @@getOp1210:
  5770 00002E3D 66B800000000             mov eax, 0
  5771 00002E43 E90000                   jmp @@retn
  5772                                  
  5773                                  ;-219 }
  5774                                  
  5775                                  
  5776                                  ;-220 
  5777                                  
  5778                                  
  5779                                  ;-221 int getMEM() {// e.g. [array+bp+si-4]
  5780                                  
  5781                                  @@retn:
  5782 00002E46 C3                       ret
  5783                                  ; ENDP
  5784 00002E47 7661726961626C6520-     getOp1_0 db "variable not found",0
  5785 00002E50 6E6F7420666F756E64-
  5786 00002E59 00                 
  5787                                  
  5788                                  getMEM:  ; *** PROC ***
  5789                                  
  5790                                  ;-222 //set: disp, rm, R2Type
  5791                                  
  5792                                  
  5793                                  ;-223     char c;
  5794                                  
  5795                                  
  5796                                  ;-224     disp=0; rm=0;
  5797                                  
  5798                                  ;Function : getMEM, Number of local variables: 1
  5799                                  ;   # type sign width line used address name   list of local variables
  5800                                  ;  200 var sign byte   223 NULL bp-2    c;
  5801 00002E5A C8020000                 ENTER  2,0
  5802 00002E5E 66B800000000             mov eax, 0
  5803 00002E64 A3[BC01]                 mov word [disp], ax
  5804 00002E67 66B800000000             mov eax, 0
  5805 00002E6D A2[BA01]                 mov byte [rm], al
  5806                                  
  5807                                  ;-225     do {
  5808                                  
  5809                                  @@getMEM214:
  5810                                  
  5811                                  ;-226         getTokeType();
  5812                                  
  5813 00002E70 E866E4                   call getTokeType
  5814                                  
  5815                                  ;-227         c=getOp1();
  5816                                  
  5817 00002E73 E85EFF                   call getOp1
  5818 00002E76 8846FE                   mov byte [bp-2], al
  5819                                  
  5820                                  ;-228         if (c ==   0) syntaxerror();
  5821                                  
  5822 00002E79 8A46FE                   mov al, [bp-2]
  5823 00002E7C 3C00                     cmp al, 0
  5824 00002E7E 0F850300                 jne @@getMEM215
  5825 00002E82 E841F4                   call syntaxerror
  5826                                  
  5827                                  ;-229         if (c == REG) {isDirect=0;
  5828                                  
  5829                                  @@getMEM215:
  5830 00002E85 8A46FE                   mov al, [bp-2]
  5831 00002E88 3C02                     cmp al, 2
  5832 00002E8A 0F851E00                 jne @@getMEM216
  5833 00002E8E 66B800000000             mov eax, 0
  5834 00002E94 A2[BB01]                 mov byte [isDirect], al
  5835                                  
  5836                                  ;-230             if (rm) rm=getIndReg2();
  5837                                  
  5838 00002E97 A0[BA01]                 mov al, [rm]
  5839 00002E9A 08C0                     or  al, al
  5840 00002E9C 0F840900                 je @@getMEM217
  5841 00002EA0 E8F300                   call getIndReg2
  5842 00002EA3 A2[BA01]                 mov byte [rm], al
  5843                                  
  5844                                  ;-231             else getIndReg1();
  5845                                  
  5846 00002EA6 E90300                   jmp @@getMEM218
  5847                                  @@getMEM217:
  5848 00002EA9 E88900                   call getIndReg1
  5849                                  
  5850                                  ;-232         }
  5851                                  
  5852                                  @@getMEM218:
  5853                                  
  5854                                  ;-233         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  5855                                  
  5856                                  @@getMEM216:
  5857 00002EAC 8A46FE                   mov al, [bp-2]
  5858 00002EAF 3C03                     cmp al, 3
  5859 00002EB1 0F851000                 jne @@getMEM219
  5860 00002EB5 A1[BC01]                 mov ax, [disp]
  5861 00002EB8 8B1E[7E06]               mov bx, [LabelIx]
  5862 00002EBC D1E3                     shl bx, 1
  5863 00002EBE 0387[B405]               add ax, [LabelAddr + bx]
  5864 00002EC2 A3[BC01]                 mov word [disp], ax
  5865                                  
  5866                                  ;-234         if (c == IMM) disp=disp+SymbolInt;
  5867                                  
  5868                                  @@getMEM219:
  5869 00002EC5 8A46FE                   mov al, [bp-2]
  5870 00002EC8 3C01                     cmp al, 1
  5871 00002ECA 0F850A00                 jne @@getMEM220
  5872 00002ECE A1[BC01]                 mov ax, [disp]
  5873 00002ED1 0306[4D00]               add ax, [SymbolInt]
  5874 00002ED5 A3[BC01]                 mov word [disp], ax
  5875                                  
  5876                                  ;-235         if (isToken('-')) {
  5877                                  
  5878                                  @@getMEM220:
  5879 00002ED8 6A2D                     push 45
  5880 00002EDA E8D2E7                   call isToken
  5881 00002EDD 83C402                   add  sp, 2
  5882 00002EE0 08C0                     or  al, al
  5883 00002EE2 0F841900                 je @@getMEM221
  5884                                  
  5885                                  ;-236             getTokeType();
  5886                                  
  5887 00002EE6 E8F0E3                   call getTokeType
  5888                                  
  5889                                  ;-237             if (TokeType != DIGIT) numbererror();
  5890                                  
  5891 00002EE9 A0[AB01]                 mov al, [TokeType]
  5892 00002EEC 3C01                     cmp al, 1
  5893 00002EEE 0F840300                 je  @@getMEM222
  5894 00002EF2 E83EF3                   call numbererror
  5895                                  
  5896                                  ;-238             disp = disp - SymbolInt;
  5897                                  
  5898                                  @@getMEM222:
  5899 00002EF5 A1[BC01]                 mov ax, [disp]
  5900 00002EF8 2B06[4D00]               sub ax, [SymbolInt]
  5901 00002EFC A3[BC01]                 mov word [disp], ax
  5902                                  
  5903                                  ;-239         }
  5904                                  
  5905                                  
  5906                                  ;-240     } while (isToken('+'));
  5907                                  
  5908                                  @@getMEM221:
  5909 00002EFF 6A2B                     push 43
  5910 00002F01 E8ABE7                   call isToken
  5911 00002F04 83C402                   add  sp, 2
  5912 00002F07 08C0                     or  al, al
  5913 00002F09 0F840300                 je @@getMEM223
  5914 00002F0D E960FF                   jmp @@getMEM214
  5915                                  @@getMEM223:
  5916                                  
  5917                                  ;-241     if (isToken(']') == 0) errorexit("] expected");
  5918                                  
  5919 00002F10 6A5D                     push 93
  5920 00002F12 E89AE7                   call isToken
  5921 00002F15 83C402                   add  sp, 2
  5922 00002F18 83F800                   cmp ax, 0
  5923 00002F1B 0F850900                 jne @@getMEM224
  5924 00002F1F 68[2A2F]                 push getMEM_0
  5925 00002F22 E841F2                   call errorexit
  5926 00002F25 83C402                   add  sp, 2
  5927                                  
  5928                                  ;-242 }
  5929                                  
  5930                                  @@getMEM224:
  5931                                  
  5932                                  ;-243 int getIndReg1() {
  5933 00002F28 C9                       LEAVE
  5934 00002F29 C3                       ret
  5935                                  ; ENDP
  5936 00002F2A 5D2065787065637465-     getMEM_0 db "] expected",0
  5937 00002F33 6400               
  5938                                  
  5939                                  getIndReg1:  ; *** PROC ***
  5940                                  
  5941                                  ;-244     if (R2Type !=WORD) indexerror();
  5942                                  
  5943 00002F35 A0[B401]                 mov al, [R2Type]
  5944 00002F38 3C02                     cmp al, 2
  5945 00002F3A 0F840300                 je  @@getIndReg1225
  5946 00002F3E E8B0F2                   call indexerror
  5947                                  
  5948                                  ;-245     if (R2No==3) rm=7;//BX
  5949                                  
  5950                                  @@getIndReg1225:
  5951 00002F41 A0[B201]                 mov al, [R2No]
  5952 00002F44 3C03                     cmp al, 3
  5953 00002F46 0F850900                 jne @@getIndReg1226
  5954 00002F4A 66B807000000             mov eax, 7
  5955 00002F50 A2[BA01]                 mov byte [rm], al
  5956                                  
  5957                                  ;-246     if (R2No==5) rm=6;//BP, change to BP+0
  5958                                  
  5959                                  @@getIndReg1226:
  5960 00002F53 A0[B201]                 mov al, [R2No]
  5961 00002F56 3C05                     cmp al, 5
  5962 00002F58 0F850900                 jne @@getIndReg1227
  5963 00002F5C 66B806000000             mov eax, 6
  5964 00002F62 A2[BA01]                 mov byte [rm], al
  5965                                  
  5966                                  ;-247     if (R2No==7) rm=5;//DI
  5967                                  
  5968                                  @@getIndReg1227:
  5969 00002F65 A0[B201]                 mov al, [R2No]
  5970 00002F68 3C07                     cmp al, 7
  5971 00002F6A 0F850900                 jne @@getIndReg1228
  5972 00002F6E 66B805000000             mov eax, 5
  5973 00002F74 A2[BA01]                 mov byte [rm], al
  5974                                  
  5975                                  ;-248     if (R2No==6) rm=4;//SI
  5976                                  
  5977                                  @@getIndReg1228:
  5978 00002F77 A0[B201]                 mov al, [R2No]
  5979 00002F7A 3C06                     cmp al, 6
  5980 00002F7C 0F850900                 jne @@getIndReg1229
  5981 00002F80 66B804000000             mov eax, 4
  5982 00002F86 A2[BA01]                 mov byte [rm], al
  5983                                  
  5984                                  ;-249     if (rm==0) indexerror();
  5985                                  
  5986                                  @@getIndReg1229:
  5987 00002F89 A0[BA01]                 mov al, [rm]
  5988 00002F8C 3C00                     cmp al, 0
  5989 00002F8E 0F850300                 jne @@getIndReg1230
  5990 00002F92 E85CF2                   call indexerror
  5991                                  
  5992                                  ;-250 }
  5993                                  
  5994                                  @@getIndReg1230:
  5995                                  
  5996                                  ;-251 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5997                                  
  5998 00002F95 C3                       ret
  5999                                  ; ENDP
  6000                                  
  6001                                  getIndReg2:  ; *** PROC ***
  6002                                  ;Function : getIndReg2, Number of local variables: 1
  6003                                  ;   # type sign width line used address name   list of local variables
  6004                                  ;  200 var sign byte   251 NULL bp-2    m;
  6005 00002F96 C8020000                 ENTER  2,0
  6006 00002F9A 66B804000000             mov eax, 4
  6007 00002FA0 8846FE                   mov byte [bp-2], al
  6008                                  
  6009                                  ;-252     if (R2Type !=WORD) indexerror();
  6010                                  
  6011 00002FA3 A0[B401]                 mov al, [R2Type]
  6012 00002FA6 3C02                     cmp al, 2
  6013 00002FA8 0F840300                 je  @@getIndReg2231
  6014 00002FAC E842F2                   call indexerror
  6015                                  
  6016                                  ;-253     if (R2No==7) if (rm==6) m=3;//BP+DI
  6017                                  
  6018                                  @@getIndReg2231:
  6019 00002FAF A0[B201]                 mov al, [R2No]
  6020 00002FB2 3C07                     cmp al, 7
  6021 00002FB4 0F852700                 jne @@getIndReg2232
  6022 00002FB8 A0[BA01]                 mov al, [rm]
  6023 00002FBB 3C06                     cmp al, 6
  6024 00002FBD 0F850C00                 jne @@getIndReg2233
  6025 00002FC1 66B803000000             mov eax, 3
  6026 00002FC7 8846FE                   mov byte [bp-2], al
  6027                                  
  6028                                  ;-254              else if (rm==7) m=1;//BX+DI
  6029                                  
  6030 00002FCA E91200                   jmp @@getIndReg2234
  6031                                  @@getIndReg2233:
  6032 00002FCD A0[BA01]                 mov al, [rm]
  6033 00002FD0 3C07                     cmp al, 7
  6034 00002FD2 0F850900                 jne @@getIndReg2235
  6035 00002FD6 66B801000000             mov eax, 1
  6036 00002FDC 8846FE                   mov byte [bp-2], al
  6037                                  
  6038                                  ;-255     if (R2No==6) if (rm==6) m=2;//BP+SI
  6039                                  
  6040                                  @@getIndReg2235:
  6041                                  @@getIndReg2234:
  6042                                  @@getIndReg2232:
  6043 00002FDF A0[B201]                 mov al, [R2No]
  6044 00002FE2 3C06                     cmp al, 6
  6045 00002FE4 0F852700                 jne @@getIndReg2236
  6046 00002FE8 A0[BA01]                 mov al, [rm]
  6047 00002FEB 3C06                     cmp al, 6
  6048 00002FED 0F850C00                 jne @@getIndReg2237
  6049 00002FF1 66B802000000             mov eax, 2
  6050 00002FF7 8846FE                   mov byte [bp-2], al
  6051                                  
  6052                                  ;-256              else if (rm==7) m=0;//BX+SI
  6053                                  
  6054 00002FFA E91200                   jmp @@getIndReg2238
  6055                                  @@getIndReg2237:
  6056 00002FFD A0[BA01]                 mov al, [rm]
  6057 00003000 3C07                     cmp al, 7
  6058 00003002 0F850900                 jne @@getIndReg2239
  6059 00003006 66B800000000             mov eax, 0
  6060 0000300C 8846FE                   mov byte [bp-2], al
  6061                                  
  6062                                  ;-257     if (m > 3) indexerror();
  6063                                  
  6064                                  @@getIndReg2239:
  6065                                  @@getIndReg2238:
  6066                                  @@getIndReg2236:
  6067 0000300F 8A46FE                   mov al, [bp-2]
  6068 00003012 3C03                     cmp al, 3
  6069 00003014 0F8E0300                 jle @@getIndReg2240
  6070 00003018 E8D6F1                   call indexerror
  6071                                  
  6072                                  ;-258     return m;
  6073                                  
  6074                                  @@getIndReg2240:
  6075 0000301B 8A46FE                   mov al, [bp-2]
  6076 0000301E E90000                   jmp @@retn
  6077                                  
  6078                                  ;-259 }
  6079                                  
  6080                                  
  6081                                  ;-260                   
  6082                                  
  6083                                  
  6084                                  ;-261 int setwflag() {//word size, bit 0
  6085                                  
  6086 00003021 C9                      @@retn: LEAVE
  6087 00003022 C3                       ret
  6088                                  ; ENDP
  6089                                  
  6090                                  setwflag:  ; *** PROC ***
  6091                                  
  6092                                  ;-262     wflag=0;
  6093                                  
  6094 00003023 66B800000000             mov eax, 0
  6095 00003029 A2[B701]                 mov byte [wflag], al
  6096                                  
  6097                                  ;-263     if (OpSize == 0) {//do not override OpSize
  6098                                  
  6099 0000302C A0[B601]                 mov al, [OpSize]
  6100 0000302F 3C00                     cmp al, 0
  6101 00003031 0F854200                 jne @@setwflag241
  6102                                  
  6103                                  ;-264         if (Op == REG) OpSize=R1Type;
  6104                                  
  6105 00003035 A0[AC01]                 mov al, [Op]
  6106 00003038 3C02                     cmp al, 2
  6107 0000303A 0F850600                 jne @@setwflag242
  6108 0000303E A0[B501]                 mov al, [R1Type]
  6109 00003041 A2[B601]                 mov byte [OpSize], al
  6110                                  
  6111                                  ;-265         if (Op2== REG) OpSize=R2Type;        
  6112                                  
  6113                                  @@setwflag242:
  6114 00003044 A0[AD01]                 mov al, [Op2]
  6115 00003047 3C02                     cmp al, 2
  6116 00003049 0F850600                 jne @@setwflag243
  6117 0000304D A0[B401]                 mov al, [R2Type]
  6118 00003050 A2[B601]                 mov byte [OpSize], al
  6119                                  
  6120                                  ;-266         if (R2Type== SEGREG) OpSize=WORD;
  6121                                  
  6122                                  @@setwflag243:
  6123 00003053 A0[B401]                 mov al, [R2Type]
  6124 00003056 3C04                     cmp al, 4
  6125 00003058 0F850900                 jne @@setwflag244
  6126 0000305C 66B802000000             mov eax, 2
  6127 00003062 A2[B601]                 mov byte [OpSize], al
  6128                                  
  6129                                  ;-267         if (R1Type == SEGREG) OpSize=WORD;        
  6130                                  
  6131                                  @@setwflag244:
  6132 00003065 A0[B501]                 mov al, [R1Type]
  6133 00003068 3C04                     cmp al, 4
  6134 0000306A 0F850900                 jne @@setwflag245
  6135 0000306E 66B802000000             mov eax, 2
  6136 00003074 A2[B601]                 mov byte [OpSize], al
  6137                                  
  6138                                  ;-268     }
  6139                                  
  6140                                  @@setwflag245:
  6141                                  
  6142                                  ;-269     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  6143                                  
  6144                                  @@setwflag241:
  6145 00003077 A0[B601]                 mov al, [OpSize]
  6146 0000307A 3C03                     cmp al, 3
  6147 0000307C 0F850C00                 jne @@setwflag246
  6148 00003080 E8FAF5                   call gen66h
  6149 00003083 66B801000000             mov eax, 1
  6150 00003089 A2[B701]                 mov byte [wflag], al
  6151                                  
  6152                                  ;-270     if (OpSize  ==  WORD) wflag=1;
  6153                                  
  6154                                  @@setwflag246:
  6155 0000308C A0[B601]                 mov al, [OpSize]
  6156 0000308F 3C02                     cmp al, 2
  6157 00003091 0F850900                 jne @@setwflag247
  6158 00003095 66B801000000             mov eax, 1
  6159 0000309B A2[B701]                 mov byte [wflag], al
  6160                                  
  6161                                  ;-271 }
  6162                                  
  6163                                  @@setwflag247:
  6164                                  
  6165                                  ;-272 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3     
  6166                                  
  6167 0000309E C3                       ret
  6168                                  ; ENDP
  6169                                  
  6170                                  setsflag:  ; *** PROC ***
  6171                                  
  6172                                  ;-273     sflag=2;  
  6173                                  
  6174 0000309F 66B802000000             mov eax, 2
  6175 000030A5 A2[B901]                 mov byte [sflag], al
  6176                                  
  6177                                  ;-274     if(imme > 127) sflag = 0;
  6178                                  
  6179 000030A8 A1[BE01]                 mov ax, [imme]
  6180 000030AB 83F87F                   cmp ax, 127
  6181 000030AE 0F8E0900                 jle @@setsflag248
  6182 000030B2 66B800000000             mov eax, 0
  6183 000030B8 A2[B901]                 mov byte [sflag], al
  6184                                  
  6185                                  ;-275     if (OpSize == BYTE) {
  6186                                  
  6187                                  @@setsflag248:
  6188 000030BB A0[B601]                 mov al, [OpSize]
  6189 000030BE 3C01                     cmp al, 1
  6190 000030C0 0F851C00                 jne @@setsflag249
  6191                                  
  6192                                  ;-276         if (imme > 255) error1("too big for byte r/m");
  6193                                  
  6194 000030C4 A1[BE01]                 mov ax, [imme]
  6195 000030C7 3DFF00                   cmp ax, 255
  6196 000030CA 0F8E0900                 jle @@setsflag250
  6197 000030CE 68[E130]                 push setsflag_0
  6198 000030D1 E833F0                   call error1
  6199 000030D4 83C402                   add  sp, 2
  6200                                  
  6201                                  ;-277         sflag=0;//byte reg does not need sign extended   
  6202                                  
  6203                                  @@setsflag250:
  6204 000030D7 66B800000000             mov eax, 0
  6205 000030DD A2[B901]                 mov byte [sflag], al
  6206                                  
  6207                                  ;-278     }
  6208                                  
  6209                                  
  6210                                  ;-279 }
  6211                                  
  6212                                  @@setsflag249:
  6213 000030E0 C3                       ret
  6214                                  ; ENDP
  6215 000030E1 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  6216 000030EA 6F7220627974652072-
  6217 000030F3 2F6D00             
  6218                                   
  6219                                  ; missing functions: 
  6220                                  ; digit
  6221                                  ; strcpy
  6222                                  ; eqstr
  6223                                  ; strlen
  6224                                  ; eqstr
  6225                                  ; eqstr
  6226                                  ; eqstr
  6227                                  ; eqstr
  6228                                  ; readRL
  6229                                  ; readRL
  6230                                  ; digit
  6231                                  ; digit
  6232                                  ; strcpy
  6233                                  ; toupper
  6234                                  ; strlen
  6235                                  ; strlen
  6236                                  ; eqstr
  6237                                  ; eqstr
  6238                                  ; eqstr
  6239                                  ; eqstr
  6240                                  ; eqstr
  6241                                  ; eqstr
  6242                                  ; eqstr
  6243                                  ; eqstr
  6244                                  ; eqstr
  6245                                  ; eqstr
  6246                                  ; eqstr
  6247                                  ; eqstr
  6248                                  ; eqstr
  6249                                  ; eqstr
  6250                                  ; eqstr
  6251                                  ; eqstr
  6252                                  ; eqstr
  6253                                  ; eqstr
  6254                                  ; eqstr
  6255                                  ; eqstr
  6256                                  ; eqstr
  6257                                  ; eqstr
  6258                                  ; eqstr
  6259                                  ; eqstr
  6260                                  ; eqstr
  6261                                  ; eqstr
  6262                                  ; eqstr
  6263                                  ; eqstr
  6264                                  ; eqstr
  6265                                  ; eqstr
  6266                                  ; writetty
  6267                                  ; writetty
  6268                                  ; fputcR
  6269                                  ; cputs
  6270                                  ; cputs
  6271                                  ; exitR
  6272                                  ; toupper
  6273                                  ; strcpy
  6274                                  ; strcat1
  6275                                  ; strcpy
  6276                                  ; strcat1
  6277                                  ; strcpy
  6278                                  ; strcat1
  6279                                  ; openR
  6280                                  ; cputs
  6281                                  ; cputs
  6282                                  ; exitR
  6283                                  ; creatR
  6284                                  ; cputs
  6285                                  ; cputs
  6286                                  ; exitR
  6287                                  ; creatR
  6288                                  ; cputs
  6289                                  ; cputs
  6290                                  ; exitR
  6291                                  ; fputcR
  6292                                  ; fcloseR
  6293                                  ; fcloseR
  6294                                  ; fcloseR
  6295                                  ; exitR
  6296                                  ; Number of unresolved CALLs :   76
  6297                                  ;use archive file: AR.C
  6298                                  
  6299                                  ;-280 // AR.C Archive
  6300                                  
  6301                                  ;Number of CALLs:    2 : writetty
  6302                                  
  6303                                  writetty:  ; *** PROC ***
  6304 000030F6 B40E                     mov  ah, 14
  6305 000030F8 BB0000                   mov  bx, 0
  6306 000030FB CD10                     int  16
  6307                                  
  6308                                  ;-281 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  6309                                  
  6310 000030FD C3                       ret
  6311                                  ; ENDP
  6312                                  ;Number of CALLs:    8 : cputs
  6313                                  
  6314                                  cputs:  ; *** PROC ***
  6315                                  ;Function : cputs, Number of local variables: 2
  6316                                  ;   # type sign width line used address name   list of local variables
  6317                                  ;  200 ptr sign byte   281 NULL bp+4    s
  6318                                  ;  201 var sign byte   281 NULL bp-2    c;
  6319 000030FE C8020000                 ENTER  2,0
  6320                                  @@cputs251:
  6321 00003102 8B5E04                   mov bx, [bp+4]
  6322 00003105 8A07                     mov al, [bx]
  6323 00003107 B400                     mov ah, 0
  6324 00003109 08C0                     or  al, al
  6325 0000310B 0F841B00                 je @@cputs252
  6326 0000310F 8B5E04                   mov bx, [bp+4]
  6327 00003112 8A07                     mov al, [bx]
  6328 00003114 B400                     mov ah, 0
  6329 00003116 8846FE                   mov byte [bp-2], al
  6330 00003119 8A46FE                   mov al, byte [bp-2]
  6331 0000311C B400                     mov ah, 0
  6332 0000311E 50                       push ax
  6333 0000311F E8C401                   call putch
  6334 00003122 83C402                   add  sp, 2
  6335 00003125 FF4604                   inc  word [bp+4]
  6336 00003128 EBD8                     jmp @@cputs251
  6337                                  @@cputs252:
  6338                                  
  6339                                  ;-282 int mkneg(int n) { n; __asm {neg ax} }
  6340 0000312A C9                       LEAVE
  6341 0000312B C3                       ret
  6342                                  ; ENDP
  6343                                  ;Number of CALLs:    2 : toupper
  6344                                  
  6345                                  toupper:  ; *** PROC ***
  6346                                  ;Function : toupper, Number of local variables: 1
  6347                                  ;   # type sign width line used address name   list of local variables
  6348                                  ;  200 ptr sign byte   282 NULL bp+4    s;
  6349 0000312C C8000000                 ENTER  0,0
  6350                                  @@toupper253:
  6351 00003130 8B5E04                   mov bx, [bp+4]
  6352 00003133 8A07                     mov al, [bx]
  6353 00003135 B400                     mov ah, 0
  6354 00003137 08C0                     or  al, al
  6355 00003139 0F843000                 je @@toupper254
  6356 0000313D 8B5E04                   mov bx, [bp+4]
  6357 00003140 8A07                     mov al, [bx]
  6358 00003142 B400                     mov ah, 0
  6359 00003144 83F861                   cmp ax, 97 ;unsigned : 1
  6360 00003147 0F8C1D00                 jl  @@toupper255
  6361 0000314B 8B5E04                   mov bx, [bp+4]
  6362 0000314E 8A07                     mov al, [bx]
  6363 00003150 B400                     mov ah, 0
  6364 00003152 83F87A                   cmp ax, 122
  6365 00003155 0F8F0F00                 jg  @@toupper256
  6366 00003159 8B5E04                   mov bx, [bp+4]
  6367 0000315C 8A07                     mov al, [bx]
  6368 0000315E B400                     mov ah, 0
  6369 00003160 83E820                   sub ax, 32
  6370 00003163 8B5E04                   mov  bx, [bp+4]
  6371 00003166 8807                     mov  [bx], al
  6372                                  @@toupper256:
  6373                                  @@toupper255:
  6374 00003168 FF4604                   inc  word [bp+4]
  6375 0000316B EBC3                     jmp @@toupper253
  6376                                  @@toupper254:
  6377                                  
  6378                                  ;-283 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6379                                  
  6380                                  
  6381                                  ;-284 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6382 0000316D C9                       LEAVE
  6383 0000316E C3                       ret
  6384                                  ; ENDP
  6385                                  ;Number of CALLs:    3 : strlen
  6386                                  
  6387                                  strlen:  ; *** PROC ***
  6388                                  ;Function : strlen, Number of local variables: 2
  6389                                  ;   # type sign width line used address name   list of local variables
  6390                                  ;  200 ptr sign byte   284 NULL bp+4    s
  6391                                  ;  201 var sign word   284 NULL bp-2    c;
  6392 0000316F C8020000                 ENTER  2,0
  6393 00003173 66B800000000             mov eax, 0
  6394 00003179 8946FE                   mov word [bp-2], ax
  6395                                  @@strlen257:
  6396 0000317C 8B5E04                   mov bx, [bp+4]
  6397 0000317F 8A07                     mov al, [bx]
  6398 00003181 B400                     mov ah, 0
  6399 00003183 83F800                   cmp ax, 0
  6400 00003186 0F840800                 je  @@strlen258
  6401 0000318A FF4604                   inc  word [bp+4]
  6402 0000318D FF46FE                   inc  word [bp-2]
  6403 00003190 EBEA                     jmp @@strlen257
  6404                                  @@strlen258:
  6405 00003192 8B46FE                   mov ax, [bp-2]
  6406 00003195 E90000                   jmp @@retn
  6407                                  
  6408                                  ;-285 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6409                                  
  6410 00003198 C9                      @@retn: LEAVE
  6411 00003199 C3                       ret
  6412                                  ; ENDP
  6413                                  ;Number of CALLs:    5 : strcpy
  6414                                  
  6415                                  strcpy:  ; *** PROC ***
  6416                                  ;Function : strcpy, Number of local variables: 2
  6417                                  ;   # type sign width line used address name   list of local variables
  6418                                  ;  200 ptr sign byte   285 NULL bp+4    s
  6419                                  ;  201 ptr sign byte   285 NULL bp+6    t;
  6420 0000319A C8000000                 ENTER  0,0
  6421                                  @@strcpy259:
  6422 0000319E 8B5E06                   mov bx, [bp+6]
  6423 000031A1 8A07                     mov al, [bx]
  6424 000031A3 B400                     mov ah, 0
  6425 000031A5 8B5E04                   mov  bx, [bp+4]
  6426 000031A8 8807                     mov  [bx], al
  6427 000031AA FF4604                   inc  word [bp+4]
  6428 000031AD FF4606                   inc  word [bp+6]
  6429                                  
  6430                                  ;-286   while (*t!=0); *s=0; return s; }
  6431                                  
  6432 000031B0 8B5E06                   mov bx, [bp+6]
  6433 000031B3 8A07                     mov al, [bx]
  6434 000031B5 B400                     mov ah, 0
  6435 000031B7 83F800                   cmp ax, 0
  6436 000031BA 0F840200                 je  @@strcpy260
  6437 000031BE EBDE                     jmp @@strcpy259
  6438                                  @@strcpy260:
  6439 000031C0 66B800000000             mov eax, 0
  6440 000031C6 8B5E04                   mov  bx, [bp+4]
  6441 000031C9 8807                     mov  [bx], al
  6442 000031CB 8B4604                   mov ax, [bp+4]
  6443 000031CE E90000                   jmp @@retn
  6444                                  
  6445                                  ;-287 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6446                                  
  6447 000031D1 C9                      @@retn: LEAVE
  6448 000031D2 C3                       ret
  6449                                  ; ENDP
  6450                                  ;Number of CALLs:    3 : digit
  6451                                  
  6452                                  digit:  ; *** PROC ***
  6453                                  ;Function : digit, Number of local variables: 1
  6454                                  ;   # type sign width line used address name   list of local variables
  6455                                  ;  200 var sign byte   287 NULL bp+4    c;
  6456 000031D3 C8000000                 ENTER  0,0
  6457 000031D7 8A4604                   mov al, [bp+4]
  6458 000031DA 3C30                     cmp al, 48
  6459 000031DC 0F8D0900                 jge @@digit261
  6460 000031E0 66B800000000             mov eax, 0
  6461 000031E6 E91B00                   jmp @@retn
  6462                                  @@digit261:
  6463 000031E9 8A4604                   mov al, [bp+4]
  6464 000031EC 3C39                     cmp al, 57
  6465 000031EE 0F8E0900                 jle @@digit262
  6466 000031F2 66B800000000             mov eax, 0
  6467 000031F8 E90900                   jmp @@retn
  6468                                  @@digit262:
  6469 000031FB 66B801000000             mov eax, 1
  6470 00003201 E90000                   jmp @@retn
  6471                                  
  6472                                  ;-288 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6473                                  
  6474 00003204 C9                      @@retn: LEAVE
  6475 00003205 C3                       ret
  6476                                  ; ENDP
  6477                                  ;Number of CALLs:   35 : eqstr
  6478                                  
  6479                                  eqstr:  ; *** PROC ***
  6480                                  ;Function : eqstr, Number of local variables: 2
  6481                                  ;   # type sign width line used address name   list of local variables
  6482                                  ;  200 ptr sign byte   288 NULL bp+4    p
  6483                                  ;  201 ptr sign byte   288 NULL bp+6    q;
  6484 00003206 C8000000                 ENTER  0,0
  6485                                  @@eqstr263:
  6486 0000320A 8B5E04                   mov bx, [bp+4]
  6487 0000320D 8A07                     mov al, [bx]
  6488 0000320F B400                     mov ah, 0
  6489 00003211 08C0                     or  al, al
  6490 00003213 0F842300                 je @@eqstr264
  6491                                  
  6492                                  ;-289     if (*p != *q) return 0; p++; q++; }
  6493                                  
  6494 00003217 8B5E04                   mov bx, [bp+4]
  6495 0000321A 8A07                     mov al, [bx]
  6496 0000321C B400                     mov ah, 0
  6497 0000321E 8B5E06                   mov bx, [bp+6]
  6498 00003221 3A07                     cmp al, [bx]
  6499 00003223 B400                     mov ah, 0
  6500 00003225 0F840900                 je  @@eqstr265
  6501 00003229 66B800000000             mov eax, 0
  6502 0000322F E92700                   jmp @@retn
  6503                                  @@eqstr265:
  6504 00003232 FF4604                   inc  word [bp+4]
  6505 00003235 FF4606                   inc  word [bp+6]
  6506                                  
  6507                                  ;-290     if(*q) return 0; return 1; }
  6508                                  
  6509 00003238 EBD0                     jmp @@eqstr263
  6510                                  @@eqstr264:
  6511 0000323A 8B5E06                   mov bx, [bp+6]
  6512 0000323D 8A07                     mov al, [bx]
  6513 0000323F B400                     mov ah, 0
  6514 00003241 08C0                     or  al, al
  6515 00003243 0F840900                 je @@eqstr266
  6516 00003247 66B800000000             mov eax, 0
  6517 0000324D E90900                   jmp @@retn
  6518                                  @@eqstr266:
  6519 00003250 66B801000000             mov eax, 1
  6520 00003256 E90000                   jmp @@retn
  6521                                  
  6522                                  ;-291 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  6523                                  
  6524 00003259 C9                      @@retn: LEAVE
  6525 0000325A C3                       ret
  6526                                  ; ENDP
  6527                                  ;Number of CALLs:    3 : strcat1
  6528                                  
  6529                                  strcat1:  ; *** PROC ***
  6530                                  ;Function : strcat1, Number of local variables: 2
  6531                                  ;   # type sign width line used address name   list of local variables
  6532                                  ;  200 ptr sign byte   291 NULL bp+4    s
  6533                                  ;  201 ptr sign byte   291 NULL bp+6    t;
  6534 0000325B C8000000                 ENTER  0,0
  6535                                  @@strcat1267:
  6536 0000325F 8B5E04                   mov bx, [bp+4]
  6537 00003262 8A07                     mov al, [bx]
  6538 00003264 B400                     mov ah, 0
  6539 00003266 83F800                   cmp ax, 0
  6540 00003269 0F840500                 je  @@strcat1268
  6541 0000326D FF4604                   inc  word [bp+4]
  6542 00003270 EBED                     jmp @@strcat1267
  6543                                  @@strcat1268:
  6544 00003272 FF7606                   push word [bp+6]
  6545 00003275 FF7604                   push word [bp+4]
  6546 00003278 E81FFF                   call strcpy
  6547 0000327B 83C404                   add  sp, 4
  6548                                  
  6549                                  ;-292 int basename(char *s) { char *p; p=0;
  6550 0000327E C9                       LEAVE
  6551 0000327F C3                       ret
  6552                                  ; ENDP
  6553                                  ;Number of CALLs:    1 : openR
  6554                                  
  6555                                  openR:  ; *** PROC ***
  6556                                  ;Function : openR, Number of local variables: 1
  6557                                  ;   # type sign width line used address name   list of local variables
  6558                                  ;  200 ptr sign byte   292 NULL bp+4    s;
  6559 00003280 C8000000                 ENTER  0,0
  6560 00003284 8B5604                   mov  dx, [bp+4]
  6561 00003287 B8023D                   mov  ax, 15618
  6562 0000328A E87200                   call DosInt
  6563                                  
  6564                                  ;-293 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  6565 0000328D C9                       LEAVE
  6566 0000328E C3                       ret
  6567                                  ; ENDP
  6568                                  ;Number of CALLs:    2 : creatR
  6569                                  
  6570                                  creatR:  ; *** PROC ***
  6571                                  ;Function : creatR, Number of local variables: 1
  6572                                  ;   # type sign width line used address name   list of local variables
  6573                                  ;  200 ptr sign byte   293 NULL bp+4    s;
  6574 0000328F C8000000                 ENTER  0,0
  6575 00003293 8B5604                   mov  dx, [bp+4]
  6576 00003296 B90000                   mov  cx, 0
  6577 00003299 B8003C                   mov  ax, 15360
  6578 0000329C E86000                   call DosInt
  6579                                  
  6580                                  ;-294 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  6581 0000329F C9                       LEAVE
  6582 000032A0 C3                       ret
  6583                                  ; ENDP
  6584                                  ;Number of CALLs:    2 : readRL
  6585                                  
  6586                                  readRL:  ; *** PROC ***
  6587                                  ;Function : readRL, Number of local variables: 3
  6588                                  ;   # type sign width line used address name   list of local variables
  6589                                  ;  200 ptr sign byte   294 NULL bp+4    s
  6590                                  ;  201 var sign word   294 NULL bp+6    fd
  6591                                  ;  202 var sign word   294 NULL bp+8    len;
  6592 000032A1 C8000000                 ENTER  0,0
  6593 000032A5 8B5604                   mov  dx, [bp+4]
  6594 000032A8 8B4E08                   mov  cx, [bp+8]
  6595 000032AB 8B5E06                   mov  bx, [bp+6]
  6596 000032AE B8003F                   mov  ax, 16128
  6597 000032B1 E84B00                   call DosInt
  6598                                  
  6599                                  ;-295 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  6600 000032B4 C9                       LEAVE
  6601 000032B5 C3                       ret
  6602                                  ; ENDP
  6603                                  ;Number of CALLs:    2 : fputcR
  6604                                  
  6605                                  fputcR:  ; *** PROC ***
  6606                                  ;Function : fputcR, Number of local variables: 2
  6607                                  ;   # type sign width line used address name   list of local variables
  6608                                  ;  200 ptr sign byte   295 NULL bp+4    n
  6609                                  ;  201 var sign word   295 NULL bp+6    fd;
  6610 000032B6 C8000000                 ENTER  0,0
  6611 000032BA 8D5604                  lea dx, [bp+4]
  6612                                  
  6613                                  ;-296   cx=1; bx=fd; ax=0x4000; DosInt(); }
  6614                                  
  6615 000032BD B90100                   mov  cx, 1
  6616 000032C0 8B5E06                   mov  bx, [bp+6]
  6617 000032C3 B80040                   mov  ax, 16384
  6618 000032C6 E83600                   call DosInt
  6619                                  
  6620                                  ;-297 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  6621 000032C9 C9                       LEAVE
  6622 000032CA C3                       ret
  6623                                  ; ENDP
  6624                                  ;Number of CALLs:    3 : fcloseR
  6625                                  
  6626                                  fcloseR:  ; *** PROC ***
  6627                                  ;Function : fcloseR, Number of local variables: 1
  6628                                  ;   # type sign width line used address name   list of local variables
  6629                                  ;  200 var sign word   297 NULL bp+4    fd;
  6630 000032CB C8000000                 ENTER  0,0
  6631 000032CF 8B5E04                   mov  bx, [bp+4]
  6632 000032D2 B8003E                   mov  ax, 15872
  6633 000032D5 CD21                     int  33
  6634                                  
  6635                                  ;-298 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  6636 000032D7 C9                       LEAVE
  6637 000032D8 C3                       ret
  6638                                  ; ENDP
  6639                                  ;Number of CALLs:    5 : exitR
  6640                                  
  6641                                  exitR:  ; *** PROC ***
  6642                                  ;Function : exitR, Number of local variables: 1
  6643                                  ;   # type sign width line used address name   list of local variables
  6644                                  ;  200 var sign byte   298 NULL bp+4    c;
  6645 000032D9 C8000000                 ENTER  0,0
  6646 000032DD B44C                     mov  ah, 76
  6647 000032DF 8A4604                   mov  al, [bp+4]
  6648 000032E2 CD21                     int  33
  6649                                  
  6650                                  ;-299 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  6651 000032E4 C9                       LEAVE
  6652 000032E5 C3                       ret
  6653                                  ; ENDP
  6654                                  ;End of archive file. 
  6655                                   
  6656                                  ; missing functions: 
  6657                                  ; putch
  6658                                  ; DosInt
  6659                                  ; DosInt
  6660                                  ; DosInt
  6661                                  ; DosInt
  6662                                  ; Number of unresolved CALLs :    5
  6663                                  ;use archive file: AR.C
  6664                                  
  6665                                  ;-300 // AR.C Archive
  6666                                  
  6667                                  ;Number of CALLs:    1 : putch
  6668                                  
  6669                                  putch:  ; *** PROC ***
  6670                                  ;Function : putch, Number of local variables: 1
  6671                                  ;   # type sign width line used address name   list of local variables
  6672                                  ;  200 var sign byte   300 NULL bp+4    c;
  6673 000032E6 C8000000                 ENTER  0,0
  6674 000032EA 807E040A                cmp byte [bp+4], 10
  6675 000032EE 0F850500                 jne @@putch269
  6676 000032F2 B00D                     mov  al, 13
  6677 000032F4 E8FFFD                   call writetty
  6678                                  @@putch269:
  6679 000032F7 8A4604                   mov  al, [bp+4]
  6680 000032FA E8F9FD                   call writetty
  6681                                  
  6682                                  ;-301 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  6683 000032FD C9                       LEAVE
  6684 000032FE C3                       ret
  6685                                  ; ENDP
  6686                                  ;Number of CALLs:    4 : DosInt
  6687                                  
  6688                                  DosInt:  ; *** PROC ***
  6689 000032FF CD21                     int  33
  6690 00003301 7304                     jae short @@DosInt270
  6691 00003303 FF06[9F01]               inc  word [DOS_ERR]
  6692                                  @@DosInt270:
  6693                                  
  6694                                  ;-302 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  6695                                  
  6696 00003307 C3                       ret
  6697                                  ; ENDP
  6698                                  ;End of archive file. 
  6699                                   
  6700                                  ; missing functions:  All FUNCTIONs in place
  6701 00003308 E80000                  LastFunctionByt:db 0E8h, 0, 0
  6702 0000330B 58                      pop ax
  6703 0000330C C3                      ret
  6704                                   
  6705                                  ;   # type sign width line used  address name   list of global variables
  6706                                  
  6707                                  ;    1 arr sign byte     1    2        0 Version1[10]
  6708                                  ;    2 var sign byte     1    3        0 LIST
  6709                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  6710                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  6711                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  6712                                  ;    6 var unsg word     5   12        0 SymbolInt
  6713                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  6714                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  6715                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  6716                                  ;   10 arr sign byte     9    5        0 namein[67]
  6717                                  ;   11 arr sign byte    10    5        0 namelst[67]
  6718                                  ;   12 arr sign byte    11    5        0 namebin[67]
  6719                                  ;   13 var sign word    12    4        0 asm_fd
  6720                                  ;   14 var sign word    13    3        0 lst_fd
  6721                                  ;   15 var sign word    14    3        0 bin_fd
  6722                                  ;   16 var sign word    15    6        0 DOS_ERR
  6723                                  ;   17 var sign word    16    4        0 ErrorCount
  6724                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  6725                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  6726                                  ;   20 var unsg word    20    5        0 PC
  6727                                  ;   21 var unsg word    21    2        0 PCStart
  6728                                  ;   22 var sign byte    22    3        0 isLabel
  6729                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  6730                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  6731                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  6732                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  6733                                  ;   27 var sign byte    27   21        0 TokeType
  6734                                  ;   28 def unsg byte    28    -        0 BYTE=1
  6735                                  ;   29 def unsg byte    29    -        0 WORD=2
  6736                                  ;   30 def unsg byte    30    -        0 DWORD=3
  6737                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  6738                                  ;   32 def unsg byte    32    -        0 IMM=1
  6739                                  ;   33 def unsg byte    33    -        0 REG=2
  6740                                  ;   34 def unsg byte    34    -        0 ADR=3
  6741                                  ;   35 def unsg byte    35    -        0 MEM=4
  6742                                  ;   36 var sign byte    36   18        0 Op
  6743                                  ;   37 var sign byte    37   23        0 Op2
  6744                                  ;   38 var sign byte    38   14        0 CodeType
  6745                                  ;   39 var sign byte    39    9        0 Code1
  6746                                  ;   40 var sign byte    40    6        0 Code2
  6747                                  ;   41 var sign byte    41    2        0 Code3
  6748                                  ;   42 var sign byte    42   14        0 R2No
  6749                                  ;   43 var sign byte    43   10        0 R1No
  6750                                  ;   44 var sign byte    44   17        0 R2Type
  6751                                  ;   45 var sign byte    45    9        0 R1Type
  6752                                  ;   46 var sign byte    46   14        0 OpSize
  6753                                  ;   47 var sign byte    47    7        0 wflag
  6754                                  ;   48 var sign byte    48    3        0 dflag
  6755                                  ;   49 var sign byte    49    6        0 sflag
  6756                                  ;   50 var sign byte    50   14        0 rm
  6757                                  ;   51 var sign byte    51    3        0 isDirect
  6758                                  ;   52 var sign word    52   15        0 disp
  6759                                  ;   53 var unsg word    53    8        0 imme
  6760                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  6761                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  6762                                  ;   56 var sign word    57    6        0 OpPrintIndex
  6763                                  ;   57 ptr sign byte    58   17        0 OpCodePtr
  6764                                  ;   58 var sign byte    59    2        0 PrintR
  6765                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  6766                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  6767                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  6768                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  6769                                  ;   63 arr unsg word    65    3        0 LabelAddr[100]
  6770                                  ;   64 var sign word    66    4        0 LabelMaxIx
  6771                                  ;   65 var sign word    67    4        0 LabelIx
  6772                                  ;   66 def unsg byte    69    -        0 FILEBINMAX=2000
  6773                                  ;   67 arr sign byte    70    2        0 FileBin[2000]
  6774                                  ;   68 var unsg word    71    5        0 BinLen
  6775                                  ;   69 ptr sign byte    73    1        0 arglen
  6776                                  ;   70 ptr sign byte    74    4        0 argv
  6777                                  ;   71 var sign byte     1    1        0 I_START
  6778                                  ;   72 arr sign byte     4 NULL        0 I_PUSHA[9]
  6779                                  ;   73 arr sign byte     5 NULL        0 I_POPA[8]
  6780                                  ;   74 arr sign byte     6 NULL        0 I_NOP[7]
  6781                                  ;   75 arr sign byte     7 NULL        0 I_CBW[7]
  6782                                  ;   76 arr sign byte     8 NULL        0 I_CWDE[8]
  6783                                  ;   77 arr sign byte     9 NULL        0 I_CWD[7]
  6784                                  ;   78 arr sign byte    10 NULL        0 I_CDQ[7]
  6785                                  ;   79 arr sign byte    11 NULL        0 I_WAIT[8]
  6786                                  ;   80 arr sign byte    12 NULL        0 I_PUSHF[9]
  6787                                  ;   81 arr sign byte    13 NULL        0 I_POPF[8]
  6788                                  ;   82 arr sign byte    14 NULL        0 I_SAHF[8]
  6789                                  ;   83 arr sign byte    15 NULL        0 I_LAHF[8]
  6790                                  ;   84 arr sign byte    16 NULL        0 I_MOVSB[9]
  6791                                  ;   85 arr sign byte    17 NULL        0 I_MOVSW[9]
  6792                                  ;   86 arr sign byte    18 NULL        0 I_CMPSB[9]
  6793                                  ;   87 arr sign byte    19 NULL        0 I_CMPSW[9]
  6794                                  ;   88 arr sign byte    20 NULL        0 I_STOSB[9]
  6795                                  ;   89 arr sign byte    21 NULL        0 I_STOSW[9]
  6796                                  ;   90 arr sign byte    22 NULL        0 I_LODSB[9]
  6797                                  ;   91 arr sign byte    23 NULL        0 I_LODSW[9]
  6798                                  ;   92 arr sign byte    24 NULL        0 I_SCASB[9]
  6799                                  ;   93 arr sign byte    25 NULL        0 I_SCASW[9]
  6800                                  ;   94 arr sign byte    26 NULL        0 I_LEAVE[9]
  6801                                  ;   95 arr sign byte    27 NULL        0 I_IRET[8]
  6802                                  ;   96 arr sign byte    28 NULL        0 I_XLAT[8]
  6803                                  ;   97 arr sign byte    29 NULL        0 I_LOCK[8]
  6804                                  ;   98 arr sign byte    30 NULL        0 I_REPNE[9]
  6805                                  ;   99 arr sign byte    31 NULL        0 I_REPNZ[9]
  6806                                  ;  100 arr sign byte    32 NULL        0 I_REPE[8]
  6807                                  ;  101 arr sign byte    33 NULL        0 I_REPZ[8]
  6808                                  ;  102 arr sign byte    34 NULL        0 I_HLT[7]
  6809                                  ;  103 arr sign byte    35 NULL        0 I_CLC[7]
  6810                                  ;  104 arr sign byte    36 NULL        0 I_STC[7]
  6811                                  ;  105 arr sign byte    37 NULL        0 I_CLI[7]
  6812                                  ;  106 arr sign byte    38 NULL        0 I_STI[7]
  6813                                  ;  107 arr sign byte    39 NULL        0 I_CLD[7]
  6814                                  ;  108 arr sign byte    40 NULL        0 I_STD[7]
  6815                                  ;  109 arr sign byte    42 NULL        0 I_INC[9]
  6816                                  ;  110 arr sign byte    43 NULL        0 I_DEC[9]
  6817                                  ;  111 arr sign byte    44 NULL        0 I_NOT[8]
  6818                                  ;  112 arr sign byte    45 NULL        0 I_NEG[8]
  6819                                  ;  113 arr sign byte    46 NULL        0 I_MUL[8]
  6820                                  ;  114 arr sign byte    47 NULL        0 I_IMUL[9]
  6821                                  ;  115 arr sign byte    48 NULL        0 I_DIV[8]
  6822                                  ;  116 arr sign byte    49 NULL        0 I_IDIV[9]
  6823                                  ;  117 arr sign byte    51 NULL        0 I_LES[7]
  6824                                  ;  118 arr sign byte    52 NULL        0 I_LDS[7]
  6825                                  ;  119 arr sign byte    53 NULL        0 I_LEA[7]
  6826                                  ;  120 arr sign byte    54 NULL        0 I_LSS[8]
  6827                                  ;  121 arr sign byte    55 NULL        0 I_LFS[8]
  6828                                  ;  122 arr sign byte    56 NULL        0 I_LGS[8]
  6829                                  ;  123 arr sign byte    58 NULL        0 I_ADD[7]
  6830                                  ;  124 arr sign byte    59 NULL        0 I_OR[6]
  6831                                  ;  125 arr sign byte    60 NULL        0 I_ADC[7]
  6832                                  ;  126 arr sign byte    61 NULL        0 I_SBB[7]
  6833                                  ;  127 arr sign byte    62 NULL        0 I_AND[7]
  6834                                  ;  128 arr sign byte    63 NULL        0 I_SUB[7]
  6835                                  ;  129 arr sign byte    64 NULL        0 I_XOR[7]
  6836                                  ;  130 arr sign byte    65 NULL        0 I_CMP[7]
  6837                                  ;  131 arr sign byte    66 NULL        0 I_TEST[11]
  6838                                  ;  132 arr sign byte    68 NULL        0 I_MOV[6]
  6839                                  ;  133 arr sign byte    69 NULL        0 I_MOVSX[9]
  6840                                  ;  134 arr sign byte    70 NULL        0 I_MOVZX[9]
  6841                                  ;  135 arr sign byte    72 NULL        0 I_JO[6]
  6842                                  ;  136 arr sign byte    73 NULL        0 I_JNO[7]
  6843                                  ;  137 arr sign byte    74 NULL        0 I_JB[6]
  6844                                  ;  138 arr sign byte    75 NULL        0 I_JC[6]
  6845                                  ;  139 arr sign byte    76 NULL        0 I_JNB[7]
  6846                                  ;  140 arr sign byte    77 NULL        0 I_JAE[7]
  6847                                  ;  141 arr sign byte    78 NULL        0 I_JNC[7]
  6848                                  ;  142 arr sign byte    79 NULL        0 I_JE[6]
  6849                                  ;  143 arr sign byte    80 NULL        0 I_JZ[6]
  6850                                  ;  144 arr sign byte    81 NULL        0 I_JNE[7]
  6851                                  ;  145 arr sign byte    82 NULL        0 I_JNZ[7]
  6852                                  ;  146 arr sign byte    83 NULL        0 I_JBE[7]
  6853                                  ;  147 arr sign byte    84 NULL        0 I_JNA[7]
  6854                                  ;  148 arr sign byte    85 NULL        0 I_JA[6]
  6855                                  ;  149 arr sign byte    86 NULL        0 I_JS[6]
  6856                                  ;  150 arr sign byte    87 NULL        0 I_JNS[7]
  6857                                  ;  151 arr sign byte    88 NULL        0 I_JP[6]
  6858                                  ;  152 arr sign byte    89 NULL        0 I_JPE[7]
  6859                                  ;  153 arr sign byte    90 NULL        0 I_JNP[7]
  6860                                  ;  154 arr sign byte    91 NULL        0 I_JPO[7]
  6861                                  ;  155 arr sign byte    92 NULL        0 I_JL[6]
  6862                                  ;  156 arr sign byte    93 NULL        0 I_JNL[7]
  6863                                  ;  157 arr sign byte    94 NULL        0 I_JGE[7]
  6864                                  ;  158 arr sign byte    95 NULL        0 I_JLE[7]
  6865                                  ;  159 arr sign byte    96 NULL        0 I_JNG[7]
  6866                                  ;  160 arr sign byte    97 NULL        0 I_JG[6]
  6867                                  ;  161 arr sign byte    99 NULL        0 I_JMP[8]
  6868                                  ;  162 arr sign byte   100 NULL        0 I_CALL[9]
  6869                                  ;  163 arr sign byte   102 NULL        0 I_RET[8]
  6870                                  ;  164 arr sign byte   103 NULL        0 I_RETF[9]
  6871                                  ;  165 arr sign byte   105 NULL        0 I_PUSH[8]
  6872                                  ;  166 arr sign byte   106 NULL        0 I_POP[7]
  6873                                  ;  167 arr sign byte   108 NULL        0 I_ROL[7]
  6874                                  ;  168 arr sign byte   109 NULL        0 I_ROR[7]
  6875                                  ;  169 arr sign byte   110 NULL        0 I_RCL[7]
  6876                                  ;  170 arr sign byte   111 NULL        0 I_RCR[7]
  6877                                  ;  171 arr sign byte   112 NULL        0 I_SHL[7]
  6878                                  ;  172 arr sign byte   113 NULL        0 I_SAL[7]
  6879                                  ;  173 arr sign byte   114 NULL        0 I_SHR[7]
  6880                                  ;  174 arr sign byte   115 NULL        0 I_SAR[7]
  6881                                  ;  175 arr sign byte   117 NULL        0 I_INT[8]
  6882                                  ;  176 arr sign byte   118 NULL        0 I_INTO[8]
  6883                                  ;  177 arr sign byte   129 NULL        0 I_XCHG[9]
  6884                                  ;  178 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6885                                  ;  179 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6886                                  ;  180 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6887                                  ;  181 arr sign byte   134 NULL        0 I_LOOPE[9]
  6888                                  ;  182 arr sign byte   135 NULL        0 I_LOOP[8]
  6889                                  ;  183 arr sign byte   136 NULL        0 I_JCXZ[8]
  6890                                  ;  184 arr sign byte   137 NULL        0 I_JECXZ[9]
  6891                                  ;  185 arr sign byte   139 NULL        0 I_ENTER[9]
  6892                                  ;  186 arr sign byte   141 NULL        0 I_ORG[6]
  6893                                  ;  187 arr sign byte   146 NULL        0 I_DB[5]
  6894                                  ;  188 arr sign byte   147 NULL        0 I_DW[5]
  6895                                  ;  189 arr sign byte   148 NULL        0 I_DD[5]
  6896                                  ;  190 arr sign byte   149 NULL        0 I_RESB[7]
  6897                                  ;  191 arr sign byte   150 NULL        0 I_RESW[7]
  6898                                  ;  192 arr sign byte   151 NULL        0 I_RESD[7]
  6899                                  ;  193 var sign byte   152 NULL        0 I_END
  6900                                  
  6901                                  
  6902                                  ;   # Calls Line Width  Name   list of functions
  6903                                  
  6904                                  ;    0    1    1 word   parse
  6905                                  ;    1   14   27 word   getTokeType
  6906                                  ;    2    2   36 word   storeLabel
  6907                                  ;    3    2   46 word   searchLabel
  6908                                  ;    4    1   57 word   getVariable
  6909                                  ;    5    2   86 word   lookCode
  6910                                  ;    6    1  101 word   getCodeSize
  6911                                  ;    7    8  108 word   isToken
  6912                                  ;    8    1  113 word   need
  6913                                  ;    9    1  123 word   skipRest
  6914                                  ;   10    1    1 word   getLine
  6915                                  ;   11    1   17 word   ifEOL
  6916                                  ;   12    3   24 word   skipBlank
  6917                                  ;   13    2   29 word   letterE
  6918                                  ;   14    1   39 word   alnumE
  6919                                  ;   15    1   44 word   getDigit
  6920                                  ;   16    1   56 word   getName
  6921                                  ;   17    1   75 word   testReg
  6922                                  ;   18    1    1 word   printLine
  6923                                  ;   19    7   22 word   prc
  6924                                  ;   20    1   34 word   prscomment
  6925                                  ;   21   21   42 word   prs
  6926                                  ;   22    3   64 word   printhex8a
  6927                                  ;   23    2   69 word   printhex4
  6928                                  ;   24    1   74 word   printhex16
  6929                                  ;   25    3   79 word   printIntU
  6930                                  ;   26   25   90 word   error1
  6931                                  ;   27   12   98 word   errorexit
  6932                                  ;   28 NULL  102 word   allowederror
  6933                                  ;   29    3  103 word   addrerror
  6934                                  ;   30    1  104 word   immeerror
  6935                                  ;   31    2  105 word   implerror
  6936                                  ;   32    4  106 word   indexerror
  6937                                  ;   33    2  107 word   invaloperror
  6938                                  ;   34    1  108 word   numbererror
  6939                                  ;   35    1  109 word   regmemerror
  6940                                  ;   36    2  110 word   reg16error
  6941                                  ;   37    1  111 word   segregerror
  6942                                  ;   38    3  112 word   syntaxerror
  6943                                  ;   39 NULL  114 word   addrexit
  6944                                  ;   40 NULL  115 word   internexit
  6945                                  ;   41 NULL    1 word   main
  6946                                  ;   42    1    8 word   getarg
  6947                                  ;   43    1   38 word   epilog
  6948                                  ;   44    2   67 word   end1
  6949                                  ;   45    1    2 word   getCodes
  6950                                  ;   46    1    7 word   gen66h
  6951                                  ;   47    3    9 word   genCode2
  6952                                  ;   48    6   13 word   genCodeW
  6953                                  ;   49   16   17 word   genCode8
  6954                                  ;   50    4   28 word   genCode16
  6955                                  ;   51    7   32 word   writeEA
  6956                                  ;   52    1   74 word   genImmediateSE
  6957                                  ;   53    4   78 word   genImmediate
  6958                                  ;   54    1   10 word   process
  6959                                  ;   55    1  150 word   ChangeDirection
  6960                                  ;   56    1  158 word   checkOpL
  6961                                  ;   57    3  171 word   check2Ops
  6962                                  ;   58    1  180 word   get2Ops
  6963                                  ;   59    2  186 word   getOpL
  6964                                  ;   60    2  195 word   getOpR
  6965                                  ;   61    2  205 word   getOp1
  6966                                  ;   62    1  221 word   getMEM
  6967                                  ;   63    1  243 word   getIndReg1
  6968                                  ;   64    1  251 word   getIndReg2
  6969                                  ;   65    2  261 word   setwflag
  6970                                  ;   66    1  272 word   setsflag
  6971                                  ;   67    4  280 word   writetty
  6972                                  ;   68    8  281 word   cputs
  6973                                  ;   69    2  282 word   toupper
  6974                                  ;   70    3  284 word   strlen
  6975                                  ;   71    6  285 word   strcpy
  6976                                  ;   72    3  287 word   digit
  6977                                  ;   73   35  288 word   eqstr
  6978                                  ;   74    3  291 word   strcat1
  6979                                  ;   75    1  292 word   openR
  6980                                  ;   76    2  293 word   creatR
  6981                                  ;   77    2  294 word   readRL
  6982                                  ;   78    2  295 word   fputcR
  6983                                  ;   79    3  297 word   fcloseR
  6984                                  ;   80    5  298 word   exitR
  6985                                  ;   81    1  300 word   putch
  6986                                  ;   82    4  301 word   DosInt
  6987                                  ;   83 NULL  302 word   LastFunctionByt
  6988                                  
  6989                                  ;    #  addr name   list of CALLs
  6990                                  
  6991                                  ;    0  1339 getLine
  6992                                  ;    1  1347 getTokeType
  6993                                  ;    2  1359 storeLabel
  6994                                  ;    3  1370 getTokeType
  6995                                  ;    4  1382 lookCode
  6996                                  ;    5  1391 process
  6997                                  ;    6  1399 getVariable
  6998                                  ;    7  1411 skipRest
  6999                                  ;    8  1420 error1
  7000                                  ;    9  1427 error1
  7001                                  ;   10  1434 printLine
  7002                                  ;   11  1458 skipBlank
  7003                                  ;   12  1468 digit
  7004                                  ;   13  1474 getDigit
  7005                                  ;   14  1483 letterE
  7006                                  ;   15  1491 getName
  7007                                  ;   16  1512 searchLabel
  7008                                  ;   17  1524 error1
  7009                                  ;   18  1531 strcpy
  7010                                  ;   19  1538 errorexit
  7011                                  ;   20  1548 errorexit
  7012                                  ;   21  1578 eqstr
  7013                                  ;   22  1584 strlen
  7014                                  ;   23  1605 storeLabel
  7015                                  ;   24  1616 getTokeType
  7016                                  ;   25  1628 lookCode
  7017                                  ;   26  1637 errorexit
  7018                                  ;   27  1647 errorexit
  7019                                  ;   28  1657 getTokeType
  7020                                  ;   29  1669 genCode8
  7021                                  ;   30  1678 skipBlank
  7022                                  ;   31  1688 isToken
  7023                                  ;   32  1696 genCode8
  7024                                  ;   33  1705 isToken
  7025                                  ;   34  1713 getTokeType
  7026                                  ;   35  1725 genCode16
  7027                                  ;   36  1735 isToken
  7028                                  ;   37  1743 errorexit
  7029                                  ;   38  1762 eqstr
  7030                                  ;   39  1780 eqstr
  7031                                  ;   40  1786 getTokeType
  7032                                  ;   41  1798 eqstr
  7033                                  ;   42  1804 getTokeType
  7034                                  ;   43  1816 eqstr
  7035                                  ;   44  1822 getTokeType
  7036                                  ;   45  1844 skipBlank
  7037                                  ;   46  1861 isToken
  7038                                  ;   47  1869 getTokeType
  7039                                  ;   48  1881 error1
  7040                                  ;   49  1888 prs
  7041                                  ;   50  1892 prc
  7042                                  ;   51  1905 getTokeType
  7043                                  ;   52  1917 error1
  7044                                  ;   53  1934 readRL
  7045                                  ;   54  1941 errorexit
  7046                                  ;   55  1951 errorexit
  7047                                  ;   56  1961 ifEOL
  7048                                  ;   57  1975 readRL
  7049                                  ;   58  2011 digit
  7050                                  ;   59  2017 letterE
  7051                                  ;   60  2044 digit
  7052                                  ;   61  2064 alnumE
  7053                                  ;   62  2071 errorexit
  7054                                  ;   63  2081 strcpy
  7055                                  ;   64  2088 toupper
  7056                                  ;   65  2104 strlen
  7057                                  ;   66  2111 strlen
  7058                                  ;   67  2118 eqstr
  7059                                  ;   68  2124 eqstr
  7060                                  ;   69  2130 eqstr
  7061                                  ;   70  2136 eqstr
  7062                                  ;   71  2142 eqstr
  7063                                  ;   72  2148 eqstr
  7064                                  ;   73  2154 eqstr
  7065                                  ;   74  2160 eqstr
  7066                                  ;   75  2166 eqstr
  7067                                  ;   76  2172 eqstr
  7068                                  ;   77  2178 eqstr
  7069                                  ;   78  2184 eqstr
  7070                                  ;   79  2190 eqstr
  7071                                  ;   80  2196 eqstr
  7072                                  ;   81  2202 eqstr
  7073                                  ;   82  2208 eqstr
  7074                                  ;   83  2214 eqstr
  7075                                  ;   84  2220 eqstr
  7076                                  ;   85  2226 eqstr
  7077                                  ;   86  2232 eqstr
  7078                                  ;   87  2238 eqstr
  7079                                  ;   88  2244 eqstr
  7080                                  ;   89  2250 eqstr
  7081                                  ;   90  2256 eqstr
  7082                                  ;   91  2262 eqstr
  7083                                  ;   92  2268 eqstr
  7084                                  ;   93  2274 eqstr
  7085                                  ;   94  2280 eqstr
  7086                                  ;   95  2286 eqstr
  7087                                  ;   96  2292 eqstr
  7088                                  ;   97  2312 prs
  7089                                  ;   98  2316 printhex16
  7090                                  ;   99  2327 prs
  7091                                  ;  100  2331 prc
  7092                                  ;  101  2335 printhex8a
  7093                                  ;  102  2346 prc
  7094                                  ;  103  2350 prs
  7095                                  ;  104  2354 prscomment
  7096                                  ;  105  2371 writetty
  7097                                  ;  106  2380 writetty
  7098                                  ;  107  2389 fputcR
  7099                                  ;  108  2411 prc
  7100                                  ;  109  2427 prc
  7101                                  ;  110  2448 printhex4
  7102                                  ;  111  2458 printhex4
  7103                                  ;  112  2480 prc
  7104                                  ;  113  2502 printhex8a
  7105                                  ;  114  2513 printhex8a
  7106                                  ;  115  2538 printIntU
  7107                                  ;  116  2548 prc
  7108                                  ;  117  2561 prs
  7109                                  ;  118  2565 prs
  7110                                  ;  119  2569 prs
  7111                                  ;  120  2573 prs
  7112                                  ;  121  2589 error1
  7113                                  ;  122  2596 end1
  7114                                  ;  123  2614 error1
  7115                                  ;  124  2631 error1
  7116                                  ;  125  2648 error1
  7117                                  ;  126  2665 error1
  7118                                  ;  127  2683 error1
  7119                                  ;  128  2703 error1
  7120                                  ;  129  2722 error1
  7121                                  ;  130  2741 error1
  7122                                  ;  131  2759 error1
  7123                                  ;  132  2778 error1
  7124                                  ;  133  2797 error1
  7125                                  ;  134  2813 errorexit
  7126                                  ;  135  2834 errorexit
  7127                                  ;  136  2849 getarg
  7128                                  ;  137  2856 parse
  7129                                  ;  138  2862 epilog
  7130                                  ;  139  2869 end1
  7131                                  ;  140  2893 cputs
  7132                                  ;  141  2899 cputs
  7133                                  ;  142  2905 exitR
  7134                                  ;  143  2911 toupper
  7135                                  ;  144  2919 strcpy
  7136                                  ;  145  2926 strcat1
  7137                                  ;  146  2934 strcpy
  7138                                  ;  147  2941 strcat1
  7139                                  ;  148  2949 strcpy
  7140                                  ;  149  2956 strcat1
  7141                                  ;  150  2964 openR
  7142                                  ;  151  2970 cputs
  7143                                  ;  152  2976 cputs
  7144                                  ;  153  2982 exitR
  7145                                  ;  154  2988 creatR
  7146                                  ;  155  2995 cputs
  7147                                  ;  156  3001 cputs
  7148                                  ;  157  3007 exitR
  7149                                  ;  158  3013 creatR
  7150                                  ;  159  3020 cputs
  7151                                  ;  160  3026 cputs
  7152                                  ;  161  3032 exitR
  7153                                  ;  162  3038 prs
  7154                                  ;  163  3042 prs
  7155                                  ;  164  3046 prs
  7156                                  ;  165  3050 prs
  7157                                  ;  166  3054 prs
  7158                                  ;  167  3058 prs
  7159                                  ;  168  3062 prs
  7160                                  ;  169  3066 prs
  7161                                  ;  170  3070 prs
  7162                                  ;  171  3087 prs
  7163                                  ;  172  3091 printIntU
  7164                                  ;  173  3101 prs
  7165                                  ;  174  3105 prs
  7166                                  ;  175  3109 printIntU
  7167                                  ;  176  3119 prs
  7168                                  ;  177  3123 fputcR
  7169                                  ;  178  3137 fcloseR
  7170                                  ;  179  3145 fcloseR
  7171                                  ;  180  3153 fcloseR
  7172                                  ;  181  3161 exitR
  7173                                  ;  182  3183 genCode8
  7174                                  ;  183  3205 genCode8
  7175                                  ;  184  3225 genCode8
  7176                                  ;  185  3245 errorexit
  7177                                  ;  186  3267 genCode8
  7178                                  ;  187  3276 genCode8
  7179                                  ;  188  3301 genCode8
  7180                                  ;  189  3310 genCode8
  7181                                  ;  190  3319 genCode16
  7182                                  ;  191  3344 genCode8
  7183                                  ;  192  3353 genImmediate
  7184                                  ;  193  3379 genCode16
  7185                                  ;  194  3389 genCode8
  7186                                  ;  195  3408 getTokeType
  7187                                  ;  196  3420 getCodeSize
  7188                                  ;  197  3432 getCodes
  7189                                  ;  198  3441 genCode8
  7190                                  ;  199  3450 getOpL
  7191                                  ;  200  3457 checkOpL
  7192                                  ;  201  3466 genCode2
  7193                                  ;  202  3475 getTokeType
  7194                                  ;  203  3487 implerror
  7195                                  ;  204  3497 genCodeW
  7196                                  ;  205  3506 writeEA
  7197                                  ;  206  3514 check2Ops
  7198                                  ;  207  3524 reg16error
  7199                                  ;  208  3535 addrerror
  7200                                  ;  209  3545 genCode8
  7201                                  ;  210  3554 genCode8
  7202                                  ;  211  3563 writeEA
  7203                                  ;  212  3571 check2Ops
  7204                                  ;  213  3581 setsflag
  7205                                  ;  214  3590 genCodeW
  7206                                  ;  215  3599 genImmediate
  7207                                  ;  216  3612 genCodeW
  7208                                  ;  217  3621 writeEA
  7209                                  ;  218  3629 genImmediateSE
  7210                                  ;  219  3644 genCodeW
  7211                                  ;  220  3653 writeEA
  7212                                  ;  221  3661 genCodeW
  7213                                  ;  222  3670 writeEA
  7214                                  ;  223  3678 syntaxerror
  7215                                  ;  224  3690 check2Ops
  7216                                  ;  225  3700 genCode2
  7217                                  ;  226  3709 genImmediate
  7218                                  ;  227  3722 genCodeW
  7219                                  ;  228  3731 writeEA
  7220                                  ;  229  3739 genImmediate
  7221                                  ;  230  3752 regmemerror
  7222                                  ;  231  3764 ChangeDirection
  7223                                  ;  232  3780 reg16error
  7224                                  ;  233  3791 genCode2
  7225                                  ;  234  3800 writeEA
  7226                                  ;  235  3808 syntaxerror
  7227                                  ;  236  3820 genCode8
  7228                                  ;  237  3829 genCode16
  7229                                  ;  238  3839 genCode8
  7230                                  ;  239  3848 error1
  7231                                  ;  240  3855 error1
  7232                                  ;  241  3889 implerror
  7233                                  ;  242  3899 segregerror
  7234                                  ;  243  3911 setwflag
  7235                                  ;  244  3920 error1
  7236                                  ;  245  3927 error1
  7237                                  ;  246  3934 error1
  7238                                  ;  247  3951 get2Ops
  7239                                  ;  248  3959 addrerror
  7240                                  ;  249  3969 invaloperror
  7241                                  ;  250  3982 immeerror
  7242                                  ;  251  3992 addrerror
  7243                                  ;  252  4002 setwflag
  7244                                  ;  253  4019 getOpL
  7245                                  ;  254  4026 need
  7246                                  ;  255  4031 getOpR
  7247                                  ;  256  4045 getOpR
  7248                                  ;  257  4059 getOp1
  7249                                  ;  258  4066 isToken
  7250                                  ;  259  4074 getMEM
  7251                                  ;  260  4081 invaloperror
  7252                                  ;  261  4094 error1
  7253                                  ;  262  4108 testReg
  7254                                  ;  263  4116 searchLabel
  7255                                  ;  264  4128 error1
  7256                                  ;  265  4144 getTokeType
  7257                                  ;  266  4156 getOp1
  7258                                  ;  267  4163 syntaxerror
  7259                                  ;  268  4175 getIndReg2
  7260                                  ;  269  4186 getIndReg1
  7261                                  ;  270  4197 isToken
  7262                                  ;  271  4205 getTokeType
  7263                                  ;  272  4217 numbererror
  7264                                  ;  273  4229 isToken
  7265                                  ;  274  4237 isToken
  7266                                  ;  275  4245 errorexit
  7267                                  ;  276  4266 indexerror
  7268                                  ;  277  4277 indexerror
  7269                                  ;  278  4301 indexerror
  7270                                  ;  279  4312 indexerror
  7271                                  ;  280  4332 gen66h
  7272                                  ;  281  4348 error1
  7273                                  ;  282  4374 putch
  7274                                  ;  283  4442 strcpy
  7275                                  ;  284  4457 DosInt
  7276                                  ;  285  4473 DosInt
  7277                                  ;  286  4496 DosInt
  7278                                  ;  287  4515 DosInt
  7279                                  ;  288  4549 writetty
  7280                                  ;  289  4558 writetty
  7281                                  ;Input: AS.C, List: AS.S,  Lines:  303
  7282                                  ;Glob. variables:  193 max.:  200
  7283                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  7284                                  ;Functions      :   84 max.:  300
  7285                                  ;Calls          :  290 max.: 2000, NameField: 4590 max.:    65535
  7286                                  ;Code until     :25998 max.: 30000, free: 4002
  7287                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  7288                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
