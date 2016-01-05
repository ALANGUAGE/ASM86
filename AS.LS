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
    11 00000003 E89919                   call getarg
    12 00000006 E8940B                   call parse
    13 00000009 E8EB1B                   call epilog
    14 0000000C E8581D                   call end1
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
    32                                  ;-2 char Symbol[80];        //next symbol to decode
    33                                  
    34                                  section .bss
    35                                  absolute 30000
    36 00007530 <res 00000050>          Symbol resb 80
    37                                  section .text
    38                                  
    39                                  ;-3 char SymbolUpper[80];   //set toupper in getName
    40                                  
    41                                  section .bss
    42                                  absolute 30080
    43 00007580 <res 00000050>          SymbolUpper resb 80
    44                                  section .text
    45                                  
    46                                  ;-4 unsigned int SymbolInt; //integer value set in getDigit
    47                                  
    48 00000025 0000                    SymbolInt dw 0
    49                                  
    50                                  ;-5 char InputBuf[128];     //filled in getLine, no overflow test
    51                                  
    52                                  section .bss
    53                                  absolute 30160
    54 000075D0 <res 00000080>          InputBuf resb 128
    55                                  section .text
    56                                  
    57                                  ;-6 unsigned char *InputPtr;//position in InputBuf
    58                                  
    59 00000027 0000                    InputPtr dw 0
    60                                  
    61                                  ;-7 char namein [67];       //input file name  .S
    62                                  
    63                                  section .bss
    64                                  absolute 30288
    65 00007650 <res 00000043>          namein resb 67
    66                                  section .text
    67                                  
    68                                  ;-8 char namelst[67];       //list file name   .LST
    69                                  
    70                                  section .bss
    71                                  absolute 30355
    72 00007693 <res 00000043>          namelst resb 67
    73                                  section .text
    74                                  
    75                                  ;-9 char namebin[67];       //output file name .COM
    76                                  
    77                                  section .bss
    78                                  absolute 30422
    79 000076D6 <res 00000043>          namebin resb 67
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
   230                                  absolute 30489
   231 00007719 <res 00000005>          OpPos resb 5
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
   252                                  absolute 30494
   253 0000771E <res 000003E8>          LabelNames resb 1000
   254                                  section .text
   255                                  
   256                                  ;-57 char *LabelNamePtr;     // first free position
   257                                  
   258 0000004E 0000                    LabelNamePtr dw 0
   259                                  
   260                                  ;-58 unsigned int LabelAddr[100];//addr of each label
   261                                  
   262                                  section .bss
   263                                  absolute 31494
   264 00007B06 <res 000000C8>          LabelAddr resw 100
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
   281                                  absolute 31694
   282 00007BCE <res 000007D0>          FileBin resb 2000
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
   596                                  ;-76 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//  0F84 je i16rel
   597                                  
   598 00000251 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   599                                  
   600                                  ;-77 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//660F84 je i32rel
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
   752 0000030F E82201                   call getTokeType
   753                                  
   754                                  ;-13   OpSize=getCodeSize();
   755                                  
   756 00000312 E8FD05                   call getCodeSize
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
   772 00000325 E82F07                   call genInstruction
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
   788 00000337 E89801                   call LeftOpwCheck
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
   805 00000354 E80007                   call genInstruction
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
   819 0000036E E8E606                   call genInstruction
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
   831 0000037F E8D506                   call genInstruction
   832 00000382 83C404                   add  sp, 4
   833 00000385 E80107                   call genCodeInREG
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
   851 00000394 E83B01                   call LeftOpwCheck
   852                                  
   853                                  ;-28     genInstruction(wflag, 1); genCodeInREG(); return;
   854                                  
   855 00000397 6A01                     push 1
   856 00000399 A0[4200]                 mov al, byte [wflag]
   857 0000039C B400                     mov ah, 0
   858 0000039E 50                       push ax
   859 0000039F E8B506                   call genInstruction
   860 000003A2 83C404                   add  sp, 4
   861 000003A5 E8E106                   call genCodeInREG
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
   884 000003C1 E89306                   call genInstruction
   885 000003C4 83C404                   add  sp, 4
   886 000003C7 FF36[2500]               push word [SymbolInt]
   887 000003CB E86806                   call genCode16
   888 000003CE 83C402                   add  sp, 2
   889 000003D1 E93A00                   jmp @@retn
   890                                  
   891                                  ;-33     genInstruction(0, 1); return;
   892                                  
   893                                  @@process8:
   894 000003D4 6A01                     push 1
   895 000003D6 6A00                     push 0
   896 000003D8 E87C06                   call genInstruction
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
   919 000003F6 E82514                   call error1
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
   936 00000408 E81314                   call error1
   937 0000040B 83C402                   add  sp, 2
   938                                  
   939                                  ;-41 }
   940                                  
   941                                  
   942                                  ;-42 
   943                                  
   944                                  
   945                                  ;-43 // scan code .....................................
   946                                  
   947                                  
   948                                  ;-44 int getTokeType() { char c;
   949                                  
   950 0000040E C9                      @@retn: LEAVE
   951 0000040F C3                       ret
   952                                  ; ENDP
   953 00000410 6F6E6C792064696769-     process_0 db "only digit allowed",0
   954 00000419 7420616C6C6F776564-
   955 00000422 00                 
   956 00000423 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
   957 0000042C 6F64655479706500   
   958                                  
   959                                  getTokeType:  ; *** PROC ***
   960                                  
   961                                  ;-45   skipBlank();
   962                                  
   963                                  ;Function : getTokeType, Number of local variables: 1
   964                                  ;   # type sign width line used address name   list of local variables
   965                                  ;  200 var sign byte    44 NULL bp-2    c;
   966 00000434 C8020000                 ENTER  2,0
   967 00000438 E8770B                   call skipBlank
   968                                  
   969                                  ;-46   c = *InputPtr;
   970                                  
   971 0000043B 8B1E[2700]               mov bx, [InputPtr]
   972 0000043F 8A07                     mov al, [bx]
   973 00000441 B400                     mov ah, 0
   974 00000443 8846FE                   mov byte [bp-2], al
   975                                  
   976                                  ;-47   if (c == 0)   {TokeType=0; return; }//last line or empty line
   977                                  
   978 00000446 8A46FE                   mov al, [bp-2]
   979 00000449 3C00                     cmp al, 0
   980 0000044B 0F850C00                 jne @@getTokeType11
   981 0000044F 66B800000000             mov eax, 0
   982 00000455 A2[3B00]                 mov byte [TokeType], al
   983 00000458 E97500                   jmp @@retn
   984                                  
   985                                  ;-48   if (c == ';') {TokeType=0; return; }//comment
   986                                  
   987                                  @@getTokeType11:
   988 0000045B 8A46FE                   mov al, [bp-2]
   989 0000045E 3C3B                     cmp al, 59
   990 00000460 0F850C00                 jne @@getTokeType12
   991 00000464 66B800000000             mov eax, 0
   992 0000046A A2[3B00]                 mov byte [TokeType], al
   993 0000046D E96000                   jmp @@retn
   994                                  
   995                                  ;-49   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
   996                                  
   997                                  @@getTokeType12:
   998 00000470 8A46FE                   mov al, byte [bp-2]
   999 00000473 B400                     mov ah, 0
  1000 00000475 50                       push ax
  1001 00000476 E8F819                   call digit
  1002 00000479 83C402                   add  sp, 2
  1003 0000047C 08C0                     or  al, al
  1004 0000047E 0F841800                 je @@getTokeType13
  1005 00000482 8A46FE                   mov al, byte [bp-2]
  1006 00000485 B400                     mov ah, 0
  1007 00000487 50                       push ax
  1008 00000488 E8090C                   call getDigit
  1009 0000048B 83C402                   add  sp, 2
  1010 0000048E 66B801000000             mov eax, 1
  1011 00000494 A2[3B00]                 mov byte [TokeType], al
  1012 00000497 E93600                   jmp @@retn
  1013                                  
  1014                                  ;-50   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1015                                  
  1016                                  @@getTokeType13:
  1017 0000049A 8A46FE                   mov al, byte [bp-2]
  1018 0000049D B400                     mov ah, 0
  1019 0000049F 50                       push ax
  1020 000004A0 E83A0B                   call letterE
  1021 000004A3 83C402                   add  sp, 2
  1022 000004A6 08C0                     or  al, al
  1023 000004A8 0F841800                 je @@getTokeType14
  1024 000004AC 8A46FE                   mov al, byte [bp-2]
  1025 000004AF B400                     mov ah, 0
  1026 000004B1 50                       push ax
  1027 000004B2 E8360C                   call getName
  1028 000004B5 83C402                   add  sp, 2
  1029 000004B8 66B803000000             mov eax, 3
  1030 000004BE A2[3B00]                 mov byte [TokeType], al
  1031 000004C1 E90C00                   jmp @@retn
  1032                                  
  1033                                  ;-51   TokeType=NOALNUME; return;
  1034                                  
  1035                                  @@getTokeType14:
  1036 000004C4 66B804000000             mov eax, 4
  1037 000004CA A2[3B00]                 mov byte [TokeType], al
  1038 000004CD E90000                   jmp @@retn
  1039                                  
  1040                                  ;-52 }
  1041                                  
  1042                                  
  1043                                  ;-53 /*
  1044                                  
  1045                                  
  1046                                  ;-54 operand::=
  1047                                  
  1048                                  
  1049                                  ;-55   none
  1050                                  
  1051                                  
  1052                                  ;-56   ac  (al, ax, eax)
  1053                                  
  1054                                  
  1055                                  ;-57   r   (b, w, s, d)
  1056                                  
  1057                                  
  1058                                  ;-58   [m] (b, w, d)
  1059                                  
  1060                                  
  1061                                  ;-59   i   (b, w)
  1062                                  
  1063                                  
  1064                                  ;-60   disp(b, w)
  1065                                  
  1066                                  
  1067                                  ;-61 
  1068                                  
  1069                                  
  1070                                  ;-62 //O2=rr,rm,ri,mr,mi
  1071                                  
  1072                                  
  1073                                  ;-63 //NumOprns==2, seg reg not allowed only mov and push
  1074                                  
  1075                                  
  1076                                  ;-64 //size: 1.declaration CodeSize, 2.reg size, 3.error1
  1077                                  
  1078                                  
  1079                                  ;-65 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
  1080                                  
  1081                                  
  1082                                  ;-66 //2. rm , imm 80
  1083                                  
  1084                                  
  1085                                  ;-67 //2a sign ext 83
  1086                                  
  1087                                  
  1088                                  ;-68 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
  1089                                  
  1090                                  
  1091                                  ;-69 //4. rm , reg 00
  1092                                  
  1093                                  
  1094                                  ;-70 //5. error1(mem2mem)
  1095                                  
  1096                                  
  1097                                  ;-71 */
  1098                                  
  1099                                  
  1100                                  ;-72 int LeftOpwCheck() {
  1101                                  
  1102 000004D0 C9                      @@retn: LEAVE
  1103 000004D1 C3                       ret
  1104                                  ; ENDP
  1105                                  
  1106                                  LeftOpwCheck:  ; *** PROC ***
  1107                                  
  1108                                  ;-73   getLeftOp();
  1109                                  
  1110 000004D2 E8A700                   call getLeftOp
  1111                                  
  1112                                  ;-74   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1113                                  
  1114 000004D5 A0[3E00]                 mov al, [RegType]
  1115 000004D8 3C04                     cmp al, 4
  1116 000004DA 0F850600                 jne @@LeftOpwCheck15
  1117 000004DE E83614                   call segregerror
  1118 000004E1 E95300                   jmp @@retn
  1119                                  
  1120                                  ;-75   setwflag();
  1121                                  
  1122                                  @@LeftOpwCheck15:
  1123 000004E4 E85B01                   call setwflag
  1124                                  
  1125                                  ;-76   if (OpSize == 0) error1("no op size declared");
  1126                                  
  1127 000004E7 A0[4000]                 mov al, [OpSize]
  1128 000004EA 3C00                     cmp al, 0
  1129 000004EC 0F850900                 jne @@LeftOpwCheck16
  1130 000004F0 68[3805]                 push LeftOpwCheck_0
  1131 000004F3 E82813                   call error1
  1132 000004F6 83C402                   add  sp, 2
  1133                                  
  1134                                  ;-77   if (OpSize == RegType) return;
  1135                                  
  1136                                  @@LeftOpwCheck16:
  1137 000004F9 A0[4000]                 mov al, [OpSize]
  1138 000004FC 3A06[3E00]               cmp al, [RegType]
  1139 00000500 0F850300                 jne @@LeftOpwCheck17
  1140 00000504 E93000                   jmp @@retn
  1141                                  
  1142                                  ;-78   if (OpSize){if (Op1 == IND) return;
  1143                                  
  1144                                  @@LeftOpwCheck17:
  1145 00000507 A0[4000]                 mov al, [OpSize]
  1146 0000050A 08C0                     or  al, al
  1147 0000050C 0F841500                 je @@LeftOpwCheck18
  1148 00000510 A0[3C00]                 mov al, [Op1]
  1149 00000513 3C04                     cmp al, 4
  1150 00000515 0F850300                 jne @@LeftOpwCheck19
  1151 00000519 E91B00                   jmp @@retn
  1152                                  
  1153                                  ;-79     error1("Conflict OpSize and RegSize"); }
  1154                                  
  1155                                  @@LeftOpwCheck19:
  1156 0000051C 68[4C05]                 push LeftOpwCheck_1
  1157 0000051F E8FC12                   call error1
  1158 00000522 83C402                   add  sp, 2
  1159                                  
  1160                                  ;-80   if (RegType==0) error1("no register defined");
  1161                                  
  1162                                  @@LeftOpwCheck18:
  1163 00000525 A0[3E00]                 mov al, [RegType]
  1164 00000528 3C00                     cmp al, 0
  1165 0000052A 0F850900                 jne @@LeftOpwCheck20
  1166 0000052E 68[6805]                 push LeftOpwCheck_2
  1167 00000531 E8EA12                   call error1
  1168 00000534 83C402                   add  sp, 2
  1169                                  
  1170                                  ;-81 }
  1171                                  
  1172                                  @@LeftOpwCheck20:
  1173                                  
  1174                                  ;-82 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
  1175                                  
  1176                                  @@retn:
  1177 00000537 C3                       ret
  1178                                  ; ENDP
  1179 00000538 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
  1180 00000541 65206465636C617265-
  1181 0000054A 6400               
  1182 0000054C 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
  1183 00000555 4F7053697A6520616E-
  1184 0000055E 642052656753697A65-
  1185 00000567 00                 
  1186 00000568 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
  1187 00000571 657220646566696E65-
  1188 0000057A 6400               
  1189                                  
  1190                                  getLeftOp:  ; *** PROC ***
  1191                                  
  1192                                  ;-83 //set: op1, disp->imm, reg, regt->size
  1193                                  
  1194                                  
  1195                                  ;-84   disp=0; imme=0; reg=0;
  1196                                  
  1197 0000057C 66B800000000             mov eax, 0
  1198 00000582 A3[4500]                 mov word [disp], ax
  1199 00000585 66B800000000             mov eax, 0
  1200 0000058B A3[4700]                 mov word [imme], ax
  1201 0000058E 66B800000000             mov eax, 0
  1202 00000594 A2[4400]                 mov byte [reg], al
  1203                                  
  1204                                  ;-85 
  1205                                  
  1206                                  
  1207                                  ;-86   Op1=getOp1();
  1208                                  
  1209 00000597 E80301                   call getOp1
  1210 0000059A A2[3C00]                 mov byte [Op1], al
  1211                                  
  1212                                  ;-87   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
  1213                                  
  1214 0000059D 6A5B                     push 91
  1215 0000059F E8F303                   call isToken
  1216 000005A2 83C402                   add  sp, 2
  1217 000005A5 08C0                     or  al, al
  1218 000005A7 0F840F00                 je @@getLeftOp21
  1219 000005AB 66B804000000             mov eax, 4
  1220 000005B1 A2[3C00]                 mov byte [Op1], al
  1221 000005B4 E86C01                   call getIND
  1222 000005B7 E95200                   jmp @@retn
  1223                                  
  1224                                  ;-88   if (Op1 == 0) error1("Name of operand expected");
  1225                                  
  1226                                  @@getLeftOp21:
  1227 000005BA A0[3C00]                 mov al, [Op1]
  1228 000005BD 3C00                     cmp al, 0
  1229 000005BF 0F850900                 jne @@getLeftOp22
  1230 000005C3 68[0D06]                 push getLeftOp_0
  1231 000005C6 E85512                   call error1
  1232 000005C9 83C402                   add  sp, 2
  1233                                  
  1234                                  ;-89   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
  1235                                  
  1236                                  @@getLeftOp22:
  1237 000005CC A0[3C00]                 mov al, [Op1]
  1238 000005CF 3C01                     cmp al, 1
  1239 000005D1 0F850900                 jne @@getLeftOp23
  1240 000005D5 A1[2500]                 mov ax, [SymbolInt]
  1241 000005D8 A3[4700]                 mov word [imme], ax
  1242 000005DB E92E00                   jmp @@retn
  1243                                  
  1244                                  ;-90   if (Op1 == REG) return;                                    //2
  1245                                  
  1246                                  @@getLeftOp23:
  1247 000005DE A0[3C00]                 mov al, [Op1]
  1248 000005E1 3C02                     cmp al, 2
  1249 000005E3 0F850300                 jne @@getLeftOp24
  1250 000005E7 E92200                   jmp @@retn
  1251                                  
  1252                                  ;-91   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
  1253                                  
  1254                                  @@getLeftOp24:
  1255 000005EA A0[3C00]                 mov al, [Op1]
  1256 000005ED 3C03                     cmp al, 3
  1257 000005EF 0F851000                 jne @@getLeftOp25
  1258 000005F3 8B1E[5200]               mov bx, [LabelIx]
  1259 000005F7 D1E3                     shl bx, 1
  1260 000005F9 8B87067B                 mov ax, [LabelAddr + bx]
  1261 000005FD A3[4500]                 mov word [disp], ax
  1262 00000600 E90900                   jmp @@retn
  1263                                  
  1264                                  ;-92   error1("Name of operand expected #1");
  1265                                  
  1266                                  @@getLeftOp25:
  1267 00000603 68[2606]                 push getLeftOp_1
  1268 00000606 E81512                   call error1
  1269 00000609 83C402                   add  sp, 2
  1270                                  
  1271                                  ;-93 }
  1272                                  
  1273                                  
  1274                                  ;-94 int setwflag() {//only Op1 (first operand)
  1275                                  
  1276                                  @@retn:
  1277 0000060C C3                       ret
  1278                                  ; ENDP
  1279 0000060D 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
  1280 00000616 706572616E64206578-
  1281 0000061F 70656374656400     
  1282 00000626 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
  1283 0000062F 706572616E64206578-
  1284 00000638 706563746564202331-
  1285 00000641 00                 
  1286                                  
  1287                                  setwflag:  ; *** PROC ***
  1288                                  
  1289                                  ;-95   wflag=0;
  1290                                  
  1291 00000642 66B800000000             mov eax, 0
  1292 00000648 A2[4200]                 mov byte [wflag], al
  1293                                  
  1294                                  ;-96   if (OpSize == 0) {//do not override OpSize
  1295                                  
  1296 0000064B A0[4000]                 mov al, [OpSize]
  1297 0000064E 3C00                     cmp al, 0
  1298 00000650 0F852100                 jne @@setwflag26
  1299                                  
  1300                                  ;-97     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
  1301                                  
  1302 00000654 A0[3C00]                 mov al, [Op1]
  1303 00000657 3C02                     cmp al, 2
  1304 00000659 0F851800                 jne @@setwflag27
  1305 0000065D A0[3E00]                 mov al, [RegType]
  1306 00000660 A2[4000]                 mov byte [OpSize], al
  1307 00000663 A0[3E00]                 mov al, [RegType]
  1308 00000666 3C04                     cmp al, 4
  1309 00000668 0F850900                 jne @@setwflag28
  1310 0000066C 66B802000000             mov eax, 2
  1311 00000672 A2[4000]                 mov byte [OpSize], al
  1312                                  @@setwflag28:
  1313                                  
  1314                                  ;-98   }
  1315                                  
  1316                                  @@setwflag27:
  1317                                  
  1318                                  ;-99   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1319                                  
  1320                                  @@setwflag26:
  1321 00000675 A0[4000]                 mov al, [OpSize]
  1322 00000678 3C03                     cmp al, 3
  1323 0000067A 0F850C00                 jne @@setwflag29
  1324 0000067E E87A03                   call gen66h
  1325 00000681 66B801000000             mov eax, 1
  1326 00000687 A2[4200]                 mov byte [wflag], al
  1327                                  
  1328                                  ;-100   if (OpSize  ==  WORD) wflag=1;
  1329                                  
  1330                                  @@setwflag29:
  1331 0000068A A0[4000]                 mov al, [OpSize]
  1332 0000068D 3C02                     cmp al, 2
  1333 0000068F 0F850900                 jne @@setwflag30
  1334 00000693 66B801000000             mov eax, 1
  1335 00000699 A2[4200]                 mov byte [wflag], al
  1336                                  
  1337                                  ;-101 }
  1338                                  
  1339                                  @@setwflag30:
  1340                                  
  1341                                  ;-102 int getOp1() {//scan for a single operand
  1342                                  
  1343 0000069C C3                       ret
  1344                                  ; ENDP
  1345                                  
  1346                                  getOp1:  ; *** PROC ***
  1347                                  
  1348                                  ;-103   //set:Op1, imme, disp, RegType, TegNo, reg
  1349                                  
  1350                                  
  1351                                  ;-104   if (TokeType == 0)      return 0;
  1352                                  
  1353 0000069D A0[3B00]                 mov al, [TokeType]
  1354 000006A0 3C00                     cmp al, 0
  1355 000006A2 0F850900                 jne @@getOp131
  1356 000006A6 66B800000000             mov eax, 0
  1357 000006AC E96000                   jmp @@retn
  1358                                  
  1359                                  ;-105   if (TokeType == DIGIT)  return IMM;// 1
  1360                                  
  1361                                  @@getOp131:
  1362 000006AF A0[3B00]                 mov al, [TokeType]
  1363 000006B2 3C01                     cmp al, 1
  1364 000006B4 0F850900                 jne @@getOp132
  1365 000006B8 66B801000000             mov eax, 1
  1366 000006BE E94E00                   jmp @@retn
  1367                                  
  1368                                  ;-106   if (TokeType == ALNUME) {
  1369                                  
  1370                                  @@getOp132:
  1371 000006C1 A0[3B00]                 mov al, [TokeType]
  1372 000006C4 3C03                     cmp al, 3
  1373 000006C6 0F853C00                 jne @@getOp133
  1374                                  
  1375                                  ;-107     RegNo=testReg();//set global RegType
  1376                                  
  1377 000006CA E8AA0A                   call testReg
  1378 000006CD A2[3F00]                 mov byte [RegNo], al
  1379                                  
  1380                                  ;-108     if (RegType)          return REG;// 2
  1381                                  
  1382 000006D0 A0[3E00]                 mov al, [RegType]
  1383 000006D3 08C0                     or  al, al
  1384 000006D5 0F840900                 je @@getOp134
  1385 000006D9 66B802000000             mov eax, 2
  1386 000006DF E92D00                   jmp @@retn
  1387                                  
  1388                                  ;-109     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];
  1389                                  
  1390                                  @@getOp134:
  1391 000006E2 E8EE05                   call searchLabel
  1392 000006E5 A3[5200]                 mov word [LabelIx], ax
  1393                                  
  1394                                  ;-110     if (LabelIx)          return DIR;// 3
  1395                                  
  1396 000006E8 A1[5200]                 mov ax, [LabelIx]
  1397 000006EB 08C0                     or  al, al
  1398 000006ED 0F840C00                 je @@getOp135
  1399 000006F1 66B803000000             mov eax, 3
  1400 000006F7 E91500                   jmp @@retn
  1401                                  
  1402                                  ;-111     else error1("variable not found"); }
  1403                                  
  1404 000006FA E90900                   jmp @@getOp136
  1405                                  @@getOp135:
  1406 000006FD 68[1007]                 push getOp1_0
  1407 00000700 E81B11                   call error1
  1408 00000703 83C402                   add  sp, 2
  1409                                  @@getOp136:
  1410                                  
  1411                                  ;-112   return 0;
  1412                                  
  1413                                  @@getOp133:
  1414 00000706 66B800000000             mov eax, 0
  1415 0000070C E90000                   jmp @@retn
  1416                                  
  1417                                  ;-113 }
  1418                                  
  1419                                  
  1420                                  ;-114 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
  1421                                  
  1422                                  @@retn:
  1423 0000070F C3                       ret
  1424                                  ; ENDP
  1425 00000710 7661726961626C6520-     getOp1_0 db "variable not found",0
  1426 00000719 6E6F7420666F756E64-
  1427 00000722 00                 
  1428                                  
  1429                                  getIND:  ; *** PROC ***
  1430                                  
  1431                                  ;-115   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
  1432                                  
  1433                                  ;Function : getIND, Number of local variables: 2
  1434                                  ;   # type sign width line used address name   list of local variables
  1435                                  ;  200 var sign byte   115 NULL bp-2    op2
  1436                                  ;  201 var sign byte   115 NULL bp-4    r1;
  1437 00000723 C8040000                 ENTER  4,0
  1438 00000727 66B800000000             mov eax, 0
  1439 0000072D A3[4500]                 mov word [disp], ax
  1440 00000730 66B800000000             mov eax, 0
  1441 00000736 8846FC                   mov byte [bp-4], al
  1442 00000739 66B800000000             mov eax, 0
  1443 0000073F A2[3E00]                 mov byte [RegType], al
  1444                                  
  1445                                  ;-116   do {
  1446                                  
  1447                                  @@getIND37:
  1448                                  
  1449                                  ;-117     getTokeType();
  1450                                  
  1451 00000742 E8EFFC                   call getTokeType
  1452                                  
  1453                                  ;-118     op2=getOp1();
  1454                                  
  1455 00000745 E855FF                   call getOp1
  1456 00000748 8846FE                   mov byte [bp-2], al
  1457                                  
  1458                                  ;-119     if (op2 ==   0) syntaxerror();
  1459                                  
  1460 0000074B 8A46FE                   mov al, [bp-2]
  1461 0000074E 3C00                     cmp al, 0
  1462 00000750 0F850300                 jne @@getIND38
  1463 00000754 E8E711                   call syntaxerror
  1464                                  
  1465                                  ;-120     if (op2 == IMM) disp=disp+SymbolInt;
  1466                                  
  1467                                  @@getIND38:
  1468 00000757 8A46FE                   mov al, [bp-2]
  1469 0000075A 3C01                     cmp al, 1
  1470 0000075C 0F850A00                 jne @@getIND39
  1471 00000760 A1[4500]                 mov ax, [disp]
  1472 00000763 0306[2500]               add ax, [SymbolInt]
  1473 00000767 A3[4500]                 mov word [disp], ax
  1474                                  
  1475                                  ;-121     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
  1476                                  
  1477                                  @@getIND39:
  1478 0000076A 8A46FE                   mov al, [bp-2]
  1479 0000076D 3C02                     cmp al, 2
  1480 0000076F 0F852100                 jne @@getIND40
  1481 00000773 8A46FC                   mov al, [bp-4]
  1482 00000776 08C0                     or  al, al
  1483 00000778 0F841200                 je @@getIND41
  1484 0000077C 8A46FC                   mov al, byte [bp-4]
  1485 0000077F B400                     mov ah, 0
  1486 00000781 50                       push ax
  1487 00000782 E80001                   call getIndReg2
  1488 00000785 83C402                   add  sp, 2
  1489 00000788 8846FC                   mov byte [bp-4], al
  1490 0000078B E90600                   jmp @@getIND42
  1491                                  @@getIND41:
  1492 0000078E E87F00                   call getIndReg1
  1493 00000791 8846FC                   mov byte [bp-4], al
  1494                                  
  1495                                  ;-122     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
  1496                                  
  1497                                  @@getIND42:
  1498                                  @@getIND40:
  1499 00000794 8A46FE                   mov al, [bp-2]
  1500 00000797 3C03                     cmp al, 3
  1501 00000799 0F851000                 jne @@getIND43
  1502 0000079D A1[4500]                 mov ax, [disp]
  1503 000007A0 8B1E[5200]               mov bx, [LabelIx]
  1504 000007A4 D1E3                     shl bx, 1
  1505 000007A6 0387067B                 add ax, [LabelAddr + bx]
  1506 000007AA A3[4500]                 mov word [disp], ax
  1507                                  
  1508                                  ;-123     if (isToken('-')) {getTokeType();
  1509                                  
  1510                                  @@getIND43:
  1511 000007AD 6A2D                     push 45
  1512 000007AF E8E301                   call isToken
  1513 000007B2 83C402                   add  sp, 2
  1514 000007B5 08C0                     or  al, al
  1515 000007B7 0F841900                 je @@getIND44
  1516 000007BB E876FC                   call getTokeType
  1517                                  
  1518                                  ;-124       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  1519                                  
  1520 000007BE A0[3B00]                 mov al, [TokeType]
  1521 000007C1 3C01                     cmp al, 1
  1522 000007C3 0F840300                 je  @@getIND45
  1523 000007C7 E80911                   call numbererror
  1524                                  @@getIND45:
  1525 000007CA A1[4500]                 mov ax, [disp]
  1526 000007CD 2B06[2500]               sub ax, [SymbolInt]
  1527 000007D1 A3[4500]                 mov word [disp], ax
  1528                                  
  1529                                  ;-125   } while (isToken('+'));
  1530                                  
  1531                                  @@getIND44:
  1532 000007D4 6A2B                     push 43
  1533 000007D6 E8BC01                   call isToken
  1534 000007D9 83C402                   add  sp, 2
  1535 000007DC 08C0                     or  al, al
  1536 000007DE 0F840300                 je @@getIND46
  1537 000007E2 E95DFF                   jmp @@getIND37
  1538                                  @@getIND46:
  1539                                  
  1540                                  ;-126   if (isToken(']') == 0) errorexit("] expected");
  1541                                  
  1542 000007E5 6A5D                     push 93
  1543 000007E7 E8AB01                   call isToken
  1544 000007EA 83C402                   add  sp, 2
  1545 000007ED 83F800                   cmp ax, 0
  1546 000007F0 0F850900                 jne @@getIND47
  1547 000007F4 68[0508]                 push getIND_0
  1548 000007F7 E85511                   call errorexit
  1549 000007FA 83C402                   add  sp, 2
  1550                                  
  1551                                  ;-127   reg=r1;
  1552                                  
  1553                                  @@getIND47:
  1554 000007FD 8A46FC                   mov al, [bp-4]
  1555 00000800 A2[4400]                 mov byte [reg], al
  1556                                  
  1557                                  ;-128 }
  1558                                  
  1559                                  
  1560                                  ;-129 int getIndReg1() {char m; m=0;
  1561 00000803 C9                       LEAVE
  1562 00000804 C3                       ret
  1563                                  ; ENDP
  1564 00000805 5D2065787065637465-     getIND_0 db "] expected",0
  1565 0000080E 6400               
  1566                                  
  1567                                  getIndReg1:  ; *** PROC ***
  1568                                  ;Function : getIndReg1, Number of local variables: 1
  1569                                  ;   # type sign width line used address name   list of local variables
  1570                                  ;  200 var sign byte   129 NULL bp-2    m;
  1571 00000810 C8020000                 ENTER  2,0
  1572 00000814 66B800000000             mov eax, 0
  1573 0000081A 8846FE                   mov byte [bp-2], al
  1574                                  
  1575                                  ;-130   if (RegType !=WORD) indexerror();
  1576                                  
  1577 0000081D A0[3E00]                 mov al, [RegType]
  1578 00000820 3C02                     cmp al, 2
  1579 00000822 0F840300                 je  @@getIndReg148
  1580 00000826 E88910                   call indexerror
  1581                                  
  1582                                  ;-131   if (RegNo==3) m=7;//BX
  1583                                  
  1584                                  @@getIndReg148:
  1585 00000829 A0[3F00]                 mov al, [RegNo]
  1586 0000082C 3C03                     cmp al, 3
  1587 0000082E 0F850900                 jne @@getIndReg149
  1588 00000832 66B807000000             mov eax, 7
  1589 00000838 8846FE                   mov byte [bp-2], al
  1590                                  
  1591                                  ;-132   if (RegNo==5) m=6;//BP change to BP+0
  1592                                  
  1593                                  @@getIndReg149:
  1594 0000083B A0[3F00]                 mov al, [RegNo]
  1595 0000083E 3C05                     cmp al, 5
  1596 00000840 0F850900                 jne @@getIndReg150
  1597 00000844 66B806000000             mov eax, 6
  1598 0000084A 8846FE                   mov byte [bp-2], al
  1599                                  
  1600                                  ;-133   if (RegNo==7) m=5;//DI
  1601                                  
  1602                                  @@getIndReg150:
  1603 0000084D A0[3F00]                 mov al, [RegNo]
  1604 00000850 3C07                     cmp al, 7
  1605 00000852 0F850900                 jne @@getIndReg151
  1606 00000856 66B805000000             mov eax, 5
  1607 0000085C 8846FE                   mov byte [bp-2], al
  1608                                  
  1609                                  ;-134   if (RegNo==6) m=4;//SI
  1610                                  
  1611                                  @@getIndReg151:
  1612 0000085F A0[3F00]                 mov al, [RegNo]
  1613 00000862 3C06                     cmp al, 6
  1614 00000864 0F850900                 jne @@getIndReg152
  1615 00000868 66B804000000             mov eax, 4
  1616 0000086E 8846FE                   mov byte [bp-2], al
  1617                                  
  1618                                  ;-135   if (m    ==0) indexerror();
  1619                                  
  1620                                  @@getIndReg152:
  1621 00000871 8A46FE                   mov al, [bp-2]
  1622 00000874 3C00                     cmp al, 0
  1623 00000876 0F850300                 jne @@getIndReg153
  1624 0000087A E83510                   call indexerror
  1625                                  
  1626                                  ;-136   return m;
  1627                                  
  1628                                  @@getIndReg153:
  1629 0000087D 8A46FE                   mov al, [bp-2]
  1630 00000880 E90000                   jmp @@retn
  1631                                  
  1632                                  ;-137 }
  1633                                  
  1634                                  
  1635                                  ;-138 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1636                                  
  1637 00000883 C9                      @@retn: LEAVE
  1638 00000884 C3                       ret
  1639                                  ; ENDP
  1640                                  
  1641                                  getIndReg2:  ; *** PROC ***
  1642                                  ;Function : getIndReg2, Number of local variables: 2
  1643                                  ;   # type sign width line used address name   list of local variables
  1644                                  ;  200 var sign byte   138 NULL bp+4    r1
  1645                                  ;  201 var sign byte   138 NULL bp-2    m;
  1646 00000885 C8020000                 ENTER  2,0
  1647 00000889 66B804000000             mov eax, 4
  1648 0000088F 8846FE                   mov byte [bp-2], al
  1649                                  
  1650                                  ;-139   if (RegType !=WORD) indexerror();
  1651                                  
  1652 00000892 A0[3E00]                 mov al, [RegType]
  1653 00000895 3C02                     cmp al, 2
  1654 00000897 0F840300                 je  @@getIndReg254
  1655 0000089B E81410                   call indexerror
  1656                                  
  1657                                  ;-140   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1658                                  
  1659                                  @@getIndReg254:
  1660 0000089E A0[3F00]                 mov al, [RegNo]
  1661 000008A1 3C07                     cmp al, 7
  1662 000008A3 0F852700                 jne @@getIndReg255
  1663 000008A7 8A4604                   mov al, [bp+4]
  1664 000008AA 3C06                     cmp al, 6
  1665 000008AC 0F850C00                 jne @@getIndReg256
  1666 000008B0 66B803000000             mov eax, 3
  1667 000008B6 8846FE                   mov byte [bp-2], al
  1668                                  
  1669                                  ;-141            else if (r1==7) m=1;//BX+DI
  1670                                  
  1671 000008B9 E91200                   jmp @@getIndReg257
  1672                                  @@getIndReg256:
  1673 000008BC 8A4604                   mov al, [bp+4]
  1674 000008BF 3C07                     cmp al, 7
  1675 000008C1 0F850900                 jne @@getIndReg258
  1676 000008C5 66B801000000             mov eax, 1
  1677 000008CB 8846FE                   mov byte [bp-2], al
  1678                                  
  1679                                  ;-142   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1680                                  
  1681                                  @@getIndReg258:
  1682                                  @@getIndReg257:
  1683                                  @@getIndReg255:
  1684 000008CE A0[3F00]                 mov al, [RegNo]
  1685 000008D1 3C06                     cmp al, 6
  1686 000008D3 0F852700                 jne @@getIndReg259
  1687 000008D7 8A4604                   mov al, [bp+4]
  1688 000008DA 3C06                     cmp al, 6
  1689 000008DC 0F850C00                 jne @@getIndReg260
  1690 000008E0 66B802000000             mov eax, 2
  1691 000008E6 8846FE                   mov byte [bp-2], al
  1692                                  
  1693                                  ;-143            else if (r1==7) m=0;//BX+DI
  1694                                  
  1695 000008E9 E91200                   jmp @@getIndReg261
  1696                                  @@getIndReg260:
  1697 000008EC 8A4604                   mov al, [bp+4]
  1698 000008EF 3C07                     cmp al, 7
  1699 000008F1 0F850900                 jne @@getIndReg262
  1700 000008F5 66B800000000             mov eax, 0
  1701 000008FB 8846FE                   mov byte [bp-2], al
  1702                                  
  1703                                  ;-144   if (m > 3) indexerror();
  1704                                  
  1705                                  @@getIndReg262:
  1706                                  @@getIndReg261:
  1707                                  @@getIndReg259:
  1708 000008FE 8A46FE                   mov al, [bp-2]
  1709 00000901 3C03                     cmp al, 3
  1710 00000903 0F8E0300                 jle @@getIndReg263
  1711 00000907 E8A80F                   call indexerror
  1712                                  
  1713                                  ;-145   return m;
  1714                                  
  1715                                  @@getIndReg263:
  1716 0000090A 8A46FE                   mov al, [bp-2]
  1717 0000090D E90000                   jmp @@retn
  1718                                  
  1719                                  ;-146 }
  1720                                  
  1721                                  
  1722                                  ;-147 
  1723                                  
  1724                                  
  1725                                  ;-148 int getCodeSize() {
  1726                                  
  1727 00000910 C9                      @@retn: LEAVE
  1728 00000911 C3                       ret
  1729                                  ; ENDP
  1730                                  
  1731                                  getCodeSize:  ; *** PROC ***
  1732                                  
  1733                                  ;-149   if (TokeType ==ALNUME) {
  1734                                  
  1735 00000912 A0[3B00]                 mov al, [TokeType]
  1736 00000915 3C03                     cmp al, 3
  1737 00000917 0F856000                 jne @@getCodeSize64
  1738                                  
  1739                                  ;-150     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1740                                  
  1741 0000091B 68[8509]                 push getCodeSize_0
  1742 0000091E 8D068075                 lea  ax, [SymbolUpper]
  1743 00000922 50                       push ax
  1744 00000923 E87E15                   call eqstr
  1745 00000926 83C404                   add  sp, 4
  1746 00000929 08C0                     or  al, al
  1747 0000092B 0F840C00                 je @@getCodeSize65
  1748 0000092F E802FB                   call getTokeType
  1749 00000932 66B801000000             mov eax, 1
  1750 00000938 E94900                   jmp @@retn
  1751                                  
  1752                                  ;-151     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1753                                  
  1754                                  @@getCodeSize65:
  1755 0000093B 68[8A09]                 push getCodeSize_1
  1756 0000093E 8D068075                 lea  ax, [SymbolUpper]
  1757 00000942 50                       push ax
  1758 00000943 E85E15                   call eqstr
  1759 00000946 83C404                   add  sp, 4
  1760 00000949 08C0                     or  al, al
  1761 0000094B 0F840C00                 je @@getCodeSize66
  1762 0000094F E8E2FA                   call getTokeType
  1763 00000952 66B802000000             mov eax, 2
  1764 00000958 E92900                   jmp @@retn
  1765                                  
  1766                                  ;-152     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1767                                  
  1768                                  @@getCodeSize66:
  1769 0000095B 68[8F09]                 push getCodeSize_2
  1770 0000095E 8D068075                 lea  ax, [SymbolUpper]
  1771 00000962 50                       push ax
  1772 00000963 E83E15                   call eqstr
  1773 00000966 83C404                   add  sp, 4
  1774 00000969 08C0                     or  al, al
  1775 0000096B 0F840C00                 je @@getCodeSize67
  1776 0000096F E8C2FA                   call getTokeType
  1777 00000972 66B803000000             mov eax, 3
  1778 00000978 E90900                   jmp @@retn
  1779                                  
  1780                                  ;-153   } return 0;
  1781                                  
  1782                                  @@getCodeSize67:
  1783                                  @@getCodeSize64:
  1784 0000097B 66B800000000             mov eax, 0
  1785 00000981 E90000                   jmp @@retn
  1786                                  
  1787                                  ;-154 }
  1788                                  
  1789                                  
  1790                                  ;-155 int isToken(char c) {
  1791                                  
  1792                                  @@retn:
  1793 00000984 C3                       ret
  1794                                  ; ENDP
  1795 00000985 4259544500              getCodeSize_0 db "BYTE",0
  1796 0000098A 574F524400              getCodeSize_1 db "WORD",0
  1797 0000098F 44574F524400            getCodeSize_2 db "DWORD",0
  1798                                  
  1799                                  isToken:  ; *** PROC ***
  1800                                  
  1801                                  ;-156   skipBlank();
  1802                                  
  1803                                  ;Function : isToken, Number of local variables: 1
  1804                                  ;   # type sign width line used address name   list of local variables
  1805                                  ;  200 var sign byte   155 NULL bp+4    c;
  1806 00000995 C8000000                 ENTER  0,0
  1807 00000999 E81606                   call skipBlank
  1808                                  
  1809                                  ;-157   if (*InputPtr == c) {
  1810                                  
  1811 0000099C 8B1E[2700]               mov bx, [InputPtr]
  1812 000009A0 8A07                     mov al, [bx]
  1813 000009A2 B400                     mov ah, 0
  1814 000009A4 3A4604                   cmp al, [bp+4]
  1815 000009A7 0F850D00                 jne @@isToken68
  1816                                  
  1817                                  ;-158     InputPtr++; return 1;} return 0;
  1818                                  
  1819 000009AB FF06[2700]               inc  word [InputPtr]
  1820 000009AF 66B801000000             mov eax, 1
  1821 000009B5 E90900                   jmp @@retn
  1822                                  @@isToken68:
  1823 000009B8 66B800000000             mov eax, 0
  1824 000009BE E90000                   jmp @@retn
  1825                                  
  1826                                  ;-159 }
  1827                                  
  1828                                  
  1829                                  ;-160 int skipRest() {
  1830                                  
  1831 000009C1 C9                      @@retn: LEAVE
  1832 000009C2 C3                       ret
  1833                                  ; ENDP
  1834                                  
  1835                                  skipRest:  ; *** PROC ***
  1836                                  
  1837                                  ;-161   getTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");
  1838                                  
  1839 000009C3 E86EFA                   call getTokeType
  1840 000009C6 A0[3B00]                 mov al, [TokeType]
  1841 000009C9 3C00                     cmp al, 0
  1842 000009CB 0F840900                 je  @@skipRest69
  1843 000009CF 68[D909]                 push skipRest_0
  1844 000009D2 E8EC0C                   call prs
  1845 000009D5 83C402                   add  sp, 2
  1846                                  
  1847                                  ;-162 }
  1848                                  
  1849                                  @@skipRest69:
  1850                                  
  1851                                  ;-163 // generate code ...........................................................
  1852                                  
  1853                                  
  1854                                  ;-164 int gen66h() {genCode8(0x66);}
  1855                                  
  1856 000009D8 C3                       ret
  1857                                  ; ENDP
  1858 000009D9 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ********** extra char ignored",0
  1859 000009E2 2A2A2A2A2A20657874-
  1860 000009EB 726120636861722069-
  1861 000009F4 676E6F72656400     
  1862                                  
  1863                                  gen66h:  ; *** PROC ***
  1864 000009FB 6A66                     push 102
  1865 000009FD E80400                   call genCode8
  1866 00000A00 83C402                   add  sp, 2
  1867                                  
  1868                                  ;-165 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  1869                                  
  1870 00000A03 C3                       ret
  1871                                  ; ENDP
  1872                                  
  1873                                  genCode8:  ; *** PROC ***
  1874                                  
  1875                                  ;-166   FileBin[BinLen]=c; BinLen++; PC++;
  1876                                  
  1877                                  ;Function : genCode8, Number of local variables: 1
  1878                                  ;   # type sign width line used address name   list of local variables
  1879                                  ;  200 var sign byte   165 NULL bp+4    c;
  1880 00000A04 C8000000                 ENTER  0,0
  1881 00000A08 8A4604                   mov al, [bp+4]
  1882 00000A0B 8B1E[5400]               mov bx, [BinLen]
  1883 00000A0F 8887CE7B                 mov [FileBin+bx], al
  1884 00000A13 FF06[5400]               inc  word [BinLen]
  1885 00000A17 FF06[3600]               inc  word [PC]
  1886                                  
  1887                                  ;-167   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
  1888                                  
  1889 00000A1B A1[4900]                 mov ax, [OpPrintIndex]
  1890 00000A1E 83F805                   cmp ax, 5
  1891 00000A21 0F8D0F00                 jge @@genCode870
  1892 00000A25 8A4604                   mov al, [bp+4]
  1893 00000A28 8B1E[4900]               mov bx, [OpPrintIndex]
  1894 00000A2C 88871977                 mov [OpPos+bx], al
  1895 00000A30 FF06[4900]               inc  word [OpPrintIndex]
  1896                                  
  1897                                  ;-168 }
  1898                                  
  1899                                  @@genCode870:
  1900                                  
  1901                                  ;-169 int genCode16(int i) {
  1902 00000A34 C9                       LEAVE
  1903 00000A35 C3                       ret
  1904                                  ; ENDP
  1905                                  
  1906                                  genCode16:  ; *** PROC ***
  1907                                  
  1908                                  ;-170   genCode8(i); i=i >> 8; genCode8(i);
  1909                                  
  1910                                  ;Function : genCode16, Number of local variables: 1
  1911                                  ;   # type sign width line used address name   list of local variables
  1912                                  ;  200 var sign word   169 NULL bp+4    i;
  1913 00000A36 C8000000                 ENTER  0,0
  1914 00000A3A FF7604                   push word [bp+4]
  1915 00000A3D E8C4FF                   call genCode8
  1916 00000A40 83C402                   add  sp, 2
  1917 00000A43 8B4604                   mov ax, [bp+4]
  1918 00000A46 C1E808                   shr ax, 8
  1919 00000A49 894604                   mov word [bp+4], ax
  1920 00000A4C FF7604                   push word [bp+4]
  1921 00000A4F E8B2FF                   call genCode8
  1922 00000A52 83C402                   add  sp, 2
  1923                                  
  1924                                  ;-171 }
  1925                                  
  1926                                  
  1927                                  ;-172 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  1928 00000A55 C9                       LEAVE
  1929 00000A56 C3                       ret
  1930                                  ; ENDP
  1931                                  
  1932                                  genInstruction:  ; *** PROC ***
  1933                                  
  1934                                  ;-173   if(loc) OpCodePtr=OpCodePtr+loc;
  1935                                  
  1936                                  ;Function : genInstruction, Number of local variables: 3
  1937                                  ;   # type sign width line used address name   list of local variables
  1938                                  ;  200 var sign byte   172 NULL bp+4    No
  1939                                  ;  201 var sign word   172 NULL bp+6    loc
  1940                                  ;  202 var sign byte   172 NULL bp-2    c;
  1941 00000A57 C8020000                 ENTER  2,0
  1942 00000A5B 8B4606                   mov ax, [bp+6]
  1943 00000A5E 08C0                     or  al, al
  1944 00000A60 0F840900                 je @@genInstruction71
  1945 00000A64 A1[4B00]                 mov ax, [OpCodePtr]
  1946 00000A67 034606                   add ax, [bp+6]
  1947 00000A6A A3[4B00]                 mov word [OpCodePtr], ax
  1948                                  
  1949                                  ;-174   c= *OpCodePtr + No; genCode8(c);
  1950                                  
  1951                                  @@genInstruction71:
  1952 00000A6D 8B1E[4B00]               mov bx, [OpCodePtr]
  1953 00000A71 8A07                     mov al, [bx]
  1954 00000A73 B400                     mov ah, 0
  1955 00000A75 024604                   add al, [bp+4]
  1956 00000A78 8846FE                   mov byte [bp-2], al
  1957 00000A7B 8A46FE                   mov al, byte [bp-2]
  1958 00000A7E B400                     mov ah, 0
  1959 00000A80 50                       push ax
  1960 00000A81 E880FF                   call genCode8
  1961 00000A84 83C402                   add  sp, 2
  1962                                  
  1963                                  ;-175 }
  1964                                  
  1965                                  
  1966                                  ;-176 int genCodeInREG() {char x; //get Code for second byte
  1967 00000A87 C9                       LEAVE
  1968 00000A88 C3                       ret
  1969                                  ; ENDP
  1970                                  
  1971                                  genCodeInREG:  ; *** PROC ***
  1972                                  
  1973                                  ;-177   OpCodePtr++; x= *OpCodePtr; writeEA(x);
  1974                                  
  1975                                  ;Function : genCodeInREG, Number of local variables: 1
  1976                                  ;   # type sign width line used address name   list of local variables
  1977                                  ;  200 var sign byte   176 NULL bp-2    x;
  1978 00000A89 C8020000                 ENTER  2,0
  1979 00000A8D FF06[4B00]               inc  word [OpCodePtr]
  1980 00000A91 8B1E[4B00]               mov bx, [OpCodePtr]
  1981 00000A95 8A07                     mov al, [bx]
  1982 00000A97 B400                     mov ah, 0
  1983 00000A99 8846FE                   mov byte [bp-2], al
  1984 00000A9C 8A46FE                   mov al, byte [bp-2]
  1985 00000A9F B400                     mov ah, 0
  1986 00000AA1 50                       push ax
  1987 00000AA2 E81200                   call writeEA
  1988 00000AA5 83C402                   add  sp, 2
  1989                                  
  1990                                  ;-178 }
  1991                                  
  1992                                  
  1993                                  ;-179 int genModRegRM(){ writeEA(reg);//todo
  1994 00000AA8 C9                       LEAVE
  1995 00000AA9 C3                       ret
  1996                                  ; ENDP
  1997                                  
  1998                                  genModRegRM:  ; *** PROC ***
  1999 00000AAA A0[4400]                 mov al, byte [reg]
  2000 00000AAD B400                     mov ah, 0
  2001 00000AAF 50                       push ax
  2002 00000AB0 E80400                   call writeEA
  2003 00000AB3 83C402                   add  sp, 2
  2004                                  
  2005                                  ;-180 }
  2006                                  
  2007                                  
  2008                                  ;-181 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  2009                                  
  2010 00000AB6 C3                       ret
  2011                                  ; ENDP
  2012                                  
  2013                                  writeEA:  ; *** PROC ***
  2014                                  
  2015                                  ;-182   len=0;
  2016                                  
  2017                                  ;Function : writeEA, Number of local variables: 2
  2018                                  ;   # type sign width line used address name   list of local variables
  2019                                  ;  200 var sign byte   181 NULL bp+4    xxx
  2020                                  ;  201 var sign byte   181 NULL bp-2    len;
  2021 00000AB7 C8020000                 ENTER  2,0
  2022 00000ABB 66B800000000             mov eax, 0
  2023 00000AC1 8846FE                   mov byte [bp-2], al
  2024                                  
  2025                                  ;-183   xxx = xxx << 3;//in reg field of mod r/m
  2026                                  
  2027 00000AC4 8A4604                   mov al, [bp+4]
  2028 00000AC7 C0E003                   shl al, 3
  2029 00000ACA 884604                   mov byte [bp+4], al
  2030                                  
  2031                                  ;-184   if (Op1 ==   0) addrexit();
  2032                                  
  2033 00000ACD A0[3C00]                 mov al, [Op1]
  2034 00000AD0 3C00                     cmp al, 0
  2035 00000AD2 0F850300                 jne @@writeEA72
  2036 00000AD6 E88D0E                   call addrexit
  2037                                  
  2038                                  ;-185   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  2039                                  
  2040                                  @@writeEA72:
  2041 00000AD9 A0[3C00]                 mov al, [Op1]
  2042 00000ADC 3C02                     cmp al, 2
  2043 00000ADE 0F850E00                 jne @@writeEA73
  2044 00000AE2 804E04C0                 or  byte [bp+4], 192
  2045 00000AE6 8A4604                   mov al, [bp+4]
  2046 00000AE9 0206[3F00]               add al, [RegNo]
  2047 00000AED 884604                   mov byte [bp+4], al
  2048                                  
  2049                                  ;-186   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  2050                                  
  2051                                  @@writeEA73:
  2052 00000AF0 A0[3C00]                 mov al, [Op1]
  2053 00000AF3 3C03                     cmp al, 3
  2054 00000AF5 0F850D00                 jne @@writeEA74
  2055 00000AF9 804E0406                 or  byte [bp+4], 6
  2056 00000AFD 66B802000000             mov eax, 2
  2057 00000B03 8846FE                   mov byte [bp-2], al
  2058                                  
  2059                                  ;-187   if (Op1 == IND) { xxx = xxx + reg;                       //4
  2060                                  
  2061                                  @@writeEA74:
  2062 00000B06 A0[3C00]                 mov al, [Op1]
  2063 00000B09 3C04                     cmp al, 4
  2064 00000B0B 0F854600                 jne @@writeEA75
  2065 00000B0F 8A4604                   mov al, [bp+4]
  2066 00000B12 0206[4400]               add al, [reg]
  2067 00000B16 884604                   mov byte [bp+4], al
  2068                                  
  2069                                  ;-188     if (disp) {disp; if(ax > 127) len=2; else len=1;
  2070                                  
  2071 00000B19 A1[4500]                 mov ax, [disp]
  2072 00000B1C 08C0                     or  al, al
  2073 00000B1E 0F843300                 je @@writeEA76
  2074 00000B22 A1[4500]                 mov ax, [disp]
  2075 00000B25 83F87F                   cmp  ax, 127
  2076 00000B28 0F8E0C00                 jle @@writeEA77
  2077 00000B2C 66B802000000             mov eax, 2
  2078 00000B32 8846FE                   mov byte [bp-2], al
  2079 00000B35 E90900                   jmp @@writeEA78
  2080                                  @@writeEA77:
  2081 00000B38 66B801000000             mov eax, 1
  2082 00000B3E 8846FE                   mov byte [bp-2], al
  2083                                  
  2084                                  ;-189       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
  2085                                  
  2086                                  @@writeEA78:
  2087 00000B41 8A46FE                   mov al, [bp-2]
  2088 00000B44 3C01                     cmp al, 1
  2089 00000B46 0F850700                 jne @@writeEA79
  2090 00000B4A 804E0440                 or  byte [bp+4], 64
  2091 00000B4E E90400                   jmp @@writeEA80
  2092                                  @@writeEA79:
  2093 00000B51 804E0480                 or  byte [bp+4], 128
  2094                                  @@writeEA80:
  2095                                  
  2096                                  ;-190     }
  2097                                  
  2098                                  @@writeEA76:
  2099                                  
  2100                                  ;-191   genCode8(xxx);// gen second byte
  2101                                  
  2102                                  @@writeEA75:
  2103 00000B55 8A4604                   mov al, byte [bp+4]
  2104 00000B58 B400                     mov ah, 0
  2105 00000B5A 50                       push ax
  2106 00000B5B E8A6FE                   call genCode8
  2107 00000B5E 83C402                   add  sp, 2
  2108                                  
  2109                                  ;-192   if (len == 1) genCode8 (disp);
  2110                                  
  2111 00000B61 8A46FE                   mov al, [bp-2]
  2112 00000B64 3C01                     cmp al, 1
  2113 00000B66 0F850A00                 jne @@writeEA81
  2114 00000B6A FF36[4500]               push word [disp]
  2115 00000B6E E893FE                   call genCode8
  2116 00000B71 83C402                   add  sp, 2
  2117                                  
  2118                                  ;-193   if (len == 2) genCode16(disp);
  2119                                  
  2120                                  @@writeEA81:
  2121 00000B74 8A46FE                   mov al, [bp-2]
  2122 00000B77 3C02                     cmp al, 2
  2123 00000B79 0F850A00                 jne @@writeEA82
  2124 00000B7D FF36[4500]               push word [disp]
  2125 00000B81 E8B2FE                   call genCode16
  2126 00000B84 83C402                   add  sp, 2
  2127                                  
  2128                                  ;-194 }
  2129                                  
  2130                                  @@writeEA82:
  2131                                  
  2132                                  ;-195 int test1() { __asm {
  2133 00000B87 C9                       LEAVE
  2134 00000B88 C3                       ret
  2135                                  ; ENDP
  2136                                  
  2137                                  test1:  ; *** PROC ***
  2138                                  
  2139                                  
  2140                                  ;-196 inc byte [Version1]   ;FE 06 [1000]
  2141                                  
  2142 00000B89 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  2143                                  
  2144                                  ;-197 add bx, ax    ;01 C3
  2145                                  
  2146 00000B8D 01C3                    add bx, ax    ;01 C3
  2147                                  
  2148                                  ;-198 add ax, bx    ;01 D8
  2149                                  
  2150 00000B8F 01D8                    add ax, bx    ;01 D8
  2151                                  
  2152                                  ;-199 add word ax, [bx] ;03 07
  2153                                  
  2154 00000B91 0307                    add word ax, [bx] ;03 07
  2155                                  
  2156                                  ;-200 VA dw 8
  2157                                  
  2158 00000B93 0800                    VA dw 8
  2159                                  
  2160                                  ;-201 mov byte [bp- 4], al ;88 46 FC
  2161                                  
  2162 00000B95 8846FC                  mov byte [bp- 4], al ;88 46 FC
  2163                                  
  2164                                  ;-202 mov      [VA+bx], al ;88 87 [300F]
  2165                                  
  2166 00000B98 8887[930B]              mov      [VA+bx], al ;88 87 [300F]
  2167                                  
  2168                                  ;-203 }  }
  2169                                  
  2170                                  
  2171                                  
  2172                                  ;-204 //#include "AS1.C"
  2173                                  
  2174                                  
  2175                                  ;-205 #include "PARSE.C"
  2176                                  
  2177 00000B9C C3                       ret
  2178                                  ; ENDP
  2179                                  ;Use include file: PARSE.C
  2180                                  
  2181                                  ;-1 /*
  2182                                  
  2183                                  
  2184                                  ;-2 parse:
  2185                                  
  2186                                  
  2187                                  ;-3   do
  2188                                  
  2189                                  
  2190                                  ;-4     getLine
  2191                                  
  2192                                  
  2193                                  ;-5     do
  2194                                  
  2195                                  
  2196                                  ;-6       getToken (getTokeType)
  2197                                  
  2198                                  
  2199                                  ;-7       if (! letterX) error
  2200                                  
  2201                                  
  2202                                  ;-8       checkOpcode
  2203                                  
  2204                                  
  2205                                  ;-9       if (! Codetype) storeLabel
  2206                                  
  2207                                  
  2208                                  ;-10     while (! CodeType)
  2209                                  
  2210                                  
  2211                                  ;-11     if (CodeType) process
  2212                                  
  2213                                  
  2214                                  ;-12     skipRest
  2215                                  
  2216                                  
  2217                                  ;-13     printLine
  2218                                  
  2219                                  
  2220                                  ;-14   while (DOS_NoBytes !=0)
  2221                                  
  2222                                  
  2223                                  ;-15 */
  2224                                  
  2225                                  
  2226                                  ;-16 int parse() {
  2227                                  
  2228                                  
  2229                                  parse:  ; *** PROC ***
  2230                                  
  2231                                  ;-17   LabelNamePtr= &LabelNames;
  2232                                  
  2233 00000B9D B81E77                   mov ax, LabelNames
  2234 00000BA0 A3[4E00]                 mov word [LabelNamePtr], ax
  2235                                  
  2236                                  ;-18   do {
  2237                                  
  2238                                  @@parse83:
  2239                                  
  2240                                  ;-19     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  2241                                  
  2242 00000BA3 A1[3600]                 mov ax, [PC]
  2243 00000BA6 A3[3800]                 mov word [PCStart], ax
  2244 00000BA9 66B800000000             mov eax, 0
  2245 00000BAF A2[4000]                 mov byte [OpSize], al
  2246 00000BB2 66B800000000             mov eax, 0
  2247 00000BB8 A3[4900]                 mov word [OpPrintIndex], ax
  2248 00000BBB 66B820000000             mov eax, 32
  2249 00000BC1 A2[4D00]                 mov byte [PrReloc], al
  2250                                  
  2251                                  ;-20     getLine();
  2252                                  
  2253 00000BC4 E81E03                   call getLine
  2254                                  
  2255                                  ;-21     InputPtr = &InputBuf;
  2256                                  
  2257 00000BC7 B8D075                   mov ax, InputBuf
  2258 00000BCA A3[2700]                 mov word [InputPtr], ax
  2259                                  
  2260                                  ;-22     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2261                                  
  2262 00000BCD E864F8                   call getTokeType
  2263                                  
  2264                                  ;-23     if (TokeType == ALNUME) {
  2265                                  
  2266 00000BD0 A0[3B00]                 mov al, [TokeType]
  2267 00000BD3 3C03                     cmp al, 3
  2268 00000BD5 0F851300                 jne @@parse84
  2269                                  
  2270                                  ;-24       if (isLabel) { //set in getName
  2271                                  
  2272 00000BD9 A0[3A00]                 mov al, [isLabel]
  2273 00000BDC 08C0                     or  al, al
  2274 00000BDE 0F840A00                 je @@parse85
  2275                                  
  2276                                  ;-25         storeLabel();
  2277                                  
  2278 00000BE2 E8A300                   call storeLabel
  2279                                  
  2280                                  ;-26         InputPtr++;//remove :
  2281                                  
  2282 00000BE5 FF06[2700]               inc  word [InputPtr]
  2283                                  
  2284                                  ;-27         getTokeType();
  2285                                  
  2286 00000BE9 E848F8                   call getTokeType
  2287                                  
  2288                                  ;-28       }
  2289                                  
  2290                                  
  2291                                  ;-29     }
  2292                                  
  2293                                  @@parse85:
  2294                                  
  2295                                  ;-30     if (TokeType == ALNUME) {
  2296                                  
  2297                                  @@parse84:
  2298 00000BEC A0[3B00]                 mov al, [TokeType]
  2299 00000BEF 3C03                     cmp al, 3
  2300 00000BF1 0F851B00                 jne @@parse86
  2301                                  
  2302                                  ;-31       lookCode();// and OpCodePtr
  2303                                  
  2304 00000BF5 E87302                   call lookCode
  2305                                  
  2306                                  ;-32       if(CodeType) process();
  2307                                  
  2308 00000BF8 A0[3D00]                 mov al, [CodeType]
  2309 00000BFB 08C0                     or  al, al
  2310 00000BFD 0F840600                 je @@parse87
  2311 00000C01 E807F7                   call process
  2312                                  
  2313                                  ;-33       else getVariable();
  2314                                  
  2315 00000C04 E90300                   jmp @@parse88
  2316                                  @@parse87:
  2317 00000C07 E82901                   call getVariable
  2318                                  
  2319                                  ;-34       skipRest();
  2320                                  
  2321                                  @@parse88:
  2322 00000C0A E8B6FD                   call skipRest
  2323                                  
  2324                                  ;-35     }
  2325                                  
  2326                                  
  2327                                  ;-36     else if (TokeType >  ALNUME) error1("Label or instruction expected");
  2328                                  
  2329 00000C0D E92700                   jmp @@parse89
  2330                                  @@parse86:
  2331 00000C10 A0[3B00]                 mov al, [TokeType]
  2332 00000C13 3C03                     cmp al, 3
  2333 00000C15 0F8E0C00                 jle @@parse90
  2334 00000C19 68[480C]                 push parse_0
  2335 00000C1C E8FF0B                   call error1
  2336 00000C1F 83C402                   add  sp, 2
  2337                                  
  2338                                  ;-37     else if (TokeType == DIGIT) error1("No digit allowed at start of line");
  2339                                  
  2340 00000C22 E91200                   jmp @@parse91
  2341                                  @@parse90:
  2342 00000C25 A0[3B00]                 mov al, [TokeType]
  2343 00000C28 3C01                     cmp al, 1
  2344 00000C2A 0F850900                 jne @@parse92
  2345 00000C2E 68[660C]                 push parse_1
  2346 00000C31 E8EA0B                   call error1
  2347 00000C34 83C402                   add  sp, 2
  2348                                  
  2349                                  ;-38     printLine();
  2350                                  
  2351                                  @@parse92:
  2352                                  @@parse91:
  2353                                  @@parse89:
  2354 00000C37 E87909                   call printLine
  2355                                  
  2356                                  ;-39   } while (DOS_NoBytes != 0 );
  2357                                  
  2358 00000C3A A1[3300]                 mov ax, [DOS_NoBytes]
  2359 00000C3D 83F800                   cmp ax, 0
  2360 00000C40 0F840300                 je  @@parse93
  2361 00000C44 E95CFF                   jmp @@parse83
  2362                                  @@parse93:
  2363                                  
  2364                                  ;-40 }
  2365                                  
  2366                                  
  2367                                  ;-41 int storeLabel() {
  2368                                  
  2369 00000C47 C3                       ret
  2370                                  ; ENDP
  2371 00000C48 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2372 00000C51 696E73747275637469-
  2373 00000C5A 6F6E20657870656374-
  2374 00000C63 656400             
  2375 00000C66 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2376 00000C6F 616C6C6F7765642061-
  2377 00000C78 74207374617274206F-
  2378 00000C81 66206C696E6500     
  2379                                  
  2380                                  storeLabel:  ; *** PROC ***
  2381                                  
  2382                                  ;-42   if(searchLabel()) error1("duplicate symbol");
  2383                                  
  2384 00000C88 E84800                   call searchLabel
  2385 00000C8B 08C0                     or  al, al
  2386 00000C8D 0F840900                 je @@storeLabel94
  2387 00000C91 68[C20C]                 push storeLabel_0
  2388 00000C94 E8870B                   call error1
  2389 00000C97 83C402                   add  sp, 2
  2390                                  
  2391                                  ;-43   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2392                                  
  2393                                  @@storeLabel94:
  2394 00000C9A 8D063075                 lea  ax, [Symbol]
  2395 00000C9E 50                       push ax
  2396 00000C9F FF36[4E00]               push word [LabelNamePtr]
  2397 00000CA3 E89211                   call strcpy
  2398 00000CA6 83C404                   add  sp, 4
  2399 00000CA9 A3[4E00]                 mov word [LabelNamePtr], ax
  2400                                  
  2401                                  ;-44   LabelNamePtr++;
  2402                                  
  2403 00000CAC FF06[4E00]               inc  word [LabelNamePtr]
  2404                                  
  2405                                  ;-45   LabelMaxIx++;
  2406                                  
  2407 00000CB0 FF06[5000]               inc  word [LabelMaxIx]
  2408                                  
  2409                                  ;-46   LabelAddr[LabelMaxIx] = PC;
  2410                                  
  2411 00000CB4 A1[3600]                 mov ax, [PC]
  2412 00000CB7 8B1E[5000]               mov bx, [LabelMaxIx]
  2413 00000CBB D1E3                     shl bx, 1
  2414 00000CBD 8987067B                 mov [LabelAddr+bx], ax
  2415                                  
  2416                                  ;-47 }
  2417                                  
  2418                                  
  2419                                  ;-48 int searchLabel() {
  2420                                  
  2421 00000CC1 C3                       ret
  2422                                  ; ENDP
  2423 00000CC2 6475706C6963617465-     storeLabel_0 db "duplicate symbol",0
  2424 00000CCB 2073796D626F6C00   
  2425                                  
  2426                                  searchLabel:  ; *** PROC ***
  2427                                  
  2428                                  ;-49   int LIx; char *p; int j;
  2429                                  
  2430                                  
  2431                                  ;-50   p = &LabelNames;
  2432                                  
  2433                                  ;Function : searchLabel, Number of local variables: 3
  2434                                  ;   # type sign width line used address name   list of local variables
  2435                                  ;  200 var sign word    49 NULL bp-2    LIx
  2436                                  ;  201 ptr sign byte    49 NULL bp-4    p
  2437                                  ;  202 var sign word    49 NULL bp-6    j;
  2438 00000CD3 C8060000                 ENTER  6,0
  2439 00000CD7 B81E77                   mov ax, LabelNames
  2440 00000CDA 8946FC                   mov word [bp-4], ax
  2441                                  
  2442                                  ;-51   LIx=1;
  2443                                  
  2444 00000CDD 66B801000000             mov eax, 1
  2445 00000CE3 8946FE                   mov word [bp-2], ax
  2446                                  
  2447                                  ;-52   while (LIx <= LabelMaxIx) {
  2448                                  
  2449                                  @@searchLabel95:
  2450 00000CE6 8B46FE                   mov ax, [bp-2]
  2451 00000CE9 3B06[5000]               cmp ax, [LabelMaxIx]
  2452 00000CED 0F8F3700                 jg  @@searchLabel96
  2453                                  
  2454                                  ;-53     if (eqstr(p, Symbol)) return LIx;//and searchType
  2455                                  
  2456 00000CF1 8D063075                 lea  ax, [Symbol]
  2457 00000CF5 50                       push ax
  2458 00000CF6 FF76FC                   push word [bp-4]
  2459 00000CF9 E8A811                   call eqstr
  2460 00000CFC 83C404                   add  sp, 4
  2461 00000CFF 08C0                     or  al, al
  2462 00000D01 0F840600                 je @@searchLabel97
  2463 00000D05 8B46FE                   mov ax, [bp-2]
  2464 00000D08 E92600                   jmp @@retn
  2465                                  
  2466                                  ;-54     j=strlen(p);
  2467                                  
  2468                                  @@searchLabel97:
  2469 00000D0B FF76FC                   push word [bp-4]
  2470 00000D0E E8FC10                   call strlen
  2471 00000D11 83C402                   add  sp, 2
  2472 00000D14 8946FA                   mov word [bp-6], ax
  2473                                  
  2474                                  ;-55     p=p+j; p++; LIx++;
  2475                                  
  2476 00000D17 8B46FC                   mov ax, [bp-4]
  2477 00000D1A 0346FA                   add ax, [bp-6]
  2478 00000D1D 8946FC                   mov word [bp-4], ax
  2479 00000D20 FF46FC                   inc  word [bp-4]
  2480 00000D23 FF46FE                   inc  word [bp-2]
  2481                                  
  2482                                  ;-56   }
  2483                                  
  2484                                  
  2485                                  ;-57   return 0;
  2486                                  
  2487 00000D26 EBBE                     jmp @@searchLabel95
  2488                                  @@searchLabel96:
  2489 00000D28 66B800000000             mov eax, 0
  2490 00000D2E E90000                   jmp @@retn
  2491                                  
  2492                                  ;-58 }
  2493                                  
  2494                                  
  2495                                  ;-59 int getVariable() { char c;
  2496                                  
  2497 00000D31 C9                      @@retn: LEAVE
  2498 00000D32 C3                       ret
  2499                                  ; ENDP
  2500                                  
  2501                                  getVariable:  ; *** PROC ***
  2502                                  
  2503                                  ;-60   storeLabel();
  2504                                  
  2505                                  ;Function : getVariable, Number of local variables: 1
  2506                                  ;   # type sign width line used address name   list of local variables
  2507                                  ;  200 var sign byte    59 NULL bp-2    c;
  2508 00000D33 C8020000                 ENTER  2,0
  2509 00000D37 E84EFF                   call storeLabel
  2510                                  
  2511                                  ;-61   getTokeType(); if(TokeType==ALNUME) {// getName
  2512                                  
  2513 00000D3A E8F7F6                   call getTokeType
  2514 00000D3D A0[3B00]                 mov al, [TokeType]
  2515 00000D40 3C03                     cmp al, 3
  2516 00000D42 0F85CC00                 jne @@getVariable98
  2517                                  
  2518                                  ;-62     lookCode();
  2519                                  
  2520 00000D46 E82201                   call lookCode
  2521                                  
  2522                                  ;-63     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2523                                  
  2524 00000D49 A0[3D00]                 mov al, [CodeType]
  2525 00000D4C 3CC8                     cmp al, 200
  2526 00000D4E 0F8D0900                 jge @@getVariable99
  2527 00000D52 68[1D0E]                 push getVariable_0
  2528 00000D55 E8F70B                   call errorexit
  2529 00000D58 83C402                   add  sp, 2
  2530                                  
  2531                                  ;-64     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2532                                  
  2533                                  @@getVariable99:
  2534 00000D5B A0[3D00]                 mov al, [CodeType]
  2535 00000D5E 3CCF                     cmp al, 207
  2536 00000D60 0F8E0900                 jle @@getVariable100
  2537 00000D64 68[350E]                 push getVariable_1
  2538 00000D67 E8E50B                   call errorexit
  2539 00000D6A 83C402                   add  sp, 2
  2540                                  
  2541                                  ;-65     if (CodeType== 200) {// DB
  2542                                  
  2543                                  @@getVariable100:
  2544 00000D6D A0[3D00]                 mov al, [CodeType]
  2545 00000D70 3CC8                     cmp al, 200
  2546 00000D72 0F856A00                 jne @@getVariable101
  2547                                  
  2548                                  ;-66       do { getTokeType();
  2549                                  
  2550                                  @@getVariable102:
  2551 00000D76 E8BBF6                   call getTokeType
  2552                                  
  2553                                  ;-67         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2554                                  
  2555 00000D79 A0[3B00]                 mov al, [TokeType]
  2556 00000D7C 3C01                     cmp al, 1
  2557 00000D7E 0F850D00                 jne @@getVariable103
  2558 00000D82 FF36[2500]               push word [SymbolInt]
  2559 00000D86 E87BFC                   call genCode8
  2560 00000D89 83C402                   add  sp, 2
  2561                                  
  2562                                  ;-68         else {
  2563                                  
  2564 00000D8C E94100                   jmp @@getVariable104
  2565                                  @@getVariable103:
  2566                                  
  2567                                  ;-69           skipBlank();
  2568                                  
  2569 00000D8F E82002                   call skipBlank
  2570                                  
  2571                                  ;-70           if (isToken('"')) {
  2572                                  
  2573 00000D92 6A22                     push 34
  2574 00000D94 E8FEFB                   call isToken
  2575 00000D97 83C402                   add  sp, 2
  2576 00000D9A 08C0                     or  al, al
  2577 00000D9C 0F843000                 je @@getVariable105
  2578                                  
  2579                                  ;-71             do { c= *InputPtr;
  2580                                  
  2581                                  @@getVariable106:
  2582 00000DA0 8B1E[2700]               mov bx, [InputPtr]
  2583 00000DA4 8A07                     mov al, [bx]
  2584 00000DA6 B400                     mov ah, 0
  2585 00000DA8 8846FE                   mov byte [bp-2], al
  2586                                  
  2587                                  ;-72               genCode8(c);
  2588                                  
  2589 00000DAB 8A46FE                   mov al, byte [bp-2]
  2590 00000DAE B400                     mov ah, 0
  2591 00000DB0 50                       push ax
  2592 00000DB1 E850FC                   call genCode8
  2593 00000DB4 83C402                   add  sp, 2
  2594                                  
  2595                                  ;-73               InputPtr++;
  2596                                  
  2597 00000DB7 FF06[2700]               inc  word [InputPtr]
  2598                                  
  2599                                  ;-74             } while (*InputPtr != '"' );
  2600                                  
  2601 00000DBB 8B1E[2700]               mov bx, [InputPtr]
  2602 00000DBF 8A07                     mov al, [bx]
  2603 00000DC1 B400                     mov ah, 0
  2604 00000DC3 83F822                   cmp ax, 34
  2605 00000DC6 0F840200                 je  @@getVariable107
  2606 00000DCA EBD4                     jmp @@getVariable106
  2607                                  @@getVariable107:
  2608                                  
  2609                                  ;-75             InputPtr++;
  2610                                  
  2611 00000DCC FF06[2700]               inc  word [InputPtr]
  2612                                  
  2613                                  ;-76           }
  2614                                  
  2615                                  
  2616                                  ;-77         }
  2617                                  
  2618                                  @@getVariable105:
  2619                                  
  2620                                  ;-78       } while (isToken(','));
  2621                                  
  2622                                  @@getVariable104:
  2623 00000DD0 6A2C                     push 44
  2624 00000DD2 E8C0FB                   call isToken
  2625 00000DD5 83C402                   add  sp, 2
  2626 00000DD8 08C0                     or  al, al
  2627 00000DDA 0F840200                 je @@getVariable108
  2628 00000DDE EB96                     jmp @@getVariable102
  2629                                  @@getVariable108:
  2630                                  
  2631                                  ;-79     }
  2632                                  
  2633                                  
  2634                                  ;-80     if (CodeType== 201) {// DW
  2635                                  
  2636                                  @@getVariable101:
  2637 00000DE0 A0[3D00]                 mov al, [CodeType]
  2638 00000DE3 3CC9                     cmp al, 201
  2639 00000DE5 0F852600                 jne @@getVariable109
  2640                                  
  2641                                  ;-81       do { getTokeType();
  2642                                  
  2643                                  @@getVariable110:
  2644 00000DE9 E848F6                   call getTokeType
  2645                                  
  2646                                  ;-82         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2647                                  
  2648 00000DEC A0[3B00]                 mov al, [TokeType]
  2649 00000DEF 3C01                     cmp al, 1
  2650 00000DF1 0F850A00                 jne @@getVariable111
  2651 00000DF5 FF36[2500]               push word [SymbolInt]
  2652 00000DF9 E83AFC                   call genCode16
  2653 00000DFC 83C402                   add  sp, 2
  2654                                  
  2655                                  ;-83       } while (isToken(','));
  2656                                  
  2657                                  @@getVariable111:
  2658 00000DFF 6A2C                     push 44
  2659 00000E01 E891FB                   call isToken
  2660 00000E04 83C402                   add  sp, 2
  2661 00000E07 08C0                     or  al, al
  2662 00000E09 0F840200                 je @@getVariable112
  2663 00000E0D EBDA                     jmp @@getVariable110
  2664                                  @@getVariable112:
  2665                                  
  2666                                  ;-84     }
  2667                                  
  2668                                  
  2669                                  ;-85   }
  2670                                  
  2671                                  @@getVariable109:
  2672                                  
  2673                                  ;-86   else errorexit("DB,DW,DD or RESB,W,D expected");
  2674                                  
  2675 00000E0F E90900                   jmp @@getVariable113
  2676                                  @@getVariable98:
  2677 00000E12 68[4D0E]                 push getVariable_2
  2678 00000E15 E8370B                   call errorexit
  2679 00000E18 83C402                   add  sp, 2
  2680                                  
  2681                                  ;-87 }
  2682                                  
  2683                                  @@getVariable113:
  2684                                  
  2685                                  ;-88 int lookCode() { // ret: CodeType, *OpCodePtr
  2686 00000E1B C9                       LEAVE
  2687 00000E1C C3                       ret
  2688                                  ; ENDP
  2689 00000E1D 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2690 00000E26 422C572C4420657870-
  2691 00000E2F 656374656400       
  2692 00000E35 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2693 00000E3E 422C572C4420657870-
  2694 00000E47 656374656400       
  2695 00000E4D 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2696 00000E56 6F7220524553422C57-
  2697 00000E5F 2C4420657870656374-
  2698 00000E68 656400             
  2699                                  
  2700                                  lookCode:  ; *** PROC ***
  2701                                  
  2702                                  ;-89   CodeType=0;
  2703                                  
  2704 00000E6B 66B800000000             mov eax, 0
  2705 00000E71 A2[3D00]                 mov byte [CodeType], al
  2706                                  
  2707                                  ;-90   OpCodePtr= &I_START;
  2708                                  
  2709 00000E74 B8[5A00]                 mov ax, I_START
  2710 00000E77 A3[4B00]                 mov word [OpCodePtr], ax
  2711                                  
  2712                                  ;-91   OpCodePtr++;
  2713                                  
  2714 00000E7A FF06[4B00]               inc  word [OpCodePtr]
  2715                                  
  2716                                  ;-92   do  {
  2717                                  
  2718                                  @@lookCode114:
  2719                                  
  2720                                  ;-93     if (eqstr(SymbolUpper, OpCodePtr))  {
  2721                                  
  2722 00000E7E FF36[4B00]               push word [OpCodePtr]
  2723 00000E82 8D068075                 lea  ax, [SymbolUpper]
  2724 00000E86 50                       push ax
  2725 00000E87 E81A10                   call eqstr
  2726 00000E8A 83C404                   add  sp, 4
  2727 00000E8D 08C0                     or  al, al
  2728 00000E8F 0F842700                 je @@lookCode115
  2729                                  
  2730                                  ;-94       while(*OpCodePtr!=0) OpCodePtr++;
  2731                                  
  2732                                  @@lookCode116:
  2733 00000E93 8B1E[4B00]               mov bx, [OpCodePtr]
  2734 00000E97 8A07                     mov al, [bx]
  2735 00000E99 B400                     mov ah, 0
  2736 00000E9B 83F800                   cmp ax, 0
  2737 00000E9E 0F840600                 je  @@lookCode117
  2738 00000EA2 FF06[4B00]               inc  word [OpCodePtr]
  2739                                  
  2740                                  ;-95       OpCodePtr++; CodeType =*OpCodePtr;
  2741                                  
  2742 00000EA6 EBEB                     jmp @@lookCode116
  2743                                  @@lookCode117:
  2744 00000EA8 FF06[4B00]               inc  word [OpCodePtr]
  2745 00000EAC 8B1E[4B00]               mov bx, [OpCodePtr]
  2746 00000EB0 8A07                     mov al, [bx]
  2747 00000EB2 B400                     mov ah, 0
  2748 00000EB4 A2[3D00]                 mov byte [CodeType], al
  2749                                  
  2750                                  ;-96       return;
  2751                                  
  2752 00000EB7 E92A00                   jmp @@retn
  2753                                  
  2754                                  ;-97     }
  2755                                  
  2756                                  
  2757                                  ;-98   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2758                                  
  2759                                  @@lookCode115:
  2760                                  @@lookCode118:
  2761 00000EBA 8B1E[4B00]               mov bx, [OpCodePtr]
  2762 00000EBE 8A07                     mov al, [bx]
  2763 00000EC0 B400                     mov ah, 0
  2764 00000EC2 3DF100                   cmp ax, 241
  2765 00000EC5 0F840600                 je  @@lookCode119
  2766 00000EC9 FF06[4B00]               inc  word [OpCodePtr]
  2767                                  
  2768                                  ;-99   OpCodePtr++;
  2769                                  
  2770 00000ECD EBEB                     jmp @@lookCode118
  2771                                  @@lookCode119:
  2772 00000ECF FF06[4B00]               inc  word [OpCodePtr]
  2773                                  
  2774                                  ;-100   } while(*OpCodePtr!=0);
  2775                                  
  2776 00000ED3 8B1E[4B00]               mov bx, [OpCodePtr]
  2777 00000ED7 8A07                     mov al, [bx]
  2778 00000ED9 B400                     mov ah, 0
  2779 00000EDB 83F800                   cmp ax, 0
  2780 00000EDE 0F840200                 je  @@lookCode120
  2781 00000EE2 EB9A                     jmp @@lookCode114
  2782                                  @@lookCode120:
  2783                                  
  2784                                  ;-101 }
  2785                                  
  2786                                  @@retn:
  2787 00000EE4 C3                       ret
  2788                                  ; ENDP
  2789                                  ;Back to main program: AS.C
  2790                                  
  2791                                  ;-206 #include "HELPER.C"
  2792                                  
  2793                                  ;Use include file: HELPER.C
  2794                                  
  2795                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2796                                  
  2797                                  
  2798                                  getLine:  ; *** PROC ***
  2799                                  
  2800                                  ;-2   InputPtr= &InputBuf;
  2801                                  
  2802 00000EE5 B8D075                   mov ax, InputBuf
  2803 00000EE8 A3[2700]                 mov word [InputPtr], ax
  2804                                  
  2805                                  ;-3   *InputPtr=0;//if last line is empty
  2806                                  
  2807 00000EEB 66B800000000             mov eax, 0
  2808 00000EF1 8B1E[2700]               mov  bx, [InputPtr]
  2809 00000EF5 8807                     mov  [bx], al
  2810                                  
  2811                                  ;-4   do {
  2812                                  
  2813                                  @@getLine121:
  2814                                  
  2815                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2816                                  
  2817 00000EF7 6A01                     push 1
  2818 00000EF9 FF36[2900]               push word [asm_fd]
  2819 00000EFD 8D06[3500]               lea  ax, [DOS_ByteRead]
  2820 00000F01 50                       push ax
  2821 00000F02 E83A10                   call readRL
  2822 00000F05 83C406                   add  sp, 6
  2823 00000F08 A3[3300]                 mov word [DOS_NoBytes], ax
  2824                                  
  2825                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  2826                                  
  2827 00000F0B A1[2F00]                 mov ax, [DOS_ERR]
  2828 00000F0E 08C0                     or  al, al
  2829 00000F10 0F840900                 je @@getLine122
  2830 00000F14 68[5C0F]                 push getLine_0
  2831 00000F17 E8350A                   call errorexit
  2832 00000F1A 83C402                   add  sp, 2
  2833                                  
  2834                                  ;-7     if (DOS_NoBytes == 0) return;
  2835                                  
  2836                                  @@getLine122:
  2837 00000F1D A1[3300]                 mov ax, [DOS_NoBytes]
  2838 00000F20 83F800                   cmp ax, 0
  2839 00000F23 0F850300                 jne @@getLine123
  2840 00000F27 E93100                   jmp @@retn
  2841                                  
  2842                                  ;-8     *InputPtr = DOS_ByteRead;
  2843                                  
  2844                                  @@getLine123:
  2845 00000F2A A0[3500]                 mov al, [DOS_ByteRead]
  2846 00000F2D 8B1E[2700]               mov  bx, [InputPtr]
  2847 00000F31 8807                     mov  [bx], al
  2848                                  
  2849                                  ;-9     InputPtr++;
  2850                                  
  2851 00000F33 FF06[2700]               inc  word [InputPtr]
  2852                                  
  2853                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  2854                                  
  2855 00000F37 A0[3500]                 mov al, byte [DOS_ByteRead]
  2856 00000F3A B400                     mov ah, 0
  2857 00000F3C 50                       push ax
  2858 00000F3D E82B00                   call ifEOL
  2859 00000F40 83C402                   add  sp, 2
  2860 00000F43 3C00                     cmp al, 0
  2861 00000F45 0F850200                 jne @@getLine124
  2862 00000F49 EBAC                     jmp @@getLine121
  2863                                  @@getLine124:
  2864                                  
  2865                                  ;-11   InputPtr--;
  2866                                  
  2867 00000F4B FF0E[2700]               dec  word [InputPtr]
  2868                                  
  2869                                  ;-12   *InputPtr=0;
  2870                                  
  2871 00000F4F 66B800000000             mov eax, 0
  2872 00000F55 8B1E[2700]               mov  bx, [InputPtr]
  2873 00000F59 8807                     mov  [bx], al
  2874                                  
  2875                                  ;-13 }
  2876                                  
  2877                                  
  2878                                  ;-14 int ifEOL(char c) {
  2879                                  
  2880                                  @@retn:
  2881 00000F5B C3                       ret
  2882                                  ; ENDP
  2883 00000F5C 52656164696E672053-     getLine_0 db "Reading Source",0
  2884 00000F65 6F7572636500       
  2885                                  
  2886                                  ifEOL:  ; *** PROC ***
  2887                                  
  2888                                  ;-15   if (c == 10) return 1;
  2889                                  
  2890                                  ;Function : ifEOL, Number of local variables: 1
  2891                                  ;   # type sign width line used address name   list of local variables
  2892                                  ;  200 var sign byte    14 NULL bp+4    c;
  2893 00000F6B C8000000                 ENTER  0,0
  2894 00000F6F 8A4604                   mov al, [bp+4]
  2895 00000F72 3C0A                     cmp al, 10
  2896 00000F74 0F850900                 jne @@ifEOL125
  2897 00000F78 66B801000000             mov eax, 1
  2898 00000F7E E92F00                   jmp @@retn
  2899                                  
  2900                                  ;-16   if (c == 13) {
  2901                                  
  2902                                  @@ifEOL125:
  2903 00000F81 8A4604                   mov al, [bp+4]
  2904 00000F84 3C0D                     cmp al, 13
  2905 00000F86 0F851D00                 jne @@ifEOL126
  2906                                  
  2907                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2908                                  
  2909 00000F8A 6A01                     push 1
  2910 00000F8C FF36[2900]               push word [asm_fd]
  2911 00000F90 8D06[3500]               lea  ax, [DOS_ByteRead]
  2912 00000F94 50                       push ax
  2913 00000F95 E8A70F                   call readRL
  2914 00000F98 83C406                   add  sp, 6
  2915 00000F9B A3[3300]                 mov word [DOS_NoBytes], ax
  2916                                  
  2917                                  ;-18     return 1;}
  2918                                  
  2919 00000F9E 66B801000000             mov eax, 1
  2920 00000FA4 E90900                   jmp @@retn
  2921                                  
  2922                                  ;-19   return 0;
  2923                                  
  2924                                  @@ifEOL126:
  2925 00000FA7 66B800000000             mov eax, 0
  2926 00000FAD E90000                   jmp @@retn
  2927                                  
  2928                                  ;-20 }
  2929                                  
  2930                                  
  2931                                  ;-21 int skipBlank() {
  2932                                  
  2933 00000FB0 C9                      @@retn: LEAVE
  2934 00000FB1 C3                       ret
  2935                                  ; ENDP
  2936                                  
  2937                                  skipBlank:  ; *** PROC ***
  2938                                  
  2939                                  ;-22   skipblank1:
  2940                                  
  2941                                  @@skipblank1:
  2942                                  
  2943                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2944                                  
  2945 00000FB2 8B1E[2700]               mov bx, [InputPtr]
  2946 00000FB6 8A07                     mov al, [bx]
  2947 00000FB8 B400                     mov ah, 0
  2948 00000FBA 83F820                   cmp ax, 32
  2949 00000FBD 0F850600                 jne @@skipBlank127
  2950 00000FC1 FF06[2700]               inc  word [InputPtr]
  2951 00000FC5 EBEB                     jmp @@skipblank1
  2952                                  
  2953                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2954                                  
  2955                                  @@skipBlank127:
  2956 00000FC7 8B1E[2700]               mov bx, [InputPtr]
  2957 00000FCB 8A07                     mov al, [bx]
  2958 00000FCD B400                     mov ah, 0
  2959 00000FCF 83F809                   cmp ax, 9
  2960 00000FD2 0F850600                 jne @@skipBlank128
  2961 00000FD6 FF06[2700]               inc  word [InputPtr]
  2962 00000FDA EBD6                     jmp @@skipblank1
  2963                                  
  2964                                  ;-25 }
  2965                                  
  2966                                  @@skipBlank128:
  2967                                  
  2968                                  ;-26 int letterE(char c) {
  2969                                  
  2970 00000FDC C3                       ret
  2971                                  ; ENDP
  2972                                  
  2973                                  letterE:  ; *** PROC ***
  2974                                  
  2975                                  ;-27   if (c=='_') return 1;
  2976                                  
  2977                                  ;Function : letterE, Number of local variables: 1
  2978                                  ;   # type sign width line used address name   list of local variables
  2979                                  ;  200 var sign byte    26 NULL bp+4    c;
  2980 00000FDD C8000000                 ENTER  0,0
  2981 00000FE1 8A4604                   mov al, [bp+4]
  2982 00000FE4 3C5F                     cmp al, 95
  2983 00000FE6 0F850900                 jne @@letterE129
  2984 00000FEA 66B801000000             mov eax, 1
  2985 00000FF0 E95A00                   jmp @@retn
  2986                                  
  2987                                  ;-28   if (c=='.') return 1;
  2988                                  
  2989                                  @@letterE129:
  2990 00000FF3 8A4604                   mov al, [bp+4]
  2991 00000FF6 3C2E                     cmp al, 46
  2992 00000FF8 0F850900                 jne @@letterE130
  2993 00000FFC 66B801000000             mov eax, 1
  2994 00001002 E94800                   jmp @@retn
  2995                                  
  2996                                  ;-29   if (c> 'z') return 0;
  2997                                  
  2998                                  @@letterE130:
  2999 00001005 8A4604                   mov al, [bp+4]
  3000 00001008 3C7A                     cmp al, 122
  3001 0000100A 0F8E0900                 jle @@letterE131
  3002 0000100E 66B800000000             mov eax, 0
  3003 00001014 E93600                   jmp @@retn
  3004                                  
  3005                                  ;-30   if (c< '@') return 0; // at included
  3006                                  
  3007                                  @@letterE131:
  3008 00001017 8A4604                   mov al, [bp+4]
  3009 0000101A 3C40                     cmp al, 64
  3010 0000101C 0F8D0900                 jge @@letterE132
  3011 00001020 66B800000000             mov eax, 0
  3012 00001026 E92400                   jmp @@retn
  3013                                  
  3014                                  ;-31   if (c> 'Z') { if (c< 'a') return 0; }
  3015                                  
  3016                                  @@letterE132:
  3017 00001029 8A4604                   mov al, [bp+4]
  3018 0000102C 3C5A                     cmp al, 90
  3019 0000102E 0F8E1200                 jle @@letterE133
  3020 00001032 8A4604                   mov al, [bp+4]
  3021 00001035 3C61                     cmp al, 97
  3022 00001037 0F8D0900                 jge @@letterE134
  3023 0000103B 66B800000000             mov eax, 0
  3024 00001041 E90900                   jmp @@retn
  3025                                  @@letterE134:
  3026                                  
  3027                                  ;-32   return 1;
  3028                                  
  3029                                  @@letterE133:
  3030 00001044 66B801000000             mov eax, 1
  3031 0000104A E90000                   jmp @@retn
  3032                                  
  3033                                  ;-33 }
  3034                                  
  3035                                  
  3036                                  ;-34 int alnumE(char c) {
  3037                                  
  3038 0000104D C9                      @@retn: LEAVE
  3039 0000104E C3                       ret
  3040                                  ; ENDP
  3041                                  
  3042                                  alnumE:  ; *** PROC ***
  3043                                  
  3044                                  ;-35   if (digit(c)) return 1;
  3045                                  
  3046                                  ;Function : alnumE, Number of local variables: 1
  3047                                  ;   # type sign width line used address name   list of local variables
  3048                                  ;  200 var sign byte    34 NULL bp+4    c;
  3049 0000104F C8000000                 ENTER  0,0
  3050 00001053 8A4604                   mov al, byte [bp+4]
  3051 00001056 B400                     mov ah, 0
  3052 00001058 50                       push ax
  3053 00001059 E8150E                   call digit
  3054 0000105C 83C402                   add  sp, 2
  3055 0000105F 08C0                     or  al, al
  3056 00001061 0F840900                 je @@alnumE135
  3057 00001065 66B801000000             mov eax, 1
  3058 0000106B E92400                   jmp @@retn
  3059                                  
  3060                                  ;-36   if (letterE(c)) return 1;
  3061                                  
  3062                                  @@alnumE135:
  3063 0000106E 8A4604                   mov al, byte [bp+4]
  3064 00001071 B400                     mov ah, 0
  3065 00001073 50                       push ax
  3066 00001074 E866FF                   call letterE
  3067 00001077 83C402                   add  sp, 2
  3068 0000107A 08C0                     or  al, al
  3069 0000107C 0F840900                 je @@alnumE136
  3070 00001080 66B801000000             mov eax, 1
  3071 00001086 E90900                   jmp @@retn
  3072                                  
  3073                                  ;-37   return 0;
  3074                                  
  3075                                  @@alnumE136:
  3076 00001089 66B800000000             mov eax, 0
  3077 0000108F E90000                   jmp @@retn
  3078                                  
  3079                                  ;-38 }
  3080                                  
  3081                                  
  3082                                  ;-39 int getDigit(unsigned char c) {//ret: SymbolInt
  3083                                  
  3084 00001092 C9                      @@retn: LEAVE
  3085 00001093 C3                       ret
  3086                                  ; ENDP
  3087                                  
  3088                                  getDigit:  ; *** PROC ***
  3089                                  
  3090                                  ;-40   unsigned int CastInt;
  3091                                  
  3092                                  
  3093                                  ;-41   SymbolInt=0;
  3094                                  
  3095                                  ;Function : getDigit, Number of local variables: 2
  3096                                  ;   # type sign width line used address name   list of local variables
  3097                                  ;  200 var unsg byte    39 NULL bp+4    c
  3098                                  ;  201 var unsg word    40 NULL bp-2    CastInt;
  3099 00001094 C8020000                 ENTER  2,0
  3100 00001098 66B800000000             mov eax, 0
  3101 0000109E A3[2500]                 mov word [SymbolInt], ax
  3102                                  
  3103                                  ;-42   do {
  3104                                  
  3105                                  @@getDigit137:
  3106                                  
  3107                                  ;-43     c-='0';
  3108                                  
  3109 000010A1 806E0430                 sub  byte [bp+4], 48
  3110                                  
  3111                                  ;-44     SymbolInt=SymbolInt*10;
  3112                                  
  3113 000010A5 A1[2500]                 mov ax, [SymbolInt]
  3114 000010A8 66BB0A000000             mov ebx, 10
  3115 000010AE 66F7E3                   mul ebx
  3116 000010B1 A3[2500]                 mov word [SymbolInt], ax
  3117                                  
  3118                                  ;-45     ax=0; CastInt=c; //cast b2w
  3119                                  
  3120 000010B4 B80000                   mov  ax, 0
  3121 000010B7 8A4604                   mov al, [bp+4]
  3122 000010BA 8946FE                   mov word [bp-2], ax
  3123                                  
  3124                                  ;-46     SymbolInt=SymbolInt+CastInt;
  3125                                  
  3126 000010BD A1[2500]                 mov ax, [SymbolInt]
  3127 000010C0 0346FE                   add ax, [bp-2]
  3128 000010C3 A3[2500]                 mov word [SymbolInt], ax
  3129                                  
  3130                                  ;-47     InputPtr++;
  3131                                  
  3132 000010C6 FF06[2700]               inc  word [InputPtr]
  3133                                  
  3134                                  ;-48     c = *InputPtr;
  3135                                  
  3136 000010CA 8B1E[2700]               mov bx, [InputPtr]
  3137 000010CE 8A07                     mov al, [bx]
  3138 000010D0 B400                     mov ah, 0
  3139 000010D2 884604                   mov byte [bp+4], al
  3140                                  
  3141                                  ;-49   } while(digit(c));
  3142                                  
  3143 000010D5 8A4604                   mov al, byte [bp+4]
  3144 000010D8 B400                     mov ah, 0
  3145 000010DA 50                       push ax
  3146 000010DB E8930D                   call digit
  3147 000010DE 83C402                   add  sp, 2
  3148 000010E1 08C0                     or  al, al
  3149 000010E3 0F840200                 je @@getDigit138
  3150 000010E7 EBB8                     jmp @@getDigit137
  3151                                  @@getDigit138:
  3152                                  
  3153                                  ;-50 }
  3154                                  
  3155                                  
  3156                                  ;-51 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3157 000010E9 C9                       LEAVE
  3158 000010EA C3                       ret
  3159                                  ; ENDP
  3160                                  
  3161                                  getName:  ; *** PROC ***
  3162                                  
  3163                                  ;-52   char *p;
  3164                                  
  3165                                  
  3166                                  ;-53   p = &Symbol;
  3167                                  
  3168                                  ;Function : getName, Number of local variables: 2
  3169                                  ;   # type sign width line used address name   list of local variables
  3170                                  ;  200 var unsg byte    51 NULL bp+4    c
  3171                                  ;  201 ptr sign byte    52 NULL bp-2    p;
  3172 000010EB C8020000                 ENTER  2,0
  3173 000010EF B83075                   mov ax, Symbol
  3174 000010F2 8946FE                   mov word [bp-2], ax
  3175                                  
  3176                                  ;-54   *p = c;
  3177                                  
  3178 000010F5 8A4604                   mov al, [bp+4]
  3179 000010F8 8B5EFE                   mov  bx, [bp-2]
  3180 000010FB 8807                     mov  [bx], al
  3181                                  
  3182                                  ;-55   p++;
  3183                                  
  3184 000010FD FF46FE                   inc  word [bp-2]
  3185                                  
  3186                                  ;-56   while (alnumE(c)) {
  3187                                  
  3188                                  @@getName139:
  3189 00001100 8A4604                   mov al, byte [bp+4]
  3190 00001103 B400                     mov ah, 0
  3191 00001105 50                       push ax
  3192 00001106 E846FF                   call alnumE
  3193 00001109 83C402                   add  sp, 2
  3194 0000110C 08C0                     or  al, al
  3195 0000110E 0F841C00                 je @@getName140
  3196                                  
  3197                                  ;-57     InputPtr++;
  3198                                  
  3199 00001112 FF06[2700]               inc  word [InputPtr]
  3200                                  
  3201                                  ;-58     c = *InputPtr;
  3202                                  
  3203 00001116 8B1E[2700]               mov bx, [InputPtr]
  3204 0000111A 8A07                     mov al, [bx]
  3205 0000111C B400                     mov ah, 0
  3206 0000111E 884604                   mov byte [bp+4], al
  3207                                  
  3208                                  ;-59     *p = c;
  3209                                  
  3210 00001121 8A4604                   mov al, [bp+4]
  3211 00001124 8B5EFE                   mov  bx, [bp-2]
  3212 00001127 8807                     mov  [bx], al
  3213                                  
  3214                                  ;-60     p++;
  3215                                  
  3216 00001129 FF46FE                   inc  word [bp-2]
  3217                                  
  3218                                  ;-61   }
  3219                                  
  3220                                  
  3221                                  ;-62   if (c == ':') isLabel=1; else isLabel=0;
  3222                                  
  3223 0000112C EBD2                     jmp @@getName139
  3224                                  @@getName140:
  3225 0000112E 8A4604                   mov al, [bp+4]
  3226 00001131 3C3A                     cmp al, 58
  3227 00001133 0F850C00                 jne @@getName141
  3228 00001137 66B801000000             mov eax, 1
  3229 0000113D A2[3A00]                 mov byte [isLabel], al
  3230 00001140 E90900                   jmp @@getName142
  3231                                  @@getName141:
  3232 00001143 66B800000000             mov eax, 0
  3233 00001149 A2[3A00]                 mov byte [isLabel], al
  3234                                  
  3235                                  ;-63   p--;
  3236                                  
  3237                                  @@getName142:
  3238 0000114C FF4EFE                   dec  word [bp-2]
  3239                                  
  3240                                  ;-64   *p = 0;
  3241                                  
  3242 0000114F 66B800000000             mov eax, 0
  3243 00001155 8B5EFE                   mov  bx, [bp-2]
  3244 00001158 8807                     mov  [bx], al
  3245                                  
  3246                                  ;-65   strcpy(SymbolUpper, Symbol);
  3247                                  
  3248 0000115A 8D063075                 lea  ax, [Symbol]
  3249 0000115E 50                       push ax
  3250 0000115F 8D068075                 lea  ax, [SymbolUpper]
  3251 00001163 50                       push ax
  3252 00001164 E8D10C                   call strcpy
  3253 00001167 83C404                   add  sp, 4
  3254                                  
  3255                                  ;-66   toupper(SymbolUpper);
  3256                                  
  3257 0000116A 8D068075                 lea  ax, [SymbolUpper]
  3258 0000116E 50                       push ax
  3259 0000116F E8580C                   call toupper
  3260 00001172 83C402                   add  sp, 2
  3261                                  
  3262                                  ;-67 }
  3263                                  
  3264                                  
  3265                                  ;-68 int testReg() {
  3266 00001175 C9                       LEAVE
  3267 00001176 C3                       ret
  3268                                  ; ENDP
  3269                                  
  3270                                  testReg:  ; *** PROC ***
  3271                                  
  3272                                  ;-69 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3273                                  
  3274                                  
  3275                                  ;-70   RegType=0;
  3276                                  
  3277 00001177 66B800000000             mov eax, 0
  3278 0000117D A2[3E00]                 mov byte [RegType], al
  3279                                  
  3280                                  ;-71   if (strlen(Symbol) < 2) return 0;
  3281                                  
  3282 00001180 8D063075                 lea  ax, [Symbol]
  3283 00001184 50                       push ax
  3284 00001185 E8850C                   call strlen
  3285 00001188 83C402                   add  sp, 2
  3286 0000118B 3C02                     cmp al, 2
  3287 0000118D 0F8D0900                 jge @@testReg143
  3288 00001191 66B800000000             mov eax, 0
  3289 00001197 E9B603                   jmp @@retn
  3290                                  
  3291                                  ;-72   if (strlen(Symbol) > 3) return 0;
  3292                                  
  3293                                  @@testReg143:
  3294 0000119A 8D063075                 lea  ax, [Symbol]
  3295 0000119E 50                       push ax
  3296 0000119F E86B0C                   call strlen
  3297 000011A2 83C402                   add  sp, 2
  3298 000011A5 3C03                     cmp al, 3
  3299 000011A7 0F8E0900                 jle @@testReg144
  3300 000011AB 66B800000000             mov eax, 0
  3301 000011B1 E99C03                   jmp @@retn
  3302                                  
  3303                                  ;-73   RegType=BYTE;
  3304                                  
  3305                                  @@testReg144:
  3306 000011B4 66B801000000             mov eax, 1
  3307 000011BA A2[3E00]                 mov byte [RegType], al
  3308                                  
  3309                                  ;-74   if (eqstr(SymbolUpper, "AL")) return 0;
  3310                                  
  3311 000011BD 68[5115]                 push testReg_0
  3312 000011C0 8D068075                 lea  ax, [SymbolUpper]
  3313 000011C4 50                       push ax
  3314 000011C5 E8DC0C                   call eqstr
  3315 000011C8 83C404                   add  sp, 4
  3316 000011CB 08C0                     or  al, al
  3317 000011CD 0F840900                 je @@testReg145
  3318 000011D1 66B800000000             mov eax, 0
  3319 000011D7 E97603                   jmp @@retn
  3320                                  
  3321                                  ;-75   if (eqstr(SymbolUpper, "CL")) return 1;
  3322                                  
  3323                                  @@testReg145:
  3324 000011DA 68[5415]                 push testReg_1
  3325 000011DD 8D068075                 lea  ax, [SymbolUpper]
  3326 000011E1 50                       push ax
  3327 000011E2 E8BF0C                   call eqstr
  3328 000011E5 83C404                   add  sp, 4
  3329 000011E8 08C0                     or  al, al
  3330 000011EA 0F840900                 je @@testReg146
  3331 000011EE 66B801000000             mov eax, 1
  3332 000011F4 E95903                   jmp @@retn
  3333                                  
  3334                                  ;-76   if (eqstr(SymbolUpper, "DL")) return 2;
  3335                                  
  3336                                  @@testReg146:
  3337 000011F7 68[5715]                 push testReg_2
  3338 000011FA 8D068075                 lea  ax, [SymbolUpper]
  3339 000011FE 50                       push ax
  3340 000011FF E8A20C                   call eqstr
  3341 00001202 83C404                   add  sp, 4
  3342 00001205 08C0                     or  al, al
  3343 00001207 0F840900                 je @@testReg147
  3344 0000120B 66B802000000             mov eax, 2
  3345 00001211 E93C03                   jmp @@retn
  3346                                  
  3347                                  ;-77   if (eqstr(SymbolUpper, "BL")) return 3;
  3348                                  
  3349                                  @@testReg147:
  3350 00001214 68[5A15]                 push testReg_3
  3351 00001217 8D068075                 lea  ax, [SymbolUpper]
  3352 0000121B 50                       push ax
  3353 0000121C E8850C                   call eqstr
  3354 0000121F 83C404                   add  sp, 4
  3355 00001222 08C0                     or  al, al
  3356 00001224 0F840900                 je @@testReg148
  3357 00001228 66B803000000             mov eax, 3
  3358 0000122E E91F03                   jmp @@retn
  3359                                  
  3360                                  ;-78   if (eqstr(SymbolUpper, "AH")) return 4;
  3361                                  
  3362                                  @@testReg148:
  3363 00001231 68[5D15]                 push testReg_4
  3364 00001234 8D068075                 lea  ax, [SymbolUpper]
  3365 00001238 50                       push ax
  3366 00001239 E8680C                   call eqstr
  3367 0000123C 83C404                   add  sp, 4
  3368 0000123F 08C0                     or  al, al
  3369 00001241 0F840900                 je @@testReg149
  3370 00001245 66B804000000             mov eax, 4
  3371 0000124B E90203                   jmp @@retn
  3372                                  
  3373                                  ;-79   if (eqstr(SymbolUpper, "CH")) return 5;
  3374                                  
  3375                                  @@testReg149:
  3376 0000124E 68[6015]                 push testReg_5
  3377 00001251 8D068075                 lea  ax, [SymbolUpper]
  3378 00001255 50                       push ax
  3379 00001256 E84B0C                   call eqstr
  3380 00001259 83C404                   add  sp, 4
  3381 0000125C 08C0                     or  al, al
  3382 0000125E 0F840900                 je @@testReg150
  3383 00001262 66B805000000             mov eax, 5
  3384 00001268 E9E502                   jmp @@retn
  3385                                  
  3386                                  ;-80   if (eqstr(SymbolUpper, "DH")) return 6;
  3387                                  
  3388                                  @@testReg150:
  3389 0000126B 68[6315]                 push testReg_6
  3390 0000126E 8D068075                 lea  ax, [SymbolUpper]
  3391 00001272 50                       push ax
  3392 00001273 E82E0C                   call eqstr
  3393 00001276 83C404                   add  sp, 4
  3394 00001279 08C0                     or  al, al
  3395 0000127B 0F840900                 je @@testReg151
  3396 0000127F 66B806000000             mov eax, 6
  3397 00001285 E9C802                   jmp @@retn
  3398                                  
  3399                                  ;-81   if (eqstr(SymbolUpper, "BH")) return 7;
  3400                                  
  3401                                  @@testReg151:
  3402 00001288 68[6615]                 push testReg_7
  3403 0000128B 8D068075                 lea  ax, [SymbolUpper]
  3404 0000128F 50                       push ax
  3405 00001290 E8110C                   call eqstr
  3406 00001293 83C404                   add  sp, 4
  3407 00001296 08C0                     or  al, al
  3408 00001298 0F840900                 je @@testReg152
  3409 0000129C 66B807000000             mov eax, 7
  3410 000012A2 E9AB02                   jmp @@retn
  3411                                  
  3412                                  ;-82   RegType=WORD;
  3413                                  
  3414                                  @@testReg152:
  3415 000012A5 66B802000000             mov eax, 2
  3416 000012AB A2[3E00]                 mov byte [RegType], al
  3417                                  
  3418                                  ;-83   if (eqstr(SymbolUpper, "AX")) return 0;
  3419                                  
  3420 000012AE 68[6915]                 push testReg_8
  3421 000012B1 8D068075                 lea  ax, [SymbolUpper]
  3422 000012B5 50                       push ax
  3423 000012B6 E8EB0B                   call eqstr
  3424 000012B9 83C404                   add  sp, 4
  3425 000012BC 08C0                     or  al, al
  3426 000012BE 0F840900                 je @@testReg153
  3427 000012C2 66B800000000             mov eax, 0
  3428 000012C8 E98502                   jmp @@retn
  3429                                  
  3430                                  ;-84   if (eqstr(SymbolUpper, "CX")) return 1;
  3431                                  
  3432                                  @@testReg153:
  3433 000012CB 68[6C15]                 push testReg_9
  3434 000012CE 8D068075                 lea  ax, [SymbolUpper]
  3435 000012D2 50                       push ax
  3436 000012D3 E8CE0B                   call eqstr
  3437 000012D6 83C404                   add  sp, 4
  3438 000012D9 08C0                     or  al, al
  3439 000012DB 0F840900                 je @@testReg154
  3440 000012DF 66B801000000             mov eax, 1
  3441 000012E5 E96802                   jmp @@retn
  3442                                  
  3443                                  ;-85   if (eqstr(SymbolUpper, "DX")) return 2;
  3444                                  
  3445                                  @@testReg154:
  3446 000012E8 68[6F15]                 push testReg_10
  3447 000012EB 8D068075                 lea  ax, [SymbolUpper]
  3448 000012EF 50                       push ax
  3449 000012F0 E8B10B                   call eqstr
  3450 000012F3 83C404                   add  sp, 4
  3451 000012F6 08C0                     or  al, al
  3452 000012F8 0F840900                 je @@testReg155
  3453 000012FC 66B802000000             mov eax, 2
  3454 00001302 E94B02                   jmp @@retn
  3455                                  
  3456                                  ;-86   if (eqstr(SymbolUpper, "BX")) return 3;
  3457                                  
  3458                                  @@testReg155:
  3459 00001305 68[7215]                 push testReg_11
  3460 00001308 8D068075                 lea  ax, [SymbolUpper]
  3461 0000130C 50                       push ax
  3462 0000130D E8940B                   call eqstr
  3463 00001310 83C404                   add  sp, 4
  3464 00001313 08C0                     or  al, al
  3465 00001315 0F840900                 je @@testReg156
  3466 00001319 66B803000000             mov eax, 3
  3467 0000131F E92E02                   jmp @@retn
  3468                                  
  3469                                  ;-87   if (eqstr(SymbolUpper, "SP")) return 4;
  3470                                  
  3471                                  @@testReg156:
  3472 00001322 68[7515]                 push testReg_12
  3473 00001325 8D068075                 lea  ax, [SymbolUpper]
  3474 00001329 50                       push ax
  3475 0000132A E8770B                   call eqstr
  3476 0000132D 83C404                   add  sp, 4
  3477 00001330 08C0                     or  al, al
  3478 00001332 0F840900                 je @@testReg157
  3479 00001336 66B804000000             mov eax, 4
  3480 0000133C E91102                   jmp @@retn
  3481                                  
  3482                                  ;-88   if (eqstr(SymbolUpper, "BP")) return 5;
  3483                                  
  3484                                  @@testReg157:
  3485 0000133F 68[7815]                 push testReg_13
  3486 00001342 8D068075                 lea  ax, [SymbolUpper]
  3487 00001346 50                       push ax
  3488 00001347 E85A0B                   call eqstr
  3489 0000134A 83C404                   add  sp, 4
  3490 0000134D 08C0                     or  al, al
  3491 0000134F 0F840900                 je @@testReg158
  3492 00001353 66B805000000             mov eax, 5
  3493 00001359 E9F401                   jmp @@retn
  3494                                  
  3495                                  ;-89   if (eqstr(SymbolUpper, "SI")) return 6;
  3496                                  
  3497                                  @@testReg158:
  3498 0000135C 68[7B15]                 push testReg_14
  3499 0000135F 8D068075                 lea  ax, [SymbolUpper]
  3500 00001363 50                       push ax
  3501 00001364 E83D0B                   call eqstr
  3502 00001367 83C404                   add  sp, 4
  3503 0000136A 08C0                     or  al, al
  3504 0000136C 0F840900                 je @@testReg159
  3505 00001370 66B806000000             mov eax, 6
  3506 00001376 E9D701                   jmp @@retn
  3507                                  
  3508                                  ;-90   if (eqstr(SymbolUpper, "DI")) return 7;
  3509                                  
  3510                                  @@testReg159:
  3511 00001379 68[7E15]                 push testReg_15
  3512 0000137C 8D068075                 lea  ax, [SymbolUpper]
  3513 00001380 50                       push ax
  3514 00001381 E8200B                   call eqstr
  3515 00001384 83C404                   add  sp, 4
  3516 00001387 08C0                     or  al, al
  3517 00001389 0F840900                 je @@testReg160
  3518 0000138D 66B807000000             mov eax, 7
  3519 00001393 E9BA01                   jmp @@retn
  3520                                  
  3521                                  ;-91   RegType=SEGREG;
  3522                                  
  3523                                  @@testReg160:
  3524 00001396 66B804000000             mov eax, 4
  3525 0000139C A2[3E00]                 mov byte [RegType], al
  3526                                  
  3527                                  ;-92   if (eqstr(SymbolUpper, "ES")) return 0;
  3528                                  
  3529 0000139F 68[8115]                 push testReg_16
  3530 000013A2 8D068075                 lea  ax, [SymbolUpper]
  3531 000013A6 50                       push ax
  3532 000013A7 E8FA0A                   call eqstr
  3533 000013AA 83C404                   add  sp, 4
  3534 000013AD 08C0                     or  al, al
  3535 000013AF 0F840900                 je @@testReg161
  3536 000013B3 66B800000000             mov eax, 0
  3537 000013B9 E99401                   jmp @@retn
  3538                                  
  3539                                  ;-93   if (eqstr(SymbolUpper, "CS")) return 1;
  3540                                  
  3541                                  @@testReg161:
  3542 000013BC 68[8415]                 push testReg_17
  3543 000013BF 8D068075                 lea  ax, [SymbolUpper]
  3544 000013C3 50                       push ax
  3545 000013C4 E8DD0A                   call eqstr
  3546 000013C7 83C404                   add  sp, 4
  3547 000013CA 08C0                     or  al, al
  3548 000013CC 0F840900                 je @@testReg162
  3549 000013D0 66B801000000             mov eax, 1
  3550 000013D6 E97701                   jmp @@retn
  3551                                  
  3552                                  ;-94   if (eqstr(SymbolUpper, "SS")) return 2;
  3553                                  
  3554                                  @@testReg162:
  3555 000013D9 68[8715]                 push testReg_18
  3556 000013DC 8D068075                 lea  ax, [SymbolUpper]
  3557 000013E0 50                       push ax
  3558 000013E1 E8C00A                   call eqstr
  3559 000013E4 83C404                   add  sp, 4
  3560 000013E7 08C0                     or  al, al
  3561 000013E9 0F840900                 je @@testReg163
  3562 000013ED 66B802000000             mov eax, 2
  3563 000013F3 E95A01                   jmp @@retn
  3564                                  
  3565                                  ;-95   if (eqstr(SymbolUpper, "DS")) return 3;
  3566                                  
  3567                                  @@testReg163:
  3568 000013F6 68[8A15]                 push testReg_19
  3569 000013F9 8D068075                 lea  ax, [SymbolUpper]
  3570 000013FD 50                       push ax
  3571 000013FE E8A30A                   call eqstr
  3572 00001401 83C404                   add  sp, 4
  3573 00001404 08C0                     or  al, al
  3574 00001406 0F840900                 je @@testReg164
  3575 0000140A 66B803000000             mov eax, 3
  3576 00001410 E93D01                   jmp @@retn
  3577                                  
  3578                                  ;-96   if (eqstr(SymbolUpper, "FS")) return 4;
  3579                                  
  3580                                  @@testReg164:
  3581 00001413 68[8D15]                 push testReg_20
  3582 00001416 8D068075                 lea  ax, [SymbolUpper]
  3583 0000141A 50                       push ax
  3584 0000141B E8860A                   call eqstr
  3585 0000141E 83C404                   add  sp, 4
  3586 00001421 08C0                     or  al, al
  3587 00001423 0F840900                 je @@testReg165
  3588 00001427 66B804000000             mov eax, 4
  3589 0000142D E92001                   jmp @@retn
  3590                                  
  3591                                  ;-97   if (eqstr(SymbolUpper, "GS")) return 5;
  3592                                  
  3593                                  @@testReg165:
  3594 00001430 68[9015]                 push testReg_21
  3595 00001433 8D068075                 lea  ax, [SymbolUpper]
  3596 00001437 50                       push ax
  3597 00001438 E8690A                   call eqstr
  3598 0000143B 83C404                   add  sp, 4
  3599 0000143E 08C0                     or  al, al
  3600 00001440 0F840900                 je @@testReg166
  3601 00001444 66B805000000             mov eax, 5
  3602 0000144A E90301                   jmp @@retn
  3603                                  
  3604                                  ;-98   RegType=DWORD;
  3605                                  
  3606                                  @@testReg166:
  3607 0000144D 66B803000000             mov eax, 3
  3608 00001453 A2[3E00]                 mov byte [RegType], al
  3609                                  
  3610                                  ;-99   if (eqstr(SymbolUpper, "EAX"))return 0;
  3611                                  
  3612 00001456 68[9315]                 push testReg_22
  3613 00001459 8D068075                 lea  ax, [SymbolUpper]
  3614 0000145D 50                       push ax
  3615 0000145E E8430A                   call eqstr
  3616 00001461 83C404                   add  sp, 4
  3617 00001464 08C0                     or  al, al
  3618 00001466 0F840900                 je @@testReg167
  3619 0000146A 66B800000000             mov eax, 0
  3620 00001470 E9DD00                   jmp @@retn
  3621                                  
  3622                                  ;-100   if (eqstr(SymbolUpper, "ECX"))return 1;
  3623                                  
  3624                                  @@testReg167:
  3625 00001473 68[9715]                 push testReg_23
  3626 00001476 8D068075                 lea  ax, [SymbolUpper]
  3627 0000147A 50                       push ax
  3628 0000147B E8260A                   call eqstr
  3629 0000147E 83C404                   add  sp, 4
  3630 00001481 08C0                     or  al, al
  3631 00001483 0F840900                 je @@testReg168
  3632 00001487 66B801000000             mov eax, 1
  3633 0000148D E9C000                   jmp @@retn
  3634                                  
  3635                                  ;-101   if (eqstr(SymbolUpper, "EDX"))return 2;
  3636                                  
  3637                                  @@testReg168:
  3638 00001490 68[9B15]                 push testReg_24
  3639 00001493 8D068075                 lea  ax, [SymbolUpper]
  3640 00001497 50                       push ax
  3641 00001498 E8090A                   call eqstr
  3642 0000149B 83C404                   add  sp, 4
  3643 0000149E 08C0                     or  al, al
  3644 000014A0 0F840900                 je @@testReg169
  3645 000014A4 66B802000000             mov eax, 2
  3646 000014AA E9A300                   jmp @@retn
  3647                                  
  3648                                  ;-102   if (eqstr(SymbolUpper, "EBX"))return 3;
  3649                                  
  3650                                  @@testReg169:
  3651 000014AD 68[9F15]                 push testReg_25
  3652 000014B0 8D068075                 lea  ax, [SymbolUpper]
  3653 000014B4 50                       push ax
  3654 000014B5 E8EC09                   call eqstr
  3655 000014B8 83C404                   add  sp, 4
  3656 000014BB 08C0                     or  al, al
  3657 000014BD 0F840900                 je @@testReg170
  3658 000014C1 66B803000000             mov eax, 3
  3659 000014C7 E98600                   jmp @@retn
  3660                                  
  3661                                  ;-103   if (eqstr(SymbolUpper, "ESP"))return 4;
  3662                                  
  3663                                  @@testReg170:
  3664 000014CA 68[A315]                 push testReg_26
  3665 000014CD 8D068075                 lea  ax, [SymbolUpper]
  3666 000014D1 50                       push ax
  3667 000014D2 E8CF09                   call eqstr
  3668 000014D5 83C404                   add  sp, 4
  3669 000014D8 08C0                     or  al, al
  3670 000014DA 0F840900                 je @@testReg171
  3671 000014DE 66B804000000             mov eax, 4
  3672 000014E4 E96900                   jmp @@retn
  3673                                  
  3674                                  ;-104   if (eqstr(SymbolUpper, "EBP"))return 5;
  3675                                  
  3676                                  @@testReg171:
  3677 000014E7 68[A715]                 push testReg_27
  3678 000014EA 8D068075                 lea  ax, [SymbolUpper]
  3679 000014EE 50                       push ax
  3680 000014EF E8B209                   call eqstr
  3681 000014F2 83C404                   add  sp, 4
  3682 000014F5 08C0                     or  al, al
  3683 000014F7 0F840900                 je @@testReg172
  3684 000014FB 66B805000000             mov eax, 5
  3685 00001501 E94C00                   jmp @@retn
  3686                                  
  3687                                  ;-105   if (eqstr(SymbolUpper, "ESI"))return 6;
  3688                                  
  3689                                  @@testReg172:
  3690 00001504 68[AB15]                 push testReg_28
  3691 00001507 8D068075                 lea  ax, [SymbolUpper]
  3692 0000150B 50                       push ax
  3693 0000150C E89509                   call eqstr
  3694 0000150F 83C404                   add  sp, 4
  3695 00001512 08C0                     or  al, al
  3696 00001514 0F840900                 je @@testReg173
  3697 00001518 66B806000000             mov eax, 6
  3698 0000151E E92F00                   jmp @@retn
  3699                                  
  3700                                  ;-106   if (eqstr(SymbolUpper, "EDI"))return 7;
  3701                                  
  3702                                  @@testReg173:
  3703 00001521 68[AF15]                 push testReg_29
  3704 00001524 8D068075                 lea  ax, [SymbolUpper]
  3705 00001528 50                       push ax
  3706 00001529 E87809                   call eqstr
  3707 0000152C 83C404                   add  sp, 4
  3708 0000152F 08C0                     or  al, al
  3709 00001531 0F840900                 je @@testReg174
  3710 00001535 66B807000000             mov eax, 7
  3711 0000153B E91200                   jmp @@retn
  3712                                  
  3713                                  ;-107   RegType=0; return 0;
  3714                                  
  3715                                  @@testReg174:
  3716 0000153E 66B800000000             mov eax, 0
  3717 00001544 A2[3E00]                 mov byte [RegType], al
  3718 00001547 66B800000000             mov eax, 0
  3719 0000154D E90000                   jmp @@retn
  3720                                  
  3721                                  ;-108 }
  3722                                  
  3723                                  @@retn:
  3724 00001550 C3                       ret
  3725                                  ; ENDP
  3726 00001551 414C00                  testReg_0 db "AL",0
  3727 00001554 434C00                  testReg_1 db "CL",0
  3728 00001557 444C00                  testReg_2 db "DL",0
  3729 0000155A 424C00                  testReg_3 db "BL",0
  3730 0000155D 414800                  testReg_4 db "AH",0
  3731 00001560 434800                  testReg_5 db "CH",0
  3732 00001563 444800                  testReg_6 db "DH",0
  3733 00001566 424800                  testReg_7 db "BH",0
  3734 00001569 415800                  testReg_8 db "AX",0
  3735 0000156C 435800                  testReg_9 db "CX",0
  3736 0000156F 445800                  testReg_10 db "DX",0
  3737 00001572 425800                  testReg_11 db "BX",0
  3738 00001575 535000                  testReg_12 db "SP",0
  3739 00001578 425000                  testReg_13 db "BP",0
  3740 0000157B 534900                  testReg_14 db "SI",0
  3741 0000157E 444900                  testReg_15 db "DI",0
  3742 00001581 455300                  testReg_16 db "ES",0
  3743 00001584 435300                  testReg_17 db "CS",0
  3744 00001587 535300                  testReg_18 db "SS",0
  3745 0000158A 445300                  testReg_19 db "DS",0
  3746 0000158D 465300                  testReg_20 db "FS",0
  3747 00001590 475300                  testReg_21 db "GS",0
  3748 00001593 45415800                testReg_22 db "EAX",0
  3749 00001597 45435800                testReg_23 db "ECX",0
  3750 0000159B 45445800                testReg_24 db "EDX",0
  3751 0000159F 45425800                testReg_25 db "EBX",0
  3752 000015A3 45535000                testReg_26 db "ESP",0
  3753 000015A7 45425000                testReg_27 db "EBP",0
  3754 000015AB 45534900                testReg_28 db "ESI",0
  3755 000015AF 45444900                testReg_29 db "EDI",0
  3756                                  ;Back to main program: AS.C
  3757                                  
  3758                                  ;-207 #include "OUTPUT.C"
  3759                                  
  3760                                  ;Use include file: OUTPUT.C
  3761                                  
  3762                                  ;-1 int printLine() { int i; char c;
  3763                                  
  3764                                  
  3765                                  printLine:  ; *** PROC ***
  3766                                  
  3767                                  ;-2   prs("\n"); printhex16(PCStart);
  3768                                  
  3769                                  ;Function : printLine, Number of local variables: 2
  3770                                  ;   # type sign width line used address name   list of local variables
  3771                                  ;  200 var sign word     1 NULL bp-2    i
  3772                                  ;  201 var sign byte     1 NULL bp-4    c;
  3773 000015B3 C8040000                 ENTER  4,0
  3774 000015B7 68[4816]                 push printLine_0
  3775 000015BA E80401                   call prs
  3776 000015BD 83C402                   add  sp, 2
  3777 000015C0 FF36[3800]               push word [PCStart]
  3778 000015C4 E8EB01                   call printhex16
  3779 000015C7 83C402                   add  sp, 2
  3780                                  
  3781                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  3782                                  
  3783 000015CA A1[4900]                 mov ax, [OpPrintIndex]
  3784 000015CD 83F800                   cmp ax, 0
  3785 000015D0 0F850C00                 jne @@printLine175
  3786 000015D4 68[4B16]                 push printLine_1
  3787 000015D7 E8E700                   call prs
  3788 000015DA 83C402                   add  sp, 2
  3789                                  
  3790                                  ;-4   else {
  3791                                  
  3792 000015DD E95B00                   jmp @@printLine176
  3793                                  @@printLine175:
  3794                                  
  3795                                  ;-5     prc(PrReloc);
  3796                                  
  3797 000015E0 A0[4D00]                 mov al, byte [PrReloc]
  3798 000015E3 B400                     mov ah, 0
  3799 000015E5 50                       push ax
  3800 000015E6 E87700                   call prc
  3801 000015E9 83C402                   add  sp, 2
  3802                                  
  3803                                  ;-6     i=0;
  3804                                  
  3805 000015EC 66B800000000             mov eax, 0
  3806 000015F2 8946FE                   mov word [bp-2], ax
  3807                                  
  3808                                  ;-7     do {
  3809                                  
  3810                                  @@printLine177:
  3811                                  
  3812                                  ;-8       c=OpPos[i];
  3813                                  
  3814 000015F5 8B5EFE                   mov bx, [bp-2]
  3815 000015F8 8A871977                 mov al, [OpPos + bx]
  3816 000015FC 8846FC                   mov byte [bp-4], al
  3817                                  
  3818                                  ;-9       printhex8a(c); prc(' ');
  3819                                  
  3820 000015FF 8A46FC                   mov al, byte [bp-4]
  3821 00001602 B400                     mov ah, 0
  3822 00001604 50                       push ax
  3823 00001605 E85C01                   call printhex8a
  3824 00001608 83C402                   add  sp, 2
  3825 0000160B 6A20                     push 32
  3826 0000160D E85000                   call prc
  3827 00001610 83C402                   add  sp, 2
  3828                                  
  3829                                  ;-10       i++;
  3830                                  
  3831 00001613 FF46FE                   inc  word [bp-2]
  3832                                  
  3833                                  ;-11     } while(i < OpPrintIndex);
  3834                                  
  3835 00001616 8B46FE                   mov ax, [bp-2]
  3836 00001619 3B06[4900]               cmp ax, [OpPrintIndex]
  3837 0000161D 0F8D0200                 jge @@printLine178
  3838 00001621 EBD2                     jmp @@printLine177
  3839                                  @@printLine178:
  3840                                  
  3841                                  ;-12     do {// fill rest with blank
  3842                                  
  3843                                  @@printLine179:
  3844                                  
  3845                                  ;-13       prs("   ");
  3846                                  
  3847 00001623 68[5C16]                 push printLine_2
  3848 00001626 E89800                   call prs
  3849 00001629 83C402                   add  sp, 2
  3850                                  
  3851                                  ;-14       i++;
  3852                                  
  3853 0000162C FF46FE                   inc  word [bp-2]
  3854                                  
  3855                                  ;-15     } while(i < OPMAXLEN);
  3856                                  
  3857 0000162F 8B46FE                   mov ax, [bp-2]
  3858 00001632 83F805                   cmp ax, 5
  3859 00001635 0F8D0200                 jge @@printLine180
  3860 00001639 EBE8                     jmp @@printLine179
  3861                                  @@printLine180:
  3862                                  
  3863                                  ;-16   }
  3864                                  
  3865                                  
  3866                                  ;-17   prscomment(InputBuf);
  3867                                  
  3868                                  @@printLine176:
  3869 0000163B 8D06D075                 lea  ax, [InputBuf]
  3870 0000163F 50                       push ax
  3871 00001640 E85000                   call prscomment
  3872 00001643 83C402                   add  sp, 2
  3873                                  
  3874                                  ;-18 }
  3875                                  
  3876                                  
  3877                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  3878 00001646 C9                       LEAVE
  3879 00001647 C3                       ret
  3880                                  ; ENDP
  3881 00001648 5C6E00                  printLine_0 db "\n",0
  3882 0000164B 202020202020202020-     printLine_1 db "                ",0
  3883 00001654 2020202020202000   
  3884 0000165C 20202000                printLine_2 db "   ",0
  3885                                  
  3886                                  prc:  ; *** PROC ***
  3887                                  ;Function : prc, Number of local variables: 1
  3888                                  ;   # type sign width line used address name   list of local variables
  3889                                  ;  200 var unsg byte    19 NULL bp+4    c;
  3890 00001660 C8000000                 ENTER  0,0
  3891 00001664 A0[2400]                 mov al, [LIST]
  3892 00001667 08C0                     or  al, al
  3893 00001669 0F841400                 je @@prc181
  3894 0000166D 807E040A                cmp byte [bp+4], 10
  3895 00001671 0F850600                 jne @@prc182
  3896 00001675 B80D00                   mov  ax, 13
  3897 00001678 E81907                   call writetty
  3898                                  
  3899                                  ;-20      al=c; writetty(); }
  3900                                  
  3901                                  @@prc182:
  3902 0000167B 8A4604                   mov  al, [bp+4]
  3903 0000167E E81307                   call writetty
  3904                                  
  3905                                  ;-21    fputcR(c,lst_fd); }
  3906                                  
  3907                                  @@prc181:
  3908 00001681 FF36[2B00]               push word [lst_fd]
  3909 00001685 8A4604                   mov al, byte [bp+4]
  3910 00001688 B400                     mov ah, 0
  3911 0000168A 50                       push ax
  3912 0000168B E8C608                   call fputcR
  3913 0000168E 83C404                   add  sp, 4
  3914                                  
  3915                                  ;-22 
  3916                                  
  3917                                  
  3918                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  3919 00001691 C9                       LEAVE
  3920 00001692 C3                       ret
  3921                                  ; ENDP
  3922                                  
  3923                                  prscomment:  ; *** PROC ***
  3924                                  
  3925                                  ;-24   while(*s){c=*s;prc(c);s++;}
  3926                                  
  3927                                  ;Function : prscomment, Number of local variables: 2
  3928                                  ;   # type sign width line used address name   list of local variables
  3929                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  3930                                  ;  201 var unsg byte    23 NULL bp-2    c;
  3931 00001693 C8020000                 ENTER  2,0
  3932                                  @@prscomment183:
  3933 00001697 8B5E04                   mov bx, [bp+4]
  3934 0000169A 8A07                     mov al, [bx]
  3935 0000169C B400                     mov ah, 0
  3936 0000169E 08C0                     or  al, al
  3937 000016A0 0F841B00                 je @@prscomment184
  3938 000016A4 8B5E04                   mov bx, [bp+4]
  3939 000016A7 8A07                     mov al, [bx]
  3940 000016A9 B400                     mov ah, 0
  3941 000016AB 8846FE                   mov byte [bp-2], al
  3942 000016AE 8A46FE                   mov al, byte [bp-2]
  3943 000016B1 B400                     mov ah, 0
  3944 000016B3 50                       push ax
  3945 000016B4 E8A9FF                   call prc
  3946 000016B7 83C402                   add  sp, 2
  3947 000016BA FF4604                   inc  word [bp+4]
  3948                                  
  3949                                  ;-25 }
  3950                                  
  3951 000016BD EBD8                     jmp @@prscomment183
  3952                                  @@prscomment184:
  3953                                  
  3954                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3955 000016BF C9                       LEAVE
  3956 000016C0 C3                       ret
  3957                                  ; ENDP
  3958                                  
  3959                                  prs:  ; *** PROC ***
  3960                                  ;Function : prs, Number of local variables: 3
  3961                                  ;   # type sign width line used address name   list of local variables
  3962                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3963                                  ;  201 var unsg byte    26 NULL bp-2    c
  3964                                  ;  202 var sign word    26 NULL bp-4    com;
  3965 000016C1 C8040000                 ENTER  4,0
  3966 000016C5 66B800000000             mov eax, 0
  3967 000016CB 8946FC                   mov word [bp-4], ax
  3968                                  
  3969                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3970                                  
  3971                                  @@prs185:
  3972 000016CE 8B5E04                   mov bx, [bp+4]
  3973 000016D1 8A07                     mov al, [bx]
  3974 000016D3 B400                     mov ah, 0
  3975 000016D5 08C0                     or  al, al
  3976 000016D7 0F848700                 je @@prs186
  3977 000016DB 8B5E04                   mov bx, [bp+4]
  3978 000016DE 8A07                     mov al, [bx]
  3979 000016E0 B400                     mov ah, 0
  3980 000016E2 8846FE                   mov byte [bp-2], al
  3981 000016E5 8A46FE                   mov al, [bp-2]
  3982 000016E8 3C22                     cmp al, 34
  3983 000016EA 0F851E00                 jne @@prs187
  3984 000016EE 8B46FC                   mov ax, [bp-4]
  3985 000016F1 08C0                     or  al, al
  3986 000016F3 0F840C00                 je @@prs188
  3987 000016F7 66B800000000             mov eax, 0
  3988 000016FD 8946FC                   mov word [bp-4], ax
  3989 00001700 E90900                   jmp @@prs189
  3990                                  @@prs188:
  3991 00001703 66B801000000             mov eax, 1
  3992 00001709 8946FC                   mov word [bp-4], ax
  3993                                  
  3994                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3995                                  
  3996                                  @@prs189:
  3997                                  @@prs187:
  3998 0000170C 8A46FE                   mov al, [bp-2]
  3999 0000170F 3C5C                     cmp al, 92
  4000 00001711 0F853B00                 jne @@prs190
  4001 00001715 8B46FC                   mov ax, [bp-4]
  4002 00001718 83F800                   cmp ax, 0
  4003 0000171B 0F853100                 jne @@prs191
  4004 0000171F FF4604                   inc  word [bp+4]
  4005 00001722 8B5E04                   mov bx, [bp+4]
  4006 00001725 8A07                     mov al, [bx]
  4007 00001727 B400                     mov ah, 0
  4008 00001729 8846FE                   mov byte [bp-2], al
  4009                                  
  4010                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4011                                  
  4012 0000172C 8A46FE                   mov al, [bp-2]
  4013 0000172F 3C6E                     cmp al, 110
  4014 00001731 0F850900                 jne @@prs192
  4015 00001735 66B80A000000             mov eax, 10
  4016 0000173B 8846FE                   mov byte [bp-2], al
  4017                                  @@prs192:
  4018 0000173E 8A46FE                   mov al, [bp-2]
  4019 00001741 3C74                     cmp al, 116
  4020 00001743 0F850900                 jne @@prs193
  4021 00001747 66B809000000             mov eax, 9
  4022 0000174D 8846FE                   mov byte [bp-2], al
  4023                                  @@prs193:
  4024                                  @@prs191:
  4025                                  @@prs190:
  4026 00001750 8A46FE                   mov al, byte [bp-2]
  4027 00001753 B400                     mov ah, 0
  4028 00001755 50                       push ax
  4029 00001756 E807FF                   call prc
  4030 00001759 83C402                   add  sp, 2
  4031 0000175C FF4604                   inc  word [bp+4]
  4032                                  
  4033                                  ;-30 }
  4034                                  
  4035 0000175F E96CFF                   jmp @@prs185
  4036                                  @@prs186:
  4037                                  
  4038                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4039 00001762 C9                       LEAVE
  4040 00001763 C3                       ret
  4041                                  ; ENDP
  4042                                  
  4043                                  printhex8a:  ; *** PROC ***
  4044                                  
  4045                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4046                                  
  4047                                  ;Function : printhex8a, Number of local variables: 2
  4048                                  ;   # type sign width line used address name   list of local variables
  4049                                  ;  200 var unsg word    31 NULL bp+4    c
  4050                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4051 00001764 C8020000                 ENTER  2,0
  4052 00001768 8B4604                   mov ax, [bp+4]
  4053 0000176B C1E804                   shr ax, 4
  4054 0000176E 8946FE                   mov word [bp-2], ax
  4055 00001771 8346FE30                 add  word [bp-2], 48
  4056 00001775 8B46FE                   mov ax, [bp-2]
  4057 00001778 83F839                   cmp ax, 57
  4058 0000177B 0F8E0400                 jle @@printhex8a194
  4059 0000177F 8346FE07                 add  word [bp-2], 7
  4060                                  @@printhex8a194:
  4061 00001783 FF76FE                   push word [bp-2]
  4062 00001786 E8D7FE                   call prc
  4063 00001789 83C402                   add  sp, 2
  4064                                  
  4065                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4066                                  
  4067 0000178C 8B4604                   mov ax, [bp+4]
  4068 0000178F 83E00F                   and ax, 15
  4069 00001792 8946FE                   mov word [bp-2], ax
  4070 00001795 8346FE30                 add  word [bp-2], 48
  4071 00001799 8B46FE                   mov ax, [bp-2]
  4072 0000179C 83F839                   cmp ax, 57
  4073 0000179F 0F8E0400                 jle @@printhex8a195
  4074 000017A3 8346FE07                 add  word [bp-2], 7
  4075                                  @@printhex8a195:
  4076 000017A7 FF76FE                   push word [bp-2]
  4077 000017AA E8B3FE                   call prc
  4078 000017AD 83C402                   add  sp, 2
  4079                                  
  4080                                  ;-34 }
  4081                                  
  4082                                  
  4083                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4084 000017B0 C9                       LEAVE
  4085 000017B1 C3                       ret
  4086                                  ; ENDP
  4087                                  
  4088                                  printhex16:  ; *** PROC ***
  4089                                  
  4090                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4091                                  
  4092                                  ;Function : printhex16, Number of local variables: 2
  4093                                  ;   # type sign width line used address name   list of local variables
  4094                                  ;  200 var unsg word    35 NULL bp+4    i
  4095                                  ;  201 var unsg word    35 NULL bp-2    half;
  4096 000017B2 C8020000                 ENTER  2,0
  4097 000017B6 8B4604                   mov ax, [bp+4]
  4098 000017B9 C1E808                   shr ax, 8
  4099 000017BC 8946FE                   mov word [bp-2], ax
  4100 000017BF FF76FE                   push word [bp-2]
  4101 000017C2 E89FFF                   call printhex8a
  4102 000017C5 83C402                   add  sp, 2
  4103 000017C8 8B4604                   mov ax, [bp+4]
  4104 000017CB 25FF00                   and ax, 255
  4105 000017CE 8946FE                   mov word [bp-2], ax
  4106 000017D1 FF76FE                   push word [bp-2]
  4107 000017D4 E88DFF                   call printhex8a
  4108 000017D7 83C402                   add  sp, 2
  4109                                  
  4110                                  ;-37 }
  4111                                  
  4112                                  
  4113                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4114 000017DA C9                       LEAVE
  4115 000017DB C3                       ret
  4116                                  ; ENDP
  4117                                  
  4118                                  printIntU:  ; *** PROC ***
  4119                                  
  4120                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4121                                  
  4122                                  ;Function : printIntU, Number of local variables: 2
  4123                                  ;   # type sign width line used address name   list of local variables
  4124                                  ;  200 var unsg word    38 NULL bp+4    n
  4125                                  ;  201 var unsg word    38 NULL bp-2    e;
  4126 000017DC C8020000                 ENTER  2,0
  4127 000017E0 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4128 000017E4 0F821700                 jb  @@printIntU196
  4129 000017E8 8B4604                   mov ax, [bp+4]
  4130 000017EB BB0A00                   mov bx, 10
  4131 000017EE BA0000                   mov dx, 0
  4132 000017F1 F7F3                     div bx
  4133 000017F3 8946FE                   mov word [bp-2], ax
  4134                                  
  4135                                  ;-40     printIntU(e); }
  4136                                  
  4137 000017F6 FF76FE                   push word [bp-2]
  4138 000017F9 E8E0FF                   call printIntU
  4139 000017FC 83C402                   add  sp, 2
  4140                                  
  4141                                  ;-41     n = n % 10; //unsigned mod
  4142                                  
  4143                                  @@printIntU196:
  4144 000017FF 8B4604                   mov ax, [bp+4]
  4145 00001802 BB0A00                   mov bx, 10
  4146 00001805 BA0000                   mov dx, 0
  4147 00001808 F7F3                     div bx
  4148 0000180A 89D0                     mov ax, dx
  4149 0000180C 894604                   mov word [bp+4], ax
  4150                                  
  4151                                  ;-42     n += '0'; prc(n);
  4152                                  
  4153 0000180F 83460430                 add  word [bp+4], 48
  4154 00001813 FF7604                   push word [bp+4]
  4155 00001816 E847FE                   call prc
  4156 00001819 83C402                   add  sp, 2
  4157                                  
  4158                                  ;-43 }
  4159                                  
  4160                                  
  4161                                  ;-44 
  4162                                  
  4163                                  
  4164                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4165 0000181C C9                       LEAVE
  4166 0000181D C3                       ret
  4167                                  ; ENDP
  4168                                  
  4169                                  error1:  ; *** PROC ***
  4170                                  ;Function : error1, Number of local variables: 1
  4171                                  ;   # type sign width line used address name   list of local variables
  4172                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4173 0000181E C8000000                 ENTER  0,0
  4174 00001822 66B801000000             mov eax, 1
  4175 00001828 A2[2400]                 mov byte [LIST], al
  4176 0000182B FF06[3100]               inc  word [ErrorCount]
  4177                                  
  4178                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4179                                  
  4180 0000182F 68[5718]                 push error1_0
  4181 00001832 E88CFE                   call prs
  4182 00001835 83C402                   add  sp, 2
  4183 00001838 FF7604                   push word [bp+4]
  4184 0000183B E883FE                   call prs
  4185 0000183E 83C402                   add  sp, 2
  4186                                  
  4187                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4188                                  
  4189 00001841 68[7218]                 push error1_1
  4190 00001844 E87AFE                   call prs
  4191 00001847 83C402                   add  sp, 2
  4192 0000184A 8D063075                 lea  ax, [Symbol]
  4193 0000184E 50                       push ax
  4194 0000184F E86FFE                   call prs
  4195 00001852 83C402                   add  sp, 2
  4196                                  
  4197                                  ;-48 int allowederror(){error1("not allowed here"); }
  4198 00001855 C9                       LEAVE
  4199 00001856 C3                       ret
  4200                                  ; ENDP
  4201 00001857 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4202 00001860 6E657874206C696E65-
  4203 00001869 204552524F523A2000 
  4204 00001872 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4205 0000187B 2000               
  4206                                  
  4207                                  allowederror:  ; *** PROC ***
  4208 0000187D 68[8718]                 push allowederror_0
  4209 00001880 E89BFF                   call error1
  4210 00001883 83C402                   add  sp, 2
  4211                                  
  4212                                  ;-49 int implmerror(){error1("not implemented");}
  4213                                  
  4214 00001886 C3                       ret
  4215                                  ; ENDP
  4216 00001887 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4217 00001890 6564206865726500   
  4218                                  
  4219                                  implmerror:  ; *** PROC ***
  4220 00001898 68[A218]                 push implmerror_0
  4221 0000189B E880FF                   call error1
  4222 0000189E 83C402                   add  sp, 2
  4223                                  
  4224                                  ;-50 int indexerror (){error1("invalid index register");}
  4225                                  
  4226 000018A1 C3                       ret
  4227                                  ; ENDP
  4228 000018A2 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4229 000018AB 6D656E74656400     
  4230                                  
  4231                                  indexerror:  ; *** PROC ***
  4232 000018B2 68[BC18]                 push indexerror_0
  4233 000018B5 E866FF                   call error1
  4234 000018B8 83C402                   add  sp, 2
  4235                                  
  4236                                  ;-51 int numbererror(){error1("number expected");}
  4237                                  
  4238 000018BB C3                       ret
  4239                                  ; ENDP
  4240 000018BC 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4241 000018C5 6E6465782072656769-
  4242 000018CE 7374657200         
  4243                                  
  4244                                  numbererror:  ; *** PROC ***
  4245 000018D3 68[DD18]                 push numbererror_0
  4246 000018D6 E845FF                   call error1
  4247 000018D9 83C402                   add  sp, 2
  4248                                  
  4249                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4250                                  
  4251 000018DC C3                       ret
  4252                                  ; ENDP
  4253 000018DD 6E756D626572206578-     numbererror_0 db "number expected",0
  4254 000018E6 70656374656400     
  4255                                  
  4256                                  regmemerror:  ; *** PROC ***
  4257 000018ED 68[F718]                 push regmemerror_0
  4258 000018F0 E82BFF                   call error1
  4259 000018F3 83C402                   add  sp, 2
  4260                                  
  4261                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4262                                  
  4263 000018F6 C3                       ret
  4264                                  ; ENDP
  4265 000018F7 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4266 00001900 73746572206F72206D-
  4267 00001909 656D6F727920616C6C-
  4268 00001912 6F77656400         
  4269                                  
  4270                                  segregerror:  ; *** PROC ***
  4271 00001917 68[2119]                 push segregerror_0
  4272 0000191A E801FF                   call error1
  4273 0000191D 83C402                   add  sp, 2
  4274                                  
  4275                                  ;-54 int syntaxerror(){error1("syntax");}
  4276                                  
  4277 00001920 C3                       ret
  4278                                  ; ENDP
  4279 00001921 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4280 0000192A 65676973746572206E-
  4281 00001933 6F7420616C6C6F7765-
  4282 0000193C 6400               
  4283                                  
  4284                                  syntaxerror:  ; *** PROC ***
  4285 0000193E 68[4819]                 push syntaxerror_0
  4286 00001941 E8DAFE                   call error1
  4287 00001944 83C402                   add  sp, 2
  4288                                  
  4289                                  ;-55 
  4290                                  
  4291                                  
  4292                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4293                                  
  4294 00001947 C3                       ret
  4295                                  ; ENDP
  4296 00001948 73796E74617800          syntaxerror_0 db "syntax",0
  4297                                  
  4298                                  errorexit:  ; *** PROC ***
  4299                                  ;Function : errorexit, Number of local variables: 1
  4300                                  ;   # type sign width line used address name   list of local variables
  4301                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4302 0000194F C8000000                 ENTER  0,0
  4303 00001953 FF7604                   push word [bp+4]
  4304 00001956 E8C5FE                   call error1
  4305 00001959 83C402                   add  sp, 2
  4306 0000195C 6A01                     push 1
  4307 0000195E E80604                   call end1
  4308 00001961 83C402                   add  sp, 2
  4309                                  
  4310                                  ;-57 int addrexit(){errorexit("illegal addres");}
  4311 00001964 C9                       LEAVE
  4312 00001965 C3                       ret
  4313                                  ; ENDP
  4314                                  
  4315                                  addrexit:  ; *** PROC ***
  4316 00001966 68[7019]                 push addrexit_0
  4317 00001969 E8E3FF                   call errorexit
  4318 0000196C 83C402                   add  sp, 2
  4319                                  
  4320                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4321                                  
  4322 0000196F C3                       ret
  4323                                  ; ENDP
  4324 00001970 696C6C6567616C2061-     addrexit_0 db "illegal addres",0
  4325 00001979 646472657300       
  4326                                  
  4327                                  internexit:  ; *** PROC ***
  4328 0000197F 68[8919]                 push internexit_0
  4329 00001982 E8CAFF                   call errorexit
  4330 00001985 83C402                   add  sp, 2
  4331 00001988 C3                       ret
  4332                                  ; ENDP
  4333 00001989 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4334 00001992 6D70696C6572206572-
  4335 0000199B 726F7200           
  4336                                  ;Back to main program: AS.C
  4337                                  
  4338                                  ;-208 #include "MAIN.C"
  4339                                  
  4340                                  ;Use include file: MAIN.C
  4341                                  
  4342                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4343                                  
  4344                                  
  4345                                  getarg:  ; *** PROC ***
  4346                                  
  4347                                  ;-2   arglen1=*arglen;
  4348                                  
  4349                                  ;Function : getarg, Number of local variables: 3
  4350                                  ;   # type sign width line used address name   list of local variables
  4351                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4352                                  ;  201 var sign word     1 NULL bp-4    i
  4353                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4354 0000199F C8060000                 ENTER  6,0
  4355 000019A3 8B1E[5600]               mov bx, [arglen]
  4356 000019A7 8A07                     mov al, [bx]
  4357 000019A9 B400                     mov ah, 0
  4358 000019AB 8946FE                   mov word [bp-2], ax
  4359                                  
  4360                                  ;-3   if (arglen1==0) {
  4361                                  
  4362 000019AE 8B46FE                   mov ax, [bp-2]
  4363 000019B1 83F800                   cmp ax, 0
  4364 000019B4 0F851C00                 jne @@getarg197
  4365                                  
  4366                                  ;-4     cputs(Version1);
  4367                                  
  4368 000019B8 8D06[1000]               lea  ax, [Version1]
  4369 000019BC 50                       push ax
  4370 000019BD E8DC03                   call cputs
  4371 000019C0 83C402                   add  sp, 2
  4372                                  
  4373                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4374                                  
  4375 000019C3 68[641B]                 push getarg_0
  4376 000019C6 E8D303                   call cputs
  4377 000019C9 83C402                   add  sp, 2
  4378                                  
  4379                                  ;-6     exitR(3);
  4380                                  
  4381 000019CC 6A03                     push 3
  4382 000019CE E8A605                   call exitR
  4383 000019D1 83C402                   add  sp, 2
  4384                                  
  4385                                  ;-7   }
  4386                                  
  4387                                  
  4388                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4389                                  
  4390                                  @@getarg197:
  4391 000019D4 8B46FE                   mov ax, [bp-2]
  4392 000019D7 058100                   add ax, 129
  4393 000019DA 8946FC                   mov word [bp-4], ax
  4394 000019DD 66B800000000             mov eax, 0
  4395 000019E3 8B5EFC                   mov  bx, [bp-4]
  4396 000019E6 8907                     mov  [bx], ax
  4397 000019E8 FF4EFE                   dec  word [bp-2]
  4398                                  
  4399                                  ;-9   toupper(argv);
  4400                                  
  4401 000019EB FF36[5800]               push word [argv]
  4402 000019EF E8D803                   call toupper
  4403 000019F2 83C402                   add  sp, 2
  4404                                  
  4405                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4406                                  
  4407 000019F5 FF36[5800]               push word [argv]
  4408 000019F9 8D065076                 lea  ax, [namein]
  4409 000019FD 50                       push ax
  4410 000019FE E83704                   call strcpy
  4411 00001A01 83C404                   add  sp, 4
  4412 00001A04 68[891B]                 push getarg_1
  4413 00001A07 8D065076                 lea  ax, [namein]
  4414 00001A0B 50                       push ax
  4415 00001A0C E8EA04                   call strcat1
  4416 00001A0F 83C404                   add  sp, 4
  4417                                  
  4418                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4419                                  
  4420 00001A12 FF36[5800]               push word [argv]
  4421 00001A16 8D069376                 lea  ax, [namelst]
  4422 00001A1A 50                       push ax
  4423 00001A1B E81A04                   call strcpy
  4424 00001A1E 83C404                   add  sp, 4
  4425 00001A21 68[8C1B]                 push getarg_2
  4426 00001A24 8D069376                 lea  ax, [namelst]
  4427 00001A28 50                       push ax
  4428 00001A29 E8CD04                   call strcat1
  4429 00001A2C 83C404                   add  sp, 4
  4430                                  
  4431                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4432                                  
  4433 00001A2F FF36[5800]               push word [argv]
  4434 00001A33 8D06D676                 lea  ax, [namebin]
  4435 00001A37 50                       push ax
  4436 00001A38 E8FD03                   call strcpy
  4437 00001A3B 83C404                   add  sp, 4
  4438 00001A3E 68[911B]                 push getarg_3
  4439 00001A41 8D06D676                 lea  ax, [namebin]
  4440 00001A45 50                       push ax
  4441 00001A46 E8B004                   call strcat1
  4442 00001A49 83C404                   add  sp, 4
  4443                                  
  4444                                  ;-13 
  4445                                  
  4446                                  
  4447                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4448                                  
  4449 00001A4C 66B801000000             mov eax, 1
  4450 00001A52 A2[2400]                 mov byte [LIST], al
  4451 00001A55 66B800000000             mov eax, 0
  4452 00001A5B A3[2F00]                 mov word [DOS_ERR], ax
  4453 00001A5E 66B800000000             mov eax, 0
  4454 00001A64 A3[3600]                 mov word [PC], ax
  4455 00001A67 66B800000000             mov eax, 0
  4456 00001A6D A3[3100]                 mov word [ErrorCount], ax
  4457                                  
  4458                                  ;-15   asm_fd=openR (namein);
  4459                                  
  4460 00001A70 8D065076                 lea  ax, [namein]
  4461 00001A74 50                       push ax
  4462 00001A75 E8A604                   call openR
  4463 00001A78 83C402                   add  sp, 2
  4464 00001A7B A3[2900]                 mov word [asm_fd], ax
  4465                                  
  4466                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4467                                  
  4468 00001A7E A1[2F00]                 mov ax, [DOS_ERR]
  4469 00001A81 08C0                     or  al, al
  4470 00001A83 0F841C00                 je @@getarg198
  4471 00001A87 68[961B]                 push getarg_4
  4472 00001A8A E80F03                   call cputs
  4473 00001A8D 83C402                   add  sp, 2
  4474 00001A90 8D065076                 lea  ax, [namein]
  4475 00001A94 50                       push ax
  4476 00001A95 E80403                   call cputs
  4477 00001A98 83C402                   add  sp, 2
  4478 00001A9B 6A01                     push 1
  4479 00001A9D E8D704                   call exitR
  4480 00001AA0 83C402                   add  sp, 2
  4481                                  
  4482                                  ;-17   lst_fd=creatR(namelst);
  4483                                  
  4484                                  @@getarg198:
  4485 00001AA3 8D069376                 lea  ax, [namelst]
  4486 00001AA7 50                       push ax
  4487 00001AA8 E88204                   call creatR
  4488 00001AAB 83C402                   add  sp, 2
  4489 00001AAE A3[2B00]                 mov word [lst_fd], ax
  4490                                  
  4491                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4492                                  
  4493 00001AB1 A1[2F00]                 mov ax, [DOS_ERR]
  4494 00001AB4 08C0                     or  al, al
  4495 00001AB6 0F841C00                 je @@getarg199
  4496 00001ABA 68[AC1B]                 push getarg_5
  4497 00001ABD E8DC02                   call cputs
  4498 00001AC0 83C402                   add  sp, 2
  4499 00001AC3 8D069376                 lea  ax, [namelst]
  4500 00001AC7 50                       push ax
  4501 00001AC8 E8D102                   call cputs
  4502 00001ACB 83C402                   add  sp, 2
  4503 00001ACE 6A02                     push 2
  4504 00001AD0 E8A404                   call exitR
  4505 00001AD3 83C402                   add  sp, 2
  4506                                  
  4507                                  ;-19   bin_fd=creatR(namebin);
  4508                                  
  4509                                  @@getarg199:
  4510 00001AD6 8D06D676                 lea  ax, [namebin]
  4511 00001ADA 50                       push ax
  4512 00001ADB E84F04                   call creatR
  4513 00001ADE 83C402                   add  sp, 2
  4514 00001AE1 A3[2D00]                 mov word [bin_fd], ax
  4515                                  
  4516                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4517                                  
  4518 00001AE4 A1[2F00]                 mov ax, [DOS_ERR]
  4519 00001AE7 08C0                     or  al, al
  4520 00001AE9 0F841C00                 je @@getarg200
  4521 00001AED 68[C31B]                 push getarg_6
  4522 00001AF0 E8A902                   call cputs
  4523 00001AF3 83C402                   add  sp, 2
  4524 00001AF6 8D06D676                 lea  ax, [namebin]
  4525 00001AFA 50                       push ax
  4526 00001AFB E89E02                   call cputs
  4527 00001AFE 83C402                   add  sp, 2
  4528 00001B01 6A02                     push 2
  4529 00001B03 E87104                   call exitR
  4530 00001B06 83C402                   add  sp, 2
  4531                                  
  4532                                  ;-21   prs(";");prs(Version1);
  4533                                  
  4534                                  @@getarg200:
  4535 00001B09 68[D91B]                 push getarg_7
  4536 00001B0C E8B2FB                   call prs
  4537 00001B0F 83C402                   add  sp, 2
  4538 00001B12 8D06[1000]               lea  ax, [Version1]
  4539 00001B16 50                       push ax
  4540 00001B17 E8A7FB                   call prs
  4541 00001B1A 83C402                   add  sp, 2
  4542                                  
  4543                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4544                                  
  4545 00001B1D 68[DB1B]                 push getarg_8
  4546 00001B20 E89EFB                   call prs
  4547 00001B23 83C402                   add  sp, 2
  4548 00001B26 8D065076                 lea  ax, [namein]
  4549 00001B2A 50                       push ax
  4550 00001B2B E893FB                   call prs
  4551 00001B2E 83C402                   add  sp, 2
  4552 00001B31 68[E61B]                 push getarg_9
  4553 00001B34 E88AFB                   call prs
  4554 00001B37 83C402                   add  sp, 2
  4555 00001B3A 8D069376                 lea  ax, [namelst]
  4556 00001B3E 50                       push ax
  4557 00001B3F E87FFB                   call prs
  4558 00001B42 83C402                   add  sp, 2
  4559                                  
  4560                                  ;-23   prs(", "); prs(namebin);
  4561                                  
  4562 00001B45 68[F11B]                 push getarg_10
  4563 00001B48 E876FB                   call prs
  4564 00001B4B 83C402                   add  sp, 2
  4565 00001B4E 8D06D676                 lea  ax, [namebin]
  4566 00001B52 50                       push ax
  4567 00001B53 E86BFB                   call prs
  4568 00001B56 83C402                   add  sp, 2
  4569                                  
  4570                                  ;-24   prs("\n");
  4571                                  
  4572 00001B59 68[F41B]                 push getarg_11
  4573 00001B5C E862FB                   call prs
  4574 00001B5F 83C402                   add  sp, 2
  4575                                  
  4576                                  ;-25 }
  4577                                  
  4578                                  
  4579                                  ;-26 int epilog() { int i; int j; char c;
  4580 00001B62 C9                       LEAVE
  4581 00001B63 C3                       ret
  4582                                  ; ENDP
  4583 00001B64 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4584 00001B6D 41532E434F4D206669-
  4585 00001B76 6C656E616D65205B77-
  4586 00001B7F 2F6F202E535D203A20-
  4587 00001B88 00                 
  4588 00001B89 2E5300                  getarg_1 db ".S",0
  4589 00001B8C 2E4C535400              getarg_2 db ".LST",0
  4590 00001B91 2E434F4D00              getarg_3 db ".COM",0
  4591 00001B96 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4592 00001B9F 6C65206D697373696E-
  4593 00001BA8 673A2000           
  4594 00001BAC 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4595 00001BB5 206E6F742063726561-
  4596 00001BBE 74653A2000         
  4597 00001BC3 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4598 00001BCC 6E6F74206372656174-
  4599 00001BD5 653A2000           
  4600 00001BD9 3B00                    getarg_7 db ";",0
  4601 00001BDB 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4602 00001BE4 2000               
  4603 00001BE6 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4604 00001BEF 2000               
  4605 00001BF1 2C2000                  getarg_10 db ", ",0
  4606 00001BF4 5C6E00                  getarg_11 db "\n",0
  4607                                  
  4608                                  epilog:  ; *** PROC ***
  4609                                  
  4610                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4611                                  
  4612                                  ;Function : epilog, Number of local variables: 3
  4613                                  ;   # type sign width line used address name   list of local variables
  4614                                  ;  200 var sign word    26 NULL bp-2    i
  4615                                  ;  201 var sign word    26 NULL bp-4    j
  4616                                  ;  202 var sign byte    26 NULL bp-6    c;
  4617 00001BF7 C8060000                 ENTER  6,0
  4618 00001BFB 68[201D]                 push epilog_0
  4619 00001BFE E8C0FA                   call prs
  4620 00001C01 83C402                   add  sp, 2
  4621 00001C04 FF36[3100]               push word [ErrorCount]
  4622 00001C08 E8D1FB                   call printIntU
  4623 00001C0B 83C402                   add  sp, 2
  4624                                  
  4625                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4626                                  
  4627 00001C0E A1[3100]                 mov ax, [ErrorCount]
  4628 00001C11 08C0                     or  al, al
  4629 00001C13 0F840900                 je @@epilog201
  4630 00001C17 68[301D]                 push epilog_1
  4631 00001C1A E8A4FA                   call prs
  4632 00001C1D 83C402                   add  sp, 2
  4633                                  
  4634                                  ;-29   prs(", Label & Var: ");
  4635                                  
  4636                                  @@epilog201:
  4637 00001C20 68[3E1D]                 push epilog_2
  4638 00001C23 E89BFA                   call prs
  4639 00001C26 83C402                   add  sp, 2
  4640                                  
  4641                                  ;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4642                                  
  4643                                  
  4644                                  ;-31   i= &LabelNames;
  4645                                  
  4646                                  
  4647                                  ;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4648                                  
  4649                                  
  4650                                  ;-33   } while (i < LabelNamePtr); prs("<< \n"); */
  4651                                  
  4652                                  
  4653                                  ;-34   if (LabelMaxIx) {
  4654                                  
  4655 00001C29 A1[5000]                 mov ax, [LabelMaxIx]
  4656 00001C2C 08C0                     or  al, al
  4657 00001C2E 0F846900                 je @@epilog202
  4658                                  
  4659                                  ;-35     i = 1;
  4660                                  
  4661 00001C32 66B801000000             mov eax, 1
  4662 00001C38 8946FE                   mov word [bp-2], ax
  4663                                  
  4664                                  ;-36     LabelNamePtr= &LabelNames;
  4665                                  
  4666 00001C3B B81E77                   mov ax, LabelNames
  4667 00001C3E A3[4E00]                 mov word [LabelNamePtr], ax
  4668                                  
  4669                                  ;-37     do {
  4670                                  
  4671                                  @@epilog203:
  4672                                  
  4673                                  ;-38       prs(LabelNamePtr); prc(' ');
  4674                                  
  4675 00001C41 FF36[4E00]               push word [LabelNamePtr]
  4676 00001C45 E879FA                   call prs
  4677 00001C48 83C402                   add  sp, 2
  4678 00001C4B 6A20                     push 32
  4679 00001C4D E810FA                   call prc
  4680 00001C50 83C402                   add  sp, 2
  4681                                  
  4682                                  ;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4683                                  
  4684 00001C53 8B5EFE                   mov bx, [bp-2]
  4685 00001C56 D1E3                     shl bx, 1
  4686 00001C58 8B87067B                 mov ax, [LabelAddr + bx]
  4687 00001C5C 8946FC                   mov word [bp-4], ax
  4688 00001C5F FF76FC                   push word [bp-4]
  4689 00001C62 E84DFB                   call printhex16
  4690 00001C65 83C402                   add  sp, 2
  4691 00001C68 68[4E1D]                 push epilog_3
  4692 00001C6B E853FA                   call prs
  4693 00001C6E 83C402                   add  sp, 2
  4694                                  
  4695                                  ;-40       j=strlen(LabelNamePtr);//get end of actual name
  4696                                  
  4697 00001C71 FF36[4E00]               push word [LabelNamePtr]
  4698 00001C75 E89501                   call strlen
  4699 00001C78 83C402                   add  sp, 2
  4700 00001C7B 8946FC                   mov word [bp-4], ax
  4701                                  
  4702                                  ;-41       LabelNamePtr=LabelNamePtr+j;
  4703                                  
  4704 00001C7E A1[4E00]                 mov ax, [LabelNamePtr]
  4705 00001C81 0346FC                   add ax, [bp-4]
  4706 00001C84 A3[4E00]                 mov word [LabelNamePtr], ax
  4707                                  
  4708                                  ;-42       LabelNamePtr++;
  4709                                  
  4710 00001C87 FF06[4E00]               inc  word [LabelNamePtr]
  4711                                  
  4712                                  ;-43       i++;
  4713                                  
  4714 00001C8B FF46FE                   inc  word [bp-2]
  4715                                  
  4716                                  ;-44     } while (i <= LabelMaxIx);
  4717                                  
  4718 00001C8E 8B46FE                   mov ax, [bp-2]
  4719 00001C91 3B06[5000]               cmp ax, [LabelMaxIx]
  4720 00001C95 0F8F0200                 jg  @@epilog204
  4721 00001C99 EBA6                     jmp @@epilog203
  4722                                  @@epilog204:
  4723                                  
  4724                                  ;-45   }
  4725                                  
  4726                                  
  4727                                  ;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4728                                  
  4729                                  @@epilog202:
  4730 00001C9B 68[521D]                 push epilog_4
  4731 00001C9E E820FA                   call prs
  4732 00001CA1 83C402                   add  sp, 2
  4733 00001CA4 FF36[5400]               push word [BinLen]
  4734 00001CA8 E831FB                   call printIntU
  4735 00001CAB 83C402                   add  sp, 2
  4736 00001CAE 68[5F1D]                 push epilog_5
  4737 00001CB1 E80DFA                   call prs
  4738 00001CB4 83C402                   add  sp, 2
  4739                                  
  4740                                  ;-47   i=0;
  4741                                  
  4742 00001CB7 66B800000000             mov eax, 0
  4743 00001CBD 8946FE                   mov word [bp-2], ax
  4744                                  
  4745                                  ;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4746                                  
  4747                                  @@epilog205:
  4748 00001CC0 6A20                     push 32
  4749 00001CC2 E89BF9                   call prc
  4750 00001CC5 83C402                   add  sp, 2
  4751 00001CC8 8B5EFE                   mov bx, [bp-2]
  4752 00001CCB 8A87CE7B                 mov al, [FileBin + bx]
  4753 00001CCF 8946FC                   mov word [bp-4], ax
  4754 00001CD2 FF76FC                   push word [bp-4]
  4755 00001CD5 E88CFA                   call printhex8a
  4756 00001CD8 83C402                   add  sp, 2
  4757 00001CDB FF46FE                   inc  word [bp-2]
  4758                                  
  4759                                  ;-49   } while (i < BinLen);
  4760                                  
  4761 00001CDE 8B46FE                   mov ax, [bp-2]
  4762 00001CE1 3B06[5400]               cmp ax, [BinLen]
  4763 00001CE5 0F8D0200                 jge @@epilog206
  4764 00001CE9 EBD5                     jmp @@epilog205
  4765                                  @@epilog206:
  4766                                  
  4767                                  ;-50   i=0;
  4768                                  
  4769 00001CEB 66B800000000             mov eax, 0
  4770 00001CF1 8946FE                   mov word [bp-2], ax
  4771                                  
  4772                                  ;-51   do {
  4773                                  
  4774                                  @@epilog207:
  4775                                  
  4776                                  ;-52     c = FileBin[i];
  4777                                  
  4778 00001CF4 8B5EFE                   mov bx, [bp-2]
  4779 00001CF7 8A87CE7B                 mov al, [FileBin + bx]
  4780 00001CFB 8846FA                   mov byte [bp-6], al
  4781                                  
  4782                                  ;-53     fputcR(c, bin_fd);
  4783                                  
  4784 00001CFE FF36[2D00]               push word [bin_fd]
  4785 00001D02 8A46FA                   mov al, byte [bp-6]
  4786 00001D05 B400                     mov ah, 0
  4787 00001D07 50                       push ax
  4788 00001D08 E84902                   call fputcR
  4789 00001D0B 83C404                   add  sp, 4
  4790                                  
  4791                                  ;-54     i++;
  4792                                  
  4793 00001D0E FF46FE                   inc  word [bp-2]
  4794                                  
  4795                                  ;-55   } while (i < BinLen);
  4796                                  
  4797 00001D11 8B46FE                   mov ax, [bp-2]
  4798 00001D14 3B06[5400]               cmp ax, [BinLen]
  4799 00001D18 0F8D0200                 jge @@epilog208
  4800 00001D1C EBD6                     jmp @@epilog207
  4801                                  @@epilog208:
  4802                                  
  4803                                  ;-56 }
  4804                                  
  4805                                  
  4806                                  ;-57 int end1(int n) {
  4807 00001D1E C9                       LEAVE
  4808 00001D1F C3                       ret
  4809                                  ; ENDP
  4810 00001D20 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4811 00001D29 726F72733A2000     
  4812 00001D30 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4813 00001D39 2A2A2A2000         
  4814 00001D3E 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4815 00001D47 205661723A2000     
  4816 00001D4E 2C202000                epilog_3 db ",  ",0
  4817 00001D52 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4818 00001D5B 6C652000           
  4819 00001D5F 2062797465733A00        epilog_5 db " bytes:",0
  4820                                  
  4821                                  end1:  ; *** PROC ***
  4822                                  
  4823                                  ;-58   fcloseR(asm_fd);
  4824                                  
  4825                                  ;Function : end1, Number of local variables: 1
  4826                                  ;   # type sign width line used address name   list of local variables
  4827                                  ;  200 var sign word    57 NULL bp+4    n;
  4828 00001D67 C8000000                 ENTER  0,0
  4829 00001D6B FF36[2900]               push word [asm_fd]
  4830 00001D6F E8F701                   call fcloseR
  4831 00001D72 83C402                   add  sp, 2
  4832                                  
  4833                                  ;-59   fcloseR(lst_fd);
  4834                                  
  4835 00001D75 FF36[2B00]               push word [lst_fd]
  4836 00001D79 E8ED01                   call fcloseR
  4837 00001D7C 83C402                   add  sp, 2
  4838                                  
  4839                                  ;-60   fcloseR(bin_fd);
  4840                                  
  4841 00001D7F FF36[2D00]               push word [bin_fd]
  4842 00001D83 E8E301                   call fcloseR
  4843 00001D86 83C402                   add  sp, 2
  4844                                  
  4845                                  ;-61   exitR(n);
  4846                                  
  4847 00001D89 FF7604                   push word [bp+4]
  4848 00001D8C E8E801                   call exitR
  4849 00001D8F 83C402                   add  sp, 2
  4850                                  
  4851                                  ;-62 }
  4852 00001D92 C9                       LEAVE
  4853 00001D93 C3                       ret
  4854                                  ; ENDP
  4855                                  ;Back to main program: AS.C
  4856                                   
  4857                                  ; missing functions: 
  4858                                  ; digit
  4859                                  ; eqstr
  4860                                  ; eqstr
  4861                                  ; eqstr
  4862                                  ; strcpy
  4863                                  ; eqstr
  4864                                  ; strlen
  4865                                  ; eqstr
  4866                                  ; readRL
  4867                                  ; readRL
  4868                                  ; digit
  4869                                  ; digit
  4870                                  ; strcpy
  4871                                  ; toupper
  4872                                  ; strlen
  4873                                  ; strlen
  4874                                  ; eqstr
  4875                                  ; eqstr
  4876                                  ; eqstr
  4877                                  ; eqstr
  4878                                  ; eqstr
  4879                                  ; eqstr
  4880                                  ; eqstr
  4881                                  ; eqstr
  4882                                  ; eqstr
  4883                                  ; eqstr
  4884                                  ; eqstr
  4885                                  ; eqstr
  4886                                  ; eqstr
  4887                                  ; eqstr
  4888                                  ; eqstr
  4889                                  ; eqstr
  4890                                  ; eqstr
  4891                                  ; eqstr
  4892                                  ; eqstr
  4893                                  ; eqstr
  4894                                  ; eqstr
  4895                                  ; eqstr
  4896                                  ; eqstr
  4897                                  ; eqstr
  4898                                  ; eqstr
  4899                                  ; eqstr
  4900                                  ; eqstr
  4901                                  ; eqstr
  4902                                  ; eqstr
  4903                                  ; eqstr
  4904                                  ; writetty
  4905                                  ; writetty
  4906                                  ; fputcR
  4907                                  ; cputs
  4908                                  ; cputs
  4909                                  ; exitR
  4910                                  ; toupper
  4911                                  ; strcpy
  4912                                  ; strcat1
  4913                                  ; strcpy
  4914                                  ; strcat1
  4915                                  ; strcpy
  4916                                  ; strcat1
  4917                                  ; openR
  4918                                  ; cputs
  4919                                  ; cputs
  4920                                  ; exitR
  4921                                  ; creatR
  4922                                  ; cputs
  4923                                  ; cputs
  4924                                  ; exitR
  4925                                  ; creatR
  4926                                  ; cputs
  4927                                  ; cputs
  4928                                  ; exitR
  4929                                  ; strlen
  4930                                  ; fputcR
  4931                                  ; fcloseR
  4932                                  ; fcloseR
  4933                                  ; fcloseR
  4934                                  ; exitR
  4935                                  ; Number of unresolved CALLs :   77
  4936                                  ;use archive file: AR.C
  4937                                  
  4938                                  ;-209 // AR.C Archive
  4939                                  
  4940                                  ;Number of CALLs:    2 : writetty
  4941                                  
  4942                                  writetty:  ; *** PROC ***
  4943 00001D94 B40E                     mov  ah, 14
  4944 00001D96 BB0000                   mov  bx, 0
  4945 00001D99 CD10                     int  16
  4946                                  
  4947                                  ;-210 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  4948                                  
  4949 00001D9B C3                       ret
  4950                                  ; ENDP
  4951                                  ;Number of CALLs:    8 : cputs
  4952                                  
  4953                                  cputs:  ; *** PROC ***
  4954                                  ;Function : cputs, Number of local variables: 2
  4955                                  ;   # type sign width line used address name   list of local variables
  4956                                  ;  200 ptr sign byte   210 NULL bp+4    s
  4957                                  ;  201 var sign byte   210 NULL bp-2    c;
  4958 00001D9C C8020000                 ENTER  2,0
  4959                                  @@cputs209:
  4960 00001DA0 8B5E04                   mov bx, [bp+4]
  4961 00001DA3 8A07                     mov al, [bx]
  4962 00001DA5 B400                     mov ah, 0
  4963 00001DA7 08C0                     or  al, al
  4964 00001DA9 0F841B00                 je @@cputs210
  4965 00001DAD 8B5E04                   mov bx, [bp+4]
  4966 00001DB0 8A07                     mov al, [bx]
  4967 00001DB2 B400                     mov ah, 0
  4968 00001DB4 8846FE                   mov byte [bp-2], al
  4969 00001DB7 8A46FE                   mov al, byte [bp-2]
  4970 00001DBA B400                     mov ah, 0
  4971 00001DBC 50                       push ax
  4972 00001DBD E8C401                   call putch
  4973 00001DC0 83C402                   add  sp, 2
  4974 00001DC3 FF4604                   inc  word [bp+4]
  4975 00001DC6 EBD8                     jmp @@cputs209
  4976                                  @@cputs210:
  4977                                  
  4978                                  ;-211 int mkneg(int n) { n; __asm {neg ax} }
  4979 00001DC8 C9                       LEAVE
  4980 00001DC9 C3                       ret
  4981                                  ; ENDP
  4982                                  ;Number of CALLs:    2 : toupper
  4983                                  
  4984                                  toupper:  ; *** PROC ***
  4985                                  ;Function : toupper, Number of local variables: 1
  4986                                  ;   # type sign width line used address name   list of local variables
  4987                                  ;  200 ptr sign byte   211 NULL bp+4    s;
  4988 00001DCA C8000000                 ENTER  0,0
  4989                                  @@toupper211:
  4990 00001DCE 8B5E04                   mov bx, [bp+4]
  4991 00001DD1 8A07                     mov al, [bx]
  4992 00001DD3 B400                     mov ah, 0
  4993 00001DD5 08C0                     or  al, al
  4994 00001DD7 0F843000                 je @@toupper212
  4995 00001DDB 8B5E04                   mov bx, [bp+4]
  4996 00001DDE 8A07                     mov al, [bx]
  4997 00001DE0 B400                     mov ah, 0
  4998 00001DE2 83F861                   cmp ax, 97 ;unsigned : 1
  4999 00001DE5 0F8C1D00                 jl  @@toupper213
  5000 00001DE9 8B5E04                   mov bx, [bp+4]
  5001 00001DEC 8A07                     mov al, [bx]
  5002 00001DEE B400                     mov ah, 0
  5003 00001DF0 83F87A                   cmp ax, 122
  5004 00001DF3 0F8F0F00                 jg  @@toupper214
  5005 00001DF7 8B5E04                   mov bx, [bp+4]
  5006 00001DFA 8A07                     mov al, [bx]
  5007 00001DFC B400                     mov ah, 0
  5008 00001DFE 83E820                   sub ax, 32
  5009 00001E01 8B5E04                   mov  bx, [bp+4]
  5010 00001E04 8807                     mov  [bx], al
  5011                                  @@toupper214:
  5012                                  @@toupper213:
  5013 00001E06 FF4604                   inc  word [bp+4]
  5014 00001E09 EBC3                     jmp @@toupper211
  5015                                  @@toupper212:
  5016                                  
  5017                                  ;-212 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5018                                  
  5019                                  
  5020                                  ;-213 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5021 00001E0B C9                       LEAVE
  5022 00001E0C C3                       ret
  5023                                  ; ENDP
  5024                                  ;Number of CALLs:    4 : strlen
  5025                                  
  5026                                  strlen:  ; *** PROC ***
  5027                                  ;Function : strlen, Number of local variables: 2
  5028                                  ;   # type sign width line used address name   list of local variables
  5029                                  ;  200 ptr sign byte   213 NULL bp+4    s
  5030                                  ;  201 var sign word   213 NULL bp-2    c;
  5031 00001E0D C8020000                 ENTER  2,0
  5032 00001E11 66B800000000             mov eax, 0
  5033 00001E17 8946FE                   mov word [bp-2], ax
  5034                                  @@strlen215:
  5035 00001E1A 8B5E04                   mov bx, [bp+4]
  5036 00001E1D 8A07                     mov al, [bx]
  5037 00001E1F B400                     mov ah, 0
  5038 00001E21 83F800                   cmp ax, 0
  5039 00001E24 0F840800                 je  @@strlen216
  5040 00001E28 FF4604                   inc  word [bp+4]
  5041 00001E2B FF46FE                   inc  word [bp-2]
  5042 00001E2E EBEA                     jmp @@strlen215
  5043                                  @@strlen216:
  5044 00001E30 8B46FE                   mov ax, [bp-2]
  5045 00001E33 E90000                   jmp @@retn
  5046                                  
  5047                                  ;-214 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5048                                  
  5049 00001E36 C9                      @@retn: LEAVE
  5050 00001E37 C3                       ret
  5051                                  ; ENDP
  5052                                  ;Number of CALLs:    5 : strcpy
  5053                                  
  5054                                  strcpy:  ; *** PROC ***
  5055                                  ;Function : strcpy, Number of local variables: 2
  5056                                  ;   # type sign width line used address name   list of local variables
  5057                                  ;  200 ptr sign byte   214 NULL bp+4    s
  5058                                  ;  201 ptr sign byte   214 NULL bp+6    t;
  5059 00001E38 C8000000                 ENTER  0,0
  5060                                  @@strcpy217:
  5061 00001E3C 8B5E06                   mov bx, [bp+6]
  5062 00001E3F 8A07                     mov al, [bx]
  5063 00001E41 B400                     mov ah, 0
  5064 00001E43 8B5E04                   mov  bx, [bp+4]
  5065 00001E46 8807                     mov  [bx], al
  5066 00001E48 FF4604                   inc  word [bp+4]
  5067 00001E4B FF4606                   inc  word [bp+6]
  5068                                  
  5069                                  ;-215   while (*t!=0); *s=0; return s; }
  5070                                  
  5071 00001E4E 8B5E06                   mov bx, [bp+6]
  5072 00001E51 8A07                     mov al, [bx]
  5073 00001E53 B400                     mov ah, 0
  5074 00001E55 83F800                   cmp ax, 0
  5075 00001E58 0F840200                 je  @@strcpy218
  5076 00001E5C EBDE                     jmp @@strcpy217
  5077                                  @@strcpy218:
  5078 00001E5E 66B800000000             mov eax, 0
  5079 00001E64 8B5E04                   mov  bx, [bp+4]
  5080 00001E67 8807                     mov  [bx], al
  5081 00001E69 8B4604                   mov ax, [bp+4]
  5082 00001E6C E90000                   jmp @@retn
  5083                                  
  5084                                  ;-216 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5085                                  
  5086 00001E6F C9                      @@retn: LEAVE
  5087 00001E70 C3                       ret
  5088                                  ; ENDP
  5089                                  ;Number of CALLs:    3 : digit
  5090                                  
  5091                                  digit:  ; *** PROC ***
  5092                                  ;Function : digit, Number of local variables: 1
  5093                                  ;   # type sign width line used address name   list of local variables
  5094                                  ;  200 var sign byte   216 NULL bp+4    c;
  5095 00001E71 C8000000                 ENTER  0,0
  5096 00001E75 8A4604                   mov al, [bp+4]
  5097 00001E78 3C30                     cmp al, 48
  5098 00001E7A 0F8D0900                 jge @@digit219
  5099 00001E7E 66B800000000             mov eax, 0
  5100 00001E84 E91B00                   jmp @@retn
  5101                                  @@digit219:
  5102 00001E87 8A4604                   mov al, [bp+4]
  5103 00001E8A 3C39                     cmp al, 57
  5104 00001E8C 0F8E0900                 jle @@digit220
  5105 00001E90 66B800000000             mov eax, 0
  5106 00001E96 E90900                   jmp @@retn
  5107                                  @@digit220:
  5108 00001E99 66B801000000             mov eax, 1
  5109 00001E9F E90000                   jmp @@retn
  5110                                  
  5111                                  ;-217 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5112                                  
  5113 00001EA2 C9                      @@retn: LEAVE
  5114 00001EA3 C3                       ret
  5115                                  ; ENDP
  5116                                  ;Number of CALLs:   35 : eqstr
  5117                                  
  5118                                  eqstr:  ; *** PROC ***
  5119                                  ;Function : eqstr, Number of local variables: 2
  5120                                  ;   # type sign width line used address name   list of local variables
  5121                                  ;  200 ptr sign byte   217 NULL bp+4    p
  5122                                  ;  201 ptr sign byte   217 NULL bp+6    q;
  5123 00001EA4 C8000000                 ENTER  0,0
  5124                                  @@eqstr221:
  5125 00001EA8 8B5E04                   mov bx, [bp+4]
  5126 00001EAB 8A07                     mov al, [bx]
  5127 00001EAD B400                     mov ah, 0
  5128 00001EAF 08C0                     or  al, al
  5129 00001EB1 0F842300                 je @@eqstr222
  5130                                  
  5131                                  ;-218     if (*p != *q) return 0; p++; q++; }
  5132                                  
  5133 00001EB5 8B5E04                   mov bx, [bp+4]
  5134 00001EB8 8A07                     mov al, [bx]
  5135 00001EBA B400                     mov ah, 0
  5136 00001EBC 8B5E06                   mov bx, [bp+6]
  5137 00001EBF 3A07                     cmp al, [bx]
  5138 00001EC1 B400                     mov ah, 0
  5139 00001EC3 0F840900                 je  @@eqstr223
  5140 00001EC7 66B800000000             mov eax, 0
  5141 00001ECD E92700                   jmp @@retn
  5142                                  @@eqstr223:
  5143 00001ED0 FF4604                   inc  word [bp+4]
  5144 00001ED3 FF4606                   inc  word [bp+6]
  5145                                  
  5146                                  ;-219     if(*q) return 0; return 1; }
  5147                                  
  5148 00001ED6 EBD0                     jmp @@eqstr221
  5149                                  @@eqstr222:
  5150 00001ED8 8B5E06                   mov bx, [bp+6]
  5151 00001EDB 8A07                     mov al, [bx]
  5152 00001EDD B400                     mov ah, 0
  5153 00001EDF 08C0                     or  al, al
  5154 00001EE1 0F840900                 je @@eqstr224
  5155 00001EE5 66B800000000             mov eax, 0
  5156 00001EEB E90900                   jmp @@retn
  5157                                  @@eqstr224:
  5158 00001EEE 66B801000000             mov eax, 1
  5159 00001EF4 E90000                   jmp @@retn
  5160                                  
  5161                                  ;-220 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5162                                  
  5163 00001EF7 C9                      @@retn: LEAVE
  5164 00001EF8 C3                       ret
  5165                                  ; ENDP
  5166                                  ;Number of CALLs:    3 : strcat1
  5167                                  
  5168                                  strcat1:  ; *** PROC ***
  5169                                  ;Function : strcat1, Number of local variables: 2
  5170                                  ;   # type sign width line used address name   list of local variables
  5171                                  ;  200 ptr sign byte   220 NULL bp+4    s
  5172                                  ;  201 ptr sign byte   220 NULL bp+6    t;
  5173 00001EF9 C8000000                 ENTER  0,0
  5174                                  @@strcat1225:
  5175 00001EFD 8B5E04                   mov bx, [bp+4]
  5176 00001F00 8A07                     mov al, [bx]
  5177 00001F02 B400                     mov ah, 0
  5178 00001F04 83F800                   cmp ax, 0
  5179 00001F07 0F840500                 je  @@strcat1226
  5180 00001F0B FF4604                   inc  word [bp+4]
  5181 00001F0E EBED                     jmp @@strcat1225
  5182                                  @@strcat1226:
  5183 00001F10 FF7606                   push word [bp+6]
  5184 00001F13 FF7604                   push word [bp+4]
  5185 00001F16 E81FFF                   call strcpy
  5186 00001F19 83C404                   add  sp, 4
  5187                                  
  5188                                  ;-221 int basename(char *s) { char *p; p=0;
  5189 00001F1C C9                       LEAVE
  5190 00001F1D C3                       ret
  5191                                  ; ENDP
  5192                                  ;Number of CALLs:    1 : openR
  5193                                  
  5194                                  openR:  ; *** PROC ***
  5195                                  ;Function : openR, Number of local variables: 1
  5196                                  ;   # type sign width line used address name   list of local variables
  5197                                  ;  200 ptr sign byte   221 NULL bp+4    s;
  5198 00001F1E C8000000                 ENTER  0,0
  5199 00001F22 8B5604                   mov  dx, [bp+4]
  5200 00001F25 B8023D                   mov  ax, 15618
  5201 00001F28 E87200                   call DosInt
  5202                                  
  5203                                  ;-222 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5204 00001F2B C9                       LEAVE
  5205 00001F2C C3                       ret
  5206                                  ; ENDP
  5207                                  ;Number of CALLs:    2 : creatR
  5208                                  
  5209                                  creatR:  ; *** PROC ***
  5210                                  ;Function : creatR, Number of local variables: 1
  5211                                  ;   # type sign width line used address name   list of local variables
  5212                                  ;  200 ptr sign byte   222 NULL bp+4    s;
  5213 00001F2D C8000000                 ENTER  0,0
  5214 00001F31 8B5604                   mov  dx, [bp+4]
  5215 00001F34 B90000                   mov  cx, 0
  5216 00001F37 B8003C                   mov  ax, 15360
  5217 00001F3A E86000                   call DosInt
  5218                                  
  5219                                  ;-223 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5220 00001F3D C9                       LEAVE
  5221 00001F3E C3                       ret
  5222                                  ; ENDP
  5223                                  ;Number of CALLs:    2 : readRL
  5224                                  
  5225                                  readRL:  ; *** PROC ***
  5226                                  ;Function : readRL, Number of local variables: 3
  5227                                  ;   # type sign width line used address name   list of local variables
  5228                                  ;  200 ptr sign byte   223 NULL bp+4    s
  5229                                  ;  201 var sign word   223 NULL bp+6    fd
  5230                                  ;  202 var sign word   223 NULL bp+8    len;
  5231 00001F3F C8000000                 ENTER  0,0
  5232 00001F43 8B5604                   mov  dx, [bp+4]
  5233 00001F46 8B4E08                   mov  cx, [bp+8]
  5234 00001F49 8B5E06                   mov  bx, [bp+6]
  5235 00001F4C B8003F                   mov  ax, 16128
  5236 00001F4F E84B00                   call DosInt
  5237                                  
  5238                                  ;-224 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5239 00001F52 C9                       LEAVE
  5240 00001F53 C3                       ret
  5241                                  ; ENDP
  5242                                  ;Number of CALLs:    2 : fputcR
  5243                                  
  5244                                  fputcR:  ; *** PROC ***
  5245                                  ;Function : fputcR, Number of local variables: 2
  5246                                  ;   # type sign width line used address name   list of local variables
  5247                                  ;  200 ptr sign byte   224 NULL bp+4    n
  5248                                  ;  201 var sign word   224 NULL bp+6    fd;
  5249 00001F54 C8000000                 ENTER  0,0
  5250 00001F58 8D5604                  lea dx, [bp+4]
  5251                                  
  5252                                  ;-225   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5253                                  
  5254 00001F5B B90100                   mov  cx, 1
  5255 00001F5E 8B5E06                   mov  bx, [bp+6]
  5256 00001F61 B80040                   mov  ax, 16384
  5257 00001F64 E83600                   call DosInt
  5258                                  
  5259                                  ;-226 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5260 00001F67 C9                       LEAVE
  5261 00001F68 C3                       ret
  5262                                  ; ENDP
  5263                                  ;Number of CALLs:    3 : fcloseR
  5264                                  
  5265                                  fcloseR:  ; *** PROC ***
  5266                                  ;Function : fcloseR, Number of local variables: 1
  5267                                  ;   # type sign width line used address name   list of local variables
  5268                                  ;  200 var sign word   226 NULL bp+4    fd;
  5269 00001F69 C8000000                 ENTER  0,0
  5270 00001F6D 8B5E04                   mov  bx, [bp+4]
  5271 00001F70 B8003E                   mov  ax, 15872
  5272 00001F73 CD21                     int  33
  5273                                  
  5274                                  ;-227 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5275 00001F75 C9                       LEAVE
  5276 00001F76 C3                       ret
  5277                                  ; ENDP
  5278                                  ;Number of CALLs:    5 : exitR
  5279                                  
  5280                                  exitR:  ; *** PROC ***
  5281                                  ;Function : exitR, Number of local variables: 1
  5282                                  ;   # type sign width line used address name   list of local variables
  5283                                  ;  200 var sign byte   227 NULL bp+4    c;
  5284 00001F77 C8000000                 ENTER  0,0
  5285 00001F7B B44C                     mov  ah, 76
  5286 00001F7D 8A4604                   mov  al, [bp+4]
  5287 00001F80 CD21                     int  33
  5288                                  
  5289                                  ;-228 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5290 00001F82 C9                       LEAVE
  5291 00001F83 C3                       ret
  5292                                  ; ENDP
  5293                                  ;End of archive file. 
  5294                                   
  5295                                  ; missing functions: 
  5296                                  ; putch
  5297                                  ; DosInt
  5298                                  ; DosInt
  5299                                  ; DosInt
  5300                                  ; DosInt
  5301                                  ; Number of unresolved CALLs :    5
  5302                                  ;use archive file: AR.C
  5303                                  
  5304                                  ;-229 // AR.C Archive
  5305                                  
  5306                                  ;Number of CALLs:    1 : putch
  5307                                  
  5308                                  putch:  ; *** PROC ***
  5309                                  ;Function : putch, Number of local variables: 1
  5310                                  ;   # type sign width line used address name   list of local variables
  5311                                  ;  200 var sign byte   229 NULL bp+4    c;
  5312 00001F84 C8000000                 ENTER  0,0
  5313 00001F88 807E040A                cmp byte [bp+4], 10
  5314 00001F8C 0F850500                 jne @@putch227
  5315 00001F90 B00D                     mov  al, 13
  5316 00001F92 E8FFFD                   call writetty
  5317                                  @@putch227:
  5318 00001F95 8A4604                   mov  al, [bp+4]
  5319 00001F98 E8F9FD                   call writetty
  5320                                  
  5321                                  ;-230 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5322 00001F9B C9                       LEAVE
  5323 00001F9C C3                       ret
  5324                                  ; ENDP
  5325                                  ;Number of CALLs:    4 : DosInt
  5326                                  
  5327                                  DosInt:  ; *** PROC ***
  5328 00001F9D CD21                     int  33
  5329 00001F9F 7304                     jae short @@DosInt228
  5330 00001FA1 FF06[2F00]               inc  word [DOS_ERR]
  5331                                  @@DosInt228:
  5332                                  
  5333                                  ;-231 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5334                                  
  5335 00001FA5 C3                       ret
  5336                                  ; ENDP
  5337                                  ;End of archive file. 
  5338                                   
  5339                                  ; missing functions:  All FUNCTIONs in place
  5340 00001FA6 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5341 00001FA9 58                      pop ax
  5342 00001FAA C3                      ret
  5343                                   
  5344                                  ;   # type sign width line used  address name   list of global variables
  5345                                  
  5346                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5347                                  ;    2 var sign byte     1    3        0 LIST
  5348                                  ;    3 arr sign byte     2    7    30000 Symbol[80]
  5349                                  ;    4 arr sign byte     3   36    30080 SymbolUpper[80]
  5350                                  ;    5 var unsg word     4   12        0 SymbolInt
  5351                                  ;    6 arr sign byte     5    3    30160 InputBuf[128]
  5352                                  ;    7 ptr unsg byte     6   23        0 InputPtr
  5353                                  ;    8 arr sign byte     7    5    30288 namein[67]
  5354                                  ;    9 arr sign byte     8    5    30355 namelst[67]
  5355                                  ;   10 arr sign byte     9    5    30422 namebin[67]
  5356                                  ;   11 var sign word    10    4        0 asm_fd
  5357                                  ;   12 var sign word    11    3        0 lst_fd
  5358                                  ;   13 var sign word    12    3        0 bin_fd
  5359                                  ;   14 var sign word    13    6        0 DOS_ERR
  5360                                  ;   15 var sign word    14    4        0 ErrorCount
  5361                                  ;   16 var sign word    15    4        0 DOS_NoBytes
  5362                                  ;   17 var sign byte    16    4        0 DOS_ByteRead
  5363                                  ;   18 var unsg word    18    5        0 PC
  5364                                  ;   19 var unsg word    19    2        0 PCStart
  5365                                  ;   20 var sign byte    20    3        0 isLabel
  5366                                  ;   21 def unsg byte    21    -        0 DIGIT=1
  5367                                  ;   22 def unsg byte    22    -        0 LETTERE=2
  5368                                  ;   23 def unsg byte    23    -        0 ALNUME=3
  5369                                  ;   24 def unsg byte    24    -        0 NOALNUME=4
  5370                                  ;   25 var sign byte    25   20        0 TokeType
  5371                                  ;   26 def unsg byte    26    -        0 BYTE=1
  5372                                  ;   27 def unsg byte    27    -        0 WORD=2
  5373                                  ;   28 def unsg byte    28    -        0 DWORD=3
  5374                                  ;   29 def unsg byte    29    -        0 SEGREG=4
  5375                                  ;   30 def unsg byte    31    -        0 IMM=1
  5376                                  ;   31 def unsg byte    32    -        0 REG=2
  5377                                  ;   32 def unsg byte    33    -        0 DIR=3
  5378                                  ;   33 def unsg byte    34    -        0 IND=4
  5379                                  ;   34 var sign byte    35   13        0 Op1
  5380                                  ;   35 var sign byte    36   12        0 CodeType
  5381                                  ;   36 var sign byte    38   17        0 RegType
  5382                                  ;   37 var sign byte    39   10        0 RegNo
  5383                                  ;   38 var sign byte    40   10        0 OpSize
  5384                                  ;   39 var sign byte    42 NULL        0 NumOprns
  5385                                  ;   40 var sign byte    43    5        0 wflag
  5386                                  ;   41 var sign byte    44 NULL        0 dflag
  5387                                  ;   42 var sign byte    46    4        0 reg
  5388                                  ;   43 var sign word    47   13        0 disp
  5389                                  ;   44 var sign word    48    2        0 imme
  5390                                  ;   45 def unsg byte    50    -        0 OPMAXLEN=5
  5391                                  ;   46 arr sign byte    51    2    30489 OpPos[5]
  5392                                  ;   47 var sign word    52    6        0 OpPrintIndex
  5393                                  ;   48 ptr sign byte    53   16        0 OpCodePtr
  5394                                  ;   49 var sign byte    54    2        0 PrReloc
  5395                                  ;   50 arr sign byte    56    3    30494 LabelNames[1000]
  5396                                  ;   51 ptr sign byte    57   10        0 LabelNamePtr
  5397                                  ;   52 arr unsg word    58    4    31494 LabelAddr[100]
  5398                                  ;   53 var sign word    59    5        0 LabelMaxIx
  5399                                  ;   54 var sign word    60    4        0 LabelIx
  5400                                  ;   55 arr sign byte    62    3    31694 FileBin[2000]
  5401                                  ;   56 var unsg word    63    5        0 BinLen
  5402                                  ;   57 ptr sign byte    65    1        0 arglen
  5403                                  ;   58 ptr sign byte    66    4        0 argv
  5404                                  ;   59 var sign byte     1    1        0 I_START
  5405                                  ;   60 arr sign byte     5 NULL        0 I_PUSHA[9]
  5406                                  ;   61 arr sign byte     6 NULL        0 I_POPA[8]
  5407                                  ;   62 arr sign byte     7 NULL        0 I_NOP[7]
  5408                                  ;   63 arr sign byte     8 NULL        0 I_CBW[7]
  5409                                  ;   64 arr sign byte     9 NULL        0 I_CWDE[8]
  5410                                  ;   65 arr sign byte    10 NULL        0 I_CWD[7]
  5411                                  ;   66 arr sign byte    11 NULL        0 I_CDQ[7]
  5412                                  ;   67 arr sign byte    12 NULL        0 I_WAIT[8]
  5413                                  ;   68 arr sign byte    13 NULL        0 I_PUSHF[9]
  5414                                  ;   69 arr sign byte    14 NULL        0 I_POPF[8]
  5415                                  ;   70 arr sign byte    15 NULL        0 I_SAHF[8]
  5416                                  ;   71 arr sign byte    16 NULL        0 I_LAHF[8]
  5417                                  ;   72 arr sign byte    17 NULL        0 I_MOVSB[9]
  5418                                  ;   73 arr sign byte    18 NULL        0 I_MOVSW[9]
  5419                                  ;   74 arr sign byte    19 NULL        0 I_CMPSB[9]
  5420                                  ;   75 arr sign byte    20 NULL        0 I_CMPSW[9]
  5421                                  ;   76 arr sign byte    21 NULL        0 I_STOSB[9]
  5422                                  ;   77 arr sign byte    22 NULL        0 I_STOSW[9]
  5423                                  ;   78 arr sign byte    23 NULL        0 I_LODSB[9]
  5424                                  ;   79 arr sign byte    24 NULL        0 I_LODSW[9]
  5425                                  ;   80 arr sign byte    25 NULL        0 I_SCASB[9]
  5426                                  ;   81 arr sign byte    26 NULL        0 I_SCASW[9]
  5427                                  ;   82 arr sign byte    27 NULL        0 I_LEAVE[9]
  5428                                  ;   83 arr sign byte    28 NULL        0 I_IRET[8]
  5429                                  ;   84 arr sign byte    29 NULL        0 I_XLAT[8]
  5430                                  ;   85 arr sign byte    30 NULL        0 I_LOCK[8]
  5431                                  ;   86 arr sign byte    31 NULL        0 I_REPNE[9]
  5432                                  ;   87 arr sign byte    32 NULL        0 I_REPNZ[9]
  5433                                  ;   88 arr sign byte    33 NULL        0 I_REPE[8]
  5434                                  ;   89 arr sign byte    34 NULL        0 I_REPZ[8]
  5435                                  ;   90 arr sign byte    35 NULL        0 I_HLT[7]
  5436                                  ;   91 arr sign byte    36 NULL        0 I_CLC[7]
  5437                                  ;   92 arr sign byte    37 NULL        0 I_STC[7]
  5438                                  ;   93 arr sign byte    38 NULL        0 I_CLI[7]
  5439                                  ;   94 arr sign byte    39 NULL        0 I_STI[7]
  5440                                  ;   95 arr sign byte    40 NULL        0 I_CLD[7]
  5441                                  ;   96 arr sign byte    41 NULL        0 I_STD[7]
  5442                                  ;   97 arr sign byte    43 NULL        0 I_INC[9]
  5443                                  ;   98 arr sign byte    44 NULL        0 I_DEC[9]
  5444                                  ;   99 arr sign byte    46 NULL        0 I_NOT[8]
  5445                                  ;  100 arr sign byte    47 NULL        0 I_NEG[8]
  5446                                  ;  101 arr sign byte    48 NULL        0 I_MUL[8]
  5447                                  ;  102 arr sign byte    49 NULL        0 I_IMUL[9]
  5448                                  ;  103 arr sign byte    50 NULL        0 I_DIV[8]
  5449                                  ;  104 arr sign byte    51 NULL        0 I_IDIV[9]
  5450                                  ;  105 arr sign byte    53 NULL        0 I_LES[7]
  5451                                  ;  106 arr sign byte    54 NULL        0 I_LDS[7]
  5452                                  ;  107 arr sign byte    55 NULL        0 I_LEA[7]
  5453                                  ;  108 arr sign byte    57 NULL        0 I_ADD[7]
  5454                                  ;  109 arr sign byte    58 NULL        0 I_OR[6]
  5455                                  ;  110 arr sign byte    59 NULL        0 I_ADC[7]
  5456                                  ;  111 arr sign byte    60 NULL        0 I_SBB[7]
  5457                                  ;  112 arr sign byte    61 NULL        0 I_AND[7]
  5458                                  ;  113 arr sign byte    62 NULL        0 I_SUB[7]
  5459                                  ;  114 arr sign byte    63 NULL        0 I_XOR[7]
  5460                                  ;  115 arr sign byte    64 NULL        0 I_CMP[7]
  5461                                  ;  116 arr sign byte    66 NULL        0 I_MOV[6]
  5462                                  ;  117 arr sign byte    68 NULL        0 I_JO[6]
  5463                                  ;  118 arr sign byte    69 NULL        0 I_JNO[7]
  5464                                  ;  119 arr sign byte    70 NULL        0 I_JB[6]
  5465                                  ;  120 arr sign byte    71 NULL        0 I_JC[6]
  5466                                  ;  121 arr sign byte    72 NULL        0 I_JNB[7]
  5467                                  ;  122 arr sign byte    73 NULL        0 I_JAE[7]
  5468                                  ;  123 arr sign byte    74 NULL        0 I_JNC[7]
  5469                                  ;  124 arr sign byte    75 NULL        0 I_JE[6]
  5470                                  ;  125 arr sign byte    76 NULL        0 I_JZ[6]
  5471                                  ;  126 arr sign byte    77 NULL        0 I_JNE[7]
  5472                                  ;  127 arr sign byte    78 NULL        0 I_JNZ[7]
  5473                                  ;  128 arr sign byte    79 NULL        0 I_JBE[7]
  5474                                  ;  129 arr sign byte    80 NULL        0 I_JNA[7]
  5475                                  ;  130 arr sign byte    81 NULL        0 I_JA[6]
  5476                                  ;  131 arr sign byte    82 NULL        0 I_JS[6]
  5477                                  ;  132 arr sign byte    83 NULL        0 I_JNS[7]
  5478                                  ;  133 arr sign byte    84 NULL        0 I_JP[6]
  5479                                  ;  134 arr sign byte    85 NULL        0 I_JPE[7]
  5480                                  ;  135 arr sign byte    86 NULL        0 I_JNP[7]
  5481                                  ;  136 arr sign byte    87 NULL        0 I_JPO[7]
  5482                                  ;  137 arr sign byte    88 NULL        0 I_JL[6]
  5483                                  ;  138 arr sign byte    89 NULL        0 I_JNL[7]
  5484                                  ;  139 arr sign byte    90 NULL        0 I_JGE[7]
  5485                                  ;  140 arr sign byte    91 NULL        0 I_JLE[7]
  5486                                  ;  141 arr sign byte    92 NULL        0 I_JNG[7]
  5487                                  ;  142 arr sign byte    93 NULL        0 I_JG[6]
  5488                                  ;  143 arr sign byte    95 NULL        0 I_RET[8]
  5489                                  ;  144 arr sign byte    97 NULL        0 I_PUSH[8]
  5490                                  ;  145 arr sign byte    98 NULL        0 I_POP[7]
  5491                                  ;  146 arr sign byte   100 NULL        0 I_ORG[6]
  5492                                  ;  147 arr sign byte   101 NULL        0 I_DB[5]
  5493                                  ;  148 arr sign byte   102 NULL        0 I_DW[5]
  5494                                  ;  149 arr sign byte   103 NULL        0 I_DD[5]
  5495                                  ;  150 arr sign byte   104 NULL        0 I_RESB[7]
  5496                                  ;  151 arr sign byte   105 NULL        0 I_RESW[7]
  5497                                  ;  152 arr sign byte   106 NULL        0 I_RESD[7]
  5498                                  ;  153 var sign byte   107 NULL        0 I_END
  5499                                  
  5500                                  
  5501                                  ;   # Calls Line Width  Name   list of functions
  5502                                  
  5503                                  ;    0 NULL    1 word   main
  5504                                  ;    1    1   11 word   process
  5505                                  ;    2   12   44 word   getTokeType
  5506                                  ;    3    2   72 word   LeftOpwCheck
  5507                                  ;    4    1   82 word   getLeftOp
  5508                                  ;    5    1   94 word   setwflag
  5509                                  ;    6    2  102 word   getOp1
  5510                                  ;    7    1  114 word   getIND
  5511                                  ;    8    1  129 word   getIndReg1
  5512                                  ;    9    1  138 word   getIndReg2
  5513                                  ;   10    1  148 word   getCodeSize
  5514                                  ;   11    7  155 word   isToken
  5515                                  ;   12    1  160 word   skipRest
  5516                                  ;   13    1  164 word   gen66h
  5517                                  ;   14    8  165 word   genCode8
  5518                                  ;   15    3  169 word   genCode16
  5519                                  ;   16    7  172 word   genInstruction
  5520                                  ;   17    2  176 word   genCodeInREG
  5521                                  ;   18 NULL  179 word   genModRegRM
  5522                                  ;   19    2  181 word   writeEA
  5523                                  ;   20 NULL  195 word   test1
  5524                                  ;   21    1   16 word   parse
  5525                                  ;   22    2   41 word   storeLabel
  5526                                  ;   23    2   48 word   searchLabel
  5527                                  ;   24    1   59 word   getVariable
  5528                                  ;   25    2   88 word   lookCode
  5529                                  ;   26    1    1 word   getLine
  5530                                  ;   27    1   14 word   ifEOL
  5531                                  ;   28    3   21 word   skipBlank
  5532                                  ;   29    2   26 word   letterE
  5533                                  ;   30    1   34 word   alnumE
  5534                                  ;   31    1   39 word   getDigit
  5535                                  ;   32    1   51 word   getName
  5536                                  ;   33    1   68 word   testReg
  5537                                  ;   34    1    1 word   printLine
  5538                                  ;   35    9   19 word   prc
  5539                                  ;   36    1   23 word   prscomment
  5540                                  ;   37   24   26 word   prs
  5541                                  ;   38    4   31 word   printhex8a
  5542                                  ;   39    2   35 word   printhex16
  5543                                  ;   40    3   38 word   printIntU
  5544                                  ;   41   19   45 word   error1
  5545                                  ;   42 NULL   48 word   allowederror
  5546                                  ;   43 NULL   49 word   implmerror
  5547                                  ;   44    4   50 word   indexerror
  5548                                  ;   45    1   51 word   numbererror
  5549                                  ;   46 NULL   52 word   regmemerror
  5550                                  ;   47    1   53 word   segregerror
  5551                                  ;   48    1   54 word   syntaxerror
  5552                                  ;   49    7   56 word   errorexit
  5553                                  ;   50    1   57 word   addrexit
  5554                                  ;   51 NULL   58 word   internexit
  5555                                  ;   52    1    1 word   getarg
  5556                                  ;   53    1   26 word   epilog
  5557                                  ;   54    2   57 word   end1
  5558                                  ;   55    4  209 word   writetty
  5559                                  ;   56    8  210 word   cputs
  5560                                  ;   57    2  211 word   toupper
  5561                                  ;   58    4  213 word   strlen
  5562                                  ;   59    6  214 word   strcpy
  5563                                  ;   60    3  216 word   digit
  5564                                  ;   61   35  217 word   eqstr
  5565                                  ;   62    3  220 word   strcat1
  5566                                  ;   63    1  221 word   openR
  5567                                  ;   64    2  222 word   creatR
  5568                                  ;   65    2  223 word   readRL
  5569                                  ;   66    2  224 word   fputcR
  5570                                  ;   67    3  226 word   fcloseR
  5571                                  ;   68    5  227 word   exitR
  5572                                  ;   69    1  229 word   putch
  5573                                  ;   70    4  230 word   DosInt
  5574                                  ;   71 NULL  231 word   LastFunctionByt
  5575                                  
  5576                                  ;    #  addr name   list of CALLs
  5577                                  
  5578                                  ;    0     5 getarg
  5579                                  ;    1    12 parse
  5580                                  ;    2    18 epilog
  5581                                  ;    3    25 end1
  5582                                  ;    4  1088 getTokeType
  5583                                  ;    5  1100 getCodeSize
  5584                                  ;    6  1112 genInstruction
  5585                                  ;    7  1127 LeftOpwCheck
  5586                                  ;    8  1140 genInstruction
  5587                                  ;    9  1155 genInstruction
  5588                                  ;   10  1170 genInstruction
  5589                                  ;   11  1185 genCodeInREG
  5590                                  ;   12  1198 LeftOpwCheck
  5591                                  ;   13  1211 genInstruction
  5592                                  ;   14  1226 genCodeInREG
  5593                                  ;   15  1239 genInstruction
  5594                                  ;   16  1254 genCode16
  5595                                  ;   17  1264 genInstruction
  5596                                  ;   18  1279 error1
  5597                                  ;   19  1286 error1
  5598                                  ;   20  1307 skipBlank
  5599                                  ;   21  1317 digit
  5600                                  ;   22  1323 getDigit
  5601                                  ;   23  1332 letterE
  5602                                  ;   24  1340 getName
  5603                                  ;   25  1361 getLeftOp
  5604                                  ;   26  1371 segregerror
  5605                                  ;   27  1383 setwflag
  5606                                  ;   28  1392 error1
  5607                                  ;   29  1399 error1
  5608                                  ;   30  1406 error1
  5609                                  ;   31  1423 getOp1
  5610                                  ;   32  1430 isToken
  5611                                  ;   33  1438 getIND
  5612                                  ;   34  1445 error1
  5613                                  ;   35  1452 error1
  5614                                  ;   36  1468 gen66h
  5615                                  ;   37  1482 testReg
  5616                                  ;   38  1490 searchLabel
  5617                                  ;   39  1502 error1
  5618                                  ;   40  1523 getTokeType
  5619                                  ;   41  1535 getOp1
  5620                                  ;   42  1542 syntaxerror
  5621                                  ;   43  1554 getIndReg2
  5622                                  ;   44  1565 getIndReg1
  5623                                  ;   45  1576 isToken
  5624                                  ;   46  1584 getTokeType
  5625                                  ;   47  1596 numbererror
  5626                                  ;   48  1608 isToken
  5627                                  ;   49  1616 isToken
  5628                                  ;   50  1624 errorexit
  5629                                  ;   51  1647 indexerror
  5630                                  ;   52  1658 indexerror
  5631                                  ;   53  1685 indexerror
  5632                                  ;   54  1696 indexerror
  5633                                  ;   55  1719 eqstr
  5634                                  ;   56  1725 getTokeType
  5635                                  ;   57  1737 eqstr
  5636                                  ;   58  1743 getTokeType
  5637                                  ;   59  1755 eqstr
  5638                                  ;   60  1761 getTokeType
  5639                                  ;   61  1783 skipBlank
  5640                                  ;   62  1802 getTokeType
  5641                                  ;   63  1814 prs
  5642                                  ;   64  1825 genCode8
  5643                                  ;   65  1857 genCode8
  5644                                  ;   66  1866 genCode8
  5645                                  ;   67  1899 genCode8
  5646                                  ;   68  1923 writeEA
  5647                                  ;   69  1943 writeEA
  5648                                  ;   70  1967 addrexit
  5649                                  ;   71  1976 genCode8
  5650                                  ;   72  1985 genCode8
  5651                                  ;   73  1994 genCode16
  5652                                  ;   74  2016 getLine
  5653                                  ;   75  2024 getTokeType
  5654                                  ;   76  2036 storeLabel
  5655                                  ;   77  2047 getTokeType
  5656                                  ;   78  2059 lookCode
  5657                                  ;   79  2068 process
  5658                                  ;   80  2076 getVariable
  5659                                  ;   81  2088 skipRest
  5660                                  ;   82  2097 error1
  5661                                  ;   83  2104 error1
  5662                                  ;   84  2111 printLine
  5663                                  ;   85  2132 searchLabel
  5664                                  ;   86  2144 error1
  5665                                  ;   87  2151 strcpy
  5666                                  ;   88  2178 eqstr
  5667                                  ;   89  2184 strlen
  5668                                  ;   90  2205 storeLabel
  5669                                  ;   91  2216 getTokeType
  5670                                  ;   92  2228 lookCode
  5671                                  ;   93  2237 errorexit
  5672                                  ;   94  2247 errorexit
  5673                                  ;   95  2257 getTokeType
  5674                                  ;   96  2269 genCode8
  5675                                  ;   97  2278 skipBlank
  5676                                  ;   98  2288 isToken
  5677                                  ;   99  2296 genCode8
  5678                                  ;  100  2305 isToken
  5679                                  ;  101  2313 getTokeType
  5680                                  ;  102  2325 genCode16
  5681                                  ;  103  2335 isToken
  5682                                  ;  104  2343 errorexit
  5683                                  ;  105  2362 eqstr
  5684                                  ;  106  2376 readRL
  5685                                  ;  107  2383 errorexit
  5686                                  ;  108  2393 ifEOL
  5687                                  ;  109  2407 readRL
  5688                                  ;  110  2443 digit
  5689                                  ;  111  2449 letterE
  5690                                  ;  112  2476 digit
  5691                                  ;  113  2494 alnumE
  5692                                  ;  114  2501 strcpy
  5693                                  ;  115  2508 toupper
  5694                                  ;  116  2524 strlen
  5695                                  ;  117  2531 strlen
  5696                                  ;  118  2538 eqstr
  5697                                  ;  119  2544 eqstr
  5698                                  ;  120  2550 eqstr
  5699                                  ;  121  2556 eqstr
  5700                                  ;  122  2562 eqstr
  5701                                  ;  123  2568 eqstr
  5702                                  ;  124  2574 eqstr
  5703                                  ;  125  2580 eqstr
  5704                                  ;  126  2586 eqstr
  5705                                  ;  127  2592 eqstr
  5706                                  ;  128  2598 eqstr
  5707                                  ;  129  2604 eqstr
  5708                                  ;  130  2610 eqstr
  5709                                  ;  131  2616 eqstr
  5710                                  ;  132  2622 eqstr
  5711                                  ;  133  2628 eqstr
  5712                                  ;  134  2634 eqstr
  5713                                  ;  135  2640 eqstr
  5714                                  ;  136  2646 eqstr
  5715                                  ;  137  2652 eqstr
  5716                                  ;  138  2658 eqstr
  5717                                  ;  139  2664 eqstr
  5718                                  ;  140  2670 eqstr
  5719                                  ;  141  2676 eqstr
  5720                                  ;  142  2682 eqstr
  5721                                  ;  143  2688 eqstr
  5722                                  ;  144  2694 eqstr
  5723                                  ;  145  2700 eqstr
  5724                                  ;  146  2706 eqstr
  5725                                  ;  147  2712 eqstr
  5726                                  ;  148  2732 prs
  5727                                  ;  149  2736 printhex16
  5728                                  ;  150  2747 prs
  5729                                  ;  151  2751 prc
  5730                                  ;  152  2755 printhex8a
  5731                                  ;  153  2766 prc
  5732                                  ;  154  2770 prs
  5733                                  ;  155  2774 prscomment
  5734                                  ;  156  2791 writetty
  5735                                  ;  157  2800 writetty
  5736                                  ;  158  2809 fputcR
  5737                                  ;  159  2831 prc
  5738                                  ;  160  2847 prc
  5739                                  ;  161  2868 prc
  5740                                  ;  162  2872 prc
  5741                                  ;  163  2894 printhex8a
  5742                                  ;  164  2905 printhex8a
  5743                                  ;  165  2930 printIntU
  5744                                  ;  166  2940 prc
  5745                                  ;  167  2953 prs
  5746                                  ;  168  2957 prs
  5747                                  ;  169  2961 prs
  5748                                  ;  170  2965 prs
  5749                                  ;  171  2982 error1
  5750                                  ;  172  3000 error1
  5751                                  ;  173  3018 error1
  5752                                  ;  174  3037 error1
  5753                                  ;  175  3056 error1
  5754                                  ;  176  3075 error1
  5755                                  ;  177  3094 error1
  5756                                  ;  178  3113 error1
  5757                                  ;  179  3120 end1
  5758                                  ;  180  3134 errorexit
  5759                                  ;  181  3155 errorexit
  5760                                  ;  182  3184 cputs
  5761                                  ;  183  3190 cputs
  5762                                  ;  184  3196 exitR
  5763                                  ;  185  3202 toupper
  5764                                  ;  186  3210 strcpy
  5765                                  ;  187  3217 strcat1
  5766                                  ;  188  3225 strcpy
  5767                                  ;  189  3232 strcat1
  5768                                  ;  190  3240 strcpy
  5769                                  ;  191  3247 strcat1
  5770                                  ;  192  3255 openR
  5771                                  ;  193  3261 cputs
  5772                                  ;  194  3267 cputs
  5773                                  ;  195  3273 exitR
  5774                                  ;  196  3279 creatR
  5775                                  ;  197  3286 cputs
  5776                                  ;  198  3292 cputs
  5777                                  ;  199  3298 exitR
  5778                                  ;  200  3304 creatR
  5779                                  ;  201  3311 cputs
  5780                                  ;  202  3317 cputs
  5781                                  ;  203  3323 exitR
  5782                                  ;  204  3329 prs
  5783                                  ;  205  3333 prs
  5784                                  ;  206  3337 prs
  5785                                  ;  207  3341 prs
  5786                                  ;  208  3345 prs
  5787                                  ;  209  3349 prs
  5788                                  ;  210  3353 prs
  5789                                  ;  211  3357 prs
  5790                                  ;  212  3361 prs
  5791                                  ;  213  3378 prs
  5792                                  ;  214  3382 printIntU
  5793                                  ;  215  3392 prs
  5794                                  ;  216  3396 prs
  5795                                  ;  217  3400 prs
  5796                                  ;  218  3404 prc
  5797                                  ;  219  3408 printhex16
  5798                                  ;  220  3419 prs
  5799                                  ;  221  3423 strlen
  5800                                  ;  222  3430 prs
  5801                                  ;  223  3434 printIntU
  5802                                  ;  224  3444 prs
  5803                                  ;  225  3448 prc
  5804                                  ;  226  3452 printhex8a
  5805                                  ;  227  3463 fputcR
  5806                                  ;  228  3477 fcloseR
  5807                                  ;  229  3485 fcloseR
  5808                                  ;  230  3493 fcloseR
  5809                                  ;  231  3501 exitR
  5810                                  ;  232  3526 putch
  5811                                  ;  233  3594 strcpy
  5812                                  ;  234  3609 DosInt
  5813                                  ;  235  3625 DosInt
  5814                                  ;  236  3648 DosInt
  5815                                  ;  237  3667 DosInt
  5816                                  ;  238  3701 writetty
  5817                                  ;  239  3710 writetty
  5818                                  ;Input: AS.C, List: AS.S,  Lines:  232
  5819                                  ;Glob. variables:  153 max.:  200
  5820                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  5821                                  ;Functions      :   72 max.:  300
  5822                                  ;Calls          :  240 max.: 2000, NameField: 3742 max.:    65535
  5823                                  ;Code until     :26009 max.: 30000, free: 3991
  5824                                  ;Data (HeapEnd) :33694, resting stacksize: 31841
  5825                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
