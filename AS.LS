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
    11 00000003 E8BC19                   call getarg
    12 00000006 E80D0A                   call parse
    13 00000009 E80E1C                   call epilog
    14 0000000C E87B1D                   call end1
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
   309                                  ;-2 //todo change CodeType and Opcode (2 bytes only)
   310                                  
   311                                  
   312                                  ;-3 //OpName,0,CodeType,OpCode1,OpCodeN,F1h
   313                                  
   314                                  
   315                                  ;-4 //  1:   1 byte opcode
   316                                  
   317                                  
   318                                  ;-5 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   319                                  
   320 0000005B 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   321                                  
   322                                  ;-6 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   323                                  
   324 00000064 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   325                                  
   326                                  ;-7 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   327                                  
   328 0000006C 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   329                                  
   330                                  ;-8 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   331                                  
   332 00000073 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   333                                  
   334                                  ;-9 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   335                                  
   336 0000007A 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   337                                  
   338                                  ;-10 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   339                                  
   340 00000082 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   341                                  
   342                                  ;-11 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   343                                  
   344 00000089 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   345                                  
   346                                  ;-12 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   347                                  
   348 00000090 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   349                                  
   350                                  ;-13 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   351                                  
   352 00000098 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   353                                  
   354                                  ;-14 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   355                                  
   356 000000A1 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   357                                  
   358                                  ;-15 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   359                                  
   360 000000A9 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   361                                  
   362                                  ;-16 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   363                                  
   364 000000B1 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   365                                  
   366                                  ;-17 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   367                                  
   368 000000B9 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   369                                  
   370                                  ;-18 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   371                                  
   372 000000C2 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   373                                  
   374                                  ;-19 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   375                                  
   376 000000CB 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   377                                  
   378                                  ;-20 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   379                                  
   380 000000D4 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   381                                  
   382                                  ;-21 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   383                                  
   384 000000DD 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   385                                  
   386                                  ;-22 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   387                                  
   388 000000E6 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   389                                  
   390                                  ;-23 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   391                                  
   392 000000EF 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   393                                  
   394                                  ;-24 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   395                                  
   396 000000F8 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   397                                  
   398                                  ;-25 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   399                                  
   400 00000101 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   401                                  
   402                                  ;-26 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   403                                  
   404 0000010A 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   405                                  
   406                                  ;-27 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   407                                  
   408 00000113 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   409                                  
   410                                  ;-28 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   411                                  
   412 0000011C 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   413                                  
   414                                  ;-29 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   415                                  
   416 00000124 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   417                                  
   418                                  ;-30 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   419                                  
   420 0000012C 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   421                                  
   422                                  ;-31 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   423                                  
   424 00000134 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   425                                  
   426                                  ;-32 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   427                                  
   428 0000013D 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   429                                  
   430                                  ;-33 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   431                                  
   432 00000146 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   433                                  
   434                                  ;-34 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   435                                  
   436 0000014E 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   437                                  
   438                                  ;-35 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   439                                  
   440 00000156 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   441                                  
   442                                  ;-36 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   443                                  
   444 0000015D 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   445                                  
   446                                  ;-37 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   447                                  
   448 00000164 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   449                                  
   450                                  ;-38 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   451                                  
   452 0000016B 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   453                                  
   454                                  ;-39 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   455                                  
   456 00000172 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   457                                  
   458                                  ;-40 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   459                                  
   460 00000179 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   461                                  
   462                                  ;-41 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   463                                  
   464 00000180 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   465                                  
   466                                  ;-42 //  2: inc,dec
   467                                  
   468                                  
   469                                  ;-43 char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};
   470                                  
   471 00000187 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   472                                  
   473                                  ;-44 char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};
   474                                  
   475 00000190 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   476                                  
   477                                  ;-45 // 52: mem reg 16 bit
   478                                  
   479                                  
   480                                  ;-46 char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};
   481                                  
   482 00000199 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
   483                                  
   484                                  ;-47 char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};
   485                                  
   486 000001A1 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
   487                                  
   488                                  ;-48 char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};
   489                                  
   490 000001A9 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
   491                                  
   492                                  ;-49 char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc
   493                                  
   494 000001B1 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
   495                                  
   496                                  ;-50 char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};
   497                                  
   498 000001BA 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
   499                                  
   500                                  ;-51 char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};
   501                                  
   502 000001C2 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
   503                                  
   504                                  ;-52 //  3: les, lda, lea
   505                                  
   506                                  
   507                                  ;-53 char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16
   508                                  
   509 000001CB 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   510                                  
   511                                  ;-54 char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16
   512                                  
   513 000001D2 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   514                                  
   515                                  ;-55 char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16
   516                                  
   517 000001D9 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   518                                  
   519                                  ;-56 //  4: acc,imm  reg,imm  index,reg
   520                                  
   521                                  
   522                                  ;-57 char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};
   523                                  
   524 000001E0 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   525                                  
   526                                  ;-58 char I_OR []={'O','R',0,                4, 1,     0xF1};
   527                                  
   528 000001E7 4F52000401F1            I_OR db 79,82,0,4,1,241
   529                                  
   530                                  ;-59 char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};
   531                                  
   532 000001ED 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   533                                  
   534                                  ;-60 char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};
   535                                  
   536 000001F4 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   537                                  
   538                                  ;-61 char I_AND[]={'A','N','D',0,            4, 4,     0xF1};
   539                                  
   540 000001FB 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   541                                  
   542                                  ;-62 char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};
   543                                  
   544 00000202 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   545                                  
   546                                  ;-63 char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};
   547                                  
   548 00000209 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   549                                  
   550                                  ;-64 char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};
   551                                  
   552 00000210 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   553                                  
   554                                  ;-65 //  5: mov
   555                                  
   556                                  
   557                                  ;-66 char I_MOV[]={'M','O','V',0,            5,        0xF1};
   558                                  
   559 00000217 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   560                                  
   561                                  ;-67 //  6: single byte relative jump
   562                                  
   563                                  
   564                                  ;-68 char I_JO []={'J','O',0,                6, 0,     0xF1};
   565                                  
   566 0000021D 4A4F000600F1            I_JO db 74,79,0,6,0,241
   567                                  
   568                                  ;-69 char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};
   569                                  
   570 00000223 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   571                                  
   572                                  ;-70 char I_JB []={'J','B',0,                6, 2,     0xF1};
   573                                  
   574 0000022A 4A42000602F1            I_JB db 74,66,0,6,2,241
   575                                  
   576                                  ;-71 char I_JC []={'J','C',0,                6, 2,     0xF1};
   577                                  
   578 00000230 4A43000602F1            I_JC db 74,67,0,6,2,241
   579                                  
   580                                  ;-72 char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};
   581                                  
   582 00000236 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   583                                  
   584                                  ;-73 char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};
   585                                  
   586 0000023D 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   587                                  
   588                                  ;-74 char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};
   589                                  
   590 00000244 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   591                                  
   592                                  ;-75 char I_JE []={'J','E',0,                6, 4,     0xF1};//    74 je i8rel
   593                                  
   594 0000024B 4A45000604F1            I_JE db 74,69,0,6,4,241
   595                                  
   596                                  ;-76 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//  0F84 je i16r
   597                                  
   598 00000251 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   599                                  
   600                                  ;-77 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//660F84 je i32r
   601                                  
   602 00000257 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   603                                  
   604                                  ;-78 char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};
   605                                  
   606 0000025E 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   607                                  
   608                                  ;-79 char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};
   609                                  
   610 00000265 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   611                                  
   612                                  ;-80 char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};
   613                                  
   614 0000026C 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   615                                  
   616                                  ;-81 char I_JA []={'J','A',0,                6, 7,     0xF1};
   617                                  
   618 00000273 4A41000607F1            I_JA db 74,65,0,6,7,241
   619                                  
   620                                  ;-82 char I_JS []={'J','S',0,                6, 8,     0xF1};
   621                                  
   622 00000279 4A53000608F1            I_JS db 74,83,0,6,8,241
   623                                  
   624                                  ;-83 char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};
   625                                  
   626 0000027F 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   627                                  
   628                                  ;-84 char I_JP[]={'J','P',0,                 6,10,     0xF1};
   629                                  
   630 00000286 4A5000060AF1            I_JP db 74,80,0,6,10,241
   631                                  
   632                                  ;-85 char I_JPE[]={'J','P','E',0,            6,10,     0xF1};
   633                                  
   634 0000028C 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   635                                  
   636                                  ;-86 char I_JNP[]={'J','N','P',0,            6,11,     0xF1};
   637                                  
   638 00000293 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   639                                  
   640                                  ;-87 char I_JPO[]={'J','P','O',0,            6,11,     0xF1};
   641                                  
   642 0000029A 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   643                                  
   644                                  ;-88 char I_JL[]={'J','L',0,                 6,12,     0xF1};
   645                                  
   646 000002A1 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   647                                  
   648                                  ;-89 char I_JNL[]={'J','N','L',0,            6,13,     0xF1};
   649                                  
   650 000002A7 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   651                                  
   652                                  ;-90 char I_JGE[]={'J','G','E',0,            6,13,     0xF1};
   653                                  
   654 000002AE 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   655                                  
   656                                  ;-91 char I_JLE[]={'J','L','E',0,            6,14,     0xF1};
   657                                  
   658 000002B5 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   659                                  
   660                                  ;-92 char I_JNG[]={'J','N','G',0,            6,14,     0xF1};
   661                                  
   662 000002BC 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   663                                  
   664                                  ;-93 char I_JG []={'J','G',0,                6,15,     0xF1};
   665                                  
   666 000002C3 4A4700060FF1            I_JG db 74,71,0,6,15,241
   667                                  
   668                                  ;-94 //  8: ret
   669                                  
   670                                  
   671                                  ;-95 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   672                                  
   673 000002C9 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   674                                  
   675                                  ;-96 //  9: seg, r/m
   676                                  
   677                                  
   678                                  ;-97 char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16
   679                                  
   680 000002D1 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   681                                  
   682                                  ;-98 char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16
   683                                  
   684 000002D9 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   685                                  
   686                                  ;-99 //  100 directives
   687                                  
   688                                  
   689                                  ;-100 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   690                                  
   691 000002E0 4F52470065F1            I_ORG db 79,82,71,0,101,241
   692                                  
   693                                  ;-101 char I_DB[]=   {'D','B',0,            200,        0xF1};
   694                                  
   695 000002E6 444200C8F1              I_DB db 68,66,0,200,241
   696                                  
   697                                  ;-102 char I_DW[]=   {'D','W',0,            201,        0xF1};
   698                                  
   699 000002EB 445700C9F1              I_DW db 68,87,0,201,241
   700                                  
   701                                  ;-103 char I_DD[]=   {'D','D',0,            202,        0xF1};
   702                                  
   703 000002F0 444400CAF1              I_DD db 68,68,0,202,241
   704                                  
   705                                  ;-104 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   706                                  
   707 000002F5 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   708                                  
   709                                  ;-105 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   710                                  
   711 000002FC 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   712                                  
   713                                  ;-106 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   714                                  
   715 00000303 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   716                                  
   717                                  ;-107 char I_END=0;// end of table char
   718                                  
   719 0000030A 00                      I_END db 0
   720                                  ;Back to main program: AS.C
   721                                  
   722                                  ;-5 /*
   723                                  
   724                                  
   725                                  ;-6 process:
   726                                  
   727                                  
   728                                  ;-7   getOpcode1
   729                                  
   730                                  
   731                                  ;-8   if (,) getOpcode2
   732                                  
   733                                  
   734                                  ;-9   genInstruction
   735                                  
   736                                  
   737                                  ;-10 */
   738                                  
   739                                  
   740                                  ;-11 int process() { int i; char c;
   741                                  
   742                                  
   743                                  process:  ; *** PROC ***
   744                                  
   745                                  ;-12   getTokeType();
   746                                  
   747                                  ;Function : process, Number of local variables: 2
   748                                  ;   # type sign width line used address name   list of local variables
   749                                  ;  200 var sign word    11 NULL bp-2    i
   750                                  ;  201 var sign byte    11 NULL bp-4    c;
   751 0000030B C8040000                 ENTER  4,0
   752 0000030F E8EE07                   call getTokeType
   753                                  
   754                                  ;-13   OpSize=getCodeSize();
   755                                  
   756 00000312 E8E50A                   call getCodeSize
   757 00000315 A2[4000]                 mov byte [OpSize], al
   758                                  
   759                                  ;-14 
   760                                  
   761                                  
   762                                  ;-15   if (CodeType ==  1) {//1 byte opcode
   763                                  
   764 00000318 A0[3D00]                 mov al, [CodeType]
   765 0000031B 3C01                     cmp al, 1
   766 0000031D 0F850D00                 jne @@process1
   767                                  
   768                                  ;-16     genInstruction(0, 1); return;
   769                                  
   770 00000321 6A01                     push 1
   771 00000323 6A00                     push 0
   772 00000325 E8A805                   call genInstruction
   773 00000328 83C404                   add  sp, 4
   774 0000032B E9E000                   jmp @@retn
   775                                  
   776                                  ;-17   }
   777                                  
   778                                  
   779                                  ;-18   if (CodeType ==  2) {//inc, dec
   780                                  
   781                                  @@process1:
   782 0000032E A0[3D00]                 mov al, [CodeType]
   783 00000331 3C02                     cmp al, 2
   784 00000333 0F855400                 jne @@process2
   785                                  
   786                                  ;-19     LeftOpwCheck();
   787                                  
   788 00000337 E8FA00                   call LeftOpwCheck
   789                                  
   790                                  ;-20     	if (Op1 == REG) {
   791                                  
   792 0000033A A0[3C00]                 mov al, [Op1]
   793 0000033D 3C02                     cmp al, 2
   794 0000033F 0F853400                 jne @@process3
   795                                  
   796                                  ;-21         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form
   797                                  
   798 00000343 A0[3E00]                 mov al, [RegType]
   799 00000346 3C02                     cmp al, 2
   800 00000348 0F851100                 jne @@process4
   801 0000034C 6A03                     push 3
   802 0000034E A0[3F00]                 mov al, byte [RegNo]
   803 00000351 B400                     mov ah, 0
   804 00000353 50                       push ax
   805 00000354 E87905                   call genInstruction
   806 00000357 83C404                   add  sp, 4
   807 0000035A E9B100                   jmp @@retn
   808                                  
   809                                  ;-22         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }
   810                                  
   811                                  @@process4:
   812 0000035D A0[3E00]                 mov al, [RegType]
   813 00000360 3C03                     cmp al, 3
   814 00000362 0F851100                 jne @@process5
   815 00000366 6A03                     push 3
   816 00000368 A0[3F00]                 mov al, byte [RegNo]
   817 0000036B B400                     mov ah, 0
   818 0000036D 50                       push ax
   819 0000036E E85F05                   call genInstruction
   820 00000371 83C404                   add  sp, 4
   821 00000374 E99700                   jmp @@retn
   822                                  @@process5:
   823                                  
   824                                  ;-23       genInstruction(wflag, 1); genCodeInREG(); return;
   825                                  
   826                                  @@process3:
   827 00000377 6A01                     push 1
   828 00000379 A0[4200]                 mov al, byte [wflag]
   829 0000037C B400                     mov ah, 0
   830 0000037E 50                       push ax
   831 0000037F E84E05                   call genInstruction
   832 00000382 83C404                   add  sp, 4
   833 00000385 E87A05                   call genCodeInREG
   834 00000388 E98300                   jmp @@retn
   835                                  
   836                                  ;-24   }
   837                                  
   838                                  
   839                                  ;-25 
   840                                  
   841                                  
   842                                  ;-26   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
   843                                  
   844                                  @@process2:
   845 0000038B A0[3D00]                 mov al, [CodeType]
   846 0000038E 3C34                     cmp al, 52
   847 00000390 0F851700                 jne @@process6
   848                                  
   849                                  ;-27     LeftOpwCheck();
   850                                  
   851 00000394 E89D00                   call LeftOpwCheck
   852                                  
   853                                  ;-28     genInstruction(wflag, 1); genCodeInREG(); return;
   854                                  
   855 00000397 6A01                     push 1
   856 00000399 A0[4200]                 mov al, byte [wflag]
   857 0000039C B400                     mov ah, 0
   858 0000039E 50                       push ax
   859 0000039F E82E05                   call genInstruction
   860 000003A2 83C404                   add  sp, 4
   861 000003A5 E85A05                   call genCodeInREG
   862 000003A8 E96300                   jmp @@retn
   863                                  
   864                                  ;-29   }
   865                                  
   866                                  
   867                                  ;-30 
   868                                  
   869                                  
   870                                  ;-31   if (CodeType==  8) {// ret
   871                                  
   872                                  @@process6:
   873 000003AB A0[3D00]                 mov al, [CodeType]
   874 000003AE 3C08                     cmp al, 8
   875 000003B0 0F852D00                 jne @@process7
   876                                  
   877                                  ;-32     if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}
   878                                  
   879 000003B4 A0[3B00]                 mov al, [TokeType]
   880 000003B7 3C01                     cmp al, 1
   881 000003B9 0F851700                 jne @@process8
   882 000003BD 6A02                     push 2
   883 000003BF 6A00                     push 0
   884 000003C1 E80C05                   call genInstruction
   885 000003C4 83C404                   add  sp, 4
   886 000003C7 FF36[2500]               push word [SymbolInt]
   887 000003CB E8E104                   call genCode16
   888 000003CE 83C402                   add  sp, 2
   889 000003D1 E93A00                   jmp @@retn
   890                                  
   891                                  ;-33     genInstruction(0, 1); return;
   892                                  
   893                                  @@process8:
   894 000003D4 6A01                     push 1
   895 000003D6 6A00                     push 0
   896 000003D8 E8F504                   call genInstruction
   897 000003DB 83C404                   add  sp, 4
   898 000003DE E92D00                   jmp @@retn
   899                                  
   900                                  ;-34   }
   901                                  
   902                                  
   903                                  ;-35 
   904                                  
   905                                  
   906                                  ;-36   if (CodeType==101) {// ORG nn
   907                                  
   908                                  @@process7:
   909 000003E1 A0[3D00]                 mov al, [CodeType]
   910 000003E4 3C65                     cmp al, 101
   911 000003E6 0F851B00                 jne @@process9
   912                                  
   913                                  ;-37     if (TokeType != DIGIT) error1("only digit allowed");
   914                                  
   915 000003EA A0[3B00]                 mov al, [TokeType]
   916 000003ED 3C01                     cmp al, 1
   917 000003EF 0F840900                 je  @@process10
   918 000003F3 68[1004]                 push process_0
   919 000003F6 E84714                   call error1
   920 000003F9 83C402                   add  sp, 2
   921                                  
   922                                  ;-38     PC=SymbolInt;return;
   923                                  
   924                                  @@process10:
   925 000003FC A1[2500]                 mov ax, [SymbolInt]
   926 000003FF A3[3600]                 mov word [PC], ax
   927 00000402 E90900                   jmp @@retn
   928                                  
   929                                  ;-39   }
   930                                  
   931                                  
   932                                  ;-40   error1("unknown CodeType");
   933                                  
   934                                  @@process9:
   935 00000405 68[2304]                 push process_1
   936 00000408 E83514                   call error1
   937 0000040B 83C402                   add  sp, 2
   938                                  
   939                                  ;-41 }
   940                                  
   941                                  
   942                                  ;-42 /*
   943                                  
   944                                  
   945                                  ;-43 operand::=
   946                                  
   947                                  
   948                                  ;-44   none
   949                                  
   950                                  
   951                                  ;-45   ac  (al, ax, eax)
   952                                  
   953                                  
   954                                  ;-46   r   (b, w, s, d)
   955                                  
   956                                  
   957                                  ;-47   [m] (b, w, d)
   958                                  
   959                                  
   960                                  ;-48   i   (b, w)
   961                                  
   962                                  
   963                                  ;-49   disp(b, w)
   964                                  
   965                                  
   966                                  ;-50 
   967                                  
   968                                  
   969                                  ;-51 //O2=rr,rm,ri,mr,mi
   970                                  
   971                                  
   972                                  ;-52 //NumOprns==2, seg reg not allowed only mov and push
   973                                  
   974                                  
   975                                  ;-53 //size: 1.declaration CodeSize, 2.reg size, 3.error1
   976                                  
   977                                  
   978                                  ;-54 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
   979                                  
   980                                  
   981                                  ;-55 //2. rm , imm 80
   982                                  
   983                                  
   984                                  ;-56 //2a sign ext 83
   985                                  
   986                                  
   987                                  ;-57 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
   988                                  
   989                                  
   990                                  ;-58 //4. rm , reg 00
   991                                  
   992                                  
   993                                  ;-59 //5. error1(mem2mem)
   994                                  
   995                                  
   996                                  ;-60 */
   997                                  
   998                                  
   999                                  ;-61 int LeftOpwCheck() {
  1000                                  
  1001 0000040E C9                      @@retn: LEAVE
  1002 0000040F C3                       ret
  1003                                  ; ENDP
  1004 00000410 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1005 00000419 7420616C6C6F776564-
  1006 00000422 00                 
  1007 00000423 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1008 0000042C 6F64655479706500   
  1009                                  
  1010                                  LeftOpwCheck:  ; *** PROC ***
  1011                                  
  1012                                  ;-62   getLeftOp();
  1013                                  
  1014 00000434 E8A700                   call getLeftOp
  1015                                  
  1016                                  ;-63   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1017                                  
  1018 00000437 A0[3E00]                 mov al, [RegType]
  1019 0000043A 3C04                     cmp al, 4
  1020 0000043C 0F850600                 jne @@LeftOpwCheck11
  1021 00000440 E8F614                   call segregerror
  1022 00000443 E95300                   jmp @@retn
  1023                                  
  1024                                  ;-64   setwflag();
  1025                                  
  1026                                  @@LeftOpwCheck11:
  1027 00000446 E85B01                   call setwflag
  1028                                  
  1029                                  ;-65   if (OpSize == 0) error1("no op size declared");
  1030                                  
  1031 00000449 A0[4000]                 mov al, [OpSize]
  1032 0000044C 3C00                     cmp al, 0
  1033 0000044E 0F850900                 jne @@LeftOpwCheck12
  1034 00000452 68[9A04]                 push LeftOpwCheck_0
  1035 00000455 E8E813                   call error1
  1036 00000458 83C402                   add  sp, 2
  1037                                  
  1038                                  ;-66   if (OpSize == RegType) return;
  1039                                  
  1040                                  @@LeftOpwCheck12:
  1041 0000045B A0[4000]                 mov al, [OpSize]
  1042 0000045E 3A06[3E00]               cmp al, [RegType]
  1043 00000462 0F850300                 jne @@LeftOpwCheck13
  1044 00000466 E93000                   jmp @@retn
  1045                                  
  1046                                  ;-67   if (OpSize){if (Op1 == IND) return;
  1047                                  
  1048                                  @@LeftOpwCheck13:
  1049 00000469 A0[4000]                 mov al, [OpSize]
  1050 0000046C 08C0                     or  al, al
  1051 0000046E 0F841500                 je @@LeftOpwCheck14
  1052 00000472 A0[3C00]                 mov al, [Op1]
  1053 00000475 3C04                     cmp al, 4
  1054 00000477 0F850300                 jne @@LeftOpwCheck15
  1055 0000047B E91B00                   jmp @@retn
  1056                                  
  1057                                  ;-68     error1("Conflict OpSize and RegSize"); }
  1058                                  
  1059                                  @@LeftOpwCheck15:
  1060 0000047E 68[AE04]                 push LeftOpwCheck_1
  1061 00000481 E8BC13                   call error1
  1062 00000484 83C402                   add  sp, 2
  1063                                  
  1064                                  ;-69   if (RegType==0) error1("no register defined");
  1065                                  
  1066                                  @@LeftOpwCheck14:
  1067 00000487 A0[3E00]                 mov al, [RegType]
  1068 0000048A 3C00                     cmp al, 0
  1069 0000048C 0F850900                 jne @@LeftOpwCheck16
  1070 00000490 68[CA04]                 push LeftOpwCheck_2
  1071 00000493 E8AA13                   call error1
  1072 00000496 83C402                   add  sp, 2
  1073                                  
  1074                                  ;-70 }
  1075                                  
  1076                                  @@LeftOpwCheck16:
  1077                                  
  1078                                  ;-71 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
  1079                                  
  1080                                  @@retn:
  1081 00000499 C3                       ret
  1082                                  ; ENDP
  1083 0000049A 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
  1084 000004A3 65206465636C617265-
  1085 000004AC 6400               
  1086 000004AE 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
  1087 000004B7 4F7053697A6520616E-
  1088 000004C0 642052656753697A65-
  1089 000004C9 00                 
  1090 000004CA 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
  1091 000004D3 657220646566696E65-
  1092 000004DC 6400               
  1093                                  
  1094                                  getLeftOp:  ; *** PROC ***
  1095                                  
  1096                                  ;-72 //set: op1, disp->imm, reg, regt->size
  1097                                  
  1098                                  
  1099                                  ;-73   disp=0; imme=0; reg=0;
  1100                                  
  1101 000004DE 66B800000000             mov eax, 0
  1102 000004E4 A3[4500]                 mov word [disp], ax
  1103 000004E7 66B800000000             mov eax, 0
  1104 000004ED A3[4700]                 mov word [imme], ax
  1105 000004F0 66B800000000             mov eax, 0
  1106 000004F6 A2[4400]                 mov byte [reg], al
  1107                                  
  1108                                  ;-74 
  1109                                  
  1110                                  
  1111                                  ;-75   Op1=getOp1();
  1112                                  
  1113 000004F9 E80301                   call getOp1
  1114 000004FC A2[3C00]                 mov byte [Op1], al
  1115                                  
  1116                                  ;-76   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
  1117                                  
  1118 000004FF 6A5B                     push 91
  1119 00000501 E87909                   call isToken
  1120 00000504 83C402                   add  sp, 2
  1121 00000507 08C0                     or  al, al
  1122 00000509 0F840F00                 je @@getLeftOp17
  1123 0000050D 66B804000000             mov eax, 4
  1124 00000513 A2[3C00]                 mov byte [Op1], al
  1125 00000516 E86C01                   call getIND
  1126 00000519 E95200                   jmp @@retn
  1127                                  
  1128                                  ;-77   if (Op1 == 0) error1("Name of operand expected");
  1129                                  
  1130                                  @@getLeftOp17:
  1131 0000051C A0[3C00]                 mov al, [Op1]
  1132 0000051F 3C00                     cmp al, 0
  1133 00000521 0F850900                 jne @@getLeftOp18
  1134 00000525 68[6F05]                 push getLeftOp_0
  1135 00000528 E81513                   call error1
  1136 0000052B 83C402                   add  sp, 2
  1137                                  
  1138                                  ;-78   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
  1139                                  
  1140                                  @@getLeftOp18:
  1141 0000052E A0[3C00]                 mov al, [Op1]
  1142 00000531 3C01                     cmp al, 1
  1143 00000533 0F850900                 jne @@getLeftOp19
  1144 00000537 A1[2500]                 mov ax, [SymbolInt]
  1145 0000053A A3[4700]                 mov word [imme], ax
  1146 0000053D E92E00                   jmp @@retn
  1147                                  
  1148                                  ;-79   if (Op1 == REG) return;                                    //2
  1149                                  
  1150                                  @@getLeftOp19:
  1151 00000540 A0[3C00]                 mov al, [Op1]
  1152 00000543 3C02                     cmp al, 2
  1153 00000545 0F850300                 jne @@getLeftOp20
  1154 00000549 E92200                   jmp @@retn
  1155                                  
  1156                                  ;-80   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
  1157                                  
  1158                                  @@getLeftOp20:
  1159 0000054C A0[3C00]                 mov al, [Op1]
  1160 0000054F 3C03                     cmp al, 3
  1161 00000551 0F851000                 jne @@getLeftOp21
  1162 00000555 8B1E[5200]               mov bx, [LabelIx]
  1163 00000559 D1E3                     shl bx, 1
  1164 0000055B 8B87A47A                 mov ax, [LabelAddr + bx]
  1165 0000055F A3[4500]                 mov word [disp], ax
  1166 00000562 E90900                   jmp @@retn
  1167                                  
  1168                                  ;-81   error1("Name of operand expected #1");
  1169                                  
  1170                                  @@getLeftOp21:
  1171 00000565 68[8805]                 push getLeftOp_1
  1172 00000568 E8D512                   call error1
  1173 0000056B 83C402                   add  sp, 2
  1174                                  
  1175                                  ;-82 }
  1176                                  
  1177                                  
  1178                                  ;-83 int setwflag() {//only Op1 (first operand)
  1179                                  
  1180                                  @@retn:
  1181 0000056E C3                       ret
  1182                                  ; ENDP
  1183 0000056F 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
  1184 00000578 706572616E64206578-
  1185 00000581 70656374656400     
  1186 00000588 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
  1187 00000591 706572616E64206578-
  1188 0000059A 706563746564202331-
  1189 000005A3 00                 
  1190                                  
  1191                                  setwflag:  ; *** PROC ***
  1192                                  
  1193                                  ;-84   wflag=0;
  1194                                  
  1195 000005A4 66B800000000             mov eax, 0
  1196 000005AA A2[4200]                 mov byte [wflag], al
  1197                                  
  1198                                  ;-85   if (OpSize == 0) {//do not override OpSize
  1199                                  
  1200 000005AD A0[4000]                 mov al, [OpSize]
  1201 000005B0 3C00                     cmp al, 0
  1202 000005B2 0F852100                 jne @@setwflag22
  1203                                  
  1204                                  ;-86     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
  1205                                  
  1206 000005B6 A0[3C00]                 mov al, [Op1]
  1207 000005B9 3C02                     cmp al, 2
  1208 000005BB 0F851800                 jne @@setwflag23
  1209 000005BF A0[3E00]                 mov al, [RegType]
  1210 000005C2 A2[4000]                 mov byte [OpSize], al
  1211 000005C5 A0[3E00]                 mov al, [RegType]
  1212 000005C8 3C04                     cmp al, 4
  1213 000005CA 0F850900                 jne @@setwflag24
  1214 000005CE 66B802000000             mov eax, 2
  1215 000005D4 A2[4000]                 mov byte [OpSize], al
  1216                                  @@setwflag24:
  1217                                  
  1218                                  ;-87   }
  1219                                  
  1220                                  @@setwflag23:
  1221                                  
  1222                                  ;-88   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1223                                  
  1224                                  @@setwflag22:
  1225 000005D7 A0[4000]                 mov al, [OpSize]
  1226 000005DA 3C03                     cmp al, 3
  1227 000005DC 0F850C00                 jne @@setwflag25
  1228 000005E0 E89102                   call gen66h
  1229 000005E3 66B801000000             mov eax, 1
  1230 000005E9 A2[4200]                 mov byte [wflag], al
  1231                                  
  1232                                  ;-89   if (OpSize  ==  WORD) wflag=1;
  1233                                  
  1234                                  @@setwflag25:
  1235 000005EC A0[4000]                 mov al, [OpSize]
  1236 000005EF 3C02                     cmp al, 2
  1237 000005F1 0F850900                 jne @@setwflag26
  1238 000005F5 66B801000000             mov eax, 1
  1239 000005FB A2[4200]                 mov byte [wflag], al
  1240                                  
  1241                                  ;-90 }
  1242                                  
  1243                                  @@setwflag26:
  1244                                  
  1245                                  ;-91 int getOp1() {//scan for a single operand
  1246                                  
  1247 000005FE C3                       ret
  1248                                  ; ENDP
  1249                                  
  1250                                  getOp1:  ; *** PROC ***
  1251                                  
  1252                                  ;-92   //set:Op1, imme, disp, RegType, TegNo, reg
  1253                                  
  1254                                  
  1255                                  ;-93   if (TokeType == 0)      return 0;
  1256                                  
  1257 000005FF A0[3B00]                 mov al, [TokeType]
  1258 00000602 3C00                     cmp al, 0
  1259 00000604 0F850900                 jne @@getOp127
  1260 00000608 66B800000000             mov eax, 0
  1261 0000060E E96000                   jmp @@retn
  1262                                  
  1263                                  ;-94   if (TokeType == DIGIT)  return IMM;// 1
  1264                                  
  1265                                  @@getOp127:
  1266 00000611 A0[3B00]                 mov al, [TokeType]
  1267 00000614 3C01                     cmp al, 1
  1268 00000616 0F850900                 jne @@getOp128
  1269 0000061A 66B801000000             mov eax, 1
  1270 00000620 E94E00                   jmp @@retn
  1271                                  
  1272                                  ;-95   if (TokeType == ALNUME) {
  1273                                  
  1274                                  @@getOp128:
  1275 00000623 A0[3B00]                 mov al, [TokeType]
  1276 00000626 3C03                     cmp al, 3
  1277 00000628 0F853C00                 jne @@getOp129
  1278                                  
  1279                                  ;-96     RegNo=testReg();//set global RegType
  1280                                  
  1281 0000062C E86A0B                   call testReg
  1282 0000062F A2[3F00]                 mov byte [RegNo], al
  1283                                  
  1284                                  ;-97     if (RegType)          return REG;// 2
  1285                                  
  1286 00000632 A0[3E00]                 mov al, [RegType]
  1287 00000635 08C0                     or  al, al
  1288 00000637 0F840900                 je @@getOp130
  1289 0000063B 66B802000000             mov eax, 2
  1290 00000641 E92D00                   jmp @@retn
  1291                                  
  1292                                  ;-98     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];
  1293                                  
  1294                                  @@getOp130:
  1295 00000644 E8A105                   call searchLabel
  1296 00000647 A3[5200]                 mov word [LabelIx], ax
  1297                                  
  1298                                  ;-99     if (LabelIx)          return DIR;// 3
  1299                                  
  1300 0000064A A1[5200]                 mov ax, [LabelIx]
  1301 0000064D 08C0                     or  al, al
  1302 0000064F 0F840C00                 je @@getOp131
  1303 00000653 66B803000000             mov eax, 3
  1304 00000659 E91500                   jmp @@retn
  1305                                  
  1306                                  ;-100     else error1("variable not found"); }
  1307                                  
  1308 0000065C E90900                   jmp @@getOp132
  1309                                  @@getOp131:
  1310 0000065F 68[7206]                 push getOp1_0
  1311 00000662 E8DB11                   call error1
  1312 00000665 83C402                   add  sp, 2
  1313                                  @@getOp132:
  1314                                  
  1315                                  ;-101   return 0;
  1316                                  
  1317                                  @@getOp129:
  1318 00000668 66B800000000             mov eax, 0
  1319 0000066E E90000                   jmp @@retn
  1320                                  
  1321                                  ;-102 }
  1322                                  
  1323                                  
  1324                                  ;-103 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
  1325                                  
  1326                                  @@retn:
  1327 00000671 C3                       ret
  1328                                  ; ENDP
  1329 00000672 7661726961626C6520-     getOp1_0 db "variable not found",0
  1330 0000067B 6E6F7420666F756E64-
  1331 00000684 00                 
  1332                                  
  1333                                  getIND:  ; *** PROC ***
  1334                                  
  1335                                  ;-104   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
  1336                                  
  1337                                  ;Function : getIND, Number of local variables: 2
  1338                                  ;   # type sign width line used address name   list of local variables
  1339                                  ;  200 var sign byte   104 NULL bp-2    op2
  1340                                  ;  201 var sign byte   104 NULL bp-4    r1;
  1341 00000685 C8040000                 ENTER  4,0
  1342 00000689 66B800000000             mov eax, 0
  1343 0000068F A3[4500]                 mov word [disp], ax
  1344 00000692 66B800000000             mov eax, 0
  1345 00000698 8846FC                   mov byte [bp-4], al
  1346 0000069B 66B800000000             mov eax, 0
  1347 000006A1 A2[3E00]                 mov byte [RegType], al
  1348                                  
  1349                                  ;-105   do {
  1350                                  
  1351                                  @@getIND33:
  1352                                  
  1353                                  ;-106     getTokeType();
  1354                                  
  1355 000006A4 E85904                   call getTokeType
  1356                                  
  1357                                  ;-107     op2=getOp1();
  1358                                  
  1359 000006A7 E855FF                   call getOp1
  1360 000006AA 8846FE                   mov byte [bp-2], al
  1361                                  
  1362                                  ;-108     if (op2 ==   0) syntaxerror();
  1363                                  
  1364 000006AD 8A46FE                   mov al, [bp-2]
  1365 000006B0 3C00                     cmp al, 0
  1366 000006B2 0F850300                 jne @@getIND34
  1367 000006B6 E8A712                   call syntaxerror
  1368                                  
  1369                                  ;-109     if (op2 == IMM) disp=disp+SymbolInt;
  1370                                  
  1371                                  @@getIND34:
  1372 000006B9 8A46FE                   mov al, [bp-2]
  1373 000006BC 3C01                     cmp al, 1
  1374 000006BE 0F850A00                 jne @@getIND35
  1375 000006C2 A1[4500]                 mov ax, [disp]
  1376 000006C5 0306[2500]               add ax, [SymbolInt]
  1377 000006C9 A3[4500]                 mov word [disp], ax
  1378                                  
  1379                                  ;-110     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
  1380                                  
  1381                                  @@getIND35:
  1382 000006CC 8A46FE                   mov al, [bp-2]
  1383 000006CF 3C02                     cmp al, 2
  1384 000006D1 0F852100                 jne @@getIND36
  1385 000006D5 8A46FC                   mov al, [bp-4]
  1386 000006D8 08C0                     or  al, al
  1387 000006DA 0F841200                 je @@getIND37
  1388 000006DE 8A46FC                   mov al, byte [bp-4]
  1389 000006E1 B400                     mov ah, 0
  1390 000006E3 50                       push ax
  1391 000006E4 E80001                   call getIndReg2
  1392 000006E7 83C402                   add  sp, 2
  1393 000006EA 8846FC                   mov byte [bp-4], al
  1394 000006ED E90600                   jmp @@getIND38
  1395                                  @@getIND37:
  1396 000006F0 E87F00                   call getIndReg1
  1397 000006F3 8846FC                   mov byte [bp-4], al
  1398                                  
  1399                                  ;-111     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
  1400                                  
  1401                                  @@getIND38:
  1402                                  @@getIND36:
  1403 000006F6 8A46FE                   mov al, [bp-2]
  1404 000006F9 3C03                     cmp al, 3
  1405 000006FB 0F851000                 jne @@getIND39
  1406 000006FF A1[4500]                 mov ax, [disp]
  1407 00000702 8B1E[5200]               mov bx, [LabelIx]
  1408 00000706 D1E3                     shl bx, 1
  1409 00000708 0387A47A                 add ax, [LabelAddr + bx]
  1410 0000070C A3[4500]                 mov word [disp], ax
  1411                                  
  1412                                  ;-112     if (isToken('-')) {getTokeType();
  1413                                  
  1414                                  @@getIND39:
  1415 0000070F 6A2D                     push 45
  1416 00000711 E86907                   call isToken
  1417 00000714 83C402                   add  sp, 2
  1418 00000717 08C0                     or  al, al
  1419 00000719 0F841900                 je @@getIND40
  1420 0000071D E8E003                   call getTokeType
  1421                                  
  1422                                  ;-113       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  1423                                  
  1424 00000720 A0[3B00]                 mov al, [TokeType]
  1425 00000723 3C01                     cmp al, 1
  1426 00000725 0F840300                 je  @@getIND41
  1427 00000729 E8C911                   call numbererror
  1428                                  @@getIND41:
  1429 0000072C A1[4500]                 mov ax, [disp]
  1430 0000072F 2B06[2500]               sub ax, [SymbolInt]
  1431 00000733 A3[4500]                 mov word [disp], ax
  1432                                  
  1433                                  ;-114   } while (isToken('+'));
  1434                                  
  1435                                  @@getIND40:
  1436 00000736 6A2B                     push 43
  1437 00000738 E84207                   call isToken
  1438 0000073B 83C402                   add  sp, 2
  1439 0000073E 08C0                     or  al, al
  1440 00000740 0F840300                 je @@getIND42
  1441 00000744 E95DFF                   jmp @@getIND33
  1442                                  @@getIND42:
  1443                                  
  1444                                  ;-115   if (isToken(']') == 0) errorexit("] expected");
  1445                                  
  1446 00000747 6A5D                     push 93
  1447 00000749 E83107                   call isToken
  1448 0000074C 83C402                   add  sp, 2
  1449 0000074F 83F800                   cmp ax, 0
  1450 00000752 0F850900                 jne @@getIND43
  1451 00000756 68[6707]                 push getIND_0
  1452 00000759 E81512                   call errorexit
  1453 0000075C 83C402                   add  sp, 2
  1454                                  
  1455                                  ;-116   reg=r1;
  1456                                  
  1457                                  @@getIND43:
  1458 0000075F 8A46FC                   mov al, [bp-4]
  1459 00000762 A2[4400]                 mov byte [reg], al
  1460                                  
  1461                                  ;-117 }
  1462                                  
  1463                                  
  1464                                  ;-118 int getIndReg1() {char m; m=0;
  1465 00000765 C9                       LEAVE
  1466 00000766 C3                       ret
  1467                                  ; ENDP
  1468 00000767 5D2065787065637465-     getIND_0 db "] expected",0
  1469 00000770 6400               
  1470                                  
  1471                                  getIndReg1:  ; *** PROC ***
  1472                                  ;Function : getIndReg1, Number of local variables: 1
  1473                                  ;   # type sign width line used address name   list of local variables
  1474                                  ;  200 var sign byte   118 NULL bp-2    m;
  1475 00000772 C8020000                 ENTER  2,0
  1476 00000776 66B800000000             mov eax, 0
  1477 0000077C 8846FE                   mov byte [bp-2], al
  1478                                  
  1479                                  ;-119   if (RegType !=WORD) indexerror();
  1480                                  
  1481 0000077F A0[3E00]                 mov al, [RegType]
  1482 00000782 3C02                     cmp al, 2
  1483 00000784 0F840300                 je  @@getIndReg144
  1484 00000788 E84911                   call indexerror
  1485                                  
  1486                                  ;-120   if (RegNo==3) m=7;//BX
  1487                                  
  1488                                  @@getIndReg144:
  1489 0000078B A0[3F00]                 mov al, [RegNo]
  1490 0000078E 3C03                     cmp al, 3
  1491 00000790 0F850900                 jne @@getIndReg145
  1492 00000794 66B807000000             mov eax, 7
  1493 0000079A 8846FE                   mov byte [bp-2], al
  1494                                  
  1495                                  ;-121   if (RegNo==5) m=6;//BP change to BP+0
  1496                                  
  1497                                  @@getIndReg145:
  1498 0000079D A0[3F00]                 mov al, [RegNo]
  1499 000007A0 3C05                     cmp al, 5
  1500 000007A2 0F850900                 jne @@getIndReg146
  1501 000007A6 66B806000000             mov eax, 6
  1502 000007AC 8846FE                   mov byte [bp-2], al
  1503                                  
  1504                                  ;-122   if (RegNo==7) m=5;//DI
  1505                                  
  1506                                  @@getIndReg146:
  1507 000007AF A0[3F00]                 mov al, [RegNo]
  1508 000007B2 3C07                     cmp al, 7
  1509 000007B4 0F850900                 jne @@getIndReg147
  1510 000007B8 66B805000000             mov eax, 5
  1511 000007BE 8846FE                   mov byte [bp-2], al
  1512                                  
  1513                                  ;-123   if (RegNo==6) m=4;//SI
  1514                                  
  1515                                  @@getIndReg147:
  1516 000007C1 A0[3F00]                 mov al, [RegNo]
  1517 000007C4 3C06                     cmp al, 6
  1518 000007C6 0F850900                 jne @@getIndReg148
  1519 000007CA 66B804000000             mov eax, 4
  1520 000007D0 8846FE                   mov byte [bp-2], al
  1521                                  
  1522                                  ;-124   if (m    ==0) indexerror();
  1523                                  
  1524                                  @@getIndReg148:
  1525 000007D3 8A46FE                   mov al, [bp-2]
  1526 000007D6 3C00                     cmp al, 0
  1527 000007D8 0F850300                 jne @@getIndReg149
  1528 000007DC E8F510                   call indexerror
  1529                                  
  1530                                  ;-125   return m;
  1531                                  
  1532                                  @@getIndReg149:
  1533 000007DF 8A46FE                   mov al, [bp-2]
  1534 000007E2 E90000                   jmp @@retn
  1535                                  
  1536                                  ;-126 }
  1537                                  
  1538                                  
  1539                                  ;-127 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1540                                  
  1541 000007E5 C9                      @@retn: LEAVE
  1542 000007E6 C3                       ret
  1543                                  ; ENDP
  1544                                  
  1545                                  getIndReg2:  ; *** PROC ***
  1546                                  ;Function : getIndReg2, Number of local variables: 2
  1547                                  ;   # type sign width line used address name   list of local variables
  1548                                  ;  200 var sign byte   127 NULL bp+4    r1
  1549                                  ;  201 var sign byte   127 NULL bp-2    m;
  1550 000007E7 C8020000                 ENTER  2,0
  1551 000007EB 66B804000000             mov eax, 4
  1552 000007F1 8846FE                   mov byte [bp-2], al
  1553                                  
  1554                                  ;-128   if (RegType !=WORD) indexerror();
  1555                                  
  1556 000007F4 A0[3E00]                 mov al, [RegType]
  1557 000007F7 3C02                     cmp al, 2
  1558 000007F9 0F840300                 je  @@getIndReg250
  1559 000007FD E8D410                   call indexerror
  1560                                  
  1561                                  ;-129   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1562                                  
  1563                                  @@getIndReg250:
  1564 00000800 A0[3F00]                 mov al, [RegNo]
  1565 00000803 3C07                     cmp al, 7
  1566 00000805 0F852700                 jne @@getIndReg251
  1567 00000809 8A4604                   mov al, [bp+4]
  1568 0000080C 3C06                     cmp al, 6
  1569 0000080E 0F850C00                 jne @@getIndReg252
  1570 00000812 66B803000000             mov eax, 3
  1571 00000818 8846FE                   mov byte [bp-2], al
  1572                                  
  1573                                  ;-130            else if (r1==7) m=1;//BX+DI
  1574                                  
  1575 0000081B E91200                   jmp @@getIndReg253
  1576                                  @@getIndReg252:
  1577 0000081E 8A4604                   mov al, [bp+4]
  1578 00000821 3C07                     cmp al, 7
  1579 00000823 0F850900                 jne @@getIndReg254
  1580 00000827 66B801000000             mov eax, 1
  1581 0000082D 8846FE                   mov byte [bp-2], al
  1582                                  
  1583                                  ;-131   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1584                                  
  1585                                  @@getIndReg254:
  1586                                  @@getIndReg253:
  1587                                  @@getIndReg251:
  1588 00000830 A0[3F00]                 mov al, [RegNo]
  1589 00000833 3C06                     cmp al, 6
  1590 00000835 0F852700                 jne @@getIndReg255
  1591 00000839 8A4604                   mov al, [bp+4]
  1592 0000083C 3C06                     cmp al, 6
  1593 0000083E 0F850C00                 jne @@getIndReg256
  1594 00000842 66B802000000             mov eax, 2
  1595 00000848 8846FE                   mov byte [bp-2], al
  1596                                  
  1597                                  ;-132            else if (r1==7) m=0;//BX+DI
  1598                                  
  1599 0000084B E91200                   jmp @@getIndReg257
  1600                                  @@getIndReg256:
  1601 0000084E 8A4604                   mov al, [bp+4]
  1602 00000851 3C07                     cmp al, 7
  1603 00000853 0F850900                 jne @@getIndReg258
  1604 00000857 66B800000000             mov eax, 0
  1605 0000085D 8846FE                   mov byte [bp-2], al
  1606                                  
  1607                                  ;-133   if (m > 3) indexerror();
  1608                                  
  1609                                  @@getIndReg258:
  1610                                  @@getIndReg257:
  1611                                  @@getIndReg255:
  1612 00000860 8A46FE                   mov al, [bp-2]
  1613 00000863 3C03                     cmp al, 3
  1614 00000865 0F8E0300                 jle @@getIndReg259
  1615 00000869 E86810                   call indexerror
  1616                                  
  1617                                  ;-134   return m;
  1618                                  
  1619                                  @@getIndReg259:
  1620 0000086C 8A46FE                   mov al, [bp-2]
  1621 0000086F E90000                   jmp @@retn
  1622                                  
  1623                                  ;-135 }
  1624                                  
  1625                                  
  1626                                  ;-136 
  1627                                  
  1628                                  
  1629                                  ;-137 // generate code ...........................................................
  1630                                  
  1631                                  
  1632                                  ;-138 int gen66h() {genCode8(0x66);}
  1633                                  
  1634 00000872 C9                      @@retn: LEAVE
  1635 00000873 C3                       ret
  1636                                  ; ENDP
  1637                                  
  1638                                  gen66h:  ; *** PROC ***
  1639 00000874 6A66                     push 102
  1640 00000876 E80400                   call genCode8
  1641 00000879 83C402                   add  sp, 2
  1642                                  
  1643                                  ;-139 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  1644                                  
  1645 0000087C C3                       ret
  1646                                  ; ENDP
  1647                                  
  1648                                  genCode8:  ; *** PROC ***
  1649                                  
  1650                                  ;-140   FileBin[BinLen]=c; BinLen++; PC++;
  1651                                  
  1652                                  ;Function : genCode8, Number of local variables: 1
  1653                                  ;   # type sign width line used address name   list of local variables
  1654                                  ;  200 var sign byte   139 NULL bp+4    c;
  1655 0000087D C8000000                 ENTER  0,0
  1656 00000881 8A4604                   mov al, [bp+4]
  1657 00000884 8B1E[5400]               mov bx, [BinLen]
  1658 00000888 88876C7B                 mov [FileBin+bx], al
  1659 0000088C FF06[5400]               inc  word [BinLen]
  1660 00000890 FF06[3600]               inc  word [PC]
  1661                                  
  1662                                  ;-141   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
  1663                                  
  1664 00000894 A1[4900]                 mov ax, [OpPrintIndex]
  1665 00000897 83F805                   cmp ax, 5
  1666 0000089A 0F8D0F00                 jge @@genCode860
  1667 0000089E 8A4604                   mov al, [bp+4]
  1668 000008A1 8B1E[4900]               mov bx, [OpPrintIndex]
  1669 000008A5 8887B776                 mov [OpPos+bx], al
  1670 000008A9 FF06[4900]               inc  word [OpPrintIndex]
  1671                                  
  1672                                  ;-142 }
  1673                                  
  1674                                  @@genCode860:
  1675                                  
  1676                                  ;-143 int genCode16(int i) {
  1677 000008AD C9                       LEAVE
  1678 000008AE C3                       ret
  1679                                  ; ENDP
  1680                                  
  1681                                  genCode16:  ; *** PROC ***
  1682                                  
  1683                                  ;-144   genCode8(i); i=i >> 8; genCode8(i);
  1684                                  
  1685                                  ;Function : genCode16, Number of local variables: 1
  1686                                  ;   # type sign width line used address name   list of local variables
  1687                                  ;  200 var sign word   143 NULL bp+4    i;
  1688 000008AF C8000000                 ENTER  0,0
  1689 000008B3 FF7604                   push word [bp+4]
  1690 000008B6 E8C4FF                   call genCode8
  1691 000008B9 83C402                   add  sp, 2
  1692 000008BC 8B4604                   mov ax, [bp+4]
  1693 000008BF C1E808                   shr ax, 8
  1694 000008C2 894604                   mov word [bp+4], ax
  1695 000008C5 FF7604                   push word [bp+4]
  1696 000008C8 E8B2FF                   call genCode8
  1697 000008CB 83C402                   add  sp, 2
  1698                                  
  1699                                  ;-145 }
  1700                                  
  1701                                  
  1702                                  ;-146 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  1703 000008CE C9                       LEAVE
  1704 000008CF C3                       ret
  1705                                  ; ENDP
  1706                                  
  1707                                  genInstruction:  ; *** PROC ***
  1708                                  
  1709                                  ;-147   if(loc) OpCodePtr=OpCodePtr+loc;
  1710                                  
  1711                                  ;Function : genInstruction, Number of local variables: 3
  1712                                  ;   # type sign width line used address name   list of local variables
  1713                                  ;  200 var sign byte   146 NULL bp+4    No
  1714                                  ;  201 var sign word   146 NULL bp+6    loc
  1715                                  ;  202 var sign byte   146 NULL bp-2    c;
  1716 000008D0 C8020000                 ENTER  2,0
  1717 000008D4 8B4606                   mov ax, [bp+6]
  1718 000008D7 08C0                     or  al, al
  1719 000008D9 0F840900                 je @@genInstruction61
  1720 000008DD A1[4B00]                 mov ax, [OpCodePtr]
  1721 000008E0 034606                   add ax, [bp+6]
  1722 000008E3 A3[4B00]                 mov word [OpCodePtr], ax
  1723                                  
  1724                                  ;-148   c= *OpCodePtr + No; genCode8(c);
  1725                                  
  1726                                  @@genInstruction61:
  1727 000008E6 8B1E[4B00]               mov bx, [OpCodePtr]
  1728 000008EA 8A07                     mov al, [bx]
  1729 000008EC B400                     mov ah, 0
  1730 000008EE 024604                   add al, [bp+4]
  1731 000008F1 8846FE                   mov byte [bp-2], al
  1732 000008F4 8A46FE                   mov al, byte [bp-2]
  1733 000008F7 B400                     mov ah, 0
  1734 000008F9 50                       push ax
  1735 000008FA E880FF                   call genCode8
  1736 000008FD 83C402                   add  sp, 2
  1737                                  
  1738                                  ;-149 }
  1739                                  
  1740                                  
  1741                                  ;-150 int genCodeInREG() {char x; //get Code for second byte
  1742 00000900 C9                       LEAVE
  1743 00000901 C3                       ret
  1744                                  ; ENDP
  1745                                  
  1746                                  genCodeInREG:  ; *** PROC ***
  1747                                  
  1748                                  ;-151   OpCodePtr++; x= *OpCodePtr; writeEA(x);
  1749                                  
  1750                                  ;Function : genCodeInREG, Number of local variables: 1
  1751                                  ;   # type sign width line used address name   list of local variables
  1752                                  ;  200 var sign byte   150 NULL bp-2    x;
  1753 00000902 C8020000                 ENTER  2,0
  1754 00000906 FF06[4B00]               inc  word [OpCodePtr]
  1755 0000090A 8B1E[4B00]               mov bx, [OpCodePtr]
  1756 0000090E 8A07                     mov al, [bx]
  1757 00000910 B400                     mov ah, 0
  1758 00000912 8846FE                   mov byte [bp-2], al
  1759 00000915 8A46FE                   mov al, byte [bp-2]
  1760 00000918 B400                     mov ah, 0
  1761 0000091A 50                       push ax
  1762 0000091B E81200                   call writeEA
  1763 0000091E 83C402                   add  sp, 2
  1764                                  
  1765                                  ;-152 }
  1766                                  
  1767                                  
  1768                                  ;-153 int genModRegRM(){ writeEA(reg);//todo
  1769 00000921 C9                       LEAVE
  1770 00000922 C3                       ret
  1771                                  ; ENDP
  1772                                  
  1773                                  genModRegRM:  ; *** PROC ***
  1774 00000923 A0[4400]                 mov al, byte [reg]
  1775 00000926 B400                     mov ah, 0
  1776 00000928 50                       push ax
  1777 00000929 E80400                   call writeEA
  1778 0000092C 83C402                   add  sp, 2
  1779                                  
  1780                                  ;-154 }
  1781                                  
  1782                                  
  1783                                  ;-155 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  1784                                  
  1785 0000092F C3                       ret
  1786                                  ; ENDP
  1787                                  
  1788                                  writeEA:  ; *** PROC ***
  1789                                  
  1790                                  ;-156   len=0;
  1791                                  
  1792                                  ;Function : writeEA, Number of local variables: 2
  1793                                  ;   # type sign width line used address name   list of local variables
  1794                                  ;  200 var sign byte   155 NULL bp+4    xxx
  1795                                  ;  201 var sign byte   155 NULL bp-2    len;
  1796 00000930 C8020000                 ENTER  2,0
  1797 00000934 66B800000000             mov eax, 0
  1798 0000093A 8846FE                   mov byte [bp-2], al
  1799                                  
  1800                                  ;-157   xxx = xxx << 3;//in reg field of mod r/m
  1801                                  
  1802 0000093D 8A4604                   mov al, [bp+4]
  1803 00000940 C0E003                   shl al, 3
  1804 00000943 884604                   mov byte [bp+4], al
  1805                                  
  1806                                  ;-158   if (Op1 ==   0) addrexit();
  1807                                  
  1808 00000946 A0[3C00]                 mov al, [Op1]
  1809 00000949 3C00                     cmp al, 0
  1810 0000094B 0F850300                 jne @@writeEA62
  1811 0000094F E83610                   call addrexit
  1812                                  
  1813                                  ;-159   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  1814                                  
  1815                                  @@writeEA62:
  1816 00000952 A0[3C00]                 mov al, [Op1]
  1817 00000955 3C02                     cmp al, 2
  1818 00000957 0F850E00                 jne @@writeEA63
  1819 0000095B 804E04C0                 or  byte [bp+4], 192
  1820 0000095F 8A4604                   mov al, [bp+4]
  1821 00000962 0206[3F00]               add al, [RegNo]
  1822 00000966 884604                   mov byte [bp+4], al
  1823                                  
  1824                                  ;-160   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  1825                                  
  1826                                  @@writeEA63:
  1827 00000969 A0[3C00]                 mov al, [Op1]
  1828 0000096C 3C03                     cmp al, 3
  1829 0000096E 0F850D00                 jne @@writeEA64
  1830 00000972 804E0406                 or  byte [bp+4], 6
  1831 00000976 66B802000000             mov eax, 2
  1832 0000097C 8846FE                   mov byte [bp-2], al
  1833                                  
  1834                                  ;-161   if (Op1 == IND) { xxx = xxx + reg;                       //4
  1835                                  
  1836                                  @@writeEA64:
  1837 0000097F A0[3C00]                 mov al, [Op1]
  1838 00000982 3C04                     cmp al, 4
  1839 00000984 0F854600                 jne @@writeEA65
  1840 00000988 8A4604                   mov al, [bp+4]
  1841 0000098B 0206[4400]               add al, [reg]
  1842 0000098F 884604                   mov byte [bp+4], al
  1843                                  
  1844                                  ;-162     if (disp) {disp; if(ax > 127) len=2; else len=1;
  1845                                  
  1846 00000992 A1[4500]                 mov ax, [disp]
  1847 00000995 08C0                     or  al, al
  1848 00000997 0F843300                 je @@writeEA66
  1849 0000099B A1[4500]                 mov ax, [disp]
  1850 0000099E 83F87F                   cmp  ax, 127
  1851 000009A1 0F8E0C00                 jle @@writeEA67
  1852 000009A5 66B802000000             mov eax, 2
  1853 000009AB 8846FE                   mov byte [bp-2], al
  1854 000009AE E90900                   jmp @@writeEA68
  1855                                  @@writeEA67:
  1856 000009B1 66B801000000             mov eax, 1
  1857 000009B7 8846FE                   mov byte [bp-2], al
  1858                                  
  1859                                  ;-163       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
  1860                                  
  1861                                  @@writeEA68:
  1862 000009BA 8A46FE                   mov al, [bp-2]
  1863 000009BD 3C01                     cmp al, 1
  1864 000009BF 0F850700                 jne @@writeEA69
  1865 000009C3 804E0440                 or  byte [bp+4], 64
  1866 000009C7 E90400                   jmp @@writeEA70
  1867                                  @@writeEA69:
  1868 000009CA 804E0480                 or  byte [bp+4], 128
  1869                                  @@writeEA70:
  1870                                  
  1871                                  ;-164     }
  1872                                  
  1873                                  @@writeEA66:
  1874                                  
  1875                                  ;-165   genCode8(xxx);// gen second byte
  1876                                  
  1877                                  @@writeEA65:
  1878 000009CE 8A4604                   mov al, byte [bp+4]
  1879 000009D1 B400                     mov ah, 0
  1880 000009D3 50                       push ax
  1881 000009D4 E8A6FE                   call genCode8
  1882 000009D7 83C402                   add  sp, 2
  1883                                  
  1884                                  ;-166   if (len == 1) genCode8 (disp);
  1885                                  
  1886 000009DA 8A46FE                   mov al, [bp-2]
  1887 000009DD 3C01                     cmp al, 1
  1888 000009DF 0F850A00                 jne @@writeEA71
  1889 000009E3 FF36[4500]               push word [disp]
  1890 000009E7 E893FE                   call genCode8
  1891 000009EA 83C402                   add  sp, 2
  1892                                  
  1893                                  ;-167   if (len == 2) genCode16(disp);
  1894                                  
  1895                                  @@writeEA71:
  1896 000009ED 8A46FE                   mov al, [bp-2]
  1897 000009F0 3C02                     cmp al, 2
  1898 000009F2 0F850A00                 jne @@writeEA72
  1899 000009F6 FF36[4500]               push word [disp]
  1900 000009FA E8B2FE                   call genCode16
  1901 000009FD 83C402                   add  sp, 2
  1902                                  
  1903                                  ;-168 }
  1904                                  
  1905                                  @@writeEA72:
  1906                                  
  1907                                  ;-169 int test1() { __asm {
  1908 00000A00 C9                       LEAVE
  1909 00000A01 C3                       ret
  1910                                  ; ENDP
  1911                                  
  1912                                  test1:  ; *** PROC ***
  1913                                  
  1914                                  
  1915                                  ;-170 inc byte [Version1]   ;FE 06 [1000]
  1916                                  
  1917 00000A02 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  1918                                  
  1919                                  ;-171 add bx, ax    ;01 C3
  1920                                  
  1921 00000A06 01C3                    add bx, ax    ;01 C3
  1922                                  
  1923                                  ;-172 add ax, bx    ;01 D8
  1924                                  
  1925 00000A08 01D8                    add ax, bx    ;01 D8
  1926                                  
  1927                                  ;-173 add word ax, [bx] ;03 07
  1928                                  
  1929 00000A0A 0307                    add word ax, [bx] ;03 07
  1930                                  
  1931                                  ;-174 VA dw 8
  1932                                  
  1933 00000A0C 0800                    VA dw 8
  1934                                  
  1935                                  ;-175 mov byte [bp- 4], al ;88 46 FC
  1936                                  
  1937 00000A0E 8846FC                  mov byte [bp- 4], al ;88 46 FC
  1938                                  
  1939                                  ;-176 mov      [VA+bx], al ;88 87 [300F]
  1940                                  
  1941 00000A11 8887[0C0A]              mov      [VA+bx], al ;88 87 [300F]
  1942                                  
  1943                                  ;-177 }  }
  1944                                  
  1945                                  
  1946                                  
  1947                                  ;-178 //#include "AS1.C"
  1948                                  
  1949                                  
  1950                                  ;-179 #include "PARSE.C"
  1951                                  
  1952 00000A15 C3                       ret
  1953                                  ; ENDP
  1954                                  ;Use include file: PARSE.C
  1955                                  
  1956                                  ;-1 int parse() {
  1957                                  
  1958                                  
  1959                                  parse:  ; *** PROC ***
  1960                                  
  1961                                  ;-2   LabelNamePtr= &LabelNames;
  1962                                  
  1963 00000A16 B8BC76                   mov ax, LabelNames
  1964 00000A19 A3[4E00]                 mov word [LabelNamePtr], ax
  1965                                  
  1966                                  ;-3   do {
  1967                                  
  1968                                  @@parse73:
  1969                                  
  1970                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  1971                                  
  1972 00000A1C A1[3600]                 mov ax, [PC]
  1973 00000A1F A3[3800]                 mov word [PCStart], ax
  1974 00000A22 66B800000000             mov eax, 0
  1975 00000A28 A2[4000]                 mov byte [OpSize], al
  1976 00000A2B 66B800000000             mov eax, 0
  1977 00000A31 A3[4900]                 mov word [OpPrintIndex], ax
  1978 00000A34 66B820000000             mov eax, 32
  1979 00000A3A A2[4D00]                 mov byte [PrReloc], al
  1980                                  
  1981                                  ;-5     getLine();
  1982                                  
  1983 00000A3D E8A304                   call getLine
  1984                                  
  1985                                  ;-6     InputPtr = &InputBuf;
  1986                                  
  1987 00000A40 B86E75                   mov ax, InputBuf
  1988 00000A43 A3[2700]                 mov word [InputPtr], ax
  1989                                  
  1990                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1991                                  
  1992 00000A46 E8B700                   call getTokeType
  1993                                  
  1994                                  ;-8     if (TokeType == ALNUME) {
  1995                                  
  1996 00000A49 A0[3B00]                 mov al, [TokeType]
  1997 00000A4C 3C03                     cmp al, 3
  1998 00000A4E 0F851300                 jne @@parse74
  1999                                  
  2000                                  ;-9       if (isLabel) { //set in getName
  2001                                  
  2002 00000A52 A0[3A00]                 mov al, [isLabel]
  2003 00000A55 08C0                     or  al, al
  2004 00000A57 0F840A00                 je @@parse75
  2005                                  
  2006                                  ;-10         storeLabel();
  2007                                  
  2008 00000A5B E84001                   call storeLabel
  2009                                  
  2010                                  ;-11         InputPtr++;//remove :
  2011                                  
  2012 00000A5E FF06[2700]               inc  word [InputPtr]
  2013                                  
  2014                                  ;-12         getTokeType();
  2015                                  
  2016 00000A62 E89B00                   call getTokeType
  2017                                  
  2018                                  ;-13       }
  2019                                  
  2020                                  
  2021                                  ;-14     }
  2022                                  
  2023                                  @@parse75:
  2024                                  
  2025                                  ;-15     if (TokeType == ALNUME) {
  2026                                  
  2027                                  @@parse74:
  2028 00000A65 A0[3B00]                 mov al, [TokeType]
  2029 00000A68 3C03                     cmp al, 3
  2030 00000A6A 0F851B00                 jne @@parse76
  2031                                  
  2032                                  ;-16       lookCode();// and OpCodePtr
  2033                                  
  2034 00000A6E E80F03                   call lookCode
  2035                                  
  2036                                  ;-17       if(CodeType) process();
  2037                                  
  2038 00000A71 A0[3D00]                 mov al, [CodeType]
  2039 00000A74 08C0                     or  al, al
  2040 00000A76 0F840600                 je @@parse77
  2041 00000A7A E88EF8                   call process
  2042                                  
  2043                                  ;-18       else getVariable();
  2044                                  
  2045 00000A7D E90300                   jmp @@parse78
  2046                                  @@parse77:
  2047 00000A80 E8C501                   call getVariable
  2048                                  
  2049                                  ;-19       skipRest();
  2050                                  
  2051                                  @@parse78:
  2052 00000A83 E82504                   call skipRest
  2053                                  
  2054                                  ;-20     }
  2055                                  
  2056                                  
  2057                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2058                                  
  2059 00000A86 E92700                   jmp @@parse79
  2060                                  @@parse76:
  2061 00000A89 A0[3B00]                 mov al, [TokeType]
  2062 00000A8C 3C03                     cmp al, 3
  2063 00000A8E 0F8E0C00                 jle @@parse80
  2064 00000A92 68[C10A]                 push parse_0
  2065 00000A95 E8A80D                   call error1
  2066 00000A98 83C402                   add  sp, 2
  2067                                  
  2068                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2069                                  
  2070 00000A9B E91200                   jmp @@parse81
  2071                                  @@parse80:
  2072 00000A9E A0[3B00]                 mov al, [TokeType]
  2073 00000AA1 3C01                     cmp al, 1
  2074 00000AA3 0F850900                 jne @@parse82
  2075 00000AA7 68[DF0A]                 push parse_1
  2076 00000AAA E8930D                   call error1
  2077 00000AAD 83C402                   add  sp, 2
  2078                                  
  2079                                  ;-23     printLine();
  2080                                  
  2081                                  @@parse82:
  2082                                  @@parse81:
  2083                                  @@parse79:
  2084 00000AB0 E8220B                   call printLine
  2085                                  
  2086                                  ;-24   } while (DOS_NoBytes != 0 );
  2087                                  
  2088 00000AB3 A1[3300]                 mov ax, [DOS_NoBytes]
  2089 00000AB6 83F800                   cmp ax, 0
  2090 00000AB9 0F840300                 je  @@parse83
  2091 00000ABD E95CFF                   jmp @@parse73
  2092                                  @@parse83:
  2093                                  
  2094                                  ;-25 }
  2095                                  
  2096                                  
  2097                                  ;-26 // scan code .....................................
  2098                                  
  2099                                  
  2100                                  ;-27 int getTokeType() { char c;
  2101                                  
  2102 00000AC0 C3                       ret
  2103                                  ; ENDP
  2104 00000AC1 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2105 00000ACA 696E73747275637469-
  2106 00000AD3 6F6E20657870656374-
  2107 00000ADC 656400             
  2108 00000ADF 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2109 00000AE8 616C6C6F7765642040-
  2110 00000AF1 207374617274206F66-
  2111 00000AFA 206C696E6500       
  2112                                  
  2113                                  getTokeType:  ; *** PROC ***
  2114                                  
  2115                                  ;-28   skipBlank();
  2116                                  
  2117                                  ;Function : getTokeType, Number of local variables: 1
  2118                                  ;   # type sign width line used address name   list of local variables
  2119                                  ;  200 var sign byte    27 NULL bp-2    c;
  2120 00000B00 C8020000                 ENTER  2,0
  2121 00000B04 E8A904                   call skipBlank
  2122                                  
  2123                                  ;-29   c = *InputPtr;
  2124                                  
  2125 00000B07 8B1E[2700]               mov bx, [InputPtr]
  2126 00000B0B 8A07                     mov al, [bx]
  2127 00000B0D B400                     mov ah, 0
  2128 00000B0F 8846FE                   mov byte [bp-2], al
  2129                                  
  2130                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2131                                  
  2132 00000B12 8A46FE                   mov al, [bp-2]
  2133 00000B15 3C00                     cmp al, 0
  2134 00000B17 0F850C00                 jne @@getTokeType84
  2135 00000B1B 66B800000000             mov eax, 0
  2136 00000B21 A2[3B00]                 mov byte [TokeType], al
  2137 00000B24 E97500                   jmp @@retn
  2138                                  
  2139                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2140                                  
  2141                                  @@getTokeType84:
  2142 00000B27 8A46FE                   mov al, [bp-2]
  2143 00000B2A 3C3B                     cmp al, 59
  2144 00000B2C 0F850C00                 jne @@getTokeType85
  2145 00000B30 66B800000000             mov eax, 0
  2146 00000B36 A2[3B00]                 mov byte [TokeType], al
  2147 00000B39 E96000                   jmp @@retn
  2148                                  
  2149                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2150                                  
  2151                                  @@getTokeType85:
  2152 00000B3C 8A46FE                   mov al, byte [bp-2]
  2153 00000B3F B400                     mov ah, 0
  2154 00000B41 50                       push ax
  2155 00000B42 E84F13                   call digit
  2156 00000B45 83C402                   add  sp, 2
  2157 00000B48 08C0                     or  al, al
  2158 00000B4A 0F841800                 je @@getTokeType86
  2159 00000B4E 8A46FE                   mov al, byte [bp-2]
  2160 00000B51 B400                     mov ah, 0
  2161 00000B53 50                       push ax
  2162 00000B54 E85F05                   call getDigit
  2163 00000B57 83C402                   add  sp, 2
  2164 00000B5A 66B801000000             mov eax, 1
  2165 00000B60 A2[3B00]                 mov byte [TokeType], al
  2166 00000B63 E93600                   jmp @@retn
  2167                                  
  2168                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2169                                  
  2170                                  @@getTokeType86:
  2171 00000B66 8A46FE                   mov al, byte [bp-2]
  2172 00000B69 B400                     mov ah, 0
  2173 00000B6B 50                       push ax
  2174 00000B6C E86C04                   call letterE
  2175 00000B6F 83C402                   add  sp, 2
  2176 00000B72 08C0                     or  al, al
  2177 00000B74 0F841800                 je @@getTokeType87
  2178 00000B78 8A46FE                   mov al, byte [bp-2]
  2179 00000B7B B400                     mov ah, 0
  2180 00000B7D 50                       push ax
  2181 00000B7E E88C05                   call getName
  2182 00000B81 83C402                   add  sp, 2
  2183 00000B84 66B803000000             mov eax, 3
  2184 00000B8A A2[3B00]                 mov byte [TokeType], al
  2185 00000B8D E90C00                   jmp @@retn
  2186                                  
  2187                                  ;-34   TokeType=NOALNUME; return;
  2188                                  
  2189                                  @@getTokeType87:
  2190 00000B90 66B804000000             mov eax, 4
  2191 00000B96 A2[3B00]                 mov byte [TokeType], al
  2192 00000B99 E90000                   jmp @@retn
  2193                                  
  2194                                  ;-35 }
  2195                                  
  2196                                  
  2197                                  ;-36 int storeLabel() {
  2198                                  
  2199 00000B9C C9                      @@retn: LEAVE
  2200 00000B9D C3                       ret
  2201                                  ; ENDP
  2202                                  
  2203                                  storeLabel:  ; *** PROC ***
  2204                                  
  2205                                  ;-37   if(searchLabel()) error1("duplicate label");
  2206                                  
  2207 00000B9E E84700                   call searchLabel
  2208 00000BA1 08C0                     or  al, al
  2209 00000BA3 0F840900                 je @@storeLabel88
  2210 00000BA7 68[D80B]                 push storeLabel_0
  2211 00000BAA E8930C                   call error1
  2212 00000BAD 83C402                   add  sp, 2
  2213                                  
  2214                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2215                                  
  2216                                  @@storeLabel88:
  2217 00000BB0 8D063075                 lea  ax, [Symbol]
  2218 00000BB4 50                       push ax
  2219 00000BB5 FF36[4E00]               push word [LabelNamePtr]
  2220 00000BB9 E89F12                   call strcpy
  2221 00000BBC 83C404                   add  sp, 4
  2222 00000BBF A3[4E00]                 mov word [LabelNamePtr], ax
  2223                                  
  2224                                  ;-39   LabelNamePtr++;
  2225                                  
  2226 00000BC2 FF06[4E00]               inc  word [LabelNamePtr]
  2227                                  
  2228                                  ;-40   LabelMaxIx++;
  2229                                  
  2230 00000BC6 FF06[5000]               inc  word [LabelMaxIx]
  2231                                  
  2232                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2233                                  
  2234 00000BCA A1[3600]                 mov ax, [PC]
  2235 00000BCD 8B1E[5000]               mov bx, [LabelMaxIx]
  2236 00000BD1 D1E3                     shl bx, 1
  2237 00000BD3 8987A47A                 mov [LabelAddr+bx], ax
  2238                                  
  2239                                  ;-42 }
  2240                                  
  2241                                  
  2242                                  ;-43 int searchLabel() {
  2243                                  
  2244 00000BD7 C3                       ret
  2245                                  ; ENDP
  2246 00000BD8 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2247 00000BE1 206C6162656C00     
  2248                                  
  2249                                  searchLabel:  ; *** PROC ***
  2250                                  
  2251                                  ;-44   int LIx; char *p; int j;
  2252                                  
  2253                                  
  2254                                  ;-45   p = &LabelNames;
  2255                                  
  2256                                  ;Function : searchLabel, Number of local variables: 3
  2257                                  ;   # type sign width line used address name   list of local variables
  2258                                  ;  200 var sign word    44 NULL bp-2    LIx
  2259                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2260                                  ;  202 var sign word    44 NULL bp-6    j;
  2261 00000BE8 C8060000                 ENTER  6,0
  2262 00000BEC B8BC76                   mov ax, LabelNames
  2263 00000BEF 8946FC                   mov word [bp-4], ax
  2264                                  
  2265                                  ;-46   LIx=1;
  2266                                  
  2267 00000BF2 66B801000000             mov eax, 1
  2268 00000BF8 8946FE                   mov word [bp-2], ax
  2269                                  
  2270                                  ;-47   while (LIx <= LabelMaxIx) {
  2271                                  
  2272                                  @@searchLabel89:
  2273 00000BFB 8B46FE                   mov ax, [bp-2]
  2274 00000BFE 3B06[5000]               cmp ax, [LabelMaxIx]
  2275 00000C02 0F8F3700                 jg  @@searchLabel90
  2276                                  
  2277                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2278                                  
  2279 00000C06 8D063075                 lea  ax, [Symbol]
  2280 00000C0A 50                       push ax
  2281 00000C0B FF76FC                   push word [bp-4]
  2282 00000C0E E8B612                   call eqstr
  2283 00000C11 83C404                   add  sp, 4
  2284 00000C14 08C0                     or  al, al
  2285 00000C16 0F840600                 je @@searchLabel91
  2286 00000C1A 8B46FE                   mov ax, [bp-2]
  2287 00000C1D E92600                   jmp @@retn
  2288                                  
  2289                                  ;-49     j=strlen(p);
  2290                                  
  2291                                  @@searchLabel91:
  2292 00000C20 FF76FC                   push word [bp-4]
  2293 00000C23 E80A12                   call strlen
  2294 00000C26 83C402                   add  sp, 2
  2295 00000C29 8946FA                   mov word [bp-6], ax
  2296                                  
  2297                                  ;-50     p=p+j; p++; LIx++;
  2298                                  
  2299 00000C2C 8B46FC                   mov ax, [bp-4]
  2300 00000C2F 0346FA                   add ax, [bp-6]
  2301 00000C32 8946FC                   mov word [bp-4], ax
  2302 00000C35 FF46FC                   inc  word [bp-4]
  2303 00000C38 FF46FE                   inc  word [bp-2]
  2304                                  
  2305                                  ;-51   }
  2306                                  
  2307                                  
  2308                                  ;-52   return 0;
  2309                                  
  2310 00000C3B EBBE                     jmp @@searchLabel89
  2311                                  @@searchLabel90:
  2312 00000C3D 66B800000000             mov eax, 0
  2313 00000C43 E90000                   jmp @@retn
  2314                                  
  2315                                  ;-53 }
  2316                                  
  2317                                  
  2318                                  ;-54 int getVariable() { char c;
  2319                                  
  2320 00000C46 C9                      @@retn: LEAVE
  2321 00000C47 C3                       ret
  2322                                  ; ENDP
  2323                                  
  2324                                  getVariable:  ; *** PROC ***
  2325                                  
  2326                                  ;-55   storeLabel();
  2327                                  
  2328                                  ;Function : getVariable, Number of local variables: 1
  2329                                  ;   # type sign width line used address name   list of local variables
  2330                                  ;  200 var sign byte    54 NULL bp-2    c;
  2331 00000C48 C8020000                 ENTER  2,0
  2332 00000C4C E84FFF                   call storeLabel
  2333                                  
  2334                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2335                                  
  2336 00000C4F E8AEFE                   call getTokeType
  2337 00000C52 A0[3B00]                 mov al, [TokeType]
  2338 00000C55 3C03                     cmp al, 3
  2339 00000C57 0F85CC00                 jne @@getVariable92
  2340                                  
  2341                                  ;-57     lookCode();
  2342                                  
  2343 00000C5B E82201                   call lookCode
  2344                                  
  2345                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2346                                  
  2347 00000C5E A0[3D00]                 mov al, [CodeType]
  2348 00000C61 3CC8                     cmp al, 200
  2349 00000C63 0F8D0900                 jge @@getVariable93
  2350 00000C67 68[320D]                 push getVariable_0
  2351 00000C6A E8040D                   call errorexit
  2352 00000C6D 83C402                   add  sp, 2
  2353                                  
  2354                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2355                                  
  2356                                  @@getVariable93:
  2357 00000C70 A0[3D00]                 mov al, [CodeType]
  2358 00000C73 3CCF                     cmp al, 207
  2359 00000C75 0F8E0900                 jle @@getVariable94
  2360 00000C79 68[4A0D]                 push getVariable_1
  2361 00000C7C E8F20C                   call errorexit
  2362 00000C7F 83C402                   add  sp, 2
  2363                                  
  2364                                  ;-60     if (CodeType== 200) {// DB
  2365                                  
  2366                                  @@getVariable94:
  2367 00000C82 A0[3D00]                 mov al, [CodeType]
  2368 00000C85 3CC8                     cmp al, 200
  2369 00000C87 0F856A00                 jne @@getVariable95
  2370                                  
  2371                                  ;-61       do { getTokeType();
  2372                                  
  2373                                  @@getVariable96:
  2374 00000C8B E872FE                   call getTokeType
  2375                                  
  2376                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2377                                  
  2378 00000C8E A0[3B00]                 mov al, [TokeType]
  2379 00000C91 3C01                     cmp al, 1
  2380 00000C93 0F850D00                 jne @@getVariable97
  2381 00000C97 FF36[2500]               push word [SymbolInt]
  2382 00000C9B E8DFFB                   call genCode8
  2383 00000C9E 83C402                   add  sp, 2
  2384                                  
  2385                                  ;-63         else {
  2386                                  
  2387 00000CA1 E94100                   jmp @@getVariable98
  2388                                  @@getVariable97:
  2389                                  
  2390                                  ;-64           skipBlank();
  2391                                  
  2392 00000CA4 E80903                   call skipBlank
  2393                                  
  2394                                  ;-65           if (isToken('"')) {
  2395                                  
  2396 00000CA7 6A22                     push 34
  2397 00000CA9 E8D101                   call isToken
  2398 00000CAC 83C402                   add  sp, 2
  2399 00000CAF 08C0                     or  al, al
  2400 00000CB1 0F843000                 je @@getVariable99
  2401                                  
  2402                                  ;-66             do { c= *InputPtr;
  2403                                  
  2404                                  @@getVariable100:
  2405 00000CB5 8B1E[2700]               mov bx, [InputPtr]
  2406 00000CB9 8A07                     mov al, [bx]
  2407 00000CBB B400                     mov ah, 0
  2408 00000CBD 8846FE                   mov byte [bp-2], al
  2409                                  
  2410                                  ;-67               genCode8(c);
  2411                                  
  2412 00000CC0 8A46FE                   mov al, byte [bp-2]
  2413 00000CC3 B400                     mov ah, 0
  2414 00000CC5 50                       push ax
  2415 00000CC6 E8B4FB                   call genCode8
  2416 00000CC9 83C402                   add  sp, 2
  2417                                  
  2418                                  ;-68               InputPtr++;
  2419                                  
  2420 00000CCC FF06[2700]               inc  word [InputPtr]
  2421                                  
  2422                                  ;-69             } while (*InputPtr != '"' );
  2423                                  
  2424 00000CD0 8B1E[2700]               mov bx, [InputPtr]
  2425 00000CD4 8A07                     mov al, [bx]
  2426 00000CD6 B400                     mov ah, 0
  2427 00000CD8 83F822                   cmp ax, 34
  2428 00000CDB 0F840200                 je  @@getVariable101
  2429 00000CDF EBD4                     jmp @@getVariable100
  2430                                  @@getVariable101:
  2431                                  
  2432                                  ;-70             InputPtr++;
  2433                                  
  2434 00000CE1 FF06[2700]               inc  word [InputPtr]
  2435                                  
  2436                                  ;-71           }
  2437                                  
  2438                                  
  2439                                  ;-72         }
  2440                                  
  2441                                  @@getVariable99:
  2442                                  
  2443                                  ;-73       } while (isToken(','));
  2444                                  
  2445                                  @@getVariable98:
  2446 00000CE5 6A2C                     push 44
  2447 00000CE7 E89301                   call isToken
  2448 00000CEA 83C402                   add  sp, 2
  2449 00000CED 08C0                     or  al, al
  2450 00000CEF 0F840200                 je @@getVariable102
  2451 00000CF3 EB96                     jmp @@getVariable96
  2452                                  @@getVariable102:
  2453                                  
  2454                                  ;-74     }
  2455                                  
  2456                                  
  2457                                  ;-75     if (CodeType== 201) {// DW
  2458                                  
  2459                                  @@getVariable95:
  2460 00000CF5 A0[3D00]                 mov al, [CodeType]
  2461 00000CF8 3CC9                     cmp al, 201
  2462 00000CFA 0F852600                 jne @@getVariable103
  2463                                  
  2464                                  ;-76       do { getTokeType();
  2465                                  
  2466                                  @@getVariable104:
  2467 00000CFE E8FFFD                   call getTokeType
  2468                                  
  2469                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2470                                  
  2471 00000D01 A0[3B00]                 mov al, [TokeType]
  2472 00000D04 3C01                     cmp al, 1
  2473 00000D06 0F850A00                 jne @@getVariable105
  2474 00000D0A FF36[2500]               push word [SymbolInt]
  2475 00000D0E E89EFB                   call genCode16
  2476 00000D11 83C402                   add  sp, 2
  2477                                  
  2478                                  ;-78       } while (isToken(','));
  2479                                  
  2480                                  @@getVariable105:
  2481 00000D14 6A2C                     push 44
  2482 00000D16 E86401                   call isToken
  2483 00000D19 83C402                   add  sp, 2
  2484 00000D1C 08C0                     or  al, al
  2485 00000D1E 0F840200                 je @@getVariable106
  2486 00000D22 EBDA                     jmp @@getVariable104
  2487                                  @@getVariable106:
  2488                                  
  2489                                  ;-79     }
  2490                                  
  2491                                  
  2492                                  ;-80   }
  2493                                  
  2494                                  @@getVariable103:
  2495                                  
  2496                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2497                                  
  2498 00000D24 E90900                   jmp @@getVariable107
  2499                                  @@getVariable92:
  2500 00000D27 68[620D]                 push getVariable_2
  2501 00000D2A E8440C                   call errorexit
  2502 00000D2D 83C402                   add  sp, 2
  2503                                  
  2504                                  ;-82 }
  2505                                  
  2506                                  @@getVariable107:
  2507                                  
  2508                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2509 00000D30 C9                       LEAVE
  2510 00000D31 C3                       ret
  2511                                  ; ENDP
  2512 00000D32 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2513 00000D3B 422C572C4420657870-
  2514 00000D44 656374656400       
  2515 00000D4A 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2516 00000D53 422C572C4420657870-
  2517 00000D5C 656374656400       
  2518 00000D62 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2519 00000D6B 6F7220524553422C57-
  2520 00000D74 2C4420657870656374-
  2521 00000D7D 656400             
  2522                                  
  2523                                  lookCode:  ; *** PROC ***
  2524                                  
  2525                                  ;-84   CodeType=0;
  2526                                  
  2527 00000D80 66B800000000             mov eax, 0
  2528 00000D86 A2[3D00]                 mov byte [CodeType], al
  2529                                  
  2530                                  ;-85   OpCodePtr= &I_START;
  2531                                  
  2532 00000D89 B8[5A00]                 mov ax, I_START
  2533 00000D8C A3[4B00]                 mov word [OpCodePtr], ax
  2534                                  
  2535                                  ;-86   OpCodePtr++;
  2536                                  
  2537 00000D8F FF06[4B00]               inc  word [OpCodePtr]
  2538                                  
  2539                                  ;-87   do  {
  2540                                  
  2541                                  @@lookCode108:
  2542                                  
  2543                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2544                                  
  2545 00000D93 FF36[4B00]               push word [OpCodePtr]
  2546 00000D97 8D064F75                 lea  ax, [SymbolUpper]
  2547 00000D9B 50                       push ax
  2548 00000D9C E82811                   call eqstr
  2549 00000D9F 83C404                   add  sp, 4
  2550 00000DA2 08C0                     or  al, al
  2551 00000DA4 0F842700                 je @@lookCode109
  2552                                  
  2553                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2554                                  
  2555                                  @@lookCode110:
  2556 00000DA8 8B1E[4B00]               mov bx, [OpCodePtr]
  2557 00000DAC 8A07                     mov al, [bx]
  2558 00000DAE B400                     mov ah, 0
  2559 00000DB0 83F800                   cmp ax, 0
  2560 00000DB3 0F840600                 je  @@lookCode111
  2561 00000DB7 FF06[4B00]               inc  word [OpCodePtr]
  2562                                  
  2563                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2564                                  
  2565 00000DBB EBEB                     jmp @@lookCode110
  2566                                  @@lookCode111:
  2567 00000DBD FF06[4B00]               inc  word [OpCodePtr]
  2568 00000DC1 8B1E[4B00]               mov bx, [OpCodePtr]
  2569 00000DC5 8A07                     mov al, [bx]
  2570 00000DC7 B400                     mov ah, 0
  2571 00000DC9 A2[3D00]                 mov byte [CodeType], al
  2572                                  
  2573                                  ;-91       return;
  2574                                  
  2575 00000DCC E92A00                   jmp @@retn
  2576                                  
  2577                                  ;-92     }
  2578                                  
  2579                                  
  2580                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2581                                  
  2582                                  @@lookCode109:
  2583                                  @@lookCode112:
  2584 00000DCF 8B1E[4B00]               mov bx, [OpCodePtr]
  2585 00000DD3 8A07                     mov al, [bx]
  2586 00000DD5 B400                     mov ah, 0
  2587 00000DD7 3DF100                   cmp ax, 241
  2588 00000DDA 0F840600                 je  @@lookCode113
  2589 00000DDE FF06[4B00]               inc  word [OpCodePtr]
  2590                                  
  2591                                  ;-94   OpCodePtr++;
  2592                                  
  2593 00000DE2 EBEB                     jmp @@lookCode112
  2594                                  @@lookCode113:
  2595 00000DE4 FF06[4B00]               inc  word [OpCodePtr]
  2596                                  
  2597                                  ;-95   } while(*OpCodePtr!=0);
  2598                                  
  2599 00000DE8 8B1E[4B00]               mov bx, [OpCodePtr]
  2600 00000DEC 8A07                     mov al, [bx]
  2601 00000DEE B400                     mov ah, 0
  2602 00000DF0 83F800                   cmp ax, 0
  2603 00000DF3 0F840200                 je  @@lookCode114
  2604 00000DF7 EB9A                     jmp @@lookCode108
  2605                                  @@lookCode114:
  2606                                  
  2607                                  ;-96 }
  2608                                  
  2609                                  
  2610                                  ;-97 int getCodeSize() {
  2611                                  
  2612                                  @@retn:
  2613 00000DF9 C3                       ret
  2614                                  ; ENDP
  2615                                  
  2616                                  getCodeSize:  ; *** PROC ***
  2617                                  
  2618                                  ;-98   if (TokeType ==ALNUME) {
  2619                                  
  2620 00000DFA A0[3B00]                 mov al, [TokeType]
  2621 00000DFD 3C03                     cmp al, 3
  2622 00000DFF 0F856000                 jne @@getCodeSize115
  2623                                  
  2624                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2625                                  
  2626 00000E03 68[6D0E]                 push getCodeSize_0
  2627 00000E06 8D064F75                 lea  ax, [SymbolUpper]
  2628 00000E0A 50                       push ax
  2629 00000E0B E8B910                   call eqstr
  2630 00000E0E 83C404                   add  sp, 4
  2631 00000E11 08C0                     or  al, al
  2632 00000E13 0F840C00                 je @@getCodeSize116
  2633 00000E17 E8E6FC                   call getTokeType
  2634 00000E1A 66B801000000             mov eax, 1
  2635 00000E20 E94900                   jmp @@retn
  2636                                  
  2637                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2638                                  
  2639                                  @@getCodeSize116:
  2640 00000E23 68[720E]                 push getCodeSize_1
  2641 00000E26 8D064F75                 lea  ax, [SymbolUpper]
  2642 00000E2A 50                       push ax
  2643 00000E2B E89910                   call eqstr
  2644 00000E2E 83C404                   add  sp, 4
  2645 00000E31 08C0                     or  al, al
  2646 00000E33 0F840C00                 je @@getCodeSize117
  2647 00000E37 E8C6FC                   call getTokeType
  2648 00000E3A 66B802000000             mov eax, 2
  2649 00000E40 E92900                   jmp @@retn
  2650                                  
  2651                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2652                                  
  2653                                  @@getCodeSize117:
  2654 00000E43 68[770E]                 push getCodeSize_2
  2655 00000E46 8D064F75                 lea  ax, [SymbolUpper]
  2656 00000E4A 50                       push ax
  2657 00000E4B E87910                   call eqstr
  2658 00000E4E 83C404                   add  sp, 4
  2659 00000E51 08C0                     or  al, al
  2660 00000E53 0F840C00                 je @@getCodeSize118
  2661 00000E57 E8A6FC                   call getTokeType
  2662 00000E5A 66B803000000             mov eax, 3
  2663 00000E60 E90900                   jmp @@retn
  2664                                  
  2665                                  ;-102   } return 0;
  2666                                  
  2667                                  @@getCodeSize118:
  2668                                  @@getCodeSize115:
  2669 00000E63 66B800000000             mov eax, 0
  2670 00000E69 E90000                   jmp @@retn
  2671                                  
  2672                                  ;-103 }
  2673                                  
  2674                                  
  2675                                  ;-104 int isToken(char c) {
  2676                                  
  2677                                  @@retn:
  2678 00000E6C C3                       ret
  2679                                  ; ENDP
  2680 00000E6D 4259544500              getCodeSize_0 db "BYTE",0
  2681 00000E72 574F524400              getCodeSize_1 db "WORD",0
  2682 00000E77 44574F524400            getCodeSize_2 db "DWORD",0
  2683                                  
  2684                                  isToken:  ; *** PROC ***
  2685                                  
  2686                                  ;-105   skipBlank();
  2687                                  
  2688                                  ;Function : isToken, Number of local variables: 1
  2689                                  ;   # type sign width line used address name   list of local variables
  2690                                  ;  200 var sign byte   104 NULL bp+4    c;
  2691 00000E7D C8000000                 ENTER  0,0
  2692 00000E81 E82C01                   call skipBlank
  2693                                  
  2694                                  ;-106   if (*InputPtr == c) {
  2695                                  
  2696 00000E84 8B1E[2700]               mov bx, [InputPtr]
  2697 00000E88 8A07                     mov al, [bx]
  2698 00000E8A B400                     mov ah, 0
  2699 00000E8C 3A4604                   cmp al, [bp+4]
  2700 00000E8F 0F850D00                 jne @@isToken119
  2701                                  
  2702                                  ;-107     InputPtr++; return 1;} return 0;
  2703                                  
  2704 00000E93 FF06[2700]               inc  word [InputPtr]
  2705 00000E97 66B801000000             mov eax, 1
  2706 00000E9D E90900                   jmp @@retn
  2707                                  @@isToken119:
  2708 00000EA0 66B800000000             mov eax, 0
  2709 00000EA6 E90000                   jmp @@retn
  2710                                  
  2711                                  ;-108 }
  2712                                  
  2713                                  
  2714                                  ;-109 int skipRest() {
  2715                                  
  2716 00000EA9 C9                      @@retn: LEAVE
  2717 00000EAA C3                       ret
  2718                                  ; ENDP
  2719                                  
  2720                                  skipRest:  ; *** PROC ***
  2721                                  
  2722                                  ;-110   getTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");
  2723                                  
  2724 00000EAB E852FC                   call getTokeType
  2725 00000EAE A0[3B00]                 mov al, [TokeType]
  2726 00000EB1 3C00                     cmp al, 0
  2727 00000EB3 0F840900                 je  @@skipRest120
  2728 00000EB7 68[C10E]                 push skipRest_0
  2729 00000EBA E82608                   call prs
  2730 00000EBD 83C402                   add  sp, 2
  2731                                  
  2732                                  ;-111 }
  2733                                  
  2734                                  @@skipRest120:
  2735 00000EC0 C3                       ret
  2736                                  ; ENDP
  2737 00000EC1 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ********** extra char ignored",0
  2738 00000ECA 2A2A2A2A2A20657874-
  2739 00000ED3 726120636861722069-
  2740 00000EDC 676E6F72656400     
  2741                                  ;Back to main program: AS.C
  2742                                  
  2743                                  ;-180 #include "HELPER.C"
  2744                                  
  2745                                  ;Use include file: HELPER.C
  2746                                  
  2747                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2748                                  
  2749                                  
  2750                                  getLine:  ; *** PROC ***
  2751                                  
  2752                                  ;-2   InputPtr= &InputBuf;
  2753                                  
  2754 00000EE3 B86E75                   mov ax, InputBuf
  2755 00000EE6 A3[2700]                 mov word [InputPtr], ax
  2756                                  
  2757                                  ;-3   *InputPtr=0;//if last line is empty
  2758                                  
  2759 00000EE9 66B800000000             mov eax, 0
  2760 00000EEF 8B1E[2700]               mov  bx, [InputPtr]
  2761 00000EF3 8807                     mov  [bx], al
  2762                                  
  2763                                  ;-4   do {
  2764                                  
  2765                                  @@getLine121:
  2766                                  
  2767                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2768                                  
  2769 00000EF5 6A01                     push 1
  2770 00000EF7 FF36[2900]               push word [asm_fd]
  2771 00000EFB 8D06[3500]               lea  ax, [DOS_ByteRead]
  2772 00000EFF 50                       push ax
  2773 00000F00 E85F10                   call readRL
  2774 00000F03 83C406                   add  sp, 6
  2775 00000F06 A3[3300]                 mov word [DOS_NoBytes], ax
  2776                                  
  2777                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  2778                                  
  2779 00000F09 A1[2F00]                 mov ax, [DOS_ERR]
  2780 00000F0C 08C0                     or  al, al
  2781 00000F0E 0F840900                 je @@getLine122
  2782 00000F12 68[5A0F]                 push getLine_0
  2783 00000F15 E8590A                   call errorexit
  2784 00000F18 83C402                   add  sp, 2
  2785                                  
  2786                                  ;-7     if (DOS_NoBytes == 0) return;
  2787                                  
  2788                                  @@getLine122:
  2789 00000F1B A1[3300]                 mov ax, [DOS_NoBytes]
  2790 00000F1E 83F800                   cmp ax, 0
  2791 00000F21 0F850300                 jne @@getLine123
  2792 00000F25 E93100                   jmp @@retn
  2793                                  
  2794                                  ;-8     *InputPtr = DOS_ByteRead;
  2795                                  
  2796                                  @@getLine123:
  2797 00000F28 A0[3500]                 mov al, [DOS_ByteRead]
  2798 00000F2B 8B1E[2700]               mov  bx, [InputPtr]
  2799 00000F2F 8807                     mov  [bx], al
  2800                                  
  2801                                  ;-9     InputPtr++;
  2802                                  
  2803 00000F31 FF06[2700]               inc  word [InputPtr]
  2804                                  
  2805                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  2806                                  
  2807 00000F35 A0[3500]                 mov al, byte [DOS_ByteRead]
  2808 00000F38 B400                     mov ah, 0
  2809 00000F3A 50                       push ax
  2810 00000F3B E82B00                   call ifEOL
  2811 00000F3E 83C402                   add  sp, 2
  2812 00000F41 3C00                     cmp al, 0
  2813 00000F43 0F850200                 jne @@getLine124
  2814 00000F47 EBAC                     jmp @@getLine121
  2815                                  @@getLine124:
  2816                                  
  2817                                  ;-11   InputPtr--;
  2818                                  
  2819 00000F49 FF0E[2700]               dec  word [InputPtr]
  2820                                  
  2821                                  ;-12   *InputPtr=0;
  2822                                  
  2823 00000F4D 66B800000000             mov eax, 0
  2824 00000F53 8B1E[2700]               mov  bx, [InputPtr]
  2825 00000F57 8807                     mov  [bx], al
  2826                                  
  2827                                  ;-13 }
  2828                                  
  2829                                  
  2830                                  ;-14 int ifEOL(char c) {
  2831                                  
  2832                                  @@retn:
  2833 00000F59 C3                       ret
  2834                                  ; ENDP
  2835 00000F5A 52656164696E672053-     getLine_0 db "Reading Source",0
  2836 00000F63 6F7572636500       
  2837                                  
  2838                                  ifEOL:  ; *** PROC ***
  2839                                  
  2840                                  ;-15   if (c == 10) return 1;
  2841                                  
  2842                                  ;Function : ifEOL, Number of local variables: 1
  2843                                  ;   # type sign width line used address name   list of local variables
  2844                                  ;  200 var sign byte    14 NULL bp+4    c;
  2845 00000F69 C8000000                 ENTER  0,0
  2846 00000F6D 8A4604                   mov al, [bp+4]
  2847 00000F70 3C0A                     cmp al, 10
  2848 00000F72 0F850900                 jne @@ifEOL125
  2849 00000F76 66B801000000             mov eax, 1
  2850 00000F7C E92F00                   jmp @@retn
  2851                                  
  2852                                  ;-16   if (c == 13) {
  2853                                  
  2854                                  @@ifEOL125:
  2855 00000F7F 8A4604                   mov al, [bp+4]
  2856 00000F82 3C0D                     cmp al, 13
  2857 00000F84 0F851D00                 jne @@ifEOL126
  2858                                  
  2859                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2860                                  
  2861 00000F88 6A01                     push 1
  2862 00000F8A FF36[2900]               push word [asm_fd]
  2863 00000F8E 8D06[3500]               lea  ax, [DOS_ByteRead]
  2864 00000F92 50                       push ax
  2865 00000F93 E8CC0F                   call readRL
  2866 00000F96 83C406                   add  sp, 6
  2867 00000F99 A3[3300]                 mov word [DOS_NoBytes], ax
  2868                                  
  2869                                  ;-18     return 1;}
  2870                                  
  2871 00000F9C 66B801000000             mov eax, 1
  2872 00000FA2 E90900                   jmp @@retn
  2873                                  
  2874                                  ;-19   return 0;
  2875                                  
  2876                                  @@ifEOL126:
  2877 00000FA5 66B800000000             mov eax, 0
  2878 00000FAB E90000                   jmp @@retn
  2879                                  
  2880                                  ;-20 }
  2881                                  
  2882                                  
  2883                                  ;-21 int skipBlank() {
  2884                                  
  2885 00000FAE C9                      @@retn: LEAVE
  2886 00000FAF C3                       ret
  2887                                  ; ENDP
  2888                                  
  2889                                  skipBlank:  ; *** PROC ***
  2890                                  
  2891                                  ;-22   skipblank1:
  2892                                  
  2893                                  @@skipblank1:
  2894                                  
  2895                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2896                                  
  2897 00000FB0 8B1E[2700]               mov bx, [InputPtr]
  2898 00000FB4 8A07                     mov al, [bx]
  2899 00000FB6 B400                     mov ah, 0
  2900 00000FB8 83F820                   cmp ax, 32
  2901 00000FBB 0F850600                 jne @@skipBlank127
  2902 00000FBF FF06[2700]               inc  word [InputPtr]
  2903 00000FC3 EBEB                     jmp @@skipblank1
  2904                                  
  2905                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2906                                  
  2907                                  @@skipBlank127:
  2908 00000FC5 8B1E[2700]               mov bx, [InputPtr]
  2909 00000FC9 8A07                     mov al, [bx]
  2910 00000FCB B400                     mov ah, 0
  2911 00000FCD 83F809                   cmp ax, 9
  2912 00000FD0 0F850600                 jne @@skipBlank128
  2913 00000FD4 FF06[2700]               inc  word [InputPtr]
  2914 00000FD8 EBD6                     jmp @@skipblank1
  2915                                  
  2916                                  ;-25 }
  2917                                  
  2918                                  @@skipBlank128:
  2919                                  
  2920                                  ;-26 int letterE(char c) {
  2921                                  
  2922 00000FDA C3                       ret
  2923                                  ; ENDP
  2924                                  
  2925                                  letterE:  ; *** PROC ***
  2926                                  
  2927                                  ;-27   if (c=='_') return 1;
  2928                                  
  2929                                  ;Function : letterE, Number of local variables: 1
  2930                                  ;   # type sign width line used address name   list of local variables
  2931                                  ;  200 var sign byte    26 NULL bp+4    c;
  2932 00000FDB C8000000                 ENTER  0,0
  2933 00000FDF 8A4604                   mov al, [bp+4]
  2934 00000FE2 3C5F                     cmp al, 95
  2935 00000FE4 0F850900                 jne @@letterE129
  2936 00000FE8 66B801000000             mov eax, 1
  2937 00000FEE E97E00                   jmp @@retn
  2938                                  
  2939                                  ;-28   if (c=='.') return 1;
  2940                                  
  2941                                  @@letterE129:
  2942 00000FF1 8A4604                   mov al, [bp+4]
  2943 00000FF4 3C2E                     cmp al, 46
  2944 00000FF6 0F850900                 jne @@letterE130
  2945 00000FFA 66B801000000             mov eax, 1
  2946 00001000 E96C00                   jmp @@retn
  2947                                  
  2948                                  ;-29   if (c=='?') return 1;
  2949                                  
  2950                                  @@letterE130:
  2951 00001003 8A4604                   mov al, [bp+4]
  2952 00001006 3C3F                     cmp al, 63
  2953 00001008 0F850900                 jne @@letterE131
  2954 0000100C 66B801000000             mov eax, 1
  2955 00001012 E95A00                   jmp @@retn
  2956                                  
  2957                                  ;-30   if (c=='$') return 1;
  2958                                  
  2959                                  @@letterE131:
  2960 00001015 8A4604                   mov al, [bp+4]
  2961 00001018 3C24                     cmp al, 36
  2962 0000101A 0F850900                 jne @@letterE132
  2963 0000101E 66B801000000             mov eax, 1
  2964 00001024 E94800                   jmp @@retn
  2965                                  
  2966                                  ;-31   if (c> 'z') return 0;
  2967                                  
  2968                                  @@letterE132:
  2969 00001027 8A4604                   mov al, [bp+4]
  2970 0000102A 3C7A                     cmp al, 122
  2971 0000102C 0F8E0900                 jle @@letterE133
  2972 00001030 66B800000000             mov eax, 0
  2973 00001036 E93600                   jmp @@retn
  2974                                  
  2975                                  ;-32   if (c< '@') return 0; // at included
  2976                                  
  2977                                  @@letterE133:
  2978 00001039 8A4604                   mov al, [bp+4]
  2979 0000103C 3C40                     cmp al, 64
  2980 0000103E 0F8D0900                 jge @@letterE134
  2981 00001042 66B800000000             mov eax, 0
  2982 00001048 E92400                   jmp @@retn
  2983                                  
  2984                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  2985                                  
  2986                                  @@letterE134:
  2987 0000104B 8A4604                   mov al, [bp+4]
  2988 0000104E 3C5A                     cmp al, 90
  2989 00001050 0F8E1200                 jle @@letterE135
  2990 00001054 8A4604                   mov al, [bp+4]
  2991 00001057 3C61                     cmp al, 97
  2992 00001059 0F8D0900                 jge @@letterE136
  2993 0000105D 66B800000000             mov eax, 0
  2994 00001063 E90900                   jmp @@retn
  2995                                  @@letterE136:
  2996                                  
  2997                                  ;-34   return 1;
  2998                                  
  2999                                  @@letterE135:
  3000 00001066 66B801000000             mov eax, 1
  3001 0000106C E90000                   jmp @@retn
  3002                                  
  3003                                  ;-35 }
  3004                                  
  3005                                  
  3006                                  ;-36 int alnumE(char c) {
  3007                                  
  3008 0000106F C9                      @@retn: LEAVE
  3009 00001070 C3                       ret
  3010                                  ; ENDP
  3011                                  
  3012                                  alnumE:  ; *** PROC ***
  3013                                  
  3014                                  ;-37   if (digit(c)) return 1;
  3015                                  
  3016                                  ;Function : alnumE, Number of local variables: 1
  3017                                  ;   # type sign width line used address name   list of local variables
  3018                                  ;  200 var sign byte    36 NULL bp+4    c;
  3019 00001071 C8000000                 ENTER  0,0
  3020 00001075 8A4604                   mov al, byte [bp+4]
  3021 00001078 B400                     mov ah, 0
  3022 0000107A 50                       push ax
  3023 0000107B E8160E                   call digit
  3024 0000107E 83C402                   add  sp, 2
  3025 00001081 08C0                     or  al, al
  3026 00001083 0F840900                 je @@alnumE137
  3027 00001087 66B801000000             mov eax, 1
  3028 0000108D E92400                   jmp @@retn
  3029                                  
  3030                                  ;-38   if (letterE(c)) return 1;
  3031                                  
  3032                                  @@alnumE137:
  3033 00001090 8A4604                   mov al, byte [bp+4]
  3034 00001093 B400                     mov ah, 0
  3035 00001095 50                       push ax
  3036 00001096 E842FF                   call letterE
  3037 00001099 83C402                   add  sp, 2
  3038 0000109C 08C0                     or  al, al
  3039 0000109E 0F840900                 je @@alnumE138
  3040 000010A2 66B801000000             mov eax, 1
  3041 000010A8 E90900                   jmp @@retn
  3042                                  
  3043                                  ;-39   return 0;
  3044                                  
  3045                                  @@alnumE138:
  3046 000010AB 66B800000000             mov eax, 0
  3047 000010B1 E90000                   jmp @@retn
  3048                                  
  3049                                  ;-40 }
  3050                                  
  3051                                  
  3052                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3053                                  
  3054 000010B4 C9                      @@retn: LEAVE
  3055 000010B5 C3                       ret
  3056                                  ; ENDP
  3057                                  
  3058                                  getDigit:  ; *** PROC ***
  3059                                  
  3060                                  ;-42   unsigned int CastInt;
  3061                                  
  3062                                  
  3063                                  ;-43   SymbolInt=0;
  3064                                  
  3065                                  ;Function : getDigit, Number of local variables: 2
  3066                                  ;   # type sign width line used address name   list of local variables
  3067                                  ;  200 var unsg byte    41 NULL bp+4    c
  3068                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3069 000010B6 C8020000                 ENTER  2,0
  3070 000010BA 66B800000000             mov eax, 0
  3071 000010C0 A3[2500]                 mov word [SymbolInt], ax
  3072                                  
  3073                                  ;-44   do {
  3074                                  
  3075                                  @@getDigit139:
  3076                                  
  3077                                  ;-45     c-='0';
  3078                                  
  3079 000010C3 806E0430                 sub  byte [bp+4], 48
  3080                                  
  3081                                  ;-46     SymbolInt=SymbolInt*10;
  3082                                  
  3083 000010C7 A1[2500]                 mov ax, [SymbolInt]
  3084 000010CA 66BB0A000000             mov ebx, 10
  3085 000010D0 66F7E3                   mul ebx
  3086 000010D3 A3[2500]                 mov word [SymbolInt], ax
  3087                                  
  3088                                  ;-47     ax=0; CastInt=c; //cast b2w
  3089                                  
  3090 000010D6 B80000                   mov  ax, 0
  3091 000010D9 8A4604                   mov al, [bp+4]
  3092 000010DC 8946FE                   mov word [bp-2], ax
  3093                                  
  3094                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3095                                  
  3096 000010DF A1[2500]                 mov ax, [SymbolInt]
  3097 000010E2 0346FE                   add ax, [bp-2]
  3098 000010E5 A3[2500]                 mov word [SymbolInt], ax
  3099                                  
  3100                                  ;-49     InputPtr++;
  3101                                  
  3102 000010E8 FF06[2700]               inc  word [InputPtr]
  3103                                  
  3104                                  ;-50     c = *InputPtr;
  3105                                  
  3106 000010EC 8B1E[2700]               mov bx, [InputPtr]
  3107 000010F0 8A07                     mov al, [bx]
  3108 000010F2 B400                     mov ah, 0
  3109 000010F4 884604                   mov byte [bp+4], al
  3110                                  
  3111                                  ;-51   } while(digit(c));
  3112                                  
  3113 000010F7 8A4604                   mov al, byte [bp+4]
  3114 000010FA B400                     mov ah, 0
  3115 000010FC 50                       push ax
  3116 000010FD E8940D                   call digit
  3117 00001100 83C402                   add  sp, 2
  3118 00001103 08C0                     or  al, al
  3119 00001105 0F840200                 je @@getDigit140
  3120 00001109 EBB8                     jmp @@getDigit139
  3121                                  @@getDigit140:
  3122                                  
  3123                                  ;-52 }
  3124                                  
  3125                                  
  3126                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3127 0000110B C9                       LEAVE
  3128 0000110C C3                       ret
  3129                                  ; ENDP
  3130                                  
  3131                                  getName:  ; *** PROC ***
  3132                                  
  3133                                  ;-54   char *p;
  3134                                  
  3135                                  
  3136                                  ;-55   p = &Symbol;
  3137                                  
  3138                                  ;Function : getName, Number of local variables: 2
  3139                                  ;   # type sign width line used address name   list of local variables
  3140                                  ;  200 var unsg byte    53 NULL bp+4    c
  3141                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3142 0000110D C8020000                 ENTER  2,0
  3143 00001111 B83075                   mov ax, Symbol
  3144 00001114 8946FE                   mov word [bp-2], ax
  3145                                  
  3146                                  ;-56   *p = c;
  3147                                  
  3148 00001117 8A4604                   mov al, [bp+4]
  3149 0000111A 8B5EFE                   mov  bx, [bp-2]
  3150 0000111D 8807                     mov  [bx], al
  3151                                  
  3152                                  ;-57   p++;
  3153                                  
  3154 0000111F FF46FE                   inc  word [bp-2]
  3155                                  
  3156                                  ;-58   while (alnumE(c)) {
  3157                                  
  3158                                  @@getName141:
  3159 00001122 8A4604                   mov al, byte [bp+4]
  3160 00001125 B400                     mov ah, 0
  3161 00001127 50                       push ax
  3162 00001128 E846FF                   call alnumE
  3163 0000112B 83C402                   add  sp, 2
  3164 0000112E 08C0                     or  al, al
  3165 00001130 0F841C00                 je @@getName142
  3166                                  
  3167                                  ;-59     InputPtr++;
  3168                                  
  3169 00001134 FF06[2700]               inc  word [InputPtr]
  3170                                  
  3171                                  ;-60     c = *InputPtr;
  3172                                  
  3173 00001138 8B1E[2700]               mov bx, [InputPtr]
  3174 0000113C 8A07                     mov al, [bx]
  3175 0000113E B400                     mov ah, 0
  3176 00001140 884604                   mov byte [bp+4], al
  3177                                  
  3178                                  ;-61     *p = c;
  3179                                  
  3180 00001143 8A4604                   mov al, [bp+4]
  3181 00001146 8B5EFE                   mov  bx, [bp-2]
  3182 00001149 8807                     mov  [bx], al
  3183                                  
  3184                                  ;-62     p++;
  3185                                  
  3186 0000114B FF46FE                   inc  word [bp-2]
  3187                                  
  3188                                  ;-63   }
  3189                                  
  3190                                  
  3191                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3192                                  
  3193 0000114E EBD2                     jmp @@getName141
  3194                                  @@getName142:
  3195 00001150 8A4604                   mov al, [bp+4]
  3196 00001153 3C3A                     cmp al, 58
  3197 00001155 0F850C00                 jne @@getName143
  3198 00001159 66B801000000             mov eax, 1
  3199 0000115F A2[3A00]                 mov byte [isLabel], al
  3200 00001162 E90900                   jmp @@getName144
  3201                                  @@getName143:
  3202 00001165 66B800000000             mov eax, 0
  3203 0000116B A2[3A00]                 mov byte [isLabel], al
  3204                                  
  3205                                  ;-65   p--;
  3206                                  
  3207                                  @@getName144:
  3208 0000116E FF4EFE                   dec  word [bp-2]
  3209                                  
  3210                                  ;-66   *p = 0;
  3211                                  
  3212 00001171 66B800000000             mov eax, 0
  3213 00001177 8B5EFE                   mov  bx, [bp-2]
  3214 0000117A 8807                     mov  [bx], al
  3215                                  
  3216                                  ;-67   strcpy(SymbolUpper, Symbol);
  3217                                  
  3218 0000117C 8D063075                 lea  ax, [Symbol]
  3219 00001180 50                       push ax
  3220 00001181 8D064F75                 lea  ax, [SymbolUpper]
  3221 00001185 50                       push ax
  3222 00001186 E8D20C                   call strcpy
  3223 00001189 83C404                   add  sp, 4
  3224                                  
  3225                                  ;-68   toupper(SymbolUpper);
  3226                                  
  3227 0000118C 8D064F75                 lea  ax, [SymbolUpper]
  3228 00001190 50                       push ax
  3229 00001191 E8590C                   call toupper
  3230 00001194 83C402                   add  sp, 2
  3231                                  
  3232                                  ;-69 }
  3233                                  
  3234                                  
  3235                                  ;-70 int testReg() {
  3236 00001197 C9                       LEAVE
  3237 00001198 C3                       ret
  3238                                  ; ENDP
  3239                                  
  3240                                  testReg:  ; *** PROC ***
  3241                                  
  3242                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3243                                  
  3244                                  
  3245                                  ;-72   RegType=0;
  3246                                  
  3247 00001199 66B800000000             mov eax, 0
  3248 0000119F A2[3E00]                 mov byte [RegType], al
  3249                                  
  3250                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3251                                  
  3252 000011A2 8D063075                 lea  ax, [Symbol]
  3253 000011A6 50                       push ax
  3254 000011A7 E8860C                   call strlen
  3255 000011AA 83C402                   add  sp, 2
  3256 000011AD 3C02                     cmp al, 2
  3257 000011AF 0F8D0900                 jge @@testReg145
  3258 000011B3 66B800000000             mov eax, 0
  3259 000011B9 E9B603                   jmp @@retn
  3260                                  
  3261                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3262                                  
  3263                                  @@testReg145:
  3264 000011BC 8D063075                 lea  ax, [Symbol]
  3265 000011C0 50                       push ax
  3266 000011C1 E86C0C                   call strlen
  3267 000011C4 83C402                   add  sp, 2
  3268 000011C7 3C03                     cmp al, 3
  3269 000011C9 0F8E0900                 jle @@testReg146
  3270 000011CD 66B800000000             mov eax, 0
  3271 000011D3 E99C03                   jmp @@retn
  3272                                  
  3273                                  ;-75   RegType=BYTE;
  3274                                  
  3275                                  @@testReg146:
  3276 000011D6 66B801000000             mov eax, 1
  3277 000011DC A2[3E00]                 mov byte [RegType], al
  3278                                  
  3279                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3280                                  
  3281 000011DF 68[7315]                 push testReg_0
  3282 000011E2 8D064F75                 lea  ax, [SymbolUpper]
  3283 000011E6 50                       push ax
  3284 000011E7 E8DD0C                   call eqstr
  3285 000011EA 83C404                   add  sp, 4
  3286 000011ED 08C0                     or  al, al
  3287 000011EF 0F840900                 je @@testReg147
  3288 000011F3 66B800000000             mov eax, 0
  3289 000011F9 E97603                   jmp @@retn
  3290                                  
  3291                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3292                                  
  3293                                  @@testReg147:
  3294 000011FC 68[7615]                 push testReg_1
  3295 000011FF 8D064F75                 lea  ax, [SymbolUpper]
  3296 00001203 50                       push ax
  3297 00001204 E8C00C                   call eqstr
  3298 00001207 83C404                   add  sp, 4
  3299 0000120A 08C0                     or  al, al
  3300 0000120C 0F840900                 je @@testReg148
  3301 00001210 66B801000000             mov eax, 1
  3302 00001216 E95903                   jmp @@retn
  3303                                  
  3304                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3305                                  
  3306                                  @@testReg148:
  3307 00001219 68[7915]                 push testReg_2
  3308 0000121C 8D064F75                 lea  ax, [SymbolUpper]
  3309 00001220 50                       push ax
  3310 00001221 E8A30C                   call eqstr
  3311 00001224 83C404                   add  sp, 4
  3312 00001227 08C0                     or  al, al
  3313 00001229 0F840900                 je @@testReg149
  3314 0000122D 66B802000000             mov eax, 2
  3315 00001233 E93C03                   jmp @@retn
  3316                                  
  3317                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3318                                  
  3319                                  @@testReg149:
  3320 00001236 68[7C15]                 push testReg_3
  3321 00001239 8D064F75                 lea  ax, [SymbolUpper]
  3322 0000123D 50                       push ax
  3323 0000123E E8860C                   call eqstr
  3324 00001241 83C404                   add  sp, 4
  3325 00001244 08C0                     or  al, al
  3326 00001246 0F840900                 je @@testReg150
  3327 0000124A 66B803000000             mov eax, 3
  3328 00001250 E91F03                   jmp @@retn
  3329                                  
  3330                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3331                                  
  3332                                  @@testReg150:
  3333 00001253 68[7F15]                 push testReg_4
  3334 00001256 8D064F75                 lea  ax, [SymbolUpper]
  3335 0000125A 50                       push ax
  3336 0000125B E8690C                   call eqstr
  3337 0000125E 83C404                   add  sp, 4
  3338 00001261 08C0                     or  al, al
  3339 00001263 0F840900                 je @@testReg151
  3340 00001267 66B804000000             mov eax, 4
  3341 0000126D E90203                   jmp @@retn
  3342                                  
  3343                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3344                                  
  3345                                  @@testReg151:
  3346 00001270 68[8215]                 push testReg_5
  3347 00001273 8D064F75                 lea  ax, [SymbolUpper]
  3348 00001277 50                       push ax
  3349 00001278 E84C0C                   call eqstr
  3350 0000127B 83C404                   add  sp, 4
  3351 0000127E 08C0                     or  al, al
  3352 00001280 0F840900                 je @@testReg152
  3353 00001284 66B805000000             mov eax, 5
  3354 0000128A E9E502                   jmp @@retn
  3355                                  
  3356                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3357                                  
  3358                                  @@testReg152:
  3359 0000128D 68[8515]                 push testReg_6
  3360 00001290 8D064F75                 lea  ax, [SymbolUpper]
  3361 00001294 50                       push ax
  3362 00001295 E82F0C                   call eqstr
  3363 00001298 83C404                   add  sp, 4
  3364 0000129B 08C0                     or  al, al
  3365 0000129D 0F840900                 je @@testReg153
  3366 000012A1 66B806000000             mov eax, 6
  3367 000012A7 E9C802                   jmp @@retn
  3368                                  
  3369                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3370                                  
  3371                                  @@testReg153:
  3372 000012AA 68[8815]                 push testReg_7
  3373 000012AD 8D064F75                 lea  ax, [SymbolUpper]
  3374 000012B1 50                       push ax
  3375 000012B2 E8120C                   call eqstr
  3376 000012B5 83C404                   add  sp, 4
  3377 000012B8 08C0                     or  al, al
  3378 000012BA 0F840900                 je @@testReg154
  3379 000012BE 66B807000000             mov eax, 7
  3380 000012C4 E9AB02                   jmp @@retn
  3381                                  
  3382                                  ;-84   RegType=WORD;
  3383                                  
  3384                                  @@testReg154:
  3385 000012C7 66B802000000             mov eax, 2
  3386 000012CD A2[3E00]                 mov byte [RegType], al
  3387                                  
  3388                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3389                                  
  3390 000012D0 68[8B15]                 push testReg_8
  3391 000012D3 8D064F75                 lea  ax, [SymbolUpper]
  3392 000012D7 50                       push ax
  3393 000012D8 E8EC0B                   call eqstr
  3394 000012DB 83C404                   add  sp, 4
  3395 000012DE 08C0                     or  al, al
  3396 000012E0 0F840900                 je @@testReg155
  3397 000012E4 66B800000000             mov eax, 0
  3398 000012EA E98502                   jmp @@retn
  3399                                  
  3400                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3401                                  
  3402                                  @@testReg155:
  3403 000012ED 68[8E15]                 push testReg_9
  3404 000012F0 8D064F75                 lea  ax, [SymbolUpper]
  3405 000012F4 50                       push ax
  3406 000012F5 E8CF0B                   call eqstr
  3407 000012F8 83C404                   add  sp, 4
  3408 000012FB 08C0                     or  al, al
  3409 000012FD 0F840900                 je @@testReg156
  3410 00001301 66B801000000             mov eax, 1
  3411 00001307 E96802                   jmp @@retn
  3412                                  
  3413                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3414                                  
  3415                                  @@testReg156:
  3416 0000130A 68[9115]                 push testReg_10
  3417 0000130D 8D064F75                 lea  ax, [SymbolUpper]
  3418 00001311 50                       push ax
  3419 00001312 E8B20B                   call eqstr
  3420 00001315 83C404                   add  sp, 4
  3421 00001318 08C0                     or  al, al
  3422 0000131A 0F840900                 je @@testReg157
  3423 0000131E 66B802000000             mov eax, 2
  3424 00001324 E94B02                   jmp @@retn
  3425                                  
  3426                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3427                                  
  3428                                  @@testReg157:
  3429 00001327 68[9415]                 push testReg_11
  3430 0000132A 8D064F75                 lea  ax, [SymbolUpper]
  3431 0000132E 50                       push ax
  3432 0000132F E8950B                   call eqstr
  3433 00001332 83C404                   add  sp, 4
  3434 00001335 08C0                     or  al, al
  3435 00001337 0F840900                 je @@testReg158
  3436 0000133B 66B803000000             mov eax, 3
  3437 00001341 E92E02                   jmp @@retn
  3438                                  
  3439                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3440                                  
  3441                                  @@testReg158:
  3442 00001344 68[9715]                 push testReg_12
  3443 00001347 8D064F75                 lea  ax, [SymbolUpper]
  3444 0000134B 50                       push ax
  3445 0000134C E8780B                   call eqstr
  3446 0000134F 83C404                   add  sp, 4
  3447 00001352 08C0                     or  al, al
  3448 00001354 0F840900                 je @@testReg159
  3449 00001358 66B804000000             mov eax, 4
  3450 0000135E E91102                   jmp @@retn
  3451                                  
  3452                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3453                                  
  3454                                  @@testReg159:
  3455 00001361 68[9A15]                 push testReg_13
  3456 00001364 8D064F75                 lea  ax, [SymbolUpper]
  3457 00001368 50                       push ax
  3458 00001369 E85B0B                   call eqstr
  3459 0000136C 83C404                   add  sp, 4
  3460 0000136F 08C0                     or  al, al
  3461 00001371 0F840900                 je @@testReg160
  3462 00001375 66B805000000             mov eax, 5
  3463 0000137B E9F401                   jmp @@retn
  3464                                  
  3465                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3466                                  
  3467                                  @@testReg160:
  3468 0000137E 68[9D15]                 push testReg_14
  3469 00001381 8D064F75                 lea  ax, [SymbolUpper]
  3470 00001385 50                       push ax
  3471 00001386 E83E0B                   call eqstr
  3472 00001389 83C404                   add  sp, 4
  3473 0000138C 08C0                     or  al, al
  3474 0000138E 0F840900                 je @@testReg161
  3475 00001392 66B806000000             mov eax, 6
  3476 00001398 E9D701                   jmp @@retn
  3477                                  
  3478                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3479                                  
  3480                                  @@testReg161:
  3481 0000139B 68[A015]                 push testReg_15
  3482 0000139E 8D064F75                 lea  ax, [SymbolUpper]
  3483 000013A2 50                       push ax
  3484 000013A3 E8210B                   call eqstr
  3485 000013A6 83C404                   add  sp, 4
  3486 000013A9 08C0                     or  al, al
  3487 000013AB 0F840900                 je @@testReg162
  3488 000013AF 66B807000000             mov eax, 7
  3489 000013B5 E9BA01                   jmp @@retn
  3490                                  
  3491                                  ;-93   RegType=SEGREG;
  3492                                  
  3493                                  @@testReg162:
  3494 000013B8 66B804000000             mov eax, 4
  3495 000013BE A2[3E00]                 mov byte [RegType], al
  3496                                  
  3497                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3498                                  
  3499 000013C1 68[A315]                 push testReg_16
  3500 000013C4 8D064F75                 lea  ax, [SymbolUpper]
  3501 000013C8 50                       push ax
  3502 000013C9 E8FB0A                   call eqstr
  3503 000013CC 83C404                   add  sp, 4
  3504 000013CF 08C0                     or  al, al
  3505 000013D1 0F840900                 je @@testReg163
  3506 000013D5 66B800000000             mov eax, 0
  3507 000013DB E99401                   jmp @@retn
  3508                                  
  3509                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3510                                  
  3511                                  @@testReg163:
  3512 000013DE 68[A615]                 push testReg_17
  3513 000013E1 8D064F75                 lea  ax, [SymbolUpper]
  3514 000013E5 50                       push ax
  3515 000013E6 E8DE0A                   call eqstr
  3516 000013E9 83C404                   add  sp, 4
  3517 000013EC 08C0                     or  al, al
  3518 000013EE 0F840900                 je @@testReg164
  3519 000013F2 66B801000000             mov eax, 1
  3520 000013F8 E97701                   jmp @@retn
  3521                                  
  3522                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3523                                  
  3524                                  @@testReg164:
  3525 000013FB 68[A915]                 push testReg_18
  3526 000013FE 8D064F75                 lea  ax, [SymbolUpper]
  3527 00001402 50                       push ax
  3528 00001403 E8C10A                   call eqstr
  3529 00001406 83C404                   add  sp, 4
  3530 00001409 08C0                     or  al, al
  3531 0000140B 0F840900                 je @@testReg165
  3532 0000140F 66B802000000             mov eax, 2
  3533 00001415 E95A01                   jmp @@retn
  3534                                  
  3535                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3536                                  
  3537                                  @@testReg165:
  3538 00001418 68[AC15]                 push testReg_19
  3539 0000141B 8D064F75                 lea  ax, [SymbolUpper]
  3540 0000141F 50                       push ax
  3541 00001420 E8A40A                   call eqstr
  3542 00001423 83C404                   add  sp, 4
  3543 00001426 08C0                     or  al, al
  3544 00001428 0F840900                 je @@testReg166
  3545 0000142C 66B803000000             mov eax, 3
  3546 00001432 E93D01                   jmp @@retn
  3547                                  
  3548                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3549                                  
  3550                                  @@testReg166:
  3551 00001435 68[AF15]                 push testReg_20
  3552 00001438 8D064F75                 lea  ax, [SymbolUpper]
  3553 0000143C 50                       push ax
  3554 0000143D E8870A                   call eqstr
  3555 00001440 83C404                   add  sp, 4
  3556 00001443 08C0                     or  al, al
  3557 00001445 0F840900                 je @@testReg167
  3558 00001449 66B804000000             mov eax, 4
  3559 0000144F E92001                   jmp @@retn
  3560                                  
  3561                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3562                                  
  3563                                  @@testReg167:
  3564 00001452 68[B215]                 push testReg_21
  3565 00001455 8D064F75                 lea  ax, [SymbolUpper]
  3566 00001459 50                       push ax
  3567 0000145A E86A0A                   call eqstr
  3568 0000145D 83C404                   add  sp, 4
  3569 00001460 08C0                     or  al, al
  3570 00001462 0F840900                 je @@testReg168
  3571 00001466 66B805000000             mov eax, 5
  3572 0000146C E90301                   jmp @@retn
  3573                                  
  3574                                  ;-100   RegType=DWORD;
  3575                                  
  3576                                  @@testReg168:
  3577 0000146F 66B803000000             mov eax, 3
  3578 00001475 A2[3E00]                 mov byte [RegType], al
  3579                                  
  3580                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3581                                  
  3582 00001478 68[B515]                 push testReg_22
  3583 0000147B 8D064F75                 lea  ax, [SymbolUpper]
  3584 0000147F 50                       push ax
  3585 00001480 E8440A                   call eqstr
  3586 00001483 83C404                   add  sp, 4
  3587 00001486 08C0                     or  al, al
  3588 00001488 0F840900                 je @@testReg169
  3589 0000148C 66B800000000             mov eax, 0
  3590 00001492 E9DD00                   jmp @@retn
  3591                                  
  3592                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3593                                  
  3594                                  @@testReg169:
  3595 00001495 68[B915]                 push testReg_23
  3596 00001498 8D064F75                 lea  ax, [SymbolUpper]
  3597 0000149C 50                       push ax
  3598 0000149D E8270A                   call eqstr
  3599 000014A0 83C404                   add  sp, 4
  3600 000014A3 08C0                     or  al, al
  3601 000014A5 0F840900                 je @@testReg170
  3602 000014A9 66B801000000             mov eax, 1
  3603 000014AF E9C000                   jmp @@retn
  3604                                  
  3605                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3606                                  
  3607                                  @@testReg170:
  3608 000014B2 68[BD15]                 push testReg_24
  3609 000014B5 8D064F75                 lea  ax, [SymbolUpper]
  3610 000014B9 50                       push ax
  3611 000014BA E80A0A                   call eqstr
  3612 000014BD 83C404                   add  sp, 4
  3613 000014C0 08C0                     or  al, al
  3614 000014C2 0F840900                 je @@testReg171
  3615 000014C6 66B802000000             mov eax, 2
  3616 000014CC E9A300                   jmp @@retn
  3617                                  
  3618                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3619                                  
  3620                                  @@testReg171:
  3621 000014CF 68[C115]                 push testReg_25
  3622 000014D2 8D064F75                 lea  ax, [SymbolUpper]
  3623 000014D6 50                       push ax
  3624 000014D7 E8ED09                   call eqstr
  3625 000014DA 83C404                   add  sp, 4
  3626 000014DD 08C0                     or  al, al
  3627 000014DF 0F840900                 je @@testReg172
  3628 000014E3 66B803000000             mov eax, 3
  3629 000014E9 E98600                   jmp @@retn
  3630                                  
  3631                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3632                                  
  3633                                  @@testReg172:
  3634 000014EC 68[C515]                 push testReg_26
  3635 000014EF 8D064F75                 lea  ax, [SymbolUpper]
  3636 000014F3 50                       push ax
  3637 000014F4 E8D009                   call eqstr
  3638 000014F7 83C404                   add  sp, 4
  3639 000014FA 08C0                     or  al, al
  3640 000014FC 0F840900                 je @@testReg173
  3641 00001500 66B804000000             mov eax, 4
  3642 00001506 E96900                   jmp @@retn
  3643                                  
  3644                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3645                                  
  3646                                  @@testReg173:
  3647 00001509 68[C915]                 push testReg_27
  3648 0000150C 8D064F75                 lea  ax, [SymbolUpper]
  3649 00001510 50                       push ax
  3650 00001511 E8B309                   call eqstr
  3651 00001514 83C404                   add  sp, 4
  3652 00001517 08C0                     or  al, al
  3653 00001519 0F840900                 je @@testReg174
  3654 0000151D 66B805000000             mov eax, 5
  3655 00001523 E94C00                   jmp @@retn
  3656                                  
  3657                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3658                                  
  3659                                  @@testReg174:
  3660 00001526 68[CD15]                 push testReg_28
  3661 00001529 8D064F75                 lea  ax, [SymbolUpper]
  3662 0000152D 50                       push ax
  3663 0000152E E89609                   call eqstr
  3664 00001531 83C404                   add  sp, 4
  3665 00001534 08C0                     or  al, al
  3666 00001536 0F840900                 je @@testReg175
  3667 0000153A 66B806000000             mov eax, 6
  3668 00001540 E92F00                   jmp @@retn
  3669                                  
  3670                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3671                                  
  3672                                  @@testReg175:
  3673 00001543 68[D115]                 push testReg_29
  3674 00001546 8D064F75                 lea  ax, [SymbolUpper]
  3675 0000154A 50                       push ax
  3676 0000154B E87909                   call eqstr
  3677 0000154E 83C404                   add  sp, 4
  3678 00001551 08C0                     or  al, al
  3679 00001553 0F840900                 je @@testReg176
  3680 00001557 66B807000000             mov eax, 7
  3681 0000155D E91200                   jmp @@retn
  3682                                  
  3683                                  ;-109   RegType=0; return 0;
  3684                                  
  3685                                  @@testReg176:
  3686 00001560 66B800000000             mov eax, 0
  3687 00001566 A2[3E00]                 mov byte [RegType], al
  3688 00001569 66B800000000             mov eax, 0
  3689 0000156F E90000                   jmp @@retn
  3690                                  
  3691                                  ;-110 }
  3692                                  
  3693                                  @@retn:
  3694 00001572 C3                       ret
  3695                                  ; ENDP
  3696 00001573 414C00                  testReg_0 db "AL",0
  3697 00001576 434C00                  testReg_1 db "CL",0
  3698 00001579 444C00                  testReg_2 db "DL",0
  3699 0000157C 424C00                  testReg_3 db "BL",0
  3700 0000157F 414800                  testReg_4 db "AH",0
  3701 00001582 434800                  testReg_5 db "CH",0
  3702 00001585 444800                  testReg_6 db "DH",0
  3703 00001588 424800                  testReg_7 db "BH",0
  3704 0000158B 415800                  testReg_8 db "AX",0
  3705 0000158E 435800                  testReg_9 db "CX",0
  3706 00001591 445800                  testReg_10 db "DX",0
  3707 00001594 425800                  testReg_11 db "BX",0
  3708 00001597 535000                  testReg_12 db "SP",0
  3709 0000159A 425000                  testReg_13 db "BP",0
  3710 0000159D 534900                  testReg_14 db "SI",0
  3711 000015A0 444900                  testReg_15 db "DI",0
  3712 000015A3 455300                  testReg_16 db "ES",0
  3713 000015A6 435300                  testReg_17 db "CS",0
  3714 000015A9 535300                  testReg_18 db "SS",0
  3715 000015AC 445300                  testReg_19 db "DS",0
  3716 000015AF 465300                  testReg_20 db "FS",0
  3717 000015B2 475300                  testReg_21 db "GS",0
  3718 000015B5 45415800                testReg_22 db "EAX",0
  3719 000015B9 45435800                testReg_23 db "ECX",0
  3720 000015BD 45445800                testReg_24 db "EDX",0
  3721 000015C1 45425800                testReg_25 db "EBX",0
  3722 000015C5 45535000                testReg_26 db "ESP",0
  3723 000015C9 45425000                testReg_27 db "EBP",0
  3724 000015CD 45534900                testReg_28 db "ESI",0
  3725 000015D1 45444900                testReg_29 db "EDI",0
  3726                                  ;Back to main program: AS.C
  3727                                  
  3728                                  ;-181 #include "OUTPUT.C"
  3729                                  
  3730                                  ;Use include file: OUTPUT.C
  3731                                  
  3732                                  ;-1 int printLine() { int i; char c;
  3733                                  
  3734                                  
  3735                                  printLine:  ; *** PROC ***
  3736                                  
  3737                                  ;-2   prs("\n"); printhex16(PCStart);
  3738                                  
  3739                                  ;Function : printLine, Number of local variables: 2
  3740                                  ;   # type sign width line used address name   list of local variables
  3741                                  ;  200 var sign word     1 NULL bp-2    i
  3742                                  ;  201 var sign byte     1 NULL bp-4    c;
  3743 000015D5 C8040000                 ENTER  4,0
  3744 000015D9 68[6A16]                 push printLine_0
  3745 000015DC E80401                   call prs
  3746 000015DF 83C402                   add  sp, 2
  3747 000015E2 FF36[3800]               push word [PCStart]
  3748 000015E6 E8EB01                   call printhex16
  3749 000015E9 83C402                   add  sp, 2
  3750                                  
  3751                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  3752                                  
  3753 000015EC A1[4900]                 mov ax, [OpPrintIndex]
  3754 000015EF 83F800                   cmp ax, 0
  3755 000015F2 0F850C00                 jne @@printLine177
  3756 000015F6 68[6D16]                 push printLine_1
  3757 000015F9 E8E700                   call prs
  3758 000015FC 83C402                   add  sp, 2
  3759                                  
  3760                                  ;-4   else {
  3761                                  
  3762 000015FF E95B00                   jmp @@printLine178
  3763                                  @@printLine177:
  3764                                  
  3765                                  ;-5     prc(PrReloc);
  3766                                  
  3767 00001602 A0[4D00]                 mov al, byte [PrReloc]
  3768 00001605 B400                     mov ah, 0
  3769 00001607 50                       push ax
  3770 00001608 E87700                   call prc
  3771 0000160B 83C402                   add  sp, 2
  3772                                  
  3773                                  ;-6     i=0;
  3774                                  
  3775 0000160E 66B800000000             mov eax, 0
  3776 00001614 8946FE                   mov word [bp-2], ax
  3777                                  
  3778                                  ;-7     do {
  3779                                  
  3780                                  @@printLine179:
  3781                                  
  3782                                  ;-8       c=OpPos[i];
  3783                                  
  3784 00001617 8B5EFE                   mov bx, [bp-2]
  3785 0000161A 8A87B776                 mov al, [OpPos + bx]
  3786 0000161E 8846FC                   mov byte [bp-4], al
  3787                                  
  3788                                  ;-9       printhex8a(c); prc(' ');
  3789                                  
  3790 00001621 8A46FC                   mov al, byte [bp-4]
  3791 00001624 B400                     mov ah, 0
  3792 00001626 50                       push ax
  3793 00001627 E85C01                   call printhex8a
  3794 0000162A 83C402                   add  sp, 2
  3795 0000162D 6A20                     push 32
  3796 0000162F E85000                   call prc
  3797 00001632 83C402                   add  sp, 2
  3798                                  
  3799                                  ;-10       i++;
  3800                                  
  3801 00001635 FF46FE                   inc  word [bp-2]
  3802                                  
  3803                                  ;-11     } while(i < OpPrintIndex);
  3804                                  
  3805 00001638 8B46FE                   mov ax, [bp-2]
  3806 0000163B 3B06[4900]               cmp ax, [OpPrintIndex]
  3807 0000163F 0F8D0200                 jge @@printLine180
  3808 00001643 EBD2                     jmp @@printLine179
  3809                                  @@printLine180:
  3810                                  
  3811                                  ;-12     do {// fill rest with blank
  3812                                  
  3813                                  @@printLine181:
  3814                                  
  3815                                  ;-13       prs("   ");
  3816                                  
  3817 00001645 68[7E16]                 push printLine_2
  3818 00001648 E89800                   call prs
  3819 0000164B 83C402                   add  sp, 2
  3820                                  
  3821                                  ;-14       i++;
  3822                                  
  3823 0000164E FF46FE                   inc  word [bp-2]
  3824                                  
  3825                                  ;-15     } while(i < OPMAXLEN);
  3826                                  
  3827 00001651 8B46FE                   mov ax, [bp-2]
  3828 00001654 83F805                   cmp ax, 5
  3829 00001657 0F8D0200                 jge @@printLine182
  3830 0000165B EBE8                     jmp @@printLine181
  3831                                  @@printLine182:
  3832                                  
  3833                                  ;-16   }
  3834                                  
  3835                                  
  3836                                  ;-17   prscomment(InputBuf);
  3837                                  
  3838                                  @@printLine178:
  3839 0000165D 8D066E75                 lea  ax, [InputBuf]
  3840 00001661 50                       push ax
  3841 00001662 E85000                   call prscomment
  3842 00001665 83C402                   add  sp, 2
  3843                                  
  3844                                  ;-18 }
  3845                                  
  3846                                  
  3847                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  3848 00001668 C9                       LEAVE
  3849 00001669 C3                       ret
  3850                                  ; ENDP
  3851 0000166A 5C6E00                  printLine_0 db "\n",0
  3852 0000166D 202020202020202020-     printLine_1 db "                ",0
  3853 00001676 2020202020202000   
  3854 0000167E 20202000                printLine_2 db "   ",0
  3855                                  
  3856                                  prc:  ; *** PROC ***
  3857                                  ;Function : prc, Number of local variables: 1
  3858                                  ;   # type sign width line used address name   list of local variables
  3859                                  ;  200 var unsg byte    19 NULL bp+4    c;
  3860 00001682 C8000000                 ENTER  0,0
  3861 00001686 A0[2400]                 mov al, [LIST]
  3862 00001689 08C0                     or  al, al
  3863 0000168B 0F841400                 je @@prc183
  3864 0000168F 807E040A                cmp byte [bp+4], 10
  3865 00001693 0F850600                 jne @@prc184
  3866 00001697 B80D00                   mov  ax, 13
  3867 0000169A E81A07                   call writetty
  3868                                  
  3869                                  ;-20      al=c; writetty(); }
  3870                                  
  3871                                  @@prc184:
  3872 0000169D 8A4604                   mov  al, [bp+4]
  3873 000016A0 E81407                   call writetty
  3874                                  
  3875                                  ;-21    fputcR(c,lst_fd); }
  3876                                  
  3877                                  @@prc183:
  3878 000016A3 FF36[2B00]               push word [lst_fd]
  3879 000016A7 8A4604                   mov al, byte [bp+4]
  3880 000016AA B400                     mov ah, 0
  3881 000016AC 50                       push ax
  3882 000016AD E8C708                   call fputcR
  3883 000016B0 83C404                   add  sp, 4
  3884                                  
  3885                                  ;-22 
  3886                                  
  3887                                  
  3888                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  3889 000016B3 C9                       LEAVE
  3890 000016B4 C3                       ret
  3891                                  ; ENDP
  3892                                  
  3893                                  prscomment:  ; *** PROC ***
  3894                                  
  3895                                  ;-24   while(*s){c=*s;prc(c);s++;}
  3896                                  
  3897                                  ;Function : prscomment, Number of local variables: 2
  3898                                  ;   # type sign width line used address name   list of local variables
  3899                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  3900                                  ;  201 var unsg byte    23 NULL bp-2    c;
  3901 000016B5 C8020000                 ENTER  2,0
  3902                                  @@prscomment185:
  3903 000016B9 8B5E04                   mov bx, [bp+4]
  3904 000016BC 8A07                     mov al, [bx]
  3905 000016BE B400                     mov ah, 0
  3906 000016C0 08C0                     or  al, al
  3907 000016C2 0F841B00                 je @@prscomment186
  3908 000016C6 8B5E04                   mov bx, [bp+4]
  3909 000016C9 8A07                     mov al, [bx]
  3910 000016CB B400                     mov ah, 0
  3911 000016CD 8846FE                   mov byte [bp-2], al
  3912 000016D0 8A46FE                   mov al, byte [bp-2]
  3913 000016D3 B400                     mov ah, 0
  3914 000016D5 50                       push ax
  3915 000016D6 E8A9FF                   call prc
  3916 000016D9 83C402                   add  sp, 2
  3917 000016DC FF4604                   inc  word [bp+4]
  3918                                  
  3919                                  ;-25 }
  3920                                  
  3921 000016DF EBD8                     jmp @@prscomment185
  3922                                  @@prscomment186:
  3923                                  
  3924                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3925 000016E1 C9                       LEAVE
  3926 000016E2 C3                       ret
  3927                                  ; ENDP
  3928                                  
  3929                                  prs:  ; *** PROC ***
  3930                                  ;Function : prs, Number of local variables: 3
  3931                                  ;   # type sign width line used address name   list of local variables
  3932                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3933                                  ;  201 var unsg byte    26 NULL bp-2    c
  3934                                  ;  202 var sign word    26 NULL bp-4    com;
  3935 000016E3 C8040000                 ENTER  4,0
  3936 000016E7 66B800000000             mov eax, 0
  3937 000016ED 8946FC                   mov word [bp-4], ax
  3938                                  
  3939                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3940                                  
  3941                                  @@prs187:
  3942 000016F0 8B5E04                   mov bx, [bp+4]
  3943 000016F3 8A07                     mov al, [bx]
  3944 000016F5 B400                     mov ah, 0
  3945 000016F7 08C0                     or  al, al
  3946 000016F9 0F848700                 je @@prs188
  3947 000016FD 8B5E04                   mov bx, [bp+4]
  3948 00001700 8A07                     mov al, [bx]
  3949 00001702 B400                     mov ah, 0
  3950 00001704 8846FE                   mov byte [bp-2], al
  3951 00001707 8A46FE                   mov al, [bp-2]
  3952 0000170A 3C22                     cmp al, 34
  3953 0000170C 0F851E00                 jne @@prs189
  3954 00001710 8B46FC                   mov ax, [bp-4]
  3955 00001713 08C0                     or  al, al
  3956 00001715 0F840C00                 je @@prs190
  3957 00001719 66B800000000             mov eax, 0
  3958 0000171F 8946FC                   mov word [bp-4], ax
  3959 00001722 E90900                   jmp @@prs191
  3960                                  @@prs190:
  3961 00001725 66B801000000             mov eax, 1
  3962 0000172B 8946FC                   mov word [bp-4], ax
  3963                                  
  3964                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3965                                  
  3966                                  @@prs191:
  3967                                  @@prs189:
  3968 0000172E 8A46FE                   mov al, [bp-2]
  3969 00001731 3C5C                     cmp al, 92
  3970 00001733 0F853B00                 jne @@prs192
  3971 00001737 8B46FC                   mov ax, [bp-4]
  3972 0000173A 83F800                   cmp ax, 0
  3973 0000173D 0F853100                 jne @@prs193
  3974 00001741 FF4604                   inc  word [bp+4]
  3975 00001744 8B5E04                   mov bx, [bp+4]
  3976 00001747 8A07                     mov al, [bx]
  3977 00001749 B400                     mov ah, 0
  3978 0000174B 8846FE                   mov byte [bp-2], al
  3979                                  
  3980                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3981                                  
  3982 0000174E 8A46FE                   mov al, [bp-2]
  3983 00001751 3C6E                     cmp al, 110
  3984 00001753 0F850900                 jne @@prs194
  3985 00001757 66B80A000000             mov eax, 10
  3986 0000175D 8846FE                   mov byte [bp-2], al
  3987                                  @@prs194:
  3988 00001760 8A46FE                   mov al, [bp-2]
  3989 00001763 3C74                     cmp al, 116
  3990 00001765 0F850900                 jne @@prs195
  3991 00001769 66B809000000             mov eax, 9
  3992 0000176F 8846FE                   mov byte [bp-2], al
  3993                                  @@prs195:
  3994                                  @@prs193:
  3995                                  @@prs192:
  3996 00001772 8A46FE                   mov al, byte [bp-2]
  3997 00001775 B400                     mov ah, 0
  3998 00001777 50                       push ax
  3999 00001778 E807FF                   call prc
  4000 0000177B 83C402                   add  sp, 2
  4001 0000177E FF4604                   inc  word [bp+4]
  4002                                  
  4003                                  ;-30 }
  4004                                  
  4005 00001781 E96CFF                   jmp @@prs187
  4006                                  @@prs188:
  4007                                  
  4008                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4009 00001784 C9                       LEAVE
  4010 00001785 C3                       ret
  4011                                  ; ENDP
  4012                                  
  4013                                  printhex8a:  ; *** PROC ***
  4014                                  
  4015                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4016                                  
  4017                                  ;Function : printhex8a, Number of local variables: 2
  4018                                  ;   # type sign width line used address name   list of local variables
  4019                                  ;  200 var unsg word    31 NULL bp+4    c
  4020                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4021 00001786 C8020000                 ENTER  2,0
  4022 0000178A 8B4604                   mov ax, [bp+4]
  4023 0000178D C1E804                   shr ax, 4
  4024 00001790 8946FE                   mov word [bp-2], ax
  4025 00001793 8346FE30                 add  word [bp-2], 48
  4026 00001797 8B46FE                   mov ax, [bp-2]
  4027 0000179A 83F839                   cmp ax, 57
  4028 0000179D 0F8E0400                 jle @@printhex8a196
  4029 000017A1 8346FE07                 add  word [bp-2], 7
  4030                                  @@printhex8a196:
  4031 000017A5 FF76FE                   push word [bp-2]
  4032 000017A8 E8D7FE                   call prc
  4033 000017AB 83C402                   add  sp, 2
  4034                                  
  4035                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4036                                  
  4037 000017AE 8B4604                   mov ax, [bp+4]
  4038 000017B1 83E00F                   and ax, 15
  4039 000017B4 8946FE                   mov word [bp-2], ax
  4040 000017B7 8346FE30                 add  word [bp-2], 48
  4041 000017BB 8B46FE                   mov ax, [bp-2]
  4042 000017BE 83F839                   cmp ax, 57
  4043 000017C1 0F8E0400                 jle @@printhex8a197
  4044 000017C5 8346FE07                 add  word [bp-2], 7
  4045                                  @@printhex8a197:
  4046 000017C9 FF76FE                   push word [bp-2]
  4047 000017CC E8B3FE                   call prc
  4048 000017CF 83C402                   add  sp, 2
  4049                                  
  4050                                  ;-34 }
  4051                                  
  4052                                  
  4053                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4054 000017D2 C9                       LEAVE
  4055 000017D3 C3                       ret
  4056                                  ; ENDP
  4057                                  
  4058                                  printhex16:  ; *** PROC ***
  4059                                  
  4060                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4061                                  
  4062                                  ;Function : printhex16, Number of local variables: 2
  4063                                  ;   # type sign width line used address name   list of local variables
  4064                                  ;  200 var unsg word    35 NULL bp+4    i
  4065                                  ;  201 var unsg word    35 NULL bp-2    half;
  4066 000017D4 C8020000                 ENTER  2,0
  4067 000017D8 8B4604                   mov ax, [bp+4]
  4068 000017DB C1E808                   shr ax, 8
  4069 000017DE 8946FE                   mov word [bp-2], ax
  4070 000017E1 FF76FE                   push word [bp-2]
  4071 000017E4 E89FFF                   call printhex8a
  4072 000017E7 83C402                   add  sp, 2
  4073 000017EA 8B4604                   mov ax, [bp+4]
  4074 000017ED 25FF00                   and ax, 255
  4075 000017F0 8946FE                   mov word [bp-2], ax
  4076 000017F3 FF76FE                   push word [bp-2]
  4077 000017F6 E88DFF                   call printhex8a
  4078 000017F9 83C402                   add  sp, 2
  4079                                  
  4080                                  ;-37 }
  4081                                  
  4082                                  
  4083                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4084 000017FC C9                       LEAVE
  4085 000017FD C3                       ret
  4086                                  ; ENDP
  4087                                  
  4088                                  printIntU:  ; *** PROC ***
  4089                                  
  4090                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4091                                  
  4092                                  ;Function : printIntU, Number of local variables: 2
  4093                                  ;   # type sign width line used address name   list of local variables
  4094                                  ;  200 var unsg word    38 NULL bp+4    n
  4095                                  ;  201 var unsg word    38 NULL bp-2    e;
  4096 000017FE C8020000                 ENTER  2,0
  4097 00001802 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4098 00001806 0F821700                 jb  @@printIntU198
  4099 0000180A 8B4604                   mov ax, [bp+4]
  4100 0000180D BB0A00                   mov bx, 10
  4101 00001810 BA0000                   mov dx, 0
  4102 00001813 F7F3                     div bx
  4103 00001815 8946FE                   mov word [bp-2], ax
  4104                                  
  4105                                  ;-40     printIntU(e); }
  4106                                  
  4107 00001818 FF76FE                   push word [bp-2]
  4108 0000181B E8E0FF                   call printIntU
  4109 0000181E 83C402                   add  sp, 2
  4110                                  
  4111                                  ;-41     n = n % 10; //unsigned mod
  4112                                  
  4113                                  @@printIntU198:
  4114 00001821 8B4604                   mov ax, [bp+4]
  4115 00001824 BB0A00                   mov bx, 10
  4116 00001827 BA0000                   mov dx, 0
  4117 0000182A F7F3                     div bx
  4118 0000182C 89D0                     mov ax, dx
  4119 0000182E 894604                   mov word [bp+4], ax
  4120                                  
  4121                                  ;-42     n += '0'; prc(n);
  4122                                  
  4123 00001831 83460430                 add  word [bp+4], 48
  4124 00001835 FF7604                   push word [bp+4]
  4125 00001838 E847FE                   call prc
  4126 0000183B 83C402                   add  sp, 2
  4127                                  
  4128                                  ;-43 }
  4129                                  
  4130                                  
  4131                                  ;-44 
  4132                                  
  4133                                  
  4134                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4135 0000183E C9                       LEAVE
  4136 0000183F C3                       ret
  4137                                  ; ENDP
  4138                                  
  4139                                  error1:  ; *** PROC ***
  4140                                  ;Function : error1, Number of local variables: 1
  4141                                  ;   # type sign width line used address name   list of local variables
  4142                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4143 00001840 C8000000                 ENTER  0,0
  4144 00001844 66B801000000             mov eax, 1
  4145 0000184A A2[2400]                 mov byte [LIST], al
  4146 0000184D FF06[3100]               inc  word [ErrorCount]
  4147                                  
  4148                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4149                                  
  4150 00001851 68[7918]                 push error1_0
  4151 00001854 E88CFE                   call prs
  4152 00001857 83C402                   add  sp, 2
  4153 0000185A FF7604                   push word [bp+4]
  4154 0000185D E883FE                   call prs
  4155 00001860 83C402                   add  sp, 2
  4156                                  
  4157                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4158                                  
  4159 00001863 68[9418]                 push error1_1
  4160 00001866 E87AFE                   call prs
  4161 00001869 83C402                   add  sp, 2
  4162 0000186C 8D063075                 lea  ax, [Symbol]
  4163 00001870 50                       push ax
  4164 00001871 E86FFE                   call prs
  4165 00001874 83C402                   add  sp, 2
  4166                                  
  4167                                  ;-48 int allowederror(){error1("not allowed here"); }
  4168 00001877 C9                       LEAVE
  4169 00001878 C3                       ret
  4170                                  ; ENDP
  4171 00001879 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4172 00001882 6E657874206C696E65-
  4173 0000188B 204552524F523A2000 
  4174 00001894 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4175 0000189D 2000               
  4176                                  
  4177                                  allowederror:  ; *** PROC ***
  4178 0000189F 68[A918]                 push allowederror_0
  4179 000018A2 E89BFF                   call error1
  4180 000018A5 83C402                   add  sp, 2
  4181                                  
  4182                                  ;-49 int implmerror(){error1("not implemented");}
  4183                                  
  4184 000018A8 C3                       ret
  4185                                  ; ENDP
  4186 000018A9 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4187 000018B2 6564206865726500   
  4188                                  
  4189                                  implmerror:  ; *** PROC ***
  4190 000018BA 68[C418]                 push implmerror_0
  4191 000018BD E880FF                   call error1
  4192 000018C0 83C402                   add  sp, 2
  4193                                  
  4194                                  ;-50 int indexerror (){error1("invalid index register");}
  4195                                  
  4196 000018C3 C3                       ret
  4197                                  ; ENDP
  4198 000018C4 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4199 000018CD 6D656E74656400     
  4200                                  
  4201                                  indexerror:  ; *** PROC ***
  4202 000018D4 68[DE18]                 push indexerror_0
  4203 000018D7 E866FF                   call error1
  4204 000018DA 83C402                   add  sp, 2
  4205                                  
  4206                                  ;-51 int numbererror(){error1("number expected");}
  4207                                  
  4208 000018DD C3                       ret
  4209                                  ; ENDP
  4210 000018DE 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4211 000018E7 6E6465782072656769-
  4212 000018F0 7374657200         
  4213                                  
  4214                                  numbererror:  ; *** PROC ***
  4215 000018F5 68[FF18]                 push numbererror_0
  4216 000018F8 E845FF                   call error1
  4217 000018FB 83C402                   add  sp, 2
  4218                                  
  4219                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4220                                  
  4221 000018FE C3                       ret
  4222                                  ; ENDP
  4223 000018FF 6E756D626572206578-     numbererror_0 db "number expected",0
  4224 00001908 70656374656400     
  4225                                  
  4226                                  regmemerror:  ; *** PROC ***
  4227 0000190F 68[1919]                 push regmemerror_0
  4228 00001912 E82BFF                   call error1
  4229 00001915 83C402                   add  sp, 2
  4230                                  
  4231                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4232                                  
  4233 00001918 C3                       ret
  4234                                  ; ENDP
  4235 00001919 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4236 00001922 73746572206F72206D-
  4237 0000192B 656D6F727920616C6C-
  4238 00001934 6F77656400         
  4239                                  
  4240                                  segregerror:  ; *** PROC ***
  4241 00001939 68[4319]                 push segregerror_0
  4242 0000193C E801FF                   call error1
  4243 0000193F 83C402                   add  sp, 2
  4244                                  
  4245                                  ;-54 int syntaxerror(){error1("syntax");}
  4246                                  
  4247 00001942 C3                       ret
  4248                                  ; ENDP
  4249 00001943 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4250 0000194C 65676973746572206E-
  4251 00001955 6F7420616C6C6F7765-
  4252 0000195E 6400               
  4253                                  
  4254                                  syntaxerror:  ; *** PROC ***
  4255 00001960 68[6A19]                 push syntaxerror_0
  4256 00001963 E8DAFE                   call error1
  4257 00001966 83C402                   add  sp, 2
  4258                                  
  4259                                  ;-55 
  4260                                  
  4261                                  
  4262                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4263                                  
  4264 00001969 C3                       ret
  4265                                  ; ENDP
  4266 0000196A 73796E74617800          syntaxerror_0 db "syntax",0
  4267                                  
  4268                                  errorexit:  ; *** PROC ***
  4269                                  ;Function : errorexit, Number of local variables: 1
  4270                                  ;   # type sign width line used address name   list of local variables
  4271                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4272 00001971 C8000000                 ENTER  0,0
  4273 00001975 FF7604                   push word [bp+4]
  4274 00001978 E8C5FE                   call error1
  4275 0000197B 83C402                   add  sp, 2
  4276 0000197E 6A01                     push 1
  4277 00001980 E80704                   call end1
  4278 00001983 83C402                   add  sp, 2
  4279                                  
  4280                                  ;-57 int addrexit(){errorexit("illegal address");}
  4281 00001986 C9                       LEAVE
  4282 00001987 C3                       ret
  4283                                  ; ENDP
  4284                                  
  4285                                  addrexit:  ; *** PROC ***
  4286 00001988 68[9219]                 push addrexit_0
  4287 0000198B E8E3FF                   call errorexit
  4288 0000198E 83C402                   add  sp, 2
  4289                                  
  4290                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4291                                  
  4292 00001991 C3                       ret
  4293                                  ; ENDP
  4294 00001992 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4295 0000199B 64647265737300     
  4296                                  
  4297                                  internexit:  ; *** PROC ***
  4298 000019A2 68[AC19]                 push internexit_0
  4299 000019A5 E8C9FF                   call errorexit
  4300 000019A8 83C402                   add  sp, 2
  4301 000019AB C3                       ret
  4302                                  ; ENDP
  4303 000019AC 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4304 000019B5 6D70696C6572206572-
  4305 000019BE 726F7200           
  4306                                  ;Back to main program: AS.C
  4307                                  
  4308                                  ;-182 #include "MAIN.C"
  4309                                  
  4310                                  ;Use include file: MAIN.C
  4311                                  
  4312                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4313                                  
  4314                                  
  4315                                  getarg:  ; *** PROC ***
  4316                                  
  4317                                  ;-2   arglen1=*arglen;
  4318                                  
  4319                                  ;Function : getarg, Number of local variables: 3
  4320                                  ;   # type sign width line used address name   list of local variables
  4321                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4322                                  ;  201 var sign word     1 NULL bp-4    i
  4323                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4324 000019C2 C8060000                 ENTER  6,0
  4325 000019C6 8B1E[5600]               mov bx, [arglen]
  4326 000019CA 8A07                     mov al, [bx]
  4327 000019CC B400                     mov ah, 0
  4328 000019CE 8946FE                   mov word [bp-2], ax
  4329                                  
  4330                                  ;-3   if (arglen1==0) {
  4331                                  
  4332 000019D1 8B46FE                   mov ax, [bp-2]
  4333 000019D4 83F800                   cmp ax, 0
  4334 000019D7 0F851C00                 jne @@getarg199
  4335                                  
  4336                                  ;-4     cputs(Version1);
  4337                                  
  4338 000019DB 8D06[1000]               lea  ax, [Version1]
  4339 000019DF 50                       push ax
  4340 000019E0 E8DC03                   call cputs
  4341 000019E3 83C402                   add  sp, 2
  4342                                  
  4343                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4344                                  
  4345 000019E6 68[871B]                 push getarg_0
  4346 000019E9 E8D303                   call cputs
  4347 000019EC 83C402                   add  sp, 2
  4348                                  
  4349                                  ;-6     exitR(3);
  4350                                  
  4351 000019EF 6A03                     push 3
  4352 000019F1 E8A605                   call exitR
  4353 000019F4 83C402                   add  sp, 2
  4354                                  
  4355                                  ;-7   }
  4356                                  
  4357                                  
  4358                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4359                                  
  4360                                  @@getarg199:
  4361 000019F7 8B46FE                   mov ax, [bp-2]
  4362 000019FA 058100                   add ax, 129
  4363 000019FD 8946FC                   mov word [bp-4], ax
  4364 00001A00 66B800000000             mov eax, 0
  4365 00001A06 8B5EFC                   mov  bx, [bp-4]
  4366 00001A09 8907                     mov  [bx], ax
  4367 00001A0B FF4EFE                   dec  word [bp-2]
  4368                                  
  4369                                  ;-9   toupper(argv);
  4370                                  
  4371 00001A0E FF36[5800]               push word [argv]
  4372 00001A12 E8D803                   call toupper
  4373 00001A15 83C402                   add  sp, 2
  4374                                  
  4375                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4376                                  
  4377 00001A18 FF36[5800]               push word [argv]
  4378 00001A1C 8D06EE75                 lea  ax, [namein]
  4379 00001A20 50                       push ax
  4380 00001A21 E83704                   call strcpy
  4381 00001A24 83C404                   add  sp, 4
  4382 00001A27 68[AC1B]                 push getarg_1
  4383 00001A2A 8D06EE75                 lea  ax, [namein]
  4384 00001A2E 50                       push ax
  4385 00001A2F E8EA04                   call strcat1
  4386 00001A32 83C404                   add  sp, 4
  4387                                  
  4388                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4389                                  
  4390 00001A35 FF36[5800]               push word [argv]
  4391 00001A39 8D063176                 lea  ax, [namelst]
  4392 00001A3D 50                       push ax
  4393 00001A3E E81A04                   call strcpy
  4394 00001A41 83C404                   add  sp, 4
  4395 00001A44 68[AF1B]                 push getarg_2
  4396 00001A47 8D063176                 lea  ax, [namelst]
  4397 00001A4B 50                       push ax
  4398 00001A4C E8CD04                   call strcat1
  4399 00001A4F 83C404                   add  sp, 4
  4400                                  
  4401                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4402                                  
  4403 00001A52 FF36[5800]               push word [argv]
  4404 00001A56 8D067476                 lea  ax, [namebin]
  4405 00001A5A 50                       push ax
  4406 00001A5B E8FD03                   call strcpy
  4407 00001A5E 83C404                   add  sp, 4
  4408 00001A61 68[B41B]                 push getarg_3
  4409 00001A64 8D067476                 lea  ax, [namebin]
  4410 00001A68 50                       push ax
  4411 00001A69 E8B004                   call strcat1
  4412 00001A6C 83C404                   add  sp, 4
  4413                                  
  4414                                  ;-13 
  4415                                  
  4416                                  
  4417                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4418                                  
  4419 00001A6F 66B801000000             mov eax, 1
  4420 00001A75 A2[2400]                 mov byte [LIST], al
  4421 00001A78 66B800000000             mov eax, 0
  4422 00001A7E A3[2F00]                 mov word [DOS_ERR], ax
  4423 00001A81 66B800000000             mov eax, 0
  4424 00001A87 A3[3600]                 mov word [PC], ax
  4425 00001A8A 66B800000000             mov eax, 0
  4426 00001A90 A3[3100]                 mov word [ErrorCount], ax
  4427                                  
  4428                                  ;-15   asm_fd=openR (namein);
  4429                                  
  4430 00001A93 8D06EE75                 lea  ax, [namein]
  4431 00001A97 50                       push ax
  4432 00001A98 E8A604                   call openR
  4433 00001A9B 83C402                   add  sp, 2
  4434 00001A9E A3[2900]                 mov word [asm_fd], ax
  4435                                  
  4436                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4437                                  
  4438 00001AA1 A1[2F00]                 mov ax, [DOS_ERR]
  4439 00001AA4 08C0                     or  al, al
  4440 00001AA6 0F841C00                 je @@getarg200
  4441 00001AAA 68[B91B]                 push getarg_4
  4442 00001AAD E80F03                   call cputs
  4443 00001AB0 83C402                   add  sp, 2
  4444 00001AB3 8D06EE75                 lea  ax, [namein]
  4445 00001AB7 50                       push ax
  4446 00001AB8 E80403                   call cputs
  4447 00001ABB 83C402                   add  sp, 2
  4448 00001ABE 6A01                     push 1
  4449 00001AC0 E8D704                   call exitR
  4450 00001AC3 83C402                   add  sp, 2
  4451                                  
  4452                                  ;-17   lst_fd=creatR(namelst);
  4453                                  
  4454                                  @@getarg200:
  4455 00001AC6 8D063176                 lea  ax, [namelst]
  4456 00001ACA 50                       push ax
  4457 00001ACB E88204                   call creatR
  4458 00001ACE 83C402                   add  sp, 2
  4459 00001AD1 A3[2B00]                 mov word [lst_fd], ax
  4460                                  
  4461                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4462                                  
  4463 00001AD4 A1[2F00]                 mov ax, [DOS_ERR]
  4464 00001AD7 08C0                     or  al, al
  4465 00001AD9 0F841C00                 je @@getarg201
  4466 00001ADD 68[CF1B]                 push getarg_5
  4467 00001AE0 E8DC02                   call cputs
  4468 00001AE3 83C402                   add  sp, 2
  4469 00001AE6 8D063176                 lea  ax, [namelst]
  4470 00001AEA 50                       push ax
  4471 00001AEB E8D102                   call cputs
  4472 00001AEE 83C402                   add  sp, 2
  4473 00001AF1 6A02                     push 2
  4474 00001AF3 E8A404                   call exitR
  4475 00001AF6 83C402                   add  sp, 2
  4476                                  
  4477                                  ;-19   bin_fd=creatR(namebin);
  4478                                  
  4479                                  @@getarg201:
  4480 00001AF9 8D067476                 lea  ax, [namebin]
  4481 00001AFD 50                       push ax
  4482 00001AFE E84F04                   call creatR
  4483 00001B01 83C402                   add  sp, 2
  4484 00001B04 A3[2D00]                 mov word [bin_fd], ax
  4485                                  
  4486                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4487                                  
  4488 00001B07 A1[2F00]                 mov ax, [DOS_ERR]
  4489 00001B0A 08C0                     or  al, al
  4490 00001B0C 0F841C00                 je @@getarg202
  4491 00001B10 68[E61B]                 push getarg_6
  4492 00001B13 E8A902                   call cputs
  4493 00001B16 83C402                   add  sp, 2
  4494 00001B19 8D067476                 lea  ax, [namebin]
  4495 00001B1D 50                       push ax
  4496 00001B1E E89E02                   call cputs
  4497 00001B21 83C402                   add  sp, 2
  4498 00001B24 6A02                     push 2
  4499 00001B26 E87104                   call exitR
  4500 00001B29 83C402                   add  sp, 2
  4501                                  
  4502                                  ;-21   prs(";");prs(Version1);
  4503                                  
  4504                                  @@getarg202:
  4505 00001B2C 68[FC1B]                 push getarg_7
  4506 00001B2F E8B1FB                   call prs
  4507 00001B32 83C402                   add  sp, 2
  4508 00001B35 8D06[1000]               lea  ax, [Version1]
  4509 00001B39 50                       push ax
  4510 00001B3A E8A6FB                   call prs
  4511 00001B3D 83C402                   add  sp, 2
  4512                                  
  4513                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4514                                  
  4515 00001B40 68[FE1B]                 push getarg_8
  4516 00001B43 E89DFB                   call prs
  4517 00001B46 83C402                   add  sp, 2
  4518 00001B49 8D06EE75                 lea  ax, [namein]
  4519 00001B4D 50                       push ax
  4520 00001B4E E892FB                   call prs
  4521 00001B51 83C402                   add  sp, 2
  4522 00001B54 68[091C]                 push getarg_9
  4523 00001B57 E889FB                   call prs
  4524 00001B5A 83C402                   add  sp, 2
  4525 00001B5D 8D063176                 lea  ax, [namelst]
  4526 00001B61 50                       push ax
  4527 00001B62 E87EFB                   call prs
  4528 00001B65 83C402                   add  sp, 2
  4529                                  
  4530                                  ;-23   prs(", "); prs(namebin);
  4531                                  
  4532 00001B68 68[141C]                 push getarg_10
  4533 00001B6B E875FB                   call prs
  4534 00001B6E 83C402                   add  sp, 2
  4535 00001B71 8D067476                 lea  ax, [namebin]
  4536 00001B75 50                       push ax
  4537 00001B76 E86AFB                   call prs
  4538 00001B79 83C402                   add  sp, 2
  4539                                  
  4540                                  ;-24   prs("\n");
  4541                                  
  4542 00001B7C 68[171C]                 push getarg_11
  4543 00001B7F E861FB                   call prs
  4544 00001B82 83C402                   add  sp, 2
  4545                                  
  4546                                  ;-25 }
  4547                                  
  4548                                  
  4549                                  ;-26 int epilog() { int i; int j; char c;
  4550 00001B85 C9                       LEAVE
  4551 00001B86 C3                       ret
  4552                                  ; ENDP
  4553 00001B87 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4554 00001B90 41532E434F4D206669-
  4555 00001B99 6C656E616D65205B77-
  4556 00001BA2 2F6F202E535D203A20-
  4557 00001BAB 00                 
  4558 00001BAC 2E5300                  getarg_1 db ".S",0
  4559 00001BAF 2E4C535400              getarg_2 db ".LST",0
  4560 00001BB4 2E434F4D00              getarg_3 db ".COM",0
  4561 00001BB9 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4562 00001BC2 6C65206D697373696E-
  4563 00001BCB 673A2000           
  4564 00001BCF 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4565 00001BD8 206E6F742063726561-
  4566 00001BE1 74653A2000         
  4567 00001BE6 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4568 00001BEF 6E6F74206372656174-
  4569 00001BF8 653A2000           
  4570 00001BFC 3B00                    getarg_7 db ";",0
  4571 00001BFE 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4572 00001C07 2000               
  4573 00001C09 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4574 00001C12 2000               
  4575 00001C14 2C2000                  getarg_10 db ", ",0
  4576 00001C17 5C6E00                  getarg_11 db "\n",0
  4577                                  
  4578                                  epilog:  ; *** PROC ***
  4579                                  
  4580                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4581                                  
  4582                                  ;Function : epilog, Number of local variables: 3
  4583                                  ;   # type sign width line used address name   list of local variables
  4584                                  ;  200 var sign word    26 NULL bp-2    i
  4585                                  ;  201 var sign word    26 NULL bp-4    j
  4586                                  ;  202 var sign byte    26 NULL bp-6    c;
  4587 00001C1A C8060000                 ENTER  6,0
  4588 00001C1E 68[431D]                 push epilog_0
  4589 00001C21 E8BFFA                   call prs
  4590 00001C24 83C402                   add  sp, 2
  4591 00001C27 FF36[3100]               push word [ErrorCount]
  4592 00001C2B E8D0FB                   call printIntU
  4593 00001C2E 83C402                   add  sp, 2
  4594                                  
  4595                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4596                                  
  4597 00001C31 A1[3100]                 mov ax, [ErrorCount]
  4598 00001C34 08C0                     or  al, al
  4599 00001C36 0F840900                 je @@epilog203
  4600 00001C3A 68[531D]                 push epilog_1
  4601 00001C3D E8A3FA                   call prs
  4602 00001C40 83C402                   add  sp, 2
  4603                                  
  4604                                  ;-29   prs(", Label & Var: ");
  4605                                  
  4606                                  @@epilog203:
  4607 00001C43 68[611D]                 push epilog_2
  4608 00001C46 E89AFA                   call prs
  4609 00001C49 83C402                   add  sp, 2
  4610                                  
  4611                                  ;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4612                                  
  4613                                  
  4614                                  ;-31   i= &LabelNames;
  4615                                  
  4616                                  
  4617                                  ;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4618                                  
  4619                                  
  4620                                  ;-33   } while (i < LabelNamePtr); prs("<< \n"); */
  4621                                  
  4622                                  
  4623                                  ;-34   if (LabelMaxIx) {
  4624                                  
  4625 00001C4C A1[5000]                 mov ax, [LabelMaxIx]
  4626 00001C4F 08C0                     or  al, al
  4627 00001C51 0F846900                 je @@epilog204
  4628                                  
  4629                                  ;-35     i = 1;
  4630                                  
  4631 00001C55 66B801000000             mov eax, 1
  4632 00001C5B 8946FE                   mov word [bp-2], ax
  4633                                  
  4634                                  ;-36     LabelNamePtr= &LabelNames;
  4635                                  
  4636 00001C5E B8BC76                   mov ax, LabelNames
  4637 00001C61 A3[4E00]                 mov word [LabelNamePtr], ax
  4638                                  
  4639                                  ;-37     do {
  4640                                  
  4641                                  @@epilog205:
  4642                                  
  4643                                  ;-38       prs(LabelNamePtr); prc(' ');
  4644                                  
  4645 00001C64 FF36[4E00]               push word [LabelNamePtr]
  4646 00001C68 E878FA                   call prs
  4647 00001C6B 83C402                   add  sp, 2
  4648 00001C6E 6A20                     push 32
  4649 00001C70 E80FFA                   call prc
  4650 00001C73 83C402                   add  sp, 2
  4651                                  
  4652                                  ;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4653                                  
  4654 00001C76 8B5EFE                   mov bx, [bp-2]
  4655 00001C79 D1E3                     shl bx, 1
  4656 00001C7B 8B87A47A                 mov ax, [LabelAddr + bx]
  4657 00001C7F 8946FC                   mov word [bp-4], ax
  4658 00001C82 FF76FC                   push word [bp-4]
  4659 00001C85 E84CFB                   call printhex16
  4660 00001C88 83C402                   add  sp, 2
  4661 00001C8B 68[711D]                 push epilog_3
  4662 00001C8E E852FA                   call prs
  4663 00001C91 83C402                   add  sp, 2
  4664                                  
  4665                                  ;-40       j=strlen(LabelNamePtr);//get end of actual name
  4666                                  
  4667 00001C94 FF36[4E00]               push word [LabelNamePtr]
  4668 00001C98 E89501                   call strlen
  4669 00001C9B 83C402                   add  sp, 2
  4670 00001C9E 8946FC                   mov word [bp-4], ax
  4671                                  
  4672                                  ;-41       LabelNamePtr=LabelNamePtr+j;
  4673                                  
  4674 00001CA1 A1[4E00]                 mov ax, [LabelNamePtr]
  4675 00001CA4 0346FC                   add ax, [bp-4]
  4676 00001CA7 A3[4E00]                 mov word [LabelNamePtr], ax
  4677                                  
  4678                                  ;-42       LabelNamePtr++;
  4679                                  
  4680 00001CAA FF06[4E00]               inc  word [LabelNamePtr]
  4681                                  
  4682                                  ;-43       i++;
  4683                                  
  4684 00001CAE FF46FE                   inc  word [bp-2]
  4685                                  
  4686                                  ;-44     } while (i <= LabelMaxIx);
  4687                                  
  4688 00001CB1 8B46FE                   mov ax, [bp-2]
  4689 00001CB4 3B06[5000]               cmp ax, [LabelMaxIx]
  4690 00001CB8 0F8F0200                 jg  @@epilog206
  4691 00001CBC EBA6                     jmp @@epilog205
  4692                                  @@epilog206:
  4693                                  
  4694                                  ;-45   }
  4695                                  
  4696                                  
  4697                                  ;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4698                                  
  4699                                  @@epilog204:
  4700 00001CBE 68[751D]                 push epilog_4
  4701 00001CC1 E81FFA                   call prs
  4702 00001CC4 83C402                   add  sp, 2
  4703 00001CC7 FF36[5400]               push word [BinLen]
  4704 00001CCB E830FB                   call printIntU
  4705 00001CCE 83C402                   add  sp, 2
  4706 00001CD1 68[821D]                 push epilog_5
  4707 00001CD4 E80CFA                   call prs
  4708 00001CD7 83C402                   add  sp, 2
  4709                                  
  4710                                  ;-47   i=0;
  4711                                  
  4712 00001CDA 66B800000000             mov eax, 0
  4713 00001CE0 8946FE                   mov word [bp-2], ax
  4714                                  
  4715                                  ;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4716                                  
  4717                                  @@epilog207:
  4718 00001CE3 6A20                     push 32
  4719 00001CE5 E89AF9                   call prc
  4720 00001CE8 83C402                   add  sp, 2
  4721 00001CEB 8B5EFE                   mov bx, [bp-2]
  4722 00001CEE 8A876C7B                 mov al, [FileBin + bx]
  4723 00001CF2 8946FC                   mov word [bp-4], ax
  4724 00001CF5 FF76FC                   push word [bp-4]
  4725 00001CF8 E88BFA                   call printhex8a
  4726 00001CFB 83C402                   add  sp, 2
  4727 00001CFE FF46FE                   inc  word [bp-2]
  4728                                  
  4729                                  ;-49   } while (i < BinLen);
  4730                                  
  4731 00001D01 8B46FE                   mov ax, [bp-2]
  4732 00001D04 3B06[5400]               cmp ax, [BinLen]
  4733 00001D08 0F8D0200                 jge @@epilog208
  4734 00001D0C EBD5                     jmp @@epilog207
  4735                                  @@epilog208:
  4736                                  
  4737                                  ;-50   i=0;
  4738                                  
  4739 00001D0E 66B800000000             mov eax, 0
  4740 00001D14 8946FE                   mov word [bp-2], ax
  4741                                  
  4742                                  ;-51   do {
  4743                                  
  4744                                  @@epilog209:
  4745                                  
  4746                                  ;-52     c = FileBin[i];
  4747                                  
  4748 00001D17 8B5EFE                   mov bx, [bp-2]
  4749 00001D1A 8A876C7B                 mov al, [FileBin + bx]
  4750 00001D1E 8846FA                   mov byte [bp-6], al
  4751                                  
  4752                                  ;-53     fputcR(c, bin_fd);
  4753                                  
  4754 00001D21 FF36[2D00]               push word [bin_fd]
  4755 00001D25 8A46FA                   mov al, byte [bp-6]
  4756 00001D28 B400                     mov ah, 0
  4757 00001D2A 50                       push ax
  4758 00001D2B E84902                   call fputcR
  4759 00001D2E 83C404                   add  sp, 4
  4760                                  
  4761                                  ;-54     i++;
  4762                                  
  4763 00001D31 FF46FE                   inc  word [bp-2]
  4764                                  
  4765                                  ;-55   } while (i < BinLen);
  4766                                  
  4767 00001D34 8B46FE                   mov ax, [bp-2]
  4768 00001D37 3B06[5400]               cmp ax, [BinLen]
  4769 00001D3B 0F8D0200                 jge @@epilog210
  4770 00001D3F EBD6                     jmp @@epilog209
  4771                                  @@epilog210:
  4772                                  
  4773                                  ;-56 }
  4774                                  
  4775                                  
  4776                                  ;-57 int end1(int n) {
  4777 00001D41 C9                       LEAVE
  4778 00001D42 C3                       ret
  4779                                  ; ENDP
  4780 00001D43 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4781 00001D4C 726F72733A2000     
  4782 00001D53 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4783 00001D5C 2A2A2A2000         
  4784 00001D61 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4785 00001D6A 205661723A2000     
  4786 00001D71 2C202000                epilog_3 db ",  ",0
  4787 00001D75 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4788 00001D7E 6C652000           
  4789 00001D82 2062797465733A00        epilog_5 db " bytes:",0
  4790                                  
  4791                                  end1:  ; *** PROC ***
  4792                                  
  4793                                  ;-58   fcloseR(asm_fd);
  4794                                  
  4795                                  ;Function : end1, Number of local variables: 1
  4796                                  ;   # type sign width line used address name   list of local variables
  4797                                  ;  200 var sign word    57 NULL bp+4    n;
  4798 00001D8A C8000000                 ENTER  0,0
  4799 00001D8E FF36[2900]               push word [asm_fd]
  4800 00001D92 E8F701                   call fcloseR
  4801 00001D95 83C402                   add  sp, 2
  4802                                  
  4803                                  ;-59   fcloseR(lst_fd);
  4804                                  
  4805 00001D98 FF36[2B00]               push word [lst_fd]
  4806 00001D9C E8ED01                   call fcloseR
  4807 00001D9F 83C402                   add  sp, 2
  4808                                  
  4809                                  ;-60   fcloseR(bin_fd);
  4810                                  
  4811 00001DA2 FF36[2D00]               push word [bin_fd]
  4812 00001DA6 E8E301                   call fcloseR
  4813 00001DA9 83C402                   add  sp, 2
  4814                                  
  4815                                  ;-61   exitR(n);
  4816                                  
  4817 00001DAC FF7604                   push word [bp+4]
  4818 00001DAF E8E801                   call exitR
  4819 00001DB2 83C402                   add  sp, 2
  4820                                  
  4821                                  ;-62 }
  4822 00001DB5 C9                       LEAVE
  4823 00001DB6 C3                       ret
  4824                                  ; ENDP
  4825                                  ;Back to main program: AS.C
  4826                                   
  4827                                  ; missing functions: 
  4828                                  ; digit
  4829                                  ; strcpy
  4830                                  ; eqstr
  4831                                  ; strlen
  4832                                  ; eqstr
  4833                                  ; eqstr
  4834                                  ; eqstr
  4835                                  ; eqstr
  4836                                  ; readRL
  4837                                  ; readRL
  4838                                  ; digit
  4839                                  ; digit
  4840                                  ; strcpy
  4841                                  ; toupper
  4842                                  ; strlen
  4843                                  ; strlen
  4844                                  ; eqstr
  4845                                  ; eqstr
  4846                                  ; eqstr
  4847                                  ; eqstr
  4848                                  ; eqstr
  4849                                  ; eqstr
  4850                                  ; eqstr
  4851                                  ; eqstr
  4852                                  ; eqstr
  4853                                  ; eqstr
  4854                                  ; eqstr
  4855                                  ; eqstr
  4856                                  ; eqstr
  4857                                  ; eqstr
  4858                                  ; eqstr
  4859                                  ; eqstr
  4860                                  ; eqstr
  4861                                  ; eqstr
  4862                                  ; eqstr
  4863                                  ; eqstr
  4864                                  ; eqstr
  4865                                  ; eqstr
  4866                                  ; eqstr
  4867                                  ; eqstr
  4868                                  ; eqstr
  4869                                  ; eqstr
  4870                                  ; eqstr
  4871                                  ; eqstr
  4872                                  ; eqstr
  4873                                  ; eqstr
  4874                                  ; writetty
  4875                                  ; writetty
  4876                                  ; fputcR
  4877                                  ; cputs
  4878                                  ; cputs
  4879                                  ; exitR
  4880                                  ; toupper
  4881                                  ; strcpy
  4882                                  ; strcat1
  4883                                  ; strcpy
  4884                                  ; strcat1
  4885                                  ; strcpy
  4886                                  ; strcat1
  4887                                  ; openR
  4888                                  ; cputs
  4889                                  ; cputs
  4890                                  ; exitR
  4891                                  ; creatR
  4892                                  ; cputs
  4893                                  ; cputs
  4894                                  ; exitR
  4895                                  ; creatR
  4896                                  ; cputs
  4897                                  ; cputs
  4898                                  ; exitR
  4899                                  ; strlen
  4900                                  ; fputcR
  4901                                  ; fcloseR
  4902                                  ; fcloseR
  4903                                  ; fcloseR
  4904                                  ; exitR
  4905                                  ; Number of unresolved CALLs :   77
  4906                                  ;use archive file: AR.C
  4907                                  
  4908                                  ;-183 // AR.C Archive
  4909                                  
  4910                                  ;Number of CALLs:    2 : writetty
  4911                                  
  4912                                  writetty:  ; *** PROC ***
  4913 00001DB7 B40E                     mov  ah, 14
  4914 00001DB9 BB0000                   mov  bx, 0
  4915 00001DBC CD10                     int  16
  4916                                  
  4917                                  ;-184 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  4918                                  
  4919 00001DBE C3                       ret
  4920                                  ; ENDP
  4921                                  ;Number of CALLs:    8 : cputs
  4922                                  
  4923                                  cputs:  ; *** PROC ***
  4924                                  ;Function : cputs, Number of local variables: 2
  4925                                  ;   # type sign width line used address name   list of local variables
  4926                                  ;  200 ptr sign byte   184 NULL bp+4    s
  4927                                  ;  201 var sign byte   184 NULL bp-2    c;
  4928 00001DBF C8020000                 ENTER  2,0
  4929                                  @@cputs211:
  4930 00001DC3 8B5E04                   mov bx, [bp+4]
  4931 00001DC6 8A07                     mov al, [bx]
  4932 00001DC8 B400                     mov ah, 0
  4933 00001DCA 08C0                     or  al, al
  4934 00001DCC 0F841B00                 je @@cputs212
  4935 00001DD0 8B5E04                   mov bx, [bp+4]
  4936 00001DD3 8A07                     mov al, [bx]
  4937 00001DD5 B400                     mov ah, 0
  4938 00001DD7 8846FE                   mov byte [bp-2], al
  4939 00001DDA 8A46FE                   mov al, byte [bp-2]
  4940 00001DDD B400                     mov ah, 0
  4941 00001DDF 50                       push ax
  4942 00001DE0 E8C401                   call putch
  4943 00001DE3 83C402                   add  sp, 2
  4944 00001DE6 FF4604                   inc  word [bp+4]
  4945 00001DE9 EBD8                     jmp @@cputs211
  4946                                  @@cputs212:
  4947                                  
  4948                                  ;-185 int mkneg(int n) { n; __asm {neg ax} }
  4949 00001DEB C9                       LEAVE
  4950 00001DEC C3                       ret
  4951                                  ; ENDP
  4952                                  ;Number of CALLs:    2 : toupper
  4953                                  
  4954                                  toupper:  ; *** PROC ***
  4955                                  ;Function : toupper, Number of local variables: 1
  4956                                  ;   # type sign width line used address name   list of local variables
  4957                                  ;  200 ptr sign byte   185 NULL bp+4    s;
  4958 00001DED C8000000                 ENTER  0,0
  4959                                  @@toupper213:
  4960 00001DF1 8B5E04                   mov bx, [bp+4]
  4961 00001DF4 8A07                     mov al, [bx]
  4962 00001DF6 B400                     mov ah, 0
  4963 00001DF8 08C0                     or  al, al
  4964 00001DFA 0F843000                 je @@toupper214
  4965 00001DFE 8B5E04                   mov bx, [bp+4]
  4966 00001E01 8A07                     mov al, [bx]
  4967 00001E03 B400                     mov ah, 0
  4968 00001E05 83F861                   cmp ax, 97 ;unsigned : 1
  4969 00001E08 0F8C1D00                 jl  @@toupper215
  4970 00001E0C 8B5E04                   mov bx, [bp+4]
  4971 00001E0F 8A07                     mov al, [bx]
  4972 00001E11 B400                     mov ah, 0
  4973 00001E13 83F87A                   cmp ax, 122
  4974 00001E16 0F8F0F00                 jg  @@toupper216
  4975 00001E1A 8B5E04                   mov bx, [bp+4]
  4976 00001E1D 8A07                     mov al, [bx]
  4977 00001E1F B400                     mov ah, 0
  4978 00001E21 83E820                   sub ax, 32
  4979 00001E24 8B5E04                   mov  bx, [bp+4]
  4980 00001E27 8807                     mov  [bx], al
  4981                                  @@toupper216:
  4982                                  @@toupper215:
  4983 00001E29 FF4604                   inc  word [bp+4]
  4984 00001E2C EBC3                     jmp @@toupper213
  4985                                  @@toupper214:
  4986                                  
  4987                                  ;-186 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  4988                                  
  4989                                  
  4990                                  ;-187 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  4991 00001E2E C9                       LEAVE
  4992 00001E2F C3                       ret
  4993                                  ; ENDP
  4994                                  ;Number of CALLs:    4 : strlen
  4995                                  
  4996                                  strlen:  ; *** PROC ***
  4997                                  ;Function : strlen, Number of local variables: 2
  4998                                  ;   # type sign width line used address name   list of local variables
  4999                                  ;  200 ptr sign byte   187 NULL bp+4    s
  5000                                  ;  201 var sign word   187 NULL bp-2    c;
  5001 00001E30 C8020000                 ENTER  2,0
  5002 00001E34 66B800000000             mov eax, 0
  5003 00001E3A 8946FE                   mov word [bp-2], ax
  5004                                  @@strlen217:
  5005 00001E3D 8B5E04                   mov bx, [bp+4]
  5006 00001E40 8A07                     mov al, [bx]
  5007 00001E42 B400                     mov ah, 0
  5008 00001E44 83F800                   cmp ax, 0
  5009 00001E47 0F840800                 je  @@strlen218
  5010 00001E4B FF4604                   inc  word [bp+4]
  5011 00001E4E FF46FE                   inc  word [bp-2]
  5012 00001E51 EBEA                     jmp @@strlen217
  5013                                  @@strlen218:
  5014 00001E53 8B46FE                   mov ax, [bp-2]
  5015 00001E56 E90000                   jmp @@retn
  5016                                  
  5017                                  ;-188 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5018                                  
  5019 00001E59 C9                      @@retn: LEAVE
  5020 00001E5A C3                       ret
  5021                                  ; ENDP
  5022                                  ;Number of CALLs:    5 : strcpy
  5023                                  
  5024                                  strcpy:  ; *** PROC ***
  5025                                  ;Function : strcpy, Number of local variables: 2
  5026                                  ;   # type sign width line used address name   list of local variables
  5027                                  ;  200 ptr sign byte   188 NULL bp+4    s
  5028                                  ;  201 ptr sign byte   188 NULL bp+6    t;
  5029 00001E5B C8000000                 ENTER  0,0
  5030                                  @@strcpy219:
  5031 00001E5F 8B5E06                   mov bx, [bp+6]
  5032 00001E62 8A07                     mov al, [bx]
  5033 00001E64 B400                     mov ah, 0
  5034 00001E66 8B5E04                   mov  bx, [bp+4]
  5035 00001E69 8807                     mov  [bx], al
  5036 00001E6B FF4604                   inc  word [bp+4]
  5037 00001E6E FF4606                   inc  word [bp+6]
  5038                                  
  5039                                  ;-189   while (*t!=0); *s=0; return s; }
  5040                                  
  5041 00001E71 8B5E06                   mov bx, [bp+6]
  5042 00001E74 8A07                     mov al, [bx]
  5043 00001E76 B400                     mov ah, 0
  5044 00001E78 83F800                   cmp ax, 0
  5045 00001E7B 0F840200                 je  @@strcpy220
  5046 00001E7F EBDE                     jmp @@strcpy219
  5047                                  @@strcpy220:
  5048 00001E81 66B800000000             mov eax, 0
  5049 00001E87 8B5E04                   mov  bx, [bp+4]
  5050 00001E8A 8807                     mov  [bx], al
  5051 00001E8C 8B4604                   mov ax, [bp+4]
  5052 00001E8F E90000                   jmp @@retn
  5053                                  
  5054                                  ;-190 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5055                                  
  5056 00001E92 C9                      @@retn: LEAVE
  5057 00001E93 C3                       ret
  5058                                  ; ENDP
  5059                                  ;Number of CALLs:    3 : digit
  5060                                  
  5061                                  digit:  ; *** PROC ***
  5062                                  ;Function : digit, Number of local variables: 1
  5063                                  ;   # type sign width line used address name   list of local variables
  5064                                  ;  200 var sign byte   190 NULL bp+4    c;
  5065 00001E94 C8000000                 ENTER  0,0
  5066 00001E98 8A4604                   mov al, [bp+4]
  5067 00001E9B 3C30                     cmp al, 48
  5068 00001E9D 0F8D0900                 jge @@digit221
  5069 00001EA1 66B800000000             mov eax, 0
  5070 00001EA7 E91B00                   jmp @@retn
  5071                                  @@digit221:
  5072 00001EAA 8A4604                   mov al, [bp+4]
  5073 00001EAD 3C39                     cmp al, 57
  5074 00001EAF 0F8E0900                 jle @@digit222
  5075 00001EB3 66B800000000             mov eax, 0
  5076 00001EB9 E90900                   jmp @@retn
  5077                                  @@digit222:
  5078 00001EBC 66B801000000             mov eax, 1
  5079 00001EC2 E90000                   jmp @@retn
  5080                                  
  5081                                  ;-191 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5082                                  
  5083 00001EC5 C9                      @@retn: LEAVE
  5084 00001EC6 C3                       ret
  5085                                  ; ENDP
  5086                                  ;Number of CALLs:   35 : eqstr
  5087                                  
  5088                                  eqstr:  ; *** PROC ***
  5089                                  ;Function : eqstr, Number of local variables: 2
  5090                                  ;   # type sign width line used address name   list of local variables
  5091                                  ;  200 ptr sign byte   191 NULL bp+4    p
  5092                                  ;  201 ptr sign byte   191 NULL bp+6    q;
  5093 00001EC7 C8000000                 ENTER  0,0
  5094                                  @@eqstr223:
  5095 00001ECB 8B5E04                   mov bx, [bp+4]
  5096 00001ECE 8A07                     mov al, [bx]
  5097 00001ED0 B400                     mov ah, 0
  5098 00001ED2 08C0                     or  al, al
  5099 00001ED4 0F842300                 je @@eqstr224
  5100                                  
  5101                                  ;-192     if (*p != *q) return 0; p++; q++; }
  5102                                  
  5103 00001ED8 8B5E04                   mov bx, [bp+4]
  5104 00001EDB 8A07                     mov al, [bx]
  5105 00001EDD B400                     mov ah, 0
  5106 00001EDF 8B5E06                   mov bx, [bp+6]
  5107 00001EE2 3A07                     cmp al, [bx]
  5108 00001EE4 B400                     mov ah, 0
  5109 00001EE6 0F840900                 je  @@eqstr225
  5110 00001EEA 66B800000000             mov eax, 0
  5111 00001EF0 E92700                   jmp @@retn
  5112                                  @@eqstr225:
  5113 00001EF3 FF4604                   inc  word [bp+4]
  5114 00001EF6 FF4606                   inc  word [bp+6]
  5115                                  
  5116                                  ;-193     if(*q) return 0; return 1; }
  5117                                  
  5118 00001EF9 EBD0                     jmp @@eqstr223
  5119                                  @@eqstr224:
  5120 00001EFB 8B5E06                   mov bx, [bp+6]
  5121 00001EFE 8A07                     mov al, [bx]
  5122 00001F00 B400                     mov ah, 0
  5123 00001F02 08C0                     or  al, al
  5124 00001F04 0F840900                 je @@eqstr226
  5125 00001F08 66B800000000             mov eax, 0
  5126 00001F0E E90900                   jmp @@retn
  5127                                  @@eqstr226:
  5128 00001F11 66B801000000             mov eax, 1
  5129 00001F17 E90000                   jmp @@retn
  5130                                  
  5131                                  ;-194 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5132                                  
  5133 00001F1A C9                      @@retn: LEAVE
  5134 00001F1B C3                       ret
  5135                                  ; ENDP
  5136                                  ;Number of CALLs:    3 : strcat1
  5137                                  
  5138                                  strcat1:  ; *** PROC ***
  5139                                  ;Function : strcat1, Number of local variables: 2
  5140                                  ;   # type sign width line used address name   list of local variables
  5141                                  ;  200 ptr sign byte   194 NULL bp+4    s
  5142                                  ;  201 ptr sign byte   194 NULL bp+6    t;
  5143 00001F1C C8000000                 ENTER  0,0
  5144                                  @@strcat1227:
  5145 00001F20 8B5E04                   mov bx, [bp+4]
  5146 00001F23 8A07                     mov al, [bx]
  5147 00001F25 B400                     mov ah, 0
  5148 00001F27 83F800                   cmp ax, 0
  5149 00001F2A 0F840500                 je  @@strcat1228
  5150 00001F2E FF4604                   inc  word [bp+4]
  5151 00001F31 EBED                     jmp @@strcat1227
  5152                                  @@strcat1228:
  5153 00001F33 FF7606                   push word [bp+6]
  5154 00001F36 FF7604                   push word [bp+4]
  5155 00001F39 E81FFF                   call strcpy
  5156 00001F3C 83C404                   add  sp, 4
  5157                                  
  5158                                  ;-195 int basename(char *s) { char *p; p=0;
  5159 00001F3F C9                       LEAVE
  5160 00001F40 C3                       ret
  5161                                  ; ENDP
  5162                                  ;Number of CALLs:    1 : openR
  5163                                  
  5164                                  openR:  ; *** PROC ***
  5165                                  ;Function : openR, Number of local variables: 1
  5166                                  ;   # type sign width line used address name   list of local variables
  5167                                  ;  200 ptr sign byte   195 NULL bp+4    s;
  5168 00001F41 C8000000                 ENTER  0,0
  5169 00001F45 8B5604                   mov  dx, [bp+4]
  5170 00001F48 B8023D                   mov  ax, 15618
  5171 00001F4B E87200                   call DosInt
  5172                                  
  5173                                  ;-196 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5174 00001F4E C9                       LEAVE
  5175 00001F4F C3                       ret
  5176                                  ; ENDP
  5177                                  ;Number of CALLs:    2 : creatR
  5178                                  
  5179                                  creatR:  ; *** PROC ***
  5180                                  ;Function : creatR, Number of local variables: 1
  5181                                  ;   # type sign width line used address name   list of local variables
  5182                                  ;  200 ptr sign byte   196 NULL bp+4    s;
  5183 00001F50 C8000000                 ENTER  0,0
  5184 00001F54 8B5604                   mov  dx, [bp+4]
  5185 00001F57 B90000                   mov  cx, 0
  5186 00001F5A B8003C                   mov  ax, 15360
  5187 00001F5D E86000                   call DosInt
  5188                                  
  5189                                  ;-197 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5190 00001F60 C9                       LEAVE
  5191 00001F61 C3                       ret
  5192                                  ; ENDP
  5193                                  ;Number of CALLs:    2 : readRL
  5194                                  
  5195                                  readRL:  ; *** PROC ***
  5196                                  ;Function : readRL, Number of local variables: 3
  5197                                  ;   # type sign width line used address name   list of local variables
  5198                                  ;  200 ptr sign byte   197 NULL bp+4    s
  5199                                  ;  201 var sign word   197 NULL bp+6    fd
  5200                                  ;  202 var sign word   197 NULL bp+8    len;
  5201 00001F62 C8000000                 ENTER  0,0
  5202 00001F66 8B5604                   mov  dx, [bp+4]
  5203 00001F69 8B4E08                   mov  cx, [bp+8]
  5204 00001F6C 8B5E06                   mov  bx, [bp+6]
  5205 00001F6F B8003F                   mov  ax, 16128
  5206 00001F72 E84B00                   call DosInt
  5207                                  
  5208                                  ;-198 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5209 00001F75 C9                       LEAVE
  5210 00001F76 C3                       ret
  5211                                  ; ENDP
  5212                                  ;Number of CALLs:    2 : fputcR
  5213                                  
  5214                                  fputcR:  ; *** PROC ***
  5215                                  ;Function : fputcR, Number of local variables: 2
  5216                                  ;   # type sign width line used address name   list of local variables
  5217                                  ;  200 ptr sign byte   198 NULL bp+4    n
  5218                                  ;  201 var sign word   198 NULL bp+6    fd;
  5219 00001F77 C8000000                 ENTER  0,0
  5220 00001F7B 8D5604                  lea dx, [bp+4]
  5221                                  
  5222                                  ;-199   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5223                                  
  5224 00001F7E B90100                   mov  cx, 1
  5225 00001F81 8B5E06                   mov  bx, [bp+6]
  5226 00001F84 B80040                   mov  ax, 16384
  5227 00001F87 E83600                   call DosInt
  5228                                  
  5229                                  ;-200 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5230 00001F8A C9                       LEAVE
  5231 00001F8B C3                       ret
  5232                                  ; ENDP
  5233                                  ;Number of CALLs:    3 : fcloseR
  5234                                  
  5235                                  fcloseR:  ; *** PROC ***
  5236                                  ;Function : fcloseR, Number of local variables: 1
  5237                                  ;   # type sign width line used address name   list of local variables
  5238                                  ;  200 var sign word   200 NULL bp+4    fd;
  5239 00001F8C C8000000                 ENTER  0,0
  5240 00001F90 8B5E04                   mov  bx, [bp+4]
  5241 00001F93 B8003E                   mov  ax, 15872
  5242 00001F96 CD21                     int  33
  5243                                  
  5244                                  ;-201 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5245 00001F98 C9                       LEAVE
  5246 00001F99 C3                       ret
  5247                                  ; ENDP
  5248                                  ;Number of CALLs:    5 : exitR
  5249                                  
  5250                                  exitR:  ; *** PROC ***
  5251                                  ;Function : exitR, Number of local variables: 1
  5252                                  ;   # type sign width line used address name   list of local variables
  5253                                  ;  200 var sign byte   201 NULL bp+4    c;
  5254 00001F9A C8000000                 ENTER  0,0
  5255 00001F9E B44C                     mov  ah, 76
  5256 00001FA0 8A4604                   mov  al, [bp+4]
  5257 00001FA3 CD21                     int  33
  5258                                  
  5259                                  ;-202 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5260 00001FA5 C9                       LEAVE
  5261 00001FA6 C3                       ret
  5262                                  ; ENDP
  5263                                  ;End of archive file. 
  5264                                   
  5265                                  ; missing functions: 
  5266                                  ; putch
  5267                                  ; DosInt
  5268                                  ; DosInt
  5269                                  ; DosInt
  5270                                  ; DosInt
  5271                                  ; Number of unresolved CALLs :    5
  5272                                  ;use archive file: AR.C
  5273                                  
  5274                                  ;-203 // AR.C Archive
  5275                                  
  5276                                  ;Number of CALLs:    1 : putch
  5277                                  
  5278                                  putch:  ; *** PROC ***
  5279                                  ;Function : putch, Number of local variables: 1
  5280                                  ;   # type sign width line used address name   list of local variables
  5281                                  ;  200 var sign byte   203 NULL bp+4    c;
  5282 00001FA7 C8000000                 ENTER  0,0
  5283 00001FAB 807E040A                cmp byte [bp+4], 10
  5284 00001FAF 0F850500                 jne @@putch229
  5285 00001FB3 B00D                     mov  al, 13
  5286 00001FB5 E8FFFD                   call writetty
  5287                                  @@putch229:
  5288 00001FB8 8A4604                   mov  al, [bp+4]
  5289 00001FBB E8F9FD                   call writetty
  5290                                  
  5291                                  ;-204 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5292 00001FBE C9                       LEAVE
  5293 00001FBF C3                       ret
  5294                                  ; ENDP
  5295                                  ;Number of CALLs:    4 : DosInt
  5296                                  
  5297                                  DosInt:  ; *** PROC ***
  5298 00001FC0 CD21                     int  33
  5299 00001FC2 7304                     jae short @@DosInt230
  5300 00001FC4 FF06[2F00]               inc  word [DOS_ERR]
  5301                                  @@DosInt230:
  5302                                  
  5303                                  ;-205 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5304                                  
  5305 00001FC8 C3                       ret
  5306                                  ; ENDP
  5307                                  ;End of archive file. 
  5308                                   
  5309                                  ; missing functions:  All FUNCTIONs in place
  5310 00001FC9 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5311 00001FCC 58                      pop ax
  5312 00001FCD C3                      ret
  5313                                   
  5314                                  ;   # type sign width line used  address name   list of global variables
  5315                                  
  5316                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5317                                  ;    2 var sign byte     1    3        0 LIST
  5318                                  ;    3 arr sign byte     2    7    30000 Symbol[31]
  5319                                  ;    4 arr sign byte     3   36    30031 SymbolUpper[31]
  5320                                  ;    5 var unsg word     4   12        0 SymbolInt
  5321                                  ;    6 arr sign byte     5    3    30062 InputBuf[128]
  5322                                  ;    7 ptr unsg byte     6   23        0 InputPtr
  5323                                  ;    8 arr sign byte     7    5    30190 namein[67]
  5324                                  ;    9 arr sign byte     8    5    30257 namelst[67]
  5325                                  ;   10 arr sign byte     9    5    30324 namebin[67]
  5326                                  ;   11 var sign word    10    4        0 asm_fd
  5327                                  ;   12 var sign word    11    3        0 lst_fd
  5328                                  ;   13 var sign word    12    3        0 bin_fd
  5329                                  ;   14 var sign word    13    6        0 DOS_ERR
  5330                                  ;   15 var sign word    14    4        0 ErrorCount
  5331                                  ;   16 var sign word    15    4        0 DOS_NoBytes
  5332                                  ;   17 var sign byte    16    4        0 DOS_ByteRead
  5333                                  ;   18 var unsg word    18    5        0 PC
  5334                                  ;   19 var unsg word    19    2        0 PCStart
  5335                                  ;   20 var sign byte    20    3        0 isLabel
  5336                                  ;   21 def unsg byte    21    -        0 DIGIT=1
  5337                                  ;   22 def unsg byte    22    -        0 LETTERE=2
  5338                                  ;   23 def unsg byte    23    -        0 ALNUME=3
  5339                                  ;   24 def unsg byte    24    -        0 NOALNUME=4
  5340                                  ;   25 var sign byte    25   20        0 TokeType
  5341                                  ;   26 def unsg byte    26    -        0 BYTE=1
  5342                                  ;   27 def unsg byte    27    -        0 WORD=2
  5343                                  ;   28 def unsg byte    28    -        0 DWORD=3
  5344                                  ;   29 def unsg byte    29    -        0 SEGREG=4
  5345                                  ;   30 def unsg byte    31    -        0 IMM=1
  5346                                  ;   31 def unsg byte    32    -        0 REG=2
  5347                                  ;   32 def unsg byte    33    -        0 DIR=3
  5348                                  ;   33 def unsg byte    34    -        0 IND=4
  5349                                  ;   34 var sign byte    35   13        0 Op1
  5350                                  ;   35 var sign byte    36   12        0 CodeType
  5351                                  ;   36 var sign byte    38   17        0 RegType
  5352                                  ;   37 var sign byte    39   10        0 RegNo
  5353                                  ;   38 var sign byte    40   10        0 OpSize
  5354                                  ;   39 var sign byte    42 NULL        0 NumOprns
  5355                                  ;   40 var sign byte    43    5        0 wflag
  5356                                  ;   41 var sign byte    44 NULL        0 dflag
  5357                                  ;   42 var sign byte    46    4        0 reg
  5358                                  ;   43 var sign word    47   13        0 disp
  5359                                  ;   44 var sign word    48    2        0 imme
  5360                                  ;   45 def unsg byte    50    -        0 OPMAXLEN=5
  5361                                  ;   46 arr sign byte    51    2    30391 OpPos[5]
  5362                                  ;   47 var sign word    52    6        0 OpPrintIndex
  5363                                  ;   48 ptr sign byte    53   16        0 OpCodePtr
  5364                                  ;   49 var sign byte    54    2        0 PrReloc
  5365                                  ;   50 arr sign byte    56    3    30396 LabelNames[1000]
  5366                                  ;   51 ptr sign byte    57   10        0 LabelNamePtr
  5367                                  ;   52 arr unsg word    58    4    31396 LabelAddr[100]
  5368                                  ;   53 var sign word    59    5        0 LabelMaxIx
  5369                                  ;   54 var sign word    60    4        0 LabelIx
  5370                                  ;   55 arr sign byte    62    3    31596 FileBin[2000]
  5371                                  ;   56 var unsg word    63    5        0 BinLen
  5372                                  ;   57 ptr sign byte    65    1        0 arglen
  5373                                  ;   58 ptr sign byte    66    4        0 argv
  5374                                  ;   59 var sign byte     1    1        0 I_START
  5375                                  ;   60 arr sign byte     5 NULL        0 I_PUSHA[9]
  5376                                  ;   61 arr sign byte     6 NULL        0 I_POPA[8]
  5377                                  ;   62 arr sign byte     7 NULL        0 I_NOP[7]
  5378                                  ;   63 arr sign byte     8 NULL        0 I_CBW[7]
  5379                                  ;   64 arr sign byte     9 NULL        0 I_CWDE[8]
  5380                                  ;   65 arr sign byte    10 NULL        0 I_CWD[7]
  5381                                  ;   66 arr sign byte    11 NULL        0 I_CDQ[7]
  5382                                  ;   67 arr sign byte    12 NULL        0 I_WAIT[8]
  5383                                  ;   68 arr sign byte    13 NULL        0 I_PUSHF[9]
  5384                                  ;   69 arr sign byte    14 NULL        0 I_POPF[8]
  5385                                  ;   70 arr sign byte    15 NULL        0 I_SAHF[8]
  5386                                  ;   71 arr sign byte    16 NULL        0 I_LAHF[8]
  5387                                  ;   72 arr sign byte    17 NULL        0 I_MOVSB[9]
  5388                                  ;   73 arr sign byte    18 NULL        0 I_MOVSW[9]
  5389                                  ;   74 arr sign byte    19 NULL        0 I_CMPSB[9]
  5390                                  ;   75 arr sign byte    20 NULL        0 I_CMPSW[9]
  5391                                  ;   76 arr sign byte    21 NULL        0 I_STOSB[9]
  5392                                  ;   77 arr sign byte    22 NULL        0 I_STOSW[9]
  5393                                  ;   78 arr sign byte    23 NULL        0 I_LODSB[9]
  5394                                  ;   79 arr sign byte    24 NULL        0 I_LODSW[9]
  5395                                  ;   80 arr sign byte    25 NULL        0 I_SCASB[9]
  5396                                  ;   81 arr sign byte    26 NULL        0 I_SCASW[9]
  5397                                  ;   82 arr sign byte    27 NULL        0 I_LEAVE[9]
  5398                                  ;   83 arr sign byte    28 NULL        0 I_IRET[8]
  5399                                  ;   84 arr sign byte    29 NULL        0 I_XLAT[8]
  5400                                  ;   85 arr sign byte    30 NULL        0 I_LOCK[8]
  5401                                  ;   86 arr sign byte    31 NULL        0 I_REPNE[9]
  5402                                  ;   87 arr sign byte    32 NULL        0 I_REPNZ[9]
  5403                                  ;   88 arr sign byte    33 NULL        0 I_REPE[8]
  5404                                  ;   89 arr sign byte    34 NULL        0 I_REPZ[8]
  5405                                  ;   90 arr sign byte    35 NULL        0 I_HLT[7]
  5406                                  ;   91 arr sign byte    36 NULL        0 I_CLC[7]
  5407                                  ;   92 arr sign byte    37 NULL        0 I_STC[7]
  5408                                  ;   93 arr sign byte    38 NULL        0 I_CLI[7]
  5409                                  ;   94 arr sign byte    39 NULL        0 I_STI[7]
  5410                                  ;   95 arr sign byte    40 NULL        0 I_CLD[7]
  5411                                  ;   96 arr sign byte    41 NULL        0 I_STD[7]
  5412                                  ;   97 arr sign byte    43 NULL        0 I_INC[9]
  5413                                  ;   98 arr sign byte    44 NULL        0 I_DEC[9]
  5414                                  ;   99 arr sign byte    46 NULL        0 I_NOT[8]
  5415                                  ;  100 arr sign byte    47 NULL        0 I_NEG[8]
  5416                                  ;  101 arr sign byte    48 NULL        0 I_MUL[8]
  5417                                  ;  102 arr sign byte    49 NULL        0 I_IMUL[9]
  5418                                  ;  103 arr sign byte    50 NULL        0 I_DIV[8]
  5419                                  ;  104 arr sign byte    51 NULL        0 I_IDIV[9]
  5420                                  ;  105 arr sign byte    53 NULL        0 I_LES[7]
  5421                                  ;  106 arr sign byte    54 NULL        0 I_LDS[7]
  5422                                  ;  107 arr sign byte    55 NULL        0 I_LEA[7]
  5423                                  ;  108 arr sign byte    57 NULL        0 I_ADD[7]
  5424                                  ;  109 arr sign byte    58 NULL        0 I_OR[6]
  5425                                  ;  110 arr sign byte    59 NULL        0 I_ADC[7]
  5426                                  ;  111 arr sign byte    60 NULL        0 I_SBB[7]
  5427                                  ;  112 arr sign byte    61 NULL        0 I_AND[7]
  5428                                  ;  113 arr sign byte    62 NULL        0 I_SUB[7]
  5429                                  ;  114 arr sign byte    63 NULL        0 I_XOR[7]
  5430                                  ;  115 arr sign byte    64 NULL        0 I_CMP[7]
  5431                                  ;  116 arr sign byte    66 NULL        0 I_MOV[6]
  5432                                  ;  117 arr sign byte    68 NULL        0 I_JO[6]
  5433                                  ;  118 arr sign byte    69 NULL        0 I_JNO[7]
  5434                                  ;  119 arr sign byte    70 NULL        0 I_JB[6]
  5435                                  ;  120 arr sign byte    71 NULL        0 I_JC[6]
  5436                                  ;  121 arr sign byte    72 NULL        0 I_JNB[7]
  5437                                  ;  122 arr sign byte    73 NULL        0 I_JAE[7]
  5438                                  ;  123 arr sign byte    74 NULL        0 I_JNC[7]
  5439                                  ;  124 arr sign byte    75 NULL        0 I_JE[6]
  5440                                  ;  125 arr sign byte    76 NULL        0 I_JZ[6]
  5441                                  ;  126 arr sign byte    77 NULL        0 I_JNE[7]
  5442                                  ;  127 arr sign byte    78 NULL        0 I_JNZ[7]
  5443                                  ;  128 arr sign byte    79 NULL        0 I_JBE[7]
  5444                                  ;  129 arr sign byte    80 NULL        0 I_JNA[7]
  5445                                  ;  130 arr sign byte    81 NULL        0 I_JA[6]
  5446                                  ;  131 arr sign byte    82 NULL        0 I_JS[6]
  5447                                  ;  132 arr sign byte    83 NULL        0 I_JNS[7]
  5448                                  ;  133 arr sign byte    84 NULL        0 I_JP[6]
  5449                                  ;  134 arr sign byte    85 NULL        0 I_JPE[7]
  5450                                  ;  135 arr sign byte    86 NULL        0 I_JNP[7]
  5451                                  ;  136 arr sign byte    87 NULL        0 I_JPO[7]
  5452                                  ;  137 arr sign byte    88 NULL        0 I_JL[6]
  5453                                  ;  138 arr sign byte    89 NULL        0 I_JNL[7]
  5454                                  ;  139 arr sign byte    90 NULL        0 I_JGE[7]
  5455                                  ;  140 arr sign byte    91 NULL        0 I_JLE[7]
  5456                                  ;  141 arr sign byte    92 NULL        0 I_JNG[7]
  5457                                  ;  142 arr sign byte    93 NULL        0 I_JG[6]
  5458                                  ;  143 arr sign byte    95 NULL        0 I_RET[8]
  5459                                  ;  144 arr sign byte    97 NULL        0 I_PUSH[8]
  5460                                  ;  145 arr sign byte    98 NULL        0 I_POP[7]
  5461                                  ;  146 arr sign byte   100 NULL        0 I_ORG[6]
  5462                                  ;  147 arr sign byte   101 NULL        0 I_DB[5]
  5463                                  ;  148 arr sign byte   102 NULL        0 I_DW[5]
  5464                                  ;  149 arr sign byte   103 NULL        0 I_DD[5]
  5465                                  ;  150 arr sign byte   104 NULL        0 I_RESB[7]
  5466                                  ;  151 arr sign byte   105 NULL        0 I_RESW[7]
  5467                                  ;  152 arr sign byte   106 NULL        0 I_RESD[7]
  5468                                  ;  153 var sign byte   107 NULL        0 I_END
  5469                                  
  5470                                  
  5471                                  ;   # Calls Line Width  Name   list of functions
  5472                                  
  5473                                  ;    0 NULL    1 word   main
  5474                                  ;    1    1   11 word   process
  5475                                  ;    2    2   61 word   LeftOpwCheck
  5476                                  ;    3    1   71 word   getLeftOp
  5477                                  ;    4    1   83 word   setwflag
  5478                                  ;    5    2   91 word   getOp1
  5479                                  ;    6    1  103 word   getIND
  5480                                  ;    7    1  118 word   getIndReg1
  5481                                  ;    8    1  127 word   getIndReg2
  5482                                  ;    9    1  138 word   gen66h
  5483                                  ;   10    8  139 word   genCode8
  5484                                  ;   11    3  143 word   genCode16
  5485                                  ;   12    7  146 word   genInstruction
  5486                                  ;   13    2  150 word   genCodeInREG
  5487                                  ;   14 NULL  153 word   genModRegRM
  5488                                  ;   15    2  155 word   writeEA
  5489                                  ;   16 NULL  169 word   test1
  5490                                  ;   17    1    1 word   parse
  5491                                  ;   18   12   27 word   getTokeType
  5492                                  ;   19    2   36 word   storeLabel
  5493                                  ;   20    2   43 word   searchLabel
  5494                                  ;   21    1   54 word   getVariable
  5495                                  ;   22    2   83 word   lookCode
  5496                                  ;   23    1   97 word   getCodeSize
  5497                                  ;   24    7  104 word   isToken
  5498                                  ;   25    1  109 word   skipRest
  5499                                  ;   26    1    1 word   getLine
  5500                                  ;   27    1   14 word   ifEOL
  5501                                  ;   28    3   21 word   skipBlank
  5502                                  ;   29    2   26 word   letterE
  5503                                  ;   30    1   36 word   alnumE
  5504                                  ;   31    1   41 word   getDigit
  5505                                  ;   32    1   53 word   getName
  5506                                  ;   33    1   70 word   testReg
  5507                                  ;   34    1    1 word   printLine
  5508                                  ;   35    9   19 word   prc
  5509                                  ;   36    1   23 word   prscomment
  5510                                  ;   37   24   26 word   prs
  5511                                  ;   38    4   31 word   printhex8a
  5512                                  ;   39    2   35 word   printhex16
  5513                                  ;   40    3   38 word   printIntU
  5514                                  ;   41   19   45 word   error1
  5515                                  ;   42 NULL   48 word   allowederror
  5516                                  ;   43 NULL   49 word   implmerror
  5517                                  ;   44    4   50 word   indexerror
  5518                                  ;   45    1   51 word   numbererror
  5519                                  ;   46 NULL   52 word   regmemerror
  5520                                  ;   47    1   53 word   segregerror
  5521                                  ;   48    1   54 word   syntaxerror
  5522                                  ;   49    7   56 word   errorexit
  5523                                  ;   50    1   57 word   addrexit
  5524                                  ;   51 NULL   58 word   internexit
  5525                                  ;   52    1    1 word   getarg
  5526                                  ;   53    1   26 word   epilog
  5527                                  ;   54    2   57 word   end1
  5528                                  ;   55    4  183 word   writetty
  5529                                  ;   56    8  184 word   cputs
  5530                                  ;   57    2  185 word   toupper
  5531                                  ;   58    4  187 word   strlen
  5532                                  ;   59    6  188 word   strcpy
  5533                                  ;   60    3  190 word   digit
  5534                                  ;   61   35  191 word   eqstr
  5535                                  ;   62    3  194 word   strcat1
  5536                                  ;   63    1  195 word   openR
  5537                                  ;   64    2  196 word   creatR
  5538                                  ;   65    2  197 word   readRL
  5539                                  ;   66    2  198 word   fputcR
  5540                                  ;   67    3  200 word   fcloseR
  5541                                  ;   68    5  201 word   exitR
  5542                                  ;   69    1  203 word   putch
  5543                                  ;   70    4  204 word   DosInt
  5544                                  ;   71 NULL  205 word   LastFunctionByt
  5545                                  
  5546                                  ;    #  addr name   list of CALLs
  5547                                  
  5548                                  ;    0     5 getarg
  5549                                  ;    1    12 parse
  5550                                  ;    2    18 epilog
  5551                                  ;    3    25 end1
  5552                                  ;    4  1088 getTokeType
  5553                                  ;    5  1100 getCodeSize
  5554                                  ;    6  1112 genInstruction
  5555                                  ;    7  1127 LeftOpwCheck
  5556                                  ;    8  1140 genInstruction
  5557                                  ;    9  1155 genInstruction
  5558                                  ;   10  1170 genInstruction
  5559                                  ;   11  1185 genCodeInREG
  5560                                  ;   12  1198 LeftOpwCheck
  5561                                  ;   13  1211 genInstruction
  5562                                  ;   14  1226 genCodeInREG
  5563                                  ;   15  1239 genInstruction
  5564                                  ;   16  1254 genCode16
  5565                                  ;   17  1264 genInstruction
  5566                                  ;   18  1279 error1
  5567                                  ;   19  1286 error1
  5568                                  ;   20  1306 getLeftOp
  5569                                  ;   21  1316 segregerror
  5570                                  ;   22  1328 setwflag
  5571                                  ;   23  1337 error1
  5572                                  ;   24  1344 error1
  5573                                  ;   25  1351 error1
  5574                                  ;   26  1368 getOp1
  5575                                  ;   27  1375 isToken
  5576                                  ;   28  1383 getIND
  5577                                  ;   29  1390 error1
  5578                                  ;   30  1397 error1
  5579                                  ;   31  1413 gen66h
  5580                                  ;   32  1427 testReg
  5581                                  ;   33  1435 searchLabel
  5582                                  ;   34  1447 error1
  5583                                  ;   35  1468 getTokeType
  5584                                  ;   36  1480 getOp1
  5585                                  ;   37  1487 syntaxerror
  5586                                  ;   38  1499 getIndReg2
  5587                                  ;   39  1510 getIndReg1
  5588                                  ;   40  1521 isToken
  5589                                  ;   41  1529 getTokeType
  5590                                  ;   42  1541 numbererror
  5591                                  ;   43  1553 isToken
  5592                                  ;   44  1561 isToken
  5593                                  ;   45  1569 errorexit
  5594                                  ;   46  1592 indexerror
  5595                                  ;   47  1603 indexerror
  5596                                  ;   48  1630 indexerror
  5597                                  ;   49  1641 indexerror
  5598                                  ;   50  1659 genCode8
  5599                                  ;   51  1691 genCode8
  5600                                  ;   52  1700 genCode8
  5601                                  ;   53  1733 genCode8
  5602                                  ;   54  1757 writeEA
  5603                                  ;   55  1777 writeEA
  5604                                  ;   56  1801 addrexit
  5605                                  ;   57  1810 genCode8
  5606                                  ;   58  1819 genCode8
  5607                                  ;   59  1828 genCode16
  5608                                  ;   60  1850 getLine
  5609                                  ;   61  1858 getTokeType
  5610                                  ;   62  1870 storeLabel
  5611                                  ;   63  1881 getTokeType
  5612                                  ;   64  1893 lookCode
  5613                                  ;   65  1902 process
  5614                                  ;   66  1910 getVariable
  5615                                  ;   67  1922 skipRest
  5616                                  ;   68  1931 error1
  5617                                  ;   69  1938 error1
  5618                                  ;   70  1945 printLine
  5619                                  ;   71  1969 skipBlank
  5620                                  ;   72  1979 digit
  5621                                  ;   73  1985 getDigit
  5622                                  ;   74  1994 letterE
  5623                                  ;   75  2002 getName
  5624                                  ;   76  2021 searchLabel
  5625                                  ;   77  2033 error1
  5626                                  ;   78  2040 strcpy
  5627                                  ;   79  2067 eqstr
  5628                                  ;   80  2073 strlen
  5629                                  ;   81  2094 storeLabel
  5630                                  ;   82  2105 getTokeType
  5631                                  ;   83  2117 lookCode
  5632                                  ;   84  2126 errorexit
  5633                                  ;   85  2136 errorexit
  5634                                  ;   86  2146 getTokeType
  5635                                  ;   87  2158 genCode8
  5636                                  ;   88  2167 skipBlank
  5637                                  ;   89  2177 isToken
  5638                                  ;   90  2185 genCode8
  5639                                  ;   91  2194 isToken
  5640                                  ;   92  2202 getTokeType
  5641                                  ;   93  2214 genCode16
  5642                                  ;   94  2224 isToken
  5643                                  ;   95  2232 errorexit
  5644                                  ;   96  2251 eqstr
  5645                                  ;   97  2269 eqstr
  5646                                  ;   98  2275 getTokeType
  5647                                  ;   99  2287 eqstr
  5648                                  ;  100  2293 getTokeType
  5649                                  ;  101  2305 eqstr
  5650                                  ;  102  2311 getTokeType
  5651                                  ;  103  2333 skipBlank
  5652                                  ;  104  2352 getTokeType
  5653                                  ;  105  2364 prs
  5654                                  ;  106  2376 readRL
  5655                                  ;  107  2383 errorexit
  5656                                  ;  108  2393 ifEOL
  5657                                  ;  109  2407 readRL
  5658                                  ;  110  2443 digit
  5659                                  ;  111  2449 letterE
  5660                                  ;  112  2476 digit
  5661                                  ;  113  2494 alnumE
  5662                                  ;  114  2501 strcpy
  5663                                  ;  115  2508 toupper
  5664                                  ;  116  2524 strlen
  5665                                  ;  117  2531 strlen
  5666                                  ;  118  2538 eqstr
  5667                                  ;  119  2544 eqstr
  5668                                  ;  120  2550 eqstr
  5669                                  ;  121  2556 eqstr
  5670                                  ;  122  2562 eqstr
  5671                                  ;  123  2568 eqstr
  5672                                  ;  124  2574 eqstr
  5673                                  ;  125  2580 eqstr
  5674                                  ;  126  2586 eqstr
  5675                                  ;  127  2592 eqstr
  5676                                  ;  128  2598 eqstr
  5677                                  ;  129  2604 eqstr
  5678                                  ;  130  2610 eqstr
  5679                                  ;  131  2616 eqstr
  5680                                  ;  132  2622 eqstr
  5681                                  ;  133  2628 eqstr
  5682                                  ;  134  2634 eqstr
  5683                                  ;  135  2640 eqstr
  5684                                  ;  136  2646 eqstr
  5685                                  ;  137  2652 eqstr
  5686                                  ;  138  2658 eqstr
  5687                                  ;  139  2664 eqstr
  5688                                  ;  140  2670 eqstr
  5689                                  ;  141  2676 eqstr
  5690                                  ;  142  2682 eqstr
  5691                                  ;  143  2688 eqstr
  5692                                  ;  144  2694 eqstr
  5693                                  ;  145  2700 eqstr
  5694                                  ;  146  2706 eqstr
  5695                                  ;  147  2712 eqstr
  5696                                  ;  148  2732 prs
  5697                                  ;  149  2736 printhex16
  5698                                  ;  150  2747 prs
  5699                                  ;  151  2751 prc
  5700                                  ;  152  2755 printhex8a
  5701                                  ;  153  2766 prc
  5702                                  ;  154  2770 prs
  5703                                  ;  155  2774 prscomment
  5704                                  ;  156  2791 writetty
  5705                                  ;  157  2800 writetty
  5706                                  ;  158  2809 fputcR
  5707                                  ;  159  2831 prc
  5708                                  ;  160  2847 prc
  5709                                  ;  161  2868 prc
  5710                                  ;  162  2872 prc
  5711                                  ;  163  2894 printhex8a
  5712                                  ;  164  2905 printhex8a
  5713                                  ;  165  2930 printIntU
  5714                                  ;  166  2940 prc
  5715                                  ;  167  2953 prs
  5716                                  ;  168  2957 prs
  5717                                  ;  169  2961 prs
  5718                                  ;  170  2965 prs
  5719                                  ;  171  2982 error1
  5720                                  ;  172  3000 error1
  5721                                  ;  173  3018 error1
  5722                                  ;  174  3037 error1
  5723                                  ;  175  3056 error1
  5724                                  ;  176  3075 error1
  5725                                  ;  177  3094 error1
  5726                                  ;  178  3113 error1
  5727                                  ;  179  3120 end1
  5728                                  ;  180  3134 errorexit
  5729                                  ;  181  3155 errorexit
  5730                                  ;  182  3184 cputs
  5731                                  ;  183  3190 cputs
  5732                                  ;  184  3196 exitR
  5733                                  ;  185  3202 toupper
  5734                                  ;  186  3210 strcpy
  5735                                  ;  187  3217 strcat1
  5736                                  ;  188  3225 strcpy
  5737                                  ;  189  3232 strcat1
  5738                                  ;  190  3240 strcpy
  5739                                  ;  191  3247 strcat1
  5740                                  ;  192  3255 openR
  5741                                  ;  193  3261 cputs
  5742                                  ;  194  3267 cputs
  5743                                  ;  195  3273 exitR
  5744                                  ;  196  3279 creatR
  5745                                  ;  197  3286 cputs
  5746                                  ;  198  3292 cputs
  5747                                  ;  199  3298 exitR
  5748                                  ;  200  3304 creatR
  5749                                  ;  201  3311 cputs
  5750                                  ;  202  3317 cputs
  5751                                  ;  203  3323 exitR
  5752                                  ;  204  3329 prs
  5753                                  ;  205  3333 prs
  5754                                  ;  206  3337 prs
  5755                                  ;  207  3341 prs
  5756                                  ;  208  3345 prs
  5757                                  ;  209  3349 prs
  5758                                  ;  210  3353 prs
  5759                                  ;  211  3357 prs
  5760                                  ;  212  3361 prs
  5761                                  ;  213  3378 prs
  5762                                  ;  214  3382 printIntU
  5763                                  ;  215  3392 prs
  5764                                  ;  216  3396 prs
  5765                                  ;  217  3400 prs
  5766                                  ;  218  3404 prc
  5767                                  ;  219  3408 printhex16
  5768                                  ;  220  3419 prs
  5769                                  ;  221  3423 strlen
  5770                                  ;  222  3430 prs
  5771                                  ;  223  3434 printIntU
  5772                                  ;  224  3444 prs
  5773                                  ;  225  3448 prc
  5774                                  ;  226  3452 printhex8a
  5775                                  ;  227  3463 fputcR
  5776                                  ;  228  3477 fcloseR
  5777                                  ;  229  3485 fcloseR
  5778                                  ;  230  3493 fcloseR
  5779                                  ;  231  3501 exitR
  5780                                  ;  232  3526 putch
  5781                                  ;  233  3594 strcpy
  5782                                  ;  234  3609 DosInt
  5783                                  ;  235  3625 DosInt
  5784                                  ;  236  3648 DosInt
  5785                                  ;  237  3667 DosInt
  5786                                  ;  238  3701 writetty
  5787                                  ;  239  3710 writetty
  5788                                  ;Input: AS.C, List: AS.S,  Lines:  206
  5789                                  ;Glob. variables:  153 max.:  200
  5790                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  5791                                  ;Functions      :   72 max.:  300
  5792                                  ;Calls          :  240 max.: 2000, NameField: 3742 max.:    65535
  5793                                  ;Code until     :26009 max.: 30000, free: 3991
  5794                                  ;Data (HeapEnd) :33596, resting stacksize: 31939
  5795                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
