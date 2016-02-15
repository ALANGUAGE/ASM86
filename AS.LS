     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E91923                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.07 14.2.16";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E30-     Version1 db "AS.C V0.07 14.2.16",0
    10 0000000C 372031342E322E3136-
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
   969 0000125A E83E16                   call process
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
  1083 00001322 E8341E                   call digit
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
  1152 0000139D E8801D                   call strcpy
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
  1245 00001447 E8421D                   call eqstr
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
  1256 0000145C E8961C                   call strlen
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
  1438 00001547 E8EA11                   call genCode16
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
  1511 000015D5 E8B41B                   call eqstr
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
  1595 00001644 E8451B                   call eqstr
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
  1609 00001664 E8251B                   call eqstr
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
  1623 00001684 E8051B                   call eqstr
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
  1807 0000176D E8B71A                   call readRL
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
  1918 00001831 E8F319                   call readRL
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
  2076 00001919 E83D18                   call digit
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
  2169 0000199B E8BB17                   call digit
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
  2292 00001A40 E8DD16                   call strcpy
  2293 00001A43 83C404                   add  sp, 4
  2294                                  
  2295                                  ;-73   toupper(SymbolUpper);
  2296                                  
  2297 00001A46 8D06[3600]               lea  ax, [SymbolUpper]
  2298 00001A4A 50                       push ax
  2299 00001A4B E86416                   call toupper
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
  2326 00001A71 E88116                   call strlen
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
  2338 00001A8B E86716                   call strlen
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
  2356 00001AB1 E8D816                   call eqstr
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
  2369 00001ACE E8BB16                   call eqstr
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
  2382 00001AEB E89E16                   call eqstr
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
  2395 00001B08 E88116                   call eqstr
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
  2408 00001B25 E86416                   call eqstr
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
  2421 00001B42 E84716                   call eqstr
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
  2434 00001B5F E82A16                   call eqstr
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
  2447 00001B7C E80D16                   call eqstr
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
  2465 00001BA2 E8E715                   call eqstr
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
  2478 00001BBF E8CA15                   call eqstr
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
  2491 00001BDC E8AD15                   call eqstr
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
  2504 00001BF9 E89015                   call eqstr
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
  2517 00001C16 E87315                   call eqstr
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
  2530 00001C33 E85615                   call eqstr
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
  2543 00001C50 E83915                   call eqstr
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
  2556 00001C6D E81C15                   call eqstr
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
  2574 00001C93 E8F614                   call eqstr
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
  2587 00001CB0 E8D914                   call eqstr
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
  2600 00001CCD E8BC14                   call eqstr
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
  2613 00001CEA E89F14                   call eqstr
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
  2626 00001D07 E88214                   call eqstr
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
  2639 00001D24 E86514                   call eqstr
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
  2657 00001D4A E83F14                   call eqstr
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
  2670 00001D67 E82214                   call eqstr
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
  2683 00001D84 E80514                   call eqstr
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
  2696 00001DA1 E8E813                   call eqstr
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
  2709 00001DBE E8CB13                   call eqstr
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
  2722 00001DDB E8AE13                   call eqstr
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
  2735 00001DF8 E89113                   call eqstr
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
  2748 00001E15 E87413                   call eqstr
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
  2939 00001F64 E81511                   call writetty
  2940                                  
  2941                                  ;-20      al=c; writetty(); }
  2942                                  
  2943                                  @@prc117:
  2944 00001F67 8A4604                   mov  al, [bp+4]
  2945 00001F6A E80F11                   call writetty
  2946                                  
  2947                                  ;-21    fputcR(c,lst_fd); }
  2948                                  
  2949                                  @@prc116:
  2950 00001F6D FF36[A301]               push word [lst_fd]
  2951 00001F71 8A4604                   mov al, byte [bp+4]
  2952 00001F74 B400                     mov ah, 0
  2953 00001F76 50                       push ax
  2954 00001F77 E8C212                   call fputcR
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
  3494 00002347 E83A0D                   call cputs
  3495 0000234A 83C402                   add  sp, 2
  3496                                  
  3497                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3498                                  
  3499 0000234D 68[EE24]                 push getarg_0
  3500 00002350 E8310D                   call cputs
  3501 00002353 83C402                   add  sp, 2
  3502                                  
  3503                                  ;-13     exitR(3);
  3504                                  
  3505 00002356 6A03                     push 3
  3506 00002358 E8040F                   call exitR
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
  3532 00002379 E8360D                   call toupper
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
  3543 00002388 E8950D                   call strcpy
  3544 0000238B 83C404                   add  sp, 4
  3545 0000238E 68[1325]                 push getarg_1
  3546 00002391 8D06[D800]               lea  ax, [namein]
  3547 00002395 50                       push ax
  3548 00002396 E8480E                   call strcat1
  3549 00002399 83C404                   add  sp, 4
  3550                                  
  3551                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3552                                  
  3553 0000239C FF36[5B0E]               push word [argv]
  3554 000023A0 8D06[1B01]               lea  ax, [namelst]
  3555 000023A4 50                       push ax
  3556 000023A5 E8780D                   call strcpy
  3557 000023A8 83C404                   add  sp, 4
  3558 000023AB 68[1625]                 push getarg_2
  3559 000023AE 8D06[1B01]               lea  ax, [namelst]
  3560 000023B2 50                       push ax
  3561 000023B3 E82B0E                   call strcat1
  3562 000023B6 83C404                   add  sp, 4
  3563                                  
  3564                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3565                                  
  3566 000023B9 FF36[5B0E]               push word [argv]
  3567 000023BD 8D06[5E01]               lea  ax, [namebin]
  3568 000023C1 50                       push ax
  3569 000023C2 E85B0D                   call strcpy
  3570 000023C5 83C404                   add  sp, 4
  3571 000023C8 68[1B25]                 push getarg_3
  3572 000023CB 8D06[5E01]               lea  ax, [namebin]
  3573 000023CF 50                       push ax
  3574 000023D0 E80E0E                   call strcat1
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
  3598 000023FF E8040E                   call openR
  3599 00002402 83C402                   add  sp, 2
  3600 00002405 A3[A101]                 mov word [asm_fd], ax
  3601                                  
  3602                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3603                                  
  3604 00002408 A1[A701]                 mov ax, [DOS_ERR]
  3605 0000240B 08C0                     or  al, al
  3606 0000240D 0F841C00                 je @@getarg133
  3607 00002411 68[2025]                 push getarg_4
  3608 00002414 E86D0C                   call cputs
  3609 00002417 83C402                   add  sp, 2
  3610 0000241A 8D06[D800]               lea  ax, [namein]
  3611 0000241E 50                       push ax
  3612 0000241F E8620C                   call cputs
  3613 00002422 83C402                   add  sp, 2
  3614 00002425 6A01                     push 1
  3615 00002427 E8350E                   call exitR
  3616 0000242A 83C402                   add  sp, 2
  3617                                  
  3618                                  ;-28   lst_fd=creatR(namelst);
  3619                                  
  3620                                  @@getarg133:
  3621 0000242D 8D06[1B01]               lea  ax, [namelst]
  3622 00002431 50                       push ax
  3623 00002432 E8E00D                   call creatR
  3624 00002435 83C402                   add  sp, 2
  3625 00002438 A3[A301]                 mov word [lst_fd], ax
  3626                                  
  3627                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3628                                  
  3629 0000243B A1[A701]                 mov ax, [DOS_ERR]
  3630 0000243E 08C0                     or  al, al
  3631 00002440 0F841C00                 je @@getarg134
  3632 00002444 68[3625]                 push getarg_5
  3633 00002447 E83A0C                   call cputs
  3634 0000244A 83C402                   add  sp, 2
  3635 0000244D 8D06[1B01]               lea  ax, [namelst]
  3636 00002451 50                       push ax
  3637 00002452 E82F0C                   call cputs
  3638 00002455 83C402                   add  sp, 2
  3639 00002458 6A02                     push 2
  3640 0000245A E8020E                   call exitR
  3641 0000245D 83C402                   add  sp, 2
  3642                                  
  3643                                  ;-30   bin_fd=creatR(namebin);
  3644                                  
  3645                                  @@getarg134:
  3646 00002460 8D06[5E01]               lea  ax, [namebin]
  3647 00002464 50                       push ax
  3648 00002465 E8AD0D                   call creatR
  3649 00002468 83C402                   add  sp, 2
  3650 0000246B A3[A501]                 mov word [bin_fd], ax
  3651                                  
  3652                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3653                                  
  3654 0000246E A1[A701]                 mov ax, [DOS_ERR]
  3655 00002471 08C0                     or  al, al
  3656 00002473 0F841C00                 je @@getarg135
  3657 00002477 68[4D25]                 push getarg_6
  3658 0000247A E8070C                   call cputs
  3659 0000247D 83C402                   add  sp, 2
  3660 00002480 8D06[5E01]               lea  ax, [namebin]
  3661 00002484 50                       push ax
  3662 00002485 E8FC0B                   call cputs
  3663 00002488 83C402                   add  sp, 2
  3664 0000248B 6A02                     push 2
  3665 0000248D E8CF0D                   call exitR
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
  3861 000025E3 E8560C                   call fputcR
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
  3900 00002635 E8190C                   call fcloseR
  3901 00002638 83C402                   add  sp, 2
  3902                                  
  3903                                  ;-69   fcloseR(lst_fd);
  3904                                  
  3905 0000263B FF36[A301]               push word [lst_fd]
  3906 0000263F E80F0C                   call fcloseR
  3907 00002642 83C402                   add  sp, 2
  3908                                  
  3909                                  ;-70   fcloseR(bin_fd);
  3910                                  
  3911 00002645 FF36[A501]               push word [bin_fd]
  3912 00002649 E8050C                   call fcloseR
  3913 0000264C 83C402                   add  sp, 2
  3914                                  
  3915                                  ;-71   exitR(n);
  3916                                  
  3917 0000264F FF7604                   push word [bp+4]
  3918 00002652 E80A0C                   call exitR
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
  4090                                  ;-26     if (BinLen >= FILEBINMAX) errorexit("COM file to long");
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
  4127 00002723 434F4D2066696C6520-     genCode8_0 db "COM file to long",0
  4128 0000272C 746F206C6F6E6700   
  4129                                  
  4130                                  genCode16:  ; *** PROC ***
  4131                                  
  4132                                  ;-33     genCode8(i); i=i >> 8;
  4133                                  
  4134                                  ;Function : genCode16, Number of local variables: 1
  4135                                  ;   # type sign width line used address name   list of local variables
  4136                                  ;  200 var unsg word    32 NULL bp+4    i;
  4137 00002734 C8000000                 ENTER  0,0
  4138 00002738 FF7604                   push word [bp+4]
  4139 0000273B E8A0FF                   call genCode8
  4140 0000273E 83C402                   add  sp, 2
  4141 00002741 8B4604                   mov ax, [bp+4]
  4142 00002744 C1E808                   shr ax, 8
  4143 00002747 894604                   mov word [bp+4], ax
  4144                                  
  4145                                  ;-34     genCode8(i);
  4146                                  
  4147 0000274A FF7604                   push word [bp+4]
  4148 0000274D E88EFF                   call genCode8
  4149 00002750 83C402                   add  sp, 2
  4150                                  
  4151                                  ;-35 }
  4152                                  
  4153                                  
  4154                                  ;-36 int writeEA(char xxx) {//need: Op, disp, RegNo, regindexbase, isDirect
  4155 00002753 C9                       LEAVE
  4156 00002754 C3                       ret
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
  4173 00002755 C8020000                 ENTER  2,0
  4174 00002759 66B800000000             mov eax, 0
  4175 0000275F 8846FE                   mov byte [bp-2], al
  4176                                  
  4177                                  ;-40 //   prs("\nx:"); printhex8a(xxx);       
  4178                                  
  4179                                  
  4180                                  ;-41 //    prs(", rib:"); printhex8a(regindexbase);       
  4181                                  
  4182                                  
  4183                                  ;-42     xxx = xxx << 3;//in reg/opcode field
  4184                                  
  4185 00002762 8A4604                   mov al, [bp+4]
  4186 00002765 C0E003                   shl al, 3
  4187 00002768 884604                   mov byte [bp+4], al
  4188                                  
  4189                                  ;-43 //    prs(", xxx:"); printhex8a(xxx);       
  4190                                  
  4191                                  
  4192                                  ;-44 //    prs(", Op:"); printhex8a(Op);
  4193                                  
  4194                                  
  4195                                  ;-45     if (Op ==   0) addrexit();
  4196                                  
  4197 0000276B A0[B401]                 mov al, [Op]
  4198 0000276E 3C00                     cmp al, 0
  4199 00002770 0F850300                 jne @@writeEA141
  4200 00002774 E86BFB                   call addrexit
  4201                                  
  4202                                  ;-46     if (Op == REG) {
  4203                                  
  4204                                  @@writeEA141:
  4205 00002777 A0[B401]                 mov al, [Op]
  4206 0000277A 3C02                     cmp al, 2
  4207 0000277C 0F852400                 jne @@writeEA142
  4208                                  
  4209                                  ;-47         xxx |= 0xC0; 
  4210                                  
  4211 00002780 804E04C0                 or  byte [bp+4], 192
  4212                                  
  4213                                  ;-48         if (Op2 == REG) xxx = xxx + R1No;
  4214                                  
  4215 00002784 A0[B501]                 mov al, [Op2]
  4216 00002787 3C02                     cmp al, 2
  4217 00002789 0F850D00                 jne @@writeEA143
  4218 0000278D 8A4604                   mov al, [bp+4]
  4219 00002790 0206[BB01]               add al, [R1No]
  4220 00002794 884604                   mov byte [bp+4], al
  4221                                  
  4222                                  ;-49         else            xxx = xxx + RegNo;
  4223                                  
  4224 00002797 E90A00                   jmp @@writeEA144
  4225                                  @@writeEA143:
  4226 0000279A 8A4604                   mov al, [bp+4]
  4227 0000279D 0206[BA01]               add al, [RegNo]
  4228 000027A1 884604                   mov byte [bp+4], al
  4229                                  
  4230                                  ;-50         } 
  4231                                  
  4232                                  @@writeEA144:
  4233                                  
  4234                                  ;-51     if (Op == ADR) error1("writeEA");           
  4235                                  
  4236                                  @@writeEA142:
  4237 000027A4 A0[B401]                 mov al, [Op]
  4238 000027A7 3C03                     cmp al, 3
  4239 000027A9 0F850900                 jne @@writeEA145
  4240 000027AD 68[7228]                 push writeEA_0
  4241 000027B0 E857F9                   call error1
  4242 000027B3 83C402                   add  sp, 2
  4243                                  
  4244                                  ;-52     if (Op == MEM) {
  4245                                  
  4246                                  @@writeEA145:
  4247 000027B6 A0[B401]                 mov al, [Op]
  4248 000027B9 3C04                     cmp al, 4
  4249 000027BB 0F857F00                 jne @@writeEA146
  4250                                  
  4251                                  ;-53         if (isDirect) {
  4252                                  
  4253 000027BF A0[C201]                 mov al, [isDirect]
  4254 000027C2 08C0                     or  al, al
  4255 000027C4 0F841000                 je @@writeEA147
  4256                                  
  4257                                  ;-54             xxx |= 6;
  4258                                  
  4259 000027C8 804E0406                 or  byte [bp+4], 6
  4260                                  
  4261                                  ;-55             len = 2;
  4262                                  
  4263 000027CC 66B802000000             mov eax, 2
  4264 000027D2 8846FE                   mov byte [bp-2], al
  4265                                  
  4266                                  ;-56         }
  4267                                  
  4268                                  
  4269                                  ;-57         else { 
  4270                                  
  4271 000027D5 E96600                   jmp @@writeEA148
  4272                                  @@writeEA147:
  4273                                  
  4274                                  ;-58             xxx = xxx + regindexbase;   
  4275                                  
  4276 000027D8 8A4604                   mov al, [bp+4]
  4277 000027DB 0206[C101]               add al, [regindexbase]
  4278 000027DF 884604                   mov byte [bp+4], al
  4279                                  
  4280                                  ;-59             if (regindexbase == 6) {//make [BP+00]
  4281                                  
  4282 000027E2 A0[C101]                 mov al, [regindexbase]
  4283 000027E5 3C06                     cmp al, 6
  4284 000027E7 0F851700                 jne @@writeEA149
  4285                                  
  4286                                  ;-60                 len=1;
  4287                                  
  4288 000027EB 66B801000000             mov eax, 1
  4289 000027F1 8846FE                   mov byte [bp-2], al
  4290                                  
  4291                                  ;-61                 if (disp == 0) xxx |= 0x40;
  4292                                  
  4293 000027F4 A1[C301]                 mov ax, [disp]
  4294 000027F7 83F800                   cmp ax, 0
  4295 000027FA 0F850400                 jne @@writeEA150
  4296 000027FE 804E0440                 or  byte [bp+4], 64
  4297                                  
  4298                                  ;-62             }
  4299                                  
  4300                                  @@writeEA150:
  4301                                  
  4302                                  ;-63 
  4303                                  
  4304                                  
  4305                                  ;-64             if (disp) {
  4306                                  
  4307                                  @@writeEA149:
  4308 00002802 A1[C301]                 mov ax, [disp]
  4309 00002805 08C0                     or  al, al
  4310 00002807 0F843300                 je @@writeEA151
  4311                                  
  4312                                  ;-65                 ax = disp;
  4313                                  
  4314 0000280B A1[C301]                 mov  ax, [disp]
  4315                                  
  4316                                  ;-66                 if(ax > 127) len=2;
  4317                                  
  4318 0000280E 83F87F                   cmp  ax, 127
  4319 00002811 0F8E0C00                 jle @@writeEA152
  4320 00002815 66B802000000             mov eax, 2
  4321 0000281B 8846FE                   mov byte [bp-2], al
  4322                                  
  4323                                  ;-67                 else len=1;
  4324                                  
  4325 0000281E E90900                   jmp @@writeEA153
  4326                                  @@writeEA152:
  4327 00002821 66B801000000             mov eax, 1
  4328 00002827 8846FE                   mov byte [bp-2], al
  4329                                  
  4330                                  ;-68                 if (len == 1) xxx |= 0x40;
  4331                                  
  4332                                  @@writeEA153:
  4333 0000282A 8A46FE                   mov al, [bp-2]
  4334 0000282D 3C01                     cmp al, 1
  4335 0000282F 0F850700                 jne @@writeEA154
  4336 00002833 804E0440                 or  byte [bp+4], 64
  4337                                  
  4338                                  ;-69                 else xxx |= 0x80;
  4339                                  
  4340 00002837 E90400                   jmp @@writeEA155
  4341                                  @@writeEA154:
  4342 0000283A 804E0480                 or  byte [bp+4], 128
  4343                                  
  4344                                  ;-70             }
  4345                                  
  4346                                  @@writeEA155:
  4347                                  
  4348                                  ;-71         }
  4349                                  
  4350                                  @@writeEA151:
  4351                                  
  4352                                  ;-72     }
  4353                                  
  4354                                  @@writeEA148:
  4355                                  
  4356                                  ;-73     genCode8(xxx);// gen second byte
  4357                                  
  4358                                  @@writeEA146:
  4359 0000283E 8A4604                   mov al, byte [bp+4]
  4360 00002841 B400                     mov ah, 0
  4361 00002843 50                       push ax
  4362 00002844 E897FE                   call genCode8
  4363 00002847 83C402                   add  sp, 2
  4364                                  
  4365                                  ;-74     if (len == 1) genCode8 (disp);
  4366                                  
  4367 0000284A 8A46FE                   mov al, [bp-2]
  4368 0000284D 3C01                     cmp al, 1
  4369 0000284F 0F850A00                 jne @@writeEA156
  4370 00002853 FF36[C301]               push word [disp]
  4371 00002857 E884FE                   call genCode8
  4372 0000285A 83C402                   add  sp, 2
  4373                                  
  4374                                  ;-75     if (len == 2) genCode16(disp);
  4375                                  
  4376                                  @@writeEA156:
  4377 0000285D 8A46FE                   mov al, [bp-2]
  4378 00002860 3C02                     cmp al, 2
  4379 00002862 0F850A00                 jne @@writeEA157
  4380 00002866 FF36[C301]               push word [disp]
  4381 0000286A E8C7FE                   call genCode16
  4382 0000286D 83C402                   add  sp, 2
  4383                                  
  4384                                  ;-76 }
  4385                                  
  4386                                  @@writeEA157:
  4387                                  
  4388                                  ;-77 
  4389                                  
  4390                                  
  4391                                  ;-78 int genImmediate() {
  4392 00002870 C9                       LEAVE
  4393 00002871 C3                       ret
  4394                                  ; ENDP
  4395 00002872 7772697465454100        writeEA_0 db "writeEA",0
  4396                                  
  4397                                  genImmediate:  ; *** PROC ***
  4398                                  
  4399                                  ;-79     if (wflag) genCode16(imme);
  4400                                  
  4401 0000287A A0[BF01]                 mov al, [wflag]
  4402 0000287D 08C0                     or  al, al
  4403 0000287F 0F840D00                 je @@genImmediate158
  4404 00002883 FF36[C501]               push word [imme]
  4405 00002887 E8AAFE                   call genCode16
  4406 0000288A 83C402                   add  sp, 2
  4407                                  
  4408                                  ;-80     else       genCode8 (imme);
  4409                                  
  4410 0000288D E90A00                   jmp @@genImmediate159
  4411                                  @@genImmediate158:
  4412 00002890 FF36[C501]               push word [imme]
  4413 00002894 E847FE                   call genCode8
  4414 00002897 83C402                   add  sp, 2
  4415                                  
  4416                                  ;-81 }    
  4417                                  
  4418                                  @@genImmediate159:
  4419 0000289A C3                       ret
  4420                                  ; ENDP
  4421                                  ;Back to main program: AS.C
  4422                                  
  4423                                  ;-10 
  4424                                  
  4425                                  
  4426                                  ;-11 int process() { 
  4427                                  
  4428                                  
  4429                                  process:  ; *** PROC ***
  4430                                  
  4431                                  ;-12     char c;
  4432                                  
  4433                                  
  4434                                  ;-13     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4435                                  
  4436                                  ;Function : process, Number of local variables: 1
  4437                                  ;   # type sign width line used address name   list of local variables
  4438                                  ;  200 var sign byte    12 NULL bp-2    c;
  4439 0000289B C8020000                 ENTER  2,0
  4440 0000289F E83EEA                   call getTokeType
  4441                                  
  4442                                  ;-14     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4443                                  
  4444 000028A2 E88EED                   call getCodeSize
  4445 000028A5 A2[BE01]                 mov byte [OpSize], al
  4446                                  
  4447                                  ;-15     getCodes();//set: Code1, Code2, Code3
  4448                                  
  4449 000028A8 E8AFFD                   call getCodes
  4450                                  
  4451                                  ;-16 
  4452                                  
  4453                                  
  4454                                  ;-17     if (CodeType ==  1) {//1 byte opcode
  4455                                  
  4456 000028AB A0[B601]                 mov al, [CodeType]
  4457 000028AE 3C01                     cmp al, 1
  4458 000028B0 0F850F00                 jne @@process160
  4459                                  
  4460                                  ;-18         genCode8(Code1);
  4461                                  
  4462 000028B4 A0[B701]                 mov al, byte [Code1]
  4463 000028B7 B400                     mov ah, 0
  4464 000028B9 50                       push ax
  4465 000028BA E821FE                   call genCode8
  4466 000028BD 83C402                   add  sp, 2
  4467                                  
  4468                                  ;-19         return;
  4469                                  
  4470 000028C0 E95402                   jmp @@retn
  4471                                  
  4472                                  ;-20     }
  4473                                  
  4474                                  
  4475                                  ;-21   
  4476                                  
  4477                                  
  4478                                  ;-22     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4479                                  
  4480                                  @@process160:
  4481 000028C3 A0[B601]                 mov al, [CodeType]
  4482 000028C6 3C02                     cmp al, 2
  4483 000028C8 0F858700                 jne @@process161
  4484                                  
  4485                                  ;-23         getOpL();
  4486                                  
  4487 000028CC E83C03                   call getOpL
  4488                                  
  4489                                  ;-24         checkOpL();
  4490                                  
  4491 000028CF E86B02                   call checkOpL
  4492                                  
  4493                                  ;-25         if (Code2 <= 1) {//inc,dec
  4494                                  
  4495 000028D2 A0[B801]                 mov al, [Code2]
  4496 000028D5 3C01                     cmp al, 1
  4497 000028D7 0F8F4500                 jg  @@process162
  4498                                  
  4499                                  ;-26   	        if (Op == REG) {//short
  4500                                  
  4501 000028DB A0[B401]                 mov al, [Op]
  4502 000028DE 3C02                     cmp al, 2
  4503 000028E0 0F853C00                 jne @@process163
  4504                                  
  4505                                  ;-27                 if (RegType == WORD) {genCode(Code3, RegNo); return; }
  4506                                  
  4507 000028E4 A0[BC01]                 mov al, [RegType]
  4508 000028E7 3C02                     cmp al, 2
  4509 000028E9 0F851500                 jne @@process164
  4510 000028ED A0[BA01]                 mov al, byte [RegNo]
  4511 000028F0 B400                     mov ah, 0
  4512 000028F2 50                       push ax
  4513 000028F3 A0[B901]                 mov al, byte [Code3]
  4514 000028F6 B400                     mov ah, 0
  4515 000028F8 50                       push ax
  4516 000028F9 E895FD                   call genCode
  4517 000028FC 83C404                   add  sp, 4
  4518 000028FF E91502                   jmp @@retn
  4519                                  
  4520                                  ;-28                 if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
  4521                                  
  4522                                  @@process164:
  4523 00002902 A0[BC01]                 mov al, [RegType]
  4524 00002905 3C03                     cmp al, 3
  4525 00002907 0F851500                 jne @@process165
  4526 0000290B A0[BA01]                 mov al, byte [RegNo]
  4527 0000290E B400                     mov ah, 0
  4528 00002910 50                       push ax
  4529 00002911 A0[B901]                 mov al, byte [Code3]
  4530 00002914 B400                     mov ah, 0
  4531 00002916 50                       push ax
  4532 00002917 E877FD                   call genCode
  4533 0000291A 83C404                   add  sp, 4
  4534 0000291D E9F701                   jmp @@retn
  4535                                  
  4536                                  ;-29             }
  4537                                  
  4538                                  @@process165:
  4539                                  
  4540                                  ;-30         }
  4541                                  
  4542                                  @@process163:
  4543                                  
  4544                                  ;-31         if (Code2 == 5) {//imul extension?
  4545                                  
  4546                                  @@process162:
  4547 00002920 A0[B801]                 mov al, [Code2]
  4548 00002923 3C05                     cmp al, 5
  4549 00002925 0F850F00                 jne @@process166
  4550                                  
  4551                                  ;-32             getTokeType();
  4552                                  
  4553 00002929 E8B4E9                   call getTokeType
  4554                                  
  4555                                  ;-33             if (TokeType) implerror();
  4556                                  
  4557 0000292C A0[B301]                 mov al, [TokeType]
  4558 0000292F 08C0                     or  al, al
  4559 00002931 0F840300                 je @@process167
  4560 00002935 E893F8                   call implerror
  4561                                  
  4562                                  ;-34         }
  4563                                  
  4564                                  @@process167:
  4565                                  
  4566                                  ;-35         genCodeW(Code1);
  4567                                  
  4568                                  @@process166:
  4569 00002938 A0[B701]                 mov al, byte [Code1]
  4570 0000293B B400                     mov ah, 0
  4571 0000293D 50                       push ax
  4572 0000293E E881FD                   call genCodeW
  4573 00002941 83C402                   add  sp, 2
  4574                                  
  4575                                  ;-36         writeEA(Code2);
  4576                                  
  4577 00002944 A0[B801]                 mov al, byte [Code2]
  4578 00002947 B400                     mov ah, 0
  4579 00002949 50                       push ax
  4580 0000294A E808FE                   call writeEA
  4581 0000294D 83C402                   add  sp, 2
  4582                                  
  4583                                  ;-37         return;
  4584                                  
  4585 00002950 E9C401                   jmp @@retn
  4586                                  
  4587                                  ;-38     }
  4588                                  
  4589                                  
  4590                                  ;-39   
  4591                                  
  4592                                  
  4593                                  ;-40     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4594                                  
  4595                                  @@process161:
  4596 00002953 A0[B601]                 mov al, [CodeType]
  4597 00002956 3C03                     cmp al, 3
  4598 00002958 0F856200                 jne @@process168
  4599                                  
  4600                                  ;-41         getOpL();
  4601                                  
  4602 0000295C E8AC02                   call getOpL
  4603                                  
  4604                                  ;-42         if (RegType != WORD) reg16error();//only r16
  4605                                  
  4606 0000295F A0[BC01]                 mov al, [RegType]
  4607 00002962 3C02                     cmp al, 2
  4608 00002964 0F840300                 je  @@process169
  4609 00002968 E800F9                   call reg16error
  4610                                  
  4611                                  ;-43         need(',');   
  4612                                  
  4613                                  @@process169:
  4614 0000296B 6A2C                     push 44
  4615 0000296D E874ED                   call need
  4616 00002970 83C402                   add  sp, 2
  4617                                  
  4618                                  ;-44         R1No = RegNo; 
  4619                                  
  4620 00002973 A0[BA01]                 mov al, [RegNo]
  4621 00002976 A2[BB01]                 mov byte [R1No], al
  4622                                  
  4623                                  ;-45         getOpR();
  4624                                  
  4625 00002979 E84B03                   call getOpR
  4626                                  
  4627                                  ;-46         if (Op2 != MEM) addrerror();//only m16 
  4628                                  
  4629 0000297C A0[B501]                 mov al, [Op2]
  4630 0000297F 3C04                     cmp al, 4
  4631 00002981 0F840300                 je  @@process170
  4632 00002985 E8FCF7                   call addrerror
  4633                                  
  4634                                  ;-47         
  4635                                  
  4636                                  
  4637                                  ;-48         genCode8(Code1);//les,lds,lea
  4638                                  
  4639                                  @@process170:
  4640 00002988 A0[B701]                 mov al, byte [Code1]
  4641 0000298B B400                     mov ah, 0
  4642 0000298D 50                       push ax
  4643 0000298E E84DFD                   call genCode8
  4644 00002991 83C402                   add  sp, 2
  4645                                  
  4646                                  ;-49         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  4647                                  
  4648 00002994 A0[B701]                 mov al, [Code1]
  4649 00002997 3C0F                     cmp al, 15
  4650 00002999 0F850C00                 jne @@process171
  4651 0000299D A0[B801]                 mov al, byte [Code2]
  4652 000029A0 B400                     mov ah, 0
  4653 000029A2 50                       push ax
  4654 000029A3 E838FD                   call genCode8
  4655 000029A6 83C402                   add  sp, 2
  4656                                  
  4657                                  ;-50         Op=Op2;//writeEA with 2. Op  
  4658                                  
  4659                                  @@process171:
  4660 000029A9 A0[B501]                 mov al, [Op2]
  4661 000029AC A2[B401]                 mov byte [Op], al
  4662                                  
  4663                                  ;-51         writeEA(R1No);           
  4664                                  
  4665 000029AF A0[BB01]                 mov al, byte [R1No]
  4666 000029B2 B400                     mov ah, 0
  4667 000029B4 50                       push ax
  4668 000029B5 E89DFD                   call writeEA
  4669 000029B8 83C402                   add  sp, 2
  4670                                  
  4671                                  ;-52         return;
  4672                                  
  4673 000029BB E95901                   jmp @@retn
  4674                                  
  4675                                  ;-53     }
  4676                                  
  4677                                  
  4678                                  ;-54 
  4679                                  
  4680                                  
  4681                                  ;-55     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  4682                                  
  4683                                  @@process168:
  4684 000029BE A0[B601]                 mov al, [CodeType]
  4685 000029C1 3C04                     cmp al, 4
  4686 000029C3 0F85E900                 jne @@process172
  4687                                  
  4688                                  ;-56         get2Ops();
  4689                                  
  4690 000029C7 E82602                   call get2Ops
  4691                                  
  4692                                  ;-57 //       prs("\nOp:"); printhex8a(Op);                
  4693                                  
  4694                                  
  4695                                  ;-58 //       prs(", R1No:"); printhex8a(R1No);           
  4696                                  
  4697                                  
  4698                                  ;-59         if (Op == IMM) immeerror();   
  4699                                  
  4700 000029CA A0[B401]                 mov al, [Op]
  4701 000029CD 3C01                     cmp al, 1
  4702 000029CF 0F850300                 jne @@process173
  4703 000029D3 E8D0F7                   call immeerror
  4704                                  
  4705                                  ;-60         if (Op == ADR) invaloperror();     
  4706                                  
  4707                                  @@process173:
  4708 000029D6 A0[B401]                 mov al, [Op]
  4709 000029D9 3C03                     cmp al, 3
  4710 000029DB 0F850300                 jne @@process174
  4711 000029DF E824F8                   call invaloperror
  4712                                  
  4713                                  ;-61         if (Op2 == IMM) {//second operand is imm     
  4714                                  
  4715                                  @@process174:
  4716 000029E2 A0[B501]                 mov al, [Op2]
  4717 000029E5 3C01                     cmp al, 1
  4718 000029E7 0F856500                 jne @@process175
  4719                                  
  4720                                  ;-62             setwflag();
  4721                                  
  4722 000029EB E8B705                   call setwflag
  4723                                  
  4724                                  ;-63             getSignExtended(imme);   
  4725                                  
  4726 000029EE FF36[C501]               push word [imme]
  4727 000029F2 E82C06                   call getSignExtended
  4728 000029F5 83C402                   add  sp, 2
  4729                                  
  4730                                  ;-64             if (Op == REG) {                
  4731                                  
  4732 000029F8 A0[B401]                 mov al, [Op]
  4733 000029FB 3C02                     cmp al, 2
  4734 000029FD 0F852900                 jne @@process176
  4735                                  
  4736                                  ;-65                 if (R1No == 0) {
  4737                                  
  4738 00002A01 A0[BB01]                 mov al, [R1No]
  4739 00002A04 3C00                     cmp al, 0
  4740 00002A06 0F852000                 jne @@process177
  4741                                  
  4742                                  ;-66                     Code1 = Code1 << 3;
  4743                                  
  4744 00002A0A A0[B701]                 mov al, [Code1]
  4745 00002A0D C0E003                   shl al, 3
  4746 00002A10 A2[B701]                 mov byte [Code1], al
  4747                                  
  4748                                  ;-67                     Code1 += 4;//code for acc,imm     
  4749                                  
  4750 00002A13 8006[B701]04             add  byte [Code1], 4
  4751                                  
  4752                                  ;-68                     genCodeW(Code1);
  4753                                  
  4754 00002A18 A0[B701]                 mov al, byte [Code1]
  4755 00002A1B B400                     mov ah, 0
  4756 00002A1D 50                       push ax
  4757 00002A1E E8A1FC                   call genCodeW
  4758 00002A21 83C402                   add  sp, 2
  4759                                  
  4760                                  ;-69                     genImmediate();
  4761                                  
  4762 00002A24 E853FE                   call genImmediate
  4763                                  
  4764                                  ;-70                     return;
  4765                                  
  4766 00002A27 E9ED00                   jmp @@retn
  4767                                  
  4768                                  ;-71                 }
  4769                                  
  4770                                  
  4771                                  ;-72             }
  4772                                  
  4773                                  @@process177:
  4774                                  
  4775                                  ;-73             //r/m, imm: 80 sign-extended,TTT,imm
  4776                                  
  4777                                  
  4778                                  ;-74             c = sflag + 0x80;       
  4779                                  
  4780                                  @@process176:
  4781 00002A2A A0[C001]                 mov al, [sflag]
  4782 00002A2D 0480                     add al, 128
  4783 00002A2F 8846FE                   mov byte [bp-2], al
  4784                                  
  4785                                  ;-75             genCodeW(c); 
  4786                                  
  4787 00002A32 8A46FE                   mov al, byte [bp-2]
  4788 00002A35 B400                     mov ah, 0
  4789 00002A37 50                       push ax
  4790 00002A38 E887FC                   call genCodeW
  4791 00002A3B 83C402                   add  sp, 2
  4792                                  
  4793                                  ;-76             writeEA(Code1);//todo not Op??  
  4794                                  
  4795 00002A3E A0[B701]                 mov al, byte [Code1]
  4796 00002A41 B400                     mov ah, 0
  4797 00002A43 50                       push ax
  4798 00002A44 E80EFD                   call writeEA
  4799 00002A47 83C402                   add  sp, 2
  4800                                  
  4801                                  ;-77             genImmediate();
  4802                                  
  4803 00002A4A E82DFE                   call genImmediate
  4804                                  
  4805                                  ;-78             return;     
  4806                                  
  4807 00002A4D E9C700                   jmp @@retn
  4808                                  
  4809                                  ;-79         }    
  4810                                  
  4811                                  
  4812                                  ;-80         c = Code1 << 3;
  4813                                  
  4814                                  @@process175:
  4815 00002A50 A0[B701]                 mov al, [Code1]
  4816 00002A53 C0E003                   shl al, 3
  4817 00002A56 8846FE                   mov byte [bp-2], al
  4818                                  
  4819                                  ;-81         if (Op == REG) {
  4820                                  
  4821 00002A59 A0[B401]                 mov al, [Op]
  4822 00002A5C 3C02                     cmp al, 2
  4823 00002A5E 0F852400                 jne @@process178
  4824                                  
  4825                                  ;-82             if (Op2 == MEM) {//reg, mem 
  4826                                  
  4827 00002A62 A0[B501]                 mov al, [Op2]
  4828 00002A65 3C04                     cmp al, 4
  4829 00002A67 0F851B00                 jne @@process179
  4830                                  
  4831                                  ;-83                 genCodeDW(c);
  4832                                  
  4833 00002A6B 8A46FE                   mov al, byte [bp-2]
  4834 00002A6E B400                     mov ah, 0
  4835 00002A70 50                       push ax
  4836 00002A71 E838FC                   call genCodeDW
  4837 00002A74 83C402                   add  sp, 2
  4838                                  
  4839                                  ;-84                 writeEA(R1No);
  4840                                  
  4841 00002A77 A0[BB01]                 mov al, byte [R1No]
  4842 00002A7A B400                     mov ah, 0
  4843 00002A7C 50                       push ax
  4844 00002A7D E8D5FC                   call writeEA
  4845 00002A80 83C402                   add  sp, 2
  4846                                  
  4847                                  ;-85                 return;    
  4848                                  
  4849 00002A83 E99100                   jmp @@retn
  4850                                  
  4851                                  ;-86             }
  4852                                  
  4853                                  
  4854                                  ;-87         }
  4855                                  
  4856                                  @@process179:
  4857                                  
  4858                                  ;-88         if (Op2 == REG) {//mem,reg    reg,reg
  4859                                  
  4860                                  @@process178:
  4861 00002A86 A0[B501]                 mov al, [Op2]
  4862 00002A89 3C02                     cmp al, 2
  4863 00002A8B 0F851B00                 jne @@process180
  4864                                  
  4865                                  ;-89             genCodeW(c);
  4866                                  
  4867 00002A8F 8A46FE                   mov al, byte [bp-2]
  4868 00002A92 B400                     mov ah, 0
  4869 00002A94 50                       push ax
  4870 00002A95 E82AFC                   call genCodeW
  4871 00002A98 83C402                   add  sp, 2
  4872                                  
  4873                                  ;-90             writeEA(RegNo);//2. Op in reg-field
  4874                                  
  4875 00002A9B A0[BA01]                 mov al, byte [RegNo]
  4876 00002A9E B400                     mov ah, 0
  4877 00002AA0 50                       push ax
  4878 00002AA1 E8B1FC                   call writeEA
  4879 00002AA4 83C402                   add  sp, 2
  4880                                  
  4881                                  ;-91             return;            
  4882                                  
  4883 00002AA7 E96D00                   jmp @@retn
  4884                                  
  4885                                  ;-92         }          
  4886                                  
  4887                                  
  4888                                  ;-93         
  4889                                  
  4890                                  
  4891                                  ;-94         syntaxerror();        
  4892                                  
  4893                                  @@process180:
  4894 00002AAA E80DF8                   call syntaxerror
  4895                                  
  4896                                  ;-95         return;
  4897                                  
  4898 00002AAD E96700                   jmp @@retn
  4899                                  
  4900                                  ;-96     }
  4901                                  
  4902                                  
  4903                                  ;-97    
  4904                                  
  4905                                  
  4906                                  ;-98     if (CodeType ==  8) {//ret,retf
  4907                                  
  4908                                  @@process172:
  4909 00002AB0 A0[B601]                 mov al, [CodeType]
  4910 00002AB3 3C08                     cmp al, 8
  4911 00002AB5 0F853100                 jne @@process181
  4912                                  
  4913                                  ;-99         if (TokeType == DIGIT) {
  4914                                  
  4915 00002AB9 A0[B301]                 mov al, [TokeType]
  4916 00002ABC 3C01                     cmp al, 1
  4917 00002ABE 0F851900                 jne @@process182
  4918                                  
  4919                                  ;-100             genCode8(Code2);
  4920                                  
  4921 00002AC2 A0[B801]                 mov al, byte [Code2]
  4922 00002AC5 B400                     mov ah, 0
  4923 00002AC7 50                       push ax
  4924 00002AC8 E813FC                   call genCode8
  4925 00002ACB 83C402                   add  sp, 2
  4926                                  
  4927                                  ;-101             genCode16(SymbolInt);
  4928                                  
  4929 00002ACE FF36[5500]               push word [SymbolInt]
  4930 00002AD2 E85FFC                   call genCode16
  4931 00002AD5 83C402                   add  sp, 2
  4932                                  
  4933                                  ;-102             return;
  4934                                  
  4935 00002AD8 E93C00                   jmp @@retn
  4936                                  
  4937                                  ;-103         }
  4938                                  
  4939                                  
  4940                                  ;-104         genCode8(Code1); 
  4941                                  
  4942                                  @@process182:
  4943 00002ADB A0[B701]                 mov al, byte [Code1]
  4944 00002ADE B400                     mov ah, 0
  4945 00002AE0 50                       push ax
  4946 00002AE1 E8FAFB                   call genCode8
  4947 00002AE4 83C402                   add  sp, 2
  4948                                  
  4949                                  ;-105         return;
  4950                                  
  4951 00002AE7 E92D00                   jmp @@retn
  4952                                  
  4953                                  ;-106     }
  4954                                  
  4955                                  
  4956                                  ;-107 
  4957                                  
  4958                                  
  4959                                  ;-108     if (CodeType==101) {// ORG nn
  4960                                  
  4961                                  @@process181:
  4962 00002AEA A0[B601]                 mov al, [CodeType]
  4963 00002AED 3C65                     cmp al, 101
  4964 00002AEF 0F851B00                 jne @@process183
  4965                                  
  4966                                  ;-109         if (TokeType != DIGIT) error1("only digit allowed");
  4967                                  
  4968 00002AF3 A0[B301]                 mov al, [TokeType]
  4969 00002AF6 3C01                     cmp al, 1
  4970 00002AF8 0F840900                 je  @@process184
  4971 00002AFC 68[192B]                 push process_0
  4972 00002AFF E808F6                   call error1
  4973 00002B02 83C402                   add  sp, 2
  4974                                  
  4975                                  ;-110         PC=SymbolInt;
  4976                                  
  4977                                  @@process184:
  4978 00002B05 A1[5500]                 mov ax, [SymbolInt]
  4979 00002B08 A3[AE01]                 mov word [PC], ax
  4980                                  
  4981                                  ;-111         return;
  4982                                  
  4983 00002B0B E90900                   jmp @@retn
  4984                                  
  4985                                  ;-112     }
  4986                                  
  4987                                  
  4988                                  ;-113     error1("unknown CodeType");
  4989                                  
  4990                                  @@process183:
  4991 00002B0E 68[2C2B]                 push process_1
  4992 00002B11 E8F6F5                   call error1
  4993 00002B14 83C402                   add  sp, 2
  4994                                  
  4995                                  ;-114 }    
  4996                                  
  4997                                  
  4998                                  ;-115 
  4999                                  
  5000                                  
  5001                                  ;-116 int checkOpL() {
  5002                                  
  5003 00002B17 C9                      @@retn: LEAVE
  5004 00002B18 C3                       ret
  5005                                  ; ENDP
  5006 00002B19 6F6E6C792064696769-     process_0 db "only digit allowed",0
  5007 00002B22 7420616C6C6F776564-
  5008 00002B2B 00                 
  5009 00002B2C 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  5010 00002B35 6F64655479706500   
  5011                                  
  5012                                  checkOpL:  ; *** PROC ***
  5013                                  
  5014                                  ;-117     if (Op == ADR) implerror();
  5015                                  
  5016 00002B3D A0[B401]                 mov al, [Op]
  5017 00002B40 3C03                     cmp al, 3
  5018 00002B42 0F850300                 jne @@checkOpL185
  5019 00002B46 E882F6                   call implerror
  5020                                  
  5021                                  ;-118     if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  5022                                  
  5023                                  @@checkOpL185:
  5024 00002B49 A0[BC01]                 mov al, [RegType]
  5025 00002B4C 3C04                     cmp al, 4
  5026 00002B4E 0F850600                 jne @@checkOpL186
  5027 00002B52 E83EF7                   call segregerror
  5028 00002B55 E95300                   jmp @@retn
  5029                                  
  5030                                  ;-119     setwflag();
  5031                                  
  5032                                  @@checkOpL186:
  5033 00002B58 E84A04                   call setwflag
  5034                                  
  5035                                  ;-120     if (OpSize == 0) error1("no op size declared");
  5036                                  
  5037 00002B5B A0[BE01]                 mov al, [OpSize]
  5038 00002B5E 3C00                     cmp al, 0
  5039 00002B60 0F850900                 jne @@checkOpL187
  5040 00002B64 68[AC2B]                 push checkOpL_0
  5041 00002B67 E8A0F5                   call error1
  5042 00002B6A 83C402                   add  sp, 2
  5043                                  
  5044                                  ;-121     if (OpSize == RegType) return;
  5045                                  
  5046                                  @@checkOpL187:
  5047 00002B6D A0[BE01]                 mov al, [OpSize]
  5048 00002B70 3A06[BC01]               cmp al, [RegType]
  5049 00002B74 0F850300                 jne @@checkOpL188
  5050 00002B78 E93000                   jmp @@retn
  5051                                  
  5052                                  ;-122     if (OpSize){
  5053                                  
  5054                                  @@checkOpL188:
  5055 00002B7B A0[BE01]                 mov al, [OpSize]
  5056 00002B7E 08C0                     or  al, al
  5057 00002B80 0F841500                 je @@checkOpL189
  5058                                  
  5059                                  ;-123         if (Op == MEM) return;
  5060                                  
  5061 00002B84 A0[B401]                 mov al, [Op]
  5062 00002B87 3C04                     cmp al, 4
  5063 00002B89 0F850300                 jne @@checkOpL190
  5064 00002B8D E91B00                   jmp @@retn
  5065                                  
  5066                                  ;-124         error1("Conflict OpSize and RegSize"); 
  5067                                  
  5068                                  @@checkOpL190:
  5069 00002B90 68[C02B]                 push checkOpL_1
  5070 00002B93 E874F5                   call error1
  5071 00002B96 83C402                   add  sp, 2
  5072                                  
  5073                                  ;-125         }
  5074                                  
  5075                                  
  5076                                  ;-126     if (RegType==0) error1("no register defined");
  5077                                  
  5078                                  @@checkOpL189:
  5079 00002B99 A0[BC01]                 mov al, [RegType]
  5080 00002B9C 3C00                     cmp al, 0
  5081 00002B9E 0F850900                 jne @@checkOpL191
  5082 00002BA2 68[DC2B]                 push checkOpL_2
  5083 00002BA5 E862F5                   call error1
  5084 00002BA8 83C402                   add  sp, 2
  5085                                  
  5086                                  ;-127 }
  5087                                  
  5088                                  @@checkOpL191:
  5089                                  
  5090                                  ;-128 /*    Op, Op2 =0, 1=IMM, 2=REG, 3=ADR, 4=MEM 
  5091                                  
  5092                                  
  5093                                  ;-129 IMM      imme           = 0, SymbolInt
  5094                                  
  5095                                  
  5096                                  ;-130 REG      R1No,RegNo     = 0 - 7
  5097                                  
  5098                                  
  5099                                  ;-131 REG      R1Type,RegType = 0, BYTE, WORD, DWORD, SEGREG 
  5100                                  
  5101                                  
  5102                                  ;-132 MEM,ADR  disp           = 0, LabelAddr[LabelIx]
  5103                                  
  5104                                  
  5105                                  ;-133 MEM      regindexbase   = 0 - 7
  5106                                  
  5107                                  
  5108                                  ;-134          OpSize         = 0, BYTE, WORD, DWORD
  5109                                  
  5110                                  
  5111                                  ;-135          wflag
  5112                                  
  5113                                  
  5114                                  ;-136 */ 
  5115                                  
  5116                                  
  5117                                  ;-137          
  5118                                  
  5119                                  
  5120                                  ;-138 int get2Ops() {
  5121                                  
  5122                                  @@retn:
  5123 00002BAB C3                       ret
  5124                                  ; ENDP
  5125 00002BAC 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  5126 00002BB5 65206465636C617265-
  5127 00002BBE 6400               
  5128 00002BC0 436F6E666C69637420-     checkOpL_1 db "Conflict OpSize and RegSize",0
  5129 00002BC9 4F7053697A6520616E-
  5130 00002BD2 642052656753697A65-
  5131 00002BDB 00                 
  5132 00002BDC 6E6F20726567697374-     checkOpL_2 db "no register defined",0
  5133 00002BE5 657220646566696E65-
  5134 00002BEE 6400               
  5135                                  
  5136                                  get2Ops:  ; *** PROC ***
  5137                                  
  5138                                  ;-139     getOpL();
  5139                                  
  5140 00002BF0 E81800                   call getOpL
  5141                                  
  5142                                  ;-140     R1No=RegNo;   
  5143                                  
  5144 00002BF3 A0[BA01]                 mov al, [RegNo]
  5145 00002BF6 A2[BB01]                 mov byte [R1No], al
  5146                                  
  5147                                  ;-141     R1Type = RegType;
  5148                                  
  5149 00002BF9 A0[BC01]                 mov al, [RegType]
  5150 00002BFC A2[BD01]                 mov byte [R1Type], al
  5151                                  
  5152                                  ;-142     need(',');    
  5153                                  
  5154 00002BFF 6A2C                     push 44
  5155 00002C01 E8E0EA                   call need
  5156 00002C04 83C402                   add  sp, 2
  5157                                  
  5158                                  ;-143     getOpR();         
  5159                                  
  5160 00002C07 E8BD00                   call getOpR
  5161                                  
  5162                                  ;-144 }         
  5163                                  
  5164                                  
  5165                                  ;-145 int getOpL() {
  5166                                  
  5167 00002C0A C3                       ret
  5168                                  ; ENDP
  5169                                  
  5170                                  getOpL:  ; *** PROC ***
  5171                                  
  5172                                  ;-146 //set: op1=0,IMM,REG,ADR,MEM
  5173                                  
  5174                                  
  5175                                  ;-147     disp=0; imme=0; isDirect=1; RegType=0; Op2=0;//for WriteEA  
  5176                                  
  5177 00002C0B 66B800000000             mov eax, 0
  5178 00002C11 A3[C301]                 mov word [disp], ax
  5179 00002C14 66B800000000             mov eax, 0
  5180 00002C1A A3[C501]                 mov word [imme], ax
  5181 00002C1D 66B801000000             mov eax, 1
  5182 00002C23 A2[C201]                 mov byte [isDirect], al
  5183 00002C26 66B800000000             mov eax, 0
  5184 00002C2C A2[BC01]                 mov byte [RegType], al
  5185 00002C2F 66B800000000             mov eax, 0
  5186 00002C35 A2[B501]                 mov byte [Op2], al
  5187                                  
  5188                                  ;-148 
  5189                                  
  5190                                  
  5191                                  ;-149     Op=getOp1();
  5192                                  
  5193 00002C38 E81B01                   call getOp1
  5194 00002C3B A2[B401]                 mov byte [Op], al
  5195                                  
  5196                                  ;-150     if (isToken('[')) {Op = MEM; getMEM();    return;}
  5197                                  
  5198 00002C3E 6A5B                     push 91
  5199 00002C40 E873EA                   call isToken
  5200 00002C43 83C402                   add  sp, 2
  5201 00002C46 08C0                     or  al, al
  5202 00002C48 0F840F00                 je @@getOpL192
  5203 00002C4C 66B804000000             mov eax, 4
  5204 00002C52 A2[B401]                 mov byte [Op], al
  5205 00002C55 E88401                   call getMEM
  5206 00002C58 E94F00                   jmp @@retn
  5207                                  
  5208                                  ;-151     if (Op == 0)     {invaloperror();         return;}
  5209                                  
  5210                                  @@getOpL192:
  5211 00002C5B A0[B401]                 mov al, [Op]
  5212 00002C5E 3C00                     cmp al, 0
  5213 00002C60 0F850600                 jne @@getOpL193
  5214 00002C64 E89FF5                   call invaloperror
  5215 00002C67 E94000                   jmp @@retn
  5216                                  
  5217                                  ;-152     if (Op == IMM)   {imme=SymbolInt;         return;}
  5218                                  
  5219                                  @@getOpL193:
  5220 00002C6A A0[B401]                 mov al, [Op]
  5221 00002C6D 3C01                     cmp al, 1
  5222 00002C6F 0F850900                 jne @@getOpL194
  5223 00002C73 A1[5500]                 mov ax, [SymbolInt]
  5224 00002C76 A3[C501]                 mov word [imme], ax
  5225 00002C79 E92E00                   jmp @@retn
  5226                                  
  5227                                  ;-153     if (Op == REG)                            return;
  5228                                  
  5229                                  @@getOpL194:
  5230 00002C7C A0[B401]                 mov al, [Op]
  5231 00002C7F 3C02                     cmp al, 2
  5232 00002C81 0F850300                 jne @@getOpL195
  5233 00002C85 E92200                   jmp @@retn
  5234                                  
  5235                                  ;-154     if (Op == ADR)   {disp=LabelAddr[LabelIx];return;}
  5236                                  
  5237                                  @@getOpL195:
  5238 00002C88 A0[B401]                 mov al, [Op]
  5239 00002C8B 3C03                     cmp al, 3
  5240 00002C8D 0F851000                 jne @@getOpL196
  5241 00002C91 8B1E[8506]               mov bx, [LabelIx]
  5242 00002C95 D1E3                     shl bx, 1
  5243 00002C97 8B87[BB05]               mov ax, [LabelAddr + bx]
  5244 00002C9B A3[C301]                 mov word [disp], ax
  5245 00002C9E E90900                   jmp @@retn
  5246                                  
  5247                                  ;-155     error1("Name of operand #1 expected");
  5248                                  
  5249                                  @@getOpL196:
  5250 00002CA1 68[AB2C]                 push getOpL_0
  5251 00002CA4 E863F4                   call error1
  5252 00002CA7 83C402                   add  sp, 2
  5253                                  
  5254                                  ;-156 }  
  5255                                  
  5256                                  
  5257                                  ;-157 
  5258                                  
  5259                                  
  5260                                  ;-158 int getOpR() {
  5261                                  
  5262                                  @@retn:
  5263 00002CAA C3                       ret
  5264                                  ; ENDP
  5265 00002CAB 4E616D65206F66206F-     getOpL_0 db "Name of operand #1 expected",0
  5266 00002CB4 706572616E64202331-
  5267 00002CBD 206578706563746564-
  5268 00002CC6 00                 
  5269                                  
  5270                                  getOpR:  ; *** PROC ***
  5271                                  
  5272                                  ;-159     Op2=getOp1();
  5273                                  
  5274 00002CC7 E88C00                   call getOp1
  5275 00002CCA A2[B501]                 mov byte [Op2], al
  5276                                  
  5277                                  ;-160     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  5278                                  
  5279 00002CCD 6A5B                     push 91
  5280 00002CCF E8E4E9                   call isToken
  5281 00002CD2 83C402                   add  sp, 2
  5282 00002CD5 08C0                     or  al, al
  5283 00002CD7 0F840F00                 je @@getOpR197
  5284 00002CDB 66B804000000             mov eax, 4
  5285 00002CE1 A2[B501]                 mov byte [Op2], al
  5286 00002CE4 E8F500                   call getMEM
  5287 00002CE7 E94F00                   jmp @@retn
  5288                                  
  5289                                  ;-161     if (Op2 == 0)     {invaloperror();         return;}
  5290                                  
  5291                                  @@getOpR197:
  5292 00002CEA A0[B501]                 mov al, [Op2]
  5293 00002CED 3C00                     cmp al, 0
  5294 00002CEF 0F850600                 jne @@getOpR198
  5295 00002CF3 E810F5                   call invaloperror
  5296 00002CF6 E94000                   jmp @@retn
  5297                                  
  5298                                  ;-162     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  5299                                  
  5300                                  @@getOpR198:
  5301 00002CF9 A0[B501]                 mov al, [Op2]
  5302 00002CFC 3C01                     cmp al, 1
  5303 00002CFE 0F850900                 jne @@getOpR199
  5304 00002D02 A1[5500]                 mov ax, [SymbolInt]
  5305 00002D05 A3[C501]                 mov word [imme], ax
  5306 00002D08 E92E00                   jmp @@retn
  5307                                  
  5308                                  ;-163     if (Op2 == REG)                            return;
  5309                                  
  5310                                  @@getOpR199:
  5311 00002D0B A0[B501]                 mov al, [Op2]
  5312 00002D0E 3C02                     cmp al, 2
  5313 00002D10 0F850300                 jne @@getOpR200
  5314 00002D14 E92200                   jmp @@retn
  5315                                  
  5316                                  ;-164     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  5317                                  
  5318                                  @@getOpR200:
  5319 00002D17 A0[B501]                 mov al, [Op2]
  5320 00002D1A 3C03                     cmp al, 3
  5321 00002D1C 0F851000                 jne @@getOpR201
  5322 00002D20 8B1E[8506]               mov bx, [LabelIx]
  5323 00002D24 D1E3                     shl bx, 1
  5324 00002D26 8B87[BB05]               mov ax, [LabelAddr + bx]
  5325 00002D2A A3[C301]                 mov word [disp], ax
  5326 00002D2D E90900                   jmp @@retn
  5327                                  
  5328                                  ;-165     error1("Name of operand #2 expected");
  5329                                  
  5330                                  @@getOpR201:
  5331 00002D30 68[3A2D]                 push getOpR_0
  5332 00002D33 E8D4F3                   call error1
  5333 00002D36 83C402                   add  sp, 2
  5334                                  
  5335                                  ;-166 }
  5336                                  
  5337                                  
  5338                                  ;-167 
  5339                                  
  5340                                  
  5341                                  ;-168 int getOp1() {//scan for a single operand
  5342                                  
  5343                                  @@retn:
  5344 00002D39 C3                       ret
  5345                                  ; ENDP
  5346 00002D3A 4E616D65206F66206F-     getOpR_0 db "Name of operand #2 expected",0
  5347 00002D43 706572616E64202332-
  5348 00002D4C 206578706563746564-
  5349 00002D55 00                 
  5350                                  
  5351                                  getOp1:  ; *** PROC ***
  5352                                  
  5353                                  ;-169 //return:0, IMM, REG, ADR (not MEM)
  5354                                  
  5355                                  
  5356                                  ;-170 //set   :RegType, RegNo by testReg
  5357                                  
  5358                                  
  5359                                  ;-171 //set   :LabelIx by searchLabel
  5360                                  
  5361                                  
  5362                                  ;-172     if (TokeType == 0)      return 0;
  5363                                  
  5364 00002D56 A0[B301]                 mov al, [TokeType]
  5365 00002D59 3C00                     cmp al, 0
  5366 00002D5B 0F850900                 jne @@getOp1202
  5367 00002D5F 66B800000000             mov eax, 0
  5368 00002D65 E96000                   jmp @@retn
  5369                                  
  5370                                  ;-173     if (TokeType == DIGIT)  return IMM;
  5371                                  
  5372                                  @@getOp1202:
  5373 00002D68 A0[B301]                 mov al, [TokeType]
  5374 00002D6B 3C01                     cmp al, 1
  5375 00002D6D 0F850900                 jne @@getOp1203
  5376 00002D71 66B801000000             mov eax, 1
  5377 00002D77 E94E00                   jmp @@retn
  5378                                  
  5379                                  ;-174     if (TokeType == ALNUME) {
  5380                                  
  5381                                  @@getOp1203:
  5382 00002D7A A0[B301]                 mov al, [TokeType]
  5383 00002D7D 3C03                     cmp al, 3
  5384 00002D7F 0F853C00                 jne @@getOp1204
  5385                                  
  5386                                  ;-175         RegNo=testReg();
  5387                                  
  5388 00002D83 E8DDEC                   call testReg
  5389 00002D86 A2[BA01]                 mov byte [RegNo], al
  5390                                  
  5391                                  ;-176         if (RegType)        return REG;
  5392                                  
  5393 00002D89 A0[BC01]                 mov al, [RegType]
  5394 00002D8C 08C0                     or  al, al
  5395 00002D8E 0F840900                 je @@getOp1205
  5396 00002D92 66B802000000             mov eax, 2
  5397 00002D98 E92D00                   jmp @@retn
  5398                                  
  5399                                  ;-177         LabelIx=searchLabel();
  5400                                  
  5401                                  @@getOp1205:
  5402 00002D9B E883E6                   call searchLabel
  5403 00002D9E A3[8506]                 mov word [LabelIx], ax
  5404                                  
  5405                                  ;-178         if (LabelIx)        return ADR;
  5406                                  
  5407 00002DA1 A1[8506]                 mov ax, [LabelIx]
  5408 00002DA4 08C0                     or  al, al
  5409 00002DA6 0F840C00                 je @@getOp1206
  5410 00002DAA 66B803000000             mov eax, 3
  5411 00002DB0 E91500                   jmp @@retn
  5412                                  
  5413                                  ;-179         else error1("variable not found"); 
  5414                                  
  5415 00002DB3 E90900                   jmp @@getOp1207
  5416                                  @@getOp1206:
  5417 00002DB6 68[C92D]                 push getOp1_0
  5418 00002DB9 E84EF3                   call error1
  5419 00002DBC 83C402                   add  sp, 2
  5420                                  
  5421                                  ;-180     }
  5422                                  
  5423                                  @@getOp1207:
  5424                                  
  5425                                  ;-181     return 0;
  5426                                  
  5427                                  @@getOp1204:
  5428 00002DBF 66B800000000             mov eax, 0
  5429 00002DC5 E90000                   jmp @@retn
  5430                                  
  5431                                  ;-182 }
  5432                                  
  5433                                  
  5434                                  ;-183 
  5435                                  
  5436                                  
  5437                                  ;-184 int getMEM() {// e.g. [array+bp+si-4]
  5438                                  
  5439                                  @@retn:
  5440 00002DC8 C3                       ret
  5441                                  ; ENDP
  5442 00002DC9 7661726961626C6520-     getOp1_0 db "variable not found",0
  5443 00002DD2 6E6F7420666F756E64-
  5444 00002DDB 00                 
  5445                                  
  5446                                  getMEM:  ; *** PROC ***
  5447                                  
  5448                                  ;-185 //set: disp, regindexbase, RegType
  5449                                  
  5450                                  
  5451                                  ;-186     char c;
  5452                                  
  5453                                  
  5454                                  ;-187     disp=0; regindexbase=0;
  5455                                  
  5456                                  ;Function : getMEM, Number of local variables: 1
  5457                                  ;   # type sign width line used address name   list of local variables
  5458                                  ;  200 var sign byte   186 NULL bp-2    c;
  5459 00002DDC C8020000                 ENTER  2,0
  5460 00002DE0 66B800000000             mov eax, 0
  5461 00002DE6 A3[C301]                 mov word [disp], ax
  5462 00002DE9 66B800000000             mov eax, 0
  5463 00002DEF A2[C101]                 mov byte [regindexbase], al
  5464                                  
  5465                                  ;-188     do {
  5466                                  
  5467                                  @@getMEM208:
  5468                                  
  5469                                  ;-189         getTokeType();
  5470                                  
  5471 00002DF2 E8EBE4                   call getTokeType
  5472                                  
  5473                                  ;-190         c=getOp1();
  5474                                  
  5475 00002DF5 E85EFF                   call getOp1
  5476 00002DF8 8846FE                   mov byte [bp-2], al
  5477                                  
  5478                                  ;-191         if (c ==   0) syntaxerror();
  5479                                  
  5480 00002DFB 8A46FE                   mov al, [bp-2]
  5481 00002DFE 3C00                     cmp al, 0
  5482 00002E00 0F850300                 jne @@getMEM209
  5483 00002E04 E8B3F4                   call syntaxerror
  5484                                  
  5485                                  ;-192         if (c == REG) {isDirect=0;
  5486                                  
  5487                                  @@getMEM209:
  5488 00002E07 8A46FE                   mov al, [bp-2]
  5489 00002E0A 3C02                     cmp al, 2
  5490 00002E0C 0F851E00                 jne @@getMEM210
  5491 00002E10 66B800000000             mov eax, 0
  5492 00002E16 A2[C201]                 mov byte [isDirect], al
  5493                                  
  5494                                  ;-193             if (regindexbase) regindexbase=getIndReg2();
  5495                                  
  5496 00002E19 A0[C101]                 mov al, [regindexbase]
  5497 00002E1C 08C0                     or  al, al
  5498 00002E1E 0F840900                 je @@getMEM211
  5499 00002E22 E8F300                   call getIndReg2
  5500 00002E25 A2[C101]                 mov byte [regindexbase], al
  5501                                  
  5502                                  ;-194             else getIndReg1();
  5503                                  
  5504 00002E28 E90300                   jmp @@getMEM212
  5505                                  @@getMEM211:
  5506 00002E2B E88900                   call getIndReg1
  5507                                  
  5508                                  ;-195         }
  5509                                  
  5510                                  @@getMEM212:
  5511                                  
  5512                                  ;-196         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  5513                                  
  5514                                  @@getMEM210:
  5515 00002E2E 8A46FE                   mov al, [bp-2]
  5516 00002E31 3C03                     cmp al, 3
  5517 00002E33 0F851000                 jne @@getMEM213
  5518 00002E37 A1[C301]                 mov ax, [disp]
  5519 00002E3A 8B1E[8506]               mov bx, [LabelIx]
  5520 00002E3E D1E3                     shl bx, 1
  5521 00002E40 0387[BB05]               add ax, [LabelAddr + bx]
  5522 00002E44 A3[C301]                 mov word [disp], ax
  5523                                  
  5524                                  ;-197         if (c == IMM) disp=disp+SymbolInt;
  5525                                  
  5526                                  @@getMEM213:
  5527 00002E47 8A46FE                   mov al, [bp-2]
  5528 00002E4A 3C01                     cmp al, 1
  5529 00002E4C 0F850A00                 jne @@getMEM214
  5530 00002E50 A1[C301]                 mov ax, [disp]
  5531 00002E53 0306[5500]               add ax, [SymbolInt]
  5532 00002E57 A3[C301]                 mov word [disp], ax
  5533                                  
  5534                                  ;-198         if (isToken('-')) {
  5535                                  
  5536                                  @@getMEM214:
  5537 00002E5A 6A2D                     push 45
  5538 00002E5C E857E8                   call isToken
  5539 00002E5F 83C402                   add  sp, 2
  5540 00002E62 08C0                     or  al, al
  5541 00002E64 0F841900                 je @@getMEM215
  5542                                  
  5543                                  ;-199             getTokeType();
  5544                                  
  5545 00002E68 E875E4                   call getTokeType
  5546                                  
  5547                                  ;-200             if (TokeType != DIGIT) numbererror();
  5548                                  
  5549 00002E6B A0[B301]                 mov al, [TokeType]
  5550 00002E6E 3C01                     cmp al, 1
  5551 00002E70 0F840300                 je  @@getMEM216
  5552 00002E74 E8B0F3                   call numbererror
  5553                                  
  5554                                  ;-201             disp = disp - SymbolInt;
  5555                                  
  5556                                  @@getMEM216:
  5557 00002E77 A1[C301]                 mov ax, [disp]
  5558 00002E7A 2B06[5500]               sub ax, [SymbolInt]
  5559 00002E7E A3[C301]                 mov word [disp], ax
  5560                                  
  5561                                  ;-202         }
  5562                                  
  5563                                  
  5564                                  ;-203     } while (isToken('+'));
  5565                                  
  5566                                  @@getMEM215:
  5567 00002E81 6A2B                     push 43
  5568 00002E83 E830E8                   call isToken
  5569 00002E86 83C402                   add  sp, 2
  5570 00002E89 08C0                     or  al, al
  5571 00002E8B 0F840300                 je @@getMEM217
  5572 00002E8F E960FF                   jmp @@getMEM208
  5573                                  @@getMEM217:
  5574                                  
  5575                                  ;-204     if (isToken(']') == 0) errorexit("] expected");
  5576                                  
  5577 00002E92 6A5D                     push 93
  5578 00002E94 E81FE8                   call isToken
  5579 00002E97 83C402                   add  sp, 2
  5580 00002E9A 83F800                   cmp ax, 0
  5581 00002E9D 0F850900                 jne @@getMEM218
  5582 00002EA1 68[AC2E]                 push getMEM_0
  5583 00002EA4 E824F4                   call errorexit
  5584 00002EA7 83C402                   add  sp, 2
  5585                                  
  5586                                  ;-205 }
  5587                                  
  5588                                  @@getMEM218:
  5589                                  
  5590                                  ;-206 int getIndReg1() {
  5591 00002EAA C9                       LEAVE
  5592 00002EAB C3                       ret
  5593                                  ; ENDP
  5594 00002EAC 5D2065787065637465-     getMEM_0 db "] expected",0
  5595 00002EB5 6400               
  5596                                  
  5597                                  getIndReg1:  ; *** PROC ***
  5598                                  
  5599                                  ;-207     if (RegType !=WORD) indexerror();
  5600                                  
  5601 00002EB7 A0[BC01]                 mov al, [RegType]
  5602 00002EBA 3C02                     cmp al, 2
  5603 00002EBC 0F840300                 je  @@getIndReg1219
  5604 00002EC0 E822F3                   call indexerror
  5605                                  
  5606                                  ;-208     if (RegNo==3) regindexbase=7;//BX
  5607                                  
  5608                                  @@getIndReg1219:
  5609 00002EC3 A0[BA01]                 mov al, [RegNo]
  5610 00002EC6 3C03                     cmp al, 3
  5611 00002EC8 0F850900                 jne @@getIndReg1220
  5612 00002ECC 66B807000000             mov eax, 7
  5613 00002ED2 A2[C101]                 mov byte [regindexbase], al
  5614                                  
  5615                                  ;-209     if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5616                                  
  5617                                  @@getIndReg1220:
  5618 00002ED5 A0[BA01]                 mov al, [RegNo]
  5619 00002ED8 3C05                     cmp al, 5
  5620 00002EDA 0F850900                 jne @@getIndReg1221
  5621 00002EDE 66B806000000             mov eax, 6
  5622 00002EE4 A2[C101]                 mov byte [regindexbase], al
  5623                                  
  5624                                  ;-210     if (RegNo==7) regindexbase=5;//DI
  5625                                  
  5626                                  @@getIndReg1221:
  5627 00002EE7 A0[BA01]                 mov al, [RegNo]
  5628 00002EEA 3C07                     cmp al, 7
  5629 00002EEC 0F850900                 jne @@getIndReg1222
  5630 00002EF0 66B805000000             mov eax, 5
  5631 00002EF6 A2[C101]                 mov byte [regindexbase], al
  5632                                  
  5633                                  ;-211     if (RegNo==6) regindexbase=4;//SI
  5634                                  
  5635                                  @@getIndReg1222:
  5636 00002EF9 A0[BA01]                 mov al, [RegNo]
  5637 00002EFC 3C06                     cmp al, 6
  5638 00002EFE 0F850900                 jne @@getIndReg1223
  5639 00002F02 66B804000000             mov eax, 4
  5640 00002F08 A2[C101]                 mov byte [regindexbase], al
  5641                                  
  5642                                  ;-212     if (regindexbase==0) indexerror();
  5643                                  
  5644                                  @@getIndReg1223:
  5645 00002F0B A0[C101]                 mov al, [regindexbase]
  5646 00002F0E 3C00                     cmp al, 0
  5647 00002F10 0F850300                 jne @@getIndReg1224
  5648 00002F14 E8CEF2                   call indexerror
  5649                                  
  5650                                  ;-213 }
  5651                                  
  5652                                  @@getIndReg1224:
  5653                                  
  5654                                  ;-214 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5655                                  
  5656 00002F17 C3                       ret
  5657                                  ; ENDP
  5658                                  
  5659                                  getIndReg2:  ; *** PROC ***
  5660                                  ;Function : getIndReg2, Number of local variables: 1
  5661                                  ;   # type sign width line used address name   list of local variables
  5662                                  ;  200 var sign byte   214 NULL bp-2    m;
  5663 00002F18 C8020000                 ENTER  2,0
  5664 00002F1C 66B804000000             mov eax, 4
  5665 00002F22 8846FE                   mov byte [bp-2], al
  5666                                  
  5667                                  ;-215     if (RegType !=WORD) indexerror();
  5668                                  
  5669 00002F25 A0[BC01]                 mov al, [RegType]
  5670 00002F28 3C02                     cmp al, 2
  5671 00002F2A 0F840300                 je  @@getIndReg2225
  5672 00002F2E E8B4F2                   call indexerror
  5673                                  
  5674                                  ;-216     if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5675                                  
  5676                                  @@getIndReg2225:
  5677 00002F31 A0[BA01]                 mov al, [RegNo]
  5678 00002F34 3C07                     cmp al, 7
  5679 00002F36 0F852700                 jne @@getIndReg2226
  5680 00002F3A A0[C101]                 mov al, [regindexbase]
  5681 00002F3D 3C06                     cmp al, 6
  5682 00002F3F 0F850C00                 jne @@getIndReg2227
  5683 00002F43 66B803000000             mov eax, 3
  5684 00002F49 8846FE                   mov byte [bp-2], al
  5685                                  
  5686                                  ;-217              else if (regindexbase==7) m=1;//BX+DI
  5687                                  
  5688 00002F4C E91200                   jmp @@getIndReg2228
  5689                                  @@getIndReg2227:
  5690 00002F4F A0[C101]                 mov al, [regindexbase]
  5691 00002F52 3C07                     cmp al, 7
  5692 00002F54 0F850900                 jne @@getIndReg2229
  5693 00002F58 66B801000000             mov eax, 1
  5694 00002F5E 8846FE                   mov byte [bp-2], al
  5695                                  
  5696                                  ;-218     if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5697                                  
  5698                                  @@getIndReg2229:
  5699                                  @@getIndReg2228:
  5700                                  @@getIndReg2226:
  5701 00002F61 A0[BA01]                 mov al, [RegNo]
  5702 00002F64 3C06                     cmp al, 6
  5703 00002F66 0F852700                 jne @@getIndReg2230
  5704 00002F6A A0[C101]                 mov al, [regindexbase]
  5705 00002F6D 3C06                     cmp al, 6
  5706 00002F6F 0F850C00                 jne @@getIndReg2231
  5707 00002F73 66B802000000             mov eax, 2
  5708 00002F79 8846FE                   mov byte [bp-2], al
  5709                                  
  5710                                  ;-219              else if (regindexbase==7) m=0;//BX+SI
  5711                                  
  5712 00002F7C E91200                   jmp @@getIndReg2232
  5713                                  @@getIndReg2231:
  5714 00002F7F A0[C101]                 mov al, [regindexbase]
  5715 00002F82 3C07                     cmp al, 7
  5716 00002F84 0F850900                 jne @@getIndReg2233
  5717 00002F88 66B800000000             mov eax, 0
  5718 00002F8E 8846FE                   mov byte [bp-2], al
  5719                                  
  5720                                  ;-220     if (m > 3) indexerror();
  5721                                  
  5722                                  @@getIndReg2233:
  5723                                  @@getIndReg2232:
  5724                                  @@getIndReg2230:
  5725 00002F91 8A46FE                   mov al, [bp-2]
  5726 00002F94 3C03                     cmp al, 3
  5727 00002F96 0F8E0300                 jle @@getIndReg2234
  5728 00002F9A E848F2                   call indexerror
  5729                                  
  5730                                  ;-221     return m;
  5731                                  
  5732                                  @@getIndReg2234:
  5733 00002F9D 8A46FE                   mov al, [bp-2]
  5734 00002FA0 E90000                   jmp @@retn
  5735                                  
  5736                                  ;-222 }
  5737                                  
  5738                                  
  5739                                  ;-223          
  5740                                  
  5741                                  
  5742                                  ;-224          
  5743                                  
  5744                                  
  5745                                  ;-225 int setwflag() {
  5746                                  
  5747 00002FA3 C9                      @@retn: LEAVE
  5748 00002FA4 C3                       ret
  5749                                  ; ENDP
  5750                                  
  5751                                  setwflag:  ; *** PROC ***
  5752                                  
  5753                                  ;-226     wflag=0;
  5754                                  
  5755 00002FA5 66B800000000             mov eax, 0
  5756 00002FAB A2[BF01]                 mov byte [wflag], al
  5757                                  
  5758                                  ;-227     if (OpSize == 0) {//do not override OpSize
  5759                                  
  5760 00002FAE A0[BE01]                 mov al, [OpSize]
  5761 00002FB1 3C00                     cmp al, 0
  5762 00002FB3 0F854200                 jne @@setwflag235
  5763                                  
  5764                                  ;-228         if (Op == REG) OpSize=RegType;
  5765                                  
  5766 00002FB7 A0[B401]                 mov al, [Op]
  5767 00002FBA 3C02                     cmp al, 2
  5768 00002FBC 0F850600                 jne @@setwflag236
  5769 00002FC0 A0[BC01]                 mov al, [RegType]
  5770 00002FC3 A2[BE01]                 mov byte [OpSize], al
  5771                                  
  5772                                  ;-229         if (Op2== REG) OpSize=RegType;        
  5773                                  
  5774                                  @@setwflag236:
  5775 00002FC6 A0[B501]                 mov al, [Op2]
  5776 00002FC9 3C02                     cmp al, 2
  5777 00002FCB 0F850600                 jne @@setwflag237
  5778 00002FCF A0[BC01]                 mov al, [RegType]
  5779 00002FD2 A2[BE01]                 mov byte [OpSize], al
  5780                                  
  5781                                  ;-230         if (RegType== SEGREG) OpSize=WORD;
  5782                                  
  5783                                  @@setwflag237:
  5784 00002FD5 A0[BC01]                 mov al, [RegType]
  5785 00002FD8 3C04                     cmp al, 4
  5786 00002FDA 0F850900                 jne @@setwflag238
  5787 00002FDE 66B802000000             mov eax, 2
  5788 00002FE4 A2[BE01]                 mov byte [OpSize], al
  5789                                  
  5790                                  ;-231         if (R1Type == SEGREG) OpSize=WORD;        
  5791                                  
  5792                                  @@setwflag238:
  5793 00002FE7 A0[BD01]                 mov al, [R1Type]
  5794 00002FEA 3C04                     cmp al, 4
  5795 00002FEC 0F850900                 jne @@setwflag239
  5796 00002FF0 66B802000000             mov eax, 2
  5797 00002FF6 A2[BE01]                 mov byte [OpSize], al
  5798                                  
  5799                                  ;-232     }
  5800                                  
  5801                                  @@setwflag239:
  5802                                  
  5803                                  ;-233     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  5804                                  
  5805                                  @@setwflag235:
  5806 00002FF9 A0[BE01]                 mov al, [OpSize]
  5807 00002FFC 3C03                     cmp al, 3
  5808 00002FFE 0F850C00                 jne @@setwflag240
  5809 00003002 E883F6                   call gen66h
  5810 00003005 66B801000000             mov eax, 1
  5811 0000300B A2[BF01]                 mov byte [wflag], al
  5812                                  
  5813                                  ;-234     if (OpSize  ==  WORD) wflag=1;
  5814                                  
  5815                                  @@setwflag240:
  5816 0000300E A0[BE01]                 mov al, [OpSize]
  5817 00003011 3C02                     cmp al, 2
  5818 00003013 0F850900                 jne @@setwflag241
  5819 00003017 66B801000000             mov eax, 1
  5820 0000301D A2[BF01]                 mov byte [wflag], al
  5821                                  
  5822                                  ;-235 }
  5823                                  
  5824                                  @@setwflag241:
  5825                                  
  5826                                  ;-236 
  5827                                  
  5828                                  
  5829                                  ;-237 int getSignExtended(unsigned int i) {  
  5830                                  
  5831 00003020 C3                       ret
  5832                                  ; ENDP
  5833                                  
  5834                                  getSignExtended:  ; *** PROC ***
  5835                                  
  5836                                  ;-238     sflag=2;
  5837                                  
  5838                                  ;Function : getSignExtended, Number of local variables: 1
  5839                                  ;   # type sign width line used address name   list of local variables
  5840                                  ;  200 var unsg word   237 NULL bp+4    i;
  5841 00003021 C8000000                 ENTER  0,0
  5842 00003025 66B802000000             mov eax, 2
  5843 0000302B A2[C001]                 mov byte [sflag], al
  5844                                  
  5845                                  ;-239     if(i > 127) sflag = 0;    
  5846                                  
  5847 0000302E 8B4604                   mov ax, [bp+4]
  5848 00003031 83F87F                   cmp ax, 127
  5849 00003034 0F8E0900                 jle @@getSignExtended242
  5850 00003038 66B800000000             mov eax, 0
  5851 0000303E A2[C001]                 mov byte [sflag], al
  5852                                  
  5853                                  ;-240     if (OpSize == BYTE) {
  5854                                  
  5855                                  @@getSignExtended242:
  5856 00003041 A0[BE01]                 mov al, [OpSize]
  5857 00003044 3C01                     cmp al, 1
  5858 00003046 0F851B00                 jne @@getSignExtended243
  5859                                  
  5860                                  ;-241         if (sflag == 0) error1("too big for byte r/m");
  5861                                  
  5862 0000304A A0[C001]                 mov al, [sflag]
  5863 0000304D 3C00                     cmp al, 0
  5864 0000304F 0F850900                 jne @@getSignExtended244
  5865 00003053 68[6730]                 push getSignExtended_0
  5866 00003056 E8B1F0                   call error1
  5867 00003059 83C402                   add  sp, 2
  5868                                  
  5869                                  ;-242         sflag=0;//byte reg does not need sign extended   
  5870                                  
  5871                                  @@getSignExtended244:
  5872 0000305C 66B800000000             mov eax, 0
  5873 00003062 A2[C001]                 mov byte [sflag], al
  5874                                  
  5875                                  ;-243     }
  5876                                  
  5877                                  
  5878                                  ;-244 }
  5879                                  
  5880 00003065 C9                      @@getSignExtended243: LEAVE
  5881 00003066 C3                       ret
  5882                                  ; ENDP
  5883 00003067 746F6F206269672066-     getSignExtended_0 db "too big for byte r/m",0
  5884 00003070 6F7220627974652072-
  5885 00003079 2F6D00             
  5886                                   
  5887                                  ; missing functions: 
  5888                                  ; digit
  5889                                  ; strcpy
  5890                                  ; eqstr
  5891                                  ; strlen
  5892                                  ; eqstr
  5893                                  ; eqstr
  5894                                  ; eqstr
  5895                                  ; eqstr
  5896                                  ; readRL
  5897                                  ; readRL
  5898                                  ; digit
  5899                                  ; digit
  5900                                  ; strcpy
  5901                                  ; toupper
  5902                                  ; strlen
  5903                                  ; strlen
  5904                                  ; eqstr
  5905                                  ; eqstr
  5906                                  ; eqstr
  5907                                  ; eqstr
  5908                                  ; eqstr
  5909                                  ; eqstr
  5910                                  ; eqstr
  5911                                  ; eqstr
  5912                                  ; eqstr
  5913                                  ; eqstr
  5914                                  ; eqstr
  5915                                  ; eqstr
  5916                                  ; eqstr
  5917                                  ; eqstr
  5918                                  ; eqstr
  5919                                  ; eqstr
  5920                                  ; eqstr
  5921                                  ; eqstr
  5922                                  ; eqstr
  5923                                  ; eqstr
  5924                                  ; eqstr
  5925                                  ; eqstr
  5926                                  ; eqstr
  5927                                  ; eqstr
  5928                                  ; eqstr
  5929                                  ; eqstr
  5930                                  ; eqstr
  5931                                  ; eqstr
  5932                                  ; eqstr
  5933                                  ; eqstr
  5934                                  ; writetty
  5935                                  ; writetty
  5936                                  ; fputcR
  5937                                  ; cputs
  5938                                  ; cputs
  5939                                  ; exitR
  5940                                  ; toupper
  5941                                  ; strcpy
  5942                                  ; strcat1
  5943                                  ; strcpy
  5944                                  ; strcat1
  5945                                  ; strcpy
  5946                                  ; strcat1
  5947                                  ; openR
  5948                                  ; cputs
  5949                                  ; cputs
  5950                                  ; exitR
  5951                                  ; creatR
  5952                                  ; cputs
  5953                                  ; cputs
  5954                                  ; exitR
  5955                                  ; creatR
  5956                                  ; cputs
  5957                                  ; cputs
  5958                                  ; exitR
  5959                                  ; fputcR
  5960                                  ; fcloseR
  5961                                  ; fcloseR
  5962                                  ; fcloseR
  5963                                  ; exitR
  5964                                  ; Number of unresolved CALLs :   76
  5965                                  ;use archive file: AR.C
  5966                                  
  5967                                  ;-245 // AR.C Archive
  5968                                  
  5969                                  ;Number of CALLs:    2 : writetty
  5970                                  
  5971                                  writetty:  ; *** PROC ***
  5972 0000307C B40E                     mov  ah, 14
  5973 0000307E BB0000                   mov  bx, 0
  5974 00003081 CD10                     int  16
  5975                                  
  5976                                  ;-246 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5977                                  
  5978 00003083 C3                       ret
  5979                                  ; ENDP
  5980                                  ;Number of CALLs:    8 : cputs
  5981                                  
  5982                                  cputs:  ; *** PROC ***
  5983                                  ;Function : cputs, Number of local variables: 2
  5984                                  ;   # type sign width line used address name   list of local variables
  5985                                  ;  200 ptr sign byte   246 NULL bp+4    s
  5986                                  ;  201 var sign byte   246 NULL bp-2    c;
  5987 00003084 C8020000                 ENTER  2,0
  5988                                  @@cputs245:
  5989 00003088 8B5E04                   mov bx, [bp+4]
  5990 0000308B 8A07                     mov al, [bx]
  5991 0000308D B400                     mov ah, 0
  5992 0000308F 08C0                     or  al, al
  5993 00003091 0F841B00                 je @@cputs246
  5994 00003095 8B5E04                   mov bx, [bp+4]
  5995 00003098 8A07                     mov al, [bx]
  5996 0000309A B400                     mov ah, 0
  5997 0000309C 8846FE                   mov byte [bp-2], al
  5998 0000309F 8A46FE                   mov al, byte [bp-2]
  5999 000030A2 B400                     mov ah, 0
  6000 000030A4 50                       push ax
  6001 000030A5 E8C401                   call putch
  6002 000030A8 83C402                   add  sp, 2
  6003 000030AB FF4604                   inc  word [bp+4]
  6004 000030AE EBD8                     jmp @@cputs245
  6005                                  @@cputs246:
  6006                                  
  6007                                  ;-247 int mkneg(int n) { n; __asm {neg ax} }
  6008 000030B0 C9                       LEAVE
  6009 000030B1 C3                       ret
  6010                                  ; ENDP
  6011                                  ;Number of CALLs:    2 : toupper
  6012                                  
  6013                                  toupper:  ; *** PROC ***
  6014                                  ;Function : toupper, Number of local variables: 1
  6015                                  ;   # type sign width line used address name   list of local variables
  6016                                  ;  200 ptr sign byte   247 NULL bp+4    s;
  6017 000030B2 C8000000                 ENTER  0,0
  6018                                  @@toupper247:
  6019 000030B6 8B5E04                   mov bx, [bp+4]
  6020 000030B9 8A07                     mov al, [bx]
  6021 000030BB B400                     mov ah, 0
  6022 000030BD 08C0                     or  al, al
  6023 000030BF 0F843000                 je @@toupper248
  6024 000030C3 8B5E04                   mov bx, [bp+4]
  6025 000030C6 8A07                     mov al, [bx]
  6026 000030C8 B400                     mov ah, 0
  6027 000030CA 83F861                   cmp ax, 97 ;unsigned : 1
  6028 000030CD 0F8C1D00                 jl  @@toupper249
  6029 000030D1 8B5E04                   mov bx, [bp+4]
  6030 000030D4 8A07                     mov al, [bx]
  6031 000030D6 B400                     mov ah, 0
  6032 000030D8 83F87A                   cmp ax, 122
  6033 000030DB 0F8F0F00                 jg  @@toupper250
  6034 000030DF 8B5E04                   mov bx, [bp+4]
  6035 000030E2 8A07                     mov al, [bx]
  6036 000030E4 B400                     mov ah, 0
  6037 000030E6 83E820                   sub ax, 32
  6038 000030E9 8B5E04                   mov  bx, [bp+4]
  6039 000030EC 8807                     mov  [bx], al
  6040                                  @@toupper250:
  6041                                  @@toupper249:
  6042 000030EE FF4604                   inc  word [bp+4]
  6043 000030F1 EBC3                     jmp @@toupper247
  6044                                  @@toupper248:
  6045                                  
  6046                                  ;-248 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6047                                  
  6048                                  
  6049                                  ;-249 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6050 000030F3 C9                       LEAVE
  6051 000030F4 C3                       ret
  6052                                  ; ENDP
  6053                                  ;Number of CALLs:    3 : strlen
  6054                                  
  6055                                  strlen:  ; *** PROC ***
  6056                                  ;Function : strlen, Number of local variables: 2
  6057                                  ;   # type sign width line used address name   list of local variables
  6058                                  ;  200 ptr sign byte   249 NULL bp+4    s
  6059                                  ;  201 var sign word   249 NULL bp-2    c;
  6060 000030F5 C8020000                 ENTER  2,0
  6061 000030F9 66B800000000             mov eax, 0
  6062 000030FF 8946FE                   mov word [bp-2], ax
  6063                                  @@strlen251:
  6064 00003102 8B5E04                   mov bx, [bp+4]
  6065 00003105 8A07                     mov al, [bx]
  6066 00003107 B400                     mov ah, 0
  6067 00003109 83F800                   cmp ax, 0
  6068 0000310C 0F840800                 je  @@strlen252
  6069 00003110 FF4604                   inc  word [bp+4]
  6070 00003113 FF46FE                   inc  word [bp-2]
  6071 00003116 EBEA                     jmp @@strlen251
  6072                                  @@strlen252:
  6073 00003118 8B46FE                   mov ax, [bp-2]
  6074 0000311B E90000                   jmp @@retn
  6075                                  
  6076                                  ;-250 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6077                                  
  6078 0000311E C9                      @@retn: LEAVE
  6079 0000311F C3                       ret
  6080                                  ; ENDP
  6081                                  ;Number of CALLs:    5 : strcpy
  6082                                  
  6083                                  strcpy:  ; *** PROC ***
  6084                                  ;Function : strcpy, Number of local variables: 2
  6085                                  ;   # type sign width line used address name   list of local variables
  6086                                  ;  200 ptr sign byte   250 NULL bp+4    s
  6087                                  ;  201 ptr sign byte   250 NULL bp+6    t;
  6088 00003120 C8000000                 ENTER  0,0
  6089                                  @@strcpy253:
  6090 00003124 8B5E06                   mov bx, [bp+6]
  6091 00003127 8A07                     mov al, [bx]
  6092 00003129 B400                     mov ah, 0
  6093 0000312B 8B5E04                   mov  bx, [bp+4]
  6094 0000312E 8807                     mov  [bx], al
  6095 00003130 FF4604                   inc  word [bp+4]
  6096 00003133 FF4606                   inc  word [bp+6]
  6097                                  
  6098                                  ;-251   while (*t!=0); *s=0; return s; }
  6099                                  
  6100 00003136 8B5E06                   mov bx, [bp+6]
  6101 00003139 8A07                     mov al, [bx]
  6102 0000313B B400                     mov ah, 0
  6103 0000313D 83F800                   cmp ax, 0
  6104 00003140 0F840200                 je  @@strcpy254
  6105 00003144 EBDE                     jmp @@strcpy253
  6106                                  @@strcpy254:
  6107 00003146 66B800000000             mov eax, 0
  6108 0000314C 8B5E04                   mov  bx, [bp+4]
  6109 0000314F 8807                     mov  [bx], al
  6110 00003151 8B4604                   mov ax, [bp+4]
  6111 00003154 E90000                   jmp @@retn
  6112                                  
  6113                                  ;-252 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6114                                  
  6115 00003157 C9                      @@retn: LEAVE
  6116 00003158 C3                       ret
  6117                                  ; ENDP
  6118                                  ;Number of CALLs:    3 : digit
  6119                                  
  6120                                  digit:  ; *** PROC ***
  6121                                  ;Function : digit, Number of local variables: 1
  6122                                  ;   # type sign width line used address name   list of local variables
  6123                                  ;  200 var sign byte   252 NULL bp+4    c;
  6124 00003159 C8000000                 ENTER  0,0
  6125 0000315D 8A4604                   mov al, [bp+4]
  6126 00003160 3C30                     cmp al, 48
  6127 00003162 0F8D0900                 jge @@digit255
  6128 00003166 66B800000000             mov eax, 0
  6129 0000316C E91B00                   jmp @@retn
  6130                                  @@digit255:
  6131 0000316F 8A4604                   mov al, [bp+4]
  6132 00003172 3C39                     cmp al, 57
  6133 00003174 0F8E0900                 jle @@digit256
  6134 00003178 66B800000000             mov eax, 0
  6135 0000317E E90900                   jmp @@retn
  6136                                  @@digit256:
  6137 00003181 66B801000000             mov eax, 1
  6138 00003187 E90000                   jmp @@retn
  6139                                  
  6140                                  ;-253 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6141                                  
  6142 0000318A C9                      @@retn: LEAVE
  6143 0000318B C3                       ret
  6144                                  ; ENDP
  6145                                  ;Number of CALLs:   35 : eqstr
  6146                                  
  6147                                  eqstr:  ; *** PROC ***
  6148                                  ;Function : eqstr, Number of local variables: 2
  6149                                  ;   # type sign width line used address name   list of local variables
  6150                                  ;  200 ptr sign byte   253 NULL bp+4    p
  6151                                  ;  201 ptr sign byte   253 NULL bp+6    q;
  6152 0000318C C8000000                 ENTER  0,0
  6153                                  @@eqstr257:
  6154 00003190 8B5E04                   mov bx, [bp+4]
  6155 00003193 8A07                     mov al, [bx]
  6156 00003195 B400                     mov ah, 0
  6157 00003197 08C0                     or  al, al
  6158 00003199 0F842300                 je @@eqstr258
  6159                                  
  6160                                  ;-254     if (*p != *q) return 0; p++; q++; }
  6161                                  
  6162 0000319D 8B5E04                   mov bx, [bp+4]
  6163 000031A0 8A07                     mov al, [bx]
  6164 000031A2 B400                     mov ah, 0
  6165 000031A4 8B5E06                   mov bx, [bp+6]
  6166 000031A7 3A07                     cmp al, [bx]
  6167 000031A9 B400                     mov ah, 0
  6168 000031AB 0F840900                 je  @@eqstr259
  6169 000031AF 66B800000000             mov eax, 0
  6170 000031B5 E92700                   jmp @@retn
  6171                                  @@eqstr259:
  6172 000031B8 FF4604                   inc  word [bp+4]
  6173 000031BB FF4606                   inc  word [bp+6]
  6174                                  
  6175                                  ;-255     if(*q) return 0; return 1; }
  6176                                  
  6177 000031BE EBD0                     jmp @@eqstr257
  6178                                  @@eqstr258:
  6179 000031C0 8B5E06                   mov bx, [bp+6]
  6180 000031C3 8A07                     mov al, [bx]
  6181 000031C5 B400                     mov ah, 0
  6182 000031C7 08C0                     or  al, al
  6183 000031C9 0F840900                 je @@eqstr260
  6184 000031CD 66B800000000             mov eax, 0
  6185 000031D3 E90900                   jmp @@retn
  6186                                  @@eqstr260:
  6187 000031D6 66B801000000             mov eax, 1
  6188 000031DC E90000                   jmp @@retn
  6189                                  
  6190                                  ;-256 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  6191                                  
  6192 000031DF C9                      @@retn: LEAVE
  6193 000031E0 C3                       ret
  6194                                  ; ENDP
  6195                                  ;Number of CALLs:    3 : strcat1
  6196                                  
  6197                                  strcat1:  ; *** PROC ***
  6198                                  ;Function : strcat1, Number of local variables: 2
  6199                                  ;   # type sign width line used address name   list of local variables
  6200                                  ;  200 ptr sign byte   256 NULL bp+4    s
  6201                                  ;  201 ptr sign byte   256 NULL bp+6    t;
  6202 000031E1 C8000000                 ENTER  0,0
  6203                                  @@strcat1261:
  6204 000031E5 8B5E04                   mov bx, [bp+4]
  6205 000031E8 8A07                     mov al, [bx]
  6206 000031EA B400                     mov ah, 0
  6207 000031EC 83F800                   cmp ax, 0
  6208 000031EF 0F840500                 je  @@strcat1262
  6209 000031F3 FF4604                   inc  word [bp+4]
  6210 000031F6 EBED                     jmp @@strcat1261
  6211                                  @@strcat1262:
  6212 000031F8 FF7606                   push word [bp+6]
  6213 000031FB FF7604                   push word [bp+4]
  6214 000031FE E81FFF                   call strcpy
  6215 00003201 83C404                   add  sp, 4
  6216                                  
  6217                                  ;-257 int basename(char *s) { char *p; p=0;
  6218 00003204 C9                       LEAVE
  6219 00003205 C3                       ret
  6220                                  ; ENDP
  6221                                  ;Number of CALLs:    1 : openR
  6222                                  
  6223                                  openR:  ; *** PROC ***
  6224                                  ;Function : openR, Number of local variables: 1
  6225                                  ;   # type sign width line used address name   list of local variables
  6226                                  ;  200 ptr sign byte   257 NULL bp+4    s;
  6227 00003206 C8000000                 ENTER  0,0
  6228 0000320A 8B5604                   mov  dx, [bp+4]
  6229 0000320D B8023D                   mov  ax, 15618
  6230 00003210 E87200                   call DosInt
  6231                                  
  6232                                  ;-258 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  6233 00003213 C9                       LEAVE
  6234 00003214 C3                       ret
  6235                                  ; ENDP
  6236                                  ;Number of CALLs:    2 : creatR
  6237                                  
  6238                                  creatR:  ; *** PROC ***
  6239                                  ;Function : creatR, Number of local variables: 1
  6240                                  ;   # type sign width line used address name   list of local variables
  6241                                  ;  200 ptr sign byte   258 NULL bp+4    s;
  6242 00003215 C8000000                 ENTER  0,0
  6243 00003219 8B5604                   mov  dx, [bp+4]
  6244 0000321C B90000                   mov  cx, 0
  6245 0000321F B8003C                   mov  ax, 15360
  6246 00003222 E86000                   call DosInt
  6247                                  
  6248                                  ;-259 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  6249 00003225 C9                       LEAVE
  6250 00003226 C3                       ret
  6251                                  ; ENDP
  6252                                  ;Number of CALLs:    2 : readRL
  6253                                  
  6254                                  readRL:  ; *** PROC ***
  6255                                  ;Function : readRL, Number of local variables: 3
  6256                                  ;   # type sign width line used address name   list of local variables
  6257                                  ;  200 ptr sign byte   259 NULL bp+4    s
  6258                                  ;  201 var sign word   259 NULL bp+6    fd
  6259                                  ;  202 var sign word   259 NULL bp+8    len;
  6260 00003227 C8000000                 ENTER  0,0
  6261 0000322B 8B5604                   mov  dx, [bp+4]
  6262 0000322E 8B4E08                   mov  cx, [bp+8]
  6263 00003231 8B5E06                   mov  bx, [bp+6]
  6264 00003234 B8003F                   mov  ax, 16128
  6265 00003237 E84B00                   call DosInt
  6266                                  
  6267                                  ;-260 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  6268 0000323A C9                       LEAVE
  6269 0000323B C3                       ret
  6270                                  ; ENDP
  6271                                  ;Number of CALLs:    2 : fputcR
  6272                                  
  6273                                  fputcR:  ; *** PROC ***
  6274                                  ;Function : fputcR, Number of local variables: 2
  6275                                  ;   # type sign width line used address name   list of local variables
  6276                                  ;  200 ptr sign byte   260 NULL bp+4    n
  6277                                  ;  201 var sign word   260 NULL bp+6    fd;
  6278 0000323C C8000000                 ENTER  0,0
  6279 00003240 8D5604                  lea dx, [bp+4]
  6280                                  
  6281                                  ;-261   cx=1; bx=fd; ax=0x4000; DosInt(); }
  6282                                  
  6283 00003243 B90100                   mov  cx, 1
  6284 00003246 8B5E06                   mov  bx, [bp+6]
  6285 00003249 B80040                   mov  ax, 16384
  6286 0000324C E83600                   call DosInt
  6287                                  
  6288                                  ;-262 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  6289 0000324F C9                       LEAVE
  6290 00003250 C3                       ret
  6291                                  ; ENDP
  6292                                  ;Number of CALLs:    3 : fcloseR
  6293                                  
  6294                                  fcloseR:  ; *** PROC ***
  6295                                  ;Function : fcloseR, Number of local variables: 1
  6296                                  ;   # type sign width line used address name   list of local variables
  6297                                  ;  200 var sign word   262 NULL bp+4    fd;
  6298 00003251 C8000000                 ENTER  0,0
  6299 00003255 8B5E04                   mov  bx, [bp+4]
  6300 00003258 B8003E                   mov  ax, 15872
  6301 0000325B CD21                     int  33
  6302                                  
  6303                                  ;-263 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  6304 0000325D C9                       LEAVE
  6305 0000325E C3                       ret
  6306                                  ; ENDP
  6307                                  ;Number of CALLs:    5 : exitR
  6308                                  
  6309                                  exitR:  ; *** PROC ***
  6310                                  ;Function : exitR, Number of local variables: 1
  6311                                  ;   # type sign width line used address name   list of local variables
  6312                                  ;  200 var sign byte   263 NULL bp+4    c;
  6313 0000325F C8000000                 ENTER  0,0
  6314 00003263 B44C                     mov  ah, 76
  6315 00003265 8A4604                   mov  al, [bp+4]
  6316 00003268 CD21                     int  33
  6317                                  
  6318                                  ;-264 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  6319 0000326A C9                       LEAVE
  6320 0000326B C3                       ret
  6321                                  ; ENDP
  6322                                  ;End of archive file. 
  6323                                   
  6324                                  ; missing functions: 
  6325                                  ; putch
  6326                                  ; DosInt
  6327                                  ; DosInt
  6328                                  ; DosInt
  6329                                  ; DosInt
  6330                                  ; Number of unresolved CALLs :    5
  6331                                  ;use archive file: AR.C
  6332                                  
  6333                                  ;-265 // AR.C Archive
  6334                                  
  6335                                  ;Number of CALLs:    1 : putch
  6336                                  
  6337                                  putch:  ; *** PROC ***
  6338                                  ;Function : putch, Number of local variables: 1
  6339                                  ;   # type sign width line used address name   list of local variables
  6340                                  ;  200 var sign byte   265 NULL bp+4    c;
  6341 0000326C C8000000                 ENTER  0,0
  6342 00003270 807E040A                cmp byte [bp+4], 10
  6343 00003274 0F850500                 jne @@putch263
  6344 00003278 B00D                     mov  al, 13
  6345 0000327A E8FFFD                   call writetty
  6346                                  @@putch263:
  6347 0000327D 8A4604                   mov  al, [bp+4]
  6348 00003280 E8F9FD                   call writetty
  6349                                  
  6350                                  ;-266 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  6351 00003283 C9                       LEAVE
  6352 00003284 C3                       ret
  6353                                  ; ENDP
  6354                                  ;Number of CALLs:    4 : DosInt
  6355                                  
  6356                                  DosInt:  ; *** PROC ***
  6357 00003285 CD21                     int  33
  6358 00003287 7304                     jae short @@DosInt264
  6359 00003289 FF06[A701]               inc  word [DOS_ERR]
  6360                                  @@DosInt264:
  6361                                  
  6362                                  ;-267 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  6363                                  
  6364 0000328D C3                       ret
  6365                                  ; ENDP
  6366                                  ;End of archive file. 
  6367                                   
  6368                                  ; missing functions:  All FUNCTIONs in place
  6369 0000328E E80000                  LastFunctionByt:db 0E8h, 0, 0
  6370 00003291 58                      pop ax
  6371 00003292 C3                      ret
  6372                                   
  6373                                  ;   # type sign width line used  address name   list of global variables
  6374                                  
  6375                                  ;    1 arr sign byte     1    2        0 Version1[18]
  6376                                  ;    2 var sign byte     1    3        0 LIST
  6377                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  6378                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  6379                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  6380                                  ;    6 var unsg word     5   13        0 SymbolInt
  6381                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  6382                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  6383                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  6384                                  ;   10 arr sign byte     9    5        0 namein[67]
  6385                                  ;   11 arr sign byte    10    5        0 namelst[67]
  6386                                  ;   12 arr sign byte    11    5        0 namebin[67]
  6387                                  ;   13 var sign word    12    4        0 asm_fd
  6388                                  ;   14 var sign word    13    3        0 lst_fd
  6389                                  ;   15 var sign word    14    3        0 bin_fd
  6390                                  ;   16 var sign word    15    6        0 DOS_ERR
  6391                                  ;   17 var sign word    16    4        0 ErrorCount
  6392                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  6393                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  6394                                  ;   20 var unsg word    20    5        0 PC
  6395                                  ;   21 var unsg word    21    2        0 PCStart
  6396                                  ;   22 var sign byte    22    3        0 isLabel
  6397                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  6398                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  6399                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  6400                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  6401                                  ;   27 var sign byte    27   21        0 TokeType
  6402                                  ;   28 def unsg byte    28    -        0 BYTE=1
  6403                                  ;   29 def unsg byte    29    -        0 WORD=2
  6404                                  ;   30 def unsg byte    30    -        0 DWORD=3
  6405                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  6406                                  ;   32 def unsg byte    32    -        0 IMM=1
  6407                                  ;   33 def unsg byte    33    -        0 REG=2
  6408                                  ;   34 def unsg byte    34    -        0 ADR=3
  6409                                  ;   35 def unsg byte    35    -        0 MEM=4
  6410                                  ;   36 var sign byte    36   19        0 Op
  6411                                  ;   37 var sign byte    37   14        0 Op2
  6412                                  ;   38 var sign byte    38   13        0 CodeType
  6413                                  ;   39 var sign byte    39   12        0 Code1
  6414                                  ;   40 var sign byte    40    6        0 Code2
  6415                                  ;   41 var sign byte    41    3        0 Code3
  6416                                  ;   42 var sign byte    42   13        0 RegNo
  6417                                  ;   43 var sign byte    43    6        0 R1No
  6418                                  ;   44 var sign byte    44   20        0 RegType
  6419                                  ;   45 var sign byte    45    2        0 R1Type
  6420                                  ;   46 var sign byte    46   13        0 OpSize
  6421                                  ;   47 var sign byte    47    5        0 wflag
  6422                                  ;   48 var sign byte    49    5        0 sflag
  6423                                  ;   49 var sign byte    50   14        0 regindexbase
  6424                                  ;   50 var sign byte    51    3        0 isDirect
  6425                                  ;   51 var sign word    52   15        0 disp
  6426                                  ;   52 var sign word    53    6        0 imme
  6427                                  ;   53 def unsg byte    55    -        0 OPMAXLEN=5
  6428                                  ;   54 arr sign byte    56    2        0 OpPos[5]
  6429                                  ;   55 var sign word    57    6        0 OpPrintIndex
  6430                                  ;   56 ptr sign byte    58   17        0 OpCodePtr
  6431                                  ;   57 var sign byte    59    2        0 PrintR
  6432                                  ;   58 def unsg byte    61    -        0 LABELNAMESMAX=969
  6433                                  ;   59 arr sign byte    62    3        0 LabelNames[1000]
  6434                                  ;   60 ptr sign byte    63    5        0 LabelNamePtr
  6435                                  ;   61 def unsg byte    64    -        0 LABELADRMAX=100
  6436                                  ;   62 arr unsg word    65    4        0 LabelAddr[100]
  6437                                  ;   63 var sign word    66    4        0 LabelMaxIx
  6438                                  ;   64 var sign word    67    5        0 LabelIx
  6439                                  ;   65 def unsg byte    69    -        0 FILEBINMAX=2000
  6440                                  ;   66 arr sign byte    70    2        0 FileBin[2000]
  6441                                  ;   67 var unsg word    71    5        0 BinLen
  6442                                  ;   68 ptr sign byte    73    1        0 arglen
  6443                                  ;   69 ptr sign byte    74    4        0 argv
  6444                                  ;   70 var sign byte     1    1        0 I_START
  6445                                  ;   71 arr sign byte     4 NULL        0 I_PUSHA[9]
  6446                                  ;   72 arr sign byte     5 NULL        0 I_POPA[8]
  6447                                  ;   73 arr sign byte     6 NULL        0 I_NOP[7]
  6448                                  ;   74 arr sign byte     7 NULL        0 I_CBW[7]
  6449                                  ;   75 arr sign byte     8 NULL        0 I_CWDE[8]
  6450                                  ;   76 arr sign byte     9 NULL        0 I_CWD[7]
  6451                                  ;   77 arr sign byte    10 NULL        0 I_CDQ[7]
  6452                                  ;   78 arr sign byte    11 NULL        0 I_WAIT[8]
  6453                                  ;   79 arr sign byte    12 NULL        0 I_PUSHF[9]
  6454                                  ;   80 arr sign byte    13 NULL        0 I_POPF[8]
  6455                                  ;   81 arr sign byte    14 NULL        0 I_SAHF[8]
  6456                                  ;   82 arr sign byte    15 NULL        0 I_LAHF[8]
  6457                                  ;   83 arr sign byte    16 NULL        0 I_MOVSB[9]
  6458                                  ;   84 arr sign byte    17 NULL        0 I_MOVSW[9]
  6459                                  ;   85 arr sign byte    18 NULL        0 I_CMPSB[9]
  6460                                  ;   86 arr sign byte    19 NULL        0 I_CMPSW[9]
  6461                                  ;   87 arr sign byte    20 NULL        0 I_STOSB[9]
  6462                                  ;   88 arr sign byte    21 NULL        0 I_STOSW[9]
  6463                                  ;   89 arr sign byte    22 NULL        0 I_LODSB[9]
  6464                                  ;   90 arr sign byte    23 NULL        0 I_LODSW[9]
  6465                                  ;   91 arr sign byte    24 NULL        0 I_SCASB[9]
  6466                                  ;   92 arr sign byte    25 NULL        0 I_SCASW[9]
  6467                                  ;   93 arr sign byte    26 NULL        0 I_LEAVE[9]
  6468                                  ;   94 arr sign byte    27 NULL        0 I_IRET[8]
  6469                                  ;   95 arr sign byte    28 NULL        0 I_XLAT[8]
  6470                                  ;   96 arr sign byte    29 NULL        0 I_LOCK[8]
  6471                                  ;   97 arr sign byte    30 NULL        0 I_REPNE[9]
  6472                                  ;   98 arr sign byte    31 NULL        0 I_REPNZ[9]
  6473                                  ;   99 arr sign byte    32 NULL        0 I_REPE[8]
  6474                                  ;  100 arr sign byte    33 NULL        0 I_REPZ[8]
  6475                                  ;  101 arr sign byte    34 NULL        0 I_HLT[7]
  6476                                  ;  102 arr sign byte    35 NULL        0 I_CLC[7]
  6477                                  ;  103 arr sign byte    36 NULL        0 I_STC[7]
  6478                                  ;  104 arr sign byte    37 NULL        0 I_CLI[7]
  6479                                  ;  105 arr sign byte    38 NULL        0 I_STI[7]
  6480                                  ;  106 arr sign byte    39 NULL        0 I_CLD[7]
  6481                                  ;  107 arr sign byte    40 NULL        0 I_STD[7]
  6482                                  ;  108 arr sign byte    42 NULL        0 I_INC[9]
  6483                                  ;  109 arr sign byte    43 NULL        0 I_DEC[9]
  6484                                  ;  110 arr sign byte    44 NULL        0 I_NOT[8]
  6485                                  ;  111 arr sign byte    45 NULL        0 I_NEG[8]
  6486                                  ;  112 arr sign byte    46 NULL        0 I_MUL[8]
  6487                                  ;  113 arr sign byte    47 NULL        0 I_IMUL[9]
  6488                                  ;  114 arr sign byte    48 NULL        0 I_DIV[8]
  6489                                  ;  115 arr sign byte    49 NULL        0 I_IDIV[9]
  6490                                  ;  116 arr sign byte    51 NULL        0 I_LES[7]
  6491                                  ;  117 arr sign byte    52 NULL        0 I_LDS[7]
  6492                                  ;  118 arr sign byte    53 NULL        0 I_LEA[7]
  6493                                  ;  119 arr sign byte    54 NULL        0 I_LSS[8]
  6494                                  ;  120 arr sign byte    55 NULL        0 I_LFS[8]
  6495                                  ;  121 arr sign byte    56 NULL        0 I_LGS[8]
  6496                                  ;  122 arr sign byte    58 NULL        0 I_ADD[7]
  6497                                  ;  123 arr sign byte    59 NULL        0 I_OR[6]
  6498                                  ;  124 arr sign byte    60 NULL        0 I_ADC[7]
  6499                                  ;  125 arr sign byte    61 NULL        0 I_SBB[7]
  6500                                  ;  126 arr sign byte    62 NULL        0 I_AND[7]
  6501                                  ;  127 arr sign byte    63 NULL        0 I_SUB[7]
  6502                                  ;  128 arr sign byte    64 NULL        0 I_XOR[7]
  6503                                  ;  129 arr sign byte    65 NULL        0 I_CMP[7]
  6504                                  ;  130 arr sign byte    66 NULL        0 I_TEST[11]
  6505                                  ;  131 arr sign byte    68 NULL        0 I_MOV[6]
  6506                                  ;  132 arr sign byte    69 NULL        0 I_MOVSX[9]
  6507                                  ;  133 arr sign byte    70 NULL        0 I_MOVZX[9]
  6508                                  ;  134 arr sign byte    72 NULL        0 I_JO[6]
  6509                                  ;  135 arr sign byte    73 NULL        0 I_JNO[7]
  6510                                  ;  136 arr sign byte    74 NULL        0 I_JB[6]
  6511                                  ;  137 arr sign byte    75 NULL        0 I_JC[6]
  6512                                  ;  138 arr sign byte    76 NULL        0 I_JNB[7]
  6513                                  ;  139 arr sign byte    77 NULL        0 I_JAE[7]
  6514                                  ;  140 arr sign byte    78 NULL        0 I_JNC[7]
  6515                                  ;  141 arr sign byte    79 NULL        0 I_JE[6]
  6516                                  ;  142 arr sign byte    80 NULL        0 I_JZ[6]
  6517                                  ;  143 arr sign byte    81 NULL        0 I_JNE[7]
  6518                                  ;  144 arr sign byte    82 NULL        0 I_JNZ[7]
  6519                                  ;  145 arr sign byte    83 NULL        0 I_JBE[7]
  6520                                  ;  146 arr sign byte    84 NULL        0 I_JNA[7]
  6521                                  ;  147 arr sign byte    85 NULL        0 I_JA[6]
  6522                                  ;  148 arr sign byte    86 NULL        0 I_JS[6]
  6523                                  ;  149 arr sign byte    87 NULL        0 I_JNS[7]
  6524                                  ;  150 arr sign byte    88 NULL        0 I_JP[6]
  6525                                  ;  151 arr sign byte    89 NULL        0 I_JPE[7]
  6526                                  ;  152 arr sign byte    90 NULL        0 I_JNP[7]
  6527                                  ;  153 arr sign byte    91 NULL        0 I_JPO[7]
  6528                                  ;  154 arr sign byte    92 NULL        0 I_JL[6]
  6529                                  ;  155 arr sign byte    93 NULL        0 I_JNL[7]
  6530                                  ;  156 arr sign byte    94 NULL        0 I_JGE[7]
  6531                                  ;  157 arr sign byte    95 NULL        0 I_JLE[7]
  6532                                  ;  158 arr sign byte    96 NULL        0 I_JNG[7]
  6533                                  ;  159 arr sign byte    97 NULL        0 I_JG[6]
  6534                                  ;  160 arr sign byte    99 NULL        0 I_JMP[8]
  6535                                  ;  161 arr sign byte   100 NULL        0 I_CALL[9]
  6536                                  ;  162 arr sign byte   102 NULL        0 I_RET[8]
  6537                                  ;  163 arr sign byte   103 NULL        0 I_RETF[9]
  6538                                  ;  164 arr sign byte   105 NULL        0 I_PUSH[8]
  6539                                  ;  165 arr sign byte   106 NULL        0 I_POP[7]
  6540                                  ;  166 arr sign byte   108 NULL        0 I_ROL[7]
  6541                                  ;  167 arr sign byte   109 NULL        0 I_ROR[7]
  6542                                  ;  168 arr sign byte   110 NULL        0 I_RCL[7]
  6543                                  ;  169 arr sign byte   111 NULL        0 I_RCR[7]
  6544                                  ;  170 arr sign byte   112 NULL        0 I_SHL[7]
  6545                                  ;  171 arr sign byte   113 NULL        0 I_SAL[7]
  6546                                  ;  172 arr sign byte   114 NULL        0 I_SHR[7]
  6547                                  ;  173 arr sign byte   115 NULL        0 I_SAR[7]
  6548                                  ;  174 arr sign byte   117 NULL        0 I_INT[8]
  6549                                  ;  175 arr sign byte   118 NULL        0 I_INTO[8]
  6550                                  ;  176 arr sign byte   129 NULL        0 I_XCHG[9]
  6551                                  ;  177 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6552                                  ;  178 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6553                                  ;  179 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6554                                  ;  180 arr sign byte   134 NULL        0 I_LOOPE[9]
  6555                                  ;  181 arr sign byte   135 NULL        0 I_LOOP[8]
  6556                                  ;  182 arr sign byte   136 NULL        0 I_JCXZ[8]
  6557                                  ;  183 arr sign byte   137 NULL        0 I_JECXZ[9]
  6558                                  ;  184 arr sign byte   139 NULL        0 I_ENTER[9]
  6559                                  ;  185 arr sign byte   141 NULL        0 I_ORG[6]
  6560                                  ;  186 arr sign byte   146 NULL        0 I_DB[5]
  6561                                  ;  187 arr sign byte   147 NULL        0 I_DW[5]
  6562                                  ;  188 arr sign byte   148 NULL        0 I_DD[5]
  6563                                  ;  189 arr sign byte   149 NULL        0 I_RESB[7]
  6564                                  ;  190 arr sign byte   150 NULL        0 I_RESW[7]
  6565                                  ;  191 arr sign byte   151 NULL        0 I_RESD[7]
  6566                                  ;  192 var sign byte   152 NULL        0 I_END
  6567                                  
  6568                                  
  6569                                  ;   # Calls Line Width  Name   list of functions
  6570                                  
  6571                                  ;    0    1    1 word   parse
  6572                                  ;    1   14   27 word   getTokeType
  6573                                  ;    2    2   36 word   storeLabel
  6574                                  ;    3    2   46 word   searchLabel
  6575                                  ;    4    1   57 word   getVariable
  6576                                  ;    5    2   86 word   lookCode
  6577                                  ;    6    1  101 word   getCodeSize
  6578                                  ;    7    9  108 word   isToken
  6579                                  ;    8    2  113 word   need
  6580                                  ;    9    1  123 word   skipRest
  6581                                  ;   10    1    1 word   getLine
  6582                                  ;   11    1   17 word   ifEOL
  6583                                  ;   12    3   24 word   skipBlank
  6584                                  ;   13    2   29 word   letterE
  6585                                  ;   14    1   39 word   alnumE
  6586                                  ;   15    1   44 word   getDigit
  6587                                  ;   16    1   56 word   getName
  6588                                  ;   17    1   75 word   testReg
  6589                                  ;   18    1    1 word   printLine
  6590                                  ;   19    8   19 word   prc
  6591                                  ;   20    1   23 word   prscomment
  6592                                  ;   21   21   26 word   prs
  6593                                  ;   22    3   31 word   printhex8a
  6594                                  ;   23    1   35 word   printhex16
  6595                                  ;   24    3   38 word   printIntU
  6596                                  ;   25   27   45 word   error1
  6597                                  ;   26 NULL   48 word   allowederror
  6598                                  ;   27    1   49 word   addrerror
  6599                                  ;   28    1   50 word   immeerror
  6600                                  ;   29    2   51 word   implerror
  6601                                  ;   30    4   52 word   indexerror
  6602                                  ;   31    3   53 word   invaloperror
  6603                                  ;   32    1   54 word   numbererror
  6604                                  ;   33 NULL   55 word   regmemerror
  6605                                  ;   34    1   56 word   reg16error
  6606                                  ;   35    1   57 word   segregerror
  6607                                  ;   36    2   58 word   syntaxerror
  6608                                  ;   37   12   60 word   errorexit
  6609                                  ;   38    1   61 word   addrexit
  6610                                  ;   39 NULL   62 word   internexit
  6611                                  ;   40 NULL    1 word   main
  6612                                  ;   41    1    8 word   getarg
  6613                                  ;   42    1   38 word   epilog
  6614                                  ;   43    2   67 word   end1
  6615                                  ;   44    1    2 word   getCodes
  6616                                  ;   45    1    7 word   gen66h
  6617                                  ;   46    2    9 word   genCode
  6618                                  ;   47    1   13 word   genCodeDW
  6619                                  ;   48    5   17 word   genCodeW
  6620                                  ;   49   15   21 word   genCode8
  6621                                  ;   50    4   32 word   genCode16
  6622                                  ;   51    5   36 word   writeEA
  6623                                  ;   52    2   78 word   genImmediate
  6624                                  ;   53    1   11 word   process
  6625                                  ;   54    1  116 word   checkOpL
  6626                                  ;   55    1  138 word   get2Ops
  6627                                  ;   56    3  145 word   getOpL
  6628                                  ;   57    2  158 word   getOpR
  6629                                  ;   58    3  168 word   getOp1
  6630                                  ;   59    2  184 word   getMEM
  6631                                  ;   60    1  206 word   getIndReg1
  6632                                  ;   61    1  214 word   getIndReg2
  6633                                  ;   62    2  225 word   setwflag
  6634                                  ;   63    1  237 word   getSignExtended
  6635                                  ;   64    4  245 word   writetty
  6636                                  ;   65    8  246 word   cputs
  6637                                  ;   66    2  247 word   toupper
  6638                                  ;   67    3  249 word   strlen
  6639                                  ;   68    6  250 word   strcpy
  6640                                  ;   69    3  252 word   digit
  6641                                  ;   70   35  253 word   eqstr
  6642                                  ;   71    3  256 word   strcat1
  6643                                  ;   72    1  257 word   openR
  6644                                  ;   73    2  258 word   creatR
  6645                                  ;   74    2  259 word   readRL
  6646                                  ;   75    2  260 word   fputcR
  6647                                  ;   76    3  262 word   fcloseR
  6648                                  ;   77    5  263 word   exitR
  6649                                  ;   78    1  265 word   putch
  6650                                  ;   79    4  266 word   DosInt
  6651                                  ;   80 NULL  267 word   LastFunctionByt
  6652                                  
  6653                                  ;    #  addr name   list of CALLs
  6654                                  
  6655                                  ;    0  1345 getLine
  6656                                  ;    1  1353 getTokeType
  6657                                  ;    2  1365 storeLabel
  6658                                  ;    3  1376 getTokeType
  6659                                  ;    4  1388 lookCode
  6660                                  ;    5  1397 process
  6661                                  ;    6  1405 getVariable
  6662                                  ;    7  1417 skipRest
  6663                                  ;    8  1426 error1
  6664                                  ;    9  1433 error1
  6665                                  ;   10  1440 printLine
  6666                                  ;   11  1464 skipBlank
  6667                                  ;   12  1474 digit
  6668                                  ;   13  1480 getDigit
  6669                                  ;   14  1489 letterE
  6670                                  ;   15  1497 getName
  6671                                  ;   16  1518 searchLabel
  6672                                  ;   17  1530 error1
  6673                                  ;   18  1537 strcpy
  6674                                  ;   19  1544 errorexit
  6675                                  ;   20  1554 errorexit
  6676                                  ;   21  1584 eqstr
  6677                                  ;   22  1590 strlen
  6678                                  ;   23  1611 storeLabel
  6679                                  ;   24  1622 getTokeType
  6680                                  ;   25  1634 lookCode
  6681                                  ;   26  1643 errorexit
  6682                                  ;   27  1653 errorexit
  6683                                  ;   28  1663 getTokeType
  6684                                  ;   29  1675 genCode8
  6685                                  ;   30  1684 skipBlank
  6686                                  ;   31  1694 isToken
  6687                                  ;   32  1702 genCode8
  6688                                  ;   33  1711 isToken
  6689                                  ;   34  1719 getTokeType
  6690                                  ;   35  1731 genCode16
  6691                                  ;   36  1741 isToken
  6692                                  ;   37  1749 errorexit
  6693                                  ;   38  1768 eqstr
  6694                                  ;   39  1786 eqstr
  6695                                  ;   40  1792 getTokeType
  6696                                  ;   41  1804 eqstr
  6697                                  ;   42  1810 getTokeType
  6698                                  ;   43  1822 eqstr
  6699                                  ;   44  1828 getTokeType
  6700                                  ;   45  1850 skipBlank
  6701                                  ;   46  1867 isToken
  6702                                  ;   47  1875 getTokeType
  6703                                  ;   48  1887 error1
  6704                                  ;   49  1894 prs
  6705                                  ;   50  1898 prc
  6706                                  ;   51  1911 getTokeType
  6707                                  ;   52  1923 error1
  6708                                  ;   53  1940 readRL
  6709                                  ;   54  1947 errorexit
  6710                                  ;   55  1957 errorexit
  6711                                  ;   56  1967 ifEOL
  6712                                  ;   57  1981 readRL
  6713                                  ;   58  2017 digit
  6714                                  ;   59  2023 letterE
  6715                                  ;   60  2050 digit
  6716                                  ;   61  2070 alnumE
  6717                                  ;   62  2077 errorexit
  6718                                  ;   63  2087 strcpy
  6719                                  ;   64  2094 toupper
  6720                                  ;   65  2110 strlen
  6721                                  ;   66  2117 strlen
  6722                                  ;   67  2124 eqstr
  6723                                  ;   68  2130 eqstr
  6724                                  ;   69  2136 eqstr
  6725                                  ;   70  2142 eqstr
  6726                                  ;   71  2148 eqstr
  6727                                  ;   72  2154 eqstr
  6728                                  ;   73  2160 eqstr
  6729                                  ;   74  2166 eqstr
  6730                                  ;   75  2172 eqstr
  6731                                  ;   76  2178 eqstr
  6732                                  ;   77  2184 eqstr
  6733                                  ;   78  2190 eqstr
  6734                                  ;   79  2196 eqstr
  6735                                  ;   80  2202 eqstr
  6736                                  ;   81  2208 eqstr
  6737                                  ;   82  2214 eqstr
  6738                                  ;   83  2220 eqstr
  6739                                  ;   84  2226 eqstr
  6740                                  ;   85  2232 eqstr
  6741                                  ;   86  2238 eqstr
  6742                                  ;   87  2244 eqstr
  6743                                  ;   88  2250 eqstr
  6744                                  ;   89  2256 eqstr
  6745                                  ;   90  2262 eqstr
  6746                                  ;   91  2268 eqstr
  6747                                  ;   92  2274 eqstr
  6748                                  ;   93  2280 eqstr
  6749                                  ;   94  2286 eqstr
  6750                                  ;   95  2292 eqstr
  6751                                  ;   96  2298 eqstr
  6752                                  ;   97  2318 prs
  6753                                  ;   98  2322 printhex16
  6754                                  ;   99  2333 prs
  6755                                  ;  100  2337 prc
  6756                                  ;  101  2341 printhex8a
  6757                                  ;  102  2352 prc
  6758                                  ;  103  2356 prs
  6759                                  ;  104  2360 prscomment
  6760                                  ;  105  2377 writetty
  6761                                  ;  106  2386 writetty
  6762                                  ;  107  2395 fputcR
  6763                                  ;  108  2417 prc
  6764                                  ;  109  2433 prc
  6765                                  ;  110  2454 prc
  6766                                  ;  111  2458 prc
  6767                                  ;  112  2480 printhex8a
  6768                                  ;  113  2491 printhex8a
  6769                                  ;  114  2516 printIntU
  6770                                  ;  115  2526 prc
  6771                                  ;  116  2539 prs
  6772                                  ;  117  2543 prs
  6773                                  ;  118  2547 prs
  6774                                  ;  119  2551 prs
  6775                                  ;  120  2568 error1
  6776                                  ;  121  2585 error1
  6777                                  ;  122  2602 error1
  6778                                  ;  123  2619 error1
  6779                                  ;  124  2637 error1
  6780                                  ;  125  2657 error1
  6781                                  ;  126  2676 error1
  6782                                  ;  127  2695 error1
  6783                                  ;  128  2713 error1
  6784                                  ;  129  2732 error1
  6785                                  ;  130  2751 error1
  6786                                  ;  131  2770 error1
  6787                                  ;  132  2777 end1
  6788                                  ;  133  2791 errorexit
  6789                                  ;  134  2812 errorexit
  6790                                  ;  135  2827 getarg
  6791                                  ;  136  2834 parse
  6792                                  ;  137  2840 epilog
  6793                                  ;  138  2847 end1
  6794                                  ;  139  2871 cputs
  6795                                  ;  140  2877 cputs
  6796                                  ;  141  2883 exitR
  6797                                  ;  142  2889 toupper
  6798                                  ;  143  2897 strcpy
  6799                                  ;  144  2904 strcat1
  6800                                  ;  145  2912 strcpy
  6801                                  ;  146  2919 strcat1
  6802                                  ;  147  2927 strcpy
  6803                                  ;  148  2934 strcat1
  6804                                  ;  149  2942 openR
  6805                                  ;  150  2948 cputs
  6806                                  ;  151  2954 cputs
  6807                                  ;  152  2960 exitR
  6808                                  ;  153  2966 creatR
  6809                                  ;  154  2973 cputs
  6810                                  ;  155  2979 cputs
  6811                                  ;  156  2985 exitR
  6812                                  ;  157  2991 creatR
  6813                                  ;  158  2998 cputs
  6814                                  ;  159  3004 cputs
  6815                                  ;  160  3010 exitR
  6816                                  ;  161  3016 prs
  6817                                  ;  162  3020 prs
  6818                                  ;  163  3024 prs
  6819                                  ;  164  3028 prs
  6820                                  ;  165  3032 prs
  6821                                  ;  166  3036 prs
  6822                                  ;  167  3040 prs
  6823                                  ;  168  3044 prs
  6824                                  ;  169  3048 prs
  6825                                  ;  170  3065 prs
  6826                                  ;  171  3069 printIntU
  6827                                  ;  172  3079 prs
  6828                                  ;  173  3083 prs
  6829                                  ;  174  3087 printIntU
  6830                                  ;  175  3097 prs
  6831                                  ;  176  3101 fputcR
  6832                                  ;  177  3115 fcloseR
  6833                                  ;  178  3123 fcloseR
  6834                                  ;  179  3131 fcloseR
  6835                                  ;  180  3139 exitR
  6836                                  ;  181  3161 genCode8
  6837                                  ;  182  3182 genCode8
  6838                                  ;  183  3203 genCodeW
  6839                                  ;  184  3223 genCode8
  6840                                  ;  185  3243 errorexit
  6841                                  ;  186  3265 genCode8
  6842                                  ;  187  3274 genCode8
  6843                                  ;  188  3299 addrexit
  6844                                  ;  189  3308 error1
  6845                                  ;  190  3315 genCode8
  6846                                  ;  191  3324 genCode8
  6847                                  ;  192  3333 genCode16
  6848                                  ;  193  3356 genCode16
  6849                                  ;  194  3366 genCode8
  6850                                  ;  195  3385 getTokeType
  6851                                  ;  196  3397 getCodeSize
  6852                                  ;  197  3409 getCodes
  6853                                  ;  198  3418 genCode8
  6854                                  ;  199  3427 getOpL
  6855                                  ;  200  3434 checkOpL
  6856                                  ;  201  3443 genCode
  6857                                  ;  202  3451 genCode
  6858                                  ;  203  3459 getTokeType
  6859                                  ;  204  3471 implerror
  6860                                  ;  205  3481 genCodeW
  6861                                  ;  206  3490 writeEA
  6862                                  ;  207  3498 getOpL
  6863                                  ;  208  3505 reg16error
  6864                                  ;  209  3516 need
  6865                                  ;  210  3521 getOpR
  6866                                  ;  211  3528 addrerror
  6867                                  ;  212  3538 genCode8
  6868                                  ;  213  3547 genCode8
  6869                                  ;  214  3556 writeEA
  6870                                  ;  215  3564 get2Ops
  6871                                  ;  216  3572 immeerror
  6872                                  ;  217  3582 invaloperror
  6873                                  ;  218  3595 setwflag
  6874                                  ;  219  3604 getSignExtended
  6875                                  ;  220  3620 genCodeW
  6876                                  ;  221  3629 genImmediate
  6877                                  ;  222  3642 genCodeW
  6878                                  ;  223  3651 writeEA
  6879                                  ;  224  3659 genImmediate
  6880                                  ;  225  3672 genCodeDW
  6881                                  ;  226  3682 writeEA
  6882                                  ;  227  3690 genCodeW
  6883                                  ;  228  3699 writeEA
  6884                                  ;  229  3707 syntaxerror
  6885                                  ;  230  3719 genCode8
  6886                                  ;  231  3728 genCode16
  6887                                  ;  232  3738 genCode8
  6888                                  ;  233  3747 error1
  6889                                  ;  234  3754 error1
  6890                                  ;  235  3770 implerror
  6891                                  ;  236  3780 segregerror
  6892                                  ;  237  3792 setwflag
  6893                                  ;  238  3801 error1
  6894                                  ;  239  3808 error1
  6895                                  ;  240  3815 error1
  6896                                  ;  241  3830 getOpL
  6897                                  ;  242  3837 need
  6898                                  ;  243  3842 getOpR
  6899                                  ;  244  3856 getOp1
  6900                                  ;  245  3863 isToken
  6901                                  ;  246  3871 getMEM
  6902                                  ;  247  3878 invaloperror
  6903                                  ;  248  3891 error1
  6904                                  ;  249  3905 getOp1
  6905                                  ;  250  3912 isToken
  6906                                  ;  251  3920 getMEM
  6907                                  ;  252  3927 invaloperror
  6908                                  ;  253  3940 error1
  6909                                  ;  254  3954 testReg
  6910                                  ;  255  3962 searchLabel
  6911                                  ;  256  3974 error1
  6912                                  ;  257  3990 getTokeType
  6913                                  ;  258  4002 getOp1
  6914                                  ;  259  4009 syntaxerror
  6915                                  ;  260  4021 getIndReg2
  6916                                  ;  261  4032 getIndReg1
  6917                                  ;  262  4043 isToken
  6918                                  ;  263  4051 getTokeType
  6919                                  ;  264  4063 numbererror
  6920                                  ;  265  4075 isToken
  6921                                  ;  266  4083 isToken
  6922                                  ;  267  4091 errorexit
  6923                                  ;  268  4112 indexerror
  6924                                  ;  269  4123 indexerror
  6925                                  ;  270  4147 indexerror
  6926                                  ;  271  4158 indexerror
  6927                                  ;  272  4178 gen66h
  6928                                  ;  273  4203 error1
  6929                                  ;  274  4229 putch
  6930                                  ;  275  4297 strcpy
  6931                                  ;  276  4312 DosInt
  6932                                  ;  277  4328 DosInt
  6933                                  ;  278  4351 DosInt
  6934                                  ;  279  4370 DosInt
  6935                                  ;  280  4404 writetty
  6936                                  ;  281  4413 writetty
  6937                                  ;Input: AS.C, List: AS.S,  Lines:  268
  6938                                  ;Glob. variables:  192 max.:  200
  6939                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6940                                  ;Functions      :   81 max.:  300
  6941                                  ;Calls          :  282 max.: 2000, NameField: 4445 max.:    65535
  6942                                  ;Code until     :25998 max.: 30000, free: 4002
  6943                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6944                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
