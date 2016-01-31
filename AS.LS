     1                                  
     2                                  ; A.COM CComp V0.7 16.11.2014, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E98114                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.07 31.1.2016";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E30-     Version1 db "AS.C V0.07 31.1.2016",0
    10 0000000C 372033312E312E3230-
    11 00000015 313600             
    12                                  
    13                                  ;-2 #include "DECL.C"
    14                                  
    15                                  ;Use include file: DECL.C
    16                                  
    17                                  ;-1 char LIST;              // listing on/off
    18                                  
    19 00000018 00                      LIST db 0
    20                                  
    21                                  ;-2 #define SYMBOLMAX    31
    22                                  
    23                                  
    24                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    25                                  
    26                                  section .bss
    27                                  absolute 30000
    28 00007530 <res 0000001F>          Symbol resb 31
    29                                  section .text
    30                                  
    31                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    32                                  
    33                                  section .bss
    34                                  absolute 30031
    35 0000754F <res 0000001F>          SymbolUpper resb 31
    36                                  section .text
    37                                  
    38                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    39                                  
    40 00000019 0000                    SymbolInt dw 0
    41                                  
    42                                  ;-6 #define INPUTBUFMAX 127
    43                                  
    44                                  
    45                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    46                                  
    47                                  section .bss
    48                                  absolute 30062
    49 0000756E <res 0000007F>          InputBuf resb 127
    50                                  section .text
    51                                  
    52                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    53                                  
    54 0000001B 0000                    InputPtr dw 0
    55                                  
    56                                  ;-9 char namein [67];       //input file name  .S
    57                                  
    58                                  section .bss
    59                                  absolute 30189
    60 000075ED <res 00000043>          namein resb 67
    61                                  section .text
    62                                  
    63                                  ;-10 char namelst[67];       //list file name   .LST
    64                                  
    65                                  section .bss
    66                                  absolute 30256
    67 00007630 <res 00000043>          namelst resb 67
    68                                  section .text
    69                                  
    70                                  ;-11 char namebin[67];       //output file name .COM
    71                                  
    72                                  section .bss
    73                                  absolute 30323
    74 00007673 <res 00000043>          namebin resb 67
    75                                  section .text
    76                                  
    77                                  ;-12 int  asm_fd;            //input file descriptor
    78                                  
    79 0000001D 0000                    asm_fd dw 0
    80                                  
    81                                  ;-13 int lst_fd;             //list file descriptor
    82                                  
    83 0000001F 0000                    lst_fd dw 0
    84                                  
    85                                  ;-14 int bin_fd;             //output file descriptor
    86                                  
    87 00000021 0000                    bin_fd dw 0
    88                                  
    89                                  ;-15 int DOS_ERR;            //global var
    90                                  
    91 00000023 0000                    DOS_ERR dw 0
    92                                  
    93                                  ;-16 int ErrorCount;         //number of errors
    94                                  
    95 00000025 0000                    ErrorCount dw 0
    96                                  
    97                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
    98                                  
    99 00000027 0000                    DOS_NoBytes dw 0
   100                                  
   101                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
   102                                  
   103 00000029 00                      DOS_ByteRead db 0
   104                                  
   105                                  ;-19 
   106                                  
   107                                  
   108                                  ;-20 unsigned int PC;        //program counter, ORG nn
   109                                  
   110 0000002A 0000                    PC dw 0
   111                                  
   112                                  ;-21 unsigned int PCStart;   //PC at start of line by PrintLine()
   113                                  
   114 0000002C 0000                    PCStart dw 0
   115                                  
   116                                  ;-22 char isLabel;           //by getName()
   117                                  
   118 0000002E 00                      isLabel db 0
   119                                  
   120                                  ;-23 #define DIGIT    1      //0-9
   121                                  
   122                                  
   123                                  ;-24 #define LETTERE  2      //a-z A-Z @ . _
   124                                  
   125                                  
   126                                  ;-25 #define ALNUME   3      //a-z A-Z @ . _  0-9
   127                                  
   128                                  
   129                                  ;-26 #define NOALNUME 4      //other char
   130                                  
   131                                  
   132                                  ;-27 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   133                                  
   134 0000002F 00                      TokeType db 0
   135                                  
   136                                  ;-28 #define BYTE     1
   137                                  
   138                                  
   139                                  ;-29 #define WORD     2
   140                                  
   141                                  
   142                                  ;-30 #define DWORD    3
   143                                  
   144                                  
   145                                  ;-31 #define SEGREG   4
   146                                  
   147                                  
   148                                  ;-32 #define IMM      1      //const  ,123
   149                                  
   150                                  
   151                                  ;-33 #define REG      2      //       ,BX    mode=11
   152                                  
   153                                  
   154                                  ;-34 #define ADR      3      //VALUE  ,var1  mod=00, r/m=110
   155                                  
   156                                  
   157                                  ;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   158                                  
   159                                  
   160                                  ;-36 char Op1;               //0, IMM, REG, ADR, MEM
   161                                  
   162 00000030 00                      Op1 db 0
   163                                  
   164                                  ;-37 char CodeType;          //1-207 by searchSymbol(), must be byte size
   165                                  
   166 00000031 00                      CodeType db 0
   167                                  
   168                                  ;-38 char Code1;             // first  Opcode
   169                                  
   170 00000032 00                      Code1 db 0
   171                                  
   172                                  ;-39 char Code2;             // second Opcode
   173                                  
   174 00000033 00                      Code2 db 0
   175                                  
   176                                  ;-40 char Code3;             // third  Opcode
   177                                  
   178 00000034 00                      Code3 db 0
   179                                  
   180                                  ;-41 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   181                                  
   182 00000035 00                      RegType db 0
   183                                  
   184                                  ;-42 char RegNo;             //0 - 7 AL, CL, ...  by testReg()
   185                                  
   186 00000036 00                      RegNo db 0
   187                                  
   188                                  ;-43 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   189                                  
   190 00000037 00                      OpSize db 0
   191                                  
   192                                  ;-44 char wflag;             //0=byte, 1=word/dword
   193                                  
   194 00000038 00                      wflag db 0
   195                                  
   196                                  ;-45 //char AddrSize;          //67h:
   197                                  
   198                                  
   199                                  ;-46 //char NumOprns;          //0-2
   200                                  
   201                                  
   202                                  ;-47 //char dflag;             //0=source is reg,  1=dest is reg
   203                                  
   204                                  
   205                                  ;-48 //char modrm;           //mod, r/m
   206                                  
   207                                  
   208                                  ;-49 char regindexbase;      //combination of index and base reg
   209                                  
   210 00000039 00                      regindexbase db 0
   211                                  
   212                                  ;-50 char isDirect;          //is direct addressing
   213                                  
   214 0000003A 00                      isDirect db 0
   215                                  
   216                                  ;-51 int disp;               //displacement      0-8 bytes
   217                                  
   218 0000003B 0000                    disp dw 0
   219                                  
   220                                  ;-52 int imme;               //immediate         0-8 bytes
   221                                  
   222 0000003D 0000                    imme dw 0
   223                                  
   224                                  ;-53 
   225                                  
   226                                  
   227                                  ;-54 #define OPMAXLEN 5
   228                                  
   229                                  
   230                                  ;-55 char OpPos[OPMAXLEN];   //array for one opcode to list
   231                                  
   232                                  section .bss
   233                                  absolute 30390
   234 000076B6 <res 00000005>          OpPos resb 5
   235                                  section .text
   236                                  
   237                                  ;-56 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   238                                  
   239 0000003F 0000                    OpPrintIndex dw 0
   240                                  
   241                                  ;-57 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   242                                  
   243 00000041 0000                    OpCodePtr dw 0
   244                                  
   245                                  ;-58 char PrintR;           //print 'R' if relocative
   246                                  
   247 00000043 00                      PrintR db 0
   248                                  
   249                                  ;-59 
   250                                  
   251                                  
   252                                  ;-60 #define LABELNAMESMAX 969//next number - 31
   253                                  
   254                                  
   255                                  ;-61 char LabelNames[1000];  //space for names of all labels
   256                                  
   257                                  section .bss
   258                                  absolute 30395
   259 000076BB <res 000003E8>          LabelNames resb 1000
   260                                  section .text
   261                                  
   262                                  ;-62 char *LabelNamePtr;     // first free position
   263                                  
   264 00000044 0000                    LabelNamePtr dw 0
   265                                  
   266                                  ;-63 #define LABELADRMAX 100
   267                                  
   268                                  
   269                                  ;-64 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   270                                  
   271                                  section .bss
   272                                  absolute 31395
   273 00007AA3 <res 000000C8>          LabelAddr resw 100
   274                                  section .text
   275                                  
   276                                  ;-65 int LabelMaxIx=0;       //actual number of stored labels
   277                                  
   278 00000046 0000                    LabelMaxIx dw 0
   279                                  
   280                                  ;-66 int LabelIx;            //actual number of just searched label
   281                                  
   282 00000048 0000                    LabelIx dw 0
   283                                  
   284                                  ;-67 
   285                                  
   286                                  
   287                                  ;-68 #define FILEBINMAX 2000 //next number - max. oplength
   288                                  
   289                                  
   290                                  ;-69 char FileBin  [FILEBINMAX];//output binary file
   291                                  
   292                                  section .bss
   293                                  absolute 31595
   294 00007B6B <res 000007D0>          FileBin resb 2000
   295                                  section .text
   296                                  
   297                                  ;-70 unsigned int BinLen=0;  //length of binary file
   298                                  
   299 0000004A 0000                    BinLen dw 0
   300                                  
   301                                  ;-71 
   302                                  
   303                                  
   304                                  ;-72 char *arglen=0x80;      // for main only
   305                                  
   306 0000004C 8000                    arglen dw 128
   307                                  
   308                                  ;-73 char *argv=0x82;        // for main only
   309                                  
   310 0000004E 8200                    argv dw 130
   311                                  ;Back to main program: AS.C
   312                                  
   313                                  ;-3 #include "OPTABL.C"
   314                                  
   315                                  ;Use include file: OPTABL.C
   316                                  
   317                                  ;-1 char I_START=0xF1;
   318                                  
   319 00000050 F1                      I_START db 241
   320                                  
   321                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   322                                  
   323                                  
   324                                  ;-3 //  1:   1 byte opcode
   325                                  
   326                                  
   327                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   328                                  
   329 00000051 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   330                                  
   331                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   332                                  
   333 0000005A 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   334                                  
   335                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   336                                  
   337 00000062 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   338                                  
   339                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   340                                  
   341 00000069 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   342                                  
   343                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   344                                  
   345 00000070 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   346                                  
   347                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   348                                  
   349 00000078 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   350                                  
   351                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   352                                  
   353 0000007F 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   354                                  
   355                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   356                                  
   357 00000086 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   358                                  
   359                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   360                                  
   361 0000008E 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   362                                  
   363                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   364                                  
   365 00000097 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   366                                  
   367                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   368                                  
   369 0000009F 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   370                                  
   371                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   372                                  
   373 000000A7 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   374                                  
   375                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   376                                  
   377 000000AF 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   378                                  
   379                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   380                                  
   381 000000B8 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   382                                  
   383                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   384                                  
   385 000000C1 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   386                                  
   387                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   388                                  
   389 000000CA 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   390                                  
   391                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   392                                  
   393 000000D3 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   394                                  
   395                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   396                                  
   397 000000DC 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   398                                  
   399                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   400                                  
   401 000000E5 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   402                                  
   403                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   404                                  
   405 000000EE 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   406                                  
   407                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   408                                  
   409 000000F7 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   410                                  
   411                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   412                                  
   413 00000100 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   414                                  
   415                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   416                                  
   417 00000109 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   418                                  
   419                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   420                                  
   421 00000112 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   422                                  
   423                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   424                                  
   425 0000011A 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   426                                  
   427                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   428                                  
   429 00000122 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   430                                  
   431                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   432                                  
   433 0000012A 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   434                                  
   435                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   436                                  
   437 00000133 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   438                                  
   439                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   440                                  
   441 0000013C 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   442                                  
   443                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   444                                  
   445 00000144 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   446                                  
   447                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   448                                  
   449 0000014C 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   450                                  
   451                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   452                                  
   453 00000153 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   454                                  
   455                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   456                                  
   457 0000015A 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   458                                  
   459                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   460                                  
   461 00000161 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   462                                  
   463                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   464                                  
   465 00000168 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   466                                  
   467                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   468                                  
   469 0000016F 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   470                                  
   471                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   472                                  
   473 00000176 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   474                                  
   475                                  ;-41 // 2: mem reg 16 bit
   476                                  
   477                                  
   478                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   479                                  
   480 0000017D 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   481                                  
   482                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   483                                  
   484 00000186 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   485                                  
   486                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   487                                  
   488 0000018F 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   489                                  
   490                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   491                                  
   492 00000197 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   493                                  
   494                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   495                                  
   496 0000019F 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   497                                  
   498                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   499                                  
   500 000001A7 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   501                                  
   502                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   503                                  
   504 000001B0 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   505                                  
   506                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   507                                  
   508 000001B8 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   509                                  
   510                                  ;-50 //  3: les, lda, lea, lss, lfs, lgs
   511                                  
   512                                  
   513                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   514                                  
   515 000001C1 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   516                                  
   517                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   518                                  
   519 000001C8 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   520                                  
   521                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   522                                  
   523 000001CF 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   524                                  
   525                                  ;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   526                                  
   527 000001D6 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   528                                  
   529                                  ;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   530                                  
   531 000001DE 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   532                                  
   533                                  ;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   534                                  
   535 000001E6 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   536                                  
   537                                  ;-57 //  4: acc,imm  reg,imm  index,reg
   538                                  
   539                                  
   540                                  ;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   541                                  
   542 000001EE 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   543                                  
   544                                  ;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   545                                  
   546 000001F5 4F52000401F1            I_OR db 79,82,0,4,1,241
   547                                  
   548                                  ;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   549                                  
   550 000001FB 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   551                                  
   552                                  ;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   553                                  
   554 00000202 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   555                                  
   556                                  ;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   557                                  
   558 00000209 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   559                                  
   560                                  ;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   561                                  
   562 00000210 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   563                                  
   564                                  ;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   565                                  
   566 00000217 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   567                                  
   568                                  ;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   569                                  
   570 0000021E 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   571                                  
   572                                  ;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   573                                  
   574 00000225 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   575 0000022E 00F1               
   576                                  
   577                                  ;-67 //  5: mov
   578                                  
   579                                  
   580                                  ;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   581                                  
   582 00000230 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   583                                  
   584                                  ;-69 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   585                                  
   586 00000236 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   587                                  
   588                                  ;-70 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   589                                  
   590 0000023F 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   591                                  
   592                                  ;-71 //  6: single byte relative jump
   593                                  
   594                                  
   595                                  ;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   596                                  
   597 00000248 4A4F000600F1            I_JO db 74,79,0,6,0,241
   598                                  
   599                                  ;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   600                                  
   601 0000024E 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   602                                  
   603                                  ;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   604                                  
   605 00000255 4A42000602F1            I_JB db 74,66,0,6,2,241
   606                                  
   607                                  ;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   608                                  
   609 0000025B 4A43000602F1            I_JC db 74,67,0,6,2,241
   610                                  
   611                                  ;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   612                                  
   613 00000261 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   614                                  
   615                                  ;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   616                                  
   617 00000268 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   618                                  
   619                                  ;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   620                                  
   621 0000026F 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   622                                  
   623                                  ;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   624                                  
   625 00000276 4A45000604F1            I_JE db 74,69,0,6,4,241
   626                                  
   627                                  ;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   628                                  
   629 0000027C 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   630                                  
   631                                  ;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   632                                  
   633 00000282 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   634                                  
   635                                  ;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   636                                  
   637 00000289 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   638                                  
   639                                  ;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   640                                  
   641 00000290 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   642                                  
   643                                  ;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   644                                  
   645 00000297 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   646                                  
   647                                  ;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   648                                  
   649 0000029E 4A41000607F1            I_JA db 74,65,0,6,7,241
   650                                  
   651                                  ;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   652                                  
   653 000002A4 4A53000608F1            I_JS db 74,83,0,6,8,241
   654                                  
   655                                  ;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   656                                  
   657 000002AA 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   658                                  
   659                                  ;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   660                                  
   661 000002B1 4A5000060AF1            I_JP db 74,80,0,6,10,241
   662                                  
   663                                  ;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   664                                  
   665 000002B7 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   666                                  
   667                                  ;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   668                                  
   669 000002BE 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   670                                  
   671                                  ;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   672                                  
   673 000002C5 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   674                                  
   675                                  ;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   676                                  
   677 000002CC 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   678                                  
   679                                  ;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   680                                  
   681 000002D2 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   682                                  
   683                                  ;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   684                                  
   685 000002D9 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   686                                  
   687                                  ;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   688                                  
   689 000002E0 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   690                                  
   691                                  ;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   692                                  
   693 000002E7 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   694                                  
   695                                  ;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   696                                  
   697 000002EE 4A4700060FF1            I_JG db 74,71,0,6,15,241
   698                                  
   699                                  ;-98 //  7: jmp, call
   700                                  
   701                                  
   702                                  ;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   703                                  
   704 000002F4 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   705                                  
   706                                  ;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   707                                  
   708 000002FC 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   709                                  
   710                                  ;-101 //  8: ret
   711                                  
   712                                  
   713                                  ;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   714                                  
   715 00000305 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   716                                  
   717                                  ;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   718                                  
   719 0000030D 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   720                                  
   721                                  ;-104 //  9: seg, r/m
   722                                  
   723                                  
   724                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   725                                  
   726 00000316 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   727                                  
   728                                  ;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   729                                  
   730 0000031E 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   731                                  
   732                                  ;-107 //  11: shift, rotates
   733                                  
   734                                  
   735                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   736                                  
   737 00000325 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   738                                  
   739                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   740                                  
   741 0000032C 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   742                                  
   743                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   744                                  
   745 00000333 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   746                                  
   747                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   748                                  
   749 0000033A 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   750                                  
   751                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   752                                  
   753 00000341 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   754                                  
   755                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   756                                  
   757 00000348 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   758                                  
   759                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   760                                  
   761 0000034F 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   762                                  
   763                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   764                                  
   765 00000356 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   766                                  
   767                                  ;-116 //  12: int
   768                                  
   769                                  
   770                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   771                                  
   772 0000035D 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   773                                  
   774                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   775                                  
   776 00000365 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   777                                  
   778                                  ;-119 //  14: in/out
   779                                  
   780                                  
   781                                  ;-120 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   782                                  
   783 0000036D 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   784                                  
   785                                  ;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   786                                  
   787 00000374 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   788                                  
   789                                  ;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   790                                  
   791 0000037C 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   792                                  
   793                                  ;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   794                                  
   795 00000384 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   796                                  
   797                                  ;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   798                                  
   799 0000038C 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   800                                  
   801                                  ;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   802                                  
   803 00000394 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   804                                  
   805                                  ;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   806                                  
   807 0000039C 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   808                                  
   809                                  ;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   810                                  
   811 000003A4 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   812                                  
   813                                  ;-128 //  15: xchg
   814                                  
   815                                  
   816                                  ;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   817                                  
   818 000003AC 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   819                                  
   820                                  ;-130 //  16: loop, jcxz
   821                                  
   822                                  
   823                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   824                                  
   825 000003B5 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   826 000003BE F1                 
   827                                  
   828                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   829                                  
   830 000003BF 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   831 000003C8 F1                 
   832                                  
   833                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   834                                  
   835 000003C9 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   836                                  
   837                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   838                                  
   839 000003D2 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   840                                  
   841                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   842                                  
   843 000003DB 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   844                                  
   845                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   846                                  
   847 000003E3 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   848                                  
   849                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   850                                  
   851 000003EB 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   852                                  
   853                                  ;-138 //  30: enter
   854                                  
   855                                  
   856                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   857                                  
   858 000003F4 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   859                                  
   860                                  ;-140 // 100: directives
   861                                  
   862                                  
   863                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   864                                  
   865 000003FD 4F52470065F1            I_ORG db 79,82,71,0,101,241
   866                                  
   867                                  ;-142 // section, segment .TEXT .DATA .BSS
   868                                  
   869                                  
   870                                  ;-143 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   871                                  
   872 00000403 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   873 0000040C F1                 
   874                                  
   875                                  ;-144 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   876                                  
   877 0000040D 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   878 00000416 F1                 
   879                                  
   880                                  ;-145 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   881                                  
   882 00000417 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   883 00000420 6EF1               
   884                                  
   885                                  ;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};
   886                                  
   887 00000422 444200C8F1              I_DB db 68,66,0,200,241
   888                                  
   889                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   890                                  
   891 00000427 445700C9F1              I_DW db 68,87,0,201,241
   892                                  
   893                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   894                                  
   895 0000042C 444400CAF1              I_DD db 68,68,0,202,241
   896                                  
   897                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   898                                  
   899 00000431 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   900                                  
   901                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   902                                  
   903 00000438 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   904                                  
   905                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   906                                  
   907 0000043F 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   908                                  
   909                                  ;-152 char I_END=0;// end of table char
   910                                  
   911 00000446 00                      I_END db 0
   912                                  ;Back to main program: AS.C
   913                                  
   914                                  ;-4 
   915                                  
   916                                  
   917                                  ;-5 #include "PARSE.C"
   918                                  
   919                                  ;Use include file: PARSE.C
   920                                  
   921                                  ;-1 int parse() {
   922                                  
   923                                  
   924                                  parse:  ; *** PROC ***
   925                                  
   926                                  ;-2   LabelNamePtr= &LabelNames;
   927                                  
   928 00000447 B8BB76                   mov ax, LabelNames
   929 0000044A A3[4400]                 mov word [LabelNamePtr], ax
   930                                  
   931                                  ;-3   do {
   932                                  
   933                                  @@parse1:
   934                                  
   935                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
   936                                  
   937 0000044D A1[2A00]                 mov ax, [PC]
   938 00000450 A3[2C00]                 mov word [PCStart], ax
   939 00000453 66B800000000             mov eax, 0
   940 00000459 A2[3700]                 mov byte [OpSize], al
   941 0000045C 66B800000000             mov eax, 0
   942 00000462 A3[3F00]                 mov word [OpPrintIndex], ax
   943 00000465 66B820000000             mov eax, 32
   944 0000046B A2[4300]                 mov byte [PrintR], al
   945                                  
   946                                  ;-5     getLine();
   947                                  
   948 0000046E E8D004                   call getLine
   949                                  
   950                                  ;-6     InputPtr = &InputBuf;
   951                                  
   952 00000471 B86E75                   mov ax, InputBuf
   953 00000474 A3[1B00]                 mov word [InputPtr], ax
   954                                  
   955                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
   956                                  
   957 00000477 E8B700                   call getTokeType
   958                                  
   959                                  ;-8     if (TokeType == ALNUME) {
   960                                  
   961 0000047A A0[2F00]                 mov al, [TokeType]
   962 0000047D 3C03                     cmp al, 3
   963 0000047F 0F851300                 jne @@parse2
   964                                  
   965                                  ;-9       if (isLabel) { //set in getName
   966                                  
   967 00000483 A0[2E00]                 mov al, [isLabel]
   968 00000486 08C0                     or  al, al
   969 00000488 0F840A00                 je @@parse3
   970                                  
   971                                  ;-10         storeLabel();
   972                                  
   973 0000048C E84001                   call storeLabel
   974                                  
   975                                  ;-11         InputPtr++;//remove :
   976                                  
   977 0000048F FF06[1B00]               inc  word [InputPtr]
   978                                  
   979                                  ;-12         getTokeType();
   980                                  
   981 00000493 E89B00                   call getTokeType
   982                                  
   983                                  ;-13       }
   984                                  
   985                                  
   986                                  ;-14     }
   987                                  
   988                                  @@parse3:
   989                                  
   990                                  ;-15     if (TokeType == ALNUME) {
   991                                  
   992                                  @@parse2:
   993 00000496 A0[2F00]                 mov al, [TokeType]
   994 00000499 3C03                     cmp al, 3
   995 0000049B 0F851B00                 jne @@parse4
   996                                  
   997                                  ;-16       lookCode();// and OpCodePtr
   998                                  
   999 0000049F E80F03                   call lookCode
  1000                                  
  1001                                  ;-17       if(CodeType) process();
  1002                                  
  1003 000004A2 A0[3100]                 mov al, [CodeType]
  1004 000004A5 08C0                     or  al, al
  1005 000004A7 0F840600                 je @@parse5
  1006 000004AB E8EC14                   call process
  1007                                  
  1008                                  ;-18       else getVariable();
  1009                                  
  1010 000004AE E90300                   jmp @@parse6
  1011                                  @@parse5:
  1012 000004B1 E8C501                   call getVariable
  1013                                  
  1014                                  ;-19       skipRest();
  1015                                  
  1016                                  @@parse6:
  1017 000004B4 E86104                   call skipRest
  1018                                  
  1019                                  ;-20     }
  1020                                  
  1021                                  
  1022                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  1023                                  
  1024 000004B7 E92700                   jmp @@parse7
  1025                                  @@parse4:
  1026 000004BA A0[2F00]                 mov al, [TokeType]
  1027 000004BD 3C03                     cmp al, 3
  1028 000004BF 0F8E0C00                 jle @@parse8
  1029 000004C3 68[F204]                 push parse_0
  1030 000004C6 E8D50D                   call error1
  1031 000004C9 83C402                   add  sp, 2
  1032                                  
  1033                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1034                                  
  1035 000004CC E91200                   jmp @@parse9
  1036                                  @@parse8:
  1037 000004CF A0[2F00]                 mov al, [TokeType]
  1038 000004D2 3C01                     cmp al, 1
  1039 000004D4 0F850900                 jne @@parse10
  1040 000004D8 68[1005]                 push parse_1
  1041 000004DB E8C00D                   call error1
  1042 000004DE 83C402                   add  sp, 2
  1043                                  
  1044                                  ;-23     printLine();
  1045                                  
  1046                                  @@parse10:
  1047                                  @@parse9:
  1048                                  @@parse7:
  1049 000004E1 E84F0B                   call printLine
  1050                                  
  1051                                  ;-24   } while (DOS_NoBytes != 0 );
  1052                                  
  1053 000004E4 A1[2700]                 mov ax, [DOS_NoBytes]
  1054 000004E7 83F800                   cmp ax, 0
  1055 000004EA 0F840300                 je  @@parse11
  1056 000004EE E95CFF                   jmp @@parse1
  1057                                  @@parse11:
  1058                                  
  1059                                  ;-25 }
  1060                                  
  1061                                  
  1062                                  ;-26 // scan code .....................................
  1063                                  
  1064                                  
  1065                                  ;-27 int getTokeType() { char c;
  1066                                  
  1067 000004F1 C3                       ret
  1068                                  ; ENDP
  1069 000004F2 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1070 000004FB 696E73747275637469-
  1071 00000504 6F6E20657870656374-
  1072 0000050D 656400             
  1073 00000510 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1074 00000519 616C6C6F7765642040-
  1075 00000522 207374617274206F66-
  1076 0000052B 206C696E6500       
  1077                                  
  1078                                  getTokeType:  ; *** PROC ***
  1079                                  
  1080                                  ;-28   skipBlank();
  1081                                  
  1082                                  ;Function : getTokeType, Number of local variables: 1
  1083                                  ;   # type sign width line used address name   list of local variables
  1084                                  ;  200 var sign byte    27 NULL bp-2    c;
  1085 00000531 C8020000                 ENTER  2,0
  1086 00000535 E8D604                   call skipBlank
  1087                                  
  1088                                  ;-29   c = *InputPtr;
  1089                                  
  1090 00000538 8B1E[1B00]               mov bx, [InputPtr]
  1091 0000053C 8A07                     mov al, [bx]
  1092 0000053E B400                     mov ah, 0
  1093 00000540 8846FE                   mov byte [bp-2], al
  1094                                  
  1095                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1096                                  
  1097 00000543 8A46FE                   mov al, [bp-2]
  1098 00000546 3C00                     cmp al, 0
  1099 00000548 0F850C00                 jne @@getTokeType12
  1100 0000054C 66B800000000             mov eax, 0
  1101 00000552 A2[2F00]                 mov byte [TokeType], al
  1102 00000555 E97500                   jmp @@retn
  1103                                  
  1104                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1105                                  
  1106                                  @@getTokeType12:
  1107 00000558 8A46FE                   mov al, [bp-2]
  1108 0000055B 3C3B                     cmp al, 59
  1109 0000055D 0F850C00                 jne @@getTokeType13
  1110 00000561 66B800000000             mov eax, 0
  1111 00000567 A2[2F00]                 mov byte [TokeType], al
  1112 0000056A E96000                   jmp @@retn
  1113                                  
  1114                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1115                                  
  1116                                  @@getTokeType13:
  1117 0000056D 8A46FE                   mov al, byte [bp-2]
  1118 00000570 B400                     mov ah, 0
  1119 00000572 50                       push ax
  1120 00000573 E8CA1A                   call digit
  1121 00000576 83C402                   add  sp, 2
  1122 00000579 08C0                     or  al, al
  1123 0000057B 0F841800                 je @@getTokeType14
  1124 0000057F 8A46FE                   mov al, byte [bp-2]
  1125 00000582 B400                     mov ah, 0
  1126 00000584 50                       push ax
  1127 00000585 E88C05                   call getDigit
  1128 00000588 83C402                   add  sp, 2
  1129 0000058B 66B801000000             mov eax, 1
  1130 00000591 A2[2F00]                 mov byte [TokeType], al
  1131 00000594 E93600                   jmp @@retn
  1132                                  
  1133                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1134                                  
  1135                                  @@getTokeType14:
  1136 00000597 8A46FE                   mov al, byte [bp-2]
  1137 0000059A B400                     mov ah, 0
  1138 0000059C 50                       push ax
  1139 0000059D E89904                   call letterE
  1140 000005A0 83C402                   add  sp, 2
  1141 000005A3 08C0                     or  al, al
  1142 000005A5 0F841800                 je @@getTokeType15
  1143 000005A9 8A46FE                   mov al, byte [bp-2]
  1144 000005AC B400                     mov ah, 0
  1145 000005AE 50                       push ax
  1146 000005AF E8B905                   call getName
  1147 000005B2 83C402                   add  sp, 2
  1148 000005B5 66B803000000             mov eax, 3
  1149 000005BB A2[2F00]                 mov byte [TokeType], al
  1150 000005BE E90C00                   jmp @@retn
  1151                                  
  1152                                  ;-34   TokeType=NOALNUME; return;
  1153                                  
  1154                                  @@getTokeType15:
  1155 000005C1 66B804000000             mov eax, 4
  1156 000005C7 A2[2F00]                 mov byte [TokeType], al
  1157 000005CA E90000                   jmp @@retn
  1158                                  
  1159                                  ;-35 }
  1160                                  
  1161                                  
  1162                                  ;-36 int storeLabel() {
  1163                                  
  1164 000005CD C9                      @@retn: LEAVE
  1165 000005CE C3                       ret
  1166                                  ; ENDP
  1167                                  
  1168                                  storeLabel:  ; *** PROC ***
  1169                                  
  1170                                  ;-37   if(searchLabel()) error1("duplicate label");
  1171                                  
  1172 000005CF E84700                   call searchLabel
  1173 000005D2 08C0                     or  al, al
  1174 000005D4 0F840900                 je @@storeLabel16
  1175 000005D8 68[0906]                 push storeLabel_0
  1176 000005DB E8C00C                   call error1
  1177 000005DE 83C402                   add  sp, 2
  1178                                  
  1179                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1180                                  
  1181                                  @@storeLabel16:
  1182 000005E1 8D063075                 lea  ax, [Symbol]
  1183 000005E5 50                       push ax
  1184 000005E6 FF36[4400]               push word [LabelNamePtr]
  1185 000005EA E81A1A                   call strcpy
  1186 000005ED 83C404                   add  sp, 4
  1187 000005F0 A3[4400]                 mov word [LabelNamePtr], ax
  1188                                  
  1189                                  ;-39   LabelNamePtr++;
  1190                                  
  1191 000005F3 FF06[4400]               inc  word [LabelNamePtr]
  1192                                  
  1193                                  ;-40   LabelMaxIx++;
  1194                                  
  1195 000005F7 FF06[4600]               inc  word [LabelMaxIx]
  1196                                  
  1197                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  1198                                  
  1199 000005FB A1[2A00]                 mov ax, [PC]
  1200 000005FE 8B1E[4600]               mov bx, [LabelMaxIx]
  1201 00000602 D1E3                     shl bx, 1
  1202 00000604 8987A37A                 mov [LabelAddr+bx], ax
  1203                                  
  1204                                  ;-42 }
  1205                                  
  1206                                  
  1207                                  ;-43 int searchLabel() {
  1208                                  
  1209 00000608 C3                       ret
  1210                                  ; ENDP
  1211 00000609 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  1212 00000612 206C6162656C00     
  1213                                  
  1214                                  searchLabel:  ; *** PROC ***
  1215                                  
  1216                                  ;-44   int LIx; char *p; int j;
  1217                                  
  1218                                  
  1219                                  ;-45   p = &LabelNames;
  1220                                  
  1221                                  ;Function : searchLabel, Number of local variables: 3
  1222                                  ;   # type sign width line used address name   list of local variables
  1223                                  ;  200 var sign word    44 NULL bp-2    LIx
  1224                                  ;  201 ptr sign byte    44 NULL bp-4    p
  1225                                  ;  202 var sign word    44 NULL bp-6    j;
  1226 00000619 C8060000                 ENTER  6,0
  1227 0000061D B8BB76                   mov ax, LabelNames
  1228 00000620 8946FC                   mov word [bp-4], ax
  1229                                  
  1230                                  ;-46   LIx=1;
  1231                                  
  1232 00000623 66B801000000             mov eax, 1
  1233 00000629 8946FE                   mov word [bp-2], ax
  1234                                  
  1235                                  ;-47   while (LIx <= LabelMaxIx) {
  1236                                  
  1237                                  @@searchLabel17:
  1238 0000062C 8B46FE                   mov ax, [bp-2]
  1239 0000062F 3B06[4600]               cmp ax, [LabelMaxIx]
  1240 00000633 0F8F3700                 jg  @@searchLabel18
  1241                                  
  1242                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  1243                                  
  1244 00000637 8D063075                 lea  ax, [Symbol]
  1245 0000063B 50                       push ax
  1246 0000063C FF76FC                   push word [bp-4]
  1247 0000063F E8311A                   call eqstr
  1248 00000642 83C404                   add  sp, 4
  1249 00000645 08C0                     or  al, al
  1250 00000647 0F840600                 je @@searchLabel19
  1251 0000064B 8B46FE                   mov ax, [bp-2]
  1252 0000064E E92600                   jmp @@retn
  1253                                  
  1254                                  ;-49     j=strlen(p);
  1255                                  
  1256                                  @@searchLabel19:
  1257 00000651 FF76FC                   push word [bp-4]
  1258 00000654 E88519                   call strlen
  1259 00000657 83C402                   add  sp, 2
  1260 0000065A 8946FA                   mov word [bp-6], ax
  1261                                  
  1262                                  ;-50     p=p+j; p++; LIx++;
  1263                                  
  1264 0000065D 8B46FC                   mov ax, [bp-4]
  1265 00000660 0346FA                   add ax, [bp-6]
  1266 00000663 8946FC                   mov word [bp-4], ax
  1267 00000666 FF46FC                   inc  word [bp-4]
  1268 00000669 FF46FE                   inc  word [bp-2]
  1269                                  
  1270                                  ;-51   }
  1271                                  
  1272                                  
  1273                                  ;-52   return 0;
  1274                                  
  1275 0000066C EBBE                     jmp @@searchLabel17
  1276                                  @@searchLabel18:
  1277 0000066E 66B800000000             mov eax, 0
  1278 00000674 E90000                   jmp @@retn
  1279                                  
  1280                                  ;-53 }
  1281                                  
  1282                                  
  1283                                  ;-54 int getVariable() { char c;
  1284                                  
  1285 00000677 C9                      @@retn: LEAVE
  1286 00000678 C3                       ret
  1287                                  ; ENDP
  1288                                  
  1289                                  getVariable:  ; *** PROC ***
  1290                                  
  1291                                  ;-55   storeLabel();
  1292                                  
  1293                                  ;Function : getVariable, Number of local variables: 1
  1294                                  ;   # type sign width line used address name   list of local variables
  1295                                  ;  200 var sign byte    54 NULL bp-2    c;
  1296 00000679 C8020000                 ENTER  2,0
  1297 0000067D E84FFF                   call storeLabel
  1298                                  
  1299                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  1300                                  
  1301 00000680 E8AEFE                   call getTokeType
  1302 00000683 A0[2F00]                 mov al, [TokeType]
  1303 00000686 3C03                     cmp al, 3
  1304 00000688 0F85CC00                 jne @@getVariable20
  1305                                  
  1306                                  ;-57     lookCode();
  1307                                  
  1308 0000068C E82201                   call lookCode
  1309                                  
  1310                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  1311                                  
  1312 0000068F A0[3100]                 mov al, [CodeType]
  1313 00000692 3CC8                     cmp al, 200
  1314 00000694 0F8D0900                 jge @@getVariable21
  1315 00000698 68[6307]                 push getVariable_0
  1316 0000069B E8950D                   call errorexit
  1317 0000069E 83C402                   add  sp, 2
  1318                                  
  1319                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1320                                  
  1321                                  @@getVariable21:
  1322 000006A1 A0[3100]                 mov al, [CodeType]
  1323 000006A4 3CCF                     cmp al, 207
  1324 000006A6 0F8E0900                 jle @@getVariable22
  1325 000006AA 68[7B07]                 push getVariable_1
  1326 000006AD E8830D                   call errorexit
  1327 000006B0 83C402                   add  sp, 2
  1328                                  
  1329                                  ;-60     if (CodeType== 200) {// DB
  1330                                  
  1331                                  @@getVariable22:
  1332 000006B3 A0[3100]                 mov al, [CodeType]
  1333 000006B6 3CC8                     cmp al, 200
  1334 000006B8 0F856A00                 jne @@getVariable23
  1335                                  
  1336                                  ;-61       do { getTokeType();
  1337                                  
  1338                                  @@getVariable24:
  1339 000006BC E872FE                   call getTokeType
  1340                                  
  1341                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  1342                                  
  1343 000006BF A0[2F00]                 mov al, [TokeType]
  1344 000006C2 3C01                     cmp al, 1
  1345 000006C4 0F850D00                 jne @@getVariable25
  1346 000006C8 FF36[1900]               push word [SymbolInt]
  1347 000006CC E84511                   call genCode8
  1348 000006CF 83C402                   add  sp, 2
  1349                                  
  1350                                  ;-63         else {
  1351                                  
  1352 000006D2 E94100                   jmp @@getVariable26
  1353                                  @@getVariable25:
  1354                                  
  1355                                  ;-64           skipBlank();
  1356                                  
  1357 000006D5 E83603                   call skipBlank
  1358                                  
  1359                                  ;-65           if (isToken('"')) {
  1360                                  
  1361 000006D8 6A22                     push 34
  1362 000006DA E8D101                   call isToken
  1363 000006DD 83C402                   add  sp, 2
  1364 000006E0 08C0                     or  al, al
  1365 000006E2 0F843000                 je @@getVariable27
  1366                                  
  1367                                  ;-66             do { c= *InputPtr;
  1368                                  
  1369                                  @@getVariable28:
  1370 000006E6 8B1E[1B00]               mov bx, [InputPtr]
  1371 000006EA 8A07                     mov al, [bx]
  1372 000006EC B400                     mov ah, 0
  1373 000006EE 8846FE                   mov byte [bp-2], al
  1374                                  
  1375                                  ;-67               genCode8(c);
  1376                                  
  1377 000006F1 8A46FE                   mov al, byte [bp-2]
  1378 000006F4 B400                     mov ah, 0
  1379 000006F6 50                       push ax
  1380 000006F7 E81A11                   call genCode8
  1381 000006FA 83C402                   add  sp, 2
  1382                                  
  1383                                  ;-68               InputPtr++;
  1384                                  
  1385 000006FD FF06[1B00]               inc  word [InputPtr]
  1386                                  
  1387                                  ;-69             } while (*InputPtr != '"' );
  1388                                  
  1389 00000701 8B1E[1B00]               mov bx, [InputPtr]
  1390 00000705 8A07                     mov al, [bx]
  1391 00000707 B400                     mov ah, 0
  1392 00000709 83F822                   cmp ax, 34
  1393 0000070C 0F840200                 je  @@getVariable29
  1394 00000710 EBD4                     jmp @@getVariable28
  1395                                  @@getVariable29:
  1396                                  
  1397                                  ;-70             InputPtr++;
  1398                                  
  1399 00000712 FF06[1B00]               inc  word [InputPtr]
  1400                                  
  1401                                  ;-71           }
  1402                                  
  1403                                  
  1404                                  ;-72         }
  1405                                  
  1406                                  @@getVariable27:
  1407                                  
  1408                                  ;-73       } while (isToken(','));
  1409                                  
  1410                                  @@getVariable26:
  1411 00000716 6A2C                     push 44
  1412 00000718 E89301                   call isToken
  1413 0000071B 83C402                   add  sp, 2
  1414 0000071E 08C0                     or  al, al
  1415 00000720 0F840200                 je @@getVariable30
  1416 00000724 EB96                     jmp @@getVariable24
  1417                                  @@getVariable30:
  1418                                  
  1419                                  ;-74     }
  1420                                  
  1421                                  
  1422                                  ;-75     if (CodeType== 201) {// DW
  1423                                  
  1424                                  @@getVariable23:
  1425 00000726 A0[3100]                 mov al, [CodeType]
  1426 00000729 3CC9                     cmp al, 201
  1427 0000072B 0F852600                 jne @@getVariable31
  1428                                  
  1429                                  ;-76       do { getTokeType();
  1430                                  
  1431                                  @@getVariable32:
  1432 0000072F E8FFFD                   call getTokeType
  1433                                  
  1434                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  1435                                  
  1436 00000732 A0[2F00]                 mov al, [TokeType]
  1437 00000735 3C01                     cmp al, 1
  1438 00000737 0F850A00                 jne @@getVariable33
  1439 0000073B FF36[1900]               push word [SymbolInt]
  1440 0000073F E82811                   call genCode16
  1441 00000742 83C402                   add  sp, 2
  1442                                  
  1443                                  ;-78       } while (isToken(','));
  1444                                  
  1445                                  @@getVariable33:
  1446 00000745 6A2C                     push 44
  1447 00000747 E86401                   call isToken
  1448 0000074A 83C402                   add  sp, 2
  1449 0000074D 08C0                     or  al, al
  1450 0000074F 0F840200                 je @@getVariable34
  1451 00000753 EBDA                     jmp @@getVariable32
  1452                                  @@getVariable34:
  1453                                  
  1454                                  ;-79     }
  1455                                  
  1456                                  
  1457                                  ;-80   }
  1458                                  
  1459                                  @@getVariable31:
  1460                                  
  1461                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  1462                                  
  1463 00000755 E90900                   jmp @@getVariable35
  1464                                  @@getVariable20:
  1465 00000758 68[9307]                 push getVariable_2
  1466 0000075B E8D50C                   call errorexit
  1467 0000075E 83C402                   add  sp, 2
  1468                                  
  1469                                  ;-82 }
  1470                                  
  1471                                  @@getVariable35:
  1472                                  
  1473                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  1474 00000761 C9                       LEAVE
  1475 00000762 C3                       ret
  1476                                  ; ENDP
  1477 00000763 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  1478 0000076C 422C572C4420657870-
  1479 00000775 656374656400       
  1480 0000077B 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  1481 00000784 422C572C4420657870-
  1482 0000078D 656374656400       
  1483 00000793 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  1484 0000079C 6F7220524553422C57-
  1485 000007A5 2C4420657870656374-
  1486 000007AE 656400             
  1487                                  
  1488                                  lookCode:  ; *** PROC ***
  1489                                  
  1490                                  ;-84   CodeType=0;
  1491                                  
  1492 000007B1 66B800000000             mov eax, 0
  1493 000007B7 A2[3100]                 mov byte [CodeType], al
  1494                                  
  1495                                  ;-85   OpCodePtr= &I_START;
  1496                                  
  1497 000007BA B8[5000]                 mov ax, I_START
  1498 000007BD A3[4100]                 mov word [OpCodePtr], ax
  1499                                  
  1500                                  ;-86   OpCodePtr++;
  1501                                  
  1502 000007C0 FF06[4100]               inc  word [OpCodePtr]
  1503                                  
  1504                                  ;-87   do  {
  1505                                  
  1506                                  @@lookCode36:
  1507                                  
  1508                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  1509                                  
  1510 000007C4 FF36[4100]               push word [OpCodePtr]
  1511 000007C8 8D064F75                 lea  ax, [SymbolUpper]
  1512 000007CC 50                       push ax
  1513 000007CD E8A318                   call eqstr
  1514 000007D0 83C404                   add  sp, 4
  1515 000007D3 08C0                     or  al, al
  1516 000007D5 0F842700                 je @@lookCode37
  1517                                  
  1518                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  1519                                  
  1520                                  @@lookCode38:
  1521 000007D9 8B1E[4100]               mov bx, [OpCodePtr]
  1522 000007DD 8A07                     mov al, [bx]
  1523 000007DF B400                     mov ah, 0
  1524 000007E1 83F800                   cmp ax, 0
  1525 000007E4 0F840600                 je  @@lookCode39
  1526 000007E8 FF06[4100]               inc  word [OpCodePtr]
  1527                                  
  1528                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  1529                                  
  1530 000007EC EBEB                     jmp @@lookCode38
  1531                                  @@lookCode39:
  1532 000007EE FF06[4100]               inc  word [OpCodePtr]
  1533 000007F2 8B1E[4100]               mov bx, [OpCodePtr]
  1534 000007F6 8A07                     mov al, [bx]
  1535 000007F8 B400                     mov ah, 0
  1536 000007FA A2[3100]                 mov byte [CodeType], al
  1537                                  
  1538                                  ;-91       return;
  1539                                  
  1540 000007FD E92A00                   jmp @@retn
  1541                                  
  1542                                  ;-92     }
  1543                                  
  1544                                  
  1545                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  1546                                  
  1547                                  @@lookCode37:
  1548                                  @@lookCode40:
  1549 00000800 8B1E[4100]               mov bx, [OpCodePtr]
  1550 00000804 8A07                     mov al, [bx]
  1551 00000806 B400                     mov ah, 0
  1552 00000808 3DF100                   cmp ax, 241
  1553 0000080B 0F840600                 je  @@lookCode41
  1554 0000080F FF06[4100]               inc  word [OpCodePtr]
  1555                                  
  1556                                  ;-94   OpCodePtr++;
  1557                                  
  1558 00000813 EBEB                     jmp @@lookCode40
  1559                                  @@lookCode41:
  1560 00000815 FF06[4100]               inc  word [OpCodePtr]
  1561                                  
  1562                                  ;-95   } while(*OpCodePtr!=0);
  1563                                  
  1564 00000819 8B1E[4100]               mov bx, [OpCodePtr]
  1565 0000081D 8A07                     mov al, [bx]
  1566 0000081F B400                     mov ah, 0
  1567 00000821 83F800                   cmp ax, 0
  1568 00000824 0F840200                 je  @@lookCode42
  1569 00000828 EB9A                     jmp @@lookCode36
  1570                                  @@lookCode42:
  1571                                  
  1572                                  ;-96 }
  1573                                  
  1574                                  
  1575                                  ;-97 
  1576                                  
  1577                                  
  1578                                  ;-98 int getCodeSize() {
  1579                                  
  1580                                  @@retn:
  1581 0000082A C3                       ret
  1582                                  ; ENDP
  1583                                  
  1584                                  getCodeSize:  ; *** PROC ***
  1585                                  
  1586                                  ;-99   if (TokeType ==ALNUME) {
  1587                                  
  1588 0000082B A0[2F00]                 mov al, [TokeType]
  1589 0000082E 3C03                     cmp al, 3
  1590 00000830 0F856000                 jne @@getCodeSize43
  1591                                  
  1592                                  ;-100     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1593                                  
  1594 00000834 68[9E08]                 push getCodeSize_0
  1595 00000837 8D064F75                 lea  ax, [SymbolUpper]
  1596 0000083B 50                       push ax
  1597 0000083C E83418                   call eqstr
  1598 0000083F 83C404                   add  sp, 4
  1599 00000842 08C0                     or  al, al
  1600 00000844 0F840C00                 je @@getCodeSize44
  1601 00000848 E8E6FC                   call getTokeType
  1602 0000084B 66B801000000             mov eax, 1
  1603 00000851 E94900                   jmp @@retn
  1604                                  
  1605                                  ;-101     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1606                                  
  1607                                  @@getCodeSize44:
  1608 00000854 68[A308]                 push getCodeSize_1
  1609 00000857 8D064F75                 lea  ax, [SymbolUpper]
  1610 0000085B 50                       push ax
  1611 0000085C E81418                   call eqstr
  1612 0000085F 83C404                   add  sp, 4
  1613 00000862 08C0                     or  al, al
  1614 00000864 0F840C00                 je @@getCodeSize45
  1615 00000868 E8C6FC                   call getTokeType
  1616 0000086B 66B802000000             mov eax, 2
  1617 00000871 E92900                   jmp @@retn
  1618                                  
  1619                                  ;-102     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1620                                  
  1621                                  @@getCodeSize45:
  1622 00000874 68[A808]                 push getCodeSize_2
  1623 00000877 8D064F75                 lea  ax, [SymbolUpper]
  1624 0000087B 50                       push ax
  1625 0000087C E8F417                   call eqstr
  1626 0000087F 83C404                   add  sp, 4
  1627 00000882 08C0                     or  al, al
  1628 00000884 0F840C00                 je @@getCodeSize46
  1629 00000888 E8A6FC                   call getTokeType
  1630 0000088B 66B803000000             mov eax, 3
  1631 00000891 E90900                   jmp @@retn
  1632                                  
  1633                                  ;-103   } return 0;
  1634                                  
  1635                                  @@getCodeSize46:
  1636                                  @@getCodeSize43:
  1637 00000894 66B800000000             mov eax, 0
  1638 0000089A E90000                   jmp @@retn
  1639                                  
  1640                                  ;-104 }
  1641                                  
  1642                                  
  1643                                  ;-105 int isToken(char c) {
  1644                                  
  1645                                  @@retn:
  1646 0000089D C3                       ret
  1647                                  ; ENDP
  1648 0000089E 4259544500              getCodeSize_0 db "BYTE",0
  1649 000008A3 574F524400              getCodeSize_1 db "WORD",0
  1650 000008A8 44574F524400            getCodeSize_2 db "DWORD",0
  1651                                  
  1652                                  isToken:  ; *** PROC ***
  1653                                  
  1654                                  ;-106   skipBlank();
  1655                                  
  1656                                  ;Function : isToken, Number of local variables: 1
  1657                                  ;   # type sign width line used address name   list of local variables
  1658                                  ;  200 var sign byte   105 NULL bp+4    c;
  1659 000008AE C8000000                 ENTER  0,0
  1660 000008B2 E85901                   call skipBlank
  1661                                  
  1662                                  ;-107   if (*InputPtr == c) {
  1663                                  
  1664 000008B5 8B1E[1B00]               mov bx, [InputPtr]
  1665 000008B9 8A07                     mov al, [bx]
  1666 000008BB B400                     mov ah, 0
  1667 000008BD 3A4604                   cmp al, [bp+4]
  1668 000008C0 0F850D00                 jne @@isToken47
  1669                                  
  1670                                  ;-108     InputPtr++; return 1;} return 0;
  1671                                  
  1672 000008C4 FF06[1B00]               inc  word [InputPtr]
  1673 000008C8 66B801000000             mov eax, 1
  1674 000008CE E90900                   jmp @@retn
  1675                                  @@isToken47:
  1676 000008D1 66B800000000             mov eax, 0
  1677 000008D7 E90000                   jmp @@retn
  1678                                  
  1679                                  ;-109 }
  1680                                  
  1681                                  
  1682                                  ;-110 int need(char c) {
  1683                                  
  1684 000008DA C9                      @@retn: LEAVE
  1685 000008DB C3                       ret
  1686                                  ; ENDP
  1687                                  
  1688                                  need:  ; *** PROC ***
  1689                                  
  1690                                  ;-111   if (isToken(c)) return;
  1691                                  
  1692                                  ;Function : need, Number of local variables: 1
  1693                                  ;   # type sign width line used address name   list of local variables
  1694                                  ;  200 var sign byte   110 NULL bp+4    c;
  1695 000008DC C8000000                 ENTER  0,0
  1696 000008E0 8A4604                   mov al, byte [bp+4]
  1697 000008E3 B400                     mov ah, 0
  1698 000008E5 50                       push ax
  1699 000008E6 E8C5FF                   call isToken
  1700 000008E9 83C402                   add  sp, 2
  1701 000008EC 08C0                     or  al, al
  1702 000008EE 0F840300                 je @@need48
  1703 000008F2 E91800                   jmp @@retn
  1704                                  
  1705                                  ;-112   error1();
  1706                                  
  1707                                  @@need48:
  1708 000008F5 E8A609                   call error1
  1709                                  
  1710                                  ;-113   prs(". need: ");
  1711                                  
  1712 000008F8 68[0F09]                 push need_0
  1713 000008FB E84308                   call prs
  1714 000008FE 83C402                   add  sp, 2
  1715                                  
  1716                                  ;-114   prc(c);
  1717                                  
  1718 00000901 8A4604                   mov al, byte [bp+4]
  1719 00000904 B400                     mov ah, 0
  1720 00000906 50                       push ax
  1721 00000907 E8D607                   call prc
  1722 0000090A 83C402                   add  sp, 2
  1723                                  
  1724                                  ;-115 }
  1725                                  
  1726                                  
  1727                                  ;-116 
  1728                                  
  1729                                  
  1730                                  ;-117 int skipRest() {
  1731                                  
  1732 0000090D C9                      @@retn: LEAVE
  1733 0000090E C3                       ret
  1734                                  ; ENDP
  1735 0000090F 2E206E6565643A2000      need_0 db ". need: ",0
  1736                                  
  1737                                  skipRest:  ; *** PROC ***
  1738                                  
  1739                                  ;-118   getTokeType(); 
  1740                                  
  1741 00000918 E816FC                   call getTokeType
  1742                                  
  1743                                  ;-119   if(TokeType)error1("extra char ignored");
  1744                                  
  1745 0000091B A0[2F00]                 mov al, [TokeType]
  1746 0000091E 08C0                     or  al, al
  1747 00000920 0F840900                 je @@skipRest49
  1748 00000924 68[2E09]                 push skipRest_0
  1749 00000927 E87409                   call error1
  1750 0000092A 83C402                   add  sp, 2
  1751                                  
  1752                                  ;-120 }
  1753                                  
  1754                                  @@skipRest49:
  1755 0000092D C3                       ret
  1756                                  ; ENDP
  1757 0000092E 657874726120636861-     skipRest_0 db "extra char ignored",0
  1758 00000937 722069676E6F726564-
  1759 00000940 00                 
  1760                                  ;Back to main program: AS.C
  1761                                  
  1762                                  ;-6 #include "HELPER.C"
  1763                                  
  1764                                  ;Use include file: HELPER.C
  1765                                  
  1766                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  1767                                  
  1768                                  
  1769                                  getLine:  ; *** PROC ***
  1770                                  
  1771                                  ;-2   InputPtr= &InputBuf;
  1772                                  
  1773 00000941 B86E75                   mov ax, InputBuf
  1774 00000944 A3[1B00]                 mov word [InputPtr], ax
  1775                                  
  1776                                  ;-3   *InputPtr=0;//if last line is empty
  1777                                  
  1778 00000947 66B800000000             mov eax, 0
  1779 0000094D 8B1E[1B00]               mov  bx, [InputPtr]
  1780 00000951 8807                     mov  [bx], al
  1781                                  
  1782                                  ;-4   do {
  1783                                  
  1784                                  @@getLine50:
  1785                                  
  1786                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1787                                  
  1788 00000953 6A01                     push 1
  1789 00000955 FF36[1D00]               push word [asm_fd]
  1790 00000959 8D06[2900]               lea  ax, [DOS_ByteRead]
  1791 0000095D 50                       push ax
  1792 0000095E E8AD17                   call readRL
  1793 00000961 83C406                   add  sp, 6
  1794 00000964 A3[2700]                 mov word [DOS_NoBytes], ax
  1795                                  
  1796                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  1797                                  
  1798 00000967 A1[2300]                 mov ax, [DOS_ERR]
  1799 0000096A 08C0                     or  al, al
  1800 0000096C 0F840900                 je @@getLine51
  1801 00000970 68[B809]                 push getLine_0
  1802 00000973 E8BD0A                   call errorexit
  1803 00000976 83C402                   add  sp, 2
  1804                                  
  1805                                  ;-7     if (DOS_NoBytes == 0) return;
  1806                                  
  1807                                  @@getLine51:
  1808 00000979 A1[2700]                 mov ax, [DOS_NoBytes]
  1809 0000097C 83F800                   cmp ax, 0
  1810 0000097F 0F850300                 jne @@getLine52
  1811 00000983 E93100                   jmp @@retn
  1812                                  
  1813                                  ;-8     *InputPtr = DOS_ByteRead;
  1814                                  
  1815                                  @@getLine52:
  1816 00000986 A0[2900]                 mov al, [DOS_ByteRead]
  1817 00000989 8B1E[1B00]               mov  bx, [InputPtr]
  1818 0000098D 8807                     mov  [bx], al
  1819                                  
  1820                                  ;-9     InputPtr++;
  1821                                  
  1822 0000098F FF06[1B00]               inc  word [InputPtr]
  1823                                  
  1824                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  1825                                  
  1826 00000993 A0[2900]                 mov al, byte [DOS_ByteRead]
  1827 00000996 B400                     mov ah, 0
  1828 00000998 50                       push ax
  1829 00000999 E82B00                   call ifEOL
  1830 0000099C 83C402                   add  sp, 2
  1831 0000099F 3C00                     cmp al, 0
  1832 000009A1 0F850200                 jne @@getLine53
  1833 000009A5 EBAC                     jmp @@getLine50
  1834                                  @@getLine53:
  1835                                  
  1836                                  ;-11   InputPtr--;
  1837                                  
  1838 000009A7 FF0E[1B00]               dec  word [InputPtr]
  1839                                  
  1840                                  ;-12   *InputPtr=0;
  1841                                  
  1842 000009AB 66B800000000             mov eax, 0
  1843 000009B1 8B1E[1B00]               mov  bx, [InputPtr]
  1844 000009B5 8807                     mov  [bx], al
  1845                                  
  1846                                  ;-13 }
  1847                                  
  1848                                  
  1849                                  ;-14 int ifEOL(char c) {
  1850                                  
  1851                                  @@retn:
  1852 000009B7 C3                       ret
  1853                                  ; ENDP
  1854 000009B8 52656164696E672053-     getLine_0 db "Reading Source",0
  1855 000009C1 6F7572636500       
  1856                                  
  1857                                  ifEOL:  ; *** PROC ***
  1858                                  
  1859                                  ;-15   if (c == 10) return 1;
  1860                                  
  1861                                  ;Function : ifEOL, Number of local variables: 1
  1862                                  ;   # type sign width line used address name   list of local variables
  1863                                  ;  200 var sign byte    14 NULL bp+4    c;
  1864 000009C7 C8000000                 ENTER  0,0
  1865 000009CB 8A4604                   mov al, [bp+4]
  1866 000009CE 3C0A                     cmp al, 10
  1867 000009D0 0F850900                 jne @@ifEOL54
  1868 000009D4 66B801000000             mov eax, 1
  1869 000009DA E92F00                   jmp @@retn
  1870                                  
  1871                                  ;-16   if (c == 13) {
  1872                                  
  1873                                  @@ifEOL54:
  1874 000009DD 8A4604                   mov al, [bp+4]
  1875 000009E0 3C0D                     cmp al, 13
  1876 000009E2 0F851D00                 jne @@ifEOL55
  1877                                  
  1878                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1879                                  
  1880 000009E6 6A01                     push 1
  1881 000009E8 FF36[1D00]               push word [asm_fd]
  1882 000009EC 8D06[2900]               lea  ax, [DOS_ByteRead]
  1883 000009F0 50                       push ax
  1884 000009F1 E81A17                   call readRL
  1885 000009F4 83C406                   add  sp, 6
  1886 000009F7 A3[2700]                 mov word [DOS_NoBytes], ax
  1887                                  
  1888                                  ;-18     return 1;}
  1889                                  
  1890 000009FA 66B801000000             mov eax, 1
  1891 00000A00 E90900                   jmp @@retn
  1892                                  
  1893                                  ;-19   return 0;
  1894                                  
  1895                                  @@ifEOL55:
  1896 00000A03 66B800000000             mov eax, 0
  1897 00000A09 E90000                   jmp @@retn
  1898                                  
  1899                                  ;-20 }
  1900                                  
  1901                                  
  1902                                  ;-21 int skipBlank() {
  1903                                  
  1904 00000A0C C9                      @@retn: LEAVE
  1905 00000A0D C3                       ret
  1906                                  ; ENDP
  1907                                  
  1908                                  skipBlank:  ; *** PROC ***
  1909                                  
  1910                                  ;-22   skipblank1:
  1911                                  
  1912                                  @@skipblank1:
  1913                                  
  1914                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  1915                                  
  1916 00000A0E 8B1E[1B00]               mov bx, [InputPtr]
  1917 00000A12 8A07                     mov al, [bx]
  1918 00000A14 B400                     mov ah, 0
  1919 00000A16 83F820                   cmp ax, 32
  1920 00000A19 0F850600                 jne @@skipBlank56
  1921 00000A1D FF06[1B00]               inc  word [InputPtr]
  1922 00000A21 EBEB                     jmp @@skipblank1
  1923                                  
  1924                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  1925                                  
  1926                                  @@skipBlank56:
  1927 00000A23 8B1E[1B00]               mov bx, [InputPtr]
  1928 00000A27 8A07                     mov al, [bx]
  1929 00000A29 B400                     mov ah, 0
  1930 00000A2B 83F809                   cmp ax, 9
  1931 00000A2E 0F850600                 jne @@skipBlank57
  1932 00000A32 FF06[1B00]               inc  word [InputPtr]
  1933 00000A36 EBD6                     jmp @@skipblank1
  1934                                  
  1935                                  ;-25 }
  1936                                  
  1937                                  @@skipBlank57:
  1938                                  
  1939                                  ;-26 int letterE(char c) {
  1940                                  
  1941 00000A38 C3                       ret
  1942                                  ; ENDP
  1943                                  
  1944                                  letterE:  ; *** PROC ***
  1945                                  
  1946                                  ;-27   if (c=='_') return 1;
  1947                                  
  1948                                  ;Function : letterE, Number of local variables: 1
  1949                                  ;   # type sign width line used address name   list of local variables
  1950                                  ;  200 var sign byte    26 NULL bp+4    c;
  1951 00000A39 C8000000                 ENTER  0,0
  1952 00000A3D 8A4604                   mov al, [bp+4]
  1953 00000A40 3C5F                     cmp al, 95
  1954 00000A42 0F850900                 jne @@letterE58
  1955 00000A46 66B801000000             mov eax, 1
  1956 00000A4C E97E00                   jmp @@retn
  1957                                  
  1958                                  ;-28   if (c=='.') return 1;
  1959                                  
  1960                                  @@letterE58:
  1961 00000A4F 8A4604                   mov al, [bp+4]
  1962 00000A52 3C2E                     cmp al, 46
  1963 00000A54 0F850900                 jne @@letterE59
  1964 00000A58 66B801000000             mov eax, 1
  1965 00000A5E E96C00                   jmp @@retn
  1966                                  
  1967                                  ;-29   if (c=='?') return 1;
  1968                                  
  1969                                  @@letterE59:
  1970 00000A61 8A4604                   mov al, [bp+4]
  1971 00000A64 3C3F                     cmp al, 63
  1972 00000A66 0F850900                 jne @@letterE60
  1973 00000A6A 66B801000000             mov eax, 1
  1974 00000A70 E95A00                   jmp @@retn
  1975                                  
  1976                                  ;-30   if (c=='$') return 1;
  1977                                  
  1978                                  @@letterE60:
  1979 00000A73 8A4604                   mov al, [bp+4]
  1980 00000A76 3C24                     cmp al, 36
  1981 00000A78 0F850900                 jne @@letterE61
  1982 00000A7C 66B801000000             mov eax, 1
  1983 00000A82 E94800                   jmp @@retn
  1984                                  
  1985                                  ;-31   if (c> 'z') return 0;
  1986                                  
  1987                                  @@letterE61:
  1988 00000A85 8A4604                   mov al, [bp+4]
  1989 00000A88 3C7A                     cmp al, 122
  1990 00000A8A 0F8E0900                 jle @@letterE62
  1991 00000A8E 66B800000000             mov eax, 0
  1992 00000A94 E93600                   jmp @@retn
  1993                                  
  1994                                  ;-32   if (c< '@') return 0; // at included
  1995                                  
  1996                                  @@letterE62:
  1997 00000A97 8A4604                   mov al, [bp+4]
  1998 00000A9A 3C40                     cmp al, 64
  1999 00000A9C 0F8D0900                 jge @@letterE63
  2000 00000AA0 66B800000000             mov eax, 0
  2001 00000AA6 E92400                   jmp @@retn
  2002                                  
  2003                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  2004                                  
  2005                                  @@letterE63:
  2006 00000AA9 8A4604                   mov al, [bp+4]
  2007 00000AAC 3C5A                     cmp al, 90
  2008 00000AAE 0F8E1200                 jle @@letterE64
  2009 00000AB2 8A4604                   mov al, [bp+4]
  2010 00000AB5 3C61                     cmp al, 97
  2011 00000AB7 0F8D0900                 jge @@letterE65
  2012 00000ABB 66B800000000             mov eax, 0
  2013 00000AC1 E90900                   jmp @@retn
  2014                                  @@letterE65:
  2015                                  
  2016                                  ;-34   return 1;
  2017                                  
  2018                                  @@letterE64:
  2019 00000AC4 66B801000000             mov eax, 1
  2020 00000ACA E90000                   jmp @@retn
  2021                                  
  2022                                  ;-35 }
  2023                                  
  2024                                  
  2025                                  ;-36 int alnumE(char c) {
  2026                                  
  2027 00000ACD C9                      @@retn: LEAVE
  2028 00000ACE C3                       ret
  2029                                  ; ENDP
  2030                                  
  2031                                  alnumE:  ; *** PROC ***
  2032                                  
  2033                                  ;-37   if (digit(c)) return 1;
  2034                                  
  2035                                  ;Function : alnumE, Number of local variables: 1
  2036                                  ;   # type sign width line used address name   list of local variables
  2037                                  ;  200 var sign byte    36 NULL bp+4    c;
  2038 00000ACF C8000000                 ENTER  0,0
  2039 00000AD3 8A4604                   mov al, byte [bp+4]
  2040 00000AD6 B400                     mov ah, 0
  2041 00000AD8 50                       push ax
  2042 00000AD9 E86415                   call digit
  2043 00000ADC 83C402                   add  sp, 2
  2044 00000ADF 08C0                     or  al, al
  2045 00000AE1 0F840900                 je @@alnumE66
  2046 00000AE5 66B801000000             mov eax, 1
  2047 00000AEB E92400                   jmp @@retn
  2048                                  
  2049                                  ;-38   if (letterE(c)) return 1;
  2050                                  
  2051                                  @@alnumE66:
  2052 00000AEE 8A4604                   mov al, byte [bp+4]
  2053 00000AF1 B400                     mov ah, 0
  2054 00000AF3 50                       push ax
  2055 00000AF4 E842FF                   call letterE
  2056 00000AF7 83C402                   add  sp, 2
  2057 00000AFA 08C0                     or  al, al
  2058 00000AFC 0F840900                 je @@alnumE67
  2059 00000B00 66B801000000             mov eax, 1
  2060 00000B06 E90900                   jmp @@retn
  2061                                  
  2062                                  ;-39   return 0;
  2063                                  
  2064                                  @@alnumE67:
  2065 00000B09 66B800000000             mov eax, 0
  2066 00000B0F E90000                   jmp @@retn
  2067                                  
  2068                                  ;-40 }
  2069                                  
  2070                                  
  2071                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  2072                                  
  2073 00000B12 C9                      @@retn: LEAVE
  2074 00000B13 C3                       ret
  2075                                  ; ENDP
  2076                                  
  2077                                  getDigit:  ; *** PROC ***
  2078                                  
  2079                                  ;-42   unsigned int CastInt;
  2080                                  
  2081                                  
  2082                                  ;-43   SymbolInt=0;
  2083                                  
  2084                                  ;Function : getDigit, Number of local variables: 2
  2085                                  ;   # type sign width line used address name   list of local variables
  2086                                  ;  200 var unsg byte    41 NULL bp+4    c
  2087                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  2088 00000B14 C8020000                 ENTER  2,0
  2089 00000B18 66B800000000             mov eax, 0
  2090 00000B1E A3[1900]                 mov word [SymbolInt], ax
  2091                                  
  2092                                  ;-44   do {
  2093                                  
  2094                                  @@getDigit68:
  2095                                  
  2096                                  ;-45     c-='0';
  2097                                  
  2098 00000B21 806E0430                 sub  byte [bp+4], 48
  2099                                  
  2100                                  ;-46     SymbolInt=SymbolInt*10;
  2101                                  
  2102 00000B25 A1[1900]                 mov ax, [SymbolInt]
  2103 00000B28 66BB0A000000             mov ebx, 10
  2104 00000B2E 66F7E3                   mul ebx
  2105 00000B31 A3[1900]                 mov word [SymbolInt], ax
  2106                                  
  2107                                  ;-47     ax=0; CastInt=c; //cast b2w
  2108                                  
  2109 00000B34 B80000                   mov  ax, 0
  2110 00000B37 8A4604                   mov al, [bp+4]
  2111 00000B3A 8946FE                   mov word [bp-2], ax
  2112                                  
  2113                                  ;-48     SymbolInt=SymbolInt+CastInt;
  2114                                  
  2115 00000B3D A1[1900]                 mov ax, [SymbolInt]
  2116 00000B40 0346FE                   add ax, [bp-2]
  2117 00000B43 A3[1900]                 mov word [SymbolInt], ax
  2118                                  
  2119                                  ;-49     InputPtr++;
  2120                                  
  2121 00000B46 FF06[1B00]               inc  word [InputPtr]
  2122                                  
  2123                                  ;-50     c = *InputPtr;
  2124                                  
  2125 00000B4A 8B1E[1B00]               mov bx, [InputPtr]
  2126 00000B4E 8A07                     mov al, [bx]
  2127 00000B50 B400                     mov ah, 0
  2128 00000B52 884604                   mov byte [bp+4], al
  2129                                  
  2130                                  ;-51   } while(digit(c));
  2131                                  
  2132 00000B55 8A4604                   mov al, byte [bp+4]
  2133 00000B58 B400                     mov ah, 0
  2134 00000B5A 50                       push ax
  2135 00000B5B E8E214                   call digit
  2136 00000B5E 83C402                   add  sp, 2
  2137 00000B61 08C0                     or  al, al
  2138 00000B63 0F840200                 je @@getDigit69
  2139 00000B67 EBB8                     jmp @@getDigit68
  2140                                  @@getDigit69:
  2141                                  
  2142                                  ;-52 }
  2143                                  
  2144                                  
  2145                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2146 00000B69 C9                       LEAVE
  2147 00000B6A C3                       ret
  2148                                  ; ENDP
  2149                                  
  2150                                  getName:  ; *** PROC ***
  2151                                  
  2152                                  ;-54   char *p;
  2153                                  
  2154                                  
  2155                                  ;-55   p = &Symbol;
  2156                                  
  2157                                  ;Function : getName, Number of local variables: 2
  2158                                  ;   # type sign width line used address name   list of local variables
  2159                                  ;  200 var unsg byte    53 NULL bp+4    c
  2160                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  2161 00000B6B C8020000                 ENTER  2,0
  2162 00000B6F B83075                   mov ax, Symbol
  2163 00000B72 8946FE                   mov word [bp-2], ax
  2164                                  
  2165                                  ;-56   *p = c;
  2166                                  
  2167 00000B75 8A4604                   mov al, [bp+4]
  2168 00000B78 8B5EFE                   mov  bx, [bp-2]
  2169 00000B7B 8807                     mov  [bx], al
  2170                                  
  2171                                  ;-57   p++;
  2172                                  
  2173 00000B7D FF46FE                   inc  word [bp-2]
  2174                                  
  2175                                  ;-58   while (alnumE(c)) {
  2176                                  
  2177                                  @@getName70:
  2178 00000B80 8A4604                   mov al, byte [bp+4]
  2179 00000B83 B400                     mov ah, 0
  2180 00000B85 50                       push ax
  2181 00000B86 E846FF                   call alnumE
  2182 00000B89 83C402                   add  sp, 2
  2183 00000B8C 08C0                     or  al, al
  2184 00000B8E 0F841C00                 je @@getName71
  2185                                  
  2186                                  ;-59     InputPtr++;
  2187                                  
  2188 00000B92 FF06[1B00]               inc  word [InputPtr]
  2189                                  
  2190                                  ;-60     c = *InputPtr;
  2191                                  
  2192 00000B96 8B1E[1B00]               mov bx, [InputPtr]
  2193 00000B9A 8A07                     mov al, [bx]
  2194 00000B9C B400                     mov ah, 0
  2195 00000B9E 884604                   mov byte [bp+4], al
  2196                                  
  2197                                  ;-61     *p = c;
  2198                                  
  2199 00000BA1 8A4604                   mov al, [bp+4]
  2200 00000BA4 8B5EFE                   mov  bx, [bp-2]
  2201 00000BA7 8807                     mov  [bx], al
  2202                                  
  2203                                  ;-62     p++;
  2204                                  
  2205 00000BA9 FF46FE                   inc  word [bp-2]
  2206                                  
  2207                                  ;-63   }
  2208                                  
  2209                                  
  2210                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  2211                                  
  2212 00000BAC EBD2                     jmp @@getName70
  2213                                  @@getName71:
  2214 00000BAE 8A4604                   mov al, [bp+4]
  2215 00000BB1 3C3A                     cmp al, 58
  2216 00000BB3 0F850C00                 jne @@getName72
  2217 00000BB7 66B801000000             mov eax, 1
  2218 00000BBD A2[2E00]                 mov byte [isLabel], al
  2219 00000BC0 E90900                   jmp @@getName73
  2220                                  @@getName72:
  2221 00000BC3 66B800000000             mov eax, 0
  2222 00000BC9 A2[2E00]                 mov byte [isLabel], al
  2223                                  
  2224                                  ;-65   p--;
  2225                                  
  2226                                  @@getName73:
  2227 00000BCC FF4EFE                   dec  word [bp-2]
  2228                                  
  2229                                  ;-66   *p = 0;
  2230                                  
  2231 00000BCF 66B800000000             mov eax, 0
  2232 00000BD5 8B5EFE                   mov  bx, [bp-2]
  2233 00000BD8 8807                     mov  [bx], al
  2234                                  
  2235                                  ;-67   strcpy(SymbolUpper, Symbol);
  2236                                  
  2237 00000BDA 8D063075                 lea  ax, [Symbol]
  2238 00000BDE 50                       push ax
  2239 00000BDF 8D064F75                 lea  ax, [SymbolUpper]
  2240 00000BE3 50                       push ax
  2241 00000BE4 E82014                   call strcpy
  2242 00000BE7 83C404                   add  sp, 4
  2243                                  
  2244                                  ;-68   toupper(SymbolUpper);
  2245                                  
  2246 00000BEA 8D064F75                 lea  ax, [SymbolUpper]
  2247 00000BEE 50                       push ax
  2248 00000BEF E8A713                   call toupper
  2249 00000BF2 83C402                   add  sp, 2
  2250                                  
  2251                                  ;-69 }
  2252                                  
  2253                                  
  2254                                  ;-70 int testReg() {
  2255 00000BF5 C9                       LEAVE
  2256 00000BF6 C3                       ret
  2257                                  ; ENDP
  2258                                  
  2259                                  testReg:  ; *** PROC ***
  2260                                  
  2261                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2262                                  
  2263                                  
  2264                                  ;-72   RegType=0;
  2265                                  
  2266 00000BF7 66B800000000             mov eax, 0
  2267 00000BFD A2[3500]                 mov byte [RegType], al
  2268                                  
  2269                                  ;-73   if (strlen(Symbol) < 2) return 0;
  2270                                  
  2271 00000C00 8D063075                 lea  ax, [Symbol]
  2272 00000C04 50                       push ax
  2273 00000C05 E8D413                   call strlen
  2274 00000C08 83C402                   add  sp, 2
  2275 00000C0B 3C02                     cmp al, 2
  2276 00000C0D 0F8D0900                 jge @@testReg74
  2277 00000C11 66B800000000             mov eax, 0
  2278 00000C17 E9B603                   jmp @@retn
  2279                                  
  2280                                  ;-74   if (strlen(Symbol) > 3) return 0;
  2281                                  
  2282                                  @@testReg74:
  2283 00000C1A 8D063075                 lea  ax, [Symbol]
  2284 00000C1E 50                       push ax
  2285 00000C1F E8BA13                   call strlen
  2286 00000C22 83C402                   add  sp, 2
  2287 00000C25 3C03                     cmp al, 3
  2288 00000C27 0F8E0900                 jle @@testReg75
  2289 00000C2B 66B800000000             mov eax, 0
  2290 00000C31 E99C03                   jmp @@retn
  2291                                  
  2292                                  ;-75   RegType=BYTE;
  2293                                  
  2294                                  @@testReg75:
  2295 00000C34 66B801000000             mov eax, 1
  2296 00000C3A A2[3500]                 mov byte [RegType], al
  2297                                  
  2298                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  2299                                  
  2300 00000C3D 68[D10F]                 push testReg_0
  2301 00000C40 8D064F75                 lea  ax, [SymbolUpper]
  2302 00000C44 50                       push ax
  2303 00000C45 E82B14                   call eqstr
  2304 00000C48 83C404                   add  sp, 4
  2305 00000C4B 08C0                     or  al, al
  2306 00000C4D 0F840900                 je @@testReg76
  2307 00000C51 66B800000000             mov eax, 0
  2308 00000C57 E97603                   jmp @@retn
  2309                                  
  2310                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  2311                                  
  2312                                  @@testReg76:
  2313 00000C5A 68[D40F]                 push testReg_1
  2314 00000C5D 8D064F75                 lea  ax, [SymbolUpper]
  2315 00000C61 50                       push ax
  2316 00000C62 E80E14                   call eqstr
  2317 00000C65 83C404                   add  sp, 4
  2318 00000C68 08C0                     or  al, al
  2319 00000C6A 0F840900                 je @@testReg77
  2320 00000C6E 66B801000000             mov eax, 1
  2321 00000C74 E95903                   jmp @@retn
  2322                                  
  2323                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  2324                                  
  2325                                  @@testReg77:
  2326 00000C77 68[D70F]                 push testReg_2
  2327 00000C7A 8D064F75                 lea  ax, [SymbolUpper]
  2328 00000C7E 50                       push ax
  2329 00000C7F E8F113                   call eqstr
  2330 00000C82 83C404                   add  sp, 4
  2331 00000C85 08C0                     or  al, al
  2332 00000C87 0F840900                 je @@testReg78
  2333 00000C8B 66B802000000             mov eax, 2
  2334 00000C91 E93C03                   jmp @@retn
  2335                                  
  2336                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  2337                                  
  2338                                  @@testReg78:
  2339 00000C94 68[DA0F]                 push testReg_3
  2340 00000C97 8D064F75                 lea  ax, [SymbolUpper]
  2341 00000C9B 50                       push ax
  2342 00000C9C E8D413                   call eqstr
  2343 00000C9F 83C404                   add  sp, 4
  2344 00000CA2 08C0                     or  al, al
  2345 00000CA4 0F840900                 je @@testReg79
  2346 00000CA8 66B803000000             mov eax, 3
  2347 00000CAE E91F03                   jmp @@retn
  2348                                  
  2349                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  2350                                  
  2351                                  @@testReg79:
  2352 00000CB1 68[DD0F]                 push testReg_4
  2353 00000CB4 8D064F75                 lea  ax, [SymbolUpper]
  2354 00000CB8 50                       push ax
  2355 00000CB9 E8B713                   call eqstr
  2356 00000CBC 83C404                   add  sp, 4
  2357 00000CBF 08C0                     or  al, al
  2358 00000CC1 0F840900                 je @@testReg80
  2359 00000CC5 66B804000000             mov eax, 4
  2360 00000CCB E90203                   jmp @@retn
  2361                                  
  2362                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  2363                                  
  2364                                  @@testReg80:
  2365 00000CCE 68[E00F]                 push testReg_5
  2366 00000CD1 8D064F75                 lea  ax, [SymbolUpper]
  2367 00000CD5 50                       push ax
  2368 00000CD6 E89A13                   call eqstr
  2369 00000CD9 83C404                   add  sp, 4
  2370 00000CDC 08C0                     or  al, al
  2371 00000CDE 0F840900                 je @@testReg81
  2372 00000CE2 66B805000000             mov eax, 5
  2373 00000CE8 E9E502                   jmp @@retn
  2374                                  
  2375                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  2376                                  
  2377                                  @@testReg81:
  2378 00000CEB 68[E30F]                 push testReg_6
  2379 00000CEE 8D064F75                 lea  ax, [SymbolUpper]
  2380 00000CF2 50                       push ax
  2381 00000CF3 E87D13                   call eqstr
  2382 00000CF6 83C404                   add  sp, 4
  2383 00000CF9 08C0                     or  al, al
  2384 00000CFB 0F840900                 je @@testReg82
  2385 00000CFF 66B806000000             mov eax, 6
  2386 00000D05 E9C802                   jmp @@retn
  2387                                  
  2388                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  2389                                  
  2390                                  @@testReg82:
  2391 00000D08 68[E60F]                 push testReg_7
  2392 00000D0B 8D064F75                 lea  ax, [SymbolUpper]
  2393 00000D0F 50                       push ax
  2394 00000D10 E86013                   call eqstr
  2395 00000D13 83C404                   add  sp, 4
  2396 00000D16 08C0                     or  al, al
  2397 00000D18 0F840900                 je @@testReg83
  2398 00000D1C 66B807000000             mov eax, 7
  2399 00000D22 E9AB02                   jmp @@retn
  2400                                  
  2401                                  ;-84   RegType=WORD;
  2402                                  
  2403                                  @@testReg83:
  2404 00000D25 66B802000000             mov eax, 2
  2405 00000D2B A2[3500]                 mov byte [RegType], al
  2406                                  
  2407                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  2408                                  
  2409 00000D2E 68[E90F]                 push testReg_8
  2410 00000D31 8D064F75                 lea  ax, [SymbolUpper]
  2411 00000D35 50                       push ax
  2412 00000D36 E83A13                   call eqstr
  2413 00000D39 83C404                   add  sp, 4
  2414 00000D3C 08C0                     or  al, al
  2415 00000D3E 0F840900                 je @@testReg84
  2416 00000D42 66B800000000             mov eax, 0
  2417 00000D48 E98502                   jmp @@retn
  2418                                  
  2419                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  2420                                  
  2421                                  @@testReg84:
  2422 00000D4B 68[EC0F]                 push testReg_9
  2423 00000D4E 8D064F75                 lea  ax, [SymbolUpper]
  2424 00000D52 50                       push ax
  2425 00000D53 E81D13                   call eqstr
  2426 00000D56 83C404                   add  sp, 4
  2427 00000D59 08C0                     or  al, al
  2428 00000D5B 0F840900                 je @@testReg85
  2429 00000D5F 66B801000000             mov eax, 1
  2430 00000D65 E96802                   jmp @@retn
  2431                                  
  2432                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  2433                                  
  2434                                  @@testReg85:
  2435 00000D68 68[EF0F]                 push testReg_10
  2436 00000D6B 8D064F75                 lea  ax, [SymbolUpper]
  2437 00000D6F 50                       push ax
  2438 00000D70 E80013                   call eqstr
  2439 00000D73 83C404                   add  sp, 4
  2440 00000D76 08C0                     or  al, al
  2441 00000D78 0F840900                 je @@testReg86
  2442 00000D7C 66B802000000             mov eax, 2
  2443 00000D82 E94B02                   jmp @@retn
  2444                                  
  2445                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  2446                                  
  2447                                  @@testReg86:
  2448 00000D85 68[F20F]                 push testReg_11
  2449 00000D88 8D064F75                 lea  ax, [SymbolUpper]
  2450 00000D8C 50                       push ax
  2451 00000D8D E8E312                   call eqstr
  2452 00000D90 83C404                   add  sp, 4
  2453 00000D93 08C0                     or  al, al
  2454 00000D95 0F840900                 je @@testReg87
  2455 00000D99 66B803000000             mov eax, 3
  2456 00000D9F E92E02                   jmp @@retn
  2457                                  
  2458                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  2459                                  
  2460                                  @@testReg87:
  2461 00000DA2 68[F50F]                 push testReg_12
  2462 00000DA5 8D064F75                 lea  ax, [SymbolUpper]
  2463 00000DA9 50                       push ax
  2464 00000DAA E8C612                   call eqstr
  2465 00000DAD 83C404                   add  sp, 4
  2466 00000DB0 08C0                     or  al, al
  2467 00000DB2 0F840900                 je @@testReg88
  2468 00000DB6 66B804000000             mov eax, 4
  2469 00000DBC E91102                   jmp @@retn
  2470                                  
  2471                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  2472                                  
  2473                                  @@testReg88:
  2474 00000DBF 68[F80F]                 push testReg_13
  2475 00000DC2 8D064F75                 lea  ax, [SymbolUpper]
  2476 00000DC6 50                       push ax
  2477 00000DC7 E8A912                   call eqstr
  2478 00000DCA 83C404                   add  sp, 4
  2479 00000DCD 08C0                     or  al, al
  2480 00000DCF 0F840900                 je @@testReg89
  2481 00000DD3 66B805000000             mov eax, 5
  2482 00000DD9 E9F401                   jmp @@retn
  2483                                  
  2484                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  2485                                  
  2486                                  @@testReg89:
  2487 00000DDC 68[FB0F]                 push testReg_14
  2488 00000DDF 8D064F75                 lea  ax, [SymbolUpper]
  2489 00000DE3 50                       push ax
  2490 00000DE4 E88C12                   call eqstr
  2491 00000DE7 83C404                   add  sp, 4
  2492 00000DEA 08C0                     or  al, al
  2493 00000DEC 0F840900                 je @@testReg90
  2494 00000DF0 66B806000000             mov eax, 6
  2495 00000DF6 E9D701                   jmp @@retn
  2496                                  
  2497                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  2498                                  
  2499                                  @@testReg90:
  2500 00000DF9 68[FE0F]                 push testReg_15
  2501 00000DFC 8D064F75                 lea  ax, [SymbolUpper]
  2502 00000E00 50                       push ax
  2503 00000E01 E86F12                   call eqstr
  2504 00000E04 83C404                   add  sp, 4
  2505 00000E07 08C0                     or  al, al
  2506 00000E09 0F840900                 je @@testReg91
  2507 00000E0D 66B807000000             mov eax, 7
  2508 00000E13 E9BA01                   jmp @@retn
  2509                                  
  2510                                  ;-93   RegType=SEGREG;
  2511                                  
  2512                                  @@testReg91:
  2513 00000E16 66B804000000             mov eax, 4
  2514 00000E1C A2[3500]                 mov byte [RegType], al
  2515                                  
  2516                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  2517                                  
  2518 00000E1F 68[0110]                 push testReg_16
  2519 00000E22 8D064F75                 lea  ax, [SymbolUpper]
  2520 00000E26 50                       push ax
  2521 00000E27 E84912                   call eqstr
  2522 00000E2A 83C404                   add  sp, 4
  2523 00000E2D 08C0                     or  al, al
  2524 00000E2F 0F840900                 je @@testReg92
  2525 00000E33 66B800000000             mov eax, 0
  2526 00000E39 E99401                   jmp @@retn
  2527                                  
  2528                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  2529                                  
  2530                                  @@testReg92:
  2531 00000E3C 68[0410]                 push testReg_17
  2532 00000E3F 8D064F75                 lea  ax, [SymbolUpper]
  2533 00000E43 50                       push ax
  2534 00000E44 E82C12                   call eqstr
  2535 00000E47 83C404                   add  sp, 4
  2536 00000E4A 08C0                     or  al, al
  2537 00000E4C 0F840900                 je @@testReg93
  2538 00000E50 66B801000000             mov eax, 1
  2539 00000E56 E97701                   jmp @@retn
  2540                                  
  2541                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  2542                                  
  2543                                  @@testReg93:
  2544 00000E59 68[0710]                 push testReg_18
  2545 00000E5C 8D064F75                 lea  ax, [SymbolUpper]
  2546 00000E60 50                       push ax
  2547 00000E61 E80F12                   call eqstr
  2548 00000E64 83C404                   add  sp, 4
  2549 00000E67 08C0                     or  al, al
  2550 00000E69 0F840900                 je @@testReg94
  2551 00000E6D 66B802000000             mov eax, 2
  2552 00000E73 E95A01                   jmp @@retn
  2553                                  
  2554                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  2555                                  
  2556                                  @@testReg94:
  2557 00000E76 68[0A10]                 push testReg_19
  2558 00000E79 8D064F75                 lea  ax, [SymbolUpper]
  2559 00000E7D 50                       push ax
  2560 00000E7E E8F211                   call eqstr
  2561 00000E81 83C404                   add  sp, 4
  2562 00000E84 08C0                     or  al, al
  2563 00000E86 0F840900                 je @@testReg95
  2564 00000E8A 66B803000000             mov eax, 3
  2565 00000E90 E93D01                   jmp @@retn
  2566                                  
  2567                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  2568                                  
  2569                                  @@testReg95:
  2570 00000E93 68[0D10]                 push testReg_20
  2571 00000E96 8D064F75                 lea  ax, [SymbolUpper]
  2572 00000E9A 50                       push ax
  2573 00000E9B E8D511                   call eqstr
  2574 00000E9E 83C404                   add  sp, 4
  2575 00000EA1 08C0                     or  al, al
  2576 00000EA3 0F840900                 je @@testReg96
  2577 00000EA7 66B804000000             mov eax, 4
  2578 00000EAD E92001                   jmp @@retn
  2579                                  
  2580                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  2581                                  
  2582                                  @@testReg96:
  2583 00000EB0 68[1010]                 push testReg_21
  2584 00000EB3 8D064F75                 lea  ax, [SymbolUpper]
  2585 00000EB7 50                       push ax
  2586 00000EB8 E8B811                   call eqstr
  2587 00000EBB 83C404                   add  sp, 4
  2588 00000EBE 08C0                     or  al, al
  2589 00000EC0 0F840900                 je @@testReg97
  2590 00000EC4 66B805000000             mov eax, 5
  2591 00000ECA E90301                   jmp @@retn
  2592                                  
  2593                                  ;-100   RegType=DWORD;
  2594                                  
  2595                                  @@testReg97:
  2596 00000ECD 66B803000000             mov eax, 3
  2597 00000ED3 A2[3500]                 mov byte [RegType], al
  2598                                  
  2599                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  2600                                  
  2601 00000ED6 68[1310]                 push testReg_22
  2602 00000ED9 8D064F75                 lea  ax, [SymbolUpper]
  2603 00000EDD 50                       push ax
  2604 00000EDE E89211                   call eqstr
  2605 00000EE1 83C404                   add  sp, 4
  2606 00000EE4 08C0                     or  al, al
  2607 00000EE6 0F840900                 je @@testReg98
  2608 00000EEA 66B800000000             mov eax, 0
  2609 00000EF0 E9DD00                   jmp @@retn
  2610                                  
  2611                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  2612                                  
  2613                                  @@testReg98:
  2614 00000EF3 68[1710]                 push testReg_23
  2615 00000EF6 8D064F75                 lea  ax, [SymbolUpper]
  2616 00000EFA 50                       push ax
  2617 00000EFB E87511                   call eqstr
  2618 00000EFE 83C404                   add  sp, 4
  2619 00000F01 08C0                     or  al, al
  2620 00000F03 0F840900                 je @@testReg99
  2621 00000F07 66B801000000             mov eax, 1
  2622 00000F0D E9C000                   jmp @@retn
  2623                                  
  2624                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  2625                                  
  2626                                  @@testReg99:
  2627 00000F10 68[1B10]                 push testReg_24
  2628 00000F13 8D064F75                 lea  ax, [SymbolUpper]
  2629 00000F17 50                       push ax
  2630 00000F18 E85811                   call eqstr
  2631 00000F1B 83C404                   add  sp, 4
  2632 00000F1E 08C0                     or  al, al
  2633 00000F20 0F840900                 je @@testReg100
  2634 00000F24 66B802000000             mov eax, 2
  2635 00000F2A E9A300                   jmp @@retn
  2636                                  
  2637                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  2638                                  
  2639                                  @@testReg100:
  2640 00000F2D 68[1F10]                 push testReg_25
  2641 00000F30 8D064F75                 lea  ax, [SymbolUpper]
  2642 00000F34 50                       push ax
  2643 00000F35 E83B11                   call eqstr
  2644 00000F38 83C404                   add  sp, 4
  2645 00000F3B 08C0                     or  al, al
  2646 00000F3D 0F840900                 je @@testReg101
  2647 00000F41 66B803000000             mov eax, 3
  2648 00000F47 E98600                   jmp @@retn
  2649                                  
  2650                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  2651                                  
  2652                                  @@testReg101:
  2653 00000F4A 68[2310]                 push testReg_26
  2654 00000F4D 8D064F75                 lea  ax, [SymbolUpper]
  2655 00000F51 50                       push ax
  2656 00000F52 E81E11                   call eqstr
  2657 00000F55 83C404                   add  sp, 4
  2658 00000F58 08C0                     or  al, al
  2659 00000F5A 0F840900                 je @@testReg102
  2660 00000F5E 66B804000000             mov eax, 4
  2661 00000F64 E96900                   jmp @@retn
  2662                                  
  2663                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  2664                                  
  2665                                  @@testReg102:
  2666 00000F67 68[2710]                 push testReg_27
  2667 00000F6A 8D064F75                 lea  ax, [SymbolUpper]
  2668 00000F6E 50                       push ax
  2669 00000F6F E80111                   call eqstr
  2670 00000F72 83C404                   add  sp, 4
  2671 00000F75 08C0                     or  al, al
  2672 00000F77 0F840900                 je @@testReg103
  2673 00000F7B 66B805000000             mov eax, 5
  2674 00000F81 E94C00                   jmp @@retn
  2675                                  
  2676                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  2677                                  
  2678                                  @@testReg103:
  2679 00000F84 68[2B10]                 push testReg_28
  2680 00000F87 8D064F75                 lea  ax, [SymbolUpper]
  2681 00000F8B 50                       push ax
  2682 00000F8C E8E410                   call eqstr
  2683 00000F8F 83C404                   add  sp, 4
  2684 00000F92 08C0                     or  al, al
  2685 00000F94 0F840900                 je @@testReg104
  2686 00000F98 66B806000000             mov eax, 6
  2687 00000F9E E92F00                   jmp @@retn
  2688                                  
  2689                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  2690                                  
  2691                                  @@testReg104:
  2692 00000FA1 68[2F10]                 push testReg_29
  2693 00000FA4 8D064F75                 lea  ax, [SymbolUpper]
  2694 00000FA8 50                       push ax
  2695 00000FA9 E8C710                   call eqstr
  2696 00000FAC 83C404                   add  sp, 4
  2697 00000FAF 08C0                     or  al, al
  2698 00000FB1 0F840900                 je @@testReg105
  2699 00000FB5 66B807000000             mov eax, 7
  2700 00000FBB E91200                   jmp @@retn
  2701                                  
  2702                                  ;-109   RegType=0; return 0;
  2703                                  
  2704                                  @@testReg105:
  2705 00000FBE 66B800000000             mov eax, 0
  2706 00000FC4 A2[3500]                 mov byte [RegType], al
  2707 00000FC7 66B800000000             mov eax, 0
  2708 00000FCD E90000                   jmp @@retn
  2709                                  
  2710                                  ;-110 }
  2711                                  
  2712                                  @@retn:
  2713 00000FD0 C3                       ret
  2714                                  ; ENDP
  2715 00000FD1 414C00                  testReg_0 db "AL",0
  2716 00000FD4 434C00                  testReg_1 db "CL",0
  2717 00000FD7 444C00                  testReg_2 db "DL",0
  2718 00000FDA 424C00                  testReg_3 db "BL",0
  2719 00000FDD 414800                  testReg_4 db "AH",0
  2720 00000FE0 434800                  testReg_5 db "CH",0
  2721 00000FE3 444800                  testReg_6 db "DH",0
  2722 00000FE6 424800                  testReg_7 db "BH",0
  2723 00000FE9 415800                  testReg_8 db "AX",0
  2724 00000FEC 435800                  testReg_9 db "CX",0
  2725 00000FEF 445800                  testReg_10 db "DX",0
  2726 00000FF2 425800                  testReg_11 db "BX",0
  2727 00000FF5 535000                  testReg_12 db "SP",0
  2728 00000FF8 425000                  testReg_13 db "BP",0
  2729 00000FFB 534900                  testReg_14 db "SI",0
  2730 00000FFE 444900                  testReg_15 db "DI",0
  2731 00001001 455300                  testReg_16 db "ES",0
  2732 00001004 435300                  testReg_17 db "CS",0
  2733 00001007 535300                  testReg_18 db "SS",0
  2734 0000100A 445300                  testReg_19 db "DS",0
  2735 0000100D 465300                  testReg_20 db "FS",0
  2736 00001010 475300                  testReg_21 db "GS",0
  2737 00001013 45415800                testReg_22 db "EAX",0
  2738 00001017 45435800                testReg_23 db "ECX",0
  2739 0000101B 45445800                testReg_24 db "EDX",0
  2740 0000101F 45425800                testReg_25 db "EBX",0
  2741 00001023 45535000                testReg_26 db "ESP",0
  2742 00001027 45425000                testReg_27 db "EBP",0
  2743 0000102B 45534900                testReg_28 db "ESI",0
  2744 0000102F 45444900                testReg_29 db "EDI",0
  2745                                  ;Back to main program: AS.C
  2746                                  
  2747                                  ;-7 #include "OUTPUT.C"
  2748                                  
  2749                                  ;Use include file: OUTPUT.C
  2750                                  
  2751                                  ;-1 int printLine() { int i; char c;
  2752                                  
  2753                                  
  2754                                  printLine:  ; *** PROC ***
  2755                                  
  2756                                  ;-2   prs("\n"); printhex16(PCStart);
  2757                                  
  2758                                  ;Function : printLine, Number of local variables: 2
  2759                                  ;   # type sign width line used address name   list of local variables
  2760                                  ;  200 var sign word     1 NULL bp-2    i
  2761                                  ;  201 var sign byte     1 NULL bp-4    c;
  2762 00001033 C8040000                 ENTER  4,0
  2763 00001037 68[C810]                 push printLine_0
  2764 0000103A E80401                   call prs
  2765 0000103D 83C402                   add  sp, 2
  2766 00001040 FF36[2C00]               push word [PCStart]
  2767 00001044 E8EB01                   call printhex16
  2768 00001047 83C402                   add  sp, 2
  2769                                  
  2770                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  2771                                  
  2772 0000104A A1[3F00]                 mov ax, [OpPrintIndex]
  2773 0000104D 83F800                   cmp ax, 0
  2774 00001050 0F850C00                 jne @@printLine106
  2775 00001054 68[CB10]                 push printLine_1
  2776 00001057 E8E700                   call prs
  2777 0000105A 83C402                   add  sp, 2
  2778                                  
  2779                                  ;-4   else {
  2780                                  
  2781 0000105D E95B00                   jmp @@printLine107
  2782                                  @@printLine106:
  2783                                  
  2784                                  ;-5     prc(PrintR);
  2785                                  
  2786 00001060 A0[4300]                 mov al, byte [PrintR]
  2787 00001063 B400                     mov ah, 0
  2788 00001065 50                       push ax
  2789 00001066 E87700                   call prc
  2790 00001069 83C402                   add  sp, 2
  2791                                  
  2792                                  ;-6     i=0;
  2793                                  
  2794 0000106C 66B800000000             mov eax, 0
  2795 00001072 8946FE                   mov word [bp-2], ax
  2796                                  
  2797                                  ;-7     do {
  2798                                  
  2799                                  @@printLine108:
  2800                                  
  2801                                  ;-8       c=OpPos[i];
  2802                                  
  2803 00001075 8B5EFE                   mov bx, [bp-2]
  2804 00001078 8A87B676                 mov al, [OpPos + bx]
  2805 0000107C 8846FC                   mov byte [bp-4], al
  2806                                  
  2807                                  ;-9       printhex8a(c); prc(' ');
  2808                                  
  2809 0000107F 8A46FC                   mov al, byte [bp-4]
  2810 00001082 B400                     mov ah, 0
  2811 00001084 50                       push ax
  2812 00001085 E85C01                   call printhex8a
  2813 00001088 83C402                   add  sp, 2
  2814 0000108B 6A20                     push 32
  2815 0000108D E85000                   call prc
  2816 00001090 83C402                   add  sp, 2
  2817                                  
  2818                                  ;-10       i++;
  2819                                  
  2820 00001093 FF46FE                   inc  word [bp-2]
  2821                                  
  2822                                  ;-11     } while(i < OpPrintIndex);
  2823                                  
  2824 00001096 8B46FE                   mov ax, [bp-2]
  2825 00001099 3B06[3F00]               cmp ax, [OpPrintIndex]
  2826 0000109D 0F8D0200                 jge @@printLine109
  2827 000010A1 EBD2                     jmp @@printLine108
  2828                                  @@printLine109:
  2829                                  
  2830                                  ;-12     do {// fill rest with blank
  2831                                  
  2832                                  @@printLine110:
  2833                                  
  2834                                  ;-13       prs("   ");
  2835                                  
  2836 000010A3 68[DC10]                 push printLine_2
  2837 000010A6 E89800                   call prs
  2838 000010A9 83C402                   add  sp, 2
  2839                                  
  2840                                  ;-14       i++;
  2841                                  
  2842 000010AC FF46FE                   inc  word [bp-2]
  2843                                  
  2844                                  ;-15     } while(i < OPMAXLEN);
  2845                                  
  2846 000010AF 8B46FE                   mov ax, [bp-2]
  2847 000010B2 83F805                   cmp ax, 5
  2848 000010B5 0F8D0200                 jge @@printLine111
  2849 000010B9 EBE8                     jmp @@printLine110
  2850                                  @@printLine111:
  2851                                  
  2852                                  ;-16   }
  2853                                  
  2854                                  
  2855                                  ;-17   prscomment(InputBuf);
  2856                                  
  2857                                  @@printLine107:
  2858 000010BB 8D066E75                 lea  ax, [InputBuf]
  2859 000010BF 50                       push ax
  2860 000010C0 E85000                   call prscomment
  2861 000010C3 83C402                   add  sp, 2
  2862                                  
  2863                                  ;-18 }
  2864                                  
  2865                                  
  2866                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  2867 000010C6 C9                       LEAVE
  2868 000010C7 C3                       ret
  2869                                  ; ENDP
  2870 000010C8 5C6E00                  printLine_0 db "\n",0
  2871 000010CB 202020202020202020-     printLine_1 db "                ",0
  2872 000010D4 2020202020202000   
  2873 000010DC 20202000                printLine_2 db "   ",0
  2874                                  
  2875                                  prc:  ; *** PROC ***
  2876                                  ;Function : prc, Number of local variables: 1
  2877                                  ;   # type sign width line used address name   list of local variables
  2878                                  ;  200 var unsg byte    19 NULL bp+4    c;
  2879 000010E0 C8000000                 ENTER  0,0
  2880 000010E4 A0[1800]                 mov al, [LIST]
  2881 000010E7 08C0                     or  al, al
  2882 000010E9 0F841400                 je @@prc112
  2883 000010ED 807E040A                cmp byte [bp+4], 10
  2884 000010F1 0F850600                 jne @@prc113
  2885 000010F5 B80D00                   mov  ax, 13
  2886 000010F8 E8680E                   call writetty
  2887                                  
  2888                                  ;-20      al=c; writetty(); }
  2889                                  
  2890                                  @@prc113:
  2891 000010FB 8A4604                   mov  al, [bp+4]
  2892 000010FE E8620E                   call writetty
  2893                                  
  2894                                  ;-21    fputcR(c,lst_fd); }
  2895                                  
  2896                                  @@prc112:
  2897 00001101 FF36[1F00]               push word [lst_fd]
  2898 00001105 8A4604                   mov al, byte [bp+4]
  2899 00001108 B400                     mov ah, 0
  2900 0000110A 50                       push ax
  2901 0000110B E81510                   call fputcR
  2902 0000110E 83C404                   add  sp, 4
  2903                                  
  2904                                  ;-22 
  2905                                  
  2906                                  
  2907                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  2908 00001111 C9                       LEAVE
  2909 00001112 C3                       ret
  2910                                  ; ENDP
  2911                                  
  2912                                  prscomment:  ; *** PROC ***
  2913                                  
  2914                                  ;-24   while(*s){c=*s;prc(c);s++;}
  2915                                  
  2916                                  ;Function : prscomment, Number of local variables: 2
  2917                                  ;   # type sign width line used address name   list of local variables
  2918                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  2919                                  ;  201 var unsg byte    23 NULL bp-2    c;
  2920 00001113 C8020000                 ENTER  2,0
  2921                                  @@prscomment114:
  2922 00001117 8B5E04                   mov bx, [bp+4]
  2923 0000111A 8A07                     mov al, [bx]
  2924 0000111C B400                     mov ah, 0
  2925 0000111E 08C0                     or  al, al
  2926 00001120 0F841B00                 je @@prscomment115
  2927 00001124 8B5E04                   mov bx, [bp+4]
  2928 00001127 8A07                     mov al, [bx]
  2929 00001129 B400                     mov ah, 0
  2930 0000112B 8846FE                   mov byte [bp-2], al
  2931 0000112E 8A46FE                   mov al, byte [bp-2]
  2932 00001131 B400                     mov ah, 0
  2933 00001133 50                       push ax
  2934 00001134 E8A9FF                   call prc
  2935 00001137 83C402                   add  sp, 2
  2936 0000113A FF4604                   inc  word [bp+4]
  2937                                  
  2938                                  ;-25 }
  2939                                  
  2940 0000113D EBD8                     jmp @@prscomment114
  2941                                  @@prscomment115:
  2942                                  
  2943                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  2944 0000113F C9                       LEAVE
  2945 00001140 C3                       ret
  2946                                  ; ENDP
  2947                                  
  2948                                  prs:  ; *** PROC ***
  2949                                  ;Function : prs, Number of local variables: 3
  2950                                  ;   # type sign width line used address name   list of local variables
  2951                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  2952                                  ;  201 var unsg byte    26 NULL bp-2    c
  2953                                  ;  202 var sign word    26 NULL bp-4    com;
  2954 00001141 C8040000                 ENTER  4,0
  2955 00001145 66B800000000             mov eax, 0
  2956 0000114B 8946FC                   mov word [bp-4], ax
  2957                                  
  2958                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  2959                                  
  2960                                  @@prs116:
  2961 0000114E 8B5E04                   mov bx, [bp+4]
  2962 00001151 8A07                     mov al, [bx]
  2963 00001153 B400                     mov ah, 0
  2964 00001155 08C0                     or  al, al
  2965 00001157 0F848700                 je @@prs117
  2966 0000115B 8B5E04                   mov bx, [bp+4]
  2967 0000115E 8A07                     mov al, [bx]
  2968 00001160 B400                     mov ah, 0
  2969 00001162 8846FE                   mov byte [bp-2], al
  2970 00001165 8A46FE                   mov al, [bp-2]
  2971 00001168 3C22                     cmp al, 34
  2972 0000116A 0F851E00                 jne @@prs118
  2973 0000116E 8B46FC                   mov ax, [bp-4]
  2974 00001171 08C0                     or  al, al
  2975 00001173 0F840C00                 je @@prs119
  2976 00001177 66B800000000             mov eax, 0
  2977 0000117D 8946FC                   mov word [bp-4], ax
  2978 00001180 E90900                   jmp @@prs120
  2979                                  @@prs119:
  2980 00001183 66B801000000             mov eax, 1
  2981 00001189 8946FC                   mov word [bp-4], ax
  2982                                  
  2983                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  2984                                  
  2985                                  @@prs120:
  2986                                  @@prs118:
  2987 0000118C 8A46FE                   mov al, [bp-2]
  2988 0000118F 3C5C                     cmp al, 92
  2989 00001191 0F853B00                 jne @@prs121
  2990 00001195 8B46FC                   mov ax, [bp-4]
  2991 00001198 83F800                   cmp ax, 0
  2992 0000119B 0F853100                 jne @@prs122
  2993 0000119F FF4604                   inc  word [bp+4]
  2994 000011A2 8B5E04                   mov bx, [bp+4]
  2995 000011A5 8A07                     mov al, [bx]
  2996 000011A7 B400                     mov ah, 0
  2997 000011A9 8846FE                   mov byte [bp-2], al
  2998                                  
  2999                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3000                                  
  3001 000011AC 8A46FE                   mov al, [bp-2]
  3002 000011AF 3C6E                     cmp al, 110
  3003 000011B1 0F850900                 jne @@prs123
  3004 000011B5 66B80A000000             mov eax, 10
  3005 000011BB 8846FE                   mov byte [bp-2], al
  3006                                  @@prs123:
  3007 000011BE 8A46FE                   mov al, [bp-2]
  3008 000011C1 3C74                     cmp al, 116
  3009 000011C3 0F850900                 jne @@prs124
  3010 000011C7 66B809000000             mov eax, 9
  3011 000011CD 8846FE                   mov byte [bp-2], al
  3012                                  @@prs124:
  3013                                  @@prs122:
  3014                                  @@prs121:
  3015 000011D0 8A46FE                   mov al, byte [bp-2]
  3016 000011D3 B400                     mov ah, 0
  3017 000011D5 50                       push ax
  3018 000011D6 E807FF                   call prc
  3019 000011D9 83C402                   add  sp, 2
  3020 000011DC FF4604                   inc  word [bp+4]
  3021                                  
  3022                                  ;-30 }
  3023                                  
  3024 000011DF E96CFF                   jmp @@prs116
  3025                                  @@prs117:
  3026                                  
  3027                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  3028 000011E2 C9                       LEAVE
  3029 000011E3 C3                       ret
  3030                                  ; ENDP
  3031                                  
  3032                                  printhex8a:  ; *** PROC ***
  3033                                  
  3034                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3035                                  
  3036                                  ;Function : printhex8a, Number of local variables: 2
  3037                                  ;   # type sign width line used address name   list of local variables
  3038                                  ;  200 var unsg word    31 NULL bp+4    c
  3039                                  ;  201 var unsg word    31 NULL bp-2    nib;
  3040 000011E4 C8020000                 ENTER  2,0
  3041 000011E8 8B4604                   mov ax, [bp+4]
  3042 000011EB C1E804                   shr ax, 4
  3043 000011EE 8946FE                   mov word [bp-2], ax
  3044 000011F1 8346FE30                 add  word [bp-2], 48
  3045 000011F5 8B46FE                   mov ax, [bp-2]
  3046 000011F8 83F839                   cmp ax, 57
  3047 000011FB 0F8E0400                 jle @@printhex8a125
  3048 000011FF 8346FE07                 add  word [bp-2], 7
  3049                                  @@printhex8a125:
  3050 00001203 FF76FE                   push word [bp-2]
  3051 00001206 E8D7FE                   call prc
  3052 00001209 83C402                   add  sp, 2
  3053                                  
  3054                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3055                                  
  3056 0000120C 8B4604                   mov ax, [bp+4]
  3057 0000120F 83E00F                   and ax, 15
  3058 00001212 8946FE                   mov word [bp-2], ax
  3059 00001215 8346FE30                 add  word [bp-2], 48
  3060 00001219 8B46FE                   mov ax, [bp-2]
  3061 0000121C 83F839                   cmp ax, 57
  3062 0000121F 0F8E0400                 jle @@printhex8a126
  3063 00001223 8346FE07                 add  word [bp-2], 7
  3064                                  @@printhex8a126:
  3065 00001227 FF76FE                   push word [bp-2]
  3066 0000122A E8B3FE                   call prc
  3067 0000122D 83C402                   add  sp, 2
  3068                                  
  3069                                  ;-34 }
  3070                                  
  3071                                  
  3072                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  3073 00001230 C9                       LEAVE
  3074 00001231 C3                       ret
  3075                                  ; ENDP
  3076                                  
  3077                                  printhex16:  ; *** PROC ***
  3078                                  
  3079                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3080                                  
  3081                                  ;Function : printhex16, Number of local variables: 2
  3082                                  ;   # type sign width line used address name   list of local variables
  3083                                  ;  200 var unsg word    35 NULL bp+4    i
  3084                                  ;  201 var unsg word    35 NULL bp-2    half;
  3085 00001232 C8020000                 ENTER  2,0
  3086 00001236 8B4604                   mov ax, [bp+4]
  3087 00001239 C1E808                   shr ax, 8
  3088 0000123C 8946FE                   mov word [bp-2], ax
  3089 0000123F FF76FE                   push word [bp-2]
  3090 00001242 E89FFF                   call printhex8a
  3091 00001245 83C402                   add  sp, 2
  3092 00001248 8B4604                   mov ax, [bp+4]
  3093 0000124B 25FF00                   and ax, 255
  3094 0000124E 8946FE                   mov word [bp-2], ax
  3095 00001251 FF76FE                   push word [bp-2]
  3096 00001254 E88DFF                   call printhex8a
  3097 00001257 83C402                   add  sp, 2
  3098                                  
  3099                                  ;-37 }
  3100                                  
  3101                                  
  3102                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  3103 0000125A C9                       LEAVE
  3104 0000125B C3                       ret
  3105                                  ; ENDP
  3106                                  
  3107                                  printIntU:  ; *** PROC ***
  3108                                  
  3109                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  3110                                  
  3111                                  ;Function : printIntU, Number of local variables: 2
  3112                                  ;   # type sign width line used address name   list of local variables
  3113                                  ;  200 var unsg word    38 NULL bp+4    n
  3114                                  ;  201 var unsg word    38 NULL bp-2    e;
  3115 0000125C C8020000                 ENTER  2,0
  3116 00001260 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3117 00001264 0F821700                 jb  @@printIntU127
  3118 00001268 8B4604                   mov ax, [bp+4]
  3119 0000126B BB0A00                   mov bx, 10
  3120 0000126E BA0000                   mov dx, 0
  3121 00001271 F7F3                     div bx
  3122 00001273 8946FE                   mov word [bp-2], ax
  3123                                  
  3124                                  ;-40     printIntU(e); }
  3125                                  
  3126 00001276 FF76FE                   push word [bp-2]
  3127 00001279 E8E0FF                   call printIntU
  3128 0000127C 83C402                   add  sp, 2
  3129                                  
  3130                                  ;-41     n = n % 10; //unsigned mod
  3131                                  
  3132                                  @@printIntU127:
  3133 0000127F 8B4604                   mov ax, [bp+4]
  3134 00001282 BB0A00                   mov bx, 10
  3135 00001285 BA0000                   mov dx, 0
  3136 00001288 F7F3                     div bx
  3137 0000128A 89D0                     mov ax, dx
  3138 0000128C 894604                   mov word [bp+4], ax
  3139                                  
  3140                                  ;-42     n += '0'; prc(n);
  3141                                  
  3142 0000128F 83460430                 add  word [bp+4], 48
  3143 00001293 FF7604                   push word [bp+4]
  3144 00001296 E847FE                   call prc
  3145 00001299 83C402                   add  sp, 2
  3146                                  
  3147                                  ;-43 }
  3148                                  
  3149                                  
  3150                                  ;-44 
  3151                                  
  3152                                  
  3153                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  3154 0000129C C9                       LEAVE
  3155 0000129D C3                       ret
  3156                                  ; ENDP
  3157                                  
  3158                                  error1:  ; *** PROC ***
  3159                                  ;Function : error1, Number of local variables: 1
  3160                                  ;   # type sign width line used address name   list of local variables
  3161                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  3162 0000129E C8000000                 ENTER  0,0
  3163 000012A2 66B801000000             mov eax, 1
  3164 000012A8 A2[1800]                 mov byte [LIST], al
  3165 000012AB FF06[2500]               inc  word [ErrorCount]
  3166                                  
  3167                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  3168                                  
  3169 000012AF 68[D712]                 push error1_0
  3170 000012B2 E88CFE                   call prs
  3171 000012B5 83C402                   add  sp, 2
  3172 000012B8 FF7604                   push word [bp+4]
  3173 000012BB E883FE                   call prs
  3174 000012BE 83C402                   add  sp, 2
  3175                                  
  3176                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  3177                                  
  3178 000012C1 68[F212]                 push error1_1
  3179 000012C4 E87AFE                   call prs
  3180 000012C7 83C402                   add  sp, 2
  3181 000012CA 8D063075                 lea  ax, [Symbol]
  3182 000012CE 50                       push ax
  3183 000012CF E86FFE                   call prs
  3184 000012D2 83C402                   add  sp, 2
  3185                                  
  3186                                  ;-48 int allowederror(){error1("not allowed here"); }
  3187 000012D5 C9                       LEAVE
  3188 000012D6 C3                       ret
  3189                                  ; ENDP
  3190 000012D7 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3191 000012E0 6E657874206C696E65-
  3192 000012E9 204552524F523A2000 
  3193 000012F2 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3194 000012FB 2000               
  3195                                  
  3196                                  allowederror:  ; *** PROC ***
  3197 000012FD 68[0713]                 push allowederror_0
  3198 00001300 E89BFF                   call error1
  3199 00001303 83C402                   add  sp, 2
  3200                                  
  3201                                  ;-49 int addrerror()   {error1("address expected");}
  3202                                  
  3203 00001306 C3                       ret
  3204                                  ; ENDP
  3205 00001307 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3206 00001310 6564206865726500   
  3207                                  
  3208                                  addrerror:  ; *** PROC ***
  3209 00001318 68[2213]                 push addrerror_0
  3210 0000131B E880FF                   call error1
  3211 0000131E 83C402                   add  sp, 2
  3212                                  
  3213                                  ;-50 int implerror()   {error1("not implemented");}
  3214                                  
  3215 00001321 C3                       ret
  3216                                  ; ENDP
  3217 00001322 616464726573732065-     addrerror_0 db "address expected",0
  3218 0000132B 7870656374656400   
  3219                                  
  3220                                  implerror:  ; *** PROC ***
  3221 00001333 68[3D13]                 push implerror_0
  3222 00001336 E865FF                   call error1
  3223 00001339 83C402                   add  sp, 2
  3224                                  
  3225                                  ;-51 int indexerror()  {error1("invalid index register");}
  3226                                  
  3227 0000133C C3                       ret
  3228                                  ; ENDP
  3229 0000133D 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3230 00001346 6D656E74656400     
  3231                                  
  3232                                  indexerror:  ; *** PROC ***
  3233 0000134D 68[5713]                 push indexerror_0
  3234 00001350 E84BFF                   call error1
  3235 00001353 83C402                   add  sp, 2
  3236                                  
  3237                                  ;-52 int invaloperror(){error1("invalid or no operands");}
  3238                                  
  3239 00001356 C3                       ret
  3240                                  ; ENDP
  3241 00001357 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3242 00001360 6E6465782072656769-
  3243 00001369 7374657200         
  3244                                  
  3245                                  invaloperror:  ; *** PROC ***
  3246 0000136E 68[7813]                 push invaloperror_0
  3247 00001371 E82AFF                   call error1
  3248 00001374 83C402                   add  sp, 2
  3249                                  
  3250                                  ;-53 int numbererror() {error1("number expected");}
  3251                                  
  3252 00001377 C3                       ret
  3253                                  ; ENDP
  3254 00001378 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3255 00001381 72206E6F206F706572-
  3256 0000138A 616E647300         
  3257                                  
  3258                                  numbererror:  ; *** PROC ***
  3259 0000138F 68[9913]                 push numbererror_0
  3260 00001392 E809FF                   call error1
  3261 00001395 83C402                   add  sp, 2
  3262                                  
  3263                                  ;-54 int regmemerror() {error1("only register or memory allowed");}
  3264                                  
  3265 00001398 C3                       ret
  3266                                  ; ENDP
  3267 00001399 6E756D626572206578-     numbererror_0 db "number expected",0
  3268 000013A2 70656374656400     
  3269                                  
  3270                                  regmemerror:  ; *** PROC ***
  3271 000013A9 68[B313]                 push regmemerror_0
  3272 000013AC E8EFFE                   call error1
  3273 000013AF 83C402                   add  sp, 2
  3274                                  
  3275                                  ;-55 int reg16error()  {error1("only reg16, no segreg allowed");}
  3276                                  
  3277 000013B2 C3                       ret
  3278                                  ; ENDP
  3279 000013B3 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3280 000013BC 73746572206F72206D-
  3281 000013C5 656D6F727920616C6C-
  3282 000013CE 6F77656400         
  3283                                  
  3284                                  reg16error:  ; *** PROC ***
  3285 000013D3 68[DD13]                 push reg16error_0
  3286 000013D6 E8C5FE                   call error1
  3287 000013D9 83C402                   add  sp, 2
  3288                                  
  3289                                  ;-56 int segregerror() {error1("segment register not allowed");}
  3290                                  
  3291 000013DC C3                       ret
  3292                                  ; ENDP
  3293 000013DD 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3294 000013E6 362C206E6F20736567-
  3295 000013EF 72656720616C6C6F77-
  3296 000013F8 656400             
  3297                                  
  3298                                  segregerror:  ; *** PROC ***
  3299 000013FB 68[0514]                 push segregerror_0
  3300 000013FE E89DFE                   call error1
  3301 00001401 83C402                   add  sp, 2
  3302                                  
  3303                                  ;-57 int syntaxerror() {error1("syntax");}
  3304                                  
  3305 00001404 C3                       ret
  3306                                  ; ENDP
  3307 00001405 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3308 0000140E 65676973746572206E-
  3309 00001417 6F7420616C6C6F7765-
  3310 00001420 6400               
  3311                                  
  3312                                  syntaxerror:  ; *** PROC ***
  3313 00001422 68[2C14]                 push syntaxerror_0
  3314 00001425 E876FE                   call error1
  3315 00001428 83C402                   add  sp, 2
  3316                                  
  3317                                  ;-58 
  3318                                  
  3319                                  
  3320                                  ;-59 int errorexit(char *s) { error1(s); end1(1);}
  3321                                  
  3322 0000142B C3                       ret
  3323                                  ; ENDP
  3324 0000142C 73796E74617800          syntaxerror_0 db "syntax",0
  3325                                  
  3326                                  errorexit:  ; *** PROC ***
  3327                                  ;Function : errorexit, Number of local variables: 1
  3328                                  ;   # type sign width line used address name   list of local variables
  3329                                  ;  200 ptr sign byte    59 NULL bp+4    s;
  3330 00001433 C8000000                 ENTER  0,0
  3331 00001437 FF7604                   push word [bp+4]
  3332 0000143A E861FE                   call error1
  3333 0000143D 83C402                   add  sp, 2
  3334 00001440 6A01                     push 1
  3335 00001442 E85003                   call end1
  3336 00001445 83C402                   add  sp, 2
  3337                                  
  3338                                  ;-60 int addrexit(){errorexit("illegal address");}
  3339 00001448 C9                       LEAVE
  3340 00001449 C3                       ret
  3341                                  ; ENDP
  3342                                  
  3343                                  addrexit:  ; *** PROC ***
  3344 0000144A 68[5414]                 push addrexit_0
  3345 0000144D E8E3FF                   call errorexit
  3346 00001450 83C402                   add  sp, 2
  3347                                  
  3348                                  ;-61 int internexit(){errorexit("intern compiler error");}
  3349                                  
  3350 00001453 C3                       ret
  3351                                  ; ENDP
  3352 00001454 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3353 0000145D 64647265737300     
  3354                                  
  3355                                  internexit:  ; *** PROC ***
  3356 00001464 68[6E14]                 push internexit_0
  3357 00001467 E8C9FF                   call errorexit
  3358 0000146A 83C402                   add  sp, 2
  3359 0000146D C3                       ret
  3360                                  ; ENDP
  3361 0000146E 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3362 00001477 6D70696C6572206572-
  3363 00001480 726F7200           
  3364                                  ;Back to main program: AS.C
  3365                                  
  3366                                  ;-8 #include "MAIN.C"
  3367                                  
  3368                                  ;Use include file: MAIN.C
  3369                                  
  3370                                  ;-1 int main() {
  3371                                  
  3372                                  
  3373                                  main:  ; *** PROC ***
  3374                                  
  3375                                  ;-2   getarg(); 
  3376                                  
  3377 00001484 E80A00                   call getarg
  3378                                  
  3379                                  ;-3   parse(); 
  3380                                  
  3381 00001487 E8BDEF                   call parse
  3382                                  
  3383                                  ;-4   epilog(); 
  3384                                  
  3385 0000148A E85C02                   call epilog
  3386                                  
  3387                                  ;-5   end1();
  3388                                  
  3389 0000148D E80503                   call end1
  3390                                  
  3391                                  ;-6 }
  3392                                  
  3393                                  
  3394                                  ;-7 
  3395                                  
  3396                                  
  3397                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3398                                  
  3399 00001490 C3                       ret
  3400                                  ; ENDP
  3401                                  
  3402                                  getarg:  ; *** PROC ***
  3403                                  
  3404                                  ;-9   arglen1=*arglen;
  3405                                  
  3406                                  ;Function : getarg, Number of local variables: 3
  3407                                  ;   # type sign width line used address name   list of local variables
  3408                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3409                                  ;  201 var sign word     8 NULL bp-4    i
  3410                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3411 00001491 C8060000                 ENTER  6,0
  3412 00001495 8B1E[4C00]               mov bx, [arglen]
  3413 00001499 8A07                     mov al, [bx]
  3414 0000149B B400                     mov ah, 0
  3415 0000149D 8946FE                   mov word [bp-2], ax
  3416                                  
  3417                                  ;-10   if (arglen1==0) {
  3418                                  
  3419 000014A0 8B46FE                   mov ax, [bp-2]
  3420 000014A3 83F800                   cmp ax, 0
  3421 000014A6 0F851C00                 jne @@getarg128
  3422                                  
  3423                                  ;-11     cputs(Version1);
  3424                                  
  3425 000014AA 8D06[0300]               lea  ax, [Version1]
  3426 000014AE 50                       push ax
  3427 000014AF E8B90A                   call cputs
  3428 000014B2 83C402                   add  sp, 2
  3429                                  
  3430                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3431                                  
  3432 000014B5 68[5616]                 push getarg_0
  3433 000014B8 E8B00A                   call cputs
  3434 000014BB 83C402                   add  sp, 2
  3435                                  
  3436                                  ;-13     exitR(3);
  3437                                  
  3438 000014BE 6A03                     push 3
  3439 000014C0 E8830C                   call exitR
  3440 000014C3 83C402                   add  sp, 2
  3441                                  
  3442                                  ;-14   }
  3443                                  
  3444                                  
  3445                                  ;-15   i=arglen1+129; 
  3446                                  
  3447                                  @@getarg128:
  3448 000014C6 8B46FE                   mov ax, [bp-2]
  3449 000014C9 058100                   add ax, 129
  3450 000014CC 8946FC                   mov word [bp-4], ax
  3451                                  
  3452                                  ;-16   *i=0;  
  3453                                  
  3454 000014CF 66B800000000             mov eax, 0
  3455 000014D5 8B5EFC                   mov  bx, [bp-4]
  3456 000014D8 8907                     mov  [bx], ax
  3457                                  
  3458                                  ;-17   arglen1--;
  3459                                  
  3460 000014DA FF4EFE                   dec  word [bp-2]
  3461                                  
  3462                                  ;-18   toupper(argv);
  3463                                  
  3464 000014DD FF36[4E00]               push word [argv]
  3465 000014E1 E8B50A                   call toupper
  3466 000014E4 83C402                   add  sp, 2
  3467                                  
  3468                                  ;-19   
  3469                                  
  3470                                  
  3471                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3472                                  
  3473 000014E7 FF36[4E00]               push word [argv]
  3474 000014EB 8D06ED75                 lea  ax, [namein]
  3475 000014EF 50                       push ax
  3476 000014F0 E8140B                   call strcpy
  3477 000014F3 83C404                   add  sp, 4
  3478 000014F6 68[7B16]                 push getarg_1
  3479 000014F9 8D06ED75                 lea  ax, [namein]
  3480 000014FD 50                       push ax
  3481 000014FE E8C70B                   call strcat1
  3482 00001501 83C404                   add  sp, 4
  3483                                  
  3484                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3485                                  
  3486 00001504 FF36[4E00]               push word [argv]
  3487 00001508 8D063076                 lea  ax, [namelst]
  3488 0000150C 50                       push ax
  3489 0000150D E8F70A                   call strcpy
  3490 00001510 83C404                   add  sp, 4
  3491 00001513 68[7E16]                 push getarg_2
  3492 00001516 8D063076                 lea  ax, [namelst]
  3493 0000151A 50                       push ax
  3494 0000151B E8AA0B                   call strcat1
  3495 0000151E 83C404                   add  sp, 4
  3496                                  
  3497                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3498                                  
  3499 00001521 FF36[4E00]               push word [argv]
  3500 00001525 8D067376                 lea  ax, [namebin]
  3501 00001529 50                       push ax
  3502 0000152A E8DA0A                   call strcpy
  3503 0000152D 83C404                   add  sp, 4
  3504 00001530 68[8316]                 push getarg_3
  3505 00001533 8D067376                 lea  ax, [namebin]
  3506 00001537 50                       push ax
  3507 00001538 E88D0B                   call strcat1
  3508 0000153B 83C404                   add  sp, 4
  3509                                  
  3510                                  ;-23 
  3511                                  
  3512                                  
  3513                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3514                                  
  3515 0000153E 66B801000000             mov eax, 1
  3516 00001544 A2[1800]                 mov byte [LIST], al
  3517 00001547 66B800000000             mov eax, 0
  3518 0000154D A3[2300]                 mov word [DOS_ERR], ax
  3519 00001550 66B800000000             mov eax, 0
  3520 00001556 A3[2A00]                 mov word [PC], ax
  3521 00001559 66B800000000             mov eax, 0
  3522 0000155F A3[2500]                 mov word [ErrorCount], ax
  3523                                  
  3524                                  ;-25   
  3525                                  
  3526                                  
  3527                                  ;-26   asm_fd=openR (namein);
  3528                                  
  3529 00001562 8D06ED75                 lea  ax, [namein]
  3530 00001566 50                       push ax
  3531 00001567 E8830B                   call openR
  3532 0000156A 83C402                   add  sp, 2
  3533 0000156D A3[1D00]                 mov word [asm_fd], ax
  3534                                  
  3535                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3536                                  
  3537 00001570 A1[2300]                 mov ax, [DOS_ERR]
  3538 00001573 08C0                     or  al, al
  3539 00001575 0F841C00                 je @@getarg129
  3540 00001579 68[8816]                 push getarg_4
  3541 0000157C E8EC09                   call cputs
  3542 0000157F 83C402                   add  sp, 2
  3543 00001582 8D06ED75                 lea  ax, [namein]
  3544 00001586 50                       push ax
  3545 00001587 E8E109                   call cputs
  3546 0000158A 83C402                   add  sp, 2
  3547 0000158D 6A01                     push 1
  3548 0000158F E8B40B                   call exitR
  3549 00001592 83C402                   add  sp, 2
  3550                                  
  3551                                  ;-28   lst_fd=creatR(namelst);
  3552                                  
  3553                                  @@getarg129:
  3554 00001595 8D063076                 lea  ax, [namelst]
  3555 00001599 50                       push ax
  3556 0000159A E85F0B                   call creatR
  3557 0000159D 83C402                   add  sp, 2
  3558 000015A0 A3[1F00]                 mov word [lst_fd], ax
  3559                                  
  3560                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3561                                  
  3562 000015A3 A1[2300]                 mov ax, [DOS_ERR]
  3563 000015A6 08C0                     or  al, al
  3564 000015A8 0F841C00                 je @@getarg130
  3565 000015AC 68[9E16]                 push getarg_5
  3566 000015AF E8B909                   call cputs
  3567 000015B2 83C402                   add  sp, 2
  3568 000015B5 8D063076                 lea  ax, [namelst]
  3569 000015B9 50                       push ax
  3570 000015BA E8AE09                   call cputs
  3571 000015BD 83C402                   add  sp, 2
  3572 000015C0 6A02                     push 2
  3573 000015C2 E8810B                   call exitR
  3574 000015C5 83C402                   add  sp, 2
  3575                                  
  3576                                  ;-30   bin_fd=creatR(namebin);
  3577                                  
  3578                                  @@getarg130:
  3579 000015C8 8D067376                 lea  ax, [namebin]
  3580 000015CC 50                       push ax
  3581 000015CD E82C0B                   call creatR
  3582 000015D0 83C402                   add  sp, 2
  3583 000015D3 A3[2100]                 mov word [bin_fd], ax
  3584                                  
  3585                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3586                                  
  3587 000015D6 A1[2300]                 mov ax, [DOS_ERR]
  3588 000015D9 08C0                     or  al, al
  3589 000015DB 0F841C00                 je @@getarg131
  3590 000015DF 68[B516]                 push getarg_6
  3591 000015E2 E88609                   call cputs
  3592 000015E5 83C402                   add  sp, 2
  3593 000015E8 8D067376                 lea  ax, [namebin]
  3594 000015EC 50                       push ax
  3595 000015ED E87B09                   call cputs
  3596 000015F0 83C402                   add  sp, 2
  3597 000015F3 6A02                     push 2
  3598 000015F5 E84E0B                   call exitR
  3599 000015F8 83C402                   add  sp, 2
  3600                                  
  3601                                  ;-32   
  3602                                  
  3603                                  
  3604                                  ;-33   prs(";");prs(Version1);
  3605                                  
  3606                                  @@getarg131:
  3607 000015FB 68[CB16]                 push getarg_7
  3608 000015FE E840FB                   call prs
  3609 00001601 83C402                   add  sp, 2
  3610 00001604 8D06[0300]               lea  ax, [Version1]
  3611 00001608 50                       push ax
  3612 00001609 E835FB                   call prs
  3613 0000160C 83C402                   add  sp, 2
  3614                                  
  3615                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3616                                  
  3617 0000160F 68[CD16]                 push getarg_8
  3618 00001612 E82CFB                   call prs
  3619 00001615 83C402                   add  sp, 2
  3620 00001618 8D06ED75                 lea  ax, [namein]
  3621 0000161C 50                       push ax
  3622 0000161D E821FB                   call prs
  3623 00001620 83C402                   add  sp, 2
  3624 00001623 68[D816]                 push getarg_9
  3625 00001626 E818FB                   call prs
  3626 00001629 83C402                   add  sp, 2
  3627 0000162C 8D063076                 lea  ax, [namelst]
  3628 00001630 50                       push ax
  3629 00001631 E80DFB                   call prs
  3630 00001634 83C402                   add  sp, 2
  3631                                  
  3632                                  ;-35   prs(", "); prs(namebin);
  3633                                  
  3634 00001637 68[E316]                 push getarg_10
  3635 0000163A E804FB                   call prs
  3636 0000163D 83C402                   add  sp, 2
  3637 00001640 8D067376                 lea  ax, [namebin]
  3638 00001644 50                       push ax
  3639 00001645 E8F9FA                   call prs
  3640 00001648 83C402                   add  sp, 2
  3641                                  
  3642                                  ;-36   prs("\n");
  3643                                  
  3644 0000164B 68[E616]                 push getarg_11
  3645 0000164E E8F0FA                   call prs
  3646 00001651 83C402                   add  sp, 2
  3647                                  
  3648                                  ;-37 }
  3649                                  
  3650                                  
  3651                                  ;-38 int epilog() { int i; int j; char c;
  3652 00001654 C9                       LEAVE
  3653 00001655 C3                       ret
  3654                                  ; ENDP
  3655 00001656 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3656 0000165F 41532E434F4D206669-
  3657 00001668 6C656E616D65205B77-
  3658 00001671 2F6F202E535D203A20-
  3659 0000167A 00                 
  3660 0000167B 2E5300                  getarg_1 db ".S",0
  3661 0000167E 2E4C535400              getarg_2 db ".LST",0
  3662 00001683 2E434F4D00              getarg_3 db ".COM",0
  3663 00001688 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3664 00001691 6C65206D697373696E-
  3665 0000169A 673A2000           
  3666 0000169E 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3667 000016A7 206E6F742063726561-
  3668 000016B0 74653A2000         
  3669 000016B5 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3670 000016BE 6E6F74206372656174-
  3671 000016C7 653A2000           
  3672 000016CB 3B00                    getarg_7 db ";",0
  3673 000016CD 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3674 000016D6 2000               
  3675 000016D8 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3676 000016E1 2000               
  3677 000016E3 2C2000                  getarg_10 db ", ",0
  3678 000016E6 5C6E00                  getarg_11 db "\n",0
  3679                                  
  3680                                  epilog:  ; *** PROC ***
  3681                                  
  3682                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3683                                  
  3684                                  ;Function : epilog, Number of local variables: 3
  3685                                  ;   # type sign width line used address name   list of local variables
  3686                                  ;  200 var sign word    38 NULL bp-2    i
  3687                                  ;  201 var sign word    38 NULL bp-4    j
  3688                                  ;  202 var sign byte    38 NULL bp-6    c;
  3689 000016E9 C8060000                 ENTER  6,0
  3690 000016ED 68[6317]                 push epilog_0
  3691 000016F0 E84EFA                   call prs
  3692 000016F3 83C402                   add  sp, 2
  3693 000016F6 FF36[2500]               push word [ErrorCount]
  3694 000016FA E85FFB                   call printIntU
  3695 000016FD 83C402                   add  sp, 2
  3696                                  
  3697                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3698                                  
  3699 00001700 A1[2500]                 mov ax, [ErrorCount]
  3700 00001703 08C0                     or  al, al
  3701 00001705 0F840900                 je @@epilog132
  3702 00001709 68[7317]                 push epilog_1
  3703 0000170C E832FA                   call prs
  3704 0000170F 83C402                   add  sp, 2
  3705                                  
  3706                                  ;-41 /*    
  3707                                  
  3708                                  
  3709                                  ;-42   prs(", Label & Var: ");
  3710                                  
  3711                                  
  3712                                  ;-43   if (LabelMaxIx) {
  3713                                  
  3714                                  
  3715                                  ;-44     i = 1;
  3716                                  
  3717                                  
  3718                                  ;-45     LabelNamePtr= &LabelNames;
  3719                                  
  3720                                  
  3721                                  ;-46     do {
  3722                                  
  3723                                  
  3724                                  ;-47       prs(LabelNamePtr); prc(' ');
  3725                                  
  3726                                  
  3727                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3728                                  
  3729                                  
  3730                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3731                                  
  3732                                  
  3733                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3734                                  
  3735                                  
  3736                                  ;-51       LabelNamePtr++;
  3737                                  
  3738                                  
  3739                                  ;-52       i++;
  3740                                  
  3741                                  
  3742                                  ;-53     } while (i <= LabelMaxIx);
  3743                                  
  3744                                  
  3745                                  ;-54   }
  3746                                  
  3747                                  
  3748                                  ;-55 */  
  3749                                  
  3750                                  
  3751                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3752                                  
  3753                                  @@epilog132:
  3754 00001712 68[8117]                 push epilog_2
  3755 00001715 E829FA                   call prs
  3756 00001718 83C402                   add  sp, 2
  3757 0000171B FF36[4A00]               push word [BinLen]
  3758 0000171F E83AFB                   call printIntU
  3759 00001722 83C402                   add  sp, 2
  3760 00001725 68[8D17]                 push epilog_3
  3761 00001728 E816FA                   call prs
  3762 0000172B 83C402                   add  sp, 2
  3763                                  
  3764                                  ;-57 //  i=0;
  3765                                  
  3766                                  
  3767                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  3768                                  
  3769                                  
  3770                                  ;-59 //  } while (i < BinLen);
  3771                                  
  3772                                  
  3773                                  ;-60   i=0;
  3774                                  
  3775 0000172E 66B800000000             mov eax, 0
  3776 00001734 8946FE                   mov word [bp-2], ax
  3777                                  
  3778                                  ;-61   do {
  3779                                  
  3780                                  @@epilog133:
  3781                                  
  3782                                  ;-62     c = FileBin[i];
  3783                                  
  3784 00001737 8B5EFE                   mov bx, [bp-2]
  3785 0000173A 8A876B7B                 mov al, [FileBin + bx]
  3786 0000173E 8846FA                   mov byte [bp-6], al
  3787                                  
  3788                                  ;-63     fputcR(c, bin_fd);
  3789                                  
  3790 00001741 FF36[2100]               push word [bin_fd]
  3791 00001745 8A46FA                   mov al, byte [bp-6]
  3792 00001748 B400                     mov ah, 0
  3793 0000174A 50                       push ax
  3794 0000174B E8D509                   call fputcR
  3795 0000174E 83C404                   add  sp, 4
  3796                                  
  3797                                  ;-64     i++;
  3798                                  
  3799 00001751 FF46FE                   inc  word [bp-2]
  3800                                  
  3801                                  ;-65   } while (i < BinLen);
  3802                                  
  3803 00001754 8B46FE                   mov ax, [bp-2]
  3804 00001757 3B06[4A00]               cmp ax, [BinLen]
  3805 0000175B 0F8D0200                 jge @@epilog134
  3806 0000175F EBD6                     jmp @@epilog133
  3807                                  @@epilog134:
  3808                                  
  3809                                  ;-66 }
  3810                                  
  3811                                  
  3812                                  ;-67 int end1(int n) {
  3813 00001761 C9                       LEAVE
  3814 00001762 C3                       ret
  3815                                  ; ENDP
  3816 00001763 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  3817 0000176C 726F72733A2000     
  3818 00001773 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  3819 0000177C 2A2A2A2000         
  3820 00001781 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  3821 0000178A 652000             
  3822 0000178D 2062797465732E00        epilog_3 db " bytes.",0
  3823                                  
  3824                                  end1:  ; *** PROC ***
  3825                                  
  3826                                  ;-68   fcloseR(asm_fd);
  3827                                  
  3828                                  ;Function : end1, Number of local variables: 1
  3829                                  ;   # type sign width line used address name   list of local variables
  3830                                  ;  200 var sign word    67 NULL bp+4    n;
  3831 00001795 C8000000                 ENTER  0,0
  3832 00001799 FF36[1D00]               push word [asm_fd]
  3833 0000179D E89809                   call fcloseR
  3834 000017A0 83C402                   add  sp, 2
  3835                                  
  3836                                  ;-69   fcloseR(lst_fd);
  3837                                  
  3838 000017A3 FF36[1F00]               push word [lst_fd]
  3839 000017A7 E88E09                   call fcloseR
  3840 000017AA 83C402                   add  sp, 2
  3841                                  
  3842                                  ;-70   fcloseR(bin_fd);
  3843                                  
  3844 000017AD FF36[2100]               push word [bin_fd]
  3845 000017B1 E88409                   call fcloseR
  3846 000017B4 83C402                   add  sp, 2
  3847                                  
  3848                                  ;-71   exitR(n);
  3849                                  
  3850 000017B7 FF7604                   push word [bp+4]
  3851 000017BA E88909                   call exitR
  3852 000017BD 83C402                   add  sp, 2
  3853                                  
  3854                                  ;-72 }
  3855 000017C0 C9                       LEAVE
  3856 000017C1 C3                       ret
  3857                                  ; ENDP
  3858                                  ;Back to main program: AS.C
  3859                                  
  3860                                  ;-9 #include "GENCODE.C"
  3861                                  
  3862                                  ;Use include file: GENCODE.C
  3863                                  
  3864                                  ;-1 // generate code
  3865                                  
  3866                                  
  3867                                  ;-2 int getCodes() {
  3868                                  
  3869                                  
  3870                                  getCodes:  ; *** PROC ***
  3871                                  
  3872                                  ;-3   OpCodePtr ++; Code1 = *OpCodePtr;
  3873                                  
  3874 000017C2 FF06[4100]               inc  word [OpCodePtr]
  3875 000017C6 8B1E[4100]               mov bx, [OpCodePtr]
  3876 000017CA 8A07                     mov al, [bx]
  3877 000017CC B400                     mov ah, 0
  3878 000017CE A2[3200]                 mov byte [Code1], al
  3879                                  
  3880                                  ;-4   OpCodePtr ++; Code2 = *OpCodePtr;
  3881                                  
  3882 000017D1 FF06[4100]               inc  word [OpCodePtr]
  3883 000017D5 8B1E[4100]               mov bx, [OpCodePtr]
  3884 000017D9 8A07                     mov al, [bx]
  3885 000017DB B400                     mov ah, 0
  3886 000017DD A2[3300]                 mov byte [Code2], al
  3887                                  
  3888                                  ;-5   OpCodePtr ++; Code3 = *OpCodePtr;
  3889                                  
  3890 000017E0 FF06[4100]               inc  word [OpCodePtr]
  3891 000017E4 8B1E[4100]               mov bx, [OpCodePtr]
  3892 000017E8 8A07                     mov al, [bx]
  3893 000017EA B400                     mov ah, 0
  3894 000017EC A2[3400]                 mov byte [Code3], al
  3895                                  
  3896                                  ;-6 }
  3897                                  
  3898                                  
  3899                                  ;-7 int gen66h() {genCode8(0x66);
  3900                                  
  3901 000017EF C3                       ret
  3902                                  ; ENDP
  3903                                  
  3904                                  gen66h:  ; *** PROC ***
  3905 000017F0 6A66                     push 102
  3906 000017F2 E81F00                   call genCode8
  3907 000017F5 83C402                   add  sp, 2
  3908                                  
  3909                                  ;-8 }
  3910                                  
  3911                                  
  3912                                  ;-9 int genCode(char c, char d) {
  3913                                  
  3914 000017F8 C3                       ret
  3915                                  ; ENDP
  3916                                  
  3917                                  genCode:  ; *** PROC ***
  3918                                  
  3919                                  ;-10     c = c + d;
  3920                                  
  3921                                  ;Function : genCode, Number of local variables: 2
  3922                                  ;   # type sign width line used address name   list of local variables
  3923                                  ;  200 var sign byte     9 NULL bp+4    c
  3924                                  ;  201 var sign byte     9 NULL bp+6    d;
  3925 000017F9 C8000000                 ENTER  0,0
  3926 000017FD 8A4604                   mov al, [bp+4]
  3927 00001800 024606                   add al, [bp+6]
  3928 00001803 884604                   mov byte [bp+4], al
  3929                                  
  3930                                  ;-11     genCode8(c);
  3931                                  
  3932 00001806 8A4604                   mov al, byte [bp+4]
  3933 00001809 B400                     mov ah, 0
  3934 0000180B 50                       push ax
  3935 0000180C E80500                   call genCode8
  3936 0000180F 83C402                   add  sp, 2
  3937                                  
  3938                                  ;-12 }
  3939                                  
  3940                                  
  3941                                  ;-13 int genCode8(char c) {
  3942 00001812 C9                       LEAVE
  3943 00001813 C3                       ret
  3944                                  ; ENDP
  3945                                  
  3946                                  genCode8:  ; *** PROC ***
  3947                                  
  3948                                  ;-14 //set: BinLen++, OpPrintIndex++
  3949                                  
  3950                                  
  3951                                  ;-15   FileBin[BinLen]=c;
  3952                                  
  3953                                  ;Function : genCode8, Number of local variables: 1
  3954                                  ;   # type sign width line used address name   list of local variables
  3955                                  ;  200 var sign byte    13 NULL bp+4    c;
  3956 00001814 C8000000                 ENTER  0,0
  3957 00001818 8A4604                   mov al, [bp+4]
  3958 0000181B 8B1E[4A00]               mov bx, [BinLen]
  3959 0000181F 88876B7B                 mov [FileBin+bx], al
  3960                                  
  3961                                  ;-16   BinLen++;
  3962                                  
  3963 00001823 FF06[4A00]               inc  word [BinLen]
  3964                                  
  3965                                  ;-17   PC++;
  3966                                  
  3967 00001827 FF06[2A00]               inc  word [PC]
  3968                                  
  3969                                  ;-18   if (BinLen >= FILEBINMAX) errorexit("COM file to long");
  3970                                  
  3971 0000182B A1[4A00]                 mov ax, [BinLen]
  3972 0000182E 3DD007                   cmp ax, 2000 ;unsigned : 0
  3973 00001831 0F820900                 jb  @@genCode8135
  3974 00001835 68[5918]                 push genCode8_0
  3975 00001838 E8F8FB                   call errorexit
  3976 0000183B 83C402                   add  sp, 2
  3977                                  
  3978                                  ;-19   if (OpPrintIndex < OPMAXLEN) {
  3979                                  
  3980                                  @@genCode8135:
  3981 0000183E A1[3F00]                 mov ax, [OpPrintIndex]
  3982 00001841 83F805                   cmp ax, 5
  3983 00001844 0F8D0F00                 jge @@genCode8136
  3984                                  
  3985                                  ;-20     OpPos[OpPrintIndex]=c;
  3986                                  
  3987 00001848 8A4604                   mov al, [bp+4]
  3988 0000184B 8B1E[3F00]               mov bx, [OpPrintIndex]
  3989 0000184F 8887B676                 mov [OpPos+bx], al
  3990                                  
  3991                                  ;-21     OpPrintIndex++;
  3992                                  
  3993 00001853 FF06[3F00]               inc  word [OpPrintIndex]
  3994                                  
  3995                                  ;-22   }
  3996                                  
  3997                                  
  3998                                  ;-23 }
  3999                                  
  4000                                  @@genCode8136:
  4001                                  
  4002                                  ;-24 int genCode16(unsigned int i) {
  4003 00001857 C9                       LEAVE
  4004 00001858 C3                       ret
  4005                                  ; ENDP
  4006 00001859 434F4D2066696C6520-     genCode8_0 db "COM file to long",0
  4007 00001862 746F206C6F6E6700   
  4008                                  
  4009                                  genCode16:  ; *** PROC ***
  4010                                  
  4011                                  ;-25   genCode8(i); i=i >> 8;
  4012                                  
  4013                                  ;Function : genCode16, Number of local variables: 1
  4014                                  ;   # type sign width line used address name   list of local variables
  4015                                  ;  200 var unsg word    24 NULL bp+4    i;
  4016 0000186A C8000000                 ENTER  0,0
  4017 0000186E FF7604                   push word [bp+4]
  4018 00001871 E8A0FF                   call genCode8
  4019 00001874 83C402                   add  sp, 2
  4020 00001877 8B4604                   mov ax, [bp+4]
  4021 0000187A C1E808                   shr ax, 8
  4022 0000187D 894604                   mov word [bp+4], ax
  4023                                  
  4024                                  ;-26   genCode8(i);
  4025                                  
  4026 00001880 FF7604                   push word [bp+4]
  4027 00001883 E88EFF                   call genCode8
  4028 00001886 83C402                   add  sp, 2
  4029                                  
  4030                                  ;-27 }
  4031                                  
  4032                                  
  4033                                  ;-28 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  4034 00001889 C9                       LEAVE
  4035 0000188A C3                       ret
  4036                                  ; ENDP
  4037                                  
  4038                                  writeEA:  ; *** PROC ***
  4039                                  
  4040                                  ;-29 //mod-byte: mode76, reg/opcode543, r/m210    
  4041                                  
  4042                                  
  4043                                  ;-30   char len;
  4044                                  
  4045                                  
  4046                                  ;-31   len=0;
  4047                                  
  4048                                  ;Function : writeEA, Number of local variables: 2
  4049                                  ;   # type sign width line used address name   list of local variables
  4050                                  ;  200 var sign byte    28 NULL bp+4    xxx
  4051                                  ;  201 var sign byte    30 NULL bp-2    len;
  4052 0000188B C8020000                 ENTER  2,0
  4053 0000188F 66B800000000             mov eax, 0
  4054 00001895 8846FE                   mov byte [bp-2], al
  4055                                  
  4056                                  ;-32   xxx = xxx << 3;//in reg/opcode field
  4057                                  
  4058 00001898 8A4604                   mov al, [bp+4]
  4059 0000189B C0E003                   shl al, 3
  4060 0000189E 884604                   mov byte [bp+4], al
  4061                                  
  4062                                  ;-33 //  prs("\nxxx:"); printhex8a(xxx);
  4063                                  
  4064                                  
  4065                                  ;-34   if (Op1 ==   0) addrexit();
  4066                                  
  4067 000018A1 A0[3000]                 mov al, [Op1]
  4068 000018A4 3C00                     cmp al, 0
  4069 000018A6 0F850300                 jne @@writeEA137
  4070 000018AA E89DFB                   call addrexit
  4071                                  
  4072                                  ;-35   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  4073                                  
  4074                                  @@writeEA137:
  4075 000018AD A0[3000]                 mov al, [Op1]
  4076 000018B0 3C02                     cmp al, 2
  4077 000018B2 0F850E00                 jne @@writeEA138
  4078 000018B6 804E04C0                 or  byte [bp+4], 192
  4079 000018BA 8A4604                   mov al, [bp+4]
  4080 000018BD 0206[3600]               add al, [RegNo]
  4081 000018C1 884604                   mov byte [bp+4], al
  4082                                  
  4083                                  ;-36   if (Op1 == ADR) error1("writeEA");           
  4084                                  
  4085                                  @@writeEA138:
  4086 000018C4 A0[3000]                 mov al, [Op1]
  4087 000018C7 3C03                     cmp al, 3
  4088 000018C9 0F850900                 jne @@writeEA139
  4089 000018CD 68[9219]                 push writeEA_0
  4090 000018D0 E8CBF9                   call error1
  4091 000018D3 83C402                   add  sp, 2
  4092                                  
  4093                                  ;-37   if (Op1 == MEM) {
  4094                                  
  4095                                  @@writeEA139:
  4096 000018D6 A0[3000]                 mov al, [Op1]
  4097 000018D9 3C04                     cmp al, 4
  4098 000018DB 0F857F00                 jne @@writeEA140
  4099                                  
  4100                                  ;-38     if (isDirect) {
  4101                                  
  4102 000018DF A0[3A00]                 mov al, [isDirect]
  4103 000018E2 08C0                     or  al, al
  4104 000018E4 0F841000                 je @@writeEA141
  4105                                  
  4106                                  ;-39         xxx |= 6;
  4107                                  
  4108 000018E8 804E0406                 or  byte [bp+4], 6
  4109                                  
  4110                                  ;-40         len = 2;
  4111                                  
  4112 000018EC 66B802000000             mov eax, 2
  4113 000018F2 8846FE                   mov byte [bp-2], al
  4114                                  
  4115                                  ;-41     }
  4116                                  
  4117                                  
  4118                                  ;-42     else { 
  4119                                  
  4120 000018F5 E96600                   jmp @@writeEA142
  4121                                  @@writeEA141:
  4122                                  
  4123                                  ;-43       xxx = xxx + regindexbase;   
  4124                                  
  4125 000018F8 8A4604                   mov al, [bp+4]
  4126 000018FB 0206[3900]               add al, [regindexbase]
  4127 000018FF 884604                   mov byte [bp+4], al
  4128                                  
  4129                                  ;-44       if (regindexbase == 6) {//make [BP+00]
  4130                                  
  4131 00001902 A0[3900]                 mov al, [regindexbase]
  4132 00001905 3C06                     cmp al, 6
  4133 00001907 0F851700                 jne @@writeEA143
  4134                                  
  4135                                  ;-45         len=1;
  4136                                  
  4137 0000190B 66B801000000             mov eax, 1
  4138 00001911 8846FE                   mov byte [bp-2], al
  4139                                  
  4140                                  ;-46         if (disp == 0) xxx |= 0x40;
  4141                                  
  4142 00001914 A1[3B00]                 mov ax, [disp]
  4143 00001917 83F800                   cmp ax, 0
  4144 0000191A 0F850400                 jne @@writeEA144
  4145 0000191E 804E0440                 or  byte [bp+4], 64
  4146                                  
  4147                                  ;-47       }
  4148                                  
  4149                                  @@writeEA144:
  4150                                  
  4151                                  ;-48 
  4152                                  
  4153                                  
  4154                                  ;-49       if (disp) {
  4155                                  
  4156                                  @@writeEA143:
  4157 00001922 A1[3B00]                 mov ax, [disp]
  4158 00001925 08C0                     or  al, al
  4159 00001927 0F843300                 je @@writeEA145
  4160                                  
  4161                                  ;-50         ax = disp;
  4162                                  
  4163 0000192B A1[3B00]                 mov  ax, [disp]
  4164                                  
  4165                                  ;-51         if(ax > 127) len=2;
  4166                                  
  4167 0000192E 83F87F                   cmp  ax, 127
  4168 00001931 0F8E0C00                 jle @@writeEA146
  4169 00001935 66B802000000             mov eax, 2
  4170 0000193B 8846FE                   mov byte [bp-2], al
  4171                                  
  4172                                  ;-52         else len=1;
  4173                                  
  4174 0000193E E90900                   jmp @@writeEA147
  4175                                  @@writeEA146:
  4176 00001941 66B801000000             mov eax, 1
  4177 00001947 8846FE                   mov byte [bp-2], al
  4178                                  
  4179                                  ;-53         if (len == 1) xxx |= 0x40;
  4180                                  
  4181                                  @@writeEA147:
  4182 0000194A 8A46FE                   mov al, [bp-2]
  4183 0000194D 3C01                     cmp al, 1
  4184 0000194F 0F850700                 jne @@writeEA148
  4185 00001953 804E0440                 or  byte [bp+4], 64
  4186                                  
  4187                                  ;-54         else xxx |= 0x80;
  4188                                  
  4189 00001957 E90400                   jmp @@writeEA149
  4190                                  @@writeEA148:
  4191 0000195A 804E0480                 or  byte [bp+4], 128
  4192                                  
  4193                                  ;-55       }
  4194                                  
  4195                                  @@writeEA149:
  4196                                  
  4197                                  ;-56     }
  4198                                  
  4199                                  @@writeEA145:
  4200                                  
  4201                                  ;-57   }
  4202                                  
  4203                                  @@writeEA142:
  4204                                  
  4205                                  ;-58   genCode8(xxx);// gen second byte
  4206                                  
  4207                                  @@writeEA140:
  4208 0000195E 8A4604                   mov al, byte [bp+4]
  4209 00001961 B400                     mov ah, 0
  4210 00001963 50                       push ax
  4211 00001964 E8ADFE                   call genCode8
  4212 00001967 83C402                   add  sp, 2
  4213                                  
  4214                                  ;-59   if (len == 1) genCode8 (disp);
  4215                                  
  4216 0000196A 8A46FE                   mov al, [bp-2]
  4217 0000196D 3C01                     cmp al, 1
  4218 0000196F 0F850A00                 jne @@writeEA150
  4219 00001973 FF36[3B00]               push word [disp]
  4220 00001977 E89AFE                   call genCode8
  4221 0000197A 83C402                   add  sp, 2
  4222                                  
  4223                                  ;-60   if (len == 2) genCode16(disp);
  4224                                  
  4225                                  @@writeEA150:
  4226 0000197D 8A46FE                   mov al, [bp-2]
  4227 00001980 3C02                     cmp al, 2
  4228 00001982 0F850A00                 jne @@writeEA151
  4229 00001986 FF36[3B00]               push word [disp]
  4230 0000198A E8DDFE                   call genCode16
  4231 0000198D 83C402                   add  sp, 2
  4232                                  
  4233                                  ;-61 }
  4234                                  
  4235 00001990 C9                      @@writeEA151: LEAVE
  4236 00001991 C3                       ret
  4237                                  ; ENDP
  4238 00001992 7772697465454100        writeEA_0 db "writeEA",0
  4239                                  ;Back to main program: AS.C
  4240                                  
  4241                                  ;-10 
  4242                                  
  4243                                  
  4244                                  ;-11 int process() {
  4245                                  
  4246                                  
  4247                                  process:  ; *** PROC ***
  4248                                  
  4249                                  ;-12   char r1;//temp for 1. register
  4250                                  
  4251                                  
  4252                                  ;-13   getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4253                                  
  4254                                  ;Function : process, Number of local variables: 1
  4255                                  ;   # type sign width line used address name   list of local variables
  4256                                  ;  200 var sign byte    12 NULL bp-2    r1;
  4257 0000199A C8020000                 ENTER  2,0
  4258 0000199E E890EB                   call getTokeType
  4259                                  
  4260                                  ;-14   OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4261                                  
  4262 000019A1 E887EE                   call getCodeSize
  4263 000019A4 A2[3700]                 mov byte [OpSize], al
  4264                                  
  4265                                  ;-15   getCodes();//set: Code1, Code2, Code3
  4266                                  
  4267 000019A7 E818FE                   call getCodes
  4268                                  
  4269                                  ;-16 
  4270                                  
  4271                                  
  4272                                  ;-17   if (CodeType ==  1) {//1 byte opcode
  4273                                  
  4274 000019AA A0[3100]                 mov al, [CodeType]
  4275 000019AD 3C01                     cmp al, 1
  4276 000019AF 0F850F00                 jne @@process152
  4277                                  
  4278                                  ;-18     genCode8(Code1);
  4279                                  
  4280 000019B3 A0[3200]                 mov al, byte [Code1]
  4281 000019B6 B400                     mov ah, 0
  4282 000019B8 50                       push ax
  4283 000019B9 E858FE                   call genCode8
  4284 000019BC 83C402                   add  sp, 2
  4285                                  
  4286                                  ;-19     return;
  4287                                  
  4288 000019BF E95F01                   jmp @@retn
  4289                                  
  4290                                  ;-20   }
  4291                                  
  4292                                  
  4293                                  ;-21   
  4294                                  
  4295                                  
  4296                                  ;-22   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4297                                  
  4298                                  @@process152:
  4299 000019C2 A0[3100]                 mov al, [CodeType]
  4300 000019C5 3C02                     cmp al, 2
  4301 000019C7 0F858A00                 jne @@process153
  4302                                  
  4303                                  ;-23     checkOp();
  4304                                  
  4305 000019CB E87901                   call checkOp
  4306                                  
  4307                                  ;-24     if (Code2 <= 1) {//inc,dec
  4308                                  
  4309 000019CE A0[3300]                 mov al, [Code2]
  4310 000019D1 3C01                     cmp al, 1
  4311 000019D3 0F8F4500                 jg  @@process154
  4312                                  
  4313                                  ;-25   	if (Op1 == REG) {
  4314                                  
  4315 000019D7 A0[3000]                 mov al, [Op1]
  4316 000019DA 3C02                     cmp al, 2
  4317 000019DC 0F853C00                 jne @@process155
  4318                                  
  4319                                  ;-26       if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
  4320                                  
  4321 000019E0 A0[3500]                 mov al, [RegType]
  4322 000019E3 3C02                     cmp al, 2
  4323 000019E5 0F851500                 jne @@process156
  4324 000019E9 A0[3600]                 mov al, byte [RegNo]
  4325 000019EC B400                     mov ah, 0
  4326 000019EE 50                       push ax
  4327 000019EF A0[3400]                 mov al, byte [Code3]
  4328 000019F2 B400                     mov ah, 0
  4329 000019F4 50                       push ax
  4330 000019F5 E801FE                   call genCode
  4331 000019F8 83C404                   add  sp, 4
  4332 000019FB E92301                   jmp @@retn
  4333                                  
  4334                                  ;-27       if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
  4335                                  
  4336                                  @@process156:
  4337 000019FE A0[3500]                 mov al, [RegType]
  4338 00001A01 3C03                     cmp al, 3
  4339 00001A03 0F851500                 jne @@process157
  4340 00001A07 A0[3600]                 mov al, byte [RegNo]
  4341 00001A0A B400                     mov ah, 0
  4342 00001A0C 50                       push ax
  4343 00001A0D A0[3400]                 mov al, byte [Code3]
  4344 00001A10 B400                     mov ah, 0
  4345 00001A12 50                       push ax
  4346 00001A13 E8E3FD                   call genCode
  4347 00001A16 83C404                   add  sp, 4
  4348 00001A19 E90501                   jmp @@retn
  4349                                  
  4350                                  ;-28       }
  4351                                  
  4352                                  @@process157:
  4353                                  
  4354                                  ;-29     }
  4355                                  
  4356                                  @@process155:
  4357                                  
  4358                                  ;-30     if (Code2 == 5) {//imul extension?
  4359                                  
  4360                                  @@process154:
  4361 00001A1C A0[3300]                 mov al, [Code2]
  4362 00001A1F 3C05                     cmp al, 5
  4363 00001A21 0F850F00                 jne @@process158
  4364                                  
  4365                                  ;-31       getTokeType();
  4366                                  
  4367 00001A25 E809EB                   call getTokeType
  4368                                  
  4369                                  ;-32       if (TokeType) implerror();
  4370                                  
  4371 00001A28 A0[2F00]                 mov al, [TokeType]
  4372 00001A2B 08C0                     or  al, al
  4373 00001A2D 0F840300                 je @@process159
  4374 00001A31 E8FFF8                   call implerror
  4375                                  
  4376                                  ;-33     }
  4377                                  
  4378                                  @@process159:
  4379                                  
  4380                                  ;-34     genCode(Code1, wflag);
  4381                                  
  4382                                  @@process158:
  4383 00001A34 A0[3800]                 mov al, byte [wflag]
  4384 00001A37 B400                     mov ah, 0
  4385 00001A39 50                       push ax
  4386 00001A3A A0[3200]                 mov al, byte [Code1]
  4387 00001A3D B400                     mov ah, 0
  4388 00001A3F 50                       push ax
  4389 00001A40 E8B6FD                   call genCode
  4390 00001A43 83C404                   add  sp, 4
  4391                                  
  4392                                  ;-35     writeEA(Code2);
  4393                                  
  4394 00001A46 A0[3300]                 mov al, byte [Code2]
  4395 00001A49 B400                     mov ah, 0
  4396 00001A4B 50                       push ax
  4397 00001A4C E83CFE                   call writeEA
  4398 00001A4F 83C402                   add  sp, 2
  4399                                  
  4400                                  ;-36     return;
  4401                                  
  4402 00001A52 E9CC00                   jmp @@retn
  4403                                  
  4404                                  ;-37   }
  4405                                  
  4406                                  
  4407                                  ;-38   
  4408                                  
  4409                                  
  4410                                  ;-39   if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4411                                  
  4412                                  @@process153:
  4413 00001A55 A0[3100]                 mov al, [CodeType]
  4414 00001A58 3C03                     cmp al, 3
  4415 00001A5A 0F855C00                 jne @@process160
  4416                                  
  4417                                  ;-40     checkOp();
  4418                                  
  4419 00001A5E E8E600                   call checkOp
  4420                                  
  4421                                  ;-41     if (RegType != WORD) reg16error();
  4422                                  
  4423 00001A61 A0[3500]                 mov al, [RegType]
  4424 00001A64 3C02                     cmp al, 2
  4425 00001A66 0F840300                 je  @@process161
  4426 00001A6A E866F9                   call reg16error
  4427                                  
  4428                                  ;-42     r1=RegNo;
  4429                                  
  4430                                  @@process161:
  4431 00001A6D A0[3600]                 mov al, [RegNo]
  4432 00001A70 8846FE                   mov byte [bp-2], al
  4433                                  
  4434                                  ;-43     need(',');    
  4435                                  
  4436 00001A73 6A2C                     push 44
  4437 00001A75 E864EE                   call need
  4438 00001A78 83C402                   add  sp, 2
  4439                                  
  4440                                  ;-44     getOp();
  4441                                  
  4442 00001A7B E87F01                   call getOp
  4443                                  
  4444                                  ;-45     if (Op1 < ADR) addrerror(); 
  4445                                  
  4446 00001A7E A0[3000]                 mov al, [Op1]
  4447 00001A81 3C03                     cmp al, 3
  4448 00001A83 0F8D0300                 jge @@process162
  4449 00001A87 E88EF8                   call addrerror
  4450                                  
  4451                                  ;-46         
  4452                                  
  4453                                  
  4454                                  ;-47     genCode8(Code1);//les,lds,lea
  4455                                  
  4456                                  @@process162:
  4457 00001A8A A0[3200]                 mov al, byte [Code1]
  4458 00001A8D B400                     mov ah, 0
  4459 00001A8F 50                       push ax
  4460 00001A90 E881FD                   call genCode8
  4461 00001A93 83C402                   add  sp, 2
  4462                                  
  4463                                  ;-48     if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  4464                                  
  4465 00001A96 A0[3200]                 mov al, [Code1]
  4466 00001A99 3C0F                     cmp al, 15
  4467 00001A9B 0F850C00                 jne @@process163
  4468 00001A9F A0[3300]                 mov al, byte [Code2]
  4469 00001AA2 B400                     mov ah, 0
  4470 00001AA4 50                       push ax
  4471 00001AA5 E86CFD                   call genCode8
  4472 00001AA8 83C402                   add  sp, 2
  4473                                  
  4474                                  ;-49     writeEA(r1);           
  4475                                  
  4476                                  @@process163:
  4477 00001AAB 8A46FE                   mov al, byte [bp-2]
  4478 00001AAE B400                     mov ah, 0
  4479 00001AB0 50                       push ax
  4480 00001AB1 E8D7FD                   call writeEA
  4481 00001AB4 83C402                   add  sp, 2
  4482                                  
  4483                                  ;-50     return;
  4484                                  
  4485 00001AB7 E96700                   jmp @@retn
  4486                                  
  4487                                  ;-51   }
  4488                                  
  4489                                  
  4490                                  ;-52  
  4491                                  
  4492                                  
  4493                                  ;-53   if (CodeType ==  8) {//ret,retf
  4494                                  
  4495                                  @@process160:
  4496 00001ABA A0[3100]                 mov al, [CodeType]
  4497 00001ABD 3C08                     cmp al, 8
  4498 00001ABF 0F853100                 jne @@process164
  4499                                  
  4500                                  ;-54     if (TokeType == DIGIT) {
  4501                                  
  4502 00001AC3 A0[2F00]                 mov al, [TokeType]
  4503 00001AC6 3C01                     cmp al, 1
  4504 00001AC8 0F851900                 jne @@process165
  4505                                  
  4506                                  ;-55       genCode8(Code2);
  4507                                  
  4508 00001ACC A0[3300]                 mov al, byte [Code2]
  4509 00001ACF B400                     mov ah, 0
  4510 00001AD1 50                       push ax
  4511 00001AD2 E83FFD                   call genCode8
  4512 00001AD5 83C402                   add  sp, 2
  4513                                  
  4514                                  ;-56       genCode16(SymbolInt);
  4515                                  
  4516 00001AD8 FF36[1900]               push word [SymbolInt]
  4517 00001ADC E88BFD                   call genCode16
  4518 00001ADF 83C402                   add  sp, 2
  4519                                  
  4520                                  ;-57       return;
  4521                                  
  4522 00001AE2 E93C00                   jmp @@retn
  4523                                  
  4524                                  ;-58     }
  4525                                  
  4526                                  
  4527                                  ;-59     genCode8(Code1); 
  4528                                  
  4529                                  @@process165:
  4530 00001AE5 A0[3200]                 mov al, byte [Code1]
  4531 00001AE8 B400                     mov ah, 0
  4532 00001AEA 50                       push ax
  4533 00001AEB E826FD                   call genCode8
  4534 00001AEE 83C402                   add  sp, 2
  4535                                  
  4536                                  ;-60     return;
  4537                                  
  4538 00001AF1 E92D00                   jmp @@retn
  4539                                  
  4540                                  ;-61   }
  4541                                  
  4542                                  
  4543                                  ;-62 
  4544                                  
  4545                                  
  4546                                  ;-63   if (CodeType==101) {// ORG nn
  4547                                  
  4548                                  @@process164:
  4549 00001AF4 A0[3100]                 mov al, [CodeType]
  4550 00001AF7 3C65                     cmp al, 101
  4551 00001AF9 0F851B00                 jne @@process166
  4552                                  
  4553                                  ;-64     if (TokeType != DIGIT) error1("only digit allowed");
  4554                                  
  4555 00001AFD A0[2F00]                 mov al, [TokeType]
  4556 00001B00 3C01                     cmp al, 1
  4557 00001B02 0F840900                 je  @@process167
  4558 00001B06 68[231B]                 push process_0
  4559 00001B09 E892F7                   call error1
  4560 00001B0C 83C402                   add  sp, 2
  4561                                  
  4562                                  ;-65     PC=SymbolInt;return;
  4563                                  
  4564                                  @@process167:
  4565 00001B0F A1[1900]                 mov ax, [SymbolInt]
  4566 00001B12 A3[2A00]                 mov word [PC], ax
  4567 00001B15 E90900                   jmp @@retn
  4568                                  
  4569                                  ;-66   }
  4570                                  
  4571                                  
  4572                                  ;-67   error1("unknown CodeType");
  4573                                  
  4574                                  @@process166:
  4575 00001B18 68[361B]                 push process_1
  4576 00001B1B E880F7                   call error1
  4577 00001B1E 83C402                   add  sp, 2
  4578                                  
  4579                                  ;-68 }
  4580                                  
  4581                                  
  4582                                  ;-69 
  4583                                  
  4584                                  
  4585                                  ;-70 int checkOp() {
  4586                                  
  4587 00001B21 C9                      @@retn: LEAVE
  4588 00001B22 C3                       ret
  4589                                  ; ENDP
  4590 00001B23 6F6E6C792064696769-     process_0 db "only digit allowed",0
  4591 00001B2C 7420616C6C6F776564-
  4592 00001B35 00                 
  4593 00001B36 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  4594 00001B3F 6F64655479706500   
  4595                                  
  4596                                  checkOp:  ; *** PROC ***
  4597                                  
  4598                                  ;-71   getOp();
  4599                                  
  4600 00001B47 E8B300                   call getOp
  4601                                  
  4602                                  ;-72   if (Op1 == ADR) implerror();
  4603                                  
  4604 00001B4A A0[3000]                 mov al, [Op1]
  4605 00001B4D 3C03                     cmp al, 3
  4606 00001B4F 0F850300                 jne @@checkOp168
  4607 00001B53 E8DDF7                   call implerror
  4608                                  
  4609                                  ;-73   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  4610                                  
  4611                                  @@checkOp168:
  4612 00001B56 A0[3500]                 mov al, [RegType]
  4613 00001B59 3C04                     cmp al, 4
  4614 00001B5B 0F850600                 jne @@checkOp169
  4615 00001B5F E899F8                   call segregerror
  4616 00001B62 E95300                   jmp @@retn
  4617                                  
  4618                                  ;-74   setwflag();
  4619                                  
  4620                                  @@checkOp169:
  4621 00001B65 E84801                   call setwflag
  4622                                  
  4623                                  ;-75   if (OpSize == 0) error1("no op size declared");
  4624                                  
  4625 00001B68 A0[3700]                 mov al, [OpSize]
  4626 00001B6B 3C00                     cmp al, 0
  4627 00001B6D 0F850900                 jne @@checkOp170
  4628 00001B71 68[B91B]                 push checkOp_0
  4629 00001B74 E827F7                   call error1
  4630 00001B77 83C402                   add  sp, 2
  4631                                  
  4632                                  ;-76   if (OpSize == RegType) return;
  4633                                  
  4634                                  @@checkOp170:
  4635 00001B7A A0[3700]                 mov al, [OpSize]
  4636 00001B7D 3A06[3500]               cmp al, [RegType]
  4637 00001B81 0F850300                 jne @@checkOp171
  4638 00001B85 E93000                   jmp @@retn
  4639                                  
  4640                                  ;-77   if (OpSize){if (Op1 == MEM) return;
  4641                                  
  4642                                  @@checkOp171:
  4643 00001B88 A0[3700]                 mov al, [OpSize]
  4644 00001B8B 08C0                     or  al, al
  4645 00001B8D 0F841500                 je @@checkOp172
  4646 00001B91 A0[3000]                 mov al, [Op1]
  4647 00001B94 3C04                     cmp al, 4
  4648 00001B96 0F850300                 jne @@checkOp173
  4649 00001B9A E91B00                   jmp @@retn
  4650                                  
  4651                                  ;-78     error1("Conflict OpSize and RegSize"); }
  4652                                  
  4653                                  @@checkOp173:
  4654 00001B9D 68[CD1B]                 push checkOp_1
  4655 00001BA0 E8FBF6                   call error1
  4656 00001BA3 83C402                   add  sp, 2
  4657                                  
  4658                                  ;-79   if (RegType==0) error1("no register defined");
  4659                                  
  4660                                  @@checkOp172:
  4661 00001BA6 A0[3500]                 mov al, [RegType]
  4662 00001BA9 3C00                     cmp al, 0
  4663 00001BAB 0F850900                 jne @@checkOp174
  4664 00001BAF 68[E91B]                 push checkOp_2
  4665 00001BB2 E8E9F6                   call error1
  4666 00001BB5 83C402                   add  sp, 2
  4667                                  
  4668                                  ;-80 }
  4669                                  
  4670                                  @@checkOp174:
  4671                                  
  4672                                  ;-81 /*        Op      = 0, IMM, REG, ADR, MEM
  4673                                  
  4674                                  
  4675                                  ;-82 IMM       imme    = 0, SymbolInt    
  4676                                  
  4677                                  
  4678                                  ;-83 REG     R RegNo   = 0 - 7
  4679                                  
  4680                                  
  4681                                  ;-84 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  4682                                  
  4683                                  
  4684                                  ;-85 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  4685                                  
  4686                                  
  4687                                  ;-86 MEM       regindexbase = 0 - 7
  4688                                  
  4689                                  
  4690                                  ;-87           OpSize  = 0, BYTE, WORD, DWORD (set wflag) */
  4691                                  
  4692                                  
  4693                                  ;-88 int getOp() {
  4694                                  
  4695                                  @@retn:
  4696 00001BB8 C3                       ret
  4697                                  ; ENDP
  4698 00001BB9 6E6F206F702073697A-     checkOp_0 db "no op size declared",0
  4699 00001BC2 65206465636C617265-
  4700 00001BCB 6400               
  4701 00001BCD 436F6E666C69637420-     checkOp_1 db "Conflict OpSize and RegSize",0
  4702 00001BD6 4F7053697A6520616E-
  4703 00001BDF 642052656753697A65-
  4704 00001BE8 00                 
  4705 00001BE9 6E6F20726567697374-     checkOp_2 db "no register defined",0
  4706 00001BF2 657220646566696E65-
  4707 00001BFB 6400               
  4708                                  
  4709                                  getOp:  ; *** PROC ***
  4710                                  
  4711                                  ;-89 //set: op1=0,IMM,REG,ADR,MEM
  4712                                  
  4713                                  
  4714                                  ;-90   disp=0; imme=0; regindexbase=0; isDirect=1;
  4715                                  
  4716 00001BFD 66B800000000             mov eax, 0
  4717 00001C03 A3[3B00]                 mov word [disp], ax
  4718 00001C06 66B800000000             mov eax, 0
  4719 00001C0C A3[3D00]                 mov word [imme], ax
  4720 00001C0F 66B800000000             mov eax, 0
  4721 00001C15 A2[3900]                 mov byte [regindexbase], al
  4722 00001C18 66B801000000             mov eax, 1
  4723 00001C1E A2[3A00]                 mov byte [isDirect], al
  4724                                  
  4725                                  ;-91 
  4726                                  
  4727                                  
  4728                                  ;-92   Op1=getOp1();
  4729                                  
  4730 00001C21 E8E700                   call getOp1
  4731 00001C24 A2[3000]                 mov byte [Op1], al
  4732                                  
  4733                                  ;-93   if (isToken('[')) {Op1 = MEM; getMEM();    return;}
  4734                                  
  4735 00001C27 6A5B                     push 91
  4736 00001C29 E882EC                   call isToken
  4737 00001C2C 83C402                   add  sp, 2
  4738 00001C2F 08C0                     or  al, al
  4739 00001C31 0F840F00                 je @@getOp175
  4740 00001C35 66B804000000             mov eax, 4
  4741 00001C3B A2[3000]                 mov byte [Op1], al
  4742 00001C3E E85001                   call getMEM
  4743 00001C41 E94F00                   jmp @@retn
  4744                                  
  4745                                  ;-94   if (Op1 == 0)     {invaloperror();         return;}
  4746                                  
  4747                                  @@getOp175:
  4748 00001C44 A0[3000]                 mov al, [Op1]
  4749 00001C47 3C00                     cmp al, 0
  4750 00001C49 0F850600                 jne @@getOp176
  4751 00001C4D E81EF7                   call invaloperror
  4752 00001C50 E94000                   jmp @@retn
  4753                                  
  4754                                  ;-95   if (Op1 == IMM)   {imme=SymbolInt;         return;}
  4755                                  
  4756                                  @@getOp176:
  4757 00001C53 A0[3000]                 mov al, [Op1]
  4758 00001C56 3C01                     cmp al, 1
  4759 00001C58 0F850900                 jne @@getOp177
  4760 00001C5C A1[1900]                 mov ax, [SymbolInt]
  4761 00001C5F A3[3D00]                 mov word [imme], ax
  4762 00001C62 E92E00                   jmp @@retn
  4763                                  
  4764                                  ;-96   if (Op1 == REG)                            return;
  4765                                  
  4766                                  @@getOp177:
  4767 00001C65 A0[3000]                 mov al, [Op1]
  4768 00001C68 3C02                     cmp al, 2
  4769 00001C6A 0F850300                 jne @@getOp178
  4770 00001C6E E92200                   jmp @@retn
  4771                                  
  4772                                  ;-97   if (Op1 == ADR)   {disp=LabelAddr[LabelIx];return;}
  4773                                  
  4774                                  @@getOp178:
  4775 00001C71 A0[3000]                 mov al, [Op1]
  4776 00001C74 3C03                     cmp al, 3
  4777 00001C76 0F851000                 jne @@getOp179
  4778 00001C7A 8B1E[4800]               mov bx, [LabelIx]
  4779 00001C7E D1E3                     shl bx, 1
  4780 00001C80 8B87A37A                 mov ax, [LabelAddr + bx]
  4781 00001C84 A3[3B00]                 mov word [disp], ax
  4782 00001C87 E90900                   jmp @@retn
  4783                                  
  4784                                  ;-98   error1("Name of operand expected #1");
  4785                                  
  4786                                  @@getOp179:
  4787 00001C8A 68[941C]                 push getOp_0
  4788 00001C8D E80EF6                   call error1
  4789 00001C90 83C402                   add  sp, 2
  4790                                  
  4791                                  ;-99 }
  4792                                  
  4793                                  
  4794                                  ;-100 
  4795                                  
  4796                                  
  4797                                  ;-101 int setwflag() {//only Op1 (first operand)
  4798                                  
  4799                                  @@retn:
  4800 00001C93 C3                       ret
  4801                                  ; ENDP
  4802 00001C94 4E616D65206F66206F-     getOp_0 db "Name of operand expected #1",0
  4803 00001C9D 706572616E64206578-
  4804 00001CA6 706563746564202331-
  4805 00001CAF 00                 
  4806                                  
  4807                                  setwflag:  ; *** PROC ***
  4808                                  
  4809                                  ;-102   wflag=0;
  4810                                  
  4811 00001CB0 66B800000000             mov eax, 0
  4812 00001CB6 A2[3800]                 mov byte [wflag], al
  4813                                  
  4814                                  ;-103   if (OpSize == 0) {//do not override OpSize
  4815                                  
  4816 00001CB9 A0[3700]                 mov al, [OpSize]
  4817 00001CBC 3C00                     cmp al, 0
  4818 00001CBE 0F852100                 jne @@setwflag180
  4819                                  
  4820                                  ;-104     if (Op1 == REG) {
  4821                                  
  4822 00001CC2 A0[3000]                 mov al, [Op1]
  4823 00001CC5 3C02                     cmp al, 2
  4824 00001CC7 0F851800                 jne @@setwflag181
  4825                                  
  4826                                  ;-105       OpSize=RegType;
  4827                                  
  4828 00001CCB A0[3500]                 mov al, [RegType]
  4829 00001CCE A2[3700]                 mov byte [OpSize], al
  4830                                  
  4831                                  ;-106       if (RegType == SEGREG) OpSize=WORD;
  4832                                  
  4833 00001CD1 A0[3500]                 mov al, [RegType]
  4834 00001CD4 3C04                     cmp al, 4
  4835 00001CD6 0F850900                 jne @@setwflag182
  4836 00001CDA 66B802000000             mov eax, 2
  4837 00001CE0 A2[3700]                 mov byte [OpSize], al
  4838                                  
  4839                                  ;-107     }
  4840                                  
  4841                                  @@setwflag182:
  4842                                  
  4843                                  ;-108   }
  4844                                  
  4845                                  @@setwflag181:
  4846                                  
  4847                                  ;-109   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  4848                                  
  4849                                  @@setwflag180:
  4850 00001CE3 A0[3700]                 mov al, [OpSize]
  4851 00001CE6 3C03                     cmp al, 3
  4852 00001CE8 0F850C00                 jne @@setwflag183
  4853 00001CEC E801FB                   call gen66h
  4854 00001CEF 66B801000000             mov eax, 1
  4855 00001CF5 A2[3800]                 mov byte [wflag], al
  4856                                  
  4857                                  ;-110   if (OpSize  ==  WORD) wflag=1;
  4858                                  
  4859                                  @@setwflag183:
  4860 00001CF8 A0[3700]                 mov al, [OpSize]
  4861 00001CFB 3C02                     cmp al, 2
  4862 00001CFD 0F850900                 jne @@setwflag184
  4863 00001D01 66B801000000             mov eax, 1
  4864 00001D07 A2[3800]                 mov byte [wflag], al
  4865                                  
  4866                                  ;-111 }
  4867                                  
  4868                                  @@setwflag184:
  4869                                  
  4870                                  ;-112 
  4871                                  
  4872                                  
  4873                                  ;-113 int getOp1() {//scan for a single operand
  4874                                  
  4875 00001D0A C3                       ret
  4876                                  ; ENDP
  4877                                  
  4878                                  getOp1:  ; *** PROC ***
  4879                                  
  4880                                  ;-114 //return:0, IMM, REG, ADR (not MEM)
  4881                                  
  4882                                  
  4883                                  ;-115 //set   :RegType, RegNo by testReg
  4884                                  
  4885                                  
  4886                                  ;-116 //set   :LabelIx by searchLabel
  4887                                  
  4888                                  
  4889                                  ;-117   if (TokeType == 0)      return 0;
  4890                                  
  4891 00001D0B A0[2F00]                 mov al, [TokeType]
  4892 00001D0E 3C00                     cmp al, 0
  4893 00001D10 0F850900                 jne @@getOp1185
  4894 00001D14 66B800000000             mov eax, 0
  4895 00001D1A E96000                   jmp @@retn
  4896                                  
  4897                                  ;-118   if (TokeType == DIGIT)  return IMM;
  4898                                  
  4899                                  @@getOp1185:
  4900 00001D1D A0[2F00]                 mov al, [TokeType]
  4901 00001D20 3C01                     cmp al, 1
  4902 00001D22 0F850900                 jne @@getOp1186
  4903 00001D26 66B801000000             mov eax, 1
  4904 00001D2C E94E00                   jmp @@retn
  4905                                  
  4906                                  ;-119   if (TokeType == ALNUME) {
  4907                                  
  4908                                  @@getOp1186:
  4909 00001D2F A0[2F00]                 mov al, [TokeType]
  4910 00001D32 3C03                     cmp al, 3
  4911 00001D34 0F853C00                 jne @@getOp1187
  4912                                  
  4913                                  ;-120     RegNo=testReg();
  4914                                  
  4915 00001D38 E8BCEE                   call testReg
  4916 00001D3B A2[3600]                 mov byte [RegNo], al
  4917                                  
  4918                                  ;-121     if (RegType)          return REG;
  4919                                  
  4920 00001D3E A0[3500]                 mov al, [RegType]
  4921 00001D41 08C0                     or  al, al
  4922 00001D43 0F840900                 je @@getOp1188
  4923 00001D47 66B802000000             mov eax, 2
  4924 00001D4D E92D00                   jmp @@retn
  4925                                  
  4926                                  ;-122     LabelIx=searchLabel();
  4927                                  
  4928                                  @@getOp1188:
  4929 00001D50 E8C6E8                   call searchLabel
  4930 00001D53 A3[4800]                 mov word [LabelIx], ax
  4931                                  
  4932                                  ;-123     if (LabelIx)          return ADR;
  4933                                  
  4934 00001D56 A1[4800]                 mov ax, [LabelIx]
  4935 00001D59 08C0                     or  al, al
  4936 00001D5B 0F840C00                 je @@getOp1189
  4937 00001D5F 66B803000000             mov eax, 3
  4938 00001D65 E91500                   jmp @@retn
  4939                                  
  4940                                  ;-124     else error1("variable not found"); 
  4941                                  
  4942 00001D68 E90900                   jmp @@getOp1190
  4943                                  @@getOp1189:
  4944 00001D6B 68[7E1D]                 push getOp1_0
  4945 00001D6E E82DF5                   call error1
  4946 00001D71 83C402                   add  sp, 2
  4947                                  
  4948                                  ;-125   }
  4949                                  
  4950                                  @@getOp1190:
  4951                                  
  4952                                  ;-126   return 0;
  4953                                  
  4954                                  @@getOp1187:
  4955 00001D74 66B800000000             mov eax, 0
  4956 00001D7A E90000                   jmp @@retn
  4957                                  
  4958                                  ;-127 }
  4959                                  
  4960                                  
  4961                                  ;-128 
  4962                                  
  4963                                  
  4964                                  ;-129 int getMEM() {// e.g. [array+bp+si-4]
  4965                                  
  4966                                  @@retn:
  4967 00001D7D C3                       ret
  4968                                  ; ENDP
  4969 00001D7E 7661726961626C6520-     getOp1_0 db "variable not found",0
  4970 00001D87 6E6F7420666F756E64-
  4971 00001D90 00                 
  4972                                  
  4973                                  getMEM:  ; *** PROC ***
  4974                                  
  4975                                  ;-130 //set: disp, regindexbase, RegType
  4976                                  
  4977                                  
  4978                                  ;-131   char op2;
  4979                                  
  4980                                  
  4981                                  ;-132   disp=0; regindexbase=0; RegType=0;
  4982                                  
  4983                                  ;Function : getMEM, Number of local variables: 1
  4984                                  ;   # type sign width line used address name   list of local variables
  4985                                  ;  200 var sign byte   131 NULL bp-2    op2;
  4986 00001D91 C8020000                 ENTER  2,0
  4987 00001D95 66B800000000             mov eax, 0
  4988 00001D9B A3[3B00]                 mov word [disp], ax
  4989 00001D9E 66B800000000             mov eax, 0
  4990 00001DA4 A2[3900]                 mov byte [regindexbase], al
  4991 00001DA7 66B800000000             mov eax, 0
  4992 00001DAD A2[3500]                 mov byte [RegType], al
  4993                                  
  4994                                  ;-133   do {
  4995                                  
  4996                                  @@getMEM191:
  4997                                  
  4998                                  ;-134     getTokeType();
  4999                                  
  5000 00001DB0 E87EE7                   call getTokeType
  5001                                  
  5002                                  ;-135     op2=getOp1();
  5003                                  
  5004 00001DB3 E855FF                   call getOp1
  5005 00001DB6 8846FE                   mov byte [bp-2], al
  5006                                  
  5007                                  ;-136     if (op2 ==   0) syntaxerror();
  5008                                  
  5009 00001DB9 8A46FE                   mov al, [bp-2]
  5010 00001DBC 3C00                     cmp al, 0
  5011 00001DBE 0F850300                 jne @@getMEM192
  5012 00001DC2 E85DF6                   call syntaxerror
  5013                                  
  5014                                  ;-137     if (op2 == REG) {isDirect=0;
  5015                                  
  5016                                  @@getMEM192:
  5017 00001DC5 8A46FE                   mov al, [bp-2]
  5018 00001DC8 3C02                     cmp al, 2
  5019 00001DCA 0F851E00                 jne @@getMEM193
  5020 00001DCE 66B800000000             mov eax, 0
  5021 00001DD4 A2[3A00]                 mov byte [isDirect], al
  5022                                  
  5023                                  ;-138                       if (regindexbase) regindexbase=getIndReg2();
  5024                                  
  5025 00001DD7 A0[3900]                 mov al, [regindexbase]
  5026 00001DDA 08C0                     or  al, al
  5027 00001DDC 0F840900                 je @@getMEM194
  5028 00001DE0 E8F300                   call getIndReg2
  5029 00001DE3 A2[3900]                 mov byte [regindexbase], al
  5030                                  
  5031                                  ;-139                       else getIndReg1();
  5032                                  
  5033 00001DE6 E90300                   jmp @@getMEM195
  5034                                  @@getMEM194:
  5035 00001DE9 E88900                   call getIndReg1
  5036                                  
  5037                                  ;-140                     }
  5038                                  
  5039                                  @@getMEM195:
  5040                                  
  5041                                  ;-141     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  5042                                  
  5043                                  @@getMEM193:
  5044 00001DEC 8A46FE                   mov al, [bp-2]
  5045 00001DEF 3C03                     cmp al, 3
  5046 00001DF1 0F851000                 jne @@getMEM196
  5047 00001DF5 A1[3B00]                 mov ax, [disp]
  5048 00001DF8 8B1E[4800]               mov bx, [LabelIx]
  5049 00001DFC D1E3                     shl bx, 1
  5050 00001DFE 0387A37A                 add ax, [LabelAddr + bx]
  5051 00001E02 A3[3B00]                 mov word [disp], ax
  5052                                  
  5053                                  ;-142     if (op2 == IMM) disp=disp+SymbolInt;
  5054                                  
  5055                                  @@getMEM196:
  5056 00001E05 8A46FE                   mov al, [bp-2]
  5057 00001E08 3C01                     cmp al, 1
  5058 00001E0A 0F850A00                 jne @@getMEM197
  5059 00001E0E A1[3B00]                 mov ax, [disp]
  5060 00001E11 0306[1900]               add ax, [SymbolInt]
  5061 00001E15 A3[3B00]                 mov word [disp], ax
  5062                                  
  5063                                  ;-143     if (isToken('-')) {
  5064                                  
  5065                                  @@getMEM197:
  5066 00001E18 6A2D                     push 45
  5067 00001E1A E891EA                   call isToken
  5068 00001E1D 83C402                   add  sp, 2
  5069 00001E20 08C0                     or  al, al
  5070 00001E22 0F841900                 je @@getMEM198
  5071                                  
  5072                                  ;-144       getTokeType();
  5073                                  
  5074 00001E26 E808E7                   call getTokeType
  5075                                  
  5076                                  ;-145       if (TokeType != DIGIT) numbererror();
  5077                                  
  5078 00001E29 A0[2F00]                 mov al, [TokeType]
  5079 00001E2C 3C01                     cmp al, 1
  5080 00001E2E 0F840300                 je  @@getMEM199
  5081 00001E32 E85AF5                   call numbererror
  5082                                  
  5083                                  ;-146       disp = disp - SymbolInt;
  5084                                  
  5085                                  @@getMEM199:
  5086 00001E35 A1[3B00]                 mov ax, [disp]
  5087 00001E38 2B06[1900]               sub ax, [SymbolInt]
  5088 00001E3C A3[3B00]                 mov word [disp], ax
  5089                                  
  5090                                  ;-147     }
  5091                                  
  5092                                  
  5093                                  ;-148   } while (isToken('+'));
  5094                                  
  5095                                  @@getMEM198:
  5096 00001E3F 6A2B                     push 43
  5097 00001E41 E86AEA                   call isToken
  5098 00001E44 83C402                   add  sp, 2
  5099 00001E47 08C0                     or  al, al
  5100 00001E49 0F840300                 je @@getMEM200
  5101 00001E4D E960FF                   jmp @@getMEM191
  5102                                  @@getMEM200:
  5103                                  
  5104                                  ;-149   if (isToken(']') == 0) errorexit("] expected");
  5105                                  
  5106 00001E50 6A5D                     push 93
  5107 00001E52 E859EA                   call isToken
  5108 00001E55 83C402                   add  sp, 2
  5109 00001E58 83F800                   cmp ax, 0
  5110 00001E5B 0F850900                 jne @@getMEM201
  5111 00001E5F 68[6A1E]                 push getMEM_0
  5112 00001E62 E8CEF5                   call errorexit
  5113 00001E65 83C402                   add  sp, 2
  5114                                  
  5115                                  ;-150 }
  5116                                  
  5117                                  @@getMEM201:
  5118                                  
  5119                                  ;-151 int getIndReg1() {
  5120 00001E68 C9                       LEAVE
  5121 00001E69 C3                       ret
  5122                                  ; ENDP
  5123 00001E6A 5D2065787065637465-     getMEM_0 db "] expected",0
  5124 00001E73 6400               
  5125                                  
  5126                                  getIndReg1:  ; *** PROC ***
  5127                                  
  5128                                  ;-152   if (RegType !=WORD) indexerror();
  5129                                  
  5130 00001E75 A0[3500]                 mov al, [RegType]
  5131 00001E78 3C02                     cmp al, 2
  5132 00001E7A 0F840300                 je  @@getIndReg1202
  5133 00001E7E E8CCF4                   call indexerror
  5134                                  
  5135                                  ;-153   if (RegNo==3) regindexbase=7;//BX
  5136                                  
  5137                                  @@getIndReg1202:
  5138 00001E81 A0[3600]                 mov al, [RegNo]
  5139 00001E84 3C03                     cmp al, 3
  5140 00001E86 0F850900                 jne @@getIndReg1203
  5141 00001E8A 66B807000000             mov eax, 7
  5142 00001E90 A2[3900]                 mov byte [regindexbase], al
  5143                                  
  5144                                  ;-154   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5145                                  
  5146                                  @@getIndReg1203:
  5147 00001E93 A0[3600]                 mov al, [RegNo]
  5148 00001E96 3C05                     cmp al, 5
  5149 00001E98 0F850900                 jne @@getIndReg1204
  5150 00001E9C 66B806000000             mov eax, 6
  5151 00001EA2 A2[3900]                 mov byte [regindexbase], al
  5152                                  
  5153                                  ;-155   if (RegNo==7) regindexbase=5;//DI
  5154                                  
  5155                                  @@getIndReg1204:
  5156 00001EA5 A0[3600]                 mov al, [RegNo]
  5157 00001EA8 3C07                     cmp al, 7
  5158 00001EAA 0F850900                 jne @@getIndReg1205
  5159 00001EAE 66B805000000             mov eax, 5
  5160 00001EB4 A2[3900]                 mov byte [regindexbase], al
  5161                                  
  5162                                  ;-156   if (RegNo==6) regindexbase=4;//SI
  5163                                  
  5164                                  @@getIndReg1205:
  5165 00001EB7 A0[3600]                 mov al, [RegNo]
  5166 00001EBA 3C06                     cmp al, 6
  5167 00001EBC 0F850900                 jne @@getIndReg1206
  5168 00001EC0 66B804000000             mov eax, 4
  5169 00001EC6 A2[3900]                 mov byte [regindexbase], al
  5170                                  
  5171                                  ;-157   if (regindexbase==0) indexerror();
  5172                                  
  5173                                  @@getIndReg1206:
  5174 00001EC9 A0[3900]                 mov al, [regindexbase]
  5175 00001ECC 3C00                     cmp al, 0
  5176 00001ECE 0F850300                 jne @@getIndReg1207
  5177 00001ED2 E878F4                   call indexerror
  5178                                  
  5179                                  ;-158 }
  5180                                  
  5181                                  @@getIndReg1207:
  5182                                  
  5183                                  ;-159 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5184                                  
  5185 00001ED5 C3                       ret
  5186                                  ; ENDP
  5187                                  
  5188                                  getIndReg2:  ; *** PROC ***
  5189                                  ;Function : getIndReg2, Number of local variables: 1
  5190                                  ;   # type sign width line used address name   list of local variables
  5191                                  ;  200 var sign byte   159 NULL bp-2    m;
  5192 00001ED6 C8020000                 ENTER  2,0
  5193 00001EDA 66B804000000             mov eax, 4
  5194 00001EE0 8846FE                   mov byte [bp-2], al
  5195                                  
  5196                                  ;-160   if (RegType !=WORD) indexerror();
  5197                                  
  5198 00001EE3 A0[3500]                 mov al, [RegType]
  5199 00001EE6 3C02                     cmp al, 2
  5200 00001EE8 0F840300                 je  @@getIndReg2208
  5201 00001EEC E85EF4                   call indexerror
  5202                                  
  5203                                  ;-161   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5204                                  
  5205                                  @@getIndReg2208:
  5206 00001EEF A0[3600]                 mov al, [RegNo]
  5207 00001EF2 3C07                     cmp al, 7
  5208 00001EF4 0F852700                 jne @@getIndReg2209
  5209 00001EF8 A0[3900]                 mov al, [regindexbase]
  5210 00001EFB 3C06                     cmp al, 6
  5211 00001EFD 0F850C00                 jne @@getIndReg2210
  5212 00001F01 66B803000000             mov eax, 3
  5213 00001F07 8846FE                   mov byte [bp-2], al
  5214                                  
  5215                                  ;-162            else if (regindexbase==7) m=1;//BX+DI
  5216                                  
  5217 00001F0A E91200                   jmp @@getIndReg2211
  5218                                  @@getIndReg2210:
  5219 00001F0D A0[3900]                 mov al, [regindexbase]
  5220 00001F10 3C07                     cmp al, 7
  5221 00001F12 0F850900                 jne @@getIndReg2212
  5222 00001F16 66B801000000             mov eax, 1
  5223 00001F1C 8846FE                   mov byte [bp-2], al
  5224                                  
  5225                                  ;-163   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5226                                  
  5227                                  @@getIndReg2212:
  5228                                  @@getIndReg2211:
  5229                                  @@getIndReg2209:
  5230 00001F1F A0[3600]                 mov al, [RegNo]
  5231 00001F22 3C06                     cmp al, 6
  5232 00001F24 0F852700                 jne @@getIndReg2213
  5233 00001F28 A0[3900]                 mov al, [regindexbase]
  5234 00001F2B 3C06                     cmp al, 6
  5235 00001F2D 0F850C00                 jne @@getIndReg2214
  5236 00001F31 66B802000000             mov eax, 2
  5237 00001F37 8846FE                   mov byte [bp-2], al
  5238                                  
  5239                                  ;-164            else if (regindexbase==7) m=0;//BX+SI
  5240                                  
  5241 00001F3A E91200                   jmp @@getIndReg2215
  5242                                  @@getIndReg2214:
  5243 00001F3D A0[3900]                 mov al, [regindexbase]
  5244 00001F40 3C07                     cmp al, 7
  5245 00001F42 0F850900                 jne @@getIndReg2216
  5246 00001F46 66B800000000             mov eax, 0
  5247 00001F4C 8846FE                   mov byte [bp-2], al
  5248                                  
  5249                                  ;-165   if (m > 3) indexerror();
  5250                                  
  5251                                  @@getIndReg2216:
  5252                                  @@getIndReg2215:
  5253                                  @@getIndReg2213:
  5254 00001F4F 8A46FE                   mov al, [bp-2]
  5255 00001F52 3C03                     cmp al, 3
  5256 00001F54 0F8E0300                 jle @@getIndReg2217
  5257 00001F58 E8F2F3                   call indexerror
  5258                                  
  5259                                  ;-166   return m;
  5260                                  
  5261                                  @@getIndReg2217:
  5262 00001F5B 8A46FE                   mov al, [bp-2]
  5263 00001F5E E90000                   jmp @@retn
  5264                                  
  5265                                  ;-167 }
  5266                                  
  5267 00001F61 C9                      @@retn: LEAVE
  5268 00001F62 C3                       ret
  5269                                  ; ENDP
  5270                                   
  5271                                  ; missing functions: 
  5272                                  ; digit
  5273                                  ; strcpy
  5274                                  ; eqstr
  5275                                  ; strlen
  5276                                  ; eqstr
  5277                                  ; eqstr
  5278                                  ; eqstr
  5279                                  ; eqstr
  5280                                  ; readRL
  5281                                  ; readRL
  5282                                  ; digit
  5283                                  ; digit
  5284                                  ; strcpy
  5285                                  ; toupper
  5286                                  ; strlen
  5287                                  ; strlen
  5288                                  ; eqstr
  5289                                  ; eqstr
  5290                                  ; eqstr
  5291                                  ; eqstr
  5292                                  ; eqstr
  5293                                  ; eqstr
  5294                                  ; eqstr
  5295                                  ; eqstr
  5296                                  ; eqstr
  5297                                  ; eqstr
  5298                                  ; eqstr
  5299                                  ; eqstr
  5300                                  ; eqstr
  5301                                  ; eqstr
  5302                                  ; eqstr
  5303                                  ; eqstr
  5304                                  ; eqstr
  5305                                  ; eqstr
  5306                                  ; eqstr
  5307                                  ; eqstr
  5308                                  ; eqstr
  5309                                  ; eqstr
  5310                                  ; eqstr
  5311                                  ; eqstr
  5312                                  ; eqstr
  5313                                  ; eqstr
  5314                                  ; eqstr
  5315                                  ; eqstr
  5316                                  ; eqstr
  5317                                  ; eqstr
  5318                                  ; writetty
  5319                                  ; writetty
  5320                                  ; fputcR
  5321                                  ; cputs
  5322                                  ; cputs
  5323                                  ; exitR
  5324                                  ; toupper
  5325                                  ; strcpy
  5326                                  ; strcat1
  5327                                  ; strcpy
  5328                                  ; strcat1
  5329                                  ; strcpy
  5330                                  ; strcat1
  5331                                  ; openR
  5332                                  ; cputs
  5333                                  ; cputs
  5334                                  ; exitR
  5335                                  ; creatR
  5336                                  ; cputs
  5337                                  ; cputs
  5338                                  ; exitR
  5339                                  ; creatR
  5340                                  ; cputs
  5341                                  ; cputs
  5342                                  ; exitR
  5343                                  ; fputcR
  5344                                  ; fcloseR
  5345                                  ; fcloseR
  5346                                  ; fcloseR
  5347                                  ; exitR
  5348                                  ; Number of unresolved CALLs :   76
  5349                                  ;use archive file: AR.C
  5350                                  
  5351                                  ;-168 // AR.C Archive
  5352                                  
  5353                                  ;Number of CALLs:    2 : writetty
  5354                                  
  5355                                  writetty:  ; *** PROC ***
  5356 00001F63 B40E                     mov  ah, 14
  5357 00001F65 BB0000                   mov  bx, 0
  5358 00001F68 CD10                     int  16
  5359                                  
  5360                                  ;-169 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5361                                  
  5362 00001F6A C3                       ret
  5363                                  ; ENDP
  5364                                  ;Number of CALLs:    8 : cputs
  5365                                  
  5366                                  cputs:  ; *** PROC ***
  5367                                  ;Function : cputs, Number of local variables: 2
  5368                                  ;   # type sign width line used address name   list of local variables
  5369                                  ;  200 ptr sign byte   169 NULL bp+4    s
  5370                                  ;  201 var sign byte   169 NULL bp-2    c;
  5371 00001F6B C8020000                 ENTER  2,0
  5372                                  @@cputs218:
  5373 00001F6F 8B5E04                   mov bx, [bp+4]
  5374 00001F72 8A07                     mov al, [bx]
  5375 00001F74 B400                     mov ah, 0
  5376 00001F76 08C0                     or  al, al
  5377 00001F78 0F841B00                 je @@cputs219
  5378 00001F7C 8B5E04                   mov bx, [bp+4]
  5379 00001F7F 8A07                     mov al, [bx]
  5380 00001F81 B400                     mov ah, 0
  5381 00001F83 8846FE                   mov byte [bp-2], al
  5382 00001F86 8A46FE                   mov al, byte [bp-2]
  5383 00001F89 B400                     mov ah, 0
  5384 00001F8B 50                       push ax
  5385 00001F8C E8C401                   call putch
  5386 00001F8F 83C402                   add  sp, 2
  5387 00001F92 FF4604                   inc  word [bp+4]
  5388 00001F95 EBD8                     jmp @@cputs218
  5389                                  @@cputs219:
  5390                                  
  5391                                  ;-170 int mkneg(int n) { n; __asm {neg ax} }
  5392 00001F97 C9                       LEAVE
  5393 00001F98 C3                       ret
  5394                                  ; ENDP
  5395                                  ;Number of CALLs:    2 : toupper
  5396                                  
  5397                                  toupper:  ; *** PROC ***
  5398                                  ;Function : toupper, Number of local variables: 1
  5399                                  ;   # type sign width line used address name   list of local variables
  5400                                  ;  200 ptr sign byte   170 NULL bp+4    s;
  5401 00001F99 C8000000                 ENTER  0,0
  5402                                  @@toupper220:
  5403 00001F9D 8B5E04                   mov bx, [bp+4]
  5404 00001FA0 8A07                     mov al, [bx]
  5405 00001FA2 B400                     mov ah, 0
  5406 00001FA4 08C0                     or  al, al
  5407 00001FA6 0F843000                 je @@toupper221
  5408 00001FAA 8B5E04                   mov bx, [bp+4]
  5409 00001FAD 8A07                     mov al, [bx]
  5410 00001FAF B400                     mov ah, 0
  5411 00001FB1 83F861                   cmp ax, 97 ;unsigned : 1
  5412 00001FB4 0F8C1D00                 jl  @@toupper222
  5413 00001FB8 8B5E04                   mov bx, [bp+4]
  5414 00001FBB 8A07                     mov al, [bx]
  5415 00001FBD B400                     mov ah, 0
  5416 00001FBF 83F87A                   cmp ax, 122
  5417 00001FC2 0F8F0F00                 jg  @@toupper223
  5418 00001FC6 8B5E04                   mov bx, [bp+4]
  5419 00001FC9 8A07                     mov al, [bx]
  5420 00001FCB B400                     mov ah, 0
  5421 00001FCD 83E820                   sub ax, 32
  5422 00001FD0 8B5E04                   mov  bx, [bp+4]
  5423 00001FD3 8807                     mov  [bx], al
  5424                                  @@toupper223:
  5425                                  @@toupper222:
  5426 00001FD5 FF4604                   inc  word [bp+4]
  5427 00001FD8 EBC3                     jmp @@toupper220
  5428                                  @@toupper221:
  5429                                  
  5430                                  ;-171 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5431                                  
  5432                                  
  5433                                  ;-172 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5434 00001FDA C9                       LEAVE
  5435 00001FDB C3                       ret
  5436                                  ; ENDP
  5437                                  ;Number of CALLs:    3 : strlen
  5438                                  
  5439                                  strlen:  ; *** PROC ***
  5440                                  ;Function : strlen, Number of local variables: 2
  5441                                  ;   # type sign width line used address name   list of local variables
  5442                                  ;  200 ptr sign byte   172 NULL bp+4    s
  5443                                  ;  201 var sign word   172 NULL bp-2    c;
  5444 00001FDC C8020000                 ENTER  2,0
  5445 00001FE0 66B800000000             mov eax, 0
  5446 00001FE6 8946FE                   mov word [bp-2], ax
  5447                                  @@strlen224:
  5448 00001FE9 8B5E04                   mov bx, [bp+4]
  5449 00001FEC 8A07                     mov al, [bx]
  5450 00001FEE B400                     mov ah, 0
  5451 00001FF0 83F800                   cmp ax, 0
  5452 00001FF3 0F840800                 je  @@strlen225
  5453 00001FF7 FF4604                   inc  word [bp+4]
  5454 00001FFA FF46FE                   inc  word [bp-2]
  5455 00001FFD EBEA                     jmp @@strlen224
  5456                                  @@strlen225:
  5457 00001FFF 8B46FE                   mov ax, [bp-2]
  5458 00002002 E90000                   jmp @@retn
  5459                                  
  5460                                  ;-173 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5461                                  
  5462 00002005 C9                      @@retn: LEAVE
  5463 00002006 C3                       ret
  5464                                  ; ENDP
  5465                                  ;Number of CALLs:    5 : strcpy
  5466                                  
  5467                                  strcpy:  ; *** PROC ***
  5468                                  ;Function : strcpy, Number of local variables: 2
  5469                                  ;   # type sign width line used address name   list of local variables
  5470                                  ;  200 ptr sign byte   173 NULL bp+4    s
  5471                                  ;  201 ptr sign byte   173 NULL bp+6    t;
  5472 00002007 C8000000                 ENTER  0,0
  5473                                  @@strcpy226:
  5474 0000200B 8B5E06                   mov bx, [bp+6]
  5475 0000200E 8A07                     mov al, [bx]
  5476 00002010 B400                     mov ah, 0
  5477 00002012 8B5E04                   mov  bx, [bp+4]
  5478 00002015 8807                     mov  [bx], al
  5479 00002017 FF4604                   inc  word [bp+4]
  5480 0000201A FF4606                   inc  word [bp+6]
  5481                                  
  5482                                  ;-174   while (*t!=0); *s=0; return s; }
  5483                                  
  5484 0000201D 8B5E06                   mov bx, [bp+6]
  5485 00002020 8A07                     mov al, [bx]
  5486 00002022 B400                     mov ah, 0
  5487 00002024 83F800                   cmp ax, 0
  5488 00002027 0F840200                 je  @@strcpy227
  5489 0000202B EBDE                     jmp @@strcpy226
  5490                                  @@strcpy227:
  5491 0000202D 66B800000000             mov eax, 0
  5492 00002033 8B5E04                   mov  bx, [bp+4]
  5493 00002036 8807                     mov  [bx], al
  5494 00002038 8B4604                   mov ax, [bp+4]
  5495 0000203B E90000                   jmp @@retn
  5496                                  
  5497                                  ;-175 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5498                                  
  5499 0000203E C9                      @@retn: LEAVE
  5500 0000203F C3                       ret
  5501                                  ; ENDP
  5502                                  ;Number of CALLs:    3 : digit
  5503                                  
  5504                                  digit:  ; *** PROC ***
  5505                                  ;Function : digit, Number of local variables: 1
  5506                                  ;   # type sign width line used address name   list of local variables
  5507                                  ;  200 var sign byte   175 NULL bp+4    c;
  5508 00002040 C8000000                 ENTER  0,0
  5509 00002044 8A4604                   mov al, [bp+4]
  5510 00002047 3C30                     cmp al, 48
  5511 00002049 0F8D0900                 jge @@digit228
  5512 0000204D 66B800000000             mov eax, 0
  5513 00002053 E91B00                   jmp @@retn
  5514                                  @@digit228:
  5515 00002056 8A4604                   mov al, [bp+4]
  5516 00002059 3C39                     cmp al, 57
  5517 0000205B 0F8E0900                 jle @@digit229
  5518 0000205F 66B800000000             mov eax, 0
  5519 00002065 E90900                   jmp @@retn
  5520                                  @@digit229:
  5521 00002068 66B801000000             mov eax, 1
  5522 0000206E E90000                   jmp @@retn
  5523                                  
  5524                                  ;-176 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5525                                  
  5526 00002071 C9                      @@retn: LEAVE
  5527 00002072 C3                       ret
  5528                                  ; ENDP
  5529                                  ;Number of CALLs:   35 : eqstr
  5530                                  
  5531                                  eqstr:  ; *** PROC ***
  5532                                  ;Function : eqstr, Number of local variables: 2
  5533                                  ;   # type sign width line used address name   list of local variables
  5534                                  ;  200 ptr sign byte   176 NULL bp+4    p
  5535                                  ;  201 ptr sign byte   176 NULL bp+6    q;
  5536 00002073 C8000000                 ENTER  0,0
  5537                                  @@eqstr230:
  5538 00002077 8B5E04                   mov bx, [bp+4]
  5539 0000207A 8A07                     mov al, [bx]
  5540 0000207C B400                     mov ah, 0
  5541 0000207E 08C0                     or  al, al
  5542 00002080 0F842300                 je @@eqstr231
  5543                                  
  5544                                  ;-177     if (*p != *q) return 0; p++; q++; }
  5545                                  
  5546 00002084 8B5E04                   mov bx, [bp+4]
  5547 00002087 8A07                     mov al, [bx]
  5548 00002089 B400                     mov ah, 0
  5549 0000208B 8B5E06                   mov bx, [bp+6]
  5550 0000208E 3A07                     cmp al, [bx]
  5551 00002090 B400                     mov ah, 0
  5552 00002092 0F840900                 je  @@eqstr232
  5553 00002096 66B800000000             mov eax, 0
  5554 0000209C E92700                   jmp @@retn
  5555                                  @@eqstr232:
  5556 0000209F FF4604                   inc  word [bp+4]
  5557 000020A2 FF4606                   inc  word [bp+6]
  5558                                  
  5559                                  ;-178     if(*q) return 0; return 1; }
  5560                                  
  5561 000020A5 EBD0                     jmp @@eqstr230
  5562                                  @@eqstr231:
  5563 000020A7 8B5E06                   mov bx, [bp+6]
  5564 000020AA 8A07                     mov al, [bx]
  5565 000020AC B400                     mov ah, 0
  5566 000020AE 08C0                     or  al, al
  5567 000020B0 0F840900                 je @@eqstr233
  5568 000020B4 66B800000000             mov eax, 0
  5569 000020BA E90900                   jmp @@retn
  5570                                  @@eqstr233:
  5571 000020BD 66B801000000             mov eax, 1
  5572 000020C3 E90000                   jmp @@retn
  5573                                  
  5574                                  ;-179 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5575                                  
  5576 000020C6 C9                      @@retn: LEAVE
  5577 000020C7 C3                       ret
  5578                                  ; ENDP
  5579                                  ;Number of CALLs:    3 : strcat1
  5580                                  
  5581                                  strcat1:  ; *** PROC ***
  5582                                  ;Function : strcat1, Number of local variables: 2
  5583                                  ;   # type sign width line used address name   list of local variables
  5584                                  ;  200 ptr sign byte   179 NULL bp+4    s
  5585                                  ;  201 ptr sign byte   179 NULL bp+6    t;
  5586 000020C8 C8000000                 ENTER  0,0
  5587                                  @@strcat1234:
  5588 000020CC 8B5E04                   mov bx, [bp+4]
  5589 000020CF 8A07                     mov al, [bx]
  5590 000020D1 B400                     mov ah, 0
  5591 000020D3 83F800                   cmp ax, 0
  5592 000020D6 0F840500                 je  @@strcat1235
  5593 000020DA FF4604                   inc  word [bp+4]
  5594 000020DD EBED                     jmp @@strcat1234
  5595                                  @@strcat1235:
  5596 000020DF FF7606                   push word [bp+6]
  5597 000020E2 FF7604                   push word [bp+4]
  5598 000020E5 E81FFF                   call strcpy
  5599 000020E8 83C404                   add  sp, 4
  5600                                  
  5601                                  ;-180 int basename(char *s) { char *p; p=0;
  5602 000020EB C9                       LEAVE
  5603 000020EC C3                       ret
  5604                                  ; ENDP
  5605                                  ;Number of CALLs:    1 : openR
  5606                                  
  5607                                  openR:  ; *** PROC ***
  5608                                  ;Function : openR, Number of local variables: 1
  5609                                  ;   # type sign width line used address name   list of local variables
  5610                                  ;  200 ptr sign byte   180 NULL bp+4    s;
  5611 000020ED C8000000                 ENTER  0,0
  5612 000020F1 8B5604                   mov  dx, [bp+4]
  5613 000020F4 B8023D                   mov  ax, 15618
  5614 000020F7 E87200                   call DosInt
  5615                                  
  5616                                  ;-181 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5617 000020FA C9                       LEAVE
  5618 000020FB C3                       ret
  5619                                  ; ENDP
  5620                                  ;Number of CALLs:    2 : creatR
  5621                                  
  5622                                  creatR:  ; *** PROC ***
  5623                                  ;Function : creatR, Number of local variables: 1
  5624                                  ;   # type sign width line used address name   list of local variables
  5625                                  ;  200 ptr sign byte   181 NULL bp+4    s;
  5626 000020FC C8000000                 ENTER  0,0
  5627 00002100 8B5604                   mov  dx, [bp+4]
  5628 00002103 B90000                   mov  cx, 0
  5629 00002106 B8003C                   mov  ax, 15360
  5630 00002109 E86000                   call DosInt
  5631                                  
  5632                                  ;-182 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5633 0000210C C9                       LEAVE
  5634 0000210D C3                       ret
  5635                                  ; ENDP
  5636                                  ;Number of CALLs:    2 : readRL
  5637                                  
  5638                                  readRL:  ; *** PROC ***
  5639                                  ;Function : readRL, Number of local variables: 3
  5640                                  ;   # type sign width line used address name   list of local variables
  5641                                  ;  200 ptr sign byte   182 NULL bp+4    s
  5642                                  ;  201 var sign word   182 NULL bp+6    fd
  5643                                  ;  202 var sign word   182 NULL bp+8    len;
  5644 0000210E C8000000                 ENTER  0,0
  5645 00002112 8B5604                   mov  dx, [bp+4]
  5646 00002115 8B4E08                   mov  cx, [bp+8]
  5647 00002118 8B5E06                   mov  bx, [bp+6]
  5648 0000211B B8003F                   mov  ax, 16128
  5649 0000211E E84B00                   call DosInt
  5650                                  
  5651                                  ;-183 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5652 00002121 C9                       LEAVE
  5653 00002122 C3                       ret
  5654                                  ; ENDP
  5655                                  ;Number of CALLs:    2 : fputcR
  5656                                  
  5657                                  fputcR:  ; *** PROC ***
  5658                                  ;Function : fputcR, Number of local variables: 2
  5659                                  ;   # type sign width line used address name   list of local variables
  5660                                  ;  200 ptr sign byte   183 NULL bp+4    n
  5661                                  ;  201 var sign word   183 NULL bp+6    fd;
  5662 00002123 C8000000                 ENTER  0,0
  5663 00002127 8D5604                  lea dx, [bp+4]
  5664                                  
  5665                                  ;-184   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5666                                  
  5667 0000212A B90100                   mov  cx, 1
  5668 0000212D 8B5E06                   mov  bx, [bp+6]
  5669 00002130 B80040                   mov  ax, 16384
  5670 00002133 E83600                   call DosInt
  5671                                  
  5672                                  ;-185 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5673 00002136 C9                       LEAVE
  5674 00002137 C3                       ret
  5675                                  ; ENDP
  5676                                  ;Number of CALLs:    3 : fcloseR
  5677                                  
  5678                                  fcloseR:  ; *** PROC ***
  5679                                  ;Function : fcloseR, Number of local variables: 1
  5680                                  ;   # type sign width line used address name   list of local variables
  5681                                  ;  200 var sign word   185 NULL bp+4    fd;
  5682 00002138 C8000000                 ENTER  0,0
  5683 0000213C 8B5E04                   mov  bx, [bp+4]
  5684 0000213F B8003E                   mov  ax, 15872
  5685 00002142 CD21                     int  33
  5686                                  
  5687                                  ;-186 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5688 00002144 C9                       LEAVE
  5689 00002145 C3                       ret
  5690                                  ; ENDP
  5691                                  ;Number of CALLs:    5 : exitR
  5692                                  
  5693                                  exitR:  ; *** PROC ***
  5694                                  ;Function : exitR, Number of local variables: 1
  5695                                  ;   # type sign width line used address name   list of local variables
  5696                                  ;  200 var sign byte   186 NULL bp+4    c;
  5697 00002146 C8000000                 ENTER  0,0
  5698 0000214A B44C                     mov  ah, 76
  5699 0000214C 8A4604                   mov  al, [bp+4]
  5700 0000214F CD21                     int  33
  5701                                  
  5702                                  ;-187 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5703 00002151 C9                       LEAVE
  5704 00002152 C3                       ret
  5705                                  ; ENDP
  5706                                  ;End of archive file. 
  5707                                   
  5708                                  ; missing functions: 
  5709                                  ; putch
  5710                                  ; DosInt
  5711                                  ; DosInt
  5712                                  ; DosInt
  5713                                  ; DosInt
  5714                                  ; Number of unresolved CALLs :    5
  5715                                  ;use archive file: AR.C
  5716                                  
  5717                                  ;-188 // AR.C Archive
  5718                                  
  5719                                  ;Number of CALLs:    1 : putch
  5720                                  
  5721                                  putch:  ; *** PROC ***
  5722                                  ;Function : putch, Number of local variables: 1
  5723                                  ;   # type sign width line used address name   list of local variables
  5724                                  ;  200 var sign byte   188 NULL bp+4    c;
  5725 00002153 C8000000                 ENTER  0,0
  5726 00002157 807E040A                cmp byte [bp+4], 10
  5727 0000215B 0F850500                 jne @@putch236
  5728 0000215F B00D                     mov  al, 13
  5729 00002161 E8FFFD                   call writetty
  5730                                  @@putch236:
  5731 00002164 8A4604                   mov  al, [bp+4]
  5732 00002167 E8F9FD                   call writetty
  5733                                  
  5734                                  ;-189 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5735 0000216A C9                       LEAVE
  5736 0000216B C3                       ret
  5737                                  ; ENDP
  5738                                  ;Number of CALLs:    4 : DosInt
  5739                                  
  5740                                  DosInt:  ; *** PROC ***
  5741 0000216C CD21                     int  33
  5742 0000216E 7304                     jae short @@DosInt237
  5743 00002170 FF06[2300]               inc  word [DOS_ERR]
  5744                                  @@DosInt237:
  5745                                  
  5746                                  ;-190 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5747                                  
  5748 00002174 C3                       ret
  5749                                  ; ENDP
  5750                                  ;End of archive file. 
  5751                                   
  5752                                  ; missing functions:  All FUNCTIONs in place
  5753 00002175 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5754 00002178 58                      pop ax
  5755 00002179 C3                      ret
  5756                                   
  5757                                  ;   # type sign width line used  address name   list of global variables
  5758                                  
  5759                                  ;    1 arr sign byte     1    2        0 Version1[20]
  5760                                  ;    2 var sign byte     1    3        0 LIST
  5761                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5762                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5763                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5764                                  ;    6 var unsg word     5   12        0 SymbolInt
  5765                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5766                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5767                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5768                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5769                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5770                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5771                                  ;   13 var sign word    12    4        0 asm_fd
  5772                                  ;   14 var sign word    13    3        0 lst_fd
  5773                                  ;   15 var sign word    14    3        0 bin_fd
  5774                                  ;   16 var sign word    15    6        0 DOS_ERR
  5775                                  ;   17 var sign word    16    4        0 ErrorCount
  5776                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5777                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5778                                  ;   20 var unsg word    20    5        0 PC
  5779                                  ;   21 var unsg word    21    2        0 PCStart
  5780                                  ;   22 var sign byte    22    3        0 isLabel
  5781                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5782                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5783                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5784                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5785                                  ;   27 var sign byte    27   21        0 TokeType
  5786                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5787                                  ;   29 def unsg byte    29    -        0 WORD=2
  5788                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5789                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5790                                  ;   32 def unsg byte    32    -        0 IMM=1
  5791                                  ;   33 def unsg byte    33    -        0 REG=2
  5792                                  ;   34 def unsg byte    34    -        0 ADR=3
  5793                                  ;   35 def unsg byte    35    -        0 MEM=4
  5794                                  ;   36 var sign byte    36   15        0 Op1
  5795                                  ;   37 var sign byte    37   12        0 CodeType
  5796                                  ;   38 var sign byte    38    6        0 Code1
  5797                                  ;   39 var sign byte    39    6        0 Code2
  5798                                  ;   40 var sign byte    40    3        0 Code3
  5799                                  ;   41 var sign byte    41   18        0 RegType
  5800                                  ;   42 var sign byte    42   11        0 RegNo
  5801                                  ;   43 var sign byte    43   10        0 OpSize
  5802                                  ;   44 var sign byte    44    4        0 wflag
  5803                                  ;   45 var sign byte    49   15        0 regindexbase
  5804                                  ;   46 var sign byte    50    3        0 isDirect
  5805                                  ;   47 var sign word    51   14        0 disp
  5806                                  ;   48 var sign word    52    2        0 imme
  5807                                  ;   49 def unsg byte    54    -        0 OPMAXLEN=5
  5808                                  ;   50 arr sign byte    55    2    30390 OpPos[5]
  5809                                  ;   51 var sign word    56    6        0 OpPrintIndex
  5810                                  ;   52 ptr sign byte    57   17        0 OpCodePtr
  5811                                  ;   53 var sign byte    58    2        0 PrintR
  5812                                  ;   54 def unsg byte    60    -        0 LABELNAMESMAX=969
  5813                                  ;   55 arr sign byte    61    2    30395 LabelNames[1000]
  5814                                  ;   56 ptr sign byte    62    4        0 LabelNamePtr
  5815                                  ;   57 def unsg byte    63    -        0 LABELADRMAX=100
  5816                                  ;   58 arr unsg word    64    3    31395 LabelAddr[100]
  5817                                  ;   59 var sign word    65    3        0 LabelMaxIx
  5818                                  ;   60 var sign word    66    4        0 LabelIx
  5819                                  ;   61 def unsg byte    68    -        0 FILEBINMAX=2000
  5820                                  ;   62 arr sign byte    69    2    31595 FileBin[2000]
  5821                                  ;   63 var unsg word    70    5        0 BinLen
  5822                                  ;   64 ptr sign byte    72    1        0 arglen
  5823                                  ;   65 ptr sign byte    73    4        0 argv
  5824                                  ;   66 var sign byte     1    1        0 I_START
  5825                                  ;   67 arr sign byte     4 NULL        0 I_PUSHA[9]
  5826                                  ;   68 arr sign byte     5 NULL        0 I_POPA[8]
  5827                                  ;   69 arr sign byte     6 NULL        0 I_NOP[7]
  5828                                  ;   70 arr sign byte     7 NULL        0 I_CBW[7]
  5829                                  ;   71 arr sign byte     8 NULL        0 I_CWDE[8]
  5830                                  ;   72 arr sign byte     9 NULL        0 I_CWD[7]
  5831                                  ;   73 arr sign byte    10 NULL        0 I_CDQ[7]
  5832                                  ;   74 arr sign byte    11 NULL        0 I_WAIT[8]
  5833                                  ;   75 arr sign byte    12 NULL        0 I_PUSHF[9]
  5834                                  ;   76 arr sign byte    13 NULL        0 I_POPF[8]
  5835                                  ;   77 arr sign byte    14 NULL        0 I_SAHF[8]
  5836                                  ;   78 arr sign byte    15 NULL        0 I_LAHF[8]
  5837                                  ;   79 arr sign byte    16 NULL        0 I_MOVSB[9]
  5838                                  ;   80 arr sign byte    17 NULL        0 I_MOVSW[9]
  5839                                  ;   81 arr sign byte    18 NULL        0 I_CMPSB[9]
  5840                                  ;   82 arr sign byte    19 NULL        0 I_CMPSW[9]
  5841                                  ;   83 arr sign byte    20 NULL        0 I_STOSB[9]
  5842                                  ;   84 arr sign byte    21 NULL        0 I_STOSW[9]
  5843                                  ;   85 arr sign byte    22 NULL        0 I_LODSB[9]
  5844                                  ;   86 arr sign byte    23 NULL        0 I_LODSW[9]
  5845                                  ;   87 arr sign byte    24 NULL        0 I_SCASB[9]
  5846                                  ;   88 arr sign byte    25 NULL        0 I_SCASW[9]
  5847                                  ;   89 arr sign byte    26 NULL        0 I_LEAVE[9]
  5848                                  ;   90 arr sign byte    27 NULL        0 I_IRET[8]
  5849                                  ;   91 arr sign byte    28 NULL        0 I_XLAT[8]
  5850                                  ;   92 arr sign byte    29 NULL        0 I_LOCK[8]
  5851                                  ;   93 arr sign byte    30 NULL        0 I_REPNE[9]
  5852                                  ;   94 arr sign byte    31 NULL        0 I_REPNZ[9]
  5853                                  ;   95 arr sign byte    32 NULL        0 I_REPE[8]
  5854                                  ;   96 arr sign byte    33 NULL        0 I_REPZ[8]
  5855                                  ;   97 arr sign byte    34 NULL        0 I_HLT[7]
  5856                                  ;   98 arr sign byte    35 NULL        0 I_CLC[7]
  5857                                  ;   99 arr sign byte    36 NULL        0 I_STC[7]
  5858                                  ;  100 arr sign byte    37 NULL        0 I_CLI[7]
  5859                                  ;  101 arr sign byte    38 NULL        0 I_STI[7]
  5860                                  ;  102 arr sign byte    39 NULL        0 I_CLD[7]
  5861                                  ;  103 arr sign byte    40 NULL        0 I_STD[7]
  5862                                  ;  104 arr sign byte    42 NULL        0 I_INC[9]
  5863                                  ;  105 arr sign byte    43 NULL        0 I_DEC[9]
  5864                                  ;  106 arr sign byte    44 NULL        0 I_NOT[8]
  5865                                  ;  107 arr sign byte    45 NULL        0 I_NEG[8]
  5866                                  ;  108 arr sign byte    46 NULL        0 I_MUL[8]
  5867                                  ;  109 arr sign byte    47 NULL        0 I_IMUL[9]
  5868                                  ;  110 arr sign byte    48 NULL        0 I_DIV[8]
  5869                                  ;  111 arr sign byte    49 NULL        0 I_IDIV[9]
  5870                                  ;  112 arr sign byte    51 NULL        0 I_LES[7]
  5871                                  ;  113 arr sign byte    52 NULL        0 I_LDS[7]
  5872                                  ;  114 arr sign byte    53 NULL        0 I_LEA[7]
  5873                                  ;  115 arr sign byte    54 NULL        0 I_LSS[8]
  5874                                  ;  116 arr sign byte    55 NULL        0 I_LFS[8]
  5875                                  ;  117 arr sign byte    56 NULL        0 I_LGS[8]
  5876                                  ;  118 arr sign byte    58 NULL        0 I_ADD[7]
  5877                                  ;  119 arr sign byte    59 NULL        0 I_OR[6]
  5878                                  ;  120 arr sign byte    60 NULL        0 I_ADC[7]
  5879                                  ;  121 arr sign byte    61 NULL        0 I_SBB[7]
  5880                                  ;  122 arr sign byte    62 NULL        0 I_AND[7]
  5881                                  ;  123 arr sign byte    63 NULL        0 I_SUB[7]
  5882                                  ;  124 arr sign byte    64 NULL        0 I_XOR[7]
  5883                                  ;  125 arr sign byte    65 NULL        0 I_CMP[7]
  5884                                  ;  126 arr sign byte    66 NULL        0 I_TEST[11]
  5885                                  ;  127 arr sign byte    68 NULL        0 I_MOV[6]
  5886                                  ;  128 arr sign byte    69 NULL        0 I_MOVSX[9]
  5887                                  ;  129 arr sign byte    70 NULL        0 I_MOVZX[9]
  5888                                  ;  130 arr sign byte    72 NULL        0 I_JO[6]
  5889                                  ;  131 arr sign byte    73 NULL        0 I_JNO[7]
  5890                                  ;  132 arr sign byte    74 NULL        0 I_JB[6]
  5891                                  ;  133 arr sign byte    75 NULL        0 I_JC[6]
  5892                                  ;  134 arr sign byte    76 NULL        0 I_JNB[7]
  5893                                  ;  135 arr sign byte    77 NULL        0 I_JAE[7]
  5894                                  ;  136 arr sign byte    78 NULL        0 I_JNC[7]
  5895                                  ;  137 arr sign byte    79 NULL        0 I_JE[6]
  5896                                  ;  138 arr sign byte    80 NULL        0 I_JZ[6]
  5897                                  ;  139 arr sign byte    81 NULL        0 I_JNE[7]
  5898                                  ;  140 arr sign byte    82 NULL        0 I_JNZ[7]
  5899                                  ;  141 arr sign byte    83 NULL        0 I_JBE[7]
  5900                                  ;  142 arr sign byte    84 NULL        0 I_JNA[7]
  5901                                  ;  143 arr sign byte    85 NULL        0 I_JA[6]
  5902                                  ;  144 arr sign byte    86 NULL        0 I_JS[6]
  5903                                  ;  145 arr sign byte    87 NULL        0 I_JNS[7]
  5904                                  ;  146 arr sign byte    88 NULL        0 I_JP[6]
  5905                                  ;  147 arr sign byte    89 NULL        0 I_JPE[7]
  5906                                  ;  148 arr sign byte    90 NULL        0 I_JNP[7]
  5907                                  ;  149 arr sign byte    91 NULL        0 I_JPO[7]
  5908                                  ;  150 arr sign byte    92 NULL        0 I_JL[6]
  5909                                  ;  151 arr sign byte    93 NULL        0 I_JNL[7]
  5910                                  ;  152 arr sign byte    94 NULL        0 I_JGE[7]
  5911                                  ;  153 arr sign byte    95 NULL        0 I_JLE[7]
  5912                                  ;  154 arr sign byte    96 NULL        0 I_JNG[7]
  5913                                  ;  155 arr sign byte    97 NULL        0 I_JG[6]
  5914                                  ;  156 arr sign byte    99 NULL        0 I_JMP[8]
  5915                                  ;  157 arr sign byte   100 NULL        0 I_CALL[9]
  5916                                  ;  158 arr sign byte   102 NULL        0 I_RET[8]
  5917                                  ;  159 arr sign byte   103 NULL        0 I_RETF[9]
  5918                                  ;  160 arr sign byte   105 NULL        0 I_PUSH[8]
  5919                                  ;  161 arr sign byte   106 NULL        0 I_POP[7]
  5920                                  ;  162 arr sign byte   108 NULL        0 I_ROL[7]
  5921                                  ;  163 arr sign byte   109 NULL        0 I_ROR[7]
  5922                                  ;  164 arr sign byte   110 NULL        0 I_RCL[7]
  5923                                  ;  165 arr sign byte   111 NULL        0 I_RCR[7]
  5924                                  ;  166 arr sign byte   112 NULL        0 I_SHL[7]
  5925                                  ;  167 arr sign byte   113 NULL        0 I_SAL[7]
  5926                                  ;  168 arr sign byte   114 NULL        0 I_SHR[7]
  5927                                  ;  169 arr sign byte   115 NULL        0 I_SAR[7]
  5928                                  ;  170 arr sign byte   117 NULL        0 I_INT[8]
  5929                                  ;  171 arr sign byte   118 NULL        0 I_INTO[8]
  5930                                  ;  172 arr sign byte   120 NULL        0 I_IN[7]
  5931                                  ;  173 arr sign byte   121 NULL        0 I_INSB[8]
  5932                                  ;  174 arr sign byte   122 NULL        0 I_INSW[8]
  5933                                  ;  175 arr sign byte   123 NULL        0 I_INSD[8]
  5934                                  ;  176 arr sign byte   124 NULL        0 I_OUT[8]
  5935                                  ;  177 arr sign byte   125 NULL        0 I_OUTSB[8]
  5936                                  ;  178 arr sign byte   126 NULL        0 I_OUTSW[8]
  5937                                  ;  179 arr sign byte   127 NULL        0 I_OUTSD[8]
  5938                                  ;  180 arr sign byte   129 NULL        0 I_XCHG[9]
  5939                                  ;  181 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  5940                                  ;  182 arr sign byte   132 NULL        0 I_LOOPNE[10]
  5941                                  ;  183 arr sign byte   133 NULL        0 I_LOOPZ[9]
  5942                                  ;  184 arr sign byte   134 NULL        0 I_LOOPE[9]
  5943                                  ;  185 arr sign byte   135 NULL        0 I_LOOP[8]
  5944                                  ;  186 arr sign byte   136 NULL        0 I_JCXZ[8]
  5945                                  ;  187 arr sign byte   137 NULL        0 I_JECXZ[9]
  5946                                  ;  188 arr sign byte   139 NULL        0 I_ENTER[9]
  5947                                  ;  189 arr sign byte   141 NULL        0 I_ORG[6]
  5948                                  ;  190 arr sign byte   143 NULL        0 I_SECTION[10]
  5949                                  ;  191 arr sign byte   144 NULL        0 I_SEGMENT[10]
  5950                                  ;  192 arr sign byte   145 NULL        0 I_ABSOLUTE[11]
  5951                                  ;  193 arr sign byte   146 NULL        0 I_DB[5]
  5952                                  ;  194 arr sign byte   147 NULL        0 I_DW[5]
  5953                                  ;  195 arr sign byte   148 NULL        0 I_DD[5]
  5954                                  ;  196 arr sign byte   149 NULL        0 I_RESB[7]
  5955                                  ;  197 arr sign byte   150 NULL        0 I_RESW[7]
  5956                                  ;  198 arr sign byte   151 NULL        0 I_RESD[7]
  5957                                  ;  199 var sign byte   152 NULL        0 I_END
  5958                                  
  5959                                  
  5960                                  ;   # Calls Line Width  Name   list of functions
  5961                                  
  5962                                  ;    0    1    1 word   parse
  5963                                  ;    1   13   27 word   getTokeType
  5964                                  ;    2    2   36 word   storeLabel
  5965                                  ;    3    2   43 word   searchLabel
  5966                                  ;    4    1   54 word   getVariable
  5967                                  ;    5    2   83 word   lookCode
  5968                                  ;    6    1   98 word   getCodeSize
  5969                                  ;    7    8  105 word   isToken
  5970                                  ;    8    1  110 word   need
  5971                                  ;    9    1  117 word   skipRest
  5972                                  ;   10    1    1 word   getLine
  5973                                  ;   11    1   14 word   ifEOL
  5974                                  ;   12    3   21 word   skipBlank
  5975                                  ;   13    2   26 word   letterE
  5976                                  ;   14    1   36 word   alnumE
  5977                                  ;   15    1   41 word   getDigit
  5978                                  ;   16    1   53 word   getName
  5979                                  ;   17    1   70 word   testReg
  5980                                  ;   18    1    1 word   printLine
  5981                                  ;   19    8   19 word   prc
  5982                                  ;   20    1   23 word   prscomment
  5983                                  ;   21   21   26 word   prs
  5984                                  ;   22    3   31 word   printhex8a
  5985                                  ;   23    1   35 word   printhex16
  5986                                  ;   24    3   38 word   printIntU
  5987                                  ;   25   24   45 word   error1
  5988                                  ;   26 NULL   48 word   allowederror
  5989                                  ;   27    1   49 word   addrerror
  5990                                  ;   28    2   50 word   implerror
  5991                                  ;   29    4   51 word   indexerror
  5992                                  ;   30    1   52 word   invaloperror
  5993                                  ;   31    1   53 word   numbererror
  5994                                  ;   32 NULL   54 word   regmemerror
  5995                                  ;   33    1   55 word   reg16error
  5996                                  ;   34    1   56 word   segregerror
  5997                                  ;   35    1   57 word   syntaxerror
  5998                                  ;   36    8   59 word   errorexit
  5999                                  ;   37    1   60 word   addrexit
  6000                                  ;   38 NULL   61 word   internexit
  6001                                  ;   39 NULL    1 word   main
  6002                                  ;   40    1    8 word   getarg
  6003                                  ;   41    1   38 word   epilog
  6004                                  ;   42    2   67 word   end1
  6005                                  ;   43    1    2 word   getCodes
  6006                                  ;   44    1    7 word   gen66h
  6007                                  ;   45    3    9 word   genCode
  6008                                  ;   46   13   13 word   genCode8
  6009                                  ;   47    3   24 word   genCode16
  6010                                  ;   48    2   28 word   writeEA
  6011                                  ;   49    1   11 word   process
  6012                                  ;   50    2   70 word   checkOp
  6013                                  ;   51    2   88 word   getOp
  6014                                  ;   52    1  101 word   setwflag
  6015                                  ;   53    2  113 word   getOp1
  6016                                  ;   54    1  129 word   getMEM
  6017                                  ;   55    1  151 word   getIndReg1
  6018                                  ;   56    1  159 word   getIndReg2
  6019                                  ;   57    4  168 word   writetty
  6020                                  ;   58    8  169 word   cputs
  6021                                  ;   59    2  170 word   toupper
  6022                                  ;   60    3  172 word   strlen
  6023                                  ;   61    6  173 word   strcpy
  6024                                  ;   62    3  175 word   digit
  6025                                  ;   63   35  176 word   eqstr
  6026                                  ;   64    3  179 word   strcat1
  6027                                  ;   65    1  180 word   openR
  6028                                  ;   66    2  181 word   creatR
  6029                                  ;   67    2  182 word   readRL
  6030                                  ;   68    2  183 word   fputcR
  6031                                  ;   69    3  185 word   fcloseR
  6032                                  ;   70    5  186 word   exitR
  6033                                  ;   71    1  188 word   putch
  6034                                  ;   72    4  189 word   DosInt
  6035                                  ;   73 NULL  190 word   LastFunctionByt
  6036                                  
  6037                                  ;    #  addr name   list of CALLs
  6038                                  
  6039                                  ;    0  1411 getLine
  6040                                  ;    1  1419 getTokeType
  6041                                  ;    2  1431 storeLabel
  6042                                  ;    3  1442 getTokeType
  6043                                  ;    4  1454 lookCode
  6044                                  ;    5  1463 process
  6045                                  ;    6  1471 getVariable
  6046                                  ;    7  1483 skipRest
  6047                                  ;    8  1492 error1
  6048                                  ;    9  1499 error1
  6049                                  ;   10  1506 printLine
  6050                                  ;   11  1530 skipBlank
  6051                                  ;   12  1540 digit
  6052                                  ;   13  1546 getDigit
  6053                                  ;   14  1555 letterE
  6054                                  ;   15  1563 getName
  6055                                  ;   16  1582 searchLabel
  6056                                  ;   17  1594 error1
  6057                                  ;   18  1601 strcpy
  6058                                  ;   19  1628 eqstr
  6059                                  ;   20  1634 strlen
  6060                                  ;   21  1655 storeLabel
  6061                                  ;   22  1666 getTokeType
  6062                                  ;   23  1678 lookCode
  6063                                  ;   24  1687 errorexit
  6064                                  ;   25  1697 errorexit
  6065                                  ;   26  1707 getTokeType
  6066                                  ;   27  1719 genCode8
  6067                                  ;   28  1728 skipBlank
  6068                                  ;   29  1738 isToken
  6069                                  ;   30  1746 genCode8
  6070                                  ;   31  1755 isToken
  6071                                  ;   32  1763 getTokeType
  6072                                  ;   33  1775 genCode16
  6073                                  ;   34  1785 isToken
  6074                                  ;   35  1793 errorexit
  6075                                  ;   36  1812 eqstr
  6076                                  ;   37  1830 eqstr
  6077                                  ;   38  1836 getTokeType
  6078                                  ;   39  1848 eqstr
  6079                                  ;   40  1854 getTokeType
  6080                                  ;   41  1866 eqstr
  6081                                  ;   42  1872 getTokeType
  6082                                  ;   43  1894 skipBlank
  6083                                  ;   44  1911 isToken
  6084                                  ;   45  1919 error1
  6085                                  ;   46  1926 prs
  6086                                  ;   47  1930 prc
  6087                                  ;   48  1943 getTokeType
  6088                                  ;   49  1955 error1
  6089                                  ;   50  1970 readRL
  6090                                  ;   51  1977 errorexit
  6091                                  ;   52  1987 ifEOL
  6092                                  ;   53  2001 readRL
  6093                                  ;   54  2037 digit
  6094                                  ;   55  2043 letterE
  6095                                  ;   56  2070 digit
  6096                                  ;   57  2088 alnumE
  6097                                  ;   58  2095 strcpy
  6098                                  ;   59  2102 toupper
  6099                                  ;   60  2118 strlen
  6100                                  ;   61  2125 strlen
  6101                                  ;   62  2132 eqstr
  6102                                  ;   63  2138 eqstr
  6103                                  ;   64  2144 eqstr
  6104                                  ;   65  2150 eqstr
  6105                                  ;   66  2156 eqstr
  6106                                  ;   67  2162 eqstr
  6107                                  ;   68  2168 eqstr
  6108                                  ;   69  2174 eqstr
  6109                                  ;   70  2180 eqstr
  6110                                  ;   71  2186 eqstr
  6111                                  ;   72  2192 eqstr
  6112                                  ;   73  2198 eqstr
  6113                                  ;   74  2204 eqstr
  6114                                  ;   75  2210 eqstr
  6115                                  ;   76  2216 eqstr
  6116                                  ;   77  2222 eqstr
  6117                                  ;   78  2228 eqstr
  6118                                  ;   79  2234 eqstr
  6119                                  ;   80  2240 eqstr
  6120                                  ;   81  2246 eqstr
  6121                                  ;   82  2252 eqstr
  6122                                  ;   83  2258 eqstr
  6123                                  ;   84  2264 eqstr
  6124                                  ;   85  2270 eqstr
  6125                                  ;   86  2276 eqstr
  6126                                  ;   87  2282 eqstr
  6127                                  ;   88  2288 eqstr
  6128                                  ;   89  2294 eqstr
  6129                                  ;   90  2300 eqstr
  6130                                  ;   91  2306 eqstr
  6131                                  ;   92  2326 prs
  6132                                  ;   93  2330 printhex16
  6133                                  ;   94  2341 prs
  6134                                  ;   95  2345 prc
  6135                                  ;   96  2349 printhex8a
  6136                                  ;   97  2360 prc
  6137                                  ;   98  2364 prs
  6138                                  ;   99  2368 prscomment
  6139                                  ;  100  2385 writetty
  6140                                  ;  101  2394 writetty
  6141                                  ;  102  2403 fputcR
  6142                                  ;  103  2425 prc
  6143                                  ;  104  2441 prc
  6144                                  ;  105  2462 prc
  6145                                  ;  106  2466 prc
  6146                                  ;  107  2488 printhex8a
  6147                                  ;  108  2499 printhex8a
  6148                                  ;  109  2524 printIntU
  6149                                  ;  110  2534 prc
  6150                                  ;  111  2547 prs
  6151                                  ;  112  2551 prs
  6152                                  ;  113  2555 prs
  6153                                  ;  114  2559 prs
  6154                                  ;  115  2576 error1
  6155                                  ;  116  2593 error1
  6156                                  ;  117  2610 error1
  6157                                  ;  118  2628 error1
  6158                                  ;  119  2648 error1
  6159                                  ;  120  2667 error1
  6160                                  ;  121  2686 error1
  6161                                  ;  122  2704 error1
  6162                                  ;  123  2723 error1
  6163                                  ;  124  2742 error1
  6164                                  ;  125  2761 error1
  6165                                  ;  126  2768 end1
  6166                                  ;  127  2782 errorexit
  6167                                  ;  128  2803 errorexit
  6168                                  ;  129  2818 getarg
  6169                                  ;  130  2825 parse
  6170                                  ;  131  2831 epilog
  6171                                  ;  132  2838 end1
  6172                                  ;  133  2862 cputs
  6173                                  ;  134  2868 cputs
  6174                                  ;  135  2874 exitR
  6175                                  ;  136  2880 toupper
  6176                                  ;  137  2888 strcpy
  6177                                  ;  138  2895 strcat1
  6178                                  ;  139  2903 strcpy
  6179                                  ;  140  2910 strcat1
  6180                                  ;  141  2918 strcpy
  6181                                  ;  142  2925 strcat1
  6182                                  ;  143  2933 openR
  6183                                  ;  144  2939 cputs
  6184                                  ;  145  2945 cputs
  6185                                  ;  146  2951 exitR
  6186                                  ;  147  2957 creatR
  6187                                  ;  148  2964 cputs
  6188                                  ;  149  2970 cputs
  6189                                  ;  150  2976 exitR
  6190                                  ;  151  2982 creatR
  6191                                  ;  152  2989 cputs
  6192                                  ;  153  2995 cputs
  6193                                  ;  154  3001 exitR
  6194                                  ;  155  3007 prs
  6195                                  ;  156  3011 prs
  6196                                  ;  157  3015 prs
  6197                                  ;  158  3019 prs
  6198                                  ;  159  3023 prs
  6199                                  ;  160  3027 prs
  6200                                  ;  161  3031 prs
  6201                                  ;  162  3035 prs
  6202                                  ;  163  3039 prs
  6203                                  ;  164  3056 prs
  6204                                  ;  165  3060 printIntU
  6205                                  ;  166  3070 prs
  6206                                  ;  167  3074 prs
  6207                                  ;  168  3078 printIntU
  6208                                  ;  169  3088 prs
  6209                                  ;  170  3092 fputcR
  6210                                  ;  171  3106 fcloseR
  6211                                  ;  172  3114 fcloseR
  6212                                  ;  173  3122 fcloseR
  6213                                  ;  174  3130 exitR
  6214                                  ;  175  3152 genCode8
  6215                                  ;  176  3173 genCode8
  6216                                  ;  177  3193 errorexit
  6217                                  ;  178  3215 genCode8
  6218                                  ;  179  3224 genCode8
  6219                                  ;  180  3249 addrexit
  6220                                  ;  181  3258 error1
  6221                                  ;  182  3265 genCode8
  6222                                  ;  183  3274 genCode8
  6223                                  ;  184  3283 genCode16
  6224                                  ;  185  3304 getTokeType
  6225                                  ;  186  3316 getCodeSize
  6226                                  ;  187  3328 getCodes
  6227                                  ;  188  3337 genCode8
  6228                                  ;  189  3346 checkOp
  6229                                  ;  190  3354 genCode
  6230                                  ;  191  3362 genCode
  6231                                  ;  192  3370 getTokeType
  6232                                  ;  193  3382 implerror
  6233                                  ;  194  3392 genCode
  6234                                  ;  195  3400 writeEA
  6235                                  ;  196  3408 checkOp
  6236                                  ;  197  3416 reg16error
  6237                                  ;  198  3427 need
  6238                                  ;  199  3432 getOp
  6239                                  ;  200  3438 addrerror
  6240                                  ;  201  3448 genCode8
  6241                                  ;  202  3457 genCode8
  6242                                  ;  203  3466 writeEA
  6243                                  ;  204  3474 genCode8
  6244                                  ;  205  3483 genCode16
  6245                                  ;  206  3493 genCode8
  6246                                  ;  207  3502 error1
  6247                                  ;  208  3509 error1
  6248                                  ;  209  3524 getOp
  6249                                  ;  210  3530 implerror
  6250                                  ;  211  3540 segregerror
  6251                                  ;  212  3552 setwflag
  6252                                  ;  213  3561 error1
  6253                                  ;  214  3568 error1
  6254                                  ;  215  3575 error1
  6255                                  ;  216  3588 getOp1
  6256                                  ;  217  3595 isToken
  6257                                  ;  218  3603 getMEM
  6258                                  ;  219  3610 invaloperror
  6259                                  ;  220  3623 error1
  6260                                  ;  221  3639 gen66h
  6261                                  ;  222  3653 testReg
  6262                                  ;  223  3661 searchLabel
  6263                                  ;  224  3673 error1
  6264                                  ;  225  3691 getTokeType
  6265                                  ;  226  3703 getOp1
  6266                                  ;  227  3710 syntaxerror
  6267                                  ;  228  3722 getIndReg2
  6268                                  ;  229  3733 getIndReg1
  6269                                  ;  230  3744 isToken
  6270                                  ;  231  3752 getTokeType
  6271                                  ;  232  3764 numbererror
  6272                                  ;  233  3776 isToken
  6273                                  ;  234  3784 isToken
  6274                                  ;  235  3792 errorexit
  6275                                  ;  236  3813 indexerror
  6276                                  ;  237  3824 indexerror
  6277                                  ;  238  3848 indexerror
  6278                                  ;  239  3859 indexerror
  6279                                  ;  240  3889 putch
  6280                                  ;  241  3957 strcpy
  6281                                  ;  242  3972 DosInt
  6282                                  ;  243  3988 DosInt
  6283                                  ;  244  4011 DosInt
  6284                                  ;  245  4030 DosInt
  6285                                  ;  246  4064 writetty
  6286                                  ;  247  4073 writetty
  6287                                  ;Input: AS.C, List: AS.S,  Lines:  191
  6288                                  ;Glob. variables:  199 max.:  200
  6289                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6290                                  ;Functions      :   74 max.:  300
  6291                                  ;Calls          :  248 max.: 2000, NameField: 4105 max.:    65535
  6292                                  ;Code until     :26009 max.: 30000, free: 3991
  6293                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6294                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
