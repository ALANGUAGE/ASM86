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
   725                                  ;-6 int process1(); NumOprns=0;
   726                                  
   727                                  
   728                                  ;-7   getOpcode1(); NumOprns=1;
   729                                  
   730                                  
   731                                  ;-8   if (isToken(',')) {
   732                                  
   733                                  
   734                                  ;-9     getOpcode2(); NumOprns=2;
   735                                  
   736                                  
   737                                  ;-10   }
   738                                  
   739                                  
   740                                  ;-11   genInstruction();
   741                                  
   742                                  
   743                                  ;-12 */
   744                                  
   745                                  
   746                                  ;-13 int process() { int i; char c;
   747                                  
   748                                  
   749                                  process:  ; *** PROC ***
   750                                  
   751                                  ;-14   getTokeType();
   752                                  
   753                                  ;Function : process, Number of local variables: 2
   754                                  ;   # type sign width line used address name   list of local variables
   755                                  ;  200 var sign word    13 NULL bp-2    i
   756                                  ;  201 var sign byte    13 NULL bp-4    c;
   757 0000030B C8040000                 ENTER  4,0
   758 0000030F E8EE07                   call getTokeType
   759                                  
   760                                  ;-15   OpSize=getCodeSize();
   761                                  
   762 00000312 E8E50A                   call getCodeSize
   763 00000315 A2[4000]                 mov byte [OpSize], al
   764                                  
   765                                  ;-16 
   766                                  
   767                                  
   768                                  ;-17   if (CodeType ==  1) {//1 byte opcode
   769                                  
   770 00000318 A0[3D00]                 mov al, [CodeType]
   771 0000031B 3C01                     cmp al, 1
   772 0000031D 0F850D00                 jne @@process1
   773                                  
   774                                  ;-18     genInstruction(0, 1); return;
   775                                  
   776 00000321 6A01                     push 1
   777 00000323 6A00                     push 0
   778 00000325 E8A805                   call genInstruction
   779 00000328 83C404                   add  sp, 4
   780 0000032B E9E000                   jmp @@retn
   781                                  
   782                                  ;-19   }
   783                                  
   784                                  
   785                                  ;-20   if (CodeType ==  2) {//inc, dec
   786                                  
   787                                  @@process1:
   788 0000032E A0[3D00]                 mov al, [CodeType]
   789 00000331 3C02                     cmp al, 2
   790 00000333 0F855400                 jne @@process2
   791                                  
   792                                  ;-21     LeftOpwCheck();
   793                                  
   794 00000337 E8FA00                   call LeftOpwCheck
   795                                  
   796                                  ;-22     	if (Op1 == REG) {
   797                                  
   798 0000033A A0[3C00]                 mov al, [Op1]
   799 0000033D 3C02                     cmp al, 2
   800 0000033F 0F853400                 jne @@process3
   801                                  
   802                                  ;-23         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form
   803                                  
   804 00000343 A0[3E00]                 mov al, [RegType]
   805 00000346 3C02                     cmp al, 2
   806 00000348 0F851100                 jne @@process4
   807 0000034C 6A03                     push 3
   808 0000034E A0[3F00]                 mov al, byte [RegNo]
   809 00000351 B400                     mov ah, 0
   810 00000353 50                       push ax
   811 00000354 E87905                   call genInstruction
   812 00000357 83C404                   add  sp, 4
   813 0000035A E9B100                   jmp @@retn
   814                                  
   815                                  ;-24         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }
   816                                  
   817                                  @@process4:
   818 0000035D A0[3E00]                 mov al, [RegType]
   819 00000360 3C03                     cmp al, 3
   820 00000362 0F851100                 jne @@process5
   821 00000366 6A03                     push 3
   822 00000368 A0[3F00]                 mov al, byte [RegNo]
   823 0000036B B400                     mov ah, 0
   824 0000036D 50                       push ax
   825 0000036E E85F05                   call genInstruction
   826 00000371 83C404                   add  sp, 4
   827 00000374 E99700                   jmp @@retn
   828                                  @@process5:
   829                                  
   830                                  ;-25       genInstruction(wflag, 1); genCodeInREG(); return;
   831                                  
   832                                  @@process3:
   833 00000377 6A01                     push 1
   834 00000379 A0[4200]                 mov al, byte [wflag]
   835 0000037C B400                     mov ah, 0
   836 0000037E 50                       push ax
   837 0000037F E84E05                   call genInstruction
   838 00000382 83C404                   add  sp, 4
   839 00000385 E87A05                   call genCodeInREG
   840 00000388 E98300                   jmp @@retn
   841                                  
   842                                  ;-26   }
   843                                  
   844                                  
   845                                  ;-27 
   846                                  
   847                                  
   848                                  ;-28   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
   849                                  
   850                                  @@process2:
   851 0000038B A0[3D00]                 mov al, [CodeType]
   852 0000038E 3C34                     cmp al, 52
   853 00000390 0F851700                 jne @@process6
   854                                  
   855                                  ;-29     LeftOpwCheck();
   856                                  
   857 00000394 E89D00                   call LeftOpwCheck
   858                                  
   859                                  ;-30     genInstruction(wflag, 1); genCodeInREG(); return;
   860                                  
   861 00000397 6A01                     push 1
   862 00000399 A0[4200]                 mov al, byte [wflag]
   863 0000039C B400                     mov ah, 0
   864 0000039E 50                       push ax
   865 0000039F E82E05                   call genInstruction
   866 000003A2 83C404                   add  sp, 4
   867 000003A5 E85A05                   call genCodeInREG
   868 000003A8 E96300                   jmp @@retn
   869                                  
   870                                  ;-31   }
   871                                  
   872                                  
   873                                  ;-32 
   874                                  
   875                                  
   876                                  ;-33   if (CodeType==  8) {// ret
   877                                  
   878                                  @@process6:
   879 000003AB A0[3D00]                 mov al, [CodeType]
   880 000003AE 3C08                     cmp al, 8
   881 000003B0 0F852D00                 jne @@process7
   882                                  
   883                                  ;-34     if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}
   884                                  
   885 000003B4 A0[3B00]                 mov al, [TokeType]
   886 000003B7 3C01                     cmp al, 1
   887 000003B9 0F851700                 jne @@process8
   888 000003BD 6A02                     push 2
   889 000003BF 6A00                     push 0
   890 000003C1 E80C05                   call genInstruction
   891 000003C4 83C404                   add  sp, 4
   892 000003C7 FF36[2500]               push word [SymbolInt]
   893 000003CB E8E104                   call genCode16
   894 000003CE 83C402                   add  sp, 2
   895 000003D1 E93A00                   jmp @@retn
   896                                  
   897                                  ;-35     genInstruction(0, 1); return;
   898                                  
   899                                  @@process8:
   900 000003D4 6A01                     push 1
   901 000003D6 6A00                     push 0
   902 000003D8 E8F504                   call genInstruction
   903 000003DB 83C404                   add  sp, 4
   904 000003DE E92D00                   jmp @@retn
   905                                  
   906                                  ;-36   }
   907                                  
   908                                  
   909                                  ;-37 
   910                                  
   911                                  
   912                                  ;-38   if (CodeType==101) {// ORG nn
   913                                  
   914                                  @@process7:
   915 000003E1 A0[3D00]                 mov al, [CodeType]
   916 000003E4 3C65                     cmp al, 101
   917 000003E6 0F851B00                 jne @@process9
   918                                  
   919                                  ;-39     if (TokeType != DIGIT) error1("only digit allowed");
   920                                  
   921 000003EA A0[3B00]                 mov al, [TokeType]
   922 000003ED 3C01                     cmp al, 1
   923 000003EF 0F840900                 je  @@process10
   924 000003F3 68[1004]                 push process_0
   925 000003F6 E84714                   call error1
   926 000003F9 83C402                   add  sp, 2
   927                                  
   928                                  ;-40     PC=SymbolInt;return;
   929                                  
   930                                  @@process10:
   931 000003FC A1[2500]                 mov ax, [SymbolInt]
   932 000003FF A3[3600]                 mov word [PC], ax
   933 00000402 E90900                   jmp @@retn
   934                                  
   935                                  ;-41   }
   936                                  
   937                                  
   938                                  ;-42   error1("unknown CodeType");
   939                                  
   940                                  @@process9:
   941 00000405 68[2304]                 push process_1
   942 00000408 E83514                   call error1
   943 0000040B 83C402                   add  sp, 2
   944                                  
   945                                  ;-43 }
   946                                  
   947                                  
   948                                  ;-44 /*
   949                                  
   950                                  
   951                                  ;-45 operand::=
   952                                  
   953                                  
   954                                  ;-46   none
   955                                  
   956                                  
   957                                  ;-47   ac  (al, ax, eax)
   958                                  
   959                                  
   960                                  ;-48   r   (b, w, s, d)
   961                                  
   962                                  
   963                                  ;-49   [m] (b, w, d)
   964                                  
   965                                  
   966                                  ;-50   i   (b, w)
   967                                  
   968                                  
   969                                  ;-51   disp(b, w)
   970                                  
   971                                  
   972                                  ;-52 
   973                                  
   974                                  
   975                                  ;-53 //O2=rr,rm,ri,mr,mi
   976                                  
   977                                  
   978                                  ;-54 //NumOprns==2, seg reg not allowed only mov and push
   979                                  
   980                                  
   981                                  ;-55 //size: 1.declaration CodeSize, 2.reg size, 3.error1
   982                                  
   983                                  
   984                                  ;-56 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
   985                                  
   986                                  
   987                                  ;-57 //2. rm , imm 80
   988                                  
   989                                  
   990                                  ;-58 //2a sign ext 83
   991                                  
   992                                  
   993                                  ;-59 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
   994                                  
   995                                  
   996                                  ;-60 //4. rm , reg 00
   997                                  
   998                                  
   999                                  ;-61 //5. error1(mem2mem)
  1000                                  
  1001                                  
  1002                                  ;-62 */
  1003                                  
  1004                                  
  1005                                  ;-63 int LeftOpwCheck() {
  1006                                  
  1007 0000040E C9                      @@retn: LEAVE
  1008 0000040F C3                       ret
  1009                                  ; ENDP
  1010 00000410 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1011 00000419 7420616C6C6F776564-
  1012 00000422 00                 
  1013 00000423 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1014 0000042C 6F64655479706500   
  1015                                  
  1016                                  LeftOpwCheck:  ; *** PROC ***
  1017                                  
  1018                                  ;-64   getLeftOp();
  1019                                  
  1020 00000434 E8A700                   call getLeftOp
  1021                                  
  1022                                  ;-65   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1023                                  
  1024 00000437 A0[3E00]                 mov al, [RegType]
  1025 0000043A 3C04                     cmp al, 4
  1026 0000043C 0F850600                 jne @@LeftOpwCheck11
  1027 00000440 E8F614                   call segregerror
  1028 00000443 E95300                   jmp @@retn
  1029                                  
  1030                                  ;-66   setwflag();
  1031                                  
  1032                                  @@LeftOpwCheck11:
  1033 00000446 E85B01                   call setwflag
  1034                                  
  1035                                  ;-67   if (OpSize == 0) error1("no op size declared");
  1036                                  
  1037 00000449 A0[4000]                 mov al, [OpSize]
  1038 0000044C 3C00                     cmp al, 0
  1039 0000044E 0F850900                 jne @@LeftOpwCheck12
  1040 00000452 68[9A04]                 push LeftOpwCheck_0
  1041 00000455 E8E813                   call error1
  1042 00000458 83C402                   add  sp, 2
  1043                                  
  1044                                  ;-68   if (OpSize == RegType) return;
  1045                                  
  1046                                  @@LeftOpwCheck12:
  1047 0000045B A0[4000]                 mov al, [OpSize]
  1048 0000045E 3A06[3E00]               cmp al, [RegType]
  1049 00000462 0F850300                 jne @@LeftOpwCheck13
  1050 00000466 E93000                   jmp @@retn
  1051                                  
  1052                                  ;-69   if (OpSize){if (Op1 == IND) return;
  1053                                  
  1054                                  @@LeftOpwCheck13:
  1055 00000469 A0[4000]                 mov al, [OpSize]
  1056 0000046C 08C0                     or  al, al
  1057 0000046E 0F841500                 je @@LeftOpwCheck14
  1058 00000472 A0[3C00]                 mov al, [Op1]
  1059 00000475 3C04                     cmp al, 4
  1060 00000477 0F850300                 jne @@LeftOpwCheck15
  1061 0000047B E91B00                   jmp @@retn
  1062                                  
  1063                                  ;-70     error1("Conflict OpSize and RegSize"); }
  1064                                  
  1065                                  @@LeftOpwCheck15:
  1066 0000047E 68[AE04]                 push LeftOpwCheck_1
  1067 00000481 E8BC13                   call error1
  1068 00000484 83C402                   add  sp, 2
  1069                                  
  1070                                  ;-71   if (RegType==0) error1("no register defined");
  1071                                  
  1072                                  @@LeftOpwCheck14:
  1073 00000487 A0[3E00]                 mov al, [RegType]
  1074 0000048A 3C00                     cmp al, 0
  1075 0000048C 0F850900                 jne @@LeftOpwCheck16
  1076 00000490 68[CA04]                 push LeftOpwCheck_2
  1077 00000493 E8AA13                   call error1
  1078 00000496 83C402                   add  sp, 2
  1079                                  
  1080                                  ;-72 }
  1081                                  
  1082                                  @@LeftOpwCheck16:
  1083                                  
  1084                                  ;-73 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
  1085                                  
  1086                                  @@retn:
  1087 00000499 C3                       ret
  1088                                  ; ENDP
  1089 0000049A 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
  1090 000004A3 65206465636C617265-
  1091 000004AC 6400               
  1092 000004AE 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
  1093 000004B7 4F7053697A6520616E-
  1094 000004C0 642052656753697A65-
  1095 000004C9 00                 
  1096 000004CA 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
  1097 000004D3 657220646566696E65-
  1098 000004DC 6400               
  1099                                  
  1100                                  getLeftOp:  ; *** PROC ***
  1101                                  
  1102                                  ;-74 //set: op1, disp->imm, reg, regt->size
  1103                                  
  1104                                  
  1105                                  ;-75   disp=0; imme=0; reg=0;
  1106                                  
  1107 000004DE 66B800000000             mov eax, 0
  1108 000004E4 A3[4500]                 mov word [disp], ax
  1109 000004E7 66B800000000             mov eax, 0
  1110 000004ED A3[4700]                 mov word [imme], ax
  1111 000004F0 66B800000000             mov eax, 0
  1112 000004F6 A2[4400]                 mov byte [reg], al
  1113                                  
  1114                                  ;-76 
  1115                                  
  1116                                  
  1117                                  ;-77   Op1=getOp1();
  1118                                  
  1119 000004F9 E80301                   call getOp1
  1120 000004FC A2[3C00]                 mov byte [Op1], al
  1121                                  
  1122                                  ;-78   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
  1123                                  
  1124 000004FF 6A5B                     push 91
  1125 00000501 E87909                   call isToken
  1126 00000504 83C402                   add  sp, 2
  1127 00000507 08C0                     or  al, al
  1128 00000509 0F840F00                 je @@getLeftOp17
  1129 0000050D 66B804000000             mov eax, 4
  1130 00000513 A2[3C00]                 mov byte [Op1], al
  1131 00000516 E86C01                   call getIND
  1132 00000519 E95200                   jmp @@retn
  1133                                  
  1134                                  ;-79   if (Op1 == 0) error1("Name of operand expected");
  1135                                  
  1136                                  @@getLeftOp17:
  1137 0000051C A0[3C00]                 mov al, [Op1]
  1138 0000051F 3C00                     cmp al, 0
  1139 00000521 0F850900                 jne @@getLeftOp18
  1140 00000525 68[6F05]                 push getLeftOp_0
  1141 00000528 E81513                   call error1
  1142 0000052B 83C402                   add  sp, 2
  1143                                  
  1144                                  ;-80   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
  1145                                  
  1146                                  @@getLeftOp18:
  1147 0000052E A0[3C00]                 mov al, [Op1]
  1148 00000531 3C01                     cmp al, 1
  1149 00000533 0F850900                 jne @@getLeftOp19
  1150 00000537 A1[2500]                 mov ax, [SymbolInt]
  1151 0000053A A3[4700]                 mov word [imme], ax
  1152 0000053D E92E00                   jmp @@retn
  1153                                  
  1154                                  ;-81   if (Op1 == REG) return;                                    //2
  1155                                  
  1156                                  @@getLeftOp19:
  1157 00000540 A0[3C00]                 mov al, [Op1]
  1158 00000543 3C02                     cmp al, 2
  1159 00000545 0F850300                 jne @@getLeftOp20
  1160 00000549 E92200                   jmp @@retn
  1161                                  
  1162                                  ;-82   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
  1163                                  
  1164                                  @@getLeftOp20:
  1165 0000054C A0[3C00]                 mov al, [Op1]
  1166 0000054F 3C03                     cmp al, 3
  1167 00000551 0F851000                 jne @@getLeftOp21
  1168 00000555 8B1E[5200]               mov bx, [LabelIx]
  1169 00000559 D1E3                     shl bx, 1
  1170 0000055B 8B87A47A                 mov ax, [LabelAddr + bx]
  1171 0000055F A3[4500]                 mov word [disp], ax
  1172 00000562 E90900                   jmp @@retn
  1173                                  
  1174                                  ;-83   error1("Name of operand expected #1");
  1175                                  
  1176                                  @@getLeftOp21:
  1177 00000565 68[8805]                 push getLeftOp_1
  1178 00000568 E8D512                   call error1
  1179 0000056B 83C402                   add  sp, 2
  1180                                  
  1181                                  ;-84 }
  1182                                  
  1183                                  
  1184                                  ;-85 int setwflag() {//only Op1 (first operand)
  1185                                  
  1186                                  @@retn:
  1187 0000056E C3                       ret
  1188                                  ; ENDP
  1189 0000056F 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
  1190 00000578 706572616E64206578-
  1191 00000581 70656374656400     
  1192 00000588 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
  1193 00000591 706572616E64206578-
  1194 0000059A 706563746564202331-
  1195 000005A3 00                 
  1196                                  
  1197                                  setwflag:  ; *** PROC ***
  1198                                  
  1199                                  ;-86   wflag=0;
  1200                                  
  1201 000005A4 66B800000000             mov eax, 0
  1202 000005AA A2[4200]                 mov byte [wflag], al
  1203                                  
  1204                                  ;-87   if (OpSize == 0) {//do not override OpSize
  1205                                  
  1206 000005AD A0[4000]                 mov al, [OpSize]
  1207 000005B0 3C00                     cmp al, 0
  1208 000005B2 0F852100                 jne @@setwflag22
  1209                                  
  1210                                  ;-88     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
  1211                                  
  1212 000005B6 A0[3C00]                 mov al, [Op1]
  1213 000005B9 3C02                     cmp al, 2
  1214 000005BB 0F851800                 jne @@setwflag23
  1215 000005BF A0[3E00]                 mov al, [RegType]
  1216 000005C2 A2[4000]                 mov byte [OpSize], al
  1217 000005C5 A0[3E00]                 mov al, [RegType]
  1218 000005C8 3C04                     cmp al, 4
  1219 000005CA 0F850900                 jne @@setwflag24
  1220 000005CE 66B802000000             mov eax, 2
  1221 000005D4 A2[4000]                 mov byte [OpSize], al
  1222                                  @@setwflag24:
  1223                                  
  1224                                  ;-89   }
  1225                                  
  1226                                  @@setwflag23:
  1227                                  
  1228                                  ;-90   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1229                                  
  1230                                  @@setwflag22:
  1231 000005D7 A0[4000]                 mov al, [OpSize]
  1232 000005DA 3C03                     cmp al, 3
  1233 000005DC 0F850C00                 jne @@setwflag25
  1234 000005E0 E89102                   call gen66h
  1235 000005E3 66B801000000             mov eax, 1
  1236 000005E9 A2[4200]                 mov byte [wflag], al
  1237                                  
  1238                                  ;-91   if (OpSize  ==  WORD) wflag=1;
  1239                                  
  1240                                  @@setwflag25:
  1241 000005EC A0[4000]                 mov al, [OpSize]
  1242 000005EF 3C02                     cmp al, 2
  1243 000005F1 0F850900                 jne @@setwflag26
  1244 000005F5 66B801000000             mov eax, 1
  1245 000005FB A2[4200]                 mov byte [wflag], al
  1246                                  
  1247                                  ;-92 }
  1248                                  
  1249                                  @@setwflag26:
  1250                                  
  1251                                  ;-93 int getOp1() {//scan for a single operand
  1252                                  
  1253 000005FE C3                       ret
  1254                                  ; ENDP
  1255                                  
  1256                                  getOp1:  ; *** PROC ***
  1257                                  
  1258                                  ;-94   //set:Op1, imme, disp, RegType, TegNo, reg
  1259                                  
  1260                                  
  1261                                  ;-95   if (TokeType == 0)      return 0;
  1262                                  
  1263 000005FF A0[3B00]                 mov al, [TokeType]
  1264 00000602 3C00                     cmp al, 0
  1265 00000604 0F850900                 jne @@getOp127
  1266 00000608 66B800000000             mov eax, 0
  1267 0000060E E96000                   jmp @@retn
  1268                                  
  1269                                  ;-96   if (TokeType == DIGIT)  return IMM;// 1
  1270                                  
  1271                                  @@getOp127:
  1272 00000611 A0[3B00]                 mov al, [TokeType]
  1273 00000614 3C01                     cmp al, 1
  1274 00000616 0F850900                 jne @@getOp128
  1275 0000061A 66B801000000             mov eax, 1
  1276 00000620 E94E00                   jmp @@retn
  1277                                  
  1278                                  ;-97   if (TokeType == ALNUME) {
  1279                                  
  1280                                  @@getOp128:
  1281 00000623 A0[3B00]                 mov al, [TokeType]
  1282 00000626 3C03                     cmp al, 3
  1283 00000628 0F853C00                 jne @@getOp129
  1284                                  
  1285                                  ;-98     RegNo=testReg();//set global RegType
  1286                                  
  1287 0000062C E86A0B                   call testReg
  1288 0000062F A2[3F00]                 mov byte [RegNo], al
  1289                                  
  1290                                  ;-99     if (RegType)          return REG;// 2
  1291                                  
  1292 00000632 A0[3E00]                 mov al, [RegType]
  1293 00000635 08C0                     or  al, al
  1294 00000637 0F840900                 je @@getOp130
  1295 0000063B 66B802000000             mov eax, 2
  1296 00000641 E92D00                   jmp @@retn
  1297                                  
  1298                                  ;-100     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];
  1299                                  
  1300                                  @@getOp130:
  1301 00000644 E8A105                   call searchLabel
  1302 00000647 A3[5200]                 mov word [LabelIx], ax
  1303                                  
  1304                                  ;-101     if (LabelIx)          return DIR;// 3
  1305                                  
  1306 0000064A A1[5200]                 mov ax, [LabelIx]
  1307 0000064D 08C0                     or  al, al
  1308 0000064F 0F840C00                 je @@getOp131
  1309 00000653 66B803000000             mov eax, 3
  1310 00000659 E91500                   jmp @@retn
  1311                                  
  1312                                  ;-102     else error1("variable not found"); }
  1313                                  
  1314 0000065C E90900                   jmp @@getOp132
  1315                                  @@getOp131:
  1316 0000065F 68[7206]                 push getOp1_0
  1317 00000662 E8DB11                   call error1
  1318 00000665 83C402                   add  sp, 2
  1319                                  @@getOp132:
  1320                                  
  1321                                  ;-103   return 0;
  1322                                  
  1323                                  @@getOp129:
  1324 00000668 66B800000000             mov eax, 0
  1325 0000066E E90000                   jmp @@retn
  1326                                  
  1327                                  ;-104 }
  1328                                  
  1329                                  
  1330                                  ;-105 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
  1331                                  
  1332                                  @@retn:
  1333 00000671 C3                       ret
  1334                                  ; ENDP
  1335 00000672 7661726961626C6520-     getOp1_0 db "variable not found",0
  1336 0000067B 6E6F7420666F756E64-
  1337 00000684 00                 
  1338                                  
  1339                                  getIND:  ; *** PROC ***
  1340                                  
  1341                                  ;-106   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
  1342                                  
  1343                                  ;Function : getIND, Number of local variables: 2
  1344                                  ;   # type sign width line used address name   list of local variables
  1345                                  ;  200 var sign byte   106 NULL bp-2    op2
  1346                                  ;  201 var sign byte   106 NULL bp-4    r1;
  1347 00000685 C8040000                 ENTER  4,0
  1348 00000689 66B800000000             mov eax, 0
  1349 0000068F A3[4500]                 mov word [disp], ax
  1350 00000692 66B800000000             mov eax, 0
  1351 00000698 8846FC                   mov byte [bp-4], al
  1352 0000069B 66B800000000             mov eax, 0
  1353 000006A1 A2[3E00]                 mov byte [RegType], al
  1354                                  
  1355                                  ;-107   do {
  1356                                  
  1357                                  @@getIND33:
  1358                                  
  1359                                  ;-108     getTokeType();
  1360                                  
  1361 000006A4 E85904                   call getTokeType
  1362                                  
  1363                                  ;-109     op2=getOp1();
  1364                                  
  1365 000006A7 E855FF                   call getOp1
  1366 000006AA 8846FE                   mov byte [bp-2], al
  1367                                  
  1368                                  ;-110     if (op2 ==   0) syntaxerror();
  1369                                  
  1370 000006AD 8A46FE                   mov al, [bp-2]
  1371 000006B0 3C00                     cmp al, 0
  1372 000006B2 0F850300                 jne @@getIND34
  1373 000006B6 E8A712                   call syntaxerror
  1374                                  
  1375                                  ;-111     if (op2 == IMM) disp=disp+SymbolInt;
  1376                                  
  1377                                  @@getIND34:
  1378 000006B9 8A46FE                   mov al, [bp-2]
  1379 000006BC 3C01                     cmp al, 1
  1380 000006BE 0F850A00                 jne @@getIND35
  1381 000006C2 A1[4500]                 mov ax, [disp]
  1382 000006C5 0306[2500]               add ax, [SymbolInt]
  1383 000006C9 A3[4500]                 mov word [disp], ax
  1384                                  
  1385                                  ;-112     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
  1386                                  
  1387                                  @@getIND35:
  1388 000006CC 8A46FE                   mov al, [bp-2]
  1389 000006CF 3C02                     cmp al, 2
  1390 000006D1 0F852100                 jne @@getIND36
  1391 000006D5 8A46FC                   mov al, [bp-4]
  1392 000006D8 08C0                     or  al, al
  1393 000006DA 0F841200                 je @@getIND37
  1394 000006DE 8A46FC                   mov al, byte [bp-4]
  1395 000006E1 B400                     mov ah, 0
  1396 000006E3 50                       push ax
  1397 000006E4 E80001                   call getIndReg2
  1398 000006E7 83C402                   add  sp, 2
  1399 000006EA 8846FC                   mov byte [bp-4], al
  1400 000006ED E90600                   jmp @@getIND38
  1401                                  @@getIND37:
  1402 000006F0 E87F00                   call getIndReg1
  1403 000006F3 8846FC                   mov byte [bp-4], al
  1404                                  
  1405                                  ;-113     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
  1406                                  
  1407                                  @@getIND38:
  1408                                  @@getIND36:
  1409 000006F6 8A46FE                   mov al, [bp-2]
  1410 000006F9 3C03                     cmp al, 3
  1411 000006FB 0F851000                 jne @@getIND39
  1412 000006FF A1[4500]                 mov ax, [disp]
  1413 00000702 8B1E[5200]               mov bx, [LabelIx]
  1414 00000706 D1E3                     shl bx, 1
  1415 00000708 0387A47A                 add ax, [LabelAddr + bx]
  1416 0000070C A3[4500]                 mov word [disp], ax
  1417                                  
  1418                                  ;-114     if (isToken('-')) {getTokeType();
  1419                                  
  1420                                  @@getIND39:
  1421 0000070F 6A2D                     push 45
  1422 00000711 E86907                   call isToken
  1423 00000714 83C402                   add  sp, 2
  1424 00000717 08C0                     or  al, al
  1425 00000719 0F841900                 je @@getIND40
  1426 0000071D E8E003                   call getTokeType
  1427                                  
  1428                                  ;-115       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  1429                                  
  1430 00000720 A0[3B00]                 mov al, [TokeType]
  1431 00000723 3C01                     cmp al, 1
  1432 00000725 0F840300                 je  @@getIND41
  1433 00000729 E8C911                   call numbererror
  1434                                  @@getIND41:
  1435 0000072C A1[4500]                 mov ax, [disp]
  1436 0000072F 2B06[2500]               sub ax, [SymbolInt]
  1437 00000733 A3[4500]                 mov word [disp], ax
  1438                                  
  1439                                  ;-116   } while (isToken('+'));
  1440                                  
  1441                                  @@getIND40:
  1442 00000736 6A2B                     push 43
  1443 00000738 E84207                   call isToken
  1444 0000073B 83C402                   add  sp, 2
  1445 0000073E 08C0                     or  al, al
  1446 00000740 0F840300                 je @@getIND42
  1447 00000744 E95DFF                   jmp @@getIND33
  1448                                  @@getIND42:
  1449                                  
  1450                                  ;-117   if (isToken(']') == 0) errorexit("] expected");
  1451                                  
  1452 00000747 6A5D                     push 93
  1453 00000749 E83107                   call isToken
  1454 0000074C 83C402                   add  sp, 2
  1455 0000074F 83F800                   cmp ax, 0
  1456 00000752 0F850900                 jne @@getIND43
  1457 00000756 68[6707]                 push getIND_0
  1458 00000759 E81512                   call errorexit
  1459 0000075C 83C402                   add  sp, 2
  1460                                  
  1461                                  ;-118   reg=r1;
  1462                                  
  1463                                  @@getIND43:
  1464 0000075F 8A46FC                   mov al, [bp-4]
  1465 00000762 A2[4400]                 mov byte [reg], al
  1466                                  
  1467                                  ;-119 }
  1468                                  
  1469                                  
  1470                                  ;-120 int getIndReg1() {char m; m=0;
  1471 00000765 C9                       LEAVE
  1472 00000766 C3                       ret
  1473                                  ; ENDP
  1474 00000767 5D2065787065637465-     getIND_0 db "] expected",0
  1475 00000770 6400               
  1476                                  
  1477                                  getIndReg1:  ; *** PROC ***
  1478                                  ;Function : getIndReg1, Number of local variables: 1
  1479                                  ;   # type sign width line used address name   list of local variables
  1480                                  ;  200 var sign byte   120 NULL bp-2    m;
  1481 00000772 C8020000                 ENTER  2,0
  1482 00000776 66B800000000             mov eax, 0
  1483 0000077C 8846FE                   mov byte [bp-2], al
  1484                                  
  1485                                  ;-121   if (RegType !=WORD) indexerror();
  1486                                  
  1487 0000077F A0[3E00]                 mov al, [RegType]
  1488 00000782 3C02                     cmp al, 2
  1489 00000784 0F840300                 je  @@getIndReg144
  1490 00000788 E84911                   call indexerror
  1491                                  
  1492                                  ;-122   if (RegNo==3) m=7;//BX
  1493                                  
  1494                                  @@getIndReg144:
  1495 0000078B A0[3F00]                 mov al, [RegNo]
  1496 0000078E 3C03                     cmp al, 3
  1497 00000790 0F850900                 jne @@getIndReg145
  1498 00000794 66B807000000             mov eax, 7
  1499 0000079A 8846FE                   mov byte [bp-2], al
  1500                                  
  1501                                  ;-123   if (RegNo==5) m=6;//BP change to BP+0
  1502                                  
  1503                                  @@getIndReg145:
  1504 0000079D A0[3F00]                 mov al, [RegNo]
  1505 000007A0 3C05                     cmp al, 5
  1506 000007A2 0F850900                 jne @@getIndReg146
  1507 000007A6 66B806000000             mov eax, 6
  1508 000007AC 8846FE                   mov byte [bp-2], al
  1509                                  
  1510                                  ;-124   if (RegNo==7) m=5;//DI
  1511                                  
  1512                                  @@getIndReg146:
  1513 000007AF A0[3F00]                 mov al, [RegNo]
  1514 000007B2 3C07                     cmp al, 7
  1515 000007B4 0F850900                 jne @@getIndReg147
  1516 000007B8 66B805000000             mov eax, 5
  1517 000007BE 8846FE                   mov byte [bp-2], al
  1518                                  
  1519                                  ;-125   if (RegNo==6) m=4;//SI
  1520                                  
  1521                                  @@getIndReg147:
  1522 000007C1 A0[3F00]                 mov al, [RegNo]
  1523 000007C4 3C06                     cmp al, 6
  1524 000007C6 0F850900                 jne @@getIndReg148
  1525 000007CA 66B804000000             mov eax, 4
  1526 000007D0 8846FE                   mov byte [bp-2], al
  1527                                  
  1528                                  ;-126   if (m    ==0) indexerror();
  1529                                  
  1530                                  @@getIndReg148:
  1531 000007D3 8A46FE                   mov al, [bp-2]
  1532 000007D6 3C00                     cmp al, 0
  1533 000007D8 0F850300                 jne @@getIndReg149
  1534 000007DC E8F510                   call indexerror
  1535                                  
  1536                                  ;-127   return m;
  1537                                  
  1538                                  @@getIndReg149:
  1539 000007DF 8A46FE                   mov al, [bp-2]
  1540 000007E2 E90000                   jmp @@retn
  1541                                  
  1542                                  ;-128 }
  1543                                  
  1544                                  
  1545                                  ;-129 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1546                                  
  1547 000007E5 C9                      @@retn: LEAVE
  1548 000007E6 C3                       ret
  1549                                  ; ENDP
  1550                                  
  1551                                  getIndReg2:  ; *** PROC ***
  1552                                  ;Function : getIndReg2, Number of local variables: 2
  1553                                  ;   # type sign width line used address name   list of local variables
  1554                                  ;  200 var sign byte   129 NULL bp+4    r1
  1555                                  ;  201 var sign byte   129 NULL bp-2    m;
  1556 000007E7 C8020000                 ENTER  2,0
  1557 000007EB 66B804000000             mov eax, 4
  1558 000007F1 8846FE                   mov byte [bp-2], al
  1559                                  
  1560                                  ;-130   if (RegType !=WORD) indexerror();
  1561                                  
  1562 000007F4 A0[3E00]                 mov al, [RegType]
  1563 000007F7 3C02                     cmp al, 2
  1564 000007F9 0F840300                 je  @@getIndReg250
  1565 000007FD E8D410                   call indexerror
  1566                                  
  1567                                  ;-131   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1568                                  
  1569                                  @@getIndReg250:
  1570 00000800 A0[3F00]                 mov al, [RegNo]
  1571 00000803 3C07                     cmp al, 7
  1572 00000805 0F852700                 jne @@getIndReg251
  1573 00000809 8A4604                   mov al, [bp+4]
  1574 0000080C 3C06                     cmp al, 6
  1575 0000080E 0F850C00                 jne @@getIndReg252
  1576 00000812 66B803000000             mov eax, 3
  1577 00000818 8846FE                   mov byte [bp-2], al
  1578                                  
  1579                                  ;-132            else if (r1==7) m=1;//BX+DI
  1580                                  
  1581 0000081B E91200                   jmp @@getIndReg253
  1582                                  @@getIndReg252:
  1583 0000081E 8A4604                   mov al, [bp+4]
  1584 00000821 3C07                     cmp al, 7
  1585 00000823 0F850900                 jne @@getIndReg254
  1586 00000827 66B801000000             mov eax, 1
  1587 0000082D 8846FE                   mov byte [bp-2], al
  1588                                  
  1589                                  ;-133   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1590                                  
  1591                                  @@getIndReg254:
  1592                                  @@getIndReg253:
  1593                                  @@getIndReg251:
  1594 00000830 A0[3F00]                 mov al, [RegNo]
  1595 00000833 3C06                     cmp al, 6
  1596 00000835 0F852700                 jne @@getIndReg255
  1597 00000839 8A4604                   mov al, [bp+4]
  1598 0000083C 3C06                     cmp al, 6
  1599 0000083E 0F850C00                 jne @@getIndReg256
  1600 00000842 66B802000000             mov eax, 2
  1601 00000848 8846FE                   mov byte [bp-2], al
  1602                                  
  1603                                  ;-134            else if (r1==7) m=0;//BX+DI
  1604                                  
  1605 0000084B E91200                   jmp @@getIndReg257
  1606                                  @@getIndReg256:
  1607 0000084E 8A4604                   mov al, [bp+4]
  1608 00000851 3C07                     cmp al, 7
  1609 00000853 0F850900                 jne @@getIndReg258
  1610 00000857 66B800000000             mov eax, 0
  1611 0000085D 8846FE                   mov byte [bp-2], al
  1612                                  
  1613                                  ;-135   if (m > 3) indexerror();
  1614                                  
  1615                                  @@getIndReg258:
  1616                                  @@getIndReg257:
  1617                                  @@getIndReg255:
  1618 00000860 8A46FE                   mov al, [bp-2]
  1619 00000863 3C03                     cmp al, 3
  1620 00000865 0F8E0300                 jle @@getIndReg259
  1621 00000869 E86810                   call indexerror
  1622                                  
  1623                                  ;-136   return m;
  1624                                  
  1625                                  @@getIndReg259:
  1626 0000086C 8A46FE                   mov al, [bp-2]
  1627 0000086F E90000                   jmp @@retn
  1628                                  
  1629                                  ;-137 }
  1630                                  
  1631                                  
  1632                                  ;-138 
  1633                                  
  1634                                  
  1635                                  ;-139 // generate code ...........................................................
  1636                                  
  1637                                  
  1638                                  ;-140 int gen66h() {genCode8(0x66);}
  1639                                  
  1640 00000872 C9                      @@retn: LEAVE
  1641 00000873 C3                       ret
  1642                                  ; ENDP
  1643                                  
  1644                                  gen66h:  ; *** PROC ***
  1645 00000874 6A66                     push 102
  1646 00000876 E80400                   call genCode8
  1647 00000879 83C402                   add  sp, 2
  1648                                  
  1649                                  ;-141 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  1650                                  
  1651 0000087C C3                       ret
  1652                                  ; ENDP
  1653                                  
  1654                                  genCode8:  ; *** PROC ***
  1655                                  
  1656                                  ;-142   FileBin[BinLen]=c; BinLen++; PC++;
  1657                                  
  1658                                  ;Function : genCode8, Number of local variables: 1
  1659                                  ;   # type sign width line used address name   list of local variables
  1660                                  ;  200 var sign byte   141 NULL bp+4    c;
  1661 0000087D C8000000                 ENTER  0,0
  1662 00000881 8A4604                   mov al, [bp+4]
  1663 00000884 8B1E[5400]               mov bx, [BinLen]
  1664 00000888 88876C7B                 mov [FileBin+bx], al
  1665 0000088C FF06[5400]               inc  word [BinLen]
  1666 00000890 FF06[3600]               inc  word [PC]
  1667                                  
  1668                                  ;-143   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
  1669                                  
  1670 00000894 A1[4900]                 mov ax, [OpPrintIndex]
  1671 00000897 83F805                   cmp ax, 5
  1672 0000089A 0F8D0F00                 jge @@genCode860
  1673 0000089E 8A4604                   mov al, [bp+4]
  1674 000008A1 8B1E[4900]               mov bx, [OpPrintIndex]
  1675 000008A5 8887B776                 mov [OpPos+bx], al
  1676 000008A9 FF06[4900]               inc  word [OpPrintIndex]
  1677                                  
  1678                                  ;-144 }
  1679                                  
  1680                                  @@genCode860:
  1681                                  
  1682                                  ;-145 int genCode16(int i) {
  1683 000008AD C9                       LEAVE
  1684 000008AE C3                       ret
  1685                                  ; ENDP
  1686                                  
  1687                                  genCode16:  ; *** PROC ***
  1688                                  
  1689                                  ;-146   genCode8(i); i=i >> 8; genCode8(i);
  1690                                  
  1691                                  ;Function : genCode16, Number of local variables: 1
  1692                                  ;   # type sign width line used address name   list of local variables
  1693                                  ;  200 var sign word   145 NULL bp+4    i;
  1694 000008AF C8000000                 ENTER  0,0
  1695 000008B3 FF7604                   push word [bp+4]
  1696 000008B6 E8C4FF                   call genCode8
  1697 000008B9 83C402                   add  sp, 2
  1698 000008BC 8B4604                   mov ax, [bp+4]
  1699 000008BF C1E808                   shr ax, 8
  1700 000008C2 894604                   mov word [bp+4], ax
  1701 000008C5 FF7604                   push word [bp+4]
  1702 000008C8 E8B2FF                   call genCode8
  1703 000008CB 83C402                   add  sp, 2
  1704                                  
  1705                                  ;-147 }
  1706                                  
  1707                                  
  1708                                  ;-148 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  1709 000008CE C9                       LEAVE
  1710 000008CF C3                       ret
  1711                                  ; ENDP
  1712                                  
  1713                                  genInstruction:  ; *** PROC ***
  1714                                  
  1715                                  ;-149   if(loc) OpCodePtr=OpCodePtr+loc;
  1716                                  
  1717                                  ;Function : genInstruction, Number of local variables: 3
  1718                                  ;   # type sign width line used address name   list of local variables
  1719                                  ;  200 var sign byte   148 NULL bp+4    No
  1720                                  ;  201 var sign word   148 NULL bp+6    loc
  1721                                  ;  202 var sign byte   148 NULL bp-2    c;
  1722 000008D0 C8020000                 ENTER  2,0
  1723 000008D4 8B4606                   mov ax, [bp+6]
  1724 000008D7 08C0                     or  al, al
  1725 000008D9 0F840900                 je @@genInstruction61
  1726 000008DD A1[4B00]                 mov ax, [OpCodePtr]
  1727 000008E0 034606                   add ax, [bp+6]
  1728 000008E3 A3[4B00]                 mov word [OpCodePtr], ax
  1729                                  
  1730                                  ;-150   c= *OpCodePtr + No; genCode8(c);
  1731                                  
  1732                                  @@genInstruction61:
  1733 000008E6 8B1E[4B00]               mov bx, [OpCodePtr]
  1734 000008EA 8A07                     mov al, [bx]
  1735 000008EC B400                     mov ah, 0
  1736 000008EE 024604                   add al, [bp+4]
  1737 000008F1 8846FE                   mov byte [bp-2], al
  1738 000008F4 8A46FE                   mov al, byte [bp-2]
  1739 000008F7 B400                     mov ah, 0
  1740 000008F9 50                       push ax
  1741 000008FA E880FF                   call genCode8
  1742 000008FD 83C402                   add  sp, 2
  1743                                  
  1744                                  ;-151 }
  1745                                  
  1746                                  
  1747                                  ;-152 int genCodeInREG() {char x; //get Code for second byte
  1748 00000900 C9                       LEAVE
  1749 00000901 C3                       ret
  1750                                  ; ENDP
  1751                                  
  1752                                  genCodeInREG:  ; *** PROC ***
  1753                                  
  1754                                  ;-153   OpCodePtr++; x= *OpCodePtr; writeEA(x);
  1755                                  
  1756                                  ;Function : genCodeInREG, Number of local variables: 1
  1757                                  ;   # type sign width line used address name   list of local variables
  1758                                  ;  200 var sign byte   152 NULL bp-2    x;
  1759 00000902 C8020000                 ENTER  2,0
  1760 00000906 FF06[4B00]               inc  word [OpCodePtr]
  1761 0000090A 8B1E[4B00]               mov bx, [OpCodePtr]
  1762 0000090E 8A07                     mov al, [bx]
  1763 00000910 B400                     mov ah, 0
  1764 00000912 8846FE                   mov byte [bp-2], al
  1765 00000915 8A46FE                   mov al, byte [bp-2]
  1766 00000918 B400                     mov ah, 0
  1767 0000091A 50                       push ax
  1768 0000091B E81200                   call writeEA
  1769 0000091E 83C402                   add  sp, 2
  1770                                  
  1771                                  ;-154 }
  1772                                  
  1773                                  
  1774                                  ;-155 int genModRegRM(){ writeEA(reg);//todo
  1775 00000921 C9                       LEAVE
  1776 00000922 C3                       ret
  1777                                  ; ENDP
  1778                                  
  1779                                  genModRegRM:  ; *** PROC ***
  1780 00000923 A0[4400]                 mov al, byte [reg]
  1781 00000926 B400                     mov ah, 0
  1782 00000928 50                       push ax
  1783 00000929 E80400                   call writeEA
  1784 0000092C 83C402                   add  sp, 2
  1785                                  
  1786                                  ;-156 }
  1787                                  
  1788                                  
  1789                                  ;-157 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  1790                                  
  1791 0000092F C3                       ret
  1792                                  ; ENDP
  1793                                  
  1794                                  writeEA:  ; *** PROC ***
  1795                                  
  1796                                  ;-158   len=0;
  1797                                  
  1798                                  ;Function : writeEA, Number of local variables: 2
  1799                                  ;   # type sign width line used address name   list of local variables
  1800                                  ;  200 var sign byte   157 NULL bp+4    xxx
  1801                                  ;  201 var sign byte   157 NULL bp-2    len;
  1802 00000930 C8020000                 ENTER  2,0
  1803 00000934 66B800000000             mov eax, 0
  1804 0000093A 8846FE                   mov byte [bp-2], al
  1805                                  
  1806                                  ;-159   xxx = xxx << 3;//in reg field of mod r/m
  1807                                  
  1808 0000093D 8A4604                   mov al, [bp+4]
  1809 00000940 C0E003                   shl al, 3
  1810 00000943 884604                   mov byte [bp+4], al
  1811                                  
  1812                                  ;-160   if (Op1 ==   0) addrexit();
  1813                                  
  1814 00000946 A0[3C00]                 mov al, [Op1]
  1815 00000949 3C00                     cmp al, 0
  1816 0000094B 0F850300                 jne @@writeEA62
  1817 0000094F E83610                   call addrexit
  1818                                  
  1819                                  ;-161   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  1820                                  
  1821                                  @@writeEA62:
  1822 00000952 A0[3C00]                 mov al, [Op1]
  1823 00000955 3C02                     cmp al, 2
  1824 00000957 0F850E00                 jne @@writeEA63
  1825 0000095B 804E04C0                 or  byte [bp+4], 192
  1826 0000095F 8A4604                   mov al, [bp+4]
  1827 00000962 0206[3F00]               add al, [RegNo]
  1828 00000966 884604                   mov byte [bp+4], al
  1829                                  
  1830                                  ;-162   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  1831                                  
  1832                                  @@writeEA63:
  1833 00000969 A0[3C00]                 mov al, [Op1]
  1834 0000096C 3C03                     cmp al, 3
  1835 0000096E 0F850D00                 jne @@writeEA64
  1836 00000972 804E0406                 or  byte [bp+4], 6
  1837 00000976 66B802000000             mov eax, 2
  1838 0000097C 8846FE                   mov byte [bp-2], al
  1839                                  
  1840                                  ;-163   if (Op1 == IND) { xxx = xxx + reg;                       //4
  1841                                  
  1842                                  @@writeEA64:
  1843 0000097F A0[3C00]                 mov al, [Op1]
  1844 00000982 3C04                     cmp al, 4
  1845 00000984 0F854600                 jne @@writeEA65
  1846 00000988 8A4604                   mov al, [bp+4]
  1847 0000098B 0206[4400]               add al, [reg]
  1848 0000098F 884604                   mov byte [bp+4], al
  1849                                  
  1850                                  ;-164     if (disp) {disp; if(ax > 127) len=2; else len=1;
  1851                                  
  1852 00000992 A1[4500]                 mov ax, [disp]
  1853 00000995 08C0                     or  al, al
  1854 00000997 0F843300                 je @@writeEA66
  1855 0000099B A1[4500]                 mov ax, [disp]
  1856 0000099E 83F87F                   cmp  ax, 127
  1857 000009A1 0F8E0C00                 jle @@writeEA67
  1858 000009A5 66B802000000             mov eax, 2
  1859 000009AB 8846FE                   mov byte [bp-2], al
  1860 000009AE E90900                   jmp @@writeEA68
  1861                                  @@writeEA67:
  1862 000009B1 66B801000000             mov eax, 1
  1863 000009B7 8846FE                   mov byte [bp-2], al
  1864                                  
  1865                                  ;-165       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
  1866                                  
  1867                                  @@writeEA68:
  1868 000009BA 8A46FE                   mov al, [bp-2]
  1869 000009BD 3C01                     cmp al, 1
  1870 000009BF 0F850700                 jne @@writeEA69
  1871 000009C3 804E0440                 or  byte [bp+4], 64
  1872 000009C7 E90400                   jmp @@writeEA70
  1873                                  @@writeEA69:
  1874 000009CA 804E0480                 or  byte [bp+4], 128
  1875                                  @@writeEA70:
  1876                                  
  1877                                  ;-166     }
  1878                                  
  1879                                  @@writeEA66:
  1880                                  
  1881                                  ;-167   genCode8(xxx);// gen second byte
  1882                                  
  1883                                  @@writeEA65:
  1884 000009CE 8A4604                   mov al, byte [bp+4]
  1885 000009D1 B400                     mov ah, 0
  1886 000009D3 50                       push ax
  1887 000009D4 E8A6FE                   call genCode8
  1888 000009D7 83C402                   add  sp, 2
  1889                                  
  1890                                  ;-168   if (len == 1) genCode8 (disp);
  1891                                  
  1892 000009DA 8A46FE                   mov al, [bp-2]
  1893 000009DD 3C01                     cmp al, 1
  1894 000009DF 0F850A00                 jne @@writeEA71
  1895 000009E3 FF36[4500]               push word [disp]
  1896 000009E7 E893FE                   call genCode8
  1897 000009EA 83C402                   add  sp, 2
  1898                                  
  1899                                  ;-169   if (len == 2) genCode16(disp);
  1900                                  
  1901                                  @@writeEA71:
  1902 000009ED 8A46FE                   mov al, [bp-2]
  1903 000009F0 3C02                     cmp al, 2
  1904 000009F2 0F850A00                 jne @@writeEA72
  1905 000009F6 FF36[4500]               push word [disp]
  1906 000009FA E8B2FE                   call genCode16
  1907 000009FD 83C402                   add  sp, 2
  1908                                  
  1909                                  ;-170 }
  1910                                  
  1911                                  @@writeEA72:
  1912                                  
  1913                                  ;-171 int test1() { __asm {
  1914 00000A00 C9                       LEAVE
  1915 00000A01 C3                       ret
  1916                                  ; ENDP
  1917                                  
  1918                                  test1:  ; *** PROC ***
  1919                                  
  1920                                  
  1921                                  ;-172 inc byte [Version1]   ;FE 06 [1000]
  1922                                  
  1923 00000A02 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  1924                                  
  1925                                  ;-173 add bx, ax    ;01 C3
  1926                                  
  1927 00000A06 01C3                    add bx, ax    ;01 C3
  1928                                  
  1929                                  ;-174 add ax, bx    ;01 D8
  1930                                  
  1931 00000A08 01D8                    add ax, bx    ;01 D8
  1932                                  
  1933                                  ;-175 add word ax, [bx] ;03 07
  1934                                  
  1935 00000A0A 0307                    add word ax, [bx] ;03 07
  1936                                  
  1937                                  ;-176 VA dw 8
  1938                                  
  1939 00000A0C 0800                    VA dw 8
  1940                                  
  1941                                  ;-177 mov byte [bp- 4], al ;88 46 FC
  1942                                  
  1943 00000A0E 8846FC                  mov byte [bp- 4], al ;88 46 FC
  1944                                  
  1945                                  ;-178 mov      [VA+bx], al ;88 87 [300F]
  1946                                  
  1947 00000A11 8887[0C0A]              mov      [VA+bx], al ;88 87 [300F]
  1948                                  
  1949                                  ;-179 }  }
  1950                                  
  1951                                  
  1952                                  
  1953                                  ;-180 //#include "AS1.C"
  1954                                  
  1955                                  
  1956                                  ;-181 #include "PARSE.C"
  1957                                  
  1958 00000A15 C3                       ret
  1959                                  ; ENDP
  1960                                  ;Use include file: PARSE.C
  1961                                  
  1962                                  ;-1 int parse() {
  1963                                  
  1964                                  
  1965                                  parse:  ; *** PROC ***
  1966                                  
  1967                                  ;-2   LabelNamePtr= &LabelNames;
  1968                                  
  1969 00000A16 B8BC76                   mov ax, LabelNames
  1970 00000A19 A3[4E00]                 mov word [LabelNamePtr], ax
  1971                                  
  1972                                  ;-3   do {
  1973                                  
  1974                                  @@parse73:
  1975                                  
  1976                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  1977                                  
  1978 00000A1C A1[3600]                 mov ax, [PC]
  1979 00000A1F A3[3800]                 mov word [PCStart], ax
  1980 00000A22 66B800000000             mov eax, 0
  1981 00000A28 A2[4000]                 mov byte [OpSize], al
  1982 00000A2B 66B800000000             mov eax, 0
  1983 00000A31 A3[4900]                 mov word [OpPrintIndex], ax
  1984 00000A34 66B820000000             mov eax, 32
  1985 00000A3A A2[4D00]                 mov byte [PrReloc], al
  1986                                  
  1987                                  ;-5     getLine();
  1988                                  
  1989 00000A3D E8A304                   call getLine
  1990                                  
  1991                                  ;-6     InputPtr = &InputBuf;
  1992                                  
  1993 00000A40 B86E75                   mov ax, InputBuf
  1994 00000A43 A3[2700]                 mov word [InputPtr], ax
  1995                                  
  1996                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1997                                  
  1998 00000A46 E8B700                   call getTokeType
  1999                                  
  2000                                  ;-8     if (TokeType == ALNUME) {
  2001                                  
  2002 00000A49 A0[3B00]                 mov al, [TokeType]
  2003 00000A4C 3C03                     cmp al, 3
  2004 00000A4E 0F851300                 jne @@parse74
  2005                                  
  2006                                  ;-9       if (isLabel) { //set in getName
  2007                                  
  2008 00000A52 A0[3A00]                 mov al, [isLabel]
  2009 00000A55 08C0                     or  al, al
  2010 00000A57 0F840A00                 je @@parse75
  2011                                  
  2012                                  ;-10         storeLabel();
  2013                                  
  2014 00000A5B E84001                   call storeLabel
  2015                                  
  2016                                  ;-11         InputPtr++;//remove :
  2017                                  
  2018 00000A5E FF06[2700]               inc  word [InputPtr]
  2019                                  
  2020                                  ;-12         getTokeType();
  2021                                  
  2022 00000A62 E89B00                   call getTokeType
  2023                                  
  2024                                  ;-13       }
  2025                                  
  2026                                  
  2027                                  ;-14     }
  2028                                  
  2029                                  @@parse75:
  2030                                  
  2031                                  ;-15     if (TokeType == ALNUME) {
  2032                                  
  2033                                  @@parse74:
  2034 00000A65 A0[3B00]                 mov al, [TokeType]
  2035 00000A68 3C03                     cmp al, 3
  2036 00000A6A 0F851B00                 jne @@parse76
  2037                                  
  2038                                  ;-16       lookCode();// and OpCodePtr
  2039                                  
  2040 00000A6E E80F03                   call lookCode
  2041                                  
  2042                                  ;-17       if(CodeType) process();
  2043                                  
  2044 00000A71 A0[3D00]                 mov al, [CodeType]
  2045 00000A74 08C0                     or  al, al
  2046 00000A76 0F840600                 je @@parse77
  2047 00000A7A E88EF8                   call process
  2048                                  
  2049                                  ;-18       else getVariable();
  2050                                  
  2051 00000A7D E90300                   jmp @@parse78
  2052                                  @@parse77:
  2053 00000A80 E8C501                   call getVariable
  2054                                  
  2055                                  ;-19       skipRest();
  2056                                  
  2057                                  @@parse78:
  2058 00000A83 E82504                   call skipRest
  2059                                  
  2060                                  ;-20     }
  2061                                  
  2062                                  
  2063                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2064                                  
  2065 00000A86 E92700                   jmp @@parse79
  2066                                  @@parse76:
  2067 00000A89 A0[3B00]                 mov al, [TokeType]
  2068 00000A8C 3C03                     cmp al, 3
  2069 00000A8E 0F8E0C00                 jle @@parse80
  2070 00000A92 68[C10A]                 push parse_0
  2071 00000A95 E8A80D                   call error1
  2072 00000A98 83C402                   add  sp, 2
  2073                                  
  2074                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2075                                  
  2076 00000A9B E91200                   jmp @@parse81
  2077                                  @@parse80:
  2078 00000A9E A0[3B00]                 mov al, [TokeType]
  2079 00000AA1 3C01                     cmp al, 1
  2080 00000AA3 0F850900                 jne @@parse82
  2081 00000AA7 68[DF0A]                 push parse_1
  2082 00000AAA E8930D                   call error1
  2083 00000AAD 83C402                   add  sp, 2
  2084                                  
  2085                                  ;-23     printLine();
  2086                                  
  2087                                  @@parse82:
  2088                                  @@parse81:
  2089                                  @@parse79:
  2090 00000AB0 E8220B                   call printLine
  2091                                  
  2092                                  ;-24   } while (DOS_NoBytes != 0 );
  2093                                  
  2094 00000AB3 A1[3300]                 mov ax, [DOS_NoBytes]
  2095 00000AB6 83F800                   cmp ax, 0
  2096 00000AB9 0F840300                 je  @@parse83
  2097 00000ABD E95CFF                   jmp @@parse73
  2098                                  @@parse83:
  2099                                  
  2100                                  ;-25 }
  2101                                  
  2102                                  
  2103                                  ;-26 // scan code .....................................
  2104                                  
  2105                                  
  2106                                  ;-27 int getTokeType() { char c;
  2107                                  
  2108 00000AC0 C3                       ret
  2109                                  ; ENDP
  2110 00000AC1 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2111 00000ACA 696E73747275637469-
  2112 00000AD3 6F6E20657870656374-
  2113 00000ADC 656400             
  2114 00000ADF 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2115 00000AE8 616C6C6F7765642040-
  2116 00000AF1 207374617274206F66-
  2117 00000AFA 206C696E6500       
  2118                                  
  2119                                  getTokeType:  ; *** PROC ***
  2120                                  
  2121                                  ;-28   skipBlank();
  2122                                  
  2123                                  ;Function : getTokeType, Number of local variables: 1
  2124                                  ;   # type sign width line used address name   list of local variables
  2125                                  ;  200 var sign byte    27 NULL bp-2    c;
  2126 00000B00 C8020000                 ENTER  2,0
  2127 00000B04 E8A904                   call skipBlank
  2128                                  
  2129                                  ;-29   c = *InputPtr;
  2130                                  
  2131 00000B07 8B1E[2700]               mov bx, [InputPtr]
  2132 00000B0B 8A07                     mov al, [bx]
  2133 00000B0D B400                     mov ah, 0
  2134 00000B0F 8846FE                   mov byte [bp-2], al
  2135                                  
  2136                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2137                                  
  2138 00000B12 8A46FE                   mov al, [bp-2]
  2139 00000B15 3C00                     cmp al, 0
  2140 00000B17 0F850C00                 jne @@getTokeType84
  2141 00000B1B 66B800000000             mov eax, 0
  2142 00000B21 A2[3B00]                 mov byte [TokeType], al
  2143 00000B24 E97500                   jmp @@retn
  2144                                  
  2145                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2146                                  
  2147                                  @@getTokeType84:
  2148 00000B27 8A46FE                   mov al, [bp-2]
  2149 00000B2A 3C3B                     cmp al, 59
  2150 00000B2C 0F850C00                 jne @@getTokeType85
  2151 00000B30 66B800000000             mov eax, 0
  2152 00000B36 A2[3B00]                 mov byte [TokeType], al
  2153 00000B39 E96000                   jmp @@retn
  2154                                  
  2155                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2156                                  
  2157                                  @@getTokeType85:
  2158 00000B3C 8A46FE                   mov al, byte [bp-2]
  2159 00000B3F B400                     mov ah, 0
  2160 00000B41 50                       push ax
  2161 00000B42 E84F13                   call digit
  2162 00000B45 83C402                   add  sp, 2
  2163 00000B48 08C0                     or  al, al
  2164 00000B4A 0F841800                 je @@getTokeType86
  2165 00000B4E 8A46FE                   mov al, byte [bp-2]
  2166 00000B51 B400                     mov ah, 0
  2167 00000B53 50                       push ax
  2168 00000B54 E85F05                   call getDigit
  2169 00000B57 83C402                   add  sp, 2
  2170 00000B5A 66B801000000             mov eax, 1
  2171 00000B60 A2[3B00]                 mov byte [TokeType], al
  2172 00000B63 E93600                   jmp @@retn
  2173                                  
  2174                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2175                                  
  2176                                  @@getTokeType86:
  2177 00000B66 8A46FE                   mov al, byte [bp-2]
  2178 00000B69 B400                     mov ah, 0
  2179 00000B6B 50                       push ax
  2180 00000B6C E86C04                   call letterE
  2181 00000B6F 83C402                   add  sp, 2
  2182 00000B72 08C0                     or  al, al
  2183 00000B74 0F841800                 je @@getTokeType87
  2184 00000B78 8A46FE                   mov al, byte [bp-2]
  2185 00000B7B B400                     mov ah, 0
  2186 00000B7D 50                       push ax
  2187 00000B7E E88C05                   call getName
  2188 00000B81 83C402                   add  sp, 2
  2189 00000B84 66B803000000             mov eax, 3
  2190 00000B8A A2[3B00]                 mov byte [TokeType], al
  2191 00000B8D E90C00                   jmp @@retn
  2192                                  
  2193                                  ;-34   TokeType=NOALNUME; return;
  2194                                  
  2195                                  @@getTokeType87:
  2196 00000B90 66B804000000             mov eax, 4
  2197 00000B96 A2[3B00]                 mov byte [TokeType], al
  2198 00000B99 E90000                   jmp @@retn
  2199                                  
  2200                                  ;-35 }
  2201                                  
  2202                                  
  2203                                  ;-36 int storeLabel() {
  2204                                  
  2205 00000B9C C9                      @@retn: LEAVE
  2206 00000B9D C3                       ret
  2207                                  ; ENDP
  2208                                  
  2209                                  storeLabel:  ; *** PROC ***
  2210                                  
  2211                                  ;-37   if(searchLabel()) error1("duplicate label");
  2212                                  
  2213 00000B9E E84700                   call searchLabel
  2214 00000BA1 08C0                     or  al, al
  2215 00000BA3 0F840900                 je @@storeLabel88
  2216 00000BA7 68[D80B]                 push storeLabel_0
  2217 00000BAA E8930C                   call error1
  2218 00000BAD 83C402                   add  sp, 2
  2219                                  
  2220                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2221                                  
  2222                                  @@storeLabel88:
  2223 00000BB0 8D063075                 lea  ax, [Symbol]
  2224 00000BB4 50                       push ax
  2225 00000BB5 FF36[4E00]               push word [LabelNamePtr]
  2226 00000BB9 E89F12                   call strcpy
  2227 00000BBC 83C404                   add  sp, 4
  2228 00000BBF A3[4E00]                 mov word [LabelNamePtr], ax
  2229                                  
  2230                                  ;-39   LabelNamePtr++;
  2231                                  
  2232 00000BC2 FF06[4E00]               inc  word [LabelNamePtr]
  2233                                  
  2234                                  ;-40   LabelMaxIx++;
  2235                                  
  2236 00000BC6 FF06[5000]               inc  word [LabelMaxIx]
  2237                                  
  2238                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2239                                  
  2240 00000BCA A1[3600]                 mov ax, [PC]
  2241 00000BCD 8B1E[5000]               mov bx, [LabelMaxIx]
  2242 00000BD1 D1E3                     shl bx, 1
  2243 00000BD3 8987A47A                 mov [LabelAddr+bx], ax
  2244                                  
  2245                                  ;-42 }
  2246                                  
  2247                                  
  2248                                  ;-43 int searchLabel() {
  2249                                  
  2250 00000BD7 C3                       ret
  2251                                  ; ENDP
  2252 00000BD8 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2253 00000BE1 206C6162656C00     
  2254                                  
  2255                                  searchLabel:  ; *** PROC ***
  2256                                  
  2257                                  ;-44   int LIx; char *p; int j;
  2258                                  
  2259                                  
  2260                                  ;-45   p = &LabelNames;
  2261                                  
  2262                                  ;Function : searchLabel, Number of local variables: 3
  2263                                  ;   # type sign width line used address name   list of local variables
  2264                                  ;  200 var sign word    44 NULL bp-2    LIx
  2265                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2266                                  ;  202 var sign word    44 NULL bp-6    j;
  2267 00000BE8 C8060000                 ENTER  6,0
  2268 00000BEC B8BC76                   mov ax, LabelNames
  2269 00000BEF 8946FC                   mov word [bp-4], ax
  2270                                  
  2271                                  ;-46   LIx=1;
  2272                                  
  2273 00000BF2 66B801000000             mov eax, 1
  2274 00000BF8 8946FE                   mov word [bp-2], ax
  2275                                  
  2276                                  ;-47   while (LIx <= LabelMaxIx) {
  2277                                  
  2278                                  @@searchLabel89:
  2279 00000BFB 8B46FE                   mov ax, [bp-2]
  2280 00000BFE 3B06[5000]               cmp ax, [LabelMaxIx]
  2281 00000C02 0F8F3700                 jg  @@searchLabel90
  2282                                  
  2283                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2284                                  
  2285 00000C06 8D063075                 lea  ax, [Symbol]
  2286 00000C0A 50                       push ax
  2287 00000C0B FF76FC                   push word [bp-4]
  2288 00000C0E E8B612                   call eqstr
  2289 00000C11 83C404                   add  sp, 4
  2290 00000C14 08C0                     or  al, al
  2291 00000C16 0F840600                 je @@searchLabel91
  2292 00000C1A 8B46FE                   mov ax, [bp-2]
  2293 00000C1D E92600                   jmp @@retn
  2294                                  
  2295                                  ;-49     j=strlen(p);
  2296                                  
  2297                                  @@searchLabel91:
  2298 00000C20 FF76FC                   push word [bp-4]
  2299 00000C23 E80A12                   call strlen
  2300 00000C26 83C402                   add  sp, 2
  2301 00000C29 8946FA                   mov word [bp-6], ax
  2302                                  
  2303                                  ;-50     p=p+j; p++; LIx++;
  2304                                  
  2305 00000C2C 8B46FC                   mov ax, [bp-4]
  2306 00000C2F 0346FA                   add ax, [bp-6]
  2307 00000C32 8946FC                   mov word [bp-4], ax
  2308 00000C35 FF46FC                   inc  word [bp-4]
  2309 00000C38 FF46FE                   inc  word [bp-2]
  2310                                  
  2311                                  ;-51   }
  2312                                  
  2313                                  
  2314                                  ;-52   return 0;
  2315                                  
  2316 00000C3B EBBE                     jmp @@searchLabel89
  2317                                  @@searchLabel90:
  2318 00000C3D 66B800000000             mov eax, 0
  2319 00000C43 E90000                   jmp @@retn
  2320                                  
  2321                                  ;-53 }
  2322                                  
  2323                                  
  2324                                  ;-54 int getVariable() { char c;
  2325                                  
  2326 00000C46 C9                      @@retn: LEAVE
  2327 00000C47 C3                       ret
  2328                                  ; ENDP
  2329                                  
  2330                                  getVariable:  ; *** PROC ***
  2331                                  
  2332                                  ;-55   storeLabel();
  2333                                  
  2334                                  ;Function : getVariable, Number of local variables: 1
  2335                                  ;   # type sign width line used address name   list of local variables
  2336                                  ;  200 var sign byte    54 NULL bp-2    c;
  2337 00000C48 C8020000                 ENTER  2,0
  2338 00000C4C E84FFF                   call storeLabel
  2339                                  
  2340                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2341                                  
  2342 00000C4F E8AEFE                   call getTokeType
  2343 00000C52 A0[3B00]                 mov al, [TokeType]
  2344 00000C55 3C03                     cmp al, 3
  2345 00000C57 0F85CC00                 jne @@getVariable92
  2346                                  
  2347                                  ;-57     lookCode();
  2348                                  
  2349 00000C5B E82201                   call lookCode
  2350                                  
  2351                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2352                                  
  2353 00000C5E A0[3D00]                 mov al, [CodeType]
  2354 00000C61 3CC8                     cmp al, 200
  2355 00000C63 0F8D0900                 jge @@getVariable93
  2356 00000C67 68[320D]                 push getVariable_0
  2357 00000C6A E8040D                   call errorexit
  2358 00000C6D 83C402                   add  sp, 2
  2359                                  
  2360                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2361                                  
  2362                                  @@getVariable93:
  2363 00000C70 A0[3D00]                 mov al, [CodeType]
  2364 00000C73 3CCF                     cmp al, 207
  2365 00000C75 0F8E0900                 jle @@getVariable94
  2366 00000C79 68[4A0D]                 push getVariable_1
  2367 00000C7C E8F20C                   call errorexit
  2368 00000C7F 83C402                   add  sp, 2
  2369                                  
  2370                                  ;-60     if (CodeType== 200) {// DB
  2371                                  
  2372                                  @@getVariable94:
  2373 00000C82 A0[3D00]                 mov al, [CodeType]
  2374 00000C85 3CC8                     cmp al, 200
  2375 00000C87 0F856A00                 jne @@getVariable95
  2376                                  
  2377                                  ;-61       do { getTokeType();
  2378                                  
  2379                                  @@getVariable96:
  2380 00000C8B E872FE                   call getTokeType
  2381                                  
  2382                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2383                                  
  2384 00000C8E A0[3B00]                 mov al, [TokeType]
  2385 00000C91 3C01                     cmp al, 1
  2386 00000C93 0F850D00                 jne @@getVariable97
  2387 00000C97 FF36[2500]               push word [SymbolInt]
  2388 00000C9B E8DFFB                   call genCode8
  2389 00000C9E 83C402                   add  sp, 2
  2390                                  
  2391                                  ;-63         else {
  2392                                  
  2393 00000CA1 E94100                   jmp @@getVariable98
  2394                                  @@getVariable97:
  2395                                  
  2396                                  ;-64           skipBlank();
  2397                                  
  2398 00000CA4 E80903                   call skipBlank
  2399                                  
  2400                                  ;-65           if (isToken('"')) {
  2401                                  
  2402 00000CA7 6A22                     push 34
  2403 00000CA9 E8D101                   call isToken
  2404 00000CAC 83C402                   add  sp, 2
  2405 00000CAF 08C0                     or  al, al
  2406 00000CB1 0F843000                 je @@getVariable99
  2407                                  
  2408                                  ;-66             do { c= *InputPtr;
  2409                                  
  2410                                  @@getVariable100:
  2411 00000CB5 8B1E[2700]               mov bx, [InputPtr]
  2412 00000CB9 8A07                     mov al, [bx]
  2413 00000CBB B400                     mov ah, 0
  2414 00000CBD 8846FE                   mov byte [bp-2], al
  2415                                  
  2416                                  ;-67               genCode8(c);
  2417                                  
  2418 00000CC0 8A46FE                   mov al, byte [bp-2]
  2419 00000CC3 B400                     mov ah, 0
  2420 00000CC5 50                       push ax
  2421 00000CC6 E8B4FB                   call genCode8
  2422 00000CC9 83C402                   add  sp, 2
  2423                                  
  2424                                  ;-68               InputPtr++;
  2425                                  
  2426 00000CCC FF06[2700]               inc  word [InputPtr]
  2427                                  
  2428                                  ;-69             } while (*InputPtr != '"' );
  2429                                  
  2430 00000CD0 8B1E[2700]               mov bx, [InputPtr]
  2431 00000CD4 8A07                     mov al, [bx]
  2432 00000CD6 B400                     mov ah, 0
  2433 00000CD8 83F822                   cmp ax, 34
  2434 00000CDB 0F840200                 je  @@getVariable101
  2435 00000CDF EBD4                     jmp @@getVariable100
  2436                                  @@getVariable101:
  2437                                  
  2438                                  ;-70             InputPtr++;
  2439                                  
  2440 00000CE1 FF06[2700]               inc  word [InputPtr]
  2441                                  
  2442                                  ;-71           }
  2443                                  
  2444                                  
  2445                                  ;-72         }
  2446                                  
  2447                                  @@getVariable99:
  2448                                  
  2449                                  ;-73       } while (isToken(','));
  2450                                  
  2451                                  @@getVariable98:
  2452 00000CE5 6A2C                     push 44
  2453 00000CE7 E89301                   call isToken
  2454 00000CEA 83C402                   add  sp, 2
  2455 00000CED 08C0                     or  al, al
  2456 00000CEF 0F840200                 je @@getVariable102
  2457 00000CF3 EB96                     jmp @@getVariable96
  2458                                  @@getVariable102:
  2459                                  
  2460                                  ;-74     }
  2461                                  
  2462                                  
  2463                                  ;-75     if (CodeType== 201) {// DW
  2464                                  
  2465                                  @@getVariable95:
  2466 00000CF5 A0[3D00]                 mov al, [CodeType]
  2467 00000CF8 3CC9                     cmp al, 201
  2468 00000CFA 0F852600                 jne @@getVariable103
  2469                                  
  2470                                  ;-76       do { getTokeType();
  2471                                  
  2472                                  @@getVariable104:
  2473 00000CFE E8FFFD                   call getTokeType
  2474                                  
  2475                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2476                                  
  2477 00000D01 A0[3B00]                 mov al, [TokeType]
  2478 00000D04 3C01                     cmp al, 1
  2479 00000D06 0F850A00                 jne @@getVariable105
  2480 00000D0A FF36[2500]               push word [SymbolInt]
  2481 00000D0E E89EFB                   call genCode16
  2482 00000D11 83C402                   add  sp, 2
  2483                                  
  2484                                  ;-78       } while (isToken(','));
  2485                                  
  2486                                  @@getVariable105:
  2487 00000D14 6A2C                     push 44
  2488 00000D16 E86401                   call isToken
  2489 00000D19 83C402                   add  sp, 2
  2490 00000D1C 08C0                     or  al, al
  2491 00000D1E 0F840200                 je @@getVariable106
  2492 00000D22 EBDA                     jmp @@getVariable104
  2493                                  @@getVariable106:
  2494                                  
  2495                                  ;-79     }
  2496                                  
  2497                                  
  2498                                  ;-80   }
  2499                                  
  2500                                  @@getVariable103:
  2501                                  
  2502                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2503                                  
  2504 00000D24 E90900                   jmp @@getVariable107
  2505                                  @@getVariable92:
  2506 00000D27 68[620D]                 push getVariable_2
  2507 00000D2A E8440C                   call errorexit
  2508 00000D2D 83C402                   add  sp, 2
  2509                                  
  2510                                  ;-82 }
  2511                                  
  2512                                  @@getVariable107:
  2513                                  
  2514                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2515 00000D30 C9                       LEAVE
  2516 00000D31 C3                       ret
  2517                                  ; ENDP
  2518 00000D32 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2519 00000D3B 422C572C4420657870-
  2520 00000D44 656374656400       
  2521 00000D4A 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2522 00000D53 422C572C4420657870-
  2523 00000D5C 656374656400       
  2524 00000D62 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2525 00000D6B 6F7220524553422C57-
  2526 00000D74 2C4420657870656374-
  2527 00000D7D 656400             
  2528                                  
  2529                                  lookCode:  ; *** PROC ***
  2530                                  
  2531                                  ;-84   CodeType=0;
  2532                                  
  2533 00000D80 66B800000000             mov eax, 0
  2534 00000D86 A2[3D00]                 mov byte [CodeType], al
  2535                                  
  2536                                  ;-85   OpCodePtr= &I_START;
  2537                                  
  2538 00000D89 B8[5A00]                 mov ax, I_START
  2539 00000D8C A3[4B00]                 mov word [OpCodePtr], ax
  2540                                  
  2541                                  ;-86   OpCodePtr++;
  2542                                  
  2543 00000D8F FF06[4B00]               inc  word [OpCodePtr]
  2544                                  
  2545                                  ;-87   do  {
  2546                                  
  2547                                  @@lookCode108:
  2548                                  
  2549                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2550                                  
  2551 00000D93 FF36[4B00]               push word [OpCodePtr]
  2552 00000D97 8D064F75                 lea  ax, [SymbolUpper]
  2553 00000D9B 50                       push ax
  2554 00000D9C E82811                   call eqstr
  2555 00000D9F 83C404                   add  sp, 4
  2556 00000DA2 08C0                     or  al, al
  2557 00000DA4 0F842700                 je @@lookCode109
  2558                                  
  2559                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2560                                  
  2561                                  @@lookCode110:
  2562 00000DA8 8B1E[4B00]               mov bx, [OpCodePtr]
  2563 00000DAC 8A07                     mov al, [bx]
  2564 00000DAE B400                     mov ah, 0
  2565 00000DB0 83F800                   cmp ax, 0
  2566 00000DB3 0F840600                 je  @@lookCode111
  2567 00000DB7 FF06[4B00]               inc  word [OpCodePtr]
  2568                                  
  2569                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2570                                  
  2571 00000DBB EBEB                     jmp @@lookCode110
  2572                                  @@lookCode111:
  2573 00000DBD FF06[4B00]               inc  word [OpCodePtr]
  2574 00000DC1 8B1E[4B00]               mov bx, [OpCodePtr]
  2575 00000DC5 8A07                     mov al, [bx]
  2576 00000DC7 B400                     mov ah, 0
  2577 00000DC9 A2[3D00]                 mov byte [CodeType], al
  2578                                  
  2579                                  ;-91       return;
  2580                                  
  2581 00000DCC E92A00                   jmp @@retn
  2582                                  
  2583                                  ;-92     }
  2584                                  
  2585                                  
  2586                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2587                                  
  2588                                  @@lookCode109:
  2589                                  @@lookCode112:
  2590 00000DCF 8B1E[4B00]               mov bx, [OpCodePtr]
  2591 00000DD3 8A07                     mov al, [bx]
  2592 00000DD5 B400                     mov ah, 0
  2593 00000DD7 3DF100                   cmp ax, 241
  2594 00000DDA 0F840600                 je  @@lookCode113
  2595 00000DDE FF06[4B00]               inc  word [OpCodePtr]
  2596                                  
  2597                                  ;-94   OpCodePtr++;
  2598                                  
  2599 00000DE2 EBEB                     jmp @@lookCode112
  2600                                  @@lookCode113:
  2601 00000DE4 FF06[4B00]               inc  word [OpCodePtr]
  2602                                  
  2603                                  ;-95   } while(*OpCodePtr!=0);
  2604                                  
  2605 00000DE8 8B1E[4B00]               mov bx, [OpCodePtr]
  2606 00000DEC 8A07                     mov al, [bx]
  2607 00000DEE B400                     mov ah, 0
  2608 00000DF0 83F800                   cmp ax, 0
  2609 00000DF3 0F840200                 je  @@lookCode114
  2610 00000DF7 EB9A                     jmp @@lookCode108
  2611                                  @@lookCode114:
  2612                                  
  2613                                  ;-96 }
  2614                                  
  2615                                  
  2616                                  ;-97 int getCodeSize() {
  2617                                  
  2618                                  @@retn:
  2619 00000DF9 C3                       ret
  2620                                  ; ENDP
  2621                                  
  2622                                  getCodeSize:  ; *** PROC ***
  2623                                  
  2624                                  ;-98   if (TokeType ==ALNUME) {
  2625                                  
  2626 00000DFA A0[3B00]                 mov al, [TokeType]
  2627 00000DFD 3C03                     cmp al, 3
  2628 00000DFF 0F856000                 jne @@getCodeSize115
  2629                                  
  2630                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2631                                  
  2632 00000E03 68[6D0E]                 push getCodeSize_0
  2633 00000E06 8D064F75                 lea  ax, [SymbolUpper]
  2634 00000E0A 50                       push ax
  2635 00000E0B E8B910                   call eqstr
  2636 00000E0E 83C404                   add  sp, 4
  2637 00000E11 08C0                     or  al, al
  2638 00000E13 0F840C00                 je @@getCodeSize116
  2639 00000E17 E8E6FC                   call getTokeType
  2640 00000E1A 66B801000000             mov eax, 1
  2641 00000E20 E94900                   jmp @@retn
  2642                                  
  2643                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2644                                  
  2645                                  @@getCodeSize116:
  2646 00000E23 68[720E]                 push getCodeSize_1
  2647 00000E26 8D064F75                 lea  ax, [SymbolUpper]
  2648 00000E2A 50                       push ax
  2649 00000E2B E89910                   call eqstr
  2650 00000E2E 83C404                   add  sp, 4
  2651 00000E31 08C0                     or  al, al
  2652 00000E33 0F840C00                 je @@getCodeSize117
  2653 00000E37 E8C6FC                   call getTokeType
  2654 00000E3A 66B802000000             mov eax, 2
  2655 00000E40 E92900                   jmp @@retn
  2656                                  
  2657                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2658                                  
  2659                                  @@getCodeSize117:
  2660 00000E43 68[770E]                 push getCodeSize_2
  2661 00000E46 8D064F75                 lea  ax, [SymbolUpper]
  2662 00000E4A 50                       push ax
  2663 00000E4B E87910                   call eqstr
  2664 00000E4E 83C404                   add  sp, 4
  2665 00000E51 08C0                     or  al, al
  2666 00000E53 0F840C00                 je @@getCodeSize118
  2667 00000E57 E8A6FC                   call getTokeType
  2668 00000E5A 66B803000000             mov eax, 3
  2669 00000E60 E90900                   jmp @@retn
  2670                                  
  2671                                  ;-102   } return 0;
  2672                                  
  2673                                  @@getCodeSize118:
  2674                                  @@getCodeSize115:
  2675 00000E63 66B800000000             mov eax, 0
  2676 00000E69 E90000                   jmp @@retn
  2677                                  
  2678                                  ;-103 }
  2679                                  
  2680                                  
  2681                                  ;-104 int isToken(char c) {
  2682                                  
  2683                                  @@retn:
  2684 00000E6C C3                       ret
  2685                                  ; ENDP
  2686 00000E6D 4259544500              getCodeSize_0 db "BYTE",0
  2687 00000E72 574F524400              getCodeSize_1 db "WORD",0
  2688 00000E77 44574F524400            getCodeSize_2 db "DWORD",0
  2689                                  
  2690                                  isToken:  ; *** PROC ***
  2691                                  
  2692                                  ;-105   skipBlank();
  2693                                  
  2694                                  ;Function : isToken, Number of local variables: 1
  2695                                  ;   # type sign width line used address name   list of local variables
  2696                                  ;  200 var sign byte   104 NULL bp+4    c;
  2697 00000E7D C8000000                 ENTER  0,0
  2698 00000E81 E82C01                   call skipBlank
  2699                                  
  2700                                  ;-106   if (*InputPtr == c) {
  2701                                  
  2702 00000E84 8B1E[2700]               mov bx, [InputPtr]
  2703 00000E88 8A07                     mov al, [bx]
  2704 00000E8A B400                     mov ah, 0
  2705 00000E8C 3A4604                   cmp al, [bp+4]
  2706 00000E8F 0F850D00                 jne @@isToken119
  2707                                  
  2708                                  ;-107     InputPtr++; return 1;} return 0;
  2709                                  
  2710 00000E93 FF06[2700]               inc  word [InputPtr]
  2711 00000E97 66B801000000             mov eax, 1
  2712 00000E9D E90900                   jmp @@retn
  2713                                  @@isToken119:
  2714 00000EA0 66B800000000             mov eax, 0
  2715 00000EA6 E90000                   jmp @@retn
  2716                                  
  2717                                  ;-108 }
  2718                                  
  2719                                  
  2720                                  ;-109 int skipRest() {
  2721                                  
  2722 00000EA9 C9                      @@retn: LEAVE
  2723 00000EAA C3                       ret
  2724                                  ; ENDP
  2725                                  
  2726                                  skipRest:  ; *** PROC ***
  2727                                  
  2728                                  ;-110   getTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");
  2729                                  
  2730 00000EAB E852FC                   call getTokeType
  2731 00000EAE A0[3B00]                 mov al, [TokeType]
  2732 00000EB1 3C00                     cmp al, 0
  2733 00000EB3 0F840900                 je  @@skipRest120
  2734 00000EB7 68[C10E]                 push skipRest_0
  2735 00000EBA E82608                   call prs
  2736 00000EBD 83C402                   add  sp, 2
  2737                                  
  2738                                  ;-111 }
  2739                                  
  2740                                  @@skipRest120:
  2741 00000EC0 C3                       ret
  2742                                  ; ENDP
  2743 00000EC1 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ********** extra char ignored",0
  2744 00000ECA 2A2A2A2A2A20657874-
  2745 00000ED3 726120636861722069-
  2746 00000EDC 676E6F72656400     
  2747                                  ;Back to main program: AS.C
  2748                                  
  2749                                  ;-182 #include "HELPER.C"
  2750                                  
  2751                                  ;Use include file: HELPER.C
  2752                                  
  2753                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2754                                  
  2755                                  
  2756                                  getLine:  ; *** PROC ***
  2757                                  
  2758                                  ;-2   InputPtr= &InputBuf;
  2759                                  
  2760 00000EE3 B86E75                   mov ax, InputBuf
  2761 00000EE6 A3[2700]                 mov word [InputPtr], ax
  2762                                  
  2763                                  ;-3   *InputPtr=0;//if last line is empty
  2764                                  
  2765 00000EE9 66B800000000             mov eax, 0
  2766 00000EEF 8B1E[2700]               mov  bx, [InputPtr]
  2767 00000EF3 8807                     mov  [bx], al
  2768                                  
  2769                                  ;-4   do {
  2770                                  
  2771                                  @@getLine121:
  2772                                  
  2773                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2774                                  
  2775 00000EF5 6A01                     push 1
  2776 00000EF7 FF36[2900]               push word [asm_fd]
  2777 00000EFB 8D06[3500]               lea  ax, [DOS_ByteRead]
  2778 00000EFF 50                       push ax
  2779 00000F00 E85F10                   call readRL
  2780 00000F03 83C406                   add  sp, 6
  2781 00000F06 A3[3300]                 mov word [DOS_NoBytes], ax
  2782                                  
  2783                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  2784                                  
  2785 00000F09 A1[2F00]                 mov ax, [DOS_ERR]
  2786 00000F0C 08C0                     or  al, al
  2787 00000F0E 0F840900                 je @@getLine122
  2788 00000F12 68[5A0F]                 push getLine_0
  2789 00000F15 E8590A                   call errorexit
  2790 00000F18 83C402                   add  sp, 2
  2791                                  
  2792                                  ;-7     if (DOS_NoBytes == 0) return;
  2793                                  
  2794                                  @@getLine122:
  2795 00000F1B A1[3300]                 mov ax, [DOS_NoBytes]
  2796 00000F1E 83F800                   cmp ax, 0
  2797 00000F21 0F850300                 jne @@getLine123
  2798 00000F25 E93100                   jmp @@retn
  2799                                  
  2800                                  ;-8     *InputPtr = DOS_ByteRead;
  2801                                  
  2802                                  @@getLine123:
  2803 00000F28 A0[3500]                 mov al, [DOS_ByteRead]
  2804 00000F2B 8B1E[2700]               mov  bx, [InputPtr]
  2805 00000F2F 8807                     mov  [bx], al
  2806                                  
  2807                                  ;-9     InputPtr++;
  2808                                  
  2809 00000F31 FF06[2700]               inc  word [InputPtr]
  2810                                  
  2811                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  2812                                  
  2813 00000F35 A0[3500]                 mov al, byte [DOS_ByteRead]
  2814 00000F38 B400                     mov ah, 0
  2815 00000F3A 50                       push ax
  2816 00000F3B E82B00                   call ifEOL
  2817 00000F3E 83C402                   add  sp, 2
  2818 00000F41 3C00                     cmp al, 0
  2819 00000F43 0F850200                 jne @@getLine124
  2820 00000F47 EBAC                     jmp @@getLine121
  2821                                  @@getLine124:
  2822                                  
  2823                                  ;-11   InputPtr--;
  2824                                  
  2825 00000F49 FF0E[2700]               dec  word [InputPtr]
  2826                                  
  2827                                  ;-12   *InputPtr=0;
  2828                                  
  2829 00000F4D 66B800000000             mov eax, 0
  2830 00000F53 8B1E[2700]               mov  bx, [InputPtr]
  2831 00000F57 8807                     mov  [bx], al
  2832                                  
  2833                                  ;-13 }
  2834                                  
  2835                                  
  2836                                  ;-14 int ifEOL(char c) {
  2837                                  
  2838                                  @@retn:
  2839 00000F59 C3                       ret
  2840                                  ; ENDP
  2841 00000F5A 52656164696E672053-     getLine_0 db "Reading Source",0
  2842 00000F63 6F7572636500       
  2843                                  
  2844                                  ifEOL:  ; *** PROC ***
  2845                                  
  2846                                  ;-15   if (c == 10) return 1;
  2847                                  
  2848                                  ;Function : ifEOL, Number of local variables: 1
  2849                                  ;   # type sign width line used address name   list of local variables
  2850                                  ;  200 var sign byte    14 NULL bp+4    c;
  2851 00000F69 C8000000                 ENTER  0,0
  2852 00000F6D 8A4604                   mov al, [bp+4]
  2853 00000F70 3C0A                     cmp al, 10
  2854 00000F72 0F850900                 jne @@ifEOL125
  2855 00000F76 66B801000000             mov eax, 1
  2856 00000F7C E92F00                   jmp @@retn
  2857                                  
  2858                                  ;-16   if (c == 13) {
  2859                                  
  2860                                  @@ifEOL125:
  2861 00000F7F 8A4604                   mov al, [bp+4]
  2862 00000F82 3C0D                     cmp al, 13
  2863 00000F84 0F851D00                 jne @@ifEOL126
  2864                                  
  2865                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2866                                  
  2867 00000F88 6A01                     push 1
  2868 00000F8A FF36[2900]               push word [asm_fd]
  2869 00000F8E 8D06[3500]               lea  ax, [DOS_ByteRead]
  2870 00000F92 50                       push ax
  2871 00000F93 E8CC0F                   call readRL
  2872 00000F96 83C406                   add  sp, 6
  2873 00000F99 A3[3300]                 mov word [DOS_NoBytes], ax
  2874                                  
  2875                                  ;-18     return 1;}
  2876                                  
  2877 00000F9C 66B801000000             mov eax, 1
  2878 00000FA2 E90900                   jmp @@retn
  2879                                  
  2880                                  ;-19   return 0;
  2881                                  
  2882                                  @@ifEOL126:
  2883 00000FA5 66B800000000             mov eax, 0
  2884 00000FAB E90000                   jmp @@retn
  2885                                  
  2886                                  ;-20 }
  2887                                  
  2888                                  
  2889                                  ;-21 int skipBlank() {
  2890                                  
  2891 00000FAE C9                      @@retn: LEAVE
  2892 00000FAF C3                       ret
  2893                                  ; ENDP
  2894                                  
  2895                                  skipBlank:  ; *** PROC ***
  2896                                  
  2897                                  ;-22   skipblank1:
  2898                                  
  2899                                  @@skipblank1:
  2900                                  
  2901                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2902                                  
  2903 00000FB0 8B1E[2700]               mov bx, [InputPtr]
  2904 00000FB4 8A07                     mov al, [bx]
  2905 00000FB6 B400                     mov ah, 0
  2906 00000FB8 83F820                   cmp ax, 32
  2907 00000FBB 0F850600                 jne @@skipBlank127
  2908 00000FBF FF06[2700]               inc  word [InputPtr]
  2909 00000FC3 EBEB                     jmp @@skipblank1
  2910                                  
  2911                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2912                                  
  2913                                  @@skipBlank127:
  2914 00000FC5 8B1E[2700]               mov bx, [InputPtr]
  2915 00000FC9 8A07                     mov al, [bx]
  2916 00000FCB B400                     mov ah, 0
  2917 00000FCD 83F809                   cmp ax, 9
  2918 00000FD0 0F850600                 jne @@skipBlank128
  2919 00000FD4 FF06[2700]               inc  word [InputPtr]
  2920 00000FD8 EBD6                     jmp @@skipblank1
  2921                                  
  2922                                  ;-25 }
  2923                                  
  2924                                  @@skipBlank128:
  2925                                  
  2926                                  ;-26 int letterE(char c) {
  2927                                  
  2928 00000FDA C3                       ret
  2929                                  ; ENDP
  2930                                  
  2931                                  letterE:  ; *** PROC ***
  2932                                  
  2933                                  ;-27   if (c=='_') return 1;
  2934                                  
  2935                                  ;Function : letterE, Number of local variables: 1
  2936                                  ;   # type sign width line used address name   list of local variables
  2937                                  ;  200 var sign byte    26 NULL bp+4    c;
  2938 00000FDB C8000000                 ENTER  0,0
  2939 00000FDF 8A4604                   mov al, [bp+4]
  2940 00000FE2 3C5F                     cmp al, 95
  2941 00000FE4 0F850900                 jne @@letterE129
  2942 00000FE8 66B801000000             mov eax, 1
  2943 00000FEE E97E00                   jmp @@retn
  2944                                  
  2945                                  ;-28   if (c=='.') return 1;
  2946                                  
  2947                                  @@letterE129:
  2948 00000FF1 8A4604                   mov al, [bp+4]
  2949 00000FF4 3C2E                     cmp al, 46
  2950 00000FF6 0F850900                 jne @@letterE130
  2951 00000FFA 66B801000000             mov eax, 1
  2952 00001000 E96C00                   jmp @@retn
  2953                                  
  2954                                  ;-29   if (c=='?') return 1;
  2955                                  
  2956                                  @@letterE130:
  2957 00001003 8A4604                   mov al, [bp+4]
  2958 00001006 3C3F                     cmp al, 63
  2959 00001008 0F850900                 jne @@letterE131
  2960 0000100C 66B801000000             mov eax, 1
  2961 00001012 E95A00                   jmp @@retn
  2962                                  
  2963                                  ;-30   if (c=='$') return 1;
  2964                                  
  2965                                  @@letterE131:
  2966 00001015 8A4604                   mov al, [bp+4]
  2967 00001018 3C24                     cmp al, 36
  2968 0000101A 0F850900                 jne @@letterE132
  2969 0000101E 66B801000000             mov eax, 1
  2970 00001024 E94800                   jmp @@retn
  2971                                  
  2972                                  ;-31   if (c> 'z') return 0;
  2973                                  
  2974                                  @@letterE132:
  2975 00001027 8A4604                   mov al, [bp+4]
  2976 0000102A 3C7A                     cmp al, 122
  2977 0000102C 0F8E0900                 jle @@letterE133
  2978 00001030 66B800000000             mov eax, 0
  2979 00001036 E93600                   jmp @@retn
  2980                                  
  2981                                  ;-32   if (c< '@') return 0; // at included
  2982                                  
  2983                                  @@letterE133:
  2984 00001039 8A4604                   mov al, [bp+4]
  2985 0000103C 3C40                     cmp al, 64
  2986 0000103E 0F8D0900                 jge @@letterE134
  2987 00001042 66B800000000             mov eax, 0
  2988 00001048 E92400                   jmp @@retn
  2989                                  
  2990                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  2991                                  
  2992                                  @@letterE134:
  2993 0000104B 8A4604                   mov al, [bp+4]
  2994 0000104E 3C5A                     cmp al, 90
  2995 00001050 0F8E1200                 jle @@letterE135
  2996 00001054 8A4604                   mov al, [bp+4]
  2997 00001057 3C61                     cmp al, 97
  2998 00001059 0F8D0900                 jge @@letterE136
  2999 0000105D 66B800000000             mov eax, 0
  3000 00001063 E90900                   jmp @@retn
  3001                                  @@letterE136:
  3002                                  
  3003                                  ;-34   return 1;
  3004                                  
  3005                                  @@letterE135:
  3006 00001066 66B801000000             mov eax, 1
  3007 0000106C E90000                   jmp @@retn
  3008                                  
  3009                                  ;-35 }
  3010                                  
  3011                                  
  3012                                  ;-36 int alnumE(char c) {
  3013                                  
  3014 0000106F C9                      @@retn: LEAVE
  3015 00001070 C3                       ret
  3016                                  ; ENDP
  3017                                  
  3018                                  alnumE:  ; *** PROC ***
  3019                                  
  3020                                  ;-37   if (digit(c)) return 1;
  3021                                  
  3022                                  ;Function : alnumE, Number of local variables: 1
  3023                                  ;   # type sign width line used address name   list of local variables
  3024                                  ;  200 var sign byte    36 NULL bp+4    c;
  3025 00001071 C8000000                 ENTER  0,0
  3026 00001075 8A4604                   mov al, byte [bp+4]
  3027 00001078 B400                     mov ah, 0
  3028 0000107A 50                       push ax
  3029 0000107B E8160E                   call digit
  3030 0000107E 83C402                   add  sp, 2
  3031 00001081 08C0                     or  al, al
  3032 00001083 0F840900                 je @@alnumE137
  3033 00001087 66B801000000             mov eax, 1
  3034 0000108D E92400                   jmp @@retn
  3035                                  
  3036                                  ;-38   if (letterE(c)) return 1;
  3037                                  
  3038                                  @@alnumE137:
  3039 00001090 8A4604                   mov al, byte [bp+4]
  3040 00001093 B400                     mov ah, 0
  3041 00001095 50                       push ax
  3042 00001096 E842FF                   call letterE
  3043 00001099 83C402                   add  sp, 2
  3044 0000109C 08C0                     or  al, al
  3045 0000109E 0F840900                 je @@alnumE138
  3046 000010A2 66B801000000             mov eax, 1
  3047 000010A8 E90900                   jmp @@retn
  3048                                  
  3049                                  ;-39   return 0;
  3050                                  
  3051                                  @@alnumE138:
  3052 000010AB 66B800000000             mov eax, 0
  3053 000010B1 E90000                   jmp @@retn
  3054                                  
  3055                                  ;-40 }
  3056                                  
  3057                                  
  3058                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3059                                  
  3060 000010B4 C9                      @@retn: LEAVE
  3061 000010B5 C3                       ret
  3062                                  ; ENDP
  3063                                  
  3064                                  getDigit:  ; *** PROC ***
  3065                                  
  3066                                  ;-42   unsigned int CastInt;
  3067                                  
  3068                                  
  3069                                  ;-43   SymbolInt=0;
  3070                                  
  3071                                  ;Function : getDigit, Number of local variables: 2
  3072                                  ;   # type sign width line used address name   list of local variables
  3073                                  ;  200 var unsg byte    41 NULL bp+4    c
  3074                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3075 000010B6 C8020000                 ENTER  2,0
  3076 000010BA 66B800000000             mov eax, 0
  3077 000010C0 A3[2500]                 mov word [SymbolInt], ax
  3078                                  
  3079                                  ;-44   do {
  3080                                  
  3081                                  @@getDigit139:
  3082                                  
  3083                                  ;-45     c-='0';
  3084                                  
  3085 000010C3 806E0430                 sub  byte [bp+4], 48
  3086                                  
  3087                                  ;-46     SymbolInt=SymbolInt*10;
  3088                                  
  3089 000010C7 A1[2500]                 mov ax, [SymbolInt]
  3090 000010CA 66BB0A000000             mov ebx, 10
  3091 000010D0 66F7E3                   mul ebx
  3092 000010D3 A3[2500]                 mov word [SymbolInt], ax
  3093                                  
  3094                                  ;-47     ax=0; CastInt=c; //cast b2w
  3095                                  
  3096 000010D6 B80000                   mov  ax, 0
  3097 000010D9 8A4604                   mov al, [bp+4]
  3098 000010DC 8946FE                   mov word [bp-2], ax
  3099                                  
  3100                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3101                                  
  3102 000010DF A1[2500]                 mov ax, [SymbolInt]
  3103 000010E2 0346FE                   add ax, [bp-2]
  3104 000010E5 A3[2500]                 mov word [SymbolInt], ax
  3105                                  
  3106                                  ;-49     InputPtr++;
  3107                                  
  3108 000010E8 FF06[2700]               inc  word [InputPtr]
  3109                                  
  3110                                  ;-50     c = *InputPtr;
  3111                                  
  3112 000010EC 8B1E[2700]               mov bx, [InputPtr]
  3113 000010F0 8A07                     mov al, [bx]
  3114 000010F2 B400                     mov ah, 0
  3115 000010F4 884604                   mov byte [bp+4], al
  3116                                  
  3117                                  ;-51   } while(digit(c));
  3118                                  
  3119 000010F7 8A4604                   mov al, byte [bp+4]
  3120 000010FA B400                     mov ah, 0
  3121 000010FC 50                       push ax
  3122 000010FD E8940D                   call digit
  3123 00001100 83C402                   add  sp, 2
  3124 00001103 08C0                     or  al, al
  3125 00001105 0F840200                 je @@getDigit140
  3126 00001109 EBB8                     jmp @@getDigit139
  3127                                  @@getDigit140:
  3128                                  
  3129                                  ;-52 }
  3130                                  
  3131                                  
  3132                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3133 0000110B C9                       LEAVE
  3134 0000110C C3                       ret
  3135                                  ; ENDP
  3136                                  
  3137                                  getName:  ; *** PROC ***
  3138                                  
  3139                                  ;-54   char *p;
  3140                                  
  3141                                  
  3142                                  ;-55   p = &Symbol;
  3143                                  
  3144                                  ;Function : getName, Number of local variables: 2
  3145                                  ;   # type sign width line used address name   list of local variables
  3146                                  ;  200 var unsg byte    53 NULL bp+4    c
  3147                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3148 0000110D C8020000                 ENTER  2,0
  3149 00001111 B83075                   mov ax, Symbol
  3150 00001114 8946FE                   mov word [bp-2], ax
  3151                                  
  3152                                  ;-56   *p = c;
  3153                                  
  3154 00001117 8A4604                   mov al, [bp+4]
  3155 0000111A 8B5EFE                   mov  bx, [bp-2]
  3156 0000111D 8807                     mov  [bx], al
  3157                                  
  3158                                  ;-57   p++;
  3159                                  
  3160 0000111F FF46FE                   inc  word [bp-2]
  3161                                  
  3162                                  ;-58   while (alnumE(c)) {
  3163                                  
  3164                                  @@getName141:
  3165 00001122 8A4604                   mov al, byte [bp+4]
  3166 00001125 B400                     mov ah, 0
  3167 00001127 50                       push ax
  3168 00001128 E846FF                   call alnumE
  3169 0000112B 83C402                   add  sp, 2
  3170 0000112E 08C0                     or  al, al
  3171 00001130 0F841C00                 je @@getName142
  3172                                  
  3173                                  ;-59     InputPtr++;
  3174                                  
  3175 00001134 FF06[2700]               inc  word [InputPtr]
  3176                                  
  3177                                  ;-60     c = *InputPtr;
  3178                                  
  3179 00001138 8B1E[2700]               mov bx, [InputPtr]
  3180 0000113C 8A07                     mov al, [bx]
  3181 0000113E B400                     mov ah, 0
  3182 00001140 884604                   mov byte [bp+4], al
  3183                                  
  3184                                  ;-61     *p = c;
  3185                                  
  3186 00001143 8A4604                   mov al, [bp+4]
  3187 00001146 8B5EFE                   mov  bx, [bp-2]
  3188 00001149 8807                     mov  [bx], al
  3189                                  
  3190                                  ;-62     p++;
  3191                                  
  3192 0000114B FF46FE                   inc  word [bp-2]
  3193                                  
  3194                                  ;-63   }
  3195                                  
  3196                                  
  3197                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3198                                  
  3199 0000114E EBD2                     jmp @@getName141
  3200                                  @@getName142:
  3201 00001150 8A4604                   mov al, [bp+4]
  3202 00001153 3C3A                     cmp al, 58
  3203 00001155 0F850C00                 jne @@getName143
  3204 00001159 66B801000000             mov eax, 1
  3205 0000115F A2[3A00]                 mov byte [isLabel], al
  3206 00001162 E90900                   jmp @@getName144
  3207                                  @@getName143:
  3208 00001165 66B800000000             mov eax, 0
  3209 0000116B A2[3A00]                 mov byte [isLabel], al
  3210                                  
  3211                                  ;-65   p--;
  3212                                  
  3213                                  @@getName144:
  3214 0000116E FF4EFE                   dec  word [bp-2]
  3215                                  
  3216                                  ;-66   *p = 0;
  3217                                  
  3218 00001171 66B800000000             mov eax, 0
  3219 00001177 8B5EFE                   mov  bx, [bp-2]
  3220 0000117A 8807                     mov  [bx], al
  3221                                  
  3222                                  ;-67   strcpy(SymbolUpper, Symbol);
  3223                                  
  3224 0000117C 8D063075                 lea  ax, [Symbol]
  3225 00001180 50                       push ax
  3226 00001181 8D064F75                 lea  ax, [SymbolUpper]
  3227 00001185 50                       push ax
  3228 00001186 E8D20C                   call strcpy
  3229 00001189 83C404                   add  sp, 4
  3230                                  
  3231                                  ;-68   toupper(SymbolUpper);
  3232                                  
  3233 0000118C 8D064F75                 lea  ax, [SymbolUpper]
  3234 00001190 50                       push ax
  3235 00001191 E8590C                   call toupper
  3236 00001194 83C402                   add  sp, 2
  3237                                  
  3238                                  ;-69 }
  3239                                  
  3240                                  
  3241                                  ;-70 int testReg() {
  3242 00001197 C9                       LEAVE
  3243 00001198 C3                       ret
  3244                                  ; ENDP
  3245                                  
  3246                                  testReg:  ; *** PROC ***
  3247                                  
  3248                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3249                                  
  3250                                  
  3251                                  ;-72   RegType=0;
  3252                                  
  3253 00001199 66B800000000             mov eax, 0
  3254 0000119F A2[3E00]                 mov byte [RegType], al
  3255                                  
  3256                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3257                                  
  3258 000011A2 8D063075                 lea  ax, [Symbol]
  3259 000011A6 50                       push ax
  3260 000011A7 E8860C                   call strlen
  3261 000011AA 83C402                   add  sp, 2
  3262 000011AD 3C02                     cmp al, 2
  3263 000011AF 0F8D0900                 jge @@testReg145
  3264 000011B3 66B800000000             mov eax, 0
  3265 000011B9 E9B603                   jmp @@retn
  3266                                  
  3267                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3268                                  
  3269                                  @@testReg145:
  3270 000011BC 8D063075                 lea  ax, [Symbol]
  3271 000011C0 50                       push ax
  3272 000011C1 E86C0C                   call strlen
  3273 000011C4 83C402                   add  sp, 2
  3274 000011C7 3C03                     cmp al, 3
  3275 000011C9 0F8E0900                 jle @@testReg146
  3276 000011CD 66B800000000             mov eax, 0
  3277 000011D3 E99C03                   jmp @@retn
  3278                                  
  3279                                  ;-75   RegType=BYTE;
  3280                                  
  3281                                  @@testReg146:
  3282 000011D6 66B801000000             mov eax, 1
  3283 000011DC A2[3E00]                 mov byte [RegType], al
  3284                                  
  3285                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3286                                  
  3287 000011DF 68[7315]                 push testReg_0
  3288 000011E2 8D064F75                 lea  ax, [SymbolUpper]
  3289 000011E6 50                       push ax
  3290 000011E7 E8DD0C                   call eqstr
  3291 000011EA 83C404                   add  sp, 4
  3292 000011ED 08C0                     or  al, al
  3293 000011EF 0F840900                 je @@testReg147
  3294 000011F3 66B800000000             mov eax, 0
  3295 000011F9 E97603                   jmp @@retn
  3296                                  
  3297                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3298                                  
  3299                                  @@testReg147:
  3300 000011FC 68[7615]                 push testReg_1
  3301 000011FF 8D064F75                 lea  ax, [SymbolUpper]
  3302 00001203 50                       push ax
  3303 00001204 E8C00C                   call eqstr
  3304 00001207 83C404                   add  sp, 4
  3305 0000120A 08C0                     or  al, al
  3306 0000120C 0F840900                 je @@testReg148
  3307 00001210 66B801000000             mov eax, 1
  3308 00001216 E95903                   jmp @@retn
  3309                                  
  3310                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3311                                  
  3312                                  @@testReg148:
  3313 00001219 68[7915]                 push testReg_2
  3314 0000121C 8D064F75                 lea  ax, [SymbolUpper]
  3315 00001220 50                       push ax
  3316 00001221 E8A30C                   call eqstr
  3317 00001224 83C404                   add  sp, 4
  3318 00001227 08C0                     or  al, al
  3319 00001229 0F840900                 je @@testReg149
  3320 0000122D 66B802000000             mov eax, 2
  3321 00001233 E93C03                   jmp @@retn
  3322                                  
  3323                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3324                                  
  3325                                  @@testReg149:
  3326 00001236 68[7C15]                 push testReg_3
  3327 00001239 8D064F75                 lea  ax, [SymbolUpper]
  3328 0000123D 50                       push ax
  3329 0000123E E8860C                   call eqstr
  3330 00001241 83C404                   add  sp, 4
  3331 00001244 08C0                     or  al, al
  3332 00001246 0F840900                 je @@testReg150
  3333 0000124A 66B803000000             mov eax, 3
  3334 00001250 E91F03                   jmp @@retn
  3335                                  
  3336                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3337                                  
  3338                                  @@testReg150:
  3339 00001253 68[7F15]                 push testReg_4
  3340 00001256 8D064F75                 lea  ax, [SymbolUpper]
  3341 0000125A 50                       push ax
  3342 0000125B E8690C                   call eqstr
  3343 0000125E 83C404                   add  sp, 4
  3344 00001261 08C0                     or  al, al
  3345 00001263 0F840900                 je @@testReg151
  3346 00001267 66B804000000             mov eax, 4
  3347 0000126D E90203                   jmp @@retn
  3348                                  
  3349                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3350                                  
  3351                                  @@testReg151:
  3352 00001270 68[8215]                 push testReg_5
  3353 00001273 8D064F75                 lea  ax, [SymbolUpper]
  3354 00001277 50                       push ax
  3355 00001278 E84C0C                   call eqstr
  3356 0000127B 83C404                   add  sp, 4
  3357 0000127E 08C0                     or  al, al
  3358 00001280 0F840900                 je @@testReg152
  3359 00001284 66B805000000             mov eax, 5
  3360 0000128A E9E502                   jmp @@retn
  3361                                  
  3362                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3363                                  
  3364                                  @@testReg152:
  3365 0000128D 68[8515]                 push testReg_6
  3366 00001290 8D064F75                 lea  ax, [SymbolUpper]
  3367 00001294 50                       push ax
  3368 00001295 E82F0C                   call eqstr
  3369 00001298 83C404                   add  sp, 4
  3370 0000129B 08C0                     or  al, al
  3371 0000129D 0F840900                 je @@testReg153
  3372 000012A1 66B806000000             mov eax, 6
  3373 000012A7 E9C802                   jmp @@retn
  3374                                  
  3375                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3376                                  
  3377                                  @@testReg153:
  3378 000012AA 68[8815]                 push testReg_7
  3379 000012AD 8D064F75                 lea  ax, [SymbolUpper]
  3380 000012B1 50                       push ax
  3381 000012B2 E8120C                   call eqstr
  3382 000012B5 83C404                   add  sp, 4
  3383 000012B8 08C0                     or  al, al
  3384 000012BA 0F840900                 je @@testReg154
  3385 000012BE 66B807000000             mov eax, 7
  3386 000012C4 E9AB02                   jmp @@retn
  3387                                  
  3388                                  ;-84   RegType=WORD;
  3389                                  
  3390                                  @@testReg154:
  3391 000012C7 66B802000000             mov eax, 2
  3392 000012CD A2[3E00]                 mov byte [RegType], al
  3393                                  
  3394                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3395                                  
  3396 000012D0 68[8B15]                 push testReg_8
  3397 000012D3 8D064F75                 lea  ax, [SymbolUpper]
  3398 000012D7 50                       push ax
  3399 000012D8 E8EC0B                   call eqstr
  3400 000012DB 83C404                   add  sp, 4
  3401 000012DE 08C0                     or  al, al
  3402 000012E0 0F840900                 je @@testReg155
  3403 000012E4 66B800000000             mov eax, 0
  3404 000012EA E98502                   jmp @@retn
  3405                                  
  3406                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3407                                  
  3408                                  @@testReg155:
  3409 000012ED 68[8E15]                 push testReg_9
  3410 000012F0 8D064F75                 lea  ax, [SymbolUpper]
  3411 000012F4 50                       push ax
  3412 000012F5 E8CF0B                   call eqstr
  3413 000012F8 83C404                   add  sp, 4
  3414 000012FB 08C0                     or  al, al
  3415 000012FD 0F840900                 je @@testReg156
  3416 00001301 66B801000000             mov eax, 1
  3417 00001307 E96802                   jmp @@retn
  3418                                  
  3419                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3420                                  
  3421                                  @@testReg156:
  3422 0000130A 68[9115]                 push testReg_10
  3423 0000130D 8D064F75                 lea  ax, [SymbolUpper]
  3424 00001311 50                       push ax
  3425 00001312 E8B20B                   call eqstr
  3426 00001315 83C404                   add  sp, 4
  3427 00001318 08C0                     or  al, al
  3428 0000131A 0F840900                 je @@testReg157
  3429 0000131E 66B802000000             mov eax, 2
  3430 00001324 E94B02                   jmp @@retn
  3431                                  
  3432                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3433                                  
  3434                                  @@testReg157:
  3435 00001327 68[9415]                 push testReg_11
  3436 0000132A 8D064F75                 lea  ax, [SymbolUpper]
  3437 0000132E 50                       push ax
  3438 0000132F E8950B                   call eqstr
  3439 00001332 83C404                   add  sp, 4
  3440 00001335 08C0                     or  al, al
  3441 00001337 0F840900                 je @@testReg158
  3442 0000133B 66B803000000             mov eax, 3
  3443 00001341 E92E02                   jmp @@retn
  3444                                  
  3445                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3446                                  
  3447                                  @@testReg158:
  3448 00001344 68[9715]                 push testReg_12
  3449 00001347 8D064F75                 lea  ax, [SymbolUpper]
  3450 0000134B 50                       push ax
  3451 0000134C E8780B                   call eqstr
  3452 0000134F 83C404                   add  sp, 4
  3453 00001352 08C0                     or  al, al
  3454 00001354 0F840900                 je @@testReg159
  3455 00001358 66B804000000             mov eax, 4
  3456 0000135E E91102                   jmp @@retn
  3457                                  
  3458                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3459                                  
  3460                                  @@testReg159:
  3461 00001361 68[9A15]                 push testReg_13
  3462 00001364 8D064F75                 lea  ax, [SymbolUpper]
  3463 00001368 50                       push ax
  3464 00001369 E85B0B                   call eqstr
  3465 0000136C 83C404                   add  sp, 4
  3466 0000136F 08C0                     or  al, al
  3467 00001371 0F840900                 je @@testReg160
  3468 00001375 66B805000000             mov eax, 5
  3469 0000137B E9F401                   jmp @@retn
  3470                                  
  3471                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3472                                  
  3473                                  @@testReg160:
  3474 0000137E 68[9D15]                 push testReg_14
  3475 00001381 8D064F75                 lea  ax, [SymbolUpper]
  3476 00001385 50                       push ax
  3477 00001386 E83E0B                   call eqstr
  3478 00001389 83C404                   add  sp, 4
  3479 0000138C 08C0                     or  al, al
  3480 0000138E 0F840900                 je @@testReg161
  3481 00001392 66B806000000             mov eax, 6
  3482 00001398 E9D701                   jmp @@retn
  3483                                  
  3484                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3485                                  
  3486                                  @@testReg161:
  3487 0000139B 68[A015]                 push testReg_15
  3488 0000139E 8D064F75                 lea  ax, [SymbolUpper]
  3489 000013A2 50                       push ax
  3490 000013A3 E8210B                   call eqstr
  3491 000013A6 83C404                   add  sp, 4
  3492 000013A9 08C0                     or  al, al
  3493 000013AB 0F840900                 je @@testReg162
  3494 000013AF 66B807000000             mov eax, 7
  3495 000013B5 E9BA01                   jmp @@retn
  3496                                  
  3497                                  ;-93   RegType=SEGREG;
  3498                                  
  3499                                  @@testReg162:
  3500 000013B8 66B804000000             mov eax, 4
  3501 000013BE A2[3E00]                 mov byte [RegType], al
  3502                                  
  3503                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3504                                  
  3505 000013C1 68[A315]                 push testReg_16
  3506 000013C4 8D064F75                 lea  ax, [SymbolUpper]
  3507 000013C8 50                       push ax
  3508 000013C9 E8FB0A                   call eqstr
  3509 000013CC 83C404                   add  sp, 4
  3510 000013CF 08C0                     or  al, al
  3511 000013D1 0F840900                 je @@testReg163
  3512 000013D5 66B800000000             mov eax, 0
  3513 000013DB E99401                   jmp @@retn
  3514                                  
  3515                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3516                                  
  3517                                  @@testReg163:
  3518 000013DE 68[A615]                 push testReg_17
  3519 000013E1 8D064F75                 lea  ax, [SymbolUpper]
  3520 000013E5 50                       push ax
  3521 000013E6 E8DE0A                   call eqstr
  3522 000013E9 83C404                   add  sp, 4
  3523 000013EC 08C0                     or  al, al
  3524 000013EE 0F840900                 je @@testReg164
  3525 000013F2 66B801000000             mov eax, 1
  3526 000013F8 E97701                   jmp @@retn
  3527                                  
  3528                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3529                                  
  3530                                  @@testReg164:
  3531 000013FB 68[A915]                 push testReg_18
  3532 000013FE 8D064F75                 lea  ax, [SymbolUpper]
  3533 00001402 50                       push ax
  3534 00001403 E8C10A                   call eqstr
  3535 00001406 83C404                   add  sp, 4
  3536 00001409 08C0                     or  al, al
  3537 0000140B 0F840900                 je @@testReg165
  3538 0000140F 66B802000000             mov eax, 2
  3539 00001415 E95A01                   jmp @@retn
  3540                                  
  3541                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3542                                  
  3543                                  @@testReg165:
  3544 00001418 68[AC15]                 push testReg_19
  3545 0000141B 8D064F75                 lea  ax, [SymbolUpper]
  3546 0000141F 50                       push ax
  3547 00001420 E8A40A                   call eqstr
  3548 00001423 83C404                   add  sp, 4
  3549 00001426 08C0                     or  al, al
  3550 00001428 0F840900                 je @@testReg166
  3551 0000142C 66B803000000             mov eax, 3
  3552 00001432 E93D01                   jmp @@retn
  3553                                  
  3554                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3555                                  
  3556                                  @@testReg166:
  3557 00001435 68[AF15]                 push testReg_20
  3558 00001438 8D064F75                 lea  ax, [SymbolUpper]
  3559 0000143C 50                       push ax
  3560 0000143D E8870A                   call eqstr
  3561 00001440 83C404                   add  sp, 4
  3562 00001443 08C0                     or  al, al
  3563 00001445 0F840900                 je @@testReg167
  3564 00001449 66B804000000             mov eax, 4
  3565 0000144F E92001                   jmp @@retn
  3566                                  
  3567                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3568                                  
  3569                                  @@testReg167:
  3570 00001452 68[B215]                 push testReg_21
  3571 00001455 8D064F75                 lea  ax, [SymbolUpper]
  3572 00001459 50                       push ax
  3573 0000145A E86A0A                   call eqstr
  3574 0000145D 83C404                   add  sp, 4
  3575 00001460 08C0                     or  al, al
  3576 00001462 0F840900                 je @@testReg168
  3577 00001466 66B805000000             mov eax, 5
  3578 0000146C E90301                   jmp @@retn
  3579                                  
  3580                                  ;-100   RegType=DWORD;
  3581                                  
  3582                                  @@testReg168:
  3583 0000146F 66B803000000             mov eax, 3
  3584 00001475 A2[3E00]                 mov byte [RegType], al
  3585                                  
  3586                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3587                                  
  3588 00001478 68[B515]                 push testReg_22
  3589 0000147B 8D064F75                 lea  ax, [SymbolUpper]
  3590 0000147F 50                       push ax
  3591 00001480 E8440A                   call eqstr
  3592 00001483 83C404                   add  sp, 4
  3593 00001486 08C0                     or  al, al
  3594 00001488 0F840900                 je @@testReg169
  3595 0000148C 66B800000000             mov eax, 0
  3596 00001492 E9DD00                   jmp @@retn
  3597                                  
  3598                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3599                                  
  3600                                  @@testReg169:
  3601 00001495 68[B915]                 push testReg_23
  3602 00001498 8D064F75                 lea  ax, [SymbolUpper]
  3603 0000149C 50                       push ax
  3604 0000149D E8270A                   call eqstr
  3605 000014A0 83C404                   add  sp, 4
  3606 000014A3 08C0                     or  al, al
  3607 000014A5 0F840900                 je @@testReg170
  3608 000014A9 66B801000000             mov eax, 1
  3609 000014AF E9C000                   jmp @@retn
  3610                                  
  3611                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3612                                  
  3613                                  @@testReg170:
  3614 000014B2 68[BD15]                 push testReg_24
  3615 000014B5 8D064F75                 lea  ax, [SymbolUpper]
  3616 000014B9 50                       push ax
  3617 000014BA E80A0A                   call eqstr
  3618 000014BD 83C404                   add  sp, 4
  3619 000014C0 08C0                     or  al, al
  3620 000014C2 0F840900                 je @@testReg171
  3621 000014C6 66B802000000             mov eax, 2
  3622 000014CC E9A300                   jmp @@retn
  3623                                  
  3624                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3625                                  
  3626                                  @@testReg171:
  3627 000014CF 68[C115]                 push testReg_25
  3628 000014D2 8D064F75                 lea  ax, [SymbolUpper]
  3629 000014D6 50                       push ax
  3630 000014D7 E8ED09                   call eqstr
  3631 000014DA 83C404                   add  sp, 4
  3632 000014DD 08C0                     or  al, al
  3633 000014DF 0F840900                 je @@testReg172
  3634 000014E3 66B803000000             mov eax, 3
  3635 000014E9 E98600                   jmp @@retn
  3636                                  
  3637                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3638                                  
  3639                                  @@testReg172:
  3640 000014EC 68[C515]                 push testReg_26
  3641 000014EF 8D064F75                 lea  ax, [SymbolUpper]
  3642 000014F3 50                       push ax
  3643 000014F4 E8D009                   call eqstr
  3644 000014F7 83C404                   add  sp, 4
  3645 000014FA 08C0                     or  al, al
  3646 000014FC 0F840900                 je @@testReg173
  3647 00001500 66B804000000             mov eax, 4
  3648 00001506 E96900                   jmp @@retn
  3649                                  
  3650                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3651                                  
  3652                                  @@testReg173:
  3653 00001509 68[C915]                 push testReg_27
  3654 0000150C 8D064F75                 lea  ax, [SymbolUpper]
  3655 00001510 50                       push ax
  3656 00001511 E8B309                   call eqstr
  3657 00001514 83C404                   add  sp, 4
  3658 00001517 08C0                     or  al, al
  3659 00001519 0F840900                 je @@testReg174
  3660 0000151D 66B805000000             mov eax, 5
  3661 00001523 E94C00                   jmp @@retn
  3662                                  
  3663                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3664                                  
  3665                                  @@testReg174:
  3666 00001526 68[CD15]                 push testReg_28
  3667 00001529 8D064F75                 lea  ax, [SymbolUpper]
  3668 0000152D 50                       push ax
  3669 0000152E E89609                   call eqstr
  3670 00001531 83C404                   add  sp, 4
  3671 00001534 08C0                     or  al, al
  3672 00001536 0F840900                 je @@testReg175
  3673 0000153A 66B806000000             mov eax, 6
  3674 00001540 E92F00                   jmp @@retn
  3675                                  
  3676                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3677                                  
  3678                                  @@testReg175:
  3679 00001543 68[D115]                 push testReg_29
  3680 00001546 8D064F75                 lea  ax, [SymbolUpper]
  3681 0000154A 50                       push ax
  3682 0000154B E87909                   call eqstr
  3683 0000154E 83C404                   add  sp, 4
  3684 00001551 08C0                     or  al, al
  3685 00001553 0F840900                 je @@testReg176
  3686 00001557 66B807000000             mov eax, 7
  3687 0000155D E91200                   jmp @@retn
  3688                                  
  3689                                  ;-109   RegType=0; return 0;
  3690                                  
  3691                                  @@testReg176:
  3692 00001560 66B800000000             mov eax, 0
  3693 00001566 A2[3E00]                 mov byte [RegType], al
  3694 00001569 66B800000000             mov eax, 0
  3695 0000156F E90000                   jmp @@retn
  3696                                  
  3697                                  ;-110 }
  3698                                  
  3699                                  @@retn:
  3700 00001572 C3                       ret
  3701                                  ; ENDP
  3702 00001573 414C00                  testReg_0 db "AL",0
  3703 00001576 434C00                  testReg_1 db "CL",0
  3704 00001579 444C00                  testReg_2 db "DL",0
  3705 0000157C 424C00                  testReg_3 db "BL",0
  3706 0000157F 414800                  testReg_4 db "AH",0
  3707 00001582 434800                  testReg_5 db "CH",0
  3708 00001585 444800                  testReg_6 db "DH",0
  3709 00001588 424800                  testReg_7 db "BH",0
  3710 0000158B 415800                  testReg_8 db "AX",0
  3711 0000158E 435800                  testReg_9 db "CX",0
  3712 00001591 445800                  testReg_10 db "DX",0
  3713 00001594 425800                  testReg_11 db "BX",0
  3714 00001597 535000                  testReg_12 db "SP",0
  3715 0000159A 425000                  testReg_13 db "BP",0
  3716 0000159D 534900                  testReg_14 db "SI",0
  3717 000015A0 444900                  testReg_15 db "DI",0
  3718 000015A3 455300                  testReg_16 db "ES",0
  3719 000015A6 435300                  testReg_17 db "CS",0
  3720 000015A9 535300                  testReg_18 db "SS",0
  3721 000015AC 445300                  testReg_19 db "DS",0
  3722 000015AF 465300                  testReg_20 db "FS",0
  3723 000015B2 475300                  testReg_21 db "GS",0
  3724 000015B5 45415800                testReg_22 db "EAX",0
  3725 000015B9 45435800                testReg_23 db "ECX",0
  3726 000015BD 45445800                testReg_24 db "EDX",0
  3727 000015C1 45425800                testReg_25 db "EBX",0
  3728 000015C5 45535000                testReg_26 db "ESP",0
  3729 000015C9 45425000                testReg_27 db "EBP",0
  3730 000015CD 45534900                testReg_28 db "ESI",0
  3731 000015D1 45444900                testReg_29 db "EDI",0
  3732                                  ;Back to main program: AS.C
  3733                                  
  3734                                  ;-183 #include "OUTPUT.C"
  3735                                  
  3736                                  ;Use include file: OUTPUT.C
  3737                                  
  3738                                  ;-1 int printLine() { int i; char c;
  3739                                  
  3740                                  
  3741                                  printLine:  ; *** PROC ***
  3742                                  
  3743                                  ;-2   prs("\n"); printhex16(PCStart);
  3744                                  
  3745                                  ;Function : printLine, Number of local variables: 2
  3746                                  ;   # type sign width line used address name   list of local variables
  3747                                  ;  200 var sign word     1 NULL bp-2    i
  3748                                  ;  201 var sign byte     1 NULL bp-4    c;
  3749 000015D5 C8040000                 ENTER  4,0
  3750 000015D9 68[6A16]                 push printLine_0
  3751 000015DC E80401                   call prs
  3752 000015DF 83C402                   add  sp, 2
  3753 000015E2 FF36[3800]               push word [PCStart]
  3754 000015E6 E8EB01                   call printhex16
  3755 000015E9 83C402                   add  sp, 2
  3756                                  
  3757                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  3758                                  
  3759 000015EC A1[4900]                 mov ax, [OpPrintIndex]
  3760 000015EF 83F800                   cmp ax, 0
  3761 000015F2 0F850C00                 jne @@printLine177
  3762 000015F6 68[6D16]                 push printLine_1
  3763 000015F9 E8E700                   call prs
  3764 000015FC 83C402                   add  sp, 2
  3765                                  
  3766                                  ;-4   else {
  3767                                  
  3768 000015FF E95B00                   jmp @@printLine178
  3769                                  @@printLine177:
  3770                                  
  3771                                  ;-5     prc(PrReloc);
  3772                                  
  3773 00001602 A0[4D00]                 mov al, byte [PrReloc]
  3774 00001605 B400                     mov ah, 0
  3775 00001607 50                       push ax
  3776 00001608 E87700                   call prc
  3777 0000160B 83C402                   add  sp, 2
  3778                                  
  3779                                  ;-6     i=0;
  3780                                  
  3781 0000160E 66B800000000             mov eax, 0
  3782 00001614 8946FE                   mov word [bp-2], ax
  3783                                  
  3784                                  ;-7     do {
  3785                                  
  3786                                  @@printLine179:
  3787                                  
  3788                                  ;-8       c=OpPos[i];
  3789                                  
  3790 00001617 8B5EFE                   mov bx, [bp-2]
  3791 0000161A 8A87B776                 mov al, [OpPos + bx]
  3792 0000161E 8846FC                   mov byte [bp-4], al
  3793                                  
  3794                                  ;-9       printhex8a(c); prc(' ');
  3795                                  
  3796 00001621 8A46FC                   mov al, byte [bp-4]
  3797 00001624 B400                     mov ah, 0
  3798 00001626 50                       push ax
  3799 00001627 E85C01                   call printhex8a
  3800 0000162A 83C402                   add  sp, 2
  3801 0000162D 6A20                     push 32
  3802 0000162F E85000                   call prc
  3803 00001632 83C402                   add  sp, 2
  3804                                  
  3805                                  ;-10       i++;
  3806                                  
  3807 00001635 FF46FE                   inc  word [bp-2]
  3808                                  
  3809                                  ;-11     } while(i < OpPrintIndex);
  3810                                  
  3811 00001638 8B46FE                   mov ax, [bp-2]
  3812 0000163B 3B06[4900]               cmp ax, [OpPrintIndex]
  3813 0000163F 0F8D0200                 jge @@printLine180
  3814 00001643 EBD2                     jmp @@printLine179
  3815                                  @@printLine180:
  3816                                  
  3817                                  ;-12     do {// fill rest with blank
  3818                                  
  3819                                  @@printLine181:
  3820                                  
  3821                                  ;-13       prs("   ");
  3822                                  
  3823 00001645 68[7E16]                 push printLine_2
  3824 00001648 E89800                   call prs
  3825 0000164B 83C402                   add  sp, 2
  3826                                  
  3827                                  ;-14       i++;
  3828                                  
  3829 0000164E FF46FE                   inc  word [bp-2]
  3830                                  
  3831                                  ;-15     } while(i < OPMAXLEN);
  3832                                  
  3833 00001651 8B46FE                   mov ax, [bp-2]
  3834 00001654 83F805                   cmp ax, 5
  3835 00001657 0F8D0200                 jge @@printLine182
  3836 0000165B EBE8                     jmp @@printLine181
  3837                                  @@printLine182:
  3838                                  
  3839                                  ;-16   }
  3840                                  
  3841                                  
  3842                                  ;-17   prscomment(InputBuf);
  3843                                  
  3844                                  @@printLine178:
  3845 0000165D 8D066E75                 lea  ax, [InputBuf]
  3846 00001661 50                       push ax
  3847 00001662 E85000                   call prscomment
  3848 00001665 83C402                   add  sp, 2
  3849                                  
  3850                                  ;-18 }
  3851                                  
  3852                                  
  3853                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  3854 00001668 C9                       LEAVE
  3855 00001669 C3                       ret
  3856                                  ; ENDP
  3857 0000166A 5C6E00                  printLine_0 db "\n",0
  3858 0000166D 202020202020202020-     printLine_1 db "                ",0
  3859 00001676 2020202020202000   
  3860 0000167E 20202000                printLine_2 db "   ",0
  3861                                  
  3862                                  prc:  ; *** PROC ***
  3863                                  ;Function : prc, Number of local variables: 1
  3864                                  ;   # type sign width line used address name   list of local variables
  3865                                  ;  200 var unsg byte    19 NULL bp+4    c;
  3866 00001682 C8000000                 ENTER  0,0
  3867 00001686 A0[2400]                 mov al, [LIST]
  3868 00001689 08C0                     or  al, al
  3869 0000168B 0F841400                 je @@prc183
  3870 0000168F 807E040A                cmp byte [bp+4], 10
  3871 00001693 0F850600                 jne @@prc184
  3872 00001697 B80D00                   mov  ax, 13
  3873 0000169A E81A07                   call writetty
  3874                                  
  3875                                  ;-20      al=c; writetty(); }
  3876                                  
  3877                                  @@prc184:
  3878 0000169D 8A4604                   mov  al, [bp+4]
  3879 000016A0 E81407                   call writetty
  3880                                  
  3881                                  ;-21    fputcR(c,lst_fd); }
  3882                                  
  3883                                  @@prc183:
  3884 000016A3 FF36[2B00]               push word [lst_fd]
  3885 000016A7 8A4604                   mov al, byte [bp+4]
  3886 000016AA B400                     mov ah, 0
  3887 000016AC 50                       push ax
  3888 000016AD E8C708                   call fputcR
  3889 000016B0 83C404                   add  sp, 4
  3890                                  
  3891                                  ;-22 
  3892                                  
  3893                                  
  3894                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  3895 000016B3 C9                       LEAVE
  3896 000016B4 C3                       ret
  3897                                  ; ENDP
  3898                                  
  3899                                  prscomment:  ; *** PROC ***
  3900                                  
  3901                                  ;-24   while(*s){c=*s;prc(c);s++;}
  3902                                  
  3903                                  ;Function : prscomment, Number of local variables: 2
  3904                                  ;   # type sign width line used address name   list of local variables
  3905                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  3906                                  ;  201 var unsg byte    23 NULL bp-2    c;
  3907 000016B5 C8020000                 ENTER  2,0
  3908                                  @@prscomment185:
  3909 000016B9 8B5E04                   mov bx, [bp+4]
  3910 000016BC 8A07                     mov al, [bx]
  3911 000016BE B400                     mov ah, 0
  3912 000016C0 08C0                     or  al, al
  3913 000016C2 0F841B00                 je @@prscomment186
  3914 000016C6 8B5E04                   mov bx, [bp+4]
  3915 000016C9 8A07                     mov al, [bx]
  3916 000016CB B400                     mov ah, 0
  3917 000016CD 8846FE                   mov byte [bp-2], al
  3918 000016D0 8A46FE                   mov al, byte [bp-2]
  3919 000016D3 B400                     mov ah, 0
  3920 000016D5 50                       push ax
  3921 000016D6 E8A9FF                   call prc
  3922 000016D9 83C402                   add  sp, 2
  3923 000016DC FF4604                   inc  word [bp+4]
  3924                                  
  3925                                  ;-25 }
  3926                                  
  3927 000016DF EBD8                     jmp @@prscomment185
  3928                                  @@prscomment186:
  3929                                  
  3930                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3931 000016E1 C9                       LEAVE
  3932 000016E2 C3                       ret
  3933                                  ; ENDP
  3934                                  
  3935                                  prs:  ; *** PROC ***
  3936                                  ;Function : prs, Number of local variables: 3
  3937                                  ;   # type sign width line used address name   list of local variables
  3938                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3939                                  ;  201 var unsg byte    26 NULL bp-2    c
  3940                                  ;  202 var sign word    26 NULL bp-4    com;
  3941 000016E3 C8040000                 ENTER  4,0
  3942 000016E7 66B800000000             mov eax, 0
  3943 000016ED 8946FC                   mov word [bp-4], ax
  3944                                  
  3945                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3946                                  
  3947                                  @@prs187:
  3948 000016F0 8B5E04                   mov bx, [bp+4]
  3949 000016F3 8A07                     mov al, [bx]
  3950 000016F5 B400                     mov ah, 0
  3951 000016F7 08C0                     or  al, al
  3952 000016F9 0F848700                 je @@prs188
  3953 000016FD 8B5E04                   mov bx, [bp+4]
  3954 00001700 8A07                     mov al, [bx]
  3955 00001702 B400                     mov ah, 0
  3956 00001704 8846FE                   mov byte [bp-2], al
  3957 00001707 8A46FE                   mov al, [bp-2]
  3958 0000170A 3C22                     cmp al, 34
  3959 0000170C 0F851E00                 jne @@prs189
  3960 00001710 8B46FC                   mov ax, [bp-4]
  3961 00001713 08C0                     or  al, al
  3962 00001715 0F840C00                 je @@prs190
  3963 00001719 66B800000000             mov eax, 0
  3964 0000171F 8946FC                   mov word [bp-4], ax
  3965 00001722 E90900                   jmp @@prs191
  3966                                  @@prs190:
  3967 00001725 66B801000000             mov eax, 1
  3968 0000172B 8946FC                   mov word [bp-4], ax
  3969                                  
  3970                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3971                                  
  3972                                  @@prs191:
  3973                                  @@prs189:
  3974 0000172E 8A46FE                   mov al, [bp-2]
  3975 00001731 3C5C                     cmp al, 92
  3976 00001733 0F853B00                 jne @@prs192
  3977 00001737 8B46FC                   mov ax, [bp-4]
  3978 0000173A 83F800                   cmp ax, 0
  3979 0000173D 0F853100                 jne @@prs193
  3980 00001741 FF4604                   inc  word [bp+4]
  3981 00001744 8B5E04                   mov bx, [bp+4]
  3982 00001747 8A07                     mov al, [bx]
  3983 00001749 B400                     mov ah, 0
  3984 0000174B 8846FE                   mov byte [bp-2], al
  3985                                  
  3986                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3987                                  
  3988 0000174E 8A46FE                   mov al, [bp-2]
  3989 00001751 3C6E                     cmp al, 110
  3990 00001753 0F850900                 jne @@prs194
  3991 00001757 66B80A000000             mov eax, 10
  3992 0000175D 8846FE                   mov byte [bp-2], al
  3993                                  @@prs194:
  3994 00001760 8A46FE                   mov al, [bp-2]
  3995 00001763 3C74                     cmp al, 116
  3996 00001765 0F850900                 jne @@prs195
  3997 00001769 66B809000000             mov eax, 9
  3998 0000176F 8846FE                   mov byte [bp-2], al
  3999                                  @@prs195:
  4000                                  @@prs193:
  4001                                  @@prs192:
  4002 00001772 8A46FE                   mov al, byte [bp-2]
  4003 00001775 B400                     mov ah, 0
  4004 00001777 50                       push ax
  4005 00001778 E807FF                   call prc
  4006 0000177B 83C402                   add  sp, 2
  4007 0000177E FF4604                   inc  word [bp+4]
  4008                                  
  4009                                  ;-30 }
  4010                                  
  4011 00001781 E96CFF                   jmp @@prs187
  4012                                  @@prs188:
  4013                                  
  4014                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4015 00001784 C9                       LEAVE
  4016 00001785 C3                       ret
  4017                                  ; ENDP
  4018                                  
  4019                                  printhex8a:  ; *** PROC ***
  4020                                  
  4021                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4022                                  
  4023                                  ;Function : printhex8a, Number of local variables: 2
  4024                                  ;   # type sign width line used address name   list of local variables
  4025                                  ;  200 var unsg word    31 NULL bp+4    c
  4026                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4027 00001786 C8020000                 ENTER  2,0
  4028 0000178A 8B4604                   mov ax, [bp+4]
  4029 0000178D C1E804                   shr ax, 4
  4030 00001790 8946FE                   mov word [bp-2], ax
  4031 00001793 8346FE30                 add  word [bp-2], 48
  4032 00001797 8B46FE                   mov ax, [bp-2]
  4033 0000179A 83F839                   cmp ax, 57
  4034 0000179D 0F8E0400                 jle @@printhex8a196
  4035 000017A1 8346FE07                 add  word [bp-2], 7
  4036                                  @@printhex8a196:
  4037 000017A5 FF76FE                   push word [bp-2]
  4038 000017A8 E8D7FE                   call prc
  4039 000017AB 83C402                   add  sp, 2
  4040                                  
  4041                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4042                                  
  4043 000017AE 8B4604                   mov ax, [bp+4]
  4044 000017B1 83E00F                   and ax, 15
  4045 000017B4 8946FE                   mov word [bp-2], ax
  4046 000017B7 8346FE30                 add  word [bp-2], 48
  4047 000017BB 8B46FE                   mov ax, [bp-2]
  4048 000017BE 83F839                   cmp ax, 57
  4049 000017C1 0F8E0400                 jle @@printhex8a197
  4050 000017C5 8346FE07                 add  word [bp-2], 7
  4051                                  @@printhex8a197:
  4052 000017C9 FF76FE                   push word [bp-2]
  4053 000017CC E8B3FE                   call prc
  4054 000017CF 83C402                   add  sp, 2
  4055                                  
  4056                                  ;-34 }
  4057                                  
  4058                                  
  4059                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4060 000017D2 C9                       LEAVE
  4061 000017D3 C3                       ret
  4062                                  ; ENDP
  4063                                  
  4064                                  printhex16:  ; *** PROC ***
  4065                                  
  4066                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4067                                  
  4068                                  ;Function : printhex16, Number of local variables: 2
  4069                                  ;   # type sign width line used address name   list of local variables
  4070                                  ;  200 var unsg word    35 NULL bp+4    i
  4071                                  ;  201 var unsg word    35 NULL bp-2    half;
  4072 000017D4 C8020000                 ENTER  2,0
  4073 000017D8 8B4604                   mov ax, [bp+4]
  4074 000017DB C1E808                   shr ax, 8
  4075 000017DE 8946FE                   mov word [bp-2], ax
  4076 000017E1 FF76FE                   push word [bp-2]
  4077 000017E4 E89FFF                   call printhex8a
  4078 000017E7 83C402                   add  sp, 2
  4079 000017EA 8B4604                   mov ax, [bp+4]
  4080 000017ED 25FF00                   and ax, 255
  4081 000017F0 8946FE                   mov word [bp-2], ax
  4082 000017F3 FF76FE                   push word [bp-2]
  4083 000017F6 E88DFF                   call printhex8a
  4084 000017F9 83C402                   add  sp, 2
  4085                                  
  4086                                  ;-37 }
  4087                                  
  4088                                  
  4089                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4090 000017FC C9                       LEAVE
  4091 000017FD C3                       ret
  4092                                  ; ENDP
  4093                                  
  4094                                  printIntU:  ; *** PROC ***
  4095                                  
  4096                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4097                                  
  4098                                  ;Function : printIntU, Number of local variables: 2
  4099                                  ;   # type sign width line used address name   list of local variables
  4100                                  ;  200 var unsg word    38 NULL bp+4    n
  4101                                  ;  201 var unsg word    38 NULL bp-2    e;
  4102 000017FE C8020000                 ENTER  2,0
  4103 00001802 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4104 00001806 0F821700                 jb  @@printIntU198
  4105 0000180A 8B4604                   mov ax, [bp+4]
  4106 0000180D BB0A00                   mov bx, 10
  4107 00001810 BA0000                   mov dx, 0
  4108 00001813 F7F3                     div bx
  4109 00001815 8946FE                   mov word [bp-2], ax
  4110                                  
  4111                                  ;-40     printIntU(e); }
  4112                                  
  4113 00001818 FF76FE                   push word [bp-2]
  4114 0000181B E8E0FF                   call printIntU
  4115 0000181E 83C402                   add  sp, 2
  4116                                  
  4117                                  ;-41     n = n % 10; //unsigned mod
  4118                                  
  4119                                  @@printIntU198:
  4120 00001821 8B4604                   mov ax, [bp+4]
  4121 00001824 BB0A00                   mov bx, 10
  4122 00001827 BA0000                   mov dx, 0
  4123 0000182A F7F3                     div bx
  4124 0000182C 89D0                     mov ax, dx
  4125 0000182E 894604                   mov word [bp+4], ax
  4126                                  
  4127                                  ;-42     n += '0'; prc(n);
  4128                                  
  4129 00001831 83460430                 add  word [bp+4], 48
  4130 00001835 FF7604                   push word [bp+4]
  4131 00001838 E847FE                   call prc
  4132 0000183B 83C402                   add  sp, 2
  4133                                  
  4134                                  ;-43 }
  4135                                  
  4136                                  
  4137                                  ;-44 
  4138                                  
  4139                                  
  4140                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4141 0000183E C9                       LEAVE
  4142 0000183F C3                       ret
  4143                                  ; ENDP
  4144                                  
  4145                                  error1:  ; *** PROC ***
  4146                                  ;Function : error1, Number of local variables: 1
  4147                                  ;   # type sign width line used address name   list of local variables
  4148                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4149 00001840 C8000000                 ENTER  0,0
  4150 00001844 66B801000000             mov eax, 1
  4151 0000184A A2[2400]                 mov byte [LIST], al
  4152 0000184D FF06[3100]               inc  word [ErrorCount]
  4153                                  
  4154                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4155                                  
  4156 00001851 68[7918]                 push error1_0
  4157 00001854 E88CFE                   call prs
  4158 00001857 83C402                   add  sp, 2
  4159 0000185A FF7604                   push word [bp+4]
  4160 0000185D E883FE                   call prs
  4161 00001860 83C402                   add  sp, 2
  4162                                  
  4163                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4164                                  
  4165 00001863 68[9418]                 push error1_1
  4166 00001866 E87AFE                   call prs
  4167 00001869 83C402                   add  sp, 2
  4168 0000186C 8D063075                 lea  ax, [Symbol]
  4169 00001870 50                       push ax
  4170 00001871 E86FFE                   call prs
  4171 00001874 83C402                   add  sp, 2
  4172                                  
  4173                                  ;-48 int allowederror(){error1("not allowed here"); }
  4174 00001877 C9                       LEAVE
  4175 00001878 C3                       ret
  4176                                  ; ENDP
  4177 00001879 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4178 00001882 6E657874206C696E65-
  4179 0000188B 204552524F523A2000 
  4180 00001894 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4181 0000189D 2000               
  4182                                  
  4183                                  allowederror:  ; *** PROC ***
  4184 0000189F 68[A918]                 push allowederror_0
  4185 000018A2 E89BFF                   call error1
  4186 000018A5 83C402                   add  sp, 2
  4187                                  
  4188                                  ;-49 int implmerror(){error1("not implemented");}
  4189                                  
  4190 000018A8 C3                       ret
  4191                                  ; ENDP
  4192 000018A9 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4193 000018B2 6564206865726500   
  4194                                  
  4195                                  implmerror:  ; *** PROC ***
  4196 000018BA 68[C418]                 push implmerror_0
  4197 000018BD E880FF                   call error1
  4198 000018C0 83C402                   add  sp, 2
  4199                                  
  4200                                  ;-50 int indexerror (){error1("invalid index register");}
  4201                                  
  4202 000018C3 C3                       ret
  4203                                  ; ENDP
  4204 000018C4 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4205 000018CD 6D656E74656400     
  4206                                  
  4207                                  indexerror:  ; *** PROC ***
  4208 000018D4 68[DE18]                 push indexerror_0
  4209 000018D7 E866FF                   call error1
  4210 000018DA 83C402                   add  sp, 2
  4211                                  
  4212                                  ;-51 int numbererror(){error1("number expected");}
  4213                                  
  4214 000018DD C3                       ret
  4215                                  ; ENDP
  4216 000018DE 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4217 000018E7 6E6465782072656769-
  4218 000018F0 7374657200         
  4219                                  
  4220                                  numbererror:  ; *** PROC ***
  4221 000018F5 68[FF18]                 push numbererror_0
  4222 000018F8 E845FF                   call error1
  4223 000018FB 83C402                   add  sp, 2
  4224                                  
  4225                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4226                                  
  4227 000018FE C3                       ret
  4228                                  ; ENDP
  4229 000018FF 6E756D626572206578-     numbererror_0 db "number expected",0
  4230 00001908 70656374656400     
  4231                                  
  4232                                  regmemerror:  ; *** PROC ***
  4233 0000190F 68[1919]                 push regmemerror_0
  4234 00001912 E82BFF                   call error1
  4235 00001915 83C402                   add  sp, 2
  4236                                  
  4237                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4238                                  
  4239 00001918 C3                       ret
  4240                                  ; ENDP
  4241 00001919 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4242 00001922 73746572206F72206D-
  4243 0000192B 656D6F727920616C6C-
  4244 00001934 6F77656400         
  4245                                  
  4246                                  segregerror:  ; *** PROC ***
  4247 00001939 68[4319]                 push segregerror_0
  4248 0000193C E801FF                   call error1
  4249 0000193F 83C402                   add  sp, 2
  4250                                  
  4251                                  ;-54 int syntaxerror(){error1("syntax");}
  4252                                  
  4253 00001942 C3                       ret
  4254                                  ; ENDP
  4255 00001943 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4256 0000194C 65676973746572206E-
  4257 00001955 6F7420616C6C6F7765-
  4258 0000195E 6400               
  4259                                  
  4260                                  syntaxerror:  ; *** PROC ***
  4261 00001960 68[6A19]                 push syntaxerror_0
  4262 00001963 E8DAFE                   call error1
  4263 00001966 83C402                   add  sp, 2
  4264                                  
  4265                                  ;-55 
  4266                                  
  4267                                  
  4268                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4269                                  
  4270 00001969 C3                       ret
  4271                                  ; ENDP
  4272 0000196A 73796E74617800          syntaxerror_0 db "syntax",0
  4273                                  
  4274                                  errorexit:  ; *** PROC ***
  4275                                  ;Function : errorexit, Number of local variables: 1
  4276                                  ;   # type sign width line used address name   list of local variables
  4277                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4278 00001971 C8000000                 ENTER  0,0
  4279 00001975 FF7604                   push word [bp+4]
  4280 00001978 E8C5FE                   call error1
  4281 0000197B 83C402                   add  sp, 2
  4282 0000197E 6A01                     push 1
  4283 00001980 E80704                   call end1
  4284 00001983 83C402                   add  sp, 2
  4285                                  
  4286                                  ;-57 int addrexit(){errorexit("illegal address");}
  4287 00001986 C9                       LEAVE
  4288 00001987 C3                       ret
  4289                                  ; ENDP
  4290                                  
  4291                                  addrexit:  ; *** PROC ***
  4292 00001988 68[9219]                 push addrexit_0
  4293 0000198B E8E3FF                   call errorexit
  4294 0000198E 83C402                   add  sp, 2
  4295                                  
  4296                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4297                                  
  4298 00001991 C3                       ret
  4299                                  ; ENDP
  4300 00001992 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4301 0000199B 64647265737300     
  4302                                  
  4303                                  internexit:  ; *** PROC ***
  4304 000019A2 68[AC19]                 push internexit_0
  4305 000019A5 E8C9FF                   call errorexit
  4306 000019A8 83C402                   add  sp, 2
  4307 000019AB C3                       ret
  4308                                  ; ENDP
  4309 000019AC 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4310 000019B5 6D70696C6572206572-
  4311 000019BE 726F7200           
  4312                                  ;Back to main program: AS.C
  4313                                  
  4314                                  ;-184 #include "MAIN.C"
  4315                                  
  4316                                  ;Use include file: MAIN.C
  4317                                  
  4318                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4319                                  
  4320                                  
  4321                                  getarg:  ; *** PROC ***
  4322                                  
  4323                                  ;-2   arglen1=*arglen;
  4324                                  
  4325                                  ;Function : getarg, Number of local variables: 3
  4326                                  ;   # type sign width line used address name   list of local variables
  4327                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4328                                  ;  201 var sign word     1 NULL bp-4    i
  4329                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4330 000019C2 C8060000                 ENTER  6,0
  4331 000019C6 8B1E[5600]               mov bx, [arglen]
  4332 000019CA 8A07                     mov al, [bx]
  4333 000019CC B400                     mov ah, 0
  4334 000019CE 8946FE                   mov word [bp-2], ax
  4335                                  
  4336                                  ;-3   if (arglen1==0) {
  4337                                  
  4338 000019D1 8B46FE                   mov ax, [bp-2]
  4339 000019D4 83F800                   cmp ax, 0
  4340 000019D7 0F851C00                 jne @@getarg199
  4341                                  
  4342                                  ;-4     cputs(Version1);
  4343                                  
  4344 000019DB 8D06[1000]               lea  ax, [Version1]
  4345 000019DF 50                       push ax
  4346 000019E0 E8DC03                   call cputs
  4347 000019E3 83C402                   add  sp, 2
  4348                                  
  4349                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4350                                  
  4351 000019E6 68[871B]                 push getarg_0
  4352 000019E9 E8D303                   call cputs
  4353 000019EC 83C402                   add  sp, 2
  4354                                  
  4355                                  ;-6     exitR(3);
  4356                                  
  4357 000019EF 6A03                     push 3
  4358 000019F1 E8A605                   call exitR
  4359 000019F4 83C402                   add  sp, 2
  4360                                  
  4361                                  ;-7   }
  4362                                  
  4363                                  
  4364                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4365                                  
  4366                                  @@getarg199:
  4367 000019F7 8B46FE                   mov ax, [bp-2]
  4368 000019FA 058100                   add ax, 129
  4369 000019FD 8946FC                   mov word [bp-4], ax
  4370 00001A00 66B800000000             mov eax, 0
  4371 00001A06 8B5EFC                   mov  bx, [bp-4]
  4372 00001A09 8907                     mov  [bx], ax
  4373 00001A0B FF4EFE                   dec  word [bp-2]
  4374                                  
  4375                                  ;-9   toupper(argv);
  4376                                  
  4377 00001A0E FF36[5800]               push word [argv]
  4378 00001A12 E8D803                   call toupper
  4379 00001A15 83C402                   add  sp, 2
  4380                                  
  4381                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4382                                  
  4383 00001A18 FF36[5800]               push word [argv]
  4384 00001A1C 8D06EE75                 lea  ax, [namein]
  4385 00001A20 50                       push ax
  4386 00001A21 E83704                   call strcpy
  4387 00001A24 83C404                   add  sp, 4
  4388 00001A27 68[AC1B]                 push getarg_1
  4389 00001A2A 8D06EE75                 lea  ax, [namein]
  4390 00001A2E 50                       push ax
  4391 00001A2F E8EA04                   call strcat1
  4392 00001A32 83C404                   add  sp, 4
  4393                                  
  4394                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4395                                  
  4396 00001A35 FF36[5800]               push word [argv]
  4397 00001A39 8D063176                 lea  ax, [namelst]
  4398 00001A3D 50                       push ax
  4399 00001A3E E81A04                   call strcpy
  4400 00001A41 83C404                   add  sp, 4
  4401 00001A44 68[AF1B]                 push getarg_2
  4402 00001A47 8D063176                 lea  ax, [namelst]
  4403 00001A4B 50                       push ax
  4404 00001A4C E8CD04                   call strcat1
  4405 00001A4F 83C404                   add  sp, 4
  4406                                  
  4407                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4408                                  
  4409 00001A52 FF36[5800]               push word [argv]
  4410 00001A56 8D067476                 lea  ax, [namebin]
  4411 00001A5A 50                       push ax
  4412 00001A5B E8FD03                   call strcpy
  4413 00001A5E 83C404                   add  sp, 4
  4414 00001A61 68[B41B]                 push getarg_3
  4415 00001A64 8D067476                 lea  ax, [namebin]
  4416 00001A68 50                       push ax
  4417 00001A69 E8B004                   call strcat1
  4418 00001A6C 83C404                   add  sp, 4
  4419                                  
  4420                                  ;-13 
  4421                                  
  4422                                  
  4423                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4424                                  
  4425 00001A6F 66B801000000             mov eax, 1
  4426 00001A75 A2[2400]                 mov byte [LIST], al
  4427 00001A78 66B800000000             mov eax, 0
  4428 00001A7E A3[2F00]                 mov word [DOS_ERR], ax
  4429 00001A81 66B800000000             mov eax, 0
  4430 00001A87 A3[3600]                 mov word [PC], ax
  4431 00001A8A 66B800000000             mov eax, 0
  4432 00001A90 A3[3100]                 mov word [ErrorCount], ax
  4433                                  
  4434                                  ;-15   asm_fd=openR (namein);
  4435                                  
  4436 00001A93 8D06EE75                 lea  ax, [namein]
  4437 00001A97 50                       push ax
  4438 00001A98 E8A604                   call openR
  4439 00001A9B 83C402                   add  sp, 2
  4440 00001A9E A3[2900]                 mov word [asm_fd], ax
  4441                                  
  4442                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4443                                  
  4444 00001AA1 A1[2F00]                 mov ax, [DOS_ERR]
  4445 00001AA4 08C0                     or  al, al
  4446 00001AA6 0F841C00                 je @@getarg200
  4447 00001AAA 68[B91B]                 push getarg_4
  4448 00001AAD E80F03                   call cputs
  4449 00001AB0 83C402                   add  sp, 2
  4450 00001AB3 8D06EE75                 lea  ax, [namein]
  4451 00001AB7 50                       push ax
  4452 00001AB8 E80403                   call cputs
  4453 00001ABB 83C402                   add  sp, 2
  4454 00001ABE 6A01                     push 1
  4455 00001AC0 E8D704                   call exitR
  4456 00001AC3 83C402                   add  sp, 2
  4457                                  
  4458                                  ;-17   lst_fd=creatR(namelst);
  4459                                  
  4460                                  @@getarg200:
  4461 00001AC6 8D063176                 lea  ax, [namelst]
  4462 00001ACA 50                       push ax
  4463 00001ACB E88204                   call creatR
  4464 00001ACE 83C402                   add  sp, 2
  4465 00001AD1 A3[2B00]                 mov word [lst_fd], ax
  4466                                  
  4467                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4468                                  
  4469 00001AD4 A1[2F00]                 mov ax, [DOS_ERR]
  4470 00001AD7 08C0                     or  al, al
  4471 00001AD9 0F841C00                 je @@getarg201
  4472 00001ADD 68[CF1B]                 push getarg_5
  4473 00001AE0 E8DC02                   call cputs
  4474 00001AE3 83C402                   add  sp, 2
  4475 00001AE6 8D063176                 lea  ax, [namelst]
  4476 00001AEA 50                       push ax
  4477 00001AEB E8D102                   call cputs
  4478 00001AEE 83C402                   add  sp, 2
  4479 00001AF1 6A02                     push 2
  4480 00001AF3 E8A404                   call exitR
  4481 00001AF6 83C402                   add  sp, 2
  4482                                  
  4483                                  ;-19   bin_fd=creatR(namebin);
  4484                                  
  4485                                  @@getarg201:
  4486 00001AF9 8D067476                 lea  ax, [namebin]
  4487 00001AFD 50                       push ax
  4488 00001AFE E84F04                   call creatR
  4489 00001B01 83C402                   add  sp, 2
  4490 00001B04 A3[2D00]                 mov word [bin_fd], ax
  4491                                  
  4492                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4493                                  
  4494 00001B07 A1[2F00]                 mov ax, [DOS_ERR]
  4495 00001B0A 08C0                     or  al, al
  4496 00001B0C 0F841C00                 je @@getarg202
  4497 00001B10 68[E61B]                 push getarg_6
  4498 00001B13 E8A902                   call cputs
  4499 00001B16 83C402                   add  sp, 2
  4500 00001B19 8D067476                 lea  ax, [namebin]
  4501 00001B1D 50                       push ax
  4502 00001B1E E89E02                   call cputs
  4503 00001B21 83C402                   add  sp, 2
  4504 00001B24 6A02                     push 2
  4505 00001B26 E87104                   call exitR
  4506 00001B29 83C402                   add  sp, 2
  4507                                  
  4508                                  ;-21   prs(";");prs(Version1);
  4509                                  
  4510                                  @@getarg202:
  4511 00001B2C 68[FC1B]                 push getarg_7
  4512 00001B2F E8B1FB                   call prs
  4513 00001B32 83C402                   add  sp, 2
  4514 00001B35 8D06[1000]               lea  ax, [Version1]
  4515 00001B39 50                       push ax
  4516 00001B3A E8A6FB                   call prs
  4517 00001B3D 83C402                   add  sp, 2
  4518                                  
  4519                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4520                                  
  4521 00001B40 68[FE1B]                 push getarg_8
  4522 00001B43 E89DFB                   call prs
  4523 00001B46 83C402                   add  sp, 2
  4524 00001B49 8D06EE75                 lea  ax, [namein]
  4525 00001B4D 50                       push ax
  4526 00001B4E E892FB                   call prs
  4527 00001B51 83C402                   add  sp, 2
  4528 00001B54 68[091C]                 push getarg_9
  4529 00001B57 E889FB                   call prs
  4530 00001B5A 83C402                   add  sp, 2
  4531 00001B5D 8D063176                 lea  ax, [namelst]
  4532 00001B61 50                       push ax
  4533 00001B62 E87EFB                   call prs
  4534 00001B65 83C402                   add  sp, 2
  4535                                  
  4536                                  ;-23   prs(", "); prs(namebin);
  4537                                  
  4538 00001B68 68[141C]                 push getarg_10
  4539 00001B6B E875FB                   call prs
  4540 00001B6E 83C402                   add  sp, 2
  4541 00001B71 8D067476                 lea  ax, [namebin]
  4542 00001B75 50                       push ax
  4543 00001B76 E86AFB                   call prs
  4544 00001B79 83C402                   add  sp, 2
  4545                                  
  4546                                  ;-24   prs("\n");
  4547                                  
  4548 00001B7C 68[171C]                 push getarg_11
  4549 00001B7F E861FB                   call prs
  4550 00001B82 83C402                   add  sp, 2
  4551                                  
  4552                                  ;-25 }
  4553                                  
  4554                                  
  4555                                  ;-26 int epilog() { int i; int j; char c;
  4556 00001B85 C9                       LEAVE
  4557 00001B86 C3                       ret
  4558                                  ; ENDP
  4559 00001B87 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4560 00001B90 41532E434F4D206669-
  4561 00001B99 6C656E616D65205B77-
  4562 00001BA2 2F6F202E535D203A20-
  4563 00001BAB 00                 
  4564 00001BAC 2E5300                  getarg_1 db ".S",0
  4565 00001BAF 2E4C535400              getarg_2 db ".LST",0
  4566 00001BB4 2E434F4D00              getarg_3 db ".COM",0
  4567 00001BB9 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4568 00001BC2 6C65206D697373696E-
  4569 00001BCB 673A2000           
  4570 00001BCF 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4571 00001BD8 206E6F742063726561-
  4572 00001BE1 74653A2000         
  4573 00001BE6 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4574 00001BEF 6E6F74206372656174-
  4575 00001BF8 653A2000           
  4576 00001BFC 3B00                    getarg_7 db ";",0
  4577 00001BFE 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4578 00001C07 2000               
  4579 00001C09 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4580 00001C12 2000               
  4581 00001C14 2C2000                  getarg_10 db ", ",0
  4582 00001C17 5C6E00                  getarg_11 db "\n",0
  4583                                  
  4584                                  epilog:  ; *** PROC ***
  4585                                  
  4586                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4587                                  
  4588                                  ;Function : epilog, Number of local variables: 3
  4589                                  ;   # type sign width line used address name   list of local variables
  4590                                  ;  200 var sign word    26 NULL bp-2    i
  4591                                  ;  201 var sign word    26 NULL bp-4    j
  4592                                  ;  202 var sign byte    26 NULL bp-6    c;
  4593 00001C1A C8060000                 ENTER  6,0
  4594 00001C1E 68[431D]                 push epilog_0
  4595 00001C21 E8BFFA                   call prs
  4596 00001C24 83C402                   add  sp, 2
  4597 00001C27 FF36[3100]               push word [ErrorCount]
  4598 00001C2B E8D0FB                   call printIntU
  4599 00001C2E 83C402                   add  sp, 2
  4600                                  
  4601                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4602                                  
  4603 00001C31 A1[3100]                 mov ax, [ErrorCount]
  4604 00001C34 08C0                     or  al, al
  4605 00001C36 0F840900                 je @@epilog203
  4606 00001C3A 68[531D]                 push epilog_1
  4607 00001C3D E8A3FA                   call prs
  4608 00001C40 83C402                   add  sp, 2
  4609                                  
  4610                                  ;-29   prs(", Label & Var: ");
  4611                                  
  4612                                  @@epilog203:
  4613 00001C43 68[611D]                 push epilog_2
  4614 00001C46 E89AFA                   call prs
  4615 00001C49 83C402                   add  sp, 2
  4616                                  
  4617                                  ;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4618                                  
  4619                                  
  4620                                  ;-31   i= &LabelNames;
  4621                                  
  4622                                  
  4623                                  ;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4624                                  
  4625                                  
  4626                                  ;-33   } while (i < LabelNamePtr); prs("<< \n"); */
  4627                                  
  4628                                  
  4629                                  ;-34   if (LabelMaxIx) {
  4630                                  
  4631 00001C4C A1[5000]                 mov ax, [LabelMaxIx]
  4632 00001C4F 08C0                     or  al, al
  4633 00001C51 0F846900                 je @@epilog204
  4634                                  
  4635                                  ;-35     i = 1;
  4636                                  
  4637 00001C55 66B801000000             mov eax, 1
  4638 00001C5B 8946FE                   mov word [bp-2], ax
  4639                                  
  4640                                  ;-36     LabelNamePtr= &LabelNames;
  4641                                  
  4642 00001C5E B8BC76                   mov ax, LabelNames
  4643 00001C61 A3[4E00]                 mov word [LabelNamePtr], ax
  4644                                  
  4645                                  ;-37     do {
  4646                                  
  4647                                  @@epilog205:
  4648                                  
  4649                                  ;-38       prs(LabelNamePtr); prc(' ');
  4650                                  
  4651 00001C64 FF36[4E00]               push word [LabelNamePtr]
  4652 00001C68 E878FA                   call prs
  4653 00001C6B 83C402                   add  sp, 2
  4654 00001C6E 6A20                     push 32
  4655 00001C70 E80FFA                   call prc
  4656 00001C73 83C402                   add  sp, 2
  4657                                  
  4658                                  ;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4659                                  
  4660 00001C76 8B5EFE                   mov bx, [bp-2]
  4661 00001C79 D1E3                     shl bx, 1
  4662 00001C7B 8B87A47A                 mov ax, [LabelAddr + bx]
  4663 00001C7F 8946FC                   mov word [bp-4], ax
  4664 00001C82 FF76FC                   push word [bp-4]
  4665 00001C85 E84CFB                   call printhex16
  4666 00001C88 83C402                   add  sp, 2
  4667 00001C8B 68[711D]                 push epilog_3
  4668 00001C8E E852FA                   call prs
  4669 00001C91 83C402                   add  sp, 2
  4670                                  
  4671                                  ;-40       j=strlen(LabelNamePtr);//get end of actual name
  4672                                  
  4673 00001C94 FF36[4E00]               push word [LabelNamePtr]
  4674 00001C98 E89501                   call strlen
  4675 00001C9B 83C402                   add  sp, 2
  4676 00001C9E 8946FC                   mov word [bp-4], ax
  4677                                  
  4678                                  ;-41       LabelNamePtr=LabelNamePtr+j;
  4679                                  
  4680 00001CA1 A1[4E00]                 mov ax, [LabelNamePtr]
  4681 00001CA4 0346FC                   add ax, [bp-4]
  4682 00001CA7 A3[4E00]                 mov word [LabelNamePtr], ax
  4683                                  
  4684                                  ;-42       LabelNamePtr++;
  4685                                  
  4686 00001CAA FF06[4E00]               inc  word [LabelNamePtr]
  4687                                  
  4688                                  ;-43       i++;
  4689                                  
  4690 00001CAE FF46FE                   inc  word [bp-2]
  4691                                  
  4692                                  ;-44     } while (i <= LabelMaxIx);
  4693                                  
  4694 00001CB1 8B46FE                   mov ax, [bp-2]
  4695 00001CB4 3B06[5000]               cmp ax, [LabelMaxIx]
  4696 00001CB8 0F8F0200                 jg  @@epilog206
  4697 00001CBC EBA6                     jmp @@epilog205
  4698                                  @@epilog206:
  4699                                  
  4700                                  ;-45   }
  4701                                  
  4702                                  
  4703                                  ;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4704                                  
  4705                                  @@epilog204:
  4706 00001CBE 68[751D]                 push epilog_4
  4707 00001CC1 E81FFA                   call prs
  4708 00001CC4 83C402                   add  sp, 2
  4709 00001CC7 FF36[5400]               push word [BinLen]
  4710 00001CCB E830FB                   call printIntU
  4711 00001CCE 83C402                   add  sp, 2
  4712 00001CD1 68[821D]                 push epilog_5
  4713 00001CD4 E80CFA                   call prs
  4714 00001CD7 83C402                   add  sp, 2
  4715                                  
  4716                                  ;-47   i=0;
  4717                                  
  4718 00001CDA 66B800000000             mov eax, 0
  4719 00001CE0 8946FE                   mov word [bp-2], ax
  4720                                  
  4721                                  ;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4722                                  
  4723                                  @@epilog207:
  4724 00001CE3 6A20                     push 32
  4725 00001CE5 E89AF9                   call prc
  4726 00001CE8 83C402                   add  sp, 2
  4727 00001CEB 8B5EFE                   mov bx, [bp-2]
  4728 00001CEE 8A876C7B                 mov al, [FileBin + bx]
  4729 00001CF2 8946FC                   mov word [bp-4], ax
  4730 00001CF5 FF76FC                   push word [bp-4]
  4731 00001CF8 E88BFA                   call printhex8a
  4732 00001CFB 83C402                   add  sp, 2
  4733 00001CFE FF46FE                   inc  word [bp-2]
  4734                                  
  4735                                  ;-49   } while (i < BinLen);
  4736                                  
  4737 00001D01 8B46FE                   mov ax, [bp-2]
  4738 00001D04 3B06[5400]               cmp ax, [BinLen]
  4739 00001D08 0F8D0200                 jge @@epilog208
  4740 00001D0C EBD5                     jmp @@epilog207
  4741                                  @@epilog208:
  4742                                  
  4743                                  ;-50   i=0;
  4744                                  
  4745 00001D0E 66B800000000             mov eax, 0
  4746 00001D14 8946FE                   mov word [bp-2], ax
  4747                                  
  4748                                  ;-51   do {
  4749                                  
  4750                                  @@epilog209:
  4751                                  
  4752                                  ;-52     c = FileBin[i];
  4753                                  
  4754 00001D17 8B5EFE                   mov bx, [bp-2]
  4755 00001D1A 8A876C7B                 mov al, [FileBin + bx]
  4756 00001D1E 8846FA                   mov byte [bp-6], al
  4757                                  
  4758                                  ;-53     fputcR(c, bin_fd);
  4759                                  
  4760 00001D21 FF36[2D00]               push word [bin_fd]
  4761 00001D25 8A46FA                   mov al, byte [bp-6]
  4762 00001D28 B400                     mov ah, 0
  4763 00001D2A 50                       push ax
  4764 00001D2B E84902                   call fputcR
  4765 00001D2E 83C404                   add  sp, 4
  4766                                  
  4767                                  ;-54     i++;
  4768                                  
  4769 00001D31 FF46FE                   inc  word [bp-2]
  4770                                  
  4771                                  ;-55   } while (i < BinLen);
  4772                                  
  4773 00001D34 8B46FE                   mov ax, [bp-2]
  4774 00001D37 3B06[5400]               cmp ax, [BinLen]
  4775 00001D3B 0F8D0200                 jge @@epilog210
  4776 00001D3F EBD6                     jmp @@epilog209
  4777                                  @@epilog210:
  4778                                  
  4779                                  ;-56 }
  4780                                  
  4781                                  
  4782                                  ;-57 int end1(int n) {
  4783 00001D41 C9                       LEAVE
  4784 00001D42 C3                       ret
  4785                                  ; ENDP
  4786 00001D43 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4787 00001D4C 726F72733A2000     
  4788 00001D53 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4789 00001D5C 2A2A2A2000         
  4790 00001D61 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4791 00001D6A 205661723A2000     
  4792 00001D71 2C202000                epilog_3 db ",  ",0
  4793 00001D75 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4794 00001D7E 6C652000           
  4795 00001D82 2062797465733A00        epilog_5 db " bytes:",0
  4796                                  
  4797                                  end1:  ; *** PROC ***
  4798                                  
  4799                                  ;-58   fcloseR(asm_fd);
  4800                                  
  4801                                  ;Function : end1, Number of local variables: 1
  4802                                  ;   # type sign width line used address name   list of local variables
  4803                                  ;  200 var sign word    57 NULL bp+4    n;
  4804 00001D8A C8000000                 ENTER  0,0
  4805 00001D8E FF36[2900]               push word [asm_fd]
  4806 00001D92 E8F701                   call fcloseR
  4807 00001D95 83C402                   add  sp, 2
  4808                                  
  4809                                  ;-59   fcloseR(lst_fd);
  4810                                  
  4811 00001D98 FF36[2B00]               push word [lst_fd]
  4812 00001D9C E8ED01                   call fcloseR
  4813 00001D9F 83C402                   add  sp, 2
  4814                                  
  4815                                  ;-60   fcloseR(bin_fd);
  4816                                  
  4817 00001DA2 FF36[2D00]               push word [bin_fd]
  4818 00001DA6 E8E301                   call fcloseR
  4819 00001DA9 83C402                   add  sp, 2
  4820                                  
  4821                                  ;-61   exitR(n);
  4822                                  
  4823 00001DAC FF7604                   push word [bp+4]
  4824 00001DAF E8E801                   call exitR
  4825 00001DB2 83C402                   add  sp, 2
  4826                                  
  4827                                  ;-62 }
  4828 00001DB5 C9                       LEAVE
  4829 00001DB6 C3                       ret
  4830                                  ; ENDP
  4831                                  ;Back to main program: AS.C
  4832                                   
  4833                                  ; missing functions: 
  4834                                  ; digit
  4835                                  ; strcpy
  4836                                  ; eqstr
  4837                                  ; strlen
  4838                                  ; eqstr
  4839                                  ; eqstr
  4840                                  ; eqstr
  4841                                  ; eqstr
  4842                                  ; readRL
  4843                                  ; readRL
  4844                                  ; digit
  4845                                  ; digit
  4846                                  ; strcpy
  4847                                  ; toupper
  4848                                  ; strlen
  4849                                  ; strlen
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
  4874                                  ; eqstr
  4875                                  ; eqstr
  4876                                  ; eqstr
  4877                                  ; eqstr
  4878                                  ; eqstr
  4879                                  ; eqstr
  4880                                  ; writetty
  4881                                  ; writetty
  4882                                  ; fputcR
  4883                                  ; cputs
  4884                                  ; cputs
  4885                                  ; exitR
  4886                                  ; toupper
  4887                                  ; strcpy
  4888                                  ; strcat1
  4889                                  ; strcpy
  4890                                  ; strcat1
  4891                                  ; strcpy
  4892                                  ; strcat1
  4893                                  ; openR
  4894                                  ; cputs
  4895                                  ; cputs
  4896                                  ; exitR
  4897                                  ; creatR
  4898                                  ; cputs
  4899                                  ; cputs
  4900                                  ; exitR
  4901                                  ; creatR
  4902                                  ; cputs
  4903                                  ; cputs
  4904                                  ; exitR
  4905                                  ; strlen
  4906                                  ; fputcR
  4907                                  ; fcloseR
  4908                                  ; fcloseR
  4909                                  ; fcloseR
  4910                                  ; exitR
  4911                                  ; Number of unresolved CALLs :   77
  4912                                  ;use archive file: AR.C
  4913                                  
  4914                                  ;-185 // AR.C Archive
  4915                                  
  4916                                  ;Number of CALLs:    2 : writetty
  4917                                  
  4918                                  writetty:  ; *** PROC ***
  4919 00001DB7 B40E                     mov  ah, 14
  4920 00001DB9 BB0000                   mov  bx, 0
  4921 00001DBC CD10                     int  16
  4922                                  
  4923                                  ;-186 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  4924                                  
  4925 00001DBE C3                       ret
  4926                                  ; ENDP
  4927                                  ;Number of CALLs:    8 : cputs
  4928                                  
  4929                                  cputs:  ; *** PROC ***
  4930                                  ;Function : cputs, Number of local variables: 2
  4931                                  ;   # type sign width line used address name   list of local variables
  4932                                  ;  200 ptr sign byte   186 NULL bp+4    s
  4933                                  ;  201 var sign byte   186 NULL bp-2    c;
  4934 00001DBF C8020000                 ENTER  2,0
  4935                                  @@cputs211:
  4936 00001DC3 8B5E04                   mov bx, [bp+4]
  4937 00001DC6 8A07                     mov al, [bx]
  4938 00001DC8 B400                     mov ah, 0
  4939 00001DCA 08C0                     or  al, al
  4940 00001DCC 0F841B00                 je @@cputs212
  4941 00001DD0 8B5E04                   mov bx, [bp+4]
  4942 00001DD3 8A07                     mov al, [bx]
  4943 00001DD5 B400                     mov ah, 0
  4944 00001DD7 8846FE                   mov byte [bp-2], al
  4945 00001DDA 8A46FE                   mov al, byte [bp-2]
  4946 00001DDD B400                     mov ah, 0
  4947 00001DDF 50                       push ax
  4948 00001DE0 E8C401                   call putch
  4949 00001DE3 83C402                   add  sp, 2
  4950 00001DE6 FF4604                   inc  word [bp+4]
  4951 00001DE9 EBD8                     jmp @@cputs211
  4952                                  @@cputs212:
  4953                                  
  4954                                  ;-187 int mkneg(int n) { n; __asm {neg ax} }
  4955 00001DEB C9                       LEAVE
  4956 00001DEC C3                       ret
  4957                                  ; ENDP
  4958                                  ;Number of CALLs:    2 : toupper
  4959                                  
  4960                                  toupper:  ; *** PROC ***
  4961                                  ;Function : toupper, Number of local variables: 1
  4962                                  ;   # type sign width line used address name   list of local variables
  4963                                  ;  200 ptr sign byte   187 NULL bp+4    s;
  4964 00001DED C8000000                 ENTER  0,0
  4965                                  @@toupper213:
  4966 00001DF1 8B5E04                   mov bx, [bp+4]
  4967 00001DF4 8A07                     mov al, [bx]
  4968 00001DF6 B400                     mov ah, 0
  4969 00001DF8 08C0                     or  al, al
  4970 00001DFA 0F843000                 je @@toupper214
  4971 00001DFE 8B5E04                   mov bx, [bp+4]
  4972 00001E01 8A07                     mov al, [bx]
  4973 00001E03 B400                     mov ah, 0
  4974 00001E05 83F861                   cmp ax, 97 ;unsigned : 1
  4975 00001E08 0F8C1D00                 jl  @@toupper215
  4976 00001E0C 8B5E04                   mov bx, [bp+4]
  4977 00001E0F 8A07                     mov al, [bx]
  4978 00001E11 B400                     mov ah, 0
  4979 00001E13 83F87A                   cmp ax, 122
  4980 00001E16 0F8F0F00                 jg  @@toupper216
  4981 00001E1A 8B5E04                   mov bx, [bp+4]
  4982 00001E1D 8A07                     mov al, [bx]
  4983 00001E1F B400                     mov ah, 0
  4984 00001E21 83E820                   sub ax, 32
  4985 00001E24 8B5E04                   mov  bx, [bp+4]
  4986 00001E27 8807                     mov  [bx], al
  4987                                  @@toupper216:
  4988                                  @@toupper215:
  4989 00001E29 FF4604                   inc  word [bp+4]
  4990 00001E2C EBC3                     jmp @@toupper213
  4991                                  @@toupper214:
  4992                                  
  4993                                  ;-188 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  4994                                  
  4995                                  
  4996                                  ;-189 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  4997 00001E2E C9                       LEAVE
  4998 00001E2F C3                       ret
  4999                                  ; ENDP
  5000                                  ;Number of CALLs:    4 : strlen
  5001                                  
  5002                                  strlen:  ; *** PROC ***
  5003                                  ;Function : strlen, Number of local variables: 2
  5004                                  ;   # type sign width line used address name   list of local variables
  5005                                  ;  200 ptr sign byte   189 NULL bp+4    s
  5006                                  ;  201 var sign word   189 NULL bp-2    c;
  5007 00001E30 C8020000                 ENTER  2,0
  5008 00001E34 66B800000000             mov eax, 0
  5009 00001E3A 8946FE                   mov word [bp-2], ax
  5010                                  @@strlen217:
  5011 00001E3D 8B5E04                   mov bx, [bp+4]
  5012 00001E40 8A07                     mov al, [bx]
  5013 00001E42 B400                     mov ah, 0
  5014 00001E44 83F800                   cmp ax, 0
  5015 00001E47 0F840800                 je  @@strlen218
  5016 00001E4B FF4604                   inc  word [bp+4]
  5017 00001E4E FF46FE                   inc  word [bp-2]
  5018 00001E51 EBEA                     jmp @@strlen217
  5019                                  @@strlen218:
  5020 00001E53 8B46FE                   mov ax, [bp-2]
  5021 00001E56 E90000                   jmp @@retn
  5022                                  
  5023                                  ;-190 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5024                                  
  5025 00001E59 C9                      @@retn: LEAVE
  5026 00001E5A C3                       ret
  5027                                  ; ENDP
  5028                                  ;Number of CALLs:    5 : strcpy
  5029                                  
  5030                                  strcpy:  ; *** PROC ***
  5031                                  ;Function : strcpy, Number of local variables: 2
  5032                                  ;   # type sign width line used address name   list of local variables
  5033                                  ;  200 ptr sign byte   190 NULL bp+4    s
  5034                                  ;  201 ptr sign byte   190 NULL bp+6    t;
  5035 00001E5B C8000000                 ENTER  0,0
  5036                                  @@strcpy219:
  5037 00001E5F 8B5E06                   mov bx, [bp+6]
  5038 00001E62 8A07                     mov al, [bx]
  5039 00001E64 B400                     mov ah, 0
  5040 00001E66 8B5E04                   mov  bx, [bp+4]
  5041 00001E69 8807                     mov  [bx], al
  5042 00001E6B FF4604                   inc  word [bp+4]
  5043 00001E6E FF4606                   inc  word [bp+6]
  5044                                  
  5045                                  ;-191   while (*t!=0); *s=0; return s; }
  5046                                  
  5047 00001E71 8B5E06                   mov bx, [bp+6]
  5048 00001E74 8A07                     mov al, [bx]
  5049 00001E76 B400                     mov ah, 0
  5050 00001E78 83F800                   cmp ax, 0
  5051 00001E7B 0F840200                 je  @@strcpy220
  5052 00001E7F EBDE                     jmp @@strcpy219
  5053                                  @@strcpy220:
  5054 00001E81 66B800000000             mov eax, 0
  5055 00001E87 8B5E04                   mov  bx, [bp+4]
  5056 00001E8A 8807                     mov  [bx], al
  5057 00001E8C 8B4604                   mov ax, [bp+4]
  5058 00001E8F E90000                   jmp @@retn
  5059                                  
  5060                                  ;-192 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5061                                  
  5062 00001E92 C9                      @@retn: LEAVE
  5063 00001E93 C3                       ret
  5064                                  ; ENDP
  5065                                  ;Number of CALLs:    3 : digit
  5066                                  
  5067                                  digit:  ; *** PROC ***
  5068                                  ;Function : digit, Number of local variables: 1
  5069                                  ;   # type sign width line used address name   list of local variables
  5070                                  ;  200 var sign byte   192 NULL bp+4    c;
  5071 00001E94 C8000000                 ENTER  0,0
  5072 00001E98 8A4604                   mov al, [bp+4]
  5073 00001E9B 3C30                     cmp al, 48
  5074 00001E9D 0F8D0900                 jge @@digit221
  5075 00001EA1 66B800000000             mov eax, 0
  5076 00001EA7 E91B00                   jmp @@retn
  5077                                  @@digit221:
  5078 00001EAA 8A4604                   mov al, [bp+4]
  5079 00001EAD 3C39                     cmp al, 57
  5080 00001EAF 0F8E0900                 jle @@digit222
  5081 00001EB3 66B800000000             mov eax, 0
  5082 00001EB9 E90900                   jmp @@retn
  5083                                  @@digit222:
  5084 00001EBC 66B801000000             mov eax, 1
  5085 00001EC2 E90000                   jmp @@retn
  5086                                  
  5087                                  ;-193 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5088                                  
  5089 00001EC5 C9                      @@retn: LEAVE
  5090 00001EC6 C3                       ret
  5091                                  ; ENDP
  5092                                  ;Number of CALLs:   35 : eqstr
  5093                                  
  5094                                  eqstr:  ; *** PROC ***
  5095                                  ;Function : eqstr, Number of local variables: 2
  5096                                  ;   # type sign width line used address name   list of local variables
  5097                                  ;  200 ptr sign byte   193 NULL bp+4    p
  5098                                  ;  201 ptr sign byte   193 NULL bp+6    q;
  5099 00001EC7 C8000000                 ENTER  0,0
  5100                                  @@eqstr223:
  5101 00001ECB 8B5E04                   mov bx, [bp+4]
  5102 00001ECE 8A07                     mov al, [bx]
  5103 00001ED0 B400                     mov ah, 0
  5104 00001ED2 08C0                     or  al, al
  5105 00001ED4 0F842300                 je @@eqstr224
  5106                                  
  5107                                  ;-194     if (*p != *q) return 0; p++; q++; }
  5108                                  
  5109 00001ED8 8B5E04                   mov bx, [bp+4]
  5110 00001EDB 8A07                     mov al, [bx]
  5111 00001EDD B400                     mov ah, 0
  5112 00001EDF 8B5E06                   mov bx, [bp+6]
  5113 00001EE2 3A07                     cmp al, [bx]
  5114 00001EE4 B400                     mov ah, 0
  5115 00001EE6 0F840900                 je  @@eqstr225
  5116 00001EEA 66B800000000             mov eax, 0
  5117 00001EF0 E92700                   jmp @@retn
  5118                                  @@eqstr225:
  5119 00001EF3 FF4604                   inc  word [bp+4]
  5120 00001EF6 FF4606                   inc  word [bp+6]
  5121                                  
  5122                                  ;-195     if(*q) return 0; return 1; }
  5123                                  
  5124 00001EF9 EBD0                     jmp @@eqstr223
  5125                                  @@eqstr224:
  5126 00001EFB 8B5E06                   mov bx, [bp+6]
  5127 00001EFE 8A07                     mov al, [bx]
  5128 00001F00 B400                     mov ah, 0
  5129 00001F02 08C0                     or  al, al
  5130 00001F04 0F840900                 je @@eqstr226
  5131 00001F08 66B800000000             mov eax, 0
  5132 00001F0E E90900                   jmp @@retn
  5133                                  @@eqstr226:
  5134 00001F11 66B801000000             mov eax, 1
  5135 00001F17 E90000                   jmp @@retn
  5136                                  
  5137                                  ;-196 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5138                                  
  5139 00001F1A C9                      @@retn: LEAVE
  5140 00001F1B C3                       ret
  5141                                  ; ENDP
  5142                                  ;Number of CALLs:    3 : strcat1
  5143                                  
  5144                                  strcat1:  ; *** PROC ***
  5145                                  ;Function : strcat1, Number of local variables: 2
  5146                                  ;   # type sign width line used address name   list of local variables
  5147                                  ;  200 ptr sign byte   196 NULL bp+4    s
  5148                                  ;  201 ptr sign byte   196 NULL bp+6    t;
  5149 00001F1C C8000000                 ENTER  0,0
  5150                                  @@strcat1227:
  5151 00001F20 8B5E04                   mov bx, [bp+4]
  5152 00001F23 8A07                     mov al, [bx]
  5153 00001F25 B400                     mov ah, 0
  5154 00001F27 83F800                   cmp ax, 0
  5155 00001F2A 0F840500                 je  @@strcat1228
  5156 00001F2E FF4604                   inc  word [bp+4]
  5157 00001F31 EBED                     jmp @@strcat1227
  5158                                  @@strcat1228:
  5159 00001F33 FF7606                   push word [bp+6]
  5160 00001F36 FF7604                   push word [bp+4]
  5161 00001F39 E81FFF                   call strcpy
  5162 00001F3C 83C404                   add  sp, 4
  5163                                  
  5164                                  ;-197 int basename(char *s) { char *p; p=0;
  5165 00001F3F C9                       LEAVE
  5166 00001F40 C3                       ret
  5167                                  ; ENDP
  5168                                  ;Number of CALLs:    1 : openR
  5169                                  
  5170                                  openR:  ; *** PROC ***
  5171                                  ;Function : openR, Number of local variables: 1
  5172                                  ;   # type sign width line used address name   list of local variables
  5173                                  ;  200 ptr sign byte   197 NULL bp+4    s;
  5174 00001F41 C8000000                 ENTER  0,0
  5175 00001F45 8B5604                   mov  dx, [bp+4]
  5176 00001F48 B8023D                   mov  ax, 15618
  5177 00001F4B E87200                   call DosInt
  5178                                  
  5179                                  ;-198 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5180 00001F4E C9                       LEAVE
  5181 00001F4F C3                       ret
  5182                                  ; ENDP
  5183                                  ;Number of CALLs:    2 : creatR
  5184                                  
  5185                                  creatR:  ; *** PROC ***
  5186                                  ;Function : creatR, Number of local variables: 1
  5187                                  ;   # type sign width line used address name   list of local variables
  5188                                  ;  200 ptr sign byte   198 NULL bp+4    s;
  5189 00001F50 C8000000                 ENTER  0,0
  5190 00001F54 8B5604                   mov  dx, [bp+4]
  5191 00001F57 B90000                   mov  cx, 0
  5192 00001F5A B8003C                   mov  ax, 15360
  5193 00001F5D E86000                   call DosInt
  5194                                  
  5195                                  ;-199 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5196 00001F60 C9                       LEAVE
  5197 00001F61 C3                       ret
  5198                                  ; ENDP
  5199                                  ;Number of CALLs:    2 : readRL
  5200                                  
  5201                                  readRL:  ; *** PROC ***
  5202                                  ;Function : readRL, Number of local variables: 3
  5203                                  ;   # type sign width line used address name   list of local variables
  5204                                  ;  200 ptr sign byte   199 NULL bp+4    s
  5205                                  ;  201 var sign word   199 NULL bp+6    fd
  5206                                  ;  202 var sign word   199 NULL bp+8    len;
  5207 00001F62 C8000000                 ENTER  0,0
  5208 00001F66 8B5604                   mov  dx, [bp+4]
  5209 00001F69 8B4E08                   mov  cx, [bp+8]
  5210 00001F6C 8B5E06                   mov  bx, [bp+6]
  5211 00001F6F B8003F                   mov  ax, 16128
  5212 00001F72 E84B00                   call DosInt
  5213                                  
  5214                                  ;-200 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5215 00001F75 C9                       LEAVE
  5216 00001F76 C3                       ret
  5217                                  ; ENDP
  5218                                  ;Number of CALLs:    2 : fputcR
  5219                                  
  5220                                  fputcR:  ; *** PROC ***
  5221                                  ;Function : fputcR, Number of local variables: 2
  5222                                  ;   # type sign width line used address name   list of local variables
  5223                                  ;  200 ptr sign byte   200 NULL bp+4    n
  5224                                  ;  201 var sign word   200 NULL bp+6    fd;
  5225 00001F77 C8000000                 ENTER  0,0
  5226 00001F7B 8D5604                  lea dx, [bp+4]
  5227                                  
  5228                                  ;-201   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5229                                  
  5230 00001F7E B90100                   mov  cx, 1
  5231 00001F81 8B5E06                   mov  bx, [bp+6]
  5232 00001F84 B80040                   mov  ax, 16384
  5233 00001F87 E83600                   call DosInt
  5234                                  
  5235                                  ;-202 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5236 00001F8A C9                       LEAVE
  5237 00001F8B C3                       ret
  5238                                  ; ENDP
  5239                                  ;Number of CALLs:    3 : fcloseR
  5240                                  
  5241                                  fcloseR:  ; *** PROC ***
  5242                                  ;Function : fcloseR, Number of local variables: 1
  5243                                  ;   # type sign width line used address name   list of local variables
  5244                                  ;  200 var sign word   202 NULL bp+4    fd;
  5245 00001F8C C8000000                 ENTER  0,0
  5246 00001F90 8B5E04                   mov  bx, [bp+4]
  5247 00001F93 B8003E                   mov  ax, 15872
  5248 00001F96 CD21                     int  33
  5249                                  
  5250                                  ;-203 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5251 00001F98 C9                       LEAVE
  5252 00001F99 C3                       ret
  5253                                  ; ENDP
  5254                                  ;Number of CALLs:    5 : exitR
  5255                                  
  5256                                  exitR:  ; *** PROC ***
  5257                                  ;Function : exitR, Number of local variables: 1
  5258                                  ;   # type sign width line used address name   list of local variables
  5259                                  ;  200 var sign byte   203 NULL bp+4    c;
  5260 00001F9A C8000000                 ENTER  0,0
  5261 00001F9E B44C                     mov  ah, 76
  5262 00001FA0 8A4604                   mov  al, [bp+4]
  5263 00001FA3 CD21                     int  33
  5264                                  
  5265                                  ;-204 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5266 00001FA5 C9                       LEAVE
  5267 00001FA6 C3                       ret
  5268                                  ; ENDP
  5269                                  ;End of archive file. 
  5270                                   
  5271                                  ; missing functions: 
  5272                                  ; putch
  5273                                  ; DosInt
  5274                                  ; DosInt
  5275                                  ; DosInt
  5276                                  ; DosInt
  5277                                  ; Number of unresolved CALLs :    5
  5278                                  ;use archive file: AR.C
  5279                                  
  5280                                  ;-205 // AR.C Archive
  5281                                  
  5282                                  ;Number of CALLs:    1 : putch
  5283                                  
  5284                                  putch:  ; *** PROC ***
  5285                                  ;Function : putch, Number of local variables: 1
  5286                                  ;   # type sign width line used address name   list of local variables
  5287                                  ;  200 var sign byte   205 NULL bp+4    c;
  5288 00001FA7 C8000000                 ENTER  0,0
  5289 00001FAB 807E040A                cmp byte [bp+4], 10
  5290 00001FAF 0F850500                 jne @@putch229
  5291 00001FB3 B00D                     mov  al, 13
  5292 00001FB5 E8FFFD                   call writetty
  5293                                  @@putch229:
  5294 00001FB8 8A4604                   mov  al, [bp+4]
  5295 00001FBB E8F9FD                   call writetty
  5296                                  
  5297                                  ;-206 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5298 00001FBE C9                       LEAVE
  5299 00001FBF C3                       ret
  5300                                  ; ENDP
  5301                                  ;Number of CALLs:    4 : DosInt
  5302                                  
  5303                                  DosInt:  ; *** PROC ***
  5304 00001FC0 CD21                     int  33
  5305 00001FC2 7304                     jae short @@DosInt230
  5306 00001FC4 FF06[2F00]               inc  word [DOS_ERR]
  5307                                  @@DosInt230:
  5308                                  
  5309                                  ;-207 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5310                                  
  5311 00001FC8 C3                       ret
  5312                                  ; ENDP
  5313                                  ;End of archive file. 
  5314                                   
  5315                                  ; missing functions:  All FUNCTIONs in place
  5316 00001FC9 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5317 00001FCC 58                      pop ax
  5318 00001FCD C3                      ret
  5319                                   
  5320                                  ;   # type sign width line used  address name   list of global variables
  5321                                  
  5322                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5323                                  ;    2 var sign byte     1    3        0 LIST
  5324                                  ;    3 arr sign byte     2    7    30000 Symbol[31]
  5325                                  ;    4 arr sign byte     3   36    30031 SymbolUpper[31]
  5326                                  ;    5 var unsg word     4   12        0 SymbolInt
  5327                                  ;    6 arr sign byte     5    3    30062 InputBuf[128]
  5328                                  ;    7 ptr unsg byte     6   23        0 InputPtr
  5329                                  ;    8 arr sign byte     7    5    30190 namein[67]
  5330                                  ;    9 arr sign byte     8    5    30257 namelst[67]
  5331                                  ;   10 arr sign byte     9    5    30324 namebin[67]
  5332                                  ;   11 var sign word    10    4        0 asm_fd
  5333                                  ;   12 var sign word    11    3        0 lst_fd
  5334                                  ;   13 var sign word    12    3        0 bin_fd
  5335                                  ;   14 var sign word    13    6        0 DOS_ERR
  5336                                  ;   15 var sign word    14    4        0 ErrorCount
  5337                                  ;   16 var sign word    15    4        0 DOS_NoBytes
  5338                                  ;   17 var sign byte    16    4        0 DOS_ByteRead
  5339                                  ;   18 var unsg word    18    5        0 PC
  5340                                  ;   19 var unsg word    19    2        0 PCStart
  5341                                  ;   20 var sign byte    20    3        0 isLabel
  5342                                  ;   21 def unsg byte    21    -        0 DIGIT=1
  5343                                  ;   22 def unsg byte    22    -        0 LETTERE=2
  5344                                  ;   23 def unsg byte    23    -        0 ALNUME=3
  5345                                  ;   24 def unsg byte    24    -        0 NOALNUME=4
  5346                                  ;   25 var sign byte    25   20        0 TokeType
  5347                                  ;   26 def unsg byte    26    -        0 BYTE=1
  5348                                  ;   27 def unsg byte    27    -        0 WORD=2
  5349                                  ;   28 def unsg byte    28    -        0 DWORD=3
  5350                                  ;   29 def unsg byte    29    -        0 SEGREG=4
  5351                                  ;   30 def unsg byte    31    -        0 IMM=1
  5352                                  ;   31 def unsg byte    32    -        0 REG=2
  5353                                  ;   32 def unsg byte    33    -        0 DIR=3
  5354                                  ;   33 def unsg byte    34    -        0 IND=4
  5355                                  ;   34 var sign byte    35   13        0 Op1
  5356                                  ;   35 var sign byte    36   12        0 CodeType
  5357                                  ;   36 var sign byte    38   17        0 RegType
  5358                                  ;   37 var sign byte    39   10        0 RegNo
  5359                                  ;   38 var sign byte    40   10        0 OpSize
  5360                                  ;   39 var sign byte    42 NULL        0 NumOprns
  5361                                  ;   40 var sign byte    43    5        0 wflag
  5362                                  ;   41 var sign byte    44 NULL        0 dflag
  5363                                  ;   42 var sign byte    46    4        0 reg
  5364                                  ;   43 var sign word    47   13        0 disp
  5365                                  ;   44 var sign word    48    2        0 imme
  5366                                  ;   45 def unsg byte    50    -        0 OPMAXLEN=5
  5367                                  ;   46 arr sign byte    51    2    30391 OpPos[5]
  5368                                  ;   47 var sign word    52    6        0 OpPrintIndex
  5369                                  ;   48 ptr sign byte    53   16        0 OpCodePtr
  5370                                  ;   49 var sign byte    54    2        0 PrReloc
  5371                                  ;   50 arr sign byte    56    3    30396 LabelNames[1000]
  5372                                  ;   51 ptr sign byte    57   10        0 LabelNamePtr
  5373                                  ;   52 arr unsg word    58    4    31396 LabelAddr[100]
  5374                                  ;   53 var sign word    59    5        0 LabelMaxIx
  5375                                  ;   54 var sign word    60    4        0 LabelIx
  5376                                  ;   55 arr sign byte    62    3    31596 FileBin[2000]
  5377                                  ;   56 var unsg word    63    5        0 BinLen
  5378                                  ;   57 ptr sign byte    65    1        0 arglen
  5379                                  ;   58 ptr sign byte    66    4        0 argv
  5380                                  ;   59 var sign byte     1    1        0 I_START
  5381                                  ;   60 arr sign byte     5 NULL        0 I_PUSHA[9]
  5382                                  ;   61 arr sign byte     6 NULL        0 I_POPA[8]
  5383                                  ;   62 arr sign byte     7 NULL        0 I_NOP[7]
  5384                                  ;   63 arr sign byte     8 NULL        0 I_CBW[7]
  5385                                  ;   64 arr sign byte     9 NULL        0 I_CWDE[8]
  5386                                  ;   65 arr sign byte    10 NULL        0 I_CWD[7]
  5387                                  ;   66 arr sign byte    11 NULL        0 I_CDQ[7]
  5388                                  ;   67 arr sign byte    12 NULL        0 I_WAIT[8]
  5389                                  ;   68 arr sign byte    13 NULL        0 I_PUSHF[9]
  5390                                  ;   69 arr sign byte    14 NULL        0 I_POPF[8]
  5391                                  ;   70 arr sign byte    15 NULL        0 I_SAHF[8]
  5392                                  ;   71 arr sign byte    16 NULL        0 I_LAHF[8]
  5393                                  ;   72 arr sign byte    17 NULL        0 I_MOVSB[9]
  5394                                  ;   73 arr sign byte    18 NULL        0 I_MOVSW[9]
  5395                                  ;   74 arr sign byte    19 NULL        0 I_CMPSB[9]
  5396                                  ;   75 arr sign byte    20 NULL        0 I_CMPSW[9]
  5397                                  ;   76 arr sign byte    21 NULL        0 I_STOSB[9]
  5398                                  ;   77 arr sign byte    22 NULL        0 I_STOSW[9]
  5399                                  ;   78 arr sign byte    23 NULL        0 I_LODSB[9]
  5400                                  ;   79 arr sign byte    24 NULL        0 I_LODSW[9]
  5401                                  ;   80 arr sign byte    25 NULL        0 I_SCASB[9]
  5402                                  ;   81 arr sign byte    26 NULL        0 I_SCASW[9]
  5403                                  ;   82 arr sign byte    27 NULL        0 I_LEAVE[9]
  5404                                  ;   83 arr sign byte    28 NULL        0 I_IRET[8]
  5405                                  ;   84 arr sign byte    29 NULL        0 I_XLAT[8]
  5406                                  ;   85 arr sign byte    30 NULL        0 I_LOCK[8]
  5407                                  ;   86 arr sign byte    31 NULL        0 I_REPNE[9]
  5408                                  ;   87 arr sign byte    32 NULL        0 I_REPNZ[9]
  5409                                  ;   88 arr sign byte    33 NULL        0 I_REPE[8]
  5410                                  ;   89 arr sign byte    34 NULL        0 I_REPZ[8]
  5411                                  ;   90 arr sign byte    35 NULL        0 I_HLT[7]
  5412                                  ;   91 arr sign byte    36 NULL        0 I_CLC[7]
  5413                                  ;   92 arr sign byte    37 NULL        0 I_STC[7]
  5414                                  ;   93 arr sign byte    38 NULL        0 I_CLI[7]
  5415                                  ;   94 arr sign byte    39 NULL        0 I_STI[7]
  5416                                  ;   95 arr sign byte    40 NULL        0 I_CLD[7]
  5417                                  ;   96 arr sign byte    41 NULL        0 I_STD[7]
  5418                                  ;   97 arr sign byte    43 NULL        0 I_INC[9]
  5419                                  ;   98 arr sign byte    44 NULL        0 I_DEC[9]
  5420                                  ;   99 arr sign byte    46 NULL        0 I_NOT[8]
  5421                                  ;  100 arr sign byte    47 NULL        0 I_NEG[8]
  5422                                  ;  101 arr sign byte    48 NULL        0 I_MUL[8]
  5423                                  ;  102 arr sign byte    49 NULL        0 I_IMUL[9]
  5424                                  ;  103 arr sign byte    50 NULL        0 I_DIV[8]
  5425                                  ;  104 arr sign byte    51 NULL        0 I_IDIV[9]
  5426                                  ;  105 arr sign byte    53 NULL        0 I_LES[7]
  5427                                  ;  106 arr sign byte    54 NULL        0 I_LDS[7]
  5428                                  ;  107 arr sign byte    55 NULL        0 I_LEA[7]
  5429                                  ;  108 arr sign byte    57 NULL        0 I_ADD[7]
  5430                                  ;  109 arr sign byte    58 NULL        0 I_OR[6]
  5431                                  ;  110 arr sign byte    59 NULL        0 I_ADC[7]
  5432                                  ;  111 arr sign byte    60 NULL        0 I_SBB[7]
  5433                                  ;  112 arr sign byte    61 NULL        0 I_AND[7]
  5434                                  ;  113 arr sign byte    62 NULL        0 I_SUB[7]
  5435                                  ;  114 arr sign byte    63 NULL        0 I_XOR[7]
  5436                                  ;  115 arr sign byte    64 NULL        0 I_CMP[7]
  5437                                  ;  116 arr sign byte    66 NULL        0 I_MOV[6]
  5438                                  ;  117 arr sign byte    68 NULL        0 I_JO[6]
  5439                                  ;  118 arr sign byte    69 NULL        0 I_JNO[7]
  5440                                  ;  119 arr sign byte    70 NULL        0 I_JB[6]
  5441                                  ;  120 arr sign byte    71 NULL        0 I_JC[6]
  5442                                  ;  121 arr sign byte    72 NULL        0 I_JNB[7]
  5443                                  ;  122 arr sign byte    73 NULL        0 I_JAE[7]
  5444                                  ;  123 arr sign byte    74 NULL        0 I_JNC[7]
  5445                                  ;  124 arr sign byte    75 NULL        0 I_JE[6]
  5446                                  ;  125 arr sign byte    76 NULL        0 I_JZ[6]
  5447                                  ;  126 arr sign byte    77 NULL        0 I_JNE[7]
  5448                                  ;  127 arr sign byte    78 NULL        0 I_JNZ[7]
  5449                                  ;  128 arr sign byte    79 NULL        0 I_JBE[7]
  5450                                  ;  129 arr sign byte    80 NULL        0 I_JNA[7]
  5451                                  ;  130 arr sign byte    81 NULL        0 I_JA[6]
  5452                                  ;  131 arr sign byte    82 NULL        0 I_JS[6]
  5453                                  ;  132 arr sign byte    83 NULL        0 I_JNS[7]
  5454                                  ;  133 arr sign byte    84 NULL        0 I_JP[6]
  5455                                  ;  134 arr sign byte    85 NULL        0 I_JPE[7]
  5456                                  ;  135 arr sign byte    86 NULL        0 I_JNP[7]
  5457                                  ;  136 arr sign byte    87 NULL        0 I_JPO[7]
  5458                                  ;  137 arr sign byte    88 NULL        0 I_JL[6]
  5459                                  ;  138 arr sign byte    89 NULL        0 I_JNL[7]
  5460                                  ;  139 arr sign byte    90 NULL        0 I_JGE[7]
  5461                                  ;  140 arr sign byte    91 NULL        0 I_JLE[7]
  5462                                  ;  141 arr sign byte    92 NULL        0 I_JNG[7]
  5463                                  ;  142 arr sign byte    93 NULL        0 I_JG[6]
  5464                                  ;  143 arr sign byte    95 NULL        0 I_RET[8]
  5465                                  ;  144 arr sign byte    97 NULL        0 I_PUSH[8]
  5466                                  ;  145 arr sign byte    98 NULL        0 I_POP[7]
  5467                                  ;  146 arr sign byte   100 NULL        0 I_ORG[6]
  5468                                  ;  147 arr sign byte   101 NULL        0 I_DB[5]
  5469                                  ;  148 arr sign byte   102 NULL        0 I_DW[5]
  5470                                  ;  149 arr sign byte   103 NULL        0 I_DD[5]
  5471                                  ;  150 arr sign byte   104 NULL        0 I_RESB[7]
  5472                                  ;  151 arr sign byte   105 NULL        0 I_RESW[7]
  5473                                  ;  152 arr sign byte   106 NULL        0 I_RESD[7]
  5474                                  ;  153 var sign byte   107 NULL        0 I_END
  5475                                  
  5476                                  
  5477                                  ;   # Calls Line Width  Name   list of functions
  5478                                  
  5479                                  ;    0 NULL    1 word   main
  5480                                  ;    1    1   13 word   process
  5481                                  ;    2    2   63 word   LeftOpwCheck
  5482                                  ;    3    1   73 word   getLeftOp
  5483                                  ;    4    1   85 word   setwflag
  5484                                  ;    5    2   93 word   getOp1
  5485                                  ;    6    1  105 word   getIND
  5486                                  ;    7    1  120 word   getIndReg1
  5487                                  ;    8    1  129 word   getIndReg2
  5488                                  ;    9    1  140 word   gen66h
  5489                                  ;   10    8  141 word   genCode8
  5490                                  ;   11    3  145 word   genCode16
  5491                                  ;   12    7  148 word   genInstruction
  5492                                  ;   13    2  152 word   genCodeInREG
  5493                                  ;   14 NULL  155 word   genModRegRM
  5494                                  ;   15    2  157 word   writeEA
  5495                                  ;   16 NULL  171 word   test1
  5496                                  ;   17    1    1 word   parse
  5497                                  ;   18   12   27 word   getTokeType
  5498                                  ;   19    2   36 word   storeLabel
  5499                                  ;   20    2   43 word   searchLabel
  5500                                  ;   21    1   54 word   getVariable
  5501                                  ;   22    2   83 word   lookCode
  5502                                  ;   23    1   97 word   getCodeSize
  5503                                  ;   24    7  104 word   isToken
  5504                                  ;   25    1  109 word   skipRest
  5505                                  ;   26    1    1 word   getLine
  5506                                  ;   27    1   14 word   ifEOL
  5507                                  ;   28    3   21 word   skipBlank
  5508                                  ;   29    2   26 word   letterE
  5509                                  ;   30    1   36 word   alnumE
  5510                                  ;   31    1   41 word   getDigit
  5511                                  ;   32    1   53 word   getName
  5512                                  ;   33    1   70 word   testReg
  5513                                  ;   34    1    1 word   printLine
  5514                                  ;   35    9   19 word   prc
  5515                                  ;   36    1   23 word   prscomment
  5516                                  ;   37   24   26 word   prs
  5517                                  ;   38    4   31 word   printhex8a
  5518                                  ;   39    2   35 word   printhex16
  5519                                  ;   40    3   38 word   printIntU
  5520                                  ;   41   19   45 word   error1
  5521                                  ;   42 NULL   48 word   allowederror
  5522                                  ;   43 NULL   49 word   implmerror
  5523                                  ;   44    4   50 word   indexerror
  5524                                  ;   45    1   51 word   numbererror
  5525                                  ;   46 NULL   52 word   regmemerror
  5526                                  ;   47    1   53 word   segregerror
  5527                                  ;   48    1   54 word   syntaxerror
  5528                                  ;   49    7   56 word   errorexit
  5529                                  ;   50    1   57 word   addrexit
  5530                                  ;   51 NULL   58 word   internexit
  5531                                  ;   52    1    1 word   getarg
  5532                                  ;   53    1   26 word   epilog
  5533                                  ;   54    2   57 word   end1
  5534                                  ;   55    4  185 word   writetty
  5535                                  ;   56    8  186 word   cputs
  5536                                  ;   57    2  187 word   toupper
  5537                                  ;   58    4  189 word   strlen
  5538                                  ;   59    6  190 word   strcpy
  5539                                  ;   60    3  192 word   digit
  5540                                  ;   61   35  193 word   eqstr
  5541                                  ;   62    3  196 word   strcat1
  5542                                  ;   63    1  197 word   openR
  5543                                  ;   64    2  198 word   creatR
  5544                                  ;   65    2  199 word   readRL
  5545                                  ;   66    2  200 word   fputcR
  5546                                  ;   67    3  202 word   fcloseR
  5547                                  ;   68    5  203 word   exitR
  5548                                  ;   69    1  205 word   putch
  5549                                  ;   70    4  206 word   DosInt
  5550                                  ;   71 NULL  207 word   LastFunctionByt
  5551                                  
  5552                                  ;    #  addr name   list of CALLs
  5553                                  
  5554                                  ;    0     5 getarg
  5555                                  ;    1    12 parse
  5556                                  ;    2    18 epilog
  5557                                  ;    3    25 end1
  5558                                  ;    4  1088 getTokeType
  5559                                  ;    5  1100 getCodeSize
  5560                                  ;    6  1112 genInstruction
  5561                                  ;    7  1127 LeftOpwCheck
  5562                                  ;    8  1140 genInstruction
  5563                                  ;    9  1155 genInstruction
  5564                                  ;   10  1170 genInstruction
  5565                                  ;   11  1185 genCodeInREG
  5566                                  ;   12  1198 LeftOpwCheck
  5567                                  ;   13  1211 genInstruction
  5568                                  ;   14  1226 genCodeInREG
  5569                                  ;   15  1239 genInstruction
  5570                                  ;   16  1254 genCode16
  5571                                  ;   17  1264 genInstruction
  5572                                  ;   18  1279 error1
  5573                                  ;   19  1286 error1
  5574                                  ;   20  1306 getLeftOp
  5575                                  ;   21  1316 segregerror
  5576                                  ;   22  1328 setwflag
  5577                                  ;   23  1337 error1
  5578                                  ;   24  1344 error1
  5579                                  ;   25  1351 error1
  5580                                  ;   26  1368 getOp1
  5581                                  ;   27  1375 isToken
  5582                                  ;   28  1383 getIND
  5583                                  ;   29  1390 error1
  5584                                  ;   30  1397 error1
  5585                                  ;   31  1413 gen66h
  5586                                  ;   32  1427 testReg
  5587                                  ;   33  1435 searchLabel
  5588                                  ;   34  1447 error1
  5589                                  ;   35  1468 getTokeType
  5590                                  ;   36  1480 getOp1
  5591                                  ;   37  1487 syntaxerror
  5592                                  ;   38  1499 getIndReg2
  5593                                  ;   39  1510 getIndReg1
  5594                                  ;   40  1521 isToken
  5595                                  ;   41  1529 getTokeType
  5596                                  ;   42  1541 numbererror
  5597                                  ;   43  1553 isToken
  5598                                  ;   44  1561 isToken
  5599                                  ;   45  1569 errorexit
  5600                                  ;   46  1592 indexerror
  5601                                  ;   47  1603 indexerror
  5602                                  ;   48  1630 indexerror
  5603                                  ;   49  1641 indexerror
  5604                                  ;   50  1659 genCode8
  5605                                  ;   51  1691 genCode8
  5606                                  ;   52  1700 genCode8
  5607                                  ;   53  1733 genCode8
  5608                                  ;   54  1757 writeEA
  5609                                  ;   55  1777 writeEA
  5610                                  ;   56  1801 addrexit
  5611                                  ;   57  1810 genCode8
  5612                                  ;   58  1819 genCode8
  5613                                  ;   59  1828 genCode16
  5614                                  ;   60  1850 getLine
  5615                                  ;   61  1858 getTokeType
  5616                                  ;   62  1870 storeLabel
  5617                                  ;   63  1881 getTokeType
  5618                                  ;   64  1893 lookCode
  5619                                  ;   65  1902 process
  5620                                  ;   66  1910 getVariable
  5621                                  ;   67  1922 skipRest
  5622                                  ;   68  1931 error1
  5623                                  ;   69  1938 error1
  5624                                  ;   70  1945 printLine
  5625                                  ;   71  1969 skipBlank
  5626                                  ;   72  1979 digit
  5627                                  ;   73  1985 getDigit
  5628                                  ;   74  1994 letterE
  5629                                  ;   75  2002 getName
  5630                                  ;   76  2021 searchLabel
  5631                                  ;   77  2033 error1
  5632                                  ;   78  2040 strcpy
  5633                                  ;   79  2067 eqstr
  5634                                  ;   80  2073 strlen
  5635                                  ;   81  2094 storeLabel
  5636                                  ;   82  2105 getTokeType
  5637                                  ;   83  2117 lookCode
  5638                                  ;   84  2126 errorexit
  5639                                  ;   85  2136 errorexit
  5640                                  ;   86  2146 getTokeType
  5641                                  ;   87  2158 genCode8
  5642                                  ;   88  2167 skipBlank
  5643                                  ;   89  2177 isToken
  5644                                  ;   90  2185 genCode8
  5645                                  ;   91  2194 isToken
  5646                                  ;   92  2202 getTokeType
  5647                                  ;   93  2214 genCode16
  5648                                  ;   94  2224 isToken
  5649                                  ;   95  2232 errorexit
  5650                                  ;   96  2251 eqstr
  5651                                  ;   97  2269 eqstr
  5652                                  ;   98  2275 getTokeType
  5653                                  ;   99  2287 eqstr
  5654                                  ;  100  2293 getTokeType
  5655                                  ;  101  2305 eqstr
  5656                                  ;  102  2311 getTokeType
  5657                                  ;  103  2333 skipBlank
  5658                                  ;  104  2352 getTokeType
  5659                                  ;  105  2364 prs
  5660                                  ;  106  2376 readRL
  5661                                  ;  107  2383 errorexit
  5662                                  ;  108  2393 ifEOL
  5663                                  ;  109  2407 readRL
  5664                                  ;  110  2443 digit
  5665                                  ;  111  2449 letterE
  5666                                  ;  112  2476 digit
  5667                                  ;  113  2494 alnumE
  5668                                  ;  114  2501 strcpy
  5669                                  ;  115  2508 toupper
  5670                                  ;  116  2524 strlen
  5671                                  ;  117  2531 strlen
  5672                                  ;  118  2538 eqstr
  5673                                  ;  119  2544 eqstr
  5674                                  ;  120  2550 eqstr
  5675                                  ;  121  2556 eqstr
  5676                                  ;  122  2562 eqstr
  5677                                  ;  123  2568 eqstr
  5678                                  ;  124  2574 eqstr
  5679                                  ;  125  2580 eqstr
  5680                                  ;  126  2586 eqstr
  5681                                  ;  127  2592 eqstr
  5682                                  ;  128  2598 eqstr
  5683                                  ;  129  2604 eqstr
  5684                                  ;  130  2610 eqstr
  5685                                  ;  131  2616 eqstr
  5686                                  ;  132  2622 eqstr
  5687                                  ;  133  2628 eqstr
  5688                                  ;  134  2634 eqstr
  5689                                  ;  135  2640 eqstr
  5690                                  ;  136  2646 eqstr
  5691                                  ;  137  2652 eqstr
  5692                                  ;  138  2658 eqstr
  5693                                  ;  139  2664 eqstr
  5694                                  ;  140  2670 eqstr
  5695                                  ;  141  2676 eqstr
  5696                                  ;  142  2682 eqstr
  5697                                  ;  143  2688 eqstr
  5698                                  ;  144  2694 eqstr
  5699                                  ;  145  2700 eqstr
  5700                                  ;  146  2706 eqstr
  5701                                  ;  147  2712 eqstr
  5702                                  ;  148  2732 prs
  5703                                  ;  149  2736 printhex16
  5704                                  ;  150  2747 prs
  5705                                  ;  151  2751 prc
  5706                                  ;  152  2755 printhex8a
  5707                                  ;  153  2766 prc
  5708                                  ;  154  2770 prs
  5709                                  ;  155  2774 prscomment
  5710                                  ;  156  2791 writetty
  5711                                  ;  157  2800 writetty
  5712                                  ;  158  2809 fputcR
  5713                                  ;  159  2831 prc
  5714                                  ;  160  2847 prc
  5715                                  ;  161  2868 prc
  5716                                  ;  162  2872 prc
  5717                                  ;  163  2894 printhex8a
  5718                                  ;  164  2905 printhex8a
  5719                                  ;  165  2930 printIntU
  5720                                  ;  166  2940 prc
  5721                                  ;  167  2953 prs
  5722                                  ;  168  2957 prs
  5723                                  ;  169  2961 prs
  5724                                  ;  170  2965 prs
  5725                                  ;  171  2982 error1
  5726                                  ;  172  3000 error1
  5727                                  ;  173  3018 error1
  5728                                  ;  174  3037 error1
  5729                                  ;  175  3056 error1
  5730                                  ;  176  3075 error1
  5731                                  ;  177  3094 error1
  5732                                  ;  178  3113 error1
  5733                                  ;  179  3120 end1
  5734                                  ;  180  3134 errorexit
  5735                                  ;  181  3155 errorexit
  5736                                  ;  182  3184 cputs
  5737                                  ;  183  3190 cputs
  5738                                  ;  184  3196 exitR
  5739                                  ;  185  3202 toupper
  5740                                  ;  186  3210 strcpy
  5741                                  ;  187  3217 strcat1
  5742                                  ;  188  3225 strcpy
  5743                                  ;  189  3232 strcat1
  5744                                  ;  190  3240 strcpy
  5745                                  ;  191  3247 strcat1
  5746                                  ;  192  3255 openR
  5747                                  ;  193  3261 cputs
  5748                                  ;  194  3267 cputs
  5749                                  ;  195  3273 exitR
  5750                                  ;  196  3279 creatR
  5751                                  ;  197  3286 cputs
  5752                                  ;  198  3292 cputs
  5753                                  ;  199  3298 exitR
  5754                                  ;  200  3304 creatR
  5755                                  ;  201  3311 cputs
  5756                                  ;  202  3317 cputs
  5757                                  ;  203  3323 exitR
  5758                                  ;  204  3329 prs
  5759                                  ;  205  3333 prs
  5760                                  ;  206  3337 prs
  5761                                  ;  207  3341 prs
  5762                                  ;  208  3345 prs
  5763                                  ;  209  3349 prs
  5764                                  ;  210  3353 prs
  5765                                  ;  211  3357 prs
  5766                                  ;  212  3361 prs
  5767                                  ;  213  3378 prs
  5768                                  ;  214  3382 printIntU
  5769                                  ;  215  3392 prs
  5770                                  ;  216  3396 prs
  5771                                  ;  217  3400 prs
  5772                                  ;  218  3404 prc
  5773                                  ;  219  3408 printhex16
  5774                                  ;  220  3419 prs
  5775                                  ;  221  3423 strlen
  5776                                  ;  222  3430 prs
  5777                                  ;  223  3434 printIntU
  5778                                  ;  224  3444 prs
  5779                                  ;  225  3448 prc
  5780                                  ;  226  3452 printhex8a
  5781                                  ;  227  3463 fputcR
  5782                                  ;  228  3477 fcloseR
  5783                                  ;  229  3485 fcloseR
  5784                                  ;  230  3493 fcloseR
  5785                                  ;  231  3501 exitR
  5786                                  ;  232  3526 putch
  5787                                  ;  233  3594 strcpy
  5788                                  ;  234  3609 DosInt
  5789                                  ;  235  3625 DosInt
  5790                                  ;  236  3648 DosInt
  5791                                  ;  237  3667 DosInt
  5792                                  ;  238  3701 writetty
  5793                                  ;  239  3710 writetty
  5794                                  ;Input: AS.C, List: AS.S,  Lines:  208
  5795                                  ;Glob. variables:  153 max.:  200
  5796                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  5797                                  ;Functions      :   72 max.:  300
  5798                                  ;Calls          :  240 max.: 2000, NameField: 3742 max.:    65535
  5799                                  ;Code until     :26009 max.: 30000, free: 3991
  5800                                  ;Data (HeapEnd) :33596, resting stacksize: 31939
  5801                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
