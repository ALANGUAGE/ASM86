     1                                  
     2                                  ; A.COM CComp V0.7 16.11.2014, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E90000                  jmp main
     6                                  
     7                                  ;-1 int main() {getarg(); parse(); epilog(); end1();}//BAS.BAT,   AS TE
     8                                  
     9                                  
    10                                  main:  ; *** PROC ***
    11 00000003 E8BE1A                   call getarg
    12 00000006 E8110B                   call parse
    13 00000009 E8101D                   call epilog
    14 0000000C E87D1E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 5.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 5.1.2016",0
    21 00000019 3720352E312E323031-
    22 00000022 3600               
    23                                  
    24                                  ;-3 #include "DECL.C"
    25                                  
    26                                  ;Use include file: DECL.C
    27                                  
    28                                  ;-1 char LIST;              // listing on/off
    29                                  
    30 00000024 00                      LIST db 0
    31                                  
    32                                  ;-2 char Symbol[31];        //next symbol to decode
    33                                  
    34                                  section .bss
    35                                  absolute 30000
    36 00007530 <res 0000001F>          Symbol resb 31
    37                                  section .text
    38                                  
    39                                  ;-3 char SymbolUpper[31];   //set toupper in getName
    40                                  
    41                                  section .bss
    42                                  absolute 30031
    43 0000754F <res 0000001F>          SymbolUpper resb 31
    44                                  section .text
    45                                  
    46                                  ;-4 unsigned int SymbolInt; //integer value set in getDigit
    47                                  
    48 00000025 0000                    SymbolInt dw 0
    49                                  
    50                                  ;-5 char InputBuf[128];     //filled in getLine, no overflow test
    51                                  
    52                                  section .bss
    53                                  absolute 30062
    54 0000756E <res 00000080>          InputBuf resb 128
    55                                  section .text
    56                                  
    57                                  ;-6 unsigned char *InputPtr;//position in InputBuf
    58                                  
    59 00000027 0000                    InputPtr dw 0
    60                                  
    61                                  ;-7 char namein [67];       //input file name  .S
    62                                  
    63                                  section .bss
    64                                  absolute 30190
    65 000075EE <res 00000043>          namein resb 67
    66                                  section .text
    67                                  
    68                                  ;-8 char namelst[67];       //list file name   .LST
    69                                  
    70                                  section .bss
    71                                  absolute 30257
    72 00007631 <res 00000043>          namelst resb 67
    73                                  section .text
    74                                  
    75                                  ;-9 char namebin[67];       //output file name .COM
    76                                  
    77                                  section .bss
    78                                  absolute 30324
    79 00007674 <res 00000043>          namebin resb 67
    80                                  section .text
    81                                  
    82                                  ;-10 int  asm_fd;            //input file descriptor
    83                                  
    84 00000029 0000                    asm_fd dw 0
    85                                  
    86                                  ;-11 int lst_fd;             //list file descriptor
    87                                  
    88 0000002B 0000                    lst_fd dw 0
    89                                  
    90                                  ;-12 int bin_fd;             //output file descriptor
    91                                  
    92 0000002D 0000                    bin_fd dw 0
    93                                  
    94                                  ;-13 int DOS_ERR;            //global var
    95                                  
    96 0000002F 0000                    DOS_ERR dw 0
    97                                  
    98                                  ;-14 int ErrorCount;         //number of errors
    99                                  
   100 00000031 0000                    ErrorCount dw 0
   101                                  
   102                                  ;-15 int DOS_NoBytes;        //number of bytes read (0 or 1)
   103                                  
   104 00000033 0000                    DOS_NoBytes dw 0
   105                                  
   106                                  ;-16 char DOS_ByteRead;      //the byte just read by DOS
   107                                  
   108 00000035 00                      DOS_ByteRead db 0
   109                                  
   110                                  ;-17 
   111                                  
   112                                  
   113                                  ;-18 unsigned int PC;        //program counter, ORG nn
   114                                  
   115 00000036 0000                    PC dw 0
   116                                  
   117                                  ;-19 unsigned int PCStart;   //PC at start of line by PrintLine()
   118                                  
   119 00000038 0000                    PCStart dw 0
   120                                  
   121                                  ;-20 char isLabel;           //by getName()
   122                                  
   123 0000003A 00                      isLabel db 0
   124                                  
   125                                  ;-21 #define DIGIT    1      //0-9
   126                                  
   127                                  
   128                                  ;-22 #define LETTERE  2      //a-z A-Z @ . _
   129                                  
   130                                  
   131                                  ;-23 #define ALNUME   3      //a-z A-Z @ . _  0-9
   132                                  
   133                                  
   134                                  ;-24 #define NOALNUME 4      //other char
   135                                  
   136                                  
   137                                  ;-25 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   138                                  
   139 0000003B 00                      TokeType db 0
   140                                  
   141                                  ;-26 #define BYTE     1
   142                                  
   143                                  
   144                                  ;-27 #define WORD     2
   145                                  
   146                                  
   147                                  ;-28 #define DWORD    3
   148                                  
   149                                  
   150                                  ;-29 #define SEGREG   4
   151                                  
   152                                  
   153                                  ;-30 //char CodeSize;          //0, BYTE, WORD, DWORD
   154                                  
   155                                  
   156                                  ;-31 #define IMM      1      //const  ,123
   157                                  
   158                                  
   159                                  ;-32 #define REG      2      //       ,BX    mode=11
   160                                  
   161                                  
   162                                  ;-33 #define DIR      3      //VALUE  ,var1  mod=00, r/m=110
   163                                  
   164                                  
   165                                  ;-34 #define IND      4      //indirec,[var1],[BX+SI],[table+BX],[bp-4] disp 0,8,16
   166                                  
   167                                  
   168                                  ;-35 char Op1;               //0, IMM, REG, DIR, IND
   169                                  
   170 0000003C 00                      Op1 db 0
   171                                  
   172                                  ;-36 char CodeType;          //1-207 by searchSymbol(), must be byte size
   173                                  
   174 0000003D 00                      CodeType db 0
   175                                  
   176                                  ;-37 
   177                                  
   178                                  
   179                                  ;-38 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   180                                  
   181 0000003E 00                      RegType db 0
   182                                  
   183                                  ;-39 char RegNo;             //0 - 7 AL, CL, ...  by testReg()
   184                                  
   185 0000003F 00                      RegNo db 0
   186                                  
   187                                  ;-40 char OpSize;            //0, BYTE, WORD, DWORD
   188                                  
   189 00000040 00                      OpSize db 0
   190                                  
   191                                  ;-41 //char AddrSize;          //67h:
   192                                  
   193                                  
   194                                  ;-42 char NumOprns;          //0-2
   195                                  
   196 00000041 00                      NumOprns db 0
   197                                  
   198                                  ;-43 char wflag;             //0=byte, 1=word/dword
   199                                  
   200 00000042 00                      wflag db 0
   201                                  
   202                                  ;-44 char dflag;             //0=source is reg,  1=dest is reg
   203                                  
   204 00000043 00                      dflag db 0
   205                                  
   206                                  ;-45 //char modrm;           //mod, r/m
   207                                  
   208                                  
   209                                  ;-46 char reg;               //combination of index and base reg
   210                                  
   211 00000044 00                      reg db 0
   212                                  
   213                                  ;-47 int disp;               //displacement      0-8 bytes
   214                                  
   215 00000045 0000                    disp dw 0
   216                                  
   217                                  ;-48 int imme;               //immediate         0-8 bytes
   218                                  
   219 00000047 0000                    imme dw 0
   220                                  
   221                                  ;-49 
   222                                  
   223                                  
   224                                  ;-50 #define OPMAXLEN  5
   225                                  
   226                                  
   227                                  ;-51 char OpPos[OPMAXLEN];   //array for one opcode to list
   228                                  
   229                                  section .bss
   230                                  absolute 30391
   231 000076B7 <res 00000005>          OpPos resb 5
   232                                  section .text
   233                                  
   234                                  ;-52 int OpPrintIndex;       //0-OPMAXLEN, Position to print opcode, by genCode8()
   235                                  
   236 00000049 0000                    OpPrintIndex dw 0
   237                                  
   238                                  ;-53 char *OpCodePtr;        //position in OpCodeTable by searchSymbol(), div.
   239                                  
   240 0000004B 0000                    OpCodePtr dw 0
   241                                  
   242                                  ;-54 char PrReloc;           //print 'R' if relocative
   243                                  
   244 0000004D 00                      PrReloc db 0
   245                                  
   246                                  ;-55 
   247                                  
   248                                  
   249                                  ;-56 char LabelNames[1000];  //space for names of all labels
   250                                  
   251                                  section .bss
   252                                  absolute 30396
   253 000076BC <res 000003E8>          LabelNames resb 1000
   254                                  section .text
   255                                  
   256                                  ;-57 char *LabelNamePtr;     // first free position
   257                                  
   258 0000004E 0000                    LabelNamePtr dw 0
   259                                  
   260                                  ;-58 unsigned int LabelAddr[100];//addr of each label
   261                                  
   262                                  section .bss
   263                                  absolute 31396
   264 00007AA4 <res 000000C8>          LabelAddr resw 100
   265                                  section .text
   266                                  
   267                                  ;-59 int LabelMaxIx=0;       //actual number of stored labels
   268                                  
   269 00000050 0000                    LabelMaxIx dw 0
   270                                  
   271                                  ;-60 int LabelIx;            //actual number of just searched label
   272                                  
   273 00000052 0000                    LabelIx dw 0
   274                                  
   275                                  ;-61 
   276                                  
   277                                  
   278                                  ;-62 char FileBin  [2000];   //output binary file
   279                                  
   280                                  section .bss
   281                                  absolute 31596
   282 00007B6C <res 000007D0>          FileBin resb 2000
   283                                  section .text
   284                                  
   285                                  ;-63 unsigned int BinLen=0;  //length of binary file
   286                                  
   287 00000054 0000                    BinLen dw 0
   288                                  
   289                                  ;-64 
   290                                  
   291                                  
   292                                  ;-65 char *arglen=0x80;      // for main only
   293                                  
   294 00000056 8000                    arglen dw 128
   295                                  
   296                                  ;-66 char *argv=0x82;        // for main only
   297                                  
   298 00000058 8200                    argv dw 130
   299                                  ;Back to main program: AS.C
   300                                  
   301                                  ;-4 #include "OPTABL.C"
   302                                  
   303                                  ;Use include file: OPTABL.C
   304                                  
   305                                  ;-1 char I_START=0xF1;
   306                                  
   307 0000005A F1                      I_START db 241
   308                                  
   309                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   310                                  
   311                                  
   312                                  ;-3 //  1:   1 byte opcode
   313                                  
   314                                  
   315                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   316                                  
   317 0000005B 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   318                                  
   319                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   320                                  
   321 00000064 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   322                                  
   323                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   324                                  
   325 0000006C 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   326                                  
   327                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   328                                  
   329 00000073 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   330                                  
   331                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   332                                  
   333 0000007A 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   334                                  
   335                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   336                                  
   337 00000082 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   338                                  
   339                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   340                                  
   341 00000089 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   342                                  
   343                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   344                                  
   345 00000090 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   346                                  
   347                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   348                                  
   349 00000098 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   350                                  
   351                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   352                                  
   353 000000A1 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   354                                  
   355                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   356                                  
   357 000000A9 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   358                                  
   359                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   360                                  
   361 000000B1 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   362                                  
   363                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   364                                  
   365 000000B9 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   366                                  
   367                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   368                                  
   369 000000C2 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   370                                  
   371                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   372                                  
   373 000000CB 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   374                                  
   375                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   376                                  
   377 000000D4 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   378                                  
   379                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   380                                  
   381 000000DD 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   382                                  
   383                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   384                                  
   385 000000E6 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   386                                  
   387                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   388                                  
   389 000000EF 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   390                                  
   391                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   392                                  
   393 000000F8 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   394                                  
   395                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   396                                  
   397 00000101 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   398                                  
   399                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   400                                  
   401 0000010A 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   402                                  
   403                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   404                                  
   405 00000113 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   406                                  
   407                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   408                                  
   409 0000011C 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   410                                  
   411                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   412                                  
   413 00000124 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   414                                  
   415                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   416                                  
   417 0000012C 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   418                                  
   419                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   420                                  
   421 00000134 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   422                                  
   423                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   424                                  
   425 0000013D 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   426                                  
   427                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   428                                  
   429 00000146 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   430                                  
   431                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   432                                  
   433 0000014E 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   434                                  
   435                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   436                                  
   437 00000156 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   438                                  
   439                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   440                                  
   441 0000015D 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   442                                  
   443                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   444                                  
   445 00000164 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   446                                  
   447                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   448                                  
   449 0000016B 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   450                                  
   451                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   452                                  
   453 00000172 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   454                                  
   455                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   456                                  
   457 00000179 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   458                                  
   459                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   460                                  
   461 00000180 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   462                                  
   463                                  ;-41 //  2: inc,dec
   464                                  
   465                                  
   466                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   467                                  
   468 00000187 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   469                                  
   470                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   471                                  
   472 00000190 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   473                                  
   474                                  ;-44 // 52: mem reg 16 bit
   475                                  
   476                                  
   477                                  ;-45 char I_NOT[]=  {'N','O','T',0,         52,0xF6, 2,0xF1};
   478                                  
   479 00000199 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
   480                                  
   481                                  ;-46 char I_NEG[]=  {'N','E','G',0,         52,0xF6, 3,0xF1};
   482                                  
   483 000001A1 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
   484                                  
   485                                  ;-47 char I_MUL[]=  {'M','U','L',0,         52,0xF6, 4,0xF1};
   486                                  
   487 000001A9 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
   488                                  
   489                                  ;-48 char I_IMUL[]= {'I','M','U','L',0,     52,0xF6, 5,0xF1};//only acc
   490                                  
   491 000001B1 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
   492                                  
   493                                  ;-49 char I_DIV[]=  {'D','I','V',0,         52,0xF6, 6,0xF1};
   494                                  
   495 000001BA 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
   496                                  
   497                                  ;-50 char I_IDIV[]= {'I','D','I','V',0,     52,0xF6, 7,0xF1};
   498                                  
   499 000001C2 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
   500                                  
   501                                  ;-51 //  3: les, lda, lea
   502                                  
   503                                  
   504                                  ;-52 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16
   505                                  
   506 000001CB 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   507                                  
   508                                  ;-53 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16
   509                                  
   510 000001D2 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   511                                  
   512                                  ;-54 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16
   513                                  
   514 000001D9 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   515                                  
   516                                  ;-55 //  4: acc,imm  reg,imm  index,reg
   517                                  
   518                                  
   519                                  ;-56 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   520                                  
   521 000001E0 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   522                                  
   523                                  ;-57 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   524                                  
   525 000001E7 4F52000401F1            I_OR db 79,82,0,4,1,241
   526                                  
   527                                  ;-58 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   528                                  
   529 000001ED 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   530                                  
   531                                  ;-59 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   532                                  
   533 000001F4 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   534                                  
   535                                  ;-60 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   536                                  
   537 000001FB 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   538                                  
   539                                  ;-61 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   540                                  
   541 00000202 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   542                                  
   543                                  ;-62 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   544                                  
   545 00000209 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   546                                  
   547                                  ;-63 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   548                                  
   549 00000210 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   550                                  
   551                                  ;-64 //  5: mov
   552                                  
   553                                  
   554                                  ;-65 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   555                                  
   556 00000217 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   557                                  
   558                                  ;-66 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   559                                  
   560 0000021D 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   561                                  
   562                                  ;-67 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   563                                  
   564 00000226 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   565                                  
   566                                  ;-68 //  6: single byte relative jump
   567                                  
   568                                  
   569                                  ;-69 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   570                                  
   571 0000022F 4A4F000600F1            I_JO db 74,79,0,6,0,241
   572                                  
   573                                  ;-70 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   574                                  
   575 00000235 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   576                                  
   577                                  ;-71 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   578                                  
   579 0000023C 4A42000602F1            I_JB db 74,66,0,6,2,241
   580                                  
   581                                  ;-72 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   582                                  
   583 00000242 4A43000602F1            I_JC db 74,67,0,6,2,241
   584                                  
   585                                  ;-73 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   586                                  
   587 00000248 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   588                                  
   589                                  ;-74 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   590                                  
   591 0000024F 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   592                                  
   593                                  ;-75 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   594                                  
   595 00000256 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   596                                  
   597                                  ;-76 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   598                                  
   599 0000025D 4A45000604F1            I_JE db 74,69,0,6,4,241
   600                                  
   601                                  ;-77 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   602                                  
   603 00000263 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   604                                  
   605                                  ;-78 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   606                                  
   607 00000269 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   608                                  
   609                                  ;-79 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   610                                  
   611 00000270 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   612                                  
   613                                  ;-80 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   614                                  
   615 00000277 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   616                                  
   617                                  ;-81 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   618                                  
   619 0000027E 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   620                                  
   621                                  ;-82 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   622                                  
   623 00000285 4A41000607F1            I_JA db 74,65,0,6,7,241
   624                                  
   625                                  ;-83 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   626                                  
   627 0000028B 4A53000608F1            I_JS db 74,83,0,6,8,241
   628                                  
   629                                  ;-84 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   630                                  
   631 00000291 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   632                                  
   633                                  ;-85 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   634                                  
   635 00000298 4A5000060AF1            I_JP db 74,80,0,6,10,241
   636                                  
   637                                  ;-86 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   638                                  
   639 0000029E 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   640                                  
   641                                  ;-87 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   642                                  
   643 000002A5 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   644                                  
   645                                  ;-88 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   646                                  
   647 000002AC 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   648                                  
   649                                  ;-89 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   650                                  
   651 000002B3 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   652                                  
   653                                  ;-90 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   654                                  
   655 000002B9 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   656                                  
   657                                  ;-91 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   658                                  
   659 000002C0 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   660                                  
   661                                  ;-92 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   662                                  
   663 000002C7 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   664                                  
   665                                  ;-93 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   666                                  
   667 000002CE 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   668                                  
   669                                  ;-94 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   670                                  
   671 000002D5 4A4700060FF1            I_JG db 74,71,0,6,15,241
   672                                  
   673                                  ;-95 //  7: jmp, call
   674                                  
   675                                  
   676                                  ;-96 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   677                                  
   678 000002DB 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   679                                  
   680                                  ;-97 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   681                                  
   682 000002E3 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   683                                  
   684                                  ;-98 //  8: ret
   685                                  
   686                                  
   687                                  ;-99 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   688                                  
   689 000002EC 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   690                                  
   691                                  ;-100 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   692                                  
   693 000002F4 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   694                                  
   695                                  ;-101 //  9: seg, r/m
   696                                  
   697                                  
   698                                  ;-102 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   699                                  
   700 000002FD 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   701                                  
   702                                  ;-103 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   703                                  
   704 00000305 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   705                                  
   706                                  ;-104 //  11: shift, rotates
   707                                  
   708                                  
   709                                  ;-105 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   710                                  
   711 0000030C 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   712                                  
   713                                  ;-106 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   714                                  
   715 00000313 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   716                                  
   717                                  ;-107 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   718                                  
   719 0000031A 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   720                                  
   721                                  ;-108 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   722                                  
   723 00000321 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   724                                  
   725                                  ;-109 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   726                                  
   727 00000328 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   728                                  
   729                                  ;-110 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   730                                  
   731 0000032F 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   732                                  
   733                                  ;-111 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   734                                  
   735 00000336 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   736                                  
   737                                  ;-112 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   738                                  
   739 0000033D 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   740                                  
   741                                  ;-113 //  12: int
   742                                  
   743                                  
   744                                  ;-114 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   745                                  
   746 00000344 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   747                                  
   748                                  ;-115 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   749                                  
   750 0000034C 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   751                                  
   752                                  ;-116 //  14: in/out
   753                                  
   754                                  
   755                                  ;-117 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   756                                  
   757 00000354 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   758                                  
   759                                  ;-118 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   760                                  
   761 0000035B 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   762                                  
   763                                  ;-119 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   764                                  
   765 00000363 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   766                                  
   767                                  ;-120 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   768                                  
   769 0000036B 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   770                                  
   771                                  ;-121 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   772                                  
   773 00000373 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   774                                  
   775                                  ;-122 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   776                                  
   777 0000037B 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   778                                  
   779                                  ;-123 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   780                                  
   781 00000383 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   782                                  
   783                                  ;-124 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   784                                  
   785 0000038B 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   786                                  
   787                                  ;-125 //  15: xchg
   788                                  
   789                                  
   790                                  ;-126 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   791                                  
   792 00000393 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   793                                  
   794                                  ;-127 //  16: loop, jcxz
   795                                  
   796                                  
   797                                  ;-128 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   798                                  
   799 0000039C 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   800 000003A5 F1                 
   801                                  
   802                                  ;-129 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   803                                  
   804 000003A6 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   805 000003AF F1                 
   806                                  
   807                                  ;-130 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   808                                  
   809 000003B0 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   810                                  
   811                                  ;-131 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   812                                  
   813 000003B9 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   814                                  
   815                                  ;-132 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   816                                  
   817 000003C2 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   818                                  
   819                                  ;-133 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   820                                  
   821 000003CA 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   822                                  
   823                                  ;-134 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   824                                  
   825 000003D2 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   826                                  
   827                                  ;-135 //  30: enter
   828                                  
   829                                  
   830                                  ;-136 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   831                                  
   832 000003DB 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   833                                  
   834                                  ;-137 // 100: directives
   835                                  
   836                                  
   837                                  ;-138 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   838                                  
   839 000003E4 4F52470065F1            I_ORG db 79,82,71,0,101,241
   840                                  
   841                                  ;-139 char I_DB[]=   {'D','B',0,            200,        0xF1};
   842                                  
   843 000003EA 444200C8F1              I_DB db 68,66,0,200,241
   844                                  
   845                                  ;-140 char I_DW[]=   {'D','W',0,            201,        0xF1};
   846                                  
   847 000003EF 445700C9F1              I_DW db 68,87,0,201,241
   848                                  
   849                                  ;-141 char I_DD[]=   {'D','D',0,            202,        0xF1};
   850                                  
   851 000003F4 444400CAF1              I_DD db 68,68,0,202,241
   852                                  
   853                                  ;-142 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   854                                  
   855 000003F9 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   856                                  
   857                                  ;-143 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   858                                  
   859 00000400 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   860                                  
   861                                  ;-144 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   862                                  
   863 00000407 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   864                                  
   865                                  ;-145 char I_END=0;// end of table char
   866                                  
   867 0000040E 00                      I_END db 0
   868                                  ;Back to main program: AS.C
   869                                  
   870                                  ;-5 int test1() { __asm {
   871                                  
   872                                  
   873                                  test1:  ; *** PROC ***
   874                                  
   875                                  
   876                                  ;-6 inc byte [Version1]   ;FE 06 [1000]
   877                                  
   878 0000040F FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
   879                                  
   880                                  ;-7 add bx, ax    ;01 C3
   881                                  
   882 00000413 01C3                    add bx, ax    ;01 C3
   883                                  
   884                                  ;-8 add ax, bx    ;01 D8
   885                                  
   886 00000415 01D8                    add ax, bx    ;01 D8
   887                                  
   888                                  ;-9 add word ax, [bx] ;03 07
   889                                  
   890 00000417 0307                    add word ax, [bx] ;03 07
   891                                  
   892                                  ;-10 VA dw 8
   893                                  
   894 00000419 0800                    VA dw 8
   895                                  
   896                                  ;-11 mov byte [bp- 4], al ;88 46 FC
   897                                  
   898 0000041B 8846FC                  mov byte [bp- 4], al ;88 46 FC
   899                                  
   900                                  ;-12 mov      [VA+bx], al ;88 87 [300F]
   901                                  
   902 0000041E 8887[1904]              mov      [VA+bx], al ;88 87 [300F]
   903                                  
   904                                  ;-13 }  }
   905                                  
   906                                  
   907                                  
   908                                  ;-14 /*
   909                                  
   910                                  
   911                                  ;-15 int process1(); NumOprns=0;
   912                                  
   913                                  
   914                                  ;-16   getOpcode1(); NumOprns=1;
   915                                  
   916                                  
   917                                  ;-17   if (isToken(',')) {
   918                                  
   919                                  
   920                                  ;-18     getOpcode2(); NumOprns=2;
   921                                  
   922                                  
   923                                  ;-19   }
   924                                  
   925                                  
   926                                  ;-20   genInstruction();
   927                                  
   928                                  
   929                                  ;-21 */
   930                                  
   931                                  
   932                                  ;-22 int process() { int i; char c;
   933                                  
   934 00000422 C3                       ret
   935                                  ; ENDP
   936                                  
   937                                  process:  ; *** PROC ***
   938                                  
   939                                  ;-23   getTokeType();
   940                                  
   941                                  ;Function : process, Number of local variables: 2
   942                                  ;   # type sign width line used address name   list of local variables
   943                                  ;  200 var sign word    22 NULL bp-2    i
   944                                  ;  201 var sign byte    22 NULL bp-4    c;
   945 00000423 C8040000                 ENTER  4,0
   946 00000427 E8DA07                   call getTokeType
   947                                  
   948                                  ;-24   OpSize=getCodeSize();
   949                                  
   950 0000042A E8D10A                   call getCodeSize
   951 0000042D A2[4000]                 mov byte [OpSize], al
   952                                  
   953                                  ;-25 
   954                                  
   955                                  
   956                                  ;-26   if (CodeType ==  1) {//1 byte opcode
   957                                  
   958 00000430 A0[3D00]                 mov al, [CodeType]
   959 00000433 3C01                     cmp al, 1
   960 00000435 0F850D00                 jne @@process1
   961                                  
   962                                  ;-27     genInstruction(0, 1); return;
   963                                  
   964 00000439 6A01                     push 1
   965 0000043B 6A00                     push 0
   966 0000043D E8A805                   call genInstruction
   967 00000440 83C404                   add  sp, 4
   968 00000443 E9E000                   jmp @@retn
   969                                  
   970                                  ;-28   }
   971                                  
   972                                  
   973                                  ;-29   if (CodeType ==  2) {//inc, dec
   974                                  
   975                                  @@process1:
   976 00000446 A0[3D00]                 mov al, [CodeType]
   977 00000449 3C02                     cmp al, 2
   978 0000044B 0F855400                 jne @@process2
   979                                  
   980                                  ;-30     LeftOpwCheck();
   981                                  
   982 0000044F E8FA00                   call LeftOpwCheck
   983                                  
   984                                  ;-31     	if (Op1 == REG) {
   985                                  
   986 00000452 A0[3C00]                 mov al, [Op1]
   987 00000455 3C02                     cmp al, 2
   988 00000457 0F853400                 jne @@process3
   989                                  
   990                                  ;-32         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short
   991                                  
   992 0000045B A0[3E00]                 mov al, [RegType]
   993 0000045E 3C02                     cmp al, 2
   994 00000460 0F851100                 jne @@process4
   995 00000464 6A03                     push 3
   996 00000466 A0[3F00]                 mov al, byte [RegNo]
   997 00000469 B400                     mov ah, 0
   998 0000046B 50                       push ax
   999 0000046C E87905                   call genInstruction
  1000 0000046F 83C404                   add  sp, 4
  1001 00000472 E9B100                   jmp @@retn
  1002                                  
  1003                                  ;-33         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }
  1004                                  
  1005                                  @@process4:
  1006 00000475 A0[3E00]                 mov al, [RegType]
  1007 00000478 3C03                     cmp al, 3
  1008 0000047A 0F851100                 jne @@process5
  1009 0000047E 6A03                     push 3
  1010 00000480 A0[3F00]                 mov al, byte [RegNo]
  1011 00000483 B400                     mov ah, 0
  1012 00000485 50                       push ax
  1013 00000486 E85F05                   call genInstruction
  1014 00000489 83C404                   add  sp, 4
  1015 0000048C E99700                   jmp @@retn
  1016                                  @@process5:
  1017                                  
  1018                                  ;-34       genInstruction(wflag, 1); genCodeInREG(); return;
  1019                                  
  1020                                  @@process3:
  1021 0000048F 6A01                     push 1
  1022 00000491 A0[4200]                 mov al, byte [wflag]
  1023 00000494 B400                     mov ah, 0
  1024 00000496 50                       push ax
  1025 00000497 E84E05                   call genInstruction
  1026 0000049A 83C404                   add  sp, 4
  1027 0000049D E87A05                   call genCodeInREG
  1028 000004A0 E98300                   jmp @@retn
  1029                                  
  1030                                  ;-35   }
  1031                                  
  1032                                  
  1033                                  ;-36 
  1034                                  
  1035                                  
  1036                                  ;-37   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
  1037                                  
  1038                                  @@process2:
  1039 000004A3 A0[3D00]                 mov al, [CodeType]
  1040 000004A6 3C34                     cmp al, 52
  1041 000004A8 0F851700                 jne @@process6
  1042                                  
  1043                                  ;-38     LeftOpwCheck();
  1044                                  
  1045 000004AC E89D00                   call LeftOpwCheck
  1046                                  
  1047                                  ;-39     genInstruction(wflag, 1); genCodeInREG(); return;
  1048                                  
  1049 000004AF 6A01                     push 1
  1050 000004B1 A0[4200]                 mov al, byte [wflag]
  1051 000004B4 B400                     mov ah, 0
  1052 000004B6 50                       push ax
  1053 000004B7 E82E05                   call genInstruction
  1054 000004BA 83C404                   add  sp, 4
  1055 000004BD E85A05                   call genCodeInREG
  1056 000004C0 E96300                   jmp @@retn
  1057                                  
  1058                                  ;-40   }
  1059                                  
  1060                                  
  1061                                  ;-41 
  1062                                  
  1063                                  
  1064                                  ;-42   if (CodeType==  8) {// ret
  1065                                  
  1066                                  @@process6:
  1067 000004C3 A0[3D00]                 mov al, [CodeType]
  1068 000004C6 3C08                     cmp al, 8
  1069 000004C8 0F852D00                 jne @@process7
  1070                                  
  1071                                  ;-43     if (TokeType == DIGIT) {
  1072                                  
  1073 000004CC A0[3B00]                 mov al, [TokeType]
  1074 000004CF 3C01                     cmp al, 1
  1075 000004D1 0F851700                 jne @@process8
  1076                                  
  1077                                  ;-44         genInstruction(0, 2); genCode16(SymbolInt);return;}
  1078                                  
  1079 000004D5 6A02                     push 2
  1080 000004D7 6A00                     push 0
  1081 000004D9 E80C05                   call genInstruction
  1082 000004DC 83C404                   add  sp, 4
  1083 000004DF FF36[2500]               push word [SymbolInt]
  1084 000004E3 E8E104                   call genCode16
  1085 000004E6 83C402                   add  sp, 2
  1086 000004E9 E93A00                   jmp @@retn
  1087                                  
  1088                                  ;-45     genInstruction(0, 1); return;
  1089                                  
  1090                                  @@process8:
  1091 000004EC 6A01                     push 1
  1092 000004EE 6A00                     push 0
  1093 000004F0 E8F504                   call genInstruction
  1094 000004F3 83C404                   add  sp, 4
  1095 000004F6 E92D00                   jmp @@retn
  1096                                  
  1097                                  ;-46   }
  1098                                  
  1099                                  
  1100                                  ;-47 
  1101                                  
  1102                                  
  1103                                  ;-48   if (CodeType==101) {// ORG nn
  1104                                  
  1105                                  @@process7:
  1106 000004F9 A0[3D00]                 mov al, [CodeType]
  1107 000004FC 3C65                     cmp al, 101
  1108 000004FE 0F851B00                 jne @@process9
  1109                                  
  1110                                  ;-49     if (TokeType != DIGIT) error1("only digit allowed");
  1111                                  
  1112 00000502 A0[3B00]                 mov al, [TokeType]
  1113 00000505 3C01                     cmp al, 1
  1114 00000507 0F840900                 je  @@process10
  1115 0000050B 68[2805]                 push process_0
  1116 0000050E E83114                   call error1
  1117 00000511 83C402                   add  sp, 2
  1118                                  
  1119                                  ;-50     PC=SymbolInt;return;
  1120                                  
  1121                                  @@process10:
  1122 00000514 A1[2500]                 mov ax, [SymbolInt]
  1123 00000517 A3[3600]                 mov word [PC], ax
  1124 0000051A E90900                   jmp @@retn
  1125                                  
  1126                                  ;-51   }
  1127                                  
  1128                                  
  1129                                  ;-52   error1("unknown CodeType");
  1130                                  
  1131                                  @@process9:
  1132 0000051D 68[3B05]                 push process_1
  1133 00000520 E81F14                   call error1
  1134 00000523 83C402                   add  sp, 2
  1135                                  
  1136                                  ;-53 }
  1137                                  
  1138                                  
  1139                                  ;-54 /*
  1140                                  
  1141                                  
  1142                                  ;-55 operand::=
  1143                                  
  1144                                  
  1145                                  ;-56   none
  1146                                  
  1147                                  
  1148                                  ;-57   ac  (al, ax, eax)
  1149                                  
  1150                                  
  1151                                  ;-58   r   (b, w, s, d)
  1152                                  
  1153                                  
  1154                                  ;-59   [m] (b, w, d)
  1155                                  
  1156                                  
  1157                                  ;-60   i   (b, w)
  1158                                  
  1159                                  
  1160                                  ;-61   disp(b, w)
  1161                                  
  1162                                  
  1163                                  ;-62 
  1164                                  
  1165                                  
  1166                                  ;-63 //O2=rr,rm,ri,mr,mi
  1167                                  
  1168                                  
  1169                                  ;-64 //NumOprns==2, seg reg not allowed only mov and push
  1170                                  
  1171                                  
  1172                                  ;-65 //size: 1.declaration CodeSize, 2.reg size, 3.error1
  1173                                  
  1174                                  
  1175                                  ;-66 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
  1176                                  
  1177                                  
  1178                                  ;-67 //2. rm , imm 80
  1179                                  
  1180                                  
  1181                                  ;-68 //2a sign ext 83
  1182                                  
  1183                                  
  1184                                  ;-69 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
  1185                                  
  1186                                  
  1187                                  ;-70 //4. rm , reg 00
  1188                                  
  1189                                  
  1190                                  ;-71 //5. error1(mem2mem)
  1191                                  
  1192                                  
  1193                                  ;-72 */
  1194                                  
  1195                                  
  1196                                  ;-73 int LeftOpwCheck() {
  1197                                  
  1198 00000526 C9                      @@retn: LEAVE
  1199 00000527 C3                       ret
  1200                                  ; ENDP
  1201 00000528 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1202 00000531 7420616C6C6F776564-
  1203 0000053A 00                 
  1204 0000053B 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1205 00000544 6F64655479706500   
  1206                                  
  1207                                  LeftOpwCheck:  ; *** PROC ***
  1208                                  
  1209                                  ;-74   getLeftOp();
  1210                                  
  1211 0000054C E8A700                   call getLeftOp
  1212                                  
  1213                                  ;-75   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1214                                  
  1215 0000054F A0[3E00]                 mov al, [RegType]
  1216 00000552 3C04                     cmp al, 4
  1217 00000554 0F850600                 jne @@LeftOpwCheck11
  1218 00000558 E8E014                   call segregerror
  1219 0000055B E95300                   jmp @@retn
  1220                                  
  1221                                  ;-76   setwflag();
  1222                                  
  1223                                  @@LeftOpwCheck11:
  1224 0000055E E85B01                   call setwflag
  1225                                  
  1226                                  ;-77   if (OpSize == 0) error1("no op size declared");
  1227                                  
  1228 00000561 A0[4000]                 mov al, [OpSize]
  1229 00000564 3C00                     cmp al, 0
  1230 00000566 0F850900                 jne @@LeftOpwCheck12
  1231 0000056A 68[B205]                 push LeftOpwCheck_0
  1232 0000056D E8D213                   call error1
  1233 00000570 83C402                   add  sp, 2
  1234                                  
  1235                                  ;-78   if (OpSize == RegType) return;
  1236                                  
  1237                                  @@LeftOpwCheck12:
  1238 00000573 A0[4000]                 mov al, [OpSize]
  1239 00000576 3A06[3E00]               cmp al, [RegType]
  1240 0000057A 0F850300                 jne @@LeftOpwCheck13
  1241 0000057E E93000                   jmp @@retn
  1242                                  
  1243                                  ;-79   if (OpSize){if (Op1 == IND) return;
  1244                                  
  1245                                  @@LeftOpwCheck13:
  1246 00000581 A0[4000]                 mov al, [OpSize]
  1247 00000584 08C0                     or  al, al
  1248 00000586 0F841500                 je @@LeftOpwCheck14
  1249 0000058A A0[3C00]                 mov al, [Op1]
  1250 0000058D 3C04                     cmp al, 4
  1251 0000058F 0F850300                 jne @@LeftOpwCheck15
  1252 00000593 E91B00                   jmp @@retn
  1253                                  
  1254                                  ;-80     error1("Conflict OpSize and RegSize"); }
  1255                                  
  1256                                  @@LeftOpwCheck15:
  1257 00000596 68[C605]                 push LeftOpwCheck_1
  1258 00000599 E8A613                   call error1
  1259 0000059C 83C402                   add  sp, 2
  1260                                  
  1261                                  ;-81   if (RegType==0) error1("no register defined");
  1262                                  
  1263                                  @@LeftOpwCheck14:
  1264 0000059F A0[3E00]                 mov al, [RegType]
  1265 000005A2 3C00                     cmp al, 0
  1266 000005A4 0F850900                 jne @@LeftOpwCheck16
  1267 000005A8 68[E205]                 push LeftOpwCheck_2
  1268 000005AB E89413                   call error1
  1269 000005AE 83C402                   add  sp, 2
  1270                                  
  1271                                  ;-82 }
  1272                                  
  1273                                  @@LeftOpwCheck16:
  1274                                  
  1275                                  ;-83 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
  1276                                  
  1277                                  @@retn:
  1278 000005B1 C3                       ret
  1279                                  ; ENDP
  1280 000005B2 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
  1281 000005BB 65206465636C617265-
  1282 000005C4 6400               
  1283 000005C6 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
  1284 000005CF 4F7053697A6520616E-
  1285 000005D8 642052656753697A65-
  1286 000005E1 00                 
  1287 000005E2 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
  1288 000005EB 657220646566696E65-
  1289 000005F4 6400               
  1290                                  
  1291                                  getLeftOp:  ; *** PROC ***
  1292                                  
  1293                                  ;-84 //set: op1, disp->imm, reg, regt->size
  1294                                  
  1295                                  
  1296                                  ;-85   disp=0; imme=0; reg=0;
  1297                                  
  1298 000005F6 66B800000000             mov eax, 0
  1299 000005FC A3[4500]                 mov word [disp], ax
  1300 000005FF 66B800000000             mov eax, 0
  1301 00000605 A3[4700]                 mov word [imme], ax
  1302 00000608 66B800000000             mov eax, 0
  1303 0000060E A2[4400]                 mov byte [reg], al
  1304                                  
  1305                                  ;-86 
  1306                                  
  1307                                  
  1308                                  ;-87   Op1=getOp1();
  1309                                  
  1310 00000611 E80301                   call getOp1
  1311 00000614 A2[3C00]                 mov byte [Op1], al
  1312                                  
  1313                                  ;-88   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
  1314                                  
  1315 00000617 6A5B                     push 91
  1316 00000619 E86509                   call isToken
  1317 0000061C 83C402                   add  sp, 2
  1318 0000061F 08C0                     or  al, al
  1319 00000621 0F840F00                 je @@getLeftOp17
  1320 00000625 66B804000000             mov eax, 4
  1321 0000062B A2[3C00]                 mov byte [Op1], al
  1322 0000062E E86C01                   call getIND
  1323 00000631 E95200                   jmp @@retn
  1324                                  
  1325                                  ;-89   if (Op1 == 0) error1("Name of operand expected");
  1326                                  
  1327                                  @@getLeftOp17:
  1328 00000634 A0[3C00]                 mov al, [Op1]
  1329 00000637 3C00                     cmp al, 0
  1330 00000639 0F850900                 jne @@getLeftOp18
  1331 0000063D 68[8706]                 push getLeftOp_0
  1332 00000640 E8FF12                   call error1
  1333 00000643 83C402                   add  sp, 2
  1334                                  
  1335                                  ;-90   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
  1336                                  
  1337                                  @@getLeftOp18:
  1338 00000646 A0[3C00]                 mov al, [Op1]
  1339 00000649 3C01                     cmp al, 1
  1340 0000064B 0F850900                 jne @@getLeftOp19
  1341 0000064F A1[2500]                 mov ax, [SymbolInt]
  1342 00000652 A3[4700]                 mov word [imme], ax
  1343 00000655 E92E00                   jmp @@retn
  1344                                  
  1345                                  ;-91   if (Op1 == REG) return;                                    //2
  1346                                  
  1347                                  @@getLeftOp19:
  1348 00000658 A0[3C00]                 mov al, [Op1]
  1349 0000065B 3C02                     cmp al, 2
  1350 0000065D 0F850300                 jne @@getLeftOp20
  1351 00000661 E92200                   jmp @@retn
  1352                                  
  1353                                  ;-92   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
  1354                                  
  1355                                  @@getLeftOp20:
  1356 00000664 A0[3C00]                 mov al, [Op1]
  1357 00000667 3C03                     cmp al, 3
  1358 00000669 0F851000                 jne @@getLeftOp21
  1359 0000066D 8B1E[5200]               mov bx, [LabelIx]
  1360 00000671 D1E3                     shl bx, 1
  1361 00000673 8B87A47A                 mov ax, [LabelAddr + bx]
  1362 00000677 A3[4500]                 mov word [disp], ax
  1363 0000067A E90900                   jmp @@retn
  1364                                  
  1365                                  ;-93   error1("Name of operand expected #1");
  1366                                  
  1367                                  @@getLeftOp21:
  1368 0000067D 68[A006]                 push getLeftOp_1
  1369 00000680 E8BF12                   call error1
  1370 00000683 83C402                   add  sp, 2
  1371                                  
  1372                                  ;-94 }
  1373                                  
  1374                                  
  1375                                  ;-95 int setwflag() {//only Op1 (first operand)
  1376                                  
  1377                                  @@retn:
  1378 00000686 C3                       ret
  1379                                  ; ENDP
  1380 00000687 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
  1381 00000690 706572616E64206578-
  1382 00000699 70656374656400     
  1383 000006A0 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
  1384 000006A9 706572616E64206578-
  1385 000006B2 706563746564202331-
  1386 000006BB 00                 
  1387                                  
  1388                                  setwflag:  ; *** PROC ***
  1389                                  
  1390                                  ;-96   wflag=0;
  1391                                  
  1392 000006BC 66B800000000             mov eax, 0
  1393 000006C2 A2[4200]                 mov byte [wflag], al
  1394                                  
  1395                                  ;-97   if (OpSize == 0) {//do not override OpSize
  1396                                  
  1397 000006C5 A0[4000]                 mov al, [OpSize]
  1398 000006C8 3C00                     cmp al, 0
  1399 000006CA 0F852100                 jne @@setwflag22
  1400                                  
  1401                                  ;-98     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
  1402                                  
  1403 000006CE A0[3C00]                 mov al, [Op1]
  1404 000006D1 3C02                     cmp al, 2
  1405 000006D3 0F851800                 jne @@setwflag23
  1406 000006D7 A0[3E00]                 mov al, [RegType]
  1407 000006DA A2[4000]                 mov byte [OpSize], al
  1408 000006DD A0[3E00]                 mov al, [RegType]
  1409 000006E0 3C04                     cmp al, 4
  1410 000006E2 0F850900                 jne @@setwflag24
  1411 000006E6 66B802000000             mov eax, 2
  1412 000006EC A2[4000]                 mov byte [OpSize], al
  1413                                  @@setwflag24:
  1414                                  
  1415                                  ;-99   }
  1416                                  
  1417                                  @@setwflag23:
  1418                                  
  1419                                  ;-100   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1420                                  
  1421                                  @@setwflag22:
  1422 000006EF A0[4000]                 mov al, [OpSize]
  1423 000006F2 3C03                     cmp al, 3
  1424 000006F4 0F850C00                 jne @@setwflag25
  1425 000006F8 E89102                   call gen66h
  1426 000006FB 66B801000000             mov eax, 1
  1427 00000701 A2[4200]                 mov byte [wflag], al
  1428                                  
  1429                                  ;-101   if (OpSize  ==  WORD) wflag=1;
  1430                                  
  1431                                  @@setwflag25:
  1432 00000704 A0[4000]                 mov al, [OpSize]
  1433 00000707 3C02                     cmp al, 2
  1434 00000709 0F850900                 jne @@setwflag26
  1435 0000070D 66B801000000             mov eax, 1
  1436 00000713 A2[4200]                 mov byte [wflag], al
  1437                                  
  1438                                  ;-102 }
  1439                                  
  1440                                  @@setwflag26:
  1441                                  
  1442                                  ;-103 int getOp1() {//scan for a single operand
  1443                                  
  1444 00000716 C3                       ret
  1445                                  ; ENDP
  1446                                  
  1447                                  getOp1:  ; *** PROC ***
  1448                                  
  1449                                  ;-104   //set:Op1, imme, disp, RegType, TegNo, reg
  1450                                  
  1451                                  
  1452                                  ;-105   if (TokeType == 0)      return 0;
  1453                                  
  1454 00000717 A0[3B00]                 mov al, [TokeType]
  1455 0000071A 3C00                     cmp al, 0
  1456 0000071C 0F850900                 jne @@getOp127
  1457 00000720 66B800000000             mov eax, 0
  1458 00000726 E96000                   jmp @@retn
  1459                                  
  1460                                  ;-106   if (TokeType == DIGIT)  return IMM;// 1
  1461                                  
  1462                                  @@getOp127:
  1463 00000729 A0[3B00]                 mov al, [TokeType]
  1464 0000072C 3C01                     cmp al, 1
  1465 0000072E 0F850900                 jne @@getOp128
  1466 00000732 66B801000000             mov eax, 1
  1467 00000738 E94E00                   jmp @@retn
  1468                                  
  1469                                  ;-107   if (TokeType == ALNUME) {
  1470                                  
  1471                                  @@getOp128:
  1472 0000073B A0[3B00]                 mov al, [TokeType]
  1473 0000073E 3C03                     cmp al, 3
  1474 00000740 0F853C00                 jne @@getOp129
  1475                                  
  1476                                  ;-108     RegNo=testReg();//set global RegType
  1477                                  
  1478 00000744 E8540B                   call testReg
  1479 00000747 A2[3F00]                 mov byte [RegNo], al
  1480                                  
  1481                                  ;-109     if (RegType)          return REG;// 2
  1482                                  
  1483 0000074A A0[3E00]                 mov al, [RegType]
  1484 0000074D 08C0                     or  al, al
  1485 0000074F 0F840900                 je @@getOp130
  1486 00000753 66B802000000             mov eax, 2
  1487 00000759 E92D00                   jmp @@retn
  1488                                  
  1489                                  ;-110     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];
  1490                                  
  1491                                  @@getOp130:
  1492 0000075C E88D05                   call searchLabel
  1493 0000075F A3[5200]                 mov word [LabelIx], ax
  1494                                  
  1495                                  ;-111     if (LabelIx)          return DIR;// 3
  1496                                  
  1497 00000762 A1[5200]                 mov ax, [LabelIx]
  1498 00000765 08C0                     or  al, al
  1499 00000767 0F840C00                 je @@getOp131
  1500 0000076B 66B803000000             mov eax, 3
  1501 00000771 E91500                   jmp @@retn
  1502                                  
  1503                                  ;-112     else error1("variable not found"); }
  1504                                  
  1505 00000774 E90900                   jmp @@getOp132
  1506                                  @@getOp131:
  1507 00000777 68[8A07]                 push getOp1_0
  1508 0000077A E8C511                   call error1
  1509 0000077D 83C402                   add  sp, 2
  1510                                  @@getOp132:
  1511                                  
  1512                                  ;-113   return 0;
  1513                                  
  1514                                  @@getOp129:
  1515 00000780 66B800000000             mov eax, 0
  1516 00000786 E90000                   jmp @@retn
  1517                                  
  1518                                  ;-114 }
  1519                                  
  1520                                  
  1521                                  ;-115 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
  1522                                  
  1523                                  @@retn:
  1524 00000789 C3                       ret
  1525                                  ; ENDP
  1526 0000078A 7661726961626C6520-     getOp1_0 db "variable not found",0
  1527 00000793 6E6F7420666F756E64-
  1528 0000079C 00                 
  1529                                  
  1530                                  getIND:  ; *** PROC ***
  1531                                  
  1532                                  ;-116   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
  1533                                  
  1534                                  ;Function : getIND, Number of local variables: 2
  1535                                  ;   # type sign width line used address name   list of local variables
  1536                                  ;  200 var sign byte   116 NULL bp-2    op2
  1537                                  ;  201 var sign byte   116 NULL bp-4    r1;
  1538 0000079D C8040000                 ENTER  4,0
  1539 000007A1 66B800000000             mov eax, 0
  1540 000007A7 A3[4500]                 mov word [disp], ax
  1541 000007AA 66B800000000             mov eax, 0
  1542 000007B0 8846FC                   mov byte [bp-4], al
  1543 000007B3 66B800000000             mov eax, 0
  1544 000007B9 A2[3E00]                 mov byte [RegType], al
  1545                                  
  1546                                  ;-117   do {
  1547                                  
  1548                                  @@getIND33:
  1549                                  
  1550                                  ;-118     getTokeType();
  1551                                  
  1552 000007BC E84504                   call getTokeType
  1553                                  
  1554                                  ;-119     op2=getOp1();
  1555                                  
  1556 000007BF E855FF                   call getOp1
  1557 000007C2 8846FE                   mov byte [bp-2], al
  1558                                  
  1559                                  ;-120     if (op2 ==   0) syntaxerror();
  1560                                  
  1561 000007C5 8A46FE                   mov al, [bp-2]
  1562 000007C8 3C00                     cmp al, 0
  1563 000007CA 0F850300                 jne @@getIND34
  1564 000007CE E89112                   call syntaxerror
  1565                                  
  1566                                  ;-121     if (op2 == IMM) disp=disp+SymbolInt;
  1567                                  
  1568                                  @@getIND34:
  1569 000007D1 8A46FE                   mov al, [bp-2]
  1570 000007D4 3C01                     cmp al, 1
  1571 000007D6 0F850A00                 jne @@getIND35
  1572 000007DA A1[4500]                 mov ax, [disp]
  1573 000007DD 0306[2500]               add ax, [SymbolInt]
  1574 000007E1 A3[4500]                 mov word [disp], ax
  1575                                  
  1576                                  ;-122     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
  1577                                  
  1578                                  @@getIND35:
  1579 000007E4 8A46FE                   mov al, [bp-2]
  1580 000007E7 3C02                     cmp al, 2
  1581 000007E9 0F852100                 jne @@getIND36
  1582 000007ED 8A46FC                   mov al, [bp-4]
  1583 000007F0 08C0                     or  al, al
  1584 000007F2 0F841200                 je @@getIND37
  1585 000007F6 8A46FC                   mov al, byte [bp-4]
  1586 000007F9 B400                     mov ah, 0
  1587 000007FB 50                       push ax
  1588 000007FC E80001                   call getIndReg2
  1589 000007FF 83C402                   add  sp, 2
  1590 00000802 8846FC                   mov byte [bp-4], al
  1591 00000805 E90600                   jmp @@getIND38
  1592                                  @@getIND37:
  1593 00000808 E87F00                   call getIndReg1
  1594 0000080B 8846FC                   mov byte [bp-4], al
  1595                                  
  1596                                  ;-123     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
  1597                                  
  1598                                  @@getIND38:
  1599                                  @@getIND36:
  1600 0000080E 8A46FE                   mov al, [bp-2]
  1601 00000811 3C03                     cmp al, 3
  1602 00000813 0F851000                 jne @@getIND39
  1603 00000817 A1[4500]                 mov ax, [disp]
  1604 0000081A 8B1E[5200]               mov bx, [LabelIx]
  1605 0000081E D1E3                     shl bx, 1
  1606 00000820 0387A47A                 add ax, [LabelAddr + bx]
  1607 00000824 A3[4500]                 mov word [disp], ax
  1608                                  
  1609                                  ;-124     if (isToken('-')) {getTokeType();
  1610                                  
  1611                                  @@getIND39:
  1612 00000827 6A2D                     push 45
  1613 00000829 E85507                   call isToken
  1614 0000082C 83C402                   add  sp, 2
  1615 0000082F 08C0                     or  al, al
  1616 00000831 0F841900                 je @@getIND40
  1617 00000835 E8CC03                   call getTokeType
  1618                                  
  1619                                  ;-125       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  1620                                  
  1621 00000838 A0[3B00]                 mov al, [TokeType]
  1622 0000083B 3C01                     cmp al, 1
  1623 0000083D 0F840300                 je  @@getIND41
  1624 00000841 E8B311                   call numbererror
  1625                                  @@getIND41:
  1626 00000844 A1[4500]                 mov ax, [disp]
  1627 00000847 2B06[2500]               sub ax, [SymbolInt]
  1628 0000084B A3[4500]                 mov word [disp], ax
  1629                                  
  1630                                  ;-126   } while (isToken('+'));
  1631                                  
  1632                                  @@getIND40:
  1633 0000084E 6A2B                     push 43
  1634 00000850 E82E07                   call isToken
  1635 00000853 83C402                   add  sp, 2
  1636 00000856 08C0                     or  al, al
  1637 00000858 0F840300                 je @@getIND42
  1638 0000085C E95DFF                   jmp @@getIND33
  1639                                  @@getIND42:
  1640                                  
  1641                                  ;-127   if (isToken(']') == 0) errorexit("] expected");
  1642                                  
  1643 0000085F 6A5D                     push 93
  1644 00000861 E81D07                   call isToken
  1645 00000864 83C402                   add  sp, 2
  1646 00000867 83F800                   cmp ax, 0
  1647 0000086A 0F850900                 jne @@getIND43
  1648 0000086E 68[7F08]                 push getIND_0
  1649 00000871 E8FF11                   call errorexit
  1650 00000874 83C402                   add  sp, 2
  1651                                  
  1652                                  ;-128   reg=r1;
  1653                                  
  1654                                  @@getIND43:
  1655 00000877 8A46FC                   mov al, [bp-4]
  1656 0000087A A2[4400]                 mov byte [reg], al
  1657                                  
  1658                                  ;-129 }
  1659                                  
  1660                                  
  1661                                  ;-130 int getIndReg1() {char m; m=0;
  1662 0000087D C9                       LEAVE
  1663 0000087E C3                       ret
  1664                                  ; ENDP
  1665 0000087F 5D2065787065637465-     getIND_0 db "] expected",0
  1666 00000888 6400               
  1667                                  
  1668                                  getIndReg1:  ; *** PROC ***
  1669                                  ;Function : getIndReg1, Number of local variables: 1
  1670                                  ;   # type sign width line used address name   list of local variables
  1671                                  ;  200 var sign byte   130 NULL bp-2    m;
  1672 0000088A C8020000                 ENTER  2,0
  1673 0000088E 66B800000000             mov eax, 0
  1674 00000894 8846FE                   mov byte [bp-2], al
  1675                                  
  1676                                  ;-131   if (RegType !=WORD) indexerror();
  1677                                  
  1678 00000897 A0[3E00]                 mov al, [RegType]
  1679 0000089A 3C02                     cmp al, 2
  1680 0000089C 0F840300                 je  @@getIndReg144
  1681 000008A0 E83311                   call indexerror
  1682                                  
  1683                                  ;-132   if (RegNo==3) m=7;//BX
  1684                                  
  1685                                  @@getIndReg144:
  1686 000008A3 A0[3F00]                 mov al, [RegNo]
  1687 000008A6 3C03                     cmp al, 3
  1688 000008A8 0F850900                 jne @@getIndReg145
  1689 000008AC 66B807000000             mov eax, 7
  1690 000008B2 8846FE                   mov byte [bp-2], al
  1691                                  
  1692                                  ;-133   if (RegNo==5) m=6;//BP change to BP+0
  1693                                  
  1694                                  @@getIndReg145:
  1695 000008B5 A0[3F00]                 mov al, [RegNo]
  1696 000008B8 3C05                     cmp al, 5
  1697 000008BA 0F850900                 jne @@getIndReg146
  1698 000008BE 66B806000000             mov eax, 6
  1699 000008C4 8846FE                   mov byte [bp-2], al
  1700                                  
  1701                                  ;-134   if (RegNo==7) m=5;//DI
  1702                                  
  1703                                  @@getIndReg146:
  1704 000008C7 A0[3F00]                 mov al, [RegNo]
  1705 000008CA 3C07                     cmp al, 7
  1706 000008CC 0F850900                 jne @@getIndReg147
  1707 000008D0 66B805000000             mov eax, 5
  1708 000008D6 8846FE                   mov byte [bp-2], al
  1709                                  
  1710                                  ;-135   if (RegNo==6) m=4;//SI
  1711                                  
  1712                                  @@getIndReg147:
  1713 000008D9 A0[3F00]                 mov al, [RegNo]
  1714 000008DC 3C06                     cmp al, 6
  1715 000008DE 0F850900                 jne @@getIndReg148
  1716 000008E2 66B804000000             mov eax, 4
  1717 000008E8 8846FE                   mov byte [bp-2], al
  1718                                  
  1719                                  ;-136   if (m    ==0) indexerror();
  1720                                  
  1721                                  @@getIndReg148:
  1722 000008EB 8A46FE                   mov al, [bp-2]
  1723 000008EE 3C00                     cmp al, 0
  1724 000008F0 0F850300                 jne @@getIndReg149
  1725 000008F4 E8DF10                   call indexerror
  1726                                  
  1727                                  ;-137   return m;
  1728                                  
  1729                                  @@getIndReg149:
  1730 000008F7 8A46FE                   mov al, [bp-2]
  1731 000008FA E90000                   jmp @@retn
  1732                                  
  1733                                  ;-138 }
  1734                                  
  1735                                  
  1736                                  ;-139 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1737                                  
  1738 000008FD C9                      @@retn: LEAVE
  1739 000008FE C3                       ret
  1740                                  ; ENDP
  1741                                  
  1742                                  getIndReg2:  ; *** PROC ***
  1743                                  ;Function : getIndReg2, Number of local variables: 2
  1744                                  ;   # type sign width line used address name   list of local variables
  1745                                  ;  200 var sign byte   139 NULL bp+4    r1
  1746                                  ;  201 var sign byte   139 NULL bp-2    m;
  1747 000008FF C8020000                 ENTER  2,0
  1748 00000903 66B804000000             mov eax, 4
  1749 00000909 8846FE                   mov byte [bp-2], al
  1750                                  
  1751                                  ;-140   if (RegType !=WORD) indexerror();
  1752                                  
  1753 0000090C A0[3E00]                 mov al, [RegType]
  1754 0000090F 3C02                     cmp al, 2
  1755 00000911 0F840300                 je  @@getIndReg250
  1756 00000915 E8BE10                   call indexerror
  1757                                  
  1758                                  ;-141   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1759                                  
  1760                                  @@getIndReg250:
  1761 00000918 A0[3F00]                 mov al, [RegNo]
  1762 0000091B 3C07                     cmp al, 7
  1763 0000091D 0F852700                 jne @@getIndReg251
  1764 00000921 8A4604                   mov al, [bp+4]
  1765 00000924 3C06                     cmp al, 6
  1766 00000926 0F850C00                 jne @@getIndReg252
  1767 0000092A 66B803000000             mov eax, 3
  1768 00000930 8846FE                   mov byte [bp-2], al
  1769                                  
  1770                                  ;-142            else if (r1==7) m=1;//BX+DI
  1771                                  
  1772 00000933 E91200                   jmp @@getIndReg253
  1773                                  @@getIndReg252:
  1774 00000936 8A4604                   mov al, [bp+4]
  1775 00000939 3C07                     cmp al, 7
  1776 0000093B 0F850900                 jne @@getIndReg254
  1777 0000093F 66B801000000             mov eax, 1
  1778 00000945 8846FE                   mov byte [bp-2], al
  1779                                  
  1780                                  ;-143   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1781                                  
  1782                                  @@getIndReg254:
  1783                                  @@getIndReg253:
  1784                                  @@getIndReg251:
  1785 00000948 A0[3F00]                 mov al, [RegNo]
  1786 0000094B 3C06                     cmp al, 6
  1787 0000094D 0F852700                 jne @@getIndReg255
  1788 00000951 8A4604                   mov al, [bp+4]
  1789 00000954 3C06                     cmp al, 6
  1790 00000956 0F850C00                 jne @@getIndReg256
  1791 0000095A 66B802000000             mov eax, 2
  1792 00000960 8846FE                   mov byte [bp-2], al
  1793                                  
  1794                                  ;-144            else if (r1==7) m=0;//BX+DI
  1795                                  
  1796 00000963 E91200                   jmp @@getIndReg257
  1797                                  @@getIndReg256:
  1798 00000966 8A4604                   mov al, [bp+4]
  1799 00000969 3C07                     cmp al, 7
  1800 0000096B 0F850900                 jne @@getIndReg258
  1801 0000096F 66B800000000             mov eax, 0
  1802 00000975 8846FE                   mov byte [bp-2], al
  1803                                  
  1804                                  ;-145   if (m > 3) indexerror();
  1805                                  
  1806                                  @@getIndReg258:
  1807                                  @@getIndReg257:
  1808                                  @@getIndReg255:
  1809 00000978 8A46FE                   mov al, [bp-2]
  1810 0000097B 3C03                     cmp al, 3
  1811 0000097D 0F8E0300                 jle @@getIndReg259
  1812 00000981 E85210                   call indexerror
  1813                                  
  1814                                  ;-146   return m;
  1815                                  
  1816                                  @@getIndReg259:
  1817 00000984 8A46FE                   mov al, [bp-2]
  1818 00000987 E90000                   jmp @@retn
  1819                                  
  1820                                  ;-147 }
  1821                                  
  1822                                  
  1823                                  ;-148 
  1824                                  
  1825                                  
  1826                                  ;-149 // generate code ...........................................................
  1827                                  
  1828                                  
  1829                                  ;-150 int gen66h() {genCode8(0x66);}
  1830                                  
  1831 0000098A C9                      @@retn: LEAVE
  1832 0000098B C3                       ret
  1833                                  ; ENDP
  1834                                  
  1835                                  gen66h:  ; *** PROC ***
  1836 0000098C 6A66                     push 102
  1837 0000098E E80400                   call genCode8
  1838 00000991 83C402                   add  sp, 2
  1839                                  
  1840                                  ;-151 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  1841                                  
  1842 00000994 C3                       ret
  1843                                  ; ENDP
  1844                                  
  1845                                  genCode8:  ; *** PROC ***
  1846                                  
  1847                                  ;-152   FileBin[BinLen]=c; BinLen++; PC++;
  1848                                  
  1849                                  ;Function : genCode8, Number of local variables: 1
  1850                                  ;   # type sign width line used address name   list of local variables
  1851                                  ;  200 var sign byte   151 NULL bp+4    c;
  1852 00000995 C8000000                 ENTER  0,0
  1853 00000999 8A4604                   mov al, [bp+4]
  1854 0000099C 8B1E[5400]               mov bx, [BinLen]
  1855 000009A0 88876C7B                 mov [FileBin+bx], al
  1856 000009A4 FF06[5400]               inc  word [BinLen]
  1857 000009A8 FF06[3600]               inc  word [PC]
  1858                                  
  1859                                  ;-153   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
  1860                                  
  1861 000009AC A1[4900]                 mov ax, [OpPrintIndex]
  1862 000009AF 83F805                   cmp ax, 5
  1863 000009B2 0F8D0F00                 jge @@genCode860
  1864 000009B6 8A4604                   mov al, [bp+4]
  1865 000009B9 8B1E[4900]               mov bx, [OpPrintIndex]
  1866 000009BD 8887B776                 mov [OpPos+bx], al
  1867 000009C1 FF06[4900]               inc  word [OpPrintIndex]
  1868                                  
  1869                                  ;-154 }
  1870                                  
  1871                                  @@genCode860:
  1872                                  
  1873                                  ;-155 int genCode16(int i) {
  1874 000009C5 C9                       LEAVE
  1875 000009C6 C3                       ret
  1876                                  ; ENDP
  1877                                  
  1878                                  genCode16:  ; *** PROC ***
  1879                                  
  1880                                  ;-156   genCode8(i); i=i >> 8; genCode8(i);
  1881                                  
  1882                                  ;Function : genCode16, Number of local variables: 1
  1883                                  ;   # type sign width line used address name   list of local variables
  1884                                  ;  200 var sign word   155 NULL bp+4    i;
  1885 000009C7 C8000000                 ENTER  0,0
  1886 000009CB FF7604                   push word [bp+4]
  1887 000009CE E8C4FF                   call genCode8
  1888 000009D1 83C402                   add  sp, 2
  1889 000009D4 8B4604                   mov ax, [bp+4]
  1890 000009D7 C1E808                   shr ax, 8
  1891 000009DA 894604                   mov word [bp+4], ax
  1892 000009DD FF7604                   push word [bp+4]
  1893 000009E0 E8B2FF                   call genCode8
  1894 000009E3 83C402                   add  sp, 2
  1895                                  
  1896                                  ;-157 }
  1897                                  
  1898                                  
  1899                                  ;-158 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  1900 000009E6 C9                       LEAVE
  1901 000009E7 C3                       ret
  1902                                  ; ENDP
  1903                                  
  1904                                  genInstruction:  ; *** PROC ***
  1905                                  
  1906                                  ;-159   if(loc) OpCodePtr=OpCodePtr+loc;
  1907                                  
  1908                                  ;Function : genInstruction, Number of local variables: 3
  1909                                  ;   # type sign width line used address name   list of local variables
  1910                                  ;  200 var sign byte   158 NULL bp+4    No
  1911                                  ;  201 var sign word   158 NULL bp+6    loc
  1912                                  ;  202 var sign byte   158 NULL bp-2    c;
  1913 000009E8 C8020000                 ENTER  2,0
  1914 000009EC 8B4606                   mov ax, [bp+6]
  1915 000009EF 08C0                     or  al, al
  1916 000009F1 0F840900                 je @@genInstruction61
  1917 000009F5 A1[4B00]                 mov ax, [OpCodePtr]
  1918 000009F8 034606                   add ax, [bp+6]
  1919 000009FB A3[4B00]                 mov word [OpCodePtr], ax
  1920                                  
  1921                                  ;-160   c= *OpCodePtr + No; genCode8(c);
  1922                                  
  1923                                  @@genInstruction61:
  1924 000009FE 8B1E[4B00]               mov bx, [OpCodePtr]
  1925 00000A02 8A07                     mov al, [bx]
  1926 00000A04 B400                     mov ah, 0
  1927 00000A06 024604                   add al, [bp+4]
  1928 00000A09 8846FE                   mov byte [bp-2], al
  1929 00000A0C 8A46FE                   mov al, byte [bp-2]
  1930 00000A0F B400                     mov ah, 0
  1931 00000A11 50                       push ax
  1932 00000A12 E880FF                   call genCode8
  1933 00000A15 83C402                   add  sp, 2
  1934                                  
  1935                                  ;-161 }
  1936                                  
  1937                                  
  1938                                  ;-162 int genCodeInREG() {char x; //get Code for second byte
  1939 00000A18 C9                       LEAVE
  1940 00000A19 C3                       ret
  1941                                  ; ENDP
  1942                                  
  1943                                  genCodeInREG:  ; *** PROC ***
  1944                                  
  1945                                  ;-163   OpCodePtr++; x= *OpCodePtr; writeEA(x);
  1946                                  
  1947                                  ;Function : genCodeInREG, Number of local variables: 1
  1948                                  ;   # type sign width line used address name   list of local variables
  1949                                  ;  200 var sign byte   162 NULL bp-2    x;
  1950 00000A1A C8020000                 ENTER  2,0
  1951 00000A1E FF06[4B00]               inc  word [OpCodePtr]
  1952 00000A22 8B1E[4B00]               mov bx, [OpCodePtr]
  1953 00000A26 8A07                     mov al, [bx]
  1954 00000A28 B400                     mov ah, 0
  1955 00000A2A 8846FE                   mov byte [bp-2], al
  1956 00000A2D 8A46FE                   mov al, byte [bp-2]
  1957 00000A30 B400                     mov ah, 0
  1958 00000A32 50                       push ax
  1959 00000A33 E81200                   call writeEA
  1960 00000A36 83C402                   add  sp, 2
  1961                                  
  1962                                  ;-164 }
  1963                                  
  1964                                  
  1965                                  ;-165 int genModRegRM(){ writeEA(reg);//todo
  1966 00000A39 C9                       LEAVE
  1967 00000A3A C3                       ret
  1968                                  ; ENDP
  1969                                  
  1970                                  genModRegRM:  ; *** PROC ***
  1971 00000A3B A0[4400]                 mov al, byte [reg]
  1972 00000A3E B400                     mov ah, 0
  1973 00000A40 50                       push ax
  1974 00000A41 E80400                   call writeEA
  1975 00000A44 83C402                   add  sp, 2
  1976                                  
  1977                                  ;-166 }
  1978                                  
  1979                                  
  1980                                  ;-167 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  1981                                  
  1982 00000A47 C3                       ret
  1983                                  ; ENDP
  1984                                  
  1985                                  writeEA:  ; *** PROC ***
  1986                                  
  1987                                  ;-168   len=0;
  1988                                  
  1989                                  ;Function : writeEA, Number of local variables: 2
  1990                                  ;   # type sign width line used address name   list of local variables
  1991                                  ;  200 var sign byte   167 NULL bp+4    xxx
  1992                                  ;  201 var sign byte   167 NULL bp-2    len;
  1993 00000A48 C8020000                 ENTER  2,0
  1994 00000A4C 66B800000000             mov eax, 0
  1995 00000A52 8846FE                   mov byte [bp-2], al
  1996                                  
  1997                                  ;-169   xxx = xxx << 3;//in reg field of mod r/m
  1998                                  
  1999 00000A55 8A4604                   mov al, [bp+4]
  2000 00000A58 C0E003                   shl al, 3
  2001 00000A5B 884604                   mov byte [bp+4], al
  2002                                  
  2003                                  ;-170   if (Op1 ==   0) addrexit();
  2004                                  
  2005 00000A5E A0[3C00]                 mov al, [Op1]
  2006 00000A61 3C00                     cmp al, 0
  2007 00000A63 0F850300                 jne @@writeEA62
  2008 00000A67 E82010                   call addrexit
  2009                                  
  2010                                  ;-171   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  2011                                  
  2012                                  @@writeEA62:
  2013 00000A6A A0[3C00]                 mov al, [Op1]
  2014 00000A6D 3C02                     cmp al, 2
  2015 00000A6F 0F850E00                 jne @@writeEA63
  2016 00000A73 804E04C0                 or  byte [bp+4], 192
  2017 00000A77 8A4604                   mov al, [bp+4]
  2018 00000A7A 0206[3F00]               add al, [RegNo]
  2019 00000A7E 884604                   mov byte [bp+4], al
  2020                                  
  2021                                  ;-172   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  2022                                  
  2023                                  @@writeEA63:
  2024 00000A81 A0[3C00]                 mov al, [Op1]
  2025 00000A84 3C03                     cmp al, 3
  2026 00000A86 0F850D00                 jne @@writeEA64
  2027 00000A8A 804E0406                 or  byte [bp+4], 6
  2028 00000A8E 66B802000000             mov eax, 2
  2029 00000A94 8846FE                   mov byte [bp-2], al
  2030                                  
  2031                                  ;-173   if (Op1 == IND) { xxx = xxx + reg;                       //4
  2032                                  
  2033                                  @@writeEA64:
  2034 00000A97 A0[3C00]                 mov al, [Op1]
  2035 00000A9A 3C04                     cmp al, 4
  2036 00000A9C 0F854600                 jne @@writeEA65
  2037 00000AA0 8A4604                   mov al, [bp+4]
  2038 00000AA3 0206[4400]               add al, [reg]
  2039 00000AA7 884604                   mov byte [bp+4], al
  2040                                  
  2041                                  ;-174     if (disp) {disp; if(ax > 127) len=2; else len=1;
  2042                                  
  2043 00000AAA A1[4500]                 mov ax, [disp]
  2044 00000AAD 08C0                     or  al, al
  2045 00000AAF 0F843300                 je @@writeEA66
  2046 00000AB3 A1[4500]                 mov ax, [disp]
  2047 00000AB6 83F87F                   cmp  ax, 127
  2048 00000AB9 0F8E0C00                 jle @@writeEA67
  2049 00000ABD 66B802000000             mov eax, 2
  2050 00000AC3 8846FE                   mov byte [bp-2], al
  2051 00000AC6 E90900                   jmp @@writeEA68
  2052                                  @@writeEA67:
  2053 00000AC9 66B801000000             mov eax, 1
  2054 00000ACF 8846FE                   mov byte [bp-2], al
  2055                                  
  2056                                  ;-175       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
  2057                                  
  2058                                  @@writeEA68:
  2059 00000AD2 8A46FE                   mov al, [bp-2]
  2060 00000AD5 3C01                     cmp al, 1
  2061 00000AD7 0F850700                 jne @@writeEA69
  2062 00000ADB 804E0440                 or  byte [bp+4], 64
  2063 00000ADF E90400                   jmp @@writeEA70
  2064                                  @@writeEA69:
  2065 00000AE2 804E0480                 or  byte [bp+4], 128
  2066                                  @@writeEA70:
  2067                                  
  2068                                  ;-176     }
  2069                                  
  2070                                  @@writeEA66:
  2071                                  
  2072                                  ;-177   genCode8(xxx);// gen second byte
  2073                                  
  2074                                  @@writeEA65:
  2075 00000AE6 8A4604                   mov al, byte [bp+4]
  2076 00000AE9 B400                     mov ah, 0
  2077 00000AEB 50                       push ax
  2078 00000AEC E8A6FE                   call genCode8
  2079 00000AEF 83C402                   add  sp, 2
  2080                                  
  2081                                  ;-178   if (len == 1) genCode8 (disp);
  2082                                  
  2083 00000AF2 8A46FE                   mov al, [bp-2]
  2084 00000AF5 3C01                     cmp al, 1
  2085 00000AF7 0F850A00                 jne @@writeEA71
  2086 00000AFB FF36[4500]               push word [disp]
  2087 00000AFF E893FE                   call genCode8
  2088 00000B02 83C402                   add  sp, 2
  2089                                  
  2090                                  ;-179   if (len == 2) genCode16(disp);
  2091                                  
  2092                                  @@writeEA71:
  2093 00000B05 8A46FE                   mov al, [bp-2]
  2094 00000B08 3C02                     cmp al, 2
  2095 00000B0A 0F850A00                 jne @@writeEA72
  2096 00000B0E FF36[4500]               push word [disp]
  2097 00000B12 E8B2FE                   call genCode16
  2098 00000B15 83C402                   add  sp, 2
  2099                                  
  2100                                  ;-180 }
  2101                                  
  2102                                  @@writeEA72:
  2103                                  
  2104                                  ;-181 
  2105                                  
  2106                                  
  2107                                  ;-182 //#include "AS1.C"
  2108                                  
  2109                                  
  2110                                  ;-183 #include "PARSE.C"
  2111 00000B18 C9                       LEAVE
  2112 00000B19 C3                       ret
  2113                                  ; ENDP
  2114                                  ;Use include file: PARSE.C
  2115                                  
  2116                                  ;-1 int parse() {
  2117                                  
  2118                                  
  2119                                  parse:  ; *** PROC ***
  2120                                  
  2121                                  ;-2   LabelNamePtr= &LabelNames;
  2122                                  
  2123 00000B1A B8BC76                   mov ax, LabelNames
  2124 00000B1D A3[4E00]                 mov word [LabelNamePtr], ax
  2125                                  
  2126                                  ;-3   do {
  2127                                  
  2128                                  @@parse73:
  2129                                  
  2130                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  2131                                  
  2132 00000B20 A1[3600]                 mov ax, [PC]
  2133 00000B23 A3[3800]                 mov word [PCStart], ax
  2134 00000B26 66B800000000             mov eax, 0
  2135 00000B2C A2[4000]                 mov byte [OpSize], al
  2136 00000B2F 66B800000000             mov eax, 0
  2137 00000B35 A3[4900]                 mov word [OpPrintIndex], ax
  2138 00000B38 66B820000000             mov eax, 32
  2139 00000B3E A2[4D00]                 mov byte [PrReloc], al
  2140                                  
  2141                                  ;-5     getLine();
  2142                                  
  2143 00000B41 E8A104                   call getLine
  2144                                  
  2145                                  ;-6     InputPtr = &InputBuf;
  2146                                  
  2147 00000B44 B86E75                   mov ax, InputBuf
  2148 00000B47 A3[2700]                 mov word [InputPtr], ax
  2149                                  
  2150                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2151                                  
  2152 00000B4A E8B700                   call getTokeType
  2153                                  
  2154                                  ;-8     if (TokeType == ALNUME) {
  2155                                  
  2156 00000B4D A0[3B00]                 mov al, [TokeType]
  2157 00000B50 3C03                     cmp al, 3
  2158 00000B52 0F851300                 jne @@parse74
  2159                                  
  2160                                  ;-9       if (isLabel) { //set in getName
  2161                                  
  2162 00000B56 A0[3A00]                 mov al, [isLabel]
  2163 00000B59 08C0                     or  al, al
  2164 00000B5B 0F840A00                 je @@parse75
  2165                                  
  2166                                  ;-10         storeLabel();
  2167                                  
  2168 00000B5F E84001                   call storeLabel
  2169                                  
  2170                                  ;-11         InputPtr++;//remove :
  2171                                  
  2172 00000B62 FF06[2700]               inc  word [InputPtr]
  2173                                  
  2174                                  ;-12         getTokeType();
  2175                                  
  2176 00000B66 E89B00                   call getTokeType
  2177                                  
  2178                                  ;-13       }
  2179                                  
  2180                                  
  2181                                  ;-14     }
  2182                                  
  2183                                  @@parse75:
  2184                                  
  2185                                  ;-15     if (TokeType == ALNUME) {
  2186                                  
  2187                                  @@parse74:
  2188 00000B69 A0[3B00]                 mov al, [TokeType]
  2189 00000B6C 3C03                     cmp al, 3
  2190 00000B6E 0F851B00                 jne @@parse76
  2191                                  
  2192                                  ;-16       lookCode();// and OpCodePtr
  2193                                  
  2194 00000B72 E80F03                   call lookCode
  2195                                  
  2196                                  ;-17       if(CodeType) process();
  2197                                  
  2198 00000B75 A0[3D00]                 mov al, [CodeType]
  2199 00000B78 08C0                     or  al, al
  2200 00000B7A 0F840600                 je @@parse77
  2201 00000B7E E8A2F8                   call process
  2202                                  
  2203                                  ;-18       else getVariable();
  2204                                  
  2205 00000B81 E90300                   jmp @@parse78
  2206                                  @@parse77:
  2207 00000B84 E8C501                   call getVariable
  2208                                  
  2209                                  ;-19       skipRest();
  2210                                  
  2211                                  @@parse78:
  2212 00000B87 E82504                   call skipRest
  2213                                  
  2214                                  ;-20     }
  2215                                  
  2216                                  
  2217                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2218                                  
  2219 00000B8A E92700                   jmp @@parse79
  2220                                  @@parse76:
  2221 00000B8D A0[3B00]                 mov al, [TokeType]
  2222 00000B90 3C03                     cmp al, 3
  2223 00000B92 0F8E0C00                 jle @@parse80
  2224 00000B96 68[C50B]                 push parse_0
  2225 00000B99 E8A60D                   call error1
  2226 00000B9C 83C402                   add  sp, 2
  2227                                  
  2228                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2229                                  
  2230 00000B9F E91200                   jmp @@parse81
  2231                                  @@parse80:
  2232 00000BA2 A0[3B00]                 mov al, [TokeType]
  2233 00000BA5 3C01                     cmp al, 1
  2234 00000BA7 0F850900                 jne @@parse82
  2235 00000BAB 68[E30B]                 push parse_1
  2236 00000BAE E8910D                   call error1
  2237 00000BB1 83C402                   add  sp, 2
  2238                                  
  2239                                  ;-23     printLine();
  2240                                  
  2241                                  @@parse82:
  2242                                  @@parse81:
  2243                                  @@parse79:
  2244 00000BB4 E8200B                   call printLine
  2245                                  
  2246                                  ;-24   } while (DOS_NoBytes != 0 );
  2247                                  
  2248 00000BB7 A1[3300]                 mov ax, [DOS_NoBytes]
  2249 00000BBA 83F800                   cmp ax, 0
  2250 00000BBD 0F840300                 je  @@parse83
  2251 00000BC1 E95CFF                   jmp @@parse73
  2252                                  @@parse83:
  2253                                  
  2254                                  ;-25 }
  2255                                  
  2256                                  
  2257                                  ;-26 // scan code .....................................
  2258                                  
  2259                                  
  2260                                  ;-27 int getTokeType() { char c;
  2261                                  
  2262 00000BC4 C3                       ret
  2263                                  ; ENDP
  2264 00000BC5 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2265 00000BCE 696E73747275637469-
  2266 00000BD7 6F6E20657870656374-
  2267 00000BE0 656400             
  2268 00000BE3 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2269 00000BEC 616C6C6F7765642040-
  2270 00000BF5 207374617274206F66-
  2271 00000BFE 206C696E6500       
  2272                                  
  2273                                  getTokeType:  ; *** PROC ***
  2274                                  
  2275                                  ;-28   skipBlank();
  2276                                  
  2277                                  ;Function : getTokeType, Number of local variables: 1
  2278                                  ;   # type sign width line used address name   list of local variables
  2279                                  ;  200 var sign byte    27 NULL bp-2    c;
  2280 00000C04 C8020000                 ENTER  2,0
  2281 00000C08 E8A704                   call skipBlank
  2282                                  
  2283                                  ;-29   c = *InputPtr;
  2284                                  
  2285 00000C0B 8B1E[2700]               mov bx, [InputPtr]
  2286 00000C0F 8A07                     mov al, [bx]
  2287 00000C11 B400                     mov ah, 0
  2288 00000C13 8846FE                   mov byte [bp-2], al
  2289                                  
  2290                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2291                                  
  2292 00000C16 8A46FE                   mov al, [bp-2]
  2293 00000C19 3C00                     cmp al, 0
  2294 00000C1B 0F850C00                 jne @@getTokeType84
  2295 00000C1F 66B800000000             mov eax, 0
  2296 00000C25 A2[3B00]                 mov byte [TokeType], al
  2297 00000C28 E97500                   jmp @@retn
  2298                                  
  2299                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2300                                  
  2301                                  @@getTokeType84:
  2302 00000C2B 8A46FE                   mov al, [bp-2]
  2303 00000C2E 3C3B                     cmp al, 59
  2304 00000C30 0F850C00                 jne @@getTokeType85
  2305 00000C34 66B800000000             mov eax, 0
  2306 00000C3A A2[3B00]                 mov byte [TokeType], al
  2307 00000C3D E96000                   jmp @@retn
  2308                                  
  2309                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2310                                  
  2311                                  @@getTokeType85:
  2312 00000C40 8A46FE                   mov al, byte [bp-2]
  2313 00000C43 B400                     mov ah, 0
  2314 00000C45 50                       push ax
  2315 00000C46 E84D13                   call digit
  2316 00000C49 83C402                   add  sp, 2
  2317 00000C4C 08C0                     or  al, al
  2318 00000C4E 0F841800                 je @@getTokeType86
  2319 00000C52 8A46FE                   mov al, byte [bp-2]
  2320 00000C55 B400                     mov ah, 0
  2321 00000C57 50                       push ax
  2322 00000C58 E85D05                   call getDigit
  2323 00000C5B 83C402                   add  sp, 2
  2324 00000C5E 66B801000000             mov eax, 1
  2325 00000C64 A2[3B00]                 mov byte [TokeType], al
  2326 00000C67 E93600                   jmp @@retn
  2327                                  
  2328                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2329                                  
  2330                                  @@getTokeType86:
  2331 00000C6A 8A46FE                   mov al, byte [bp-2]
  2332 00000C6D B400                     mov ah, 0
  2333 00000C6F 50                       push ax
  2334 00000C70 E86A04                   call letterE
  2335 00000C73 83C402                   add  sp, 2
  2336 00000C76 08C0                     or  al, al
  2337 00000C78 0F841800                 je @@getTokeType87
  2338 00000C7C 8A46FE                   mov al, byte [bp-2]
  2339 00000C7F B400                     mov ah, 0
  2340 00000C81 50                       push ax
  2341 00000C82 E88A05                   call getName
  2342 00000C85 83C402                   add  sp, 2
  2343 00000C88 66B803000000             mov eax, 3
  2344 00000C8E A2[3B00]                 mov byte [TokeType], al
  2345 00000C91 E90C00                   jmp @@retn
  2346                                  
  2347                                  ;-34   TokeType=NOALNUME; return;
  2348                                  
  2349                                  @@getTokeType87:
  2350 00000C94 66B804000000             mov eax, 4
  2351 00000C9A A2[3B00]                 mov byte [TokeType], al
  2352 00000C9D E90000                   jmp @@retn
  2353                                  
  2354                                  ;-35 }
  2355                                  
  2356                                  
  2357                                  ;-36 int storeLabel() {
  2358                                  
  2359 00000CA0 C9                      @@retn: LEAVE
  2360 00000CA1 C3                       ret
  2361                                  ; ENDP
  2362                                  
  2363                                  storeLabel:  ; *** PROC ***
  2364                                  
  2365                                  ;-37   if(searchLabel()) error1("duplicate label");
  2366                                  
  2367 00000CA2 E84700                   call searchLabel
  2368 00000CA5 08C0                     or  al, al
  2369 00000CA7 0F840900                 je @@storeLabel88
  2370 00000CAB 68[DC0C]                 push storeLabel_0
  2371 00000CAE E8910C                   call error1
  2372 00000CB1 83C402                   add  sp, 2
  2373                                  
  2374                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2375                                  
  2376                                  @@storeLabel88:
  2377 00000CB4 8D063075                 lea  ax, [Symbol]
  2378 00000CB8 50                       push ax
  2379 00000CB9 FF36[4E00]               push word [LabelNamePtr]
  2380 00000CBD E89D12                   call strcpy
  2381 00000CC0 83C404                   add  sp, 4
  2382 00000CC3 A3[4E00]                 mov word [LabelNamePtr], ax
  2383                                  
  2384                                  ;-39   LabelNamePtr++;
  2385                                  
  2386 00000CC6 FF06[4E00]               inc  word [LabelNamePtr]
  2387                                  
  2388                                  ;-40   LabelMaxIx++;
  2389                                  
  2390 00000CCA FF06[5000]               inc  word [LabelMaxIx]
  2391                                  
  2392                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2393                                  
  2394 00000CCE A1[3600]                 mov ax, [PC]
  2395 00000CD1 8B1E[5000]               mov bx, [LabelMaxIx]
  2396 00000CD5 D1E3                     shl bx, 1
  2397 00000CD7 8987A47A                 mov [LabelAddr+bx], ax
  2398                                  
  2399                                  ;-42 }
  2400                                  
  2401                                  
  2402                                  ;-43 int searchLabel() {
  2403                                  
  2404 00000CDB C3                       ret
  2405                                  ; ENDP
  2406 00000CDC 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2407 00000CE5 206C6162656C00     
  2408                                  
  2409                                  searchLabel:  ; *** PROC ***
  2410                                  
  2411                                  ;-44   int LIx; char *p; int j;
  2412                                  
  2413                                  
  2414                                  ;-45   p = &LabelNames;
  2415                                  
  2416                                  ;Function : searchLabel, Number of local variables: 3
  2417                                  ;   # type sign width line used address name   list of local variables
  2418                                  ;  200 var sign word    44 NULL bp-2    LIx
  2419                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2420                                  ;  202 var sign word    44 NULL bp-6    j;
  2421 00000CEC C8060000                 ENTER  6,0
  2422 00000CF0 B8BC76                   mov ax, LabelNames
  2423 00000CF3 8946FC                   mov word [bp-4], ax
  2424                                  
  2425                                  ;-46   LIx=1;
  2426                                  
  2427 00000CF6 66B801000000             mov eax, 1
  2428 00000CFC 8946FE                   mov word [bp-2], ax
  2429                                  
  2430                                  ;-47   while (LIx <= LabelMaxIx) {
  2431                                  
  2432                                  @@searchLabel89:
  2433 00000CFF 8B46FE                   mov ax, [bp-2]
  2434 00000D02 3B06[5000]               cmp ax, [LabelMaxIx]
  2435 00000D06 0F8F3700                 jg  @@searchLabel90
  2436                                  
  2437                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2438                                  
  2439 00000D0A 8D063075                 lea  ax, [Symbol]
  2440 00000D0E 50                       push ax
  2441 00000D0F FF76FC                   push word [bp-4]
  2442 00000D12 E8B412                   call eqstr
  2443 00000D15 83C404                   add  sp, 4
  2444 00000D18 08C0                     or  al, al
  2445 00000D1A 0F840600                 je @@searchLabel91
  2446 00000D1E 8B46FE                   mov ax, [bp-2]
  2447 00000D21 E92600                   jmp @@retn
  2448                                  
  2449                                  ;-49     j=strlen(p);
  2450                                  
  2451                                  @@searchLabel91:
  2452 00000D24 FF76FC                   push word [bp-4]
  2453 00000D27 E80812                   call strlen
  2454 00000D2A 83C402                   add  sp, 2
  2455 00000D2D 8946FA                   mov word [bp-6], ax
  2456                                  
  2457                                  ;-50     p=p+j; p++; LIx++;
  2458                                  
  2459 00000D30 8B46FC                   mov ax, [bp-4]
  2460 00000D33 0346FA                   add ax, [bp-6]
  2461 00000D36 8946FC                   mov word [bp-4], ax
  2462 00000D39 FF46FC                   inc  word [bp-4]
  2463 00000D3C FF46FE                   inc  word [bp-2]
  2464                                  
  2465                                  ;-51   }
  2466                                  
  2467                                  
  2468                                  ;-52   return 0;
  2469                                  
  2470 00000D3F EBBE                     jmp @@searchLabel89
  2471                                  @@searchLabel90:
  2472 00000D41 66B800000000             mov eax, 0
  2473 00000D47 E90000                   jmp @@retn
  2474                                  
  2475                                  ;-53 }
  2476                                  
  2477                                  
  2478                                  ;-54 int getVariable() { char c;
  2479                                  
  2480 00000D4A C9                      @@retn: LEAVE
  2481 00000D4B C3                       ret
  2482                                  ; ENDP
  2483                                  
  2484                                  getVariable:  ; *** PROC ***
  2485                                  
  2486                                  ;-55   storeLabel();
  2487                                  
  2488                                  ;Function : getVariable, Number of local variables: 1
  2489                                  ;   # type sign width line used address name   list of local variables
  2490                                  ;  200 var sign byte    54 NULL bp-2    c;
  2491 00000D4C C8020000                 ENTER  2,0
  2492 00000D50 E84FFF                   call storeLabel
  2493                                  
  2494                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2495                                  
  2496 00000D53 E8AEFE                   call getTokeType
  2497 00000D56 A0[3B00]                 mov al, [TokeType]
  2498 00000D59 3C03                     cmp al, 3
  2499 00000D5B 0F85CC00                 jne @@getVariable92
  2500                                  
  2501                                  ;-57     lookCode();
  2502                                  
  2503 00000D5F E82201                   call lookCode
  2504                                  
  2505                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2506                                  
  2507 00000D62 A0[3D00]                 mov al, [CodeType]
  2508 00000D65 3CC8                     cmp al, 200
  2509 00000D67 0F8D0900                 jge @@getVariable93
  2510 00000D6B 68[360E]                 push getVariable_0
  2511 00000D6E E8020D                   call errorexit
  2512 00000D71 83C402                   add  sp, 2
  2513                                  
  2514                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2515                                  
  2516                                  @@getVariable93:
  2517 00000D74 A0[3D00]                 mov al, [CodeType]
  2518 00000D77 3CCF                     cmp al, 207
  2519 00000D79 0F8E0900                 jle @@getVariable94
  2520 00000D7D 68[4E0E]                 push getVariable_1
  2521 00000D80 E8F00C                   call errorexit
  2522 00000D83 83C402                   add  sp, 2
  2523                                  
  2524                                  ;-60     if (CodeType== 200) {// DB
  2525                                  
  2526                                  @@getVariable94:
  2527 00000D86 A0[3D00]                 mov al, [CodeType]
  2528 00000D89 3CC8                     cmp al, 200
  2529 00000D8B 0F856A00                 jne @@getVariable95
  2530                                  
  2531                                  ;-61       do { getTokeType();
  2532                                  
  2533                                  @@getVariable96:
  2534 00000D8F E872FE                   call getTokeType
  2535                                  
  2536                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2537                                  
  2538 00000D92 A0[3B00]                 mov al, [TokeType]
  2539 00000D95 3C01                     cmp al, 1
  2540 00000D97 0F850D00                 jne @@getVariable97
  2541 00000D9B FF36[2500]               push word [SymbolInt]
  2542 00000D9F E8F3FB                   call genCode8
  2543 00000DA2 83C402                   add  sp, 2
  2544                                  
  2545                                  ;-63         else {
  2546                                  
  2547 00000DA5 E94100                   jmp @@getVariable98
  2548                                  @@getVariable97:
  2549                                  
  2550                                  ;-64           skipBlank();
  2551                                  
  2552 00000DA8 E80703                   call skipBlank
  2553                                  
  2554                                  ;-65           if (isToken('"')) {
  2555                                  
  2556 00000DAB 6A22                     push 34
  2557 00000DAD E8D101                   call isToken
  2558 00000DB0 83C402                   add  sp, 2
  2559 00000DB3 08C0                     or  al, al
  2560 00000DB5 0F843000                 je @@getVariable99
  2561                                  
  2562                                  ;-66             do { c= *InputPtr;
  2563                                  
  2564                                  @@getVariable100:
  2565 00000DB9 8B1E[2700]               mov bx, [InputPtr]
  2566 00000DBD 8A07                     mov al, [bx]
  2567 00000DBF B400                     mov ah, 0
  2568 00000DC1 8846FE                   mov byte [bp-2], al
  2569                                  
  2570                                  ;-67               genCode8(c);
  2571                                  
  2572 00000DC4 8A46FE                   mov al, byte [bp-2]
  2573 00000DC7 B400                     mov ah, 0
  2574 00000DC9 50                       push ax
  2575 00000DCA E8C8FB                   call genCode8
  2576 00000DCD 83C402                   add  sp, 2
  2577                                  
  2578                                  ;-68               InputPtr++;
  2579                                  
  2580 00000DD0 FF06[2700]               inc  word [InputPtr]
  2581                                  
  2582                                  ;-69             } while (*InputPtr != '"' );
  2583                                  
  2584 00000DD4 8B1E[2700]               mov bx, [InputPtr]
  2585 00000DD8 8A07                     mov al, [bx]
  2586 00000DDA B400                     mov ah, 0
  2587 00000DDC 83F822                   cmp ax, 34
  2588 00000DDF 0F840200                 je  @@getVariable101
  2589 00000DE3 EBD4                     jmp @@getVariable100
  2590                                  @@getVariable101:
  2591                                  
  2592                                  ;-70             InputPtr++;
  2593                                  
  2594 00000DE5 FF06[2700]               inc  word [InputPtr]
  2595                                  
  2596                                  ;-71           }
  2597                                  
  2598                                  
  2599                                  ;-72         }
  2600                                  
  2601                                  @@getVariable99:
  2602                                  
  2603                                  ;-73       } while (isToken(','));
  2604                                  
  2605                                  @@getVariable98:
  2606 00000DE9 6A2C                     push 44
  2607 00000DEB E89301                   call isToken
  2608 00000DEE 83C402                   add  sp, 2
  2609 00000DF1 08C0                     or  al, al
  2610 00000DF3 0F840200                 je @@getVariable102
  2611 00000DF7 EB96                     jmp @@getVariable96
  2612                                  @@getVariable102:
  2613                                  
  2614                                  ;-74     }
  2615                                  
  2616                                  
  2617                                  ;-75     if (CodeType== 201) {// DW
  2618                                  
  2619                                  @@getVariable95:
  2620 00000DF9 A0[3D00]                 mov al, [CodeType]
  2621 00000DFC 3CC9                     cmp al, 201
  2622 00000DFE 0F852600                 jne @@getVariable103
  2623                                  
  2624                                  ;-76       do { getTokeType();
  2625                                  
  2626                                  @@getVariable104:
  2627 00000E02 E8FFFD                   call getTokeType
  2628                                  
  2629                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2630                                  
  2631 00000E05 A0[3B00]                 mov al, [TokeType]
  2632 00000E08 3C01                     cmp al, 1
  2633 00000E0A 0F850A00                 jne @@getVariable105
  2634 00000E0E FF36[2500]               push word [SymbolInt]
  2635 00000E12 E8B2FB                   call genCode16
  2636 00000E15 83C402                   add  sp, 2
  2637                                  
  2638                                  ;-78       } while (isToken(','));
  2639                                  
  2640                                  @@getVariable105:
  2641 00000E18 6A2C                     push 44
  2642 00000E1A E86401                   call isToken
  2643 00000E1D 83C402                   add  sp, 2
  2644 00000E20 08C0                     or  al, al
  2645 00000E22 0F840200                 je @@getVariable106
  2646 00000E26 EBDA                     jmp @@getVariable104
  2647                                  @@getVariable106:
  2648                                  
  2649                                  ;-79     }
  2650                                  
  2651                                  
  2652                                  ;-80   }
  2653                                  
  2654                                  @@getVariable103:
  2655                                  
  2656                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2657                                  
  2658 00000E28 E90900                   jmp @@getVariable107
  2659                                  @@getVariable92:
  2660 00000E2B 68[660E]                 push getVariable_2
  2661 00000E2E E8420C                   call errorexit
  2662 00000E31 83C402                   add  sp, 2
  2663                                  
  2664                                  ;-82 }
  2665                                  
  2666                                  @@getVariable107:
  2667                                  
  2668                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2669 00000E34 C9                       LEAVE
  2670 00000E35 C3                       ret
  2671                                  ; ENDP
  2672 00000E36 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2673 00000E3F 422C572C4420657870-
  2674 00000E48 656374656400       
  2675 00000E4E 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2676 00000E57 422C572C4420657870-
  2677 00000E60 656374656400       
  2678 00000E66 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2679 00000E6F 6F7220524553422C57-
  2680 00000E78 2C4420657870656374-
  2681 00000E81 656400             
  2682                                  
  2683                                  lookCode:  ; *** PROC ***
  2684                                  
  2685                                  ;-84   CodeType=0;
  2686                                  
  2687 00000E84 66B800000000             mov eax, 0
  2688 00000E8A A2[3D00]                 mov byte [CodeType], al
  2689                                  
  2690                                  ;-85   OpCodePtr= &I_START;
  2691                                  
  2692 00000E8D B8[5A00]                 mov ax, I_START
  2693 00000E90 A3[4B00]                 mov word [OpCodePtr], ax
  2694                                  
  2695                                  ;-86   OpCodePtr++;
  2696                                  
  2697 00000E93 FF06[4B00]               inc  word [OpCodePtr]
  2698                                  
  2699                                  ;-87   do  {
  2700                                  
  2701                                  @@lookCode108:
  2702                                  
  2703                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2704                                  
  2705 00000E97 FF36[4B00]               push word [OpCodePtr]
  2706 00000E9B 8D064F75                 lea  ax, [SymbolUpper]
  2707 00000E9F 50                       push ax
  2708 00000EA0 E82611                   call eqstr
  2709 00000EA3 83C404                   add  sp, 4
  2710 00000EA6 08C0                     or  al, al
  2711 00000EA8 0F842700                 je @@lookCode109
  2712                                  
  2713                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2714                                  
  2715                                  @@lookCode110:
  2716 00000EAC 8B1E[4B00]               mov bx, [OpCodePtr]
  2717 00000EB0 8A07                     mov al, [bx]
  2718 00000EB2 B400                     mov ah, 0
  2719 00000EB4 83F800                   cmp ax, 0
  2720 00000EB7 0F840600                 je  @@lookCode111
  2721 00000EBB FF06[4B00]               inc  word [OpCodePtr]
  2722                                  
  2723                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2724                                  
  2725 00000EBF EBEB                     jmp @@lookCode110
  2726                                  @@lookCode111:
  2727 00000EC1 FF06[4B00]               inc  word [OpCodePtr]
  2728 00000EC5 8B1E[4B00]               mov bx, [OpCodePtr]
  2729 00000EC9 8A07                     mov al, [bx]
  2730 00000ECB B400                     mov ah, 0
  2731 00000ECD A2[3D00]                 mov byte [CodeType], al
  2732                                  
  2733                                  ;-91       return;
  2734                                  
  2735 00000ED0 E92A00                   jmp @@retn
  2736                                  
  2737                                  ;-92     }
  2738                                  
  2739                                  
  2740                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2741                                  
  2742                                  @@lookCode109:
  2743                                  @@lookCode112:
  2744 00000ED3 8B1E[4B00]               mov bx, [OpCodePtr]
  2745 00000ED7 8A07                     mov al, [bx]
  2746 00000ED9 B400                     mov ah, 0
  2747 00000EDB 3DF100                   cmp ax, 241
  2748 00000EDE 0F840600                 je  @@lookCode113
  2749 00000EE2 FF06[4B00]               inc  word [OpCodePtr]
  2750                                  
  2751                                  ;-94   OpCodePtr++;
  2752                                  
  2753 00000EE6 EBEB                     jmp @@lookCode112
  2754                                  @@lookCode113:
  2755 00000EE8 FF06[4B00]               inc  word [OpCodePtr]
  2756                                  
  2757                                  ;-95   } while(*OpCodePtr!=0);
  2758                                  
  2759 00000EEC 8B1E[4B00]               mov bx, [OpCodePtr]
  2760 00000EF0 8A07                     mov al, [bx]
  2761 00000EF2 B400                     mov ah, 0
  2762 00000EF4 83F800                   cmp ax, 0
  2763 00000EF7 0F840200                 je  @@lookCode114
  2764 00000EFB EB9A                     jmp @@lookCode108
  2765                                  @@lookCode114:
  2766                                  
  2767                                  ;-96 }
  2768                                  
  2769                                  
  2770                                  ;-97 int getCodeSize() {
  2771                                  
  2772                                  @@retn:
  2773 00000EFD C3                       ret
  2774                                  ; ENDP
  2775                                  
  2776                                  getCodeSize:  ; *** PROC ***
  2777                                  
  2778                                  ;-98   if (TokeType ==ALNUME) {
  2779                                  
  2780 00000EFE A0[3B00]                 mov al, [TokeType]
  2781 00000F01 3C03                     cmp al, 3
  2782 00000F03 0F856000                 jne @@getCodeSize115
  2783                                  
  2784                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2785                                  
  2786 00000F07 68[710F]                 push getCodeSize_0
  2787 00000F0A 8D064F75                 lea  ax, [SymbolUpper]
  2788 00000F0E 50                       push ax
  2789 00000F0F E8B710                   call eqstr
  2790 00000F12 83C404                   add  sp, 4
  2791 00000F15 08C0                     or  al, al
  2792 00000F17 0F840C00                 je @@getCodeSize116
  2793 00000F1B E8E6FC                   call getTokeType
  2794 00000F1E 66B801000000             mov eax, 1
  2795 00000F24 E94900                   jmp @@retn
  2796                                  
  2797                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2798                                  
  2799                                  @@getCodeSize116:
  2800 00000F27 68[760F]                 push getCodeSize_1
  2801 00000F2A 8D064F75                 lea  ax, [SymbolUpper]
  2802 00000F2E 50                       push ax
  2803 00000F2F E89710                   call eqstr
  2804 00000F32 83C404                   add  sp, 4
  2805 00000F35 08C0                     or  al, al
  2806 00000F37 0F840C00                 je @@getCodeSize117
  2807 00000F3B E8C6FC                   call getTokeType
  2808 00000F3E 66B802000000             mov eax, 2
  2809 00000F44 E92900                   jmp @@retn
  2810                                  
  2811                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2812                                  
  2813                                  @@getCodeSize117:
  2814 00000F47 68[7B0F]                 push getCodeSize_2
  2815 00000F4A 8D064F75                 lea  ax, [SymbolUpper]
  2816 00000F4E 50                       push ax
  2817 00000F4F E87710                   call eqstr
  2818 00000F52 83C404                   add  sp, 4
  2819 00000F55 08C0                     or  al, al
  2820 00000F57 0F840C00                 je @@getCodeSize118
  2821 00000F5B E8A6FC                   call getTokeType
  2822 00000F5E 66B803000000             mov eax, 3
  2823 00000F64 E90900                   jmp @@retn
  2824                                  
  2825                                  ;-102   } return 0;
  2826                                  
  2827                                  @@getCodeSize118:
  2828                                  @@getCodeSize115:
  2829 00000F67 66B800000000             mov eax, 0
  2830 00000F6D E90000                   jmp @@retn
  2831                                  
  2832                                  ;-103 }
  2833                                  
  2834                                  
  2835                                  ;-104 int isToken(char c) {
  2836                                  
  2837                                  @@retn:
  2838 00000F70 C3                       ret
  2839                                  ; ENDP
  2840 00000F71 4259544500              getCodeSize_0 db "BYTE",0
  2841 00000F76 574F524400              getCodeSize_1 db "WORD",0
  2842 00000F7B 44574F524400            getCodeSize_2 db "DWORD",0
  2843                                  
  2844                                  isToken:  ; *** PROC ***
  2845                                  
  2846                                  ;-105   skipBlank();
  2847                                  
  2848                                  ;Function : isToken, Number of local variables: 1
  2849                                  ;   # type sign width line used address name   list of local variables
  2850                                  ;  200 var sign byte   104 NULL bp+4    c;
  2851 00000F81 C8000000                 ENTER  0,0
  2852 00000F85 E82A01                   call skipBlank
  2853                                  
  2854                                  ;-106   if (*InputPtr == c) {
  2855                                  
  2856 00000F88 8B1E[2700]               mov bx, [InputPtr]
  2857 00000F8C 8A07                     mov al, [bx]
  2858 00000F8E B400                     mov ah, 0
  2859 00000F90 3A4604                   cmp al, [bp+4]
  2860 00000F93 0F850D00                 jne @@isToken119
  2861                                  
  2862                                  ;-107     InputPtr++; return 1;} return 0;
  2863                                  
  2864 00000F97 FF06[2700]               inc  word [InputPtr]
  2865 00000F9B 66B801000000             mov eax, 1
  2866 00000FA1 E90900                   jmp @@retn
  2867                                  @@isToken119:
  2868 00000FA4 66B800000000             mov eax, 0
  2869 00000FAA E90000                   jmp @@retn
  2870                                  
  2871                                  ;-108 }
  2872                                  
  2873                                  
  2874                                  ;-109 int skipRest() {
  2875                                  
  2876 00000FAD C9                      @@retn: LEAVE
  2877 00000FAE C3                       ret
  2878                                  ; ENDP
  2879                                  
  2880                                  skipRest:  ; *** PROC ***
  2881                                  
  2882                                  ;-110   getTokeType(); if(TokeType!=0)prs("\n; ******** extra char ignored");
  2883                                  
  2884 00000FAF E852FC                   call getTokeType
  2885 00000FB2 A0[3B00]                 mov al, [TokeType]
  2886 00000FB5 3C00                     cmp al, 0
  2887 00000FB7 0F840900                 je  @@skipRest120
  2888 00000FBB 68[C50F]                 push skipRest_0
  2889 00000FBE E82408                   call prs
  2890 00000FC1 83C402                   add  sp, 2
  2891                                  
  2892                                  ;-111 }
  2893                                  
  2894                                  @@skipRest120:
  2895 00000FC4 C3                       ret
  2896                                  ; ENDP
  2897 00000FC5 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ******** extra char ignored",0
  2898 00000FCE 2A2A2A206578747261-
  2899 00000FD7 20636861722069676E-
  2900 00000FE0 6F72656400         
  2901                                  ;Back to main program: AS.C
  2902                                  
  2903                                  ;-184 #include "HELPER.C"
  2904                                  
  2905                                  ;Use include file: HELPER.C
  2906                                  
  2907                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2908                                  
  2909                                  
  2910                                  getLine:  ; *** PROC ***
  2911                                  
  2912                                  ;-2   InputPtr= &InputBuf;
  2913                                  
  2914 00000FE5 B86E75                   mov ax, InputBuf
  2915 00000FE8 A3[2700]                 mov word [InputPtr], ax
  2916                                  
  2917                                  ;-3   *InputPtr=0;//if last line is empty
  2918                                  
  2919 00000FEB 66B800000000             mov eax, 0
  2920 00000FF1 8B1E[2700]               mov  bx, [InputPtr]
  2921 00000FF5 8807                     mov  [bx], al
  2922                                  
  2923                                  ;-4   do {
  2924                                  
  2925                                  @@getLine121:
  2926                                  
  2927                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2928                                  
  2929 00000FF7 6A01                     push 1
  2930 00000FF9 FF36[2900]               push word [asm_fd]
  2931 00000FFD 8D06[3500]               lea  ax, [DOS_ByteRead]
  2932 00001001 50                       push ax
  2933 00001002 E85F10                   call readRL
  2934 00001005 83C406                   add  sp, 6
  2935 00001008 A3[3300]                 mov word [DOS_NoBytes], ax
  2936                                  
  2937                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  2938                                  
  2939 0000100B A1[2F00]                 mov ax, [DOS_ERR]
  2940 0000100E 08C0                     or  al, al
  2941 00001010 0F840900                 je @@getLine122
  2942 00001014 68[5C10]                 push getLine_0
  2943 00001017 E8590A                   call errorexit
  2944 0000101A 83C402                   add  sp, 2
  2945                                  
  2946                                  ;-7     if (DOS_NoBytes == 0) return;
  2947                                  
  2948                                  @@getLine122:
  2949 0000101D A1[3300]                 mov ax, [DOS_NoBytes]
  2950 00001020 83F800                   cmp ax, 0
  2951 00001023 0F850300                 jne @@getLine123
  2952 00001027 E93100                   jmp @@retn
  2953                                  
  2954                                  ;-8     *InputPtr = DOS_ByteRead;
  2955                                  
  2956                                  @@getLine123:
  2957 0000102A A0[3500]                 mov al, [DOS_ByteRead]
  2958 0000102D 8B1E[2700]               mov  bx, [InputPtr]
  2959 00001031 8807                     mov  [bx], al
  2960                                  
  2961                                  ;-9     InputPtr++;
  2962                                  
  2963 00001033 FF06[2700]               inc  word [InputPtr]
  2964                                  
  2965                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  2966                                  
  2967 00001037 A0[3500]                 mov al, byte [DOS_ByteRead]
  2968 0000103A B400                     mov ah, 0
  2969 0000103C 50                       push ax
  2970 0000103D E82B00                   call ifEOL
  2971 00001040 83C402                   add  sp, 2
  2972 00001043 3C00                     cmp al, 0
  2973 00001045 0F850200                 jne @@getLine124
  2974 00001049 EBAC                     jmp @@getLine121
  2975                                  @@getLine124:
  2976                                  
  2977                                  ;-11   InputPtr--;
  2978                                  
  2979 0000104B FF0E[2700]               dec  word [InputPtr]
  2980                                  
  2981                                  ;-12   *InputPtr=0;
  2982                                  
  2983 0000104F 66B800000000             mov eax, 0
  2984 00001055 8B1E[2700]               mov  bx, [InputPtr]
  2985 00001059 8807                     mov  [bx], al
  2986                                  
  2987                                  ;-13 }
  2988                                  
  2989                                  
  2990                                  ;-14 int ifEOL(char c) {
  2991                                  
  2992                                  @@retn:
  2993 0000105B C3                       ret
  2994                                  ; ENDP
  2995 0000105C 52656164696E672053-     getLine_0 db "Reading Source",0
  2996 00001065 6F7572636500       
  2997                                  
  2998                                  ifEOL:  ; *** PROC ***
  2999                                  
  3000                                  ;-15   if (c == 10) return 1;
  3001                                  
  3002                                  ;Function : ifEOL, Number of local variables: 1
  3003                                  ;   # type sign width line used address name   list of local variables
  3004                                  ;  200 var sign byte    14 NULL bp+4    c;
  3005 0000106B C8000000                 ENTER  0,0
  3006 0000106F 8A4604                   mov al, [bp+4]
  3007 00001072 3C0A                     cmp al, 10
  3008 00001074 0F850900                 jne @@ifEOL125
  3009 00001078 66B801000000             mov eax, 1
  3010 0000107E E92F00                   jmp @@retn
  3011                                  
  3012                                  ;-16   if (c == 13) {
  3013                                  
  3014                                  @@ifEOL125:
  3015 00001081 8A4604                   mov al, [bp+4]
  3016 00001084 3C0D                     cmp al, 13
  3017 00001086 0F851D00                 jne @@ifEOL126
  3018                                  
  3019                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3020                                  
  3021 0000108A 6A01                     push 1
  3022 0000108C FF36[2900]               push word [asm_fd]
  3023 00001090 8D06[3500]               lea  ax, [DOS_ByteRead]
  3024 00001094 50                       push ax
  3025 00001095 E8CC0F                   call readRL
  3026 00001098 83C406                   add  sp, 6
  3027 0000109B A3[3300]                 mov word [DOS_NoBytes], ax
  3028                                  
  3029                                  ;-18     return 1;}
  3030                                  
  3031 0000109E 66B801000000             mov eax, 1
  3032 000010A4 E90900                   jmp @@retn
  3033                                  
  3034                                  ;-19   return 0;
  3035                                  
  3036                                  @@ifEOL126:
  3037 000010A7 66B800000000             mov eax, 0
  3038 000010AD E90000                   jmp @@retn
  3039                                  
  3040                                  ;-20 }
  3041                                  
  3042                                  
  3043                                  ;-21 int skipBlank() {
  3044                                  
  3045 000010B0 C9                      @@retn: LEAVE
  3046 000010B1 C3                       ret
  3047                                  ; ENDP
  3048                                  
  3049                                  skipBlank:  ; *** PROC ***
  3050                                  
  3051                                  ;-22   skipblank1:
  3052                                  
  3053                                  @@skipblank1:
  3054                                  
  3055                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3056                                  
  3057 000010B2 8B1E[2700]               mov bx, [InputPtr]
  3058 000010B6 8A07                     mov al, [bx]
  3059 000010B8 B400                     mov ah, 0
  3060 000010BA 83F820                   cmp ax, 32
  3061 000010BD 0F850600                 jne @@skipBlank127
  3062 000010C1 FF06[2700]               inc  word [InputPtr]
  3063 000010C5 EBEB                     jmp @@skipblank1
  3064                                  
  3065                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3066                                  
  3067                                  @@skipBlank127:
  3068 000010C7 8B1E[2700]               mov bx, [InputPtr]
  3069 000010CB 8A07                     mov al, [bx]
  3070 000010CD B400                     mov ah, 0
  3071 000010CF 83F809                   cmp ax, 9
  3072 000010D2 0F850600                 jne @@skipBlank128
  3073 000010D6 FF06[2700]               inc  word [InputPtr]
  3074 000010DA EBD6                     jmp @@skipblank1
  3075                                  
  3076                                  ;-25 }
  3077                                  
  3078                                  @@skipBlank128:
  3079                                  
  3080                                  ;-26 int letterE(char c) {
  3081                                  
  3082 000010DC C3                       ret
  3083                                  ; ENDP
  3084                                  
  3085                                  letterE:  ; *** PROC ***
  3086                                  
  3087                                  ;-27   if (c=='_') return 1;
  3088                                  
  3089                                  ;Function : letterE, Number of local variables: 1
  3090                                  ;   # type sign width line used address name   list of local variables
  3091                                  ;  200 var sign byte    26 NULL bp+4    c;
  3092 000010DD C8000000                 ENTER  0,0
  3093 000010E1 8A4604                   mov al, [bp+4]
  3094 000010E4 3C5F                     cmp al, 95
  3095 000010E6 0F850900                 jne @@letterE129
  3096 000010EA 66B801000000             mov eax, 1
  3097 000010F0 E97E00                   jmp @@retn
  3098                                  
  3099                                  ;-28   if (c=='.') return 1;
  3100                                  
  3101                                  @@letterE129:
  3102 000010F3 8A4604                   mov al, [bp+4]
  3103 000010F6 3C2E                     cmp al, 46
  3104 000010F8 0F850900                 jne @@letterE130
  3105 000010FC 66B801000000             mov eax, 1
  3106 00001102 E96C00                   jmp @@retn
  3107                                  
  3108                                  ;-29   if (c=='?') return 1;
  3109                                  
  3110                                  @@letterE130:
  3111 00001105 8A4604                   mov al, [bp+4]
  3112 00001108 3C3F                     cmp al, 63
  3113 0000110A 0F850900                 jne @@letterE131
  3114 0000110E 66B801000000             mov eax, 1
  3115 00001114 E95A00                   jmp @@retn
  3116                                  
  3117                                  ;-30   if (c=='$') return 1;
  3118                                  
  3119                                  @@letterE131:
  3120 00001117 8A4604                   mov al, [bp+4]
  3121 0000111A 3C24                     cmp al, 36
  3122 0000111C 0F850900                 jne @@letterE132
  3123 00001120 66B801000000             mov eax, 1
  3124 00001126 E94800                   jmp @@retn
  3125                                  
  3126                                  ;-31   if (c> 'z') return 0;
  3127                                  
  3128                                  @@letterE132:
  3129 00001129 8A4604                   mov al, [bp+4]
  3130 0000112C 3C7A                     cmp al, 122
  3131 0000112E 0F8E0900                 jle @@letterE133
  3132 00001132 66B800000000             mov eax, 0
  3133 00001138 E93600                   jmp @@retn
  3134                                  
  3135                                  ;-32   if (c< '@') return 0; // at included
  3136                                  
  3137                                  @@letterE133:
  3138 0000113B 8A4604                   mov al, [bp+4]
  3139 0000113E 3C40                     cmp al, 64
  3140 00001140 0F8D0900                 jge @@letterE134
  3141 00001144 66B800000000             mov eax, 0
  3142 0000114A E92400                   jmp @@retn
  3143                                  
  3144                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3145                                  
  3146                                  @@letterE134:
  3147 0000114D 8A4604                   mov al, [bp+4]
  3148 00001150 3C5A                     cmp al, 90
  3149 00001152 0F8E1200                 jle @@letterE135
  3150 00001156 8A4604                   mov al, [bp+4]
  3151 00001159 3C61                     cmp al, 97
  3152 0000115B 0F8D0900                 jge @@letterE136
  3153 0000115F 66B800000000             mov eax, 0
  3154 00001165 E90900                   jmp @@retn
  3155                                  @@letterE136:
  3156                                  
  3157                                  ;-34   return 1;
  3158                                  
  3159                                  @@letterE135:
  3160 00001168 66B801000000             mov eax, 1
  3161 0000116E E90000                   jmp @@retn
  3162                                  
  3163                                  ;-35 }
  3164                                  
  3165                                  
  3166                                  ;-36 int alnumE(char c) {
  3167                                  
  3168 00001171 C9                      @@retn: LEAVE
  3169 00001172 C3                       ret
  3170                                  ; ENDP
  3171                                  
  3172                                  alnumE:  ; *** PROC ***
  3173                                  
  3174                                  ;-37   if (digit(c)) return 1;
  3175                                  
  3176                                  ;Function : alnumE, Number of local variables: 1
  3177                                  ;   # type sign width line used address name   list of local variables
  3178                                  ;  200 var sign byte    36 NULL bp+4    c;
  3179 00001173 C8000000                 ENTER  0,0
  3180 00001177 8A4604                   mov al, byte [bp+4]
  3181 0000117A B400                     mov ah, 0
  3182 0000117C 50                       push ax
  3183 0000117D E8160E                   call digit
  3184 00001180 83C402                   add  sp, 2
  3185 00001183 08C0                     or  al, al
  3186 00001185 0F840900                 je @@alnumE137
  3187 00001189 66B801000000             mov eax, 1
  3188 0000118F E92400                   jmp @@retn
  3189                                  
  3190                                  ;-38   if (letterE(c)) return 1;
  3191                                  
  3192                                  @@alnumE137:
  3193 00001192 8A4604                   mov al, byte [bp+4]
  3194 00001195 B400                     mov ah, 0
  3195 00001197 50                       push ax
  3196 00001198 E842FF                   call letterE
  3197 0000119B 83C402                   add  sp, 2
  3198 0000119E 08C0                     or  al, al
  3199 000011A0 0F840900                 je @@alnumE138
  3200 000011A4 66B801000000             mov eax, 1
  3201 000011AA E90900                   jmp @@retn
  3202                                  
  3203                                  ;-39   return 0;
  3204                                  
  3205                                  @@alnumE138:
  3206 000011AD 66B800000000             mov eax, 0
  3207 000011B3 E90000                   jmp @@retn
  3208                                  
  3209                                  ;-40 }
  3210                                  
  3211                                  
  3212                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3213                                  
  3214 000011B6 C9                      @@retn: LEAVE
  3215 000011B7 C3                       ret
  3216                                  ; ENDP
  3217                                  
  3218                                  getDigit:  ; *** PROC ***
  3219                                  
  3220                                  ;-42   unsigned int CastInt;
  3221                                  
  3222                                  
  3223                                  ;-43   SymbolInt=0;
  3224                                  
  3225                                  ;Function : getDigit, Number of local variables: 2
  3226                                  ;   # type sign width line used address name   list of local variables
  3227                                  ;  200 var unsg byte    41 NULL bp+4    c
  3228                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3229 000011B8 C8020000                 ENTER  2,0
  3230 000011BC 66B800000000             mov eax, 0
  3231 000011C2 A3[2500]                 mov word [SymbolInt], ax
  3232                                  
  3233                                  ;-44   do {
  3234                                  
  3235                                  @@getDigit139:
  3236                                  
  3237                                  ;-45     c-='0';
  3238                                  
  3239 000011C5 806E0430                 sub  byte [bp+4], 48
  3240                                  
  3241                                  ;-46     SymbolInt=SymbolInt*10;
  3242                                  
  3243 000011C9 A1[2500]                 mov ax, [SymbolInt]
  3244 000011CC 66BB0A000000             mov ebx, 10
  3245 000011D2 66F7E3                   mul ebx
  3246 000011D5 A3[2500]                 mov word [SymbolInt], ax
  3247                                  
  3248                                  ;-47     ax=0; CastInt=c; //cast b2w
  3249                                  
  3250 000011D8 B80000                   mov  ax, 0
  3251 000011DB 8A4604                   mov al, [bp+4]
  3252 000011DE 8946FE                   mov word [bp-2], ax
  3253                                  
  3254                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3255                                  
  3256 000011E1 A1[2500]                 mov ax, [SymbolInt]
  3257 000011E4 0346FE                   add ax, [bp-2]
  3258 000011E7 A3[2500]                 mov word [SymbolInt], ax
  3259                                  
  3260                                  ;-49     InputPtr++;
  3261                                  
  3262 000011EA FF06[2700]               inc  word [InputPtr]
  3263                                  
  3264                                  ;-50     c = *InputPtr;
  3265                                  
  3266 000011EE 8B1E[2700]               mov bx, [InputPtr]
  3267 000011F2 8A07                     mov al, [bx]
  3268 000011F4 B400                     mov ah, 0
  3269 000011F6 884604                   mov byte [bp+4], al
  3270                                  
  3271                                  ;-51   } while(digit(c));
  3272                                  
  3273 000011F9 8A4604                   mov al, byte [bp+4]
  3274 000011FC B400                     mov ah, 0
  3275 000011FE 50                       push ax
  3276 000011FF E8940D                   call digit
  3277 00001202 83C402                   add  sp, 2
  3278 00001205 08C0                     or  al, al
  3279 00001207 0F840200                 je @@getDigit140
  3280 0000120B EBB8                     jmp @@getDigit139
  3281                                  @@getDigit140:
  3282                                  
  3283                                  ;-52 }
  3284                                  
  3285                                  
  3286                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3287 0000120D C9                       LEAVE
  3288 0000120E C3                       ret
  3289                                  ; ENDP
  3290                                  
  3291                                  getName:  ; *** PROC ***
  3292                                  
  3293                                  ;-54   char *p;
  3294                                  
  3295                                  
  3296                                  ;-55   p = &Symbol;
  3297                                  
  3298                                  ;Function : getName, Number of local variables: 2
  3299                                  ;   # type sign width line used address name   list of local variables
  3300                                  ;  200 var unsg byte    53 NULL bp+4    c
  3301                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3302 0000120F C8020000                 ENTER  2,0
  3303 00001213 B83075                   mov ax, Symbol
  3304 00001216 8946FE                   mov word [bp-2], ax
  3305                                  
  3306                                  ;-56   *p = c;
  3307                                  
  3308 00001219 8A4604                   mov al, [bp+4]
  3309 0000121C 8B5EFE                   mov  bx, [bp-2]
  3310 0000121F 8807                     mov  [bx], al
  3311                                  
  3312                                  ;-57   p++;
  3313                                  
  3314 00001221 FF46FE                   inc  word [bp-2]
  3315                                  
  3316                                  ;-58   while (alnumE(c)) {
  3317                                  
  3318                                  @@getName141:
  3319 00001224 8A4604                   mov al, byte [bp+4]
  3320 00001227 B400                     mov ah, 0
  3321 00001229 50                       push ax
  3322 0000122A E846FF                   call alnumE
  3323 0000122D 83C402                   add  sp, 2
  3324 00001230 08C0                     or  al, al
  3325 00001232 0F841C00                 je @@getName142
  3326                                  
  3327                                  ;-59     InputPtr++;
  3328                                  
  3329 00001236 FF06[2700]               inc  word [InputPtr]
  3330                                  
  3331                                  ;-60     c = *InputPtr;
  3332                                  
  3333 0000123A 8B1E[2700]               mov bx, [InputPtr]
  3334 0000123E 8A07                     mov al, [bx]
  3335 00001240 B400                     mov ah, 0
  3336 00001242 884604                   mov byte [bp+4], al
  3337                                  
  3338                                  ;-61     *p = c;
  3339                                  
  3340 00001245 8A4604                   mov al, [bp+4]
  3341 00001248 8B5EFE                   mov  bx, [bp-2]
  3342 0000124B 8807                     mov  [bx], al
  3343                                  
  3344                                  ;-62     p++;
  3345                                  
  3346 0000124D FF46FE                   inc  word [bp-2]
  3347                                  
  3348                                  ;-63   }
  3349                                  
  3350                                  
  3351                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3352                                  
  3353 00001250 EBD2                     jmp @@getName141
  3354                                  @@getName142:
  3355 00001252 8A4604                   mov al, [bp+4]
  3356 00001255 3C3A                     cmp al, 58
  3357 00001257 0F850C00                 jne @@getName143
  3358 0000125B 66B801000000             mov eax, 1
  3359 00001261 A2[3A00]                 mov byte [isLabel], al
  3360 00001264 E90900                   jmp @@getName144
  3361                                  @@getName143:
  3362 00001267 66B800000000             mov eax, 0
  3363 0000126D A2[3A00]                 mov byte [isLabel], al
  3364                                  
  3365                                  ;-65   p--;
  3366                                  
  3367                                  @@getName144:
  3368 00001270 FF4EFE                   dec  word [bp-2]
  3369                                  
  3370                                  ;-66   *p = 0;
  3371                                  
  3372 00001273 66B800000000             mov eax, 0
  3373 00001279 8B5EFE                   mov  bx, [bp-2]
  3374 0000127C 8807                     mov  [bx], al
  3375                                  
  3376                                  ;-67   strcpy(SymbolUpper, Symbol);
  3377                                  
  3378 0000127E 8D063075                 lea  ax, [Symbol]
  3379 00001282 50                       push ax
  3380 00001283 8D064F75                 lea  ax, [SymbolUpper]
  3381 00001287 50                       push ax
  3382 00001288 E8D20C                   call strcpy
  3383 0000128B 83C404                   add  sp, 4
  3384                                  
  3385                                  ;-68   toupper(SymbolUpper);
  3386                                  
  3387 0000128E 8D064F75                 lea  ax, [SymbolUpper]
  3388 00001292 50                       push ax
  3389 00001293 E8590C                   call toupper
  3390 00001296 83C402                   add  sp, 2
  3391                                  
  3392                                  ;-69 }
  3393                                  
  3394                                  
  3395                                  ;-70 int testReg() {
  3396 00001299 C9                       LEAVE
  3397 0000129A C3                       ret
  3398                                  ; ENDP
  3399                                  
  3400                                  testReg:  ; *** PROC ***
  3401                                  
  3402                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3403                                  
  3404                                  
  3405                                  ;-72   RegType=0;
  3406                                  
  3407 0000129B 66B800000000             mov eax, 0
  3408 000012A1 A2[3E00]                 mov byte [RegType], al
  3409                                  
  3410                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3411                                  
  3412 000012A4 8D063075                 lea  ax, [Symbol]
  3413 000012A8 50                       push ax
  3414 000012A9 E8860C                   call strlen
  3415 000012AC 83C402                   add  sp, 2
  3416 000012AF 3C02                     cmp al, 2
  3417 000012B1 0F8D0900                 jge @@testReg145
  3418 000012B5 66B800000000             mov eax, 0
  3419 000012BB E9B603                   jmp @@retn
  3420                                  
  3421                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3422                                  
  3423                                  @@testReg145:
  3424 000012BE 8D063075                 lea  ax, [Symbol]
  3425 000012C2 50                       push ax
  3426 000012C3 E86C0C                   call strlen
  3427 000012C6 83C402                   add  sp, 2
  3428 000012C9 3C03                     cmp al, 3
  3429 000012CB 0F8E0900                 jle @@testReg146
  3430 000012CF 66B800000000             mov eax, 0
  3431 000012D5 E99C03                   jmp @@retn
  3432                                  
  3433                                  ;-75   RegType=BYTE;
  3434                                  
  3435                                  @@testReg146:
  3436 000012D8 66B801000000             mov eax, 1
  3437 000012DE A2[3E00]                 mov byte [RegType], al
  3438                                  
  3439                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3440                                  
  3441 000012E1 68[7516]                 push testReg_0
  3442 000012E4 8D064F75                 lea  ax, [SymbolUpper]
  3443 000012E8 50                       push ax
  3444 000012E9 E8DD0C                   call eqstr
  3445 000012EC 83C404                   add  sp, 4
  3446 000012EF 08C0                     or  al, al
  3447 000012F1 0F840900                 je @@testReg147
  3448 000012F5 66B800000000             mov eax, 0
  3449 000012FB E97603                   jmp @@retn
  3450                                  
  3451                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3452                                  
  3453                                  @@testReg147:
  3454 000012FE 68[7816]                 push testReg_1
  3455 00001301 8D064F75                 lea  ax, [SymbolUpper]
  3456 00001305 50                       push ax
  3457 00001306 E8C00C                   call eqstr
  3458 00001309 83C404                   add  sp, 4
  3459 0000130C 08C0                     or  al, al
  3460 0000130E 0F840900                 je @@testReg148
  3461 00001312 66B801000000             mov eax, 1
  3462 00001318 E95903                   jmp @@retn
  3463                                  
  3464                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3465                                  
  3466                                  @@testReg148:
  3467 0000131B 68[7B16]                 push testReg_2
  3468 0000131E 8D064F75                 lea  ax, [SymbolUpper]
  3469 00001322 50                       push ax
  3470 00001323 E8A30C                   call eqstr
  3471 00001326 83C404                   add  sp, 4
  3472 00001329 08C0                     or  al, al
  3473 0000132B 0F840900                 je @@testReg149
  3474 0000132F 66B802000000             mov eax, 2
  3475 00001335 E93C03                   jmp @@retn
  3476                                  
  3477                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3478                                  
  3479                                  @@testReg149:
  3480 00001338 68[7E16]                 push testReg_3
  3481 0000133B 8D064F75                 lea  ax, [SymbolUpper]
  3482 0000133F 50                       push ax
  3483 00001340 E8860C                   call eqstr
  3484 00001343 83C404                   add  sp, 4
  3485 00001346 08C0                     or  al, al
  3486 00001348 0F840900                 je @@testReg150
  3487 0000134C 66B803000000             mov eax, 3
  3488 00001352 E91F03                   jmp @@retn
  3489                                  
  3490                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3491                                  
  3492                                  @@testReg150:
  3493 00001355 68[8116]                 push testReg_4
  3494 00001358 8D064F75                 lea  ax, [SymbolUpper]
  3495 0000135C 50                       push ax
  3496 0000135D E8690C                   call eqstr
  3497 00001360 83C404                   add  sp, 4
  3498 00001363 08C0                     or  al, al
  3499 00001365 0F840900                 je @@testReg151
  3500 00001369 66B804000000             mov eax, 4
  3501 0000136F E90203                   jmp @@retn
  3502                                  
  3503                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3504                                  
  3505                                  @@testReg151:
  3506 00001372 68[8416]                 push testReg_5
  3507 00001375 8D064F75                 lea  ax, [SymbolUpper]
  3508 00001379 50                       push ax
  3509 0000137A E84C0C                   call eqstr
  3510 0000137D 83C404                   add  sp, 4
  3511 00001380 08C0                     or  al, al
  3512 00001382 0F840900                 je @@testReg152
  3513 00001386 66B805000000             mov eax, 5
  3514 0000138C E9E502                   jmp @@retn
  3515                                  
  3516                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3517                                  
  3518                                  @@testReg152:
  3519 0000138F 68[8716]                 push testReg_6
  3520 00001392 8D064F75                 lea  ax, [SymbolUpper]
  3521 00001396 50                       push ax
  3522 00001397 E82F0C                   call eqstr
  3523 0000139A 83C404                   add  sp, 4
  3524 0000139D 08C0                     or  al, al
  3525 0000139F 0F840900                 je @@testReg153
  3526 000013A3 66B806000000             mov eax, 6
  3527 000013A9 E9C802                   jmp @@retn
  3528                                  
  3529                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3530                                  
  3531                                  @@testReg153:
  3532 000013AC 68[8A16]                 push testReg_7
  3533 000013AF 8D064F75                 lea  ax, [SymbolUpper]
  3534 000013B3 50                       push ax
  3535 000013B4 E8120C                   call eqstr
  3536 000013B7 83C404                   add  sp, 4
  3537 000013BA 08C0                     or  al, al
  3538 000013BC 0F840900                 je @@testReg154
  3539 000013C0 66B807000000             mov eax, 7
  3540 000013C6 E9AB02                   jmp @@retn
  3541                                  
  3542                                  ;-84   RegType=WORD;
  3543                                  
  3544                                  @@testReg154:
  3545 000013C9 66B802000000             mov eax, 2
  3546 000013CF A2[3E00]                 mov byte [RegType], al
  3547                                  
  3548                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3549                                  
  3550 000013D2 68[8D16]                 push testReg_8
  3551 000013D5 8D064F75                 lea  ax, [SymbolUpper]
  3552 000013D9 50                       push ax
  3553 000013DA E8EC0B                   call eqstr
  3554 000013DD 83C404                   add  sp, 4
  3555 000013E0 08C0                     or  al, al
  3556 000013E2 0F840900                 je @@testReg155
  3557 000013E6 66B800000000             mov eax, 0
  3558 000013EC E98502                   jmp @@retn
  3559                                  
  3560                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3561                                  
  3562                                  @@testReg155:
  3563 000013EF 68[9016]                 push testReg_9
  3564 000013F2 8D064F75                 lea  ax, [SymbolUpper]
  3565 000013F6 50                       push ax
  3566 000013F7 E8CF0B                   call eqstr
  3567 000013FA 83C404                   add  sp, 4
  3568 000013FD 08C0                     or  al, al
  3569 000013FF 0F840900                 je @@testReg156
  3570 00001403 66B801000000             mov eax, 1
  3571 00001409 E96802                   jmp @@retn
  3572                                  
  3573                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3574                                  
  3575                                  @@testReg156:
  3576 0000140C 68[9316]                 push testReg_10
  3577 0000140F 8D064F75                 lea  ax, [SymbolUpper]
  3578 00001413 50                       push ax
  3579 00001414 E8B20B                   call eqstr
  3580 00001417 83C404                   add  sp, 4
  3581 0000141A 08C0                     or  al, al
  3582 0000141C 0F840900                 je @@testReg157
  3583 00001420 66B802000000             mov eax, 2
  3584 00001426 E94B02                   jmp @@retn
  3585                                  
  3586                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3587                                  
  3588                                  @@testReg157:
  3589 00001429 68[9616]                 push testReg_11
  3590 0000142C 8D064F75                 lea  ax, [SymbolUpper]
  3591 00001430 50                       push ax
  3592 00001431 E8950B                   call eqstr
  3593 00001434 83C404                   add  sp, 4
  3594 00001437 08C0                     or  al, al
  3595 00001439 0F840900                 je @@testReg158
  3596 0000143D 66B803000000             mov eax, 3
  3597 00001443 E92E02                   jmp @@retn
  3598                                  
  3599                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3600                                  
  3601                                  @@testReg158:
  3602 00001446 68[9916]                 push testReg_12
  3603 00001449 8D064F75                 lea  ax, [SymbolUpper]
  3604 0000144D 50                       push ax
  3605 0000144E E8780B                   call eqstr
  3606 00001451 83C404                   add  sp, 4
  3607 00001454 08C0                     or  al, al
  3608 00001456 0F840900                 je @@testReg159
  3609 0000145A 66B804000000             mov eax, 4
  3610 00001460 E91102                   jmp @@retn
  3611                                  
  3612                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3613                                  
  3614                                  @@testReg159:
  3615 00001463 68[9C16]                 push testReg_13
  3616 00001466 8D064F75                 lea  ax, [SymbolUpper]
  3617 0000146A 50                       push ax
  3618 0000146B E85B0B                   call eqstr
  3619 0000146E 83C404                   add  sp, 4
  3620 00001471 08C0                     or  al, al
  3621 00001473 0F840900                 je @@testReg160
  3622 00001477 66B805000000             mov eax, 5
  3623 0000147D E9F401                   jmp @@retn
  3624                                  
  3625                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3626                                  
  3627                                  @@testReg160:
  3628 00001480 68[9F16]                 push testReg_14
  3629 00001483 8D064F75                 lea  ax, [SymbolUpper]
  3630 00001487 50                       push ax
  3631 00001488 E83E0B                   call eqstr
  3632 0000148B 83C404                   add  sp, 4
  3633 0000148E 08C0                     or  al, al
  3634 00001490 0F840900                 je @@testReg161
  3635 00001494 66B806000000             mov eax, 6
  3636 0000149A E9D701                   jmp @@retn
  3637                                  
  3638                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3639                                  
  3640                                  @@testReg161:
  3641 0000149D 68[A216]                 push testReg_15
  3642 000014A0 8D064F75                 lea  ax, [SymbolUpper]
  3643 000014A4 50                       push ax
  3644 000014A5 E8210B                   call eqstr
  3645 000014A8 83C404                   add  sp, 4
  3646 000014AB 08C0                     or  al, al
  3647 000014AD 0F840900                 je @@testReg162
  3648 000014B1 66B807000000             mov eax, 7
  3649 000014B7 E9BA01                   jmp @@retn
  3650                                  
  3651                                  ;-93   RegType=SEGREG;
  3652                                  
  3653                                  @@testReg162:
  3654 000014BA 66B804000000             mov eax, 4
  3655 000014C0 A2[3E00]                 mov byte [RegType], al
  3656                                  
  3657                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3658                                  
  3659 000014C3 68[A516]                 push testReg_16
  3660 000014C6 8D064F75                 lea  ax, [SymbolUpper]
  3661 000014CA 50                       push ax
  3662 000014CB E8FB0A                   call eqstr
  3663 000014CE 83C404                   add  sp, 4
  3664 000014D1 08C0                     or  al, al
  3665 000014D3 0F840900                 je @@testReg163
  3666 000014D7 66B800000000             mov eax, 0
  3667 000014DD E99401                   jmp @@retn
  3668                                  
  3669                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3670                                  
  3671                                  @@testReg163:
  3672 000014E0 68[A816]                 push testReg_17
  3673 000014E3 8D064F75                 lea  ax, [SymbolUpper]
  3674 000014E7 50                       push ax
  3675 000014E8 E8DE0A                   call eqstr
  3676 000014EB 83C404                   add  sp, 4
  3677 000014EE 08C0                     or  al, al
  3678 000014F0 0F840900                 je @@testReg164
  3679 000014F4 66B801000000             mov eax, 1
  3680 000014FA E97701                   jmp @@retn
  3681                                  
  3682                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3683                                  
  3684                                  @@testReg164:
  3685 000014FD 68[AB16]                 push testReg_18
  3686 00001500 8D064F75                 lea  ax, [SymbolUpper]
  3687 00001504 50                       push ax
  3688 00001505 E8C10A                   call eqstr
  3689 00001508 83C404                   add  sp, 4
  3690 0000150B 08C0                     or  al, al
  3691 0000150D 0F840900                 je @@testReg165
  3692 00001511 66B802000000             mov eax, 2
  3693 00001517 E95A01                   jmp @@retn
  3694                                  
  3695                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3696                                  
  3697                                  @@testReg165:
  3698 0000151A 68[AE16]                 push testReg_19
  3699 0000151D 8D064F75                 lea  ax, [SymbolUpper]
  3700 00001521 50                       push ax
  3701 00001522 E8A40A                   call eqstr
  3702 00001525 83C404                   add  sp, 4
  3703 00001528 08C0                     or  al, al
  3704 0000152A 0F840900                 je @@testReg166
  3705 0000152E 66B803000000             mov eax, 3
  3706 00001534 E93D01                   jmp @@retn
  3707                                  
  3708                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3709                                  
  3710                                  @@testReg166:
  3711 00001537 68[B116]                 push testReg_20
  3712 0000153A 8D064F75                 lea  ax, [SymbolUpper]
  3713 0000153E 50                       push ax
  3714 0000153F E8870A                   call eqstr
  3715 00001542 83C404                   add  sp, 4
  3716 00001545 08C0                     or  al, al
  3717 00001547 0F840900                 je @@testReg167
  3718 0000154B 66B804000000             mov eax, 4
  3719 00001551 E92001                   jmp @@retn
  3720                                  
  3721                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3722                                  
  3723                                  @@testReg167:
  3724 00001554 68[B416]                 push testReg_21
  3725 00001557 8D064F75                 lea  ax, [SymbolUpper]
  3726 0000155B 50                       push ax
  3727 0000155C E86A0A                   call eqstr
  3728 0000155F 83C404                   add  sp, 4
  3729 00001562 08C0                     or  al, al
  3730 00001564 0F840900                 je @@testReg168
  3731 00001568 66B805000000             mov eax, 5
  3732 0000156E E90301                   jmp @@retn
  3733                                  
  3734                                  ;-100   RegType=DWORD;
  3735                                  
  3736                                  @@testReg168:
  3737 00001571 66B803000000             mov eax, 3
  3738 00001577 A2[3E00]                 mov byte [RegType], al
  3739                                  
  3740                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3741                                  
  3742 0000157A 68[B716]                 push testReg_22
  3743 0000157D 8D064F75                 lea  ax, [SymbolUpper]
  3744 00001581 50                       push ax
  3745 00001582 E8440A                   call eqstr
  3746 00001585 83C404                   add  sp, 4
  3747 00001588 08C0                     or  al, al
  3748 0000158A 0F840900                 je @@testReg169
  3749 0000158E 66B800000000             mov eax, 0
  3750 00001594 E9DD00                   jmp @@retn
  3751                                  
  3752                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3753                                  
  3754                                  @@testReg169:
  3755 00001597 68[BB16]                 push testReg_23
  3756 0000159A 8D064F75                 lea  ax, [SymbolUpper]
  3757 0000159E 50                       push ax
  3758 0000159F E8270A                   call eqstr
  3759 000015A2 83C404                   add  sp, 4
  3760 000015A5 08C0                     or  al, al
  3761 000015A7 0F840900                 je @@testReg170
  3762 000015AB 66B801000000             mov eax, 1
  3763 000015B1 E9C000                   jmp @@retn
  3764                                  
  3765                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3766                                  
  3767                                  @@testReg170:
  3768 000015B4 68[BF16]                 push testReg_24
  3769 000015B7 8D064F75                 lea  ax, [SymbolUpper]
  3770 000015BB 50                       push ax
  3771 000015BC E80A0A                   call eqstr
  3772 000015BF 83C404                   add  sp, 4
  3773 000015C2 08C0                     or  al, al
  3774 000015C4 0F840900                 je @@testReg171
  3775 000015C8 66B802000000             mov eax, 2
  3776 000015CE E9A300                   jmp @@retn
  3777                                  
  3778                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3779                                  
  3780                                  @@testReg171:
  3781 000015D1 68[C316]                 push testReg_25
  3782 000015D4 8D064F75                 lea  ax, [SymbolUpper]
  3783 000015D8 50                       push ax
  3784 000015D9 E8ED09                   call eqstr
  3785 000015DC 83C404                   add  sp, 4
  3786 000015DF 08C0                     or  al, al
  3787 000015E1 0F840900                 je @@testReg172
  3788 000015E5 66B803000000             mov eax, 3
  3789 000015EB E98600                   jmp @@retn
  3790                                  
  3791                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3792                                  
  3793                                  @@testReg172:
  3794 000015EE 68[C716]                 push testReg_26
  3795 000015F1 8D064F75                 lea  ax, [SymbolUpper]
  3796 000015F5 50                       push ax
  3797 000015F6 E8D009                   call eqstr
  3798 000015F9 83C404                   add  sp, 4
  3799 000015FC 08C0                     or  al, al
  3800 000015FE 0F840900                 je @@testReg173
  3801 00001602 66B804000000             mov eax, 4
  3802 00001608 E96900                   jmp @@retn
  3803                                  
  3804                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3805                                  
  3806                                  @@testReg173:
  3807 0000160B 68[CB16]                 push testReg_27
  3808 0000160E 8D064F75                 lea  ax, [SymbolUpper]
  3809 00001612 50                       push ax
  3810 00001613 E8B309                   call eqstr
  3811 00001616 83C404                   add  sp, 4
  3812 00001619 08C0                     or  al, al
  3813 0000161B 0F840900                 je @@testReg174
  3814 0000161F 66B805000000             mov eax, 5
  3815 00001625 E94C00                   jmp @@retn
  3816                                  
  3817                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3818                                  
  3819                                  @@testReg174:
  3820 00001628 68[CF16]                 push testReg_28
  3821 0000162B 8D064F75                 lea  ax, [SymbolUpper]
  3822 0000162F 50                       push ax
  3823 00001630 E89609                   call eqstr
  3824 00001633 83C404                   add  sp, 4
  3825 00001636 08C0                     or  al, al
  3826 00001638 0F840900                 je @@testReg175
  3827 0000163C 66B806000000             mov eax, 6
  3828 00001642 E92F00                   jmp @@retn
  3829                                  
  3830                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3831                                  
  3832                                  @@testReg175:
  3833 00001645 68[D316]                 push testReg_29
  3834 00001648 8D064F75                 lea  ax, [SymbolUpper]
  3835 0000164C 50                       push ax
  3836 0000164D E87909                   call eqstr
  3837 00001650 83C404                   add  sp, 4
  3838 00001653 08C0                     or  al, al
  3839 00001655 0F840900                 je @@testReg176
  3840 00001659 66B807000000             mov eax, 7
  3841 0000165F E91200                   jmp @@retn
  3842                                  
  3843                                  ;-109   RegType=0; return 0;
  3844                                  
  3845                                  @@testReg176:
  3846 00001662 66B800000000             mov eax, 0
  3847 00001668 A2[3E00]                 mov byte [RegType], al
  3848 0000166B 66B800000000             mov eax, 0
  3849 00001671 E90000                   jmp @@retn
  3850                                  
  3851                                  ;-110 }
  3852                                  
  3853                                  @@retn:
  3854 00001674 C3                       ret
  3855                                  ; ENDP
  3856 00001675 414C00                  testReg_0 db "AL",0
  3857 00001678 434C00                  testReg_1 db "CL",0
  3858 0000167B 444C00                  testReg_2 db "DL",0
  3859 0000167E 424C00                  testReg_3 db "BL",0
  3860 00001681 414800                  testReg_4 db "AH",0
  3861 00001684 434800                  testReg_5 db "CH",0
  3862 00001687 444800                  testReg_6 db "DH",0
  3863 0000168A 424800                  testReg_7 db "BH",0
  3864 0000168D 415800                  testReg_8 db "AX",0
  3865 00001690 435800                  testReg_9 db "CX",0
  3866 00001693 445800                  testReg_10 db "DX",0
  3867 00001696 425800                  testReg_11 db "BX",0
  3868 00001699 535000                  testReg_12 db "SP",0
  3869 0000169C 425000                  testReg_13 db "BP",0
  3870 0000169F 534900                  testReg_14 db "SI",0
  3871 000016A2 444900                  testReg_15 db "DI",0
  3872 000016A5 455300                  testReg_16 db "ES",0
  3873 000016A8 435300                  testReg_17 db "CS",0
  3874 000016AB 535300                  testReg_18 db "SS",0
  3875 000016AE 445300                  testReg_19 db "DS",0
  3876 000016B1 465300                  testReg_20 db "FS",0
  3877 000016B4 475300                  testReg_21 db "GS",0
  3878 000016B7 45415800                testReg_22 db "EAX",0
  3879 000016BB 45435800                testReg_23 db "ECX",0
  3880 000016BF 45445800                testReg_24 db "EDX",0
  3881 000016C3 45425800                testReg_25 db "EBX",0
  3882 000016C7 45535000                testReg_26 db "ESP",0
  3883 000016CB 45425000                testReg_27 db "EBP",0
  3884 000016CF 45534900                testReg_28 db "ESI",0
  3885 000016D3 45444900                testReg_29 db "EDI",0
  3886                                  ;Back to main program: AS.C
  3887                                  
  3888                                  ;-185 #include "OUTPUT.C"
  3889                                  
  3890                                  ;Use include file: OUTPUT.C
  3891                                  
  3892                                  ;-1 int printLine() { int i; char c;
  3893                                  
  3894                                  
  3895                                  printLine:  ; *** PROC ***
  3896                                  
  3897                                  ;-2   prs("\n"); printhex16(PCStart);
  3898                                  
  3899                                  ;Function : printLine, Number of local variables: 2
  3900                                  ;   # type sign width line used address name   list of local variables
  3901                                  ;  200 var sign word     1 NULL bp-2    i
  3902                                  ;  201 var sign byte     1 NULL bp-4    c;
  3903 000016D7 C8040000                 ENTER  4,0
  3904 000016DB 68[6C17]                 push printLine_0
  3905 000016DE E80401                   call prs
  3906 000016E1 83C402                   add  sp, 2
  3907 000016E4 FF36[3800]               push word [PCStart]
  3908 000016E8 E8EB01                   call printhex16
  3909 000016EB 83C402                   add  sp, 2
  3910                                  
  3911                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  3912                                  
  3913 000016EE A1[4900]                 mov ax, [OpPrintIndex]
  3914 000016F1 83F800                   cmp ax, 0
  3915 000016F4 0F850C00                 jne @@printLine177
  3916 000016F8 68[6F17]                 push printLine_1
  3917 000016FB E8E700                   call prs
  3918 000016FE 83C402                   add  sp, 2
  3919                                  
  3920                                  ;-4   else {
  3921                                  
  3922 00001701 E95B00                   jmp @@printLine178
  3923                                  @@printLine177:
  3924                                  
  3925                                  ;-5     prc(PrReloc);
  3926                                  
  3927 00001704 A0[4D00]                 mov al, byte [PrReloc]
  3928 00001707 B400                     mov ah, 0
  3929 00001709 50                       push ax
  3930 0000170A E87700                   call prc
  3931 0000170D 83C402                   add  sp, 2
  3932                                  
  3933                                  ;-6     i=0;
  3934                                  
  3935 00001710 66B800000000             mov eax, 0
  3936 00001716 8946FE                   mov word [bp-2], ax
  3937                                  
  3938                                  ;-7     do {
  3939                                  
  3940                                  @@printLine179:
  3941                                  
  3942                                  ;-8       c=OpPos[i];
  3943                                  
  3944 00001719 8B5EFE                   mov bx, [bp-2]
  3945 0000171C 8A87B776                 mov al, [OpPos + bx]
  3946 00001720 8846FC                   mov byte [bp-4], al
  3947                                  
  3948                                  ;-9       printhex8a(c); prc(' ');
  3949                                  
  3950 00001723 8A46FC                   mov al, byte [bp-4]
  3951 00001726 B400                     mov ah, 0
  3952 00001728 50                       push ax
  3953 00001729 E85C01                   call printhex8a
  3954 0000172C 83C402                   add  sp, 2
  3955 0000172F 6A20                     push 32
  3956 00001731 E85000                   call prc
  3957 00001734 83C402                   add  sp, 2
  3958                                  
  3959                                  ;-10       i++;
  3960                                  
  3961 00001737 FF46FE                   inc  word [bp-2]
  3962                                  
  3963                                  ;-11     } while(i < OpPrintIndex);
  3964                                  
  3965 0000173A 8B46FE                   mov ax, [bp-2]
  3966 0000173D 3B06[4900]               cmp ax, [OpPrintIndex]
  3967 00001741 0F8D0200                 jge @@printLine180
  3968 00001745 EBD2                     jmp @@printLine179
  3969                                  @@printLine180:
  3970                                  
  3971                                  ;-12     do {// fill rest with blank
  3972                                  
  3973                                  @@printLine181:
  3974                                  
  3975                                  ;-13       prs("   ");
  3976                                  
  3977 00001747 68[8017]                 push printLine_2
  3978 0000174A E89800                   call prs
  3979 0000174D 83C402                   add  sp, 2
  3980                                  
  3981                                  ;-14       i++;
  3982                                  
  3983 00001750 FF46FE                   inc  word [bp-2]
  3984                                  
  3985                                  ;-15     } while(i < OPMAXLEN);
  3986                                  
  3987 00001753 8B46FE                   mov ax, [bp-2]
  3988 00001756 83F805                   cmp ax, 5
  3989 00001759 0F8D0200                 jge @@printLine182
  3990 0000175D EBE8                     jmp @@printLine181
  3991                                  @@printLine182:
  3992                                  
  3993                                  ;-16   }
  3994                                  
  3995                                  
  3996                                  ;-17   prscomment(InputBuf);
  3997                                  
  3998                                  @@printLine178:
  3999 0000175F 8D066E75                 lea  ax, [InputBuf]
  4000 00001763 50                       push ax
  4001 00001764 E85000                   call prscomment
  4002 00001767 83C402                   add  sp, 2
  4003                                  
  4004                                  ;-18 }
  4005                                  
  4006                                  
  4007                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4008 0000176A C9                       LEAVE
  4009 0000176B C3                       ret
  4010                                  ; ENDP
  4011 0000176C 5C6E00                  printLine_0 db "\n",0
  4012 0000176F 202020202020202020-     printLine_1 db "                ",0
  4013 00001778 2020202020202000   
  4014 00001780 20202000                printLine_2 db "   ",0
  4015                                  
  4016                                  prc:  ; *** PROC ***
  4017                                  ;Function : prc, Number of local variables: 1
  4018                                  ;   # type sign width line used address name   list of local variables
  4019                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4020 00001784 C8000000                 ENTER  0,0
  4021 00001788 A0[2400]                 mov al, [LIST]
  4022 0000178B 08C0                     or  al, al
  4023 0000178D 0F841400                 je @@prc183
  4024 00001791 807E040A                cmp byte [bp+4], 10
  4025 00001795 0F850600                 jne @@prc184
  4026 00001799 B80D00                   mov  ax, 13
  4027 0000179C E81A07                   call writetty
  4028                                  
  4029                                  ;-20      al=c; writetty(); }
  4030                                  
  4031                                  @@prc184:
  4032 0000179F 8A4604                   mov  al, [bp+4]
  4033 000017A2 E81407                   call writetty
  4034                                  
  4035                                  ;-21    fputcR(c,lst_fd); }
  4036                                  
  4037                                  @@prc183:
  4038 000017A5 FF36[2B00]               push word [lst_fd]
  4039 000017A9 8A4604                   mov al, byte [bp+4]
  4040 000017AC B400                     mov ah, 0
  4041 000017AE 50                       push ax
  4042 000017AF E8C708                   call fputcR
  4043 000017B2 83C404                   add  sp, 4
  4044                                  
  4045                                  ;-22 
  4046                                  
  4047                                  
  4048                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4049 000017B5 C9                       LEAVE
  4050 000017B6 C3                       ret
  4051                                  ; ENDP
  4052                                  
  4053                                  prscomment:  ; *** PROC ***
  4054                                  
  4055                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4056                                  
  4057                                  ;Function : prscomment, Number of local variables: 2
  4058                                  ;   # type sign width line used address name   list of local variables
  4059                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4060                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4061 000017B7 C8020000                 ENTER  2,0
  4062                                  @@prscomment185:
  4063 000017BB 8B5E04                   mov bx, [bp+4]
  4064 000017BE 8A07                     mov al, [bx]
  4065 000017C0 B400                     mov ah, 0
  4066 000017C2 08C0                     or  al, al
  4067 000017C4 0F841B00                 je @@prscomment186
  4068 000017C8 8B5E04                   mov bx, [bp+4]
  4069 000017CB 8A07                     mov al, [bx]
  4070 000017CD B400                     mov ah, 0
  4071 000017CF 8846FE                   mov byte [bp-2], al
  4072 000017D2 8A46FE                   mov al, byte [bp-2]
  4073 000017D5 B400                     mov ah, 0
  4074 000017D7 50                       push ax
  4075 000017D8 E8A9FF                   call prc
  4076 000017DB 83C402                   add  sp, 2
  4077 000017DE FF4604                   inc  word [bp+4]
  4078                                  
  4079                                  ;-25 }
  4080                                  
  4081 000017E1 EBD8                     jmp @@prscomment185
  4082                                  @@prscomment186:
  4083                                  
  4084                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4085 000017E3 C9                       LEAVE
  4086 000017E4 C3                       ret
  4087                                  ; ENDP
  4088                                  
  4089                                  prs:  ; *** PROC ***
  4090                                  ;Function : prs, Number of local variables: 3
  4091                                  ;   # type sign width line used address name   list of local variables
  4092                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4093                                  ;  201 var unsg byte    26 NULL bp-2    c
  4094                                  ;  202 var sign word    26 NULL bp-4    com;
  4095 000017E5 C8040000                 ENTER  4,0
  4096 000017E9 66B800000000             mov eax, 0
  4097 000017EF 8946FC                   mov word [bp-4], ax
  4098                                  
  4099                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4100                                  
  4101                                  @@prs187:
  4102 000017F2 8B5E04                   mov bx, [bp+4]
  4103 000017F5 8A07                     mov al, [bx]
  4104 000017F7 B400                     mov ah, 0
  4105 000017F9 08C0                     or  al, al
  4106 000017FB 0F848700                 je @@prs188
  4107 000017FF 8B5E04                   mov bx, [bp+4]
  4108 00001802 8A07                     mov al, [bx]
  4109 00001804 B400                     mov ah, 0
  4110 00001806 8846FE                   mov byte [bp-2], al
  4111 00001809 8A46FE                   mov al, [bp-2]
  4112 0000180C 3C22                     cmp al, 34
  4113 0000180E 0F851E00                 jne @@prs189
  4114 00001812 8B46FC                   mov ax, [bp-4]
  4115 00001815 08C0                     or  al, al
  4116 00001817 0F840C00                 je @@prs190
  4117 0000181B 66B800000000             mov eax, 0
  4118 00001821 8946FC                   mov word [bp-4], ax
  4119 00001824 E90900                   jmp @@prs191
  4120                                  @@prs190:
  4121 00001827 66B801000000             mov eax, 1
  4122 0000182D 8946FC                   mov word [bp-4], ax
  4123                                  
  4124                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4125                                  
  4126                                  @@prs191:
  4127                                  @@prs189:
  4128 00001830 8A46FE                   mov al, [bp-2]
  4129 00001833 3C5C                     cmp al, 92
  4130 00001835 0F853B00                 jne @@prs192
  4131 00001839 8B46FC                   mov ax, [bp-4]
  4132 0000183C 83F800                   cmp ax, 0
  4133 0000183F 0F853100                 jne @@prs193
  4134 00001843 FF4604                   inc  word [bp+4]
  4135 00001846 8B5E04                   mov bx, [bp+4]
  4136 00001849 8A07                     mov al, [bx]
  4137 0000184B B400                     mov ah, 0
  4138 0000184D 8846FE                   mov byte [bp-2], al
  4139                                  
  4140                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4141                                  
  4142 00001850 8A46FE                   mov al, [bp-2]
  4143 00001853 3C6E                     cmp al, 110
  4144 00001855 0F850900                 jne @@prs194
  4145 00001859 66B80A000000             mov eax, 10
  4146 0000185F 8846FE                   mov byte [bp-2], al
  4147                                  @@prs194:
  4148 00001862 8A46FE                   mov al, [bp-2]
  4149 00001865 3C74                     cmp al, 116
  4150 00001867 0F850900                 jne @@prs195
  4151 0000186B 66B809000000             mov eax, 9
  4152 00001871 8846FE                   mov byte [bp-2], al
  4153                                  @@prs195:
  4154                                  @@prs193:
  4155                                  @@prs192:
  4156 00001874 8A46FE                   mov al, byte [bp-2]
  4157 00001877 B400                     mov ah, 0
  4158 00001879 50                       push ax
  4159 0000187A E807FF                   call prc
  4160 0000187D 83C402                   add  sp, 2
  4161 00001880 FF4604                   inc  word [bp+4]
  4162                                  
  4163                                  ;-30 }
  4164                                  
  4165 00001883 E96CFF                   jmp @@prs187
  4166                                  @@prs188:
  4167                                  
  4168                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4169 00001886 C9                       LEAVE
  4170 00001887 C3                       ret
  4171                                  ; ENDP
  4172                                  
  4173                                  printhex8a:  ; *** PROC ***
  4174                                  
  4175                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4176                                  
  4177                                  ;Function : printhex8a, Number of local variables: 2
  4178                                  ;   # type sign width line used address name   list of local variables
  4179                                  ;  200 var unsg word    31 NULL bp+4    c
  4180                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4181 00001888 C8020000                 ENTER  2,0
  4182 0000188C 8B4604                   mov ax, [bp+4]
  4183 0000188F C1E804                   shr ax, 4
  4184 00001892 8946FE                   mov word [bp-2], ax
  4185 00001895 8346FE30                 add  word [bp-2], 48
  4186 00001899 8B46FE                   mov ax, [bp-2]
  4187 0000189C 83F839                   cmp ax, 57
  4188 0000189F 0F8E0400                 jle @@printhex8a196
  4189 000018A3 8346FE07                 add  word [bp-2], 7
  4190                                  @@printhex8a196:
  4191 000018A7 FF76FE                   push word [bp-2]
  4192 000018AA E8D7FE                   call prc
  4193 000018AD 83C402                   add  sp, 2
  4194                                  
  4195                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4196                                  
  4197 000018B0 8B4604                   mov ax, [bp+4]
  4198 000018B3 83E00F                   and ax, 15
  4199 000018B6 8946FE                   mov word [bp-2], ax
  4200 000018B9 8346FE30                 add  word [bp-2], 48
  4201 000018BD 8B46FE                   mov ax, [bp-2]
  4202 000018C0 83F839                   cmp ax, 57
  4203 000018C3 0F8E0400                 jle @@printhex8a197
  4204 000018C7 8346FE07                 add  word [bp-2], 7
  4205                                  @@printhex8a197:
  4206 000018CB FF76FE                   push word [bp-2]
  4207 000018CE E8B3FE                   call prc
  4208 000018D1 83C402                   add  sp, 2
  4209                                  
  4210                                  ;-34 }
  4211                                  
  4212                                  
  4213                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4214 000018D4 C9                       LEAVE
  4215 000018D5 C3                       ret
  4216                                  ; ENDP
  4217                                  
  4218                                  printhex16:  ; *** PROC ***
  4219                                  
  4220                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4221                                  
  4222                                  ;Function : printhex16, Number of local variables: 2
  4223                                  ;   # type sign width line used address name   list of local variables
  4224                                  ;  200 var unsg word    35 NULL bp+4    i
  4225                                  ;  201 var unsg word    35 NULL bp-2    half;
  4226 000018D6 C8020000                 ENTER  2,0
  4227 000018DA 8B4604                   mov ax, [bp+4]
  4228 000018DD C1E808                   shr ax, 8
  4229 000018E0 8946FE                   mov word [bp-2], ax
  4230 000018E3 FF76FE                   push word [bp-2]
  4231 000018E6 E89FFF                   call printhex8a
  4232 000018E9 83C402                   add  sp, 2
  4233 000018EC 8B4604                   mov ax, [bp+4]
  4234 000018EF 25FF00                   and ax, 255
  4235 000018F2 8946FE                   mov word [bp-2], ax
  4236 000018F5 FF76FE                   push word [bp-2]
  4237 000018F8 E88DFF                   call printhex8a
  4238 000018FB 83C402                   add  sp, 2
  4239                                  
  4240                                  ;-37 }
  4241                                  
  4242                                  
  4243                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4244 000018FE C9                       LEAVE
  4245 000018FF C3                       ret
  4246                                  ; ENDP
  4247                                  
  4248                                  printIntU:  ; *** PROC ***
  4249                                  
  4250                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4251                                  
  4252                                  ;Function : printIntU, Number of local variables: 2
  4253                                  ;   # type sign width line used address name   list of local variables
  4254                                  ;  200 var unsg word    38 NULL bp+4    n
  4255                                  ;  201 var unsg word    38 NULL bp-2    e;
  4256 00001900 C8020000                 ENTER  2,0
  4257 00001904 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4258 00001908 0F821700                 jb  @@printIntU198
  4259 0000190C 8B4604                   mov ax, [bp+4]
  4260 0000190F BB0A00                   mov bx, 10
  4261 00001912 BA0000                   mov dx, 0
  4262 00001915 F7F3                     div bx
  4263 00001917 8946FE                   mov word [bp-2], ax
  4264                                  
  4265                                  ;-40     printIntU(e); }
  4266                                  
  4267 0000191A FF76FE                   push word [bp-2]
  4268 0000191D E8E0FF                   call printIntU
  4269 00001920 83C402                   add  sp, 2
  4270                                  
  4271                                  ;-41     n = n % 10; //unsigned mod
  4272                                  
  4273                                  @@printIntU198:
  4274 00001923 8B4604                   mov ax, [bp+4]
  4275 00001926 BB0A00                   mov bx, 10
  4276 00001929 BA0000                   mov dx, 0
  4277 0000192C F7F3                     div bx
  4278 0000192E 89D0                     mov ax, dx
  4279 00001930 894604                   mov word [bp+4], ax
  4280                                  
  4281                                  ;-42     n += '0'; prc(n);
  4282                                  
  4283 00001933 83460430                 add  word [bp+4], 48
  4284 00001937 FF7604                   push word [bp+4]
  4285 0000193A E847FE                   call prc
  4286 0000193D 83C402                   add  sp, 2
  4287                                  
  4288                                  ;-43 }
  4289                                  
  4290                                  
  4291                                  ;-44 
  4292                                  
  4293                                  
  4294                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4295 00001940 C9                       LEAVE
  4296 00001941 C3                       ret
  4297                                  ; ENDP
  4298                                  
  4299                                  error1:  ; *** PROC ***
  4300                                  ;Function : error1, Number of local variables: 1
  4301                                  ;   # type sign width line used address name   list of local variables
  4302                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4303 00001942 C8000000                 ENTER  0,0
  4304 00001946 66B801000000             mov eax, 1
  4305 0000194C A2[2400]                 mov byte [LIST], al
  4306 0000194F FF06[3100]               inc  word [ErrorCount]
  4307                                  
  4308                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4309                                  
  4310 00001953 68[7B19]                 push error1_0
  4311 00001956 E88CFE                   call prs
  4312 00001959 83C402                   add  sp, 2
  4313 0000195C FF7604                   push word [bp+4]
  4314 0000195F E883FE                   call prs
  4315 00001962 83C402                   add  sp, 2
  4316                                  
  4317                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4318                                  
  4319 00001965 68[9619]                 push error1_1
  4320 00001968 E87AFE                   call prs
  4321 0000196B 83C402                   add  sp, 2
  4322 0000196E 8D063075                 lea  ax, [Symbol]
  4323 00001972 50                       push ax
  4324 00001973 E86FFE                   call prs
  4325 00001976 83C402                   add  sp, 2
  4326                                  
  4327                                  ;-48 int allowederror(){error1("not allowed here"); }
  4328 00001979 C9                       LEAVE
  4329 0000197A C3                       ret
  4330                                  ; ENDP
  4331 0000197B 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4332 00001984 6E657874206C696E65-
  4333 0000198D 204552524F523A2000 
  4334 00001996 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4335 0000199F 2000               
  4336                                  
  4337                                  allowederror:  ; *** PROC ***
  4338 000019A1 68[AB19]                 push allowederror_0
  4339 000019A4 E89BFF                   call error1
  4340 000019A7 83C402                   add  sp, 2
  4341                                  
  4342                                  ;-49 int implmerror(){error1("not implemented");}
  4343                                  
  4344 000019AA C3                       ret
  4345                                  ; ENDP
  4346 000019AB 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4347 000019B4 6564206865726500   
  4348                                  
  4349                                  implmerror:  ; *** PROC ***
  4350 000019BC 68[C619]                 push implmerror_0
  4351 000019BF E880FF                   call error1
  4352 000019C2 83C402                   add  sp, 2
  4353                                  
  4354                                  ;-50 int indexerror (){error1("invalid index register");}
  4355                                  
  4356 000019C5 C3                       ret
  4357                                  ; ENDP
  4358 000019C6 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4359 000019CF 6D656E74656400     
  4360                                  
  4361                                  indexerror:  ; *** PROC ***
  4362 000019D6 68[E019]                 push indexerror_0
  4363 000019D9 E866FF                   call error1
  4364 000019DC 83C402                   add  sp, 2
  4365                                  
  4366                                  ;-51 int numbererror(){error1("number expected");}
  4367                                  
  4368 000019DF C3                       ret
  4369                                  ; ENDP
  4370 000019E0 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4371 000019E9 6E6465782072656769-
  4372 000019F2 7374657200         
  4373                                  
  4374                                  numbererror:  ; *** PROC ***
  4375 000019F7 68[011A]                 push numbererror_0
  4376 000019FA E845FF                   call error1
  4377 000019FD 83C402                   add  sp, 2
  4378                                  
  4379                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4380                                  
  4381 00001A00 C3                       ret
  4382                                  ; ENDP
  4383 00001A01 6E756D626572206578-     numbererror_0 db "number expected",0
  4384 00001A0A 70656374656400     
  4385                                  
  4386                                  regmemerror:  ; *** PROC ***
  4387 00001A11 68[1B1A]                 push regmemerror_0
  4388 00001A14 E82BFF                   call error1
  4389 00001A17 83C402                   add  sp, 2
  4390                                  
  4391                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4392                                  
  4393 00001A1A C3                       ret
  4394                                  ; ENDP
  4395 00001A1B 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4396 00001A24 73746572206F72206D-
  4397 00001A2D 656D6F727920616C6C-
  4398 00001A36 6F77656400         
  4399                                  
  4400                                  segregerror:  ; *** PROC ***
  4401 00001A3B 68[451A]                 push segregerror_0
  4402 00001A3E E801FF                   call error1
  4403 00001A41 83C402                   add  sp, 2
  4404                                  
  4405                                  ;-54 int syntaxerror(){error1("syntax");}
  4406                                  
  4407 00001A44 C3                       ret
  4408                                  ; ENDP
  4409 00001A45 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4410 00001A4E 65676973746572206E-
  4411 00001A57 6F7420616C6C6F7765-
  4412 00001A60 6400               
  4413                                  
  4414                                  syntaxerror:  ; *** PROC ***
  4415 00001A62 68[6C1A]                 push syntaxerror_0
  4416 00001A65 E8DAFE                   call error1
  4417 00001A68 83C402                   add  sp, 2
  4418                                  
  4419                                  ;-55 
  4420                                  
  4421                                  
  4422                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4423                                  
  4424 00001A6B C3                       ret
  4425                                  ; ENDP
  4426 00001A6C 73796E74617800          syntaxerror_0 db "syntax",0
  4427                                  
  4428                                  errorexit:  ; *** PROC ***
  4429                                  ;Function : errorexit, Number of local variables: 1
  4430                                  ;   # type sign width line used address name   list of local variables
  4431                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4432 00001A73 C8000000                 ENTER  0,0
  4433 00001A77 FF7604                   push word [bp+4]
  4434 00001A7A E8C5FE                   call error1
  4435 00001A7D 83C402                   add  sp, 2
  4436 00001A80 6A01                     push 1
  4437 00001A82 E80704                   call end1
  4438 00001A85 83C402                   add  sp, 2
  4439                                  
  4440                                  ;-57 int addrexit(){errorexit("illegal address");}
  4441 00001A88 C9                       LEAVE
  4442 00001A89 C3                       ret
  4443                                  ; ENDP
  4444                                  
  4445                                  addrexit:  ; *** PROC ***
  4446 00001A8A 68[941A]                 push addrexit_0
  4447 00001A8D E8E3FF                   call errorexit
  4448 00001A90 83C402                   add  sp, 2
  4449                                  
  4450                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4451                                  
  4452 00001A93 C3                       ret
  4453                                  ; ENDP
  4454 00001A94 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4455 00001A9D 64647265737300     
  4456                                  
  4457                                  internexit:  ; *** PROC ***
  4458 00001AA4 68[AE1A]                 push internexit_0
  4459 00001AA7 E8C9FF                   call errorexit
  4460 00001AAA 83C402                   add  sp, 2
  4461 00001AAD C3                       ret
  4462                                  ; ENDP
  4463 00001AAE 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4464 00001AB7 6D70696C6572206572-
  4465 00001AC0 726F7200           
  4466                                  ;Back to main program: AS.C
  4467                                  
  4468                                  ;-186 #include "MAIN.C"
  4469                                  
  4470                                  ;Use include file: MAIN.C
  4471                                  
  4472                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4473                                  
  4474                                  
  4475                                  getarg:  ; *** PROC ***
  4476                                  
  4477                                  ;-2   arglen1=*arglen;
  4478                                  
  4479                                  ;Function : getarg, Number of local variables: 3
  4480                                  ;   # type sign width line used address name   list of local variables
  4481                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4482                                  ;  201 var sign word     1 NULL bp-4    i
  4483                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4484 00001AC4 C8060000                 ENTER  6,0
  4485 00001AC8 8B1E[5600]               mov bx, [arglen]
  4486 00001ACC 8A07                     mov al, [bx]
  4487 00001ACE B400                     mov ah, 0
  4488 00001AD0 8946FE                   mov word [bp-2], ax
  4489                                  
  4490                                  ;-3   if (arglen1==0) {
  4491                                  
  4492 00001AD3 8B46FE                   mov ax, [bp-2]
  4493 00001AD6 83F800                   cmp ax, 0
  4494 00001AD9 0F851C00                 jne @@getarg199
  4495                                  
  4496                                  ;-4     cputs(Version1);
  4497                                  
  4498 00001ADD 8D06[1000]               lea  ax, [Version1]
  4499 00001AE1 50                       push ax
  4500 00001AE2 E8DC03                   call cputs
  4501 00001AE5 83C402                   add  sp, 2
  4502                                  
  4503                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4504                                  
  4505 00001AE8 68[891C]                 push getarg_0
  4506 00001AEB E8D303                   call cputs
  4507 00001AEE 83C402                   add  sp, 2
  4508                                  
  4509                                  ;-6     exitR(3);
  4510                                  
  4511 00001AF1 6A03                     push 3
  4512 00001AF3 E8A605                   call exitR
  4513 00001AF6 83C402                   add  sp, 2
  4514                                  
  4515                                  ;-7   }
  4516                                  
  4517                                  
  4518                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4519                                  
  4520                                  @@getarg199:
  4521 00001AF9 8B46FE                   mov ax, [bp-2]
  4522 00001AFC 058100                   add ax, 129
  4523 00001AFF 8946FC                   mov word [bp-4], ax
  4524 00001B02 66B800000000             mov eax, 0
  4525 00001B08 8B5EFC                   mov  bx, [bp-4]
  4526 00001B0B 8907                     mov  [bx], ax
  4527 00001B0D FF4EFE                   dec  word [bp-2]
  4528                                  
  4529                                  ;-9   toupper(argv);
  4530                                  
  4531 00001B10 FF36[5800]               push word [argv]
  4532 00001B14 E8D803                   call toupper
  4533 00001B17 83C402                   add  sp, 2
  4534                                  
  4535                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4536                                  
  4537 00001B1A FF36[5800]               push word [argv]
  4538 00001B1E 8D06EE75                 lea  ax, [namein]
  4539 00001B22 50                       push ax
  4540 00001B23 E83704                   call strcpy
  4541 00001B26 83C404                   add  sp, 4
  4542 00001B29 68[AE1C]                 push getarg_1
  4543 00001B2C 8D06EE75                 lea  ax, [namein]
  4544 00001B30 50                       push ax
  4545 00001B31 E8EA04                   call strcat1
  4546 00001B34 83C404                   add  sp, 4
  4547                                  
  4548                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4549                                  
  4550 00001B37 FF36[5800]               push word [argv]
  4551 00001B3B 8D063176                 lea  ax, [namelst]
  4552 00001B3F 50                       push ax
  4553 00001B40 E81A04                   call strcpy
  4554 00001B43 83C404                   add  sp, 4
  4555 00001B46 68[B11C]                 push getarg_2
  4556 00001B49 8D063176                 lea  ax, [namelst]
  4557 00001B4D 50                       push ax
  4558 00001B4E E8CD04                   call strcat1
  4559 00001B51 83C404                   add  sp, 4
  4560                                  
  4561                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4562                                  
  4563 00001B54 FF36[5800]               push word [argv]
  4564 00001B58 8D067476                 lea  ax, [namebin]
  4565 00001B5C 50                       push ax
  4566 00001B5D E8FD03                   call strcpy
  4567 00001B60 83C404                   add  sp, 4
  4568 00001B63 68[B61C]                 push getarg_3
  4569 00001B66 8D067476                 lea  ax, [namebin]
  4570 00001B6A 50                       push ax
  4571 00001B6B E8B004                   call strcat1
  4572 00001B6E 83C404                   add  sp, 4
  4573                                  
  4574                                  ;-13 
  4575                                  
  4576                                  
  4577                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4578                                  
  4579 00001B71 66B801000000             mov eax, 1
  4580 00001B77 A2[2400]                 mov byte [LIST], al
  4581 00001B7A 66B800000000             mov eax, 0
  4582 00001B80 A3[2F00]                 mov word [DOS_ERR], ax
  4583 00001B83 66B800000000             mov eax, 0
  4584 00001B89 A3[3600]                 mov word [PC], ax
  4585 00001B8C 66B800000000             mov eax, 0
  4586 00001B92 A3[3100]                 mov word [ErrorCount], ax
  4587                                  
  4588                                  ;-15   asm_fd=openR (namein);
  4589                                  
  4590 00001B95 8D06EE75                 lea  ax, [namein]
  4591 00001B99 50                       push ax
  4592 00001B9A E8A604                   call openR
  4593 00001B9D 83C402                   add  sp, 2
  4594 00001BA0 A3[2900]                 mov word [asm_fd], ax
  4595                                  
  4596                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4597                                  
  4598 00001BA3 A1[2F00]                 mov ax, [DOS_ERR]
  4599 00001BA6 08C0                     or  al, al
  4600 00001BA8 0F841C00                 je @@getarg200
  4601 00001BAC 68[BB1C]                 push getarg_4
  4602 00001BAF E80F03                   call cputs
  4603 00001BB2 83C402                   add  sp, 2
  4604 00001BB5 8D06EE75                 lea  ax, [namein]
  4605 00001BB9 50                       push ax
  4606 00001BBA E80403                   call cputs
  4607 00001BBD 83C402                   add  sp, 2
  4608 00001BC0 6A01                     push 1
  4609 00001BC2 E8D704                   call exitR
  4610 00001BC5 83C402                   add  sp, 2
  4611                                  
  4612                                  ;-17   lst_fd=creatR(namelst);
  4613                                  
  4614                                  @@getarg200:
  4615 00001BC8 8D063176                 lea  ax, [namelst]
  4616 00001BCC 50                       push ax
  4617 00001BCD E88204                   call creatR
  4618 00001BD0 83C402                   add  sp, 2
  4619 00001BD3 A3[2B00]                 mov word [lst_fd], ax
  4620                                  
  4621                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4622                                  
  4623 00001BD6 A1[2F00]                 mov ax, [DOS_ERR]
  4624 00001BD9 08C0                     or  al, al
  4625 00001BDB 0F841C00                 je @@getarg201
  4626 00001BDF 68[D11C]                 push getarg_5
  4627 00001BE2 E8DC02                   call cputs
  4628 00001BE5 83C402                   add  sp, 2
  4629 00001BE8 8D063176                 lea  ax, [namelst]
  4630 00001BEC 50                       push ax
  4631 00001BED E8D102                   call cputs
  4632 00001BF0 83C402                   add  sp, 2
  4633 00001BF3 6A02                     push 2
  4634 00001BF5 E8A404                   call exitR
  4635 00001BF8 83C402                   add  sp, 2
  4636                                  
  4637                                  ;-19   bin_fd=creatR(namebin);
  4638                                  
  4639                                  @@getarg201:
  4640 00001BFB 8D067476                 lea  ax, [namebin]
  4641 00001BFF 50                       push ax
  4642 00001C00 E84F04                   call creatR
  4643 00001C03 83C402                   add  sp, 2
  4644 00001C06 A3[2D00]                 mov word [bin_fd], ax
  4645                                  
  4646                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4647                                  
  4648 00001C09 A1[2F00]                 mov ax, [DOS_ERR]
  4649 00001C0C 08C0                     or  al, al
  4650 00001C0E 0F841C00                 je @@getarg202
  4651 00001C12 68[E81C]                 push getarg_6
  4652 00001C15 E8A902                   call cputs
  4653 00001C18 83C402                   add  sp, 2
  4654 00001C1B 8D067476                 lea  ax, [namebin]
  4655 00001C1F 50                       push ax
  4656 00001C20 E89E02                   call cputs
  4657 00001C23 83C402                   add  sp, 2
  4658 00001C26 6A02                     push 2
  4659 00001C28 E87104                   call exitR
  4660 00001C2B 83C402                   add  sp, 2
  4661                                  
  4662                                  ;-21   prs(";");prs(Version1);
  4663                                  
  4664                                  @@getarg202:
  4665 00001C2E 68[FE1C]                 push getarg_7
  4666 00001C31 E8B1FB                   call prs
  4667 00001C34 83C402                   add  sp, 2
  4668 00001C37 8D06[1000]               lea  ax, [Version1]
  4669 00001C3B 50                       push ax
  4670 00001C3C E8A6FB                   call prs
  4671 00001C3F 83C402                   add  sp, 2
  4672                                  
  4673                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4674                                  
  4675 00001C42 68[001D]                 push getarg_8
  4676 00001C45 E89DFB                   call prs
  4677 00001C48 83C402                   add  sp, 2
  4678 00001C4B 8D06EE75                 lea  ax, [namein]
  4679 00001C4F 50                       push ax
  4680 00001C50 E892FB                   call prs
  4681 00001C53 83C402                   add  sp, 2
  4682 00001C56 68[0B1D]                 push getarg_9
  4683 00001C59 E889FB                   call prs
  4684 00001C5C 83C402                   add  sp, 2
  4685 00001C5F 8D063176                 lea  ax, [namelst]
  4686 00001C63 50                       push ax
  4687 00001C64 E87EFB                   call prs
  4688 00001C67 83C402                   add  sp, 2
  4689                                  
  4690                                  ;-23   prs(", "); prs(namebin);
  4691                                  
  4692 00001C6A 68[161D]                 push getarg_10
  4693 00001C6D E875FB                   call prs
  4694 00001C70 83C402                   add  sp, 2
  4695 00001C73 8D067476                 lea  ax, [namebin]
  4696 00001C77 50                       push ax
  4697 00001C78 E86AFB                   call prs
  4698 00001C7B 83C402                   add  sp, 2
  4699                                  
  4700                                  ;-24   prs("\n");
  4701                                  
  4702 00001C7E 68[191D]                 push getarg_11
  4703 00001C81 E861FB                   call prs
  4704 00001C84 83C402                   add  sp, 2
  4705                                  
  4706                                  ;-25 }
  4707                                  
  4708                                  
  4709                                  ;-26 int epilog() { int i; int j; char c;
  4710 00001C87 C9                       LEAVE
  4711 00001C88 C3                       ret
  4712                                  ; ENDP
  4713 00001C89 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4714 00001C92 41532E434F4D206669-
  4715 00001C9B 6C656E616D65205B77-
  4716 00001CA4 2F6F202E535D203A20-
  4717 00001CAD 00                 
  4718 00001CAE 2E5300                  getarg_1 db ".S",0
  4719 00001CB1 2E4C535400              getarg_2 db ".LST",0
  4720 00001CB6 2E434F4D00              getarg_3 db ".COM",0
  4721 00001CBB 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4722 00001CC4 6C65206D697373696E-
  4723 00001CCD 673A2000           
  4724 00001CD1 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4725 00001CDA 206E6F742063726561-
  4726 00001CE3 74653A2000         
  4727 00001CE8 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4728 00001CF1 6E6F74206372656174-
  4729 00001CFA 653A2000           
  4730 00001CFE 3B00                    getarg_7 db ";",0
  4731 00001D00 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4732 00001D09 2000               
  4733 00001D0B 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4734 00001D14 2000               
  4735 00001D16 2C2000                  getarg_10 db ", ",0
  4736 00001D19 5C6E00                  getarg_11 db "\n",0
  4737                                  
  4738                                  epilog:  ; *** PROC ***
  4739                                  
  4740                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4741                                  
  4742                                  ;Function : epilog, Number of local variables: 3
  4743                                  ;   # type sign width line used address name   list of local variables
  4744                                  ;  200 var sign word    26 NULL bp-2    i
  4745                                  ;  201 var sign word    26 NULL bp-4    j
  4746                                  ;  202 var sign byte    26 NULL bp-6    c;
  4747 00001D1C C8060000                 ENTER  6,0
  4748 00001D20 68[451E]                 push epilog_0
  4749 00001D23 E8BFFA                   call prs
  4750 00001D26 83C402                   add  sp, 2
  4751 00001D29 FF36[3100]               push word [ErrorCount]
  4752 00001D2D E8D0FB                   call printIntU
  4753 00001D30 83C402                   add  sp, 2
  4754                                  
  4755                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4756                                  
  4757 00001D33 A1[3100]                 mov ax, [ErrorCount]
  4758 00001D36 08C0                     or  al, al
  4759 00001D38 0F840900                 je @@epilog203
  4760 00001D3C 68[551E]                 push epilog_1
  4761 00001D3F E8A3FA                   call prs
  4762 00001D42 83C402                   add  sp, 2
  4763                                  
  4764                                  ;-29   prs(", Label & Var: ");
  4765                                  
  4766                                  @@epilog203:
  4767 00001D45 68[631E]                 push epilog_2
  4768 00001D48 E89AFA                   call prs
  4769 00001D4B 83C402                   add  sp, 2
  4770                                  
  4771                                  ;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4772                                  
  4773                                  
  4774                                  ;-31   i= &LabelNames;
  4775                                  
  4776                                  
  4777                                  ;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4778                                  
  4779                                  
  4780                                  ;-33   } while (i < LabelNamePtr); prs("<< \n"); */
  4781                                  
  4782                                  
  4783                                  ;-34   if (LabelMaxIx) {
  4784                                  
  4785 00001D4E A1[5000]                 mov ax, [LabelMaxIx]
  4786 00001D51 08C0                     or  al, al
  4787 00001D53 0F846900                 je @@epilog204
  4788                                  
  4789                                  ;-35     i = 1;
  4790                                  
  4791 00001D57 66B801000000             mov eax, 1
  4792 00001D5D 8946FE                   mov word [bp-2], ax
  4793                                  
  4794                                  ;-36     LabelNamePtr= &LabelNames;
  4795                                  
  4796 00001D60 B8BC76                   mov ax, LabelNames
  4797 00001D63 A3[4E00]                 mov word [LabelNamePtr], ax
  4798                                  
  4799                                  ;-37     do {
  4800                                  
  4801                                  @@epilog205:
  4802                                  
  4803                                  ;-38       prs(LabelNamePtr); prc(' ');
  4804                                  
  4805 00001D66 FF36[4E00]               push word [LabelNamePtr]
  4806 00001D6A E878FA                   call prs
  4807 00001D6D 83C402                   add  sp, 2
  4808 00001D70 6A20                     push 32
  4809 00001D72 E80FFA                   call prc
  4810 00001D75 83C402                   add  sp, 2
  4811                                  
  4812                                  ;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4813                                  
  4814 00001D78 8B5EFE                   mov bx, [bp-2]
  4815 00001D7B D1E3                     shl bx, 1
  4816 00001D7D 8B87A47A                 mov ax, [LabelAddr + bx]
  4817 00001D81 8946FC                   mov word [bp-4], ax
  4818 00001D84 FF76FC                   push word [bp-4]
  4819 00001D87 E84CFB                   call printhex16
  4820 00001D8A 83C402                   add  sp, 2
  4821 00001D8D 68[731E]                 push epilog_3
  4822 00001D90 E852FA                   call prs
  4823 00001D93 83C402                   add  sp, 2
  4824                                  
  4825                                  ;-40       j=strlen(LabelNamePtr);//get end of actual name
  4826                                  
  4827 00001D96 FF36[4E00]               push word [LabelNamePtr]
  4828 00001D9A E89501                   call strlen
  4829 00001D9D 83C402                   add  sp, 2
  4830 00001DA0 8946FC                   mov word [bp-4], ax
  4831                                  
  4832                                  ;-41       LabelNamePtr=LabelNamePtr+j;
  4833                                  
  4834 00001DA3 A1[4E00]                 mov ax, [LabelNamePtr]
  4835 00001DA6 0346FC                   add ax, [bp-4]
  4836 00001DA9 A3[4E00]                 mov word [LabelNamePtr], ax
  4837                                  
  4838                                  ;-42       LabelNamePtr++;
  4839                                  
  4840 00001DAC FF06[4E00]               inc  word [LabelNamePtr]
  4841                                  
  4842                                  ;-43       i++;
  4843                                  
  4844 00001DB0 FF46FE                   inc  word [bp-2]
  4845                                  
  4846                                  ;-44     } while (i <= LabelMaxIx);
  4847                                  
  4848 00001DB3 8B46FE                   mov ax, [bp-2]
  4849 00001DB6 3B06[5000]               cmp ax, [LabelMaxIx]
  4850 00001DBA 0F8F0200                 jg  @@epilog206
  4851 00001DBE EBA6                     jmp @@epilog205
  4852                                  @@epilog206:
  4853                                  
  4854                                  ;-45   }
  4855                                  
  4856                                  
  4857                                  ;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4858                                  
  4859                                  @@epilog204:
  4860 00001DC0 68[771E]                 push epilog_4
  4861 00001DC3 E81FFA                   call prs
  4862 00001DC6 83C402                   add  sp, 2
  4863 00001DC9 FF36[5400]               push word [BinLen]
  4864 00001DCD E830FB                   call printIntU
  4865 00001DD0 83C402                   add  sp, 2
  4866 00001DD3 68[841E]                 push epilog_5
  4867 00001DD6 E80CFA                   call prs
  4868 00001DD9 83C402                   add  sp, 2
  4869                                  
  4870                                  ;-47   i=0;
  4871                                  
  4872 00001DDC 66B800000000             mov eax, 0
  4873 00001DE2 8946FE                   mov word [bp-2], ax
  4874                                  
  4875                                  ;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4876                                  
  4877                                  @@epilog207:
  4878 00001DE5 6A20                     push 32
  4879 00001DE7 E89AF9                   call prc
  4880 00001DEA 83C402                   add  sp, 2
  4881 00001DED 8B5EFE                   mov bx, [bp-2]
  4882 00001DF0 8A876C7B                 mov al, [FileBin + bx]
  4883 00001DF4 8946FC                   mov word [bp-4], ax
  4884 00001DF7 FF76FC                   push word [bp-4]
  4885 00001DFA E88BFA                   call printhex8a
  4886 00001DFD 83C402                   add  sp, 2
  4887 00001E00 FF46FE                   inc  word [bp-2]
  4888                                  
  4889                                  ;-49   } while (i < BinLen);
  4890                                  
  4891 00001E03 8B46FE                   mov ax, [bp-2]
  4892 00001E06 3B06[5400]               cmp ax, [BinLen]
  4893 00001E0A 0F8D0200                 jge @@epilog208
  4894 00001E0E EBD5                     jmp @@epilog207
  4895                                  @@epilog208:
  4896                                  
  4897                                  ;-50   i=0;
  4898                                  
  4899 00001E10 66B800000000             mov eax, 0
  4900 00001E16 8946FE                   mov word [bp-2], ax
  4901                                  
  4902                                  ;-51   do {
  4903                                  
  4904                                  @@epilog209:
  4905                                  
  4906                                  ;-52     c = FileBin[i];
  4907                                  
  4908 00001E19 8B5EFE                   mov bx, [bp-2]
  4909 00001E1C 8A876C7B                 mov al, [FileBin + bx]
  4910 00001E20 8846FA                   mov byte [bp-6], al
  4911                                  
  4912                                  ;-53     fputcR(c, bin_fd);
  4913                                  
  4914 00001E23 FF36[2D00]               push word [bin_fd]
  4915 00001E27 8A46FA                   mov al, byte [bp-6]
  4916 00001E2A B400                     mov ah, 0
  4917 00001E2C 50                       push ax
  4918 00001E2D E84902                   call fputcR
  4919 00001E30 83C404                   add  sp, 4
  4920                                  
  4921                                  ;-54     i++;
  4922                                  
  4923 00001E33 FF46FE                   inc  word [bp-2]
  4924                                  
  4925                                  ;-55   } while (i < BinLen);
  4926                                  
  4927 00001E36 8B46FE                   mov ax, [bp-2]
  4928 00001E39 3B06[5400]               cmp ax, [BinLen]
  4929 00001E3D 0F8D0200                 jge @@epilog210
  4930 00001E41 EBD6                     jmp @@epilog209
  4931                                  @@epilog210:
  4932                                  
  4933                                  ;-56 }
  4934                                  
  4935                                  
  4936                                  ;-57 int end1(int n) {
  4937 00001E43 C9                       LEAVE
  4938 00001E44 C3                       ret
  4939                                  ; ENDP
  4940 00001E45 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4941 00001E4E 726F72733A2000     
  4942 00001E55 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4943 00001E5E 2A2A2A2000         
  4944 00001E63 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4945 00001E6C 205661723A2000     
  4946 00001E73 2C202000                epilog_3 db ",  ",0
  4947 00001E77 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4948 00001E80 6C652000           
  4949 00001E84 2062797465733A00        epilog_5 db " bytes:",0
  4950                                  
  4951                                  end1:  ; *** PROC ***
  4952                                  
  4953                                  ;-58   fcloseR(asm_fd);
  4954                                  
  4955                                  ;Function : end1, Number of local variables: 1
  4956                                  ;   # type sign width line used address name   list of local variables
  4957                                  ;  200 var sign word    57 NULL bp+4    n;
  4958 00001E8C C8000000                 ENTER  0,0
  4959 00001E90 FF36[2900]               push word [asm_fd]
  4960 00001E94 E8F701                   call fcloseR
  4961 00001E97 83C402                   add  sp, 2
  4962                                  
  4963                                  ;-59   fcloseR(lst_fd);
  4964                                  
  4965 00001E9A FF36[2B00]               push word [lst_fd]
  4966 00001E9E E8ED01                   call fcloseR
  4967 00001EA1 83C402                   add  sp, 2
  4968                                  
  4969                                  ;-60   fcloseR(bin_fd);
  4970                                  
  4971 00001EA4 FF36[2D00]               push word [bin_fd]
  4972 00001EA8 E8E301                   call fcloseR
  4973 00001EAB 83C402                   add  sp, 2
  4974                                  
  4975                                  ;-61   exitR(n);
  4976                                  
  4977 00001EAE FF7604                   push word [bp+4]
  4978 00001EB1 E8E801                   call exitR
  4979 00001EB4 83C402                   add  sp, 2
  4980                                  
  4981                                  ;-62 }
  4982 00001EB7 C9                       LEAVE
  4983 00001EB8 C3                       ret
  4984                                  ; ENDP
  4985                                  ;Back to main program: AS.C
  4986                                   
  4987                                  ; missing functions: 
  4988                                  ; digit
  4989                                  ; strcpy
  4990                                  ; eqstr
  4991                                  ; strlen
  4992                                  ; eqstr
  4993                                  ; eqstr
  4994                                  ; eqstr
  4995                                  ; eqstr
  4996                                  ; readRL
  4997                                  ; readRL
  4998                                  ; digit
  4999                                  ; digit
  5000                                  ; strcpy
  5001                                  ; toupper
  5002                                  ; strlen
  5003                                  ; strlen
  5004                                  ; eqstr
  5005                                  ; eqstr
  5006                                  ; eqstr
  5007                                  ; eqstr
  5008                                  ; eqstr
  5009                                  ; eqstr
  5010                                  ; eqstr
  5011                                  ; eqstr
  5012                                  ; eqstr
  5013                                  ; eqstr
  5014                                  ; eqstr
  5015                                  ; eqstr
  5016                                  ; eqstr
  5017                                  ; eqstr
  5018                                  ; eqstr
  5019                                  ; eqstr
  5020                                  ; eqstr
  5021                                  ; eqstr
  5022                                  ; eqstr
  5023                                  ; eqstr
  5024                                  ; eqstr
  5025                                  ; eqstr
  5026                                  ; eqstr
  5027                                  ; eqstr
  5028                                  ; eqstr
  5029                                  ; eqstr
  5030                                  ; eqstr
  5031                                  ; eqstr
  5032                                  ; eqstr
  5033                                  ; eqstr
  5034                                  ; writetty
  5035                                  ; writetty
  5036                                  ; fputcR
  5037                                  ; cputs
  5038                                  ; cputs
  5039                                  ; exitR
  5040                                  ; toupper
  5041                                  ; strcpy
  5042                                  ; strcat1
  5043                                  ; strcpy
  5044                                  ; strcat1
  5045                                  ; strcpy
  5046                                  ; strcat1
  5047                                  ; openR
  5048                                  ; cputs
  5049                                  ; cputs
  5050                                  ; exitR
  5051                                  ; creatR
  5052                                  ; cputs
  5053                                  ; cputs
  5054                                  ; exitR
  5055                                  ; creatR
  5056                                  ; cputs
  5057                                  ; cputs
  5058                                  ; exitR
  5059                                  ; strlen
  5060                                  ; fputcR
  5061                                  ; fcloseR
  5062                                  ; fcloseR
  5063                                  ; fcloseR
  5064                                  ; exitR
  5065                                  ; Number of unresolved CALLs :   77
  5066                                  ;use archive file: AR.C
  5067                                  
  5068                                  ;-187 // AR.C Archive
  5069                                  
  5070                                  ;Number of CALLs:    2 : writetty
  5071                                  
  5072                                  writetty:  ; *** PROC ***
  5073 00001EB9 B40E                     mov  ah, 14
  5074 00001EBB BB0000                   mov  bx, 0
  5075 00001EBE CD10                     int  16
  5076                                  
  5077                                  ;-188 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5078                                  
  5079 00001EC0 C3                       ret
  5080                                  ; ENDP
  5081                                  ;Number of CALLs:    8 : cputs
  5082                                  
  5083                                  cputs:  ; *** PROC ***
  5084                                  ;Function : cputs, Number of local variables: 2
  5085                                  ;   # type sign width line used address name   list of local variables
  5086                                  ;  200 ptr sign byte   188 NULL bp+4    s
  5087                                  ;  201 var sign byte   188 NULL bp-2    c;
  5088 00001EC1 C8020000                 ENTER  2,0
  5089                                  @@cputs211:
  5090 00001EC5 8B5E04                   mov bx, [bp+4]
  5091 00001EC8 8A07                     mov al, [bx]
  5092 00001ECA B400                     mov ah, 0
  5093 00001ECC 08C0                     or  al, al
  5094 00001ECE 0F841B00                 je @@cputs212
  5095 00001ED2 8B5E04                   mov bx, [bp+4]
  5096 00001ED5 8A07                     mov al, [bx]
  5097 00001ED7 B400                     mov ah, 0
  5098 00001ED9 8846FE                   mov byte [bp-2], al
  5099 00001EDC 8A46FE                   mov al, byte [bp-2]
  5100 00001EDF B400                     mov ah, 0
  5101 00001EE1 50                       push ax
  5102 00001EE2 E8C401                   call putch
  5103 00001EE5 83C402                   add  sp, 2
  5104 00001EE8 FF4604                   inc  word [bp+4]
  5105 00001EEB EBD8                     jmp @@cputs211
  5106                                  @@cputs212:
  5107                                  
  5108                                  ;-189 int mkneg(int n) { n; __asm {neg ax} }
  5109 00001EED C9                       LEAVE
  5110 00001EEE C3                       ret
  5111                                  ; ENDP
  5112                                  ;Number of CALLs:    2 : toupper
  5113                                  
  5114                                  toupper:  ; *** PROC ***
  5115                                  ;Function : toupper, Number of local variables: 1
  5116                                  ;   # type sign width line used address name   list of local variables
  5117                                  ;  200 ptr sign byte   189 NULL bp+4    s;
  5118 00001EEF C8000000                 ENTER  0,0
  5119                                  @@toupper213:
  5120 00001EF3 8B5E04                   mov bx, [bp+4]
  5121 00001EF6 8A07                     mov al, [bx]
  5122 00001EF8 B400                     mov ah, 0
  5123 00001EFA 08C0                     or  al, al
  5124 00001EFC 0F843000                 je @@toupper214
  5125 00001F00 8B5E04                   mov bx, [bp+4]
  5126 00001F03 8A07                     mov al, [bx]
  5127 00001F05 B400                     mov ah, 0
  5128 00001F07 83F861                   cmp ax, 97 ;unsigned : 1
  5129 00001F0A 0F8C1D00                 jl  @@toupper215
  5130 00001F0E 8B5E04                   mov bx, [bp+4]
  5131 00001F11 8A07                     mov al, [bx]
  5132 00001F13 B400                     mov ah, 0
  5133 00001F15 83F87A                   cmp ax, 122
  5134 00001F18 0F8F0F00                 jg  @@toupper216
  5135 00001F1C 8B5E04                   mov bx, [bp+4]
  5136 00001F1F 8A07                     mov al, [bx]
  5137 00001F21 B400                     mov ah, 0
  5138 00001F23 83E820                   sub ax, 32
  5139 00001F26 8B5E04                   mov  bx, [bp+4]
  5140 00001F29 8807                     mov  [bx], al
  5141                                  @@toupper216:
  5142                                  @@toupper215:
  5143 00001F2B FF4604                   inc  word [bp+4]
  5144 00001F2E EBC3                     jmp @@toupper213
  5145                                  @@toupper214:
  5146                                  
  5147                                  ;-190 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5148                                  
  5149                                  
  5150                                  ;-191 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5151 00001F30 C9                       LEAVE
  5152 00001F31 C3                       ret
  5153                                  ; ENDP
  5154                                  ;Number of CALLs:    4 : strlen
  5155                                  
  5156                                  strlen:  ; *** PROC ***
  5157                                  ;Function : strlen, Number of local variables: 2
  5158                                  ;   # type sign width line used address name   list of local variables
  5159                                  ;  200 ptr sign byte   191 NULL bp+4    s
  5160                                  ;  201 var sign word   191 NULL bp-2    c;
  5161 00001F32 C8020000                 ENTER  2,0
  5162 00001F36 66B800000000             mov eax, 0
  5163 00001F3C 8946FE                   mov word [bp-2], ax
  5164                                  @@strlen217:
  5165 00001F3F 8B5E04                   mov bx, [bp+4]
  5166 00001F42 8A07                     mov al, [bx]
  5167 00001F44 B400                     mov ah, 0
  5168 00001F46 83F800                   cmp ax, 0
  5169 00001F49 0F840800                 je  @@strlen218
  5170 00001F4D FF4604                   inc  word [bp+4]
  5171 00001F50 FF46FE                   inc  word [bp-2]
  5172 00001F53 EBEA                     jmp @@strlen217
  5173                                  @@strlen218:
  5174 00001F55 8B46FE                   mov ax, [bp-2]
  5175 00001F58 E90000                   jmp @@retn
  5176                                  
  5177                                  ;-192 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5178                                  
  5179 00001F5B C9                      @@retn: LEAVE
  5180 00001F5C C3                       ret
  5181                                  ; ENDP
  5182                                  ;Number of CALLs:    5 : strcpy
  5183                                  
  5184                                  strcpy:  ; *** PROC ***
  5185                                  ;Function : strcpy, Number of local variables: 2
  5186                                  ;   # type sign width line used address name   list of local variables
  5187                                  ;  200 ptr sign byte   192 NULL bp+4    s
  5188                                  ;  201 ptr sign byte   192 NULL bp+6    t;
  5189 00001F5D C8000000                 ENTER  0,0
  5190                                  @@strcpy219:
  5191 00001F61 8B5E06                   mov bx, [bp+6]
  5192 00001F64 8A07                     mov al, [bx]
  5193 00001F66 B400                     mov ah, 0
  5194 00001F68 8B5E04                   mov  bx, [bp+4]
  5195 00001F6B 8807                     mov  [bx], al
  5196 00001F6D FF4604                   inc  word [bp+4]
  5197 00001F70 FF4606                   inc  word [bp+6]
  5198                                  
  5199                                  ;-193   while (*t!=0); *s=0; return s; }
  5200                                  
  5201 00001F73 8B5E06                   mov bx, [bp+6]
  5202 00001F76 8A07                     mov al, [bx]
  5203 00001F78 B400                     mov ah, 0
  5204 00001F7A 83F800                   cmp ax, 0
  5205 00001F7D 0F840200                 je  @@strcpy220
  5206 00001F81 EBDE                     jmp @@strcpy219
  5207                                  @@strcpy220:
  5208 00001F83 66B800000000             mov eax, 0
  5209 00001F89 8B5E04                   mov  bx, [bp+4]
  5210 00001F8C 8807                     mov  [bx], al
  5211 00001F8E 8B4604                   mov ax, [bp+4]
  5212 00001F91 E90000                   jmp @@retn
  5213                                  
  5214                                  ;-194 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5215                                  
  5216 00001F94 C9                      @@retn: LEAVE
  5217 00001F95 C3                       ret
  5218                                  ; ENDP
  5219                                  ;Number of CALLs:    3 : digit
  5220                                  
  5221                                  digit:  ; *** PROC ***
  5222                                  ;Function : digit, Number of local variables: 1
  5223                                  ;   # type sign width line used address name   list of local variables
  5224                                  ;  200 var sign byte   194 NULL bp+4    c;
  5225 00001F96 C8000000                 ENTER  0,0
  5226 00001F9A 8A4604                   mov al, [bp+4]
  5227 00001F9D 3C30                     cmp al, 48
  5228 00001F9F 0F8D0900                 jge @@digit221
  5229 00001FA3 66B800000000             mov eax, 0
  5230 00001FA9 E91B00                   jmp @@retn
  5231                                  @@digit221:
  5232 00001FAC 8A4604                   mov al, [bp+4]
  5233 00001FAF 3C39                     cmp al, 57
  5234 00001FB1 0F8E0900                 jle @@digit222
  5235 00001FB5 66B800000000             mov eax, 0
  5236 00001FBB E90900                   jmp @@retn
  5237                                  @@digit222:
  5238 00001FBE 66B801000000             mov eax, 1
  5239 00001FC4 E90000                   jmp @@retn
  5240                                  
  5241                                  ;-195 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5242                                  
  5243 00001FC7 C9                      @@retn: LEAVE
  5244 00001FC8 C3                       ret
  5245                                  ; ENDP
  5246                                  ;Number of CALLs:   35 : eqstr
  5247                                  
  5248                                  eqstr:  ; *** PROC ***
  5249                                  ;Function : eqstr, Number of local variables: 2
  5250                                  ;   # type sign width line used address name   list of local variables
  5251                                  ;  200 ptr sign byte   195 NULL bp+4    p
  5252                                  ;  201 ptr sign byte   195 NULL bp+6    q;
  5253 00001FC9 C8000000                 ENTER  0,0
  5254                                  @@eqstr223:
  5255 00001FCD 8B5E04                   mov bx, [bp+4]
  5256 00001FD0 8A07                     mov al, [bx]
  5257 00001FD2 B400                     mov ah, 0
  5258 00001FD4 08C0                     or  al, al
  5259 00001FD6 0F842300                 je @@eqstr224
  5260                                  
  5261                                  ;-196     if (*p != *q) return 0; p++; q++; }
  5262                                  
  5263 00001FDA 8B5E04                   mov bx, [bp+4]
  5264 00001FDD 8A07                     mov al, [bx]
  5265 00001FDF B400                     mov ah, 0
  5266 00001FE1 8B5E06                   mov bx, [bp+6]
  5267 00001FE4 3A07                     cmp al, [bx]
  5268 00001FE6 B400                     mov ah, 0
  5269 00001FE8 0F840900                 je  @@eqstr225
  5270 00001FEC 66B800000000             mov eax, 0
  5271 00001FF2 E92700                   jmp @@retn
  5272                                  @@eqstr225:
  5273 00001FF5 FF4604                   inc  word [bp+4]
  5274 00001FF8 FF4606                   inc  word [bp+6]
  5275                                  
  5276                                  ;-197     if(*q) return 0; return 1; }
  5277                                  
  5278 00001FFB EBD0                     jmp @@eqstr223
  5279                                  @@eqstr224:
  5280 00001FFD 8B5E06                   mov bx, [bp+6]
  5281 00002000 8A07                     mov al, [bx]
  5282 00002002 B400                     mov ah, 0
  5283 00002004 08C0                     or  al, al
  5284 00002006 0F840900                 je @@eqstr226
  5285 0000200A 66B800000000             mov eax, 0
  5286 00002010 E90900                   jmp @@retn
  5287                                  @@eqstr226:
  5288 00002013 66B801000000             mov eax, 1
  5289 00002019 E90000                   jmp @@retn
  5290                                  
  5291                                  ;-198 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5292                                  
  5293 0000201C C9                      @@retn: LEAVE
  5294 0000201D C3                       ret
  5295                                  ; ENDP
  5296                                  ;Number of CALLs:    3 : strcat1
  5297                                  
  5298                                  strcat1:  ; *** PROC ***
  5299                                  ;Function : strcat1, Number of local variables: 2
  5300                                  ;   # type sign width line used address name   list of local variables
  5301                                  ;  200 ptr sign byte   198 NULL bp+4    s
  5302                                  ;  201 ptr sign byte   198 NULL bp+6    t;
  5303 0000201E C8000000                 ENTER  0,0
  5304                                  @@strcat1227:
  5305 00002022 8B5E04                   mov bx, [bp+4]
  5306 00002025 8A07                     mov al, [bx]
  5307 00002027 B400                     mov ah, 0
  5308 00002029 83F800                   cmp ax, 0
  5309 0000202C 0F840500                 je  @@strcat1228
  5310 00002030 FF4604                   inc  word [bp+4]
  5311 00002033 EBED                     jmp @@strcat1227
  5312                                  @@strcat1228:
  5313 00002035 FF7606                   push word [bp+6]
  5314 00002038 FF7604                   push word [bp+4]
  5315 0000203B E81FFF                   call strcpy
  5316 0000203E 83C404                   add  sp, 4
  5317                                  
  5318                                  ;-199 int basename(char *s) { char *p; p=0;
  5319 00002041 C9                       LEAVE
  5320 00002042 C3                       ret
  5321                                  ; ENDP
  5322                                  ;Number of CALLs:    1 : openR
  5323                                  
  5324                                  openR:  ; *** PROC ***
  5325                                  ;Function : openR, Number of local variables: 1
  5326                                  ;   # type sign width line used address name   list of local variables
  5327                                  ;  200 ptr sign byte   199 NULL bp+4    s;
  5328 00002043 C8000000                 ENTER  0,0
  5329 00002047 8B5604                   mov  dx, [bp+4]
  5330 0000204A B8023D                   mov  ax, 15618
  5331 0000204D E87200                   call DosInt
  5332                                  
  5333                                  ;-200 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5334 00002050 C9                       LEAVE
  5335 00002051 C3                       ret
  5336                                  ; ENDP
  5337                                  ;Number of CALLs:    2 : creatR
  5338                                  
  5339                                  creatR:  ; *** PROC ***
  5340                                  ;Function : creatR, Number of local variables: 1
  5341                                  ;   # type sign width line used address name   list of local variables
  5342                                  ;  200 ptr sign byte   200 NULL bp+4    s;
  5343 00002052 C8000000                 ENTER  0,0
  5344 00002056 8B5604                   mov  dx, [bp+4]
  5345 00002059 B90000                   mov  cx, 0
  5346 0000205C B8003C                   mov  ax, 15360
  5347 0000205F E86000                   call DosInt
  5348                                  
  5349                                  ;-201 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5350 00002062 C9                       LEAVE
  5351 00002063 C3                       ret
  5352                                  ; ENDP
  5353                                  ;Number of CALLs:    2 : readRL
  5354                                  
  5355                                  readRL:  ; *** PROC ***
  5356                                  ;Function : readRL, Number of local variables: 3
  5357                                  ;   # type sign width line used address name   list of local variables
  5358                                  ;  200 ptr sign byte   201 NULL bp+4    s
  5359                                  ;  201 var sign word   201 NULL bp+6    fd
  5360                                  ;  202 var sign word   201 NULL bp+8    len;
  5361 00002064 C8000000                 ENTER  0,0
  5362 00002068 8B5604                   mov  dx, [bp+4]
  5363 0000206B 8B4E08                   mov  cx, [bp+8]
  5364 0000206E 8B5E06                   mov  bx, [bp+6]
  5365 00002071 B8003F                   mov  ax, 16128
  5366 00002074 E84B00                   call DosInt
  5367                                  
  5368                                  ;-202 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5369 00002077 C9                       LEAVE
  5370 00002078 C3                       ret
  5371                                  ; ENDP
  5372                                  ;Number of CALLs:    2 : fputcR
  5373                                  
  5374                                  fputcR:  ; *** PROC ***
  5375                                  ;Function : fputcR, Number of local variables: 2
  5376                                  ;   # type sign width line used address name   list of local variables
  5377                                  ;  200 ptr sign byte   202 NULL bp+4    n
  5378                                  ;  201 var sign word   202 NULL bp+6    fd;
  5379 00002079 C8000000                 ENTER  0,0
  5380 0000207D 8D5604                  lea dx, [bp+4]
  5381                                  
  5382                                  ;-203   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5383                                  
  5384 00002080 B90100                   mov  cx, 1
  5385 00002083 8B5E06                   mov  bx, [bp+6]
  5386 00002086 B80040                   mov  ax, 16384
  5387 00002089 E83600                   call DosInt
  5388                                  
  5389                                  ;-204 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5390 0000208C C9                       LEAVE
  5391 0000208D C3                       ret
  5392                                  ; ENDP
  5393                                  ;Number of CALLs:    3 : fcloseR
  5394                                  
  5395                                  fcloseR:  ; *** PROC ***
  5396                                  ;Function : fcloseR, Number of local variables: 1
  5397                                  ;   # type sign width line used address name   list of local variables
  5398                                  ;  200 var sign word   204 NULL bp+4    fd;
  5399 0000208E C8000000                 ENTER  0,0
  5400 00002092 8B5E04                   mov  bx, [bp+4]
  5401 00002095 B8003E                   mov  ax, 15872
  5402 00002098 CD21                     int  33
  5403                                  
  5404                                  ;-205 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5405 0000209A C9                       LEAVE
  5406 0000209B C3                       ret
  5407                                  ; ENDP
  5408                                  ;Number of CALLs:    5 : exitR
  5409                                  
  5410                                  exitR:  ; *** PROC ***
  5411                                  ;Function : exitR, Number of local variables: 1
  5412                                  ;   # type sign width line used address name   list of local variables
  5413                                  ;  200 var sign byte   205 NULL bp+4    c;
  5414 0000209C C8000000                 ENTER  0,0
  5415 000020A0 B44C                     mov  ah, 76
  5416 000020A2 8A4604                   mov  al, [bp+4]
  5417 000020A5 CD21                     int  33
  5418                                  
  5419                                  ;-206 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5420 000020A7 C9                       LEAVE
  5421 000020A8 C3                       ret
  5422                                  ; ENDP
  5423                                  ;End of archive file. 
  5424                                   
  5425                                  ; missing functions: 
  5426                                  ; putch
  5427                                  ; DosInt
  5428                                  ; DosInt
  5429                                  ; DosInt
  5430                                  ; DosInt
  5431                                  ; Number of unresolved CALLs :    5
  5432                                  ;use archive file: AR.C
  5433                                  
  5434                                  ;-207 // AR.C Archive
  5435                                  
  5436                                  ;Number of CALLs:    1 : putch
  5437                                  
  5438                                  putch:  ; *** PROC ***
  5439                                  ;Function : putch, Number of local variables: 1
  5440                                  ;   # type sign width line used address name   list of local variables
  5441                                  ;  200 var sign byte   207 NULL bp+4    c;
  5442 000020A9 C8000000                 ENTER  0,0
  5443 000020AD 807E040A                cmp byte [bp+4], 10
  5444 000020B1 0F850500                 jne @@putch229
  5445 000020B5 B00D                     mov  al, 13
  5446 000020B7 E8FFFD                   call writetty
  5447                                  @@putch229:
  5448 000020BA 8A4604                   mov  al, [bp+4]
  5449 000020BD E8F9FD                   call writetty
  5450                                  
  5451                                  ;-208 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5452 000020C0 C9                       LEAVE
  5453 000020C1 C3                       ret
  5454                                  ; ENDP
  5455                                  ;Number of CALLs:    4 : DosInt
  5456                                  
  5457                                  DosInt:  ; *** PROC ***
  5458 000020C2 CD21                     int  33
  5459 000020C4 7304                     jae short @@DosInt230
  5460 000020C6 FF06[2F00]               inc  word [DOS_ERR]
  5461                                  @@DosInt230:
  5462                                  
  5463                                  ;-209 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5464                                  
  5465 000020CA C3                       ret
  5466                                  ; ENDP
  5467                                  ;End of archive file. 
  5468                                   
  5469                                  ; missing functions:  All FUNCTIONs in place
  5470 000020CB E80000                  LastFunctionByt:db 0E8h, 0, 0
  5471 000020CE 58                      pop ax
  5472 000020CF C3                      ret
  5473                                   
  5474                                  ;   # type sign width line used  address name   list of global variables
  5475                                  
  5476                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5477                                  ;    2 var sign byte     1    3        0 LIST
  5478                                  ;    3 arr sign byte     2    7    30000 Symbol[31]
  5479                                  ;    4 arr sign byte     3   36    30031 SymbolUpper[31]
  5480                                  ;    5 var unsg word     4   12        0 SymbolInt
  5481                                  ;    6 arr sign byte     5    3    30062 InputBuf[128]
  5482                                  ;    7 ptr unsg byte     6   23        0 InputPtr
  5483                                  ;    8 arr sign byte     7    5    30190 namein[67]
  5484                                  ;    9 arr sign byte     8    5    30257 namelst[67]
  5485                                  ;   10 arr sign byte     9    5    30324 namebin[67]
  5486                                  ;   11 var sign word    10    4        0 asm_fd
  5487                                  ;   12 var sign word    11    3        0 lst_fd
  5488                                  ;   13 var sign word    12    3        0 bin_fd
  5489                                  ;   14 var sign word    13    6        0 DOS_ERR
  5490                                  ;   15 var sign word    14    4        0 ErrorCount
  5491                                  ;   16 var sign word    15    4        0 DOS_NoBytes
  5492                                  ;   17 var sign byte    16    4        0 DOS_ByteRead
  5493                                  ;   18 var unsg word    18    5        0 PC
  5494                                  ;   19 var unsg word    19    2        0 PCStart
  5495                                  ;   20 var sign byte    20    3        0 isLabel
  5496                                  ;   21 def unsg byte    21    -        0 DIGIT=1
  5497                                  ;   22 def unsg byte    22    -        0 LETTERE=2
  5498                                  ;   23 def unsg byte    23    -        0 ALNUME=3
  5499                                  ;   24 def unsg byte    24    -        0 NOALNUME=4
  5500                                  ;   25 var sign byte    25   20        0 TokeType
  5501                                  ;   26 def unsg byte    26    -        0 BYTE=1
  5502                                  ;   27 def unsg byte    27    -        0 WORD=2
  5503                                  ;   28 def unsg byte    28    -        0 DWORD=3
  5504                                  ;   29 def unsg byte    29    -        0 SEGREG=4
  5505                                  ;   30 def unsg byte    31    -        0 IMM=1
  5506                                  ;   31 def unsg byte    32    -        0 REG=2
  5507                                  ;   32 def unsg byte    33    -        0 DIR=3
  5508                                  ;   33 def unsg byte    34    -        0 IND=4
  5509                                  ;   34 var sign byte    35   13        0 Op1
  5510                                  ;   35 var sign byte    36   12        0 CodeType
  5511                                  ;   36 var sign byte    38   17        0 RegType
  5512                                  ;   37 var sign byte    39   10        0 RegNo
  5513                                  ;   38 var sign byte    40   10        0 OpSize
  5514                                  ;   39 var sign byte    42 NULL        0 NumOprns
  5515                                  ;   40 var sign byte    43    5        0 wflag
  5516                                  ;   41 var sign byte    44 NULL        0 dflag
  5517                                  ;   42 var sign byte    46    4        0 reg
  5518                                  ;   43 var sign word    47   13        0 disp
  5519                                  ;   44 var sign word    48    2        0 imme
  5520                                  ;   45 def unsg byte    50    -        0 OPMAXLEN=5
  5521                                  ;   46 arr sign byte    51    2    30391 OpPos[5]
  5522                                  ;   47 var sign word    52    6        0 OpPrintIndex
  5523                                  ;   48 ptr sign byte    53   16        0 OpCodePtr
  5524                                  ;   49 var sign byte    54    2        0 PrReloc
  5525                                  ;   50 arr sign byte    56    3    30396 LabelNames[1000]
  5526                                  ;   51 ptr sign byte    57   10        0 LabelNamePtr
  5527                                  ;   52 arr unsg word    58    4    31396 LabelAddr[100]
  5528                                  ;   53 var sign word    59    5        0 LabelMaxIx
  5529                                  ;   54 var sign word    60    4        0 LabelIx
  5530                                  ;   55 arr sign byte    62    3    31596 FileBin[2000]
  5531                                  ;   56 var unsg word    63    5        0 BinLen
  5532                                  ;   57 ptr sign byte    65    1        0 arglen
  5533                                  ;   58 ptr sign byte    66    4        0 argv
  5534                                  ;   59 var sign byte     1    1        0 I_START
  5535                                  ;   60 arr sign byte     4 NULL        0 I_PUSHA[9]
  5536                                  ;   61 arr sign byte     5 NULL        0 I_POPA[8]
  5537                                  ;   62 arr sign byte     6 NULL        0 I_NOP[7]
  5538                                  ;   63 arr sign byte     7 NULL        0 I_CBW[7]
  5539                                  ;   64 arr sign byte     8 NULL        0 I_CWDE[8]
  5540                                  ;   65 arr sign byte     9 NULL        0 I_CWD[7]
  5541                                  ;   66 arr sign byte    10 NULL        0 I_CDQ[7]
  5542                                  ;   67 arr sign byte    11 NULL        0 I_WAIT[8]
  5543                                  ;   68 arr sign byte    12 NULL        0 I_PUSHF[9]
  5544                                  ;   69 arr sign byte    13 NULL        0 I_POPF[8]
  5545                                  ;   70 arr sign byte    14 NULL        0 I_SAHF[8]
  5546                                  ;   71 arr sign byte    15 NULL        0 I_LAHF[8]
  5547                                  ;   72 arr sign byte    16 NULL        0 I_MOVSB[9]
  5548                                  ;   73 arr sign byte    17 NULL        0 I_MOVSW[9]
  5549                                  ;   74 arr sign byte    18 NULL        0 I_CMPSB[9]
  5550                                  ;   75 arr sign byte    19 NULL        0 I_CMPSW[9]
  5551                                  ;   76 arr sign byte    20 NULL        0 I_STOSB[9]
  5552                                  ;   77 arr sign byte    21 NULL        0 I_STOSW[9]
  5553                                  ;   78 arr sign byte    22 NULL        0 I_LODSB[9]
  5554                                  ;   79 arr sign byte    23 NULL        0 I_LODSW[9]
  5555                                  ;   80 arr sign byte    24 NULL        0 I_SCASB[9]
  5556                                  ;   81 arr sign byte    25 NULL        0 I_SCASW[9]
  5557                                  ;   82 arr sign byte    26 NULL        0 I_LEAVE[9]
  5558                                  ;   83 arr sign byte    27 NULL        0 I_IRET[8]
  5559                                  ;   84 arr sign byte    28 NULL        0 I_XLAT[8]
  5560                                  ;   85 arr sign byte    29 NULL        0 I_LOCK[8]
  5561                                  ;   86 arr sign byte    30 NULL        0 I_REPNE[9]
  5562                                  ;   87 arr sign byte    31 NULL        0 I_REPNZ[9]
  5563                                  ;   88 arr sign byte    32 NULL        0 I_REPE[8]
  5564                                  ;   89 arr sign byte    33 NULL        0 I_REPZ[8]
  5565                                  ;   90 arr sign byte    34 NULL        0 I_HLT[7]
  5566                                  ;   91 arr sign byte    35 NULL        0 I_CLC[7]
  5567                                  ;   92 arr sign byte    36 NULL        0 I_STC[7]
  5568                                  ;   93 arr sign byte    37 NULL        0 I_CLI[7]
  5569                                  ;   94 arr sign byte    38 NULL        0 I_STI[7]
  5570                                  ;   95 arr sign byte    39 NULL        0 I_CLD[7]
  5571                                  ;   96 arr sign byte    40 NULL        0 I_STD[7]
  5572                                  ;   97 arr sign byte    42 NULL        0 I_INC[9]
  5573                                  ;   98 arr sign byte    43 NULL        0 I_DEC[9]
  5574                                  ;   99 arr sign byte    45 NULL        0 I_NOT[8]
  5575                                  ;  100 arr sign byte    46 NULL        0 I_NEG[8]
  5576                                  ;  101 arr sign byte    47 NULL        0 I_MUL[8]
  5577                                  ;  102 arr sign byte    48 NULL        0 I_IMUL[9]
  5578                                  ;  103 arr sign byte    49 NULL        0 I_DIV[8]
  5579                                  ;  104 arr sign byte    50 NULL        0 I_IDIV[9]
  5580                                  ;  105 arr sign byte    52 NULL        0 I_LES[7]
  5581                                  ;  106 arr sign byte    53 NULL        0 I_LDS[7]
  5582                                  ;  107 arr sign byte    54 NULL        0 I_LEA[7]
  5583                                  ;  108 arr sign byte    56 NULL        0 I_ADD[7]
  5584                                  ;  109 arr sign byte    57 NULL        0 I_OR[6]
  5585                                  ;  110 arr sign byte    58 NULL        0 I_ADC[7]
  5586                                  ;  111 arr sign byte    59 NULL        0 I_SBB[7]
  5587                                  ;  112 arr sign byte    60 NULL        0 I_AND[7]
  5588                                  ;  113 arr sign byte    61 NULL        0 I_SUB[7]
  5589                                  ;  114 arr sign byte    62 NULL        0 I_XOR[7]
  5590                                  ;  115 arr sign byte    63 NULL        0 I_CMP[7]
  5591                                  ;  116 arr sign byte    65 NULL        0 I_MOV[6]
  5592                                  ;  117 arr sign byte    66 NULL        0 I_MOVSX[9]
  5593                                  ;  118 arr sign byte    67 NULL        0 I_MOVZX[9]
  5594                                  ;  119 arr sign byte    69 NULL        0 I_JO[6]
  5595                                  ;  120 arr sign byte    70 NULL        0 I_JNO[7]
  5596                                  ;  121 arr sign byte    71 NULL        0 I_JB[6]
  5597                                  ;  122 arr sign byte    72 NULL        0 I_JC[6]
  5598                                  ;  123 arr sign byte    73 NULL        0 I_JNB[7]
  5599                                  ;  124 arr sign byte    74 NULL        0 I_JAE[7]
  5600                                  ;  125 arr sign byte    75 NULL        0 I_JNC[7]
  5601                                  ;  126 arr sign byte    76 NULL        0 I_JE[6]
  5602                                  ;  127 arr sign byte    77 NULL        0 I_JZ[6]
  5603                                  ;  128 arr sign byte    78 NULL        0 I_JNE[7]
  5604                                  ;  129 arr sign byte    79 NULL        0 I_JNZ[7]
  5605                                  ;  130 arr sign byte    80 NULL        0 I_JBE[7]
  5606                                  ;  131 arr sign byte    81 NULL        0 I_JNA[7]
  5607                                  ;  132 arr sign byte    82 NULL        0 I_JA[6]
  5608                                  ;  133 arr sign byte    83 NULL        0 I_JS[6]
  5609                                  ;  134 arr sign byte    84 NULL        0 I_JNS[7]
  5610                                  ;  135 arr sign byte    85 NULL        0 I_JP[6]
  5611                                  ;  136 arr sign byte    86 NULL        0 I_JPE[7]
  5612                                  ;  137 arr sign byte    87 NULL        0 I_JNP[7]
  5613                                  ;  138 arr sign byte    88 NULL        0 I_JPO[7]
  5614                                  ;  139 arr sign byte    89 NULL        0 I_JL[6]
  5615                                  ;  140 arr sign byte    90 NULL        0 I_JNL[7]
  5616                                  ;  141 arr sign byte    91 NULL        0 I_JGE[7]
  5617                                  ;  142 arr sign byte    92 NULL        0 I_JLE[7]
  5618                                  ;  143 arr sign byte    93 NULL        0 I_JNG[7]
  5619                                  ;  144 arr sign byte    94 NULL        0 I_JG[6]
  5620                                  ;  145 arr sign byte    96 NULL        0 I_JMP[8]
  5621                                  ;  146 arr sign byte    97 NULL        0 I_CALL[9]
  5622                                  ;  147 arr sign byte    99 NULL        0 I_RET[8]
  5623                                  ;  148 arr sign byte   100 NULL        0 I_RETF[9]
  5624                                  ;  149 arr sign byte   102 NULL        0 I_PUSH[8]
  5625                                  ;  150 arr sign byte   103 NULL        0 I_POP[7]
  5626                                  ;  151 arr sign byte   105 NULL        0 I_ROL[7]
  5627                                  ;  152 arr sign byte   106 NULL        0 I_ROR[7]
  5628                                  ;  153 arr sign byte   107 NULL        0 I_RCL[7]
  5629                                  ;  154 arr sign byte   108 NULL        0 I_RCR[7]
  5630                                  ;  155 arr sign byte   109 NULL        0 I_SHL[7]
  5631                                  ;  156 arr sign byte   110 NULL        0 I_SAL[7]
  5632                                  ;  157 arr sign byte   111 NULL        0 I_SHR[7]
  5633                                  ;  158 arr sign byte   112 NULL        0 I_SAR[7]
  5634                                  ;  159 arr sign byte   114 NULL        0 I_INT[8]
  5635                                  ;  160 arr sign byte   115 NULL        0 I_INTO[8]
  5636                                  ;  161 arr sign byte   117 NULL        0 I_IN[7]
  5637                                  ;  162 arr sign byte   118 NULL        0 I_INSB[8]
  5638                                  ;  163 arr sign byte   119 NULL        0 I_INSW[8]
  5639                                  ;  164 arr sign byte   120 NULL        0 I_INSD[8]
  5640                                  ;  165 arr sign byte   121 NULL        0 I_OUT[8]
  5641                                  ;  166 arr sign byte   122 NULL        0 I_OUTSB[8]
  5642                                  ;  167 arr sign byte   123 NULL        0 I_OUTSW[8]
  5643                                  ;  168 arr sign byte   124 NULL        0 I_OUTSD[8]
  5644                                  ;  169 arr sign byte   126 NULL        0 I_XCHG[9]
  5645                                  ;  170 arr sign byte   128 NULL        0 I_LOOPNZ[10]
  5646                                  ;  171 arr sign byte   129 NULL        0 I_LOOPNE[10]
  5647                                  ;  172 arr sign byte   130 NULL        0 I_LOOPZ[9]
  5648                                  ;  173 arr sign byte   131 NULL        0 I_LOOPE[9]
  5649                                  ;  174 arr sign byte   132 NULL        0 I_LOOP[8]
  5650                                  ;  175 arr sign byte   133 NULL        0 I_JCXZ[8]
  5651                                  ;  176 arr sign byte   134 NULL        0 I_JECXZ[9]
  5652                                  ;  177 arr sign byte   136 NULL        0 I_ENTER[9]
  5653                                  ;  178 arr sign byte   138 NULL        0 I_ORG[6]
  5654                                  ;  179 arr sign byte   139 NULL        0 I_DB[5]
  5655                                  ;  180 arr sign byte   140 NULL        0 I_DW[5]
  5656                                  ;  181 arr sign byte   141 NULL        0 I_DD[5]
  5657                                  ;  182 arr sign byte   142 NULL        0 I_RESB[7]
  5658                                  ;  183 arr sign byte   143 NULL        0 I_RESW[7]
  5659                                  ;  184 arr sign byte   144 NULL        0 I_RESD[7]
  5660                                  ;  185 var sign byte   145 NULL        0 I_END
  5661                                  
  5662                                  
  5663                                  ;   # Calls Line Width  Name   list of functions
  5664                                  
  5665                                  ;    0 NULL    1 word   main
  5666                                  ;    1 NULL    5 word   test1
  5667                                  ;    2    1   22 word   process
  5668                                  ;    3    2   73 word   LeftOpwCheck
  5669                                  ;    4    1   83 word   getLeftOp
  5670                                  ;    5    1   95 word   setwflag
  5671                                  ;    6    2  103 word   getOp1
  5672                                  ;    7    1  115 word   getIND
  5673                                  ;    8    1  130 word   getIndReg1
  5674                                  ;    9    1  139 word   getIndReg2
  5675                                  ;   10    1  150 word   gen66h
  5676                                  ;   11    8  151 word   genCode8
  5677                                  ;   12    3  155 word   genCode16
  5678                                  ;   13    7  158 word   genInstruction
  5679                                  ;   14    2  162 word   genCodeInREG
  5680                                  ;   15 NULL  165 word   genModRegRM
  5681                                  ;   16    2  167 word   writeEA
  5682                                  ;   17    1    1 word   parse
  5683                                  ;   18   12   27 word   getTokeType
  5684                                  ;   19    2   36 word   storeLabel
  5685                                  ;   20    2   43 word   searchLabel
  5686                                  ;   21    1   54 word   getVariable
  5687                                  ;   22    2   83 word   lookCode
  5688                                  ;   23    1   97 word   getCodeSize
  5689                                  ;   24    7  104 word   isToken
  5690                                  ;   25    1  109 word   skipRest
  5691                                  ;   26    1    1 word   getLine
  5692                                  ;   27    1   14 word   ifEOL
  5693                                  ;   28    3   21 word   skipBlank
  5694                                  ;   29    2   26 word   letterE
  5695                                  ;   30    1   36 word   alnumE
  5696                                  ;   31    1   41 word   getDigit
  5697                                  ;   32    1   53 word   getName
  5698                                  ;   33    1   70 word   testReg
  5699                                  ;   34    1    1 word   printLine
  5700                                  ;   35    9   19 word   prc
  5701                                  ;   36    1   23 word   prscomment
  5702                                  ;   37   24   26 word   prs
  5703                                  ;   38    4   31 word   printhex8a
  5704                                  ;   39    2   35 word   printhex16
  5705                                  ;   40    3   38 word   printIntU
  5706                                  ;   41   19   45 word   error1
  5707                                  ;   42 NULL   48 word   allowederror
  5708                                  ;   43 NULL   49 word   implmerror
  5709                                  ;   44    4   50 word   indexerror
  5710                                  ;   45    1   51 word   numbererror
  5711                                  ;   46 NULL   52 word   regmemerror
  5712                                  ;   47    1   53 word   segregerror
  5713                                  ;   48    1   54 word   syntaxerror
  5714                                  ;   49    7   56 word   errorexit
  5715                                  ;   50    1   57 word   addrexit
  5716                                  ;   51 NULL   58 word   internexit
  5717                                  ;   52    1    1 word   getarg
  5718                                  ;   53    1   26 word   epilog
  5719                                  ;   54    2   57 word   end1
  5720                                  ;   55    4  187 word   writetty
  5721                                  ;   56    8  188 word   cputs
  5722                                  ;   57    2  189 word   toupper
  5723                                  ;   58    4  191 word   strlen
  5724                                  ;   59    6  192 word   strcpy
  5725                                  ;   60    3  194 word   digit
  5726                                  ;   61   35  195 word   eqstr
  5727                                  ;   62    3  198 word   strcat1
  5728                                  ;   63    1  199 word   openR
  5729                                  ;   64    2  200 word   creatR
  5730                                  ;   65    2  201 word   readRL
  5731                                  ;   66    2  202 word   fputcR
  5732                                  ;   67    3  204 word   fcloseR
  5733                                  ;   68    5  205 word   exitR
  5734                                  ;   69    1  207 word   putch
  5735                                  ;   70    4  208 word   DosInt
  5736                                  ;   71 NULL  209 word   LastFunctionByt
  5737                                  
  5738                                  ;    #  addr name   list of CALLs
  5739                                  
  5740                                  ;    0     5 getarg
  5741                                  ;    1    12 parse
  5742                                  ;    2    18 epilog
  5743                                  ;    3    25 end1
  5744                                  ;    4  1318 getTokeType
  5745                                  ;    5  1330 getCodeSize
  5746                                  ;    6  1342 genInstruction
  5747                                  ;    7  1357 LeftOpwCheck
  5748                                  ;    8  1370 genInstruction
  5749                                  ;    9  1385 genInstruction
  5750                                  ;   10  1400 genInstruction
  5751                                  ;   11  1415 genCodeInREG
  5752                                  ;   12  1428 LeftOpwCheck
  5753                                  ;   13  1441 genInstruction
  5754                                  ;   14  1456 genCodeInREG
  5755                                  ;   15  1469 genInstruction
  5756                                  ;   16  1484 genCode16
  5757                                  ;   17  1494 genInstruction
  5758                                  ;   18  1509 error1
  5759                                  ;   19  1516 error1
  5760                                  ;   20  1536 getLeftOp
  5761                                  ;   21  1546 segregerror
  5762                                  ;   22  1558 setwflag
  5763                                  ;   23  1567 error1
  5764                                  ;   24  1574 error1
  5765                                  ;   25  1581 error1
  5766                                  ;   26  1598 getOp1
  5767                                  ;   27  1605 isToken
  5768                                  ;   28  1613 getIND
  5769                                  ;   29  1620 error1
  5770                                  ;   30  1627 error1
  5771                                  ;   31  1643 gen66h
  5772                                  ;   32  1657 testReg
  5773                                  ;   33  1665 searchLabel
  5774                                  ;   34  1677 error1
  5775                                  ;   35  1698 getTokeType
  5776                                  ;   36  1710 getOp1
  5777                                  ;   37  1717 syntaxerror
  5778                                  ;   38  1729 getIndReg2
  5779                                  ;   39  1740 getIndReg1
  5780                                  ;   40  1751 isToken
  5781                                  ;   41  1759 getTokeType
  5782                                  ;   42  1771 numbererror
  5783                                  ;   43  1783 isToken
  5784                                  ;   44  1791 isToken
  5785                                  ;   45  1799 errorexit
  5786                                  ;   46  1822 indexerror
  5787                                  ;   47  1833 indexerror
  5788                                  ;   48  1860 indexerror
  5789                                  ;   49  1871 indexerror
  5790                                  ;   50  1889 genCode8
  5791                                  ;   51  1921 genCode8
  5792                                  ;   52  1930 genCode8
  5793                                  ;   53  1963 genCode8
  5794                                  ;   54  1987 writeEA
  5795                                  ;   55  2007 writeEA
  5796                                  ;   56  2031 addrexit
  5797                                  ;   57  2040 genCode8
  5798                                  ;   58  2049 genCode8
  5799                                  ;   59  2058 genCode16
  5800                                  ;   60  2074 getLine
  5801                                  ;   61  2082 getTokeType
  5802                                  ;   62  2094 storeLabel
  5803                                  ;   63  2105 getTokeType
  5804                                  ;   64  2117 lookCode
  5805                                  ;   65  2126 process
  5806                                  ;   66  2134 getVariable
  5807                                  ;   67  2146 skipRest
  5808                                  ;   68  2155 error1
  5809                                  ;   69  2162 error1
  5810                                  ;   70  2169 printLine
  5811                                  ;   71  2193 skipBlank
  5812                                  ;   72  2203 digit
  5813                                  ;   73  2209 getDigit
  5814                                  ;   74  2218 letterE
  5815                                  ;   75  2226 getName
  5816                                  ;   76  2245 searchLabel
  5817                                  ;   77  2257 error1
  5818                                  ;   78  2264 strcpy
  5819                                  ;   79  2291 eqstr
  5820                                  ;   80  2297 strlen
  5821                                  ;   81  2318 storeLabel
  5822                                  ;   82  2329 getTokeType
  5823                                  ;   83  2341 lookCode
  5824                                  ;   84  2350 errorexit
  5825                                  ;   85  2360 errorexit
  5826                                  ;   86  2370 getTokeType
  5827                                  ;   87  2382 genCode8
  5828                                  ;   88  2391 skipBlank
  5829                                  ;   89  2401 isToken
  5830                                  ;   90  2409 genCode8
  5831                                  ;   91  2418 isToken
  5832                                  ;   92  2426 getTokeType
  5833                                  ;   93  2438 genCode16
  5834                                  ;   94  2448 isToken
  5835                                  ;   95  2456 errorexit
  5836                                  ;   96  2475 eqstr
  5837                                  ;   97  2493 eqstr
  5838                                  ;   98  2499 getTokeType
  5839                                  ;   99  2511 eqstr
  5840                                  ;  100  2517 getTokeType
  5841                                  ;  101  2529 eqstr
  5842                                  ;  102  2535 getTokeType
  5843                                  ;  103  2557 skipBlank
  5844                                  ;  104  2576 getTokeType
  5845                                  ;  105  2588 prs
  5846                                  ;  106  2600 readRL
  5847                                  ;  107  2607 errorexit
  5848                                  ;  108  2617 ifEOL
  5849                                  ;  109  2631 readRL
  5850                                  ;  110  2667 digit
  5851                                  ;  111  2673 letterE
  5852                                  ;  112  2700 digit
  5853                                  ;  113  2718 alnumE
  5854                                  ;  114  2725 strcpy
  5855                                  ;  115  2732 toupper
  5856                                  ;  116  2748 strlen
  5857                                  ;  117  2755 strlen
  5858                                  ;  118  2762 eqstr
  5859                                  ;  119  2768 eqstr
  5860                                  ;  120  2774 eqstr
  5861                                  ;  121  2780 eqstr
  5862                                  ;  122  2786 eqstr
  5863                                  ;  123  2792 eqstr
  5864                                  ;  124  2798 eqstr
  5865                                  ;  125  2804 eqstr
  5866                                  ;  126  2810 eqstr
  5867                                  ;  127  2816 eqstr
  5868                                  ;  128  2822 eqstr
  5869                                  ;  129  2828 eqstr
  5870                                  ;  130  2834 eqstr
  5871                                  ;  131  2840 eqstr
  5872                                  ;  132  2846 eqstr
  5873                                  ;  133  2852 eqstr
  5874                                  ;  134  2858 eqstr
  5875                                  ;  135  2864 eqstr
  5876                                  ;  136  2870 eqstr
  5877                                  ;  137  2876 eqstr
  5878                                  ;  138  2882 eqstr
  5879                                  ;  139  2888 eqstr
  5880                                  ;  140  2894 eqstr
  5881                                  ;  141  2900 eqstr
  5882                                  ;  142  2906 eqstr
  5883                                  ;  143  2912 eqstr
  5884                                  ;  144  2918 eqstr
  5885                                  ;  145  2924 eqstr
  5886                                  ;  146  2930 eqstr
  5887                                  ;  147  2936 eqstr
  5888                                  ;  148  2956 prs
  5889                                  ;  149  2960 printhex16
  5890                                  ;  150  2971 prs
  5891                                  ;  151  2975 prc
  5892                                  ;  152  2979 printhex8a
  5893                                  ;  153  2990 prc
  5894                                  ;  154  2994 prs
  5895                                  ;  155  2998 prscomment
  5896                                  ;  156  3015 writetty
  5897                                  ;  157  3024 writetty
  5898                                  ;  158  3033 fputcR
  5899                                  ;  159  3055 prc
  5900                                  ;  160  3071 prc
  5901                                  ;  161  3092 prc
  5902                                  ;  162  3096 prc
  5903                                  ;  163  3118 printhex8a
  5904                                  ;  164  3129 printhex8a
  5905                                  ;  165  3154 printIntU
  5906                                  ;  166  3164 prc
  5907                                  ;  167  3177 prs
  5908                                  ;  168  3181 prs
  5909                                  ;  169  3185 prs
  5910                                  ;  170  3189 prs
  5911                                  ;  171  3206 error1
  5912                                  ;  172  3224 error1
  5913                                  ;  173  3242 error1
  5914                                  ;  174  3261 error1
  5915                                  ;  175  3280 error1
  5916                                  ;  176  3299 error1
  5917                                  ;  177  3318 error1
  5918                                  ;  178  3337 error1
  5919                                  ;  179  3344 end1
  5920                                  ;  180  3358 errorexit
  5921                                  ;  181  3379 errorexit
  5922                                  ;  182  3408 cputs
  5923                                  ;  183  3414 cputs
  5924                                  ;  184  3420 exitR
  5925                                  ;  185  3426 toupper
  5926                                  ;  186  3434 strcpy
  5927                                  ;  187  3441 strcat1
  5928                                  ;  188  3449 strcpy
  5929                                  ;  189  3456 strcat1
  5930                                  ;  190  3464 strcpy
  5931                                  ;  191  3471 strcat1
  5932                                  ;  192  3479 openR
  5933                                  ;  193  3485 cputs
  5934                                  ;  194  3491 cputs
  5935                                  ;  195  3497 exitR
  5936                                  ;  196  3503 creatR
  5937                                  ;  197  3510 cputs
  5938                                  ;  198  3516 cputs
  5939                                  ;  199  3522 exitR
  5940                                  ;  200  3528 creatR
  5941                                  ;  201  3535 cputs
  5942                                  ;  202  3541 cputs
  5943                                  ;  203  3547 exitR
  5944                                  ;  204  3553 prs
  5945                                  ;  205  3557 prs
  5946                                  ;  206  3561 prs
  5947                                  ;  207  3565 prs
  5948                                  ;  208  3569 prs
  5949                                  ;  209  3573 prs
  5950                                  ;  210  3577 prs
  5951                                  ;  211  3581 prs
  5952                                  ;  212  3585 prs
  5953                                  ;  213  3602 prs
  5954                                  ;  214  3606 printIntU
  5955                                  ;  215  3616 prs
  5956                                  ;  216  3620 prs
  5957                                  ;  217  3624 prs
  5958                                  ;  218  3628 prc
  5959                                  ;  219  3632 printhex16
  5960                                  ;  220  3643 prs
  5961                                  ;  221  3647 strlen
  5962                                  ;  222  3654 prs
  5963                                  ;  223  3658 printIntU
  5964                                  ;  224  3668 prs
  5965                                  ;  225  3672 prc
  5966                                  ;  226  3676 printhex8a
  5967                                  ;  227  3687 fputcR
  5968                                  ;  228  3701 fcloseR
  5969                                  ;  229  3709 fcloseR
  5970                                  ;  230  3717 fcloseR
  5971                                  ;  231  3725 exitR
  5972                                  ;  232  3750 putch
  5973                                  ;  233  3818 strcpy
  5974                                  ;  234  3833 DosInt
  5975                                  ;  235  3849 DosInt
  5976                                  ;  236  3872 DosInt
  5977                                  ;  237  3891 DosInt
  5978                                  ;  238  3925 writetty
  5979                                  ;  239  3934 writetty
  5980                                  ;Input: AS.C, List: AS.S,  Lines:  210
  5981                                  ;Glob. variables:  185 max.:  200
  5982                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  5983                                  ;Functions      :   72 max.:  300
  5984                                  ;Calls          :  240 max.: 2000, NameField: 3966 max.:    65535
  5985                                  ;Code until     :26009 max.: 30000, free: 3991
  5986                                  ;Data (HeapEnd) :33596, resting stacksize: 31939
  5987                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
