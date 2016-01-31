     1                                  
     2                                  ; A.COM CComp V0.7 16.11.2014, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E93B15                  jmp main
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
   948 0000046E E82905                   call getLine
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
   999 0000049F E86803                   call lookCode
  1000                                  
  1001                                  ;-17       if(CodeType) process();
  1002                                  
  1003 000004A2 A0[3100]                 mov al, [CodeType]
  1004 000004A5 08C0                     or  al, al
  1005 000004A7 0F840600                 je @@parse5
  1006 000004AB E8A615                   call process
  1007                                  
  1008                                  ;-18       else getVariable();
  1009                                  
  1010 000004AE E90300                   jmp @@parse6
  1011                                  @@parse5:
  1012 000004B1 E81E02                   call getVariable
  1013                                  
  1014                                  ;-19       skipRest();
  1015                                  
  1016                                  @@parse6:
  1017 000004B4 E8BA04                   call skipRest
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
  1030 000004C6 E88F0E                   call error1
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
  1041 000004DB E87A0E                   call error1
  1042 000004DE 83C402                   add  sp, 2
  1043                                  
  1044                                  ;-23     printLine();
  1045                                  
  1046                                  @@parse10:
  1047                                  @@parse9:
  1048                                  @@parse7:
  1049 000004E1 E8090C                   call printLine
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
  1086 00000535 E86405                   call skipBlank
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
  1120 00000573 E8841B                   call digit
  1121 00000576 83C402                   add  sp, 2
  1122 00000579 08C0                     or  al, al
  1123 0000057B 0F841800                 je @@getTokeType14
  1124 0000057F 8A46FE                   mov al, byte [bp-2]
  1125 00000582 B400                     mov ah, 0
  1126 00000584 50                       push ax
  1127 00000585 E81A06                   call getDigit
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
  1139 0000059D E82705                   call letterE
  1140 000005A0 83C402                   add  sp, 2
  1141 000005A3 08C0                     or  al, al
  1142 000005A5 0F841800                 je @@getTokeType15
  1143 000005A9 8A46FE                   mov al, byte [bp-2]
  1144 000005AC B400                     mov ah, 0
  1145 000005AE 50                       push ax
  1146 000005AF E84706                   call getName
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
  1162                                  ;-36 int storeLabel() {unsigned int i;
  1163                                  
  1164 000005CD C9                      @@retn: LEAVE
  1165 000005CE C3                       ret
  1166                                  ; ENDP
  1167                                  
  1168                                  storeLabel:  ; *** PROC ***
  1169                                  
  1170                                  ;-37   if(searchLabel()) error1("duplicate label");
  1171                                  
  1172                                  ;Function : storeLabel, Number of local variables: 1
  1173                                  ;   # type sign width line used address name   list of local variables
  1174                                  ;  200 var unsg word    36 NULL bp-2    i;
  1175 000005CF C8020000                 ENTER  2,0
  1176 000005D3 E89C00                   call searchLabel
  1177 000005D6 08C0                     or  al, al
  1178 000005D8 0F840900                 je @@storeLabel16
  1179 000005DC 68[3D06]                 push storeLabel_0
  1180 000005DF E8760D                   call error1
  1181 000005E2 83C402                   add  sp, 2
  1182                                  
  1183                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1184                                  
  1185                                  @@storeLabel16:
  1186 000005E5 8D063075                 lea  ax, [Symbol]
  1187 000005E9 50                       push ax
  1188 000005EA FF36[4400]               push word [LabelNamePtr]
  1189 000005EE E8D01A                   call strcpy
  1190 000005F1 83C404                   add  sp, 4
  1191 000005F4 A3[4400]                 mov word [LabelNamePtr], ax
  1192                                  
  1193                                  ;-39   LabelNamePtr++;
  1194                                  
  1195 000005F7 FF06[4400]               inc  word [LabelNamePtr]
  1196                                  
  1197                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  1198                                  
  1199 000005FB A1[4400]                 mov ax, [LabelNamePtr]
  1200 000005FE 2DBB76                   sub ax, LabelNames
  1201 00000601 8946FE                   mov word [bp-2], ax
  1202                                  
  1203                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  1204                                  
  1205 00000604 8B46FE                   mov ax, [bp-2]
  1206 00000607 3DC903                   cmp ax, 969 ;unsigned : 0
  1207 0000060A 0F820900                 jb  @@storeLabel17
  1208 0000060E 68[4D06]                 push storeLabel_1
  1209 00000611 E8D90E                   call errorexit
  1210 00000614 83C402                   add  sp, 2
  1211                                  
  1212                                  ;-42   LabelMaxIx++;
  1213                                  
  1214                                  @@storeLabel17:
  1215 00000617 FF06[4600]               inc  word [LabelMaxIx]
  1216                                  
  1217                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  1218                                  
  1219 0000061B A1[4600]                 mov ax, [LabelMaxIx]
  1220 0000061E 83F864                   cmp ax, 100 ;unsigned : 1
  1221 00000621 0F8C0900                 jl  @@storeLabel18
  1222 00000625 68[6206]                 push storeLabel_2
  1223 00000628 E8C20E                   call errorexit
  1224 0000062B 83C402                   add  sp, 2
  1225                                  
  1226                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  1227                                  
  1228                                  @@storeLabel18:
  1229 0000062E A1[2A00]                 mov ax, [PC]
  1230 00000631 8B1E[4600]               mov bx, [LabelMaxIx]
  1231 00000635 D1E3                     shl bx, 1
  1232 00000637 8987A37A                 mov [LabelAddr+bx], ax
  1233                                  
  1234                                  ;-45 }
  1235                                  
  1236                                  
  1237                                  ;-46 int searchLabel() {
  1238 0000063B C9                       LEAVE
  1239 0000063C C3                       ret
  1240                                  ; ENDP
  1241 0000063D 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  1242 00000646 206C6162656C00     
  1243 0000064D 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  1244 00000656 6C6162656C206E616D-
  1245 0000065F 657300             
  1246 00000662 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  1247 0000066B 6C6162656C7300     
  1248                                  
  1249                                  searchLabel:  ; *** PROC ***
  1250                                  
  1251                                  ;-47   int LIx; char *p; int j;
  1252                                  
  1253                                  
  1254                                  ;-48   p = &LabelNames;
  1255                                  
  1256                                  ;Function : searchLabel, Number of local variables: 3
  1257                                  ;   # type sign width line used address name   list of local variables
  1258                                  ;  200 var sign word    47 NULL bp-2    LIx
  1259                                  ;  201 ptr sign byte    47 NULL bp-4    p
  1260                                  ;  202 var sign word    47 NULL bp-6    j;
  1261 00000672 C8060000                 ENTER  6,0
  1262 00000676 B8BB76                   mov ax, LabelNames
  1263 00000679 8946FC                   mov word [bp-4], ax
  1264                                  
  1265                                  ;-49   LIx=1;
  1266                                  
  1267 0000067C 66B801000000             mov eax, 1
  1268 00000682 8946FE                   mov word [bp-2], ax
  1269                                  
  1270                                  ;-50   while (LIx <= LabelMaxIx) {
  1271                                  
  1272                                  @@searchLabel19:
  1273 00000685 8B46FE                   mov ax, [bp-2]
  1274 00000688 3B06[4600]               cmp ax, [LabelMaxIx]
  1275 0000068C 0F8F3700                 jg  @@searchLabel20
  1276                                  
  1277                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  1278                                  
  1279 00000690 8D063075                 lea  ax, [Symbol]
  1280 00000694 50                       push ax
  1281 00000695 FF76FC                   push word [bp-4]
  1282 00000698 E8921A                   call eqstr
  1283 0000069B 83C404                   add  sp, 4
  1284 0000069E 08C0                     or  al, al
  1285 000006A0 0F840600                 je @@searchLabel21
  1286 000006A4 8B46FE                   mov ax, [bp-2]
  1287 000006A7 E92600                   jmp @@retn
  1288                                  
  1289                                  ;-52     j=strlen(p);
  1290                                  
  1291                                  @@searchLabel21:
  1292 000006AA FF76FC                   push word [bp-4]
  1293 000006AD E8E619                   call strlen
  1294 000006B0 83C402                   add  sp, 2
  1295 000006B3 8946FA                   mov word [bp-6], ax
  1296                                  
  1297                                  ;-53     p=p+j; p++; LIx++;
  1298                                  
  1299 000006B6 8B46FC                   mov ax, [bp-4]
  1300 000006B9 0346FA                   add ax, [bp-6]
  1301 000006BC 8946FC                   mov word [bp-4], ax
  1302 000006BF FF46FC                   inc  word [bp-4]
  1303 000006C2 FF46FE                   inc  word [bp-2]
  1304                                  
  1305                                  ;-54   }
  1306                                  
  1307                                  
  1308                                  ;-55   return 0;
  1309                                  
  1310 000006C5 EBBE                     jmp @@searchLabel19
  1311                                  @@searchLabel20:
  1312 000006C7 66B800000000             mov eax, 0
  1313 000006CD E90000                   jmp @@retn
  1314                                  
  1315                                  ;-56 }
  1316                                  
  1317                                  
  1318                                  ;-57 int getVariable() { char c;
  1319                                  
  1320 000006D0 C9                      @@retn: LEAVE
  1321 000006D1 C3                       ret
  1322                                  ; ENDP
  1323                                  
  1324                                  getVariable:  ; *** PROC ***
  1325                                  
  1326                                  ;-58   storeLabel();
  1327                                  
  1328                                  ;Function : getVariable, Number of local variables: 1
  1329                                  ;   # type sign width line used address name   list of local variables
  1330                                  ;  200 var sign byte    57 NULL bp-2    c;
  1331 000006D2 C8020000                 ENTER  2,0
  1332 000006D6 E8F6FE                   call storeLabel
  1333                                  
  1334                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  1335                                  
  1336 000006D9 E855FE                   call getTokeType
  1337 000006DC A0[2F00]                 mov al, [TokeType]
  1338 000006DF 3C03                     cmp al, 3
  1339 000006E1 0F85CC00                 jne @@getVariable22
  1340                                  
  1341                                  ;-60     lookCode();
  1342                                  
  1343 000006E5 E82201                   call lookCode
  1344                                  
  1345                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  1346                                  
  1347 000006E8 A0[3100]                 mov al, [CodeType]
  1348 000006EB 3CC8                     cmp al, 200
  1349 000006ED 0F8D0900                 jge @@getVariable23
  1350 000006F1 68[BC07]                 push getVariable_0
  1351 000006F4 E8F60D                   call errorexit
  1352 000006F7 83C402                   add  sp, 2
  1353                                  
  1354                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1355                                  
  1356                                  @@getVariable23:
  1357 000006FA A0[3100]                 mov al, [CodeType]
  1358 000006FD 3CCF                     cmp al, 207
  1359 000006FF 0F8E0900                 jle @@getVariable24
  1360 00000703 68[D407]                 push getVariable_1
  1361 00000706 E8E40D                   call errorexit
  1362 00000709 83C402                   add  sp, 2
  1363                                  
  1364                                  ;-63     if (CodeType== 200) {// DB
  1365                                  
  1366                                  @@getVariable24:
  1367 0000070C A0[3100]                 mov al, [CodeType]
  1368 0000070F 3CC8                     cmp al, 200
  1369 00000711 0F856A00                 jne @@getVariable25
  1370                                  
  1371                                  ;-64       do { getTokeType();
  1372                                  
  1373                                  @@getVariable26:
  1374 00000715 E819FE                   call getTokeType
  1375                                  
  1376                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  1377                                  
  1378 00000718 A0[2F00]                 mov al, [TokeType]
  1379 0000071B 3C01                     cmp al, 1
  1380 0000071D 0F850D00                 jne @@getVariable27
  1381 00000721 FF36[1900]               push word [SymbolInt]
  1382 00000725 E8A611                   call genCode8
  1383 00000728 83C402                   add  sp, 2
  1384                                  
  1385                                  ;-66         else {
  1386                                  
  1387 0000072B E94100                   jmp @@getVariable28
  1388                                  @@getVariable27:
  1389                                  
  1390                                  ;-67           skipBlank();
  1391                                  
  1392 0000072E E86B03                   call skipBlank
  1393                                  
  1394                                  ;-68           if (isToken('"')) {
  1395                                  
  1396 00000731 6A22                     push 34
  1397 00000733 E8D101                   call isToken
  1398 00000736 83C402                   add  sp, 2
  1399 00000739 08C0                     or  al, al
  1400 0000073B 0F843000                 je @@getVariable29
  1401                                  
  1402                                  ;-69             do { c= *InputPtr;
  1403                                  
  1404                                  @@getVariable30:
  1405 0000073F 8B1E[1B00]               mov bx, [InputPtr]
  1406 00000743 8A07                     mov al, [bx]
  1407 00000745 B400                     mov ah, 0
  1408 00000747 8846FE                   mov byte [bp-2], al
  1409                                  
  1410                                  ;-70               genCode8(c);
  1411                                  
  1412 0000074A 8A46FE                   mov al, byte [bp-2]
  1413 0000074D B400                     mov ah, 0
  1414 0000074F 50                       push ax
  1415 00000750 E87B11                   call genCode8
  1416 00000753 83C402                   add  sp, 2
  1417                                  
  1418                                  ;-71               InputPtr++;
  1419                                  
  1420 00000756 FF06[1B00]               inc  word [InputPtr]
  1421                                  
  1422                                  ;-72             } while (*InputPtr != '"' );
  1423                                  
  1424 0000075A 8B1E[1B00]               mov bx, [InputPtr]
  1425 0000075E 8A07                     mov al, [bx]
  1426 00000760 B400                     mov ah, 0
  1427 00000762 83F822                   cmp ax, 34
  1428 00000765 0F840200                 je  @@getVariable31
  1429 00000769 EBD4                     jmp @@getVariable30
  1430                                  @@getVariable31:
  1431                                  
  1432                                  ;-73             InputPtr++;
  1433                                  
  1434 0000076B FF06[1B00]               inc  word [InputPtr]
  1435                                  
  1436                                  ;-74           }
  1437                                  
  1438                                  
  1439                                  ;-75         }
  1440                                  
  1441                                  @@getVariable29:
  1442                                  
  1443                                  ;-76       } while (isToken(','));
  1444                                  
  1445                                  @@getVariable28:
  1446 0000076F 6A2C                     push 44
  1447 00000771 E89301                   call isToken
  1448 00000774 83C402                   add  sp, 2
  1449 00000777 08C0                     or  al, al
  1450 00000779 0F840200                 je @@getVariable32
  1451 0000077D EB96                     jmp @@getVariable26
  1452                                  @@getVariable32:
  1453                                  
  1454                                  ;-77     }
  1455                                  
  1456                                  
  1457                                  ;-78     if (CodeType== 201) {// DW
  1458                                  
  1459                                  @@getVariable25:
  1460 0000077F A0[3100]                 mov al, [CodeType]
  1461 00000782 3CC9                     cmp al, 201
  1462 00000784 0F852600                 jne @@getVariable33
  1463                                  
  1464                                  ;-79       do { getTokeType();
  1465                                  
  1466                                  @@getVariable34:
  1467 00000788 E8A6FD                   call getTokeType
  1468                                  
  1469                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  1470                                  
  1471 0000078B A0[2F00]                 mov al, [TokeType]
  1472 0000078E 3C01                     cmp al, 1
  1473 00000790 0F850A00                 jne @@getVariable35
  1474 00000794 FF36[1900]               push word [SymbolInt]
  1475 00000798 E88911                   call genCode16
  1476 0000079B 83C402                   add  sp, 2
  1477                                  
  1478                                  ;-81       } while (isToken(','));
  1479                                  
  1480                                  @@getVariable35:
  1481 0000079E 6A2C                     push 44
  1482 000007A0 E86401                   call isToken
  1483 000007A3 83C402                   add  sp, 2
  1484 000007A6 08C0                     or  al, al
  1485 000007A8 0F840200                 je @@getVariable36
  1486 000007AC EBDA                     jmp @@getVariable34
  1487                                  @@getVariable36:
  1488                                  
  1489                                  ;-82     }
  1490                                  
  1491                                  
  1492                                  ;-83   }
  1493                                  
  1494                                  @@getVariable33:
  1495                                  
  1496                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  1497                                  
  1498 000007AE E90900                   jmp @@getVariable37
  1499                                  @@getVariable22:
  1500 000007B1 68[EC07]                 push getVariable_2
  1501 000007B4 E8360D                   call errorexit
  1502 000007B7 83C402                   add  sp, 2
  1503                                  
  1504                                  ;-85 }
  1505                                  
  1506                                  @@getVariable37:
  1507                                  
  1508                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  1509 000007BA C9                       LEAVE
  1510 000007BB C3                       ret
  1511                                  ; ENDP
  1512 000007BC 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  1513 000007C5 422C572C4420657870-
  1514 000007CE 656374656400       
  1515 000007D4 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  1516 000007DD 422C572C4420657870-
  1517 000007E6 656374656400       
  1518 000007EC 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  1519 000007F5 6F7220524553422C57-
  1520 000007FE 2C4420657870656374-
  1521 00000807 656400             
  1522                                  
  1523                                  lookCode:  ; *** PROC ***
  1524                                  
  1525                                  ;-87   CodeType=0;
  1526                                  
  1527 0000080A 66B800000000             mov eax, 0
  1528 00000810 A2[3100]                 mov byte [CodeType], al
  1529                                  
  1530                                  ;-88   OpCodePtr= &I_START;
  1531                                  
  1532 00000813 B8[5000]                 mov ax, I_START
  1533 00000816 A3[4100]                 mov word [OpCodePtr], ax
  1534                                  
  1535                                  ;-89   OpCodePtr++;
  1536                                  
  1537 00000819 FF06[4100]               inc  word [OpCodePtr]
  1538                                  
  1539                                  ;-90   do  {
  1540                                  
  1541                                  @@lookCode38:
  1542                                  
  1543                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  1544                                  
  1545 0000081D FF36[4100]               push word [OpCodePtr]
  1546 00000821 8D064F75                 lea  ax, [SymbolUpper]
  1547 00000825 50                       push ax
  1548 00000826 E80419                   call eqstr
  1549 00000829 83C404                   add  sp, 4
  1550 0000082C 08C0                     or  al, al
  1551 0000082E 0F842700                 je @@lookCode39
  1552                                  
  1553                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  1554                                  
  1555                                  @@lookCode40:
  1556 00000832 8B1E[4100]               mov bx, [OpCodePtr]
  1557 00000836 8A07                     mov al, [bx]
  1558 00000838 B400                     mov ah, 0
  1559 0000083A 83F800                   cmp ax, 0
  1560 0000083D 0F840600                 je  @@lookCode41
  1561 00000841 FF06[4100]               inc  word [OpCodePtr]
  1562                                  
  1563                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  1564                                  
  1565 00000845 EBEB                     jmp @@lookCode40
  1566                                  @@lookCode41:
  1567 00000847 FF06[4100]               inc  word [OpCodePtr]
  1568 0000084B 8B1E[4100]               mov bx, [OpCodePtr]
  1569 0000084F 8A07                     mov al, [bx]
  1570 00000851 B400                     mov ah, 0
  1571 00000853 A2[3100]                 mov byte [CodeType], al
  1572                                  
  1573                                  ;-94       return;
  1574                                  
  1575 00000856 E92A00                   jmp @@retn
  1576                                  
  1577                                  ;-95     }
  1578                                  
  1579                                  
  1580                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  1581                                  
  1582                                  @@lookCode39:
  1583                                  @@lookCode42:
  1584 00000859 8B1E[4100]               mov bx, [OpCodePtr]
  1585 0000085D 8A07                     mov al, [bx]
  1586 0000085F B400                     mov ah, 0
  1587 00000861 3DF100                   cmp ax, 241
  1588 00000864 0F840600                 je  @@lookCode43
  1589 00000868 FF06[4100]               inc  word [OpCodePtr]
  1590                                  
  1591                                  ;-97   OpCodePtr++;
  1592                                  
  1593 0000086C EBEB                     jmp @@lookCode42
  1594                                  @@lookCode43:
  1595 0000086E FF06[4100]               inc  word [OpCodePtr]
  1596                                  
  1597                                  ;-98   } while(*OpCodePtr!=0);
  1598                                  
  1599 00000872 8B1E[4100]               mov bx, [OpCodePtr]
  1600 00000876 8A07                     mov al, [bx]
  1601 00000878 B400                     mov ah, 0
  1602 0000087A 83F800                   cmp ax, 0
  1603 0000087D 0F840200                 je  @@lookCode44
  1604 00000881 EB9A                     jmp @@lookCode38
  1605                                  @@lookCode44:
  1606                                  
  1607                                  ;-99 }
  1608                                  
  1609                                  
  1610                                  ;-100 
  1611                                  
  1612                                  
  1613                                  ;-101 int getCodeSize() {
  1614                                  
  1615                                  @@retn:
  1616 00000883 C3                       ret
  1617                                  ; ENDP
  1618                                  
  1619                                  getCodeSize:  ; *** PROC ***
  1620                                  
  1621                                  ;-102   if (TokeType ==ALNUME) {
  1622                                  
  1623 00000884 A0[2F00]                 mov al, [TokeType]
  1624 00000887 3C03                     cmp al, 3
  1625 00000889 0F856000                 jne @@getCodeSize45
  1626                                  
  1627                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1628                                  
  1629 0000088D 68[F708]                 push getCodeSize_0
  1630 00000890 8D064F75                 lea  ax, [SymbolUpper]
  1631 00000894 50                       push ax
  1632 00000895 E89518                   call eqstr
  1633 00000898 83C404                   add  sp, 4
  1634 0000089B 08C0                     or  al, al
  1635 0000089D 0F840C00                 je @@getCodeSize46
  1636 000008A1 E88DFC                   call getTokeType
  1637 000008A4 66B801000000             mov eax, 1
  1638 000008AA E94900                   jmp @@retn
  1639                                  
  1640                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1641                                  
  1642                                  @@getCodeSize46:
  1643 000008AD 68[FC08]                 push getCodeSize_1
  1644 000008B0 8D064F75                 lea  ax, [SymbolUpper]
  1645 000008B4 50                       push ax
  1646 000008B5 E87518                   call eqstr
  1647 000008B8 83C404                   add  sp, 4
  1648 000008BB 08C0                     or  al, al
  1649 000008BD 0F840C00                 je @@getCodeSize47
  1650 000008C1 E86DFC                   call getTokeType
  1651 000008C4 66B802000000             mov eax, 2
  1652 000008CA E92900                   jmp @@retn
  1653                                  
  1654                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1655                                  
  1656                                  @@getCodeSize47:
  1657 000008CD 68[0109]                 push getCodeSize_2
  1658 000008D0 8D064F75                 lea  ax, [SymbolUpper]
  1659 000008D4 50                       push ax
  1660 000008D5 E85518                   call eqstr
  1661 000008D8 83C404                   add  sp, 4
  1662 000008DB 08C0                     or  al, al
  1663 000008DD 0F840C00                 je @@getCodeSize48
  1664 000008E1 E84DFC                   call getTokeType
  1665 000008E4 66B803000000             mov eax, 3
  1666 000008EA E90900                   jmp @@retn
  1667                                  
  1668                                  ;-106   } return 0;
  1669                                  
  1670                                  @@getCodeSize48:
  1671                                  @@getCodeSize45:
  1672 000008ED 66B800000000             mov eax, 0
  1673 000008F3 E90000                   jmp @@retn
  1674                                  
  1675                                  ;-107 }
  1676                                  
  1677                                  
  1678                                  ;-108 int isToken(char c) {
  1679                                  
  1680                                  @@retn:
  1681 000008F6 C3                       ret
  1682                                  ; ENDP
  1683 000008F7 4259544500              getCodeSize_0 db "BYTE",0
  1684 000008FC 574F524400              getCodeSize_1 db "WORD",0
  1685 00000901 44574F524400            getCodeSize_2 db "DWORD",0
  1686                                  
  1687                                  isToken:  ; *** PROC ***
  1688                                  
  1689                                  ;-109   skipBlank();
  1690                                  
  1691                                  ;Function : isToken, Number of local variables: 1
  1692                                  ;   # type sign width line used address name   list of local variables
  1693                                  ;  200 var sign byte   108 NULL bp+4    c;
  1694 00000907 C8000000                 ENTER  0,0
  1695 0000090B E88E01                   call skipBlank
  1696                                  
  1697                                  ;-110   if (*InputPtr == c) {
  1698                                  
  1699 0000090E 8B1E[1B00]               mov bx, [InputPtr]
  1700 00000912 8A07                     mov al, [bx]
  1701 00000914 B400                     mov ah, 0
  1702 00000916 3A4604                   cmp al, [bp+4]
  1703 00000919 0F850D00                 jne @@isToken49
  1704                                  
  1705                                  ;-111     InputPtr++; return 1;} return 0;
  1706                                  
  1707 0000091D FF06[1B00]               inc  word [InputPtr]
  1708 00000921 66B801000000             mov eax, 1
  1709 00000927 E90900                   jmp @@retn
  1710                                  @@isToken49:
  1711 0000092A 66B800000000             mov eax, 0
  1712 00000930 E90000                   jmp @@retn
  1713                                  
  1714                                  ;-112 }
  1715                                  
  1716                                  
  1717                                  ;-113 int need(char c) {
  1718                                  
  1719 00000933 C9                      @@retn: LEAVE
  1720 00000934 C3                       ret
  1721                                  ; ENDP
  1722                                  
  1723                                  need:  ; *** PROC ***
  1724                                  
  1725                                  ;-114   if (isToken(c)) return;
  1726                                  
  1727                                  ;Function : need, Number of local variables: 1
  1728                                  ;   # type sign width line used address name   list of local variables
  1729                                  ;  200 var sign byte   113 NULL bp+4    c;
  1730 00000935 C8000000                 ENTER  0,0
  1731 00000939 8A4604                   mov al, byte [bp+4]
  1732 0000093C B400                     mov ah, 0
  1733 0000093E 50                       push ax
  1734 0000093F E8C5FF                   call isToken
  1735 00000942 83C402                   add  sp, 2
  1736 00000945 08C0                     or  al, al
  1737 00000947 0F840300                 je @@need50
  1738 0000094B E91800                   jmp @@retn
  1739                                  
  1740                                  ;-115   error1();
  1741                                  
  1742                                  @@need50:
  1743 0000094E E8070A                   call error1
  1744                                  
  1745                                  ;-116   prs(". need: ");
  1746                                  
  1747 00000951 68[6809]                 push need_0
  1748 00000954 E8A408                   call prs
  1749 00000957 83C402                   add  sp, 2
  1750                                  
  1751                                  ;-117   prc(c);
  1752                                  
  1753 0000095A 8A4604                   mov al, byte [bp+4]
  1754 0000095D B400                     mov ah, 0
  1755 0000095F 50                       push ax
  1756 00000960 E83708                   call prc
  1757 00000963 83C402                   add  sp, 2
  1758                                  
  1759                                  ;-118 }
  1760                                  
  1761                                  
  1762                                  ;-119 
  1763                                  
  1764                                  
  1765                                  ;-120 int skipRest() {
  1766                                  
  1767 00000966 C9                      @@retn: LEAVE
  1768 00000967 C3                       ret
  1769                                  ; ENDP
  1770 00000968 2E206E6565643A2000      need_0 db ". need: ",0
  1771                                  
  1772                                  skipRest:  ; *** PROC ***
  1773                                  
  1774                                  ;-121   getTokeType(); 
  1775                                  
  1776 00000971 E8BDFB                   call getTokeType
  1777                                  
  1778                                  ;-122   if(TokeType)error1("extra char ignored");
  1779                                  
  1780 00000974 A0[2F00]                 mov al, [TokeType]
  1781 00000977 08C0                     or  al, al
  1782 00000979 0F840900                 je @@skipRest51
  1783 0000097D 68[8709]                 push skipRest_0
  1784 00000980 E8D509                   call error1
  1785 00000983 83C402                   add  sp, 2
  1786                                  
  1787                                  ;-123 }
  1788                                  
  1789                                  @@skipRest51:
  1790 00000986 C3                       ret
  1791                                  ; ENDP
  1792 00000987 657874726120636861-     skipRest_0 db "extra char ignored",0
  1793 00000990 722069676E6F726564-
  1794 00000999 00                 
  1795                                  ;Back to main program: AS.C
  1796                                  
  1797                                  ;-6 #include "HELPER.C"
  1798                                  
  1799                                  ;Use include file: HELPER.C
  1800                                  
  1801                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  1802                                  
  1803                                  
  1804                                  getLine:  ; *** PROC ***
  1805                                  
  1806                                  ;-2   unsigned int i;
  1807                                  
  1808                                  
  1809                                  ;-3   InputPtr= &InputBuf;
  1810                                  
  1811                                  ;Function : getLine, Number of local variables: 1
  1812                                  ;   # type sign width line used address name   list of local variables
  1813                                  ;  200 var unsg word     2 NULL bp-2    i;
  1814 0000099A C8020000                 ENTER  2,0
  1815 0000099E B86E75                   mov ax, InputBuf
  1816 000009A1 A3[1B00]                 mov word [InputPtr], ax
  1817                                  
  1818                                  ;-4   *InputPtr=0;//if last line is empty
  1819                                  
  1820 000009A4 66B800000000             mov eax, 0
  1821 000009AA 8B1E[1B00]               mov  bx, [InputPtr]
  1822 000009AE 8807                     mov  [bx], al
  1823                                  
  1824                                  ;-5   do {
  1825                                  
  1826                                  @@getLine52:
  1827                                  
  1828                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1829                                  
  1830 000009B0 6A01                     push 1
  1831 000009B2 FF36[1D00]               push word [asm_fd]
  1832 000009B6 8D06[2900]               lea  ax, [DOS_ByteRead]
  1833 000009BA 50                       push ax
  1834 000009BB E80A18                   call readRL
  1835 000009BE 83C406                   add  sp, 6
  1836 000009C1 A3[2700]                 mov word [DOS_NoBytes], ax
  1837                                  
  1838                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  1839                                  
  1840 000009C4 A1[2300]                 mov ax, [DOS_ERR]
  1841 000009C7 08C0                     or  al, al
  1842 000009C9 0F840900                 je @@getLine53
  1843 000009CD 68[320A]                 push getLine_0
  1844 000009D0 E81A0B                   call errorexit
  1845 000009D3 83C402                   add  sp, 2
  1846                                  
  1847                                  ;-8     if (DOS_NoBytes == 0) return;
  1848                                  
  1849                                  @@getLine53:
  1850 000009D6 A1[2700]                 mov ax, [DOS_NoBytes]
  1851 000009D9 83F800                   cmp ax, 0
  1852 000009DC 0F850300                 jne @@getLine54
  1853 000009E0 E94D00                   jmp @@retn
  1854                                  
  1855                                  ;-9     *InputPtr = DOS_ByteRead;
  1856                                  
  1857                                  @@getLine54:
  1858 000009E3 A0[2900]                 mov al, [DOS_ByteRead]
  1859 000009E6 8B1E[1B00]               mov  bx, [InputPtr]
  1860 000009EA 8807                     mov  [bx], al
  1861                                  
  1862                                  ;-10     InputPtr++;
  1863                                  
  1864 000009EC FF06[1B00]               inc  word [InputPtr]
  1865                                  
  1866                                  ;-11     i = InputPtr - &InputBuf;
  1867                                  
  1868 000009F0 A1[1B00]                 mov ax, [InputPtr]
  1869 000009F3 2D6E75                   sub ax, InputBuf
  1870 000009F6 8946FE                   mov word [bp-2], ax
  1871                                  
  1872                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  1873                                  
  1874 000009F9 8B46FE                   mov ax, [bp-2]
  1875 000009FC 83F87F                   cmp ax, 127 ;unsigned : 0
  1876 000009FF 0F820900                 jb  @@getLine55
  1877 00000A03 68[410A]                 push getLine_1
  1878 00000A06 E8E40A                   call errorexit
  1879 00000A09 83C402                   add  sp, 2
  1880                                  
  1881                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  1882                                  
  1883                                  @@getLine55:
  1884 00000A0C A0[2900]                 mov al, byte [DOS_ByteRead]
  1885 00000A0F B400                     mov ah, 0
  1886 00000A11 50                       push ax
  1887 00000A12 E84000                   call ifEOL
  1888 00000A15 83C402                   add  sp, 2
  1889 00000A18 3C00                     cmp al, 0
  1890 00000A1A 0F850200                 jne @@getLine56
  1891 00000A1E EB90                     jmp @@getLine52
  1892                                  @@getLine56:
  1893                                  
  1894                                  ;-14   InputPtr--;
  1895                                  
  1896 00000A20 FF0E[1B00]               dec  word [InputPtr]
  1897                                  
  1898                                  ;-15   *InputPtr=0;
  1899                                  
  1900 00000A24 66B800000000             mov eax, 0
  1901 00000A2A 8B1E[1B00]               mov  bx, [InputPtr]
  1902 00000A2E 8807                     mov  [bx], al
  1903                                  
  1904                                  ;-16 }
  1905                                  
  1906                                  
  1907                                  ;-17 int ifEOL(char c) {
  1908                                  
  1909 00000A30 C9                      @@retn: LEAVE
  1910 00000A31 C3                       ret
  1911                                  ; ENDP
  1912 00000A32 52656164696E672053-     getLine_0 db "Reading Source",0
  1913 00000A3B 6F7572636500       
  1914 00000A41 696E707574206C696E-     getLine_1 db "input line too long",0
  1915 00000A4A 6520746F6F206C6F6E-
  1916 00000A53 6700               
  1917                                  
  1918                                  ifEOL:  ; *** PROC ***
  1919                                  
  1920                                  ;-18   if (c == 10) return 1;
  1921                                  
  1922                                  ;Function : ifEOL, Number of local variables: 1
  1923                                  ;   # type sign width line used address name   list of local variables
  1924                                  ;  200 var sign byte    17 NULL bp+4    c;
  1925 00000A55 C8000000                 ENTER  0,0
  1926 00000A59 8A4604                   mov al, [bp+4]
  1927 00000A5C 3C0A                     cmp al, 10
  1928 00000A5E 0F850900                 jne @@ifEOL57
  1929 00000A62 66B801000000             mov eax, 1
  1930 00000A68 E92F00                   jmp @@retn
  1931                                  
  1932                                  ;-19   if (c == 13) {
  1933                                  
  1934                                  @@ifEOL57:
  1935 00000A6B 8A4604                   mov al, [bp+4]
  1936 00000A6E 3C0D                     cmp al, 13
  1937 00000A70 0F851D00                 jne @@ifEOL58
  1938                                  
  1939                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1940                                  
  1941 00000A74 6A01                     push 1
  1942 00000A76 FF36[1D00]               push word [asm_fd]
  1943 00000A7A 8D06[2900]               lea  ax, [DOS_ByteRead]
  1944 00000A7E 50                       push ax
  1945 00000A7F E84617                   call readRL
  1946 00000A82 83C406                   add  sp, 6
  1947 00000A85 A3[2700]                 mov word [DOS_NoBytes], ax
  1948                                  
  1949                                  ;-21     return 1;}
  1950                                  
  1951 00000A88 66B801000000             mov eax, 1
  1952 00000A8E E90900                   jmp @@retn
  1953                                  
  1954                                  ;-22   return 0;
  1955                                  
  1956                                  @@ifEOL58:
  1957 00000A91 66B800000000             mov eax, 0
  1958 00000A97 E90000                   jmp @@retn
  1959                                  
  1960                                  ;-23 }
  1961                                  
  1962                                  
  1963                                  ;-24 int skipBlank() {
  1964                                  
  1965 00000A9A C9                      @@retn: LEAVE
  1966 00000A9B C3                       ret
  1967                                  ; ENDP
  1968                                  
  1969                                  skipBlank:  ; *** PROC ***
  1970                                  
  1971                                  ;-25   skipblank1:
  1972                                  
  1973                                  @@skipblank1:
  1974                                  
  1975                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  1976                                  
  1977 00000A9C 8B1E[1B00]               mov bx, [InputPtr]
  1978 00000AA0 8A07                     mov al, [bx]
  1979 00000AA2 B400                     mov ah, 0
  1980 00000AA4 83F820                   cmp ax, 32
  1981 00000AA7 0F850600                 jne @@skipBlank59
  1982 00000AAB FF06[1B00]               inc  word [InputPtr]
  1983 00000AAF EBEB                     jmp @@skipblank1
  1984                                  
  1985                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  1986                                  
  1987                                  @@skipBlank59:
  1988 00000AB1 8B1E[1B00]               mov bx, [InputPtr]
  1989 00000AB5 8A07                     mov al, [bx]
  1990 00000AB7 B400                     mov ah, 0
  1991 00000AB9 83F809                   cmp ax, 9
  1992 00000ABC 0F850600                 jne @@skipBlank60
  1993 00000AC0 FF06[1B00]               inc  word [InputPtr]
  1994 00000AC4 EBD6                     jmp @@skipblank1
  1995                                  
  1996                                  ;-28 }
  1997                                  
  1998                                  @@skipBlank60:
  1999                                  
  2000                                  ;-29 int letterE(char c) {
  2001                                  
  2002 00000AC6 C3                       ret
  2003                                  ; ENDP
  2004                                  
  2005                                  letterE:  ; *** PROC ***
  2006                                  
  2007                                  ;-30   if (c=='_') return 1;
  2008                                  
  2009                                  ;Function : letterE, Number of local variables: 1
  2010                                  ;   # type sign width line used address name   list of local variables
  2011                                  ;  200 var sign byte    29 NULL bp+4    c;
  2012 00000AC7 C8000000                 ENTER  0,0
  2013 00000ACB 8A4604                   mov al, [bp+4]
  2014 00000ACE 3C5F                     cmp al, 95
  2015 00000AD0 0F850900                 jne @@letterE61
  2016 00000AD4 66B801000000             mov eax, 1
  2017 00000ADA E97E00                   jmp @@retn
  2018                                  
  2019                                  ;-31   if (c=='.') return 1;
  2020                                  
  2021                                  @@letterE61:
  2022 00000ADD 8A4604                   mov al, [bp+4]
  2023 00000AE0 3C2E                     cmp al, 46
  2024 00000AE2 0F850900                 jne @@letterE62
  2025 00000AE6 66B801000000             mov eax, 1
  2026 00000AEC E96C00                   jmp @@retn
  2027                                  
  2028                                  ;-32   if (c=='?') return 1;
  2029                                  
  2030                                  @@letterE62:
  2031 00000AEF 8A4604                   mov al, [bp+4]
  2032 00000AF2 3C3F                     cmp al, 63
  2033 00000AF4 0F850900                 jne @@letterE63
  2034 00000AF8 66B801000000             mov eax, 1
  2035 00000AFE E95A00                   jmp @@retn
  2036                                  
  2037                                  ;-33   if (c=='$') return 1;
  2038                                  
  2039                                  @@letterE63:
  2040 00000B01 8A4604                   mov al, [bp+4]
  2041 00000B04 3C24                     cmp al, 36
  2042 00000B06 0F850900                 jne @@letterE64
  2043 00000B0A 66B801000000             mov eax, 1
  2044 00000B10 E94800                   jmp @@retn
  2045                                  
  2046                                  ;-34   if (c> 'z') return 0;
  2047                                  
  2048                                  @@letterE64:
  2049 00000B13 8A4604                   mov al, [bp+4]
  2050 00000B16 3C7A                     cmp al, 122
  2051 00000B18 0F8E0900                 jle @@letterE65
  2052 00000B1C 66B800000000             mov eax, 0
  2053 00000B22 E93600                   jmp @@retn
  2054                                  
  2055                                  ;-35   if (c< '@') return 0; // at included
  2056                                  
  2057                                  @@letterE65:
  2058 00000B25 8A4604                   mov al, [bp+4]
  2059 00000B28 3C40                     cmp al, 64
  2060 00000B2A 0F8D0900                 jge @@letterE66
  2061 00000B2E 66B800000000             mov eax, 0
  2062 00000B34 E92400                   jmp @@retn
  2063                                  
  2064                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2065                                  
  2066                                  @@letterE66:
  2067 00000B37 8A4604                   mov al, [bp+4]
  2068 00000B3A 3C5A                     cmp al, 90
  2069 00000B3C 0F8E1200                 jle @@letterE67
  2070 00000B40 8A4604                   mov al, [bp+4]
  2071 00000B43 3C61                     cmp al, 97
  2072 00000B45 0F8D0900                 jge @@letterE68
  2073 00000B49 66B800000000             mov eax, 0
  2074 00000B4F E90900                   jmp @@retn
  2075                                  @@letterE68:
  2076                                  
  2077                                  ;-37   return 1;
  2078                                  
  2079                                  @@letterE67:
  2080 00000B52 66B801000000             mov eax, 1
  2081 00000B58 E90000                   jmp @@retn
  2082                                  
  2083                                  ;-38 }
  2084                                  
  2085                                  
  2086                                  ;-39 int alnumE(char c) {
  2087                                  
  2088 00000B5B C9                      @@retn: LEAVE
  2089 00000B5C C3                       ret
  2090                                  ; ENDP
  2091                                  
  2092                                  alnumE:  ; *** PROC ***
  2093                                  
  2094                                  ;-40   if (digit(c)) return 1;
  2095                                  
  2096                                  ;Function : alnumE, Number of local variables: 1
  2097                                  ;   # type sign width line used address name   list of local variables
  2098                                  ;  200 var sign byte    39 NULL bp+4    c;
  2099 00000B5D C8000000                 ENTER  0,0
  2100 00000B61 8A4604                   mov al, byte [bp+4]
  2101 00000B64 B400                     mov ah, 0
  2102 00000B66 50                       push ax
  2103 00000B67 E89015                   call digit
  2104 00000B6A 83C402                   add  sp, 2
  2105 00000B6D 08C0                     or  al, al
  2106 00000B6F 0F840900                 je @@alnumE69
  2107 00000B73 66B801000000             mov eax, 1
  2108 00000B79 E92400                   jmp @@retn
  2109                                  
  2110                                  ;-41   if (letterE(c)) return 1;
  2111                                  
  2112                                  @@alnumE69:
  2113 00000B7C 8A4604                   mov al, byte [bp+4]
  2114 00000B7F B400                     mov ah, 0
  2115 00000B81 50                       push ax
  2116 00000B82 E842FF                   call letterE
  2117 00000B85 83C402                   add  sp, 2
  2118 00000B88 08C0                     or  al, al
  2119 00000B8A 0F840900                 je @@alnumE70
  2120 00000B8E 66B801000000             mov eax, 1
  2121 00000B94 E90900                   jmp @@retn
  2122                                  
  2123                                  ;-42   return 0;
  2124                                  
  2125                                  @@alnumE70:
  2126 00000B97 66B800000000             mov eax, 0
  2127 00000B9D E90000                   jmp @@retn
  2128                                  
  2129                                  ;-43 }
  2130                                  
  2131                                  
  2132                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2133                                  
  2134 00000BA0 C9                      @@retn: LEAVE
  2135 00000BA1 C3                       ret
  2136                                  ; ENDP
  2137                                  
  2138                                  getDigit:  ; *** PROC ***
  2139                                  
  2140                                  ;-45   unsigned int CastInt;
  2141                                  
  2142                                  
  2143                                  ;-46   SymbolInt=0;
  2144                                  
  2145                                  ;Function : getDigit, Number of local variables: 2
  2146                                  ;   # type sign width line used address name   list of local variables
  2147                                  ;  200 var unsg byte    44 NULL bp+4    c
  2148                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  2149 00000BA2 C8020000                 ENTER  2,0
  2150 00000BA6 66B800000000             mov eax, 0
  2151 00000BAC A3[1900]                 mov word [SymbolInt], ax
  2152                                  
  2153                                  ;-47   do {
  2154                                  
  2155                                  @@getDigit71:
  2156                                  
  2157                                  ;-48     c-='0';
  2158                                  
  2159 00000BAF 806E0430                 sub  byte [bp+4], 48
  2160                                  
  2161                                  ;-49     SymbolInt=SymbolInt*10;
  2162                                  
  2163 00000BB3 A1[1900]                 mov ax, [SymbolInt]
  2164 00000BB6 66BB0A000000             mov ebx, 10
  2165 00000BBC 66F7E3                   mul ebx
  2166 00000BBF A3[1900]                 mov word [SymbolInt], ax
  2167                                  
  2168                                  ;-50     ax=0; CastInt=c; //cast b2w
  2169                                  
  2170 00000BC2 B80000                   mov  ax, 0
  2171 00000BC5 8A4604                   mov al, [bp+4]
  2172 00000BC8 8946FE                   mov word [bp-2], ax
  2173                                  
  2174                                  ;-51     SymbolInt=SymbolInt+CastInt;
  2175                                  
  2176 00000BCB A1[1900]                 mov ax, [SymbolInt]
  2177 00000BCE 0346FE                   add ax, [bp-2]
  2178 00000BD1 A3[1900]                 mov word [SymbolInt], ax
  2179                                  
  2180                                  ;-52     InputPtr++;
  2181                                  
  2182 00000BD4 FF06[1B00]               inc  word [InputPtr]
  2183                                  
  2184                                  ;-53     c = *InputPtr;
  2185                                  
  2186 00000BD8 8B1E[1B00]               mov bx, [InputPtr]
  2187 00000BDC 8A07                     mov al, [bx]
  2188 00000BDE B400                     mov ah, 0
  2189 00000BE0 884604                   mov byte [bp+4], al
  2190                                  
  2191                                  ;-54   } while(digit(c));
  2192                                  
  2193 00000BE3 8A4604                   mov al, byte [bp+4]
  2194 00000BE6 B400                     mov ah, 0
  2195 00000BE8 50                       push ax
  2196 00000BE9 E80E15                   call digit
  2197 00000BEC 83C402                   add  sp, 2
  2198 00000BEF 08C0                     or  al, al
  2199 00000BF1 0F840200                 je @@getDigit72
  2200 00000BF5 EBB8                     jmp @@getDigit71
  2201                                  @@getDigit72:
  2202                                  
  2203                                  ;-55 }
  2204                                  
  2205                                  
  2206                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2207 00000BF7 C9                       LEAVE
  2208 00000BF8 C3                       ret
  2209                                  ; ENDP
  2210                                  
  2211                                  getName:  ; *** PROC ***
  2212                                  
  2213                                  ;-57   char *p; unsigned int i;
  2214                                  
  2215                                  
  2216                                  ;-58   p = &Symbol;
  2217                                  
  2218                                  ;Function : getName, Number of local variables: 3
  2219                                  ;   # type sign width line used address name   list of local variables
  2220                                  ;  200 var unsg byte    56 NULL bp+4    c
  2221                                  ;  201 ptr sign byte    57 NULL bp-2    p
  2222                                  ;  202 var unsg word    57 NULL bp-4    i;
  2223 00000BF9 C8040000                 ENTER  4,0
  2224 00000BFD B83075                   mov ax, Symbol
  2225 00000C00 8946FE                   mov word [bp-2], ax
  2226                                  
  2227                                  ;-59   *p = c;
  2228                                  
  2229 00000C03 8A4604                   mov al, [bp+4]
  2230 00000C06 8B5EFE                   mov  bx, [bp-2]
  2231 00000C09 8807                     mov  [bx], al
  2232                                  
  2233                                  ;-60   p++;
  2234                                  
  2235 00000C0B FF46FE                   inc  word [bp-2]
  2236                                  
  2237                                  ;-61   while (alnumE(c)) {
  2238                                  
  2239                                  @@getName73:
  2240 00000C0E 8A4604                   mov al, byte [bp+4]
  2241 00000C11 B400                     mov ah, 0
  2242 00000C13 50                       push ax
  2243 00000C14 E846FF                   call alnumE
  2244 00000C17 83C402                   add  sp, 2
  2245 00000C1A 08C0                     or  al, al
  2246 00000C1C 0F843800                 je @@getName74
  2247                                  
  2248                                  ;-62     InputPtr++;
  2249                                  
  2250 00000C20 FF06[1B00]               inc  word [InputPtr]
  2251                                  
  2252                                  ;-63     c = *InputPtr;
  2253                                  
  2254 00000C24 8B1E[1B00]               mov bx, [InputPtr]
  2255 00000C28 8A07                     mov al, [bx]
  2256 00000C2A B400                     mov ah, 0
  2257 00000C2C 884604                   mov byte [bp+4], al
  2258                                  
  2259                                  ;-64     *p = c;
  2260                                  
  2261 00000C2F 8A4604                   mov al, [bp+4]
  2262 00000C32 8B5EFE                   mov  bx, [bp-2]
  2263 00000C35 8807                     mov  [bx], al
  2264                                  
  2265                                  ;-65     p++;
  2266                                  
  2267 00000C37 FF46FE                   inc  word [bp-2]
  2268                                  
  2269                                  ;-66     i = p - &Symbol;
  2270                                  
  2271 00000C3A 8B46FE                   mov ax, [bp-2]
  2272 00000C3D 2D3075                   sub ax, Symbol
  2273 00000C40 8946FC                   mov word [bp-4], ax
  2274                                  
  2275                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  2276                                  
  2277 00000C43 8B46FC                   mov ax, [bp-4]
  2278 00000C46 83F81F                   cmp ax, 31 ;unsigned : 0
  2279 00000C49 0F820900                 jb  @@getName75
  2280 00000C4D 68[A10C]                 push getName_0
  2281 00000C50 E89A08                   call errorexit
  2282 00000C53 83C402                   add  sp, 2
  2283                                  
  2284                                  ;-68   }
  2285                                  
  2286                                  @@getName75:
  2287                                  
  2288                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  2289                                  
  2290 00000C56 EBB6                     jmp @@getName73
  2291                                  @@getName74:
  2292 00000C58 8A4604                   mov al, [bp+4]
  2293 00000C5B 3C3A                     cmp al, 58
  2294 00000C5D 0F850C00                 jne @@getName76
  2295 00000C61 66B801000000             mov eax, 1
  2296 00000C67 A2[2E00]                 mov byte [isLabel], al
  2297 00000C6A E90900                   jmp @@getName77
  2298                                  @@getName76:
  2299 00000C6D 66B800000000             mov eax, 0
  2300 00000C73 A2[2E00]                 mov byte [isLabel], al
  2301                                  
  2302                                  ;-70   p--;
  2303                                  
  2304                                  @@getName77:
  2305 00000C76 FF4EFE                   dec  word [bp-2]
  2306                                  
  2307                                  ;-71   *p = 0;
  2308                                  
  2309 00000C79 66B800000000             mov eax, 0
  2310 00000C7F 8B5EFE                   mov  bx, [bp-2]
  2311 00000C82 8807                     mov  [bx], al
  2312                                  
  2313                                  ;-72   strcpy(SymbolUpper, Symbol);
  2314                                  
  2315 00000C84 8D063075                 lea  ax, [Symbol]
  2316 00000C88 50                       push ax
  2317 00000C89 8D064F75                 lea  ax, [SymbolUpper]
  2318 00000C8D 50                       push ax
  2319 00000C8E E83014                   call strcpy
  2320 00000C91 83C404                   add  sp, 4
  2321                                  
  2322                                  ;-73   toupper(SymbolUpper);
  2323                                  
  2324 00000C94 8D064F75                 lea  ax, [SymbolUpper]
  2325 00000C98 50                       push ax
  2326 00000C99 E8B713                   call toupper
  2327 00000C9C 83C402                   add  sp, 2
  2328                                  
  2329                                  ;-74 }
  2330                                  
  2331                                  
  2332                                  ;-75 int testReg() {
  2333 00000C9F C9                       LEAVE
  2334 00000CA0 C3                       ret
  2335                                  ; ENDP
  2336 00000CA1 73796D626F6C20746F-     getName_0 db "symbol too long",0
  2337 00000CAA 6F206C6F6E6700     
  2338                                  
  2339                                  testReg:  ; *** PROC ***
  2340                                  
  2341                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2342                                  
  2343                                  
  2344                                  ;-77   RegType=0;
  2345                                  
  2346 00000CB1 66B800000000             mov eax, 0
  2347 00000CB7 A2[3500]                 mov byte [RegType], al
  2348                                  
  2349                                  ;-78   if (strlen(Symbol) < 2) return 0;
  2350                                  
  2351 00000CBA 8D063075                 lea  ax, [Symbol]
  2352 00000CBE 50                       push ax
  2353 00000CBF E8D413                   call strlen
  2354 00000CC2 83C402                   add  sp, 2
  2355 00000CC5 3C02                     cmp al, 2
  2356 00000CC7 0F8D0900                 jge @@testReg78
  2357 00000CCB 66B800000000             mov eax, 0
  2358 00000CD1 E9B603                   jmp @@retn
  2359                                  
  2360                                  ;-79   if (strlen(Symbol) > 3) return 0;
  2361                                  
  2362                                  @@testReg78:
  2363 00000CD4 8D063075                 lea  ax, [Symbol]
  2364 00000CD8 50                       push ax
  2365 00000CD9 E8BA13                   call strlen
  2366 00000CDC 83C402                   add  sp, 2
  2367 00000CDF 3C03                     cmp al, 3
  2368 00000CE1 0F8E0900                 jle @@testReg79
  2369 00000CE5 66B800000000             mov eax, 0
  2370 00000CEB E99C03                   jmp @@retn
  2371                                  
  2372                                  ;-80   RegType=BYTE;
  2373                                  
  2374                                  @@testReg79:
  2375 00000CEE 66B801000000             mov eax, 1
  2376 00000CF4 A2[3500]                 mov byte [RegType], al
  2377                                  
  2378                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  2379                                  
  2380 00000CF7 68[8B10]                 push testReg_0
  2381 00000CFA 8D064F75                 lea  ax, [SymbolUpper]
  2382 00000CFE 50                       push ax
  2383 00000CFF E82B14                   call eqstr
  2384 00000D02 83C404                   add  sp, 4
  2385 00000D05 08C0                     or  al, al
  2386 00000D07 0F840900                 je @@testReg80
  2387 00000D0B 66B800000000             mov eax, 0
  2388 00000D11 E97603                   jmp @@retn
  2389                                  
  2390                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  2391                                  
  2392                                  @@testReg80:
  2393 00000D14 68[8E10]                 push testReg_1
  2394 00000D17 8D064F75                 lea  ax, [SymbolUpper]
  2395 00000D1B 50                       push ax
  2396 00000D1C E80E14                   call eqstr
  2397 00000D1F 83C404                   add  sp, 4
  2398 00000D22 08C0                     or  al, al
  2399 00000D24 0F840900                 je @@testReg81
  2400 00000D28 66B801000000             mov eax, 1
  2401 00000D2E E95903                   jmp @@retn
  2402                                  
  2403                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  2404                                  
  2405                                  @@testReg81:
  2406 00000D31 68[9110]                 push testReg_2
  2407 00000D34 8D064F75                 lea  ax, [SymbolUpper]
  2408 00000D38 50                       push ax
  2409 00000D39 E8F113                   call eqstr
  2410 00000D3C 83C404                   add  sp, 4
  2411 00000D3F 08C0                     or  al, al
  2412 00000D41 0F840900                 je @@testReg82
  2413 00000D45 66B802000000             mov eax, 2
  2414 00000D4B E93C03                   jmp @@retn
  2415                                  
  2416                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  2417                                  
  2418                                  @@testReg82:
  2419 00000D4E 68[9410]                 push testReg_3
  2420 00000D51 8D064F75                 lea  ax, [SymbolUpper]
  2421 00000D55 50                       push ax
  2422 00000D56 E8D413                   call eqstr
  2423 00000D59 83C404                   add  sp, 4
  2424 00000D5C 08C0                     or  al, al
  2425 00000D5E 0F840900                 je @@testReg83
  2426 00000D62 66B803000000             mov eax, 3
  2427 00000D68 E91F03                   jmp @@retn
  2428                                  
  2429                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  2430                                  
  2431                                  @@testReg83:
  2432 00000D6B 68[9710]                 push testReg_4
  2433 00000D6E 8D064F75                 lea  ax, [SymbolUpper]
  2434 00000D72 50                       push ax
  2435 00000D73 E8B713                   call eqstr
  2436 00000D76 83C404                   add  sp, 4
  2437 00000D79 08C0                     or  al, al
  2438 00000D7B 0F840900                 je @@testReg84
  2439 00000D7F 66B804000000             mov eax, 4
  2440 00000D85 E90203                   jmp @@retn
  2441                                  
  2442                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  2443                                  
  2444                                  @@testReg84:
  2445 00000D88 68[9A10]                 push testReg_5
  2446 00000D8B 8D064F75                 lea  ax, [SymbolUpper]
  2447 00000D8F 50                       push ax
  2448 00000D90 E89A13                   call eqstr
  2449 00000D93 83C404                   add  sp, 4
  2450 00000D96 08C0                     or  al, al
  2451 00000D98 0F840900                 je @@testReg85
  2452 00000D9C 66B805000000             mov eax, 5
  2453 00000DA2 E9E502                   jmp @@retn
  2454                                  
  2455                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  2456                                  
  2457                                  @@testReg85:
  2458 00000DA5 68[9D10]                 push testReg_6
  2459 00000DA8 8D064F75                 lea  ax, [SymbolUpper]
  2460 00000DAC 50                       push ax
  2461 00000DAD E87D13                   call eqstr
  2462 00000DB0 83C404                   add  sp, 4
  2463 00000DB3 08C0                     or  al, al
  2464 00000DB5 0F840900                 je @@testReg86
  2465 00000DB9 66B806000000             mov eax, 6
  2466 00000DBF E9C802                   jmp @@retn
  2467                                  
  2468                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  2469                                  
  2470                                  @@testReg86:
  2471 00000DC2 68[A010]                 push testReg_7
  2472 00000DC5 8D064F75                 lea  ax, [SymbolUpper]
  2473 00000DC9 50                       push ax
  2474 00000DCA E86013                   call eqstr
  2475 00000DCD 83C404                   add  sp, 4
  2476 00000DD0 08C0                     or  al, al
  2477 00000DD2 0F840900                 je @@testReg87
  2478 00000DD6 66B807000000             mov eax, 7
  2479 00000DDC E9AB02                   jmp @@retn
  2480                                  
  2481                                  ;-89   RegType=WORD;
  2482                                  
  2483                                  @@testReg87:
  2484 00000DDF 66B802000000             mov eax, 2
  2485 00000DE5 A2[3500]                 mov byte [RegType], al
  2486                                  
  2487                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  2488                                  
  2489 00000DE8 68[A310]                 push testReg_8
  2490 00000DEB 8D064F75                 lea  ax, [SymbolUpper]
  2491 00000DEF 50                       push ax
  2492 00000DF0 E83A13                   call eqstr
  2493 00000DF3 83C404                   add  sp, 4
  2494 00000DF6 08C0                     or  al, al
  2495 00000DF8 0F840900                 je @@testReg88
  2496 00000DFC 66B800000000             mov eax, 0
  2497 00000E02 E98502                   jmp @@retn
  2498                                  
  2499                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  2500                                  
  2501                                  @@testReg88:
  2502 00000E05 68[A610]                 push testReg_9
  2503 00000E08 8D064F75                 lea  ax, [SymbolUpper]
  2504 00000E0C 50                       push ax
  2505 00000E0D E81D13                   call eqstr
  2506 00000E10 83C404                   add  sp, 4
  2507 00000E13 08C0                     or  al, al
  2508 00000E15 0F840900                 je @@testReg89
  2509 00000E19 66B801000000             mov eax, 1
  2510 00000E1F E96802                   jmp @@retn
  2511                                  
  2512                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  2513                                  
  2514                                  @@testReg89:
  2515 00000E22 68[A910]                 push testReg_10
  2516 00000E25 8D064F75                 lea  ax, [SymbolUpper]
  2517 00000E29 50                       push ax
  2518 00000E2A E80013                   call eqstr
  2519 00000E2D 83C404                   add  sp, 4
  2520 00000E30 08C0                     or  al, al
  2521 00000E32 0F840900                 je @@testReg90
  2522 00000E36 66B802000000             mov eax, 2
  2523 00000E3C E94B02                   jmp @@retn
  2524                                  
  2525                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  2526                                  
  2527                                  @@testReg90:
  2528 00000E3F 68[AC10]                 push testReg_11
  2529 00000E42 8D064F75                 lea  ax, [SymbolUpper]
  2530 00000E46 50                       push ax
  2531 00000E47 E8E312                   call eqstr
  2532 00000E4A 83C404                   add  sp, 4
  2533 00000E4D 08C0                     or  al, al
  2534 00000E4F 0F840900                 je @@testReg91
  2535 00000E53 66B803000000             mov eax, 3
  2536 00000E59 E92E02                   jmp @@retn
  2537                                  
  2538                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  2539                                  
  2540                                  @@testReg91:
  2541 00000E5C 68[AF10]                 push testReg_12
  2542 00000E5F 8D064F75                 lea  ax, [SymbolUpper]
  2543 00000E63 50                       push ax
  2544 00000E64 E8C612                   call eqstr
  2545 00000E67 83C404                   add  sp, 4
  2546 00000E6A 08C0                     or  al, al
  2547 00000E6C 0F840900                 je @@testReg92
  2548 00000E70 66B804000000             mov eax, 4
  2549 00000E76 E91102                   jmp @@retn
  2550                                  
  2551                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  2552                                  
  2553                                  @@testReg92:
  2554 00000E79 68[B210]                 push testReg_13
  2555 00000E7C 8D064F75                 lea  ax, [SymbolUpper]
  2556 00000E80 50                       push ax
  2557 00000E81 E8A912                   call eqstr
  2558 00000E84 83C404                   add  sp, 4
  2559 00000E87 08C0                     or  al, al
  2560 00000E89 0F840900                 je @@testReg93
  2561 00000E8D 66B805000000             mov eax, 5
  2562 00000E93 E9F401                   jmp @@retn
  2563                                  
  2564                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  2565                                  
  2566                                  @@testReg93:
  2567 00000E96 68[B510]                 push testReg_14
  2568 00000E99 8D064F75                 lea  ax, [SymbolUpper]
  2569 00000E9D 50                       push ax
  2570 00000E9E E88C12                   call eqstr
  2571 00000EA1 83C404                   add  sp, 4
  2572 00000EA4 08C0                     or  al, al
  2573 00000EA6 0F840900                 je @@testReg94
  2574 00000EAA 66B806000000             mov eax, 6
  2575 00000EB0 E9D701                   jmp @@retn
  2576                                  
  2577                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  2578                                  
  2579                                  @@testReg94:
  2580 00000EB3 68[B810]                 push testReg_15
  2581 00000EB6 8D064F75                 lea  ax, [SymbolUpper]
  2582 00000EBA 50                       push ax
  2583 00000EBB E86F12                   call eqstr
  2584 00000EBE 83C404                   add  sp, 4
  2585 00000EC1 08C0                     or  al, al
  2586 00000EC3 0F840900                 je @@testReg95
  2587 00000EC7 66B807000000             mov eax, 7
  2588 00000ECD E9BA01                   jmp @@retn
  2589                                  
  2590                                  ;-98   RegType=SEGREG;
  2591                                  
  2592                                  @@testReg95:
  2593 00000ED0 66B804000000             mov eax, 4
  2594 00000ED6 A2[3500]                 mov byte [RegType], al
  2595                                  
  2596                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  2597                                  
  2598 00000ED9 68[BB10]                 push testReg_16
  2599 00000EDC 8D064F75                 lea  ax, [SymbolUpper]
  2600 00000EE0 50                       push ax
  2601 00000EE1 E84912                   call eqstr
  2602 00000EE4 83C404                   add  sp, 4
  2603 00000EE7 08C0                     or  al, al
  2604 00000EE9 0F840900                 je @@testReg96
  2605 00000EED 66B800000000             mov eax, 0
  2606 00000EF3 E99401                   jmp @@retn
  2607                                  
  2608                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  2609                                  
  2610                                  @@testReg96:
  2611 00000EF6 68[BE10]                 push testReg_17
  2612 00000EF9 8D064F75                 lea  ax, [SymbolUpper]
  2613 00000EFD 50                       push ax
  2614 00000EFE E82C12                   call eqstr
  2615 00000F01 83C404                   add  sp, 4
  2616 00000F04 08C0                     or  al, al
  2617 00000F06 0F840900                 je @@testReg97
  2618 00000F0A 66B801000000             mov eax, 1
  2619 00000F10 E97701                   jmp @@retn
  2620                                  
  2621                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  2622                                  
  2623                                  @@testReg97:
  2624 00000F13 68[C110]                 push testReg_18
  2625 00000F16 8D064F75                 lea  ax, [SymbolUpper]
  2626 00000F1A 50                       push ax
  2627 00000F1B E80F12                   call eqstr
  2628 00000F1E 83C404                   add  sp, 4
  2629 00000F21 08C0                     or  al, al
  2630 00000F23 0F840900                 je @@testReg98
  2631 00000F27 66B802000000             mov eax, 2
  2632 00000F2D E95A01                   jmp @@retn
  2633                                  
  2634                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  2635                                  
  2636                                  @@testReg98:
  2637 00000F30 68[C410]                 push testReg_19
  2638 00000F33 8D064F75                 lea  ax, [SymbolUpper]
  2639 00000F37 50                       push ax
  2640 00000F38 E8F211                   call eqstr
  2641 00000F3B 83C404                   add  sp, 4
  2642 00000F3E 08C0                     or  al, al
  2643 00000F40 0F840900                 je @@testReg99
  2644 00000F44 66B803000000             mov eax, 3
  2645 00000F4A E93D01                   jmp @@retn
  2646                                  
  2647                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  2648                                  
  2649                                  @@testReg99:
  2650 00000F4D 68[C710]                 push testReg_20
  2651 00000F50 8D064F75                 lea  ax, [SymbolUpper]
  2652 00000F54 50                       push ax
  2653 00000F55 E8D511                   call eqstr
  2654 00000F58 83C404                   add  sp, 4
  2655 00000F5B 08C0                     or  al, al
  2656 00000F5D 0F840900                 je @@testReg100
  2657 00000F61 66B804000000             mov eax, 4
  2658 00000F67 E92001                   jmp @@retn
  2659                                  
  2660                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  2661                                  
  2662                                  @@testReg100:
  2663 00000F6A 68[CA10]                 push testReg_21
  2664 00000F6D 8D064F75                 lea  ax, [SymbolUpper]
  2665 00000F71 50                       push ax
  2666 00000F72 E8B811                   call eqstr
  2667 00000F75 83C404                   add  sp, 4
  2668 00000F78 08C0                     or  al, al
  2669 00000F7A 0F840900                 je @@testReg101
  2670 00000F7E 66B805000000             mov eax, 5
  2671 00000F84 E90301                   jmp @@retn
  2672                                  
  2673                                  ;-105   RegType=DWORD;
  2674                                  
  2675                                  @@testReg101:
  2676 00000F87 66B803000000             mov eax, 3
  2677 00000F8D A2[3500]                 mov byte [RegType], al
  2678                                  
  2679                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  2680                                  
  2681 00000F90 68[CD10]                 push testReg_22
  2682 00000F93 8D064F75                 lea  ax, [SymbolUpper]
  2683 00000F97 50                       push ax
  2684 00000F98 E89211                   call eqstr
  2685 00000F9B 83C404                   add  sp, 4
  2686 00000F9E 08C0                     or  al, al
  2687 00000FA0 0F840900                 je @@testReg102
  2688 00000FA4 66B800000000             mov eax, 0
  2689 00000FAA E9DD00                   jmp @@retn
  2690                                  
  2691                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  2692                                  
  2693                                  @@testReg102:
  2694 00000FAD 68[D110]                 push testReg_23
  2695 00000FB0 8D064F75                 lea  ax, [SymbolUpper]
  2696 00000FB4 50                       push ax
  2697 00000FB5 E87511                   call eqstr
  2698 00000FB8 83C404                   add  sp, 4
  2699 00000FBB 08C0                     or  al, al
  2700 00000FBD 0F840900                 je @@testReg103
  2701 00000FC1 66B801000000             mov eax, 1
  2702 00000FC7 E9C000                   jmp @@retn
  2703                                  
  2704                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  2705                                  
  2706                                  @@testReg103:
  2707 00000FCA 68[D510]                 push testReg_24
  2708 00000FCD 8D064F75                 lea  ax, [SymbolUpper]
  2709 00000FD1 50                       push ax
  2710 00000FD2 E85811                   call eqstr
  2711 00000FD5 83C404                   add  sp, 4
  2712 00000FD8 08C0                     or  al, al
  2713 00000FDA 0F840900                 je @@testReg104
  2714 00000FDE 66B802000000             mov eax, 2
  2715 00000FE4 E9A300                   jmp @@retn
  2716                                  
  2717                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  2718                                  
  2719                                  @@testReg104:
  2720 00000FE7 68[D910]                 push testReg_25
  2721 00000FEA 8D064F75                 lea  ax, [SymbolUpper]
  2722 00000FEE 50                       push ax
  2723 00000FEF E83B11                   call eqstr
  2724 00000FF2 83C404                   add  sp, 4
  2725 00000FF5 08C0                     or  al, al
  2726 00000FF7 0F840900                 je @@testReg105
  2727 00000FFB 66B803000000             mov eax, 3
  2728 00001001 E98600                   jmp @@retn
  2729                                  
  2730                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  2731                                  
  2732                                  @@testReg105:
  2733 00001004 68[DD10]                 push testReg_26
  2734 00001007 8D064F75                 lea  ax, [SymbolUpper]
  2735 0000100B 50                       push ax
  2736 0000100C E81E11                   call eqstr
  2737 0000100F 83C404                   add  sp, 4
  2738 00001012 08C0                     or  al, al
  2739 00001014 0F840900                 je @@testReg106
  2740 00001018 66B804000000             mov eax, 4
  2741 0000101E E96900                   jmp @@retn
  2742                                  
  2743                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  2744                                  
  2745                                  @@testReg106:
  2746 00001021 68[E110]                 push testReg_27
  2747 00001024 8D064F75                 lea  ax, [SymbolUpper]
  2748 00001028 50                       push ax
  2749 00001029 E80111                   call eqstr
  2750 0000102C 83C404                   add  sp, 4
  2751 0000102F 08C0                     or  al, al
  2752 00001031 0F840900                 je @@testReg107
  2753 00001035 66B805000000             mov eax, 5
  2754 0000103B E94C00                   jmp @@retn
  2755                                  
  2756                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  2757                                  
  2758                                  @@testReg107:
  2759 0000103E 68[E510]                 push testReg_28
  2760 00001041 8D064F75                 lea  ax, [SymbolUpper]
  2761 00001045 50                       push ax
  2762 00001046 E8E410                   call eqstr
  2763 00001049 83C404                   add  sp, 4
  2764 0000104C 08C0                     or  al, al
  2765 0000104E 0F840900                 je @@testReg108
  2766 00001052 66B806000000             mov eax, 6
  2767 00001058 E92F00                   jmp @@retn
  2768                                  
  2769                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  2770                                  
  2771                                  @@testReg108:
  2772 0000105B 68[E910]                 push testReg_29
  2773 0000105E 8D064F75                 lea  ax, [SymbolUpper]
  2774 00001062 50                       push ax
  2775 00001063 E8C710                   call eqstr
  2776 00001066 83C404                   add  sp, 4
  2777 00001069 08C0                     or  al, al
  2778 0000106B 0F840900                 je @@testReg109
  2779 0000106F 66B807000000             mov eax, 7
  2780 00001075 E91200                   jmp @@retn
  2781                                  
  2782                                  ;-114   RegType=0; return 0;
  2783                                  
  2784                                  @@testReg109:
  2785 00001078 66B800000000             mov eax, 0
  2786 0000107E A2[3500]                 mov byte [RegType], al
  2787 00001081 66B800000000             mov eax, 0
  2788 00001087 E90000                   jmp @@retn
  2789                                  
  2790                                  ;-115 }
  2791                                  
  2792                                  @@retn:
  2793 0000108A C3                       ret
  2794                                  ; ENDP
  2795 0000108B 414C00                  testReg_0 db "AL",0
  2796 0000108E 434C00                  testReg_1 db "CL",0
  2797 00001091 444C00                  testReg_2 db "DL",0
  2798 00001094 424C00                  testReg_3 db "BL",0
  2799 00001097 414800                  testReg_4 db "AH",0
  2800 0000109A 434800                  testReg_5 db "CH",0
  2801 0000109D 444800                  testReg_6 db "DH",0
  2802 000010A0 424800                  testReg_7 db "BH",0
  2803 000010A3 415800                  testReg_8 db "AX",0
  2804 000010A6 435800                  testReg_9 db "CX",0
  2805 000010A9 445800                  testReg_10 db "DX",0
  2806 000010AC 425800                  testReg_11 db "BX",0
  2807 000010AF 535000                  testReg_12 db "SP",0
  2808 000010B2 425000                  testReg_13 db "BP",0
  2809 000010B5 534900                  testReg_14 db "SI",0
  2810 000010B8 444900                  testReg_15 db "DI",0
  2811 000010BB 455300                  testReg_16 db "ES",0
  2812 000010BE 435300                  testReg_17 db "CS",0
  2813 000010C1 535300                  testReg_18 db "SS",0
  2814 000010C4 445300                  testReg_19 db "DS",0
  2815 000010C7 465300                  testReg_20 db "FS",0
  2816 000010CA 475300                  testReg_21 db "GS",0
  2817 000010CD 45415800                testReg_22 db "EAX",0
  2818 000010D1 45435800                testReg_23 db "ECX",0
  2819 000010D5 45445800                testReg_24 db "EDX",0
  2820 000010D9 45425800                testReg_25 db "EBX",0
  2821 000010DD 45535000                testReg_26 db "ESP",0
  2822 000010E1 45425000                testReg_27 db "EBP",0
  2823 000010E5 45534900                testReg_28 db "ESI",0
  2824 000010E9 45444900                testReg_29 db "EDI",0
  2825                                  ;Back to main program: AS.C
  2826                                  
  2827                                  ;-7 #include "OUTPUT.C"
  2828                                  
  2829                                  ;Use include file: OUTPUT.C
  2830                                  
  2831                                  ;-1 int printLine() { int i; char c;
  2832                                  
  2833                                  
  2834                                  printLine:  ; *** PROC ***
  2835                                  
  2836                                  ;-2   prs("\n"); printhex16(PCStart);
  2837                                  
  2838                                  ;Function : printLine, Number of local variables: 2
  2839                                  ;   # type sign width line used address name   list of local variables
  2840                                  ;  200 var sign word     1 NULL bp-2    i
  2841                                  ;  201 var sign byte     1 NULL bp-4    c;
  2842 000010ED C8040000                 ENTER  4,0
  2843 000010F1 68[8211]                 push printLine_0
  2844 000010F4 E80401                   call prs
  2845 000010F7 83C402                   add  sp, 2
  2846 000010FA FF36[2C00]               push word [PCStart]
  2847 000010FE E8EB01                   call printhex16
  2848 00001101 83C402                   add  sp, 2
  2849                                  
  2850                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  2851                                  
  2852 00001104 A1[3F00]                 mov ax, [OpPrintIndex]
  2853 00001107 83F800                   cmp ax, 0
  2854 0000110A 0F850C00                 jne @@printLine110
  2855 0000110E 68[8511]                 push printLine_1
  2856 00001111 E8E700                   call prs
  2857 00001114 83C402                   add  sp, 2
  2858                                  
  2859                                  ;-4   else {
  2860                                  
  2861 00001117 E95B00                   jmp @@printLine111
  2862                                  @@printLine110:
  2863                                  
  2864                                  ;-5     prc(PrintR);
  2865                                  
  2866 0000111A A0[4300]                 mov al, byte [PrintR]
  2867 0000111D B400                     mov ah, 0
  2868 0000111F 50                       push ax
  2869 00001120 E87700                   call prc
  2870 00001123 83C402                   add  sp, 2
  2871                                  
  2872                                  ;-6     i=0;
  2873                                  
  2874 00001126 66B800000000             mov eax, 0
  2875 0000112C 8946FE                   mov word [bp-2], ax
  2876                                  
  2877                                  ;-7     do {
  2878                                  
  2879                                  @@printLine112:
  2880                                  
  2881                                  ;-8       c=OpPos[i];
  2882                                  
  2883 0000112F 8B5EFE                   mov bx, [bp-2]
  2884 00001132 8A87B676                 mov al, [OpPos + bx]
  2885 00001136 8846FC                   mov byte [bp-4], al
  2886                                  
  2887                                  ;-9       printhex8a(c); prc(' ');
  2888                                  
  2889 00001139 8A46FC                   mov al, byte [bp-4]
  2890 0000113C B400                     mov ah, 0
  2891 0000113E 50                       push ax
  2892 0000113F E85C01                   call printhex8a
  2893 00001142 83C402                   add  sp, 2
  2894 00001145 6A20                     push 32
  2895 00001147 E85000                   call prc
  2896 0000114A 83C402                   add  sp, 2
  2897                                  
  2898                                  ;-10       i++;
  2899                                  
  2900 0000114D FF46FE                   inc  word [bp-2]
  2901                                  
  2902                                  ;-11     } while(i < OpPrintIndex);
  2903                                  
  2904 00001150 8B46FE                   mov ax, [bp-2]
  2905 00001153 3B06[3F00]               cmp ax, [OpPrintIndex]
  2906 00001157 0F8D0200                 jge @@printLine113
  2907 0000115B EBD2                     jmp @@printLine112
  2908                                  @@printLine113:
  2909                                  
  2910                                  ;-12     do {// fill rest with blank
  2911                                  
  2912                                  @@printLine114:
  2913                                  
  2914                                  ;-13       prs("   ");
  2915                                  
  2916 0000115D 68[9611]                 push printLine_2
  2917 00001160 E89800                   call prs
  2918 00001163 83C402                   add  sp, 2
  2919                                  
  2920                                  ;-14       i++;
  2921                                  
  2922 00001166 FF46FE                   inc  word [bp-2]
  2923                                  
  2924                                  ;-15     } while(i < OPMAXLEN);
  2925                                  
  2926 00001169 8B46FE                   mov ax, [bp-2]
  2927 0000116C 83F805                   cmp ax, 5
  2928 0000116F 0F8D0200                 jge @@printLine115
  2929 00001173 EBE8                     jmp @@printLine114
  2930                                  @@printLine115:
  2931                                  
  2932                                  ;-16   }
  2933                                  
  2934                                  
  2935                                  ;-17   prscomment(InputBuf);
  2936                                  
  2937                                  @@printLine111:
  2938 00001175 8D066E75                 lea  ax, [InputBuf]
  2939 00001179 50                       push ax
  2940 0000117A E85000                   call prscomment
  2941 0000117D 83C402                   add  sp, 2
  2942                                  
  2943                                  ;-18 }
  2944                                  
  2945                                  
  2946                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  2947 00001180 C9                       LEAVE
  2948 00001181 C3                       ret
  2949                                  ; ENDP
  2950 00001182 5C6E00                  printLine_0 db "\n",0
  2951 00001185 202020202020202020-     printLine_1 db "                ",0
  2952 0000118E 2020202020202000   
  2953 00001196 20202000                printLine_2 db "   ",0
  2954                                  
  2955                                  prc:  ; *** PROC ***
  2956                                  ;Function : prc, Number of local variables: 1
  2957                                  ;   # type sign width line used address name   list of local variables
  2958                                  ;  200 var unsg byte    19 NULL bp+4    c;
  2959 0000119A C8000000                 ENTER  0,0
  2960 0000119E A0[1800]                 mov al, [LIST]
  2961 000011A1 08C0                     or  al, al
  2962 000011A3 0F841400                 je @@prc116
  2963 000011A7 807E040A                cmp byte [bp+4], 10
  2964 000011AB 0F850600                 jne @@prc117
  2965 000011AF B80D00                   mov  ax, 13
  2966 000011B2 E8680E                   call writetty
  2967                                  
  2968                                  ;-20      al=c; writetty(); }
  2969                                  
  2970                                  @@prc117:
  2971 000011B5 8A4604                   mov  al, [bp+4]
  2972 000011B8 E8620E                   call writetty
  2973                                  
  2974                                  ;-21    fputcR(c,lst_fd); }
  2975                                  
  2976                                  @@prc116:
  2977 000011BB FF36[1F00]               push word [lst_fd]
  2978 000011BF 8A4604                   mov al, byte [bp+4]
  2979 000011C2 B400                     mov ah, 0
  2980 000011C4 50                       push ax
  2981 000011C5 E81510                   call fputcR
  2982 000011C8 83C404                   add  sp, 4
  2983                                  
  2984                                  ;-22 
  2985                                  
  2986                                  
  2987                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  2988 000011CB C9                       LEAVE
  2989 000011CC C3                       ret
  2990                                  ; ENDP
  2991                                  
  2992                                  prscomment:  ; *** PROC ***
  2993                                  
  2994                                  ;-24   while(*s){c=*s;prc(c);s++;}
  2995                                  
  2996                                  ;Function : prscomment, Number of local variables: 2
  2997                                  ;   # type sign width line used address name   list of local variables
  2998                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  2999                                  ;  201 var unsg byte    23 NULL bp-2    c;
  3000 000011CD C8020000                 ENTER  2,0
  3001                                  @@prscomment118:
  3002 000011D1 8B5E04                   mov bx, [bp+4]
  3003 000011D4 8A07                     mov al, [bx]
  3004 000011D6 B400                     mov ah, 0
  3005 000011D8 08C0                     or  al, al
  3006 000011DA 0F841B00                 je @@prscomment119
  3007 000011DE 8B5E04                   mov bx, [bp+4]
  3008 000011E1 8A07                     mov al, [bx]
  3009 000011E3 B400                     mov ah, 0
  3010 000011E5 8846FE                   mov byte [bp-2], al
  3011 000011E8 8A46FE                   mov al, byte [bp-2]
  3012 000011EB B400                     mov ah, 0
  3013 000011ED 50                       push ax
  3014 000011EE E8A9FF                   call prc
  3015 000011F1 83C402                   add  sp, 2
  3016 000011F4 FF4604                   inc  word [bp+4]
  3017                                  
  3018                                  ;-25 }
  3019                                  
  3020 000011F7 EBD8                     jmp @@prscomment118
  3021                                  @@prscomment119:
  3022                                  
  3023                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3024 000011F9 C9                       LEAVE
  3025 000011FA C3                       ret
  3026                                  ; ENDP
  3027                                  
  3028                                  prs:  ; *** PROC ***
  3029                                  ;Function : prs, Number of local variables: 3
  3030                                  ;   # type sign width line used address name   list of local variables
  3031                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3032                                  ;  201 var unsg byte    26 NULL bp-2    c
  3033                                  ;  202 var sign word    26 NULL bp-4    com;
  3034 000011FB C8040000                 ENTER  4,0
  3035 000011FF 66B800000000             mov eax, 0
  3036 00001205 8946FC                   mov word [bp-4], ax
  3037                                  
  3038                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3039                                  
  3040                                  @@prs120:
  3041 00001208 8B5E04                   mov bx, [bp+4]
  3042 0000120B 8A07                     mov al, [bx]
  3043 0000120D B400                     mov ah, 0
  3044 0000120F 08C0                     or  al, al
  3045 00001211 0F848700                 je @@prs121
  3046 00001215 8B5E04                   mov bx, [bp+4]
  3047 00001218 8A07                     mov al, [bx]
  3048 0000121A B400                     mov ah, 0
  3049 0000121C 8846FE                   mov byte [bp-2], al
  3050 0000121F 8A46FE                   mov al, [bp-2]
  3051 00001222 3C22                     cmp al, 34
  3052 00001224 0F851E00                 jne @@prs122
  3053 00001228 8B46FC                   mov ax, [bp-4]
  3054 0000122B 08C0                     or  al, al
  3055 0000122D 0F840C00                 je @@prs123
  3056 00001231 66B800000000             mov eax, 0
  3057 00001237 8946FC                   mov word [bp-4], ax
  3058 0000123A E90900                   jmp @@prs124
  3059                                  @@prs123:
  3060 0000123D 66B801000000             mov eax, 1
  3061 00001243 8946FC                   mov word [bp-4], ax
  3062                                  
  3063                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3064                                  
  3065                                  @@prs124:
  3066                                  @@prs122:
  3067 00001246 8A46FE                   mov al, [bp-2]
  3068 00001249 3C5C                     cmp al, 92
  3069 0000124B 0F853B00                 jne @@prs125
  3070 0000124F 8B46FC                   mov ax, [bp-4]
  3071 00001252 83F800                   cmp ax, 0
  3072 00001255 0F853100                 jne @@prs126
  3073 00001259 FF4604                   inc  word [bp+4]
  3074 0000125C 8B5E04                   mov bx, [bp+4]
  3075 0000125F 8A07                     mov al, [bx]
  3076 00001261 B400                     mov ah, 0
  3077 00001263 8846FE                   mov byte [bp-2], al
  3078                                  
  3079                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3080                                  
  3081 00001266 8A46FE                   mov al, [bp-2]
  3082 00001269 3C6E                     cmp al, 110
  3083 0000126B 0F850900                 jne @@prs127
  3084 0000126F 66B80A000000             mov eax, 10
  3085 00001275 8846FE                   mov byte [bp-2], al
  3086                                  @@prs127:
  3087 00001278 8A46FE                   mov al, [bp-2]
  3088 0000127B 3C74                     cmp al, 116
  3089 0000127D 0F850900                 jne @@prs128
  3090 00001281 66B809000000             mov eax, 9
  3091 00001287 8846FE                   mov byte [bp-2], al
  3092                                  @@prs128:
  3093                                  @@prs126:
  3094                                  @@prs125:
  3095 0000128A 8A46FE                   mov al, byte [bp-2]
  3096 0000128D B400                     mov ah, 0
  3097 0000128F 50                       push ax
  3098 00001290 E807FF                   call prc
  3099 00001293 83C402                   add  sp, 2
  3100 00001296 FF4604                   inc  word [bp+4]
  3101                                  
  3102                                  ;-30 }
  3103                                  
  3104 00001299 E96CFF                   jmp @@prs120
  3105                                  @@prs121:
  3106                                  
  3107                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  3108 0000129C C9                       LEAVE
  3109 0000129D C3                       ret
  3110                                  ; ENDP
  3111                                  
  3112                                  printhex8a:  ; *** PROC ***
  3113                                  
  3114                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3115                                  
  3116                                  ;Function : printhex8a, Number of local variables: 2
  3117                                  ;   # type sign width line used address name   list of local variables
  3118                                  ;  200 var unsg word    31 NULL bp+4    c
  3119                                  ;  201 var unsg word    31 NULL bp-2    nib;
  3120 0000129E C8020000                 ENTER  2,0
  3121 000012A2 8B4604                   mov ax, [bp+4]
  3122 000012A5 C1E804                   shr ax, 4
  3123 000012A8 8946FE                   mov word [bp-2], ax
  3124 000012AB 8346FE30                 add  word [bp-2], 48
  3125 000012AF 8B46FE                   mov ax, [bp-2]
  3126 000012B2 83F839                   cmp ax, 57
  3127 000012B5 0F8E0400                 jle @@printhex8a129
  3128 000012B9 8346FE07                 add  word [bp-2], 7
  3129                                  @@printhex8a129:
  3130 000012BD FF76FE                   push word [bp-2]
  3131 000012C0 E8D7FE                   call prc
  3132 000012C3 83C402                   add  sp, 2
  3133                                  
  3134                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3135                                  
  3136 000012C6 8B4604                   mov ax, [bp+4]
  3137 000012C9 83E00F                   and ax, 15
  3138 000012CC 8946FE                   mov word [bp-2], ax
  3139 000012CF 8346FE30                 add  word [bp-2], 48
  3140 000012D3 8B46FE                   mov ax, [bp-2]
  3141 000012D6 83F839                   cmp ax, 57
  3142 000012D9 0F8E0400                 jle @@printhex8a130
  3143 000012DD 8346FE07                 add  word [bp-2], 7
  3144                                  @@printhex8a130:
  3145 000012E1 FF76FE                   push word [bp-2]
  3146 000012E4 E8B3FE                   call prc
  3147 000012E7 83C402                   add  sp, 2
  3148                                  
  3149                                  ;-34 }
  3150                                  
  3151                                  
  3152                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  3153 000012EA C9                       LEAVE
  3154 000012EB C3                       ret
  3155                                  ; ENDP
  3156                                  
  3157                                  printhex16:  ; *** PROC ***
  3158                                  
  3159                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3160                                  
  3161                                  ;Function : printhex16, Number of local variables: 2
  3162                                  ;   # type sign width line used address name   list of local variables
  3163                                  ;  200 var unsg word    35 NULL bp+4    i
  3164                                  ;  201 var unsg word    35 NULL bp-2    half;
  3165 000012EC C8020000                 ENTER  2,0
  3166 000012F0 8B4604                   mov ax, [bp+4]
  3167 000012F3 C1E808                   shr ax, 8
  3168 000012F6 8946FE                   mov word [bp-2], ax
  3169 000012F9 FF76FE                   push word [bp-2]
  3170 000012FC E89FFF                   call printhex8a
  3171 000012FF 83C402                   add  sp, 2
  3172 00001302 8B4604                   mov ax, [bp+4]
  3173 00001305 25FF00                   and ax, 255
  3174 00001308 8946FE                   mov word [bp-2], ax
  3175 0000130B FF76FE                   push word [bp-2]
  3176 0000130E E88DFF                   call printhex8a
  3177 00001311 83C402                   add  sp, 2
  3178                                  
  3179                                  ;-37 }
  3180                                  
  3181                                  
  3182                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  3183 00001314 C9                       LEAVE
  3184 00001315 C3                       ret
  3185                                  ; ENDP
  3186                                  
  3187                                  printIntU:  ; *** PROC ***
  3188                                  
  3189                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  3190                                  
  3191                                  ;Function : printIntU, Number of local variables: 2
  3192                                  ;   # type sign width line used address name   list of local variables
  3193                                  ;  200 var unsg word    38 NULL bp+4    n
  3194                                  ;  201 var unsg word    38 NULL bp-2    e;
  3195 00001316 C8020000                 ENTER  2,0
  3196 0000131A 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3197 0000131E 0F821700                 jb  @@printIntU131
  3198 00001322 8B4604                   mov ax, [bp+4]
  3199 00001325 BB0A00                   mov bx, 10
  3200 00001328 BA0000                   mov dx, 0
  3201 0000132B F7F3                     div bx
  3202 0000132D 8946FE                   mov word [bp-2], ax
  3203                                  
  3204                                  ;-40     printIntU(e); }
  3205                                  
  3206 00001330 FF76FE                   push word [bp-2]
  3207 00001333 E8E0FF                   call printIntU
  3208 00001336 83C402                   add  sp, 2
  3209                                  
  3210                                  ;-41     n = n % 10; //unsigned mod
  3211                                  
  3212                                  @@printIntU131:
  3213 00001339 8B4604                   mov ax, [bp+4]
  3214 0000133C BB0A00                   mov bx, 10
  3215 0000133F BA0000                   mov dx, 0
  3216 00001342 F7F3                     div bx
  3217 00001344 89D0                     mov ax, dx
  3218 00001346 894604                   mov word [bp+4], ax
  3219                                  
  3220                                  ;-42     n += '0'; prc(n);
  3221                                  
  3222 00001349 83460430                 add  word [bp+4], 48
  3223 0000134D FF7604                   push word [bp+4]
  3224 00001350 E847FE                   call prc
  3225 00001353 83C402                   add  sp, 2
  3226                                  
  3227                                  ;-43 }
  3228                                  
  3229                                  
  3230                                  ;-44 
  3231                                  
  3232                                  
  3233                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  3234 00001356 C9                       LEAVE
  3235 00001357 C3                       ret
  3236                                  ; ENDP
  3237                                  
  3238                                  error1:  ; *** PROC ***
  3239                                  ;Function : error1, Number of local variables: 1
  3240                                  ;   # type sign width line used address name   list of local variables
  3241                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  3242 00001358 C8000000                 ENTER  0,0
  3243 0000135C 66B801000000             mov eax, 1
  3244 00001362 A2[1800]                 mov byte [LIST], al
  3245 00001365 FF06[2500]               inc  word [ErrorCount]
  3246                                  
  3247                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  3248                                  
  3249 00001369 68[9113]                 push error1_0
  3250 0000136C E88CFE                   call prs
  3251 0000136F 83C402                   add  sp, 2
  3252 00001372 FF7604                   push word [bp+4]
  3253 00001375 E883FE                   call prs
  3254 00001378 83C402                   add  sp, 2
  3255                                  
  3256                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  3257                                  
  3258 0000137B 68[AC13]                 push error1_1
  3259 0000137E E87AFE                   call prs
  3260 00001381 83C402                   add  sp, 2
  3261 00001384 8D063075                 lea  ax, [Symbol]
  3262 00001388 50                       push ax
  3263 00001389 E86FFE                   call prs
  3264 0000138C 83C402                   add  sp, 2
  3265                                  
  3266                                  ;-48 int allowederror(){error1("not allowed here"); }
  3267 0000138F C9                       LEAVE
  3268 00001390 C3                       ret
  3269                                  ; ENDP
  3270 00001391 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3271 0000139A 6E657874206C696E65-
  3272 000013A3 204552524F523A2000 
  3273 000013AC 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3274 000013B5 2000               
  3275                                  
  3276                                  allowederror:  ; *** PROC ***
  3277 000013B7 68[C113]                 push allowederror_0
  3278 000013BA E89BFF                   call error1
  3279 000013BD 83C402                   add  sp, 2
  3280                                  
  3281                                  ;-49 int addrerror()   {error1("address expected");}
  3282                                  
  3283 000013C0 C3                       ret
  3284                                  ; ENDP
  3285 000013C1 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3286 000013CA 6564206865726500   
  3287                                  
  3288                                  addrerror:  ; *** PROC ***
  3289 000013D2 68[DC13]                 push addrerror_0
  3290 000013D5 E880FF                   call error1
  3291 000013D8 83C402                   add  sp, 2
  3292                                  
  3293                                  ;-50 int implerror()   {error1("not implemented");}
  3294                                  
  3295 000013DB C3                       ret
  3296                                  ; ENDP
  3297 000013DC 616464726573732065-     addrerror_0 db "address expected",0
  3298 000013E5 7870656374656400   
  3299                                  
  3300                                  implerror:  ; *** PROC ***
  3301 000013ED 68[F713]                 push implerror_0
  3302 000013F0 E865FF                   call error1
  3303 000013F3 83C402                   add  sp, 2
  3304                                  
  3305                                  ;-51 int indexerror()  {error1("invalid index register");}
  3306                                  
  3307 000013F6 C3                       ret
  3308                                  ; ENDP
  3309 000013F7 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3310 00001400 6D656E74656400     
  3311                                  
  3312                                  indexerror:  ; *** PROC ***
  3313 00001407 68[1114]                 push indexerror_0
  3314 0000140A E84BFF                   call error1
  3315 0000140D 83C402                   add  sp, 2
  3316                                  
  3317                                  ;-52 int invaloperror(){error1("invalid or no operands");}
  3318                                  
  3319 00001410 C3                       ret
  3320                                  ; ENDP
  3321 00001411 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3322 0000141A 6E6465782072656769-
  3323 00001423 7374657200         
  3324                                  
  3325                                  invaloperror:  ; *** PROC ***
  3326 00001428 68[3214]                 push invaloperror_0
  3327 0000142B E82AFF                   call error1
  3328 0000142E 83C402                   add  sp, 2
  3329                                  
  3330                                  ;-53 int numbererror() {error1("number expected");}
  3331                                  
  3332 00001431 C3                       ret
  3333                                  ; ENDP
  3334 00001432 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3335 0000143B 72206E6F206F706572-
  3336 00001444 616E647300         
  3337                                  
  3338                                  numbererror:  ; *** PROC ***
  3339 00001449 68[5314]                 push numbererror_0
  3340 0000144C E809FF                   call error1
  3341 0000144F 83C402                   add  sp, 2
  3342                                  
  3343                                  ;-54 int regmemerror() {error1("only register or memory allowed");}
  3344                                  
  3345 00001452 C3                       ret
  3346                                  ; ENDP
  3347 00001453 6E756D626572206578-     numbererror_0 db "number expected",0
  3348 0000145C 70656374656400     
  3349                                  
  3350                                  regmemerror:  ; *** PROC ***
  3351 00001463 68[6D14]                 push regmemerror_0
  3352 00001466 E8EFFE                   call error1
  3353 00001469 83C402                   add  sp, 2
  3354                                  
  3355                                  ;-55 int reg16error()  {error1("only reg16, no segreg allowed");}
  3356                                  
  3357 0000146C C3                       ret
  3358                                  ; ENDP
  3359 0000146D 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3360 00001476 73746572206F72206D-
  3361 0000147F 656D6F727920616C6C-
  3362 00001488 6F77656400         
  3363                                  
  3364                                  reg16error:  ; *** PROC ***
  3365 0000148D 68[9714]                 push reg16error_0
  3366 00001490 E8C5FE                   call error1
  3367 00001493 83C402                   add  sp, 2
  3368                                  
  3369                                  ;-56 int segregerror() {error1("segment register not allowed");}
  3370                                  
  3371 00001496 C3                       ret
  3372                                  ; ENDP
  3373 00001497 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3374 000014A0 362C206E6F20736567-
  3375 000014A9 72656720616C6C6F77-
  3376 000014B2 656400             
  3377                                  
  3378                                  segregerror:  ; *** PROC ***
  3379 000014B5 68[BF14]                 push segregerror_0
  3380 000014B8 E89DFE                   call error1
  3381 000014BB 83C402                   add  sp, 2
  3382                                  
  3383                                  ;-57 int syntaxerror() {error1("syntax");}
  3384                                  
  3385 000014BE C3                       ret
  3386                                  ; ENDP
  3387 000014BF 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3388 000014C8 65676973746572206E-
  3389 000014D1 6F7420616C6C6F7765-
  3390 000014DA 6400               
  3391                                  
  3392                                  syntaxerror:  ; *** PROC ***
  3393 000014DC 68[E614]                 push syntaxerror_0
  3394 000014DF E876FE                   call error1
  3395 000014E2 83C402                   add  sp, 2
  3396                                  
  3397                                  ;-58 
  3398                                  
  3399                                  
  3400                                  ;-59 int errorexit(char *s) { error1(s); end1(1);}
  3401                                  
  3402 000014E5 C3                       ret
  3403                                  ; ENDP
  3404 000014E6 73796E74617800          syntaxerror_0 db "syntax",0
  3405                                  
  3406                                  errorexit:  ; *** PROC ***
  3407                                  ;Function : errorexit, Number of local variables: 1
  3408                                  ;   # type sign width line used address name   list of local variables
  3409                                  ;  200 ptr sign byte    59 NULL bp+4    s;
  3410 000014ED C8000000                 ENTER  0,0
  3411 000014F1 FF7604                   push word [bp+4]
  3412 000014F4 E861FE                   call error1
  3413 000014F7 83C402                   add  sp, 2
  3414 000014FA 6A01                     push 1
  3415 000014FC E85003                   call end1
  3416 000014FF 83C402                   add  sp, 2
  3417                                  
  3418                                  ;-60 int addrexit(){errorexit("illegal address");}
  3419 00001502 C9                       LEAVE
  3420 00001503 C3                       ret
  3421                                  ; ENDP
  3422                                  
  3423                                  addrexit:  ; *** PROC ***
  3424 00001504 68[0E15]                 push addrexit_0
  3425 00001507 E8E3FF                   call errorexit
  3426 0000150A 83C402                   add  sp, 2
  3427                                  
  3428                                  ;-61 int internexit(){errorexit("intern compiler error");}
  3429                                  
  3430 0000150D C3                       ret
  3431                                  ; ENDP
  3432 0000150E 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3433 00001517 64647265737300     
  3434                                  
  3435                                  internexit:  ; *** PROC ***
  3436 0000151E 68[2815]                 push internexit_0
  3437 00001521 E8C9FF                   call errorexit
  3438 00001524 83C402                   add  sp, 2
  3439 00001527 C3                       ret
  3440                                  ; ENDP
  3441 00001528 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3442 00001531 6D70696C6572206572-
  3443 0000153A 726F7200           
  3444                                  ;Back to main program: AS.C
  3445                                  
  3446                                  ;-8 #include "MAIN.C"
  3447                                  
  3448                                  ;Use include file: MAIN.C
  3449                                  
  3450                                  ;-1 int main() {
  3451                                  
  3452                                  
  3453                                  main:  ; *** PROC ***
  3454                                  
  3455                                  ;-2   getarg(); 
  3456                                  
  3457 0000153E E80A00                   call getarg
  3458                                  
  3459                                  ;-3   parse(); 
  3460                                  
  3461 00001541 E803EF                   call parse
  3462                                  
  3463                                  ;-4   epilog(); 
  3464                                  
  3465 00001544 E85C02                   call epilog
  3466                                  
  3467                                  ;-5   end1();
  3468                                  
  3469 00001547 E80503                   call end1
  3470                                  
  3471                                  ;-6 }
  3472                                  
  3473                                  
  3474                                  ;-7 
  3475                                  
  3476                                  
  3477                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3478                                  
  3479 0000154A C3                       ret
  3480                                  ; ENDP
  3481                                  
  3482                                  getarg:  ; *** PROC ***
  3483                                  
  3484                                  ;-9   arglen1=*arglen;
  3485                                  
  3486                                  ;Function : getarg, Number of local variables: 3
  3487                                  ;   # type sign width line used address name   list of local variables
  3488                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3489                                  ;  201 var sign word     8 NULL bp-4    i
  3490                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3491 0000154B C8060000                 ENTER  6,0
  3492 0000154F 8B1E[4C00]               mov bx, [arglen]
  3493 00001553 8A07                     mov al, [bx]
  3494 00001555 B400                     mov ah, 0
  3495 00001557 8946FE                   mov word [bp-2], ax
  3496                                  
  3497                                  ;-10   if (arglen1==0) {
  3498                                  
  3499 0000155A 8B46FE                   mov ax, [bp-2]
  3500 0000155D 83F800                   cmp ax, 0
  3501 00001560 0F851C00                 jne @@getarg132
  3502                                  
  3503                                  ;-11     cputs(Version1);
  3504                                  
  3505 00001564 8D06[0300]               lea  ax, [Version1]
  3506 00001568 50                       push ax
  3507 00001569 E8B90A                   call cputs
  3508 0000156C 83C402                   add  sp, 2
  3509                                  
  3510                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3511                                  
  3512 0000156F 68[1017]                 push getarg_0
  3513 00001572 E8B00A                   call cputs
  3514 00001575 83C402                   add  sp, 2
  3515                                  
  3516                                  ;-13     exitR(3);
  3517                                  
  3518 00001578 6A03                     push 3
  3519 0000157A E8830C                   call exitR
  3520 0000157D 83C402                   add  sp, 2
  3521                                  
  3522                                  ;-14   }
  3523                                  
  3524                                  
  3525                                  ;-15   i=arglen1+129; 
  3526                                  
  3527                                  @@getarg132:
  3528 00001580 8B46FE                   mov ax, [bp-2]
  3529 00001583 058100                   add ax, 129
  3530 00001586 8946FC                   mov word [bp-4], ax
  3531                                  
  3532                                  ;-16   *i=0;  
  3533                                  
  3534 00001589 66B800000000             mov eax, 0
  3535 0000158F 8B5EFC                   mov  bx, [bp-4]
  3536 00001592 8907                     mov  [bx], ax
  3537                                  
  3538                                  ;-17   arglen1--;
  3539                                  
  3540 00001594 FF4EFE                   dec  word [bp-2]
  3541                                  
  3542                                  ;-18   toupper(argv);
  3543                                  
  3544 00001597 FF36[4E00]               push word [argv]
  3545 0000159B E8B50A                   call toupper
  3546 0000159E 83C402                   add  sp, 2
  3547                                  
  3548                                  ;-19   
  3549                                  
  3550                                  
  3551                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3552                                  
  3553 000015A1 FF36[4E00]               push word [argv]
  3554 000015A5 8D06ED75                 lea  ax, [namein]
  3555 000015A9 50                       push ax
  3556 000015AA E8140B                   call strcpy
  3557 000015AD 83C404                   add  sp, 4
  3558 000015B0 68[3517]                 push getarg_1
  3559 000015B3 8D06ED75                 lea  ax, [namein]
  3560 000015B7 50                       push ax
  3561 000015B8 E8C70B                   call strcat1
  3562 000015BB 83C404                   add  sp, 4
  3563                                  
  3564                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3565                                  
  3566 000015BE FF36[4E00]               push word [argv]
  3567 000015C2 8D063076                 lea  ax, [namelst]
  3568 000015C6 50                       push ax
  3569 000015C7 E8F70A                   call strcpy
  3570 000015CA 83C404                   add  sp, 4
  3571 000015CD 68[3817]                 push getarg_2
  3572 000015D0 8D063076                 lea  ax, [namelst]
  3573 000015D4 50                       push ax
  3574 000015D5 E8AA0B                   call strcat1
  3575 000015D8 83C404                   add  sp, 4
  3576                                  
  3577                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3578                                  
  3579 000015DB FF36[4E00]               push word [argv]
  3580 000015DF 8D067376                 lea  ax, [namebin]
  3581 000015E3 50                       push ax
  3582 000015E4 E8DA0A                   call strcpy
  3583 000015E7 83C404                   add  sp, 4
  3584 000015EA 68[3D17]                 push getarg_3
  3585 000015ED 8D067376                 lea  ax, [namebin]
  3586 000015F1 50                       push ax
  3587 000015F2 E88D0B                   call strcat1
  3588 000015F5 83C404                   add  sp, 4
  3589                                  
  3590                                  ;-23 
  3591                                  
  3592                                  
  3593                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3594                                  
  3595 000015F8 66B801000000             mov eax, 1
  3596 000015FE A2[1800]                 mov byte [LIST], al
  3597 00001601 66B800000000             mov eax, 0
  3598 00001607 A3[2300]                 mov word [DOS_ERR], ax
  3599 0000160A 66B800000000             mov eax, 0
  3600 00001610 A3[2A00]                 mov word [PC], ax
  3601 00001613 66B800000000             mov eax, 0
  3602 00001619 A3[2500]                 mov word [ErrorCount], ax
  3603                                  
  3604                                  ;-25   
  3605                                  
  3606                                  
  3607                                  ;-26   asm_fd=openR (namein);
  3608                                  
  3609 0000161C 8D06ED75                 lea  ax, [namein]
  3610 00001620 50                       push ax
  3611 00001621 E8830B                   call openR
  3612 00001624 83C402                   add  sp, 2
  3613 00001627 A3[1D00]                 mov word [asm_fd], ax
  3614                                  
  3615                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3616                                  
  3617 0000162A A1[2300]                 mov ax, [DOS_ERR]
  3618 0000162D 08C0                     or  al, al
  3619 0000162F 0F841C00                 je @@getarg133
  3620 00001633 68[4217]                 push getarg_4
  3621 00001636 E8EC09                   call cputs
  3622 00001639 83C402                   add  sp, 2
  3623 0000163C 8D06ED75                 lea  ax, [namein]
  3624 00001640 50                       push ax
  3625 00001641 E8E109                   call cputs
  3626 00001644 83C402                   add  sp, 2
  3627 00001647 6A01                     push 1
  3628 00001649 E8B40B                   call exitR
  3629 0000164C 83C402                   add  sp, 2
  3630                                  
  3631                                  ;-28   lst_fd=creatR(namelst);
  3632                                  
  3633                                  @@getarg133:
  3634 0000164F 8D063076                 lea  ax, [namelst]
  3635 00001653 50                       push ax
  3636 00001654 E85F0B                   call creatR
  3637 00001657 83C402                   add  sp, 2
  3638 0000165A A3[1F00]                 mov word [lst_fd], ax
  3639                                  
  3640                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3641                                  
  3642 0000165D A1[2300]                 mov ax, [DOS_ERR]
  3643 00001660 08C0                     or  al, al
  3644 00001662 0F841C00                 je @@getarg134
  3645 00001666 68[5817]                 push getarg_5
  3646 00001669 E8B909                   call cputs
  3647 0000166C 83C402                   add  sp, 2
  3648 0000166F 8D063076                 lea  ax, [namelst]
  3649 00001673 50                       push ax
  3650 00001674 E8AE09                   call cputs
  3651 00001677 83C402                   add  sp, 2
  3652 0000167A 6A02                     push 2
  3653 0000167C E8810B                   call exitR
  3654 0000167F 83C402                   add  sp, 2
  3655                                  
  3656                                  ;-30   bin_fd=creatR(namebin);
  3657                                  
  3658                                  @@getarg134:
  3659 00001682 8D067376                 lea  ax, [namebin]
  3660 00001686 50                       push ax
  3661 00001687 E82C0B                   call creatR
  3662 0000168A 83C402                   add  sp, 2
  3663 0000168D A3[2100]                 mov word [bin_fd], ax
  3664                                  
  3665                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3666                                  
  3667 00001690 A1[2300]                 mov ax, [DOS_ERR]
  3668 00001693 08C0                     or  al, al
  3669 00001695 0F841C00                 je @@getarg135
  3670 00001699 68[6F17]                 push getarg_6
  3671 0000169C E88609                   call cputs
  3672 0000169F 83C402                   add  sp, 2
  3673 000016A2 8D067376                 lea  ax, [namebin]
  3674 000016A6 50                       push ax
  3675 000016A7 E87B09                   call cputs
  3676 000016AA 83C402                   add  sp, 2
  3677 000016AD 6A02                     push 2
  3678 000016AF E84E0B                   call exitR
  3679 000016B2 83C402                   add  sp, 2
  3680                                  
  3681                                  ;-32   
  3682                                  
  3683                                  
  3684                                  ;-33   prs(";");prs(Version1);
  3685                                  
  3686                                  @@getarg135:
  3687 000016B5 68[8517]                 push getarg_7
  3688 000016B8 E840FB                   call prs
  3689 000016BB 83C402                   add  sp, 2
  3690 000016BE 8D06[0300]               lea  ax, [Version1]
  3691 000016C2 50                       push ax
  3692 000016C3 E835FB                   call prs
  3693 000016C6 83C402                   add  sp, 2
  3694                                  
  3695                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3696                                  
  3697 000016C9 68[8717]                 push getarg_8
  3698 000016CC E82CFB                   call prs
  3699 000016CF 83C402                   add  sp, 2
  3700 000016D2 8D06ED75                 lea  ax, [namein]
  3701 000016D6 50                       push ax
  3702 000016D7 E821FB                   call prs
  3703 000016DA 83C402                   add  sp, 2
  3704 000016DD 68[9217]                 push getarg_9
  3705 000016E0 E818FB                   call prs
  3706 000016E3 83C402                   add  sp, 2
  3707 000016E6 8D063076                 lea  ax, [namelst]
  3708 000016EA 50                       push ax
  3709 000016EB E80DFB                   call prs
  3710 000016EE 83C402                   add  sp, 2
  3711                                  
  3712                                  ;-35   prs(", "); prs(namebin);
  3713                                  
  3714 000016F1 68[9D17]                 push getarg_10
  3715 000016F4 E804FB                   call prs
  3716 000016F7 83C402                   add  sp, 2
  3717 000016FA 8D067376                 lea  ax, [namebin]
  3718 000016FE 50                       push ax
  3719 000016FF E8F9FA                   call prs
  3720 00001702 83C402                   add  sp, 2
  3721                                  
  3722                                  ;-36   prs("\n");
  3723                                  
  3724 00001705 68[A017]                 push getarg_11
  3725 00001708 E8F0FA                   call prs
  3726 0000170B 83C402                   add  sp, 2
  3727                                  
  3728                                  ;-37 }
  3729                                  
  3730                                  
  3731                                  ;-38 int epilog() { int i; int j; char c;
  3732 0000170E C9                       LEAVE
  3733 0000170F C3                       ret
  3734                                  ; ENDP
  3735 00001710 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3736 00001719 41532E434F4D206669-
  3737 00001722 6C656E616D65205B77-
  3738 0000172B 2F6F202E535D203A20-
  3739 00001734 00                 
  3740 00001735 2E5300                  getarg_1 db ".S",0
  3741 00001738 2E4C535400              getarg_2 db ".LST",0
  3742 0000173D 2E434F4D00              getarg_3 db ".COM",0
  3743 00001742 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3744 0000174B 6C65206D697373696E-
  3745 00001754 673A2000           
  3746 00001758 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3747 00001761 206E6F742063726561-
  3748 0000176A 74653A2000         
  3749 0000176F 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3750 00001778 6E6F74206372656174-
  3751 00001781 653A2000           
  3752 00001785 3B00                    getarg_7 db ";",0
  3753 00001787 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3754 00001790 2000               
  3755 00001792 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3756 0000179B 2000               
  3757 0000179D 2C2000                  getarg_10 db ", ",0
  3758 000017A0 5C6E00                  getarg_11 db "\n",0
  3759                                  
  3760                                  epilog:  ; *** PROC ***
  3761                                  
  3762                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3763                                  
  3764                                  ;Function : epilog, Number of local variables: 3
  3765                                  ;   # type sign width line used address name   list of local variables
  3766                                  ;  200 var sign word    38 NULL bp-2    i
  3767                                  ;  201 var sign word    38 NULL bp-4    j
  3768                                  ;  202 var sign byte    38 NULL bp-6    c;
  3769 000017A3 C8060000                 ENTER  6,0
  3770 000017A7 68[1D18]                 push epilog_0
  3771 000017AA E84EFA                   call prs
  3772 000017AD 83C402                   add  sp, 2
  3773 000017B0 FF36[2500]               push word [ErrorCount]
  3774 000017B4 E85FFB                   call printIntU
  3775 000017B7 83C402                   add  sp, 2
  3776                                  
  3777                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3778                                  
  3779 000017BA A1[2500]                 mov ax, [ErrorCount]
  3780 000017BD 08C0                     or  al, al
  3781 000017BF 0F840900                 je @@epilog136
  3782 000017C3 68[2D18]                 push epilog_1
  3783 000017C6 E832FA                   call prs
  3784 000017C9 83C402                   add  sp, 2
  3785                                  
  3786                                  ;-41 /*    
  3787                                  
  3788                                  
  3789                                  ;-42   prs(", Label & Var: ");
  3790                                  
  3791                                  
  3792                                  ;-43   if (LabelMaxIx) {
  3793                                  
  3794                                  
  3795                                  ;-44     i = 1;
  3796                                  
  3797                                  
  3798                                  ;-45     LabelNamePtr= &LabelNames;
  3799                                  
  3800                                  
  3801                                  ;-46     do {
  3802                                  
  3803                                  
  3804                                  ;-47       prs(LabelNamePtr); prc(' ');
  3805                                  
  3806                                  
  3807                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3808                                  
  3809                                  
  3810                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3811                                  
  3812                                  
  3813                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3814                                  
  3815                                  
  3816                                  ;-51       LabelNamePtr++;
  3817                                  
  3818                                  
  3819                                  ;-52       i++;
  3820                                  
  3821                                  
  3822                                  ;-53     } while (i <= LabelMaxIx);
  3823                                  
  3824                                  
  3825                                  ;-54   }
  3826                                  
  3827                                  
  3828                                  ;-55 */  
  3829                                  
  3830                                  
  3831                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3832                                  
  3833                                  @@epilog136:
  3834 000017CC 68[3B18]                 push epilog_2
  3835 000017CF E829FA                   call prs
  3836 000017D2 83C402                   add  sp, 2
  3837 000017D5 FF36[4A00]               push word [BinLen]
  3838 000017D9 E83AFB                   call printIntU
  3839 000017DC 83C402                   add  sp, 2
  3840 000017DF 68[4718]                 push epilog_3
  3841 000017E2 E816FA                   call prs
  3842 000017E5 83C402                   add  sp, 2
  3843                                  
  3844                                  ;-57 //  i=0;
  3845                                  
  3846                                  
  3847                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  3848                                  
  3849                                  
  3850                                  ;-59 //  } while (i < BinLen);
  3851                                  
  3852                                  
  3853                                  ;-60   i=0;
  3854                                  
  3855 000017E8 66B800000000             mov eax, 0
  3856 000017EE 8946FE                   mov word [bp-2], ax
  3857                                  
  3858                                  ;-61   do {
  3859                                  
  3860                                  @@epilog137:
  3861                                  
  3862                                  ;-62     c = FileBin[i];
  3863                                  
  3864 000017F1 8B5EFE                   mov bx, [bp-2]
  3865 000017F4 8A876B7B                 mov al, [FileBin + bx]
  3866 000017F8 8846FA                   mov byte [bp-6], al
  3867                                  
  3868                                  ;-63     fputcR(c, bin_fd);
  3869                                  
  3870 000017FB FF36[2100]               push word [bin_fd]
  3871 000017FF 8A46FA                   mov al, byte [bp-6]
  3872 00001802 B400                     mov ah, 0
  3873 00001804 50                       push ax
  3874 00001805 E8D509                   call fputcR
  3875 00001808 83C404                   add  sp, 4
  3876                                  
  3877                                  ;-64     i++;
  3878                                  
  3879 0000180B FF46FE                   inc  word [bp-2]
  3880                                  
  3881                                  ;-65   } while (i < BinLen);
  3882                                  
  3883 0000180E 8B46FE                   mov ax, [bp-2]
  3884 00001811 3B06[4A00]               cmp ax, [BinLen]
  3885 00001815 0F8D0200                 jge @@epilog138
  3886 00001819 EBD6                     jmp @@epilog137
  3887                                  @@epilog138:
  3888                                  
  3889                                  ;-66 }
  3890                                  
  3891                                  
  3892                                  ;-67 int end1(int n) {
  3893 0000181B C9                       LEAVE
  3894 0000181C C3                       ret
  3895                                  ; ENDP
  3896 0000181D 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  3897 00001826 726F72733A2000     
  3898 0000182D 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  3899 00001836 2A2A2A2000         
  3900 0000183B 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  3901 00001844 652000             
  3902 00001847 2062797465732E00        epilog_3 db " bytes.",0
  3903                                  
  3904                                  end1:  ; *** PROC ***
  3905                                  
  3906                                  ;-68   fcloseR(asm_fd);
  3907                                  
  3908                                  ;Function : end1, Number of local variables: 1
  3909                                  ;   # type sign width line used address name   list of local variables
  3910                                  ;  200 var sign word    67 NULL bp+4    n;
  3911 0000184F C8000000                 ENTER  0,0
  3912 00001853 FF36[1D00]               push word [asm_fd]
  3913 00001857 E89809                   call fcloseR
  3914 0000185A 83C402                   add  sp, 2
  3915                                  
  3916                                  ;-69   fcloseR(lst_fd);
  3917                                  
  3918 0000185D FF36[1F00]               push word [lst_fd]
  3919 00001861 E88E09                   call fcloseR
  3920 00001864 83C402                   add  sp, 2
  3921                                  
  3922                                  ;-70   fcloseR(bin_fd);
  3923                                  
  3924 00001867 FF36[2100]               push word [bin_fd]
  3925 0000186B E88409                   call fcloseR
  3926 0000186E 83C402                   add  sp, 2
  3927                                  
  3928                                  ;-71   exitR(n);
  3929                                  
  3930 00001871 FF7604                   push word [bp+4]
  3931 00001874 E88909                   call exitR
  3932 00001877 83C402                   add  sp, 2
  3933                                  
  3934                                  ;-72 }
  3935 0000187A C9                       LEAVE
  3936 0000187B C3                       ret
  3937                                  ; ENDP
  3938                                  ;Back to main program: AS.C
  3939                                  
  3940                                  ;-9 #include "GENCODE.C"
  3941                                  
  3942                                  ;Use include file: GENCODE.C
  3943                                  
  3944                                  ;-1 // generate code
  3945                                  
  3946                                  
  3947                                  ;-2 int getCodes() {
  3948                                  
  3949                                  
  3950                                  getCodes:  ; *** PROC ***
  3951                                  
  3952                                  ;-3   OpCodePtr ++; Code1 = *OpCodePtr;
  3953                                  
  3954 0000187C FF06[4100]               inc  word [OpCodePtr]
  3955 00001880 8B1E[4100]               mov bx, [OpCodePtr]
  3956 00001884 8A07                     mov al, [bx]
  3957 00001886 B400                     mov ah, 0
  3958 00001888 A2[3200]                 mov byte [Code1], al
  3959                                  
  3960                                  ;-4   OpCodePtr ++; Code2 = *OpCodePtr;
  3961                                  
  3962 0000188B FF06[4100]               inc  word [OpCodePtr]
  3963 0000188F 8B1E[4100]               mov bx, [OpCodePtr]
  3964 00001893 8A07                     mov al, [bx]
  3965 00001895 B400                     mov ah, 0
  3966 00001897 A2[3300]                 mov byte [Code2], al
  3967                                  
  3968                                  ;-5   OpCodePtr ++; Code3 = *OpCodePtr;
  3969                                  
  3970 0000189A FF06[4100]               inc  word [OpCodePtr]
  3971 0000189E 8B1E[4100]               mov bx, [OpCodePtr]
  3972 000018A2 8A07                     mov al, [bx]
  3973 000018A4 B400                     mov ah, 0
  3974 000018A6 A2[3400]                 mov byte [Code3], al
  3975                                  
  3976                                  ;-6 }
  3977                                  
  3978                                  
  3979                                  ;-7 int gen66h() {genCode8(0x66);
  3980                                  
  3981 000018A9 C3                       ret
  3982                                  ; ENDP
  3983                                  
  3984                                  gen66h:  ; *** PROC ***
  3985 000018AA 6A66                     push 102
  3986 000018AC E81F00                   call genCode8
  3987 000018AF 83C402                   add  sp, 2
  3988                                  
  3989                                  ;-8 }
  3990                                  
  3991                                  
  3992                                  ;-9 int genCode(char c, char d) {
  3993                                  
  3994 000018B2 C3                       ret
  3995                                  ; ENDP
  3996                                  
  3997                                  genCode:  ; *** PROC ***
  3998                                  
  3999                                  ;-10     c = c + d;
  4000                                  
  4001                                  ;Function : genCode, Number of local variables: 2
  4002                                  ;   # type sign width line used address name   list of local variables
  4003                                  ;  200 var sign byte     9 NULL bp+4    c
  4004                                  ;  201 var sign byte     9 NULL bp+6    d;
  4005 000018B3 C8000000                 ENTER  0,0
  4006 000018B7 8A4604                   mov al, [bp+4]
  4007 000018BA 024606                   add al, [bp+6]
  4008 000018BD 884604                   mov byte [bp+4], al
  4009                                  
  4010                                  ;-11     genCode8(c);
  4011                                  
  4012 000018C0 8A4604                   mov al, byte [bp+4]
  4013 000018C3 B400                     mov ah, 0
  4014 000018C5 50                       push ax
  4015 000018C6 E80500                   call genCode8
  4016 000018C9 83C402                   add  sp, 2
  4017                                  
  4018                                  ;-12 }
  4019                                  
  4020                                  
  4021                                  ;-13 int genCode8(char c) {
  4022 000018CC C9                       LEAVE
  4023 000018CD C3                       ret
  4024                                  ; ENDP
  4025                                  
  4026                                  genCode8:  ; *** PROC ***
  4027                                  
  4028                                  ;-14 //set: BinLen++, OpPrintIndex++
  4029                                  
  4030                                  
  4031                                  ;-15   FileBin[BinLen]=c;
  4032                                  
  4033                                  ;Function : genCode8, Number of local variables: 1
  4034                                  ;   # type sign width line used address name   list of local variables
  4035                                  ;  200 var sign byte    13 NULL bp+4    c;
  4036 000018CE C8000000                 ENTER  0,0
  4037 000018D2 8A4604                   mov al, [bp+4]
  4038 000018D5 8B1E[4A00]               mov bx, [BinLen]
  4039 000018D9 88876B7B                 mov [FileBin+bx], al
  4040                                  
  4041                                  ;-16   BinLen++;
  4042                                  
  4043 000018DD FF06[4A00]               inc  word [BinLen]
  4044                                  
  4045                                  ;-17   PC++;
  4046                                  
  4047 000018E1 FF06[2A00]               inc  word [PC]
  4048                                  
  4049                                  ;-18   if (BinLen >= FILEBINMAX) errorexit("COM file to long");
  4050                                  
  4051 000018E5 A1[4A00]                 mov ax, [BinLen]
  4052 000018E8 3DD007                   cmp ax, 2000 ;unsigned : 0
  4053 000018EB 0F820900                 jb  @@genCode8139
  4054 000018EF 68[1319]                 push genCode8_0
  4055 000018F2 E8F8FB                   call errorexit
  4056 000018F5 83C402                   add  sp, 2
  4057                                  
  4058                                  ;-19   if (OpPrintIndex < OPMAXLEN) {
  4059                                  
  4060                                  @@genCode8139:
  4061 000018F8 A1[3F00]                 mov ax, [OpPrintIndex]
  4062 000018FB 83F805                   cmp ax, 5
  4063 000018FE 0F8D0F00                 jge @@genCode8140
  4064                                  
  4065                                  ;-20     OpPos[OpPrintIndex]=c;
  4066                                  
  4067 00001902 8A4604                   mov al, [bp+4]
  4068 00001905 8B1E[3F00]               mov bx, [OpPrintIndex]
  4069 00001909 8887B676                 mov [OpPos+bx], al
  4070                                  
  4071                                  ;-21     OpPrintIndex++;
  4072                                  
  4073 0000190D FF06[3F00]               inc  word [OpPrintIndex]
  4074                                  
  4075                                  ;-22   }
  4076                                  
  4077                                  
  4078                                  ;-23 }
  4079                                  
  4080                                  @@genCode8140:
  4081                                  
  4082                                  ;-24 int genCode16(unsigned int i) {
  4083 00001911 C9                       LEAVE
  4084 00001912 C3                       ret
  4085                                  ; ENDP
  4086 00001913 434F4D2066696C6520-     genCode8_0 db "COM file to long",0
  4087 0000191C 746F206C6F6E6700   
  4088                                  
  4089                                  genCode16:  ; *** PROC ***
  4090                                  
  4091                                  ;-25   genCode8(i); i=i >> 8;
  4092                                  
  4093                                  ;Function : genCode16, Number of local variables: 1
  4094                                  ;   # type sign width line used address name   list of local variables
  4095                                  ;  200 var unsg word    24 NULL bp+4    i;
  4096 00001924 C8000000                 ENTER  0,0
  4097 00001928 FF7604                   push word [bp+4]
  4098 0000192B E8A0FF                   call genCode8
  4099 0000192E 83C402                   add  sp, 2
  4100 00001931 8B4604                   mov ax, [bp+4]
  4101 00001934 C1E808                   shr ax, 8
  4102 00001937 894604                   mov word [bp+4], ax
  4103                                  
  4104                                  ;-26   genCode8(i);
  4105                                  
  4106 0000193A FF7604                   push word [bp+4]
  4107 0000193D E88EFF                   call genCode8
  4108 00001940 83C402                   add  sp, 2
  4109                                  
  4110                                  ;-27 }
  4111                                  
  4112                                  
  4113                                  ;-28 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  4114 00001943 C9                       LEAVE
  4115 00001944 C3                       ret
  4116                                  ; ENDP
  4117                                  
  4118                                  writeEA:  ; *** PROC ***
  4119                                  
  4120                                  ;-29 //mod-byte: mode76, reg/opcode543, r/m210    
  4121                                  
  4122                                  
  4123                                  ;-30   char len;
  4124                                  
  4125                                  
  4126                                  ;-31   len=0;
  4127                                  
  4128                                  ;Function : writeEA, Number of local variables: 2
  4129                                  ;   # type sign width line used address name   list of local variables
  4130                                  ;  200 var sign byte    28 NULL bp+4    xxx
  4131                                  ;  201 var sign byte    30 NULL bp-2    len;
  4132 00001945 C8020000                 ENTER  2,0
  4133 00001949 66B800000000             mov eax, 0
  4134 0000194F 8846FE                   mov byte [bp-2], al
  4135                                  
  4136                                  ;-32   xxx = xxx << 3;//in reg/opcode field
  4137                                  
  4138 00001952 8A4604                   mov al, [bp+4]
  4139 00001955 C0E003                   shl al, 3
  4140 00001958 884604                   mov byte [bp+4], al
  4141                                  
  4142                                  ;-33 //  prs("\nxxx:"); printhex8a(xxx);
  4143                                  
  4144                                  
  4145                                  ;-34   if (Op1 ==   0) addrexit();
  4146                                  
  4147 0000195B A0[3000]                 mov al, [Op1]
  4148 0000195E 3C00                     cmp al, 0
  4149 00001960 0F850300                 jne @@writeEA141
  4150 00001964 E89DFB                   call addrexit
  4151                                  
  4152                                  ;-35   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  4153                                  
  4154                                  @@writeEA141:
  4155 00001967 A0[3000]                 mov al, [Op1]
  4156 0000196A 3C02                     cmp al, 2
  4157 0000196C 0F850E00                 jne @@writeEA142
  4158 00001970 804E04C0                 or  byte [bp+4], 192
  4159 00001974 8A4604                   mov al, [bp+4]
  4160 00001977 0206[3600]               add al, [RegNo]
  4161 0000197B 884604                   mov byte [bp+4], al
  4162                                  
  4163                                  ;-36   if (Op1 == ADR) error1("writeEA");           
  4164                                  
  4165                                  @@writeEA142:
  4166 0000197E A0[3000]                 mov al, [Op1]
  4167 00001981 3C03                     cmp al, 3
  4168 00001983 0F850900                 jne @@writeEA143
  4169 00001987 68[4C1A]                 push writeEA_0
  4170 0000198A E8CBF9                   call error1
  4171 0000198D 83C402                   add  sp, 2
  4172                                  
  4173                                  ;-37   if (Op1 == MEM) {
  4174                                  
  4175                                  @@writeEA143:
  4176 00001990 A0[3000]                 mov al, [Op1]
  4177 00001993 3C04                     cmp al, 4
  4178 00001995 0F857F00                 jne @@writeEA144
  4179                                  
  4180                                  ;-38     if (isDirect) {
  4181                                  
  4182 00001999 A0[3A00]                 mov al, [isDirect]
  4183 0000199C 08C0                     or  al, al
  4184 0000199E 0F841000                 je @@writeEA145
  4185                                  
  4186                                  ;-39         xxx |= 6;
  4187                                  
  4188 000019A2 804E0406                 or  byte [bp+4], 6
  4189                                  
  4190                                  ;-40         len = 2;
  4191                                  
  4192 000019A6 66B802000000             mov eax, 2
  4193 000019AC 8846FE                   mov byte [bp-2], al
  4194                                  
  4195                                  ;-41     }
  4196                                  
  4197                                  
  4198                                  ;-42     else { 
  4199                                  
  4200 000019AF E96600                   jmp @@writeEA146
  4201                                  @@writeEA145:
  4202                                  
  4203                                  ;-43       xxx = xxx + regindexbase;   
  4204                                  
  4205 000019B2 8A4604                   mov al, [bp+4]
  4206 000019B5 0206[3900]               add al, [regindexbase]
  4207 000019B9 884604                   mov byte [bp+4], al
  4208                                  
  4209                                  ;-44       if (regindexbase == 6) {//make [BP+00]
  4210                                  
  4211 000019BC A0[3900]                 mov al, [regindexbase]
  4212 000019BF 3C06                     cmp al, 6
  4213 000019C1 0F851700                 jne @@writeEA147
  4214                                  
  4215                                  ;-45         len=1;
  4216                                  
  4217 000019C5 66B801000000             mov eax, 1
  4218 000019CB 8846FE                   mov byte [bp-2], al
  4219                                  
  4220                                  ;-46         if (disp == 0) xxx |= 0x40;
  4221                                  
  4222 000019CE A1[3B00]                 mov ax, [disp]
  4223 000019D1 83F800                   cmp ax, 0
  4224 000019D4 0F850400                 jne @@writeEA148
  4225 000019D8 804E0440                 or  byte [bp+4], 64
  4226                                  
  4227                                  ;-47       }
  4228                                  
  4229                                  @@writeEA148:
  4230                                  
  4231                                  ;-48 
  4232                                  
  4233                                  
  4234                                  ;-49       if (disp) {
  4235                                  
  4236                                  @@writeEA147:
  4237 000019DC A1[3B00]                 mov ax, [disp]
  4238 000019DF 08C0                     or  al, al
  4239 000019E1 0F843300                 je @@writeEA149
  4240                                  
  4241                                  ;-50         ax = disp;
  4242                                  
  4243 000019E5 A1[3B00]                 mov  ax, [disp]
  4244                                  
  4245                                  ;-51         if(ax > 127) len=2;
  4246                                  
  4247 000019E8 83F87F                   cmp  ax, 127
  4248 000019EB 0F8E0C00                 jle @@writeEA150
  4249 000019EF 66B802000000             mov eax, 2
  4250 000019F5 8846FE                   mov byte [bp-2], al
  4251                                  
  4252                                  ;-52         else len=1;
  4253                                  
  4254 000019F8 E90900                   jmp @@writeEA151
  4255                                  @@writeEA150:
  4256 000019FB 66B801000000             mov eax, 1
  4257 00001A01 8846FE                   mov byte [bp-2], al
  4258                                  
  4259                                  ;-53         if (len == 1) xxx |= 0x40;
  4260                                  
  4261                                  @@writeEA151:
  4262 00001A04 8A46FE                   mov al, [bp-2]
  4263 00001A07 3C01                     cmp al, 1
  4264 00001A09 0F850700                 jne @@writeEA152
  4265 00001A0D 804E0440                 or  byte [bp+4], 64
  4266                                  
  4267                                  ;-54         else xxx |= 0x80;
  4268                                  
  4269 00001A11 E90400                   jmp @@writeEA153
  4270                                  @@writeEA152:
  4271 00001A14 804E0480                 or  byte [bp+4], 128
  4272                                  
  4273                                  ;-55       }
  4274                                  
  4275                                  @@writeEA153:
  4276                                  
  4277                                  ;-56     }
  4278                                  
  4279                                  @@writeEA149:
  4280                                  
  4281                                  ;-57   }
  4282                                  
  4283                                  @@writeEA146:
  4284                                  
  4285                                  ;-58   genCode8(xxx);// gen second byte
  4286                                  
  4287                                  @@writeEA144:
  4288 00001A18 8A4604                   mov al, byte [bp+4]
  4289 00001A1B B400                     mov ah, 0
  4290 00001A1D 50                       push ax
  4291 00001A1E E8ADFE                   call genCode8
  4292 00001A21 83C402                   add  sp, 2
  4293                                  
  4294                                  ;-59   if (len == 1) genCode8 (disp);
  4295                                  
  4296 00001A24 8A46FE                   mov al, [bp-2]
  4297 00001A27 3C01                     cmp al, 1
  4298 00001A29 0F850A00                 jne @@writeEA154
  4299 00001A2D FF36[3B00]               push word [disp]
  4300 00001A31 E89AFE                   call genCode8
  4301 00001A34 83C402                   add  sp, 2
  4302                                  
  4303                                  ;-60   if (len == 2) genCode16(disp);
  4304                                  
  4305                                  @@writeEA154:
  4306 00001A37 8A46FE                   mov al, [bp-2]
  4307 00001A3A 3C02                     cmp al, 2
  4308 00001A3C 0F850A00                 jne @@writeEA155
  4309 00001A40 FF36[3B00]               push word [disp]
  4310 00001A44 E8DDFE                   call genCode16
  4311 00001A47 83C402                   add  sp, 2
  4312                                  
  4313                                  ;-61 }
  4314                                  
  4315 00001A4A C9                      @@writeEA155: LEAVE
  4316 00001A4B C3                       ret
  4317                                  ; ENDP
  4318 00001A4C 7772697465454100        writeEA_0 db "writeEA",0
  4319                                  ;Back to main program: AS.C
  4320                                  
  4321                                  ;-10 
  4322                                  
  4323                                  
  4324                                  ;-11 int process() {
  4325                                  
  4326                                  
  4327                                  process:  ; *** PROC ***
  4328                                  
  4329                                  ;-12   char r1;//temp for 1. register
  4330                                  
  4331                                  
  4332                                  ;-13   getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4333                                  
  4334                                  ;Function : process, Number of local variables: 1
  4335                                  ;   # type sign width line used address name   list of local variables
  4336                                  ;  200 var sign byte    12 NULL bp-2    r1;
  4337 00001A54 C8020000                 ENTER  2,0
  4338 00001A58 E8D6EA                   call getTokeType
  4339                                  
  4340                                  ;-14   OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4341                                  
  4342 00001A5B E826EE                   call getCodeSize
  4343 00001A5E A2[3700]                 mov byte [OpSize], al
  4344                                  
  4345                                  ;-15   getCodes();//set: Code1, Code2, Code3
  4346                                  
  4347 00001A61 E818FE                   call getCodes
  4348                                  
  4349                                  ;-16 
  4350                                  
  4351                                  
  4352                                  ;-17   if (CodeType ==  1) {//1 byte opcode
  4353                                  
  4354 00001A64 A0[3100]                 mov al, [CodeType]
  4355 00001A67 3C01                     cmp al, 1
  4356 00001A69 0F850F00                 jne @@process156
  4357                                  
  4358                                  ;-18     genCode8(Code1);
  4359                                  
  4360 00001A6D A0[3200]                 mov al, byte [Code1]
  4361 00001A70 B400                     mov ah, 0
  4362 00001A72 50                       push ax
  4363 00001A73 E858FE                   call genCode8
  4364 00001A76 83C402                   add  sp, 2
  4365                                  
  4366                                  ;-19     return;
  4367                                  
  4368 00001A79 E95F01                   jmp @@retn
  4369                                  
  4370                                  ;-20   }
  4371                                  
  4372                                  
  4373                                  ;-21   
  4374                                  
  4375                                  
  4376                                  ;-22   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4377                                  
  4378                                  @@process156:
  4379 00001A7C A0[3100]                 mov al, [CodeType]
  4380 00001A7F 3C02                     cmp al, 2
  4381 00001A81 0F858A00                 jne @@process157
  4382                                  
  4383                                  ;-23     checkOp();
  4384                                  
  4385 00001A85 E87901                   call checkOp
  4386                                  
  4387                                  ;-24     if (Code2 <= 1) {//inc,dec
  4388                                  
  4389 00001A88 A0[3300]                 mov al, [Code2]
  4390 00001A8B 3C01                     cmp al, 1
  4391 00001A8D 0F8F4500                 jg  @@process158
  4392                                  
  4393                                  ;-25   	if (Op1 == REG) {
  4394                                  
  4395 00001A91 A0[3000]                 mov al, [Op1]
  4396 00001A94 3C02                     cmp al, 2
  4397 00001A96 0F853C00                 jne @@process159
  4398                                  
  4399                                  ;-26       if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
  4400                                  
  4401 00001A9A A0[3500]                 mov al, [RegType]
  4402 00001A9D 3C02                     cmp al, 2
  4403 00001A9F 0F851500                 jne @@process160
  4404 00001AA3 A0[3600]                 mov al, byte [RegNo]
  4405 00001AA6 B400                     mov ah, 0
  4406 00001AA8 50                       push ax
  4407 00001AA9 A0[3400]                 mov al, byte [Code3]
  4408 00001AAC B400                     mov ah, 0
  4409 00001AAE 50                       push ax
  4410 00001AAF E801FE                   call genCode
  4411 00001AB2 83C404                   add  sp, 4
  4412 00001AB5 E92301                   jmp @@retn
  4413                                  
  4414                                  ;-27       if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
  4415                                  
  4416                                  @@process160:
  4417 00001AB8 A0[3500]                 mov al, [RegType]
  4418 00001ABB 3C03                     cmp al, 3
  4419 00001ABD 0F851500                 jne @@process161
  4420 00001AC1 A0[3600]                 mov al, byte [RegNo]
  4421 00001AC4 B400                     mov ah, 0
  4422 00001AC6 50                       push ax
  4423 00001AC7 A0[3400]                 mov al, byte [Code3]
  4424 00001ACA B400                     mov ah, 0
  4425 00001ACC 50                       push ax
  4426 00001ACD E8E3FD                   call genCode
  4427 00001AD0 83C404                   add  sp, 4
  4428 00001AD3 E90501                   jmp @@retn
  4429                                  
  4430                                  ;-28       }
  4431                                  
  4432                                  @@process161:
  4433                                  
  4434                                  ;-29     }
  4435                                  
  4436                                  @@process159:
  4437                                  
  4438                                  ;-30     if (Code2 == 5) {//imul extension?
  4439                                  
  4440                                  @@process158:
  4441 00001AD6 A0[3300]                 mov al, [Code2]
  4442 00001AD9 3C05                     cmp al, 5
  4443 00001ADB 0F850F00                 jne @@process162
  4444                                  
  4445                                  ;-31       getTokeType();
  4446                                  
  4447 00001ADF E84FEA                   call getTokeType
  4448                                  
  4449                                  ;-32       if (TokeType) implerror();
  4450                                  
  4451 00001AE2 A0[2F00]                 mov al, [TokeType]
  4452 00001AE5 08C0                     or  al, al
  4453 00001AE7 0F840300                 je @@process163
  4454 00001AEB E8FFF8                   call implerror
  4455                                  
  4456                                  ;-33     }
  4457                                  
  4458                                  @@process163:
  4459                                  
  4460                                  ;-34     genCode(Code1, wflag);
  4461                                  
  4462                                  @@process162:
  4463 00001AEE A0[3800]                 mov al, byte [wflag]
  4464 00001AF1 B400                     mov ah, 0
  4465 00001AF3 50                       push ax
  4466 00001AF4 A0[3200]                 mov al, byte [Code1]
  4467 00001AF7 B400                     mov ah, 0
  4468 00001AF9 50                       push ax
  4469 00001AFA E8B6FD                   call genCode
  4470 00001AFD 83C404                   add  sp, 4
  4471                                  
  4472                                  ;-35     writeEA(Code2);
  4473                                  
  4474 00001B00 A0[3300]                 mov al, byte [Code2]
  4475 00001B03 B400                     mov ah, 0
  4476 00001B05 50                       push ax
  4477 00001B06 E83CFE                   call writeEA
  4478 00001B09 83C402                   add  sp, 2
  4479                                  
  4480                                  ;-36     return;
  4481                                  
  4482 00001B0C E9CC00                   jmp @@retn
  4483                                  
  4484                                  ;-37   }
  4485                                  
  4486                                  
  4487                                  ;-38   
  4488                                  
  4489                                  
  4490                                  ;-39   if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4491                                  
  4492                                  @@process157:
  4493 00001B0F A0[3100]                 mov al, [CodeType]
  4494 00001B12 3C03                     cmp al, 3
  4495 00001B14 0F855C00                 jne @@process164
  4496                                  
  4497                                  ;-40     checkOp();
  4498                                  
  4499 00001B18 E8E600                   call checkOp
  4500                                  
  4501                                  ;-41     if (RegType != WORD) reg16error();
  4502                                  
  4503 00001B1B A0[3500]                 mov al, [RegType]
  4504 00001B1E 3C02                     cmp al, 2
  4505 00001B20 0F840300                 je  @@process165
  4506 00001B24 E866F9                   call reg16error
  4507                                  
  4508                                  ;-42     r1=RegNo;
  4509                                  
  4510                                  @@process165:
  4511 00001B27 A0[3600]                 mov al, [RegNo]
  4512 00001B2A 8846FE                   mov byte [bp-2], al
  4513                                  
  4514                                  ;-43     need(',');    
  4515                                  
  4516 00001B2D 6A2C                     push 44
  4517 00001B2F E803EE                   call need
  4518 00001B32 83C402                   add  sp, 2
  4519                                  
  4520                                  ;-44     getOp();
  4521                                  
  4522 00001B35 E87F01                   call getOp
  4523                                  
  4524                                  ;-45     if (Op1 < ADR) addrerror(); 
  4525                                  
  4526 00001B38 A0[3000]                 mov al, [Op1]
  4527 00001B3B 3C03                     cmp al, 3
  4528 00001B3D 0F8D0300                 jge @@process166
  4529 00001B41 E88EF8                   call addrerror
  4530                                  
  4531                                  ;-46         
  4532                                  
  4533                                  
  4534                                  ;-47     genCode8(Code1);//les,lds,lea
  4535                                  
  4536                                  @@process166:
  4537 00001B44 A0[3200]                 mov al, byte [Code1]
  4538 00001B47 B400                     mov ah, 0
  4539 00001B49 50                       push ax
  4540 00001B4A E881FD                   call genCode8
  4541 00001B4D 83C402                   add  sp, 2
  4542                                  
  4543                                  ;-48     if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  4544                                  
  4545 00001B50 A0[3200]                 mov al, [Code1]
  4546 00001B53 3C0F                     cmp al, 15
  4547 00001B55 0F850C00                 jne @@process167
  4548 00001B59 A0[3300]                 mov al, byte [Code2]
  4549 00001B5C B400                     mov ah, 0
  4550 00001B5E 50                       push ax
  4551 00001B5F E86CFD                   call genCode8
  4552 00001B62 83C402                   add  sp, 2
  4553                                  
  4554                                  ;-49     writeEA(r1);           
  4555                                  
  4556                                  @@process167:
  4557 00001B65 8A46FE                   mov al, byte [bp-2]
  4558 00001B68 B400                     mov ah, 0
  4559 00001B6A 50                       push ax
  4560 00001B6B E8D7FD                   call writeEA
  4561 00001B6E 83C402                   add  sp, 2
  4562                                  
  4563                                  ;-50     return;
  4564                                  
  4565 00001B71 E96700                   jmp @@retn
  4566                                  
  4567                                  ;-51   }
  4568                                  
  4569                                  
  4570                                  ;-52  
  4571                                  
  4572                                  
  4573                                  ;-53   if (CodeType ==  8) {//ret,retf
  4574                                  
  4575                                  @@process164:
  4576 00001B74 A0[3100]                 mov al, [CodeType]
  4577 00001B77 3C08                     cmp al, 8
  4578 00001B79 0F853100                 jne @@process168
  4579                                  
  4580                                  ;-54     if (TokeType == DIGIT) {
  4581                                  
  4582 00001B7D A0[2F00]                 mov al, [TokeType]
  4583 00001B80 3C01                     cmp al, 1
  4584 00001B82 0F851900                 jne @@process169
  4585                                  
  4586                                  ;-55       genCode8(Code2);
  4587                                  
  4588 00001B86 A0[3300]                 mov al, byte [Code2]
  4589 00001B89 B400                     mov ah, 0
  4590 00001B8B 50                       push ax
  4591 00001B8C E83FFD                   call genCode8
  4592 00001B8F 83C402                   add  sp, 2
  4593                                  
  4594                                  ;-56       genCode16(SymbolInt);
  4595                                  
  4596 00001B92 FF36[1900]               push word [SymbolInt]
  4597 00001B96 E88BFD                   call genCode16
  4598 00001B99 83C402                   add  sp, 2
  4599                                  
  4600                                  ;-57       return;
  4601                                  
  4602 00001B9C E93C00                   jmp @@retn
  4603                                  
  4604                                  ;-58     }
  4605                                  
  4606                                  
  4607                                  ;-59     genCode8(Code1); 
  4608                                  
  4609                                  @@process169:
  4610 00001B9F A0[3200]                 mov al, byte [Code1]
  4611 00001BA2 B400                     mov ah, 0
  4612 00001BA4 50                       push ax
  4613 00001BA5 E826FD                   call genCode8
  4614 00001BA8 83C402                   add  sp, 2
  4615                                  
  4616                                  ;-60     return;
  4617                                  
  4618 00001BAB E92D00                   jmp @@retn
  4619                                  
  4620                                  ;-61   }
  4621                                  
  4622                                  
  4623                                  ;-62 
  4624                                  
  4625                                  
  4626                                  ;-63   if (CodeType==101) {// ORG nn
  4627                                  
  4628                                  @@process168:
  4629 00001BAE A0[3100]                 mov al, [CodeType]
  4630 00001BB1 3C65                     cmp al, 101
  4631 00001BB3 0F851B00                 jne @@process170
  4632                                  
  4633                                  ;-64     if (TokeType != DIGIT) error1("only digit allowed");
  4634                                  
  4635 00001BB7 A0[2F00]                 mov al, [TokeType]
  4636 00001BBA 3C01                     cmp al, 1
  4637 00001BBC 0F840900                 je  @@process171
  4638 00001BC0 68[DD1B]                 push process_0
  4639 00001BC3 E892F7                   call error1
  4640 00001BC6 83C402                   add  sp, 2
  4641                                  
  4642                                  ;-65     PC=SymbolInt;return;
  4643                                  
  4644                                  @@process171:
  4645 00001BC9 A1[1900]                 mov ax, [SymbolInt]
  4646 00001BCC A3[2A00]                 mov word [PC], ax
  4647 00001BCF E90900                   jmp @@retn
  4648                                  
  4649                                  ;-66   }
  4650                                  
  4651                                  
  4652                                  ;-67   error1("unknown CodeType");
  4653                                  
  4654                                  @@process170:
  4655 00001BD2 68[F01B]                 push process_1
  4656 00001BD5 E880F7                   call error1
  4657 00001BD8 83C402                   add  sp, 2
  4658                                  
  4659                                  ;-68 }
  4660                                  
  4661                                  
  4662                                  ;-69 
  4663                                  
  4664                                  
  4665                                  ;-70 int checkOp() {
  4666                                  
  4667 00001BDB C9                      @@retn: LEAVE
  4668 00001BDC C3                       ret
  4669                                  ; ENDP
  4670 00001BDD 6F6E6C792064696769-     process_0 db "only digit allowed",0
  4671 00001BE6 7420616C6C6F776564-
  4672 00001BEF 00                 
  4673 00001BF0 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  4674 00001BF9 6F64655479706500   
  4675                                  
  4676                                  checkOp:  ; *** PROC ***
  4677                                  
  4678                                  ;-71   getOp();
  4679                                  
  4680 00001C01 E8B300                   call getOp
  4681                                  
  4682                                  ;-72   if (Op1 == ADR) implerror();
  4683                                  
  4684 00001C04 A0[3000]                 mov al, [Op1]
  4685 00001C07 3C03                     cmp al, 3
  4686 00001C09 0F850300                 jne @@checkOp172
  4687 00001C0D E8DDF7                   call implerror
  4688                                  
  4689                                  ;-73   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  4690                                  
  4691                                  @@checkOp172:
  4692 00001C10 A0[3500]                 mov al, [RegType]
  4693 00001C13 3C04                     cmp al, 4
  4694 00001C15 0F850600                 jne @@checkOp173
  4695 00001C19 E899F8                   call segregerror
  4696 00001C1C E95300                   jmp @@retn
  4697                                  
  4698                                  ;-74   setwflag();
  4699                                  
  4700                                  @@checkOp173:
  4701 00001C1F E84801                   call setwflag
  4702                                  
  4703                                  ;-75   if (OpSize == 0) error1("no op size declared");
  4704                                  
  4705 00001C22 A0[3700]                 mov al, [OpSize]
  4706 00001C25 3C00                     cmp al, 0
  4707 00001C27 0F850900                 jne @@checkOp174
  4708 00001C2B 68[731C]                 push checkOp_0
  4709 00001C2E E827F7                   call error1
  4710 00001C31 83C402                   add  sp, 2
  4711                                  
  4712                                  ;-76   if (OpSize == RegType) return;
  4713                                  
  4714                                  @@checkOp174:
  4715 00001C34 A0[3700]                 mov al, [OpSize]
  4716 00001C37 3A06[3500]               cmp al, [RegType]
  4717 00001C3B 0F850300                 jne @@checkOp175
  4718 00001C3F E93000                   jmp @@retn
  4719                                  
  4720                                  ;-77   if (OpSize){if (Op1 == MEM) return;
  4721                                  
  4722                                  @@checkOp175:
  4723 00001C42 A0[3700]                 mov al, [OpSize]
  4724 00001C45 08C0                     or  al, al
  4725 00001C47 0F841500                 je @@checkOp176
  4726 00001C4B A0[3000]                 mov al, [Op1]
  4727 00001C4E 3C04                     cmp al, 4
  4728 00001C50 0F850300                 jne @@checkOp177
  4729 00001C54 E91B00                   jmp @@retn
  4730                                  
  4731                                  ;-78     error1("Conflict OpSize and RegSize"); }
  4732                                  
  4733                                  @@checkOp177:
  4734 00001C57 68[871C]                 push checkOp_1
  4735 00001C5A E8FBF6                   call error1
  4736 00001C5D 83C402                   add  sp, 2
  4737                                  
  4738                                  ;-79   if (RegType==0) error1("no register defined");
  4739                                  
  4740                                  @@checkOp176:
  4741 00001C60 A0[3500]                 mov al, [RegType]
  4742 00001C63 3C00                     cmp al, 0
  4743 00001C65 0F850900                 jne @@checkOp178
  4744 00001C69 68[A31C]                 push checkOp_2
  4745 00001C6C E8E9F6                   call error1
  4746 00001C6F 83C402                   add  sp, 2
  4747                                  
  4748                                  ;-80 }
  4749                                  
  4750                                  @@checkOp178:
  4751                                  
  4752                                  ;-81 /*        Op      = 0, IMM, REG, ADR, MEM
  4753                                  
  4754                                  
  4755                                  ;-82 IMM       imme    = 0, SymbolInt    
  4756                                  
  4757                                  
  4758                                  ;-83 REG     R RegNo   = 0 - 7
  4759                                  
  4760                                  
  4761                                  ;-84 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  4762                                  
  4763                                  
  4764                                  ;-85 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  4765                                  
  4766                                  
  4767                                  ;-86 MEM       regindexbase = 0 - 7
  4768                                  
  4769                                  
  4770                                  ;-87           OpSize  = 0, BYTE, WORD, DWORD (set wflag) */
  4771                                  
  4772                                  
  4773                                  ;-88 int getOp() {
  4774                                  
  4775                                  @@retn:
  4776 00001C72 C3                       ret
  4777                                  ; ENDP
  4778 00001C73 6E6F206F702073697A-     checkOp_0 db "no op size declared",0
  4779 00001C7C 65206465636C617265-
  4780 00001C85 6400               
  4781 00001C87 436F6E666C69637420-     checkOp_1 db "Conflict OpSize and RegSize",0
  4782 00001C90 4F7053697A6520616E-
  4783 00001C99 642052656753697A65-
  4784 00001CA2 00                 
  4785 00001CA3 6E6F20726567697374-     checkOp_2 db "no register defined",0
  4786 00001CAC 657220646566696E65-
  4787 00001CB5 6400               
  4788                                  
  4789                                  getOp:  ; *** PROC ***
  4790                                  
  4791                                  ;-89 //set: op1=0,IMM,REG,ADR,MEM
  4792                                  
  4793                                  
  4794                                  ;-90   disp=0; imme=0; regindexbase=0; isDirect=1;
  4795                                  
  4796 00001CB7 66B800000000             mov eax, 0
  4797 00001CBD A3[3B00]                 mov word [disp], ax
  4798 00001CC0 66B800000000             mov eax, 0
  4799 00001CC6 A3[3D00]                 mov word [imme], ax
  4800 00001CC9 66B800000000             mov eax, 0
  4801 00001CCF A2[3900]                 mov byte [regindexbase], al
  4802 00001CD2 66B801000000             mov eax, 1
  4803 00001CD8 A2[3A00]                 mov byte [isDirect], al
  4804                                  
  4805                                  ;-91 
  4806                                  
  4807                                  
  4808                                  ;-92   Op1=getOp1();
  4809                                  
  4810 00001CDB E8E700                   call getOp1
  4811 00001CDE A2[3000]                 mov byte [Op1], al
  4812                                  
  4813                                  ;-93   if (isToken('[')) {Op1 = MEM; getMEM();    return;}
  4814                                  
  4815 00001CE1 6A5B                     push 91
  4816 00001CE3 E821EC                   call isToken
  4817 00001CE6 83C402                   add  sp, 2
  4818 00001CE9 08C0                     or  al, al
  4819 00001CEB 0F840F00                 je @@getOp179
  4820 00001CEF 66B804000000             mov eax, 4
  4821 00001CF5 A2[3000]                 mov byte [Op1], al
  4822 00001CF8 E85001                   call getMEM
  4823 00001CFB E94F00                   jmp @@retn
  4824                                  
  4825                                  ;-94   if (Op1 == 0)     {invaloperror();         return;}
  4826                                  
  4827                                  @@getOp179:
  4828 00001CFE A0[3000]                 mov al, [Op1]
  4829 00001D01 3C00                     cmp al, 0
  4830 00001D03 0F850600                 jne @@getOp180
  4831 00001D07 E81EF7                   call invaloperror
  4832 00001D0A E94000                   jmp @@retn
  4833                                  
  4834                                  ;-95   if (Op1 == IMM)   {imme=SymbolInt;         return;}
  4835                                  
  4836                                  @@getOp180:
  4837 00001D0D A0[3000]                 mov al, [Op1]
  4838 00001D10 3C01                     cmp al, 1
  4839 00001D12 0F850900                 jne @@getOp181
  4840 00001D16 A1[1900]                 mov ax, [SymbolInt]
  4841 00001D19 A3[3D00]                 mov word [imme], ax
  4842 00001D1C E92E00                   jmp @@retn
  4843                                  
  4844                                  ;-96   if (Op1 == REG)                            return;
  4845                                  
  4846                                  @@getOp181:
  4847 00001D1F A0[3000]                 mov al, [Op1]
  4848 00001D22 3C02                     cmp al, 2
  4849 00001D24 0F850300                 jne @@getOp182
  4850 00001D28 E92200                   jmp @@retn
  4851                                  
  4852                                  ;-97   if (Op1 == ADR)   {disp=LabelAddr[LabelIx];return;}
  4853                                  
  4854                                  @@getOp182:
  4855 00001D2B A0[3000]                 mov al, [Op1]
  4856 00001D2E 3C03                     cmp al, 3
  4857 00001D30 0F851000                 jne @@getOp183
  4858 00001D34 8B1E[4800]               mov bx, [LabelIx]
  4859 00001D38 D1E3                     shl bx, 1
  4860 00001D3A 8B87A37A                 mov ax, [LabelAddr + bx]
  4861 00001D3E A3[3B00]                 mov word [disp], ax
  4862 00001D41 E90900                   jmp @@retn
  4863                                  
  4864                                  ;-98   error1("Name of operand expected #1");
  4865                                  
  4866                                  @@getOp183:
  4867 00001D44 68[4E1D]                 push getOp_0
  4868 00001D47 E80EF6                   call error1
  4869 00001D4A 83C402                   add  sp, 2
  4870                                  
  4871                                  ;-99 }
  4872                                  
  4873                                  
  4874                                  ;-100 
  4875                                  
  4876                                  
  4877                                  ;-101 int setwflag() {//only Op1 (first operand)
  4878                                  
  4879                                  @@retn:
  4880 00001D4D C3                       ret
  4881                                  ; ENDP
  4882 00001D4E 4E616D65206F66206F-     getOp_0 db "Name of operand expected #1",0
  4883 00001D57 706572616E64206578-
  4884 00001D60 706563746564202331-
  4885 00001D69 00                 
  4886                                  
  4887                                  setwflag:  ; *** PROC ***
  4888                                  
  4889                                  ;-102   wflag=0;
  4890                                  
  4891 00001D6A 66B800000000             mov eax, 0
  4892 00001D70 A2[3800]                 mov byte [wflag], al
  4893                                  
  4894                                  ;-103   if (OpSize == 0) {//do not override OpSize
  4895                                  
  4896 00001D73 A0[3700]                 mov al, [OpSize]
  4897 00001D76 3C00                     cmp al, 0
  4898 00001D78 0F852100                 jne @@setwflag184
  4899                                  
  4900                                  ;-104     if (Op1 == REG) {
  4901                                  
  4902 00001D7C A0[3000]                 mov al, [Op1]
  4903 00001D7F 3C02                     cmp al, 2
  4904 00001D81 0F851800                 jne @@setwflag185
  4905                                  
  4906                                  ;-105       OpSize=RegType;
  4907                                  
  4908 00001D85 A0[3500]                 mov al, [RegType]
  4909 00001D88 A2[3700]                 mov byte [OpSize], al
  4910                                  
  4911                                  ;-106       if (RegType == SEGREG) OpSize=WORD;
  4912                                  
  4913 00001D8B A0[3500]                 mov al, [RegType]
  4914 00001D8E 3C04                     cmp al, 4
  4915 00001D90 0F850900                 jne @@setwflag186
  4916 00001D94 66B802000000             mov eax, 2
  4917 00001D9A A2[3700]                 mov byte [OpSize], al
  4918                                  
  4919                                  ;-107     }
  4920                                  
  4921                                  @@setwflag186:
  4922                                  
  4923                                  ;-108   }
  4924                                  
  4925                                  @@setwflag185:
  4926                                  
  4927                                  ;-109   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  4928                                  
  4929                                  @@setwflag184:
  4930 00001D9D A0[3700]                 mov al, [OpSize]
  4931 00001DA0 3C03                     cmp al, 3
  4932 00001DA2 0F850C00                 jne @@setwflag187
  4933 00001DA6 E801FB                   call gen66h
  4934 00001DA9 66B801000000             mov eax, 1
  4935 00001DAF A2[3800]                 mov byte [wflag], al
  4936                                  
  4937                                  ;-110   if (OpSize  ==  WORD) wflag=1;
  4938                                  
  4939                                  @@setwflag187:
  4940 00001DB2 A0[3700]                 mov al, [OpSize]
  4941 00001DB5 3C02                     cmp al, 2
  4942 00001DB7 0F850900                 jne @@setwflag188
  4943 00001DBB 66B801000000             mov eax, 1
  4944 00001DC1 A2[3800]                 mov byte [wflag], al
  4945                                  
  4946                                  ;-111 }
  4947                                  
  4948                                  @@setwflag188:
  4949                                  
  4950                                  ;-112 
  4951                                  
  4952                                  
  4953                                  ;-113 int getOp1() {//scan for a single operand
  4954                                  
  4955 00001DC4 C3                       ret
  4956                                  ; ENDP
  4957                                  
  4958                                  getOp1:  ; *** PROC ***
  4959                                  
  4960                                  ;-114 //return:0, IMM, REG, ADR (not MEM)
  4961                                  
  4962                                  
  4963                                  ;-115 //set   :RegType, RegNo by testReg
  4964                                  
  4965                                  
  4966                                  ;-116 //set   :LabelIx by searchLabel
  4967                                  
  4968                                  
  4969                                  ;-117   if (TokeType == 0)      return 0;
  4970                                  
  4971 00001DC5 A0[2F00]                 mov al, [TokeType]
  4972 00001DC8 3C00                     cmp al, 0
  4973 00001DCA 0F850900                 jne @@getOp1189
  4974 00001DCE 66B800000000             mov eax, 0
  4975 00001DD4 E96000                   jmp @@retn
  4976                                  
  4977                                  ;-118   if (TokeType == DIGIT)  return IMM;
  4978                                  
  4979                                  @@getOp1189:
  4980 00001DD7 A0[2F00]                 mov al, [TokeType]
  4981 00001DDA 3C01                     cmp al, 1
  4982 00001DDC 0F850900                 jne @@getOp1190
  4983 00001DE0 66B801000000             mov eax, 1
  4984 00001DE6 E94E00                   jmp @@retn
  4985                                  
  4986                                  ;-119   if (TokeType == ALNUME) {
  4987                                  
  4988                                  @@getOp1190:
  4989 00001DE9 A0[2F00]                 mov al, [TokeType]
  4990 00001DEC 3C03                     cmp al, 3
  4991 00001DEE 0F853C00                 jne @@getOp1191
  4992                                  
  4993                                  ;-120     RegNo=testReg();
  4994                                  
  4995 00001DF2 E8BCEE                   call testReg
  4996 00001DF5 A2[3600]                 mov byte [RegNo], al
  4997                                  
  4998                                  ;-121     if (RegType)          return REG;
  4999                                  
  5000 00001DF8 A0[3500]                 mov al, [RegType]
  5001 00001DFB 08C0                     or  al, al
  5002 00001DFD 0F840900                 je @@getOp1192
  5003 00001E01 66B802000000             mov eax, 2
  5004 00001E07 E92D00                   jmp @@retn
  5005                                  
  5006                                  ;-122     LabelIx=searchLabel();
  5007                                  
  5008                                  @@getOp1192:
  5009 00001E0A E865E8                   call searchLabel
  5010 00001E0D A3[4800]                 mov word [LabelIx], ax
  5011                                  
  5012                                  ;-123     if (LabelIx)          return ADR;
  5013                                  
  5014 00001E10 A1[4800]                 mov ax, [LabelIx]
  5015 00001E13 08C0                     or  al, al
  5016 00001E15 0F840C00                 je @@getOp1193
  5017 00001E19 66B803000000             mov eax, 3
  5018 00001E1F E91500                   jmp @@retn
  5019                                  
  5020                                  ;-124     else error1("variable not found"); 
  5021                                  
  5022 00001E22 E90900                   jmp @@getOp1194
  5023                                  @@getOp1193:
  5024 00001E25 68[381E]                 push getOp1_0
  5025 00001E28 E82DF5                   call error1
  5026 00001E2B 83C402                   add  sp, 2
  5027                                  
  5028                                  ;-125   }
  5029                                  
  5030                                  @@getOp1194:
  5031                                  
  5032                                  ;-126   return 0;
  5033                                  
  5034                                  @@getOp1191:
  5035 00001E2E 66B800000000             mov eax, 0
  5036 00001E34 E90000                   jmp @@retn
  5037                                  
  5038                                  ;-127 }
  5039                                  
  5040                                  
  5041                                  ;-128 
  5042                                  
  5043                                  
  5044                                  ;-129 int getMEM() {// e.g. [array+bp+si-4]
  5045                                  
  5046                                  @@retn:
  5047 00001E37 C3                       ret
  5048                                  ; ENDP
  5049 00001E38 7661726961626C6520-     getOp1_0 db "variable not found",0
  5050 00001E41 6E6F7420666F756E64-
  5051 00001E4A 00                 
  5052                                  
  5053                                  getMEM:  ; *** PROC ***
  5054                                  
  5055                                  ;-130 //set: disp, regindexbase, RegType
  5056                                  
  5057                                  
  5058                                  ;-131   char op2;
  5059                                  
  5060                                  
  5061                                  ;-132   disp=0; regindexbase=0; RegType=0;
  5062                                  
  5063                                  ;Function : getMEM, Number of local variables: 1
  5064                                  ;   # type sign width line used address name   list of local variables
  5065                                  ;  200 var sign byte   131 NULL bp-2    op2;
  5066 00001E4B C8020000                 ENTER  2,0
  5067 00001E4F 66B800000000             mov eax, 0
  5068 00001E55 A3[3B00]                 mov word [disp], ax
  5069 00001E58 66B800000000             mov eax, 0
  5070 00001E5E A2[3900]                 mov byte [regindexbase], al
  5071 00001E61 66B800000000             mov eax, 0
  5072 00001E67 A2[3500]                 mov byte [RegType], al
  5073                                  
  5074                                  ;-133   do {
  5075                                  
  5076                                  @@getMEM195:
  5077                                  
  5078                                  ;-134     getTokeType();
  5079                                  
  5080 00001E6A E8C4E6                   call getTokeType
  5081                                  
  5082                                  ;-135     op2=getOp1();
  5083                                  
  5084 00001E6D E855FF                   call getOp1
  5085 00001E70 8846FE                   mov byte [bp-2], al
  5086                                  
  5087                                  ;-136     if (op2 ==   0) syntaxerror();
  5088                                  
  5089 00001E73 8A46FE                   mov al, [bp-2]
  5090 00001E76 3C00                     cmp al, 0
  5091 00001E78 0F850300                 jne @@getMEM196
  5092 00001E7C E85DF6                   call syntaxerror
  5093                                  
  5094                                  ;-137     if (op2 == REG) {isDirect=0;
  5095                                  
  5096                                  @@getMEM196:
  5097 00001E7F 8A46FE                   mov al, [bp-2]
  5098 00001E82 3C02                     cmp al, 2
  5099 00001E84 0F851E00                 jne @@getMEM197
  5100 00001E88 66B800000000             mov eax, 0
  5101 00001E8E A2[3A00]                 mov byte [isDirect], al
  5102                                  
  5103                                  ;-138                       if (regindexbase) regindexbase=getIndReg2();
  5104                                  
  5105 00001E91 A0[3900]                 mov al, [regindexbase]
  5106 00001E94 08C0                     or  al, al
  5107 00001E96 0F840900                 je @@getMEM198
  5108 00001E9A E8F300                   call getIndReg2
  5109 00001E9D A2[3900]                 mov byte [regindexbase], al
  5110                                  
  5111                                  ;-139                       else getIndReg1();
  5112                                  
  5113 00001EA0 E90300                   jmp @@getMEM199
  5114                                  @@getMEM198:
  5115 00001EA3 E88900                   call getIndReg1
  5116                                  
  5117                                  ;-140                     }
  5118                                  
  5119                                  @@getMEM199:
  5120                                  
  5121                                  ;-141     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  5122                                  
  5123                                  @@getMEM197:
  5124 00001EA6 8A46FE                   mov al, [bp-2]
  5125 00001EA9 3C03                     cmp al, 3
  5126 00001EAB 0F851000                 jne @@getMEM200
  5127 00001EAF A1[3B00]                 mov ax, [disp]
  5128 00001EB2 8B1E[4800]               mov bx, [LabelIx]
  5129 00001EB6 D1E3                     shl bx, 1
  5130 00001EB8 0387A37A                 add ax, [LabelAddr + bx]
  5131 00001EBC A3[3B00]                 mov word [disp], ax
  5132                                  
  5133                                  ;-142     if (op2 == IMM) disp=disp+SymbolInt;
  5134                                  
  5135                                  @@getMEM200:
  5136 00001EBF 8A46FE                   mov al, [bp-2]
  5137 00001EC2 3C01                     cmp al, 1
  5138 00001EC4 0F850A00                 jne @@getMEM201
  5139 00001EC8 A1[3B00]                 mov ax, [disp]
  5140 00001ECB 0306[1900]               add ax, [SymbolInt]
  5141 00001ECF A3[3B00]                 mov word [disp], ax
  5142                                  
  5143                                  ;-143     if (isToken('-')) {
  5144                                  
  5145                                  @@getMEM201:
  5146 00001ED2 6A2D                     push 45
  5147 00001ED4 E830EA                   call isToken
  5148 00001ED7 83C402                   add  sp, 2
  5149 00001EDA 08C0                     or  al, al
  5150 00001EDC 0F841900                 je @@getMEM202
  5151                                  
  5152                                  ;-144       getTokeType();
  5153                                  
  5154 00001EE0 E84EE6                   call getTokeType
  5155                                  
  5156                                  ;-145       if (TokeType != DIGIT) numbererror();
  5157                                  
  5158 00001EE3 A0[2F00]                 mov al, [TokeType]
  5159 00001EE6 3C01                     cmp al, 1
  5160 00001EE8 0F840300                 je  @@getMEM203
  5161 00001EEC E85AF5                   call numbererror
  5162                                  
  5163                                  ;-146       disp = disp - SymbolInt;
  5164                                  
  5165                                  @@getMEM203:
  5166 00001EEF A1[3B00]                 mov ax, [disp]
  5167 00001EF2 2B06[1900]               sub ax, [SymbolInt]
  5168 00001EF6 A3[3B00]                 mov word [disp], ax
  5169                                  
  5170                                  ;-147     }
  5171                                  
  5172                                  
  5173                                  ;-148   } while (isToken('+'));
  5174                                  
  5175                                  @@getMEM202:
  5176 00001EF9 6A2B                     push 43
  5177 00001EFB E809EA                   call isToken
  5178 00001EFE 83C402                   add  sp, 2
  5179 00001F01 08C0                     or  al, al
  5180 00001F03 0F840300                 je @@getMEM204
  5181 00001F07 E960FF                   jmp @@getMEM195
  5182                                  @@getMEM204:
  5183                                  
  5184                                  ;-149   if (isToken(']') == 0) errorexit("] expected");
  5185                                  
  5186 00001F0A 6A5D                     push 93
  5187 00001F0C E8F8E9                   call isToken
  5188 00001F0F 83C402                   add  sp, 2
  5189 00001F12 83F800                   cmp ax, 0
  5190 00001F15 0F850900                 jne @@getMEM205
  5191 00001F19 68[241F]                 push getMEM_0
  5192 00001F1C E8CEF5                   call errorexit
  5193 00001F1F 83C402                   add  sp, 2
  5194                                  
  5195                                  ;-150 }
  5196                                  
  5197                                  @@getMEM205:
  5198                                  
  5199                                  ;-151 int getIndReg1() {
  5200 00001F22 C9                       LEAVE
  5201 00001F23 C3                       ret
  5202                                  ; ENDP
  5203 00001F24 5D2065787065637465-     getMEM_0 db "] expected",0
  5204 00001F2D 6400               
  5205                                  
  5206                                  getIndReg1:  ; *** PROC ***
  5207                                  
  5208                                  ;-152   if (RegType !=WORD) indexerror();
  5209                                  
  5210 00001F2F A0[3500]                 mov al, [RegType]
  5211 00001F32 3C02                     cmp al, 2
  5212 00001F34 0F840300                 je  @@getIndReg1206
  5213 00001F38 E8CCF4                   call indexerror
  5214                                  
  5215                                  ;-153   if (RegNo==3) regindexbase=7;//BX
  5216                                  
  5217                                  @@getIndReg1206:
  5218 00001F3B A0[3600]                 mov al, [RegNo]
  5219 00001F3E 3C03                     cmp al, 3
  5220 00001F40 0F850900                 jne @@getIndReg1207
  5221 00001F44 66B807000000             mov eax, 7
  5222 00001F4A A2[3900]                 mov byte [regindexbase], al
  5223                                  
  5224                                  ;-154   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5225                                  
  5226                                  @@getIndReg1207:
  5227 00001F4D A0[3600]                 mov al, [RegNo]
  5228 00001F50 3C05                     cmp al, 5
  5229 00001F52 0F850900                 jne @@getIndReg1208
  5230 00001F56 66B806000000             mov eax, 6
  5231 00001F5C A2[3900]                 mov byte [regindexbase], al
  5232                                  
  5233                                  ;-155   if (RegNo==7) regindexbase=5;//DI
  5234                                  
  5235                                  @@getIndReg1208:
  5236 00001F5F A0[3600]                 mov al, [RegNo]
  5237 00001F62 3C07                     cmp al, 7
  5238 00001F64 0F850900                 jne @@getIndReg1209
  5239 00001F68 66B805000000             mov eax, 5
  5240 00001F6E A2[3900]                 mov byte [regindexbase], al
  5241                                  
  5242                                  ;-156   if (RegNo==6) regindexbase=4;//SI
  5243                                  
  5244                                  @@getIndReg1209:
  5245 00001F71 A0[3600]                 mov al, [RegNo]
  5246 00001F74 3C06                     cmp al, 6
  5247 00001F76 0F850900                 jne @@getIndReg1210
  5248 00001F7A 66B804000000             mov eax, 4
  5249 00001F80 A2[3900]                 mov byte [regindexbase], al
  5250                                  
  5251                                  ;-157   if (regindexbase==0) indexerror();
  5252                                  
  5253                                  @@getIndReg1210:
  5254 00001F83 A0[3900]                 mov al, [regindexbase]
  5255 00001F86 3C00                     cmp al, 0
  5256 00001F88 0F850300                 jne @@getIndReg1211
  5257 00001F8C E878F4                   call indexerror
  5258                                  
  5259                                  ;-158 }
  5260                                  
  5261                                  @@getIndReg1211:
  5262                                  
  5263                                  ;-159 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5264                                  
  5265 00001F8F C3                       ret
  5266                                  ; ENDP
  5267                                  
  5268                                  getIndReg2:  ; *** PROC ***
  5269                                  ;Function : getIndReg2, Number of local variables: 1
  5270                                  ;   # type sign width line used address name   list of local variables
  5271                                  ;  200 var sign byte   159 NULL bp-2    m;
  5272 00001F90 C8020000                 ENTER  2,0
  5273 00001F94 66B804000000             mov eax, 4
  5274 00001F9A 8846FE                   mov byte [bp-2], al
  5275                                  
  5276                                  ;-160   if (RegType !=WORD) indexerror();
  5277                                  
  5278 00001F9D A0[3500]                 mov al, [RegType]
  5279 00001FA0 3C02                     cmp al, 2
  5280 00001FA2 0F840300                 je  @@getIndReg2212
  5281 00001FA6 E85EF4                   call indexerror
  5282                                  
  5283                                  ;-161   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5284                                  
  5285                                  @@getIndReg2212:
  5286 00001FA9 A0[3600]                 mov al, [RegNo]
  5287 00001FAC 3C07                     cmp al, 7
  5288 00001FAE 0F852700                 jne @@getIndReg2213
  5289 00001FB2 A0[3900]                 mov al, [regindexbase]
  5290 00001FB5 3C06                     cmp al, 6
  5291 00001FB7 0F850C00                 jne @@getIndReg2214
  5292 00001FBB 66B803000000             mov eax, 3
  5293 00001FC1 8846FE                   mov byte [bp-2], al
  5294                                  
  5295                                  ;-162            else if (regindexbase==7) m=1;//BX+DI
  5296                                  
  5297 00001FC4 E91200                   jmp @@getIndReg2215
  5298                                  @@getIndReg2214:
  5299 00001FC7 A0[3900]                 mov al, [regindexbase]
  5300 00001FCA 3C07                     cmp al, 7
  5301 00001FCC 0F850900                 jne @@getIndReg2216
  5302 00001FD0 66B801000000             mov eax, 1
  5303 00001FD6 8846FE                   mov byte [bp-2], al
  5304                                  
  5305                                  ;-163   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5306                                  
  5307                                  @@getIndReg2216:
  5308                                  @@getIndReg2215:
  5309                                  @@getIndReg2213:
  5310 00001FD9 A0[3600]                 mov al, [RegNo]
  5311 00001FDC 3C06                     cmp al, 6
  5312 00001FDE 0F852700                 jne @@getIndReg2217
  5313 00001FE2 A0[3900]                 mov al, [regindexbase]
  5314 00001FE5 3C06                     cmp al, 6
  5315 00001FE7 0F850C00                 jne @@getIndReg2218
  5316 00001FEB 66B802000000             mov eax, 2
  5317 00001FF1 8846FE                   mov byte [bp-2], al
  5318                                  
  5319                                  ;-164            else if (regindexbase==7) m=0;//BX+SI
  5320                                  
  5321 00001FF4 E91200                   jmp @@getIndReg2219
  5322                                  @@getIndReg2218:
  5323 00001FF7 A0[3900]                 mov al, [regindexbase]
  5324 00001FFA 3C07                     cmp al, 7
  5325 00001FFC 0F850900                 jne @@getIndReg2220
  5326 00002000 66B800000000             mov eax, 0
  5327 00002006 8846FE                   mov byte [bp-2], al
  5328                                  
  5329                                  ;-165   if (m > 3) indexerror();
  5330                                  
  5331                                  @@getIndReg2220:
  5332                                  @@getIndReg2219:
  5333                                  @@getIndReg2217:
  5334 00002009 8A46FE                   mov al, [bp-2]
  5335 0000200C 3C03                     cmp al, 3
  5336 0000200E 0F8E0300                 jle @@getIndReg2221
  5337 00002012 E8F2F3                   call indexerror
  5338                                  
  5339                                  ;-166   return m;
  5340                                  
  5341                                  @@getIndReg2221:
  5342 00002015 8A46FE                   mov al, [bp-2]
  5343 00002018 E90000                   jmp @@retn
  5344                                  
  5345                                  ;-167 }
  5346                                  
  5347 0000201B C9                      @@retn: LEAVE
  5348 0000201C C3                       ret
  5349                                  ; ENDP
  5350                                   
  5351                                  ; missing functions: 
  5352                                  ; digit
  5353                                  ; strcpy
  5354                                  ; eqstr
  5355                                  ; strlen
  5356                                  ; eqstr
  5357                                  ; eqstr
  5358                                  ; eqstr
  5359                                  ; eqstr
  5360                                  ; readRL
  5361                                  ; readRL
  5362                                  ; digit
  5363                                  ; digit
  5364                                  ; strcpy
  5365                                  ; toupper
  5366                                  ; strlen
  5367                                  ; strlen
  5368                                  ; eqstr
  5369                                  ; eqstr
  5370                                  ; eqstr
  5371                                  ; eqstr
  5372                                  ; eqstr
  5373                                  ; eqstr
  5374                                  ; eqstr
  5375                                  ; eqstr
  5376                                  ; eqstr
  5377                                  ; eqstr
  5378                                  ; eqstr
  5379                                  ; eqstr
  5380                                  ; eqstr
  5381                                  ; eqstr
  5382                                  ; eqstr
  5383                                  ; eqstr
  5384                                  ; eqstr
  5385                                  ; eqstr
  5386                                  ; eqstr
  5387                                  ; eqstr
  5388                                  ; eqstr
  5389                                  ; eqstr
  5390                                  ; eqstr
  5391                                  ; eqstr
  5392                                  ; eqstr
  5393                                  ; eqstr
  5394                                  ; eqstr
  5395                                  ; eqstr
  5396                                  ; eqstr
  5397                                  ; eqstr
  5398                                  ; writetty
  5399                                  ; writetty
  5400                                  ; fputcR
  5401                                  ; cputs
  5402                                  ; cputs
  5403                                  ; exitR
  5404                                  ; toupper
  5405                                  ; strcpy
  5406                                  ; strcat1
  5407                                  ; strcpy
  5408                                  ; strcat1
  5409                                  ; strcpy
  5410                                  ; strcat1
  5411                                  ; openR
  5412                                  ; cputs
  5413                                  ; cputs
  5414                                  ; exitR
  5415                                  ; creatR
  5416                                  ; cputs
  5417                                  ; cputs
  5418                                  ; exitR
  5419                                  ; creatR
  5420                                  ; cputs
  5421                                  ; cputs
  5422                                  ; exitR
  5423                                  ; fputcR
  5424                                  ; fcloseR
  5425                                  ; fcloseR
  5426                                  ; fcloseR
  5427                                  ; exitR
  5428                                  ; Number of unresolved CALLs :   76
  5429                                  ;use archive file: AR.C
  5430                                  
  5431                                  ;-168 // AR.C Archive
  5432                                  
  5433                                  ;Number of CALLs:    2 : writetty
  5434                                  
  5435                                  writetty:  ; *** PROC ***
  5436 0000201D B40E                     mov  ah, 14
  5437 0000201F BB0000                   mov  bx, 0
  5438 00002022 CD10                     int  16
  5439                                  
  5440                                  ;-169 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5441                                  
  5442 00002024 C3                       ret
  5443                                  ; ENDP
  5444                                  ;Number of CALLs:    8 : cputs
  5445                                  
  5446                                  cputs:  ; *** PROC ***
  5447                                  ;Function : cputs, Number of local variables: 2
  5448                                  ;   # type sign width line used address name   list of local variables
  5449                                  ;  200 ptr sign byte   169 NULL bp+4    s
  5450                                  ;  201 var sign byte   169 NULL bp-2    c;
  5451 00002025 C8020000                 ENTER  2,0
  5452                                  @@cputs222:
  5453 00002029 8B5E04                   mov bx, [bp+4]
  5454 0000202C 8A07                     mov al, [bx]
  5455 0000202E B400                     mov ah, 0
  5456 00002030 08C0                     or  al, al
  5457 00002032 0F841B00                 je @@cputs223
  5458 00002036 8B5E04                   mov bx, [bp+4]
  5459 00002039 8A07                     mov al, [bx]
  5460 0000203B B400                     mov ah, 0
  5461 0000203D 8846FE                   mov byte [bp-2], al
  5462 00002040 8A46FE                   mov al, byte [bp-2]
  5463 00002043 B400                     mov ah, 0
  5464 00002045 50                       push ax
  5465 00002046 E8C401                   call putch
  5466 00002049 83C402                   add  sp, 2
  5467 0000204C FF4604                   inc  word [bp+4]
  5468 0000204F EBD8                     jmp @@cputs222
  5469                                  @@cputs223:
  5470                                  
  5471                                  ;-170 int mkneg(int n) { n; __asm {neg ax} }
  5472 00002051 C9                       LEAVE
  5473 00002052 C3                       ret
  5474                                  ; ENDP
  5475                                  ;Number of CALLs:    2 : toupper
  5476                                  
  5477                                  toupper:  ; *** PROC ***
  5478                                  ;Function : toupper, Number of local variables: 1
  5479                                  ;   # type sign width line used address name   list of local variables
  5480                                  ;  200 ptr sign byte   170 NULL bp+4    s;
  5481 00002053 C8000000                 ENTER  0,0
  5482                                  @@toupper224:
  5483 00002057 8B5E04                   mov bx, [bp+4]
  5484 0000205A 8A07                     mov al, [bx]
  5485 0000205C B400                     mov ah, 0
  5486 0000205E 08C0                     or  al, al
  5487 00002060 0F843000                 je @@toupper225
  5488 00002064 8B5E04                   mov bx, [bp+4]
  5489 00002067 8A07                     mov al, [bx]
  5490 00002069 B400                     mov ah, 0
  5491 0000206B 83F861                   cmp ax, 97 ;unsigned : 1
  5492 0000206E 0F8C1D00                 jl  @@toupper226
  5493 00002072 8B5E04                   mov bx, [bp+4]
  5494 00002075 8A07                     mov al, [bx]
  5495 00002077 B400                     mov ah, 0
  5496 00002079 83F87A                   cmp ax, 122
  5497 0000207C 0F8F0F00                 jg  @@toupper227
  5498 00002080 8B5E04                   mov bx, [bp+4]
  5499 00002083 8A07                     mov al, [bx]
  5500 00002085 B400                     mov ah, 0
  5501 00002087 83E820                   sub ax, 32
  5502 0000208A 8B5E04                   mov  bx, [bp+4]
  5503 0000208D 8807                     mov  [bx], al
  5504                                  @@toupper227:
  5505                                  @@toupper226:
  5506 0000208F FF4604                   inc  word [bp+4]
  5507 00002092 EBC3                     jmp @@toupper224
  5508                                  @@toupper225:
  5509                                  
  5510                                  ;-171 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5511                                  
  5512                                  
  5513                                  ;-172 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5514 00002094 C9                       LEAVE
  5515 00002095 C3                       ret
  5516                                  ; ENDP
  5517                                  ;Number of CALLs:    3 : strlen
  5518                                  
  5519                                  strlen:  ; *** PROC ***
  5520                                  ;Function : strlen, Number of local variables: 2
  5521                                  ;   # type sign width line used address name   list of local variables
  5522                                  ;  200 ptr sign byte   172 NULL bp+4    s
  5523                                  ;  201 var sign word   172 NULL bp-2    c;
  5524 00002096 C8020000                 ENTER  2,0
  5525 0000209A 66B800000000             mov eax, 0
  5526 000020A0 8946FE                   mov word [bp-2], ax
  5527                                  @@strlen228:
  5528 000020A3 8B5E04                   mov bx, [bp+4]
  5529 000020A6 8A07                     mov al, [bx]
  5530 000020A8 B400                     mov ah, 0
  5531 000020AA 83F800                   cmp ax, 0
  5532 000020AD 0F840800                 je  @@strlen229
  5533 000020B1 FF4604                   inc  word [bp+4]
  5534 000020B4 FF46FE                   inc  word [bp-2]
  5535 000020B7 EBEA                     jmp @@strlen228
  5536                                  @@strlen229:
  5537 000020B9 8B46FE                   mov ax, [bp-2]
  5538 000020BC E90000                   jmp @@retn
  5539                                  
  5540                                  ;-173 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5541                                  
  5542 000020BF C9                      @@retn: LEAVE
  5543 000020C0 C3                       ret
  5544                                  ; ENDP
  5545                                  ;Number of CALLs:    5 : strcpy
  5546                                  
  5547                                  strcpy:  ; *** PROC ***
  5548                                  ;Function : strcpy, Number of local variables: 2
  5549                                  ;   # type sign width line used address name   list of local variables
  5550                                  ;  200 ptr sign byte   173 NULL bp+4    s
  5551                                  ;  201 ptr sign byte   173 NULL bp+6    t;
  5552 000020C1 C8000000                 ENTER  0,0
  5553                                  @@strcpy230:
  5554 000020C5 8B5E06                   mov bx, [bp+6]
  5555 000020C8 8A07                     mov al, [bx]
  5556 000020CA B400                     mov ah, 0
  5557 000020CC 8B5E04                   mov  bx, [bp+4]
  5558 000020CF 8807                     mov  [bx], al
  5559 000020D1 FF4604                   inc  word [bp+4]
  5560 000020D4 FF4606                   inc  word [bp+6]
  5561                                  
  5562                                  ;-174   while (*t!=0); *s=0; return s; }
  5563                                  
  5564 000020D7 8B5E06                   mov bx, [bp+6]
  5565 000020DA 8A07                     mov al, [bx]
  5566 000020DC B400                     mov ah, 0
  5567 000020DE 83F800                   cmp ax, 0
  5568 000020E1 0F840200                 je  @@strcpy231
  5569 000020E5 EBDE                     jmp @@strcpy230
  5570                                  @@strcpy231:
  5571 000020E7 66B800000000             mov eax, 0
  5572 000020ED 8B5E04                   mov  bx, [bp+4]
  5573 000020F0 8807                     mov  [bx], al
  5574 000020F2 8B4604                   mov ax, [bp+4]
  5575 000020F5 E90000                   jmp @@retn
  5576                                  
  5577                                  ;-175 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5578                                  
  5579 000020F8 C9                      @@retn: LEAVE
  5580 000020F9 C3                       ret
  5581                                  ; ENDP
  5582                                  ;Number of CALLs:    3 : digit
  5583                                  
  5584                                  digit:  ; *** PROC ***
  5585                                  ;Function : digit, Number of local variables: 1
  5586                                  ;   # type sign width line used address name   list of local variables
  5587                                  ;  200 var sign byte   175 NULL bp+4    c;
  5588 000020FA C8000000                 ENTER  0,0
  5589 000020FE 8A4604                   mov al, [bp+4]
  5590 00002101 3C30                     cmp al, 48
  5591 00002103 0F8D0900                 jge @@digit232
  5592 00002107 66B800000000             mov eax, 0
  5593 0000210D E91B00                   jmp @@retn
  5594                                  @@digit232:
  5595 00002110 8A4604                   mov al, [bp+4]
  5596 00002113 3C39                     cmp al, 57
  5597 00002115 0F8E0900                 jle @@digit233
  5598 00002119 66B800000000             mov eax, 0
  5599 0000211F E90900                   jmp @@retn
  5600                                  @@digit233:
  5601 00002122 66B801000000             mov eax, 1
  5602 00002128 E90000                   jmp @@retn
  5603                                  
  5604                                  ;-176 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5605                                  
  5606 0000212B C9                      @@retn: LEAVE
  5607 0000212C C3                       ret
  5608                                  ; ENDP
  5609                                  ;Number of CALLs:   35 : eqstr
  5610                                  
  5611                                  eqstr:  ; *** PROC ***
  5612                                  ;Function : eqstr, Number of local variables: 2
  5613                                  ;   # type sign width line used address name   list of local variables
  5614                                  ;  200 ptr sign byte   176 NULL bp+4    p
  5615                                  ;  201 ptr sign byte   176 NULL bp+6    q;
  5616 0000212D C8000000                 ENTER  0,0
  5617                                  @@eqstr234:
  5618 00002131 8B5E04                   mov bx, [bp+4]
  5619 00002134 8A07                     mov al, [bx]
  5620 00002136 B400                     mov ah, 0
  5621 00002138 08C0                     or  al, al
  5622 0000213A 0F842300                 je @@eqstr235
  5623                                  
  5624                                  ;-177     if (*p != *q) return 0; p++; q++; }
  5625                                  
  5626 0000213E 8B5E04                   mov bx, [bp+4]
  5627 00002141 8A07                     mov al, [bx]
  5628 00002143 B400                     mov ah, 0
  5629 00002145 8B5E06                   mov bx, [bp+6]
  5630 00002148 3A07                     cmp al, [bx]
  5631 0000214A B400                     mov ah, 0
  5632 0000214C 0F840900                 je  @@eqstr236
  5633 00002150 66B800000000             mov eax, 0
  5634 00002156 E92700                   jmp @@retn
  5635                                  @@eqstr236:
  5636 00002159 FF4604                   inc  word [bp+4]
  5637 0000215C FF4606                   inc  word [bp+6]
  5638                                  
  5639                                  ;-178     if(*q) return 0; return 1; }
  5640                                  
  5641 0000215F EBD0                     jmp @@eqstr234
  5642                                  @@eqstr235:
  5643 00002161 8B5E06                   mov bx, [bp+6]
  5644 00002164 8A07                     mov al, [bx]
  5645 00002166 B400                     mov ah, 0
  5646 00002168 08C0                     or  al, al
  5647 0000216A 0F840900                 je @@eqstr237
  5648 0000216E 66B800000000             mov eax, 0
  5649 00002174 E90900                   jmp @@retn
  5650                                  @@eqstr237:
  5651 00002177 66B801000000             mov eax, 1
  5652 0000217D E90000                   jmp @@retn
  5653                                  
  5654                                  ;-179 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5655                                  
  5656 00002180 C9                      @@retn: LEAVE
  5657 00002181 C3                       ret
  5658                                  ; ENDP
  5659                                  ;Number of CALLs:    3 : strcat1
  5660                                  
  5661                                  strcat1:  ; *** PROC ***
  5662                                  ;Function : strcat1, Number of local variables: 2
  5663                                  ;   # type sign width line used address name   list of local variables
  5664                                  ;  200 ptr sign byte   179 NULL bp+4    s
  5665                                  ;  201 ptr sign byte   179 NULL bp+6    t;
  5666 00002182 C8000000                 ENTER  0,0
  5667                                  @@strcat1238:
  5668 00002186 8B5E04                   mov bx, [bp+4]
  5669 00002189 8A07                     mov al, [bx]
  5670 0000218B B400                     mov ah, 0
  5671 0000218D 83F800                   cmp ax, 0
  5672 00002190 0F840500                 je  @@strcat1239
  5673 00002194 FF4604                   inc  word [bp+4]
  5674 00002197 EBED                     jmp @@strcat1238
  5675                                  @@strcat1239:
  5676 00002199 FF7606                   push word [bp+6]
  5677 0000219C FF7604                   push word [bp+4]
  5678 0000219F E81FFF                   call strcpy
  5679 000021A2 83C404                   add  sp, 4
  5680                                  
  5681                                  ;-180 int basename(char *s) { char *p; p=0;
  5682 000021A5 C9                       LEAVE
  5683 000021A6 C3                       ret
  5684                                  ; ENDP
  5685                                  ;Number of CALLs:    1 : openR
  5686                                  
  5687                                  openR:  ; *** PROC ***
  5688                                  ;Function : openR, Number of local variables: 1
  5689                                  ;   # type sign width line used address name   list of local variables
  5690                                  ;  200 ptr sign byte   180 NULL bp+4    s;
  5691 000021A7 C8000000                 ENTER  0,0
  5692 000021AB 8B5604                   mov  dx, [bp+4]
  5693 000021AE B8023D                   mov  ax, 15618
  5694 000021B1 E87200                   call DosInt
  5695                                  
  5696                                  ;-181 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5697 000021B4 C9                       LEAVE
  5698 000021B5 C3                       ret
  5699                                  ; ENDP
  5700                                  ;Number of CALLs:    2 : creatR
  5701                                  
  5702                                  creatR:  ; *** PROC ***
  5703                                  ;Function : creatR, Number of local variables: 1
  5704                                  ;   # type sign width line used address name   list of local variables
  5705                                  ;  200 ptr sign byte   181 NULL bp+4    s;
  5706 000021B6 C8000000                 ENTER  0,0
  5707 000021BA 8B5604                   mov  dx, [bp+4]
  5708 000021BD B90000                   mov  cx, 0
  5709 000021C0 B8003C                   mov  ax, 15360
  5710 000021C3 E86000                   call DosInt
  5711                                  
  5712                                  ;-182 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5713 000021C6 C9                       LEAVE
  5714 000021C7 C3                       ret
  5715                                  ; ENDP
  5716                                  ;Number of CALLs:    2 : readRL
  5717                                  
  5718                                  readRL:  ; *** PROC ***
  5719                                  ;Function : readRL, Number of local variables: 3
  5720                                  ;   # type sign width line used address name   list of local variables
  5721                                  ;  200 ptr sign byte   182 NULL bp+4    s
  5722                                  ;  201 var sign word   182 NULL bp+6    fd
  5723                                  ;  202 var sign word   182 NULL bp+8    len;
  5724 000021C8 C8000000                 ENTER  0,0
  5725 000021CC 8B5604                   mov  dx, [bp+4]
  5726 000021CF 8B4E08                   mov  cx, [bp+8]
  5727 000021D2 8B5E06                   mov  bx, [bp+6]
  5728 000021D5 B8003F                   mov  ax, 16128
  5729 000021D8 E84B00                   call DosInt
  5730                                  
  5731                                  ;-183 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5732 000021DB C9                       LEAVE
  5733 000021DC C3                       ret
  5734                                  ; ENDP
  5735                                  ;Number of CALLs:    2 : fputcR
  5736                                  
  5737                                  fputcR:  ; *** PROC ***
  5738                                  ;Function : fputcR, Number of local variables: 2
  5739                                  ;   # type sign width line used address name   list of local variables
  5740                                  ;  200 ptr sign byte   183 NULL bp+4    n
  5741                                  ;  201 var sign word   183 NULL bp+6    fd;
  5742 000021DD C8000000                 ENTER  0,0
  5743 000021E1 8D5604                  lea dx, [bp+4]
  5744                                  
  5745                                  ;-184   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5746                                  
  5747 000021E4 B90100                   mov  cx, 1
  5748 000021E7 8B5E06                   mov  bx, [bp+6]
  5749 000021EA B80040                   mov  ax, 16384
  5750 000021ED E83600                   call DosInt
  5751                                  
  5752                                  ;-185 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5753 000021F0 C9                       LEAVE
  5754 000021F1 C3                       ret
  5755                                  ; ENDP
  5756                                  ;Number of CALLs:    3 : fcloseR
  5757                                  
  5758                                  fcloseR:  ; *** PROC ***
  5759                                  ;Function : fcloseR, Number of local variables: 1
  5760                                  ;   # type sign width line used address name   list of local variables
  5761                                  ;  200 var sign word   185 NULL bp+4    fd;
  5762 000021F2 C8000000                 ENTER  0,0
  5763 000021F6 8B5E04                   mov  bx, [bp+4]
  5764 000021F9 B8003E                   mov  ax, 15872
  5765 000021FC CD21                     int  33
  5766                                  
  5767                                  ;-186 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5768 000021FE C9                       LEAVE
  5769 000021FF C3                       ret
  5770                                  ; ENDP
  5771                                  ;Number of CALLs:    5 : exitR
  5772                                  
  5773                                  exitR:  ; *** PROC ***
  5774                                  ;Function : exitR, Number of local variables: 1
  5775                                  ;   # type sign width line used address name   list of local variables
  5776                                  ;  200 var sign byte   186 NULL bp+4    c;
  5777 00002200 C8000000                 ENTER  0,0
  5778 00002204 B44C                     mov  ah, 76
  5779 00002206 8A4604                   mov  al, [bp+4]
  5780 00002209 CD21                     int  33
  5781                                  
  5782                                  ;-187 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5783 0000220B C9                       LEAVE
  5784 0000220C C3                       ret
  5785                                  ; ENDP
  5786                                  ;End of archive file. 
  5787                                   
  5788                                  ; missing functions: 
  5789                                  ; putch
  5790                                  ; DosInt
  5791                                  ; DosInt
  5792                                  ; DosInt
  5793                                  ; DosInt
  5794                                  ; Number of unresolved CALLs :    5
  5795                                  ;use archive file: AR.C
  5796                                  
  5797                                  ;-188 // AR.C Archive
  5798                                  
  5799                                  ;Number of CALLs:    1 : putch
  5800                                  
  5801                                  putch:  ; *** PROC ***
  5802                                  ;Function : putch, Number of local variables: 1
  5803                                  ;   # type sign width line used address name   list of local variables
  5804                                  ;  200 var sign byte   188 NULL bp+4    c;
  5805 0000220D C8000000                 ENTER  0,0
  5806 00002211 807E040A                cmp byte [bp+4], 10
  5807 00002215 0F850500                 jne @@putch240
  5808 00002219 B00D                     mov  al, 13
  5809 0000221B E8FFFD                   call writetty
  5810                                  @@putch240:
  5811 0000221E 8A4604                   mov  al, [bp+4]
  5812 00002221 E8F9FD                   call writetty
  5813                                  
  5814                                  ;-189 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5815 00002224 C9                       LEAVE
  5816 00002225 C3                       ret
  5817                                  ; ENDP
  5818                                  ;Number of CALLs:    4 : DosInt
  5819                                  
  5820                                  DosInt:  ; *** PROC ***
  5821 00002226 CD21                     int  33
  5822 00002228 7304                     jae short @@DosInt241
  5823 0000222A FF06[2300]               inc  word [DOS_ERR]
  5824                                  @@DosInt241:
  5825                                  
  5826                                  ;-190 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5827                                  
  5828 0000222E C3                       ret
  5829                                  ; ENDP
  5830                                  ;End of archive file. 
  5831                                   
  5832                                  ; missing functions:  All FUNCTIONs in place
  5833 0000222F E80000                  LastFunctionByt:db 0E8h, 0, 0
  5834 00002232 58                      pop ax
  5835 00002233 C3                      ret
  5836                                   
  5837                                  ;   # type sign width line used  address name   list of global variables
  5838                                  
  5839                                  ;    1 arr sign byte     1    2        0 Version1[20]
  5840                                  ;    2 var sign byte     1    3        0 LIST
  5841                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5842                                  ;    4 arr sign byte     3    8    30000 Symbol[31]
  5843                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5844                                  ;    6 var unsg word     5   12        0 SymbolInt
  5845                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5846                                  ;    8 arr sign byte     7    4    30062 InputBuf[127]
  5847                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  5848                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5849                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5850                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5851                                  ;   13 var sign word    12    4        0 asm_fd
  5852                                  ;   14 var sign word    13    3        0 lst_fd
  5853                                  ;   15 var sign word    14    3        0 bin_fd
  5854                                  ;   16 var sign word    15    6        0 DOS_ERR
  5855                                  ;   17 var sign word    16    4        0 ErrorCount
  5856                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5857                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5858                                  ;   20 var unsg word    20    5        0 PC
  5859                                  ;   21 var unsg word    21    2        0 PCStart
  5860                                  ;   22 var sign byte    22    3        0 isLabel
  5861                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5862                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5863                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5864                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5865                                  ;   27 var sign byte    27   21        0 TokeType
  5866                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5867                                  ;   29 def unsg byte    29    -        0 WORD=2
  5868                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5869                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5870                                  ;   32 def unsg byte    32    -        0 IMM=1
  5871                                  ;   33 def unsg byte    33    -        0 REG=2
  5872                                  ;   34 def unsg byte    34    -        0 ADR=3
  5873                                  ;   35 def unsg byte    35    -        0 MEM=4
  5874                                  ;   36 var sign byte    36   15        0 Op1
  5875                                  ;   37 var sign byte    37   12        0 CodeType
  5876                                  ;   38 var sign byte    38    6        0 Code1
  5877                                  ;   39 var sign byte    39    6        0 Code2
  5878                                  ;   40 var sign byte    40    3        0 Code3
  5879                                  ;   41 var sign byte    41   18        0 RegType
  5880                                  ;   42 var sign byte    42   11        0 RegNo
  5881                                  ;   43 var sign byte    43   10        0 OpSize
  5882                                  ;   44 var sign byte    44    4        0 wflag
  5883                                  ;   45 var sign byte    49   15        0 regindexbase
  5884                                  ;   46 var sign byte    50    3        0 isDirect
  5885                                  ;   47 var sign word    51   14        0 disp
  5886                                  ;   48 var sign word    52    2        0 imme
  5887                                  ;   49 def unsg byte    54    -        0 OPMAXLEN=5
  5888                                  ;   50 arr sign byte    55    2    30390 OpPos[5]
  5889                                  ;   51 var sign word    56    6        0 OpPrintIndex
  5890                                  ;   52 ptr sign byte    57   17        0 OpCodePtr
  5891                                  ;   53 var sign byte    58    2        0 PrintR
  5892                                  ;   54 def unsg byte    60    -        0 LABELNAMESMAX=969
  5893                                  ;   55 arr sign byte    61    3    30395 LabelNames[1000]
  5894                                  ;   56 ptr sign byte    62    5        0 LabelNamePtr
  5895                                  ;   57 def unsg byte    63    -        0 LABELADRMAX=100
  5896                                  ;   58 arr unsg word    64    3    31395 LabelAddr[100]
  5897                                  ;   59 var sign word    65    4        0 LabelMaxIx
  5898                                  ;   60 var sign word    66    4        0 LabelIx
  5899                                  ;   61 def unsg byte    68    -        0 FILEBINMAX=2000
  5900                                  ;   62 arr sign byte    69    2    31595 FileBin[2000]
  5901                                  ;   63 var unsg word    70    5        0 BinLen
  5902                                  ;   64 ptr sign byte    72    1        0 arglen
  5903                                  ;   65 ptr sign byte    73    4        0 argv
  5904                                  ;   66 var sign byte     1    1        0 I_START
  5905                                  ;   67 arr sign byte     4 NULL        0 I_PUSHA[9]
  5906                                  ;   68 arr sign byte     5 NULL        0 I_POPA[8]
  5907                                  ;   69 arr sign byte     6 NULL        0 I_NOP[7]
  5908                                  ;   70 arr sign byte     7 NULL        0 I_CBW[7]
  5909                                  ;   71 arr sign byte     8 NULL        0 I_CWDE[8]
  5910                                  ;   72 arr sign byte     9 NULL        0 I_CWD[7]
  5911                                  ;   73 arr sign byte    10 NULL        0 I_CDQ[7]
  5912                                  ;   74 arr sign byte    11 NULL        0 I_WAIT[8]
  5913                                  ;   75 arr sign byte    12 NULL        0 I_PUSHF[9]
  5914                                  ;   76 arr sign byte    13 NULL        0 I_POPF[8]
  5915                                  ;   77 arr sign byte    14 NULL        0 I_SAHF[8]
  5916                                  ;   78 arr sign byte    15 NULL        0 I_LAHF[8]
  5917                                  ;   79 arr sign byte    16 NULL        0 I_MOVSB[9]
  5918                                  ;   80 arr sign byte    17 NULL        0 I_MOVSW[9]
  5919                                  ;   81 arr sign byte    18 NULL        0 I_CMPSB[9]
  5920                                  ;   82 arr sign byte    19 NULL        0 I_CMPSW[9]
  5921                                  ;   83 arr sign byte    20 NULL        0 I_STOSB[9]
  5922                                  ;   84 arr sign byte    21 NULL        0 I_STOSW[9]
  5923                                  ;   85 arr sign byte    22 NULL        0 I_LODSB[9]
  5924                                  ;   86 arr sign byte    23 NULL        0 I_LODSW[9]
  5925                                  ;   87 arr sign byte    24 NULL        0 I_SCASB[9]
  5926                                  ;   88 arr sign byte    25 NULL        0 I_SCASW[9]
  5927                                  ;   89 arr sign byte    26 NULL        0 I_LEAVE[9]
  5928                                  ;   90 arr sign byte    27 NULL        0 I_IRET[8]
  5929                                  ;   91 arr sign byte    28 NULL        0 I_XLAT[8]
  5930                                  ;   92 arr sign byte    29 NULL        0 I_LOCK[8]
  5931                                  ;   93 arr sign byte    30 NULL        0 I_REPNE[9]
  5932                                  ;   94 arr sign byte    31 NULL        0 I_REPNZ[9]
  5933                                  ;   95 arr sign byte    32 NULL        0 I_REPE[8]
  5934                                  ;   96 arr sign byte    33 NULL        0 I_REPZ[8]
  5935                                  ;   97 arr sign byte    34 NULL        0 I_HLT[7]
  5936                                  ;   98 arr sign byte    35 NULL        0 I_CLC[7]
  5937                                  ;   99 arr sign byte    36 NULL        0 I_STC[7]
  5938                                  ;  100 arr sign byte    37 NULL        0 I_CLI[7]
  5939                                  ;  101 arr sign byte    38 NULL        0 I_STI[7]
  5940                                  ;  102 arr sign byte    39 NULL        0 I_CLD[7]
  5941                                  ;  103 arr sign byte    40 NULL        0 I_STD[7]
  5942                                  ;  104 arr sign byte    42 NULL        0 I_INC[9]
  5943                                  ;  105 arr sign byte    43 NULL        0 I_DEC[9]
  5944                                  ;  106 arr sign byte    44 NULL        0 I_NOT[8]
  5945                                  ;  107 arr sign byte    45 NULL        0 I_NEG[8]
  5946                                  ;  108 arr sign byte    46 NULL        0 I_MUL[8]
  5947                                  ;  109 arr sign byte    47 NULL        0 I_IMUL[9]
  5948                                  ;  110 arr sign byte    48 NULL        0 I_DIV[8]
  5949                                  ;  111 arr sign byte    49 NULL        0 I_IDIV[9]
  5950                                  ;  112 arr sign byte    51 NULL        0 I_LES[7]
  5951                                  ;  113 arr sign byte    52 NULL        0 I_LDS[7]
  5952                                  ;  114 arr sign byte    53 NULL        0 I_LEA[7]
  5953                                  ;  115 arr sign byte    54 NULL        0 I_LSS[8]
  5954                                  ;  116 arr sign byte    55 NULL        0 I_LFS[8]
  5955                                  ;  117 arr sign byte    56 NULL        0 I_LGS[8]
  5956                                  ;  118 arr sign byte    58 NULL        0 I_ADD[7]
  5957                                  ;  119 arr sign byte    59 NULL        0 I_OR[6]
  5958                                  ;  120 arr sign byte    60 NULL        0 I_ADC[7]
  5959                                  ;  121 arr sign byte    61 NULL        0 I_SBB[7]
  5960                                  ;  122 arr sign byte    62 NULL        0 I_AND[7]
  5961                                  ;  123 arr sign byte    63 NULL        0 I_SUB[7]
  5962                                  ;  124 arr sign byte    64 NULL        0 I_XOR[7]
  5963                                  ;  125 arr sign byte    65 NULL        0 I_CMP[7]
  5964                                  ;  126 arr sign byte    66 NULL        0 I_TEST[11]
  5965                                  ;  127 arr sign byte    68 NULL        0 I_MOV[6]
  5966                                  ;  128 arr sign byte    69 NULL        0 I_MOVSX[9]
  5967                                  ;  129 arr sign byte    70 NULL        0 I_MOVZX[9]
  5968                                  ;  130 arr sign byte    72 NULL        0 I_JO[6]
  5969                                  ;  131 arr sign byte    73 NULL        0 I_JNO[7]
  5970                                  ;  132 arr sign byte    74 NULL        0 I_JB[6]
  5971                                  ;  133 arr sign byte    75 NULL        0 I_JC[6]
  5972                                  ;  134 arr sign byte    76 NULL        0 I_JNB[7]
  5973                                  ;  135 arr sign byte    77 NULL        0 I_JAE[7]
  5974                                  ;  136 arr sign byte    78 NULL        0 I_JNC[7]
  5975                                  ;  137 arr sign byte    79 NULL        0 I_JE[6]
  5976                                  ;  138 arr sign byte    80 NULL        0 I_JZ[6]
  5977                                  ;  139 arr sign byte    81 NULL        0 I_JNE[7]
  5978                                  ;  140 arr sign byte    82 NULL        0 I_JNZ[7]
  5979                                  ;  141 arr sign byte    83 NULL        0 I_JBE[7]
  5980                                  ;  142 arr sign byte    84 NULL        0 I_JNA[7]
  5981                                  ;  143 arr sign byte    85 NULL        0 I_JA[6]
  5982                                  ;  144 arr sign byte    86 NULL        0 I_JS[6]
  5983                                  ;  145 arr sign byte    87 NULL        0 I_JNS[7]
  5984                                  ;  146 arr sign byte    88 NULL        0 I_JP[6]
  5985                                  ;  147 arr sign byte    89 NULL        0 I_JPE[7]
  5986                                  ;  148 arr sign byte    90 NULL        0 I_JNP[7]
  5987                                  ;  149 arr sign byte    91 NULL        0 I_JPO[7]
  5988                                  ;  150 arr sign byte    92 NULL        0 I_JL[6]
  5989                                  ;  151 arr sign byte    93 NULL        0 I_JNL[7]
  5990                                  ;  152 arr sign byte    94 NULL        0 I_JGE[7]
  5991                                  ;  153 arr sign byte    95 NULL        0 I_JLE[7]
  5992                                  ;  154 arr sign byte    96 NULL        0 I_JNG[7]
  5993                                  ;  155 arr sign byte    97 NULL        0 I_JG[6]
  5994                                  ;  156 arr sign byte    99 NULL        0 I_JMP[8]
  5995                                  ;  157 arr sign byte   100 NULL        0 I_CALL[9]
  5996                                  ;  158 arr sign byte   102 NULL        0 I_RET[8]
  5997                                  ;  159 arr sign byte   103 NULL        0 I_RETF[9]
  5998                                  ;  160 arr sign byte   105 NULL        0 I_PUSH[8]
  5999                                  ;  161 arr sign byte   106 NULL        0 I_POP[7]
  6000                                  ;  162 arr sign byte   108 NULL        0 I_ROL[7]
  6001                                  ;  163 arr sign byte   109 NULL        0 I_ROR[7]
  6002                                  ;  164 arr sign byte   110 NULL        0 I_RCL[7]
  6003                                  ;  165 arr sign byte   111 NULL        0 I_RCR[7]
  6004                                  ;  166 arr sign byte   112 NULL        0 I_SHL[7]
  6005                                  ;  167 arr sign byte   113 NULL        0 I_SAL[7]
  6006                                  ;  168 arr sign byte   114 NULL        0 I_SHR[7]
  6007                                  ;  169 arr sign byte   115 NULL        0 I_SAR[7]
  6008                                  ;  170 arr sign byte   117 NULL        0 I_INT[8]
  6009                                  ;  171 arr sign byte   118 NULL        0 I_INTO[8]
  6010                                  ;  172 arr sign byte   120 NULL        0 I_IN[7]
  6011                                  ;  173 arr sign byte   121 NULL        0 I_INSB[8]
  6012                                  ;  174 arr sign byte   122 NULL        0 I_INSW[8]
  6013                                  ;  175 arr sign byte   123 NULL        0 I_INSD[8]
  6014                                  ;  176 arr sign byte   124 NULL        0 I_OUT[8]
  6015                                  ;  177 arr sign byte   125 NULL        0 I_OUTSB[8]
  6016                                  ;  178 arr sign byte   126 NULL        0 I_OUTSW[8]
  6017                                  ;  179 arr sign byte   127 NULL        0 I_OUTSD[8]
  6018                                  ;  180 arr sign byte   129 NULL        0 I_XCHG[9]
  6019                                  ;  181 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6020                                  ;  182 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6021                                  ;  183 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6022                                  ;  184 arr sign byte   134 NULL        0 I_LOOPE[9]
  6023                                  ;  185 arr sign byte   135 NULL        0 I_LOOP[8]
  6024                                  ;  186 arr sign byte   136 NULL        0 I_JCXZ[8]
  6025                                  ;  187 arr sign byte   137 NULL        0 I_JECXZ[9]
  6026                                  ;  188 arr sign byte   139 NULL        0 I_ENTER[9]
  6027                                  ;  189 arr sign byte   141 NULL        0 I_ORG[6]
  6028                                  ;  190 arr sign byte   143 NULL        0 I_SECTION[10]
  6029                                  ;  191 arr sign byte   144 NULL        0 I_SEGMENT[10]
  6030                                  ;  192 arr sign byte   145 NULL        0 I_ABSOLUTE[11]
  6031                                  ;  193 arr sign byte   146 NULL        0 I_DB[5]
  6032                                  ;  194 arr sign byte   147 NULL        0 I_DW[5]
  6033                                  ;  195 arr sign byte   148 NULL        0 I_DD[5]
  6034                                  ;  196 arr sign byte   149 NULL        0 I_RESB[7]
  6035                                  ;  197 arr sign byte   150 NULL        0 I_RESW[7]
  6036                                  ;  198 arr sign byte   151 NULL        0 I_RESD[7]
  6037                                  ;  199 var sign byte   152 NULL        0 I_END
  6038                                  
  6039                                  
  6040                                  ;   # Calls Line Width  Name   list of functions
  6041                                  
  6042                                  ;    0    1    1 word   parse
  6043                                  ;    1   13   27 word   getTokeType
  6044                                  ;    2    2   36 word   storeLabel
  6045                                  ;    3    2   46 word   searchLabel
  6046                                  ;    4    1   57 word   getVariable
  6047                                  ;    5    2   86 word   lookCode
  6048                                  ;    6    1  101 word   getCodeSize
  6049                                  ;    7    8  108 word   isToken
  6050                                  ;    8    1  113 word   need
  6051                                  ;    9    1  120 word   skipRest
  6052                                  ;   10    1    1 word   getLine
  6053                                  ;   11    1   17 word   ifEOL
  6054                                  ;   12    3   24 word   skipBlank
  6055                                  ;   13    2   29 word   letterE
  6056                                  ;   14    1   39 word   alnumE
  6057                                  ;   15    1   44 word   getDigit
  6058                                  ;   16    1   56 word   getName
  6059                                  ;   17    1   75 word   testReg
  6060                                  ;   18    1    1 word   printLine
  6061                                  ;   19    8   19 word   prc
  6062                                  ;   20    1   23 word   prscomment
  6063                                  ;   21   21   26 word   prs
  6064                                  ;   22    3   31 word   printhex8a
  6065                                  ;   23    1   35 word   printhex16
  6066                                  ;   24    3   38 word   printIntU
  6067                                  ;   25   24   45 word   error1
  6068                                  ;   26 NULL   48 word   allowederror
  6069                                  ;   27    1   49 word   addrerror
  6070                                  ;   28    2   50 word   implerror
  6071                                  ;   29    4   51 word   indexerror
  6072                                  ;   30    1   52 word   invaloperror
  6073                                  ;   31    1   53 word   numbererror
  6074                                  ;   32 NULL   54 word   regmemerror
  6075                                  ;   33    1   55 word   reg16error
  6076                                  ;   34    1   56 word   segregerror
  6077                                  ;   35    1   57 word   syntaxerror
  6078                                  ;   36   12   59 word   errorexit
  6079                                  ;   37    1   60 word   addrexit
  6080                                  ;   38 NULL   61 word   internexit
  6081                                  ;   39 NULL    1 word   main
  6082                                  ;   40    1    8 word   getarg
  6083                                  ;   41    1   38 word   epilog
  6084                                  ;   42    2   67 word   end1
  6085                                  ;   43    1    2 word   getCodes
  6086                                  ;   44    1    7 word   gen66h
  6087                                  ;   45    3    9 word   genCode
  6088                                  ;   46   13   13 word   genCode8
  6089                                  ;   47    3   24 word   genCode16
  6090                                  ;   48    2   28 word   writeEA
  6091                                  ;   49    1   11 word   process
  6092                                  ;   50    2   70 word   checkOp
  6093                                  ;   51    2   88 word   getOp
  6094                                  ;   52    1  101 word   setwflag
  6095                                  ;   53    2  113 word   getOp1
  6096                                  ;   54    1  129 word   getMEM
  6097                                  ;   55    1  151 word   getIndReg1
  6098                                  ;   56    1  159 word   getIndReg2
  6099                                  ;   57    4  168 word   writetty
  6100                                  ;   58    8  169 word   cputs
  6101                                  ;   59    2  170 word   toupper
  6102                                  ;   60    3  172 word   strlen
  6103                                  ;   61    6  173 word   strcpy
  6104                                  ;   62    3  175 word   digit
  6105                                  ;   63   35  176 word   eqstr
  6106                                  ;   64    3  179 word   strcat1
  6107                                  ;   65    1  180 word   openR
  6108                                  ;   66    2  181 word   creatR
  6109                                  ;   67    2  182 word   readRL
  6110                                  ;   68    2  183 word   fputcR
  6111                                  ;   69    3  185 word   fcloseR
  6112                                  ;   70    5  186 word   exitR
  6113                                  ;   71    1  188 word   putch
  6114                                  ;   72    4  189 word   DosInt
  6115                                  ;   73 NULL  190 word   LastFunctionByt
  6116                                  
  6117                                  ;    #  addr name   list of CALLs
  6118                                  
  6119                                  ;    0  1411 getLine
  6120                                  ;    1  1419 getTokeType
  6121                                  ;    2  1431 storeLabel
  6122                                  ;    3  1442 getTokeType
  6123                                  ;    4  1454 lookCode
  6124                                  ;    5  1463 process
  6125                                  ;    6  1471 getVariable
  6126                                  ;    7  1483 skipRest
  6127                                  ;    8  1492 error1
  6128                                  ;    9  1499 error1
  6129                                  ;   10  1506 printLine
  6130                                  ;   11  1530 skipBlank
  6131                                  ;   12  1540 digit
  6132                                  ;   13  1546 getDigit
  6133                                  ;   14  1555 letterE
  6134                                  ;   15  1563 getName
  6135                                  ;   16  1584 searchLabel
  6136                                  ;   17  1596 error1
  6137                                  ;   18  1603 strcpy
  6138                                  ;   19  1610 errorexit
  6139                                  ;   20  1620 errorexit
  6140                                  ;   21  1650 eqstr
  6141                                  ;   22  1656 strlen
  6142                                  ;   23  1677 storeLabel
  6143                                  ;   24  1688 getTokeType
  6144                                  ;   25  1700 lookCode
  6145                                  ;   26  1709 errorexit
  6146                                  ;   27  1719 errorexit
  6147                                  ;   28  1729 getTokeType
  6148                                  ;   29  1741 genCode8
  6149                                  ;   30  1750 skipBlank
  6150                                  ;   31  1760 isToken
  6151                                  ;   32  1768 genCode8
  6152                                  ;   33  1777 isToken
  6153                                  ;   34  1785 getTokeType
  6154                                  ;   35  1797 genCode16
  6155                                  ;   36  1807 isToken
  6156                                  ;   37  1815 errorexit
  6157                                  ;   38  1834 eqstr
  6158                                  ;   39  1852 eqstr
  6159                                  ;   40  1858 getTokeType
  6160                                  ;   41  1870 eqstr
  6161                                  ;   42  1876 getTokeType
  6162                                  ;   43  1888 eqstr
  6163                                  ;   44  1894 getTokeType
  6164                                  ;   45  1916 skipBlank
  6165                                  ;   46  1933 isToken
  6166                                  ;   47  1941 error1
  6167                                  ;   48  1948 prs
  6168                                  ;   49  1952 prc
  6169                                  ;   50  1965 getTokeType
  6170                                  ;   51  1977 error1
  6171                                  ;   52  1994 readRL
  6172                                  ;   53  2001 errorexit
  6173                                  ;   54  2011 errorexit
  6174                                  ;   55  2021 ifEOL
  6175                                  ;   56  2035 readRL
  6176                                  ;   57  2071 digit
  6177                                  ;   58  2077 letterE
  6178                                  ;   59  2104 digit
  6179                                  ;   60  2124 alnumE
  6180                                  ;   61  2131 errorexit
  6181                                  ;   62  2141 strcpy
  6182                                  ;   63  2148 toupper
  6183                                  ;   64  2164 strlen
  6184                                  ;   65  2171 strlen
  6185                                  ;   66  2178 eqstr
  6186                                  ;   67  2184 eqstr
  6187                                  ;   68  2190 eqstr
  6188                                  ;   69  2196 eqstr
  6189                                  ;   70  2202 eqstr
  6190                                  ;   71  2208 eqstr
  6191                                  ;   72  2214 eqstr
  6192                                  ;   73  2220 eqstr
  6193                                  ;   74  2226 eqstr
  6194                                  ;   75  2232 eqstr
  6195                                  ;   76  2238 eqstr
  6196                                  ;   77  2244 eqstr
  6197                                  ;   78  2250 eqstr
  6198                                  ;   79  2256 eqstr
  6199                                  ;   80  2262 eqstr
  6200                                  ;   81  2268 eqstr
  6201                                  ;   82  2274 eqstr
  6202                                  ;   83  2280 eqstr
  6203                                  ;   84  2286 eqstr
  6204                                  ;   85  2292 eqstr
  6205                                  ;   86  2298 eqstr
  6206                                  ;   87  2304 eqstr
  6207                                  ;   88  2310 eqstr
  6208                                  ;   89  2316 eqstr
  6209                                  ;   90  2322 eqstr
  6210                                  ;   91  2328 eqstr
  6211                                  ;   92  2334 eqstr
  6212                                  ;   93  2340 eqstr
  6213                                  ;   94  2346 eqstr
  6214                                  ;   95  2352 eqstr
  6215                                  ;   96  2372 prs
  6216                                  ;   97  2376 printhex16
  6217                                  ;   98  2387 prs
  6218                                  ;   99  2391 prc
  6219                                  ;  100  2395 printhex8a
  6220                                  ;  101  2406 prc
  6221                                  ;  102  2410 prs
  6222                                  ;  103  2414 prscomment
  6223                                  ;  104  2431 writetty
  6224                                  ;  105  2440 writetty
  6225                                  ;  106  2449 fputcR
  6226                                  ;  107  2471 prc
  6227                                  ;  108  2487 prc
  6228                                  ;  109  2508 prc
  6229                                  ;  110  2512 prc
  6230                                  ;  111  2534 printhex8a
  6231                                  ;  112  2545 printhex8a
  6232                                  ;  113  2570 printIntU
  6233                                  ;  114  2580 prc
  6234                                  ;  115  2593 prs
  6235                                  ;  116  2597 prs
  6236                                  ;  117  2601 prs
  6237                                  ;  118  2605 prs
  6238                                  ;  119  2622 error1
  6239                                  ;  120  2639 error1
  6240                                  ;  121  2656 error1
  6241                                  ;  122  2674 error1
  6242                                  ;  123  2694 error1
  6243                                  ;  124  2713 error1
  6244                                  ;  125  2732 error1
  6245                                  ;  126  2750 error1
  6246                                  ;  127  2769 error1
  6247                                  ;  128  2788 error1
  6248                                  ;  129  2807 error1
  6249                                  ;  130  2814 end1
  6250                                  ;  131  2828 errorexit
  6251                                  ;  132  2849 errorexit
  6252                                  ;  133  2864 getarg
  6253                                  ;  134  2871 parse
  6254                                  ;  135  2877 epilog
  6255                                  ;  136  2884 end1
  6256                                  ;  137  2908 cputs
  6257                                  ;  138  2914 cputs
  6258                                  ;  139  2920 exitR
  6259                                  ;  140  2926 toupper
  6260                                  ;  141  2934 strcpy
  6261                                  ;  142  2941 strcat1
  6262                                  ;  143  2949 strcpy
  6263                                  ;  144  2956 strcat1
  6264                                  ;  145  2964 strcpy
  6265                                  ;  146  2971 strcat1
  6266                                  ;  147  2979 openR
  6267                                  ;  148  2985 cputs
  6268                                  ;  149  2991 cputs
  6269                                  ;  150  2997 exitR
  6270                                  ;  151  3003 creatR
  6271                                  ;  152  3010 cputs
  6272                                  ;  153  3016 cputs
  6273                                  ;  154  3022 exitR
  6274                                  ;  155  3028 creatR
  6275                                  ;  156  3035 cputs
  6276                                  ;  157  3041 cputs
  6277                                  ;  158  3047 exitR
  6278                                  ;  159  3053 prs
  6279                                  ;  160  3057 prs
  6280                                  ;  161  3061 prs
  6281                                  ;  162  3065 prs
  6282                                  ;  163  3069 prs
  6283                                  ;  164  3073 prs
  6284                                  ;  165  3077 prs
  6285                                  ;  166  3081 prs
  6286                                  ;  167  3085 prs
  6287                                  ;  168  3102 prs
  6288                                  ;  169  3106 printIntU
  6289                                  ;  170  3116 prs
  6290                                  ;  171  3120 prs
  6291                                  ;  172  3124 printIntU
  6292                                  ;  173  3134 prs
  6293                                  ;  174  3138 fputcR
  6294                                  ;  175  3152 fcloseR
  6295                                  ;  176  3160 fcloseR
  6296                                  ;  177  3168 fcloseR
  6297                                  ;  178  3176 exitR
  6298                                  ;  179  3198 genCode8
  6299                                  ;  180  3219 genCode8
  6300                                  ;  181  3239 errorexit
  6301                                  ;  182  3261 genCode8
  6302                                  ;  183  3270 genCode8
  6303                                  ;  184  3295 addrexit
  6304                                  ;  185  3304 error1
  6305                                  ;  186  3311 genCode8
  6306                                  ;  187  3320 genCode8
  6307                                  ;  188  3329 genCode16
  6308                                  ;  189  3350 getTokeType
  6309                                  ;  190  3362 getCodeSize
  6310                                  ;  191  3374 getCodes
  6311                                  ;  192  3383 genCode8
  6312                                  ;  193  3392 checkOp
  6313                                  ;  194  3400 genCode
  6314                                  ;  195  3408 genCode
  6315                                  ;  196  3416 getTokeType
  6316                                  ;  197  3428 implerror
  6317                                  ;  198  3438 genCode
  6318                                  ;  199  3446 writeEA
  6319                                  ;  200  3454 checkOp
  6320                                  ;  201  3462 reg16error
  6321                                  ;  202  3473 need
  6322                                  ;  203  3478 getOp
  6323                                  ;  204  3484 addrerror
  6324                                  ;  205  3494 genCode8
  6325                                  ;  206  3503 genCode8
  6326                                  ;  207  3512 writeEA
  6327                                  ;  208  3520 genCode8
  6328                                  ;  209  3529 genCode16
  6329                                  ;  210  3539 genCode8
  6330                                  ;  211  3548 error1
  6331                                  ;  212  3555 error1
  6332                                  ;  213  3570 getOp
  6333                                  ;  214  3576 implerror
  6334                                  ;  215  3586 segregerror
  6335                                  ;  216  3598 setwflag
  6336                                  ;  217  3607 error1
  6337                                  ;  218  3614 error1
  6338                                  ;  219  3621 error1
  6339                                  ;  220  3634 getOp1
  6340                                  ;  221  3641 isToken
  6341                                  ;  222  3649 getMEM
  6342                                  ;  223  3656 invaloperror
  6343                                  ;  224  3669 error1
  6344                                  ;  225  3685 gen66h
  6345                                  ;  226  3699 testReg
  6346                                  ;  227  3707 searchLabel
  6347                                  ;  228  3719 error1
  6348                                  ;  229  3737 getTokeType
  6349                                  ;  230  3749 getOp1
  6350                                  ;  231  3756 syntaxerror
  6351                                  ;  232  3768 getIndReg2
  6352                                  ;  233  3779 getIndReg1
  6353                                  ;  234  3790 isToken
  6354                                  ;  235  3798 getTokeType
  6355                                  ;  236  3810 numbererror
  6356                                  ;  237  3822 isToken
  6357                                  ;  238  3830 isToken
  6358                                  ;  239  3838 errorexit
  6359                                  ;  240  3859 indexerror
  6360                                  ;  241  3870 indexerror
  6361                                  ;  242  3894 indexerror
  6362                                  ;  243  3905 indexerror
  6363                                  ;  244  3935 putch
  6364                                  ;  245  4003 strcpy
  6365                                  ;  246  4018 DosInt
  6366                                  ;  247  4034 DosInt
  6367                                  ;  248  4057 DosInt
  6368                                  ;  249  4076 DosInt
  6369                                  ;  250  4110 writetty
  6370                                  ;  251  4119 writetty
  6371                                  ;Input: AS.C, List: AS.S,  Lines:  191
  6372                                  ;Glob. variables:  199 max.:  200
  6373                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6374                                  ;Functions      :   74 max.:  300
  6375                                  ;Calls          :  252 max.: 2000, NameField: 4151 max.:    65535
  6376                                  ;Code until     :26009 max.: 30000, free: 3991
  6377                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6378                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
