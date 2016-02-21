     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E91923                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.07 17.2.16";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E30-     Version1 db "AS.C V0.07 17.2.16",0
    10 0000000C 372031372E322E3136-
    11 00000015 00                 
    12                                  
    13                                  ;-2 #include "DECL.C"
    14                                  
    15                                  ;Use include file: DECL.C
    16                                  
    17                                  ;-1 char LIST;              // listing on/off
    18                                  
    19 00000016 00                      LIST db 0
    20                                  
    21                                  ;-2 #define SYMBOLMAX    31
    22                                  
    23                                  
    24                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    25                                  
    26 00000017 <res 0000001F>          Symbol resb 31
    27                                  
    28                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    29                                  
    30 00000036 <res 0000001F>          SymbolUpper resb 31
    31                                  
    32                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    33                                  
    34 00000055 0000                    SymbolInt dw 0
    35                                  
    36                                  ;-6 #define INPUTBUFMAX 127
    37                                  
    38                                  
    39                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    40                                  
    41 00000057 <res 0000007F>          InputBuf resb 127
    42                                  
    43                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    44                                  
    45 000000D6 0000                    InputPtr dw 0
    46                                  
    47                                  ;-9 char namein [67];       //input file name  .S
    48                                  
    49 000000D8 <res 00000043>          namein resb 67
    50                                  
    51                                  ;-10 char namelst[67];       //list file name   .LST
    52                                  
    53 0000011B <res 00000043>          namelst resb 67
    54                                  
    55                                  ;-11 char namebin[67];       //output file name .COM
    56                                  
    57 0000015E <res 00000043>          namebin resb 67
    58                                  
    59                                  ;-12 int  asm_fd;            //input file descriptor
    60                                  
    61 000001A1 0000                    asm_fd dw 0
    62                                  
    63                                  ;-13 int lst_fd;             //list file descriptor
    64                                  
    65 000001A3 0000                    lst_fd dw 0
    66                                  
    67                                  ;-14 int bin_fd;             //output file descriptor
    68                                  
    69 000001A5 0000                    bin_fd dw 0
    70                                  
    71                                  ;-15 int DOS_ERR;            //global var
    72                                  
    73 000001A7 0000                    DOS_ERR dw 0
    74                                  
    75                                  ;-16 int ErrorCount;         //number of errors
    76                                  
    77 000001A9 0000                    ErrorCount dw 0
    78                                  
    79                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
    80                                  
    81 000001AB 0000                    DOS_NoBytes dw 0
    82                                  
    83                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
    84                                  
    85 000001AD 00                      DOS_ByteRead db 0
    86                                  
    87                                  ;-19 
    88                                  
    89                                  
    90                                  ;-20 unsigned int PC;        //program counter, ORG nn
    91                                  
    92 000001AE 0000                    PC dw 0
    93                                  
    94                                  ;-21 unsigned int PCStart;   //PC at start of line by PrintLine()
    95                                  
    96 000001B0 0000                    PCStart dw 0
    97                                  
    98                                  ;-22 char isLabel;           //by getName()
    99                                  
   100 000001B2 00                      isLabel db 0
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
   116 000001B3 00                      TokeType db 0
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
   136                                  ;-34 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   137                                  
   138                                  
   139                                  ;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   140                                  
   141                                  
   142                                  ;-36 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  
   143                                  
   144 000001B4 00                      Op db 0
   145                                  
   146                                  ;-37 char Op2;               //2. operand
   147                                  
   148 000001B5 00                      Op2 db 0
   149                                  
   150                                  ;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size
   151                                  
   152 000001B6 00                      CodeType db 0
   153                                  
   154                                  ;-39 char Code1;             //1. Opcode
   155                                  
   156 000001B7 00                      Code1 db 0
   157                                  
   158                                  ;-40 char Code2;             //2. Opcode
   159                                  
   160 000001B8 00                      Code2 db 0
   161                                  
   162                                  ;-41 char Code3;             //3. Opcode
   163                                  
   164 000001B9 00                      Code3 db 0
   165                                  
   166                                  ;-42 char RegNo;             //0 - 7 AL, CL, ...  set in testReg()  
   167                                  
   168 000001BA 00                      RegNo db 0
   169                                  
   170                                  ;-43 char R1No;              //temp for 1. register
   171                                  
   172 000001BB 00                      R1No db 0
   173                                  
   174                                  ;-44 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   175                                  
   176 000001BC 00                      RegType db 0
   177                                  
   178                                  ;-45 char R1Type;            //temp for 1. register 
   179                                  
   180 000001BD 00                      R1Type db 0
   181                                  
   182                                  ;-46 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   183                                  
   184 000001BE 00                      OpSize db 0
   185                                  
   186                                  ;-47 char wflag;             //wordflag: 0=byte, 1=word/dword
   187                                  
   188 000001BF 00                      wflag db 0
   189                                  
   190                                  ;-48 //char dflag;             //directionflag: 1=to reg MOV,ALU    
   191                                  
   192                                  
   193                                  ;-49 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   194                                  
   195 000001C0 00                      sflag db 0
   196                                  
   197                                  ;-50 char regindexbase;      //combination of index and base reg
   198                                  
   199 000001C1 00                      regindexbase db 0
   200                                  
   201                                  ;-51 char isDirect;          //set in getOpL and getMeM, need in WriteEA
   202                                  
   203 000001C2 00                      isDirect db 0
   204                                  
   205                                  ;-52 int disp;               //displacement      0-8 bytes
   206                                  
   207 000001C3 0000                    disp dw 0
   208                                  
   209                                  ;-53 int imme;               //immediate         0-8 bytes
   210                                  
   211 000001C5 0000                    imme dw 0
   212                                  
   213                                  ;-54 
   214                                  
   215                                  
   216                                  ;-55 #define OPMAXLEN 5
   217                                  
   218                                  
   219                                  ;-56 char OpPos[OPMAXLEN];   //array for one opcode to list
   220                                  
   221 000001C7 <res 00000005>          OpPos resb 5
   222                                  
   223                                  ;-57 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   224                                  
   225 000001CC 0000                    OpPrintIndex dw 0
   226                                  
   227                                  ;-58 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   228                                  
   229 000001CE 0000                    OpCodePtr dw 0
   230                                  
   231                                  ;-59 char PrintR;           //print 'R' if relocative
   232                                  
   233 000001D0 00                      PrintR db 0
   234                                  
   235                                  ;-60 
   236                                  
   237                                  
   238                                  ;-61 #define LABELNAMESMAX 969//next number - 31
   239                                  
   240                                  
   241                                  ;-62 char LabelNames[1000];  //space for names of all labels
   242                                  
   243 000001D1 <res 000003E8>          LabelNames resb 1000
   244                                  
   245                                  ;-63 char *LabelNamePtr;     // first free position
   246                                  
   247 000005B9 0000                    LabelNamePtr dw 0
   248                                  
   249                                  ;-64 #define LABELADRMAX 100
   250                                  
   251                                  
   252                                  ;-65 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   253                                  
   254 000005BB <res 000000C8>          LabelAddr resw 100
   255                                  
   256                                  ;-66 int LabelMaxIx=0;       //actual number of stored labels
   257                                  
   258 00000683 0000                    LabelMaxIx dw 0
   259                                  
   260                                  ;-67 int LabelIx;            //actual number of just searched label
   261                                  
   262 00000685 0000                    LabelIx dw 0
   263                                  
   264                                  ;-68 
   265                                  
   266                                  
   267                                  ;-69 #define FILEBINMAX 2000 //next number - max. oplength
   268                                  
   269                                  
   270                                  ;-70 char FileBin  [FILEBINMAX];//output binary file
   271                                  
   272 00000687 <res 000007D0>          FileBin resb 2000
   273                                  
   274                                  ;-71 unsigned int BinLen=0;  //length of binary file
   275                                  
   276 00000E57 0000                    BinLen dw 0
   277                                  
   278                                  ;-72 
   279                                  
   280                                  
   281                                  ;-73 char *arglen=0x80;      // for main only
   282                                  
   283 00000E59 8000                    arglen dw 128
   284                                  
   285                                  ;-74 char *argv=0x82;        // for main only
   286                                  
   287 00000E5B 8200                    argv dw 130
   288                                  ;Back to main program: AS.C
   289                                  
   290                                  ;-3 #include "OPTABL.C"
   291                                  
   292                                  ;Use include file: OPTABL.C
   293                                  
   294                                  ;-1 char I_START=0xF1;
   295                                  
   296 00000E5D F1                      I_START db 241
   297                                  
   298                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   299                                  
   300                                  
   301                                  ;-3 //  1:   1 byte opcode
   302                                  
   303                                  
   304                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   305                                  
   306 00000E5E 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   307                                  
   308                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   309                                  
   310 00000E67 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   311                                  
   312                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   313                                  
   314 00000E6F 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   315                                  
   316                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   317                                  
   318 00000E76 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   319                                  
   320                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   321                                  
   322 00000E7D 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   323                                  
   324                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   325                                  
   326 00000E85 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   327                                  
   328                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   329                                  
   330 00000E8C 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   331                                  
   332                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   333                                  
   334 00000E93 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   335                                  
   336                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   337                                  
   338 00000E9B 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   339                                  
   340                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   341                                  
   342 00000EA4 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   343                                  
   344                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   345                                  
   346 00000EAC 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   347                                  
   348                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   349                                  
   350 00000EB4 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   351                                  
   352                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   353                                  
   354 00000EBC 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   355                                  
   356                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   357                                  
   358 00000EC5 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   359                                  
   360                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   361                                  
   362 00000ECE 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   363                                  
   364                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   365                                  
   366 00000ED7 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   367                                  
   368                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   369                                  
   370 00000EE0 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   371                                  
   372                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   373                                  
   374 00000EE9 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   375                                  
   376                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   377                                  
   378 00000EF2 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   379                                  
   380                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   381                                  
   382 00000EFB 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   383                                  
   384                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   385                                  
   386 00000F04 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   387                                  
   388                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   389                                  
   390 00000F0D 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   391                                  
   392                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   393                                  
   394 00000F16 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   395                                  
   396                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   397                                  
   398 00000F1F 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   399                                  
   400                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   401                                  
   402 00000F27 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   403                                  
   404                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   405                                  
   406 00000F2F 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   407                                  
   408                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   409                                  
   410 00000F37 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   411                                  
   412                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   413                                  
   414 00000F40 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   415                                  
   416                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   417                                  
   418 00000F49 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   419                                  
   420                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   421                                  
   422 00000F51 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   423                                  
   424                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   425                                  
   426 00000F59 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   427                                  
   428                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   429                                  
   430 00000F60 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   431                                  
   432                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   433                                  
   434 00000F67 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   435                                  
   436                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   437                                  
   438 00000F6E 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   439                                  
   440                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   441                                  
   442 00000F75 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   443                                  
   444                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   445                                  
   446 00000F7C 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   447                                  
   448                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   449                                  
   450 00000F83 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   451                                  
   452                                  ;-41 // 2: mem reg 16 bit
   453                                  
   454                                  
   455                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   456                                  
   457 00000F8A 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   458                                  
   459                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   460                                  
   461 00000F93 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   462                                  
   463                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   464                                  
   465 00000F9C 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   466                                  
   467                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   468                                  
   469 00000FA4 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   470                                  
   471                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   472                                  
   473 00000FAC 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   474                                  
   475                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   476                                  
   477 00000FB4 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   478                                  
   479                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   480                                  
   481 00000FBD 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   482                                  
   483                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   484                                  
   485 00000FC5 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   486                                  
   487                                  ;-50 //  3: les, lda, lea, lss, lfs, lgs
   488                                  
   489                                  
   490                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   491                                  
   492 00000FCE 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   493                                  
   494                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   495                                  
   496 00000FD5 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   497                                  
   498                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   499                                  
   500 00000FDC 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   501                                  
   502                                  ;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   503                                  
   504 00000FE3 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   505                                  
   506                                  ;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   507                                  
   508 00000FEB 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   509                                  
   510                                  ;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   511                                  
   512 00000FF3 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   513                                  
   514                                  ;-57 //  4: acc,imm  reg,imm  index,reg
   515                                  
   516                                  
   517                                  ;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   518                                  
   519 00000FFB 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   520                                  
   521                                  ;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   522                                  
   523 00001002 4F52000401F1            I_OR db 79,82,0,4,1,241
   524                                  
   525                                  ;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   526                                  
   527 00001008 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   528                                  
   529                                  ;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   530                                  
   531 0000100F 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   532                                  
   533                                  ;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   534                                  
   535 00001016 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   536                                  
   537                                  ;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   538                                  
   539 0000101D 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   540                                  
   541                                  ;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   542                                  
   543 00001024 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   544                                  
   545                                  ;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   546                                  
   547 0000102B 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   548                                  
   549                                  ;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   550                                  
   551 00001032 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   552 0000103B 00F1               
   553                                  
   554                                  ;-67 //  5: mov
   555                                  
   556                                  
   557                                  ;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   558                                  
   559 0000103D 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   560                                  
   561                                  ;-69 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   562                                  
   563 00001043 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   564                                  
   565                                  ;-70 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   566                                  
   567 0000104C 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   568                                  
   569                                  ;-71 //  6: single byte relative jump
   570                                  
   571                                  
   572                                  ;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   573                                  
   574 00001055 4A4F000600F1            I_JO db 74,79,0,6,0,241
   575                                  
   576                                  ;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   577                                  
   578 0000105B 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   579                                  
   580                                  ;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   581                                  
   582 00001062 4A42000602F1            I_JB db 74,66,0,6,2,241
   583                                  
   584                                  ;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   585                                  
   586 00001068 4A43000602F1            I_JC db 74,67,0,6,2,241
   587                                  
   588                                  ;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   589                                  
   590 0000106E 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   591                                  
   592                                  ;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   593                                  
   594 00001075 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   595                                  
   596                                  ;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   597                                  
   598 0000107C 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   599                                  
   600                                  ;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   601                                  
   602 00001083 4A45000604F1            I_JE db 74,69,0,6,4,241
   603                                  
   604                                  ;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   605                                  
   606 00001089 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   607                                  
   608                                  ;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   609                                  
   610 0000108F 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   611                                  
   612                                  ;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   613                                  
   614 00001096 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   615                                  
   616                                  ;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   617                                  
   618 0000109D 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   619                                  
   620                                  ;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   621                                  
   622 000010A4 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   623                                  
   624                                  ;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   625                                  
   626 000010AB 4A41000607F1            I_JA db 74,65,0,6,7,241
   627                                  
   628                                  ;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   629                                  
   630 000010B1 4A53000608F1            I_JS db 74,83,0,6,8,241
   631                                  
   632                                  ;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   633                                  
   634 000010B7 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   635                                  
   636                                  ;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   637                                  
   638 000010BE 4A5000060AF1            I_JP db 74,80,0,6,10,241
   639                                  
   640                                  ;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   641                                  
   642 000010C4 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   643                                  
   644                                  ;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   645                                  
   646 000010CB 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   647                                  
   648                                  ;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   649                                  
   650 000010D2 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   651                                  
   652                                  ;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   653                                  
   654 000010D9 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   655                                  
   656                                  ;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   657                                  
   658 000010DF 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   659                                  
   660                                  ;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   661                                  
   662 000010E6 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   663                                  
   664                                  ;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   665                                  
   666 000010ED 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   667                                  
   668                                  ;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   669                                  
   670 000010F4 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   671                                  
   672                                  ;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   673                                  
   674 000010FB 4A4700060FF1            I_JG db 74,71,0,6,15,241
   675                                  
   676                                  ;-98 //  7: jmp, call
   677                                  
   678                                  
   679                                  ;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   680                                  
   681 00001101 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   682                                  
   683                                  ;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   684                                  
   685 00001109 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   686                                  
   687                                  ;-101 //  8: ret
   688                                  
   689                                  
   690                                  ;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   691                                  
   692 00001112 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   693                                  
   694                                  ;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   695                                  
   696 0000111A 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   697                                  
   698                                  ;-104 //  9: seg, r/m
   699                                  
   700                                  
   701                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   702                                  
   703 00001123 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   704                                  
   705                                  ;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   706                                  
   707 0000112B 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   708                                  
   709                                  ;-107 //  11: shift, rotates
   710                                  
   711                                  
   712                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   713                                  
   714 00001132 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   715                                  
   716                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   717                                  
   718 00001139 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   719                                  
   720                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   721                                  
   722 00001140 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   723                                  
   724                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   725                                  
   726 00001147 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   727                                  
   728                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   729                                  
   730 0000114E 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   731                                  
   732                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   733                                  
   734 00001155 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   735                                  
   736                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   737                                  
   738 0000115C 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   739                                  
   740                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   741                                  
   742 00001163 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   743                                  
   744                                  ;-116 //  12: int
   745                                  
   746                                  
   747                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   748                                  
   749 0000116A 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   750                                  
   751                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   752                                  
   753 00001172 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
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
   787 0000117A 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   788                                  
   789                                  ;-130 //  16: loop, jcxz
   790                                  
   791                                  
   792                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   793                                  
   794 00001183 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   795 0000118C F1                 
   796                                  
   797                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   798                                  
   799 0000118D 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   800 00001196 F1                 
   801                                  
   802                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   803                                  
   804 00001197 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   805                                  
   806                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   807                                  
   808 000011A0 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   809                                  
   810                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   811                                  
   812 000011A9 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   813                                  
   814                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   815                                  
   816 000011B1 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   817                                  
   818                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   819                                  
   820 000011B9 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   821                                  
   822                                  ;-138 //  30: enter
   823                                  
   824                                  
   825                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   826                                  
   827 000011C2 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   828                                  
   829                                  ;-140 // 100: directives
   830                                  
   831                                  
   832                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   833                                  
   834 000011CB 4F52470065F1            I_ORG db 79,82,71,0,101,241
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
   850 000011D1 444200C8F1              I_DB db 68,66,0,200,241
   851                                  
   852                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   853                                  
   854 000011D6 445700C9F1              I_DW db 68,87,0,201,241
   855                                  
   856                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   857                                  
   858 000011DB 444400CAF1              I_DD db 68,68,0,202,241
   859                                  
   860                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   861                                  
   862 000011E0 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   863                                  
   864                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   865                                  
   866 000011E7 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   867                                  
   868                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   869                                  
   870 000011EE 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   871                                  
   872                                  ;-152 char I_END=0;// end of table char
   873                                  
   874 000011F5 00                      I_END db 0
   875                                  ;Back to main program: AS.C
   876                                  
   877                                  ;-4 
   878                                  
   879                                  
   880                                  ;-5 #include "PARSE.C"
   881                                  
   882                                  ;Use include file: PARSE.C
   883                                  
   884                                  ;-1 int parse() {
   885                                  
   886                                  
   887                                  parse:  ; *** PROC ***
   888                                  
   889                                  ;-2   LabelNamePtr= &LabelNames;
   890                                  
   891 000011F6 B8[D101]                 mov ax, LabelNames
   892 000011F9 A3[B905]                 mov word [LabelNamePtr], ax
   893                                  
   894                                  ;-3   do {
   895                                  
   896                                  @@parse1:
   897                                  
   898                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
   899                                  
   900 000011FC A1[AE01]                 mov ax, [PC]
   901 000011FF A3[B001]                 mov word [PCStart], ax
   902 00001202 66B800000000             mov eax, 0
   903 00001208 A2[BE01]                 mov byte [OpSize], al
   904 0000120B 66B800000000             mov eax, 0
   905 00001211 A3[CC01]                 mov word [OpPrintIndex], ax
   906 00001214 66B820000000             mov eax, 32
   907 0000121A A2[D001]                 mov byte [PrintR], al
   908                                  
   909                                  ;-5     getLine();
   910                                  
   911 0000121D E82C05                   call getLine
   912                                  
   913                                  ;-6     InputPtr = &InputBuf;
   914                                  
   915 00001220 B8[5700]                 mov ax, InputBuf
   916 00001223 A3[D600]                 mov word [InputPtr], ax
   917                                  
   918                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
   919                                  
   920 00001226 E8B700                   call getTokeType
   921                                  
   922                                  ;-8     if (TokeType == ALNUME) {
   923                                  
   924 00001229 A0[B301]                 mov al, [TokeType]
   925 0000122C 3C03                     cmp al, 3
   926 0000122E 0F851300                 jne @@parse2
   927                                  
   928                                  ;-9       if (isLabel) { //set in getName
   929                                  
   930 00001232 A0[B201]                 mov al, [isLabel]
   931 00001235 08C0                     or  al, al
   932 00001237 0F840A00                 je @@parse3
   933                                  
   934                                  ;-10         storeLabel();
   935                                  
   936 0000123B E84001                   call storeLabel
   937                                  
   938                                  ;-11         InputPtr++;//remove :
   939                                  
   940 0000123E FF06[D600]               inc  word [InputPtr]
   941                                  
   942                                  ;-12         getTokeType();
   943                                  
   944 00001242 E89B00                   call getTokeType
   945                                  
   946                                  ;-13       }
   947                                  
   948                                  
   949                                  ;-14     }
   950                                  
   951                                  @@parse3:
   952                                  
   953                                  ;-15     if (TokeType == ALNUME) {
   954                                  
   955                                  @@parse2:
   956 00001245 A0[B301]                 mov al, [TokeType]
   957 00001248 3C03                     cmp al, 3
   958 0000124A 0F851B00                 jne @@parse4
   959                                  
   960                                  ;-16       lookCode();// and OpCodePtr
   961                                  
   962 0000124E E86803                   call lookCode
   963                                  
   964                                  ;-17       if(CodeType) process();
   965                                  
   966 00001251 A0[B601]                 mov al, [CodeType]
   967 00001254 08C0                     or  al, al
   968 00001256 0F840600                 je @@parse5
   969 0000125A E8DF16                   call process
   970                                  
   971                                  ;-18       else getVariable();
   972                                  
   973 0000125D E90300                   jmp @@parse6
   974                                  @@parse5:
   975 00001260 E81E02                   call getVariable
   976                                  
   977                                  ;-19       skipRest();
   978                                  
   979                                  @@parse6:
   980 00001263 E8BD04                   call skipRest
   981                                  
   982                                  ;-20     }
   983                                  
   984                                  
   985                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
   986                                  
   987 00001266 E92700                   jmp @@parse7
   988                                  @@parse4:
   989 00001269 A0[B301]                 mov al, [TokeType]
   990 0000126C 3C03                     cmp al, 3
   991 0000126E 0F8E0C00                 jle @@parse8
   992 00001272 68[A112]                 push parse_0
   993 00001275 E8920E                   call error1
   994 00001278 83C402                   add  sp, 2
   995                                  
   996                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
   997                                  
   998 0000127B E91200                   jmp @@parse9
   999                                  @@parse8:
  1000 0000127E A0[B301]                 mov al, [TokeType]
  1001 00001281 3C01                     cmp al, 1
  1002 00001283 0F850900                 jne @@parse10
  1003 00001287 68[BF12]                 push parse_1
  1004 0000128A E87D0E                   call error1
  1005 0000128D 83C402                   add  sp, 2
  1006                                  
  1007                                  ;-23     printLine();
  1008                                  
  1009                                  @@parse10:
  1010                                  @@parse9:
  1011                                  @@parse7:
  1012 00001290 E80C0C                   call printLine
  1013                                  
  1014                                  ;-24   } while (DOS_NoBytes != 0 );
  1015                                  
  1016 00001293 A1[AB01]                 mov ax, [DOS_NoBytes]
  1017 00001296 83F800                   cmp ax, 0
  1018 00001299 0F840300                 je  @@parse11
  1019 0000129D E95CFF                   jmp @@parse1
  1020                                  @@parse11:
  1021                                  
  1022                                  ;-25 }
  1023                                  
  1024                                  
  1025                                  ;-26 // scan code .....................................
  1026                                  
  1027                                  
  1028                                  ;-27 int getTokeType() { char c;
  1029                                  
  1030 000012A0 C3                       ret
  1031                                  ; ENDP
  1032 000012A1 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1033 000012AA 696E73747275637469-
  1034 000012B3 6F6E20657870656374-
  1035 000012BC 656400             
  1036 000012BF 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1037 000012C8 616C6C6F7765642040-
  1038 000012D1 207374617274206F66-
  1039 000012DA 206C696E6500       
  1040                                  
  1041                                  getTokeType:  ; *** PROC ***
  1042                                  
  1043                                  ;-28   skipBlank();
  1044                                  
  1045                                  ;Function : getTokeType, Number of local variables: 1
  1046                                  ;   # type sign width line used address name   list of local variables
  1047                                  ;  200 var sign byte    27 NULL bp-2    c;
  1048 000012E0 C8020000                 ENTER  2,0
  1049 000012E4 E86705                   call skipBlank
  1050                                  
  1051                                  ;-29   c = *InputPtr;
  1052                                  
  1053 000012E7 8B1E[D600]               mov bx, [InputPtr]
  1054 000012EB 8A07                     mov al, [bx]
  1055 000012ED B400                     mov ah, 0
  1056 000012EF 8846FE                   mov byte [bp-2], al
  1057                                  
  1058                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1059                                  
  1060 000012F2 8A46FE                   mov al, [bp-2]
  1061 000012F5 3C00                     cmp al, 0
  1062 000012F7 0F850C00                 jne @@getTokeType12
  1063 000012FB 66B800000000             mov eax, 0
  1064 00001301 A2[B301]                 mov byte [TokeType], al
  1065 00001304 E97500                   jmp @@retn
  1066                                  
  1067                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1068                                  
  1069                                  @@getTokeType12:
  1070 00001307 8A46FE                   mov al, [bp-2]
  1071 0000130A 3C3B                     cmp al, 59
  1072 0000130C 0F850C00                 jne @@getTokeType13
  1073 00001310 66B800000000             mov eax, 0
  1074 00001316 A2[B301]                 mov byte [TokeType], al
  1075 00001319 E96000                   jmp @@retn
  1076                                  
  1077                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1078                                  
  1079                                  @@getTokeType13:
  1080 0000131C 8A46FE                   mov al, byte [bp-2]
  1081 0000131F B400                     mov ah, 0
  1082 00001321 50                       push ax
  1083 00001322 E8D71E                   call digit
  1084 00001325 83C402                   add  sp, 2
  1085 00001328 08C0                     or  al, al
  1086 0000132A 0F841800                 je @@getTokeType14
  1087 0000132E 8A46FE                   mov al, byte [bp-2]
  1088 00001331 B400                     mov ah, 0
  1089 00001333 50                       push ax
  1090 00001334 E81D06                   call getDigit
  1091 00001337 83C402                   add  sp, 2
  1092 0000133A 66B801000000             mov eax, 1
  1093 00001340 A2[B301]                 mov byte [TokeType], al
  1094 00001343 E93600                   jmp @@retn
  1095                                  
  1096                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1097                                  
  1098                                  @@getTokeType14:
  1099 00001346 8A46FE                   mov al, byte [bp-2]
  1100 00001349 B400                     mov ah, 0
  1101 0000134B 50                       push ax
  1102 0000134C E82A05                   call letterE
  1103 0000134F 83C402                   add  sp, 2
  1104 00001352 08C0                     or  al, al
  1105 00001354 0F841800                 je @@getTokeType15
  1106 00001358 8A46FE                   mov al, byte [bp-2]
  1107 0000135B B400                     mov ah, 0
  1108 0000135D 50                       push ax
  1109 0000135E E84A06                   call getName
  1110 00001361 83C402                   add  sp, 2
  1111 00001364 66B803000000             mov eax, 3
  1112 0000136A A2[B301]                 mov byte [TokeType], al
  1113 0000136D E90C00                   jmp @@retn
  1114                                  
  1115                                  ;-34   TokeType=NOALNUME; return;
  1116                                  
  1117                                  @@getTokeType15:
  1118 00001370 66B804000000             mov eax, 4
  1119 00001376 A2[B301]                 mov byte [TokeType], al
  1120 00001379 E90000                   jmp @@retn
  1121                                  
  1122                                  ;-35 }
  1123                                  
  1124                                  
  1125                                  ;-36 int storeLabel() {unsigned int i;
  1126                                  
  1127 0000137C C9                      @@retn: LEAVE
  1128 0000137D C3                       ret
  1129                                  ; ENDP
  1130                                  
  1131                                  storeLabel:  ; *** PROC ***
  1132                                  
  1133                                  ;-37   if(searchLabel()) error1("duplicate label");
  1134                                  
  1135                                  ;Function : storeLabel, Number of local variables: 1
  1136                                  ;   # type sign width line used address name   list of local variables
  1137                                  ;  200 var unsg word    36 NULL bp-2    i;
  1138 0000137E C8020000                 ENTER  2,0
  1139 00001382 E89C00                   call searchLabel
  1140 00001385 08C0                     or  al, al
  1141 00001387 0F840900                 je @@storeLabel16
  1142 0000138B 68[EC13]                 push storeLabel_0
  1143 0000138E E8790D                   call error1
  1144 00001391 83C402                   add  sp, 2
  1145                                  
  1146                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1147                                  
  1148                                  @@storeLabel16:
  1149 00001394 8D06[1700]               lea  ax, [Symbol]
  1150 00001398 50                       push ax
  1151 00001399 FF36[B905]               push word [LabelNamePtr]
  1152 0000139D E8231E                   call strcpy
  1153 000013A0 83C404                   add  sp, 4
  1154 000013A3 A3[B905]                 mov word [LabelNamePtr], ax
  1155                                  
  1156                                  ;-39   LabelNamePtr++;
  1157                                  
  1158 000013A6 FF06[B905]               inc  word [LabelNamePtr]
  1159                                  
  1160                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  1161                                  
  1162 000013AA A1[B905]                 mov ax, [LabelNamePtr]
  1163 000013AD 2D[D101]                 sub ax, LabelNames
  1164 000013B0 8946FE                   mov word [bp-2], ax
  1165                                  
  1166                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  1167                                  
  1168 000013B3 8B46FE                   mov ax, [bp-2]
  1169 000013B6 3DC903                   cmp ax, 969 ;unsigned : 0
  1170 000013B9 0F820900                 jb  @@storeLabel17
  1171 000013BD 68[FC13]                 push storeLabel_1
  1172 000013C0 E8080F                   call errorexit
  1173 000013C3 83C402                   add  sp, 2
  1174                                  
  1175                                  ;-42   LabelMaxIx++;
  1176                                  
  1177                                  @@storeLabel17:
  1178 000013C6 FF06[8306]               inc  word [LabelMaxIx]
  1179                                  
  1180                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  1181                                  
  1182 000013CA A1[8306]                 mov ax, [LabelMaxIx]
  1183 000013CD 83F864                   cmp ax, 100 ;unsigned : 1
  1184 000013D0 0F8C0900                 jl  @@storeLabel18
  1185 000013D4 68[1114]                 push storeLabel_2
  1186 000013D7 E8F10E                   call errorexit
  1187 000013DA 83C402                   add  sp, 2
  1188                                  
  1189                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  1190                                  
  1191                                  @@storeLabel18:
  1192 000013DD A1[AE01]                 mov ax, [PC]
  1193 000013E0 8B1E[8306]               mov bx, [LabelMaxIx]
  1194 000013E4 D1E3                     shl bx, 1
  1195 000013E6 8987[BB05]               mov [LabelAddr+bx], ax
  1196                                  
  1197                                  ;-45 }
  1198                                  
  1199                                  
  1200                                  ;-46 int searchLabel() {
  1201 000013EA C9                       LEAVE
  1202 000013EB C3                       ret
  1203                                  ; ENDP
  1204 000013EC 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  1205 000013F5 206C6162656C00     
  1206 000013FC 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  1207 00001405 6C6162656C206E616D-
  1208 0000140E 657300             
  1209 00001411 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  1210 0000141A 6C6162656C7300     
  1211                                  
  1212                                  searchLabel:  ; *** PROC ***
  1213                                  
  1214                                  ;-47   int LIx; char *p; int j;
  1215                                  
  1216                                  
  1217                                  ;-48   p = &LabelNames;
  1218                                  
  1219                                  ;Function : searchLabel, Number of local variables: 3
  1220                                  ;   # type sign width line used address name   list of local variables
  1221                                  ;  200 var sign word    47 NULL bp-2    LIx
  1222                                  ;  201 ptr sign byte    47 NULL bp-4    p
  1223                                  ;  202 var sign word    47 NULL bp-6    j;
  1224 00001421 C8060000                 ENTER  6,0
  1225 00001425 B8[D101]                 mov ax, LabelNames
  1226 00001428 8946FC                   mov word [bp-4], ax
  1227                                  
  1228                                  ;-49   LIx=1;
  1229                                  
  1230 0000142B 66B801000000             mov eax, 1
  1231 00001431 8946FE                   mov word [bp-2], ax
  1232                                  
  1233                                  ;-50   while (LIx <= LabelMaxIx) {
  1234                                  
  1235                                  @@searchLabel19:
  1236 00001434 8B46FE                   mov ax, [bp-2]
  1237 00001437 3B06[8306]               cmp ax, [LabelMaxIx]
  1238 0000143B 0F8F3700                 jg  @@searchLabel20
  1239                                  
  1240                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  1241                                  
  1242 0000143F 8D06[1700]               lea  ax, [Symbol]
  1243 00001443 50                       push ax
  1244 00001444 FF76FC                   push word [bp-4]
  1245 00001447 E8E51D                   call eqstr
  1246 0000144A 83C404                   add  sp, 4
  1247 0000144D 08C0                     or  al, al
  1248 0000144F 0F840600                 je @@searchLabel21
  1249 00001453 8B46FE                   mov ax, [bp-2]
  1250 00001456 E92600                   jmp @@retn
  1251                                  
  1252                                  ;-52     j=strlen(p);
  1253                                  
  1254                                  @@searchLabel21:
  1255 00001459 FF76FC                   push word [bp-4]
  1256 0000145C E8391D                   call strlen
  1257 0000145F 83C402                   add  sp, 2
  1258 00001462 8946FA                   mov word [bp-6], ax
  1259                                  
  1260                                  ;-53     p=p+j; p++; LIx++;
  1261                                  
  1262 00001465 8B46FC                   mov ax, [bp-4]
  1263 00001468 0346FA                   add ax, [bp-6]
  1264 0000146B 8946FC                   mov word [bp-4], ax
  1265 0000146E FF46FC                   inc  word [bp-4]
  1266 00001471 FF46FE                   inc  word [bp-2]
  1267                                  
  1268                                  ;-54   }
  1269                                  
  1270                                  
  1271                                  ;-55   return 0;
  1272                                  
  1273 00001474 EBBE                     jmp @@searchLabel19
  1274                                  @@searchLabel20:
  1275 00001476 66B800000000             mov eax, 0
  1276 0000147C E90000                   jmp @@retn
  1277                                  
  1278                                  ;-56 }
  1279                                  
  1280                                  
  1281                                  ;-57 int getVariable() { char c;
  1282                                  
  1283 0000147F C9                      @@retn: LEAVE
  1284 00001480 C3                       ret
  1285                                  ; ENDP
  1286                                  
  1287                                  getVariable:  ; *** PROC ***
  1288                                  
  1289                                  ;-58   storeLabel();
  1290                                  
  1291                                  ;Function : getVariable, Number of local variables: 1
  1292                                  ;   # type sign width line used address name   list of local variables
  1293                                  ;  200 var sign byte    57 NULL bp-2    c;
  1294 00001481 C8020000                 ENTER  2,0
  1295 00001485 E8F6FE                   call storeLabel
  1296                                  
  1297                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  1298                                  
  1299 00001488 E855FE                   call getTokeType
  1300 0000148B A0[B301]                 mov al, [TokeType]
  1301 0000148E 3C03                     cmp al, 3
  1302 00001490 0F85CC00                 jne @@getVariable22
  1303                                  
  1304                                  ;-60     lookCode();
  1305                                  
  1306 00001494 E82201                   call lookCode
  1307                                  
  1308                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  1309                                  
  1310 00001497 A0[B601]                 mov al, [CodeType]
  1311 0000149A 3CC8                     cmp al, 200
  1312 0000149C 0F8D0900                 jge @@getVariable23
  1313 000014A0 68[6B15]                 push getVariable_0
  1314 000014A3 E8250E                   call errorexit
  1315 000014A6 83C402                   add  sp, 2
  1316                                  
  1317                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1318                                  
  1319                                  @@getVariable23:
  1320 000014A9 A0[B601]                 mov al, [CodeType]
  1321 000014AC 3CCF                     cmp al, 207
  1322 000014AE 0F8E0900                 jle @@getVariable24
  1323 000014B2 68[8315]                 push getVariable_1
  1324 000014B5 E8130E                   call errorexit
  1325 000014B8 83C402                   add  sp, 2
  1326                                  
  1327                                  ;-63     if (CodeType== 200) {// DB
  1328                                  
  1329                                  @@getVariable24:
  1330 000014BB A0[B601]                 mov al, [CodeType]
  1331 000014BE 3CC8                     cmp al, 200
  1332 000014C0 0F856A00                 jne @@getVariable25
  1333                                  
  1334                                  ;-64       do { getTokeType();
  1335                                  
  1336                                  @@getVariable26:
  1337 000014C4 E819FE                   call getTokeType
  1338                                  
  1339                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  1340                                  
  1341 000014C7 A0[B301]                 mov al, [TokeType]
  1342 000014CA 3C01                     cmp al, 1
  1343 000014CC 0F850D00                 jne @@getVariable27
  1344 000014D0 FF36[5500]               push word [SymbolInt]
  1345 000014D4 E80712                   call genCode8
  1346 000014D7 83C402                   add  sp, 2
  1347                                  
  1348                                  ;-66         else {
  1349                                  
  1350 000014DA E94100                   jmp @@getVariable28
  1351                                  @@getVariable27:
  1352                                  
  1353                                  ;-67           skipBlank();
  1354                                  
  1355 000014DD E86E03                   call skipBlank
  1356                                  
  1357                                  ;-68           if (isToken('"')) {
  1358                                  
  1359 000014E0 6A22                     push 34
  1360 000014E2 E8D101                   call isToken
  1361 000014E5 83C402                   add  sp, 2
  1362 000014E8 08C0                     or  al, al
  1363 000014EA 0F843000                 je @@getVariable29
  1364                                  
  1365                                  ;-69             do { c= *InputPtr;
  1366                                  
  1367                                  @@getVariable30:
  1368 000014EE 8B1E[D600]               mov bx, [InputPtr]
  1369 000014F2 8A07                     mov al, [bx]
  1370 000014F4 B400                     mov ah, 0
  1371 000014F6 8846FE                   mov byte [bp-2], al
  1372                                  
  1373                                  ;-70               genCode8(c);
  1374                                  
  1375 000014F9 8A46FE                   mov al, byte [bp-2]
  1376 000014FC B400                     mov ah, 0
  1377 000014FE 50                       push ax
  1378 000014FF E8DC11                   call genCode8
  1379 00001502 83C402                   add  sp, 2
  1380                                  
  1381                                  ;-71               InputPtr++;
  1382                                  
  1383 00001505 FF06[D600]               inc  word [InputPtr]
  1384                                  
  1385                                  ;-72             } while (*InputPtr != '"' );
  1386                                  
  1387 00001509 8B1E[D600]               mov bx, [InputPtr]
  1388 0000150D 8A07                     mov al, [bx]
  1389 0000150F B400                     mov ah, 0
  1390 00001511 83F822                   cmp ax, 34
  1391 00001514 0F840200                 je  @@getVariable31
  1392 00001518 EBD4                     jmp @@getVariable30
  1393                                  @@getVariable31:
  1394                                  
  1395                                  ;-73             InputPtr++;
  1396                                  
  1397 0000151A FF06[D600]               inc  word [InputPtr]
  1398                                  
  1399                                  ;-74           }
  1400                                  
  1401                                  
  1402                                  ;-75         }
  1403                                  
  1404                                  @@getVariable29:
  1405                                  
  1406                                  ;-76       } while (isToken(','));
  1407                                  
  1408                                  @@getVariable28:
  1409 0000151E 6A2C                     push 44
  1410 00001520 E89301                   call isToken
  1411 00001523 83C402                   add  sp, 2
  1412 00001526 08C0                     or  al, al
  1413 00001528 0F840200                 je @@getVariable32
  1414 0000152C EB96                     jmp @@getVariable26
  1415                                  @@getVariable32:
  1416                                  
  1417                                  ;-77     }
  1418                                  
  1419                                  
  1420                                  ;-78     if (CodeType== 201) {// DW
  1421                                  
  1422                                  @@getVariable25:
  1423 0000152E A0[B601]                 mov al, [CodeType]
  1424 00001531 3CC9                     cmp al, 201
  1425 00001533 0F852600                 jne @@getVariable33
  1426                                  
  1427                                  ;-79       do { getTokeType();
  1428                                  
  1429                                  @@getVariable34:
  1430 00001537 E8A6FD                   call getTokeType
  1431                                  
  1432                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  1433                                  
  1434 0000153A A0[B301]                 mov al, [TokeType]
  1435 0000153D 3C01                     cmp al, 1
  1436 0000153F 0F850A00                 jne @@getVariable35
  1437 00001543 FF36[5500]               push word [SymbolInt]
  1438 00001547 E8EB11                   call genCode16
  1439 0000154A 83C402                   add  sp, 2
  1440                                  
  1441                                  ;-81       } while (isToken(','));
  1442                                  
  1443                                  @@getVariable35:
  1444 0000154D 6A2C                     push 44
  1445 0000154F E86401                   call isToken
  1446 00001552 83C402                   add  sp, 2
  1447 00001555 08C0                     or  al, al
  1448 00001557 0F840200                 je @@getVariable36
  1449 0000155B EBDA                     jmp @@getVariable34
  1450                                  @@getVariable36:
  1451                                  
  1452                                  ;-82     }
  1453                                  
  1454                                  
  1455                                  ;-83   }
  1456                                  
  1457                                  @@getVariable33:
  1458                                  
  1459                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  1460                                  
  1461 0000155D E90900                   jmp @@getVariable37
  1462                                  @@getVariable22:
  1463 00001560 68[9B15]                 push getVariable_2
  1464 00001563 E8650D                   call errorexit
  1465 00001566 83C402                   add  sp, 2
  1466                                  
  1467                                  ;-85 }
  1468                                  
  1469                                  @@getVariable37:
  1470                                  
  1471                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  1472 00001569 C9                       LEAVE
  1473 0000156A C3                       ret
  1474                                  ; ENDP
  1475 0000156B 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  1476 00001574 422C572C4420657870-
  1477 0000157D 656374656400       
  1478 00001583 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  1479 0000158C 422C572C4420657870-
  1480 00001595 656374656400       
  1481 0000159B 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  1482 000015A4 6F7220524553422C57-
  1483 000015AD 2C4420657870656374-
  1484 000015B6 656400             
  1485                                  
  1486                                  lookCode:  ; *** PROC ***
  1487                                  
  1488                                  ;-87   CodeType=0;
  1489                                  
  1490 000015B9 66B800000000             mov eax, 0
  1491 000015BF A2[B601]                 mov byte [CodeType], al
  1492                                  
  1493                                  ;-88   OpCodePtr= &I_START;
  1494                                  
  1495 000015C2 B8[5D0E]                 mov ax, I_START
  1496 000015C5 A3[CE01]                 mov word [OpCodePtr], ax
  1497                                  
  1498                                  ;-89   OpCodePtr++;
  1499                                  
  1500 000015C8 FF06[CE01]               inc  word [OpCodePtr]
  1501                                  
  1502                                  ;-90   do  {
  1503                                  
  1504                                  @@lookCode38:
  1505                                  
  1506                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  1507                                  
  1508 000015CC FF36[CE01]               push word [OpCodePtr]
  1509 000015D0 8D06[3600]               lea  ax, [SymbolUpper]
  1510 000015D4 50                       push ax
  1511 000015D5 E8571C                   call eqstr
  1512 000015D8 83C404                   add  sp, 4
  1513 000015DB 08C0                     or  al, al
  1514 000015DD 0F842700                 je @@lookCode39
  1515                                  
  1516                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  1517                                  
  1518                                  @@lookCode40:
  1519 000015E1 8B1E[CE01]               mov bx, [OpCodePtr]
  1520 000015E5 8A07                     mov al, [bx]
  1521 000015E7 B400                     mov ah, 0
  1522 000015E9 83F800                   cmp ax, 0
  1523 000015EC 0F840600                 je  @@lookCode41
  1524 000015F0 FF06[CE01]               inc  word [OpCodePtr]
  1525                                  
  1526                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  1527                                  
  1528 000015F4 EBEB                     jmp @@lookCode40
  1529                                  @@lookCode41:
  1530 000015F6 FF06[CE01]               inc  word [OpCodePtr]
  1531 000015FA 8B1E[CE01]               mov bx, [OpCodePtr]
  1532 000015FE 8A07                     mov al, [bx]
  1533 00001600 B400                     mov ah, 0
  1534 00001602 A2[B601]                 mov byte [CodeType], al
  1535                                  
  1536                                  ;-94       return;
  1537                                  
  1538 00001605 E92A00                   jmp @@retn
  1539                                  
  1540                                  ;-95     }
  1541                                  
  1542                                  
  1543                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  1544                                  
  1545                                  @@lookCode39:
  1546                                  @@lookCode42:
  1547 00001608 8B1E[CE01]               mov bx, [OpCodePtr]
  1548 0000160C 8A07                     mov al, [bx]
  1549 0000160E B400                     mov ah, 0
  1550 00001610 3DF100                   cmp ax, 241
  1551 00001613 0F840600                 je  @@lookCode43
  1552 00001617 FF06[CE01]               inc  word [OpCodePtr]
  1553                                  
  1554                                  ;-97   OpCodePtr++;
  1555                                  
  1556 0000161B EBEB                     jmp @@lookCode42
  1557                                  @@lookCode43:
  1558 0000161D FF06[CE01]               inc  word [OpCodePtr]
  1559                                  
  1560                                  ;-98   } while(*OpCodePtr!=0);
  1561                                  
  1562 00001621 8B1E[CE01]               mov bx, [OpCodePtr]
  1563 00001625 8A07                     mov al, [bx]
  1564 00001627 B400                     mov ah, 0
  1565 00001629 83F800                   cmp ax, 0
  1566 0000162C 0F840200                 je  @@lookCode44
  1567 00001630 EB9A                     jmp @@lookCode38
  1568                                  @@lookCode44:
  1569                                  
  1570                                  ;-99 }
  1571                                  
  1572                                  
  1573                                  ;-100 
  1574                                  
  1575                                  
  1576                                  ;-101 int getCodeSize() {
  1577                                  
  1578                                  @@retn:
  1579 00001632 C3                       ret
  1580                                  ; ENDP
  1581                                  
  1582                                  getCodeSize:  ; *** PROC ***
  1583                                  
  1584                                  ;-102   if (TokeType ==ALNUME) {
  1585                                  
  1586 00001633 A0[B301]                 mov al, [TokeType]
  1587 00001636 3C03                     cmp al, 3
  1588 00001638 0F856000                 jne @@getCodeSize45
  1589                                  
  1590                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1591                                  
  1592 0000163C 68[A616]                 push getCodeSize_0
  1593 0000163F 8D06[3600]               lea  ax, [SymbolUpper]
  1594 00001643 50                       push ax
  1595 00001644 E8E81B                   call eqstr
  1596 00001647 83C404                   add  sp, 4
  1597 0000164A 08C0                     or  al, al
  1598 0000164C 0F840C00                 je @@getCodeSize46
  1599 00001650 E88DFC                   call getTokeType
  1600 00001653 66B801000000             mov eax, 1
  1601 00001659 E94900                   jmp @@retn
  1602                                  
  1603                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1604                                  
  1605                                  @@getCodeSize46:
  1606 0000165C 68[AB16]                 push getCodeSize_1
  1607 0000165F 8D06[3600]               lea  ax, [SymbolUpper]
  1608 00001663 50                       push ax
  1609 00001664 E8C81B                   call eqstr
  1610 00001667 83C404                   add  sp, 4
  1611 0000166A 08C0                     or  al, al
  1612 0000166C 0F840C00                 je @@getCodeSize47
  1613 00001670 E86DFC                   call getTokeType
  1614 00001673 66B802000000             mov eax, 2
  1615 00001679 E92900                   jmp @@retn
  1616                                  
  1617                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1618                                  
  1619                                  @@getCodeSize47:
  1620 0000167C 68[B016]                 push getCodeSize_2
  1621 0000167F 8D06[3600]               lea  ax, [SymbolUpper]
  1622 00001683 50                       push ax
  1623 00001684 E8A81B                   call eqstr
  1624 00001687 83C404                   add  sp, 4
  1625 0000168A 08C0                     or  al, al
  1626 0000168C 0F840C00                 je @@getCodeSize48
  1627 00001690 E84DFC                   call getTokeType
  1628 00001693 66B803000000             mov eax, 3
  1629 00001699 E90900                   jmp @@retn
  1630                                  
  1631                                  ;-106   } return 0;
  1632                                  
  1633                                  @@getCodeSize48:
  1634                                  @@getCodeSize45:
  1635 0000169C 66B800000000             mov eax, 0
  1636 000016A2 E90000                   jmp @@retn
  1637                                  
  1638                                  ;-107 }
  1639                                  
  1640                                  
  1641                                  ;-108 int isToken(char c) {
  1642                                  
  1643                                  @@retn:
  1644 000016A5 C3                       ret
  1645                                  ; ENDP
  1646 000016A6 4259544500              getCodeSize_0 db "BYTE",0
  1647 000016AB 574F524400              getCodeSize_1 db "WORD",0
  1648 000016B0 44574F524400            getCodeSize_2 db "DWORD",0
  1649                                  
  1650                                  isToken:  ; *** PROC ***
  1651                                  
  1652                                  ;-109   skipBlank();
  1653                                  
  1654                                  ;Function : isToken, Number of local variables: 1
  1655                                  ;   # type sign width line used address name   list of local variables
  1656                                  ;  200 var sign byte   108 NULL bp+4    c;
  1657 000016B6 C8000000                 ENTER  0,0
  1658 000016BA E89101                   call skipBlank
  1659                                  
  1660                                  ;-110   if (*InputPtr == c) {
  1661                                  
  1662 000016BD 8B1E[D600]               mov bx, [InputPtr]
  1663 000016C1 8A07                     mov al, [bx]
  1664 000016C3 B400                     mov ah, 0
  1665 000016C5 3A4604                   cmp al, [bp+4]
  1666 000016C8 0F850D00                 jne @@isToken49
  1667                                  
  1668                                  ;-111     InputPtr++; return 1;} return 0;
  1669                                  
  1670 000016CC FF06[D600]               inc  word [InputPtr]
  1671 000016D0 66B801000000             mov eax, 1
  1672 000016D6 E90900                   jmp @@retn
  1673                                  @@isToken49:
  1674 000016D9 66B800000000             mov eax, 0
  1675 000016DF E90000                   jmp @@retn
  1676                                  
  1677                                  ;-112 }
  1678                                  
  1679                                  
  1680                                  ;-113 int need(char c) {
  1681                                  
  1682 000016E2 C9                      @@retn: LEAVE
  1683 000016E3 C3                       ret
  1684                                  ; ENDP
  1685                                  
  1686                                  need:  ; *** PROC ***
  1687                                  
  1688                                  ;-114   if (isToken(c)) {
  1689                                  
  1690                                  ;Function : need, Number of local variables: 1
  1691                                  ;   # type sign width line used address name   list of local variables
  1692                                  ;  200 var sign byte   113 NULL bp+4    c;
  1693 000016E4 C8000000                 ENTER  0,0
  1694 000016E8 8A4604                   mov al, byte [bp+4]
  1695 000016EB B400                     mov ah, 0
  1696 000016ED 50                       push ax
  1697 000016EE E8C5FF                   call isToken
  1698 000016F1 83C402                   add  sp, 2
  1699 000016F4 08C0                     or  al, al
  1700 000016F6 0F840600                 je @@need50
  1701                                  
  1702                                  ;-115       getTokeType();
  1703                                  
  1704 000016FA E8E3FB                   call getTokeType
  1705                                  
  1706                                  ;-116       return;
  1707                                  
  1708 000016FD E91800                   jmp @@retn
  1709                                  
  1710                                  ;-117       }
  1711                                  
  1712                                  
  1713                                  ;-118   error1();
  1714                                  
  1715                                  @@need50:
  1716 00001700 E8070A                   call error1
  1717                                  
  1718                                  ;-119   prs(". need: ");
  1719                                  
  1720 00001703 68[1A17]                 push need_0
  1721 00001706 E8A408                   call prs
  1722 00001709 83C402                   add  sp, 2
  1723                                  
  1724                                  ;-120   prc(c);
  1725                                  
  1726 0000170C 8A4604                   mov al, byte [bp+4]
  1727 0000170F B400                     mov ah, 0
  1728 00001711 50                       push ax
  1729 00001712 E83708                   call prc
  1730 00001715 83C402                   add  sp, 2
  1731                                  
  1732                                  ;-121 }
  1733                                  
  1734                                  
  1735                                  ;-122 
  1736                                  
  1737                                  
  1738                                  ;-123 int skipRest() {
  1739                                  
  1740 00001718 C9                      @@retn: LEAVE
  1741 00001719 C3                       ret
  1742                                  ; ENDP
  1743 0000171A 2E206E6565643A2000      need_0 db ". need: ",0
  1744                                  
  1745                                  skipRest:  ; *** PROC ***
  1746                                  
  1747                                  ;-124   getTokeType(); 
  1748                                  
  1749 00001723 E8BAFB                   call getTokeType
  1750                                  
  1751                                  ;-125   if(TokeType)error1("extra char ignored");
  1752                                  
  1753 00001726 A0[B301]                 mov al, [TokeType]
  1754 00001729 08C0                     or  al, al
  1755 0000172B 0F840900                 je @@skipRest51
  1756 0000172F 68[3917]                 push skipRest_0
  1757 00001732 E8D509                   call error1
  1758 00001735 83C402                   add  sp, 2
  1759                                  
  1760                                  ;-126 }
  1761                                  
  1762                                  @@skipRest51:
  1763 00001738 C3                       ret
  1764                                  ; ENDP
  1765 00001739 657874726120636861-     skipRest_0 db "extra char ignored",0
  1766 00001742 722069676E6F726564-
  1767 0000174B 00                 
  1768                                  ;Back to main program: AS.C
  1769                                  
  1770                                  ;-6 #include "HELPER.C"
  1771                                  
  1772                                  ;Use include file: HELPER.C
  1773                                  
  1774                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  1775                                  
  1776                                  
  1777                                  getLine:  ; *** PROC ***
  1778                                  
  1779                                  ;-2   unsigned int i;
  1780                                  
  1781                                  
  1782                                  ;-3   InputPtr= &InputBuf;
  1783                                  
  1784                                  ;Function : getLine, Number of local variables: 1
  1785                                  ;   # type sign width line used address name   list of local variables
  1786                                  ;  200 var unsg word     2 NULL bp-2    i;
  1787 0000174C C8020000                 ENTER  2,0
  1788 00001750 B8[5700]                 mov ax, InputBuf
  1789 00001753 A3[D600]                 mov word [InputPtr], ax
  1790                                  
  1791                                  ;-4   *InputPtr=0;//if last line is empty
  1792                                  
  1793 00001756 66B800000000             mov eax, 0
  1794 0000175C 8B1E[D600]               mov  bx, [InputPtr]
  1795 00001760 8807                     mov  [bx], al
  1796                                  
  1797                                  ;-5   do {
  1798                                  
  1799                                  @@getLine52:
  1800                                  
  1801                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1802                                  
  1803 00001762 6A01                     push 1
  1804 00001764 FF36[A101]               push word [asm_fd]
  1805 00001768 8D06[AD01]               lea  ax, [DOS_ByteRead]
  1806 0000176C 50                       push ax
  1807 0000176D E85A1B                   call readRL
  1808 00001770 83C406                   add  sp, 6
  1809 00001773 A3[AB01]                 mov word [DOS_NoBytes], ax
  1810                                  
  1811                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  1812                                  
  1813 00001776 A1[A701]                 mov ax, [DOS_ERR]
  1814 00001779 08C0                     or  al, al
  1815 0000177B 0F840900                 je @@getLine53
  1816 0000177F 68[E417]                 push getLine_0
  1817 00001782 E8460B                   call errorexit
  1818 00001785 83C402                   add  sp, 2
  1819                                  
  1820                                  ;-8     if (DOS_NoBytes == 0) return;
  1821                                  
  1822                                  @@getLine53:
  1823 00001788 A1[AB01]                 mov ax, [DOS_NoBytes]
  1824 0000178B 83F800                   cmp ax, 0
  1825 0000178E 0F850300                 jne @@getLine54
  1826 00001792 E94D00                   jmp @@retn
  1827                                  
  1828                                  ;-9     *InputPtr = DOS_ByteRead;
  1829                                  
  1830                                  @@getLine54:
  1831 00001795 A0[AD01]                 mov al, [DOS_ByteRead]
  1832 00001798 8B1E[D600]               mov  bx, [InputPtr]
  1833 0000179C 8807                     mov  [bx], al
  1834                                  
  1835                                  ;-10     InputPtr++;
  1836                                  
  1837 0000179E FF06[D600]               inc  word [InputPtr]
  1838                                  
  1839                                  ;-11     i = InputPtr - &InputBuf;
  1840                                  
  1841 000017A2 A1[D600]                 mov ax, [InputPtr]
  1842 000017A5 2D[5700]                 sub ax, InputBuf
  1843 000017A8 8946FE                   mov word [bp-2], ax
  1844                                  
  1845                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  1846                                  
  1847 000017AB 8B46FE                   mov ax, [bp-2]
  1848 000017AE 83F87F                   cmp ax, 127 ;unsigned : 0
  1849 000017B1 0F820900                 jb  @@getLine55
  1850 000017B5 68[F317]                 push getLine_1
  1851 000017B8 E8100B                   call errorexit
  1852 000017BB 83C402                   add  sp, 2
  1853                                  
  1854                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  1855                                  
  1856                                  @@getLine55:
  1857 000017BE A0[AD01]                 mov al, byte [DOS_ByteRead]
  1858 000017C1 B400                     mov ah, 0
  1859 000017C3 50                       push ax
  1860 000017C4 E84000                   call ifEOL
  1861 000017C7 83C402                   add  sp, 2
  1862 000017CA 3C00                     cmp al, 0
  1863 000017CC 0F850200                 jne @@getLine56
  1864 000017D0 EB90                     jmp @@getLine52
  1865                                  @@getLine56:
  1866                                  
  1867                                  ;-14   InputPtr--;
  1868                                  
  1869 000017D2 FF0E[D600]               dec  word [InputPtr]
  1870                                  
  1871                                  ;-15   *InputPtr=0;
  1872                                  
  1873 000017D6 66B800000000             mov eax, 0
  1874 000017DC 8B1E[D600]               mov  bx, [InputPtr]
  1875 000017E0 8807                     mov  [bx], al
  1876                                  
  1877                                  ;-16 }
  1878                                  
  1879                                  
  1880                                  ;-17 int ifEOL(char c) {
  1881                                  
  1882 000017E2 C9                      @@retn: LEAVE
  1883 000017E3 C3                       ret
  1884                                  ; ENDP
  1885 000017E4 52656164696E672053-     getLine_0 db "Reading Source",0
  1886 000017ED 6F7572636500       
  1887 000017F3 696E707574206C696E-     getLine_1 db "input line too long",0
  1888 000017FC 6520746F6F206C6F6E-
  1889 00001805 6700               
  1890                                  
  1891                                  ifEOL:  ; *** PROC ***
  1892                                  
  1893                                  ;-18   if (c == 10) return 1;
  1894                                  
  1895                                  ;Function : ifEOL, Number of local variables: 1
  1896                                  ;   # type sign width line used address name   list of local variables
  1897                                  ;  200 var sign byte    17 NULL bp+4    c;
  1898 00001807 C8000000                 ENTER  0,0
  1899 0000180B 8A4604                   mov al, [bp+4]
  1900 0000180E 3C0A                     cmp al, 10
  1901 00001810 0F850900                 jne @@ifEOL57
  1902 00001814 66B801000000             mov eax, 1
  1903 0000181A E92F00                   jmp @@retn
  1904                                  
  1905                                  ;-19   if (c == 13) {
  1906                                  
  1907                                  @@ifEOL57:
  1908 0000181D 8A4604                   mov al, [bp+4]
  1909 00001820 3C0D                     cmp al, 13
  1910 00001822 0F851D00                 jne @@ifEOL58
  1911                                  
  1912                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1913                                  
  1914 00001826 6A01                     push 1
  1915 00001828 FF36[A101]               push word [asm_fd]
  1916 0000182C 8D06[AD01]               lea  ax, [DOS_ByteRead]
  1917 00001830 50                       push ax
  1918 00001831 E8961A                   call readRL
  1919 00001834 83C406                   add  sp, 6
  1920 00001837 A3[AB01]                 mov word [DOS_NoBytes], ax
  1921                                  
  1922                                  ;-21     return 1;}
  1923                                  
  1924 0000183A 66B801000000             mov eax, 1
  1925 00001840 E90900                   jmp @@retn
  1926                                  
  1927                                  ;-22   return 0;
  1928                                  
  1929                                  @@ifEOL58:
  1930 00001843 66B800000000             mov eax, 0
  1931 00001849 E90000                   jmp @@retn
  1932                                  
  1933                                  ;-23 }
  1934                                  
  1935                                  
  1936                                  ;-24 int skipBlank() {
  1937                                  
  1938 0000184C C9                      @@retn: LEAVE
  1939 0000184D C3                       ret
  1940                                  ; ENDP
  1941                                  
  1942                                  skipBlank:  ; *** PROC ***
  1943                                  
  1944                                  ;-25   skipblank1:
  1945                                  
  1946                                  @@skipblank1:
  1947                                  
  1948                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  1949                                  
  1950 0000184E 8B1E[D600]               mov bx, [InputPtr]
  1951 00001852 8A07                     mov al, [bx]
  1952 00001854 B400                     mov ah, 0
  1953 00001856 83F820                   cmp ax, 32
  1954 00001859 0F850600                 jne @@skipBlank59
  1955 0000185D FF06[D600]               inc  word [InputPtr]
  1956 00001861 EBEB                     jmp @@skipblank1
  1957                                  
  1958                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  1959                                  
  1960                                  @@skipBlank59:
  1961 00001863 8B1E[D600]               mov bx, [InputPtr]
  1962 00001867 8A07                     mov al, [bx]
  1963 00001869 B400                     mov ah, 0
  1964 0000186B 83F809                   cmp ax, 9
  1965 0000186E 0F850600                 jne @@skipBlank60
  1966 00001872 FF06[D600]               inc  word [InputPtr]
  1967 00001876 EBD6                     jmp @@skipblank1
  1968                                  
  1969                                  ;-28 }
  1970                                  
  1971                                  @@skipBlank60:
  1972                                  
  1973                                  ;-29 int letterE(char c) {
  1974                                  
  1975 00001878 C3                       ret
  1976                                  ; ENDP
  1977                                  
  1978                                  letterE:  ; *** PROC ***
  1979                                  
  1980                                  ;-30   if (c=='_') return 1;
  1981                                  
  1982                                  ;Function : letterE, Number of local variables: 1
  1983                                  ;   # type sign width line used address name   list of local variables
  1984                                  ;  200 var sign byte    29 NULL bp+4    c;
  1985 00001879 C8000000                 ENTER  0,0
  1986 0000187D 8A4604                   mov al, [bp+4]
  1987 00001880 3C5F                     cmp al, 95
  1988 00001882 0F850900                 jne @@letterE61
  1989 00001886 66B801000000             mov eax, 1
  1990 0000188C E97E00                   jmp @@retn
  1991                                  
  1992                                  ;-31   if (c=='.') return 1;
  1993                                  
  1994                                  @@letterE61:
  1995 0000188F 8A4604                   mov al, [bp+4]
  1996 00001892 3C2E                     cmp al, 46
  1997 00001894 0F850900                 jne @@letterE62
  1998 00001898 66B801000000             mov eax, 1
  1999 0000189E E96C00                   jmp @@retn
  2000                                  
  2001                                  ;-32   if (c=='?') return 1;
  2002                                  
  2003                                  @@letterE62:
  2004 000018A1 8A4604                   mov al, [bp+4]
  2005 000018A4 3C3F                     cmp al, 63
  2006 000018A6 0F850900                 jne @@letterE63
  2007 000018AA 66B801000000             mov eax, 1
  2008 000018B0 E95A00                   jmp @@retn
  2009                                  
  2010                                  ;-33   if (c=='$') return 1;
  2011                                  
  2012                                  @@letterE63:
  2013 000018B3 8A4604                   mov al, [bp+4]
  2014 000018B6 3C24                     cmp al, 36
  2015 000018B8 0F850900                 jne @@letterE64
  2016 000018BC 66B801000000             mov eax, 1
  2017 000018C2 E94800                   jmp @@retn
  2018                                  
  2019                                  ;-34   if (c> 'z') return 0;
  2020                                  
  2021                                  @@letterE64:
  2022 000018C5 8A4604                   mov al, [bp+4]
  2023 000018C8 3C7A                     cmp al, 122
  2024 000018CA 0F8E0900                 jle @@letterE65
  2025 000018CE 66B800000000             mov eax, 0
  2026 000018D4 E93600                   jmp @@retn
  2027                                  
  2028                                  ;-35   if (c< '@') return 0; // at included
  2029                                  
  2030                                  @@letterE65:
  2031 000018D7 8A4604                   mov al, [bp+4]
  2032 000018DA 3C40                     cmp al, 64
  2033 000018DC 0F8D0900                 jge @@letterE66
  2034 000018E0 66B800000000             mov eax, 0
  2035 000018E6 E92400                   jmp @@retn
  2036                                  
  2037                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2038                                  
  2039                                  @@letterE66:
  2040 000018E9 8A4604                   mov al, [bp+4]
  2041 000018EC 3C5A                     cmp al, 90
  2042 000018EE 0F8E1200                 jle @@letterE67
  2043 000018F2 8A4604                   mov al, [bp+4]
  2044 000018F5 3C61                     cmp al, 97
  2045 000018F7 0F8D0900                 jge @@letterE68
  2046 000018FB 66B800000000             mov eax, 0
  2047 00001901 E90900                   jmp @@retn
  2048                                  @@letterE68:
  2049                                  
  2050                                  ;-37   return 1;
  2051                                  
  2052                                  @@letterE67:
  2053 00001904 66B801000000             mov eax, 1
  2054 0000190A E90000                   jmp @@retn
  2055                                  
  2056                                  ;-38 }
  2057                                  
  2058                                  
  2059                                  ;-39 int alnumE(char c) {
  2060                                  
  2061 0000190D C9                      @@retn: LEAVE
  2062 0000190E C3                       ret
  2063                                  ; ENDP
  2064                                  
  2065                                  alnumE:  ; *** PROC ***
  2066                                  
  2067                                  ;-40   if (digit(c)) return 1;
  2068                                  
  2069                                  ;Function : alnumE, Number of local variables: 1
  2070                                  ;   # type sign width line used address name   list of local variables
  2071                                  ;  200 var sign byte    39 NULL bp+4    c;
  2072 0000190F C8000000                 ENTER  0,0
  2073 00001913 8A4604                   mov al, byte [bp+4]
  2074 00001916 B400                     mov ah, 0
  2075 00001918 50                       push ax
  2076 00001919 E8E018                   call digit
  2077 0000191C 83C402                   add  sp, 2
  2078 0000191F 08C0                     or  al, al
  2079 00001921 0F840900                 je @@alnumE69
  2080 00001925 66B801000000             mov eax, 1
  2081 0000192B E92400                   jmp @@retn
  2082                                  
  2083                                  ;-41   if (letterE(c)) return 1;
  2084                                  
  2085                                  @@alnumE69:
  2086 0000192E 8A4604                   mov al, byte [bp+4]
  2087 00001931 B400                     mov ah, 0
  2088 00001933 50                       push ax
  2089 00001934 E842FF                   call letterE
  2090 00001937 83C402                   add  sp, 2
  2091 0000193A 08C0                     or  al, al
  2092 0000193C 0F840900                 je @@alnumE70
  2093 00001940 66B801000000             mov eax, 1
  2094 00001946 E90900                   jmp @@retn
  2095                                  
  2096                                  ;-42   return 0;
  2097                                  
  2098                                  @@alnumE70:
  2099 00001949 66B800000000             mov eax, 0
  2100 0000194F E90000                   jmp @@retn
  2101                                  
  2102                                  ;-43 }
  2103                                  
  2104                                  
  2105                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2106                                  
  2107 00001952 C9                      @@retn: LEAVE
  2108 00001953 C3                       ret
  2109                                  ; ENDP
  2110                                  
  2111                                  getDigit:  ; *** PROC ***
  2112                                  
  2113                                  ;-45   unsigned int CastInt;
  2114                                  
  2115                                  
  2116                                  ;-46   SymbolInt=0;
  2117                                  
  2118                                  ;Function : getDigit, Number of local variables: 2
  2119                                  ;   # type sign width line used address name   list of local variables
  2120                                  ;  200 var unsg byte    44 NULL bp+4    c
  2121                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  2122 00001954 C8020000                 ENTER  2,0
  2123 00001958 66B800000000             mov eax, 0
  2124 0000195E A3[5500]                 mov word [SymbolInt], ax
  2125                                  
  2126                                  ;-47   do {
  2127                                  
  2128                                  @@getDigit71:
  2129                                  
  2130                                  ;-48     c-='0';
  2131                                  
  2132 00001961 806E0430                 sub  byte [bp+4], 48
  2133                                  
  2134                                  ;-49     SymbolInt=SymbolInt*10;
  2135                                  
  2136 00001965 A1[5500]                 mov ax, [SymbolInt]
  2137 00001968 66BB0A000000             mov ebx, 10
  2138 0000196E 66F7E3                   mul ebx
  2139 00001971 A3[5500]                 mov word [SymbolInt], ax
  2140                                  
  2141                                  ;-50     ax=0; CastInt=c; //cast b2w
  2142                                  
  2143 00001974 B80000                   mov  ax, 0
  2144 00001977 8A4604                   mov al, [bp+4]
  2145 0000197A 8946FE                   mov word [bp-2], ax
  2146                                  
  2147                                  ;-51     SymbolInt=SymbolInt+CastInt;
  2148                                  
  2149 0000197D A1[5500]                 mov ax, [SymbolInt]
  2150 00001980 0346FE                   add ax, [bp-2]
  2151 00001983 A3[5500]                 mov word [SymbolInt], ax
  2152                                  
  2153                                  ;-52     InputPtr++;
  2154                                  
  2155 00001986 FF06[D600]               inc  word [InputPtr]
  2156                                  
  2157                                  ;-53     c = *InputPtr;
  2158                                  
  2159 0000198A 8B1E[D600]               mov bx, [InputPtr]
  2160 0000198E 8A07                     mov al, [bx]
  2161 00001990 B400                     mov ah, 0
  2162 00001992 884604                   mov byte [bp+4], al
  2163                                  
  2164                                  ;-54   } while(digit(c));
  2165                                  
  2166 00001995 8A4604                   mov al, byte [bp+4]
  2167 00001998 B400                     mov ah, 0
  2168 0000199A 50                       push ax
  2169 0000199B E85E18                   call digit
  2170 0000199E 83C402                   add  sp, 2
  2171 000019A1 08C0                     or  al, al
  2172 000019A3 0F840200                 je @@getDigit72
  2173 000019A7 EBB8                     jmp @@getDigit71
  2174                                  @@getDigit72:
  2175                                  
  2176                                  ;-55 }
  2177                                  
  2178                                  
  2179                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2180 000019A9 C9                       LEAVE
  2181 000019AA C3                       ret
  2182                                  ; ENDP
  2183                                  
  2184                                  getName:  ; *** PROC ***
  2185                                  
  2186                                  ;-57   char *p; unsigned int i;
  2187                                  
  2188                                  
  2189                                  ;-58   p = &Symbol;
  2190                                  
  2191                                  ;Function : getName, Number of local variables: 3
  2192                                  ;   # type sign width line used address name   list of local variables
  2193                                  ;  200 var unsg byte    56 NULL bp+4    c
  2194                                  ;  201 ptr sign byte    57 NULL bp-2    p
  2195                                  ;  202 var unsg word    57 NULL bp-4    i;
  2196 000019AB C8040000                 ENTER  4,0
  2197 000019AF B8[1700]                 mov ax, Symbol
  2198 000019B2 8946FE                   mov word [bp-2], ax
  2199                                  
  2200                                  ;-59   *p = c;
  2201                                  
  2202 000019B5 8A4604                   mov al, [bp+4]
  2203 000019B8 8B5EFE                   mov  bx, [bp-2]
  2204 000019BB 8807                     mov  [bx], al
  2205                                  
  2206                                  ;-60   p++;
  2207                                  
  2208 000019BD FF46FE                   inc  word [bp-2]
  2209                                  
  2210                                  ;-61   while (alnumE(c)) {
  2211                                  
  2212                                  @@getName73:
  2213 000019C0 8A4604                   mov al, byte [bp+4]
  2214 000019C3 B400                     mov ah, 0
  2215 000019C5 50                       push ax
  2216 000019C6 E846FF                   call alnumE
  2217 000019C9 83C402                   add  sp, 2
  2218 000019CC 08C0                     or  al, al
  2219 000019CE 0F843800                 je @@getName74
  2220                                  
  2221                                  ;-62     InputPtr++;
  2222                                  
  2223 000019D2 FF06[D600]               inc  word [InputPtr]
  2224                                  
  2225                                  ;-63     c = *InputPtr;
  2226                                  
  2227 000019D6 8B1E[D600]               mov bx, [InputPtr]
  2228 000019DA 8A07                     mov al, [bx]
  2229 000019DC B400                     mov ah, 0
  2230 000019DE 884604                   mov byte [bp+4], al
  2231                                  
  2232                                  ;-64     *p = c;
  2233                                  
  2234 000019E1 8A4604                   mov al, [bp+4]
  2235 000019E4 8B5EFE                   mov  bx, [bp-2]
  2236 000019E7 8807                     mov  [bx], al
  2237                                  
  2238                                  ;-65     p++;
  2239                                  
  2240 000019E9 FF46FE                   inc  word [bp-2]
  2241                                  
  2242                                  ;-66     i = p - &Symbol;
  2243                                  
  2244 000019EC 8B46FE                   mov ax, [bp-2]
  2245 000019EF 2D[1700]                 sub ax, Symbol
  2246 000019F2 8946FC                   mov word [bp-4], ax
  2247                                  
  2248                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  2249                                  
  2250 000019F5 8B46FC                   mov ax, [bp-4]
  2251 000019F8 83F81F                   cmp ax, 31 ;unsigned : 0
  2252 000019FB 0F820900                 jb  @@getName75
  2253 000019FF 68[531A]                 push getName_0
  2254 00001A02 E8C608                   call errorexit
  2255 00001A05 83C402                   add  sp, 2
  2256                                  
  2257                                  ;-68   }
  2258                                  
  2259                                  @@getName75:
  2260                                  
  2261                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  2262                                  
  2263 00001A08 EBB6                     jmp @@getName73
  2264                                  @@getName74:
  2265 00001A0A 8A4604                   mov al, [bp+4]
  2266 00001A0D 3C3A                     cmp al, 58
  2267 00001A0F 0F850C00                 jne @@getName76
  2268 00001A13 66B801000000             mov eax, 1
  2269 00001A19 A2[B201]                 mov byte [isLabel], al
  2270 00001A1C E90900                   jmp @@getName77
  2271                                  @@getName76:
  2272 00001A1F 66B800000000             mov eax, 0
  2273 00001A25 A2[B201]                 mov byte [isLabel], al
  2274                                  
  2275                                  ;-70   p--;
  2276                                  
  2277                                  @@getName77:
  2278 00001A28 FF4EFE                   dec  word [bp-2]
  2279                                  
  2280                                  ;-71   *p = 0;
  2281                                  
  2282 00001A2B 66B800000000             mov eax, 0
  2283 00001A31 8B5EFE                   mov  bx, [bp-2]
  2284 00001A34 8807                     mov  [bx], al
  2285                                  
  2286                                  ;-72   strcpy(SymbolUpper, Symbol);
  2287                                  
  2288 00001A36 8D06[1700]               lea  ax, [Symbol]
  2289 00001A3A 50                       push ax
  2290 00001A3B 8D06[3600]               lea  ax, [SymbolUpper]
  2291 00001A3F 50                       push ax
  2292 00001A40 E88017                   call strcpy
  2293 00001A43 83C404                   add  sp, 4
  2294                                  
  2295                                  ;-73   toupper(SymbolUpper);
  2296                                  
  2297 00001A46 8D06[3600]               lea  ax, [SymbolUpper]
  2298 00001A4A 50                       push ax
  2299 00001A4B E80717                   call toupper
  2300 00001A4E 83C402                   add  sp, 2
  2301                                  
  2302                                  ;-74 }
  2303                                  
  2304                                  
  2305                                  ;-75 int testReg() {
  2306 00001A51 C9                       LEAVE
  2307 00001A52 C3                       ret
  2308                                  ; ENDP
  2309 00001A53 73796D626F6C20746F-     getName_0 db "symbol too long",0
  2310 00001A5C 6F206C6F6E6700     
  2311                                  
  2312                                  testReg:  ; *** PROC ***
  2313                                  
  2314                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2315                                  
  2316                                  
  2317                                  ;-77   RegType=0;
  2318                                  
  2319 00001A63 66B800000000             mov eax, 0
  2320 00001A69 A2[BC01]                 mov byte [RegType], al
  2321                                  
  2322                                  ;-78   if (strlen(Symbol) < 2) return 0;
  2323                                  
  2324 00001A6C 8D06[1700]               lea  ax, [Symbol]
  2325 00001A70 50                       push ax
  2326 00001A71 E82417                   call strlen
  2327 00001A74 83C402                   add  sp, 2
  2328 00001A77 3C02                     cmp al, 2
  2329 00001A79 0F8D0900                 jge @@testReg78
  2330 00001A7D 66B800000000             mov eax, 0
  2331 00001A83 E9B603                   jmp @@retn
  2332                                  
  2333                                  ;-79   if (strlen(Symbol) > 3) return 0;
  2334                                  
  2335                                  @@testReg78:
  2336 00001A86 8D06[1700]               lea  ax, [Symbol]
  2337 00001A8A 50                       push ax
  2338 00001A8B E80A17                   call strlen
  2339 00001A8E 83C402                   add  sp, 2
  2340 00001A91 3C03                     cmp al, 3
  2341 00001A93 0F8E0900                 jle @@testReg79
  2342 00001A97 66B800000000             mov eax, 0
  2343 00001A9D E99C03                   jmp @@retn
  2344                                  
  2345                                  ;-80   RegType=BYTE;
  2346                                  
  2347                                  @@testReg79:
  2348 00001AA0 66B801000000             mov eax, 1
  2349 00001AA6 A2[BC01]                 mov byte [RegType], al
  2350                                  
  2351                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  2352                                  
  2353 00001AA9 68[3D1E]                 push testReg_0
  2354 00001AAC 8D06[3600]               lea  ax, [SymbolUpper]
  2355 00001AB0 50                       push ax
  2356 00001AB1 E87B17                   call eqstr
  2357 00001AB4 83C404                   add  sp, 4
  2358 00001AB7 08C0                     or  al, al
  2359 00001AB9 0F840900                 je @@testReg80
  2360 00001ABD 66B800000000             mov eax, 0
  2361 00001AC3 E97603                   jmp @@retn
  2362                                  
  2363                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  2364                                  
  2365                                  @@testReg80:
  2366 00001AC6 68[401E]                 push testReg_1
  2367 00001AC9 8D06[3600]               lea  ax, [SymbolUpper]
  2368 00001ACD 50                       push ax
  2369 00001ACE E85E17                   call eqstr
  2370 00001AD1 83C404                   add  sp, 4
  2371 00001AD4 08C0                     or  al, al
  2372 00001AD6 0F840900                 je @@testReg81
  2373 00001ADA 66B801000000             mov eax, 1
  2374 00001AE0 E95903                   jmp @@retn
  2375                                  
  2376                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  2377                                  
  2378                                  @@testReg81:
  2379 00001AE3 68[431E]                 push testReg_2
  2380 00001AE6 8D06[3600]               lea  ax, [SymbolUpper]
  2381 00001AEA 50                       push ax
  2382 00001AEB E84117                   call eqstr
  2383 00001AEE 83C404                   add  sp, 4
  2384 00001AF1 08C0                     or  al, al
  2385 00001AF3 0F840900                 je @@testReg82
  2386 00001AF7 66B802000000             mov eax, 2
  2387 00001AFD E93C03                   jmp @@retn
  2388                                  
  2389                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  2390                                  
  2391                                  @@testReg82:
  2392 00001B00 68[461E]                 push testReg_3
  2393 00001B03 8D06[3600]               lea  ax, [SymbolUpper]
  2394 00001B07 50                       push ax
  2395 00001B08 E82417                   call eqstr
  2396 00001B0B 83C404                   add  sp, 4
  2397 00001B0E 08C0                     or  al, al
  2398 00001B10 0F840900                 je @@testReg83
  2399 00001B14 66B803000000             mov eax, 3
  2400 00001B1A E91F03                   jmp @@retn
  2401                                  
  2402                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  2403                                  
  2404                                  @@testReg83:
  2405 00001B1D 68[491E]                 push testReg_4
  2406 00001B20 8D06[3600]               lea  ax, [SymbolUpper]
  2407 00001B24 50                       push ax
  2408 00001B25 E80717                   call eqstr
  2409 00001B28 83C404                   add  sp, 4
  2410 00001B2B 08C0                     or  al, al
  2411 00001B2D 0F840900                 je @@testReg84
  2412 00001B31 66B804000000             mov eax, 4
  2413 00001B37 E90203                   jmp @@retn
  2414                                  
  2415                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  2416                                  
  2417                                  @@testReg84:
  2418 00001B3A 68[4C1E]                 push testReg_5
  2419 00001B3D 8D06[3600]               lea  ax, [SymbolUpper]
  2420 00001B41 50                       push ax
  2421 00001B42 E8EA16                   call eqstr
  2422 00001B45 83C404                   add  sp, 4
  2423 00001B48 08C0                     or  al, al
  2424 00001B4A 0F840900                 je @@testReg85
  2425 00001B4E 66B805000000             mov eax, 5
  2426 00001B54 E9E502                   jmp @@retn
  2427                                  
  2428                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  2429                                  
  2430                                  @@testReg85:
  2431 00001B57 68[4F1E]                 push testReg_6
  2432 00001B5A 8D06[3600]               lea  ax, [SymbolUpper]
  2433 00001B5E 50                       push ax
  2434 00001B5F E8CD16                   call eqstr
  2435 00001B62 83C404                   add  sp, 4
  2436 00001B65 08C0                     or  al, al
  2437 00001B67 0F840900                 je @@testReg86
  2438 00001B6B 66B806000000             mov eax, 6
  2439 00001B71 E9C802                   jmp @@retn
  2440                                  
  2441                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  2442                                  
  2443                                  @@testReg86:
  2444 00001B74 68[521E]                 push testReg_7
  2445 00001B77 8D06[3600]               lea  ax, [SymbolUpper]
  2446 00001B7B 50                       push ax
  2447 00001B7C E8B016                   call eqstr
  2448 00001B7F 83C404                   add  sp, 4
  2449 00001B82 08C0                     or  al, al
  2450 00001B84 0F840900                 je @@testReg87
  2451 00001B88 66B807000000             mov eax, 7
  2452 00001B8E E9AB02                   jmp @@retn
  2453                                  
  2454                                  ;-89   RegType=WORD;
  2455                                  
  2456                                  @@testReg87:
  2457 00001B91 66B802000000             mov eax, 2
  2458 00001B97 A2[BC01]                 mov byte [RegType], al
  2459                                  
  2460                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  2461                                  
  2462 00001B9A 68[551E]                 push testReg_8
  2463 00001B9D 8D06[3600]               lea  ax, [SymbolUpper]
  2464 00001BA1 50                       push ax
  2465 00001BA2 E88A16                   call eqstr
  2466 00001BA5 83C404                   add  sp, 4
  2467 00001BA8 08C0                     or  al, al
  2468 00001BAA 0F840900                 je @@testReg88
  2469 00001BAE 66B800000000             mov eax, 0
  2470 00001BB4 E98502                   jmp @@retn
  2471                                  
  2472                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  2473                                  
  2474                                  @@testReg88:
  2475 00001BB7 68[581E]                 push testReg_9
  2476 00001BBA 8D06[3600]               lea  ax, [SymbolUpper]
  2477 00001BBE 50                       push ax
  2478 00001BBF E86D16                   call eqstr
  2479 00001BC2 83C404                   add  sp, 4
  2480 00001BC5 08C0                     or  al, al
  2481 00001BC7 0F840900                 je @@testReg89
  2482 00001BCB 66B801000000             mov eax, 1
  2483 00001BD1 E96802                   jmp @@retn
  2484                                  
  2485                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  2486                                  
  2487                                  @@testReg89:
  2488 00001BD4 68[5B1E]                 push testReg_10
  2489 00001BD7 8D06[3600]               lea  ax, [SymbolUpper]
  2490 00001BDB 50                       push ax
  2491 00001BDC E85016                   call eqstr
  2492 00001BDF 83C404                   add  sp, 4
  2493 00001BE2 08C0                     or  al, al
  2494 00001BE4 0F840900                 je @@testReg90
  2495 00001BE8 66B802000000             mov eax, 2
  2496 00001BEE E94B02                   jmp @@retn
  2497                                  
  2498                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  2499                                  
  2500                                  @@testReg90:
  2501 00001BF1 68[5E1E]                 push testReg_11
  2502 00001BF4 8D06[3600]               lea  ax, [SymbolUpper]
  2503 00001BF8 50                       push ax
  2504 00001BF9 E83316                   call eqstr
  2505 00001BFC 83C404                   add  sp, 4
  2506 00001BFF 08C0                     or  al, al
  2507 00001C01 0F840900                 je @@testReg91
  2508 00001C05 66B803000000             mov eax, 3
  2509 00001C0B E92E02                   jmp @@retn
  2510                                  
  2511                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  2512                                  
  2513                                  @@testReg91:
  2514 00001C0E 68[611E]                 push testReg_12
  2515 00001C11 8D06[3600]               lea  ax, [SymbolUpper]
  2516 00001C15 50                       push ax
  2517 00001C16 E81616                   call eqstr
  2518 00001C19 83C404                   add  sp, 4
  2519 00001C1C 08C0                     or  al, al
  2520 00001C1E 0F840900                 je @@testReg92
  2521 00001C22 66B804000000             mov eax, 4
  2522 00001C28 E91102                   jmp @@retn
  2523                                  
  2524                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  2525                                  
  2526                                  @@testReg92:
  2527 00001C2B 68[641E]                 push testReg_13
  2528 00001C2E 8D06[3600]               lea  ax, [SymbolUpper]
  2529 00001C32 50                       push ax
  2530 00001C33 E8F915                   call eqstr
  2531 00001C36 83C404                   add  sp, 4
  2532 00001C39 08C0                     or  al, al
  2533 00001C3B 0F840900                 je @@testReg93
  2534 00001C3F 66B805000000             mov eax, 5
  2535 00001C45 E9F401                   jmp @@retn
  2536                                  
  2537                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  2538                                  
  2539                                  @@testReg93:
  2540 00001C48 68[671E]                 push testReg_14
  2541 00001C4B 8D06[3600]               lea  ax, [SymbolUpper]
  2542 00001C4F 50                       push ax
  2543 00001C50 E8DC15                   call eqstr
  2544 00001C53 83C404                   add  sp, 4
  2545 00001C56 08C0                     or  al, al
  2546 00001C58 0F840900                 je @@testReg94
  2547 00001C5C 66B806000000             mov eax, 6
  2548 00001C62 E9D701                   jmp @@retn
  2549                                  
  2550                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  2551                                  
  2552                                  @@testReg94:
  2553 00001C65 68[6A1E]                 push testReg_15
  2554 00001C68 8D06[3600]               lea  ax, [SymbolUpper]
  2555 00001C6C 50                       push ax
  2556 00001C6D E8BF15                   call eqstr
  2557 00001C70 83C404                   add  sp, 4
  2558 00001C73 08C0                     or  al, al
  2559 00001C75 0F840900                 je @@testReg95
  2560 00001C79 66B807000000             mov eax, 7
  2561 00001C7F E9BA01                   jmp @@retn
  2562                                  
  2563                                  ;-98   RegType=SEGREG;
  2564                                  
  2565                                  @@testReg95:
  2566 00001C82 66B804000000             mov eax, 4
  2567 00001C88 A2[BC01]                 mov byte [RegType], al
  2568                                  
  2569                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  2570                                  
  2571 00001C8B 68[6D1E]                 push testReg_16
  2572 00001C8E 8D06[3600]               lea  ax, [SymbolUpper]
  2573 00001C92 50                       push ax
  2574 00001C93 E89915                   call eqstr
  2575 00001C96 83C404                   add  sp, 4
  2576 00001C99 08C0                     or  al, al
  2577 00001C9B 0F840900                 je @@testReg96
  2578 00001C9F 66B800000000             mov eax, 0
  2579 00001CA5 E99401                   jmp @@retn
  2580                                  
  2581                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  2582                                  
  2583                                  @@testReg96:
  2584 00001CA8 68[701E]                 push testReg_17
  2585 00001CAB 8D06[3600]               lea  ax, [SymbolUpper]
  2586 00001CAF 50                       push ax
  2587 00001CB0 E87C15                   call eqstr
  2588 00001CB3 83C404                   add  sp, 4
  2589 00001CB6 08C0                     or  al, al
  2590 00001CB8 0F840900                 je @@testReg97
  2591 00001CBC 66B801000000             mov eax, 1
  2592 00001CC2 E97701                   jmp @@retn
  2593                                  
  2594                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  2595                                  
  2596                                  @@testReg97:
  2597 00001CC5 68[731E]                 push testReg_18
  2598 00001CC8 8D06[3600]               lea  ax, [SymbolUpper]
  2599 00001CCC 50                       push ax
  2600 00001CCD E85F15                   call eqstr
  2601 00001CD0 83C404                   add  sp, 4
  2602 00001CD3 08C0                     or  al, al
  2603 00001CD5 0F840900                 je @@testReg98
  2604 00001CD9 66B802000000             mov eax, 2
  2605 00001CDF E95A01                   jmp @@retn
  2606                                  
  2607                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  2608                                  
  2609                                  @@testReg98:
  2610 00001CE2 68[761E]                 push testReg_19
  2611 00001CE5 8D06[3600]               lea  ax, [SymbolUpper]
  2612 00001CE9 50                       push ax
  2613 00001CEA E84215                   call eqstr
  2614 00001CED 83C404                   add  sp, 4
  2615 00001CF0 08C0                     or  al, al
  2616 00001CF2 0F840900                 je @@testReg99
  2617 00001CF6 66B803000000             mov eax, 3
  2618 00001CFC E93D01                   jmp @@retn
  2619                                  
  2620                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  2621                                  
  2622                                  @@testReg99:
  2623 00001CFF 68[791E]                 push testReg_20
  2624 00001D02 8D06[3600]               lea  ax, [SymbolUpper]
  2625 00001D06 50                       push ax
  2626 00001D07 E82515                   call eqstr
  2627 00001D0A 83C404                   add  sp, 4
  2628 00001D0D 08C0                     or  al, al
  2629 00001D0F 0F840900                 je @@testReg100
  2630 00001D13 66B804000000             mov eax, 4
  2631 00001D19 E92001                   jmp @@retn
  2632                                  
  2633                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  2634                                  
  2635                                  @@testReg100:
  2636 00001D1C 68[7C1E]                 push testReg_21
  2637 00001D1F 8D06[3600]               lea  ax, [SymbolUpper]
  2638 00001D23 50                       push ax
  2639 00001D24 E80815                   call eqstr
  2640 00001D27 83C404                   add  sp, 4
  2641 00001D2A 08C0                     or  al, al
  2642 00001D2C 0F840900                 je @@testReg101
  2643 00001D30 66B805000000             mov eax, 5
  2644 00001D36 E90301                   jmp @@retn
  2645                                  
  2646                                  ;-105   RegType=DWORD;
  2647                                  
  2648                                  @@testReg101:
  2649 00001D39 66B803000000             mov eax, 3
  2650 00001D3F A2[BC01]                 mov byte [RegType], al
  2651                                  
  2652                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  2653                                  
  2654 00001D42 68[7F1E]                 push testReg_22
  2655 00001D45 8D06[3600]               lea  ax, [SymbolUpper]
  2656 00001D49 50                       push ax
  2657 00001D4A E8E214                   call eqstr
  2658 00001D4D 83C404                   add  sp, 4
  2659 00001D50 08C0                     or  al, al
  2660 00001D52 0F840900                 je @@testReg102
  2661 00001D56 66B800000000             mov eax, 0
  2662 00001D5C E9DD00                   jmp @@retn
  2663                                  
  2664                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  2665                                  
  2666                                  @@testReg102:
  2667 00001D5F 68[831E]                 push testReg_23
  2668 00001D62 8D06[3600]               lea  ax, [SymbolUpper]
  2669 00001D66 50                       push ax
  2670 00001D67 E8C514                   call eqstr
  2671 00001D6A 83C404                   add  sp, 4
  2672 00001D6D 08C0                     or  al, al
  2673 00001D6F 0F840900                 je @@testReg103
  2674 00001D73 66B801000000             mov eax, 1
  2675 00001D79 E9C000                   jmp @@retn
  2676                                  
  2677                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  2678                                  
  2679                                  @@testReg103:
  2680 00001D7C 68[871E]                 push testReg_24
  2681 00001D7F 8D06[3600]               lea  ax, [SymbolUpper]
  2682 00001D83 50                       push ax
  2683 00001D84 E8A814                   call eqstr
  2684 00001D87 83C404                   add  sp, 4
  2685 00001D8A 08C0                     or  al, al
  2686 00001D8C 0F840900                 je @@testReg104
  2687 00001D90 66B802000000             mov eax, 2
  2688 00001D96 E9A300                   jmp @@retn
  2689                                  
  2690                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  2691                                  
  2692                                  @@testReg104:
  2693 00001D99 68[8B1E]                 push testReg_25
  2694 00001D9C 8D06[3600]               lea  ax, [SymbolUpper]
  2695 00001DA0 50                       push ax
  2696 00001DA1 E88B14                   call eqstr
  2697 00001DA4 83C404                   add  sp, 4
  2698 00001DA7 08C0                     or  al, al
  2699 00001DA9 0F840900                 je @@testReg105
  2700 00001DAD 66B803000000             mov eax, 3
  2701 00001DB3 E98600                   jmp @@retn
  2702                                  
  2703                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  2704                                  
  2705                                  @@testReg105:
  2706 00001DB6 68[8F1E]                 push testReg_26
  2707 00001DB9 8D06[3600]               lea  ax, [SymbolUpper]
  2708 00001DBD 50                       push ax
  2709 00001DBE E86E14                   call eqstr
  2710 00001DC1 83C404                   add  sp, 4
  2711 00001DC4 08C0                     or  al, al
  2712 00001DC6 0F840900                 je @@testReg106
  2713 00001DCA 66B804000000             mov eax, 4
  2714 00001DD0 E96900                   jmp @@retn
  2715                                  
  2716                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  2717                                  
  2718                                  @@testReg106:
  2719 00001DD3 68[931E]                 push testReg_27
  2720 00001DD6 8D06[3600]               lea  ax, [SymbolUpper]
  2721 00001DDA 50                       push ax
  2722 00001DDB E85114                   call eqstr
  2723 00001DDE 83C404                   add  sp, 4
  2724 00001DE1 08C0                     or  al, al
  2725 00001DE3 0F840900                 je @@testReg107
  2726 00001DE7 66B805000000             mov eax, 5
  2727 00001DED E94C00                   jmp @@retn
  2728                                  
  2729                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  2730                                  
  2731                                  @@testReg107:
  2732 00001DF0 68[971E]                 push testReg_28
  2733 00001DF3 8D06[3600]               lea  ax, [SymbolUpper]
  2734 00001DF7 50                       push ax
  2735 00001DF8 E83414                   call eqstr
  2736 00001DFB 83C404                   add  sp, 4
  2737 00001DFE 08C0                     or  al, al
  2738 00001E00 0F840900                 je @@testReg108
  2739 00001E04 66B806000000             mov eax, 6
  2740 00001E0A E92F00                   jmp @@retn
  2741                                  
  2742                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  2743                                  
  2744                                  @@testReg108:
  2745 00001E0D 68[9B1E]                 push testReg_29
  2746 00001E10 8D06[3600]               lea  ax, [SymbolUpper]
  2747 00001E14 50                       push ax
  2748 00001E15 E81714                   call eqstr
  2749 00001E18 83C404                   add  sp, 4
  2750 00001E1B 08C0                     or  al, al
  2751 00001E1D 0F840900                 je @@testReg109
  2752 00001E21 66B807000000             mov eax, 7
  2753 00001E27 E91200                   jmp @@retn
  2754                                  
  2755                                  ;-114   RegType=0; return 0;
  2756                                  
  2757                                  @@testReg109:
  2758 00001E2A 66B800000000             mov eax, 0
  2759 00001E30 A2[BC01]                 mov byte [RegType], al
  2760 00001E33 66B800000000             mov eax, 0
  2761 00001E39 E90000                   jmp @@retn
  2762                                  
  2763                                  ;-115 }
  2764                                  
  2765                                  @@retn:
  2766 00001E3C C3                       ret
  2767                                  ; ENDP
  2768 00001E3D 414C00                  testReg_0 db "AL",0
  2769 00001E40 434C00                  testReg_1 db "CL",0
  2770 00001E43 444C00                  testReg_2 db "DL",0
  2771 00001E46 424C00                  testReg_3 db "BL",0
  2772 00001E49 414800                  testReg_4 db "AH",0
  2773 00001E4C 434800                  testReg_5 db "CH",0
  2774 00001E4F 444800                  testReg_6 db "DH",0
  2775 00001E52 424800                  testReg_7 db "BH",0
  2776 00001E55 415800                  testReg_8 db "AX",0
  2777 00001E58 435800                  testReg_9 db "CX",0
  2778 00001E5B 445800                  testReg_10 db "DX",0
  2779 00001E5E 425800                  testReg_11 db "BX",0
  2780 00001E61 535000                  testReg_12 db "SP",0
  2781 00001E64 425000                  testReg_13 db "BP",0
  2782 00001E67 534900                  testReg_14 db "SI",0
  2783 00001E6A 444900                  testReg_15 db "DI",0
  2784 00001E6D 455300                  testReg_16 db "ES",0
  2785 00001E70 435300                  testReg_17 db "CS",0
  2786 00001E73 535300                  testReg_18 db "SS",0
  2787 00001E76 445300                  testReg_19 db "DS",0
  2788 00001E79 465300                  testReg_20 db "FS",0
  2789 00001E7C 475300                  testReg_21 db "GS",0
  2790 00001E7F 45415800                testReg_22 db "EAX",0
  2791 00001E83 45435800                testReg_23 db "ECX",0
  2792 00001E87 45445800                testReg_24 db "EDX",0
  2793 00001E8B 45425800                testReg_25 db "EBX",0
  2794 00001E8F 45535000                testReg_26 db "ESP",0
  2795 00001E93 45425000                testReg_27 db "EBP",0
  2796 00001E97 45534900                testReg_28 db "ESI",0
  2797 00001E9B 45444900                testReg_29 db "EDI",0
  2798                                  ;Back to main program: AS.C
  2799                                  
  2800                                  ;-7 #include "OUTPUT.C"
  2801                                  
  2802                                  ;Use include file: OUTPUT.C
  2803                                  
  2804                                  ;-1 int printLine() { int i; char c;
  2805                                  
  2806                                  
  2807                                  printLine:  ; *** PROC ***
  2808                                  
  2809                                  ;-2   prs("\n"); printhex16(PCStart);
  2810                                  
  2811                                  ;Function : printLine, Number of local variables: 2
  2812                                  ;   # type sign width line used address name   list of local variables
  2813                                  ;  200 var sign word     1 NULL bp-2    i
  2814                                  ;  201 var sign byte     1 NULL bp-4    c;
  2815 00001E9F C8040000                 ENTER  4,0
  2816 00001EA3 68[341F]                 push printLine_0
  2817 00001EA6 E80401                   call prs
  2818 00001EA9 83C402                   add  sp, 2
  2819 00001EAC FF36[B001]               push word [PCStart]
  2820 00001EB0 E8EB01                   call printhex16
  2821 00001EB3 83C402                   add  sp, 2
  2822                                  
  2823                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  2824                                  
  2825 00001EB6 A1[CC01]                 mov ax, [OpPrintIndex]
  2826 00001EB9 83F800                   cmp ax, 0
  2827 00001EBC 0F850C00                 jne @@printLine110
  2828 00001EC0 68[371F]                 push printLine_1
  2829 00001EC3 E8E700                   call prs
  2830 00001EC6 83C402                   add  sp, 2
  2831                                  
  2832                                  ;-4   else {
  2833                                  
  2834 00001EC9 E95B00                   jmp @@printLine111
  2835                                  @@printLine110:
  2836                                  
  2837                                  ;-5     prc(PrintR);
  2838                                  
  2839 00001ECC A0[D001]                 mov al, byte [PrintR]
  2840 00001ECF B400                     mov ah, 0
  2841 00001ED1 50                       push ax
  2842 00001ED2 E87700                   call prc
  2843 00001ED5 83C402                   add  sp, 2
  2844                                  
  2845                                  ;-6     i=0;
  2846                                  
  2847 00001ED8 66B800000000             mov eax, 0
  2848 00001EDE 8946FE                   mov word [bp-2], ax
  2849                                  
  2850                                  ;-7     do {
  2851                                  
  2852                                  @@printLine112:
  2853                                  
  2854                                  ;-8       c=OpPos[i];
  2855                                  
  2856 00001EE1 8B5EFE                   mov bx, [bp-2]
  2857 00001EE4 8A87[C701]               mov al, [OpPos + bx]
  2858 00001EE8 8846FC                   mov byte [bp-4], al
  2859                                  
  2860                                  ;-9       printhex8a(c); prc(' ');
  2861                                  
  2862 00001EEB 8A46FC                   mov al, byte [bp-4]
  2863 00001EEE B400                     mov ah, 0
  2864 00001EF0 50                       push ax
  2865 00001EF1 E85C01                   call printhex8a
  2866 00001EF4 83C402                   add  sp, 2
  2867 00001EF7 6A20                     push 32
  2868 00001EF9 E85000                   call prc
  2869 00001EFC 83C402                   add  sp, 2
  2870                                  
  2871                                  ;-10       i++;
  2872                                  
  2873 00001EFF FF46FE                   inc  word [bp-2]
  2874                                  
  2875                                  ;-11     } while(i < OpPrintIndex);
  2876                                  
  2877 00001F02 8B46FE                   mov ax, [bp-2]
  2878 00001F05 3B06[CC01]               cmp ax, [OpPrintIndex]
  2879 00001F09 0F8D0200                 jge @@printLine113
  2880 00001F0D EBD2                     jmp @@printLine112
  2881                                  @@printLine113:
  2882                                  
  2883                                  ;-12     do {// fill rest with blank
  2884                                  
  2885                                  @@printLine114:
  2886                                  
  2887                                  ;-13       prs("   ");
  2888                                  
  2889 00001F0F 68[481F]                 push printLine_2
  2890 00001F12 E89800                   call prs
  2891 00001F15 83C402                   add  sp, 2
  2892                                  
  2893                                  ;-14       i++;
  2894                                  
  2895 00001F18 FF46FE                   inc  word [bp-2]
  2896                                  
  2897                                  ;-15     } while(i < OPMAXLEN);
  2898                                  
  2899 00001F1B 8B46FE                   mov ax, [bp-2]
  2900 00001F1E 83F805                   cmp ax, 5
  2901 00001F21 0F8D0200                 jge @@printLine115
  2902 00001F25 EBE8                     jmp @@printLine114
  2903                                  @@printLine115:
  2904                                  
  2905                                  ;-16   }
  2906                                  
  2907                                  
  2908                                  ;-17   prscomment(InputBuf);
  2909                                  
  2910                                  @@printLine111:
  2911 00001F27 8D06[5700]               lea  ax, [InputBuf]
  2912 00001F2B 50                       push ax
  2913 00001F2C E85000                   call prscomment
  2914 00001F2F 83C402                   add  sp, 2
  2915                                  
  2916                                  ;-18 }
  2917                                  
  2918                                  
  2919                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  2920 00001F32 C9                       LEAVE
  2921 00001F33 C3                       ret
  2922                                  ; ENDP
  2923 00001F34 5C6E00                  printLine_0 db "\n",0
  2924 00001F37 202020202020202020-     printLine_1 db "                ",0
  2925 00001F40 2020202020202000   
  2926 00001F48 20202000                printLine_2 db "   ",0
  2927                                  
  2928                                  prc:  ; *** PROC ***
  2929                                  ;Function : prc, Number of local variables: 1
  2930                                  ;   # type sign width line used address name   list of local variables
  2931                                  ;  200 var unsg byte    19 NULL bp+4    c;
  2932 00001F4C C8000000                 ENTER  0,0
  2933 00001F50 A0[1600]                 mov al, [LIST]
  2934 00001F53 08C0                     or  al, al
  2935 00001F55 0F841400                 je @@prc116
  2936 00001F59 807E040A                cmp byte [bp+4], 10
  2937 00001F5D 0F850600                 jne @@prc117
  2938 00001F61 B80D00                   mov  ax, 13
  2939 00001F64 E8B811                   call writetty
  2940                                  
  2941                                  ;-20      al=c; writetty(); }
  2942                                  
  2943                                  @@prc117:
  2944 00001F67 8A4604                   mov  al, [bp+4]
  2945 00001F6A E8B211                   call writetty
  2946                                  
  2947                                  ;-21    fputcR(c,lst_fd); }
  2948                                  
  2949                                  @@prc116:
  2950 00001F6D FF36[A301]               push word [lst_fd]
  2951 00001F71 8A4604                   mov al, byte [bp+4]
  2952 00001F74 B400                     mov ah, 0
  2953 00001F76 50                       push ax
  2954 00001F77 E86513                   call fputcR
  2955 00001F7A 83C404                   add  sp, 4
  2956                                  
  2957                                  ;-22 
  2958                                  
  2959                                  
  2960                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  2961 00001F7D C9                       LEAVE
  2962 00001F7E C3                       ret
  2963                                  ; ENDP
  2964                                  
  2965                                  prscomment:  ; *** PROC ***
  2966                                  
  2967                                  ;-24   while(*s){c=*s;prc(c);s++;}
  2968                                  
  2969                                  ;Function : prscomment, Number of local variables: 2
  2970                                  ;   # type sign width line used address name   list of local variables
  2971                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  2972                                  ;  201 var unsg byte    23 NULL bp-2    c;
  2973 00001F7F C8020000                 ENTER  2,0
  2974                                  @@prscomment118:
  2975 00001F83 8B5E04                   mov bx, [bp+4]
  2976 00001F86 8A07                     mov al, [bx]
  2977 00001F88 B400                     mov ah, 0
  2978 00001F8A 08C0                     or  al, al
  2979 00001F8C 0F841B00                 je @@prscomment119
  2980 00001F90 8B5E04                   mov bx, [bp+4]
  2981 00001F93 8A07                     mov al, [bx]
  2982 00001F95 B400                     mov ah, 0
  2983 00001F97 8846FE                   mov byte [bp-2], al
  2984 00001F9A 8A46FE                   mov al, byte [bp-2]
  2985 00001F9D B400                     mov ah, 0
  2986 00001F9F 50                       push ax
  2987 00001FA0 E8A9FF                   call prc
  2988 00001FA3 83C402                   add  sp, 2
  2989 00001FA6 FF4604                   inc  word [bp+4]
  2990                                  
  2991                                  ;-25 }
  2992                                  
  2993 00001FA9 EBD8                     jmp @@prscomment118
  2994                                  @@prscomment119:
  2995                                  
  2996                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  2997 00001FAB C9                       LEAVE
  2998 00001FAC C3                       ret
  2999                                  ; ENDP
  3000                                  
  3001                                  prs:  ; *** PROC ***
  3002                                  ;Function : prs, Number of local variables: 3
  3003                                  ;   # type sign width line used address name   list of local variables
  3004                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3005                                  ;  201 var unsg byte    26 NULL bp-2    c
  3006                                  ;  202 var sign word    26 NULL bp-4    com;
  3007 00001FAD C8040000                 ENTER  4,0
  3008 00001FB1 66B800000000             mov eax, 0
  3009 00001FB7 8946FC                   mov word [bp-4], ax
  3010                                  
  3011                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3012                                  
  3013                                  @@prs120:
  3014 00001FBA 8B5E04                   mov bx, [bp+4]
  3015 00001FBD 8A07                     mov al, [bx]
  3016 00001FBF B400                     mov ah, 0
  3017 00001FC1 08C0                     or  al, al
  3018 00001FC3 0F848700                 je @@prs121
  3019 00001FC7 8B5E04                   mov bx, [bp+4]
  3020 00001FCA 8A07                     mov al, [bx]
  3021 00001FCC B400                     mov ah, 0
  3022 00001FCE 8846FE                   mov byte [bp-2], al
  3023 00001FD1 8A46FE                   mov al, [bp-2]
  3024 00001FD4 3C22                     cmp al, 34
  3025 00001FD6 0F851E00                 jne @@prs122
  3026 00001FDA 8B46FC                   mov ax, [bp-4]
  3027 00001FDD 08C0                     or  al, al
  3028 00001FDF 0F840C00                 je @@prs123
  3029 00001FE3 66B800000000             mov eax, 0
  3030 00001FE9 8946FC                   mov word [bp-4], ax
  3031 00001FEC E90900                   jmp @@prs124
  3032                                  @@prs123:
  3033 00001FEF 66B801000000             mov eax, 1
  3034 00001FF5 8946FC                   mov word [bp-4], ax
  3035                                  
  3036                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3037                                  
  3038                                  @@prs124:
  3039                                  @@prs122:
  3040 00001FF8 8A46FE                   mov al, [bp-2]
  3041 00001FFB 3C5C                     cmp al, 92
  3042 00001FFD 0F853B00                 jne @@prs125
  3043 00002001 8B46FC                   mov ax, [bp-4]
  3044 00002004 83F800                   cmp ax, 0
  3045 00002007 0F853100                 jne @@prs126
  3046 0000200B FF4604                   inc  word [bp+4]
  3047 0000200E 8B5E04                   mov bx, [bp+4]
  3048 00002011 8A07                     mov al, [bx]
  3049 00002013 B400                     mov ah, 0
  3050 00002015 8846FE                   mov byte [bp-2], al
  3051                                  
  3052                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3053                                  
  3054 00002018 8A46FE                   mov al, [bp-2]
  3055 0000201B 3C6E                     cmp al, 110
  3056 0000201D 0F850900                 jne @@prs127
  3057 00002021 66B80A000000             mov eax, 10
  3058 00002027 8846FE                   mov byte [bp-2], al
  3059                                  @@prs127:
  3060 0000202A 8A46FE                   mov al, [bp-2]
  3061 0000202D 3C74                     cmp al, 116
  3062 0000202F 0F850900                 jne @@prs128
  3063 00002033 66B809000000             mov eax, 9
  3064 00002039 8846FE                   mov byte [bp-2], al
  3065                                  @@prs128:
  3066                                  @@prs126:
  3067                                  @@prs125:
  3068 0000203C 8A46FE                   mov al, byte [bp-2]
  3069 0000203F B400                     mov ah, 0
  3070 00002041 50                       push ax
  3071 00002042 E807FF                   call prc
  3072 00002045 83C402                   add  sp, 2
  3073 00002048 FF4604                   inc  word [bp+4]
  3074                                  
  3075                                  ;-30 }
  3076                                  
  3077 0000204B E96CFF                   jmp @@prs120
  3078                                  @@prs121:
  3079                                  
  3080                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  3081 0000204E C9                       LEAVE
  3082 0000204F C3                       ret
  3083                                  ; ENDP
  3084                                  
  3085                                  printhex8a:  ; *** PROC ***
  3086                                  
  3087                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3088                                  
  3089                                  ;Function : printhex8a, Number of local variables: 2
  3090                                  ;   # type sign width line used address name   list of local variables
  3091                                  ;  200 var unsg word    31 NULL bp+4    c
  3092                                  ;  201 var unsg word    31 NULL bp-2    nib;
  3093 00002050 C8020000                 ENTER  2,0
  3094 00002054 8B4604                   mov ax, [bp+4]
  3095 00002057 C1E804                   shr ax, 4
  3096 0000205A 8946FE                   mov word [bp-2], ax
  3097 0000205D 8346FE30                 add  word [bp-2], 48
  3098 00002061 8B46FE                   mov ax, [bp-2]
  3099 00002064 83F839                   cmp ax, 57
  3100 00002067 0F8E0400                 jle @@printhex8a129
  3101 0000206B 8346FE07                 add  word [bp-2], 7
  3102                                  @@printhex8a129:
  3103 0000206F FF76FE                   push word [bp-2]
  3104 00002072 E8D7FE                   call prc
  3105 00002075 83C402                   add  sp, 2
  3106                                  
  3107                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3108                                  
  3109 00002078 8B4604                   mov ax, [bp+4]
  3110 0000207B 83E00F                   and ax, 15
  3111 0000207E 8946FE                   mov word [bp-2], ax
  3112 00002081 8346FE30                 add  word [bp-2], 48
  3113 00002085 8B46FE                   mov ax, [bp-2]
  3114 00002088 83F839                   cmp ax, 57
  3115 0000208B 0F8E0400                 jle @@printhex8a130
  3116 0000208F 8346FE07                 add  word [bp-2], 7
  3117                                  @@printhex8a130:
  3118 00002093 FF76FE                   push word [bp-2]
  3119 00002096 E8B3FE                   call prc
  3120 00002099 83C402                   add  sp, 2
  3121                                  
  3122                                  ;-34 }
  3123                                  
  3124                                  
  3125                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  3126 0000209C C9                       LEAVE
  3127 0000209D C3                       ret
  3128                                  ; ENDP
  3129                                  
  3130                                  printhex16:  ; *** PROC ***
  3131                                  
  3132                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3133                                  
  3134                                  ;Function : printhex16, Number of local variables: 2
  3135                                  ;   # type sign width line used address name   list of local variables
  3136                                  ;  200 var unsg word    35 NULL bp+4    i
  3137                                  ;  201 var unsg word    35 NULL bp-2    half;
  3138 0000209E C8020000                 ENTER  2,0
  3139 000020A2 8B4604                   mov ax, [bp+4]
  3140 000020A5 C1E808                   shr ax, 8
  3141 000020A8 8946FE                   mov word [bp-2], ax
  3142 000020AB FF76FE                   push word [bp-2]
  3143 000020AE E89FFF                   call printhex8a
  3144 000020B1 83C402                   add  sp, 2
  3145 000020B4 8B4604                   mov ax, [bp+4]
  3146 000020B7 25FF00                   and ax, 255
  3147 000020BA 8946FE                   mov word [bp-2], ax
  3148 000020BD FF76FE                   push word [bp-2]
  3149 000020C0 E88DFF                   call printhex8a
  3150 000020C3 83C402                   add  sp, 2
  3151                                  
  3152                                  ;-37 }
  3153                                  
  3154                                  
  3155                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  3156 000020C6 C9                       LEAVE
  3157 000020C7 C3                       ret
  3158                                  ; ENDP
  3159                                  
  3160                                  printIntU:  ; *** PROC ***
  3161                                  
  3162                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  3163                                  
  3164                                  ;Function : printIntU, Number of local variables: 2
  3165                                  ;   # type sign width line used address name   list of local variables
  3166                                  ;  200 var unsg word    38 NULL bp+4    n
  3167                                  ;  201 var unsg word    38 NULL bp-2    e;
  3168 000020C8 C8020000                 ENTER  2,0
  3169 000020CC 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3170 000020D0 0F821700                 jb  @@printIntU131
  3171 000020D4 8B4604                   mov ax, [bp+4]
  3172 000020D7 BB0A00                   mov bx, 10
  3173 000020DA BA0000                   mov dx, 0
  3174 000020DD F7F3                     div bx
  3175 000020DF 8946FE                   mov word [bp-2], ax
  3176                                  
  3177                                  ;-40     printIntU(e); }
  3178                                  
  3179 000020E2 FF76FE                   push word [bp-2]
  3180 000020E5 E8E0FF                   call printIntU
  3181 000020E8 83C402                   add  sp, 2
  3182                                  
  3183                                  ;-41     n = n % 10; //unsigned mod
  3184                                  
  3185                                  @@printIntU131:
  3186 000020EB 8B4604                   mov ax, [bp+4]
  3187 000020EE BB0A00                   mov bx, 10
  3188 000020F1 BA0000                   mov dx, 0
  3189 000020F4 F7F3                     div bx
  3190 000020F6 89D0                     mov ax, dx
  3191 000020F8 894604                   mov word [bp+4], ax
  3192                                  
  3193                                  ;-42     n += '0'; prc(n);
  3194                                  
  3195 000020FB 83460430                 add  word [bp+4], 48
  3196 000020FF FF7604                   push word [bp+4]
  3197 00002102 E847FE                   call prc
  3198 00002105 83C402                   add  sp, 2
  3199                                  
  3200                                  ;-43 }
  3201                                  
  3202                                  
  3203                                  ;-44 
  3204                                  
  3205                                  
  3206                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  3207 00002108 C9                       LEAVE
  3208 00002109 C3                       ret
  3209                                  ; ENDP
  3210                                  
  3211                                  error1:  ; *** PROC ***
  3212                                  ;Function : error1, Number of local variables: 1
  3213                                  ;   # type sign width line used address name   list of local variables
  3214                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  3215 0000210A C8000000                 ENTER  0,0
  3216 0000210E 66B801000000             mov eax, 1
  3217 00002114 A2[1600]                 mov byte [LIST], al
  3218 00002117 FF06[A901]               inc  word [ErrorCount]
  3219                                  
  3220                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  3221                                  
  3222 0000211B 68[4321]                 push error1_0
  3223 0000211E E88CFE                   call prs
  3224 00002121 83C402                   add  sp, 2
  3225 00002124 FF7604                   push word [bp+4]
  3226 00002127 E883FE                   call prs
  3227 0000212A 83C402                   add  sp, 2
  3228                                  
  3229                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  3230                                  
  3231 0000212D 68[5E21]                 push error1_1
  3232 00002130 E87AFE                   call prs
  3233 00002133 83C402                   add  sp, 2
  3234 00002136 8D06[1700]               lea  ax, [Symbol]
  3235 0000213A 50                       push ax
  3236 0000213B E86FFE                   call prs
  3237 0000213E 83C402                   add  sp, 2
  3238                                  
  3239                                  ;-48 int allowederror(){error1("not allowed here"); }
  3240 00002141 C9                       LEAVE
  3241 00002142 C3                       ret
  3242                                  ; ENDP
  3243 00002143 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3244 0000214C 6E657874206C696E65-
  3245 00002155 204552524F523A2000 
  3246 0000215E 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3247 00002167 2000               
  3248                                  
  3249                                  allowederror:  ; *** PROC ***
  3250 00002169 68[7321]                 push allowederror_0
  3251 0000216C E89BFF                   call error1
  3252 0000216F 83C402                   add  sp, 2
  3253                                  
  3254                                  ;-49 int addrerror()   {error1("memory address expected");} 
  3255                                  
  3256 00002172 C3                       ret
  3257                                  ; ENDP
  3258 00002173 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3259 0000217C 6564206865726500   
  3260                                  
  3261                                  addrerror:  ; *** PROC ***
  3262 00002184 68[8E21]                 push addrerror_0
  3263 00002187 E880FF                   call error1
  3264 0000218A 83C402                   add  sp, 2
  3265                                  
  3266                                  ;-50 int immeerror()   {error1("immediate not allowed here");}
  3267                                  
  3268 0000218D C3                       ret
  3269                                  ; ENDP
  3270 0000218E 6D656D6F7279206164-     addrerror_0 db "memory address expected",0
  3271 00002197 647265737320657870-
  3272 000021A0 656374656400       
  3273                                  
  3274                                  immeerror:  ; *** PROC ***
  3275 000021A6 68[B021]                 push immeerror_0
  3276 000021A9 E85EFF                   call error1
  3277 000021AC 83C402                   add  sp, 2
  3278                                  
  3279                                  ;-51 int implerror()   {error1("not implemented");}
  3280                                  
  3281 000021AF C3                       ret
  3282                                  ; ENDP
  3283 000021B0 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  3284 000021B9 206E6F7420616C6C6F-
  3285 000021C2 776564206865726500 
  3286                                  
  3287                                  implerror:  ; *** PROC ***
  3288 000021CB 68[D521]                 push implerror_0
  3289 000021CE E839FF                   call error1
  3290 000021D1 83C402                   add  sp, 2
  3291                                  
  3292                                  ;-52 int indexerror()  {error1("invalid index register");}
  3293                                  
  3294 000021D4 C3                       ret
  3295                                  ; ENDP
  3296 000021D5 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3297 000021DE 6D656E74656400     
  3298                                  
  3299                                  indexerror:  ; *** PROC ***
  3300 000021E5 68[EF21]                 push indexerror_0
  3301 000021E8 E81FFF                   call error1
  3302 000021EB 83C402                   add  sp, 2
  3303                                  
  3304                                  ;-53 int invaloperror(){error1("invalid or no operands");}
  3305                                  
  3306 000021EE C3                       ret
  3307                                  ; ENDP
  3308 000021EF 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3309 000021F8 6E6465782072656769-
  3310 00002201 7374657200         
  3311                                  
  3312                                  invaloperror:  ; *** PROC ***
  3313 00002206 68[1022]                 push invaloperror_0
  3314 00002209 E8FEFE                   call error1
  3315 0000220C 83C402                   add  sp, 2
  3316                                  
  3317                                  ;-54 int numbererror() {error1("number expected");}
  3318                                  
  3319 0000220F C3                       ret
  3320                                  ; ENDP
  3321 00002210 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3322 00002219 72206E6F206F706572-
  3323 00002222 616E647300         
  3324                                  
  3325                                  numbererror:  ; *** PROC ***
  3326 00002227 68[3122]                 push numbererror_0
  3327 0000222A E8DDFE                   call error1
  3328 0000222D 83C402                   add  sp, 2
  3329                                  
  3330                                  ;-55 int regmemerror() {error1("only register or memory allowed");}
  3331                                  
  3332 00002230 C3                       ret
  3333                                  ; ENDP
  3334 00002231 6E756D626572206578-     numbererror_0 db "number expected",0
  3335 0000223A 70656374656400     
  3336                                  
  3337                                  regmemerror:  ; *** PROC ***
  3338 00002241 68[4B22]                 push regmemerror_0
  3339 00002244 E8C3FE                   call error1
  3340 00002247 83C402                   add  sp, 2
  3341                                  
  3342                                  ;-56 int reg16error()  {error1("only reg16, no segreg allowed");}
  3343                                  
  3344 0000224A C3                       ret
  3345                                  ; ENDP
  3346 0000224B 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3347 00002254 73746572206F72206D-
  3348 0000225D 656D6F727920616C6C-
  3349 00002266 6F77656400         
  3350                                  
  3351                                  reg16error:  ; *** PROC ***
  3352 0000226B 68[7522]                 push reg16error_0
  3353 0000226E E899FE                   call error1
  3354 00002271 83C402                   add  sp, 2
  3355                                  
  3356                                  ;-57 int segregerror() {error1("segment register not allowed");}
  3357                                  
  3358 00002274 C3                       ret
  3359                                  ; ENDP
  3360 00002275 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3361 0000227E 362C206E6F20736567-
  3362 00002287 72656720616C6C6F77-
  3363 00002290 656400             
  3364                                  
  3365                                  segregerror:  ; *** PROC ***
  3366 00002293 68[9D22]                 push segregerror_0
  3367 00002296 E871FE                   call error1
  3368 00002299 83C402                   add  sp, 2
  3369                                  
  3370                                  ;-58 int syntaxerror() {error1("syntax");}
  3371                                  
  3372 0000229C C3                       ret
  3373                                  ; ENDP
  3374 0000229D 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3375 000022A6 65676973746572206E-
  3376 000022AF 6F7420616C6C6F7765-
  3377 000022B8 6400               
  3378                                  
  3379                                  syntaxerror:  ; *** PROC ***
  3380 000022BA 68[C422]                 push syntaxerror_0
  3381 000022BD E84AFE                   call error1
  3382 000022C0 83C402                   add  sp, 2
  3383                                  
  3384                                  ;-59 
  3385                                  
  3386                                  
  3387                                  ;-60 int errorexit(char *s) { error1(s); end1(1);}
  3388                                  
  3389 000022C3 C3                       ret
  3390                                  ; ENDP
  3391 000022C4 73796E74617800          syntaxerror_0 db "syntax",0
  3392                                  
  3393                                  errorexit:  ; *** PROC ***
  3394                                  ;Function : errorexit, Number of local variables: 1
  3395                                  ;   # type sign width line used address name   list of local variables
  3396                                  ;  200 ptr sign byte    60 NULL bp+4    s;
  3397 000022CB C8000000                 ENTER  0,0
  3398 000022CF FF7604                   push word [bp+4]
  3399 000022D2 E835FE                   call error1
  3400 000022D5 83C402                   add  sp, 2
  3401 000022D8 6A01                     push 1
  3402 000022DA E85003                   call end1
  3403 000022DD 83C402                   add  sp, 2
  3404                                  
  3405                                  ;-61 int addrexit(){errorexit("illegal address");}
  3406 000022E0 C9                       LEAVE
  3407 000022E1 C3                       ret
  3408                                  ; ENDP
  3409                                  
  3410                                  addrexit:  ; *** PROC ***
  3411 000022E2 68[EC22]                 push addrexit_0
  3412 000022E5 E8E3FF                   call errorexit
  3413 000022E8 83C402                   add  sp, 2
  3414                                  
  3415                                  ;-62 int internexit(){errorexit("intern compiler error");}
  3416                                  
  3417 000022EB C3                       ret
  3418                                  ; ENDP
  3419 000022EC 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3420 000022F5 64647265737300     
  3421                                  
  3422                                  internexit:  ; *** PROC ***
  3423 000022FC 68[0623]                 push internexit_0
  3424 000022FF E8C9FF                   call errorexit
  3425 00002302 83C402                   add  sp, 2
  3426 00002305 C3                       ret
  3427                                  ; ENDP
  3428 00002306 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3429 0000230F 6D70696C6572206572-
  3430 00002318 726F7200           
  3431                                  ;Back to main program: AS.C
  3432                                  
  3433                                  ;-8 #include "MAIN.C"
  3434                                  
  3435                                  ;Use include file: MAIN.C
  3436                                  
  3437                                  ;-1 int main() {
  3438                                  
  3439                                  
  3440                                  main:  ; *** PROC ***
  3441                                  
  3442                                  ;-2   getarg(); 
  3443                                  
  3444 0000231C E80A00                   call getarg
  3445                                  
  3446                                  ;-3   parse(); 
  3447                                  
  3448 0000231F E8D4EE                   call parse
  3449                                  
  3450                                  ;-4   epilog(); 
  3451                                  
  3452 00002322 E85C02                   call epilog
  3453                                  
  3454                                  ;-5   end1();
  3455                                  
  3456 00002325 E80503                   call end1
  3457                                  
  3458                                  ;-6 }
  3459                                  
  3460                                  
  3461                                  ;-7 
  3462                                  
  3463                                  
  3464                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3465                                  
  3466 00002328 C3                       ret
  3467                                  ; ENDP
  3468                                  
  3469                                  getarg:  ; *** PROC ***
  3470                                  
  3471                                  ;-9   arglen1=*arglen;
  3472                                  
  3473                                  ;Function : getarg, Number of local variables: 3
  3474                                  ;   # type sign width line used address name   list of local variables
  3475                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3476                                  ;  201 var sign word     8 NULL bp-4    i
  3477                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3478 00002329 C8060000                 ENTER  6,0
  3479 0000232D 8B1E[590E]               mov bx, [arglen]
  3480 00002331 8A07                     mov al, [bx]
  3481 00002333 B400                     mov ah, 0
  3482 00002335 8946FE                   mov word [bp-2], ax
  3483                                  
  3484                                  ;-10   if (arglen1==0) {
  3485                                  
  3486 00002338 8B46FE                   mov ax, [bp-2]
  3487 0000233B 83F800                   cmp ax, 0
  3488 0000233E 0F851C00                 jne @@getarg132
  3489                                  
  3490                                  ;-11     cputs(Version1);
  3491                                  
  3492 00002342 8D06[0300]               lea  ax, [Version1]
  3493 00002346 50                       push ax
  3494 00002347 E8DD0D                   call cputs
  3495 0000234A 83C402                   add  sp, 2
  3496                                  
  3497                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3498                                  
  3499 0000234D 68[EE24]                 push getarg_0
  3500 00002350 E8D40D                   call cputs
  3501 00002353 83C402                   add  sp, 2
  3502                                  
  3503                                  ;-13     exitR(3);
  3504                                  
  3505 00002356 6A03                     push 3
  3506 00002358 E8A70F                   call exitR
  3507 0000235B 83C402                   add  sp, 2
  3508                                  
  3509                                  ;-14   }
  3510                                  
  3511                                  
  3512                                  ;-15   i=arglen1+129; 
  3513                                  
  3514                                  @@getarg132:
  3515 0000235E 8B46FE                   mov ax, [bp-2]
  3516 00002361 058100                   add ax, 129
  3517 00002364 8946FC                   mov word [bp-4], ax
  3518                                  
  3519                                  ;-16   *i=0;  
  3520                                  
  3521 00002367 66B800000000             mov eax, 0
  3522 0000236D 8B5EFC                   mov  bx, [bp-4]
  3523 00002370 8907                     mov  [bx], ax
  3524                                  
  3525                                  ;-17   arglen1--;
  3526                                  
  3527 00002372 FF4EFE                   dec  word [bp-2]
  3528                                  
  3529                                  ;-18   toupper(argv);
  3530                                  
  3531 00002375 FF36[5B0E]               push word [argv]
  3532 00002379 E8D90D                   call toupper
  3533 0000237C 83C402                   add  sp, 2
  3534                                  
  3535                                  ;-19   
  3536                                  
  3537                                  
  3538                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3539                                  
  3540 0000237F FF36[5B0E]               push word [argv]
  3541 00002383 8D06[D800]               lea  ax, [namein]
  3542 00002387 50                       push ax
  3543 00002388 E8380E                   call strcpy
  3544 0000238B 83C404                   add  sp, 4
  3545 0000238E 68[1325]                 push getarg_1
  3546 00002391 8D06[D800]               lea  ax, [namein]
  3547 00002395 50                       push ax
  3548 00002396 E8EB0E                   call strcat1
  3549 00002399 83C404                   add  sp, 4
  3550                                  
  3551                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3552                                  
  3553 0000239C FF36[5B0E]               push word [argv]
  3554 000023A0 8D06[1B01]               lea  ax, [namelst]
  3555 000023A4 50                       push ax
  3556 000023A5 E81B0E                   call strcpy
  3557 000023A8 83C404                   add  sp, 4
  3558 000023AB 68[1625]                 push getarg_2
  3559 000023AE 8D06[1B01]               lea  ax, [namelst]
  3560 000023B2 50                       push ax
  3561 000023B3 E8CE0E                   call strcat1
  3562 000023B6 83C404                   add  sp, 4
  3563                                  
  3564                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3565                                  
  3566 000023B9 FF36[5B0E]               push word [argv]
  3567 000023BD 8D06[5E01]               lea  ax, [namebin]
  3568 000023C1 50                       push ax
  3569 000023C2 E8FE0D                   call strcpy
  3570 000023C5 83C404                   add  sp, 4
  3571 000023C8 68[1B25]                 push getarg_3
  3572 000023CB 8D06[5E01]               lea  ax, [namebin]
  3573 000023CF 50                       push ax
  3574 000023D0 E8B10E                   call strcat1
  3575 000023D3 83C404                   add  sp, 4
  3576                                  
  3577                                  ;-23 
  3578                                  
  3579                                  
  3580                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3581                                  
  3582 000023D6 66B801000000             mov eax, 1
  3583 000023DC A2[1600]                 mov byte [LIST], al
  3584 000023DF 66B800000000             mov eax, 0
  3585 000023E5 A3[A701]                 mov word [DOS_ERR], ax
  3586 000023E8 66B800000000             mov eax, 0
  3587 000023EE A3[AE01]                 mov word [PC], ax
  3588 000023F1 66B800000000             mov eax, 0
  3589 000023F7 A3[A901]                 mov word [ErrorCount], ax
  3590                                  
  3591                                  ;-25   
  3592                                  
  3593                                  
  3594                                  ;-26   asm_fd=openR (namein);
  3595                                  
  3596 000023FA 8D06[D800]               lea  ax, [namein]
  3597 000023FE 50                       push ax
  3598 000023FF E8A70E                   call openR
  3599 00002402 83C402                   add  sp, 2
  3600 00002405 A3[A101]                 mov word [asm_fd], ax
  3601                                  
  3602                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3603                                  
  3604 00002408 A1[A701]                 mov ax, [DOS_ERR]
  3605 0000240B 08C0                     or  al, al
  3606 0000240D 0F841C00                 je @@getarg133
  3607 00002411 68[2025]                 push getarg_4
  3608 00002414 E8100D                   call cputs
  3609 00002417 83C402                   add  sp, 2
  3610 0000241A 8D06[D800]               lea  ax, [namein]
  3611 0000241E 50                       push ax
  3612 0000241F E8050D                   call cputs
  3613 00002422 83C402                   add  sp, 2
  3614 00002425 6A01                     push 1
  3615 00002427 E8D80E                   call exitR
  3616 0000242A 83C402                   add  sp, 2
  3617                                  
  3618                                  ;-28   lst_fd=creatR(namelst);
  3619                                  
  3620                                  @@getarg133:
  3621 0000242D 8D06[1B01]               lea  ax, [namelst]
  3622 00002431 50                       push ax
  3623 00002432 E8830E                   call creatR
  3624 00002435 83C402                   add  sp, 2
  3625 00002438 A3[A301]                 mov word [lst_fd], ax
  3626                                  
  3627                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3628                                  
  3629 0000243B A1[A701]                 mov ax, [DOS_ERR]
  3630 0000243E 08C0                     or  al, al
  3631 00002440 0F841C00                 je @@getarg134
  3632 00002444 68[3625]                 push getarg_5
  3633 00002447 E8DD0C                   call cputs
  3634 0000244A 83C402                   add  sp, 2
  3635 0000244D 8D06[1B01]               lea  ax, [namelst]
  3636 00002451 50                       push ax
  3637 00002452 E8D20C                   call cputs
  3638 00002455 83C402                   add  sp, 2
  3639 00002458 6A02                     push 2
  3640 0000245A E8A50E                   call exitR
  3641 0000245D 83C402                   add  sp, 2
  3642                                  
  3643                                  ;-30   bin_fd=creatR(namebin);
  3644                                  
  3645                                  @@getarg134:
  3646 00002460 8D06[5E01]               lea  ax, [namebin]
  3647 00002464 50                       push ax
  3648 00002465 E8500E                   call creatR
  3649 00002468 83C402                   add  sp, 2
  3650 0000246B A3[A501]                 mov word [bin_fd], ax
  3651                                  
  3652                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3653                                  
  3654 0000246E A1[A701]                 mov ax, [DOS_ERR]
  3655 00002471 08C0                     or  al, al
  3656 00002473 0F841C00                 je @@getarg135
  3657 00002477 68[4D25]                 push getarg_6
  3658 0000247A E8AA0C                   call cputs
  3659 0000247D 83C402                   add  sp, 2
  3660 00002480 8D06[5E01]               lea  ax, [namebin]
  3661 00002484 50                       push ax
  3662 00002485 E89F0C                   call cputs
  3663 00002488 83C402                   add  sp, 2
  3664 0000248B 6A02                     push 2
  3665 0000248D E8720E                   call exitR
  3666 00002490 83C402                   add  sp, 2
  3667                                  
  3668                                  ;-32   
  3669                                  
  3670                                  
  3671                                  ;-33   prs(";");prs(Version1);
  3672                                  
  3673                                  @@getarg135:
  3674 00002493 68[6325]                 push getarg_7
  3675 00002496 E814FB                   call prs
  3676 00002499 83C402                   add  sp, 2
  3677 0000249C 8D06[0300]               lea  ax, [Version1]
  3678 000024A0 50                       push ax
  3679 000024A1 E809FB                   call prs
  3680 000024A4 83C402                   add  sp, 2
  3681                                  
  3682                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3683                                  
  3684 000024A7 68[6525]                 push getarg_8
  3685 000024AA E800FB                   call prs
  3686 000024AD 83C402                   add  sp, 2
  3687 000024B0 8D06[D800]               lea  ax, [namein]
  3688 000024B4 50                       push ax
  3689 000024B5 E8F5FA                   call prs
  3690 000024B8 83C402                   add  sp, 2
  3691 000024BB 68[7025]                 push getarg_9
  3692 000024BE E8ECFA                   call prs
  3693 000024C1 83C402                   add  sp, 2
  3694 000024C4 8D06[1B01]               lea  ax, [namelst]
  3695 000024C8 50                       push ax
  3696 000024C9 E8E1FA                   call prs
  3697 000024CC 83C402                   add  sp, 2
  3698                                  
  3699                                  ;-35   prs(", "); prs(namebin);
  3700                                  
  3701 000024CF 68[7B25]                 push getarg_10
  3702 000024D2 E8D8FA                   call prs
  3703 000024D5 83C402                   add  sp, 2
  3704 000024D8 8D06[5E01]               lea  ax, [namebin]
  3705 000024DC 50                       push ax
  3706 000024DD E8CDFA                   call prs
  3707 000024E0 83C402                   add  sp, 2
  3708                                  
  3709                                  ;-36   prs("\n");
  3710                                  
  3711 000024E3 68[7E25]                 push getarg_11
  3712 000024E6 E8C4FA                   call prs
  3713 000024E9 83C402                   add  sp, 2
  3714                                  
  3715                                  ;-37 }
  3716                                  
  3717                                  
  3718                                  ;-38 int epilog() { int i; int j; char c;
  3719 000024EC C9                       LEAVE
  3720 000024ED C3                       ret
  3721                                  ; ENDP
  3722 000024EE 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3723 000024F7 41532E434F4D206669-
  3724 00002500 6C656E616D65205B77-
  3725 00002509 2F6F202E535D203A20-
  3726 00002512 00                 
  3727 00002513 2E5300                  getarg_1 db ".S",0
  3728 00002516 2E4C535400              getarg_2 db ".LST",0
  3729 0000251B 2E434F4D00              getarg_3 db ".COM",0
  3730 00002520 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3731 00002529 6C65206D697373696E-
  3732 00002532 673A2000           
  3733 00002536 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3734 0000253F 206E6F742063726561-
  3735 00002548 74653A2000         
  3736 0000254D 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3737 00002556 6E6F74206372656174-
  3738 0000255F 653A2000           
  3739 00002563 3B00                    getarg_7 db ";",0
  3740 00002565 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3741 0000256E 2000               
  3742 00002570 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3743 00002579 2000               
  3744 0000257B 2C2000                  getarg_10 db ", ",0
  3745 0000257E 5C6E00                  getarg_11 db "\n",0
  3746                                  
  3747                                  epilog:  ; *** PROC ***
  3748                                  
  3749                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3750                                  
  3751                                  ;Function : epilog, Number of local variables: 3
  3752                                  ;   # type sign width line used address name   list of local variables
  3753                                  ;  200 var sign word    38 NULL bp-2    i
  3754                                  ;  201 var sign word    38 NULL bp-4    j
  3755                                  ;  202 var sign byte    38 NULL bp-6    c;
  3756 00002581 C8060000                 ENTER  6,0
  3757 00002585 68[FB25]                 push epilog_0
  3758 00002588 E822FA                   call prs
  3759 0000258B 83C402                   add  sp, 2
  3760 0000258E FF36[A901]               push word [ErrorCount]
  3761 00002592 E833FB                   call printIntU
  3762 00002595 83C402                   add  sp, 2
  3763                                  
  3764                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3765                                  
  3766 00002598 A1[A901]                 mov ax, [ErrorCount]
  3767 0000259B 08C0                     or  al, al
  3768 0000259D 0F840900                 je @@epilog136
  3769 000025A1 68[0B26]                 push epilog_1
  3770 000025A4 E806FA                   call prs
  3771 000025A7 83C402                   add  sp, 2
  3772                                  
  3773                                  ;-41 /*    
  3774                                  
  3775                                  
  3776                                  ;-42   prs(", Label & Var: ");
  3777                                  
  3778                                  
  3779                                  ;-43   if (LabelMaxIx) {
  3780                                  
  3781                                  
  3782                                  ;-44     i = 1;
  3783                                  
  3784                                  
  3785                                  ;-45     LabelNamePtr= &LabelNames;
  3786                                  
  3787                                  
  3788                                  ;-46     do {
  3789                                  
  3790                                  
  3791                                  ;-47       prs(LabelNamePtr); prc(' ');
  3792                                  
  3793                                  
  3794                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3795                                  
  3796                                  
  3797                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3798                                  
  3799                                  
  3800                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3801                                  
  3802                                  
  3803                                  ;-51       LabelNamePtr++;
  3804                                  
  3805                                  
  3806                                  ;-52       i++;
  3807                                  
  3808                                  
  3809                                  ;-53     } while (i <= LabelMaxIx);
  3810                                  
  3811                                  
  3812                                  ;-54   }
  3813                                  
  3814                                  
  3815                                  ;-55 */  
  3816                                  
  3817                                  
  3818                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3819                                  
  3820                                  @@epilog136:
  3821 000025AA 68[1926]                 push epilog_2
  3822 000025AD E8FDF9                   call prs
  3823 000025B0 83C402                   add  sp, 2
  3824 000025B3 FF36[570E]               push word [BinLen]
  3825 000025B7 E80EFB                   call printIntU
  3826 000025BA 83C402                   add  sp, 2
  3827 000025BD 68[2526]                 push epilog_3
  3828 000025C0 E8EAF9                   call prs
  3829 000025C3 83C402                   add  sp, 2
  3830                                  
  3831                                  ;-57 //  i=0;
  3832                                  
  3833                                  
  3834                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  3835                                  
  3836                                  
  3837                                  ;-59 //  } while (i < BinLen);
  3838                                  
  3839                                  
  3840                                  ;-60   i=0;
  3841                                  
  3842 000025C6 66B800000000             mov eax, 0
  3843 000025CC 8946FE                   mov word [bp-2], ax
  3844                                  
  3845                                  ;-61   do {
  3846                                  
  3847                                  @@epilog137:
  3848                                  
  3849                                  ;-62     c = FileBin[i];
  3850                                  
  3851 000025CF 8B5EFE                   mov bx, [bp-2]
  3852 000025D2 8A87[8706]               mov al, [FileBin + bx]
  3853 000025D6 8846FA                   mov byte [bp-6], al
  3854                                  
  3855                                  ;-63     fputcR(c, bin_fd);
  3856                                  
  3857 000025D9 FF36[A501]               push word [bin_fd]
  3858 000025DD 8A46FA                   mov al, byte [bp-6]
  3859 000025E0 B400                     mov ah, 0
  3860 000025E2 50                       push ax
  3861 000025E3 E8F90C                   call fputcR
  3862 000025E6 83C404                   add  sp, 4
  3863                                  
  3864                                  ;-64     i++;
  3865                                  
  3866 000025E9 FF46FE                   inc  word [bp-2]
  3867                                  
  3868                                  ;-65   } while (i < BinLen);
  3869                                  
  3870 000025EC 8B46FE                   mov ax, [bp-2]
  3871 000025EF 3B06[570E]               cmp ax, [BinLen]
  3872 000025F3 0F8D0200                 jge @@epilog138
  3873 000025F7 EBD6                     jmp @@epilog137
  3874                                  @@epilog138:
  3875                                  
  3876                                  ;-66 }
  3877                                  
  3878                                  
  3879                                  ;-67 int end1(int n) {
  3880 000025F9 C9                       LEAVE
  3881 000025FA C3                       ret
  3882                                  ; ENDP
  3883 000025FB 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  3884 00002604 726F72733A2000     
  3885 0000260B 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  3886 00002614 2A2A2A2000         
  3887 00002619 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  3888 00002622 652000             
  3889 00002625 2062797465732E00        epilog_3 db " bytes.",0
  3890                                  
  3891                                  end1:  ; *** PROC ***
  3892                                  
  3893                                  ;-68   fcloseR(asm_fd);
  3894                                  
  3895                                  ;Function : end1, Number of local variables: 1
  3896                                  ;   # type sign width line used address name   list of local variables
  3897                                  ;  200 var sign word    67 NULL bp+4    n;
  3898 0000262D C8000000                 ENTER  0,0
  3899 00002631 FF36[A101]               push word [asm_fd]
  3900 00002635 E8BC0C                   call fcloseR
  3901 00002638 83C402                   add  sp, 2
  3902                                  
  3903                                  ;-69   fcloseR(lst_fd);
  3904                                  
  3905 0000263B FF36[A301]               push word [lst_fd]
  3906 0000263F E8B20C                   call fcloseR
  3907 00002642 83C402                   add  sp, 2
  3908                                  
  3909                                  ;-70   fcloseR(bin_fd);
  3910                                  
  3911 00002645 FF36[A501]               push word [bin_fd]
  3912 00002649 E8A80C                   call fcloseR
  3913 0000264C 83C402                   add  sp, 2
  3914                                  
  3915                                  ;-71   exitR(n);
  3916                                  
  3917 0000264F FF7604                   push word [bp+4]
  3918 00002652 E8AD0C                   call exitR
  3919 00002655 83C402                   add  sp, 2
  3920                                  
  3921                                  ;-72 }
  3922 00002658 C9                       LEAVE
  3923 00002659 C3                       ret
  3924                                  ; ENDP
  3925                                  ;Back to main program: AS.C
  3926                                  
  3927                                  ;-9 #include "GENCODE.C"
  3928                                  
  3929                                  ;Use include file: GENCODE.C
  3930                                  
  3931                                  ;-1 // generate code
  3932                                  
  3933                                  
  3934                                  ;-2 int getCodes() {
  3935                                  
  3936                                  
  3937                                  getCodes:  ; *** PROC ***
  3938                                  
  3939                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  3940                                  
  3941 0000265A FF06[CE01]               inc  word [OpCodePtr]
  3942 0000265E 8B1E[CE01]               mov bx, [OpCodePtr]
  3943 00002662 8A07                     mov al, [bx]
  3944 00002664 B400                     mov ah, 0
  3945 00002666 A2[B701]                 mov byte [Code1], al
  3946                                  
  3947                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  3948                                  
  3949 00002669 FF06[CE01]               inc  word [OpCodePtr]
  3950 0000266D 8B1E[CE01]               mov bx, [OpCodePtr]
  3951 00002671 8A07                     mov al, [bx]
  3952 00002673 B400                     mov ah, 0
  3953 00002675 A2[B801]                 mov byte [Code2], al
  3954                                  
  3955                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  3956                                  
  3957 00002678 FF06[CE01]               inc  word [OpCodePtr]
  3958 0000267C 8B1E[CE01]               mov bx, [OpCodePtr]
  3959 00002680 8A07                     mov al, [bx]
  3960 00002682 B400                     mov ah, 0
  3961 00002684 A2[B901]                 mov byte [Code3], al
  3962                                  
  3963                                  ;-6 }
  3964                                  
  3965                                  
  3966                                  ;-7 int gen66h() {genCode8(0x66);
  3967                                  
  3968 00002687 C3                       ret
  3969                                  ; ENDP
  3970                                  
  3971                                  gen66h:  ; *** PROC ***
  3972 00002688 6A66                     push 102
  3973 0000268A E85100                   call genCode8
  3974 0000268D 83C402                   add  sp, 2
  3975                                  
  3976                                  ;-8 }
  3977                                  
  3978                                  
  3979                                  ;-9 int genCode(char c, char d) {
  3980                                  
  3981 00002690 C3                       ret
  3982                                  ; ENDP
  3983                                  
  3984                                  genCode:  ; *** PROC ***
  3985                                  
  3986                                  ;-10     c = c + d;
  3987                                  
  3988                                  ;Function : genCode, Number of local variables: 2
  3989                                  ;   # type sign width line used address name   list of local variables
  3990                                  ;  200 var sign byte     9 NULL bp+4    c
  3991                                  ;  201 var sign byte     9 NULL bp+6    d;
  3992 00002691 C8000000                 ENTER  0,0
  3993 00002695 8A4604                   mov al, [bp+4]
  3994 00002698 024606                   add al, [bp+6]
  3995 0000269B 884604                   mov byte [bp+4], al
  3996                                  
  3997                                  ;-11     genCode8(c);
  3998                                  
  3999 0000269E 8A4604                   mov al, byte [bp+4]
  4000 000026A1 B400                     mov ah, 0
  4001 000026A3 50                       push ax
  4002 000026A4 E83700                   call genCode8
  4003 000026A7 83C402                   add  sp, 2
  4004                                  
  4005                                  ;-12 }   
  4006                                  
  4007                                  
  4008                                  ;-13 int genCodeDW(char c) {
  4009 000026AA C9                       LEAVE
  4010 000026AB C3                       ret
  4011                                  ; ENDP
  4012                                  
  4013                                  genCodeDW:  ; *** PROC ***
  4014                                  
  4015                                  ;-14     c +=2;//direction flag  
  4016                                  
  4017                                  ;Function : genCodeDW, Number of local variables: 1
  4018                                  ;   # type sign width line used address name   list of local variables
  4019                                  ;  200 var sign byte    13 NULL bp+4    c;
  4020 000026AC C8000000                 ENTER  0,0
  4021 000026B0 80460402                 add  byte [bp+4], 2
  4022                                  
  4023                                  ;-15     genCodeW(c);
  4024                                  
  4025 000026B4 8A4604                   mov al, byte [bp+4]
  4026 000026B7 B400                     mov ah, 0
  4027 000026B9 50                       push ax
  4028 000026BA E80500                   call genCodeW
  4029 000026BD 83C402                   add  sp, 2
  4030                                  
  4031                                  ;-16 } 
  4032                                  
  4033                                  
  4034                                  ;-17 int genCodeW(char c) {
  4035 000026C0 C9                       LEAVE
  4036 000026C1 C3                       ret
  4037                                  ; ENDP
  4038                                  
  4039                                  genCodeW:  ; *** PROC ***
  4040                                  
  4041                                  ;-18     c = c + wflag;  
  4042                                  
  4043                                  ;Function : genCodeW, Number of local variables: 1
  4044                                  ;   # type sign width line used address name   list of local variables
  4045                                  ;  200 var sign byte    17 NULL bp+4    c;
  4046 000026C2 C8000000                 ENTER  0,0
  4047 000026C6 8A4604                   mov al, [bp+4]
  4048 000026C9 0206[BF01]               add al, [wflag]
  4049 000026CD 884604                   mov byte [bp+4], al
  4050                                  
  4051                                  ;-19     genCode8(c);
  4052                                  
  4053 000026D0 8A4604                   mov al, byte [bp+4]
  4054 000026D3 B400                     mov ah, 0
  4055 000026D5 50                       push ax
  4056 000026D6 E80500                   call genCode8
  4057 000026D9 83C402                   add  sp, 2
  4058                                  
  4059                                  ;-20 }   
  4060                                  
  4061                                  
  4062                                  ;-21 int genCode8(char c) {
  4063 000026DC C9                       LEAVE
  4064 000026DD C3                       ret
  4065                                  ; ENDP
  4066                                  
  4067                                  genCode8:  ; *** PROC ***
  4068                                  
  4069                                  ;-22 //set: BinLen++, OpPrintIndex++
  4070                                  
  4071                                  
  4072                                  ;-23     FileBin[BinLen]=c;
  4073                                  
  4074                                  ;Function : genCode8, Number of local variables: 1
  4075                                  ;   # type sign width line used address name   list of local variables
  4076                                  ;  200 var sign byte    21 NULL bp+4    c;
  4077 000026DE C8000000                 ENTER  0,0
  4078 000026E2 8A4604                   mov al, [bp+4]
  4079 000026E5 8B1E[570E]               mov bx, [BinLen]
  4080 000026E9 8887[8706]               mov [FileBin+bx], al
  4081                                  
  4082                                  ;-24     BinLen++;
  4083                                  
  4084 000026ED FF06[570E]               inc  word [BinLen]
  4085                                  
  4086                                  ;-25     PC++;
  4087                                  
  4088 000026F1 FF06[AE01]               inc  word [PC]
  4089                                  
  4090                                  ;-26     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  4091                                  
  4092 000026F5 A1[570E]                 mov ax, [BinLen]
  4093 000026F8 3DD007                   cmp ax, 2000 ;unsigned : 0
  4094 000026FB 0F820900                 jb  @@genCode8139
  4095 000026FF 68[2327]                 push genCode8_0
  4096 00002702 E8C6FB                   call errorexit
  4097 00002705 83C402                   add  sp, 2
  4098                                  
  4099                                  ;-27     if (OpPrintIndex < OPMAXLEN) {
  4100                                  
  4101                                  @@genCode8139:
  4102 00002708 A1[CC01]                 mov ax, [OpPrintIndex]
  4103 0000270B 83F805                   cmp ax, 5
  4104 0000270E 0F8D0F00                 jge @@genCode8140
  4105                                  
  4106                                  ;-28         OpPos[OpPrintIndex]=c;
  4107                                  
  4108 00002712 8A4604                   mov al, [bp+4]
  4109 00002715 8B1E[CC01]               mov bx, [OpPrintIndex]
  4110 00002719 8887[C701]               mov [OpPos+bx], al
  4111                                  
  4112                                  ;-29         OpPrintIndex++;
  4113                                  
  4114 0000271D FF06[CC01]               inc  word [OpPrintIndex]
  4115                                  
  4116                                  ;-30     }
  4117                                  
  4118                                  
  4119                                  ;-31 }
  4120                                  
  4121                                  @@genCode8140:
  4122                                  
  4123                                  ;-32 int genCode16(unsigned int i) {
  4124 00002721 C9                       LEAVE
  4125 00002722 C3                       ret
  4126                                  ; ENDP
  4127 00002723 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  4128 0000272C 746F6F206C6F6E6700 
  4129                                  
  4130                                  genCode16:  ; *** PROC ***
  4131                                  
  4132                                  ;-33     genCode8(i); i=i >> 8;
  4133                                  
  4134                                  ;Function : genCode16, Number of local variables: 1
  4135                                  ;   # type sign width line used address name   list of local variables
  4136                                  ;  200 var unsg word    32 NULL bp+4    i;
  4137 00002735 C8000000                 ENTER  0,0
  4138 00002739 FF7604                   push word [bp+4]
  4139 0000273C E89FFF                   call genCode8
  4140 0000273F 83C402                   add  sp, 2
  4141 00002742 8B4604                   mov ax, [bp+4]
  4142 00002745 C1E808                   shr ax, 8
  4143 00002748 894604                   mov word [bp+4], ax
  4144                                  
  4145                                  ;-34     genCode8(i);
  4146                                  
  4147 0000274B FF7604                   push word [bp+4]
  4148 0000274E E88DFF                   call genCode8
  4149 00002751 83C402                   add  sp, 2
  4150                                  
  4151                                  ;-35 }
  4152                                  
  4153                                  
  4154                                  ;-36 int writeEA(char xxx) {//need: Op, Op2, disp, RegNo, regindexbase, isDirect
  4155 00002754 C9                       LEAVE
  4156 00002755 C3                       ret
  4157                                  ; ENDP
  4158                                  
  4159                                  writeEA:  ; *** PROC ***
  4160                                  
  4161                                  ;-37 //mod-byte: mode76, reg/opcode543, r/m210    
  4162                                  
  4163                                  
  4164                                  ;-38     char len;
  4165                                  
  4166                                  
  4167                                  ;-39     len=0;   
  4168                                  
  4169                                  ;Function : writeEA, Number of local variables: 2
  4170                                  ;   # type sign width line used address name   list of local variables
  4171                                  ;  200 var sign byte    36 NULL bp+4    xxx
  4172                                  ;  201 var sign byte    38 NULL bp-2    len;
  4173 00002756 C8020000                 ENTER  2,0
  4174 0000275A 66B800000000             mov eax, 0
  4175 00002760 8846FE                   mov byte [bp-2], al
  4176                                  
  4177                                  ;-40    prs("\nxxx:"); printhex8a(xxx);       
  4178                                  
  4179 00002763 68[DC28]                 push writeEA_0
  4180 00002766 E844F8                   call prs
  4181 00002769 83C402                   add  sp, 2
  4182 0000276C 8A4604                   mov al, byte [bp+4]
  4183 0000276F B400                     mov ah, 0
  4184 00002771 50                       push ax
  4185 00002772 E8DBF8                   call printhex8a
  4186 00002775 83C402                   add  sp, 2
  4187                                  
  4188                                  ;-41     prs(", Op:"); printhex8a(Op);
  4189                                  
  4190 00002778 68[E328]                 push writeEA_1
  4191 0000277B E82FF8                   call prs
  4192 0000277E 83C402                   add  sp, 2
  4193 00002781 A0[B401]                 mov al, byte [Op]
  4194 00002784 B400                     mov ah, 0
  4195 00002786 50                       push ax
  4196 00002787 E8C6F8                   call printhex8a
  4197 0000278A 83C402                   add  sp, 2
  4198                                  
  4199                                  ;-42     prs(", Op2:"); printhex8a(Op2);
  4200                                  
  4201 0000278D 68[E928]                 push writeEA_2
  4202 00002790 E81AF8                   call prs
  4203 00002793 83C402                   add  sp, 2
  4204 00002796 A0[B501]                 mov al, byte [Op2]
  4205 00002799 B400                     mov ah, 0
  4206 0000279B 50                       push ax
  4207 0000279C E8B1F8                   call printhex8a
  4208 0000279F 83C402                   add  sp, 2
  4209                                  
  4210                                  ;-43     prs(", RegNo:"); printhex8a(RegNo);
  4211                                  
  4212 000027A2 68[F028]                 push writeEA_3
  4213 000027A5 E805F8                   call prs
  4214 000027A8 83C402                   add  sp, 2
  4215 000027AB A0[BA01]                 mov al, byte [RegNo]
  4216 000027AE B400                     mov ah, 0
  4217 000027B0 50                       push ax
  4218 000027B1 E89CF8                   call printhex8a
  4219 000027B4 83C402                   add  sp, 2
  4220                                  
  4221                                  ;-44     prs(", R1No:"); printhex8a(R1No);
  4222                                  
  4223 000027B7 68[F928]                 push writeEA_4
  4224 000027BA E8F0F7                   call prs
  4225 000027BD 83C402                   add  sp, 2
  4226 000027C0 A0[BB01]                 mov al, byte [R1No]
  4227 000027C3 B400                     mov ah, 0
  4228 000027C5 50                       push ax
  4229 000027C6 E887F8                   call printhex8a
  4230 000027C9 83C402                   add  sp, 2
  4231                                  
  4232                                  ;-45            
  4233                                  
  4234                                  
  4235                                  ;-46     xxx = xxx << 3;//in reg/opcode field
  4236                                  
  4237 000027CC 8A4604                   mov al, [bp+4]
  4238 000027CF C0E003                   shl al, 3
  4239 000027D2 884604                   mov byte [bp+4], al
  4240                                  
  4241                                  ;-47 //    prs(", xxx:"); printhex8a(xxx);       
  4242                                  
  4243                                  
  4244                                  ;-48 //    prs(", Op:"); printhex8a(Op);
  4245                                  
  4246                                  
  4247                                  ;-49     if (Op ==   0) addrexit();
  4248                                  
  4249 000027D5 A0[B401]                 mov al, [Op]
  4250 000027D8 3C00                     cmp al, 0
  4251 000027DA 0F850300                 jne @@writeEA141
  4252 000027DE E801FB                   call addrexit
  4253                                  
  4254                                  ;-50     if (Op == REG) {
  4255                                  
  4256                                  @@writeEA141:
  4257 000027E1 A0[B401]                 mov al, [Op]
  4258 000027E4 3C02                     cmp al, 2
  4259 000027E6 0F852400                 jne @@writeEA142
  4260                                  
  4261                                  ;-51         xxx |= 0xC0; 
  4262                                  
  4263 000027EA 804E04C0                 or  byte [bp+4], 192
  4264                                  
  4265                                  ;-52         if (Op2 == REG) xxx = xxx + R1No;
  4266                                  
  4267 000027EE A0[B501]                 mov al, [Op2]
  4268 000027F1 3C02                     cmp al, 2
  4269 000027F3 0F850D00                 jne @@writeEA143
  4270 000027F7 8A4604                   mov al, [bp+4]
  4271 000027FA 0206[BB01]               add al, [R1No]
  4272 000027FE 884604                   mov byte [bp+4], al
  4273                                  
  4274                                  ;-53         else            xxx = xxx + RegNo;
  4275                                  
  4276 00002801 E90A00                   jmp @@writeEA144
  4277                                  @@writeEA143:
  4278 00002804 8A4604                   mov al, [bp+4]
  4279 00002807 0206[BA01]               add al, [RegNo]
  4280 0000280B 884604                   mov byte [bp+4], al
  4281                                  
  4282                                  ;-54         } 
  4283                                  
  4284                                  @@writeEA144:
  4285                                  
  4286                                  ;-55     if (Op == ADR) error1("writeEA");           
  4287                                  
  4288                                  @@writeEA142:
  4289 0000280E A0[B401]                 mov al, [Op]
  4290 00002811 3C03                     cmp al, 3
  4291 00002813 0F850900                 jne @@writeEA145
  4292 00002817 68[0129]                 push writeEA_5
  4293 0000281A E8EDF8                   call error1
  4294 0000281D 83C402                   add  sp, 2
  4295                                  
  4296                                  ;-56     if (Op == MEM) {
  4297                                  
  4298                                  @@writeEA145:
  4299 00002820 A0[B401]                 mov al, [Op]
  4300 00002823 3C04                     cmp al, 4
  4301 00002825 0F857F00                 jne @@writeEA146
  4302                                  
  4303                                  ;-57         if (isDirect) {
  4304                                  
  4305 00002829 A0[C201]                 mov al, [isDirect]
  4306 0000282C 08C0                     or  al, al
  4307 0000282E 0F841000                 je @@writeEA147
  4308                                  
  4309                                  ;-58             xxx |= 6;
  4310                                  
  4311 00002832 804E0406                 or  byte [bp+4], 6
  4312                                  
  4313                                  ;-59             len = 2;
  4314                                  
  4315 00002836 66B802000000             mov eax, 2
  4316 0000283C 8846FE                   mov byte [bp-2], al
  4317                                  
  4318                                  ;-60         }
  4319                                  
  4320                                  
  4321                                  ;-61         else { 
  4322                                  
  4323 0000283F E96600                   jmp @@writeEA148
  4324                                  @@writeEA147:
  4325                                  
  4326                                  ;-62             xxx = xxx + regindexbase;   
  4327                                  
  4328 00002842 8A4604                   mov al, [bp+4]
  4329 00002845 0206[C101]               add al, [regindexbase]
  4330 00002849 884604                   mov byte [bp+4], al
  4331                                  
  4332                                  ;-63             if (regindexbase == 6) {//make [BP+00]
  4333                                  
  4334 0000284C A0[C101]                 mov al, [regindexbase]
  4335 0000284F 3C06                     cmp al, 6
  4336 00002851 0F851700                 jne @@writeEA149
  4337                                  
  4338                                  ;-64                 len=1;
  4339                                  
  4340 00002855 66B801000000             mov eax, 1
  4341 0000285B 8846FE                   mov byte [bp-2], al
  4342                                  
  4343                                  ;-65                 if (disp == 0) xxx |= 0x40;
  4344                                  
  4345 0000285E A1[C301]                 mov ax, [disp]
  4346 00002861 83F800                   cmp ax, 0
  4347 00002864 0F850400                 jne @@writeEA150
  4348 00002868 804E0440                 or  byte [bp+4], 64
  4349                                  
  4350                                  ;-66             }
  4351                                  
  4352                                  @@writeEA150:
  4353                                  
  4354                                  ;-67 
  4355                                  
  4356                                  
  4357                                  ;-68             if (disp) {
  4358                                  
  4359                                  @@writeEA149:
  4360 0000286C A1[C301]                 mov ax, [disp]
  4361 0000286F 08C0                     or  al, al
  4362 00002871 0F843300                 je @@writeEA151
  4363                                  
  4364                                  ;-69                 ax = disp;
  4365                                  
  4366 00002875 A1[C301]                 mov  ax, [disp]
  4367                                  
  4368                                  ;-70                 if(ax > 127) len=2;
  4369                                  
  4370 00002878 83F87F                   cmp  ax, 127
  4371 0000287B 0F8E0C00                 jle @@writeEA152
  4372 0000287F 66B802000000             mov eax, 2
  4373 00002885 8846FE                   mov byte [bp-2], al
  4374                                  
  4375                                  ;-71                 else len=1;
  4376                                  
  4377 00002888 E90900                   jmp @@writeEA153
  4378                                  @@writeEA152:
  4379 0000288B 66B801000000             mov eax, 1
  4380 00002891 8846FE                   mov byte [bp-2], al
  4381                                  
  4382                                  ;-72                 if (len == 1) xxx |= 0x40;
  4383                                  
  4384                                  @@writeEA153:
  4385 00002894 8A46FE                   mov al, [bp-2]
  4386 00002897 3C01                     cmp al, 1
  4387 00002899 0F850700                 jne @@writeEA154
  4388 0000289D 804E0440                 or  byte [bp+4], 64
  4389                                  
  4390                                  ;-73                 else xxx |= 0x80;
  4391                                  
  4392 000028A1 E90400                   jmp @@writeEA155
  4393                                  @@writeEA154:
  4394 000028A4 804E0480                 or  byte [bp+4], 128
  4395                                  
  4396                                  ;-74             }
  4397                                  
  4398                                  @@writeEA155:
  4399                                  
  4400                                  ;-75         }
  4401                                  
  4402                                  @@writeEA151:
  4403                                  
  4404                                  ;-76     }
  4405                                  
  4406                                  @@writeEA148:
  4407                                  
  4408                                  ;-77     genCode8(xxx);// gen second byte
  4409                                  
  4410                                  @@writeEA146:
  4411 000028A8 8A4604                   mov al, byte [bp+4]
  4412 000028AB B400                     mov ah, 0
  4413 000028AD 50                       push ax
  4414 000028AE E82DFE                   call genCode8
  4415 000028B1 83C402                   add  sp, 2
  4416                                  
  4417                                  ;-78     if (len == 1) genCode8 (disp);
  4418                                  
  4419 000028B4 8A46FE                   mov al, [bp-2]
  4420 000028B7 3C01                     cmp al, 1
  4421 000028B9 0F850A00                 jne @@writeEA156
  4422 000028BD FF36[C301]               push word [disp]
  4423 000028C1 E81AFE                   call genCode8
  4424 000028C4 83C402                   add  sp, 2
  4425                                  
  4426                                  ;-79     if (len == 2) genCode16(disp);
  4427                                  
  4428                                  @@writeEA156:
  4429 000028C7 8A46FE                   mov al, [bp-2]
  4430 000028CA 3C02                     cmp al, 2
  4431 000028CC 0F850A00                 jne @@writeEA157
  4432 000028D0 FF36[C301]               push word [disp]
  4433 000028D4 E85EFE                   call genCode16
  4434 000028D7 83C402                   add  sp, 2
  4435                                  
  4436                                  ;-80 }
  4437                                  
  4438                                  @@writeEA157:
  4439                                  
  4440                                  ;-81 
  4441                                  
  4442                                  
  4443                                  ;-82 int genImmediate() {
  4444 000028DA C9                       LEAVE
  4445 000028DB C3                       ret
  4446                                  ; ENDP
  4447 000028DC 5C6E7878783A00          writeEA_0 db "\nxxx:",0
  4448 000028E3 2C204F703A00            writeEA_1 db ", Op:",0
  4449 000028E9 2C204F70323A00          writeEA_2 db ", Op2:",0
  4450 000028F0 2C205265674E6F3A00      writeEA_3 db ", RegNo:",0
  4451 000028F9 2C2052314E6F3A00        writeEA_4 db ", R1No:",0
  4452 00002901 7772697465454100        writeEA_5 db "writeEA",0
  4453                                  
  4454                                  genImmediate:  ; *** PROC ***
  4455                                  
  4456                                  ;-83     if (sflag) wflag=0;
  4457                                  
  4458 00002909 A0[C001]                 mov al, [sflag]
  4459 0000290C 08C0                     or  al, al
  4460 0000290E 0F840900                 je @@genImmediate158
  4461 00002912 66B800000000             mov eax, 0
  4462 00002918 A2[BF01]                 mov byte [wflag], al
  4463                                  
  4464                                  ;-84     if (wflag) genCode16(imme);
  4465                                  
  4466                                  @@genImmediate158:
  4467 0000291B A0[BF01]                 mov al, [wflag]
  4468 0000291E 08C0                     or  al, al
  4469 00002920 0F840D00                 je @@genImmediate159
  4470 00002924 FF36[C501]               push word [imme]
  4471 00002928 E80AFE                   call genCode16
  4472 0000292B 83C402                   add  sp, 2
  4473                                  
  4474                                  ;-85     else       genCode8 (imme);  
  4475                                  
  4476 0000292E E90A00                   jmp @@genImmediate160
  4477                                  @@genImmediate159:
  4478 00002931 FF36[C501]               push word [imme]
  4479 00002935 E8A6FD                   call genCode8
  4480 00002938 83C402                   add  sp, 2
  4481                                  
  4482                                  ;-86     }    
  4483                                  
  4484                                  @@genImmediate160:
  4485 0000293B C3                       ret
  4486                                  ; ENDP
  4487                                  ;Back to main program: AS.C
  4488                                  
  4489                                  ;-10 
  4490                                  
  4491                                  
  4492                                  ;-11 int process() { 
  4493                                  
  4494                                  
  4495                                  process:  ; *** PROC ***
  4496                                  
  4497                                  ;-12     char c;
  4498                                  
  4499                                  
  4500                                  ;-13     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4501                                  
  4502                                  ;Function : process, Number of local variables: 1
  4503                                  ;   # type sign width line used address name   list of local variables
  4504                                  ;  200 var sign byte    12 NULL bp-2    c;
  4505 0000293C C8020000                 ENTER  2,0
  4506 00002940 E89DE9                   call getTokeType
  4507                                  
  4508                                  ;-14     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4509                                  
  4510 00002943 E8EDEC                   call getCodeSize
  4511 00002946 A2[BE01]                 mov byte [OpSize], al
  4512                                  
  4513                                  ;-15     getCodes();//set: Code1, Code2, Code3
  4514                                  
  4515 00002949 E80EFD                   call getCodes
  4516                                  
  4517                                  ;-16 
  4518                                  
  4519                                  
  4520                                  ;-17     if (CodeType ==  1) {//1 byte opcode
  4521                                  
  4522 0000294C A0[B601]                 mov al, [CodeType]
  4523 0000294F 3C01                     cmp al, 1
  4524 00002951 0F850F00                 jne @@process161
  4525                                  
  4526                                  ;-18         genCode8(Code1);
  4527                                  
  4528 00002955 A0[B701]                 mov al, byte [Code1]
  4529 00002958 B400                     mov ah, 0
  4530 0000295A 50                       push ax
  4531 0000295B E880FD                   call genCode8
  4532 0000295E 83C402                   add  sp, 2
  4533                                  
  4534                                  ;-19         return;
  4535                                  
  4536 00002961 E9AE02                   jmp @@retn
  4537                                  
  4538                                  ;-20     }
  4539                                  
  4540                                  
  4541                                  ;-21   
  4542                                  
  4543                                  
  4544                                  ;-22     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4545                                  
  4546                                  @@process161:
  4547 00002964 A0[B601]                 mov al, [CodeType]
  4548 00002967 3C02                     cmp al, 2
  4549 00002969 0F85DB00                 jne @@process162
  4550                                  
  4551                                  ;-23         getOpL();
  4552                                  
  4553 0000296D E8C003                   call getOpL
  4554                                  
  4555                                  ;-24         checkOpL();     
  4556                                  
  4557 00002970 E8EF02                   call checkOpL
  4558                                  
  4559                                  ;-25        prs("\ncheckOpL Op:"); printhex8a(Op);                
  4560                                  
  4561 00002973 68[142C]                 push process_0
  4562 00002976 E834F6                   call prs
  4563 00002979 83C402                   add  sp, 2
  4564 0000297C A0[B401]                 mov al, byte [Op]
  4565 0000297F B400                     mov ah, 0
  4566 00002981 50                       push ax
  4567 00002982 E8CBF6                   call printhex8a
  4568 00002985 83C402                   add  sp, 2
  4569                                  
  4570                                  ;-26        prs("\, Op2:"); printhex8a(Op2);                
  4571                                  
  4572 00002988 68[232C]                 push process_1
  4573 0000298B E81FF6                   call prs
  4574 0000298E 83C402                   add  sp, 2
  4575 00002991 A0[B501]                 mov al, byte [Op2]
  4576 00002994 B400                     mov ah, 0
  4577 00002996 50                       push ax
  4578 00002997 E8B6F6                   call printhex8a
  4579 0000299A 83C402                   add  sp, 2
  4580                                  
  4581                                  ;-27        prs(", wflag:"); printhex8a(wflag);           
  4582                                  
  4583 0000299D 68[2B2C]                 push process_2
  4584 000029A0 E80AF6                   call prs
  4585 000029A3 83C402                   add  sp, 2
  4586 000029A6 A0[BF01]                 mov al, byte [wflag]
  4587 000029A9 B400                     mov ah, 0
  4588 000029AB 50                       push ax
  4589 000029AC E8A1F6                   call printhex8a
  4590 000029AF 83C402                   add  sp, 2
  4591                                  
  4592                                  ;-28        prs(", OpSize:"); printhex8a(OpSize);         
  4593                                  
  4594 000029B2 68[342C]                 push process_3
  4595 000029B5 E8F5F5                   call prs
  4596 000029B8 83C402                   add  sp, 2
  4597 000029BB A0[BE01]                 mov al, byte [OpSize]
  4598 000029BE B400                     mov ah, 0
  4599 000029C0 50                       push ax
  4600 000029C1 E88CF6                   call printhex8a
  4601 000029C4 83C402                   add  sp, 2
  4602                                  
  4603                                  ;-29         if (Code2 <= 1) {//inc,dec
  4604                                  
  4605 000029C7 A0[B801]                 mov al, [Code2]
  4606 000029CA 3C01                     cmp al, 1
  4607 000029CC 0F8F4500                 jg  @@process163
  4608                                  
  4609                                  ;-30   	        if (Op == REG) {//short
  4610                                  
  4611 000029D0 A0[B401]                 mov al, [Op]
  4612 000029D3 3C02                     cmp al, 2
  4613 000029D5 0F853C00                 jne @@process164
  4614                                  
  4615                                  ;-31                 if (RegType == WORD) {genCode(Code3, RegNo); return; }
  4616                                  
  4617 000029D9 A0[BC01]                 mov al, [RegType]
  4618 000029DC 3C02                     cmp al, 2
  4619 000029DE 0F851500                 jne @@process165
  4620 000029E2 A0[BA01]                 mov al, byte [RegNo]
  4621 000029E5 B400                     mov ah, 0
  4622 000029E7 50                       push ax
  4623 000029E8 A0[B901]                 mov al, byte [Code3]
  4624 000029EB B400                     mov ah, 0
  4625 000029ED 50                       push ax
  4626 000029EE E8A0FC                   call genCode
  4627 000029F1 83C404                   add  sp, 4
  4628 000029F4 E91B02                   jmp @@retn
  4629                                  
  4630                                  ;-32                 if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
  4631                                  
  4632                                  @@process165:
  4633 000029F7 A0[BC01]                 mov al, [RegType]
  4634 000029FA 3C03                     cmp al, 3
  4635 000029FC 0F851500                 jne @@process166
  4636 00002A00 A0[BA01]                 mov al, byte [RegNo]
  4637 00002A03 B400                     mov ah, 0
  4638 00002A05 50                       push ax
  4639 00002A06 A0[B901]                 mov al, byte [Code3]
  4640 00002A09 B400                     mov ah, 0
  4641 00002A0B 50                       push ax
  4642 00002A0C E882FC                   call genCode
  4643 00002A0F 83C404                   add  sp, 4
  4644 00002A12 E9FD01                   jmp @@retn
  4645                                  
  4646                                  ;-33             }
  4647                                  
  4648                                  @@process166:
  4649                                  
  4650                                  ;-34         }
  4651                                  
  4652                                  @@process164:
  4653                                  
  4654                                  ;-35         if (Code2 == 5) {//imul extension?
  4655                                  
  4656                                  @@process163:
  4657 00002A15 A0[B801]                 mov al, [Code2]
  4658 00002A18 3C05                     cmp al, 5
  4659 00002A1A 0F850F00                 jne @@process167
  4660                                  
  4661                                  ;-36             getTokeType();
  4662                                  
  4663 00002A1E E8BFE8                   call getTokeType
  4664                                  
  4665                                  ;-37             if (TokeType) implerror();
  4666                                  
  4667 00002A21 A0[B301]                 mov al, [TokeType]
  4668 00002A24 08C0                     or  al, al
  4669 00002A26 0F840300                 je @@process168
  4670 00002A2A E89EF7                   call implerror
  4671                                  
  4672                                  ;-38         }
  4673                                  
  4674                                  @@process168:
  4675                                  
  4676                                  ;-39         genCodeW(Code1);
  4677                                  
  4678                                  @@process167:
  4679 00002A2D A0[B701]                 mov al, byte [Code1]
  4680 00002A30 B400                     mov ah, 0
  4681 00002A32 50                       push ax
  4682 00002A33 E88CFC                   call genCodeW
  4683 00002A36 83C402                   add  sp, 2
  4684                                  
  4685                                  ;-40         writeEA(Code2);
  4686                                  
  4687 00002A39 A0[B801]                 mov al, byte [Code2]
  4688 00002A3C B400                     mov ah, 0
  4689 00002A3E 50                       push ax
  4690 00002A3F E814FD                   call writeEA
  4691 00002A42 83C402                   add  sp, 2
  4692                                  
  4693                                  ;-41         return;
  4694                                  
  4695 00002A45 E9CA01                   jmp @@retn
  4696                                  
  4697                                  ;-42     }
  4698                                  
  4699                                  
  4700                                  ;-43   
  4701                                  
  4702                                  
  4703                                  ;-44     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4704                                  
  4705                                  @@process162:
  4706 00002A48 A0[B601]                 mov al, [CodeType]
  4707 00002A4B 3C03                     cmp al, 3
  4708 00002A4D 0F856200                 jne @@process169
  4709                                  
  4710                                  ;-45         getOpL();
  4711                                  
  4712 00002A51 E8DC02                   call getOpL
  4713                                  
  4714                                  ;-46         if (RegType != WORD) reg16error();//only r16
  4715                                  
  4716 00002A54 A0[BC01]                 mov al, [RegType]
  4717 00002A57 3C02                     cmp al, 2
  4718 00002A59 0F840300                 je  @@process170
  4719 00002A5D E80BF8                   call reg16error
  4720                                  
  4721                                  ;-47         need(',');   
  4722                                  
  4723                                  @@process170:
  4724 00002A60 6A2C                     push 44
  4725 00002A62 E87FEC                   call need
  4726 00002A65 83C402                   add  sp, 2
  4727                                  
  4728                                  ;-48         R1No = RegNo; 
  4729                                  
  4730 00002A68 A0[BA01]                 mov al, [RegNo]
  4731 00002A6B A2[BB01]                 mov byte [R1No], al
  4732                                  
  4733                                  ;-49         getOpR();
  4734                                  
  4735 00002A6E E8FC02                   call getOpR
  4736                                  
  4737                                  ;-50         if (Op2 != MEM) addrerror();//only m16 
  4738                                  
  4739 00002A71 A0[B501]                 mov al, [Op2]
  4740 00002A74 3C04                     cmp al, 4
  4741 00002A76 0F840300                 je  @@process171
  4742 00002A7A E807F7                   call addrerror
  4743                                  
  4744                                  ;-51         
  4745                                  
  4746                                  
  4747                                  ;-52         genCode8(Code1);//les,lds,lea
  4748                                  
  4749                                  @@process171:
  4750 00002A7D A0[B701]                 mov al, byte [Code1]
  4751 00002A80 B400                     mov ah, 0
  4752 00002A82 50                       push ax
  4753 00002A83 E858FC                   call genCode8
  4754 00002A86 83C402                   add  sp, 2
  4755                                  
  4756                                  ;-53         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  4757                                  
  4758 00002A89 A0[B701]                 mov al, [Code1]
  4759 00002A8C 3C0F                     cmp al, 15
  4760 00002A8E 0F850C00                 jne @@process172
  4761 00002A92 A0[B801]                 mov al, byte [Code2]
  4762 00002A95 B400                     mov ah, 0
  4763 00002A97 50                       push ax
  4764 00002A98 E843FC                   call genCode8
  4765 00002A9B 83C402                   add  sp, 2
  4766                                  
  4767                                  ;-54         Op=Op2;//writeEA with 2. Op  
  4768                                  
  4769                                  @@process172:
  4770 00002A9E A0[B501]                 mov al, [Op2]
  4771 00002AA1 A2[B401]                 mov byte [Op], al
  4772                                  
  4773                                  ;-55         writeEA(R1No);           
  4774                                  
  4775 00002AA4 A0[BB01]                 mov al, byte [R1No]
  4776 00002AA7 B400                     mov ah, 0
  4777 00002AA9 50                       push ax
  4778 00002AAA E8A9FC                   call writeEA
  4779 00002AAD 83C402                   add  sp, 2
  4780                                  
  4781                                  ;-56         return;
  4782                                  
  4783 00002AB0 E95F01                   jmp @@retn
  4784                                  
  4785                                  ;-57     }
  4786                                  
  4787                                  
  4788                                  ;-58 
  4789                                  
  4790                                  
  4791                                  ;-59     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  4792                                  
  4793                                  @@process169:
  4794 00002AB3 A0[B601]                 mov al, [CodeType]
  4795 00002AB6 3C04                     cmp al, 4
  4796 00002AB8 0F85EF00                 jne @@process173
  4797                                  
  4798                                  ;-60         get2Ops();    
  4799                                  
  4800 00002ABC E85602                   call get2Ops
  4801                                  
  4802                                  ;-61         if (Op == IMM) immeerror();   
  4803                                  
  4804 00002ABF A0[B401]                 mov al, [Op]
  4805 00002AC2 3C01                     cmp al, 1
  4806 00002AC4 0F850300                 jne @@process174
  4807 00002AC8 E8DBF6                   call immeerror
  4808                                  
  4809                                  ;-62         if (Op == ADR) invaloperror();     
  4810                                  
  4811                                  @@process174:
  4812 00002ACB A0[B401]                 mov al, [Op]
  4813 00002ACE 3C03                     cmp al, 3
  4814 00002AD0 0F850300                 jne @@process175
  4815 00002AD4 E82FF7                   call invaloperror
  4816                                  
  4817                                  ;-63         setwflag();
  4818                                  
  4819                                  @@process175:
  4820 00002AD7 E86E05                   call setwflag
  4821                                  
  4822                                  ;-64 //       prs("\nOp:"); printhex8a(Op);                
  4823                                  
  4824                                  
  4825                                  ;-65 //       prs("\, Op2:"); printhex8a(Op2);                
  4826                                  
  4827                                  
  4828                                  ;-66 //       prs(", wflag:"); printhex8a(wflag);           
  4829                                  
  4830                                  
  4831                                  ;-67 //       prs(", OpSize:"); printhex8a(OpSize);            
  4832                                  
  4833                                  
  4834                                  ;-68         if (Op2 == IMM) {//second operand is imm     
  4835                                  
  4836 00002ADA A0[B501]                 mov al, [Op2]
  4837 00002ADD 3C01                     cmp al, 1
  4838 00002ADF 0F856200                 jne @@process176
  4839                                  
  4840                                  ;-69             getSignExtended(imme);   
  4841                                  
  4842 00002AE3 FF36[C501]               push word [imme]
  4843 00002AE7 E8DA05                   call getSignExtended
  4844 00002AEA 83C402                   add  sp, 2
  4845                                  
  4846                                  ;-70             if (Op == REG) {                
  4847                                  
  4848 00002AED A0[B401]                 mov al, [Op]
  4849 00002AF0 3C02                     cmp al, 2
  4850 00002AF2 0F852900                 jne @@process177
  4851                                  
  4852                                  ;-71                 if (R1No == 0) {
  4853                                  
  4854 00002AF6 A0[BB01]                 mov al, [R1No]
  4855 00002AF9 3C00                     cmp al, 0
  4856 00002AFB 0F852000                 jne @@process178
  4857                                  
  4858                                  ;-72                     Code1 = Code1 << 3;
  4859                                  
  4860 00002AFF A0[B701]                 mov al, [Code1]
  4861 00002B02 C0E003                   shl al, 3
  4862 00002B05 A2[B701]                 mov byte [Code1], al
  4863                                  
  4864                                  ;-73                     Code1 += 4;//code for acc,imm     
  4865                                  
  4866 00002B08 8006[B701]04             add  byte [Code1], 4
  4867                                  
  4868                                  ;-74                     genCodeW(Code1);
  4869                                  
  4870 00002B0D A0[B701]                 mov al, byte [Code1]
  4871 00002B10 B400                     mov ah, 0
  4872 00002B12 50                       push ax
  4873 00002B13 E8ACFB                   call genCodeW
  4874 00002B16 83C402                   add  sp, 2
  4875                                  
  4876                                  ;-75                     genImmediate();
  4877                                  
  4878 00002B19 E8EDFD                   call genImmediate
  4879                                  
  4880                                  ;-76                     return;
  4881                                  
  4882 00002B1C E9F300                   jmp @@retn
  4883                                  
  4884                                  ;-77                 }
  4885                                  
  4886                                  
  4887                                  ;-78             }
  4888                                  
  4889                                  @@process178:
  4890                                  
  4891                                  ;-79             //r/m, imm: 80 sign-extended,TTT,imm
  4892                                  
  4893                                  
  4894                                  ;-80             c = sflag + 0x80;       
  4895                                  
  4896                                  @@process177:
  4897 00002B1F A0[C001]                 mov al, [sflag]
  4898 00002B22 0480                     add al, 128
  4899 00002B24 8846FE                   mov byte [bp-2], al
  4900                                  
  4901                                  ;-81             genCodeW(c); 
  4902                                  
  4903 00002B27 8A46FE                   mov al, byte [bp-2]
  4904 00002B2A B400                     mov ah, 0
  4905 00002B2C 50                       push ax
  4906 00002B2D E892FB                   call genCodeW
  4907 00002B30 83C402                   add  sp, 2
  4908                                  
  4909                                  ;-82             writeEA(Code1);//todo not Op??  
  4910                                  
  4911 00002B33 A0[B701]                 mov al, byte [Code1]
  4912 00002B36 B400                     mov ah, 0
  4913 00002B38 50                       push ax
  4914 00002B39 E81AFC                   call writeEA
  4915 00002B3C 83C402                   add  sp, 2
  4916                                  
  4917                                  ;-83             genImmediate();
  4918                                  
  4919 00002B3F E8C7FD                   call genImmediate
  4920                                  
  4921                                  ;-84             return;     
  4922                                  
  4923 00002B42 E9CD00                   jmp @@retn
  4924                                  
  4925                                  ;-85         }  
  4926                                  
  4927                                  
  4928                                  ;-86        
  4929                                  
  4930                                  
  4931                                  ;-87         c = Code1 << 3;//r/m, r/m  
  4932                                  
  4933                                  @@process176:
  4934 00002B45 A0[B701]                 mov al, [Code1]
  4935 00002B48 C0E003                   shl al, 3
  4936 00002B4B 8846FE                   mov byte [bp-2], al
  4937                                  
  4938                                  ;-88         if (Op == REG) {
  4939                                  
  4940 00002B4E A0[B401]                 mov al, [Op]
  4941 00002B51 3C02                     cmp al, 2
  4942 00002B53 0F852A00                 jne @@process179
  4943                                  
  4944                                  ;-89             if (Op2 == MEM) {//reg, mem        
  4945                                  
  4946 00002B57 A0[B501]                 mov al, [Op2]
  4947 00002B5A 3C04                     cmp al, 4
  4948 00002B5C 0F852100                 jne @@process180
  4949                                  
  4950                                  ;-90 //   prs(", c:"); printhex8a(c);           
  4951                                  
  4952                                  
  4953                                  ;-91                 genCodeDW(c);//implicit set directionflag
  4954                                  
  4955 00002B60 8A46FE                   mov al, byte [bp-2]
  4956 00002B63 B400                     mov ah, 0
  4957 00002B65 50                       push ax
  4958 00002B66 E843FB                   call genCodeDW
  4959 00002B69 83C402                   add  sp, 2
  4960                                  
  4961                                  ;-92                 Op=Op2;//writeEA with 2. Op  
  4962                                  
  4963 00002B6C A0[B501]                 mov al, [Op2]
  4964 00002B6F A2[B401]                 mov byte [Op], al
  4965                                  
  4966                                  ;-93                 writeEA(R1No);
  4967                                  
  4968 00002B72 A0[BB01]                 mov al, byte [R1No]
  4969 00002B75 B400                     mov ah, 0
  4970 00002B77 50                       push ax
  4971 00002B78 E8DBFB                   call writeEA
  4972 00002B7B 83C402                   add  sp, 2
  4973                                  
  4974                                  ;-94                 return;    
  4975                                  
  4976 00002B7E E99100                   jmp @@retn
  4977                                  
  4978                                  ;-95             }
  4979                                  
  4980                                  
  4981                                  ;-96         }
  4982                                  
  4983                                  @@process180:
  4984                                  
  4985                                  ;-97         if (Op2 == REG) {//mem,reg    reg,reg
  4986                                  
  4987                                  @@process179:
  4988 00002B81 A0[B501]                 mov al, [Op2]
  4989 00002B84 3C02                     cmp al, 2
  4990 00002B86 0F851B00                 jne @@process181
  4991                                  
  4992                                  ;-98             genCodeW(c);
  4993                                  
  4994 00002B8A 8A46FE                   mov al, byte [bp-2]
  4995 00002B8D B400                     mov ah, 0
  4996 00002B8F 50                       push ax
  4997 00002B90 E82FFB                   call genCodeW
  4998 00002B93 83C402                   add  sp, 2
  4999                                  
  5000                                  ;-99             writeEA(RegNo);//2. Op in reg-field
  5001                                  
  5002 00002B96 A0[BA01]                 mov al, byte [RegNo]
  5003 00002B99 B400                     mov ah, 0
  5004 00002B9B 50                       push ax
  5005 00002B9C E8B7FB                   call writeEA
  5006 00002B9F 83C402                   add  sp, 2
  5007                                  
  5008                                  ;-100             return;            
  5009                                  
  5010 00002BA2 E96D00                   jmp @@retn
  5011                                  
  5012                                  ;-101         }          
  5013                                  
  5014                                  
  5015                                  ;-102         
  5016                                  
  5017                                  
  5018                                  ;-103         syntaxerror();        
  5019                                  
  5020                                  @@process181:
  5021 00002BA5 E812F7                   call syntaxerror
  5022                                  
  5023                                  ;-104         return;
  5024                                  
  5025 00002BA8 E96700                   jmp @@retn
  5026                                  
  5027                                  ;-105     }
  5028                                  
  5029                                  
  5030                                  ;-106    
  5031                                  
  5032                                  
  5033                                  ;-107     if (CodeType ==  8) {//ret,retf
  5034                                  
  5035                                  @@process173:
  5036 00002BAB A0[B601]                 mov al, [CodeType]
  5037 00002BAE 3C08                     cmp al, 8
  5038 00002BB0 0F853100                 jne @@process182
  5039                                  
  5040                                  ;-108         if (TokeType == DIGIT) {
  5041                                  
  5042 00002BB4 A0[B301]                 mov al, [TokeType]
  5043 00002BB7 3C01                     cmp al, 1
  5044 00002BB9 0F851900                 jne @@process183
  5045                                  
  5046                                  ;-109             genCode8(Code2);
  5047                                  
  5048 00002BBD A0[B801]                 mov al, byte [Code2]
  5049 00002BC0 B400                     mov ah, 0
  5050 00002BC2 50                       push ax
  5051 00002BC3 E818FB                   call genCode8
  5052 00002BC6 83C402                   add  sp, 2
  5053                                  
  5054                                  ;-110             genCode16(SymbolInt);
  5055                                  
  5056 00002BC9 FF36[5500]               push word [SymbolInt]
  5057 00002BCD E865FB                   call genCode16
  5058 00002BD0 83C402                   add  sp, 2
  5059                                  
  5060                                  ;-111             return;
  5061                                  
  5062 00002BD3 E93C00                   jmp @@retn
  5063                                  
  5064                                  ;-112         }
  5065                                  
  5066                                  
  5067                                  ;-113         genCode8(Code1); 
  5068                                  
  5069                                  @@process183:
  5070 00002BD6 A0[B701]                 mov al, byte [Code1]
  5071 00002BD9 B400                     mov ah, 0
  5072 00002BDB 50                       push ax
  5073 00002BDC E8FFFA                   call genCode8
  5074 00002BDF 83C402                   add  sp, 2
  5075                                  
  5076                                  ;-114         return;
  5077                                  
  5078 00002BE2 E92D00                   jmp @@retn
  5079                                  
  5080                                  ;-115     }
  5081                                  
  5082                                  
  5083                                  ;-116 
  5084                                  
  5085                                  
  5086                                  ;-117     if (CodeType==101) {// ORG nn
  5087                                  
  5088                                  @@process182:
  5089 00002BE5 A0[B601]                 mov al, [CodeType]
  5090 00002BE8 3C65                     cmp al, 101
  5091 00002BEA 0F851B00                 jne @@process184
  5092                                  
  5093                                  ;-118         if (TokeType != DIGIT) error1("only digit allowed");
  5094                                  
  5095 00002BEE A0[B301]                 mov al, [TokeType]
  5096 00002BF1 3C01                     cmp al, 1
  5097 00002BF3 0F840900                 je  @@process185
  5098 00002BF7 68[3E2C]                 push process_4
  5099 00002BFA E80DF5                   call error1
  5100 00002BFD 83C402                   add  sp, 2
  5101                                  
  5102                                  ;-119         PC=SymbolInt;
  5103                                  
  5104                                  @@process185:
  5105 00002C00 A1[5500]                 mov ax, [SymbolInt]
  5106 00002C03 A3[AE01]                 mov word [PC], ax
  5107                                  
  5108                                  ;-120         return;
  5109                                  
  5110 00002C06 E90900                   jmp @@retn
  5111                                  
  5112                                  ;-121     }
  5113                                  
  5114                                  
  5115                                  ;-122     error1("unknown CodeType");
  5116                                  
  5117                                  @@process184:
  5118 00002C09 68[512C]                 push process_5
  5119 00002C0C E8FBF4                   call error1
  5120 00002C0F 83C402                   add  sp, 2
  5121                                  
  5122                                  ;-123 }    
  5123                                  
  5124                                  
  5125                                  ;-124 
  5126                                  
  5127                                  
  5128                                  ;-125 int checkOpL() {
  5129                                  
  5130 00002C12 C9                      @@retn: LEAVE
  5131 00002C13 C3                       ret
  5132                                  ; ENDP
  5133 00002C14 5C6E636865636B4F70-     process_0 db "\ncheckOpL Op:",0
  5134 00002C1D 4C204F703A00       
  5135 00002C23 5C2C204F70323A00        process_1 db "\, Op2:",0
  5136 00002C2B 2C2077666C61673A00      process_2 db ", wflag:",0
  5137 00002C34 2C204F7053697A653A-     process_3 db ", OpSize:",0
  5138 00002C3D 00                 
  5139 00002C3E 6F6E6C792064696769-     process_4 db "only digit allowed",0
  5140 00002C47 7420616C6C6F776564-
  5141 00002C50 00                 
  5142 00002C51 756E6B6E6F776E2043-     process_5 db "unknown CodeType",0
  5143 00002C5A 6F64655479706500   
  5144                                  
  5145                                  checkOpL:  ; *** PROC ***
  5146                                  
  5147                                  ;-126     if (Op == ADR) implerror();
  5148                                  
  5149 00002C62 A0[B401]                 mov al, [Op]
  5150 00002C65 3C03                     cmp al, 3
  5151 00002C67 0F850300                 jne @@checkOpL186
  5152 00002C6B E85DF5                   call implerror
  5153                                  
  5154                                  ;-127     if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  5155                                  
  5156                                  @@checkOpL186:
  5157 00002C6E A0[BC01]                 mov al, [RegType]
  5158 00002C71 3C04                     cmp al, 4
  5159 00002C73 0F850600                 jne @@checkOpL187
  5160 00002C77 E819F6                   call segregerror
  5161 00002C7A E95300                   jmp @@retn
  5162                                  
  5163                                  ;-128     setwflag();
  5164                                  
  5165                                  @@checkOpL187:
  5166 00002C7D E8C803                   call setwflag
  5167                                  
  5168                                  ;-129     if (OpSize == 0) error1("no op size declared");
  5169                                  
  5170 00002C80 A0[BE01]                 mov al, [OpSize]
  5171 00002C83 3C00                     cmp al, 0
  5172 00002C85 0F850900                 jne @@checkOpL188
  5173 00002C89 68[D12C]                 push checkOpL_0
  5174 00002C8C E87BF4                   call error1
  5175 00002C8F 83C402                   add  sp, 2
  5176                                  
  5177                                  ;-130     if (OpSize == RegType) return;
  5178                                  
  5179                                  @@checkOpL188:
  5180 00002C92 A0[BE01]                 mov al, [OpSize]
  5181 00002C95 3A06[BC01]               cmp al, [RegType]
  5182 00002C99 0F850300                 jne @@checkOpL189
  5183 00002C9D E93000                   jmp @@retn
  5184                                  
  5185                                  ;-131     if (OpSize){
  5186                                  
  5187                                  @@checkOpL189:
  5188 00002CA0 A0[BE01]                 mov al, [OpSize]
  5189 00002CA3 08C0                     or  al, al
  5190 00002CA5 0F841500                 je @@checkOpL190
  5191                                  
  5192                                  ;-132         if (Op == MEM) return;
  5193                                  
  5194 00002CA9 A0[B401]                 mov al, [Op]
  5195 00002CAC 3C04                     cmp al, 4
  5196 00002CAE 0F850300                 jne @@checkOpL191
  5197 00002CB2 E91B00                   jmp @@retn
  5198                                  
  5199                                  ;-133         error1("Conflict OpSize and RegSize"); 
  5200                                  
  5201                                  @@checkOpL191:
  5202 00002CB5 68[E52C]                 push checkOpL_1
  5203 00002CB8 E84FF4                   call error1
  5204 00002CBB 83C402                   add  sp, 2
  5205                                  
  5206                                  ;-134         }
  5207                                  
  5208                                  
  5209                                  ;-135     if (RegType==0) error1("no register defined");
  5210                                  
  5211                                  @@checkOpL190:
  5212 00002CBE A0[BC01]                 mov al, [RegType]
  5213 00002CC1 3C00                     cmp al, 0
  5214 00002CC3 0F850900                 jne @@checkOpL192
  5215 00002CC7 68[012D]                 push checkOpL_2
  5216 00002CCA E83DF4                   call error1
  5217 00002CCD 83C402                   add  sp, 2
  5218                                  
  5219                                  ;-136 }
  5220                                  
  5221                                  @@checkOpL192:
  5222                                  
  5223                                  ;-137 /*    Op, Op2 =0, 1=IMM, 2=REG, 3=ADR, 4=MEM 
  5224                                  
  5225                                  
  5226                                  ;-138 IMM      imme           = 0, SymbolInt
  5227                                  
  5228                                  
  5229                                  ;-139 REG      R1No,RegNo     = 0 - 7
  5230                                  
  5231                                  
  5232                                  ;-140 REG      R1Type,RegType = 0, BYTE, WORD, DWORD, SEGREG 
  5233                                  
  5234                                  
  5235                                  ;-141 MEM,ADR  disp           = 0, LabelAddr[LabelIx]
  5236                                  
  5237                                  
  5238                                  ;-142 MEM      regindexbase   = 0 - 7
  5239                                  
  5240                                  
  5241                                  ;-143          OpSize         = 0, BYTE, WORD, DWORD
  5242                                  
  5243                                  
  5244                                  ;-144          wflag          */         
  5245                                  
  5246                                  
  5247                                  ;-145 int get2Ops() {
  5248                                  
  5249                                  @@retn:
  5250 00002CD0 C3                       ret
  5251                                  ; ENDP
  5252 00002CD1 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  5253 00002CDA 65206465636C617265-
  5254 00002CE3 6400               
  5255 00002CE5 436F6E666C69637420-     checkOpL_1 db "Conflict OpSize and RegSize",0
  5256 00002CEE 4F7053697A6520616E-
  5257 00002CF7 642052656753697A65-
  5258 00002D00 00                 
  5259 00002D01 6E6F20726567697374-     checkOpL_2 db "no register defined",0
  5260 00002D0A 657220646566696E65-
  5261 00002D13 6400               
  5262                                  
  5263                                  get2Ops:  ; *** PROC ***
  5264                                  
  5265                                  ;-146     getOpL();
  5266                                  
  5267 00002D15 E81800                   call getOpL
  5268                                  
  5269                                  ;-147     R1No=RegNo;   
  5270                                  
  5271 00002D18 A0[BA01]                 mov al, [RegNo]
  5272 00002D1B A2[BB01]                 mov byte [R1No], al
  5273                                  
  5274                                  ;-148     R1Type = RegType;
  5275                                  
  5276 00002D1E A0[BC01]                 mov al, [RegType]
  5277 00002D21 A2[BD01]                 mov byte [R1Type], al
  5278                                  
  5279                                  ;-149     need(',');    
  5280                                  
  5281 00002D24 6A2C                     push 44
  5282 00002D26 E8BBE9                   call need
  5283 00002D29 83C402                   add  sp, 2
  5284                                  
  5285                                  ;-150     getOpR();         
  5286                                  
  5287 00002D2C E83E00                   call getOpR
  5288                                  
  5289                                  ;-151 }         
  5290                                  
  5291                                  
  5292                                  ;-152 int getOpL() {
  5293                                  
  5294 00002D2F C3                       ret
  5295                                  ; ENDP
  5296                                  
  5297                                  getOpL:  ; *** PROC ***
  5298                                  
  5299                                  ;-153 //set: op1=0,IMM,REG,ADR,MEM
  5300                                  
  5301                                  
  5302                                  ;-154     disp=0; imme=0; isDirect=1; 
  5303                                  
  5304 00002D30 66B800000000             mov eax, 0
  5305 00002D36 A3[C301]                 mov word [disp], ax
  5306 00002D39 66B800000000             mov eax, 0
  5307 00002D3F A3[C501]                 mov word [imme], ax
  5308 00002D42 66B801000000             mov eax, 1
  5309 00002D48 A2[C201]                 mov byte [isDirect], al
  5310                                  
  5311                                  ;-155     getOpR();
  5312                                  
  5313 00002D4B E81F00                   call getOpR
  5314                                  
  5315                                  ;-156     Op=Op2;
  5316                                  
  5317 00002D4E A0[B501]                 mov al, [Op2]
  5318 00002D51 A2[B401]                 mov byte [Op], al
  5319                                  
  5320                                  ;-157     Op2=0;//for single operand statement    
  5321                                  
  5322 00002D54 66B800000000             mov eax, 0
  5323 00002D5A A2[B501]                 mov byte [Op2], al
  5324                                  
  5325                                  ;-158     R1Type=RegType;
  5326                                  
  5327 00002D5D A0[BC01]                 mov al, [RegType]
  5328 00002D60 A2[BD01]                 mov byte [R1Type], al
  5329                                  
  5330                                  ;-159     RegType=0;//for WriteEA  
  5331                                  
  5332 00002D63 66B800000000             mov eax, 0
  5333 00002D69 A2[BC01]                 mov byte [RegType], al
  5334                                  
  5335                                  ;-160 }  
  5336                                  
  5337                                  
  5338                                  ;-161 
  5339                                  
  5340                                  
  5341                                  ;-162 int getOpR() {
  5342                                  
  5343 00002D6C C3                       ret
  5344                                  ; ENDP
  5345                                  
  5346                                  getOpR:  ; *** PROC ***
  5347                                  
  5348                                  ;-163     Op2=getOp1();
  5349                                  
  5350 00002D6D E88900                   call getOp1
  5351 00002D70 A2[B501]                 mov byte [Op2], al
  5352                                  
  5353                                  ;-164     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  5354                                  
  5355 00002D73 6A5B                     push 91
  5356 00002D75 E83EE9                   call isToken
  5357 00002D78 83C402                   add  sp, 2
  5358 00002D7B 08C0                     or  al, al
  5359 00002D7D 0F840F00                 je @@getOpR193
  5360 00002D81 66B804000000             mov eax, 4
  5361 00002D87 A2[B501]                 mov byte [Op2], al
  5362 00002D8A E8F200                   call getMEM
  5363 00002D8D E94F00                   jmp @@retn
  5364                                  
  5365                                  ;-165     if (Op2 == 0)     {invaloperror();         return;}
  5366                                  
  5367                                  @@getOpR193:
  5368 00002D90 A0[B501]                 mov al, [Op2]
  5369 00002D93 3C00                     cmp al, 0
  5370 00002D95 0F850600                 jne @@getOpR194
  5371 00002D99 E86AF4                   call invaloperror
  5372 00002D9C E94000                   jmp @@retn
  5373                                  
  5374                                  ;-166     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  5375                                  
  5376                                  @@getOpR194:
  5377 00002D9F A0[B501]                 mov al, [Op2]
  5378 00002DA2 3C01                     cmp al, 1
  5379 00002DA4 0F850900                 jne @@getOpR195
  5380 00002DA8 A1[5500]                 mov ax, [SymbolInt]
  5381 00002DAB A3[C501]                 mov word [imme], ax
  5382 00002DAE E92E00                   jmp @@retn
  5383                                  
  5384                                  ;-167     if (Op2 == REG)                            return;
  5385                                  
  5386                                  @@getOpR195:
  5387 00002DB1 A0[B501]                 mov al, [Op2]
  5388 00002DB4 3C02                     cmp al, 2
  5389 00002DB6 0F850300                 jne @@getOpR196
  5390 00002DBA E92200                   jmp @@retn
  5391                                  
  5392                                  ;-168     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  5393                                  
  5394                                  @@getOpR196:
  5395 00002DBD A0[B501]                 mov al, [Op2]
  5396 00002DC0 3C03                     cmp al, 3
  5397 00002DC2 0F851000                 jne @@getOpR197
  5398 00002DC6 8B1E[8506]               mov bx, [LabelIx]
  5399 00002DCA D1E3                     shl bx, 1
  5400 00002DCC 8B87[BB05]               mov ax, [LabelAddr + bx]
  5401 00002DD0 A3[C301]                 mov word [disp], ax
  5402 00002DD3 E90900                   jmp @@retn
  5403                                  
  5404                                  ;-169     error1("Name of operand expected");
  5405                                  
  5406                                  @@getOpR197:
  5407 00002DD6 68[E02D]                 push getOpR_0
  5408 00002DD9 E82EF3                   call error1
  5409 00002DDC 83C402                   add  sp, 2
  5410                                  
  5411                                  ;-170 }
  5412                                  
  5413                                  
  5414                                  ;-171 
  5415                                  
  5416                                  
  5417                                  ;-172 int getOp1() {//scan for a single operand
  5418                                  
  5419                                  @@retn:
  5420 00002DDF C3                       ret
  5421                                  ; ENDP
  5422 00002DE0 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  5423 00002DE9 706572616E64206578-
  5424 00002DF2 70656374656400     
  5425                                  
  5426                                  getOp1:  ; *** PROC ***
  5427                                  
  5428                                  ;-173 //return:0, IMM, REG, ADR (not MEM)
  5429                                  
  5430                                  
  5431                                  ;-174 //set   :RegType, RegNo by testReg
  5432                                  
  5433                                  
  5434                                  ;-175 //set   :LabelIx by searchLabel
  5435                                  
  5436                                  
  5437                                  ;-176     if (TokeType == 0)      return 0;
  5438                                  
  5439 00002DF9 A0[B301]                 mov al, [TokeType]
  5440 00002DFC 3C00                     cmp al, 0
  5441 00002DFE 0F850900                 jne @@getOp1198
  5442 00002E02 66B800000000             mov eax, 0
  5443 00002E08 E96000                   jmp @@retn
  5444                                  
  5445                                  ;-177     if (TokeType == DIGIT)  return IMM;
  5446                                  
  5447                                  @@getOp1198:
  5448 00002E0B A0[B301]                 mov al, [TokeType]
  5449 00002E0E 3C01                     cmp al, 1
  5450 00002E10 0F850900                 jne @@getOp1199
  5451 00002E14 66B801000000             mov eax, 1
  5452 00002E1A E94E00                   jmp @@retn
  5453                                  
  5454                                  ;-178     if (TokeType == ALNUME) {
  5455                                  
  5456                                  @@getOp1199:
  5457 00002E1D A0[B301]                 mov al, [TokeType]
  5458 00002E20 3C03                     cmp al, 3
  5459 00002E22 0F853C00                 jne @@getOp1200
  5460                                  
  5461                                  ;-179         RegNo=testReg();
  5462                                  
  5463 00002E26 E83AEC                   call testReg
  5464 00002E29 A2[BA01]                 mov byte [RegNo], al
  5465                                  
  5466                                  ;-180         if (RegType)        return REG;
  5467                                  
  5468 00002E2C A0[BC01]                 mov al, [RegType]
  5469 00002E2F 08C0                     or  al, al
  5470 00002E31 0F840900                 je @@getOp1201
  5471 00002E35 66B802000000             mov eax, 2
  5472 00002E3B E92D00                   jmp @@retn
  5473                                  
  5474                                  ;-181         LabelIx=searchLabel();
  5475                                  
  5476                                  @@getOp1201:
  5477 00002E3E E8E0E5                   call searchLabel
  5478 00002E41 A3[8506]                 mov word [LabelIx], ax
  5479                                  
  5480                                  ;-182         if (LabelIx)        return ADR;
  5481                                  
  5482 00002E44 A1[8506]                 mov ax, [LabelIx]
  5483 00002E47 08C0                     or  al, al
  5484 00002E49 0F840C00                 je @@getOp1202
  5485 00002E4D 66B803000000             mov eax, 3
  5486 00002E53 E91500                   jmp @@retn
  5487                                  
  5488                                  ;-183         else error1("variable not found"); 
  5489                                  
  5490 00002E56 E90900                   jmp @@getOp1203
  5491                                  @@getOp1202:
  5492 00002E59 68[6C2E]                 push getOp1_0
  5493 00002E5C E8ABF2                   call error1
  5494 00002E5F 83C402                   add  sp, 2
  5495                                  
  5496                                  ;-184     }
  5497                                  
  5498                                  @@getOp1203:
  5499                                  
  5500                                  ;-185     return 0;
  5501                                  
  5502                                  @@getOp1200:
  5503 00002E62 66B800000000             mov eax, 0
  5504 00002E68 E90000                   jmp @@retn
  5505                                  
  5506                                  ;-186 }
  5507                                  
  5508                                  
  5509                                  ;-187 
  5510                                  
  5511                                  
  5512                                  ;-188 int getMEM() {// e.g. [array+bp+si-4]
  5513                                  
  5514                                  @@retn:
  5515 00002E6B C3                       ret
  5516                                  ; ENDP
  5517 00002E6C 7661726961626C6520-     getOp1_0 db "variable not found",0
  5518 00002E75 6E6F7420666F756E64-
  5519 00002E7E 00                 
  5520                                  
  5521                                  getMEM:  ; *** PROC ***
  5522                                  
  5523                                  ;-189 //set: disp, regindexbase, RegType
  5524                                  
  5525                                  
  5526                                  ;-190     char c;
  5527                                  
  5528                                  
  5529                                  ;-191     disp=0; regindexbase=0;
  5530                                  
  5531                                  ;Function : getMEM, Number of local variables: 1
  5532                                  ;   # type sign width line used address name   list of local variables
  5533                                  ;  200 var sign byte   190 NULL bp-2    c;
  5534 00002E7F C8020000                 ENTER  2,0
  5535 00002E83 66B800000000             mov eax, 0
  5536 00002E89 A3[C301]                 mov word [disp], ax
  5537 00002E8C 66B800000000             mov eax, 0
  5538 00002E92 A2[C101]                 mov byte [regindexbase], al
  5539                                  
  5540                                  ;-192     do {
  5541                                  
  5542                                  @@getMEM204:
  5543                                  
  5544                                  ;-193         getTokeType();
  5545                                  
  5546 00002E95 E848E4                   call getTokeType
  5547                                  
  5548                                  ;-194         c=getOp1();
  5549                                  
  5550 00002E98 E85EFF                   call getOp1
  5551 00002E9B 8846FE                   mov byte [bp-2], al
  5552                                  
  5553                                  ;-195         if (c ==   0) syntaxerror();
  5554                                  
  5555 00002E9E 8A46FE                   mov al, [bp-2]
  5556 00002EA1 3C00                     cmp al, 0
  5557 00002EA3 0F850300                 jne @@getMEM205
  5558 00002EA7 E810F4                   call syntaxerror
  5559                                  
  5560                                  ;-196         if (c == REG) {isDirect=0;
  5561                                  
  5562                                  @@getMEM205:
  5563 00002EAA 8A46FE                   mov al, [bp-2]
  5564 00002EAD 3C02                     cmp al, 2
  5565 00002EAF 0F851E00                 jne @@getMEM206
  5566 00002EB3 66B800000000             mov eax, 0
  5567 00002EB9 A2[C201]                 mov byte [isDirect], al
  5568                                  
  5569                                  ;-197             if (regindexbase) regindexbase=getIndReg2();
  5570                                  
  5571 00002EBC A0[C101]                 mov al, [regindexbase]
  5572 00002EBF 08C0                     or  al, al
  5573 00002EC1 0F840900                 je @@getMEM207
  5574 00002EC5 E8F300                   call getIndReg2
  5575 00002EC8 A2[C101]                 mov byte [regindexbase], al
  5576                                  
  5577                                  ;-198             else getIndReg1();
  5578                                  
  5579 00002ECB E90300                   jmp @@getMEM208
  5580                                  @@getMEM207:
  5581 00002ECE E88900                   call getIndReg1
  5582                                  
  5583                                  ;-199         }
  5584                                  
  5585                                  @@getMEM208:
  5586                                  
  5587                                  ;-200         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  5588                                  
  5589                                  @@getMEM206:
  5590 00002ED1 8A46FE                   mov al, [bp-2]
  5591 00002ED4 3C03                     cmp al, 3
  5592 00002ED6 0F851000                 jne @@getMEM209
  5593 00002EDA A1[C301]                 mov ax, [disp]
  5594 00002EDD 8B1E[8506]               mov bx, [LabelIx]
  5595 00002EE1 D1E3                     shl bx, 1
  5596 00002EE3 0387[BB05]               add ax, [LabelAddr + bx]
  5597 00002EE7 A3[C301]                 mov word [disp], ax
  5598                                  
  5599                                  ;-201         if (c == IMM) disp=disp+SymbolInt;
  5600                                  
  5601                                  @@getMEM209:
  5602 00002EEA 8A46FE                   mov al, [bp-2]
  5603 00002EED 3C01                     cmp al, 1
  5604 00002EEF 0F850A00                 jne @@getMEM210
  5605 00002EF3 A1[C301]                 mov ax, [disp]
  5606 00002EF6 0306[5500]               add ax, [SymbolInt]
  5607 00002EFA A3[C301]                 mov word [disp], ax
  5608                                  
  5609                                  ;-202         if (isToken('-')) {
  5610                                  
  5611                                  @@getMEM210:
  5612 00002EFD 6A2D                     push 45
  5613 00002EFF E8B4E7                   call isToken
  5614 00002F02 83C402                   add  sp, 2
  5615 00002F05 08C0                     or  al, al
  5616 00002F07 0F841900                 je @@getMEM211
  5617                                  
  5618                                  ;-203             getTokeType();
  5619                                  
  5620 00002F0B E8D2E3                   call getTokeType
  5621                                  
  5622                                  ;-204             if (TokeType != DIGIT) numbererror();
  5623                                  
  5624 00002F0E A0[B301]                 mov al, [TokeType]
  5625 00002F11 3C01                     cmp al, 1
  5626 00002F13 0F840300                 je  @@getMEM212
  5627 00002F17 E80DF3                   call numbererror
  5628                                  
  5629                                  ;-205             disp = disp - SymbolInt;
  5630                                  
  5631                                  @@getMEM212:
  5632 00002F1A A1[C301]                 mov ax, [disp]
  5633 00002F1D 2B06[5500]               sub ax, [SymbolInt]
  5634 00002F21 A3[C301]                 mov word [disp], ax
  5635                                  
  5636                                  ;-206         }
  5637                                  
  5638                                  
  5639                                  ;-207     } while (isToken('+'));
  5640                                  
  5641                                  @@getMEM211:
  5642 00002F24 6A2B                     push 43
  5643 00002F26 E88DE7                   call isToken
  5644 00002F29 83C402                   add  sp, 2
  5645 00002F2C 08C0                     or  al, al
  5646 00002F2E 0F840300                 je @@getMEM213
  5647 00002F32 E960FF                   jmp @@getMEM204
  5648                                  @@getMEM213:
  5649                                  
  5650                                  ;-208     if (isToken(']') == 0) errorexit("] expected");
  5651                                  
  5652 00002F35 6A5D                     push 93
  5653 00002F37 E87CE7                   call isToken
  5654 00002F3A 83C402                   add  sp, 2
  5655 00002F3D 83F800                   cmp ax, 0
  5656 00002F40 0F850900                 jne @@getMEM214
  5657 00002F44 68[4F2F]                 push getMEM_0
  5658 00002F47 E881F3                   call errorexit
  5659 00002F4A 83C402                   add  sp, 2
  5660                                  
  5661                                  ;-209 }
  5662                                  
  5663                                  @@getMEM214:
  5664                                  
  5665                                  ;-210 int getIndReg1() {
  5666 00002F4D C9                       LEAVE
  5667 00002F4E C3                       ret
  5668                                  ; ENDP
  5669 00002F4F 5D2065787065637465-     getMEM_0 db "] expected",0
  5670 00002F58 6400               
  5671                                  
  5672                                  getIndReg1:  ; *** PROC ***
  5673                                  
  5674                                  ;-211     if (RegType !=WORD) indexerror();
  5675                                  
  5676 00002F5A A0[BC01]                 mov al, [RegType]
  5677 00002F5D 3C02                     cmp al, 2
  5678 00002F5F 0F840300                 je  @@getIndReg1215
  5679 00002F63 E87FF2                   call indexerror
  5680                                  
  5681                                  ;-212     if (RegNo==3) regindexbase=7;//BX
  5682                                  
  5683                                  @@getIndReg1215:
  5684 00002F66 A0[BA01]                 mov al, [RegNo]
  5685 00002F69 3C03                     cmp al, 3
  5686 00002F6B 0F850900                 jne @@getIndReg1216
  5687 00002F6F 66B807000000             mov eax, 7
  5688 00002F75 A2[C101]                 mov byte [regindexbase], al
  5689                                  
  5690                                  ;-213     if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5691                                  
  5692                                  @@getIndReg1216:
  5693 00002F78 A0[BA01]                 mov al, [RegNo]
  5694 00002F7B 3C05                     cmp al, 5
  5695 00002F7D 0F850900                 jne @@getIndReg1217
  5696 00002F81 66B806000000             mov eax, 6
  5697 00002F87 A2[C101]                 mov byte [regindexbase], al
  5698                                  
  5699                                  ;-214     if (RegNo==7) regindexbase=5;//DI
  5700                                  
  5701                                  @@getIndReg1217:
  5702 00002F8A A0[BA01]                 mov al, [RegNo]
  5703 00002F8D 3C07                     cmp al, 7
  5704 00002F8F 0F850900                 jne @@getIndReg1218
  5705 00002F93 66B805000000             mov eax, 5
  5706 00002F99 A2[C101]                 mov byte [regindexbase], al
  5707                                  
  5708                                  ;-215     if (RegNo==6) regindexbase=4;//SI
  5709                                  
  5710                                  @@getIndReg1218:
  5711 00002F9C A0[BA01]                 mov al, [RegNo]
  5712 00002F9F 3C06                     cmp al, 6
  5713 00002FA1 0F850900                 jne @@getIndReg1219
  5714 00002FA5 66B804000000             mov eax, 4
  5715 00002FAB A2[C101]                 mov byte [regindexbase], al
  5716                                  
  5717                                  ;-216     if (regindexbase==0) indexerror();
  5718                                  
  5719                                  @@getIndReg1219:
  5720 00002FAE A0[C101]                 mov al, [regindexbase]
  5721 00002FB1 3C00                     cmp al, 0
  5722 00002FB3 0F850300                 jne @@getIndReg1220
  5723 00002FB7 E82BF2                   call indexerror
  5724                                  
  5725                                  ;-217 }
  5726                                  
  5727                                  @@getIndReg1220:
  5728                                  
  5729                                  ;-218 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5730                                  
  5731 00002FBA C3                       ret
  5732                                  ; ENDP
  5733                                  
  5734                                  getIndReg2:  ; *** PROC ***
  5735                                  ;Function : getIndReg2, Number of local variables: 1
  5736                                  ;   # type sign width line used address name   list of local variables
  5737                                  ;  200 var sign byte   218 NULL bp-2    m;
  5738 00002FBB C8020000                 ENTER  2,0
  5739 00002FBF 66B804000000             mov eax, 4
  5740 00002FC5 8846FE                   mov byte [bp-2], al
  5741                                  
  5742                                  ;-219     if (RegType !=WORD) indexerror();
  5743                                  
  5744 00002FC8 A0[BC01]                 mov al, [RegType]
  5745 00002FCB 3C02                     cmp al, 2
  5746 00002FCD 0F840300                 je  @@getIndReg2221
  5747 00002FD1 E811F2                   call indexerror
  5748                                  
  5749                                  ;-220     if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5750                                  
  5751                                  @@getIndReg2221:
  5752 00002FD4 A0[BA01]                 mov al, [RegNo]
  5753 00002FD7 3C07                     cmp al, 7
  5754 00002FD9 0F852700                 jne @@getIndReg2222
  5755 00002FDD A0[C101]                 mov al, [regindexbase]
  5756 00002FE0 3C06                     cmp al, 6
  5757 00002FE2 0F850C00                 jne @@getIndReg2223
  5758 00002FE6 66B803000000             mov eax, 3
  5759 00002FEC 8846FE                   mov byte [bp-2], al
  5760                                  
  5761                                  ;-221              else if (regindexbase==7) m=1;//BX+DI
  5762                                  
  5763 00002FEF E91200                   jmp @@getIndReg2224
  5764                                  @@getIndReg2223:
  5765 00002FF2 A0[C101]                 mov al, [regindexbase]
  5766 00002FF5 3C07                     cmp al, 7
  5767 00002FF7 0F850900                 jne @@getIndReg2225
  5768 00002FFB 66B801000000             mov eax, 1
  5769 00003001 8846FE                   mov byte [bp-2], al
  5770                                  
  5771                                  ;-222     if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5772                                  
  5773                                  @@getIndReg2225:
  5774                                  @@getIndReg2224:
  5775                                  @@getIndReg2222:
  5776 00003004 A0[BA01]                 mov al, [RegNo]
  5777 00003007 3C06                     cmp al, 6
  5778 00003009 0F852700                 jne @@getIndReg2226
  5779 0000300D A0[C101]                 mov al, [regindexbase]
  5780 00003010 3C06                     cmp al, 6
  5781 00003012 0F850C00                 jne @@getIndReg2227
  5782 00003016 66B802000000             mov eax, 2
  5783 0000301C 8846FE                   mov byte [bp-2], al
  5784                                  
  5785                                  ;-223              else if (regindexbase==7) m=0;//BX+SI
  5786                                  
  5787 0000301F E91200                   jmp @@getIndReg2228
  5788                                  @@getIndReg2227:
  5789 00003022 A0[C101]                 mov al, [regindexbase]
  5790 00003025 3C07                     cmp al, 7
  5791 00003027 0F850900                 jne @@getIndReg2229
  5792 0000302B 66B800000000             mov eax, 0
  5793 00003031 8846FE                   mov byte [bp-2], al
  5794                                  
  5795                                  ;-224     if (m > 3) indexerror();
  5796                                  
  5797                                  @@getIndReg2229:
  5798                                  @@getIndReg2228:
  5799                                  @@getIndReg2226:
  5800 00003034 8A46FE                   mov al, [bp-2]
  5801 00003037 3C03                     cmp al, 3
  5802 00003039 0F8E0300                 jle @@getIndReg2230
  5803 0000303D E8A5F1                   call indexerror
  5804                                  
  5805                                  ;-225     return m;
  5806                                  
  5807                                  @@getIndReg2230:
  5808 00003040 8A46FE                   mov al, [bp-2]
  5809 00003043 E90000                   jmp @@retn
  5810                                  
  5811                                  ;-226 }
  5812                                  
  5813                                  
  5814                                  ;-227          
  5815                                  
  5816                                  
  5817                                  ;-228          
  5818                                  
  5819                                  
  5820                                  ;-229 int setwflag() {
  5821                                  
  5822 00003046 C9                      @@retn: LEAVE
  5823 00003047 C3                       ret
  5824                                  ; ENDP
  5825                                  
  5826                                  setwflag:  ; *** PROC ***
  5827                                  
  5828                                  ;-230     wflag=0;
  5829                                  
  5830 00003048 66B800000000             mov eax, 0
  5831 0000304E A2[BF01]                 mov byte [wflag], al
  5832                                  
  5833                                  ;-231     if (OpSize == 0) {//do not override OpSize
  5834                                  
  5835 00003051 A0[BE01]                 mov al, [OpSize]
  5836 00003054 3C00                     cmp al, 0
  5837 00003056 0F854200                 jne @@setwflag231
  5838                                  
  5839                                  ;-232         if (Op == REG) OpSize=R1Type;
  5840                                  
  5841 0000305A A0[B401]                 mov al, [Op]
  5842 0000305D 3C02                     cmp al, 2
  5843 0000305F 0F850600                 jne @@setwflag232
  5844 00003063 A0[BD01]                 mov al, [R1Type]
  5845 00003066 A2[BE01]                 mov byte [OpSize], al
  5846                                  
  5847                                  ;-233         if (Op2== REG) OpSize=RegType;        
  5848                                  
  5849                                  @@setwflag232:
  5850 00003069 A0[B501]                 mov al, [Op2]
  5851 0000306C 3C02                     cmp al, 2
  5852 0000306E 0F850600                 jne @@setwflag233
  5853 00003072 A0[BC01]                 mov al, [RegType]
  5854 00003075 A2[BE01]                 mov byte [OpSize], al
  5855                                  
  5856                                  ;-234         if (RegType== SEGREG) OpSize=WORD;
  5857                                  
  5858                                  @@setwflag233:
  5859 00003078 A0[BC01]                 mov al, [RegType]
  5860 0000307B 3C04                     cmp al, 4
  5861 0000307D 0F850900                 jne @@setwflag234
  5862 00003081 66B802000000             mov eax, 2
  5863 00003087 A2[BE01]                 mov byte [OpSize], al
  5864                                  
  5865                                  ;-235         if (R1Type == SEGREG) OpSize=WORD;        
  5866                                  
  5867                                  @@setwflag234:
  5868 0000308A A0[BD01]                 mov al, [R1Type]
  5869 0000308D 3C04                     cmp al, 4
  5870 0000308F 0F850900                 jne @@setwflag235
  5871 00003093 66B802000000             mov eax, 2
  5872 00003099 A2[BE01]                 mov byte [OpSize], al
  5873                                  
  5874                                  ;-236     }
  5875                                  
  5876                                  @@setwflag235:
  5877                                  
  5878                                  ;-237     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  5879                                  
  5880                                  @@setwflag231:
  5881 0000309C A0[BE01]                 mov al, [OpSize]
  5882 0000309F 3C03                     cmp al, 3
  5883 000030A1 0F850C00                 jne @@setwflag236
  5884 000030A5 E8E0F5                   call gen66h
  5885 000030A8 66B801000000             mov eax, 1
  5886 000030AE A2[BF01]                 mov byte [wflag], al
  5887                                  
  5888                                  ;-238     if (OpSize  ==  WORD) wflag=1;
  5889                                  
  5890                                  @@setwflag236:
  5891 000030B1 A0[BE01]                 mov al, [OpSize]
  5892 000030B4 3C02                     cmp al, 2
  5893 000030B6 0F850900                 jne @@setwflag237
  5894 000030BA 66B801000000             mov eax, 1
  5895 000030C0 A2[BF01]                 mov byte [wflag], al
  5896                                  
  5897                                  ;-239 }
  5898                                  
  5899                                  @@setwflag237:
  5900                                  
  5901                                  ;-240 
  5902                                  
  5903                                  
  5904                                  ;-241 int getSignExtended(unsigned int i) {  
  5905                                  
  5906 000030C3 C3                       ret
  5907                                  ; ENDP
  5908                                  
  5909                                  getSignExtended:  ; *** PROC ***
  5910                                  
  5911                                  ;-242     sflag=2;
  5912                                  
  5913                                  ;Function : getSignExtended, Number of local variables: 1
  5914                                  ;   # type sign width line used address name   list of local variables
  5915                                  ;  200 var unsg word   241 NULL bp+4    i;
  5916 000030C4 C8000000                 ENTER  0,0
  5917 000030C8 66B802000000             mov eax, 2
  5918 000030CE A2[C001]                 mov byte [sflag], al
  5919                                  
  5920                                  ;-243     if(i > 127) sflag = 0;    
  5921                                  
  5922 000030D1 8B4604                   mov ax, [bp+4]
  5923 000030D4 83F87F                   cmp ax, 127
  5924 000030D7 0F8E0900                 jle @@getSignExtended238
  5925 000030DB 66B800000000             mov eax, 0
  5926 000030E1 A2[C001]                 mov byte [sflag], al
  5927                                  
  5928                                  ;-244     if (OpSize == BYTE) {
  5929                                  
  5930                                  @@getSignExtended238:
  5931 000030E4 A0[BE01]                 mov al, [OpSize]
  5932 000030E7 3C01                     cmp al, 1
  5933 000030E9 0F851B00                 jne @@getSignExtended239
  5934                                  
  5935                                  ;-245         if (sflag == 0) error1("too big for byte r/m");
  5936                                  
  5937 000030ED A0[C001]                 mov al, [sflag]
  5938 000030F0 3C00                     cmp al, 0
  5939 000030F2 0F850900                 jne @@getSignExtended240
  5940 000030F6 68[0A31]                 push getSignExtended_0
  5941 000030F9 E80EF0                   call error1
  5942 000030FC 83C402                   add  sp, 2
  5943                                  
  5944                                  ;-246         sflag=0;//byte reg does not need sign extended   
  5945                                  
  5946                                  @@getSignExtended240:
  5947 000030FF 66B800000000             mov eax, 0
  5948 00003105 A2[C001]                 mov byte [sflag], al
  5949                                  
  5950                                  ;-247     }
  5951                                  
  5952                                  
  5953                                  ;-248 }
  5954                                  
  5955 00003108 C9                      @@getSignExtended239: LEAVE
  5956 00003109 C3                       ret
  5957                                  ; ENDP
  5958 0000310A 746F6F206269672066-     getSignExtended_0 db "too big for byte r/m",0
  5959 00003113 6F7220627974652072-
  5960 0000311C 2F6D00             
  5961                                   
  5962                                  ; missing functions: 
  5963                                  ; digit
  5964                                  ; strcpy
  5965                                  ; eqstr
  5966                                  ; strlen
  5967                                  ; eqstr
  5968                                  ; eqstr
  5969                                  ; eqstr
  5970                                  ; eqstr
  5971                                  ; readRL
  5972                                  ; readRL
  5973                                  ; digit
  5974                                  ; digit
  5975                                  ; strcpy
  5976                                  ; toupper
  5977                                  ; strlen
  5978                                  ; strlen
  5979                                  ; eqstr
  5980                                  ; eqstr
  5981                                  ; eqstr
  5982                                  ; eqstr
  5983                                  ; eqstr
  5984                                  ; eqstr
  5985                                  ; eqstr
  5986                                  ; eqstr
  5987                                  ; eqstr
  5988                                  ; eqstr
  5989                                  ; eqstr
  5990                                  ; eqstr
  5991                                  ; eqstr
  5992                                  ; eqstr
  5993                                  ; eqstr
  5994                                  ; eqstr
  5995                                  ; eqstr
  5996                                  ; eqstr
  5997                                  ; eqstr
  5998                                  ; eqstr
  5999                                  ; eqstr
  6000                                  ; eqstr
  6001                                  ; eqstr
  6002                                  ; eqstr
  6003                                  ; eqstr
  6004                                  ; eqstr
  6005                                  ; eqstr
  6006                                  ; eqstr
  6007                                  ; eqstr
  6008                                  ; eqstr
  6009                                  ; writetty
  6010                                  ; writetty
  6011                                  ; fputcR
  6012                                  ; cputs
  6013                                  ; cputs
  6014                                  ; exitR
  6015                                  ; toupper
  6016                                  ; strcpy
  6017                                  ; strcat1
  6018                                  ; strcpy
  6019                                  ; strcat1
  6020                                  ; strcpy
  6021                                  ; strcat1
  6022                                  ; openR
  6023                                  ; cputs
  6024                                  ; cputs
  6025                                  ; exitR
  6026                                  ; creatR
  6027                                  ; cputs
  6028                                  ; cputs
  6029                                  ; exitR
  6030                                  ; creatR
  6031                                  ; cputs
  6032                                  ; cputs
  6033                                  ; exitR
  6034                                  ; fputcR
  6035                                  ; fcloseR
  6036                                  ; fcloseR
  6037                                  ; fcloseR
  6038                                  ; exitR
  6039                                  ; Number of unresolved CALLs :   76
  6040                                  ;use archive file: AR.C
  6041                                  
  6042                                  ;-249 // AR.C Archive
  6043                                  
  6044                                  ;Number of CALLs:    2 : writetty
  6045                                  
  6046                                  writetty:  ; *** PROC ***
  6047 0000311F B40E                     mov  ah, 14
  6048 00003121 BB0000                   mov  bx, 0
  6049 00003124 CD10                     int  16
  6050                                  
  6051                                  ;-250 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  6052                                  
  6053 00003126 C3                       ret
  6054                                  ; ENDP
  6055                                  ;Number of CALLs:    8 : cputs
  6056                                  
  6057                                  cputs:  ; *** PROC ***
  6058                                  ;Function : cputs, Number of local variables: 2
  6059                                  ;   # type sign width line used address name   list of local variables
  6060                                  ;  200 ptr sign byte   250 NULL bp+4    s
  6061                                  ;  201 var sign byte   250 NULL bp-2    c;
  6062 00003127 C8020000                 ENTER  2,0
  6063                                  @@cputs241:
  6064 0000312B 8B5E04                   mov bx, [bp+4]
  6065 0000312E 8A07                     mov al, [bx]
  6066 00003130 B400                     mov ah, 0
  6067 00003132 08C0                     or  al, al
  6068 00003134 0F841B00                 je @@cputs242
  6069 00003138 8B5E04                   mov bx, [bp+4]
  6070 0000313B 8A07                     mov al, [bx]
  6071 0000313D B400                     mov ah, 0
  6072 0000313F 8846FE                   mov byte [bp-2], al
  6073 00003142 8A46FE                   mov al, byte [bp-2]
  6074 00003145 B400                     mov ah, 0
  6075 00003147 50                       push ax
  6076 00003148 E8C401                   call putch
  6077 0000314B 83C402                   add  sp, 2
  6078 0000314E FF4604                   inc  word [bp+4]
  6079 00003151 EBD8                     jmp @@cputs241
  6080                                  @@cputs242:
  6081                                  
  6082                                  ;-251 int mkneg(int n) { n; __asm {neg ax} }
  6083 00003153 C9                       LEAVE
  6084 00003154 C3                       ret
  6085                                  ; ENDP
  6086                                  ;Number of CALLs:    2 : toupper
  6087                                  
  6088                                  toupper:  ; *** PROC ***
  6089                                  ;Function : toupper, Number of local variables: 1
  6090                                  ;   # type sign width line used address name   list of local variables
  6091                                  ;  200 ptr sign byte   251 NULL bp+4    s;
  6092 00003155 C8000000                 ENTER  0,0
  6093                                  @@toupper243:
  6094 00003159 8B5E04                   mov bx, [bp+4]
  6095 0000315C 8A07                     mov al, [bx]
  6096 0000315E B400                     mov ah, 0
  6097 00003160 08C0                     or  al, al
  6098 00003162 0F843000                 je @@toupper244
  6099 00003166 8B5E04                   mov bx, [bp+4]
  6100 00003169 8A07                     mov al, [bx]
  6101 0000316B B400                     mov ah, 0
  6102 0000316D 83F861                   cmp ax, 97 ;unsigned : 1
  6103 00003170 0F8C1D00                 jl  @@toupper245
  6104 00003174 8B5E04                   mov bx, [bp+4]
  6105 00003177 8A07                     mov al, [bx]
  6106 00003179 B400                     mov ah, 0
  6107 0000317B 83F87A                   cmp ax, 122
  6108 0000317E 0F8F0F00                 jg  @@toupper246
  6109 00003182 8B5E04                   mov bx, [bp+4]
  6110 00003185 8A07                     mov al, [bx]
  6111 00003187 B400                     mov ah, 0
  6112 00003189 83E820                   sub ax, 32
  6113 0000318C 8B5E04                   mov  bx, [bp+4]
  6114 0000318F 8807                     mov  [bx], al
  6115                                  @@toupper246:
  6116                                  @@toupper245:
  6117 00003191 FF4604                   inc  word [bp+4]
  6118 00003194 EBC3                     jmp @@toupper243
  6119                                  @@toupper244:
  6120                                  
  6121                                  ;-252 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6122                                  
  6123                                  
  6124                                  ;-253 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6125 00003196 C9                       LEAVE
  6126 00003197 C3                       ret
  6127                                  ; ENDP
  6128                                  ;Number of CALLs:    3 : strlen
  6129                                  
  6130                                  strlen:  ; *** PROC ***
  6131                                  ;Function : strlen, Number of local variables: 2
  6132                                  ;   # type sign width line used address name   list of local variables
  6133                                  ;  200 ptr sign byte   253 NULL bp+4    s
  6134                                  ;  201 var sign word   253 NULL bp-2    c;
  6135 00003198 C8020000                 ENTER  2,0
  6136 0000319C 66B800000000             mov eax, 0
  6137 000031A2 8946FE                   mov word [bp-2], ax
  6138                                  @@strlen247:
  6139 000031A5 8B5E04                   mov bx, [bp+4]
  6140 000031A8 8A07                     mov al, [bx]
  6141 000031AA B400                     mov ah, 0
  6142 000031AC 83F800                   cmp ax, 0
  6143 000031AF 0F840800                 je  @@strlen248
  6144 000031B3 FF4604                   inc  word [bp+4]
  6145 000031B6 FF46FE                   inc  word [bp-2]
  6146 000031B9 EBEA                     jmp @@strlen247
  6147                                  @@strlen248:
  6148 000031BB 8B46FE                   mov ax, [bp-2]
  6149 000031BE E90000                   jmp @@retn
  6150                                  
  6151                                  ;-254 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6152                                  
  6153 000031C1 C9                      @@retn: LEAVE
  6154 000031C2 C3                       ret
  6155                                  ; ENDP
  6156                                  ;Number of CALLs:    5 : strcpy
  6157                                  
  6158                                  strcpy:  ; *** PROC ***
  6159                                  ;Function : strcpy, Number of local variables: 2
  6160                                  ;   # type sign width line used address name   list of local variables
  6161                                  ;  200 ptr sign byte   254 NULL bp+4    s
  6162                                  ;  201 ptr sign byte   254 NULL bp+6    t;
  6163 000031C3 C8000000                 ENTER  0,0
  6164                                  @@strcpy249:
  6165 000031C7 8B5E06                   mov bx, [bp+6]
  6166 000031CA 8A07                     mov al, [bx]
  6167 000031CC B400                     mov ah, 0
  6168 000031CE 8B5E04                   mov  bx, [bp+4]
  6169 000031D1 8807                     mov  [bx], al
  6170 000031D3 FF4604                   inc  word [bp+4]
  6171 000031D6 FF4606                   inc  word [bp+6]
  6172                                  
  6173                                  ;-255   while (*t!=0); *s=0; return s; }
  6174                                  
  6175 000031D9 8B5E06                   mov bx, [bp+6]
  6176 000031DC 8A07                     mov al, [bx]
  6177 000031DE B400                     mov ah, 0
  6178 000031E0 83F800                   cmp ax, 0
  6179 000031E3 0F840200                 je  @@strcpy250
  6180 000031E7 EBDE                     jmp @@strcpy249
  6181                                  @@strcpy250:
  6182 000031E9 66B800000000             mov eax, 0
  6183 000031EF 8B5E04                   mov  bx, [bp+4]
  6184 000031F2 8807                     mov  [bx], al
  6185 000031F4 8B4604                   mov ax, [bp+4]
  6186 000031F7 E90000                   jmp @@retn
  6187                                  
  6188                                  ;-256 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6189                                  
  6190 000031FA C9                      @@retn: LEAVE
  6191 000031FB C3                       ret
  6192                                  ; ENDP
  6193                                  ;Number of CALLs:    3 : digit
  6194                                  
  6195                                  digit:  ; *** PROC ***
  6196                                  ;Function : digit, Number of local variables: 1
  6197                                  ;   # type sign width line used address name   list of local variables
  6198                                  ;  200 var sign byte   256 NULL bp+4    c;
  6199 000031FC C8000000                 ENTER  0,0
  6200 00003200 8A4604                   mov al, [bp+4]
  6201 00003203 3C30                     cmp al, 48
  6202 00003205 0F8D0900                 jge @@digit251
  6203 00003209 66B800000000             mov eax, 0
  6204 0000320F E91B00                   jmp @@retn
  6205                                  @@digit251:
  6206 00003212 8A4604                   mov al, [bp+4]
  6207 00003215 3C39                     cmp al, 57
  6208 00003217 0F8E0900                 jle @@digit252
  6209 0000321B 66B800000000             mov eax, 0
  6210 00003221 E90900                   jmp @@retn
  6211                                  @@digit252:
  6212 00003224 66B801000000             mov eax, 1
  6213 0000322A E90000                   jmp @@retn
  6214                                  
  6215                                  ;-257 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6216                                  
  6217 0000322D C9                      @@retn: LEAVE
  6218 0000322E C3                       ret
  6219                                  ; ENDP
  6220                                  ;Number of CALLs:   35 : eqstr
  6221                                  
  6222                                  eqstr:  ; *** PROC ***
  6223                                  ;Function : eqstr, Number of local variables: 2
  6224                                  ;   # type sign width line used address name   list of local variables
  6225                                  ;  200 ptr sign byte   257 NULL bp+4    p
  6226                                  ;  201 ptr sign byte   257 NULL bp+6    q;
  6227 0000322F C8000000                 ENTER  0,0
  6228                                  @@eqstr253:
  6229 00003233 8B5E04                   mov bx, [bp+4]
  6230 00003236 8A07                     mov al, [bx]
  6231 00003238 B400                     mov ah, 0
  6232 0000323A 08C0                     or  al, al
  6233 0000323C 0F842300                 je @@eqstr254
  6234                                  
  6235                                  ;-258     if (*p != *q) return 0; p++; q++; }
  6236                                  
  6237 00003240 8B5E04                   mov bx, [bp+4]
  6238 00003243 8A07                     mov al, [bx]
  6239 00003245 B400                     mov ah, 0
  6240 00003247 8B5E06                   mov bx, [bp+6]
  6241 0000324A 3A07                     cmp al, [bx]
  6242 0000324C B400                     mov ah, 0
  6243 0000324E 0F840900                 je  @@eqstr255
  6244 00003252 66B800000000             mov eax, 0
  6245 00003258 E92700                   jmp @@retn
  6246                                  @@eqstr255:
  6247 0000325B FF4604                   inc  word [bp+4]
  6248 0000325E FF4606                   inc  word [bp+6]
  6249                                  
  6250                                  ;-259     if(*q) return 0; return 1; }
  6251                                  
  6252 00003261 EBD0                     jmp @@eqstr253
  6253                                  @@eqstr254:
  6254 00003263 8B5E06                   mov bx, [bp+6]
  6255 00003266 8A07                     mov al, [bx]
  6256 00003268 B400                     mov ah, 0
  6257 0000326A 08C0                     or  al, al
  6258 0000326C 0F840900                 je @@eqstr256
  6259 00003270 66B800000000             mov eax, 0
  6260 00003276 E90900                   jmp @@retn
  6261                                  @@eqstr256:
  6262 00003279 66B801000000             mov eax, 1
  6263 0000327F E90000                   jmp @@retn
  6264                                  
  6265                                  ;-260 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  6266                                  
  6267 00003282 C9                      @@retn: LEAVE
  6268 00003283 C3                       ret
  6269                                  ; ENDP
  6270                                  ;Number of CALLs:    3 : strcat1
  6271                                  
  6272                                  strcat1:  ; *** PROC ***
  6273                                  ;Function : strcat1, Number of local variables: 2
  6274                                  ;   # type sign width line used address name   list of local variables
  6275                                  ;  200 ptr sign byte   260 NULL bp+4    s
  6276                                  ;  201 ptr sign byte   260 NULL bp+6    t;
  6277 00003284 C8000000                 ENTER  0,0
  6278                                  @@strcat1257:
  6279 00003288 8B5E04                   mov bx, [bp+4]
  6280 0000328B 8A07                     mov al, [bx]
  6281 0000328D B400                     mov ah, 0
  6282 0000328F 83F800                   cmp ax, 0
  6283 00003292 0F840500                 je  @@strcat1258
  6284 00003296 FF4604                   inc  word [bp+4]
  6285 00003299 EBED                     jmp @@strcat1257
  6286                                  @@strcat1258:
  6287 0000329B FF7606                   push word [bp+6]
  6288 0000329E FF7604                   push word [bp+4]
  6289 000032A1 E81FFF                   call strcpy
  6290 000032A4 83C404                   add  sp, 4
  6291                                  
  6292                                  ;-261 int basename(char *s) { char *p; p=0;
  6293 000032A7 C9                       LEAVE
  6294 000032A8 C3                       ret
  6295                                  ; ENDP
  6296                                  ;Number of CALLs:    1 : openR
  6297                                  
  6298                                  openR:  ; *** PROC ***
  6299                                  ;Function : openR, Number of local variables: 1
  6300                                  ;   # type sign width line used address name   list of local variables
  6301                                  ;  200 ptr sign byte   261 NULL bp+4    s;
  6302 000032A9 C8000000                 ENTER  0,0
  6303 000032AD 8B5604                   mov  dx, [bp+4]
  6304 000032B0 B8023D                   mov  ax, 15618
  6305 000032B3 E87200                   call DosInt
  6306                                  
  6307                                  ;-262 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  6308 000032B6 C9                       LEAVE
  6309 000032B7 C3                       ret
  6310                                  ; ENDP
  6311                                  ;Number of CALLs:    2 : creatR
  6312                                  
  6313                                  creatR:  ; *** PROC ***
  6314                                  ;Function : creatR, Number of local variables: 1
  6315                                  ;   # type sign width line used address name   list of local variables
  6316                                  ;  200 ptr sign byte   262 NULL bp+4    s;
  6317 000032B8 C8000000                 ENTER  0,0
  6318 000032BC 8B5604                   mov  dx, [bp+4]
  6319 000032BF B90000                   mov  cx, 0
  6320 000032C2 B8003C                   mov  ax, 15360
  6321 000032C5 E86000                   call DosInt
  6322                                  
  6323                                  ;-263 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  6324 000032C8 C9                       LEAVE
  6325 000032C9 C3                       ret
  6326                                  ; ENDP
  6327                                  ;Number of CALLs:    2 : readRL
  6328                                  
  6329                                  readRL:  ; *** PROC ***
  6330                                  ;Function : readRL, Number of local variables: 3
  6331                                  ;   # type sign width line used address name   list of local variables
  6332                                  ;  200 ptr sign byte   263 NULL bp+4    s
  6333                                  ;  201 var sign word   263 NULL bp+6    fd
  6334                                  ;  202 var sign word   263 NULL bp+8    len;
  6335 000032CA C8000000                 ENTER  0,0
  6336 000032CE 8B5604                   mov  dx, [bp+4]
  6337 000032D1 8B4E08                   mov  cx, [bp+8]
  6338 000032D4 8B5E06                   mov  bx, [bp+6]
  6339 000032D7 B8003F                   mov  ax, 16128
  6340 000032DA E84B00                   call DosInt
  6341                                  
  6342                                  ;-264 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  6343 000032DD C9                       LEAVE
  6344 000032DE C3                       ret
  6345                                  ; ENDP
  6346                                  ;Number of CALLs:    2 : fputcR
  6347                                  
  6348                                  fputcR:  ; *** PROC ***
  6349                                  ;Function : fputcR, Number of local variables: 2
  6350                                  ;   # type sign width line used address name   list of local variables
  6351                                  ;  200 ptr sign byte   264 NULL bp+4    n
  6352                                  ;  201 var sign word   264 NULL bp+6    fd;
  6353 000032DF C8000000                 ENTER  0,0
  6354 000032E3 8D5604                  lea dx, [bp+4]
  6355                                  
  6356                                  ;-265   cx=1; bx=fd; ax=0x4000; DosInt(); }
  6357                                  
  6358 000032E6 B90100                   mov  cx, 1
  6359 000032E9 8B5E06                   mov  bx, [bp+6]
  6360 000032EC B80040                   mov  ax, 16384
  6361 000032EF E83600                   call DosInt
  6362                                  
  6363                                  ;-266 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  6364 000032F2 C9                       LEAVE
  6365 000032F3 C3                       ret
  6366                                  ; ENDP
  6367                                  ;Number of CALLs:    3 : fcloseR
  6368                                  
  6369                                  fcloseR:  ; *** PROC ***
  6370                                  ;Function : fcloseR, Number of local variables: 1
  6371                                  ;   # type sign width line used address name   list of local variables
  6372                                  ;  200 var sign word   266 NULL bp+4    fd;
  6373 000032F4 C8000000                 ENTER  0,0
  6374 000032F8 8B5E04                   mov  bx, [bp+4]
  6375 000032FB B8003E                   mov  ax, 15872
  6376 000032FE CD21                     int  33
  6377                                  
  6378                                  ;-267 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  6379 00003300 C9                       LEAVE
  6380 00003301 C3                       ret
  6381                                  ; ENDP
  6382                                  ;Number of CALLs:    5 : exitR
  6383                                  
  6384                                  exitR:  ; *** PROC ***
  6385                                  ;Function : exitR, Number of local variables: 1
  6386                                  ;   # type sign width line used address name   list of local variables
  6387                                  ;  200 var sign byte   267 NULL bp+4    c;
  6388 00003302 C8000000                 ENTER  0,0
  6389 00003306 B44C                     mov  ah, 76
  6390 00003308 8A4604                   mov  al, [bp+4]
  6391 0000330B CD21                     int  33
  6392                                  
  6393                                  ;-268 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  6394 0000330D C9                       LEAVE
  6395 0000330E C3                       ret
  6396                                  ; ENDP
  6397                                  ;End of archive file. 
  6398                                   
  6399                                  ; missing functions: 
  6400                                  ; putch
  6401                                  ; DosInt
  6402                                  ; DosInt
  6403                                  ; DosInt
  6404                                  ; DosInt
  6405                                  ; Number of unresolved CALLs :    5
  6406                                  ;use archive file: AR.C
  6407                                  
  6408                                  ;-269 // AR.C Archive
  6409                                  
  6410                                  ;Number of CALLs:    1 : putch
  6411                                  
  6412                                  putch:  ; *** PROC ***
  6413                                  ;Function : putch, Number of local variables: 1
  6414                                  ;   # type sign width line used address name   list of local variables
  6415                                  ;  200 var sign byte   269 NULL bp+4    c;
  6416 0000330F C8000000                 ENTER  0,0
  6417 00003313 807E040A                cmp byte [bp+4], 10
  6418 00003317 0F850500                 jne @@putch259
  6419 0000331B B00D                     mov  al, 13
  6420 0000331D E8FFFD                   call writetty
  6421                                  @@putch259:
  6422 00003320 8A4604                   mov  al, [bp+4]
  6423 00003323 E8F9FD                   call writetty
  6424                                  
  6425                                  ;-270 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  6426 00003326 C9                       LEAVE
  6427 00003327 C3                       ret
  6428                                  ; ENDP
  6429                                  ;Number of CALLs:    4 : DosInt
  6430                                  
  6431                                  DosInt:  ; *** PROC ***
  6432 00003328 CD21                     int  33
  6433 0000332A 7304                     jae short @@DosInt260
  6434 0000332C FF06[A701]               inc  word [DOS_ERR]
  6435                                  @@DosInt260:
  6436                                  
  6437                                  ;-271 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  6438                                  
  6439 00003330 C3                       ret
  6440                                  ; ENDP
  6441                                  ;End of archive file. 
  6442                                   
  6443                                  ; missing functions:  All FUNCTIONs in place
  6444 00003331 E80000                  LastFunctionByt:db 0E8h, 0, 0
  6445 00003334 58                      pop ax
  6446 00003335 C3                      ret
  6447                                   
  6448                                  ;   # type sign width line used  address name   list of global variables
  6449                                  
  6450                                  ;    1 arr sign byte     1    2        0 Version1[18]
  6451                                  ;    2 var sign byte     1    3        0 LIST
  6452                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  6453                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  6454                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  6455                                  ;    6 var unsg word     5   12        0 SymbolInt
  6456                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  6457                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  6458                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  6459                                  ;   10 arr sign byte     9    5        0 namein[67]
  6460                                  ;   11 arr sign byte    10    5        0 namelst[67]
  6461                                  ;   12 arr sign byte    11    5        0 namebin[67]
  6462                                  ;   13 var sign word    12    4        0 asm_fd
  6463                                  ;   14 var sign word    13    3        0 lst_fd
  6464                                  ;   15 var sign word    14    3        0 bin_fd
  6465                                  ;   16 var sign word    15    6        0 DOS_ERR
  6466                                  ;   17 var sign word    16    4        0 ErrorCount
  6467                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  6468                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  6469                                  ;   20 var unsg word    20    5        0 PC
  6470                                  ;   21 var unsg word    21    2        0 PCStart
  6471                                  ;   22 var sign byte    22    3        0 isLabel
  6472                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  6473                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  6474                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  6475                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  6476                                  ;   27 var sign byte    27   21        0 TokeType
  6477                                  ;   28 def unsg byte    28    -        0 BYTE=1
  6478                                  ;   29 def unsg byte    29    -        0 WORD=2
  6479                                  ;   30 def unsg byte    30    -        0 DWORD=3
  6480                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  6481                                  ;   32 def unsg byte    32    -        0 IMM=1
  6482                                  ;   33 def unsg byte    33    -        0 REG=2
  6483                                  ;   34 def unsg byte    34    -        0 ADR=3
  6484                                  ;   35 def unsg byte    35    -        0 MEM=4
  6485                                  ;   36 var sign byte    36   17        0 Op
  6486                                  ;   37 var sign byte    37   18        0 Op2
  6487                                  ;   38 var sign byte    38   13        0 CodeType
  6488                                  ;   39 var sign byte    39   12        0 Code1
  6489                                  ;   40 var sign byte    40    6        0 Code2
  6490                                  ;   41 var sign byte    41    3        0 Code3
  6491                                  ;   42 var sign byte    42   14        0 RegNo
  6492                                  ;   43 var sign byte    43    7        0 R1No
  6493                                  ;   44 var sign byte    44   20        0 RegType
  6494                                  ;   45 var sign byte    45    4        0 R1Type
  6495                                  ;   46 var sign byte    46   14        0 OpSize
  6496                                  ;   47 var sign byte    47    7        0 wflag
  6497                                  ;   48 var sign byte    49    6        0 sflag
  6498                                  ;   49 var sign byte    50   14        0 regindexbase
  6499                                  ;   50 var sign byte    51    3        0 isDirect
  6500                                  ;   51 var sign word    52   14        0 disp
  6501                                  ;   52 var sign word    53    5        0 imme
  6502                                  ;   53 def unsg byte    55    -        0 OPMAXLEN=5
  6503                                  ;   54 arr sign byte    56    2        0 OpPos[5]
  6504                                  ;   55 var sign word    57    6        0 OpPrintIndex
  6505                                  ;   56 ptr sign byte    58   17        0 OpCodePtr
  6506                                  ;   57 var sign byte    59    2        0 PrintR
  6507                                  ;   58 def unsg byte    61    -        0 LABELNAMESMAX=969
  6508                                  ;   59 arr sign byte    62    3        0 LabelNames[1000]
  6509                                  ;   60 ptr sign byte    63    5        0 LabelNamePtr
  6510                                  ;   61 def unsg byte    64    -        0 LABELADRMAX=100
  6511                                  ;   62 arr unsg word    65    3        0 LabelAddr[100]
  6512                                  ;   63 var sign word    66    4        0 LabelMaxIx
  6513                                  ;   64 var sign word    67    4        0 LabelIx
  6514                                  ;   65 def unsg byte    69    -        0 FILEBINMAX=2000
  6515                                  ;   66 arr sign byte    70    2        0 FileBin[2000]
  6516                                  ;   67 var unsg word    71    5        0 BinLen
  6517                                  ;   68 ptr sign byte    73    1        0 arglen
  6518                                  ;   69 ptr sign byte    74    4        0 argv
  6519                                  ;   70 var sign byte     1    1        0 I_START
  6520                                  ;   71 arr sign byte     4 NULL        0 I_PUSHA[9]
  6521                                  ;   72 arr sign byte     5 NULL        0 I_POPA[8]
  6522                                  ;   73 arr sign byte     6 NULL        0 I_NOP[7]
  6523                                  ;   74 arr sign byte     7 NULL        0 I_CBW[7]
  6524                                  ;   75 arr sign byte     8 NULL        0 I_CWDE[8]
  6525                                  ;   76 arr sign byte     9 NULL        0 I_CWD[7]
  6526                                  ;   77 arr sign byte    10 NULL        0 I_CDQ[7]
  6527                                  ;   78 arr sign byte    11 NULL        0 I_WAIT[8]
  6528                                  ;   79 arr sign byte    12 NULL        0 I_PUSHF[9]
  6529                                  ;   80 arr sign byte    13 NULL        0 I_POPF[8]
  6530                                  ;   81 arr sign byte    14 NULL        0 I_SAHF[8]
  6531                                  ;   82 arr sign byte    15 NULL        0 I_LAHF[8]
  6532                                  ;   83 arr sign byte    16 NULL        0 I_MOVSB[9]
  6533                                  ;   84 arr sign byte    17 NULL        0 I_MOVSW[9]
  6534                                  ;   85 arr sign byte    18 NULL        0 I_CMPSB[9]
  6535                                  ;   86 arr sign byte    19 NULL        0 I_CMPSW[9]
  6536                                  ;   87 arr sign byte    20 NULL        0 I_STOSB[9]
  6537                                  ;   88 arr sign byte    21 NULL        0 I_STOSW[9]
  6538                                  ;   89 arr sign byte    22 NULL        0 I_LODSB[9]
  6539                                  ;   90 arr sign byte    23 NULL        0 I_LODSW[9]
  6540                                  ;   91 arr sign byte    24 NULL        0 I_SCASB[9]
  6541                                  ;   92 arr sign byte    25 NULL        0 I_SCASW[9]
  6542                                  ;   93 arr sign byte    26 NULL        0 I_LEAVE[9]
  6543                                  ;   94 arr sign byte    27 NULL        0 I_IRET[8]
  6544                                  ;   95 arr sign byte    28 NULL        0 I_XLAT[8]
  6545                                  ;   96 arr sign byte    29 NULL        0 I_LOCK[8]
  6546                                  ;   97 arr sign byte    30 NULL        0 I_REPNE[9]
  6547                                  ;   98 arr sign byte    31 NULL        0 I_REPNZ[9]
  6548                                  ;   99 arr sign byte    32 NULL        0 I_REPE[8]
  6549                                  ;  100 arr sign byte    33 NULL        0 I_REPZ[8]
  6550                                  ;  101 arr sign byte    34 NULL        0 I_HLT[7]
  6551                                  ;  102 arr sign byte    35 NULL        0 I_CLC[7]
  6552                                  ;  103 arr sign byte    36 NULL        0 I_STC[7]
  6553                                  ;  104 arr sign byte    37 NULL        0 I_CLI[7]
  6554                                  ;  105 arr sign byte    38 NULL        0 I_STI[7]
  6555                                  ;  106 arr sign byte    39 NULL        0 I_CLD[7]
  6556                                  ;  107 arr sign byte    40 NULL        0 I_STD[7]
  6557                                  ;  108 arr sign byte    42 NULL        0 I_INC[9]
  6558                                  ;  109 arr sign byte    43 NULL        0 I_DEC[9]
  6559                                  ;  110 arr sign byte    44 NULL        0 I_NOT[8]
  6560                                  ;  111 arr sign byte    45 NULL        0 I_NEG[8]
  6561                                  ;  112 arr sign byte    46 NULL        0 I_MUL[8]
  6562                                  ;  113 arr sign byte    47 NULL        0 I_IMUL[9]
  6563                                  ;  114 arr sign byte    48 NULL        0 I_DIV[8]
  6564                                  ;  115 arr sign byte    49 NULL        0 I_IDIV[9]
  6565                                  ;  116 arr sign byte    51 NULL        0 I_LES[7]
  6566                                  ;  117 arr sign byte    52 NULL        0 I_LDS[7]
  6567                                  ;  118 arr sign byte    53 NULL        0 I_LEA[7]
  6568                                  ;  119 arr sign byte    54 NULL        0 I_LSS[8]
  6569                                  ;  120 arr sign byte    55 NULL        0 I_LFS[8]
  6570                                  ;  121 arr sign byte    56 NULL        0 I_LGS[8]
  6571                                  ;  122 arr sign byte    58 NULL        0 I_ADD[7]
  6572                                  ;  123 arr sign byte    59 NULL        0 I_OR[6]
  6573                                  ;  124 arr sign byte    60 NULL        0 I_ADC[7]
  6574                                  ;  125 arr sign byte    61 NULL        0 I_SBB[7]
  6575                                  ;  126 arr sign byte    62 NULL        0 I_AND[7]
  6576                                  ;  127 arr sign byte    63 NULL        0 I_SUB[7]
  6577                                  ;  128 arr sign byte    64 NULL        0 I_XOR[7]
  6578                                  ;  129 arr sign byte    65 NULL        0 I_CMP[7]
  6579                                  ;  130 arr sign byte    66 NULL        0 I_TEST[11]
  6580                                  ;  131 arr sign byte    68 NULL        0 I_MOV[6]
  6581                                  ;  132 arr sign byte    69 NULL        0 I_MOVSX[9]
  6582                                  ;  133 arr sign byte    70 NULL        0 I_MOVZX[9]
  6583                                  ;  134 arr sign byte    72 NULL        0 I_JO[6]
  6584                                  ;  135 arr sign byte    73 NULL        0 I_JNO[7]
  6585                                  ;  136 arr sign byte    74 NULL        0 I_JB[6]
  6586                                  ;  137 arr sign byte    75 NULL        0 I_JC[6]
  6587                                  ;  138 arr sign byte    76 NULL        0 I_JNB[7]
  6588                                  ;  139 arr sign byte    77 NULL        0 I_JAE[7]
  6589                                  ;  140 arr sign byte    78 NULL        0 I_JNC[7]
  6590                                  ;  141 arr sign byte    79 NULL        0 I_JE[6]
  6591                                  ;  142 arr sign byte    80 NULL        0 I_JZ[6]
  6592                                  ;  143 arr sign byte    81 NULL        0 I_JNE[7]
  6593                                  ;  144 arr sign byte    82 NULL        0 I_JNZ[7]
  6594                                  ;  145 arr sign byte    83 NULL        0 I_JBE[7]
  6595                                  ;  146 arr sign byte    84 NULL        0 I_JNA[7]
  6596                                  ;  147 arr sign byte    85 NULL        0 I_JA[6]
  6597                                  ;  148 arr sign byte    86 NULL        0 I_JS[6]
  6598                                  ;  149 arr sign byte    87 NULL        0 I_JNS[7]
  6599                                  ;  150 arr sign byte    88 NULL        0 I_JP[6]
  6600                                  ;  151 arr sign byte    89 NULL        0 I_JPE[7]
  6601                                  ;  152 arr sign byte    90 NULL        0 I_JNP[7]
  6602                                  ;  153 arr sign byte    91 NULL        0 I_JPO[7]
  6603                                  ;  154 arr sign byte    92 NULL        0 I_JL[6]
  6604                                  ;  155 arr sign byte    93 NULL        0 I_JNL[7]
  6605                                  ;  156 arr sign byte    94 NULL        0 I_JGE[7]
  6606                                  ;  157 arr sign byte    95 NULL        0 I_JLE[7]
  6607                                  ;  158 arr sign byte    96 NULL        0 I_JNG[7]
  6608                                  ;  159 arr sign byte    97 NULL        0 I_JG[6]
  6609                                  ;  160 arr sign byte    99 NULL        0 I_JMP[8]
  6610                                  ;  161 arr sign byte   100 NULL        0 I_CALL[9]
  6611                                  ;  162 arr sign byte   102 NULL        0 I_RET[8]
  6612                                  ;  163 arr sign byte   103 NULL        0 I_RETF[9]
  6613                                  ;  164 arr sign byte   105 NULL        0 I_PUSH[8]
  6614                                  ;  165 arr sign byte   106 NULL        0 I_POP[7]
  6615                                  ;  166 arr sign byte   108 NULL        0 I_ROL[7]
  6616                                  ;  167 arr sign byte   109 NULL        0 I_ROR[7]
  6617                                  ;  168 arr sign byte   110 NULL        0 I_RCL[7]
  6618                                  ;  169 arr sign byte   111 NULL        0 I_RCR[7]
  6619                                  ;  170 arr sign byte   112 NULL        0 I_SHL[7]
  6620                                  ;  171 arr sign byte   113 NULL        0 I_SAL[7]
  6621                                  ;  172 arr sign byte   114 NULL        0 I_SHR[7]
  6622                                  ;  173 arr sign byte   115 NULL        0 I_SAR[7]
  6623                                  ;  174 arr sign byte   117 NULL        0 I_INT[8]
  6624                                  ;  175 arr sign byte   118 NULL        0 I_INTO[8]
  6625                                  ;  176 arr sign byte   129 NULL        0 I_XCHG[9]
  6626                                  ;  177 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6627                                  ;  178 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6628                                  ;  179 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6629                                  ;  180 arr sign byte   134 NULL        0 I_LOOPE[9]
  6630                                  ;  181 arr sign byte   135 NULL        0 I_LOOP[8]
  6631                                  ;  182 arr sign byte   136 NULL        0 I_JCXZ[8]
  6632                                  ;  183 arr sign byte   137 NULL        0 I_JECXZ[9]
  6633                                  ;  184 arr sign byte   139 NULL        0 I_ENTER[9]
  6634                                  ;  185 arr sign byte   141 NULL        0 I_ORG[6]
  6635                                  ;  186 arr sign byte   146 NULL        0 I_DB[5]
  6636                                  ;  187 arr sign byte   147 NULL        0 I_DW[5]
  6637                                  ;  188 arr sign byte   148 NULL        0 I_DD[5]
  6638                                  ;  189 arr sign byte   149 NULL        0 I_RESB[7]
  6639                                  ;  190 arr sign byte   150 NULL        0 I_RESW[7]
  6640                                  ;  191 arr sign byte   151 NULL        0 I_RESD[7]
  6641                                  ;  192 var sign byte   152 NULL        0 I_END
  6642                                  
  6643                                  
  6644                                  ;   # Calls Line Width  Name   list of functions
  6645                                  
  6646                                  ;    0    1    1 word   parse
  6647                                  ;    1   14   27 word   getTokeType
  6648                                  ;    2    2   36 word   storeLabel
  6649                                  ;    3    2   46 word   searchLabel
  6650                                  ;    4    1   57 word   getVariable
  6651                                  ;    5    2   86 word   lookCode
  6652                                  ;    6    1  101 word   getCodeSize
  6653                                  ;    7    8  108 word   isToken
  6654                                  ;    8    2  113 word   need
  6655                                  ;    9    1  123 word   skipRest
  6656                                  ;   10    1    1 word   getLine
  6657                                  ;   11    1   17 word   ifEOL
  6658                                  ;   12    3   24 word   skipBlank
  6659                                  ;   13    2   29 word   letterE
  6660                                  ;   14    1   39 word   alnumE
  6661                                  ;   15    1   44 word   getDigit
  6662                                  ;   16    1   56 word   getName
  6663                                  ;   17    1   75 word   testReg
  6664                                  ;   18    1    1 word   printLine
  6665                                  ;   19    8   19 word   prc
  6666                                  ;   20    1   23 word   prscomment
  6667                                  ;   21   30   26 word   prs
  6668                                  ;   22   12   31 word   printhex8a
  6669                                  ;   23    1   35 word   printhex16
  6670                                  ;   24    3   38 word   printIntU
  6671                                  ;   25   26   45 word   error1
  6672                                  ;   26 NULL   48 word   allowederror
  6673                                  ;   27    1   49 word   addrerror
  6674                                  ;   28    1   50 word   immeerror
  6675                                  ;   29    2   51 word   implerror
  6676                                  ;   30    4   52 word   indexerror
  6677                                  ;   31    2   53 word   invaloperror
  6678                                  ;   32    1   54 word   numbererror
  6679                                  ;   33 NULL   55 word   regmemerror
  6680                                  ;   34    1   56 word   reg16error
  6681                                  ;   35    1   57 word   segregerror
  6682                                  ;   36    2   58 word   syntaxerror
  6683                                  ;   37   12   60 word   errorexit
  6684                                  ;   38    1   61 word   addrexit
  6685                                  ;   39 NULL   62 word   internexit
  6686                                  ;   40 NULL    1 word   main
  6687                                  ;   41    1    8 word   getarg
  6688                                  ;   42    1   38 word   epilog
  6689                                  ;   43    2   67 word   end1
  6690                                  ;   44    1    2 word   getCodes
  6691                                  ;   45    1    7 word   gen66h
  6692                                  ;   46    2    9 word   genCode
  6693                                  ;   47    1   13 word   genCodeDW
  6694                                  ;   48    5   17 word   genCodeW
  6695                                  ;   49   15   21 word   genCode8
  6696                                  ;   50    4   32 word   genCode16
  6697                                  ;   51    5   36 word   writeEA
  6698                                  ;   52    2   82 word   genImmediate
  6699                                  ;   53    1   11 word   process
  6700                                  ;   54    1  125 word   checkOpL
  6701                                  ;   55    1  145 word   get2Ops
  6702                                  ;   56    3  152 word   getOpL
  6703                                  ;   57    3  162 word   getOpR
  6704                                  ;   58    2  172 word   getOp1
  6705                                  ;   59    1  188 word   getMEM
  6706                                  ;   60    1  210 word   getIndReg1
  6707                                  ;   61    1  218 word   getIndReg2
  6708                                  ;   62    2  229 word   setwflag
  6709                                  ;   63    1  241 word   getSignExtended
  6710                                  ;   64    4  249 word   writetty
  6711                                  ;   65    8  250 word   cputs
  6712                                  ;   66    2  251 word   toupper
  6713                                  ;   67    3  253 word   strlen
  6714                                  ;   68    6  254 word   strcpy
  6715                                  ;   69    3  256 word   digit
  6716                                  ;   70   35  257 word   eqstr
  6717                                  ;   71    3  260 word   strcat1
  6718                                  ;   72    1  261 word   openR
  6719                                  ;   73    2  262 word   creatR
  6720                                  ;   74    2  263 word   readRL
  6721                                  ;   75    2  264 word   fputcR
  6722                                  ;   76    3  266 word   fcloseR
  6723                                  ;   77    5  267 word   exitR
  6724                                  ;   78    1  269 word   putch
  6725                                  ;   79    4  270 word   DosInt
  6726                                  ;   80 NULL  271 word   LastFunctionByt
  6727                                  
  6728                                  ;    #  addr name   list of CALLs
  6729                                  
  6730                                  ;    0  1345 getLine
  6731                                  ;    1  1353 getTokeType
  6732                                  ;    2  1365 storeLabel
  6733                                  ;    3  1376 getTokeType
  6734                                  ;    4  1388 lookCode
  6735                                  ;    5  1397 process
  6736                                  ;    6  1405 getVariable
  6737                                  ;    7  1417 skipRest
  6738                                  ;    8  1426 error1
  6739                                  ;    9  1433 error1
  6740                                  ;   10  1440 printLine
  6741                                  ;   11  1464 skipBlank
  6742                                  ;   12  1474 digit
  6743                                  ;   13  1480 getDigit
  6744                                  ;   14  1489 letterE
  6745                                  ;   15  1497 getName
  6746                                  ;   16  1518 searchLabel
  6747                                  ;   17  1530 error1
  6748                                  ;   18  1537 strcpy
  6749                                  ;   19  1544 errorexit
  6750                                  ;   20  1554 errorexit
  6751                                  ;   21  1584 eqstr
  6752                                  ;   22  1590 strlen
  6753                                  ;   23  1611 storeLabel
  6754                                  ;   24  1622 getTokeType
  6755                                  ;   25  1634 lookCode
  6756                                  ;   26  1643 errorexit
  6757                                  ;   27  1653 errorexit
  6758                                  ;   28  1663 getTokeType
  6759                                  ;   29  1675 genCode8
  6760                                  ;   30  1684 skipBlank
  6761                                  ;   31  1694 isToken
  6762                                  ;   32  1702 genCode8
  6763                                  ;   33  1711 isToken
  6764                                  ;   34  1719 getTokeType
  6765                                  ;   35  1731 genCode16
  6766                                  ;   36  1741 isToken
  6767                                  ;   37  1749 errorexit
  6768                                  ;   38  1768 eqstr
  6769                                  ;   39  1786 eqstr
  6770                                  ;   40  1792 getTokeType
  6771                                  ;   41  1804 eqstr
  6772                                  ;   42  1810 getTokeType
  6773                                  ;   43  1822 eqstr
  6774                                  ;   44  1828 getTokeType
  6775                                  ;   45  1850 skipBlank
  6776                                  ;   46  1867 isToken
  6777                                  ;   47  1875 getTokeType
  6778                                  ;   48  1887 error1
  6779                                  ;   49  1894 prs
  6780                                  ;   50  1898 prc
  6781                                  ;   51  1911 getTokeType
  6782                                  ;   52  1923 error1
  6783                                  ;   53  1940 readRL
  6784                                  ;   54  1947 errorexit
  6785                                  ;   55  1957 errorexit
  6786                                  ;   56  1967 ifEOL
  6787                                  ;   57  1981 readRL
  6788                                  ;   58  2017 digit
  6789                                  ;   59  2023 letterE
  6790                                  ;   60  2050 digit
  6791                                  ;   61  2070 alnumE
  6792                                  ;   62  2077 errorexit
  6793                                  ;   63  2087 strcpy
  6794                                  ;   64  2094 toupper
  6795                                  ;   65  2110 strlen
  6796                                  ;   66  2117 strlen
  6797                                  ;   67  2124 eqstr
  6798                                  ;   68  2130 eqstr
  6799                                  ;   69  2136 eqstr
  6800                                  ;   70  2142 eqstr
  6801                                  ;   71  2148 eqstr
  6802                                  ;   72  2154 eqstr
  6803                                  ;   73  2160 eqstr
  6804                                  ;   74  2166 eqstr
  6805                                  ;   75  2172 eqstr
  6806                                  ;   76  2178 eqstr
  6807                                  ;   77  2184 eqstr
  6808                                  ;   78  2190 eqstr
  6809                                  ;   79  2196 eqstr
  6810                                  ;   80  2202 eqstr
  6811                                  ;   81  2208 eqstr
  6812                                  ;   82  2214 eqstr
  6813                                  ;   83  2220 eqstr
  6814                                  ;   84  2226 eqstr
  6815                                  ;   85  2232 eqstr
  6816                                  ;   86  2238 eqstr
  6817                                  ;   87  2244 eqstr
  6818                                  ;   88  2250 eqstr
  6819                                  ;   89  2256 eqstr
  6820                                  ;   90  2262 eqstr
  6821                                  ;   91  2268 eqstr
  6822                                  ;   92  2274 eqstr
  6823                                  ;   93  2280 eqstr
  6824                                  ;   94  2286 eqstr
  6825                                  ;   95  2292 eqstr
  6826                                  ;   96  2298 eqstr
  6827                                  ;   97  2318 prs
  6828                                  ;   98  2322 printhex16
  6829                                  ;   99  2333 prs
  6830                                  ;  100  2337 prc
  6831                                  ;  101  2341 printhex8a
  6832                                  ;  102  2352 prc
  6833                                  ;  103  2356 prs
  6834                                  ;  104  2360 prscomment
  6835                                  ;  105  2377 writetty
  6836                                  ;  106  2386 writetty
  6837                                  ;  107  2395 fputcR
  6838                                  ;  108  2417 prc
  6839                                  ;  109  2433 prc
  6840                                  ;  110  2454 prc
  6841                                  ;  111  2458 prc
  6842                                  ;  112  2480 printhex8a
  6843                                  ;  113  2491 printhex8a
  6844                                  ;  114  2516 printIntU
  6845                                  ;  115  2526 prc
  6846                                  ;  116  2539 prs
  6847                                  ;  117  2543 prs
  6848                                  ;  118  2547 prs
  6849                                  ;  119  2551 prs
  6850                                  ;  120  2568 error1
  6851                                  ;  121  2585 error1
  6852                                  ;  122  2602 error1
  6853                                  ;  123  2619 error1
  6854                                  ;  124  2637 error1
  6855                                  ;  125  2657 error1
  6856                                  ;  126  2676 error1
  6857                                  ;  127  2695 error1
  6858                                  ;  128  2713 error1
  6859                                  ;  129  2732 error1
  6860                                  ;  130  2751 error1
  6861                                  ;  131  2770 error1
  6862                                  ;  132  2777 end1
  6863                                  ;  133  2791 errorexit
  6864                                  ;  134  2812 errorexit
  6865                                  ;  135  2827 getarg
  6866                                  ;  136  2834 parse
  6867                                  ;  137  2840 epilog
  6868                                  ;  138  2847 end1
  6869                                  ;  139  2871 cputs
  6870                                  ;  140  2877 cputs
  6871                                  ;  141  2883 exitR
  6872                                  ;  142  2889 toupper
  6873                                  ;  143  2897 strcpy
  6874                                  ;  144  2904 strcat1
  6875                                  ;  145  2912 strcpy
  6876                                  ;  146  2919 strcat1
  6877                                  ;  147  2927 strcpy
  6878                                  ;  148  2934 strcat1
  6879                                  ;  149  2942 openR
  6880                                  ;  150  2948 cputs
  6881                                  ;  151  2954 cputs
  6882                                  ;  152  2960 exitR
  6883                                  ;  153  2966 creatR
  6884                                  ;  154  2973 cputs
  6885                                  ;  155  2979 cputs
  6886                                  ;  156  2985 exitR
  6887                                  ;  157  2991 creatR
  6888                                  ;  158  2998 cputs
  6889                                  ;  159  3004 cputs
  6890                                  ;  160  3010 exitR
  6891                                  ;  161  3016 prs
  6892                                  ;  162  3020 prs
  6893                                  ;  163  3024 prs
  6894                                  ;  164  3028 prs
  6895                                  ;  165  3032 prs
  6896                                  ;  166  3036 prs
  6897                                  ;  167  3040 prs
  6898                                  ;  168  3044 prs
  6899                                  ;  169  3048 prs
  6900                                  ;  170  3065 prs
  6901                                  ;  171  3069 printIntU
  6902                                  ;  172  3079 prs
  6903                                  ;  173  3083 prs
  6904                                  ;  174  3087 printIntU
  6905                                  ;  175  3097 prs
  6906                                  ;  176  3101 fputcR
  6907                                  ;  177  3115 fcloseR
  6908                                  ;  178  3123 fcloseR
  6909                                  ;  179  3131 fcloseR
  6910                                  ;  180  3139 exitR
  6911                                  ;  181  3161 genCode8
  6912                                  ;  182  3182 genCode8
  6913                                  ;  183  3203 genCodeW
  6914                                  ;  184  3223 genCode8
  6915                                  ;  185  3243 errorexit
  6916                                  ;  186  3265 genCode8
  6917                                  ;  187  3274 genCode8
  6918                                  ;  188  3299 prs
  6919                                  ;  189  3303 printhex8a
  6920                                  ;  190  3314 prs
  6921                                  ;  191  3318 printhex8a
  6922                                  ;  192  3329 prs
  6923                                  ;  193  3333 printhex8a
  6924                                  ;  194  3344 prs
  6925                                  ;  195  3348 printhex8a
  6926                                  ;  196  3359 prs
  6927                                  ;  197  3363 printhex8a
  6928                                  ;  198  3374 addrexit
  6929                                  ;  199  3383 error1
  6930                                  ;  200  3390 genCode8
  6931                                  ;  201  3399 genCode8
  6932                                  ;  202  3408 genCode16
  6933                                  ;  203  3431 genCode16
  6934                                  ;  204  3441 genCode8
  6935                                  ;  205  3460 getTokeType
  6936                                  ;  206  3472 getCodeSize
  6937                                  ;  207  3484 getCodes
  6938                                  ;  208  3493 genCode8
  6939                                  ;  209  3502 getOpL
  6940                                  ;  210  3509 checkOpL
  6941                                  ;  211  3518 prs
  6942                                  ;  212  3522 printhex8a
  6943                                  ;  213  3533 prs
  6944                                  ;  214  3537 printhex8a
  6945                                  ;  215  3548 prs
  6946                                  ;  216  3552 printhex8a
  6947                                  ;  217  3563 prs
  6948                                  ;  218  3567 printhex8a
  6949                                  ;  219  3578 genCode
  6950                                  ;  220  3586 genCode
  6951                                  ;  221  3594 getTokeType
  6952                                  ;  222  3606 implerror
  6953                                  ;  223  3616 genCodeW
  6954                                  ;  224  3625 writeEA
  6955                                  ;  225  3633 getOpL
  6956                                  ;  226  3640 reg16error
  6957                                  ;  227  3651 need
  6958                                  ;  228  3656 getOpR
  6959                                  ;  229  3663 addrerror
  6960                                  ;  230  3673 genCode8
  6961                                  ;  231  3682 genCode8
  6962                                  ;  232  3691 writeEA
  6963                                  ;  233  3699 get2Ops
  6964                                  ;  234  3707 immeerror
  6965                                  ;  235  3717 invaloperror
  6966                                  ;  236  3730 setwflag
  6967                                  ;  237  3739 getSignExtended
  6968                                  ;  238  3755 genCodeW
  6969                                  ;  239  3764 genImmediate
  6970                                  ;  240  3777 genCodeW
  6971                                  ;  241  3786 writeEA
  6972                                  ;  242  3794 genImmediate
  6973                                  ;  243  3807 genCodeDW
  6974                                  ;  244  3817 writeEA
  6975                                  ;  245  3825 genCodeW
  6976                                  ;  246  3834 writeEA
  6977                                  ;  247  3842 syntaxerror
  6978                                  ;  248  3854 genCode8
  6979                                  ;  249  3863 genCode16
  6980                                  ;  250  3873 genCode8
  6981                                  ;  251  3882 error1
  6982                                  ;  252  3889 error1
  6983                                  ;  253  3905 implerror
  6984                                  ;  254  3915 segregerror
  6985                                  ;  255  3927 setwflag
  6986                                  ;  256  3936 error1
  6987                                  ;  257  3943 error1
  6988                                  ;  258  3950 error1
  6989                                  ;  259  3965 getOpL
  6990                                  ;  260  3972 need
  6991                                  ;  261  3977 getOpR
  6992                                  ;  262  3991 getOpR
  6993                                  ;  263  4005 getOp1
  6994                                  ;  264  4012 isToken
  6995                                  ;  265  4020 getMEM
  6996                                  ;  266  4027 invaloperror
  6997                                  ;  267  4040 error1
  6998                                  ;  268  4054 testReg
  6999                                  ;  269  4062 searchLabel
  7000                                  ;  270  4074 error1
  7001                                  ;  271  4090 getTokeType
  7002                                  ;  272  4102 getOp1
  7003                                  ;  273  4109 syntaxerror
  7004                                  ;  274  4121 getIndReg2
  7005                                  ;  275  4132 getIndReg1
  7006                                  ;  276  4143 isToken
  7007                                  ;  277  4151 getTokeType
  7008                                  ;  278  4163 numbererror
  7009                                  ;  279  4175 isToken
  7010                                  ;  280  4183 isToken
  7011                                  ;  281  4191 errorexit
  7012                                  ;  282  4212 indexerror
  7013                                  ;  283  4223 indexerror
  7014                                  ;  284  4247 indexerror
  7015                                  ;  285  4258 indexerror
  7016                                  ;  286  4278 gen66h
  7017                                  ;  287  4303 error1
  7018                                  ;  288  4329 putch
  7019                                  ;  289  4397 strcpy
  7020                                  ;  290  4412 DosInt
  7021                                  ;  291  4428 DosInt
  7022                                  ;  292  4451 DosInt
  7023                                  ;  293  4470 DosInt
  7024                                  ;  294  4504 writetty
  7025                                  ;  295  4513 writetty
  7026                                  ;Input: AS.C, List: AS.S,  Lines:  272
  7027                                  ;Glob. variables:  192 max.:  200
  7028                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  7029                                  ;Functions      :   81 max.:  300
  7030                                  ;Calls          :  296 max.: 2000, NameField: 4545 max.:    65535
  7031                                  ;Code until     :25998 max.: 30000, free: 4002
  7032                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  7033                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
