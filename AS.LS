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
    32                                  ;-2 #define SYMBOLMAX    31
    33                                  
    34                                  
    35                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    36                                  
    37                                  section .bss
    38                                  absolute 30000
    39 00007530 <res 0000001F>          Symbol resb 31
    40                                  section .text
    41                                  
    42                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    43                                  
    44                                  section .bss
    45                                  absolute 30031
    46 0000754F <res 0000001F>          SymbolUpper resb 31
    47                                  section .text
    48                                  
    49                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    50                                  
    51 00000025 0000                    SymbolInt dw 0
    52                                  
    53                                  ;-6 #define INPUTBUFMAX 127
    54                                  
    55                                  
    56                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    57                                  
    58                                  section .bss
    59                                  absolute 30062
    60 0000756E <res 0000007F>          InputBuf resb 127
    61                                  section .text
    62                                  
    63                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    64                                  
    65 00000027 0000                    InputPtr dw 0
    66                                  
    67                                  ;-9 char namein [67];       //input file name  .S
    68                                  
    69                                  section .bss
    70                                  absolute 30189
    71 000075ED <res 00000043>          namein resb 67
    72                                  section .text
    73                                  
    74                                  ;-10 char namelst[67];       //list file name   .LST
    75                                  
    76                                  section .bss
    77                                  absolute 30256
    78 00007630 <res 00000043>          namelst resb 67
    79                                  section .text
    80                                  
    81                                  ;-11 char namebin[67];       //output file name .COM
    82                                  
    83                                  section .bss
    84                                  absolute 30323
    85 00007673 <res 00000043>          namebin resb 67
    86                                  section .text
    87                                  
    88                                  ;-12 int  asm_fd;            //input file descriptor
    89                                  
    90 00000029 0000                    asm_fd dw 0
    91                                  
    92                                  ;-13 int lst_fd;             //list file descriptor
    93                                  
    94 0000002B 0000                    lst_fd dw 0
    95                                  
    96                                  ;-14 int bin_fd;             //output file descriptor
    97                                  
    98 0000002D 0000                    bin_fd dw 0
    99                                  
   100                                  ;-15 int DOS_ERR;            //global var
   101                                  
   102 0000002F 0000                    DOS_ERR dw 0
   103                                  
   104                                  ;-16 int ErrorCount;         //number of errors
   105                                  
   106 00000031 0000                    ErrorCount dw 0
   107                                  
   108                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
   109                                  
   110 00000033 0000                    DOS_NoBytes dw 0
   111                                  
   112                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
   113                                  
   114 00000035 00                      DOS_ByteRead db 0
   115                                  
   116                                  ;-19 
   117                                  
   118                                  
   119                                  ;-20 unsigned int PC;        //program counter, ORG nn
   120                                  
   121 00000036 0000                    PC dw 0
   122                                  
   123                                  ;-21 unsigned int PCStart;   //PC at start of line by PrintLine()
   124                                  
   125 00000038 0000                    PCStart dw 0
   126                                  
   127                                  ;-22 char isLabel;           //by getName()
   128                                  
   129 0000003A 00                      isLabel db 0
   130                                  
   131                                  ;-23 #define DIGIT    1      //0-9
   132                                  
   133                                  
   134                                  ;-24 #define LETTERE  2      //a-z A-Z @ . _
   135                                  
   136                                  
   137                                  ;-25 #define ALNUME   3      //a-z A-Z @ . _  0-9
   138                                  
   139                                  
   140                                  ;-26 #define NOALNUME 4      //other char
   141                                  
   142                                  
   143                                  ;-27 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   144                                  
   145 0000003B 00                      TokeType db 0
   146                                  
   147                                  ;-28 #define BYTE     1
   148                                  
   149                                  
   150                                  ;-29 #define WORD     2
   151                                  
   152                                  
   153                                  ;-30 #define DWORD    3
   154                                  
   155                                  
   156                                  ;-31 #define SEGREG   4
   157                                  
   158                                  
   159                                  ;-32 //char CodeSize;          //0, BYTE, WORD, DWORD
   160                                  
   161                                  
   162                                  ;-33 #define IMM      1      //const  ,123
   163                                  
   164                                  
   165                                  ;-34 #define REG      2      //       ,BX    mode=11
   166                                  
   167                                  
   168                                  ;-35 #define DIR      3      //VALUE  ,var1  mod=00, r/m=110
   169                                  
   170                                  
   171                                  ;-36 #define IND      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   172                                  
   173                                  
   174                                  ;-37 char Op1;               //0, IMM, REG, DIR, IND
   175                                  
   176 0000003C 00                      Op1 db 0
   177                                  
   178                                  ;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size
   179                                  
   180 0000003D 00                      CodeType db 0
   181                                  
   182                                  ;-39 
   183                                  
   184                                  
   185                                  ;-40 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   186                                  
   187 0000003E 00                      RegType db 0
   188                                  
   189                                  ;-41 char RegNo;             //0 - 7 AL, CL, ...  by testReg()
   190                                  
   191 0000003F 00                      RegNo db 0
   192                                  
   193                                  ;-42 char OpSize;            //0, BYTE, WORD, DWORD
   194                                  
   195 00000040 00                      OpSize db 0
   196                                  
   197                                  ;-43 //char AddrSize;          //67h:
   198                                  
   199                                  
   200                                  ;-44 char NumOprns;          //0-2
   201                                  
   202 00000041 00                      NumOprns db 0
   203                                  
   204                                  ;-45 char wflag;             //0=byte, 1=word/dword
   205                                  
   206 00000042 00                      wflag db 0
   207                                  
   208                                  ;-46 char dflag;             //0=source is reg,  1=dest is reg
   209                                  
   210 00000043 00                      dflag db 0
   211                                  
   212                                  ;-47 //char modrm;           //mod, r/m
   213                                  
   214                                  
   215                                  ;-48 char reg;               //combination of index and base reg
   216                                  
   217 00000044 00                      reg db 0
   218                                  
   219                                  ;-49 int disp;               //displacement      0-8 bytes
   220                                  
   221 00000045 0000                    disp dw 0
   222                                  
   223                                  ;-50 int imme;               //immediate         0-8 bytes
   224                                  
   225 00000047 0000                    imme dw 0
   226                                  
   227                                  ;-51 
   228                                  
   229                                  
   230                                  ;-52 #define OPMAXLEN 5
   231                                  
   232                                  
   233                                  ;-53 char OpPos[OPMAXLEN];   //array for one opcode to list
   234                                  
   235                                  section .bss
   236                                  absolute 30390
   237 000076B6 <res 00000005>          OpPos resb 5
   238                                  section .text
   239                                  
   240                                  ;-54 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   241                                  
   242 00000049 0000                    OpPrintIndex dw 0
   243                                  
   244                                  ;-55 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   245                                  
   246 0000004B 0000                    OpCodePtr dw 0
   247                                  
   248                                  ;-56 char PrReloc;           //print 'R' if relocative
   249                                  
   250 0000004D 00                      PrReloc db 0
   251                                  
   252                                  ;-57 
   253                                  
   254                                  
   255                                  ;-58 #define LABELNAMESMAX 969//next number - 31
   256                                  
   257                                  
   258                                  ;-59 char LabelNames[1000];  //space for names of all labels
   259                                  
   260                                  section .bss
   261                                  absolute 30395
   262 000076BB <res 000003E8>          LabelNames resb 1000
   263                                  section .text
   264                                  
   265                                  ;-60 char *LabelNamePtr;     // first free position
   266                                  
   267 0000004E 0000                    LabelNamePtr dw 0
   268                                  
   269                                  ;-61 #define LABELADRMAX 100
   270                                  
   271                                  
   272                                  ;-62 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   273                                  
   274                                  section .bss
   275                                  absolute 31395
   276 00007AA3 <res 000000C8>          LabelAddr resw 100
   277                                  section .text
   278                                  
   279                                  ;-63 int LabelMaxIx=0;       //actual number of stored labels
   280                                  
   281 00000050 0000                    LabelMaxIx dw 0
   282                                  
   283                                  ;-64 int LabelIx;            //actual number of just searched label
   284                                  
   285 00000052 0000                    LabelIx dw 0
   286                                  
   287                                  ;-65 
   288                                  
   289                                  
   290                                  ;-66 #define FILEBINMAX 1990 //next number - max. oplemgth
   291                                  
   292                                  
   293                                  ;-67 char FileBin  [2000];   //output binary file
   294                                  
   295                                  section .bss
   296                                  absolute 31595
   297 00007B6B <res 000007D0>          FileBin resb 2000
   298                                  section .text
   299                                  
   300                                  ;-68 unsigned int BinLen=0;  //length of binary file
   301                                  
   302 00000054 0000                    BinLen dw 0
   303                                  
   304                                  ;-69 
   305                                  
   306                                  
   307                                  ;-70 char *arglen=0x80;      // for main only
   308                                  
   309 00000056 8000                    arglen dw 128
   310                                  
   311                                  ;-71 char *argv=0x82;        // for main only
   312                                  
   313 00000058 8200                    argv dw 130
   314                                  ;Back to main program: AS.C
   315                                  
   316                                  ;-4 #include "OPTABL.C"
   317                                  
   318                                  ;Use include file: OPTABL.C
   319                                  
   320                                  ;-1 char I_START=0xF1;
   321                                  
   322 0000005A F1                      I_START db 241
   323                                  
   324                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   325                                  
   326                                  
   327                                  ;-3 //  1:   1 byte opcode
   328                                  
   329                                  
   330                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   331                                  
   332 0000005B 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   333                                  
   334                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   335                                  
   336 00000064 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   337                                  
   338                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   339                                  
   340 0000006C 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   341                                  
   342                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   343                                  
   344 00000073 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   345                                  
   346                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   347                                  
   348 0000007A 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   349                                  
   350                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   351                                  
   352 00000082 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   353                                  
   354                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   355                                  
   356 00000089 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   357                                  
   358                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   359                                  
   360 00000090 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   361                                  
   362                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   363                                  
   364 00000098 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   365                                  
   366                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   367                                  
   368 000000A1 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   369                                  
   370                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   371                                  
   372 000000A9 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   373                                  
   374                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   375                                  
   376 000000B1 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   377                                  
   378                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   379                                  
   380 000000B9 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   381                                  
   382                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   383                                  
   384 000000C2 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   385                                  
   386                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   387                                  
   388 000000CB 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   389                                  
   390                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   391                                  
   392 000000D4 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   393                                  
   394                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   395                                  
   396 000000DD 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   397                                  
   398                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   399                                  
   400 000000E6 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   401                                  
   402                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   403                                  
   404 000000EF 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   405                                  
   406                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   407                                  
   408 000000F8 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   409                                  
   410                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   411                                  
   412 00000101 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   413                                  
   414                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   415                                  
   416 0000010A 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   417                                  
   418                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   419                                  
   420 00000113 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   421                                  
   422                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   423                                  
   424 0000011C 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   425                                  
   426                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   427                                  
   428 00000124 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   429                                  
   430                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   431                                  
   432 0000012C 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   433                                  
   434                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   435                                  
   436 00000134 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   437                                  
   438                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   439                                  
   440 0000013D 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   441                                  
   442                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   443                                  
   444 00000146 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   445                                  
   446                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   447                                  
   448 0000014E 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   449                                  
   450                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   451                                  
   452 00000156 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   453                                  
   454                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   455                                  
   456 0000015D 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   457                                  
   458                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   459                                  
   460 00000164 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   461                                  
   462                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   463                                  
   464 0000016B 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   465                                  
   466                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   467                                  
   468 00000172 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   469                                  
   470                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   471                                  
   472 00000179 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   473                                  
   474                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   475                                  
   476 00000180 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   477                                  
   478                                  ;-41 //  2: inc,dec
   479                                  
   480                                  
   481                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   482                                  
   483 00000187 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   484                                  
   485                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   486                                  
   487 00000190 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   488                                  
   489                                  ;-44 // 52: mem reg 16 bit
   490                                  
   491                                  
   492                                  ;-45 char I_NOT[]=  {'N','O','T',0,         52,0xF6, 2,0xF1};
   493                                  
   494 00000199 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
   495                                  
   496                                  ;-46 char I_NEG[]=  {'N','E','G',0,         52,0xF6, 3,0xF1};
   497                                  
   498 000001A1 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
   499                                  
   500                                  ;-47 char I_MUL[]=  {'M','U','L',0,         52,0xF6, 4,0xF1};
   501                                  
   502 000001A9 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
   503                                  
   504                                  ;-48 char I_IMUL[]= {'I','M','U','L',0,     52,0xF6, 5,0xF1};//only acc
   505                                  
   506 000001B1 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
   507                                  
   508                                  ;-49 char I_DIV[]=  {'D','I','V',0,         52,0xF6, 6,0xF1};
   509                                  
   510 000001BA 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
   511                                  
   512                                  ;-50 char I_IDIV[]= {'I','D','I','V',0,     52,0xF6, 7,0xF1};
   513                                  
   514 000001C2 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
   515                                  
   516                                  ;-51 //  3: les, lda, lea
   517                                  
   518                                  
   519                                  ;-52 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16
   520                                  
   521 000001CB 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   522                                  
   523                                  ;-53 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16
   524                                  
   525 000001D2 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   526                                  
   527                                  ;-54 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16
   528                                  
   529 000001D9 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   530                                  
   531                                  ;-55 //  4: acc,imm  reg,imm  index,reg
   532                                  
   533                                  
   534                                  ;-56 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   535                                  
   536 000001E0 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   537                                  
   538                                  ;-57 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   539                                  
   540 000001E7 4F52000401F1            I_OR db 79,82,0,4,1,241
   541                                  
   542                                  ;-58 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   543                                  
   544 000001ED 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   545                                  
   546                                  ;-59 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   547                                  
   548 000001F4 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   549                                  
   550                                  ;-60 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   551                                  
   552 000001FB 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   553                                  
   554                                  ;-61 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   555                                  
   556 00000202 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   557                                  
   558                                  ;-62 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   559                                  
   560 00000209 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   561                                  
   562                                  ;-63 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   563                                  
   564 00000210 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   565                                  
   566                                  ;-64 //  5: mov
   567                                  
   568                                  
   569                                  ;-65 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   570                                  
   571 00000217 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   572                                  
   573                                  ;-66 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   574                                  
   575 0000021D 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   576                                  
   577                                  ;-67 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   578                                  
   579 00000226 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   580                                  
   581                                  ;-68 //  6: single byte relative jump
   582                                  
   583                                  
   584                                  ;-69 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   585                                  
   586 0000022F 4A4F000600F1            I_JO db 74,79,0,6,0,241
   587                                  
   588                                  ;-70 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   589                                  
   590 00000235 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   591                                  
   592                                  ;-71 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   593                                  
   594 0000023C 4A42000602F1            I_JB db 74,66,0,6,2,241
   595                                  
   596                                  ;-72 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   597                                  
   598 00000242 4A43000602F1            I_JC db 74,67,0,6,2,241
   599                                  
   600                                  ;-73 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   601                                  
   602 00000248 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   603                                  
   604                                  ;-74 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   605                                  
   606 0000024F 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   607                                  
   608                                  ;-75 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   609                                  
   610 00000256 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   611                                  
   612                                  ;-76 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   613                                  
   614 0000025D 4A45000604F1            I_JE db 74,69,0,6,4,241
   615                                  
   616                                  ;-77 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   617                                  
   618 00000263 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   619                                  
   620                                  ;-78 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   621                                  
   622 00000269 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   623                                  
   624                                  ;-79 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   625                                  
   626 00000270 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   627                                  
   628                                  ;-80 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   629                                  
   630 00000277 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   631                                  
   632                                  ;-81 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   633                                  
   634 0000027E 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   635                                  
   636                                  ;-82 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   637                                  
   638 00000285 4A41000607F1            I_JA db 74,65,0,6,7,241
   639                                  
   640                                  ;-83 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   641                                  
   642 0000028B 4A53000608F1            I_JS db 74,83,0,6,8,241
   643                                  
   644                                  ;-84 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   645                                  
   646 00000291 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   647                                  
   648                                  ;-85 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   649                                  
   650 00000298 4A5000060AF1            I_JP db 74,80,0,6,10,241
   651                                  
   652                                  ;-86 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   653                                  
   654 0000029E 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   655                                  
   656                                  ;-87 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   657                                  
   658 000002A5 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   659                                  
   660                                  ;-88 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   661                                  
   662 000002AC 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   663                                  
   664                                  ;-89 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   665                                  
   666 000002B3 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   667                                  
   668                                  ;-90 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   669                                  
   670 000002B9 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   671                                  
   672                                  ;-91 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   673                                  
   674 000002C0 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   675                                  
   676                                  ;-92 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   677                                  
   678 000002C7 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   679                                  
   680                                  ;-93 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   681                                  
   682 000002CE 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   683                                  
   684                                  ;-94 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   685                                  
   686 000002D5 4A4700060FF1            I_JG db 74,71,0,6,15,241
   687                                  
   688                                  ;-95 //  7: jmp, call
   689                                  
   690                                  
   691                                  ;-96 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   692                                  
   693 000002DB 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   694                                  
   695                                  ;-97 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   696                                  
   697 000002E3 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   698                                  
   699                                  ;-98 //  8: ret
   700                                  
   701                                  
   702                                  ;-99 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   703                                  
   704 000002EC 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   705                                  
   706                                  ;-100 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   707                                  
   708 000002F4 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   709                                  
   710                                  ;-101 //  9: seg, r/m
   711                                  
   712                                  
   713                                  ;-102 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   714                                  
   715 000002FD 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   716                                  
   717                                  ;-103 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   718                                  
   719 00000305 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   720                                  
   721                                  ;-104 //  11: shift, rotates
   722                                  
   723                                  
   724                                  ;-105 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   725                                  
   726 0000030C 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   727                                  
   728                                  ;-106 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   729                                  
   730 00000313 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   731                                  
   732                                  ;-107 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   733                                  
   734 0000031A 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   735                                  
   736                                  ;-108 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   737                                  
   738 00000321 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   739                                  
   740                                  ;-109 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   741                                  
   742 00000328 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   743                                  
   744                                  ;-110 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   745                                  
   746 0000032F 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   747                                  
   748                                  ;-111 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   749                                  
   750 00000336 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   751                                  
   752                                  ;-112 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   753                                  
   754 0000033D 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   755                                  
   756                                  ;-113 //  12: int
   757                                  
   758                                  
   759                                  ;-114 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   760                                  
   761 00000344 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   762                                  
   763                                  ;-115 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   764                                  
   765 0000034C 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   766                                  
   767                                  ;-116 //  14: in/out
   768                                  
   769                                  
   770                                  ;-117 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   771                                  
   772 00000354 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   773                                  
   774                                  ;-118 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   775                                  
   776 0000035B 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   777                                  
   778                                  ;-119 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   779                                  
   780 00000363 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   781                                  
   782                                  ;-120 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   783                                  
   784 0000036B 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   785                                  
   786                                  ;-121 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   787                                  
   788 00000373 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   789                                  
   790                                  ;-122 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   791                                  
   792 0000037B 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   793                                  
   794                                  ;-123 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   795                                  
   796 00000383 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   797                                  
   798                                  ;-124 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   799                                  
   800 0000038B 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   801                                  
   802                                  ;-125 //  15: xchg
   803                                  
   804                                  
   805                                  ;-126 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   806                                  
   807 00000393 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   808                                  
   809                                  ;-127 //  16: loop, jcxz
   810                                  
   811                                  
   812                                  ;-128 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   813                                  
   814 0000039C 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   815 000003A5 F1                 
   816                                  
   817                                  ;-129 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   818                                  
   819 000003A6 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   820 000003AF F1                 
   821                                  
   822                                  ;-130 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   823                                  
   824 000003B0 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   825                                  
   826                                  ;-131 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   827                                  
   828 000003B9 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   829                                  
   830                                  ;-132 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   831                                  
   832 000003C2 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   833                                  
   834                                  ;-133 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   835                                  
   836 000003CA 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   837                                  
   838                                  ;-134 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   839                                  
   840 000003D2 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   841                                  
   842                                  ;-135 //  30: enter
   843                                  
   844                                  
   845                                  ;-136 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   846                                  
   847 000003DB 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   848                                  
   849                                  ;-137 // 100: directives
   850                                  
   851                                  
   852                                  ;-138 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   853                                  
   854 000003E4 4F52470065F1            I_ORG db 79,82,71,0,101,241
   855                                  
   856                                  ;-139 char I_DB[]=   {'D','B',0,            200,        0xF1};
   857                                  
   858 000003EA 444200C8F1              I_DB db 68,66,0,200,241
   859                                  
   860                                  ;-140 char I_DW[]=   {'D','W',0,            201,        0xF1};
   861                                  
   862 000003EF 445700C9F1              I_DW db 68,87,0,201,241
   863                                  
   864                                  ;-141 char I_DD[]=   {'D','D',0,            202,        0xF1};
   865                                  
   866 000003F4 444400CAF1              I_DD db 68,68,0,202,241
   867                                  
   868                                  ;-142 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   869                                  
   870 000003F9 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   871                                  
   872                                  ;-143 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   873                                  
   874 00000400 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   875                                  
   876                                  ;-144 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   877                                  
   878 00000407 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   879                                  
   880                                  ;-145 char I_END=0;// end of table char
   881                                  
   882 0000040E 00                      I_END db 0
   883                                  ;Back to main program: AS.C
   884                                  
   885                                  ;-5 int test1() { __asm {
   886                                  
   887                                  
   888                                  test1:  ; *** PROC ***
   889                                  
   890                                  
   891                                  ;-6 inc byte [Version1]   ;FE 06 [1000]
   892                                  
   893 0000040F FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
   894                                  
   895                                  ;-7 add bx, ax    ;01 C3
   896                                  
   897 00000413 01C3                    add bx, ax    ;01 C3
   898                                  
   899                                  ;-8 add ax, bx    ;01 D8
   900                                  
   901 00000415 01D8                    add ax, bx    ;01 D8
   902                                  
   903                                  ;-9 add word ax, [bx] ;03 07
   904                                  
   905 00000417 0307                    add word ax, [bx] ;03 07
   906                                  
   907                                  ;-10 VA dw 8
   908                                  
   909 00000419 0800                    VA dw 8
   910                                  
   911                                  ;-11 mov byte [bp- 4], al ;88 46 FC
   912                                  
   913 0000041B 8846FC                  mov byte [bp- 4], al ;88 46 FC
   914                                  
   915                                  ;-12 mov      [VA+bx], al ;88 87 [300F]
   916                                  
   917 0000041E 8887[1904]              mov      [VA+bx], al ;88 87 [300F]
   918                                  
   919                                  ;-13 }  }
   920                                  
   921                                  
   922                                  
   923                                  ;-14 /*
   924                                  
   925                                  
   926                                  ;-15 int process1(); NumOprns=0;
   927                                  
   928                                  
   929                                  ;-16   getOpcode1(); NumOprns=1;
   930                                  
   931                                  
   932                                  ;-17   if (isToken(',')) {
   933                                  
   934                                  
   935                                  ;-18     getOpcode2(); NumOprns=2;
   936                                  
   937                                  
   938                                  ;-19   }
   939                                  
   940                                  
   941                                  ;-20   genInstruction();
   942                                  
   943                                  
   944                                  ;-21 */
   945                                  
   946                                  
   947                                  ;-22 int process() { int i; char c;
   948                                  
   949 00000422 C3                       ret
   950                                  ; ENDP
   951                                  
   952                                  process:  ; *** PROC ***
   953                                  
   954                                  ;-23   getTokeType();
   955                                  
   956                                  ;Function : process, Number of local variables: 2
   957                                  ;   # type sign width line used address name   list of local variables
   958                                  ;  200 var sign word    22 NULL bp-2    i
   959                                  ;  201 var sign byte    22 NULL bp-4    c;
   960 00000423 C8040000                 ENTER  4,0
   961 00000427 E8DA07                   call getTokeType
   962                                  
   963                                  ;-24   OpSize=getCodeSize();
   964                                  
   965 0000042A E8D10A                   call getCodeSize
   966 0000042D A2[4000]                 mov byte [OpSize], al
   967                                  
   968                                  ;-25 
   969                                  
   970                                  
   971                                  ;-26   if (CodeType ==  1) {//1 byte opcode
   972                                  
   973 00000430 A0[3D00]                 mov al, [CodeType]
   974 00000433 3C01                     cmp al, 1
   975 00000435 0F850D00                 jne @@process1
   976                                  
   977                                  ;-27     genInstruction(0, 1); return;
   978                                  
   979 00000439 6A01                     push 1
   980 0000043B 6A00                     push 0
   981 0000043D E8A805                   call genInstruction
   982 00000440 83C404                   add  sp, 4
   983 00000443 E9E000                   jmp @@retn
   984                                  
   985                                  ;-28   }
   986                                  
   987                                  
   988                                  ;-29   if (CodeType ==  2) {//inc, dec
   989                                  
   990                                  @@process1:
   991 00000446 A0[3D00]                 mov al, [CodeType]
   992 00000449 3C02                     cmp al, 2
   993 0000044B 0F855400                 jne @@process2
   994                                  
   995                                  ;-30     LeftOpwCheck();
   996                                  
   997 0000044F E8FA00                   call LeftOpwCheck
   998                                  
   999                                  ;-31     	if (Op1 == REG) {
  1000                                  
  1001 00000452 A0[3C00]                 mov al, [Op1]
  1002 00000455 3C02                     cmp al, 2
  1003 00000457 0F853400                 jne @@process3
  1004                                  
  1005                                  ;-32         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short
  1006                                  
  1007 0000045B A0[3E00]                 mov al, [RegType]
  1008 0000045E 3C02                     cmp al, 2
  1009 00000460 0F851100                 jne @@process4
  1010 00000464 6A03                     push 3
  1011 00000466 A0[3F00]                 mov al, byte [RegNo]
  1012 00000469 B400                     mov ah, 0
  1013 0000046B 50                       push ax
  1014 0000046C E87905                   call genInstruction
  1015 0000046F 83C404                   add  sp, 4
  1016 00000472 E9B100                   jmp @@retn
  1017                                  
  1018                                  ;-33         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }
  1019                                  
  1020                                  @@process4:
  1021 00000475 A0[3E00]                 mov al, [RegType]
  1022 00000478 3C03                     cmp al, 3
  1023 0000047A 0F851100                 jne @@process5
  1024 0000047E 6A03                     push 3
  1025 00000480 A0[3F00]                 mov al, byte [RegNo]
  1026 00000483 B400                     mov ah, 0
  1027 00000485 50                       push ax
  1028 00000486 E85F05                   call genInstruction
  1029 00000489 83C404                   add  sp, 4
  1030 0000048C E99700                   jmp @@retn
  1031                                  @@process5:
  1032                                  
  1033                                  ;-34       genInstruction(wflag, 1); genCodeInREG(); return;
  1034                                  
  1035                                  @@process3:
  1036 0000048F 6A01                     push 1
  1037 00000491 A0[4200]                 mov al, byte [wflag]
  1038 00000494 B400                     mov ah, 0
  1039 00000496 50                       push ax
  1040 00000497 E84E05                   call genInstruction
  1041 0000049A 83C404                   add  sp, 4
  1042 0000049D E87A05                   call genCodeInREG
  1043 000004A0 E98300                   jmp @@retn
  1044                                  
  1045                                  ;-35   }
  1046                                  
  1047                                  
  1048                                  ;-36 
  1049                                  
  1050                                  
  1051                                  ;-37   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
  1052                                  
  1053                                  @@process2:
  1054 000004A3 A0[3D00]                 mov al, [CodeType]
  1055 000004A6 3C34                     cmp al, 52
  1056 000004A8 0F851700                 jne @@process6
  1057                                  
  1058                                  ;-38     LeftOpwCheck();
  1059                                  
  1060 000004AC E89D00                   call LeftOpwCheck
  1061                                  
  1062                                  ;-39     genInstruction(wflag, 1); genCodeInREG(); return;
  1063                                  
  1064 000004AF 6A01                     push 1
  1065 000004B1 A0[4200]                 mov al, byte [wflag]
  1066 000004B4 B400                     mov ah, 0
  1067 000004B6 50                       push ax
  1068 000004B7 E82E05                   call genInstruction
  1069 000004BA 83C404                   add  sp, 4
  1070 000004BD E85A05                   call genCodeInREG
  1071 000004C0 E96300                   jmp @@retn
  1072                                  
  1073                                  ;-40   }
  1074                                  
  1075                                  
  1076                                  ;-41 
  1077                                  
  1078                                  
  1079                                  ;-42   if (CodeType==  8) {// ret
  1080                                  
  1081                                  @@process6:
  1082 000004C3 A0[3D00]                 mov al, [CodeType]
  1083 000004C6 3C08                     cmp al, 8
  1084 000004C8 0F852D00                 jne @@process7
  1085                                  
  1086                                  ;-43     if (TokeType == DIGIT) {
  1087                                  
  1088 000004CC A0[3B00]                 mov al, [TokeType]
  1089 000004CF 3C01                     cmp al, 1
  1090 000004D1 0F851700                 jne @@process8
  1091                                  
  1092                                  ;-44         genInstruction(0, 2); genCode16(SymbolInt);return;}
  1093                                  
  1094 000004D5 6A02                     push 2
  1095 000004D7 6A00                     push 0
  1096 000004D9 E80C05                   call genInstruction
  1097 000004DC 83C404                   add  sp, 4
  1098 000004DF FF36[2500]               push word [SymbolInt]
  1099 000004E3 E8E104                   call genCode16
  1100 000004E6 83C402                   add  sp, 2
  1101 000004E9 E93A00                   jmp @@retn
  1102                                  
  1103                                  ;-45     genInstruction(0, 1); return;
  1104                                  
  1105                                  @@process8:
  1106 000004EC 6A01                     push 1
  1107 000004EE 6A00                     push 0
  1108 000004F0 E8F504                   call genInstruction
  1109 000004F3 83C404                   add  sp, 4
  1110 000004F6 E92D00                   jmp @@retn
  1111                                  
  1112                                  ;-46   }
  1113                                  
  1114                                  
  1115                                  ;-47 
  1116                                  
  1117                                  
  1118                                  ;-48   if (CodeType==101) {// ORG nn
  1119                                  
  1120                                  @@process7:
  1121 000004F9 A0[3D00]                 mov al, [CodeType]
  1122 000004FC 3C65                     cmp al, 101
  1123 000004FE 0F851B00                 jne @@process9
  1124                                  
  1125                                  ;-49     if (TokeType != DIGIT) error1("only digit allowed");
  1126                                  
  1127 00000502 A0[3B00]                 mov al, [TokeType]
  1128 00000505 3C01                     cmp al, 1
  1129 00000507 0F840900                 je  @@process10
  1130 0000050B 68[2805]                 push process_0
  1131 0000050E E83114                   call error1
  1132 00000511 83C402                   add  sp, 2
  1133                                  
  1134                                  ;-50     PC=SymbolInt;return;
  1135                                  
  1136                                  @@process10:
  1137 00000514 A1[2500]                 mov ax, [SymbolInt]
  1138 00000517 A3[3600]                 mov word [PC], ax
  1139 0000051A E90900                   jmp @@retn
  1140                                  
  1141                                  ;-51   }
  1142                                  
  1143                                  
  1144                                  ;-52   error1("unknown CodeType");
  1145                                  
  1146                                  @@process9:
  1147 0000051D 68[3B05]                 push process_1
  1148 00000520 E81F14                   call error1
  1149 00000523 83C402                   add  sp, 2
  1150                                  
  1151                                  ;-53 }
  1152                                  
  1153                                  
  1154                                  ;-54 /*
  1155                                  
  1156                                  
  1157                                  ;-55 operand::=
  1158                                  
  1159                                  
  1160                                  ;-56   none
  1161                                  
  1162                                  
  1163                                  ;-57   ac  (al, ax, eax)
  1164                                  
  1165                                  
  1166                                  ;-58   r   (b, w, s, d)
  1167                                  
  1168                                  
  1169                                  ;-59   [m] (b, w, d)
  1170                                  
  1171                                  
  1172                                  ;-60   i   (b, w)
  1173                                  
  1174                                  
  1175                                  ;-61   disp(b, w)
  1176                                  
  1177                                  
  1178                                  ;-62 
  1179                                  
  1180                                  
  1181                                  ;-63 //O2=rr,rm,ri,mr,mi
  1182                                  
  1183                                  
  1184                                  ;-64 //NumOprns==2, seg reg not allowed only mov and push
  1185                                  
  1186                                  
  1187                                  ;-65 //size: 1.declaration CodeSize, 2.reg size, 3.error1
  1188                                  
  1189                                  
  1190                                  ;-66 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
  1191                                  
  1192                                  
  1193                                  ;-67 //2. rm , imm 80
  1194                                  
  1195                                  
  1196                                  ;-68 //2a sign ext 83
  1197                                  
  1198                                  
  1199                                  ;-69 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
  1200                                  
  1201                                  
  1202                                  ;-70 //4. rm , reg 00
  1203                                  
  1204                                  
  1205                                  ;-71 //5. error1(mem2mem)
  1206                                  
  1207                                  
  1208                                  ;-72 */
  1209                                  
  1210                                  
  1211                                  ;-73 int LeftOpwCheck() {
  1212                                  
  1213 00000526 C9                      @@retn: LEAVE
  1214 00000527 C3                       ret
  1215                                  ; ENDP
  1216 00000528 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1217 00000531 7420616C6C6F776564-
  1218 0000053A 00                 
  1219 0000053B 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1220 00000544 6F64655479706500   
  1221                                  
  1222                                  LeftOpwCheck:  ; *** PROC ***
  1223                                  
  1224                                  ;-74   getLeftOp();
  1225                                  
  1226 0000054C E8A700                   call getLeftOp
  1227                                  
  1228                                  ;-75   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1229                                  
  1230 0000054F A0[3E00]                 mov al, [RegType]
  1231 00000552 3C04                     cmp al, 4
  1232 00000554 0F850600                 jne @@LeftOpwCheck11
  1233 00000558 E8E014                   call segregerror
  1234 0000055B E95300                   jmp @@retn
  1235                                  
  1236                                  ;-76   setwflag();
  1237                                  
  1238                                  @@LeftOpwCheck11:
  1239 0000055E E85B01                   call setwflag
  1240                                  
  1241                                  ;-77   if (OpSize == 0) error1("no op size declared");
  1242                                  
  1243 00000561 A0[4000]                 mov al, [OpSize]
  1244 00000564 3C00                     cmp al, 0
  1245 00000566 0F850900                 jne @@LeftOpwCheck12
  1246 0000056A 68[B205]                 push LeftOpwCheck_0
  1247 0000056D E8D213                   call error1
  1248 00000570 83C402                   add  sp, 2
  1249                                  
  1250                                  ;-78   if (OpSize == RegType) return;
  1251                                  
  1252                                  @@LeftOpwCheck12:
  1253 00000573 A0[4000]                 mov al, [OpSize]
  1254 00000576 3A06[3E00]               cmp al, [RegType]
  1255 0000057A 0F850300                 jne @@LeftOpwCheck13
  1256 0000057E E93000                   jmp @@retn
  1257                                  
  1258                                  ;-79   if (OpSize){if (Op1 == IND) return;
  1259                                  
  1260                                  @@LeftOpwCheck13:
  1261 00000581 A0[4000]                 mov al, [OpSize]
  1262 00000584 08C0                     or  al, al
  1263 00000586 0F841500                 je @@LeftOpwCheck14
  1264 0000058A A0[3C00]                 mov al, [Op1]
  1265 0000058D 3C04                     cmp al, 4
  1266 0000058F 0F850300                 jne @@LeftOpwCheck15
  1267 00000593 E91B00                   jmp @@retn
  1268                                  
  1269                                  ;-80     error1("Conflict OpSize and RegSize"); }
  1270                                  
  1271                                  @@LeftOpwCheck15:
  1272 00000596 68[C605]                 push LeftOpwCheck_1
  1273 00000599 E8A613                   call error1
  1274 0000059C 83C402                   add  sp, 2
  1275                                  
  1276                                  ;-81   if (RegType==0) error1("no register defined");
  1277                                  
  1278                                  @@LeftOpwCheck14:
  1279 0000059F A0[3E00]                 mov al, [RegType]
  1280 000005A2 3C00                     cmp al, 0
  1281 000005A4 0F850900                 jne @@LeftOpwCheck16
  1282 000005A8 68[E205]                 push LeftOpwCheck_2
  1283 000005AB E89413                   call error1
  1284 000005AE 83C402                   add  sp, 2
  1285                                  
  1286                                  ;-82 }
  1287                                  
  1288                                  @@LeftOpwCheck16:
  1289                                  
  1290                                  ;-83 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
  1291                                  
  1292                                  @@retn:
  1293 000005B1 C3                       ret
  1294                                  ; ENDP
  1295 000005B2 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
  1296 000005BB 65206465636C617265-
  1297 000005C4 6400               
  1298 000005C6 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
  1299 000005CF 4F7053697A6520616E-
  1300 000005D8 642052656753697A65-
  1301 000005E1 00                 
  1302 000005E2 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
  1303 000005EB 657220646566696E65-
  1304 000005F4 6400               
  1305                                  
  1306                                  getLeftOp:  ; *** PROC ***
  1307                                  
  1308                                  ;-84 //set: op1, disp->imm, reg, regt->size
  1309                                  
  1310                                  
  1311                                  ;-85   disp=0; imme=0; reg=0;
  1312                                  
  1313 000005F6 66B800000000             mov eax, 0
  1314 000005FC A3[4500]                 mov word [disp], ax
  1315 000005FF 66B800000000             mov eax, 0
  1316 00000605 A3[4700]                 mov word [imme], ax
  1317 00000608 66B800000000             mov eax, 0
  1318 0000060E A2[4400]                 mov byte [reg], al
  1319                                  
  1320                                  ;-86 
  1321                                  
  1322                                  
  1323                                  ;-87   Op1=getOp1();
  1324                                  
  1325 00000611 E80301                   call getOp1
  1326 00000614 A2[3C00]                 mov byte [Op1], al
  1327                                  
  1328                                  ;-88   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
  1329                                  
  1330 00000617 6A5B                     push 91
  1331 00000619 E86509                   call isToken
  1332 0000061C 83C402                   add  sp, 2
  1333 0000061F 08C0                     or  al, al
  1334 00000621 0F840F00                 je @@getLeftOp17
  1335 00000625 66B804000000             mov eax, 4
  1336 0000062B A2[3C00]                 mov byte [Op1], al
  1337 0000062E E86C01                   call getIND
  1338 00000631 E95200                   jmp @@retn
  1339                                  
  1340                                  ;-89   if (Op1 == 0) error1("Name of operand expected");
  1341                                  
  1342                                  @@getLeftOp17:
  1343 00000634 A0[3C00]                 mov al, [Op1]
  1344 00000637 3C00                     cmp al, 0
  1345 00000639 0F850900                 jne @@getLeftOp18
  1346 0000063D 68[8706]                 push getLeftOp_0
  1347 00000640 E8FF12                   call error1
  1348 00000643 83C402                   add  sp, 2
  1349                                  
  1350                                  ;-90   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
  1351                                  
  1352                                  @@getLeftOp18:
  1353 00000646 A0[3C00]                 mov al, [Op1]
  1354 00000649 3C01                     cmp al, 1
  1355 0000064B 0F850900                 jne @@getLeftOp19
  1356 0000064F A1[2500]                 mov ax, [SymbolInt]
  1357 00000652 A3[4700]                 mov word [imme], ax
  1358 00000655 E92E00                   jmp @@retn
  1359                                  
  1360                                  ;-91   if (Op1 == REG) return;                                    //2
  1361                                  
  1362                                  @@getLeftOp19:
  1363 00000658 A0[3C00]                 mov al, [Op1]
  1364 0000065B 3C02                     cmp al, 2
  1365 0000065D 0F850300                 jne @@getLeftOp20
  1366 00000661 E92200                   jmp @@retn
  1367                                  
  1368                                  ;-92   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
  1369                                  
  1370                                  @@getLeftOp20:
  1371 00000664 A0[3C00]                 mov al, [Op1]
  1372 00000667 3C03                     cmp al, 3
  1373 00000669 0F851000                 jne @@getLeftOp21
  1374 0000066D 8B1E[5200]               mov bx, [LabelIx]
  1375 00000671 D1E3                     shl bx, 1
  1376 00000673 8B87A37A                 mov ax, [LabelAddr + bx]
  1377 00000677 A3[4500]                 mov word [disp], ax
  1378 0000067A E90900                   jmp @@retn
  1379                                  
  1380                                  ;-93   error1("Name of operand expected #1");
  1381                                  
  1382                                  @@getLeftOp21:
  1383 0000067D 68[A006]                 push getLeftOp_1
  1384 00000680 E8BF12                   call error1
  1385 00000683 83C402                   add  sp, 2
  1386                                  
  1387                                  ;-94 }
  1388                                  
  1389                                  
  1390                                  ;-95 int setwflag() {//only Op1 (first operand)
  1391                                  
  1392                                  @@retn:
  1393 00000686 C3                       ret
  1394                                  ; ENDP
  1395 00000687 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
  1396 00000690 706572616E64206578-
  1397 00000699 70656374656400     
  1398 000006A0 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
  1399 000006A9 706572616E64206578-
  1400 000006B2 706563746564202331-
  1401 000006BB 00                 
  1402                                  
  1403                                  setwflag:  ; *** PROC ***
  1404                                  
  1405                                  ;-96   wflag=0;
  1406                                  
  1407 000006BC 66B800000000             mov eax, 0
  1408 000006C2 A2[4200]                 mov byte [wflag], al
  1409                                  
  1410                                  ;-97   if (OpSize == 0) {//do not override OpSize
  1411                                  
  1412 000006C5 A0[4000]                 mov al, [OpSize]
  1413 000006C8 3C00                     cmp al, 0
  1414 000006CA 0F852100                 jne @@setwflag22
  1415                                  
  1416                                  ;-98     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
  1417                                  
  1418 000006CE A0[3C00]                 mov al, [Op1]
  1419 000006D1 3C02                     cmp al, 2
  1420 000006D3 0F851800                 jne @@setwflag23
  1421 000006D7 A0[3E00]                 mov al, [RegType]
  1422 000006DA A2[4000]                 mov byte [OpSize], al
  1423 000006DD A0[3E00]                 mov al, [RegType]
  1424 000006E0 3C04                     cmp al, 4
  1425 000006E2 0F850900                 jne @@setwflag24
  1426 000006E6 66B802000000             mov eax, 2
  1427 000006EC A2[4000]                 mov byte [OpSize], al
  1428                                  @@setwflag24:
  1429                                  
  1430                                  ;-99   }
  1431                                  
  1432                                  @@setwflag23:
  1433                                  
  1434                                  ;-100   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1435                                  
  1436                                  @@setwflag22:
  1437 000006EF A0[4000]                 mov al, [OpSize]
  1438 000006F2 3C03                     cmp al, 3
  1439 000006F4 0F850C00                 jne @@setwflag25
  1440 000006F8 E89102                   call gen66h
  1441 000006FB 66B801000000             mov eax, 1
  1442 00000701 A2[4200]                 mov byte [wflag], al
  1443                                  
  1444                                  ;-101   if (OpSize  ==  WORD) wflag=1;
  1445                                  
  1446                                  @@setwflag25:
  1447 00000704 A0[4000]                 mov al, [OpSize]
  1448 00000707 3C02                     cmp al, 2
  1449 00000709 0F850900                 jne @@setwflag26
  1450 0000070D 66B801000000             mov eax, 1
  1451 00000713 A2[4200]                 mov byte [wflag], al
  1452                                  
  1453                                  ;-102 }
  1454                                  
  1455                                  @@setwflag26:
  1456                                  
  1457                                  ;-103 int getOp1() {//scan for a single operand
  1458                                  
  1459 00000716 C3                       ret
  1460                                  ; ENDP
  1461                                  
  1462                                  getOp1:  ; *** PROC ***
  1463                                  
  1464                                  ;-104   //set:Op1, imme, disp, RegType, TegNo, reg
  1465                                  
  1466                                  
  1467                                  ;-105   if (TokeType == 0)      return 0;
  1468                                  
  1469 00000717 A0[3B00]                 mov al, [TokeType]
  1470 0000071A 3C00                     cmp al, 0
  1471 0000071C 0F850900                 jne @@getOp127
  1472 00000720 66B800000000             mov eax, 0
  1473 00000726 E96000                   jmp @@retn
  1474                                  
  1475                                  ;-106   if (TokeType == DIGIT)  return IMM;// 1
  1476                                  
  1477                                  @@getOp127:
  1478 00000729 A0[3B00]                 mov al, [TokeType]
  1479 0000072C 3C01                     cmp al, 1
  1480 0000072E 0F850900                 jne @@getOp128
  1481 00000732 66B801000000             mov eax, 1
  1482 00000738 E94E00                   jmp @@retn
  1483                                  
  1484                                  ;-107   if (TokeType == ALNUME) {
  1485                                  
  1486                                  @@getOp128:
  1487 0000073B A0[3B00]                 mov al, [TokeType]
  1488 0000073E 3C03                     cmp al, 3
  1489 00000740 0F853C00                 jne @@getOp129
  1490                                  
  1491                                  ;-108     RegNo=testReg();//set global RegType
  1492                                  
  1493 00000744 E8540B                   call testReg
  1494 00000747 A2[3F00]                 mov byte [RegNo], al
  1495                                  
  1496                                  ;-109     if (RegType)          return REG;// 2
  1497                                  
  1498 0000074A A0[3E00]                 mov al, [RegType]
  1499 0000074D 08C0                     or  al, al
  1500 0000074F 0F840900                 je @@getOp130
  1501 00000753 66B802000000             mov eax, 2
  1502 00000759 E92D00                   jmp @@retn
  1503                                  
  1504                                  ;-110     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];
  1505                                  
  1506                                  @@getOp130:
  1507 0000075C E88D05                   call searchLabel
  1508 0000075F A3[5200]                 mov word [LabelIx], ax
  1509                                  
  1510                                  ;-111     if (LabelIx)          return DIR;// 3
  1511                                  
  1512 00000762 A1[5200]                 mov ax, [LabelIx]
  1513 00000765 08C0                     or  al, al
  1514 00000767 0F840C00                 je @@getOp131
  1515 0000076B 66B803000000             mov eax, 3
  1516 00000771 E91500                   jmp @@retn
  1517                                  
  1518                                  ;-112     else error1("variable not found"); }
  1519                                  
  1520 00000774 E90900                   jmp @@getOp132
  1521                                  @@getOp131:
  1522 00000777 68[8A07]                 push getOp1_0
  1523 0000077A E8C511                   call error1
  1524 0000077D 83C402                   add  sp, 2
  1525                                  @@getOp132:
  1526                                  
  1527                                  ;-113   return 0;
  1528                                  
  1529                                  @@getOp129:
  1530 00000780 66B800000000             mov eax, 0
  1531 00000786 E90000                   jmp @@retn
  1532                                  
  1533                                  ;-114 }
  1534                                  
  1535                                  
  1536                                  ;-115 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
  1537                                  
  1538                                  @@retn:
  1539 00000789 C3                       ret
  1540                                  ; ENDP
  1541 0000078A 7661726961626C6520-     getOp1_0 db "variable not found",0
  1542 00000793 6E6F7420666F756E64-
  1543 0000079C 00                 
  1544                                  
  1545                                  getIND:  ; *** PROC ***
  1546                                  
  1547                                  ;-116   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
  1548                                  
  1549                                  ;Function : getIND, Number of local variables: 2
  1550                                  ;   # type sign width line used address name   list of local variables
  1551                                  ;  200 var sign byte   116 NULL bp-2    op2
  1552                                  ;  201 var sign byte   116 NULL bp-4    r1;
  1553 0000079D C8040000                 ENTER  4,0
  1554 000007A1 66B800000000             mov eax, 0
  1555 000007A7 A3[4500]                 mov word [disp], ax
  1556 000007AA 66B800000000             mov eax, 0
  1557 000007B0 8846FC                   mov byte [bp-4], al
  1558 000007B3 66B800000000             mov eax, 0
  1559 000007B9 A2[3E00]                 mov byte [RegType], al
  1560                                  
  1561                                  ;-117   do {
  1562                                  
  1563                                  @@getIND33:
  1564                                  
  1565                                  ;-118     getTokeType();
  1566                                  
  1567 000007BC E84504                   call getTokeType
  1568                                  
  1569                                  ;-119     op2=getOp1();
  1570                                  
  1571 000007BF E855FF                   call getOp1
  1572 000007C2 8846FE                   mov byte [bp-2], al
  1573                                  
  1574                                  ;-120     if (op2 ==   0) syntaxerror();
  1575                                  
  1576 000007C5 8A46FE                   mov al, [bp-2]
  1577 000007C8 3C00                     cmp al, 0
  1578 000007CA 0F850300                 jne @@getIND34
  1579 000007CE E89112                   call syntaxerror
  1580                                  
  1581                                  ;-121     if (op2 == IMM) disp=disp+SymbolInt;
  1582                                  
  1583                                  @@getIND34:
  1584 000007D1 8A46FE                   mov al, [bp-2]
  1585 000007D4 3C01                     cmp al, 1
  1586 000007D6 0F850A00                 jne @@getIND35
  1587 000007DA A1[4500]                 mov ax, [disp]
  1588 000007DD 0306[2500]               add ax, [SymbolInt]
  1589 000007E1 A3[4500]                 mov word [disp], ax
  1590                                  
  1591                                  ;-122     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
  1592                                  
  1593                                  @@getIND35:
  1594 000007E4 8A46FE                   mov al, [bp-2]
  1595 000007E7 3C02                     cmp al, 2
  1596 000007E9 0F852100                 jne @@getIND36
  1597 000007ED 8A46FC                   mov al, [bp-4]
  1598 000007F0 08C0                     or  al, al
  1599 000007F2 0F841200                 je @@getIND37
  1600 000007F6 8A46FC                   mov al, byte [bp-4]
  1601 000007F9 B400                     mov ah, 0
  1602 000007FB 50                       push ax
  1603 000007FC E80001                   call getIndReg2
  1604 000007FF 83C402                   add  sp, 2
  1605 00000802 8846FC                   mov byte [bp-4], al
  1606 00000805 E90600                   jmp @@getIND38
  1607                                  @@getIND37:
  1608 00000808 E87F00                   call getIndReg1
  1609 0000080B 8846FC                   mov byte [bp-4], al
  1610                                  
  1611                                  ;-123     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
  1612                                  
  1613                                  @@getIND38:
  1614                                  @@getIND36:
  1615 0000080E 8A46FE                   mov al, [bp-2]
  1616 00000811 3C03                     cmp al, 3
  1617 00000813 0F851000                 jne @@getIND39
  1618 00000817 A1[4500]                 mov ax, [disp]
  1619 0000081A 8B1E[5200]               mov bx, [LabelIx]
  1620 0000081E D1E3                     shl bx, 1
  1621 00000820 0387A37A                 add ax, [LabelAddr + bx]
  1622 00000824 A3[4500]                 mov word [disp], ax
  1623                                  
  1624                                  ;-124     if (isToken('-')) {getTokeType();
  1625                                  
  1626                                  @@getIND39:
  1627 00000827 6A2D                     push 45
  1628 00000829 E85507                   call isToken
  1629 0000082C 83C402                   add  sp, 2
  1630 0000082F 08C0                     or  al, al
  1631 00000831 0F841900                 je @@getIND40
  1632 00000835 E8CC03                   call getTokeType
  1633                                  
  1634                                  ;-125       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  1635                                  
  1636 00000838 A0[3B00]                 mov al, [TokeType]
  1637 0000083B 3C01                     cmp al, 1
  1638 0000083D 0F840300                 je  @@getIND41
  1639 00000841 E8B311                   call numbererror
  1640                                  @@getIND41:
  1641 00000844 A1[4500]                 mov ax, [disp]
  1642 00000847 2B06[2500]               sub ax, [SymbolInt]
  1643 0000084B A3[4500]                 mov word [disp], ax
  1644                                  
  1645                                  ;-126   } while (isToken('+'));
  1646                                  
  1647                                  @@getIND40:
  1648 0000084E 6A2B                     push 43
  1649 00000850 E82E07                   call isToken
  1650 00000853 83C402                   add  sp, 2
  1651 00000856 08C0                     or  al, al
  1652 00000858 0F840300                 je @@getIND42
  1653 0000085C E95DFF                   jmp @@getIND33
  1654                                  @@getIND42:
  1655                                  
  1656                                  ;-127   if (isToken(']') == 0) errorexit("] expected");
  1657                                  
  1658 0000085F 6A5D                     push 93
  1659 00000861 E81D07                   call isToken
  1660 00000864 83C402                   add  sp, 2
  1661 00000867 83F800                   cmp ax, 0
  1662 0000086A 0F850900                 jne @@getIND43
  1663 0000086E 68[7F08]                 push getIND_0
  1664 00000871 E8FF11                   call errorexit
  1665 00000874 83C402                   add  sp, 2
  1666                                  
  1667                                  ;-128   reg=r1;
  1668                                  
  1669                                  @@getIND43:
  1670 00000877 8A46FC                   mov al, [bp-4]
  1671 0000087A A2[4400]                 mov byte [reg], al
  1672                                  
  1673                                  ;-129 }
  1674                                  
  1675                                  
  1676                                  ;-130 int getIndReg1() {char m; m=0;
  1677 0000087D C9                       LEAVE
  1678 0000087E C3                       ret
  1679                                  ; ENDP
  1680 0000087F 5D2065787065637465-     getIND_0 db "] expected",0
  1681 00000888 6400               
  1682                                  
  1683                                  getIndReg1:  ; *** PROC ***
  1684                                  ;Function : getIndReg1, Number of local variables: 1
  1685                                  ;   # type sign width line used address name   list of local variables
  1686                                  ;  200 var sign byte   130 NULL bp-2    m;
  1687 0000088A C8020000                 ENTER  2,0
  1688 0000088E 66B800000000             mov eax, 0
  1689 00000894 8846FE                   mov byte [bp-2], al
  1690                                  
  1691                                  ;-131   if (RegType !=WORD) indexerror();
  1692                                  
  1693 00000897 A0[3E00]                 mov al, [RegType]
  1694 0000089A 3C02                     cmp al, 2
  1695 0000089C 0F840300                 je  @@getIndReg144
  1696 000008A0 E83311                   call indexerror
  1697                                  
  1698                                  ;-132   if (RegNo==3) m=7;//BX
  1699                                  
  1700                                  @@getIndReg144:
  1701 000008A3 A0[3F00]                 mov al, [RegNo]
  1702 000008A6 3C03                     cmp al, 3
  1703 000008A8 0F850900                 jne @@getIndReg145
  1704 000008AC 66B807000000             mov eax, 7
  1705 000008B2 8846FE                   mov byte [bp-2], al
  1706                                  
  1707                                  ;-133   if (RegNo==5) m=6;//BP change to BP+0
  1708                                  
  1709                                  @@getIndReg145:
  1710 000008B5 A0[3F00]                 mov al, [RegNo]
  1711 000008B8 3C05                     cmp al, 5
  1712 000008BA 0F850900                 jne @@getIndReg146
  1713 000008BE 66B806000000             mov eax, 6
  1714 000008C4 8846FE                   mov byte [bp-2], al
  1715                                  
  1716                                  ;-134   if (RegNo==7) m=5;//DI
  1717                                  
  1718                                  @@getIndReg146:
  1719 000008C7 A0[3F00]                 mov al, [RegNo]
  1720 000008CA 3C07                     cmp al, 7
  1721 000008CC 0F850900                 jne @@getIndReg147
  1722 000008D0 66B805000000             mov eax, 5
  1723 000008D6 8846FE                   mov byte [bp-2], al
  1724                                  
  1725                                  ;-135   if (RegNo==6) m=4;//SI
  1726                                  
  1727                                  @@getIndReg147:
  1728 000008D9 A0[3F00]                 mov al, [RegNo]
  1729 000008DC 3C06                     cmp al, 6
  1730 000008DE 0F850900                 jne @@getIndReg148
  1731 000008E2 66B804000000             mov eax, 4
  1732 000008E8 8846FE                   mov byte [bp-2], al
  1733                                  
  1734                                  ;-136   if (m    ==0) indexerror();
  1735                                  
  1736                                  @@getIndReg148:
  1737 000008EB 8A46FE                   mov al, [bp-2]
  1738 000008EE 3C00                     cmp al, 0
  1739 000008F0 0F850300                 jne @@getIndReg149
  1740 000008F4 E8DF10                   call indexerror
  1741                                  
  1742                                  ;-137   return m;
  1743                                  
  1744                                  @@getIndReg149:
  1745 000008F7 8A46FE                   mov al, [bp-2]
  1746 000008FA E90000                   jmp @@retn
  1747                                  
  1748                                  ;-138 }
  1749                                  
  1750                                  
  1751                                  ;-139 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1752                                  
  1753 000008FD C9                      @@retn: LEAVE
  1754 000008FE C3                       ret
  1755                                  ; ENDP
  1756                                  
  1757                                  getIndReg2:  ; *** PROC ***
  1758                                  ;Function : getIndReg2, Number of local variables: 2
  1759                                  ;   # type sign width line used address name   list of local variables
  1760                                  ;  200 var sign byte   139 NULL bp+4    r1
  1761                                  ;  201 var sign byte   139 NULL bp-2    m;
  1762 000008FF C8020000                 ENTER  2,0
  1763 00000903 66B804000000             mov eax, 4
  1764 00000909 8846FE                   mov byte [bp-2], al
  1765                                  
  1766                                  ;-140   if (RegType !=WORD) indexerror();
  1767                                  
  1768 0000090C A0[3E00]                 mov al, [RegType]
  1769 0000090F 3C02                     cmp al, 2
  1770 00000911 0F840300                 je  @@getIndReg250
  1771 00000915 E8BE10                   call indexerror
  1772                                  
  1773                                  ;-141   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1774                                  
  1775                                  @@getIndReg250:
  1776 00000918 A0[3F00]                 mov al, [RegNo]
  1777 0000091B 3C07                     cmp al, 7
  1778 0000091D 0F852700                 jne @@getIndReg251
  1779 00000921 8A4604                   mov al, [bp+4]
  1780 00000924 3C06                     cmp al, 6
  1781 00000926 0F850C00                 jne @@getIndReg252
  1782 0000092A 66B803000000             mov eax, 3
  1783 00000930 8846FE                   mov byte [bp-2], al
  1784                                  
  1785                                  ;-142            else if (r1==7) m=1;//BX+DI
  1786                                  
  1787 00000933 E91200                   jmp @@getIndReg253
  1788                                  @@getIndReg252:
  1789 00000936 8A4604                   mov al, [bp+4]
  1790 00000939 3C07                     cmp al, 7
  1791 0000093B 0F850900                 jne @@getIndReg254
  1792 0000093F 66B801000000             mov eax, 1
  1793 00000945 8846FE                   mov byte [bp-2], al
  1794                                  
  1795                                  ;-143   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1796                                  
  1797                                  @@getIndReg254:
  1798                                  @@getIndReg253:
  1799                                  @@getIndReg251:
  1800 00000948 A0[3F00]                 mov al, [RegNo]
  1801 0000094B 3C06                     cmp al, 6
  1802 0000094D 0F852700                 jne @@getIndReg255
  1803 00000951 8A4604                   mov al, [bp+4]
  1804 00000954 3C06                     cmp al, 6
  1805 00000956 0F850C00                 jne @@getIndReg256
  1806 0000095A 66B802000000             mov eax, 2
  1807 00000960 8846FE                   mov byte [bp-2], al
  1808                                  
  1809                                  ;-144            else if (r1==7) m=0;//BX+DI
  1810                                  
  1811 00000963 E91200                   jmp @@getIndReg257
  1812                                  @@getIndReg256:
  1813 00000966 8A4604                   mov al, [bp+4]
  1814 00000969 3C07                     cmp al, 7
  1815 0000096B 0F850900                 jne @@getIndReg258
  1816 0000096F 66B800000000             mov eax, 0
  1817 00000975 8846FE                   mov byte [bp-2], al
  1818                                  
  1819                                  ;-145   if (m > 3) indexerror();
  1820                                  
  1821                                  @@getIndReg258:
  1822                                  @@getIndReg257:
  1823                                  @@getIndReg255:
  1824 00000978 8A46FE                   mov al, [bp-2]
  1825 0000097B 3C03                     cmp al, 3
  1826 0000097D 0F8E0300                 jle @@getIndReg259
  1827 00000981 E85210                   call indexerror
  1828                                  
  1829                                  ;-146   return m;
  1830                                  
  1831                                  @@getIndReg259:
  1832 00000984 8A46FE                   mov al, [bp-2]
  1833 00000987 E90000                   jmp @@retn
  1834                                  
  1835                                  ;-147 }
  1836                                  
  1837                                  
  1838                                  ;-148 
  1839                                  
  1840                                  
  1841                                  ;-149 // generate code ...........................................................
  1842                                  
  1843                                  
  1844                                  ;-150 int gen66h() {genCode8(0x66);}
  1845                                  
  1846 0000098A C9                      @@retn: LEAVE
  1847 0000098B C3                       ret
  1848                                  ; ENDP
  1849                                  
  1850                                  gen66h:  ; *** PROC ***
  1851 0000098C 6A66                     push 102
  1852 0000098E E80400                   call genCode8
  1853 00000991 83C402                   add  sp, 2
  1854                                  
  1855                                  ;-151 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  1856                                  
  1857 00000994 C3                       ret
  1858                                  ; ENDP
  1859                                  
  1860                                  genCode8:  ; *** PROC ***
  1861                                  
  1862                                  ;-152   FileBin[BinLen]=c; BinLen++; PC++;
  1863                                  
  1864                                  ;Function : genCode8, Number of local variables: 1
  1865                                  ;   # type sign width line used address name   list of local variables
  1866                                  ;  200 var sign byte   151 NULL bp+4    c;
  1867 00000995 C8000000                 ENTER  0,0
  1868 00000999 8A4604                   mov al, [bp+4]
  1869 0000099C 8B1E[5400]               mov bx, [BinLen]
  1870 000009A0 88876B7B                 mov [FileBin+bx], al
  1871 000009A4 FF06[5400]               inc  word [BinLen]
  1872 000009A8 FF06[3600]               inc  word [PC]
  1873                                  
  1874                                  ;-153   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
  1875                                  
  1876 000009AC A1[4900]                 mov ax, [OpPrintIndex]
  1877 000009AF 83F805                   cmp ax, 5
  1878 000009B2 0F8D0F00                 jge @@genCode860
  1879 000009B6 8A4604                   mov al, [bp+4]
  1880 000009B9 8B1E[4900]               mov bx, [OpPrintIndex]
  1881 000009BD 8887B676                 mov [OpPos+bx], al
  1882 000009C1 FF06[4900]               inc  word [OpPrintIndex]
  1883                                  
  1884                                  ;-154 }
  1885                                  
  1886                                  @@genCode860:
  1887                                  
  1888                                  ;-155 int genCode16(int i) {
  1889 000009C5 C9                       LEAVE
  1890 000009C6 C3                       ret
  1891                                  ; ENDP
  1892                                  
  1893                                  genCode16:  ; *** PROC ***
  1894                                  
  1895                                  ;-156   genCode8(i); i=i >> 8; genCode8(i);
  1896                                  
  1897                                  ;Function : genCode16, Number of local variables: 1
  1898                                  ;   # type sign width line used address name   list of local variables
  1899                                  ;  200 var sign word   155 NULL bp+4    i;
  1900 000009C7 C8000000                 ENTER  0,0
  1901 000009CB FF7604                   push word [bp+4]
  1902 000009CE E8C4FF                   call genCode8
  1903 000009D1 83C402                   add  sp, 2
  1904 000009D4 8B4604                   mov ax, [bp+4]
  1905 000009D7 C1E808                   shr ax, 8
  1906 000009DA 894604                   mov word [bp+4], ax
  1907 000009DD FF7604                   push word [bp+4]
  1908 000009E0 E8B2FF                   call genCode8
  1909 000009E3 83C402                   add  sp, 2
  1910                                  
  1911                                  ;-157 }
  1912                                  
  1913                                  
  1914                                  ;-158 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  1915 000009E6 C9                       LEAVE
  1916 000009E7 C3                       ret
  1917                                  ; ENDP
  1918                                  
  1919                                  genInstruction:  ; *** PROC ***
  1920                                  
  1921                                  ;-159   if(loc) OpCodePtr=OpCodePtr+loc;
  1922                                  
  1923                                  ;Function : genInstruction, Number of local variables: 3
  1924                                  ;   # type sign width line used address name   list of local variables
  1925                                  ;  200 var sign byte   158 NULL bp+4    No
  1926                                  ;  201 var sign word   158 NULL bp+6    loc
  1927                                  ;  202 var sign byte   158 NULL bp-2    c;
  1928 000009E8 C8020000                 ENTER  2,0
  1929 000009EC 8B4606                   mov ax, [bp+6]
  1930 000009EF 08C0                     or  al, al
  1931 000009F1 0F840900                 je @@genInstruction61
  1932 000009F5 A1[4B00]                 mov ax, [OpCodePtr]
  1933 000009F8 034606                   add ax, [bp+6]
  1934 000009FB A3[4B00]                 mov word [OpCodePtr], ax
  1935                                  
  1936                                  ;-160   c= *OpCodePtr + No; genCode8(c);
  1937                                  
  1938                                  @@genInstruction61:
  1939 000009FE 8B1E[4B00]               mov bx, [OpCodePtr]
  1940 00000A02 8A07                     mov al, [bx]
  1941 00000A04 B400                     mov ah, 0
  1942 00000A06 024604                   add al, [bp+4]
  1943 00000A09 8846FE                   mov byte [bp-2], al
  1944 00000A0C 8A46FE                   mov al, byte [bp-2]
  1945 00000A0F B400                     mov ah, 0
  1946 00000A11 50                       push ax
  1947 00000A12 E880FF                   call genCode8
  1948 00000A15 83C402                   add  sp, 2
  1949                                  
  1950                                  ;-161 }
  1951                                  
  1952                                  
  1953                                  ;-162 int genCodeInREG() {char x; //get Code for second byte
  1954 00000A18 C9                       LEAVE
  1955 00000A19 C3                       ret
  1956                                  ; ENDP
  1957                                  
  1958                                  genCodeInREG:  ; *** PROC ***
  1959                                  
  1960                                  ;-163   OpCodePtr++; x= *OpCodePtr; writeEA(x);
  1961                                  
  1962                                  ;Function : genCodeInREG, Number of local variables: 1
  1963                                  ;   # type sign width line used address name   list of local variables
  1964                                  ;  200 var sign byte   162 NULL bp-2    x;
  1965 00000A1A C8020000                 ENTER  2,0
  1966 00000A1E FF06[4B00]               inc  word [OpCodePtr]
  1967 00000A22 8B1E[4B00]               mov bx, [OpCodePtr]
  1968 00000A26 8A07                     mov al, [bx]
  1969 00000A28 B400                     mov ah, 0
  1970 00000A2A 8846FE                   mov byte [bp-2], al
  1971 00000A2D 8A46FE                   mov al, byte [bp-2]
  1972 00000A30 B400                     mov ah, 0
  1973 00000A32 50                       push ax
  1974 00000A33 E81200                   call writeEA
  1975 00000A36 83C402                   add  sp, 2
  1976                                  
  1977                                  ;-164 }
  1978                                  
  1979                                  
  1980                                  ;-165 int genModRegRM(){ writeEA(reg);//todo
  1981 00000A39 C9                       LEAVE
  1982 00000A3A C3                       ret
  1983                                  ; ENDP
  1984                                  
  1985                                  genModRegRM:  ; *** PROC ***
  1986 00000A3B A0[4400]                 mov al, byte [reg]
  1987 00000A3E B400                     mov ah, 0
  1988 00000A40 50                       push ax
  1989 00000A41 E80400                   call writeEA
  1990 00000A44 83C402                   add  sp, 2
  1991                                  
  1992                                  ;-166 }
  1993                                  
  1994                                  
  1995                                  ;-167 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  1996                                  
  1997 00000A47 C3                       ret
  1998                                  ; ENDP
  1999                                  
  2000                                  writeEA:  ; *** PROC ***
  2001                                  
  2002                                  ;-168   len=0;
  2003                                  
  2004                                  ;Function : writeEA, Number of local variables: 2
  2005                                  ;   # type sign width line used address name   list of local variables
  2006                                  ;  200 var sign byte   167 NULL bp+4    xxx
  2007                                  ;  201 var sign byte   167 NULL bp-2    len;
  2008 00000A48 C8020000                 ENTER  2,0
  2009 00000A4C 66B800000000             mov eax, 0
  2010 00000A52 8846FE                   mov byte [bp-2], al
  2011                                  
  2012                                  ;-169   xxx = xxx << 3;//in reg field of mod r/m
  2013                                  
  2014 00000A55 8A4604                   mov al, [bp+4]
  2015 00000A58 C0E003                   shl al, 3
  2016 00000A5B 884604                   mov byte [bp+4], al
  2017                                  
  2018                                  ;-170   if (Op1 ==   0) addrexit();
  2019                                  
  2020 00000A5E A0[3C00]                 mov al, [Op1]
  2021 00000A61 3C00                     cmp al, 0
  2022 00000A63 0F850300                 jne @@writeEA62
  2023 00000A67 E82010                   call addrexit
  2024                                  
  2025                                  ;-171   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  2026                                  
  2027                                  @@writeEA62:
  2028 00000A6A A0[3C00]                 mov al, [Op1]
  2029 00000A6D 3C02                     cmp al, 2
  2030 00000A6F 0F850E00                 jne @@writeEA63
  2031 00000A73 804E04C0                 or  byte [bp+4], 192
  2032 00000A77 8A4604                   mov al, [bp+4]
  2033 00000A7A 0206[3F00]               add al, [RegNo]
  2034 00000A7E 884604                   mov byte [bp+4], al
  2035                                  
  2036                                  ;-172   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  2037                                  
  2038                                  @@writeEA63:
  2039 00000A81 A0[3C00]                 mov al, [Op1]
  2040 00000A84 3C03                     cmp al, 3
  2041 00000A86 0F850D00                 jne @@writeEA64
  2042 00000A8A 804E0406                 or  byte [bp+4], 6
  2043 00000A8E 66B802000000             mov eax, 2
  2044 00000A94 8846FE                   mov byte [bp-2], al
  2045                                  
  2046                                  ;-173   if (Op1 == IND) { xxx = xxx + reg;                       //4
  2047                                  
  2048                                  @@writeEA64:
  2049 00000A97 A0[3C00]                 mov al, [Op1]
  2050 00000A9A 3C04                     cmp al, 4
  2051 00000A9C 0F854600                 jne @@writeEA65
  2052 00000AA0 8A4604                   mov al, [bp+4]
  2053 00000AA3 0206[4400]               add al, [reg]
  2054 00000AA7 884604                   mov byte [bp+4], al
  2055                                  
  2056                                  ;-174     if (disp) {disp; if(ax > 127) len=2; else len=1;
  2057                                  
  2058 00000AAA A1[4500]                 mov ax, [disp]
  2059 00000AAD 08C0                     or  al, al
  2060 00000AAF 0F843300                 je @@writeEA66
  2061 00000AB3 A1[4500]                 mov ax, [disp]
  2062 00000AB6 83F87F                   cmp  ax, 127
  2063 00000AB9 0F8E0C00                 jle @@writeEA67
  2064 00000ABD 66B802000000             mov eax, 2
  2065 00000AC3 8846FE                   mov byte [bp-2], al
  2066 00000AC6 E90900                   jmp @@writeEA68
  2067                                  @@writeEA67:
  2068 00000AC9 66B801000000             mov eax, 1
  2069 00000ACF 8846FE                   mov byte [bp-2], al
  2070                                  
  2071                                  ;-175       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
  2072                                  
  2073                                  @@writeEA68:
  2074 00000AD2 8A46FE                   mov al, [bp-2]
  2075 00000AD5 3C01                     cmp al, 1
  2076 00000AD7 0F850700                 jne @@writeEA69
  2077 00000ADB 804E0440                 or  byte [bp+4], 64
  2078 00000ADF E90400                   jmp @@writeEA70
  2079                                  @@writeEA69:
  2080 00000AE2 804E0480                 or  byte [bp+4], 128
  2081                                  @@writeEA70:
  2082                                  
  2083                                  ;-176     }
  2084                                  
  2085                                  @@writeEA66:
  2086                                  
  2087                                  ;-177   genCode8(xxx);// gen second byte
  2088                                  
  2089                                  @@writeEA65:
  2090 00000AE6 8A4604                   mov al, byte [bp+4]
  2091 00000AE9 B400                     mov ah, 0
  2092 00000AEB 50                       push ax
  2093 00000AEC E8A6FE                   call genCode8
  2094 00000AEF 83C402                   add  sp, 2
  2095                                  
  2096                                  ;-178   if (len == 1) genCode8 (disp);
  2097                                  
  2098 00000AF2 8A46FE                   mov al, [bp-2]
  2099 00000AF5 3C01                     cmp al, 1
  2100 00000AF7 0F850A00                 jne @@writeEA71
  2101 00000AFB FF36[4500]               push word [disp]
  2102 00000AFF E893FE                   call genCode8
  2103 00000B02 83C402                   add  sp, 2
  2104                                  
  2105                                  ;-179   if (len == 2) genCode16(disp);
  2106                                  
  2107                                  @@writeEA71:
  2108 00000B05 8A46FE                   mov al, [bp-2]
  2109 00000B08 3C02                     cmp al, 2
  2110 00000B0A 0F850A00                 jne @@writeEA72
  2111 00000B0E FF36[4500]               push word [disp]
  2112 00000B12 E8B2FE                   call genCode16
  2113 00000B15 83C402                   add  sp, 2
  2114                                  
  2115                                  ;-180 }
  2116                                  
  2117                                  @@writeEA72:
  2118                                  
  2119                                  ;-181 
  2120                                  
  2121                                  
  2122                                  ;-182 //#include "AS1.C"
  2123                                  
  2124                                  
  2125                                  ;-183 #include "PARSE.C"
  2126 00000B18 C9                       LEAVE
  2127 00000B19 C3                       ret
  2128                                  ; ENDP
  2129                                  ;Use include file: PARSE.C
  2130                                  
  2131                                  ;-1 int parse() {
  2132                                  
  2133                                  
  2134                                  parse:  ; *** PROC ***
  2135                                  
  2136                                  ;-2   LabelNamePtr= &LabelNames;
  2137                                  
  2138 00000B1A B8BB76                   mov ax, LabelNames
  2139 00000B1D A3[4E00]                 mov word [LabelNamePtr], ax
  2140                                  
  2141                                  ;-3   do {
  2142                                  
  2143                                  @@parse73:
  2144                                  
  2145                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  2146                                  
  2147 00000B20 A1[3600]                 mov ax, [PC]
  2148 00000B23 A3[3800]                 mov word [PCStart], ax
  2149 00000B26 66B800000000             mov eax, 0
  2150 00000B2C A2[4000]                 mov byte [OpSize], al
  2151 00000B2F 66B800000000             mov eax, 0
  2152 00000B35 A3[4900]                 mov word [OpPrintIndex], ax
  2153 00000B38 66B820000000             mov eax, 32
  2154 00000B3E A2[4D00]                 mov byte [PrReloc], al
  2155                                  
  2156                                  ;-5     getLine();
  2157                                  
  2158 00000B41 E8A104                   call getLine
  2159                                  
  2160                                  ;-6     InputPtr = &InputBuf;
  2161                                  
  2162 00000B44 B86E75                   mov ax, InputBuf
  2163 00000B47 A3[2700]                 mov word [InputPtr], ax
  2164                                  
  2165                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2166                                  
  2167 00000B4A E8B700                   call getTokeType
  2168                                  
  2169                                  ;-8     if (TokeType == ALNUME) {
  2170                                  
  2171 00000B4D A0[3B00]                 mov al, [TokeType]
  2172 00000B50 3C03                     cmp al, 3
  2173 00000B52 0F851300                 jne @@parse74
  2174                                  
  2175                                  ;-9       if (isLabel) { //set in getName
  2176                                  
  2177 00000B56 A0[3A00]                 mov al, [isLabel]
  2178 00000B59 08C0                     or  al, al
  2179 00000B5B 0F840A00                 je @@parse75
  2180                                  
  2181                                  ;-10         storeLabel();
  2182                                  
  2183 00000B5F E84001                   call storeLabel
  2184                                  
  2185                                  ;-11         InputPtr++;//remove :
  2186                                  
  2187 00000B62 FF06[2700]               inc  word [InputPtr]
  2188                                  
  2189                                  ;-12         getTokeType();
  2190                                  
  2191 00000B66 E89B00                   call getTokeType
  2192                                  
  2193                                  ;-13       }
  2194                                  
  2195                                  
  2196                                  ;-14     }
  2197                                  
  2198                                  @@parse75:
  2199                                  
  2200                                  ;-15     if (TokeType == ALNUME) {
  2201                                  
  2202                                  @@parse74:
  2203 00000B69 A0[3B00]                 mov al, [TokeType]
  2204 00000B6C 3C03                     cmp al, 3
  2205 00000B6E 0F851B00                 jne @@parse76
  2206                                  
  2207                                  ;-16       lookCode();// and OpCodePtr
  2208                                  
  2209 00000B72 E80F03                   call lookCode
  2210                                  
  2211                                  ;-17       if(CodeType) process();
  2212                                  
  2213 00000B75 A0[3D00]                 mov al, [CodeType]
  2214 00000B78 08C0                     or  al, al
  2215 00000B7A 0F840600                 je @@parse77
  2216 00000B7E E8A2F8                   call process
  2217                                  
  2218                                  ;-18       else getVariable();
  2219                                  
  2220 00000B81 E90300                   jmp @@parse78
  2221                                  @@parse77:
  2222 00000B84 E8C501                   call getVariable
  2223                                  
  2224                                  ;-19       skipRest();
  2225                                  
  2226                                  @@parse78:
  2227 00000B87 E82504                   call skipRest
  2228                                  
  2229                                  ;-20     }
  2230                                  
  2231                                  
  2232                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2233                                  
  2234 00000B8A E92700                   jmp @@parse79
  2235                                  @@parse76:
  2236 00000B8D A0[3B00]                 mov al, [TokeType]
  2237 00000B90 3C03                     cmp al, 3
  2238 00000B92 0F8E0C00                 jle @@parse80
  2239 00000B96 68[C50B]                 push parse_0
  2240 00000B99 E8A60D                   call error1
  2241 00000B9C 83C402                   add  sp, 2
  2242                                  
  2243                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2244                                  
  2245 00000B9F E91200                   jmp @@parse81
  2246                                  @@parse80:
  2247 00000BA2 A0[3B00]                 mov al, [TokeType]
  2248 00000BA5 3C01                     cmp al, 1
  2249 00000BA7 0F850900                 jne @@parse82
  2250 00000BAB 68[E30B]                 push parse_1
  2251 00000BAE E8910D                   call error1
  2252 00000BB1 83C402                   add  sp, 2
  2253                                  
  2254                                  ;-23     printLine();
  2255                                  
  2256                                  @@parse82:
  2257                                  @@parse81:
  2258                                  @@parse79:
  2259 00000BB4 E8200B                   call printLine
  2260                                  
  2261                                  ;-24   } while (DOS_NoBytes != 0 );
  2262                                  
  2263 00000BB7 A1[3300]                 mov ax, [DOS_NoBytes]
  2264 00000BBA 83F800                   cmp ax, 0
  2265 00000BBD 0F840300                 je  @@parse83
  2266 00000BC1 E95CFF                   jmp @@parse73
  2267                                  @@parse83:
  2268                                  
  2269                                  ;-25 }
  2270                                  
  2271                                  
  2272                                  ;-26 // scan code .....................................
  2273                                  
  2274                                  
  2275                                  ;-27 int getTokeType() { char c;
  2276                                  
  2277 00000BC4 C3                       ret
  2278                                  ; ENDP
  2279 00000BC5 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2280 00000BCE 696E73747275637469-
  2281 00000BD7 6F6E20657870656374-
  2282 00000BE0 656400             
  2283 00000BE3 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2284 00000BEC 616C6C6F7765642040-
  2285 00000BF5 207374617274206F66-
  2286 00000BFE 206C696E6500       
  2287                                  
  2288                                  getTokeType:  ; *** PROC ***
  2289                                  
  2290                                  ;-28   skipBlank();
  2291                                  
  2292                                  ;Function : getTokeType, Number of local variables: 1
  2293                                  ;   # type sign width line used address name   list of local variables
  2294                                  ;  200 var sign byte    27 NULL bp-2    c;
  2295 00000C04 C8020000                 ENTER  2,0
  2296 00000C08 E8A704                   call skipBlank
  2297                                  
  2298                                  ;-29   c = *InputPtr;
  2299                                  
  2300 00000C0B 8B1E[2700]               mov bx, [InputPtr]
  2301 00000C0F 8A07                     mov al, [bx]
  2302 00000C11 B400                     mov ah, 0
  2303 00000C13 8846FE                   mov byte [bp-2], al
  2304                                  
  2305                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2306                                  
  2307 00000C16 8A46FE                   mov al, [bp-2]
  2308 00000C19 3C00                     cmp al, 0
  2309 00000C1B 0F850C00                 jne @@getTokeType84
  2310 00000C1F 66B800000000             mov eax, 0
  2311 00000C25 A2[3B00]                 mov byte [TokeType], al
  2312 00000C28 E97500                   jmp @@retn
  2313                                  
  2314                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2315                                  
  2316                                  @@getTokeType84:
  2317 00000C2B 8A46FE                   mov al, [bp-2]
  2318 00000C2E 3C3B                     cmp al, 59
  2319 00000C30 0F850C00                 jne @@getTokeType85
  2320 00000C34 66B800000000             mov eax, 0
  2321 00000C3A A2[3B00]                 mov byte [TokeType], al
  2322 00000C3D E96000                   jmp @@retn
  2323                                  
  2324                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2325                                  
  2326                                  @@getTokeType85:
  2327 00000C40 8A46FE                   mov al, byte [bp-2]
  2328 00000C43 B400                     mov ah, 0
  2329 00000C45 50                       push ax
  2330 00000C46 E84D13                   call digit
  2331 00000C49 83C402                   add  sp, 2
  2332 00000C4C 08C0                     or  al, al
  2333 00000C4E 0F841800                 je @@getTokeType86
  2334 00000C52 8A46FE                   mov al, byte [bp-2]
  2335 00000C55 B400                     mov ah, 0
  2336 00000C57 50                       push ax
  2337 00000C58 E85D05                   call getDigit
  2338 00000C5B 83C402                   add  sp, 2
  2339 00000C5E 66B801000000             mov eax, 1
  2340 00000C64 A2[3B00]                 mov byte [TokeType], al
  2341 00000C67 E93600                   jmp @@retn
  2342                                  
  2343                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2344                                  
  2345                                  @@getTokeType86:
  2346 00000C6A 8A46FE                   mov al, byte [bp-2]
  2347 00000C6D B400                     mov ah, 0
  2348 00000C6F 50                       push ax
  2349 00000C70 E86A04                   call letterE
  2350 00000C73 83C402                   add  sp, 2
  2351 00000C76 08C0                     or  al, al
  2352 00000C78 0F841800                 je @@getTokeType87
  2353 00000C7C 8A46FE                   mov al, byte [bp-2]
  2354 00000C7F B400                     mov ah, 0
  2355 00000C81 50                       push ax
  2356 00000C82 E88A05                   call getName
  2357 00000C85 83C402                   add  sp, 2
  2358 00000C88 66B803000000             mov eax, 3
  2359 00000C8E A2[3B00]                 mov byte [TokeType], al
  2360 00000C91 E90C00                   jmp @@retn
  2361                                  
  2362                                  ;-34   TokeType=NOALNUME; return;
  2363                                  
  2364                                  @@getTokeType87:
  2365 00000C94 66B804000000             mov eax, 4
  2366 00000C9A A2[3B00]                 mov byte [TokeType], al
  2367 00000C9D E90000                   jmp @@retn
  2368                                  
  2369                                  ;-35 }
  2370                                  
  2371                                  
  2372                                  ;-36 int storeLabel() {
  2373                                  
  2374 00000CA0 C9                      @@retn: LEAVE
  2375 00000CA1 C3                       ret
  2376                                  ; ENDP
  2377                                  
  2378                                  storeLabel:  ; *** PROC ***
  2379                                  
  2380                                  ;-37   if(searchLabel()) error1("duplicate label");
  2381                                  
  2382 00000CA2 E84700                   call searchLabel
  2383 00000CA5 08C0                     or  al, al
  2384 00000CA7 0F840900                 je @@storeLabel88
  2385 00000CAB 68[DC0C]                 push storeLabel_0
  2386 00000CAE E8910C                   call error1
  2387 00000CB1 83C402                   add  sp, 2
  2388                                  
  2389                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2390                                  
  2391                                  @@storeLabel88:
  2392 00000CB4 8D063075                 lea  ax, [Symbol]
  2393 00000CB8 50                       push ax
  2394 00000CB9 FF36[4E00]               push word [LabelNamePtr]
  2395 00000CBD E89D12                   call strcpy
  2396 00000CC0 83C404                   add  sp, 4
  2397 00000CC3 A3[4E00]                 mov word [LabelNamePtr], ax
  2398                                  
  2399                                  ;-39   LabelNamePtr++;
  2400                                  
  2401 00000CC6 FF06[4E00]               inc  word [LabelNamePtr]
  2402                                  
  2403                                  ;-40   LabelMaxIx++;
  2404                                  
  2405 00000CCA FF06[5000]               inc  word [LabelMaxIx]
  2406                                  
  2407                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2408                                  
  2409 00000CCE A1[3600]                 mov ax, [PC]
  2410 00000CD1 8B1E[5000]               mov bx, [LabelMaxIx]
  2411 00000CD5 D1E3                     shl bx, 1
  2412 00000CD7 8987A37A                 mov [LabelAddr+bx], ax
  2413                                  
  2414                                  ;-42 }
  2415                                  
  2416                                  
  2417                                  ;-43 int searchLabel() {
  2418                                  
  2419 00000CDB C3                       ret
  2420                                  ; ENDP
  2421 00000CDC 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2422 00000CE5 206C6162656C00     
  2423                                  
  2424                                  searchLabel:  ; *** PROC ***
  2425                                  
  2426                                  ;-44   int LIx; char *p; int j;
  2427                                  
  2428                                  
  2429                                  ;-45   p = &LabelNames;
  2430                                  
  2431                                  ;Function : searchLabel, Number of local variables: 3
  2432                                  ;   # type sign width line used address name   list of local variables
  2433                                  ;  200 var sign word    44 NULL bp-2    LIx
  2434                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2435                                  ;  202 var sign word    44 NULL bp-6    j;
  2436 00000CEC C8060000                 ENTER  6,0
  2437 00000CF0 B8BB76                   mov ax, LabelNames
  2438 00000CF3 8946FC                   mov word [bp-4], ax
  2439                                  
  2440                                  ;-46   LIx=1;
  2441                                  
  2442 00000CF6 66B801000000             mov eax, 1
  2443 00000CFC 8946FE                   mov word [bp-2], ax
  2444                                  
  2445                                  ;-47   while (LIx <= LabelMaxIx) {
  2446                                  
  2447                                  @@searchLabel89:
  2448 00000CFF 8B46FE                   mov ax, [bp-2]
  2449 00000D02 3B06[5000]               cmp ax, [LabelMaxIx]
  2450 00000D06 0F8F3700                 jg  @@searchLabel90
  2451                                  
  2452                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2453                                  
  2454 00000D0A 8D063075                 lea  ax, [Symbol]
  2455 00000D0E 50                       push ax
  2456 00000D0F FF76FC                   push word [bp-4]
  2457 00000D12 E8B412                   call eqstr
  2458 00000D15 83C404                   add  sp, 4
  2459 00000D18 08C0                     or  al, al
  2460 00000D1A 0F840600                 je @@searchLabel91
  2461 00000D1E 8B46FE                   mov ax, [bp-2]
  2462 00000D21 E92600                   jmp @@retn
  2463                                  
  2464                                  ;-49     j=strlen(p);
  2465                                  
  2466                                  @@searchLabel91:
  2467 00000D24 FF76FC                   push word [bp-4]
  2468 00000D27 E80812                   call strlen
  2469 00000D2A 83C402                   add  sp, 2
  2470 00000D2D 8946FA                   mov word [bp-6], ax
  2471                                  
  2472                                  ;-50     p=p+j; p++; LIx++;
  2473                                  
  2474 00000D30 8B46FC                   mov ax, [bp-4]
  2475 00000D33 0346FA                   add ax, [bp-6]
  2476 00000D36 8946FC                   mov word [bp-4], ax
  2477 00000D39 FF46FC                   inc  word [bp-4]
  2478 00000D3C FF46FE                   inc  word [bp-2]
  2479                                  
  2480                                  ;-51   }
  2481                                  
  2482                                  
  2483                                  ;-52   return 0;
  2484                                  
  2485 00000D3F EBBE                     jmp @@searchLabel89
  2486                                  @@searchLabel90:
  2487 00000D41 66B800000000             mov eax, 0
  2488 00000D47 E90000                   jmp @@retn
  2489                                  
  2490                                  ;-53 }
  2491                                  
  2492                                  
  2493                                  ;-54 int getVariable() { char c;
  2494                                  
  2495 00000D4A C9                      @@retn: LEAVE
  2496 00000D4B C3                       ret
  2497                                  ; ENDP
  2498                                  
  2499                                  getVariable:  ; *** PROC ***
  2500                                  
  2501                                  ;-55   storeLabel();
  2502                                  
  2503                                  ;Function : getVariable, Number of local variables: 1
  2504                                  ;   # type sign width line used address name   list of local variables
  2505                                  ;  200 var sign byte    54 NULL bp-2    c;
  2506 00000D4C C8020000                 ENTER  2,0
  2507 00000D50 E84FFF                   call storeLabel
  2508                                  
  2509                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2510                                  
  2511 00000D53 E8AEFE                   call getTokeType
  2512 00000D56 A0[3B00]                 mov al, [TokeType]
  2513 00000D59 3C03                     cmp al, 3
  2514 00000D5B 0F85CC00                 jne @@getVariable92
  2515                                  
  2516                                  ;-57     lookCode();
  2517                                  
  2518 00000D5F E82201                   call lookCode
  2519                                  
  2520                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2521                                  
  2522 00000D62 A0[3D00]                 mov al, [CodeType]
  2523 00000D65 3CC8                     cmp al, 200
  2524 00000D67 0F8D0900                 jge @@getVariable93
  2525 00000D6B 68[360E]                 push getVariable_0
  2526 00000D6E E8020D                   call errorexit
  2527 00000D71 83C402                   add  sp, 2
  2528                                  
  2529                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2530                                  
  2531                                  @@getVariable93:
  2532 00000D74 A0[3D00]                 mov al, [CodeType]
  2533 00000D77 3CCF                     cmp al, 207
  2534 00000D79 0F8E0900                 jle @@getVariable94
  2535 00000D7D 68[4E0E]                 push getVariable_1
  2536 00000D80 E8F00C                   call errorexit
  2537 00000D83 83C402                   add  sp, 2
  2538                                  
  2539                                  ;-60     if (CodeType== 200) {// DB
  2540                                  
  2541                                  @@getVariable94:
  2542 00000D86 A0[3D00]                 mov al, [CodeType]
  2543 00000D89 3CC8                     cmp al, 200
  2544 00000D8B 0F856A00                 jne @@getVariable95
  2545                                  
  2546                                  ;-61       do { getTokeType();
  2547                                  
  2548                                  @@getVariable96:
  2549 00000D8F E872FE                   call getTokeType
  2550                                  
  2551                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2552                                  
  2553 00000D92 A0[3B00]                 mov al, [TokeType]
  2554 00000D95 3C01                     cmp al, 1
  2555 00000D97 0F850D00                 jne @@getVariable97
  2556 00000D9B FF36[2500]               push word [SymbolInt]
  2557 00000D9F E8F3FB                   call genCode8
  2558 00000DA2 83C402                   add  sp, 2
  2559                                  
  2560                                  ;-63         else {
  2561                                  
  2562 00000DA5 E94100                   jmp @@getVariable98
  2563                                  @@getVariable97:
  2564                                  
  2565                                  ;-64           skipBlank();
  2566                                  
  2567 00000DA8 E80703                   call skipBlank
  2568                                  
  2569                                  ;-65           if (isToken('"')) {
  2570                                  
  2571 00000DAB 6A22                     push 34
  2572 00000DAD E8D101                   call isToken
  2573 00000DB0 83C402                   add  sp, 2
  2574 00000DB3 08C0                     or  al, al
  2575 00000DB5 0F843000                 je @@getVariable99
  2576                                  
  2577                                  ;-66             do { c= *InputPtr;
  2578                                  
  2579                                  @@getVariable100:
  2580 00000DB9 8B1E[2700]               mov bx, [InputPtr]
  2581 00000DBD 8A07                     mov al, [bx]
  2582 00000DBF B400                     mov ah, 0
  2583 00000DC1 8846FE                   mov byte [bp-2], al
  2584                                  
  2585                                  ;-67               genCode8(c);
  2586                                  
  2587 00000DC4 8A46FE                   mov al, byte [bp-2]
  2588 00000DC7 B400                     mov ah, 0
  2589 00000DC9 50                       push ax
  2590 00000DCA E8C8FB                   call genCode8
  2591 00000DCD 83C402                   add  sp, 2
  2592                                  
  2593                                  ;-68               InputPtr++;
  2594                                  
  2595 00000DD0 FF06[2700]               inc  word [InputPtr]
  2596                                  
  2597                                  ;-69             } while (*InputPtr != '"' );
  2598                                  
  2599 00000DD4 8B1E[2700]               mov bx, [InputPtr]
  2600 00000DD8 8A07                     mov al, [bx]
  2601 00000DDA B400                     mov ah, 0
  2602 00000DDC 83F822                   cmp ax, 34
  2603 00000DDF 0F840200                 je  @@getVariable101
  2604 00000DE3 EBD4                     jmp @@getVariable100
  2605                                  @@getVariable101:
  2606                                  
  2607                                  ;-70             InputPtr++;
  2608                                  
  2609 00000DE5 FF06[2700]               inc  word [InputPtr]
  2610                                  
  2611                                  ;-71           }
  2612                                  
  2613                                  
  2614                                  ;-72         }
  2615                                  
  2616                                  @@getVariable99:
  2617                                  
  2618                                  ;-73       } while (isToken(','));
  2619                                  
  2620                                  @@getVariable98:
  2621 00000DE9 6A2C                     push 44
  2622 00000DEB E89301                   call isToken
  2623 00000DEE 83C402                   add  sp, 2
  2624 00000DF1 08C0                     or  al, al
  2625 00000DF3 0F840200                 je @@getVariable102
  2626 00000DF7 EB96                     jmp @@getVariable96
  2627                                  @@getVariable102:
  2628                                  
  2629                                  ;-74     }
  2630                                  
  2631                                  
  2632                                  ;-75     if (CodeType== 201) {// DW
  2633                                  
  2634                                  @@getVariable95:
  2635 00000DF9 A0[3D00]                 mov al, [CodeType]
  2636 00000DFC 3CC9                     cmp al, 201
  2637 00000DFE 0F852600                 jne @@getVariable103
  2638                                  
  2639                                  ;-76       do { getTokeType();
  2640                                  
  2641                                  @@getVariable104:
  2642 00000E02 E8FFFD                   call getTokeType
  2643                                  
  2644                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2645                                  
  2646 00000E05 A0[3B00]                 mov al, [TokeType]
  2647 00000E08 3C01                     cmp al, 1
  2648 00000E0A 0F850A00                 jne @@getVariable105
  2649 00000E0E FF36[2500]               push word [SymbolInt]
  2650 00000E12 E8B2FB                   call genCode16
  2651 00000E15 83C402                   add  sp, 2
  2652                                  
  2653                                  ;-78       } while (isToken(','));
  2654                                  
  2655                                  @@getVariable105:
  2656 00000E18 6A2C                     push 44
  2657 00000E1A E86401                   call isToken
  2658 00000E1D 83C402                   add  sp, 2
  2659 00000E20 08C0                     or  al, al
  2660 00000E22 0F840200                 je @@getVariable106
  2661 00000E26 EBDA                     jmp @@getVariable104
  2662                                  @@getVariable106:
  2663                                  
  2664                                  ;-79     }
  2665                                  
  2666                                  
  2667                                  ;-80   }
  2668                                  
  2669                                  @@getVariable103:
  2670                                  
  2671                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2672                                  
  2673 00000E28 E90900                   jmp @@getVariable107
  2674                                  @@getVariable92:
  2675 00000E2B 68[660E]                 push getVariable_2
  2676 00000E2E E8420C                   call errorexit
  2677 00000E31 83C402                   add  sp, 2
  2678                                  
  2679                                  ;-82 }
  2680                                  
  2681                                  @@getVariable107:
  2682                                  
  2683                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2684 00000E34 C9                       LEAVE
  2685 00000E35 C3                       ret
  2686                                  ; ENDP
  2687 00000E36 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2688 00000E3F 422C572C4420657870-
  2689 00000E48 656374656400       
  2690 00000E4E 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2691 00000E57 422C572C4420657870-
  2692 00000E60 656374656400       
  2693 00000E66 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2694 00000E6F 6F7220524553422C57-
  2695 00000E78 2C4420657870656374-
  2696 00000E81 656400             
  2697                                  
  2698                                  lookCode:  ; *** PROC ***
  2699                                  
  2700                                  ;-84   CodeType=0;
  2701                                  
  2702 00000E84 66B800000000             mov eax, 0
  2703 00000E8A A2[3D00]                 mov byte [CodeType], al
  2704                                  
  2705                                  ;-85   OpCodePtr= &I_START;
  2706                                  
  2707 00000E8D B8[5A00]                 mov ax, I_START
  2708 00000E90 A3[4B00]                 mov word [OpCodePtr], ax
  2709                                  
  2710                                  ;-86   OpCodePtr++;
  2711                                  
  2712 00000E93 FF06[4B00]               inc  word [OpCodePtr]
  2713                                  
  2714                                  ;-87   do  {
  2715                                  
  2716                                  @@lookCode108:
  2717                                  
  2718                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2719                                  
  2720 00000E97 FF36[4B00]               push word [OpCodePtr]
  2721 00000E9B 8D064F75                 lea  ax, [SymbolUpper]
  2722 00000E9F 50                       push ax
  2723 00000EA0 E82611                   call eqstr
  2724 00000EA3 83C404                   add  sp, 4
  2725 00000EA6 08C0                     or  al, al
  2726 00000EA8 0F842700                 je @@lookCode109
  2727                                  
  2728                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2729                                  
  2730                                  @@lookCode110:
  2731 00000EAC 8B1E[4B00]               mov bx, [OpCodePtr]
  2732 00000EB0 8A07                     mov al, [bx]
  2733 00000EB2 B400                     mov ah, 0
  2734 00000EB4 83F800                   cmp ax, 0
  2735 00000EB7 0F840600                 je  @@lookCode111
  2736 00000EBB FF06[4B00]               inc  word [OpCodePtr]
  2737                                  
  2738                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2739                                  
  2740 00000EBF EBEB                     jmp @@lookCode110
  2741                                  @@lookCode111:
  2742 00000EC1 FF06[4B00]               inc  word [OpCodePtr]
  2743 00000EC5 8B1E[4B00]               mov bx, [OpCodePtr]
  2744 00000EC9 8A07                     mov al, [bx]
  2745 00000ECB B400                     mov ah, 0
  2746 00000ECD A2[3D00]                 mov byte [CodeType], al
  2747                                  
  2748                                  ;-91       return;
  2749                                  
  2750 00000ED0 E92A00                   jmp @@retn
  2751                                  
  2752                                  ;-92     }
  2753                                  
  2754                                  
  2755                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2756                                  
  2757                                  @@lookCode109:
  2758                                  @@lookCode112:
  2759 00000ED3 8B1E[4B00]               mov bx, [OpCodePtr]
  2760 00000ED7 8A07                     mov al, [bx]
  2761 00000ED9 B400                     mov ah, 0
  2762 00000EDB 3DF100                   cmp ax, 241
  2763 00000EDE 0F840600                 je  @@lookCode113
  2764 00000EE2 FF06[4B00]               inc  word [OpCodePtr]
  2765                                  
  2766                                  ;-94   OpCodePtr++;
  2767                                  
  2768 00000EE6 EBEB                     jmp @@lookCode112
  2769                                  @@lookCode113:
  2770 00000EE8 FF06[4B00]               inc  word [OpCodePtr]
  2771                                  
  2772                                  ;-95   } while(*OpCodePtr!=0);
  2773                                  
  2774 00000EEC 8B1E[4B00]               mov bx, [OpCodePtr]
  2775 00000EF0 8A07                     mov al, [bx]
  2776 00000EF2 B400                     mov ah, 0
  2777 00000EF4 83F800                   cmp ax, 0
  2778 00000EF7 0F840200                 je  @@lookCode114
  2779 00000EFB EB9A                     jmp @@lookCode108
  2780                                  @@lookCode114:
  2781                                  
  2782                                  ;-96 }
  2783                                  
  2784                                  
  2785                                  ;-97 int getCodeSize() {
  2786                                  
  2787                                  @@retn:
  2788 00000EFD C3                       ret
  2789                                  ; ENDP
  2790                                  
  2791                                  getCodeSize:  ; *** PROC ***
  2792                                  
  2793                                  ;-98   if (TokeType ==ALNUME) {
  2794                                  
  2795 00000EFE A0[3B00]                 mov al, [TokeType]
  2796 00000F01 3C03                     cmp al, 3
  2797 00000F03 0F856000                 jne @@getCodeSize115
  2798                                  
  2799                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2800                                  
  2801 00000F07 68[710F]                 push getCodeSize_0
  2802 00000F0A 8D064F75                 lea  ax, [SymbolUpper]
  2803 00000F0E 50                       push ax
  2804 00000F0F E8B710                   call eqstr
  2805 00000F12 83C404                   add  sp, 4
  2806 00000F15 08C0                     or  al, al
  2807 00000F17 0F840C00                 je @@getCodeSize116
  2808 00000F1B E8E6FC                   call getTokeType
  2809 00000F1E 66B801000000             mov eax, 1
  2810 00000F24 E94900                   jmp @@retn
  2811                                  
  2812                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2813                                  
  2814                                  @@getCodeSize116:
  2815 00000F27 68[760F]                 push getCodeSize_1
  2816 00000F2A 8D064F75                 lea  ax, [SymbolUpper]
  2817 00000F2E 50                       push ax
  2818 00000F2F E89710                   call eqstr
  2819 00000F32 83C404                   add  sp, 4
  2820 00000F35 08C0                     or  al, al
  2821 00000F37 0F840C00                 je @@getCodeSize117
  2822 00000F3B E8C6FC                   call getTokeType
  2823 00000F3E 66B802000000             mov eax, 2
  2824 00000F44 E92900                   jmp @@retn
  2825                                  
  2826                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2827                                  
  2828                                  @@getCodeSize117:
  2829 00000F47 68[7B0F]                 push getCodeSize_2
  2830 00000F4A 8D064F75                 lea  ax, [SymbolUpper]
  2831 00000F4E 50                       push ax
  2832 00000F4F E87710                   call eqstr
  2833 00000F52 83C404                   add  sp, 4
  2834 00000F55 08C0                     or  al, al
  2835 00000F57 0F840C00                 je @@getCodeSize118
  2836 00000F5B E8A6FC                   call getTokeType
  2837 00000F5E 66B803000000             mov eax, 3
  2838 00000F64 E90900                   jmp @@retn
  2839                                  
  2840                                  ;-102   } return 0;
  2841                                  
  2842                                  @@getCodeSize118:
  2843                                  @@getCodeSize115:
  2844 00000F67 66B800000000             mov eax, 0
  2845 00000F6D E90000                   jmp @@retn
  2846                                  
  2847                                  ;-103 }
  2848                                  
  2849                                  
  2850                                  ;-104 int isToken(char c) {
  2851                                  
  2852                                  @@retn:
  2853 00000F70 C3                       ret
  2854                                  ; ENDP
  2855 00000F71 4259544500              getCodeSize_0 db "BYTE",0
  2856 00000F76 574F524400              getCodeSize_1 db "WORD",0
  2857 00000F7B 44574F524400            getCodeSize_2 db "DWORD",0
  2858                                  
  2859                                  isToken:  ; *** PROC ***
  2860                                  
  2861                                  ;-105   skipBlank();
  2862                                  
  2863                                  ;Function : isToken, Number of local variables: 1
  2864                                  ;   # type sign width line used address name   list of local variables
  2865                                  ;  200 var sign byte   104 NULL bp+4    c;
  2866 00000F81 C8000000                 ENTER  0,0
  2867 00000F85 E82A01                   call skipBlank
  2868                                  
  2869                                  ;-106   if (*InputPtr == c) {
  2870                                  
  2871 00000F88 8B1E[2700]               mov bx, [InputPtr]
  2872 00000F8C 8A07                     mov al, [bx]
  2873 00000F8E B400                     mov ah, 0
  2874 00000F90 3A4604                   cmp al, [bp+4]
  2875 00000F93 0F850D00                 jne @@isToken119
  2876                                  
  2877                                  ;-107     InputPtr++; return 1;} return 0;
  2878                                  
  2879 00000F97 FF06[2700]               inc  word [InputPtr]
  2880 00000F9B 66B801000000             mov eax, 1
  2881 00000FA1 E90900                   jmp @@retn
  2882                                  @@isToken119:
  2883 00000FA4 66B800000000             mov eax, 0
  2884 00000FAA E90000                   jmp @@retn
  2885                                  
  2886                                  ;-108 }
  2887                                  
  2888                                  
  2889                                  ;-109 int skipRest() {
  2890                                  
  2891 00000FAD C9                      @@retn: LEAVE
  2892 00000FAE C3                       ret
  2893                                  ; ENDP
  2894                                  
  2895                                  skipRest:  ; *** PROC ***
  2896                                  
  2897                                  ;-110   getTokeType(); if(TokeType!=0)prs("\n; ******** extra char ignored");
  2898                                  
  2899 00000FAF E852FC                   call getTokeType
  2900 00000FB2 A0[3B00]                 mov al, [TokeType]
  2901 00000FB5 3C00                     cmp al, 0
  2902 00000FB7 0F840900                 je  @@skipRest120
  2903 00000FBB 68[C50F]                 push skipRest_0
  2904 00000FBE E82408                   call prs
  2905 00000FC1 83C402                   add  sp, 2
  2906                                  
  2907                                  ;-111 }
  2908                                  
  2909                                  @@skipRest120:
  2910 00000FC4 C3                       ret
  2911                                  ; ENDP
  2912 00000FC5 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ******** extra char ignored",0
  2913 00000FCE 2A2A2A206578747261-
  2914 00000FD7 20636861722069676E-
  2915 00000FE0 6F72656400         
  2916                                  ;Back to main program: AS.C
  2917                                  
  2918                                  ;-184 #include "HELPER.C"
  2919                                  
  2920                                  ;Use include file: HELPER.C
  2921                                  
  2922                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2923                                  
  2924                                  
  2925                                  getLine:  ; *** PROC ***
  2926                                  
  2927                                  ;-2   InputPtr= &InputBuf;
  2928                                  
  2929 00000FE5 B86E75                   mov ax, InputBuf
  2930 00000FE8 A3[2700]                 mov word [InputPtr], ax
  2931                                  
  2932                                  ;-3   *InputPtr=0;//if last line is empty
  2933                                  
  2934 00000FEB 66B800000000             mov eax, 0
  2935 00000FF1 8B1E[2700]               mov  bx, [InputPtr]
  2936 00000FF5 8807                     mov  [bx], al
  2937                                  
  2938                                  ;-4   do {
  2939                                  
  2940                                  @@getLine121:
  2941                                  
  2942                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2943                                  
  2944 00000FF7 6A01                     push 1
  2945 00000FF9 FF36[2900]               push word [asm_fd]
  2946 00000FFD 8D06[3500]               lea  ax, [DOS_ByteRead]
  2947 00001001 50                       push ax
  2948 00001002 E85F10                   call readRL
  2949 00001005 83C406                   add  sp, 6
  2950 00001008 A3[3300]                 mov word [DOS_NoBytes], ax
  2951                                  
  2952                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  2953                                  
  2954 0000100B A1[2F00]                 mov ax, [DOS_ERR]
  2955 0000100E 08C0                     or  al, al
  2956 00001010 0F840900                 je @@getLine122
  2957 00001014 68[5C10]                 push getLine_0
  2958 00001017 E8590A                   call errorexit
  2959 0000101A 83C402                   add  sp, 2
  2960                                  
  2961                                  ;-7     if (DOS_NoBytes == 0) return;
  2962                                  
  2963                                  @@getLine122:
  2964 0000101D A1[3300]                 mov ax, [DOS_NoBytes]
  2965 00001020 83F800                   cmp ax, 0
  2966 00001023 0F850300                 jne @@getLine123
  2967 00001027 E93100                   jmp @@retn
  2968                                  
  2969                                  ;-8     *InputPtr = DOS_ByteRead;
  2970                                  
  2971                                  @@getLine123:
  2972 0000102A A0[3500]                 mov al, [DOS_ByteRead]
  2973 0000102D 8B1E[2700]               mov  bx, [InputPtr]
  2974 00001031 8807                     mov  [bx], al
  2975                                  
  2976                                  ;-9     InputPtr++;
  2977                                  
  2978 00001033 FF06[2700]               inc  word [InputPtr]
  2979                                  
  2980                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  2981                                  
  2982 00001037 A0[3500]                 mov al, byte [DOS_ByteRead]
  2983 0000103A B400                     mov ah, 0
  2984 0000103C 50                       push ax
  2985 0000103D E82B00                   call ifEOL
  2986 00001040 83C402                   add  sp, 2
  2987 00001043 3C00                     cmp al, 0
  2988 00001045 0F850200                 jne @@getLine124
  2989 00001049 EBAC                     jmp @@getLine121
  2990                                  @@getLine124:
  2991                                  
  2992                                  ;-11   InputPtr--;
  2993                                  
  2994 0000104B FF0E[2700]               dec  word [InputPtr]
  2995                                  
  2996                                  ;-12   *InputPtr=0;
  2997                                  
  2998 0000104F 66B800000000             mov eax, 0
  2999 00001055 8B1E[2700]               mov  bx, [InputPtr]
  3000 00001059 8807                     mov  [bx], al
  3001                                  
  3002                                  ;-13 }
  3003                                  
  3004                                  
  3005                                  ;-14 int ifEOL(char c) {
  3006                                  
  3007                                  @@retn:
  3008 0000105B C3                       ret
  3009                                  ; ENDP
  3010 0000105C 52656164696E672053-     getLine_0 db "Reading Source",0
  3011 00001065 6F7572636500       
  3012                                  
  3013                                  ifEOL:  ; *** PROC ***
  3014                                  
  3015                                  ;-15   if (c == 10) return 1;
  3016                                  
  3017                                  ;Function : ifEOL, Number of local variables: 1
  3018                                  ;   # type sign width line used address name   list of local variables
  3019                                  ;  200 var sign byte    14 NULL bp+4    c;
  3020 0000106B C8000000                 ENTER  0,0
  3021 0000106F 8A4604                   mov al, [bp+4]
  3022 00001072 3C0A                     cmp al, 10
  3023 00001074 0F850900                 jne @@ifEOL125
  3024 00001078 66B801000000             mov eax, 1
  3025 0000107E E92F00                   jmp @@retn
  3026                                  
  3027                                  ;-16   if (c == 13) {
  3028                                  
  3029                                  @@ifEOL125:
  3030 00001081 8A4604                   mov al, [bp+4]
  3031 00001084 3C0D                     cmp al, 13
  3032 00001086 0F851D00                 jne @@ifEOL126
  3033                                  
  3034                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3035                                  
  3036 0000108A 6A01                     push 1
  3037 0000108C FF36[2900]               push word [asm_fd]
  3038 00001090 8D06[3500]               lea  ax, [DOS_ByteRead]
  3039 00001094 50                       push ax
  3040 00001095 E8CC0F                   call readRL
  3041 00001098 83C406                   add  sp, 6
  3042 0000109B A3[3300]                 mov word [DOS_NoBytes], ax
  3043                                  
  3044                                  ;-18     return 1;}
  3045                                  
  3046 0000109E 66B801000000             mov eax, 1
  3047 000010A4 E90900                   jmp @@retn
  3048                                  
  3049                                  ;-19   return 0;
  3050                                  
  3051                                  @@ifEOL126:
  3052 000010A7 66B800000000             mov eax, 0
  3053 000010AD E90000                   jmp @@retn
  3054                                  
  3055                                  ;-20 }
  3056                                  
  3057                                  
  3058                                  ;-21 int skipBlank() {
  3059                                  
  3060 000010B0 C9                      @@retn: LEAVE
  3061 000010B1 C3                       ret
  3062                                  ; ENDP
  3063                                  
  3064                                  skipBlank:  ; *** PROC ***
  3065                                  
  3066                                  ;-22   skipblank1:
  3067                                  
  3068                                  @@skipblank1:
  3069                                  
  3070                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3071                                  
  3072 000010B2 8B1E[2700]               mov bx, [InputPtr]
  3073 000010B6 8A07                     mov al, [bx]
  3074 000010B8 B400                     mov ah, 0
  3075 000010BA 83F820                   cmp ax, 32
  3076 000010BD 0F850600                 jne @@skipBlank127
  3077 000010C1 FF06[2700]               inc  word [InputPtr]
  3078 000010C5 EBEB                     jmp @@skipblank1
  3079                                  
  3080                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3081                                  
  3082                                  @@skipBlank127:
  3083 000010C7 8B1E[2700]               mov bx, [InputPtr]
  3084 000010CB 8A07                     mov al, [bx]
  3085 000010CD B400                     mov ah, 0
  3086 000010CF 83F809                   cmp ax, 9
  3087 000010D2 0F850600                 jne @@skipBlank128
  3088 000010D6 FF06[2700]               inc  word [InputPtr]
  3089 000010DA EBD6                     jmp @@skipblank1
  3090                                  
  3091                                  ;-25 }
  3092                                  
  3093                                  @@skipBlank128:
  3094                                  
  3095                                  ;-26 int letterE(char c) {
  3096                                  
  3097 000010DC C3                       ret
  3098                                  ; ENDP
  3099                                  
  3100                                  letterE:  ; *** PROC ***
  3101                                  
  3102                                  ;-27   if (c=='_') return 1;
  3103                                  
  3104                                  ;Function : letterE, Number of local variables: 1
  3105                                  ;   # type sign width line used address name   list of local variables
  3106                                  ;  200 var sign byte    26 NULL bp+4    c;
  3107 000010DD C8000000                 ENTER  0,0
  3108 000010E1 8A4604                   mov al, [bp+4]
  3109 000010E4 3C5F                     cmp al, 95
  3110 000010E6 0F850900                 jne @@letterE129
  3111 000010EA 66B801000000             mov eax, 1
  3112 000010F0 E97E00                   jmp @@retn
  3113                                  
  3114                                  ;-28   if (c=='.') return 1;
  3115                                  
  3116                                  @@letterE129:
  3117 000010F3 8A4604                   mov al, [bp+4]
  3118 000010F6 3C2E                     cmp al, 46
  3119 000010F8 0F850900                 jne @@letterE130
  3120 000010FC 66B801000000             mov eax, 1
  3121 00001102 E96C00                   jmp @@retn
  3122                                  
  3123                                  ;-29   if (c=='?') return 1;
  3124                                  
  3125                                  @@letterE130:
  3126 00001105 8A4604                   mov al, [bp+4]
  3127 00001108 3C3F                     cmp al, 63
  3128 0000110A 0F850900                 jne @@letterE131
  3129 0000110E 66B801000000             mov eax, 1
  3130 00001114 E95A00                   jmp @@retn
  3131                                  
  3132                                  ;-30   if (c=='$') return 1;
  3133                                  
  3134                                  @@letterE131:
  3135 00001117 8A4604                   mov al, [bp+4]
  3136 0000111A 3C24                     cmp al, 36
  3137 0000111C 0F850900                 jne @@letterE132
  3138 00001120 66B801000000             mov eax, 1
  3139 00001126 E94800                   jmp @@retn
  3140                                  
  3141                                  ;-31   if (c> 'z') return 0;
  3142                                  
  3143                                  @@letterE132:
  3144 00001129 8A4604                   mov al, [bp+4]
  3145 0000112C 3C7A                     cmp al, 122
  3146 0000112E 0F8E0900                 jle @@letterE133
  3147 00001132 66B800000000             mov eax, 0
  3148 00001138 E93600                   jmp @@retn
  3149                                  
  3150                                  ;-32   if (c< '@') return 0; // at included
  3151                                  
  3152                                  @@letterE133:
  3153 0000113B 8A4604                   mov al, [bp+4]
  3154 0000113E 3C40                     cmp al, 64
  3155 00001140 0F8D0900                 jge @@letterE134
  3156 00001144 66B800000000             mov eax, 0
  3157 0000114A E92400                   jmp @@retn
  3158                                  
  3159                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3160                                  
  3161                                  @@letterE134:
  3162 0000114D 8A4604                   mov al, [bp+4]
  3163 00001150 3C5A                     cmp al, 90
  3164 00001152 0F8E1200                 jle @@letterE135
  3165 00001156 8A4604                   mov al, [bp+4]
  3166 00001159 3C61                     cmp al, 97
  3167 0000115B 0F8D0900                 jge @@letterE136
  3168 0000115F 66B800000000             mov eax, 0
  3169 00001165 E90900                   jmp @@retn
  3170                                  @@letterE136:
  3171                                  
  3172                                  ;-34   return 1;
  3173                                  
  3174                                  @@letterE135:
  3175 00001168 66B801000000             mov eax, 1
  3176 0000116E E90000                   jmp @@retn
  3177                                  
  3178                                  ;-35 }
  3179                                  
  3180                                  
  3181                                  ;-36 int alnumE(char c) {
  3182                                  
  3183 00001171 C9                      @@retn: LEAVE
  3184 00001172 C3                       ret
  3185                                  ; ENDP
  3186                                  
  3187                                  alnumE:  ; *** PROC ***
  3188                                  
  3189                                  ;-37   if (digit(c)) return 1;
  3190                                  
  3191                                  ;Function : alnumE, Number of local variables: 1
  3192                                  ;   # type sign width line used address name   list of local variables
  3193                                  ;  200 var sign byte    36 NULL bp+4    c;
  3194 00001173 C8000000                 ENTER  0,0
  3195 00001177 8A4604                   mov al, byte [bp+4]
  3196 0000117A B400                     mov ah, 0
  3197 0000117C 50                       push ax
  3198 0000117D E8160E                   call digit
  3199 00001180 83C402                   add  sp, 2
  3200 00001183 08C0                     or  al, al
  3201 00001185 0F840900                 je @@alnumE137
  3202 00001189 66B801000000             mov eax, 1
  3203 0000118F E92400                   jmp @@retn
  3204                                  
  3205                                  ;-38   if (letterE(c)) return 1;
  3206                                  
  3207                                  @@alnumE137:
  3208 00001192 8A4604                   mov al, byte [bp+4]
  3209 00001195 B400                     mov ah, 0
  3210 00001197 50                       push ax
  3211 00001198 E842FF                   call letterE
  3212 0000119B 83C402                   add  sp, 2
  3213 0000119E 08C0                     or  al, al
  3214 000011A0 0F840900                 je @@alnumE138
  3215 000011A4 66B801000000             mov eax, 1
  3216 000011AA E90900                   jmp @@retn
  3217                                  
  3218                                  ;-39   return 0;
  3219                                  
  3220                                  @@alnumE138:
  3221 000011AD 66B800000000             mov eax, 0
  3222 000011B3 E90000                   jmp @@retn
  3223                                  
  3224                                  ;-40 }
  3225                                  
  3226                                  
  3227                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3228                                  
  3229 000011B6 C9                      @@retn: LEAVE
  3230 000011B7 C3                       ret
  3231                                  ; ENDP
  3232                                  
  3233                                  getDigit:  ; *** PROC ***
  3234                                  
  3235                                  ;-42   unsigned int CastInt;
  3236                                  
  3237                                  
  3238                                  ;-43   SymbolInt=0;
  3239                                  
  3240                                  ;Function : getDigit, Number of local variables: 2
  3241                                  ;   # type sign width line used address name   list of local variables
  3242                                  ;  200 var unsg byte    41 NULL bp+4    c
  3243                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3244 000011B8 C8020000                 ENTER  2,0
  3245 000011BC 66B800000000             mov eax, 0
  3246 000011C2 A3[2500]                 mov word [SymbolInt], ax
  3247                                  
  3248                                  ;-44   do {
  3249                                  
  3250                                  @@getDigit139:
  3251                                  
  3252                                  ;-45     c-='0';
  3253                                  
  3254 000011C5 806E0430                 sub  byte [bp+4], 48
  3255                                  
  3256                                  ;-46     SymbolInt=SymbolInt*10;
  3257                                  
  3258 000011C9 A1[2500]                 mov ax, [SymbolInt]
  3259 000011CC 66BB0A000000             mov ebx, 10
  3260 000011D2 66F7E3                   mul ebx
  3261 000011D5 A3[2500]                 mov word [SymbolInt], ax
  3262                                  
  3263                                  ;-47     ax=0; CastInt=c; //cast b2w
  3264                                  
  3265 000011D8 B80000                   mov  ax, 0
  3266 000011DB 8A4604                   mov al, [bp+4]
  3267 000011DE 8946FE                   mov word [bp-2], ax
  3268                                  
  3269                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3270                                  
  3271 000011E1 A1[2500]                 mov ax, [SymbolInt]
  3272 000011E4 0346FE                   add ax, [bp-2]
  3273 000011E7 A3[2500]                 mov word [SymbolInt], ax
  3274                                  
  3275                                  ;-49     InputPtr++;
  3276                                  
  3277 000011EA FF06[2700]               inc  word [InputPtr]
  3278                                  
  3279                                  ;-50     c = *InputPtr;
  3280                                  
  3281 000011EE 8B1E[2700]               mov bx, [InputPtr]
  3282 000011F2 8A07                     mov al, [bx]
  3283 000011F4 B400                     mov ah, 0
  3284 000011F6 884604                   mov byte [bp+4], al
  3285                                  
  3286                                  ;-51   } while(digit(c));
  3287                                  
  3288 000011F9 8A4604                   mov al, byte [bp+4]
  3289 000011FC B400                     mov ah, 0
  3290 000011FE 50                       push ax
  3291 000011FF E8940D                   call digit
  3292 00001202 83C402                   add  sp, 2
  3293 00001205 08C0                     or  al, al
  3294 00001207 0F840200                 je @@getDigit140
  3295 0000120B EBB8                     jmp @@getDigit139
  3296                                  @@getDigit140:
  3297                                  
  3298                                  ;-52 }
  3299                                  
  3300                                  
  3301                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3302 0000120D C9                       LEAVE
  3303 0000120E C3                       ret
  3304                                  ; ENDP
  3305                                  
  3306                                  getName:  ; *** PROC ***
  3307                                  
  3308                                  ;-54   char *p;
  3309                                  
  3310                                  
  3311                                  ;-55   p = &Symbol;
  3312                                  
  3313                                  ;Function : getName, Number of local variables: 2
  3314                                  ;   # type sign width line used address name   list of local variables
  3315                                  ;  200 var unsg byte    53 NULL bp+4    c
  3316                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3317 0000120F C8020000                 ENTER  2,0
  3318 00001213 B83075                   mov ax, Symbol
  3319 00001216 8946FE                   mov word [bp-2], ax
  3320                                  
  3321                                  ;-56   *p = c;
  3322                                  
  3323 00001219 8A4604                   mov al, [bp+4]
  3324 0000121C 8B5EFE                   mov  bx, [bp-2]
  3325 0000121F 8807                     mov  [bx], al
  3326                                  
  3327                                  ;-57   p++;
  3328                                  
  3329 00001221 FF46FE                   inc  word [bp-2]
  3330                                  
  3331                                  ;-58   while (alnumE(c)) {
  3332                                  
  3333                                  @@getName141:
  3334 00001224 8A4604                   mov al, byte [bp+4]
  3335 00001227 B400                     mov ah, 0
  3336 00001229 50                       push ax
  3337 0000122A E846FF                   call alnumE
  3338 0000122D 83C402                   add  sp, 2
  3339 00001230 08C0                     or  al, al
  3340 00001232 0F841C00                 je @@getName142
  3341                                  
  3342                                  ;-59     InputPtr++;
  3343                                  
  3344 00001236 FF06[2700]               inc  word [InputPtr]
  3345                                  
  3346                                  ;-60     c = *InputPtr;
  3347                                  
  3348 0000123A 8B1E[2700]               mov bx, [InputPtr]
  3349 0000123E 8A07                     mov al, [bx]
  3350 00001240 B400                     mov ah, 0
  3351 00001242 884604                   mov byte [bp+4], al
  3352                                  
  3353                                  ;-61     *p = c;
  3354                                  
  3355 00001245 8A4604                   mov al, [bp+4]
  3356 00001248 8B5EFE                   mov  bx, [bp-2]
  3357 0000124B 8807                     mov  [bx], al
  3358                                  
  3359                                  ;-62     p++;
  3360                                  
  3361 0000124D FF46FE                   inc  word [bp-2]
  3362                                  
  3363                                  ;-63   }
  3364                                  
  3365                                  
  3366                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3367                                  
  3368 00001250 EBD2                     jmp @@getName141
  3369                                  @@getName142:
  3370 00001252 8A4604                   mov al, [bp+4]
  3371 00001255 3C3A                     cmp al, 58
  3372 00001257 0F850C00                 jne @@getName143
  3373 0000125B 66B801000000             mov eax, 1
  3374 00001261 A2[3A00]                 mov byte [isLabel], al
  3375 00001264 E90900                   jmp @@getName144
  3376                                  @@getName143:
  3377 00001267 66B800000000             mov eax, 0
  3378 0000126D A2[3A00]                 mov byte [isLabel], al
  3379                                  
  3380                                  ;-65   p--;
  3381                                  
  3382                                  @@getName144:
  3383 00001270 FF4EFE                   dec  word [bp-2]
  3384                                  
  3385                                  ;-66   *p = 0;
  3386                                  
  3387 00001273 66B800000000             mov eax, 0
  3388 00001279 8B5EFE                   mov  bx, [bp-2]
  3389 0000127C 8807                     mov  [bx], al
  3390                                  
  3391                                  ;-67   strcpy(SymbolUpper, Symbol);
  3392                                  
  3393 0000127E 8D063075                 lea  ax, [Symbol]
  3394 00001282 50                       push ax
  3395 00001283 8D064F75                 lea  ax, [SymbolUpper]
  3396 00001287 50                       push ax
  3397 00001288 E8D20C                   call strcpy
  3398 0000128B 83C404                   add  sp, 4
  3399                                  
  3400                                  ;-68   toupper(SymbolUpper);
  3401                                  
  3402 0000128E 8D064F75                 lea  ax, [SymbolUpper]
  3403 00001292 50                       push ax
  3404 00001293 E8590C                   call toupper
  3405 00001296 83C402                   add  sp, 2
  3406                                  
  3407                                  ;-69 }
  3408                                  
  3409                                  
  3410                                  ;-70 int testReg() {
  3411 00001299 C9                       LEAVE
  3412 0000129A C3                       ret
  3413                                  ; ENDP
  3414                                  
  3415                                  testReg:  ; *** PROC ***
  3416                                  
  3417                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3418                                  
  3419                                  
  3420                                  ;-72   RegType=0;
  3421                                  
  3422 0000129B 66B800000000             mov eax, 0
  3423 000012A1 A2[3E00]                 mov byte [RegType], al
  3424                                  
  3425                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3426                                  
  3427 000012A4 8D063075                 lea  ax, [Symbol]
  3428 000012A8 50                       push ax
  3429 000012A9 E8860C                   call strlen
  3430 000012AC 83C402                   add  sp, 2
  3431 000012AF 3C02                     cmp al, 2
  3432 000012B1 0F8D0900                 jge @@testReg145
  3433 000012B5 66B800000000             mov eax, 0
  3434 000012BB E9B603                   jmp @@retn
  3435                                  
  3436                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3437                                  
  3438                                  @@testReg145:
  3439 000012BE 8D063075                 lea  ax, [Symbol]
  3440 000012C2 50                       push ax
  3441 000012C3 E86C0C                   call strlen
  3442 000012C6 83C402                   add  sp, 2
  3443 000012C9 3C03                     cmp al, 3
  3444 000012CB 0F8E0900                 jle @@testReg146
  3445 000012CF 66B800000000             mov eax, 0
  3446 000012D5 E99C03                   jmp @@retn
  3447                                  
  3448                                  ;-75   RegType=BYTE;
  3449                                  
  3450                                  @@testReg146:
  3451 000012D8 66B801000000             mov eax, 1
  3452 000012DE A2[3E00]                 mov byte [RegType], al
  3453                                  
  3454                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3455                                  
  3456 000012E1 68[7516]                 push testReg_0
  3457 000012E4 8D064F75                 lea  ax, [SymbolUpper]
  3458 000012E8 50                       push ax
  3459 000012E9 E8DD0C                   call eqstr
  3460 000012EC 83C404                   add  sp, 4
  3461 000012EF 08C0                     or  al, al
  3462 000012F1 0F840900                 je @@testReg147
  3463 000012F5 66B800000000             mov eax, 0
  3464 000012FB E97603                   jmp @@retn
  3465                                  
  3466                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3467                                  
  3468                                  @@testReg147:
  3469 000012FE 68[7816]                 push testReg_1
  3470 00001301 8D064F75                 lea  ax, [SymbolUpper]
  3471 00001305 50                       push ax
  3472 00001306 E8C00C                   call eqstr
  3473 00001309 83C404                   add  sp, 4
  3474 0000130C 08C0                     or  al, al
  3475 0000130E 0F840900                 je @@testReg148
  3476 00001312 66B801000000             mov eax, 1
  3477 00001318 E95903                   jmp @@retn
  3478                                  
  3479                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3480                                  
  3481                                  @@testReg148:
  3482 0000131B 68[7B16]                 push testReg_2
  3483 0000131E 8D064F75                 lea  ax, [SymbolUpper]
  3484 00001322 50                       push ax
  3485 00001323 E8A30C                   call eqstr
  3486 00001326 83C404                   add  sp, 4
  3487 00001329 08C0                     or  al, al
  3488 0000132B 0F840900                 je @@testReg149
  3489 0000132F 66B802000000             mov eax, 2
  3490 00001335 E93C03                   jmp @@retn
  3491                                  
  3492                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3493                                  
  3494                                  @@testReg149:
  3495 00001338 68[7E16]                 push testReg_3
  3496 0000133B 8D064F75                 lea  ax, [SymbolUpper]
  3497 0000133F 50                       push ax
  3498 00001340 E8860C                   call eqstr
  3499 00001343 83C404                   add  sp, 4
  3500 00001346 08C0                     or  al, al
  3501 00001348 0F840900                 je @@testReg150
  3502 0000134C 66B803000000             mov eax, 3
  3503 00001352 E91F03                   jmp @@retn
  3504                                  
  3505                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3506                                  
  3507                                  @@testReg150:
  3508 00001355 68[8116]                 push testReg_4
  3509 00001358 8D064F75                 lea  ax, [SymbolUpper]
  3510 0000135C 50                       push ax
  3511 0000135D E8690C                   call eqstr
  3512 00001360 83C404                   add  sp, 4
  3513 00001363 08C0                     or  al, al
  3514 00001365 0F840900                 je @@testReg151
  3515 00001369 66B804000000             mov eax, 4
  3516 0000136F E90203                   jmp @@retn
  3517                                  
  3518                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3519                                  
  3520                                  @@testReg151:
  3521 00001372 68[8416]                 push testReg_5
  3522 00001375 8D064F75                 lea  ax, [SymbolUpper]
  3523 00001379 50                       push ax
  3524 0000137A E84C0C                   call eqstr
  3525 0000137D 83C404                   add  sp, 4
  3526 00001380 08C0                     or  al, al
  3527 00001382 0F840900                 je @@testReg152
  3528 00001386 66B805000000             mov eax, 5
  3529 0000138C E9E502                   jmp @@retn
  3530                                  
  3531                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3532                                  
  3533                                  @@testReg152:
  3534 0000138F 68[8716]                 push testReg_6
  3535 00001392 8D064F75                 lea  ax, [SymbolUpper]
  3536 00001396 50                       push ax
  3537 00001397 E82F0C                   call eqstr
  3538 0000139A 83C404                   add  sp, 4
  3539 0000139D 08C0                     or  al, al
  3540 0000139F 0F840900                 je @@testReg153
  3541 000013A3 66B806000000             mov eax, 6
  3542 000013A9 E9C802                   jmp @@retn
  3543                                  
  3544                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3545                                  
  3546                                  @@testReg153:
  3547 000013AC 68[8A16]                 push testReg_7
  3548 000013AF 8D064F75                 lea  ax, [SymbolUpper]
  3549 000013B3 50                       push ax
  3550 000013B4 E8120C                   call eqstr
  3551 000013B7 83C404                   add  sp, 4
  3552 000013BA 08C0                     or  al, al
  3553 000013BC 0F840900                 je @@testReg154
  3554 000013C0 66B807000000             mov eax, 7
  3555 000013C6 E9AB02                   jmp @@retn
  3556                                  
  3557                                  ;-84   RegType=WORD;
  3558                                  
  3559                                  @@testReg154:
  3560 000013C9 66B802000000             mov eax, 2
  3561 000013CF A2[3E00]                 mov byte [RegType], al
  3562                                  
  3563                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3564                                  
  3565 000013D2 68[8D16]                 push testReg_8
  3566 000013D5 8D064F75                 lea  ax, [SymbolUpper]
  3567 000013D9 50                       push ax
  3568 000013DA E8EC0B                   call eqstr
  3569 000013DD 83C404                   add  sp, 4
  3570 000013E0 08C0                     or  al, al
  3571 000013E2 0F840900                 je @@testReg155
  3572 000013E6 66B800000000             mov eax, 0
  3573 000013EC E98502                   jmp @@retn
  3574                                  
  3575                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3576                                  
  3577                                  @@testReg155:
  3578 000013EF 68[9016]                 push testReg_9
  3579 000013F2 8D064F75                 lea  ax, [SymbolUpper]
  3580 000013F6 50                       push ax
  3581 000013F7 E8CF0B                   call eqstr
  3582 000013FA 83C404                   add  sp, 4
  3583 000013FD 08C0                     or  al, al
  3584 000013FF 0F840900                 je @@testReg156
  3585 00001403 66B801000000             mov eax, 1
  3586 00001409 E96802                   jmp @@retn
  3587                                  
  3588                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3589                                  
  3590                                  @@testReg156:
  3591 0000140C 68[9316]                 push testReg_10
  3592 0000140F 8D064F75                 lea  ax, [SymbolUpper]
  3593 00001413 50                       push ax
  3594 00001414 E8B20B                   call eqstr
  3595 00001417 83C404                   add  sp, 4
  3596 0000141A 08C0                     or  al, al
  3597 0000141C 0F840900                 je @@testReg157
  3598 00001420 66B802000000             mov eax, 2
  3599 00001426 E94B02                   jmp @@retn
  3600                                  
  3601                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3602                                  
  3603                                  @@testReg157:
  3604 00001429 68[9616]                 push testReg_11
  3605 0000142C 8D064F75                 lea  ax, [SymbolUpper]
  3606 00001430 50                       push ax
  3607 00001431 E8950B                   call eqstr
  3608 00001434 83C404                   add  sp, 4
  3609 00001437 08C0                     or  al, al
  3610 00001439 0F840900                 je @@testReg158
  3611 0000143D 66B803000000             mov eax, 3
  3612 00001443 E92E02                   jmp @@retn
  3613                                  
  3614                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3615                                  
  3616                                  @@testReg158:
  3617 00001446 68[9916]                 push testReg_12
  3618 00001449 8D064F75                 lea  ax, [SymbolUpper]
  3619 0000144D 50                       push ax
  3620 0000144E E8780B                   call eqstr
  3621 00001451 83C404                   add  sp, 4
  3622 00001454 08C0                     or  al, al
  3623 00001456 0F840900                 je @@testReg159
  3624 0000145A 66B804000000             mov eax, 4
  3625 00001460 E91102                   jmp @@retn
  3626                                  
  3627                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3628                                  
  3629                                  @@testReg159:
  3630 00001463 68[9C16]                 push testReg_13
  3631 00001466 8D064F75                 lea  ax, [SymbolUpper]
  3632 0000146A 50                       push ax
  3633 0000146B E85B0B                   call eqstr
  3634 0000146E 83C404                   add  sp, 4
  3635 00001471 08C0                     or  al, al
  3636 00001473 0F840900                 je @@testReg160
  3637 00001477 66B805000000             mov eax, 5
  3638 0000147D E9F401                   jmp @@retn
  3639                                  
  3640                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3641                                  
  3642                                  @@testReg160:
  3643 00001480 68[9F16]                 push testReg_14
  3644 00001483 8D064F75                 lea  ax, [SymbolUpper]
  3645 00001487 50                       push ax
  3646 00001488 E83E0B                   call eqstr
  3647 0000148B 83C404                   add  sp, 4
  3648 0000148E 08C0                     or  al, al
  3649 00001490 0F840900                 je @@testReg161
  3650 00001494 66B806000000             mov eax, 6
  3651 0000149A E9D701                   jmp @@retn
  3652                                  
  3653                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3654                                  
  3655                                  @@testReg161:
  3656 0000149D 68[A216]                 push testReg_15
  3657 000014A0 8D064F75                 lea  ax, [SymbolUpper]
  3658 000014A4 50                       push ax
  3659 000014A5 E8210B                   call eqstr
  3660 000014A8 83C404                   add  sp, 4
  3661 000014AB 08C0                     or  al, al
  3662 000014AD 0F840900                 je @@testReg162
  3663 000014B1 66B807000000             mov eax, 7
  3664 000014B7 E9BA01                   jmp @@retn
  3665                                  
  3666                                  ;-93   RegType=SEGREG;
  3667                                  
  3668                                  @@testReg162:
  3669 000014BA 66B804000000             mov eax, 4
  3670 000014C0 A2[3E00]                 mov byte [RegType], al
  3671                                  
  3672                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3673                                  
  3674 000014C3 68[A516]                 push testReg_16
  3675 000014C6 8D064F75                 lea  ax, [SymbolUpper]
  3676 000014CA 50                       push ax
  3677 000014CB E8FB0A                   call eqstr
  3678 000014CE 83C404                   add  sp, 4
  3679 000014D1 08C0                     or  al, al
  3680 000014D3 0F840900                 je @@testReg163
  3681 000014D7 66B800000000             mov eax, 0
  3682 000014DD E99401                   jmp @@retn
  3683                                  
  3684                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3685                                  
  3686                                  @@testReg163:
  3687 000014E0 68[A816]                 push testReg_17
  3688 000014E3 8D064F75                 lea  ax, [SymbolUpper]
  3689 000014E7 50                       push ax
  3690 000014E8 E8DE0A                   call eqstr
  3691 000014EB 83C404                   add  sp, 4
  3692 000014EE 08C0                     or  al, al
  3693 000014F0 0F840900                 je @@testReg164
  3694 000014F4 66B801000000             mov eax, 1
  3695 000014FA E97701                   jmp @@retn
  3696                                  
  3697                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3698                                  
  3699                                  @@testReg164:
  3700 000014FD 68[AB16]                 push testReg_18
  3701 00001500 8D064F75                 lea  ax, [SymbolUpper]
  3702 00001504 50                       push ax
  3703 00001505 E8C10A                   call eqstr
  3704 00001508 83C404                   add  sp, 4
  3705 0000150B 08C0                     or  al, al
  3706 0000150D 0F840900                 je @@testReg165
  3707 00001511 66B802000000             mov eax, 2
  3708 00001517 E95A01                   jmp @@retn
  3709                                  
  3710                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3711                                  
  3712                                  @@testReg165:
  3713 0000151A 68[AE16]                 push testReg_19
  3714 0000151D 8D064F75                 lea  ax, [SymbolUpper]
  3715 00001521 50                       push ax
  3716 00001522 E8A40A                   call eqstr
  3717 00001525 83C404                   add  sp, 4
  3718 00001528 08C0                     or  al, al
  3719 0000152A 0F840900                 je @@testReg166
  3720 0000152E 66B803000000             mov eax, 3
  3721 00001534 E93D01                   jmp @@retn
  3722                                  
  3723                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3724                                  
  3725                                  @@testReg166:
  3726 00001537 68[B116]                 push testReg_20
  3727 0000153A 8D064F75                 lea  ax, [SymbolUpper]
  3728 0000153E 50                       push ax
  3729 0000153F E8870A                   call eqstr
  3730 00001542 83C404                   add  sp, 4
  3731 00001545 08C0                     or  al, al
  3732 00001547 0F840900                 je @@testReg167
  3733 0000154B 66B804000000             mov eax, 4
  3734 00001551 E92001                   jmp @@retn
  3735                                  
  3736                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3737                                  
  3738                                  @@testReg167:
  3739 00001554 68[B416]                 push testReg_21
  3740 00001557 8D064F75                 lea  ax, [SymbolUpper]
  3741 0000155B 50                       push ax
  3742 0000155C E86A0A                   call eqstr
  3743 0000155F 83C404                   add  sp, 4
  3744 00001562 08C0                     or  al, al
  3745 00001564 0F840900                 je @@testReg168
  3746 00001568 66B805000000             mov eax, 5
  3747 0000156E E90301                   jmp @@retn
  3748                                  
  3749                                  ;-100   RegType=DWORD;
  3750                                  
  3751                                  @@testReg168:
  3752 00001571 66B803000000             mov eax, 3
  3753 00001577 A2[3E00]                 mov byte [RegType], al
  3754                                  
  3755                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3756                                  
  3757 0000157A 68[B716]                 push testReg_22
  3758 0000157D 8D064F75                 lea  ax, [SymbolUpper]
  3759 00001581 50                       push ax
  3760 00001582 E8440A                   call eqstr
  3761 00001585 83C404                   add  sp, 4
  3762 00001588 08C0                     or  al, al
  3763 0000158A 0F840900                 je @@testReg169
  3764 0000158E 66B800000000             mov eax, 0
  3765 00001594 E9DD00                   jmp @@retn
  3766                                  
  3767                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3768                                  
  3769                                  @@testReg169:
  3770 00001597 68[BB16]                 push testReg_23
  3771 0000159A 8D064F75                 lea  ax, [SymbolUpper]
  3772 0000159E 50                       push ax
  3773 0000159F E8270A                   call eqstr
  3774 000015A2 83C404                   add  sp, 4
  3775 000015A5 08C0                     or  al, al
  3776 000015A7 0F840900                 je @@testReg170
  3777 000015AB 66B801000000             mov eax, 1
  3778 000015B1 E9C000                   jmp @@retn
  3779                                  
  3780                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3781                                  
  3782                                  @@testReg170:
  3783 000015B4 68[BF16]                 push testReg_24
  3784 000015B7 8D064F75                 lea  ax, [SymbolUpper]
  3785 000015BB 50                       push ax
  3786 000015BC E80A0A                   call eqstr
  3787 000015BF 83C404                   add  sp, 4
  3788 000015C2 08C0                     or  al, al
  3789 000015C4 0F840900                 je @@testReg171
  3790 000015C8 66B802000000             mov eax, 2
  3791 000015CE E9A300                   jmp @@retn
  3792                                  
  3793                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3794                                  
  3795                                  @@testReg171:
  3796 000015D1 68[C316]                 push testReg_25
  3797 000015D4 8D064F75                 lea  ax, [SymbolUpper]
  3798 000015D8 50                       push ax
  3799 000015D9 E8ED09                   call eqstr
  3800 000015DC 83C404                   add  sp, 4
  3801 000015DF 08C0                     or  al, al
  3802 000015E1 0F840900                 je @@testReg172
  3803 000015E5 66B803000000             mov eax, 3
  3804 000015EB E98600                   jmp @@retn
  3805                                  
  3806                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3807                                  
  3808                                  @@testReg172:
  3809 000015EE 68[C716]                 push testReg_26
  3810 000015F1 8D064F75                 lea  ax, [SymbolUpper]
  3811 000015F5 50                       push ax
  3812 000015F6 E8D009                   call eqstr
  3813 000015F9 83C404                   add  sp, 4
  3814 000015FC 08C0                     or  al, al
  3815 000015FE 0F840900                 je @@testReg173
  3816 00001602 66B804000000             mov eax, 4
  3817 00001608 E96900                   jmp @@retn
  3818                                  
  3819                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3820                                  
  3821                                  @@testReg173:
  3822 0000160B 68[CB16]                 push testReg_27
  3823 0000160E 8D064F75                 lea  ax, [SymbolUpper]
  3824 00001612 50                       push ax
  3825 00001613 E8B309                   call eqstr
  3826 00001616 83C404                   add  sp, 4
  3827 00001619 08C0                     or  al, al
  3828 0000161B 0F840900                 je @@testReg174
  3829 0000161F 66B805000000             mov eax, 5
  3830 00001625 E94C00                   jmp @@retn
  3831                                  
  3832                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3833                                  
  3834                                  @@testReg174:
  3835 00001628 68[CF16]                 push testReg_28
  3836 0000162B 8D064F75                 lea  ax, [SymbolUpper]
  3837 0000162F 50                       push ax
  3838 00001630 E89609                   call eqstr
  3839 00001633 83C404                   add  sp, 4
  3840 00001636 08C0                     or  al, al
  3841 00001638 0F840900                 je @@testReg175
  3842 0000163C 66B806000000             mov eax, 6
  3843 00001642 E92F00                   jmp @@retn
  3844                                  
  3845                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3846                                  
  3847                                  @@testReg175:
  3848 00001645 68[D316]                 push testReg_29
  3849 00001648 8D064F75                 lea  ax, [SymbolUpper]
  3850 0000164C 50                       push ax
  3851 0000164D E87909                   call eqstr
  3852 00001650 83C404                   add  sp, 4
  3853 00001653 08C0                     or  al, al
  3854 00001655 0F840900                 je @@testReg176
  3855 00001659 66B807000000             mov eax, 7
  3856 0000165F E91200                   jmp @@retn
  3857                                  
  3858                                  ;-109   RegType=0; return 0;
  3859                                  
  3860                                  @@testReg176:
  3861 00001662 66B800000000             mov eax, 0
  3862 00001668 A2[3E00]                 mov byte [RegType], al
  3863 0000166B 66B800000000             mov eax, 0
  3864 00001671 E90000                   jmp @@retn
  3865                                  
  3866                                  ;-110 }
  3867                                  
  3868                                  @@retn:
  3869 00001674 C3                       ret
  3870                                  ; ENDP
  3871 00001675 414C00                  testReg_0 db "AL",0
  3872 00001678 434C00                  testReg_1 db "CL",0
  3873 0000167B 444C00                  testReg_2 db "DL",0
  3874 0000167E 424C00                  testReg_3 db "BL",0
  3875 00001681 414800                  testReg_4 db "AH",0
  3876 00001684 434800                  testReg_5 db "CH",0
  3877 00001687 444800                  testReg_6 db "DH",0
  3878 0000168A 424800                  testReg_7 db "BH",0
  3879 0000168D 415800                  testReg_8 db "AX",0
  3880 00001690 435800                  testReg_9 db "CX",0
  3881 00001693 445800                  testReg_10 db "DX",0
  3882 00001696 425800                  testReg_11 db "BX",0
  3883 00001699 535000                  testReg_12 db "SP",0
  3884 0000169C 425000                  testReg_13 db "BP",0
  3885 0000169F 534900                  testReg_14 db "SI",0
  3886 000016A2 444900                  testReg_15 db "DI",0
  3887 000016A5 455300                  testReg_16 db "ES",0
  3888 000016A8 435300                  testReg_17 db "CS",0
  3889 000016AB 535300                  testReg_18 db "SS",0
  3890 000016AE 445300                  testReg_19 db "DS",0
  3891 000016B1 465300                  testReg_20 db "FS",0
  3892 000016B4 475300                  testReg_21 db "GS",0
  3893 000016B7 45415800                testReg_22 db "EAX",0
  3894 000016BB 45435800                testReg_23 db "ECX",0
  3895 000016BF 45445800                testReg_24 db "EDX",0
  3896 000016C3 45425800                testReg_25 db "EBX",0
  3897 000016C7 45535000                testReg_26 db "ESP",0
  3898 000016CB 45425000                testReg_27 db "EBP",0
  3899 000016CF 45534900                testReg_28 db "ESI",0
  3900 000016D3 45444900                testReg_29 db "EDI",0
  3901                                  ;Back to main program: AS.C
  3902                                  
  3903                                  ;-185 #include "OUTPUT.C"
  3904                                  
  3905                                  ;Use include file: OUTPUT.C
  3906                                  
  3907                                  ;-1 int printLine() { int i; char c;
  3908                                  
  3909                                  
  3910                                  printLine:  ; *** PROC ***
  3911                                  
  3912                                  ;-2   prs("\n"); printhex16(PCStart);
  3913                                  
  3914                                  ;Function : printLine, Number of local variables: 2
  3915                                  ;   # type sign width line used address name   list of local variables
  3916                                  ;  200 var sign word     1 NULL bp-2    i
  3917                                  ;  201 var sign byte     1 NULL bp-4    c;
  3918 000016D7 C8040000                 ENTER  4,0
  3919 000016DB 68[6C17]                 push printLine_0
  3920 000016DE E80401                   call prs
  3921 000016E1 83C402                   add  sp, 2
  3922 000016E4 FF36[3800]               push word [PCStart]
  3923 000016E8 E8EB01                   call printhex16
  3924 000016EB 83C402                   add  sp, 2
  3925                                  
  3926                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  3927                                  
  3928 000016EE A1[4900]                 mov ax, [OpPrintIndex]
  3929 000016F1 83F800                   cmp ax, 0
  3930 000016F4 0F850C00                 jne @@printLine177
  3931 000016F8 68[6F17]                 push printLine_1
  3932 000016FB E8E700                   call prs
  3933 000016FE 83C402                   add  sp, 2
  3934                                  
  3935                                  ;-4   else {
  3936                                  
  3937 00001701 E95B00                   jmp @@printLine178
  3938                                  @@printLine177:
  3939                                  
  3940                                  ;-5     prc(PrReloc);
  3941                                  
  3942 00001704 A0[4D00]                 mov al, byte [PrReloc]
  3943 00001707 B400                     mov ah, 0
  3944 00001709 50                       push ax
  3945 0000170A E87700                   call prc
  3946 0000170D 83C402                   add  sp, 2
  3947                                  
  3948                                  ;-6     i=0;
  3949                                  
  3950 00001710 66B800000000             mov eax, 0
  3951 00001716 8946FE                   mov word [bp-2], ax
  3952                                  
  3953                                  ;-7     do {
  3954                                  
  3955                                  @@printLine179:
  3956                                  
  3957                                  ;-8       c=OpPos[i];
  3958                                  
  3959 00001719 8B5EFE                   mov bx, [bp-2]
  3960 0000171C 8A87B676                 mov al, [OpPos + bx]
  3961 00001720 8846FC                   mov byte [bp-4], al
  3962                                  
  3963                                  ;-9       printhex8a(c); prc(' ');
  3964                                  
  3965 00001723 8A46FC                   mov al, byte [bp-4]
  3966 00001726 B400                     mov ah, 0
  3967 00001728 50                       push ax
  3968 00001729 E85C01                   call printhex8a
  3969 0000172C 83C402                   add  sp, 2
  3970 0000172F 6A20                     push 32
  3971 00001731 E85000                   call prc
  3972 00001734 83C402                   add  sp, 2
  3973                                  
  3974                                  ;-10       i++;
  3975                                  
  3976 00001737 FF46FE                   inc  word [bp-2]
  3977                                  
  3978                                  ;-11     } while(i < OpPrintIndex);
  3979                                  
  3980 0000173A 8B46FE                   mov ax, [bp-2]
  3981 0000173D 3B06[4900]               cmp ax, [OpPrintIndex]
  3982 00001741 0F8D0200                 jge @@printLine180
  3983 00001745 EBD2                     jmp @@printLine179
  3984                                  @@printLine180:
  3985                                  
  3986                                  ;-12     do {// fill rest with blank
  3987                                  
  3988                                  @@printLine181:
  3989                                  
  3990                                  ;-13       prs("   ");
  3991                                  
  3992 00001747 68[8017]                 push printLine_2
  3993 0000174A E89800                   call prs
  3994 0000174D 83C402                   add  sp, 2
  3995                                  
  3996                                  ;-14       i++;
  3997                                  
  3998 00001750 FF46FE                   inc  word [bp-2]
  3999                                  
  4000                                  ;-15     } while(i < OPMAXLEN);
  4001                                  
  4002 00001753 8B46FE                   mov ax, [bp-2]
  4003 00001756 83F805                   cmp ax, 5
  4004 00001759 0F8D0200                 jge @@printLine182
  4005 0000175D EBE8                     jmp @@printLine181
  4006                                  @@printLine182:
  4007                                  
  4008                                  ;-16   }
  4009                                  
  4010                                  
  4011                                  ;-17   prscomment(InputBuf);
  4012                                  
  4013                                  @@printLine178:
  4014 0000175F 8D066E75                 lea  ax, [InputBuf]
  4015 00001763 50                       push ax
  4016 00001764 E85000                   call prscomment
  4017 00001767 83C402                   add  sp, 2
  4018                                  
  4019                                  ;-18 }
  4020                                  
  4021                                  
  4022                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4023 0000176A C9                       LEAVE
  4024 0000176B C3                       ret
  4025                                  ; ENDP
  4026 0000176C 5C6E00                  printLine_0 db "\n",0
  4027 0000176F 202020202020202020-     printLine_1 db "                ",0
  4028 00001778 2020202020202000   
  4029 00001780 20202000                printLine_2 db "   ",0
  4030                                  
  4031                                  prc:  ; *** PROC ***
  4032                                  ;Function : prc, Number of local variables: 1
  4033                                  ;   # type sign width line used address name   list of local variables
  4034                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4035 00001784 C8000000                 ENTER  0,0
  4036 00001788 A0[2400]                 mov al, [LIST]
  4037 0000178B 08C0                     or  al, al
  4038 0000178D 0F841400                 je @@prc183
  4039 00001791 807E040A                cmp byte [bp+4], 10
  4040 00001795 0F850600                 jne @@prc184
  4041 00001799 B80D00                   mov  ax, 13
  4042 0000179C E81A07                   call writetty
  4043                                  
  4044                                  ;-20      al=c; writetty(); }
  4045                                  
  4046                                  @@prc184:
  4047 0000179F 8A4604                   mov  al, [bp+4]
  4048 000017A2 E81407                   call writetty
  4049                                  
  4050                                  ;-21    fputcR(c,lst_fd); }
  4051                                  
  4052                                  @@prc183:
  4053 000017A5 FF36[2B00]               push word [lst_fd]
  4054 000017A9 8A4604                   mov al, byte [bp+4]
  4055 000017AC B400                     mov ah, 0
  4056 000017AE 50                       push ax
  4057 000017AF E8C708                   call fputcR
  4058 000017B2 83C404                   add  sp, 4
  4059                                  
  4060                                  ;-22 
  4061                                  
  4062                                  
  4063                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4064 000017B5 C9                       LEAVE
  4065 000017B6 C3                       ret
  4066                                  ; ENDP
  4067                                  
  4068                                  prscomment:  ; *** PROC ***
  4069                                  
  4070                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4071                                  
  4072                                  ;Function : prscomment, Number of local variables: 2
  4073                                  ;   # type sign width line used address name   list of local variables
  4074                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4075                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4076 000017B7 C8020000                 ENTER  2,0
  4077                                  @@prscomment185:
  4078 000017BB 8B5E04                   mov bx, [bp+4]
  4079 000017BE 8A07                     mov al, [bx]
  4080 000017C0 B400                     mov ah, 0
  4081 000017C2 08C0                     or  al, al
  4082 000017C4 0F841B00                 je @@prscomment186
  4083 000017C8 8B5E04                   mov bx, [bp+4]
  4084 000017CB 8A07                     mov al, [bx]
  4085 000017CD B400                     mov ah, 0
  4086 000017CF 8846FE                   mov byte [bp-2], al
  4087 000017D2 8A46FE                   mov al, byte [bp-2]
  4088 000017D5 B400                     mov ah, 0
  4089 000017D7 50                       push ax
  4090 000017D8 E8A9FF                   call prc
  4091 000017DB 83C402                   add  sp, 2
  4092 000017DE FF4604                   inc  word [bp+4]
  4093                                  
  4094                                  ;-25 }
  4095                                  
  4096 000017E1 EBD8                     jmp @@prscomment185
  4097                                  @@prscomment186:
  4098                                  
  4099                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4100 000017E3 C9                       LEAVE
  4101 000017E4 C3                       ret
  4102                                  ; ENDP
  4103                                  
  4104                                  prs:  ; *** PROC ***
  4105                                  ;Function : prs, Number of local variables: 3
  4106                                  ;   # type sign width line used address name   list of local variables
  4107                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4108                                  ;  201 var unsg byte    26 NULL bp-2    c
  4109                                  ;  202 var sign word    26 NULL bp-4    com;
  4110 000017E5 C8040000                 ENTER  4,0
  4111 000017E9 66B800000000             mov eax, 0
  4112 000017EF 8946FC                   mov word [bp-4], ax
  4113                                  
  4114                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4115                                  
  4116                                  @@prs187:
  4117 000017F2 8B5E04                   mov bx, [bp+4]
  4118 000017F5 8A07                     mov al, [bx]
  4119 000017F7 B400                     mov ah, 0
  4120 000017F9 08C0                     or  al, al
  4121 000017FB 0F848700                 je @@prs188
  4122 000017FF 8B5E04                   mov bx, [bp+4]
  4123 00001802 8A07                     mov al, [bx]
  4124 00001804 B400                     mov ah, 0
  4125 00001806 8846FE                   mov byte [bp-2], al
  4126 00001809 8A46FE                   mov al, [bp-2]
  4127 0000180C 3C22                     cmp al, 34
  4128 0000180E 0F851E00                 jne @@prs189
  4129 00001812 8B46FC                   mov ax, [bp-4]
  4130 00001815 08C0                     or  al, al
  4131 00001817 0F840C00                 je @@prs190
  4132 0000181B 66B800000000             mov eax, 0
  4133 00001821 8946FC                   mov word [bp-4], ax
  4134 00001824 E90900                   jmp @@prs191
  4135                                  @@prs190:
  4136 00001827 66B801000000             mov eax, 1
  4137 0000182D 8946FC                   mov word [bp-4], ax
  4138                                  
  4139                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4140                                  
  4141                                  @@prs191:
  4142                                  @@prs189:
  4143 00001830 8A46FE                   mov al, [bp-2]
  4144 00001833 3C5C                     cmp al, 92
  4145 00001835 0F853B00                 jne @@prs192
  4146 00001839 8B46FC                   mov ax, [bp-4]
  4147 0000183C 83F800                   cmp ax, 0
  4148 0000183F 0F853100                 jne @@prs193
  4149 00001843 FF4604                   inc  word [bp+4]
  4150 00001846 8B5E04                   mov bx, [bp+4]
  4151 00001849 8A07                     mov al, [bx]
  4152 0000184B B400                     mov ah, 0
  4153 0000184D 8846FE                   mov byte [bp-2], al
  4154                                  
  4155                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4156                                  
  4157 00001850 8A46FE                   mov al, [bp-2]
  4158 00001853 3C6E                     cmp al, 110
  4159 00001855 0F850900                 jne @@prs194
  4160 00001859 66B80A000000             mov eax, 10
  4161 0000185F 8846FE                   mov byte [bp-2], al
  4162                                  @@prs194:
  4163 00001862 8A46FE                   mov al, [bp-2]
  4164 00001865 3C74                     cmp al, 116
  4165 00001867 0F850900                 jne @@prs195
  4166 0000186B 66B809000000             mov eax, 9
  4167 00001871 8846FE                   mov byte [bp-2], al
  4168                                  @@prs195:
  4169                                  @@prs193:
  4170                                  @@prs192:
  4171 00001874 8A46FE                   mov al, byte [bp-2]
  4172 00001877 B400                     mov ah, 0
  4173 00001879 50                       push ax
  4174 0000187A E807FF                   call prc
  4175 0000187D 83C402                   add  sp, 2
  4176 00001880 FF4604                   inc  word [bp+4]
  4177                                  
  4178                                  ;-30 }
  4179                                  
  4180 00001883 E96CFF                   jmp @@prs187
  4181                                  @@prs188:
  4182                                  
  4183                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4184 00001886 C9                       LEAVE
  4185 00001887 C3                       ret
  4186                                  ; ENDP
  4187                                  
  4188                                  printhex8a:  ; *** PROC ***
  4189                                  
  4190                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4191                                  
  4192                                  ;Function : printhex8a, Number of local variables: 2
  4193                                  ;   # type sign width line used address name   list of local variables
  4194                                  ;  200 var unsg word    31 NULL bp+4    c
  4195                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4196 00001888 C8020000                 ENTER  2,0
  4197 0000188C 8B4604                   mov ax, [bp+4]
  4198 0000188F C1E804                   shr ax, 4
  4199 00001892 8946FE                   mov word [bp-2], ax
  4200 00001895 8346FE30                 add  word [bp-2], 48
  4201 00001899 8B46FE                   mov ax, [bp-2]
  4202 0000189C 83F839                   cmp ax, 57
  4203 0000189F 0F8E0400                 jle @@printhex8a196
  4204 000018A3 8346FE07                 add  word [bp-2], 7
  4205                                  @@printhex8a196:
  4206 000018A7 FF76FE                   push word [bp-2]
  4207 000018AA E8D7FE                   call prc
  4208 000018AD 83C402                   add  sp, 2
  4209                                  
  4210                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4211                                  
  4212 000018B0 8B4604                   mov ax, [bp+4]
  4213 000018B3 83E00F                   and ax, 15
  4214 000018B6 8946FE                   mov word [bp-2], ax
  4215 000018B9 8346FE30                 add  word [bp-2], 48
  4216 000018BD 8B46FE                   mov ax, [bp-2]
  4217 000018C0 83F839                   cmp ax, 57
  4218 000018C3 0F8E0400                 jle @@printhex8a197
  4219 000018C7 8346FE07                 add  word [bp-2], 7
  4220                                  @@printhex8a197:
  4221 000018CB FF76FE                   push word [bp-2]
  4222 000018CE E8B3FE                   call prc
  4223 000018D1 83C402                   add  sp, 2
  4224                                  
  4225                                  ;-34 }
  4226                                  
  4227                                  
  4228                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4229 000018D4 C9                       LEAVE
  4230 000018D5 C3                       ret
  4231                                  ; ENDP
  4232                                  
  4233                                  printhex16:  ; *** PROC ***
  4234                                  
  4235                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4236                                  
  4237                                  ;Function : printhex16, Number of local variables: 2
  4238                                  ;   # type sign width line used address name   list of local variables
  4239                                  ;  200 var unsg word    35 NULL bp+4    i
  4240                                  ;  201 var unsg word    35 NULL bp-2    half;
  4241 000018D6 C8020000                 ENTER  2,0
  4242 000018DA 8B4604                   mov ax, [bp+4]
  4243 000018DD C1E808                   shr ax, 8
  4244 000018E0 8946FE                   mov word [bp-2], ax
  4245 000018E3 FF76FE                   push word [bp-2]
  4246 000018E6 E89FFF                   call printhex8a
  4247 000018E9 83C402                   add  sp, 2
  4248 000018EC 8B4604                   mov ax, [bp+4]
  4249 000018EF 25FF00                   and ax, 255
  4250 000018F2 8946FE                   mov word [bp-2], ax
  4251 000018F5 FF76FE                   push word [bp-2]
  4252 000018F8 E88DFF                   call printhex8a
  4253 000018FB 83C402                   add  sp, 2
  4254                                  
  4255                                  ;-37 }
  4256                                  
  4257                                  
  4258                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4259 000018FE C9                       LEAVE
  4260 000018FF C3                       ret
  4261                                  ; ENDP
  4262                                  
  4263                                  printIntU:  ; *** PROC ***
  4264                                  
  4265                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4266                                  
  4267                                  ;Function : printIntU, Number of local variables: 2
  4268                                  ;   # type sign width line used address name   list of local variables
  4269                                  ;  200 var unsg word    38 NULL bp+4    n
  4270                                  ;  201 var unsg word    38 NULL bp-2    e;
  4271 00001900 C8020000                 ENTER  2,0
  4272 00001904 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4273 00001908 0F821700                 jb  @@printIntU198
  4274 0000190C 8B4604                   mov ax, [bp+4]
  4275 0000190F BB0A00                   mov bx, 10
  4276 00001912 BA0000                   mov dx, 0
  4277 00001915 F7F3                     div bx
  4278 00001917 8946FE                   mov word [bp-2], ax
  4279                                  
  4280                                  ;-40     printIntU(e); }
  4281                                  
  4282 0000191A FF76FE                   push word [bp-2]
  4283 0000191D E8E0FF                   call printIntU
  4284 00001920 83C402                   add  sp, 2
  4285                                  
  4286                                  ;-41     n = n % 10; //unsigned mod
  4287                                  
  4288                                  @@printIntU198:
  4289 00001923 8B4604                   mov ax, [bp+4]
  4290 00001926 BB0A00                   mov bx, 10
  4291 00001929 BA0000                   mov dx, 0
  4292 0000192C F7F3                     div bx
  4293 0000192E 89D0                     mov ax, dx
  4294 00001930 894604                   mov word [bp+4], ax
  4295                                  
  4296                                  ;-42     n += '0'; prc(n);
  4297                                  
  4298 00001933 83460430                 add  word [bp+4], 48
  4299 00001937 FF7604                   push word [bp+4]
  4300 0000193A E847FE                   call prc
  4301 0000193D 83C402                   add  sp, 2
  4302                                  
  4303                                  ;-43 }
  4304                                  
  4305                                  
  4306                                  ;-44 
  4307                                  
  4308                                  
  4309                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4310 00001940 C9                       LEAVE
  4311 00001941 C3                       ret
  4312                                  ; ENDP
  4313                                  
  4314                                  error1:  ; *** PROC ***
  4315                                  ;Function : error1, Number of local variables: 1
  4316                                  ;   # type sign width line used address name   list of local variables
  4317                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4318 00001942 C8000000                 ENTER  0,0
  4319 00001946 66B801000000             mov eax, 1
  4320 0000194C A2[2400]                 mov byte [LIST], al
  4321 0000194F FF06[3100]               inc  word [ErrorCount]
  4322                                  
  4323                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4324                                  
  4325 00001953 68[7B19]                 push error1_0
  4326 00001956 E88CFE                   call prs
  4327 00001959 83C402                   add  sp, 2
  4328 0000195C FF7604                   push word [bp+4]
  4329 0000195F E883FE                   call prs
  4330 00001962 83C402                   add  sp, 2
  4331                                  
  4332                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4333                                  
  4334 00001965 68[9619]                 push error1_1
  4335 00001968 E87AFE                   call prs
  4336 0000196B 83C402                   add  sp, 2
  4337 0000196E 8D063075                 lea  ax, [Symbol]
  4338 00001972 50                       push ax
  4339 00001973 E86FFE                   call prs
  4340 00001976 83C402                   add  sp, 2
  4341                                  
  4342                                  ;-48 int allowederror(){error1("not allowed here"); }
  4343 00001979 C9                       LEAVE
  4344 0000197A C3                       ret
  4345                                  ; ENDP
  4346 0000197B 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4347 00001984 6E657874206C696E65-
  4348 0000198D 204552524F523A2000 
  4349 00001996 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4350 0000199F 2000               
  4351                                  
  4352                                  allowederror:  ; *** PROC ***
  4353 000019A1 68[AB19]                 push allowederror_0
  4354 000019A4 E89BFF                   call error1
  4355 000019A7 83C402                   add  sp, 2
  4356                                  
  4357                                  ;-49 int implmerror(){error1("not implemented");}
  4358                                  
  4359 000019AA C3                       ret
  4360                                  ; ENDP
  4361 000019AB 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4362 000019B4 6564206865726500   
  4363                                  
  4364                                  implmerror:  ; *** PROC ***
  4365 000019BC 68[C619]                 push implmerror_0
  4366 000019BF E880FF                   call error1
  4367 000019C2 83C402                   add  sp, 2
  4368                                  
  4369                                  ;-50 int indexerror (){error1("invalid index register");}
  4370                                  
  4371 000019C5 C3                       ret
  4372                                  ; ENDP
  4373 000019C6 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4374 000019CF 6D656E74656400     
  4375                                  
  4376                                  indexerror:  ; *** PROC ***
  4377 000019D6 68[E019]                 push indexerror_0
  4378 000019D9 E866FF                   call error1
  4379 000019DC 83C402                   add  sp, 2
  4380                                  
  4381                                  ;-51 int numbererror(){error1("number expected");}
  4382                                  
  4383 000019DF C3                       ret
  4384                                  ; ENDP
  4385 000019E0 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4386 000019E9 6E6465782072656769-
  4387 000019F2 7374657200         
  4388                                  
  4389                                  numbererror:  ; *** PROC ***
  4390 000019F7 68[011A]                 push numbererror_0
  4391 000019FA E845FF                   call error1
  4392 000019FD 83C402                   add  sp, 2
  4393                                  
  4394                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4395                                  
  4396 00001A00 C3                       ret
  4397                                  ; ENDP
  4398 00001A01 6E756D626572206578-     numbererror_0 db "number expected",0
  4399 00001A0A 70656374656400     
  4400                                  
  4401                                  regmemerror:  ; *** PROC ***
  4402 00001A11 68[1B1A]                 push regmemerror_0
  4403 00001A14 E82BFF                   call error1
  4404 00001A17 83C402                   add  sp, 2
  4405                                  
  4406                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4407                                  
  4408 00001A1A C3                       ret
  4409                                  ; ENDP
  4410 00001A1B 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4411 00001A24 73746572206F72206D-
  4412 00001A2D 656D6F727920616C6C-
  4413 00001A36 6F77656400         
  4414                                  
  4415                                  segregerror:  ; *** PROC ***
  4416 00001A3B 68[451A]                 push segregerror_0
  4417 00001A3E E801FF                   call error1
  4418 00001A41 83C402                   add  sp, 2
  4419                                  
  4420                                  ;-54 int syntaxerror(){error1("syntax");}
  4421                                  
  4422 00001A44 C3                       ret
  4423                                  ; ENDP
  4424 00001A45 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4425 00001A4E 65676973746572206E-
  4426 00001A57 6F7420616C6C6F7765-
  4427 00001A60 6400               
  4428                                  
  4429                                  syntaxerror:  ; *** PROC ***
  4430 00001A62 68[6C1A]                 push syntaxerror_0
  4431 00001A65 E8DAFE                   call error1
  4432 00001A68 83C402                   add  sp, 2
  4433                                  
  4434                                  ;-55 
  4435                                  
  4436                                  
  4437                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4438                                  
  4439 00001A6B C3                       ret
  4440                                  ; ENDP
  4441 00001A6C 73796E74617800          syntaxerror_0 db "syntax",0
  4442                                  
  4443                                  errorexit:  ; *** PROC ***
  4444                                  ;Function : errorexit, Number of local variables: 1
  4445                                  ;   # type sign width line used address name   list of local variables
  4446                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4447 00001A73 C8000000                 ENTER  0,0
  4448 00001A77 FF7604                   push word [bp+4]
  4449 00001A7A E8C5FE                   call error1
  4450 00001A7D 83C402                   add  sp, 2
  4451 00001A80 6A01                     push 1
  4452 00001A82 E80704                   call end1
  4453 00001A85 83C402                   add  sp, 2
  4454                                  
  4455                                  ;-57 int addrexit(){errorexit("illegal address");}
  4456 00001A88 C9                       LEAVE
  4457 00001A89 C3                       ret
  4458                                  ; ENDP
  4459                                  
  4460                                  addrexit:  ; *** PROC ***
  4461 00001A8A 68[941A]                 push addrexit_0
  4462 00001A8D E8E3FF                   call errorexit
  4463 00001A90 83C402                   add  sp, 2
  4464                                  
  4465                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4466                                  
  4467 00001A93 C3                       ret
  4468                                  ; ENDP
  4469 00001A94 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4470 00001A9D 64647265737300     
  4471                                  
  4472                                  internexit:  ; *** PROC ***
  4473 00001AA4 68[AE1A]                 push internexit_0
  4474 00001AA7 E8C9FF                   call errorexit
  4475 00001AAA 83C402                   add  sp, 2
  4476 00001AAD C3                       ret
  4477                                  ; ENDP
  4478 00001AAE 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4479 00001AB7 6D70696C6572206572-
  4480 00001AC0 726F7200           
  4481                                  ;Back to main program: AS.C
  4482                                  
  4483                                  ;-186 #include "MAIN.C"
  4484                                  
  4485                                  ;Use include file: MAIN.C
  4486                                  
  4487                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4488                                  
  4489                                  
  4490                                  getarg:  ; *** PROC ***
  4491                                  
  4492                                  ;-2   arglen1=*arglen;
  4493                                  
  4494                                  ;Function : getarg, Number of local variables: 3
  4495                                  ;   # type sign width line used address name   list of local variables
  4496                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4497                                  ;  201 var sign word     1 NULL bp-4    i
  4498                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4499 00001AC4 C8060000                 ENTER  6,0
  4500 00001AC8 8B1E[5600]               mov bx, [arglen]
  4501 00001ACC 8A07                     mov al, [bx]
  4502 00001ACE B400                     mov ah, 0
  4503 00001AD0 8946FE                   mov word [bp-2], ax
  4504                                  
  4505                                  ;-3   if (arglen1==0) {
  4506                                  
  4507 00001AD3 8B46FE                   mov ax, [bp-2]
  4508 00001AD6 83F800                   cmp ax, 0
  4509 00001AD9 0F851C00                 jne @@getarg199
  4510                                  
  4511                                  ;-4     cputs(Version1);
  4512                                  
  4513 00001ADD 8D06[1000]               lea  ax, [Version1]
  4514 00001AE1 50                       push ax
  4515 00001AE2 E8DC03                   call cputs
  4516 00001AE5 83C402                   add  sp, 2
  4517                                  
  4518                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4519                                  
  4520 00001AE8 68[891C]                 push getarg_0
  4521 00001AEB E8D303                   call cputs
  4522 00001AEE 83C402                   add  sp, 2
  4523                                  
  4524                                  ;-6     exitR(3);
  4525                                  
  4526 00001AF1 6A03                     push 3
  4527 00001AF3 E8A605                   call exitR
  4528 00001AF6 83C402                   add  sp, 2
  4529                                  
  4530                                  ;-7   }
  4531                                  
  4532                                  
  4533                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4534                                  
  4535                                  @@getarg199:
  4536 00001AF9 8B46FE                   mov ax, [bp-2]
  4537 00001AFC 058100                   add ax, 129
  4538 00001AFF 8946FC                   mov word [bp-4], ax
  4539 00001B02 66B800000000             mov eax, 0
  4540 00001B08 8B5EFC                   mov  bx, [bp-4]
  4541 00001B0B 8907                     mov  [bx], ax
  4542 00001B0D FF4EFE                   dec  word [bp-2]
  4543                                  
  4544                                  ;-9   toupper(argv);
  4545                                  
  4546 00001B10 FF36[5800]               push word [argv]
  4547 00001B14 E8D803                   call toupper
  4548 00001B17 83C402                   add  sp, 2
  4549                                  
  4550                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4551                                  
  4552 00001B1A FF36[5800]               push word [argv]
  4553 00001B1E 8D06ED75                 lea  ax, [namein]
  4554 00001B22 50                       push ax
  4555 00001B23 E83704                   call strcpy
  4556 00001B26 83C404                   add  sp, 4
  4557 00001B29 68[AE1C]                 push getarg_1
  4558 00001B2C 8D06ED75                 lea  ax, [namein]
  4559 00001B30 50                       push ax
  4560 00001B31 E8EA04                   call strcat1
  4561 00001B34 83C404                   add  sp, 4
  4562                                  
  4563                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4564                                  
  4565 00001B37 FF36[5800]               push word [argv]
  4566 00001B3B 8D063076                 lea  ax, [namelst]
  4567 00001B3F 50                       push ax
  4568 00001B40 E81A04                   call strcpy
  4569 00001B43 83C404                   add  sp, 4
  4570 00001B46 68[B11C]                 push getarg_2
  4571 00001B49 8D063076                 lea  ax, [namelst]
  4572 00001B4D 50                       push ax
  4573 00001B4E E8CD04                   call strcat1
  4574 00001B51 83C404                   add  sp, 4
  4575                                  
  4576                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4577                                  
  4578 00001B54 FF36[5800]               push word [argv]
  4579 00001B58 8D067376                 lea  ax, [namebin]
  4580 00001B5C 50                       push ax
  4581 00001B5D E8FD03                   call strcpy
  4582 00001B60 83C404                   add  sp, 4
  4583 00001B63 68[B61C]                 push getarg_3
  4584 00001B66 8D067376                 lea  ax, [namebin]
  4585 00001B6A 50                       push ax
  4586 00001B6B E8B004                   call strcat1
  4587 00001B6E 83C404                   add  sp, 4
  4588                                  
  4589                                  ;-13 
  4590                                  
  4591                                  
  4592                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4593                                  
  4594 00001B71 66B801000000             mov eax, 1
  4595 00001B77 A2[2400]                 mov byte [LIST], al
  4596 00001B7A 66B800000000             mov eax, 0
  4597 00001B80 A3[2F00]                 mov word [DOS_ERR], ax
  4598 00001B83 66B800000000             mov eax, 0
  4599 00001B89 A3[3600]                 mov word [PC], ax
  4600 00001B8C 66B800000000             mov eax, 0
  4601 00001B92 A3[3100]                 mov word [ErrorCount], ax
  4602                                  
  4603                                  ;-15   asm_fd=openR (namein);
  4604                                  
  4605 00001B95 8D06ED75                 lea  ax, [namein]
  4606 00001B99 50                       push ax
  4607 00001B9A E8A604                   call openR
  4608 00001B9D 83C402                   add  sp, 2
  4609 00001BA0 A3[2900]                 mov word [asm_fd], ax
  4610                                  
  4611                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4612                                  
  4613 00001BA3 A1[2F00]                 mov ax, [DOS_ERR]
  4614 00001BA6 08C0                     or  al, al
  4615 00001BA8 0F841C00                 je @@getarg200
  4616 00001BAC 68[BB1C]                 push getarg_4
  4617 00001BAF E80F03                   call cputs
  4618 00001BB2 83C402                   add  sp, 2
  4619 00001BB5 8D06ED75                 lea  ax, [namein]
  4620 00001BB9 50                       push ax
  4621 00001BBA E80403                   call cputs
  4622 00001BBD 83C402                   add  sp, 2
  4623 00001BC0 6A01                     push 1
  4624 00001BC2 E8D704                   call exitR
  4625 00001BC5 83C402                   add  sp, 2
  4626                                  
  4627                                  ;-17   lst_fd=creatR(namelst);
  4628                                  
  4629                                  @@getarg200:
  4630 00001BC8 8D063076                 lea  ax, [namelst]
  4631 00001BCC 50                       push ax
  4632 00001BCD E88204                   call creatR
  4633 00001BD0 83C402                   add  sp, 2
  4634 00001BD3 A3[2B00]                 mov word [lst_fd], ax
  4635                                  
  4636                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4637                                  
  4638 00001BD6 A1[2F00]                 mov ax, [DOS_ERR]
  4639 00001BD9 08C0                     or  al, al
  4640 00001BDB 0F841C00                 je @@getarg201
  4641 00001BDF 68[D11C]                 push getarg_5
  4642 00001BE2 E8DC02                   call cputs
  4643 00001BE5 83C402                   add  sp, 2
  4644 00001BE8 8D063076                 lea  ax, [namelst]
  4645 00001BEC 50                       push ax
  4646 00001BED E8D102                   call cputs
  4647 00001BF0 83C402                   add  sp, 2
  4648 00001BF3 6A02                     push 2
  4649 00001BF5 E8A404                   call exitR
  4650 00001BF8 83C402                   add  sp, 2
  4651                                  
  4652                                  ;-19   bin_fd=creatR(namebin);
  4653                                  
  4654                                  @@getarg201:
  4655 00001BFB 8D067376                 lea  ax, [namebin]
  4656 00001BFF 50                       push ax
  4657 00001C00 E84F04                   call creatR
  4658 00001C03 83C402                   add  sp, 2
  4659 00001C06 A3[2D00]                 mov word [bin_fd], ax
  4660                                  
  4661                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4662                                  
  4663 00001C09 A1[2F00]                 mov ax, [DOS_ERR]
  4664 00001C0C 08C0                     or  al, al
  4665 00001C0E 0F841C00                 je @@getarg202
  4666 00001C12 68[E81C]                 push getarg_6
  4667 00001C15 E8A902                   call cputs
  4668 00001C18 83C402                   add  sp, 2
  4669 00001C1B 8D067376                 lea  ax, [namebin]
  4670 00001C1F 50                       push ax
  4671 00001C20 E89E02                   call cputs
  4672 00001C23 83C402                   add  sp, 2
  4673 00001C26 6A02                     push 2
  4674 00001C28 E87104                   call exitR
  4675 00001C2B 83C402                   add  sp, 2
  4676                                  
  4677                                  ;-21   prs(";");prs(Version1);
  4678                                  
  4679                                  @@getarg202:
  4680 00001C2E 68[FE1C]                 push getarg_7
  4681 00001C31 E8B1FB                   call prs
  4682 00001C34 83C402                   add  sp, 2
  4683 00001C37 8D06[1000]               lea  ax, [Version1]
  4684 00001C3B 50                       push ax
  4685 00001C3C E8A6FB                   call prs
  4686 00001C3F 83C402                   add  sp, 2
  4687                                  
  4688                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4689                                  
  4690 00001C42 68[001D]                 push getarg_8
  4691 00001C45 E89DFB                   call prs
  4692 00001C48 83C402                   add  sp, 2
  4693 00001C4B 8D06ED75                 lea  ax, [namein]
  4694 00001C4F 50                       push ax
  4695 00001C50 E892FB                   call prs
  4696 00001C53 83C402                   add  sp, 2
  4697 00001C56 68[0B1D]                 push getarg_9
  4698 00001C59 E889FB                   call prs
  4699 00001C5C 83C402                   add  sp, 2
  4700 00001C5F 8D063076                 lea  ax, [namelst]
  4701 00001C63 50                       push ax
  4702 00001C64 E87EFB                   call prs
  4703 00001C67 83C402                   add  sp, 2
  4704                                  
  4705                                  ;-23   prs(", "); prs(namebin);
  4706                                  
  4707 00001C6A 68[161D]                 push getarg_10
  4708 00001C6D E875FB                   call prs
  4709 00001C70 83C402                   add  sp, 2
  4710 00001C73 8D067376                 lea  ax, [namebin]
  4711 00001C77 50                       push ax
  4712 00001C78 E86AFB                   call prs
  4713 00001C7B 83C402                   add  sp, 2
  4714                                  
  4715                                  ;-24   prs("\n");
  4716                                  
  4717 00001C7E 68[191D]                 push getarg_11
  4718 00001C81 E861FB                   call prs
  4719 00001C84 83C402                   add  sp, 2
  4720                                  
  4721                                  ;-25 }
  4722                                  
  4723                                  
  4724                                  ;-26 int epilog() { int i; int j; char c;
  4725 00001C87 C9                       LEAVE
  4726 00001C88 C3                       ret
  4727                                  ; ENDP
  4728 00001C89 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4729 00001C92 41532E434F4D206669-
  4730 00001C9B 6C656E616D65205B77-
  4731 00001CA4 2F6F202E535D203A20-
  4732 00001CAD 00                 
  4733 00001CAE 2E5300                  getarg_1 db ".S",0
  4734 00001CB1 2E4C535400              getarg_2 db ".LST",0
  4735 00001CB6 2E434F4D00              getarg_3 db ".COM",0
  4736 00001CBB 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4737 00001CC4 6C65206D697373696E-
  4738 00001CCD 673A2000           
  4739 00001CD1 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4740 00001CDA 206E6F742063726561-
  4741 00001CE3 74653A2000         
  4742 00001CE8 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4743 00001CF1 6E6F74206372656174-
  4744 00001CFA 653A2000           
  4745 00001CFE 3B00                    getarg_7 db ";",0
  4746 00001D00 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4747 00001D09 2000               
  4748 00001D0B 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4749 00001D14 2000               
  4750 00001D16 2C2000                  getarg_10 db ", ",0
  4751 00001D19 5C6E00                  getarg_11 db "\n",0
  4752                                  
  4753                                  epilog:  ; *** PROC ***
  4754                                  
  4755                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4756                                  
  4757                                  ;Function : epilog, Number of local variables: 3
  4758                                  ;   # type sign width line used address name   list of local variables
  4759                                  ;  200 var sign word    26 NULL bp-2    i
  4760                                  ;  201 var sign word    26 NULL bp-4    j
  4761                                  ;  202 var sign byte    26 NULL bp-6    c;
  4762 00001D1C C8060000                 ENTER  6,0
  4763 00001D20 68[451E]                 push epilog_0
  4764 00001D23 E8BFFA                   call prs
  4765 00001D26 83C402                   add  sp, 2
  4766 00001D29 FF36[3100]               push word [ErrorCount]
  4767 00001D2D E8D0FB                   call printIntU
  4768 00001D30 83C402                   add  sp, 2
  4769                                  
  4770                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4771                                  
  4772 00001D33 A1[3100]                 mov ax, [ErrorCount]
  4773 00001D36 08C0                     or  al, al
  4774 00001D38 0F840900                 je @@epilog203
  4775 00001D3C 68[551E]                 push epilog_1
  4776 00001D3F E8A3FA                   call prs
  4777 00001D42 83C402                   add  sp, 2
  4778                                  
  4779                                  ;-29   prs(", Label & Var: ");
  4780                                  
  4781                                  @@epilog203:
  4782 00001D45 68[631E]                 push epilog_2
  4783 00001D48 E89AFA                   call prs
  4784 00001D4B 83C402                   add  sp, 2
  4785                                  
  4786                                  ;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4787                                  
  4788                                  
  4789                                  ;-31   i= &LabelNames;
  4790                                  
  4791                                  
  4792                                  ;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4793                                  
  4794                                  
  4795                                  ;-33   } while (i < LabelNamePtr); prs("<< \n"); */
  4796                                  
  4797                                  
  4798                                  ;-34   if (LabelMaxIx) {
  4799                                  
  4800 00001D4E A1[5000]                 mov ax, [LabelMaxIx]
  4801 00001D51 08C0                     or  al, al
  4802 00001D53 0F846900                 je @@epilog204
  4803                                  
  4804                                  ;-35     i = 1;
  4805                                  
  4806 00001D57 66B801000000             mov eax, 1
  4807 00001D5D 8946FE                   mov word [bp-2], ax
  4808                                  
  4809                                  ;-36     LabelNamePtr= &LabelNames;
  4810                                  
  4811 00001D60 B8BB76                   mov ax, LabelNames
  4812 00001D63 A3[4E00]                 mov word [LabelNamePtr], ax
  4813                                  
  4814                                  ;-37     do {
  4815                                  
  4816                                  @@epilog205:
  4817                                  
  4818                                  ;-38       prs(LabelNamePtr); prc(' ');
  4819                                  
  4820 00001D66 FF36[4E00]               push word [LabelNamePtr]
  4821 00001D6A E878FA                   call prs
  4822 00001D6D 83C402                   add  sp, 2
  4823 00001D70 6A20                     push 32
  4824 00001D72 E80FFA                   call prc
  4825 00001D75 83C402                   add  sp, 2
  4826                                  
  4827                                  ;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4828                                  
  4829 00001D78 8B5EFE                   mov bx, [bp-2]
  4830 00001D7B D1E3                     shl bx, 1
  4831 00001D7D 8B87A37A                 mov ax, [LabelAddr + bx]
  4832 00001D81 8946FC                   mov word [bp-4], ax
  4833 00001D84 FF76FC                   push word [bp-4]
  4834 00001D87 E84CFB                   call printhex16
  4835 00001D8A 83C402                   add  sp, 2
  4836 00001D8D 68[731E]                 push epilog_3
  4837 00001D90 E852FA                   call prs
  4838 00001D93 83C402                   add  sp, 2
  4839                                  
  4840                                  ;-40       j=strlen(LabelNamePtr);//get end of actual name
  4841                                  
  4842 00001D96 FF36[4E00]               push word [LabelNamePtr]
  4843 00001D9A E89501                   call strlen
  4844 00001D9D 83C402                   add  sp, 2
  4845 00001DA0 8946FC                   mov word [bp-4], ax
  4846                                  
  4847                                  ;-41       LabelNamePtr=LabelNamePtr+j;
  4848                                  
  4849 00001DA3 A1[4E00]                 mov ax, [LabelNamePtr]
  4850 00001DA6 0346FC                   add ax, [bp-4]
  4851 00001DA9 A3[4E00]                 mov word [LabelNamePtr], ax
  4852                                  
  4853                                  ;-42       LabelNamePtr++;
  4854                                  
  4855 00001DAC FF06[4E00]               inc  word [LabelNamePtr]
  4856                                  
  4857                                  ;-43       i++;
  4858                                  
  4859 00001DB0 FF46FE                   inc  word [bp-2]
  4860                                  
  4861                                  ;-44     } while (i <= LabelMaxIx);
  4862                                  
  4863 00001DB3 8B46FE                   mov ax, [bp-2]
  4864 00001DB6 3B06[5000]               cmp ax, [LabelMaxIx]
  4865 00001DBA 0F8F0200                 jg  @@epilog206
  4866 00001DBE EBA6                     jmp @@epilog205
  4867                                  @@epilog206:
  4868                                  
  4869                                  ;-45   }
  4870                                  
  4871                                  
  4872                                  ;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4873                                  
  4874                                  @@epilog204:
  4875 00001DC0 68[771E]                 push epilog_4
  4876 00001DC3 E81FFA                   call prs
  4877 00001DC6 83C402                   add  sp, 2
  4878 00001DC9 FF36[5400]               push word [BinLen]
  4879 00001DCD E830FB                   call printIntU
  4880 00001DD0 83C402                   add  sp, 2
  4881 00001DD3 68[841E]                 push epilog_5
  4882 00001DD6 E80CFA                   call prs
  4883 00001DD9 83C402                   add  sp, 2
  4884                                  
  4885                                  ;-47   i=0;
  4886                                  
  4887 00001DDC 66B800000000             mov eax, 0
  4888 00001DE2 8946FE                   mov word [bp-2], ax
  4889                                  
  4890                                  ;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4891                                  
  4892                                  @@epilog207:
  4893 00001DE5 6A20                     push 32
  4894 00001DE7 E89AF9                   call prc
  4895 00001DEA 83C402                   add  sp, 2
  4896 00001DED 8B5EFE                   mov bx, [bp-2]
  4897 00001DF0 8A876B7B                 mov al, [FileBin + bx]
  4898 00001DF4 8946FC                   mov word [bp-4], ax
  4899 00001DF7 FF76FC                   push word [bp-4]
  4900 00001DFA E88BFA                   call printhex8a
  4901 00001DFD 83C402                   add  sp, 2
  4902 00001E00 FF46FE                   inc  word [bp-2]
  4903                                  
  4904                                  ;-49   } while (i < BinLen);
  4905                                  
  4906 00001E03 8B46FE                   mov ax, [bp-2]
  4907 00001E06 3B06[5400]               cmp ax, [BinLen]
  4908 00001E0A 0F8D0200                 jge @@epilog208
  4909 00001E0E EBD5                     jmp @@epilog207
  4910                                  @@epilog208:
  4911                                  
  4912                                  ;-50   i=0;
  4913                                  
  4914 00001E10 66B800000000             mov eax, 0
  4915 00001E16 8946FE                   mov word [bp-2], ax
  4916                                  
  4917                                  ;-51   do {
  4918                                  
  4919                                  @@epilog209:
  4920                                  
  4921                                  ;-52     c = FileBin[i];
  4922                                  
  4923 00001E19 8B5EFE                   mov bx, [bp-2]
  4924 00001E1C 8A876B7B                 mov al, [FileBin + bx]
  4925 00001E20 8846FA                   mov byte [bp-6], al
  4926                                  
  4927                                  ;-53     fputcR(c, bin_fd);
  4928                                  
  4929 00001E23 FF36[2D00]               push word [bin_fd]
  4930 00001E27 8A46FA                   mov al, byte [bp-6]
  4931 00001E2A B400                     mov ah, 0
  4932 00001E2C 50                       push ax
  4933 00001E2D E84902                   call fputcR
  4934 00001E30 83C404                   add  sp, 4
  4935                                  
  4936                                  ;-54     i++;
  4937                                  
  4938 00001E33 FF46FE                   inc  word [bp-2]
  4939                                  
  4940                                  ;-55   } while (i < BinLen);
  4941                                  
  4942 00001E36 8B46FE                   mov ax, [bp-2]
  4943 00001E39 3B06[5400]               cmp ax, [BinLen]
  4944 00001E3D 0F8D0200                 jge @@epilog210
  4945 00001E41 EBD6                     jmp @@epilog209
  4946                                  @@epilog210:
  4947                                  
  4948                                  ;-56 }
  4949                                  
  4950                                  
  4951                                  ;-57 int end1(int n) {
  4952 00001E43 C9                       LEAVE
  4953 00001E44 C3                       ret
  4954                                  ; ENDP
  4955 00001E45 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4956 00001E4E 726F72733A2000     
  4957 00001E55 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4958 00001E5E 2A2A2A2000         
  4959 00001E63 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4960 00001E6C 205661723A2000     
  4961 00001E73 2C202000                epilog_3 db ",  ",0
  4962 00001E77 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4963 00001E80 6C652000           
  4964 00001E84 2062797465733A00        epilog_5 db " bytes:",0
  4965                                  
  4966                                  end1:  ; *** PROC ***
  4967                                  
  4968                                  ;-58   fcloseR(asm_fd);
  4969                                  
  4970                                  ;Function : end1, Number of local variables: 1
  4971                                  ;   # type sign width line used address name   list of local variables
  4972                                  ;  200 var sign word    57 NULL bp+4    n;
  4973 00001E8C C8000000                 ENTER  0,0
  4974 00001E90 FF36[2900]               push word [asm_fd]
  4975 00001E94 E8F701                   call fcloseR
  4976 00001E97 83C402                   add  sp, 2
  4977                                  
  4978                                  ;-59   fcloseR(lst_fd);
  4979                                  
  4980 00001E9A FF36[2B00]               push word [lst_fd]
  4981 00001E9E E8ED01                   call fcloseR
  4982 00001EA1 83C402                   add  sp, 2
  4983                                  
  4984                                  ;-60   fcloseR(bin_fd);
  4985                                  
  4986 00001EA4 FF36[2D00]               push word [bin_fd]
  4987 00001EA8 E8E301                   call fcloseR
  4988 00001EAB 83C402                   add  sp, 2
  4989                                  
  4990                                  ;-61   exitR(n);
  4991                                  
  4992 00001EAE FF7604                   push word [bp+4]
  4993 00001EB1 E8E801                   call exitR
  4994 00001EB4 83C402                   add  sp, 2
  4995                                  
  4996                                  ;-62 }
  4997 00001EB7 C9                       LEAVE
  4998 00001EB8 C3                       ret
  4999                                  ; ENDP
  5000                                  ;Back to main program: AS.C
  5001                                   
  5002                                  ; missing functions: 
  5003                                  ; digit
  5004                                  ; strcpy
  5005                                  ; eqstr
  5006                                  ; strlen
  5007                                  ; eqstr
  5008                                  ; eqstr
  5009                                  ; eqstr
  5010                                  ; eqstr
  5011                                  ; readRL
  5012                                  ; readRL
  5013                                  ; digit
  5014                                  ; digit
  5015                                  ; strcpy
  5016                                  ; toupper
  5017                                  ; strlen
  5018                                  ; strlen
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
  5034                                  ; eqstr
  5035                                  ; eqstr
  5036                                  ; eqstr
  5037                                  ; eqstr
  5038                                  ; eqstr
  5039                                  ; eqstr
  5040                                  ; eqstr
  5041                                  ; eqstr
  5042                                  ; eqstr
  5043                                  ; eqstr
  5044                                  ; eqstr
  5045                                  ; eqstr
  5046                                  ; eqstr
  5047                                  ; eqstr
  5048                                  ; eqstr
  5049                                  ; writetty
  5050                                  ; writetty
  5051                                  ; fputcR
  5052                                  ; cputs
  5053                                  ; cputs
  5054                                  ; exitR
  5055                                  ; toupper
  5056                                  ; strcpy
  5057                                  ; strcat1
  5058                                  ; strcpy
  5059                                  ; strcat1
  5060                                  ; strcpy
  5061                                  ; strcat1
  5062                                  ; openR
  5063                                  ; cputs
  5064                                  ; cputs
  5065                                  ; exitR
  5066                                  ; creatR
  5067                                  ; cputs
  5068                                  ; cputs
  5069                                  ; exitR
  5070                                  ; creatR
  5071                                  ; cputs
  5072                                  ; cputs
  5073                                  ; exitR
  5074                                  ; strlen
  5075                                  ; fputcR
  5076                                  ; fcloseR
  5077                                  ; fcloseR
  5078                                  ; fcloseR
  5079                                  ; exitR
  5080                                  ; Number of unresolved CALLs :   77
  5081                                  ;use archive file: AR.C
  5082                                  
  5083                                  ;-187 // AR.C Archive
  5084                                  
  5085                                  ;Number of CALLs:    2 : writetty
  5086                                  
  5087                                  writetty:  ; *** PROC ***
  5088 00001EB9 B40E                     mov  ah, 14
  5089 00001EBB BB0000                   mov  bx, 0
  5090 00001EBE CD10                     int  16
  5091                                  
  5092                                  ;-188 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5093                                  
  5094 00001EC0 C3                       ret
  5095                                  ; ENDP
  5096                                  ;Number of CALLs:    8 : cputs
  5097                                  
  5098                                  cputs:  ; *** PROC ***
  5099                                  ;Function : cputs, Number of local variables: 2
  5100                                  ;   # type sign width line used address name   list of local variables
  5101                                  ;  200 ptr sign byte   188 NULL bp+4    s
  5102                                  ;  201 var sign byte   188 NULL bp-2    c;
  5103 00001EC1 C8020000                 ENTER  2,0
  5104                                  @@cputs211:
  5105 00001EC5 8B5E04                   mov bx, [bp+4]
  5106 00001EC8 8A07                     mov al, [bx]
  5107 00001ECA B400                     mov ah, 0
  5108 00001ECC 08C0                     or  al, al
  5109 00001ECE 0F841B00                 je @@cputs212
  5110 00001ED2 8B5E04                   mov bx, [bp+4]
  5111 00001ED5 8A07                     mov al, [bx]
  5112 00001ED7 B400                     mov ah, 0
  5113 00001ED9 8846FE                   mov byte [bp-2], al
  5114 00001EDC 8A46FE                   mov al, byte [bp-2]
  5115 00001EDF B400                     mov ah, 0
  5116 00001EE1 50                       push ax
  5117 00001EE2 E8C401                   call putch
  5118 00001EE5 83C402                   add  sp, 2
  5119 00001EE8 FF4604                   inc  word [bp+4]
  5120 00001EEB EBD8                     jmp @@cputs211
  5121                                  @@cputs212:
  5122                                  
  5123                                  ;-189 int mkneg(int n) { n; __asm {neg ax} }
  5124 00001EED C9                       LEAVE
  5125 00001EEE C3                       ret
  5126                                  ; ENDP
  5127                                  ;Number of CALLs:    2 : toupper
  5128                                  
  5129                                  toupper:  ; *** PROC ***
  5130                                  ;Function : toupper, Number of local variables: 1
  5131                                  ;   # type sign width line used address name   list of local variables
  5132                                  ;  200 ptr sign byte   189 NULL bp+4    s;
  5133 00001EEF C8000000                 ENTER  0,0
  5134                                  @@toupper213:
  5135 00001EF3 8B5E04                   mov bx, [bp+4]
  5136 00001EF6 8A07                     mov al, [bx]
  5137 00001EF8 B400                     mov ah, 0
  5138 00001EFA 08C0                     or  al, al
  5139 00001EFC 0F843000                 je @@toupper214
  5140 00001F00 8B5E04                   mov bx, [bp+4]
  5141 00001F03 8A07                     mov al, [bx]
  5142 00001F05 B400                     mov ah, 0
  5143 00001F07 83F861                   cmp ax, 97 ;unsigned : 1
  5144 00001F0A 0F8C1D00                 jl  @@toupper215
  5145 00001F0E 8B5E04                   mov bx, [bp+4]
  5146 00001F11 8A07                     mov al, [bx]
  5147 00001F13 B400                     mov ah, 0
  5148 00001F15 83F87A                   cmp ax, 122
  5149 00001F18 0F8F0F00                 jg  @@toupper216
  5150 00001F1C 8B5E04                   mov bx, [bp+4]
  5151 00001F1F 8A07                     mov al, [bx]
  5152 00001F21 B400                     mov ah, 0
  5153 00001F23 83E820                   sub ax, 32
  5154 00001F26 8B5E04                   mov  bx, [bp+4]
  5155 00001F29 8807                     mov  [bx], al
  5156                                  @@toupper216:
  5157                                  @@toupper215:
  5158 00001F2B FF4604                   inc  word [bp+4]
  5159 00001F2E EBC3                     jmp @@toupper213
  5160                                  @@toupper214:
  5161                                  
  5162                                  ;-190 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5163                                  
  5164                                  
  5165                                  ;-191 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5166 00001F30 C9                       LEAVE
  5167 00001F31 C3                       ret
  5168                                  ; ENDP
  5169                                  ;Number of CALLs:    4 : strlen
  5170                                  
  5171                                  strlen:  ; *** PROC ***
  5172                                  ;Function : strlen, Number of local variables: 2
  5173                                  ;   # type sign width line used address name   list of local variables
  5174                                  ;  200 ptr sign byte   191 NULL bp+4    s
  5175                                  ;  201 var sign word   191 NULL bp-2    c;
  5176 00001F32 C8020000                 ENTER  2,0
  5177 00001F36 66B800000000             mov eax, 0
  5178 00001F3C 8946FE                   mov word [bp-2], ax
  5179                                  @@strlen217:
  5180 00001F3F 8B5E04                   mov bx, [bp+4]
  5181 00001F42 8A07                     mov al, [bx]
  5182 00001F44 B400                     mov ah, 0
  5183 00001F46 83F800                   cmp ax, 0
  5184 00001F49 0F840800                 je  @@strlen218
  5185 00001F4D FF4604                   inc  word [bp+4]
  5186 00001F50 FF46FE                   inc  word [bp-2]
  5187 00001F53 EBEA                     jmp @@strlen217
  5188                                  @@strlen218:
  5189 00001F55 8B46FE                   mov ax, [bp-2]
  5190 00001F58 E90000                   jmp @@retn
  5191                                  
  5192                                  ;-192 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5193                                  
  5194 00001F5B C9                      @@retn: LEAVE
  5195 00001F5C C3                       ret
  5196                                  ; ENDP
  5197                                  ;Number of CALLs:    5 : strcpy
  5198                                  
  5199                                  strcpy:  ; *** PROC ***
  5200                                  ;Function : strcpy, Number of local variables: 2
  5201                                  ;   # type sign width line used address name   list of local variables
  5202                                  ;  200 ptr sign byte   192 NULL bp+4    s
  5203                                  ;  201 ptr sign byte   192 NULL bp+6    t;
  5204 00001F5D C8000000                 ENTER  0,0
  5205                                  @@strcpy219:
  5206 00001F61 8B5E06                   mov bx, [bp+6]
  5207 00001F64 8A07                     mov al, [bx]
  5208 00001F66 B400                     mov ah, 0
  5209 00001F68 8B5E04                   mov  bx, [bp+4]
  5210 00001F6B 8807                     mov  [bx], al
  5211 00001F6D FF4604                   inc  word [bp+4]
  5212 00001F70 FF4606                   inc  word [bp+6]
  5213                                  
  5214                                  ;-193   while (*t!=0); *s=0; return s; }
  5215                                  
  5216 00001F73 8B5E06                   mov bx, [bp+6]
  5217 00001F76 8A07                     mov al, [bx]
  5218 00001F78 B400                     mov ah, 0
  5219 00001F7A 83F800                   cmp ax, 0
  5220 00001F7D 0F840200                 je  @@strcpy220
  5221 00001F81 EBDE                     jmp @@strcpy219
  5222                                  @@strcpy220:
  5223 00001F83 66B800000000             mov eax, 0
  5224 00001F89 8B5E04                   mov  bx, [bp+4]
  5225 00001F8C 8807                     mov  [bx], al
  5226 00001F8E 8B4604                   mov ax, [bp+4]
  5227 00001F91 E90000                   jmp @@retn
  5228                                  
  5229                                  ;-194 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5230                                  
  5231 00001F94 C9                      @@retn: LEAVE
  5232 00001F95 C3                       ret
  5233                                  ; ENDP
  5234                                  ;Number of CALLs:    3 : digit
  5235                                  
  5236                                  digit:  ; *** PROC ***
  5237                                  ;Function : digit, Number of local variables: 1
  5238                                  ;   # type sign width line used address name   list of local variables
  5239                                  ;  200 var sign byte   194 NULL bp+4    c;
  5240 00001F96 C8000000                 ENTER  0,0
  5241 00001F9A 8A4604                   mov al, [bp+4]
  5242 00001F9D 3C30                     cmp al, 48
  5243 00001F9F 0F8D0900                 jge @@digit221
  5244 00001FA3 66B800000000             mov eax, 0
  5245 00001FA9 E91B00                   jmp @@retn
  5246                                  @@digit221:
  5247 00001FAC 8A4604                   mov al, [bp+4]
  5248 00001FAF 3C39                     cmp al, 57
  5249 00001FB1 0F8E0900                 jle @@digit222
  5250 00001FB5 66B800000000             mov eax, 0
  5251 00001FBB E90900                   jmp @@retn
  5252                                  @@digit222:
  5253 00001FBE 66B801000000             mov eax, 1
  5254 00001FC4 E90000                   jmp @@retn
  5255                                  
  5256                                  ;-195 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5257                                  
  5258 00001FC7 C9                      @@retn: LEAVE
  5259 00001FC8 C3                       ret
  5260                                  ; ENDP
  5261                                  ;Number of CALLs:   35 : eqstr
  5262                                  
  5263                                  eqstr:  ; *** PROC ***
  5264                                  ;Function : eqstr, Number of local variables: 2
  5265                                  ;   # type sign width line used address name   list of local variables
  5266                                  ;  200 ptr sign byte   195 NULL bp+4    p
  5267                                  ;  201 ptr sign byte   195 NULL bp+6    q;
  5268 00001FC9 C8000000                 ENTER  0,0
  5269                                  @@eqstr223:
  5270 00001FCD 8B5E04                   mov bx, [bp+4]
  5271 00001FD0 8A07                     mov al, [bx]
  5272 00001FD2 B400                     mov ah, 0
  5273 00001FD4 08C0                     or  al, al
  5274 00001FD6 0F842300                 je @@eqstr224
  5275                                  
  5276                                  ;-196     if (*p != *q) return 0; p++; q++; }
  5277                                  
  5278 00001FDA 8B5E04                   mov bx, [bp+4]
  5279 00001FDD 8A07                     mov al, [bx]
  5280 00001FDF B400                     mov ah, 0
  5281 00001FE1 8B5E06                   mov bx, [bp+6]
  5282 00001FE4 3A07                     cmp al, [bx]
  5283 00001FE6 B400                     mov ah, 0
  5284 00001FE8 0F840900                 je  @@eqstr225
  5285 00001FEC 66B800000000             mov eax, 0
  5286 00001FF2 E92700                   jmp @@retn
  5287                                  @@eqstr225:
  5288 00001FF5 FF4604                   inc  word [bp+4]
  5289 00001FF8 FF4606                   inc  word [bp+6]
  5290                                  
  5291                                  ;-197     if(*q) return 0; return 1; }
  5292                                  
  5293 00001FFB EBD0                     jmp @@eqstr223
  5294                                  @@eqstr224:
  5295 00001FFD 8B5E06                   mov bx, [bp+6]
  5296 00002000 8A07                     mov al, [bx]
  5297 00002002 B400                     mov ah, 0
  5298 00002004 08C0                     or  al, al
  5299 00002006 0F840900                 je @@eqstr226
  5300 0000200A 66B800000000             mov eax, 0
  5301 00002010 E90900                   jmp @@retn
  5302                                  @@eqstr226:
  5303 00002013 66B801000000             mov eax, 1
  5304 00002019 E90000                   jmp @@retn
  5305                                  
  5306                                  ;-198 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5307                                  
  5308 0000201C C9                      @@retn: LEAVE
  5309 0000201D C3                       ret
  5310                                  ; ENDP
  5311                                  ;Number of CALLs:    3 : strcat1
  5312                                  
  5313                                  strcat1:  ; *** PROC ***
  5314                                  ;Function : strcat1, Number of local variables: 2
  5315                                  ;   # type sign width line used address name   list of local variables
  5316                                  ;  200 ptr sign byte   198 NULL bp+4    s
  5317                                  ;  201 ptr sign byte   198 NULL bp+6    t;
  5318 0000201E C8000000                 ENTER  0,0
  5319                                  @@strcat1227:
  5320 00002022 8B5E04                   mov bx, [bp+4]
  5321 00002025 8A07                     mov al, [bx]
  5322 00002027 B400                     mov ah, 0
  5323 00002029 83F800                   cmp ax, 0
  5324 0000202C 0F840500                 je  @@strcat1228
  5325 00002030 FF4604                   inc  word [bp+4]
  5326 00002033 EBED                     jmp @@strcat1227
  5327                                  @@strcat1228:
  5328 00002035 FF7606                   push word [bp+6]
  5329 00002038 FF7604                   push word [bp+4]
  5330 0000203B E81FFF                   call strcpy
  5331 0000203E 83C404                   add  sp, 4
  5332                                  
  5333                                  ;-199 int basename(char *s) { char *p; p=0;
  5334 00002041 C9                       LEAVE
  5335 00002042 C3                       ret
  5336                                  ; ENDP
  5337                                  ;Number of CALLs:    1 : openR
  5338                                  
  5339                                  openR:  ; *** PROC ***
  5340                                  ;Function : openR, Number of local variables: 1
  5341                                  ;   # type sign width line used address name   list of local variables
  5342                                  ;  200 ptr sign byte   199 NULL bp+4    s;
  5343 00002043 C8000000                 ENTER  0,0
  5344 00002047 8B5604                   mov  dx, [bp+4]
  5345 0000204A B8023D                   mov  ax, 15618
  5346 0000204D E87200                   call DosInt
  5347                                  
  5348                                  ;-200 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5349 00002050 C9                       LEAVE
  5350 00002051 C3                       ret
  5351                                  ; ENDP
  5352                                  ;Number of CALLs:    2 : creatR
  5353                                  
  5354                                  creatR:  ; *** PROC ***
  5355                                  ;Function : creatR, Number of local variables: 1
  5356                                  ;   # type sign width line used address name   list of local variables
  5357                                  ;  200 ptr sign byte   200 NULL bp+4    s;
  5358 00002052 C8000000                 ENTER  0,0
  5359 00002056 8B5604                   mov  dx, [bp+4]
  5360 00002059 B90000                   mov  cx, 0
  5361 0000205C B8003C                   mov  ax, 15360
  5362 0000205F E86000                   call DosInt
  5363                                  
  5364                                  ;-201 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5365 00002062 C9                       LEAVE
  5366 00002063 C3                       ret
  5367                                  ; ENDP
  5368                                  ;Number of CALLs:    2 : readRL
  5369                                  
  5370                                  readRL:  ; *** PROC ***
  5371                                  ;Function : readRL, Number of local variables: 3
  5372                                  ;   # type sign width line used address name   list of local variables
  5373                                  ;  200 ptr sign byte   201 NULL bp+4    s
  5374                                  ;  201 var sign word   201 NULL bp+6    fd
  5375                                  ;  202 var sign word   201 NULL bp+8    len;
  5376 00002064 C8000000                 ENTER  0,0
  5377 00002068 8B5604                   mov  dx, [bp+4]
  5378 0000206B 8B4E08                   mov  cx, [bp+8]
  5379 0000206E 8B5E06                   mov  bx, [bp+6]
  5380 00002071 B8003F                   mov  ax, 16128
  5381 00002074 E84B00                   call DosInt
  5382                                  
  5383                                  ;-202 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5384 00002077 C9                       LEAVE
  5385 00002078 C3                       ret
  5386                                  ; ENDP
  5387                                  ;Number of CALLs:    2 : fputcR
  5388                                  
  5389                                  fputcR:  ; *** PROC ***
  5390                                  ;Function : fputcR, Number of local variables: 2
  5391                                  ;   # type sign width line used address name   list of local variables
  5392                                  ;  200 ptr sign byte   202 NULL bp+4    n
  5393                                  ;  201 var sign word   202 NULL bp+6    fd;
  5394 00002079 C8000000                 ENTER  0,0
  5395 0000207D 8D5604                  lea dx, [bp+4]
  5396                                  
  5397                                  ;-203   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5398                                  
  5399 00002080 B90100                   mov  cx, 1
  5400 00002083 8B5E06                   mov  bx, [bp+6]
  5401 00002086 B80040                   mov  ax, 16384
  5402 00002089 E83600                   call DosInt
  5403                                  
  5404                                  ;-204 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5405 0000208C C9                       LEAVE
  5406 0000208D C3                       ret
  5407                                  ; ENDP
  5408                                  ;Number of CALLs:    3 : fcloseR
  5409                                  
  5410                                  fcloseR:  ; *** PROC ***
  5411                                  ;Function : fcloseR, Number of local variables: 1
  5412                                  ;   # type sign width line used address name   list of local variables
  5413                                  ;  200 var sign word   204 NULL bp+4    fd;
  5414 0000208E C8000000                 ENTER  0,0
  5415 00002092 8B5E04                   mov  bx, [bp+4]
  5416 00002095 B8003E                   mov  ax, 15872
  5417 00002098 CD21                     int  33
  5418                                  
  5419                                  ;-205 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5420 0000209A C9                       LEAVE
  5421 0000209B C3                       ret
  5422                                  ; ENDP
  5423                                  ;Number of CALLs:    5 : exitR
  5424                                  
  5425                                  exitR:  ; *** PROC ***
  5426                                  ;Function : exitR, Number of local variables: 1
  5427                                  ;   # type sign width line used address name   list of local variables
  5428                                  ;  200 var sign byte   205 NULL bp+4    c;
  5429 0000209C C8000000                 ENTER  0,0
  5430 000020A0 B44C                     mov  ah, 76
  5431 000020A2 8A4604                   mov  al, [bp+4]
  5432 000020A5 CD21                     int  33
  5433                                  
  5434                                  ;-206 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5435 000020A7 C9                       LEAVE
  5436 000020A8 C3                       ret
  5437                                  ; ENDP
  5438                                  ;End of archive file. 
  5439                                   
  5440                                  ; missing functions: 
  5441                                  ; putch
  5442                                  ; DosInt
  5443                                  ; DosInt
  5444                                  ; DosInt
  5445                                  ; DosInt
  5446                                  ; Number of unresolved CALLs :    5
  5447                                  ;use archive file: AR.C
  5448                                  
  5449                                  ;-207 // AR.C Archive
  5450                                  
  5451                                  ;Number of CALLs:    1 : putch
  5452                                  
  5453                                  putch:  ; *** PROC ***
  5454                                  ;Function : putch, Number of local variables: 1
  5455                                  ;   # type sign width line used address name   list of local variables
  5456                                  ;  200 var sign byte   207 NULL bp+4    c;
  5457 000020A9 C8000000                 ENTER  0,0
  5458 000020AD 807E040A                cmp byte [bp+4], 10
  5459 000020B1 0F850500                 jne @@putch229
  5460 000020B5 B00D                     mov  al, 13
  5461 000020B7 E8FFFD                   call writetty
  5462                                  @@putch229:
  5463 000020BA 8A4604                   mov  al, [bp+4]
  5464 000020BD E8F9FD                   call writetty
  5465                                  
  5466                                  ;-208 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5467 000020C0 C9                       LEAVE
  5468 000020C1 C3                       ret
  5469                                  ; ENDP
  5470                                  ;Number of CALLs:    4 : DosInt
  5471                                  
  5472                                  DosInt:  ; *** PROC ***
  5473 000020C2 CD21                     int  33
  5474 000020C4 7304                     jae short @@DosInt230
  5475 000020C6 FF06[2F00]               inc  word [DOS_ERR]
  5476                                  @@DosInt230:
  5477                                  
  5478                                  ;-209 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5479                                  
  5480 000020CA C3                       ret
  5481                                  ; ENDP
  5482                                  ;End of archive file. 
  5483                                   
  5484                                  ; missing functions:  All FUNCTIONs in place
  5485 000020CB E80000                  LastFunctionByt:db 0E8h, 0, 0
  5486 000020CE 58                      pop ax
  5487 000020CF C3                      ret
  5488                                   
  5489                                  ;   # type sign width line used  address name   list of global variables
  5490                                  
  5491                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5492                                  ;    2 var sign byte     1    3        0 LIST
  5493                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5494                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5495                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5496                                  ;    6 var unsg word     5   12        0 SymbolInt
  5497                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5498                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5499                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5500                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5501                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5502                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5503                                  ;   13 var sign word    12    4        0 asm_fd
  5504                                  ;   14 var sign word    13    3        0 lst_fd
  5505                                  ;   15 var sign word    14    3        0 bin_fd
  5506                                  ;   16 var sign word    15    6        0 DOS_ERR
  5507                                  ;   17 var sign word    16    4        0 ErrorCount
  5508                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5509                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5510                                  ;   20 var unsg word    20    5        0 PC
  5511                                  ;   21 var unsg word    21    2        0 PCStart
  5512                                  ;   22 var sign byte    22    3        0 isLabel
  5513                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5514                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5515                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5516                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5517                                  ;   27 var sign byte    27   20        0 TokeType
  5518                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5519                                  ;   29 def unsg byte    29    -        0 WORD=2
  5520                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5521                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5522                                  ;   32 def unsg byte    33    -        0 IMM=1
  5523                                  ;   33 def unsg byte    34    -        0 REG=2
  5524                                  ;   34 def unsg byte    35    -        0 DIR=3
  5525                                  ;   35 def unsg byte    36    -        0 IND=4
  5526                                  ;   36 var sign byte    37   13        0 Op1
  5527                                  ;   37 var sign byte    38   12        0 CodeType
  5528                                  ;   38 var sign byte    40   17        0 RegType
  5529                                  ;   39 var sign byte    41   10        0 RegNo
  5530                                  ;   40 var sign byte    42   10        0 OpSize
  5531                                  ;   41 var sign byte    44 NULL        0 NumOprns
  5532                                  ;   42 var sign byte    45    5        0 wflag
  5533                                  ;   43 var sign byte    46 NULL        0 dflag
  5534                                  ;   44 var sign byte    48    4        0 reg
  5535                                  ;   45 var sign word    49   13        0 disp
  5536                                  ;   46 var sign word    50    2        0 imme
  5537                                  ;   47 def unsg byte    52    -        0 OPMAXLEN=5
  5538                                  ;   48 arr sign byte    53    2    30390 OpPos[5]
  5539                                  ;   49 var sign word    54    6        0 OpPrintIndex
  5540                                  ;   50 ptr sign byte    55   16        0 OpCodePtr
  5541                                  ;   51 var sign byte    56    2        0 PrReloc
  5542                                  ;   52 def unsg byte    58    -        0 LABELNAMESMAX=969
  5543                                  ;   53 arr sign byte    59    3    30395 LabelNames[1000]
  5544                                  ;   54 ptr sign byte    60   10        0 LabelNamePtr
  5545                                  ;   55 def unsg byte    61    -        0 LABELADRMAX=100
  5546                                  ;   56 arr unsg word    62    4    31395 LabelAddr[100]
  5547                                  ;   57 var sign word    63    5        0 LabelMaxIx
  5548                                  ;   58 var sign word    64    4        0 LabelIx
  5549                                  ;   59 def unsg byte    66    -        0 FILEBINMAX=1990
  5550                                  ;   60 arr sign byte    67    3    31595 FileBin[2000]
  5551                                  ;   61 var unsg word    68    5        0 BinLen
  5552                                  ;   62 ptr sign byte    70    1        0 arglen
  5553                                  ;   63 ptr sign byte    71    4        0 argv
  5554                                  ;   64 var sign byte     1    1        0 I_START
  5555                                  ;   65 arr sign byte     4 NULL        0 I_PUSHA[9]
  5556                                  ;   66 arr sign byte     5 NULL        0 I_POPA[8]
  5557                                  ;   67 arr sign byte     6 NULL        0 I_NOP[7]
  5558                                  ;   68 arr sign byte     7 NULL        0 I_CBW[7]
  5559                                  ;   69 arr sign byte     8 NULL        0 I_CWDE[8]
  5560                                  ;   70 arr sign byte     9 NULL        0 I_CWD[7]
  5561                                  ;   71 arr sign byte    10 NULL        0 I_CDQ[7]
  5562                                  ;   72 arr sign byte    11 NULL        0 I_WAIT[8]
  5563                                  ;   73 arr sign byte    12 NULL        0 I_PUSHF[9]
  5564                                  ;   74 arr sign byte    13 NULL        0 I_POPF[8]
  5565                                  ;   75 arr sign byte    14 NULL        0 I_SAHF[8]
  5566                                  ;   76 arr sign byte    15 NULL        0 I_LAHF[8]
  5567                                  ;   77 arr sign byte    16 NULL        0 I_MOVSB[9]
  5568                                  ;   78 arr sign byte    17 NULL        0 I_MOVSW[9]
  5569                                  ;   79 arr sign byte    18 NULL        0 I_CMPSB[9]
  5570                                  ;   80 arr sign byte    19 NULL        0 I_CMPSW[9]
  5571                                  ;   81 arr sign byte    20 NULL        0 I_STOSB[9]
  5572                                  ;   82 arr sign byte    21 NULL        0 I_STOSW[9]
  5573                                  ;   83 arr sign byte    22 NULL        0 I_LODSB[9]
  5574                                  ;   84 arr sign byte    23 NULL        0 I_LODSW[9]
  5575                                  ;   85 arr sign byte    24 NULL        0 I_SCASB[9]
  5576                                  ;   86 arr sign byte    25 NULL        0 I_SCASW[9]
  5577                                  ;   87 arr sign byte    26 NULL        0 I_LEAVE[9]
  5578                                  ;   88 arr sign byte    27 NULL        0 I_IRET[8]
  5579                                  ;   89 arr sign byte    28 NULL        0 I_XLAT[8]
  5580                                  ;   90 arr sign byte    29 NULL        0 I_LOCK[8]
  5581                                  ;   91 arr sign byte    30 NULL        0 I_REPNE[9]
  5582                                  ;   92 arr sign byte    31 NULL        0 I_REPNZ[9]
  5583                                  ;   93 arr sign byte    32 NULL        0 I_REPE[8]
  5584                                  ;   94 arr sign byte    33 NULL        0 I_REPZ[8]
  5585                                  ;   95 arr sign byte    34 NULL        0 I_HLT[7]
  5586                                  ;   96 arr sign byte    35 NULL        0 I_CLC[7]
  5587                                  ;   97 arr sign byte    36 NULL        0 I_STC[7]
  5588                                  ;   98 arr sign byte    37 NULL        0 I_CLI[7]
  5589                                  ;   99 arr sign byte    38 NULL        0 I_STI[7]
  5590                                  ;  100 arr sign byte    39 NULL        0 I_CLD[7]
  5591                                  ;  101 arr sign byte    40 NULL        0 I_STD[7]
  5592                                  ;  102 arr sign byte    42 NULL        0 I_INC[9]
  5593                                  ;  103 arr sign byte    43 NULL        0 I_DEC[9]
  5594                                  ;  104 arr sign byte    45 NULL        0 I_NOT[8]
  5595                                  ;  105 arr sign byte    46 NULL        0 I_NEG[8]
  5596                                  ;  106 arr sign byte    47 NULL        0 I_MUL[8]
  5597                                  ;  107 arr sign byte    48 NULL        0 I_IMUL[9]
  5598                                  ;  108 arr sign byte    49 NULL        0 I_DIV[8]
  5599                                  ;  109 arr sign byte    50 NULL        0 I_IDIV[9]
  5600                                  ;  110 arr sign byte    52 NULL        0 I_LES[7]
  5601                                  ;  111 arr sign byte    53 NULL        0 I_LDS[7]
  5602                                  ;  112 arr sign byte    54 NULL        0 I_LEA[7]
  5603                                  ;  113 arr sign byte    56 NULL        0 I_ADD[7]
  5604                                  ;  114 arr sign byte    57 NULL        0 I_OR[6]
  5605                                  ;  115 arr sign byte    58 NULL        0 I_ADC[7]
  5606                                  ;  116 arr sign byte    59 NULL        0 I_SBB[7]
  5607                                  ;  117 arr sign byte    60 NULL        0 I_AND[7]
  5608                                  ;  118 arr sign byte    61 NULL        0 I_SUB[7]
  5609                                  ;  119 arr sign byte    62 NULL        0 I_XOR[7]
  5610                                  ;  120 arr sign byte    63 NULL        0 I_CMP[7]
  5611                                  ;  121 arr sign byte    65 NULL        0 I_MOV[6]
  5612                                  ;  122 arr sign byte    66 NULL        0 I_MOVSX[9]
  5613                                  ;  123 arr sign byte    67 NULL        0 I_MOVZX[9]
  5614                                  ;  124 arr sign byte    69 NULL        0 I_JO[6]
  5615                                  ;  125 arr sign byte    70 NULL        0 I_JNO[7]
  5616                                  ;  126 arr sign byte    71 NULL        0 I_JB[6]
  5617                                  ;  127 arr sign byte    72 NULL        0 I_JC[6]
  5618                                  ;  128 arr sign byte    73 NULL        0 I_JNB[7]
  5619                                  ;  129 arr sign byte    74 NULL        0 I_JAE[7]
  5620                                  ;  130 arr sign byte    75 NULL        0 I_JNC[7]
  5621                                  ;  131 arr sign byte    76 NULL        0 I_JE[6]
  5622                                  ;  132 arr sign byte    77 NULL        0 I_JZ[6]
  5623                                  ;  133 arr sign byte    78 NULL        0 I_JNE[7]
  5624                                  ;  134 arr sign byte    79 NULL        0 I_JNZ[7]
  5625                                  ;  135 arr sign byte    80 NULL        0 I_JBE[7]
  5626                                  ;  136 arr sign byte    81 NULL        0 I_JNA[7]
  5627                                  ;  137 arr sign byte    82 NULL        0 I_JA[6]
  5628                                  ;  138 arr sign byte    83 NULL        0 I_JS[6]
  5629                                  ;  139 arr sign byte    84 NULL        0 I_JNS[7]
  5630                                  ;  140 arr sign byte    85 NULL        0 I_JP[6]
  5631                                  ;  141 arr sign byte    86 NULL        0 I_JPE[7]
  5632                                  ;  142 arr sign byte    87 NULL        0 I_JNP[7]
  5633                                  ;  143 arr sign byte    88 NULL        0 I_JPO[7]
  5634                                  ;  144 arr sign byte    89 NULL        0 I_JL[6]
  5635                                  ;  145 arr sign byte    90 NULL        0 I_JNL[7]
  5636                                  ;  146 arr sign byte    91 NULL        0 I_JGE[7]
  5637                                  ;  147 arr sign byte    92 NULL        0 I_JLE[7]
  5638                                  ;  148 arr sign byte    93 NULL        0 I_JNG[7]
  5639                                  ;  149 arr sign byte    94 NULL        0 I_JG[6]
  5640                                  ;  150 arr sign byte    96 NULL        0 I_JMP[8]
  5641                                  ;  151 arr sign byte    97 NULL        0 I_CALL[9]
  5642                                  ;  152 arr sign byte    99 NULL        0 I_RET[8]
  5643                                  ;  153 arr sign byte   100 NULL        0 I_RETF[9]
  5644                                  ;  154 arr sign byte   102 NULL        0 I_PUSH[8]
  5645                                  ;  155 arr sign byte   103 NULL        0 I_POP[7]
  5646                                  ;  156 arr sign byte   105 NULL        0 I_ROL[7]
  5647                                  ;  157 arr sign byte   106 NULL        0 I_ROR[7]
  5648                                  ;  158 arr sign byte   107 NULL        0 I_RCL[7]
  5649                                  ;  159 arr sign byte   108 NULL        0 I_RCR[7]
  5650                                  ;  160 arr sign byte   109 NULL        0 I_SHL[7]
  5651                                  ;  161 arr sign byte   110 NULL        0 I_SAL[7]
  5652                                  ;  162 arr sign byte   111 NULL        0 I_SHR[7]
  5653                                  ;  163 arr sign byte   112 NULL        0 I_SAR[7]
  5654                                  ;  164 arr sign byte   114 NULL        0 I_INT[8]
  5655                                  ;  165 arr sign byte   115 NULL        0 I_INTO[8]
  5656                                  ;  166 arr sign byte   117 NULL        0 I_IN[7]
  5657                                  ;  167 arr sign byte   118 NULL        0 I_INSB[8]
  5658                                  ;  168 arr sign byte   119 NULL        0 I_INSW[8]
  5659                                  ;  169 arr sign byte   120 NULL        0 I_INSD[8]
  5660                                  ;  170 arr sign byte   121 NULL        0 I_OUT[8]
  5661                                  ;  171 arr sign byte   122 NULL        0 I_OUTSB[8]
  5662                                  ;  172 arr sign byte   123 NULL        0 I_OUTSW[8]
  5663                                  ;  173 arr sign byte   124 NULL        0 I_OUTSD[8]
  5664                                  ;  174 arr sign byte   126 NULL        0 I_XCHG[9]
  5665                                  ;  175 arr sign byte   128 NULL        0 I_LOOPNZ[10]
  5666                                  ;  176 arr sign byte   129 NULL        0 I_LOOPNE[10]
  5667                                  ;  177 arr sign byte   130 NULL        0 I_LOOPZ[9]
  5668                                  ;  178 arr sign byte   131 NULL        0 I_LOOPE[9]
  5669                                  ;  179 arr sign byte   132 NULL        0 I_LOOP[8]
  5670                                  ;  180 arr sign byte   133 NULL        0 I_JCXZ[8]
  5671                                  ;  181 arr sign byte   134 NULL        0 I_JECXZ[9]
  5672                                  ;  182 arr sign byte   136 NULL        0 I_ENTER[9]
  5673                                  ;  183 arr sign byte   138 NULL        0 I_ORG[6]
  5674                                  ;  184 arr sign byte   139 NULL        0 I_DB[5]
  5675                                  ;  185 arr sign byte   140 NULL        0 I_DW[5]
  5676                                  ;  186 arr sign byte   141 NULL        0 I_DD[5]
  5677                                  ;  187 arr sign byte   142 NULL        0 I_RESB[7]
  5678                                  ;  188 arr sign byte   143 NULL        0 I_RESW[7]
  5679                                  ;  189 arr sign byte   144 NULL        0 I_RESD[7]
  5680                                  ;  190 var sign byte   145 NULL        0 I_END
  5681                                  
  5682                                  
  5683                                  ;   # Calls Line Width  Name   list of functions
  5684                                  
  5685                                  ;    0 NULL    1 word   main
  5686                                  ;    1 NULL    5 word   test1
  5687                                  ;    2    1   22 word   process
  5688                                  ;    3    2   73 word   LeftOpwCheck
  5689                                  ;    4    1   83 word   getLeftOp
  5690                                  ;    5    1   95 word   setwflag
  5691                                  ;    6    2  103 word   getOp1
  5692                                  ;    7    1  115 word   getIND
  5693                                  ;    8    1  130 word   getIndReg1
  5694                                  ;    9    1  139 word   getIndReg2
  5695                                  ;   10    1  150 word   gen66h
  5696                                  ;   11    8  151 word   genCode8
  5697                                  ;   12    3  155 word   genCode16
  5698                                  ;   13    7  158 word   genInstruction
  5699                                  ;   14    2  162 word   genCodeInREG
  5700                                  ;   15 NULL  165 word   genModRegRM
  5701                                  ;   16    2  167 word   writeEA
  5702                                  ;   17    1    1 word   parse
  5703                                  ;   18   12   27 word   getTokeType
  5704                                  ;   19    2   36 word   storeLabel
  5705                                  ;   20    2   43 word   searchLabel
  5706                                  ;   21    1   54 word   getVariable
  5707                                  ;   22    2   83 word   lookCode
  5708                                  ;   23    1   97 word   getCodeSize
  5709                                  ;   24    7  104 word   isToken
  5710                                  ;   25    1  109 word   skipRest
  5711                                  ;   26    1    1 word   getLine
  5712                                  ;   27    1   14 word   ifEOL
  5713                                  ;   28    3   21 word   skipBlank
  5714                                  ;   29    2   26 word   letterE
  5715                                  ;   30    1   36 word   alnumE
  5716                                  ;   31    1   41 word   getDigit
  5717                                  ;   32    1   53 word   getName
  5718                                  ;   33    1   70 word   testReg
  5719                                  ;   34    1    1 word   printLine
  5720                                  ;   35    9   19 word   prc
  5721                                  ;   36    1   23 word   prscomment
  5722                                  ;   37   24   26 word   prs
  5723                                  ;   38    4   31 word   printhex8a
  5724                                  ;   39    2   35 word   printhex16
  5725                                  ;   40    3   38 word   printIntU
  5726                                  ;   41   19   45 word   error1
  5727                                  ;   42 NULL   48 word   allowederror
  5728                                  ;   43 NULL   49 word   implmerror
  5729                                  ;   44    4   50 word   indexerror
  5730                                  ;   45    1   51 word   numbererror
  5731                                  ;   46 NULL   52 word   regmemerror
  5732                                  ;   47    1   53 word   segregerror
  5733                                  ;   48    1   54 word   syntaxerror
  5734                                  ;   49    7   56 word   errorexit
  5735                                  ;   50    1   57 word   addrexit
  5736                                  ;   51 NULL   58 word   internexit
  5737                                  ;   52    1    1 word   getarg
  5738                                  ;   53    1   26 word   epilog
  5739                                  ;   54    2   57 word   end1
  5740                                  ;   55    4  187 word   writetty
  5741                                  ;   56    8  188 word   cputs
  5742                                  ;   57    2  189 word   toupper
  5743                                  ;   58    4  191 word   strlen
  5744                                  ;   59    6  192 word   strcpy
  5745                                  ;   60    3  194 word   digit
  5746                                  ;   61   35  195 word   eqstr
  5747                                  ;   62    3  198 word   strcat1
  5748                                  ;   63    1  199 word   openR
  5749                                  ;   64    2  200 word   creatR
  5750                                  ;   65    2  201 word   readRL
  5751                                  ;   66    2  202 word   fputcR
  5752                                  ;   67    3  204 word   fcloseR
  5753                                  ;   68    5  205 word   exitR
  5754                                  ;   69    1  207 word   putch
  5755                                  ;   70    4  208 word   DosInt
  5756                                  ;   71 NULL  209 word   LastFunctionByt
  5757                                  
  5758                                  ;    #  addr name   list of CALLs
  5759                                  
  5760                                  ;    0     5 getarg
  5761                                  ;    1    12 parse
  5762                                  ;    2    18 epilog
  5763                                  ;    3    25 end1
  5764                                  ;    4  1377 getTokeType
  5765                                  ;    5  1389 getCodeSize
  5766                                  ;    6  1401 genInstruction
  5767                                  ;    7  1416 LeftOpwCheck
  5768                                  ;    8  1429 genInstruction
  5769                                  ;    9  1444 genInstruction
  5770                                  ;   10  1459 genInstruction
  5771                                  ;   11  1474 genCodeInREG
  5772                                  ;   12  1487 LeftOpwCheck
  5773                                  ;   13  1500 genInstruction
  5774                                  ;   14  1515 genCodeInREG
  5775                                  ;   15  1528 genInstruction
  5776                                  ;   16  1543 genCode16
  5777                                  ;   17  1553 genInstruction
  5778                                  ;   18  1568 error1
  5779                                  ;   19  1575 error1
  5780                                  ;   20  1595 getLeftOp
  5781                                  ;   21  1605 segregerror
  5782                                  ;   22  1617 setwflag
  5783                                  ;   23  1626 error1
  5784                                  ;   24  1633 error1
  5785                                  ;   25  1640 error1
  5786                                  ;   26  1657 getOp1
  5787                                  ;   27  1664 isToken
  5788                                  ;   28  1672 getIND
  5789                                  ;   29  1679 error1
  5790                                  ;   30  1686 error1
  5791                                  ;   31  1702 gen66h
  5792                                  ;   32  1716 testReg
  5793                                  ;   33  1724 searchLabel
  5794                                  ;   34  1736 error1
  5795                                  ;   35  1757 getTokeType
  5796                                  ;   36  1769 getOp1
  5797                                  ;   37  1776 syntaxerror
  5798                                  ;   38  1788 getIndReg2
  5799                                  ;   39  1799 getIndReg1
  5800                                  ;   40  1810 isToken
  5801                                  ;   41  1818 getTokeType
  5802                                  ;   42  1830 numbererror
  5803                                  ;   43  1842 isToken
  5804                                  ;   44  1850 isToken
  5805                                  ;   45  1858 errorexit
  5806                                  ;   46  1881 indexerror
  5807                                  ;   47  1892 indexerror
  5808                                  ;   48  1919 indexerror
  5809                                  ;   49  1930 indexerror
  5810                                  ;   50  1948 genCode8
  5811                                  ;   51  1980 genCode8
  5812                                  ;   52  1989 genCode8
  5813                                  ;   53  2022 genCode8
  5814                                  ;   54  2046 writeEA
  5815                                  ;   55  2066 writeEA
  5816                                  ;   56  2090 addrexit
  5817                                  ;   57  2099 genCode8
  5818                                  ;   58  2108 genCode8
  5819                                  ;   59  2117 genCode16
  5820                                  ;   60  2133 getLine
  5821                                  ;   61  2141 getTokeType
  5822                                  ;   62  2153 storeLabel
  5823                                  ;   63  2164 getTokeType
  5824                                  ;   64  2176 lookCode
  5825                                  ;   65  2185 process
  5826                                  ;   66  2193 getVariable
  5827                                  ;   67  2205 skipRest
  5828                                  ;   68  2214 error1
  5829                                  ;   69  2221 error1
  5830                                  ;   70  2228 printLine
  5831                                  ;   71  2252 skipBlank
  5832                                  ;   72  2262 digit
  5833                                  ;   73  2268 getDigit
  5834                                  ;   74  2277 letterE
  5835                                  ;   75  2285 getName
  5836                                  ;   76  2304 searchLabel
  5837                                  ;   77  2316 error1
  5838                                  ;   78  2323 strcpy
  5839                                  ;   79  2350 eqstr
  5840                                  ;   80  2356 strlen
  5841                                  ;   81  2377 storeLabel
  5842                                  ;   82  2388 getTokeType
  5843                                  ;   83  2400 lookCode
  5844                                  ;   84  2409 errorexit
  5845                                  ;   85  2419 errorexit
  5846                                  ;   86  2429 getTokeType
  5847                                  ;   87  2441 genCode8
  5848                                  ;   88  2450 skipBlank
  5849                                  ;   89  2460 isToken
  5850                                  ;   90  2468 genCode8
  5851                                  ;   91  2477 isToken
  5852                                  ;   92  2485 getTokeType
  5853                                  ;   93  2497 genCode16
  5854                                  ;   94  2507 isToken
  5855                                  ;   95  2515 errorexit
  5856                                  ;   96  2534 eqstr
  5857                                  ;   97  2552 eqstr
  5858                                  ;   98  2558 getTokeType
  5859                                  ;   99  2570 eqstr
  5860                                  ;  100  2576 getTokeType
  5861                                  ;  101  2588 eqstr
  5862                                  ;  102  2594 getTokeType
  5863                                  ;  103  2616 skipBlank
  5864                                  ;  104  2635 getTokeType
  5865                                  ;  105  2647 prs
  5866                                  ;  106  2659 readRL
  5867                                  ;  107  2666 errorexit
  5868                                  ;  108  2676 ifEOL
  5869                                  ;  109  2690 readRL
  5870                                  ;  110  2726 digit
  5871                                  ;  111  2732 letterE
  5872                                  ;  112  2759 digit
  5873                                  ;  113  2777 alnumE
  5874                                  ;  114  2784 strcpy
  5875                                  ;  115  2791 toupper
  5876                                  ;  116  2807 strlen
  5877                                  ;  117  2814 strlen
  5878                                  ;  118  2821 eqstr
  5879                                  ;  119  2827 eqstr
  5880                                  ;  120  2833 eqstr
  5881                                  ;  121  2839 eqstr
  5882                                  ;  122  2845 eqstr
  5883                                  ;  123  2851 eqstr
  5884                                  ;  124  2857 eqstr
  5885                                  ;  125  2863 eqstr
  5886                                  ;  126  2869 eqstr
  5887                                  ;  127  2875 eqstr
  5888                                  ;  128  2881 eqstr
  5889                                  ;  129  2887 eqstr
  5890                                  ;  130  2893 eqstr
  5891                                  ;  131  2899 eqstr
  5892                                  ;  132  2905 eqstr
  5893                                  ;  133  2911 eqstr
  5894                                  ;  134  2917 eqstr
  5895                                  ;  135  2923 eqstr
  5896                                  ;  136  2929 eqstr
  5897                                  ;  137  2935 eqstr
  5898                                  ;  138  2941 eqstr
  5899                                  ;  139  2947 eqstr
  5900                                  ;  140  2953 eqstr
  5901                                  ;  141  2959 eqstr
  5902                                  ;  142  2965 eqstr
  5903                                  ;  143  2971 eqstr
  5904                                  ;  144  2977 eqstr
  5905                                  ;  145  2983 eqstr
  5906                                  ;  146  2989 eqstr
  5907                                  ;  147  2995 eqstr
  5908                                  ;  148  3015 prs
  5909                                  ;  149  3019 printhex16
  5910                                  ;  150  3030 prs
  5911                                  ;  151  3034 prc
  5912                                  ;  152  3038 printhex8a
  5913                                  ;  153  3049 prc
  5914                                  ;  154  3053 prs
  5915                                  ;  155  3057 prscomment
  5916                                  ;  156  3074 writetty
  5917                                  ;  157  3083 writetty
  5918                                  ;  158  3092 fputcR
  5919                                  ;  159  3114 prc
  5920                                  ;  160  3130 prc
  5921                                  ;  161  3151 prc
  5922                                  ;  162  3155 prc
  5923                                  ;  163  3177 printhex8a
  5924                                  ;  164  3188 printhex8a
  5925                                  ;  165  3213 printIntU
  5926                                  ;  166  3223 prc
  5927                                  ;  167  3236 prs
  5928                                  ;  168  3240 prs
  5929                                  ;  169  3244 prs
  5930                                  ;  170  3248 prs
  5931                                  ;  171  3265 error1
  5932                                  ;  172  3283 error1
  5933                                  ;  173  3301 error1
  5934                                  ;  174  3320 error1
  5935                                  ;  175  3339 error1
  5936                                  ;  176  3358 error1
  5937                                  ;  177  3377 error1
  5938                                  ;  178  3396 error1
  5939                                  ;  179  3403 end1
  5940                                  ;  180  3417 errorexit
  5941                                  ;  181  3438 errorexit
  5942                                  ;  182  3467 cputs
  5943                                  ;  183  3473 cputs
  5944                                  ;  184  3479 exitR
  5945                                  ;  185  3485 toupper
  5946                                  ;  186  3493 strcpy
  5947                                  ;  187  3500 strcat1
  5948                                  ;  188  3508 strcpy
  5949                                  ;  189  3515 strcat1
  5950                                  ;  190  3523 strcpy
  5951                                  ;  191  3530 strcat1
  5952                                  ;  192  3538 openR
  5953                                  ;  193  3544 cputs
  5954                                  ;  194  3550 cputs
  5955                                  ;  195  3556 exitR
  5956                                  ;  196  3562 creatR
  5957                                  ;  197  3569 cputs
  5958                                  ;  198  3575 cputs
  5959                                  ;  199  3581 exitR
  5960                                  ;  200  3587 creatR
  5961                                  ;  201  3594 cputs
  5962                                  ;  202  3600 cputs
  5963                                  ;  203  3606 exitR
  5964                                  ;  204  3612 prs
  5965                                  ;  205  3616 prs
  5966                                  ;  206  3620 prs
  5967                                  ;  207  3624 prs
  5968                                  ;  208  3628 prs
  5969                                  ;  209  3632 prs
  5970                                  ;  210  3636 prs
  5971                                  ;  211  3640 prs
  5972                                  ;  212  3644 prs
  5973                                  ;  213  3661 prs
  5974                                  ;  214  3665 printIntU
  5975                                  ;  215  3675 prs
  5976                                  ;  216  3679 prs
  5977                                  ;  217  3683 prs
  5978                                  ;  218  3687 prc
  5979                                  ;  219  3691 printhex16
  5980                                  ;  220  3702 prs
  5981                                  ;  221  3706 strlen
  5982                                  ;  222  3713 prs
  5983                                  ;  223  3717 printIntU
  5984                                  ;  224  3727 prs
  5985                                  ;  225  3731 prc
  5986                                  ;  226  3735 printhex8a
  5987                                  ;  227  3746 fputcR
  5988                                  ;  228  3760 fcloseR
  5989                                  ;  229  3768 fcloseR
  5990                                  ;  230  3776 fcloseR
  5991                                  ;  231  3784 exitR
  5992                                  ;  232  3809 putch
  5993                                  ;  233  3877 strcpy
  5994                                  ;  234  3892 DosInt
  5995                                  ;  235  3908 DosInt
  5996                                  ;  236  3931 DosInt
  5997                                  ;  237  3950 DosInt
  5998                                  ;  238  3984 writetty
  5999                                  ;  239  3993 writetty
  6000                                  ;Input: AS.C, List: AS.S,  Lines:  210
  6001                                  ;Glob. variables:  190 max.:  200
  6002                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  6003                                  ;Functions      :   72 max.:  300
  6004                                  ;Calls          :  240 max.: 2000, NameField: 4025 max.:    65535
  6005                                  ;Code until     :26009 max.: 30000, free: 3991
  6006                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6007                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
