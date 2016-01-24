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
    11 00000003 E8321B                   call getarg
    12 00000006 E8920B                   call parse
    13 00000009 E8841D                   call epilog
    14 0000000C E8F11E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 18.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 18.1.2016",0
    21 00000019 372031382E312E3230-
    22 00000022 313600             
    23                                  
    24                                  ;-3 #include "DECL.C"
    25                                  
    26                                  ;Use include file: DECL.C
    27                                  
    28                                  ;-1 char LIST;              // listing on/off
    29                                  
    30 00000025 00                      LIST db 0
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
    51 00000026 0000                    SymbolInt dw 0
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
    65 00000028 0000                    InputPtr dw 0
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
    90 0000002A 0000                    asm_fd dw 0
    91                                  
    92                                  ;-13 int lst_fd;             //list file descriptor
    93                                  
    94 0000002C 0000                    lst_fd dw 0
    95                                  
    96                                  ;-14 int bin_fd;             //output file descriptor
    97                                  
    98 0000002E 0000                    bin_fd dw 0
    99                                  
   100                                  ;-15 int DOS_ERR;            //global var
   101                                  
   102 00000030 0000                    DOS_ERR dw 0
   103                                  
   104                                  ;-16 int ErrorCount;         //number of errors
   105                                  
   106 00000032 0000                    ErrorCount dw 0
   107                                  
   108                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
   109                                  
   110 00000034 0000                    DOS_NoBytes dw 0
   111                                  
   112                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
   113                                  
   114 00000036 00                      DOS_ByteRead db 0
   115                                  
   116                                  ;-19 
   117                                  
   118                                  
   119                                  ;-20 unsigned int PC;        //program counter, ORG nn
   120                                  
   121 00000037 0000                    PC dw 0
   122                                  
   123                                  ;-21 unsigned int PCStart;   //PC at start of line by PrintLine()
   124                                  
   125 00000039 0000                    PCStart dw 0
   126                                  
   127                                  ;-22 char isLabel;           //by getName()
   128                                  
   129 0000003B 00                      isLabel db 0
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
   145 0000003C 00                      TokeType db 0
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
   168                                  ;-35 #define ADR      3      //VALUE  ,var1  mod=00, r/m=110
   169                                  
   170                                  
   171                                  ;-36 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   172                                  
   173                                  
   174                                  ;-37 char Op1;               //0, IMM, REG, ADR, MEM
   175                                  
   176 0000003D 00                      Op1 db 0
   177                                  
   178                                  ;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size
   179                                  
   180 0000003E 00                      CodeType db 0
   181                                  
   182                                  ;-39 char Code1;             // first  Opcode
   183                                  
   184 0000003F 00                      Code1 db 0
   185                                  
   186                                  ;-40 char Code2;             // second Opcode
   187                                  
   188 00000040 00                      Code2 db 0
   189                                  
   190                                  ;-41 char Code3;             // third  Opcode
   191                                  
   192 00000041 00                      Code3 db 0
   193                                  
   194                                  ;-42 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   195                                  
   196 00000042 00                      RegType db 0
   197                                  
   198                                  ;-43 char RegNo;             //0 - 7 AL, CL, ...  by testReg()
   199                                  
   200 00000043 00                      RegNo db 0
   201                                  
   202                                  ;-44 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   203                                  
   204 00000044 00                      OpSize db 0
   205                                  
   206                                  ;-45 char wflag;             //0=byte, 1=word/dword
   207                                  
   208 00000045 00                      wflag db 0
   209                                  
   210                                  ;-46 //char AddrSize;          //67h:
   211                                  
   212                                  
   213                                  ;-47 //char NumOprns;          //0-2
   214                                  
   215                                  
   216                                  ;-48 //char dflag;             //0=source is reg,  1=dest is reg
   217                                  
   218                                  
   219                                  ;-49 //char modrm;           //mod, r/m
   220                                  
   221                                  
   222                                  ;-50 char regindexbase;      //combination of index and base reg
   223                                  
   224 00000046 00                      regindexbase db 0
   225                                  
   226                                  ;-51 int disp;               //displacement      0-8 bytes
   227                                  
   228 00000047 0000                    disp dw 0
   229                                  
   230                                  ;-52 int imme;               //immediate         0-8 bytes
   231                                  
   232 00000049 0000                    imme dw 0
   233                                  
   234                                  ;-53 
   235                                  
   236                                  
   237                                  ;-54 #define OPMAXLEN 5
   238                                  
   239                                  
   240                                  ;-55 char OpPos[OPMAXLEN];   //array for one opcode to list
   241                                  
   242                                  section .bss
   243                                  absolute 30390
   244 000076B6 <res 00000005>          OpPos resb 5
   245                                  section .text
   246                                  
   247                                  ;-56 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   248                                  
   249 0000004B 0000                    OpPrintIndex dw 0
   250                                  
   251                                  ;-57 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   252                                  
   253 0000004D 0000                    OpCodePtr dw 0
   254                                  
   255                                  ;-58 char PrintR;           //print 'R' if relocative
   256                                  
   257 0000004F 00                      PrintR db 0
   258                                  
   259                                  ;-59 
   260                                  
   261                                  
   262                                  ;-60 #define LABELNAMESMAX 969//next number - 31
   263                                  
   264                                  
   265                                  ;-61 char LabelNames[1000];  //space for names of all labels
   266                                  
   267                                  section .bss
   268                                  absolute 30395
   269 000076BB <res 000003E8>          LabelNames resb 1000
   270                                  section .text
   271                                  
   272                                  ;-62 char *LabelNamePtr;     // first free position
   273                                  
   274 00000050 0000                    LabelNamePtr dw 0
   275                                  
   276                                  ;-63 #define LABELADRMAX 100
   277                                  
   278                                  
   279                                  ;-64 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   280                                  
   281                                  section .bss
   282                                  absolute 31395
   283 00007AA3 <res 000000C8>          LabelAddr resw 100
   284                                  section .text
   285                                  
   286                                  ;-65 int LabelMaxIx=0;       //actual number of stored labels
   287                                  
   288 00000052 0000                    LabelMaxIx dw 0
   289                                  
   290                                  ;-66 int LabelIx;            //actual number of just searched label
   291                                  
   292 00000054 0000                    LabelIx dw 0
   293                                  
   294                                  ;-67 
   295                                  
   296                                  
   297                                  ;-68 #define FILEBINMAX 1990 //next number - max. oplemgth
   298                                  
   299                                  
   300                                  ;-69 char FileBin  [2000];   //output binary file
   301                                  
   302                                  section .bss
   303                                  absolute 31595
   304 00007B6B <res 000007D0>          FileBin resb 2000
   305                                  section .text
   306                                  
   307                                  ;-70 unsigned int BinLen=0;  //length of binary file
   308                                  
   309 00000056 0000                    BinLen dw 0
   310                                  
   311                                  ;-71 
   312                                  
   313                                  
   314                                  ;-72 char *arglen=0x80;      // for main only
   315                                  
   316 00000058 8000                    arglen dw 128
   317                                  
   318                                  ;-73 char *argv=0x82;        // for main only
   319                                  
   320 0000005A 8200                    argv dw 130
   321                                  ;Back to main program: AS.C
   322                                  
   323                                  ;-4 #include "OPTABL.C"
   324                                  
   325                                  ;Use include file: OPTABL.C
   326                                  
   327                                  ;-1 char I_START=0xF1;
   328                                  
   329 0000005C F1                      I_START db 241
   330                                  
   331                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   332                                  
   333                                  
   334                                  ;-3 //  1:   1 byte opcode
   335                                  
   336                                  
   337                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   338                                  
   339 0000005D 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   340                                  
   341                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   342                                  
   343 00000066 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   344                                  
   345                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   346                                  
   347 0000006E 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   348                                  
   349                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   350                                  
   351 00000075 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   352                                  
   353                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   354                                  
   355 0000007C 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   356                                  
   357                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   358                                  
   359 00000084 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   360                                  
   361                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   362                                  
   363 0000008B 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   364                                  
   365                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   366                                  
   367 00000092 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   368                                  
   369                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   370                                  
   371 0000009A 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   372                                  
   373                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   374                                  
   375 000000A3 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   376                                  
   377                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   378                                  
   379 000000AB 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   380                                  
   381                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   382                                  
   383 000000B3 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   384                                  
   385                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   386                                  
   387 000000BB 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   388                                  
   389                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   390                                  
   391 000000C4 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   392                                  
   393                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   394                                  
   395 000000CD 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   396                                  
   397                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   398                                  
   399 000000D6 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   400                                  
   401                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   402                                  
   403 000000DF 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   404                                  
   405                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   406                                  
   407 000000E8 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   408                                  
   409                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   410                                  
   411 000000F1 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   412                                  
   413                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   414                                  
   415 000000FA 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   416                                  
   417                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   418                                  
   419 00000103 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   420                                  
   421                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   422                                  
   423 0000010C 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   424                                  
   425                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   426                                  
   427 00000115 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   428                                  
   429                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   430                                  
   431 0000011E 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   432                                  
   433                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   434                                  
   435 00000126 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   436                                  
   437                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   438                                  
   439 0000012E 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   440                                  
   441                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   442                                  
   443 00000136 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   444                                  
   445                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   446                                  
   447 0000013F 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   448                                  
   449                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   450                                  
   451 00000148 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   452                                  
   453                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   454                                  
   455 00000150 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   456                                  
   457                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   458                                  
   459 00000158 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   460                                  
   461                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   462                                  
   463 0000015F 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   464                                  
   465                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   466                                  
   467 00000166 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   468                                  
   469                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   470                                  
   471 0000016D 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   472                                  
   473                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   474                                  
   475 00000174 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   476                                  
   477                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   478                                  
   479 0000017B 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   480                                  
   481                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   482                                  
   483 00000182 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   484                                  
   485                                  ;-41 // 52: mem reg 16 bit
   486                                  
   487                                  
   488                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   489                                  
   490 00000189 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   491                                  
   492                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   493                                  
   494 00000192 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   495                                  
   496                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,0xF1};
   497                                  
   498 0000019B 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   499                                  
   500                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,0xF1};
   501                                  
   502 000001A3 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   503                                  
   504                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,0xF1};
   505                                  
   506 000001AB 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   507                                  
   508                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,0xF1};//only acc
   509                                  
   510 000001B3 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   511                                  
   512                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,0xF1};
   513                                  
   514 000001BC 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   515                                  
   516                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,0xF1};
   517                                  
   518 000001C4 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   519                                  
   520                                  ;-50 //  3: les, lda, lea
   521                                  
   522                                  
   523                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16
   524                                  
   525 000001CD 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   526                                  
   527                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16
   528                                  
   529 000001D4 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   530                                  
   531                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16
   532                                  
   533 000001DB 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   534                                  
   535                                  ;-54 //  4: acc,imm  reg,imm  index,reg
   536                                  
   537                                  
   538                                  ;-55 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   539                                  
   540 000001E2 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   541                                  
   542                                  ;-56 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   543                                  
   544 000001E9 4F52000401F1            I_OR db 79,82,0,4,1,241
   545                                  
   546                                  ;-57 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   547                                  
   548 000001EF 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   549                                  
   550                                  ;-58 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   551                                  
   552 000001F6 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   553                                  
   554                                  ;-59 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   555                                  
   556 000001FD 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   557                                  
   558                                  ;-60 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   559                                  
   560 00000204 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   561                                  
   562                                  ;-61 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   563                                  
   564 0000020B 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   565                                  
   566                                  ;-62 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   567                                  
   568 00000212 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   569                                  
   570                                  ;-63 //  5: mov
   571                                  
   572                                  
   573                                  ;-64 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   574                                  
   575 00000219 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   576                                  
   577                                  ;-65 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   578                                  
   579 0000021F 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   580                                  
   581                                  ;-66 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   582                                  
   583 00000228 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   584                                  
   585                                  ;-67 //  6: single byte relative jump
   586                                  
   587                                  
   588                                  ;-68 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   589                                  
   590 00000231 4A4F000600F1            I_JO db 74,79,0,6,0,241
   591                                  
   592                                  ;-69 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   593                                  
   594 00000237 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   595                                  
   596                                  ;-70 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   597                                  
   598 0000023E 4A42000602F1            I_JB db 74,66,0,6,2,241
   599                                  
   600                                  ;-71 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   601                                  
   602 00000244 4A43000602F1            I_JC db 74,67,0,6,2,241
   603                                  
   604                                  ;-72 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   605                                  
   606 0000024A 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   607                                  
   608                                  ;-73 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   609                                  
   610 00000251 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   611                                  
   612                                  ;-74 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   613                                  
   614 00000258 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   615                                  
   616                                  ;-75 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   617                                  
   618 0000025F 4A45000604F1            I_JE db 74,69,0,6,4,241
   619                                  
   620                                  ;-76 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   621                                  
   622 00000265 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   623                                  
   624                                  ;-77 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   625                                  
   626 0000026B 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   627                                  
   628                                  ;-78 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   629                                  
   630 00000272 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   631                                  
   632                                  ;-79 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   633                                  
   634 00000279 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   635                                  
   636                                  ;-80 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   637                                  
   638 00000280 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   639                                  
   640                                  ;-81 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   641                                  
   642 00000287 4A41000607F1            I_JA db 74,65,0,6,7,241
   643                                  
   644                                  ;-82 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   645                                  
   646 0000028D 4A53000608F1            I_JS db 74,83,0,6,8,241
   647                                  
   648                                  ;-83 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   649                                  
   650 00000293 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   651                                  
   652                                  ;-84 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   653                                  
   654 0000029A 4A5000060AF1            I_JP db 74,80,0,6,10,241
   655                                  
   656                                  ;-85 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   657                                  
   658 000002A0 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   659                                  
   660                                  ;-86 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   661                                  
   662 000002A7 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   663                                  
   664                                  ;-87 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   665                                  
   666 000002AE 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   667                                  
   668                                  ;-88 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   669                                  
   670 000002B5 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   671                                  
   672                                  ;-89 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   673                                  
   674 000002BB 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   675                                  
   676                                  ;-90 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   677                                  
   678 000002C2 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   679                                  
   680                                  ;-91 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   681                                  
   682 000002C9 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   683                                  
   684                                  ;-92 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   685                                  
   686 000002D0 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   687                                  
   688                                  ;-93 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   689                                  
   690 000002D7 4A4700060FF1            I_JG db 74,71,0,6,15,241
   691                                  
   692                                  ;-94 //  7: jmp, call
   693                                  
   694                                  
   695                                  ;-95 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   696                                  
   697 000002DD 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   698                                  
   699                                  ;-96 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   700                                  
   701 000002E5 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   702                                  
   703                                  ;-97 //  8: ret
   704                                  
   705                                  
   706                                  ;-98 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   707                                  
   708 000002EE 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   709                                  
   710                                  ;-99 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   711                                  
   712 000002F6 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   713                                  
   714                                  ;-100 //  9: seg, r/m
   715                                  
   716                                  
   717                                  ;-101 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   718                                  
   719 000002FF 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   720                                  
   721                                  ;-102 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   722                                  
   723 00000307 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   724                                  
   725                                  ;-103 //  11: shift, rotates
   726                                  
   727                                  
   728                                  ;-104 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   729                                  
   730 0000030E 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   731                                  
   732                                  ;-105 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   733                                  
   734 00000315 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   735                                  
   736                                  ;-106 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   737                                  
   738 0000031C 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   739                                  
   740                                  ;-107 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   741                                  
   742 00000323 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   743                                  
   744                                  ;-108 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   745                                  
   746 0000032A 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   747                                  
   748                                  ;-109 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   749                                  
   750 00000331 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   751                                  
   752                                  ;-110 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   753                                  
   754 00000338 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   755                                  
   756                                  ;-111 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   757                                  
   758 0000033F 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   759                                  
   760                                  ;-112 //  12: int
   761                                  
   762                                  
   763                                  ;-113 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   764                                  
   765 00000346 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   766                                  
   767                                  ;-114 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   768                                  
   769 0000034E 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   770                                  
   771                                  ;-115 //  14: in/out
   772                                  
   773                                  
   774                                  ;-116 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   775                                  
   776 00000356 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   777                                  
   778                                  ;-117 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   779                                  
   780 0000035D 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   781                                  
   782                                  ;-118 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   783                                  
   784 00000365 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   785                                  
   786                                  ;-119 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   787                                  
   788 0000036D 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   789                                  
   790                                  ;-120 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   791                                  
   792 00000375 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   793                                  
   794                                  ;-121 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   795                                  
   796 0000037D 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   797                                  
   798                                  ;-122 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   799                                  
   800 00000385 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   801                                  
   802                                  ;-123 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   803                                  
   804 0000038D 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   805                                  
   806                                  ;-124 //  15: xchg
   807                                  
   808                                  
   809                                  ;-125 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   810                                  
   811 00000395 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   812                                  
   813                                  ;-126 //  16: loop, jcxz
   814                                  
   815                                  
   816                                  ;-127 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   817                                  
   818 0000039E 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   819 000003A7 F1                 
   820                                  
   821                                  ;-128 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   822                                  
   823 000003A8 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   824 000003B1 F1                 
   825                                  
   826                                  ;-129 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   827                                  
   828 000003B2 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   829                                  
   830                                  ;-130 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   831                                  
   832 000003BB 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   833                                  
   834                                  ;-131 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   835                                  
   836 000003C4 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   837                                  
   838                                  ;-132 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   839                                  
   840 000003CC 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   841                                  
   842                                  ;-133 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   843                                  
   844 000003D4 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   845                                  
   846                                  ;-134 //  30: enter
   847                                  
   848                                  
   849                                  ;-135 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   850                                  
   851 000003DD 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   852                                  
   853                                  ;-136 // 100: directives
   854                                  
   855                                  
   856                                  ;-137 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   857                                  
   858 000003E6 4F52470065F1            I_ORG db 79,82,71,0,101,241
   859                                  
   860                                  ;-138 char I_DB[]=   {'D','B',0,            200,        0xF1};
   861                                  
   862 000003EC 444200C8F1              I_DB db 68,66,0,200,241
   863                                  
   864                                  ;-139 char I_DW[]=   {'D','W',0,            201,        0xF1};
   865                                  
   866 000003F1 445700C9F1              I_DW db 68,87,0,201,241
   867                                  
   868                                  ;-140 char I_DD[]=   {'D','D',0,            202,        0xF1};
   869                                  
   870 000003F6 444400CAF1              I_DD db 68,68,0,202,241
   871                                  
   872                                  ;-141 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   873                                  
   874 000003FB 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   875                                  
   876                                  ;-142 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   877                                  
   878 00000402 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   879                                  
   880                                  ;-143 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   881                                  
   882 00000409 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   883                                  
   884                                  ;-144 char I_END=0;// end of table char
   885                                  
   886 00000410 00                      I_END db 0
   887                                  ;Back to main program: AS.C
   888                                  
   889                                  ;-5 
   890                                  
   891                                  
   892                                  ;-6 int process() { int i; char c;
   893                                  
   894                                  
   895                                  process:  ; *** PROC ***
   896                                  
   897                                  ;-7   getTokeType();
   898                                  
   899                                  ;Function : process, Number of local variables: 2
   900                                  ;   # type sign width line used address name   list of local variables
   901                                  ;  200 var sign word     6 NULL bp-2    i
   902                                  ;  201 var sign byte     6 NULL bp-4    c;
   903 00000411 C8040000                 ENTER  4,0
   904 00000415 E86D08                   call getTokeType
   905                                  
   906                                  ;-8   OpSize=getCodeSize();
   907                                  
   908 00000418 E8640B                   call getCodeSize
   909 0000041B A2[4400]                 mov byte [OpSize], al
   910                                  
   911                                  ;-9   getCodes();//set: Code1, Code2, Code3
   912                                  
   913 0000041E E84705                   call getCodes
   914                                  
   915                                  ;-10 
   916                                  
   917                                  
   918                                  ;-11   if (CodeType ==  1) {//1 byte opcode
   919                                  
   920 00000421 A0[3E00]                 mov al, [CodeType]
   921 00000424 3C01                     cmp al, 1
   922 00000426 0F850F00                 jne @@process1
   923                                  
   924                                  ;-12     genCode8(Code1);
   925                                  
   926 0000042A A0[3F00]                 mov al, byte [Code1]
   927 0000042D B400                     mov ah, 0
   928 0000042F 50                       push ax
   929 00000430 E88705                   call genCode8
   930 00000433 83C402                   add  sp, 2
   931                                  
   932                                  ;-13     return;
   933                                  
   934 00000436 E9E200                   jmp @@retn
   935                                  
   936                                  ;-14   }
   937                                  
   938                                  
   939                                  ;-15   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
   940                                  
   941                                  @@process1:
   942 00000439 A0[3E00]                 mov al, [CodeType]
   943 0000043C 3C02                     cmp al, 2
   944 0000043E 0F857200                 jne @@process2
   945                                  
   946                                  ;-16     checkLeftOp();
   947                                  
   948 00000442 E85D01                   call checkLeftOp
   949                                  
   950                                  ;-17       if (Code2 <= 1) {//inc,dec
   951                                  
   952 00000445 A0[4000]                 mov al, [Code2]
   953 00000448 3C01                     cmp al, 1
   954 0000044A 0F8F4500                 jg  @@process3
   955                                  
   956                                  ;-18     	if (Op1 == REG) {
   957                                  
   958 0000044E A0[3D00]                 mov al, [Op1]
   959 00000451 3C02                     cmp al, 2
   960 00000453 0F853C00                 jne @@process4
   961                                  
   962                                  ;-19         if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
   963                                  
   964 00000457 A0[4200]                 mov al, [RegType]
   965 0000045A 3C02                     cmp al, 2
   966 0000045C 0F851500                 jne @@process5
   967 00000460 A0[4300]                 mov al, byte [RegNo]
   968 00000463 B400                     mov ah, 0
   969 00000465 50                       push ax
   970 00000466 A0[4100]                 mov al, byte [Code3]
   971 00000469 B400                     mov ah, 0
   972 0000046B 50                       push ax
   973 0000046C E83005                   call genCode
   974 0000046F 83C404                   add  sp, 4
   975 00000472 E9A600                   jmp @@retn
   976                                  
   977                                  ;-20         if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
   978                                  
   979                                  @@process5:
   980 00000475 A0[4200]                 mov al, [RegType]
   981 00000478 3C03                     cmp al, 3
   982 0000047A 0F851500                 jne @@process6
   983 0000047E A0[4300]                 mov al, byte [RegNo]
   984 00000481 B400                     mov ah, 0
   985 00000483 50                       push ax
   986 00000484 A0[4100]                 mov al, byte [Code3]
   987 00000487 B400                     mov ah, 0
   988 00000489 50                       push ax
   989 0000048A E81205                   call genCode
   990 0000048D 83C404                   add  sp, 4
   991 00000490 E98800                   jmp @@retn
   992                                  
   993                                  ;-21         }
   994                                  
   995                                  @@process6:
   996                                  
   997                                  ;-22       }
   998                                  
   999                                  @@process4:
  1000                                  
  1001                                  ;-23       genCode(Code1, wflag);
  1002                                  
  1003                                  @@process3:
  1004 00000493 A0[4500]                 mov al, byte [wflag]
  1005 00000496 B400                     mov ah, 0
  1006 00000498 50                       push ax
  1007 00000499 A0[3F00]                 mov al, byte [Code1]
  1008 0000049C B400                     mov ah, 0
  1009 0000049E 50                       push ax
  1010 0000049F E8FD04                   call genCode
  1011 000004A2 83C404                   add  sp, 4
  1012                                  
  1013                                  ;-24       writeEA(Code2);
  1014                                  
  1015 000004A5 A0[4000]                 mov al, byte [Code2]
  1016 000004A8 B400                     mov ah, 0
  1017 000004AA 50                       push ax
  1018 000004AB E85F05                   call writeEA
  1019 000004AE 83C402                   add  sp, 2
  1020                                  
  1021                                  ;-25       return;
  1022                                  
  1023 000004B1 E96700                   jmp @@retn
  1024                                  
  1025                                  ;-26   }
  1026                                  
  1027                                  
  1028                                  ;-27  
  1029                                  
  1030                                  
  1031                                  ;-28   if (CodeType ==  8) {//ret,retf
  1032                                  
  1033                                  @@process2:
  1034 000004B4 A0[3E00]                 mov al, [CodeType]
  1035 000004B7 3C08                     cmp al, 8
  1036 000004B9 0F853100                 jne @@process7
  1037                                  
  1038                                  ;-29     if (TokeType == DIGIT) {
  1039                                  
  1040 000004BD A0[3C00]                 mov al, [TokeType]
  1041 000004C0 3C01                     cmp al, 1
  1042 000004C2 0F851900                 jne @@process8
  1043                                  
  1044                                  ;-30       genCode8(Code2);
  1045                                  
  1046 000004C6 A0[4000]                 mov al, byte [Code2]
  1047 000004C9 B400                     mov ah, 0
  1048 000004CB 50                       push ax
  1049 000004CC E8EB04                   call genCode8
  1050 000004CF 83C402                   add  sp, 2
  1051                                  
  1052                                  ;-31       genCode16(SymbolInt);
  1053                                  
  1054 000004D2 FF36[2600]               push word [SymbolInt]
  1055 000004D6 E81305                   call genCode16
  1056 000004D9 83C402                   add  sp, 2
  1057                                  
  1058                                  ;-32       return;
  1059                                  
  1060 000004DC E93C00                   jmp @@retn
  1061                                  
  1062                                  ;-33     }
  1063                                  
  1064                                  
  1065                                  ;-34     genCode8(Code1); 
  1066                                  
  1067                                  @@process8:
  1068 000004DF A0[3F00]                 mov al, byte [Code1]
  1069 000004E2 B400                     mov ah, 0
  1070 000004E4 50                       push ax
  1071 000004E5 E8D204                   call genCode8
  1072 000004E8 83C402                   add  sp, 2
  1073                                  
  1074                                  ;-35     return;
  1075                                  
  1076 000004EB E92D00                   jmp @@retn
  1077                                  
  1078                                  ;-36   }
  1079                                  
  1080                                  
  1081                                  ;-37 
  1082                                  
  1083                                  
  1084                                  ;-38   if (CodeType==101) {// ORG nn
  1085                                  
  1086                                  @@process7:
  1087 000004EE A0[3E00]                 mov al, [CodeType]
  1088 000004F1 3C65                     cmp al, 101
  1089 000004F3 0F851B00                 jne @@process9
  1090                                  
  1091                                  ;-39     if (TokeType != DIGIT) error1("only digit allowed");
  1092                                  
  1093 000004F7 A0[3C00]                 mov al, [TokeType]
  1094 000004FA 3C01                     cmp al, 1
  1095 000004FC 0F840900                 je  @@process10
  1096 00000500 68[1D05]                 push process_0
  1097 00000503 E8B014                   call error1
  1098 00000506 83C402                   add  sp, 2
  1099                                  
  1100                                  ;-40     PC=SymbolInt;return;
  1101                                  
  1102                                  @@process10:
  1103 00000509 A1[2600]                 mov ax, [SymbolInt]
  1104 0000050C A3[3700]                 mov word [PC], ax
  1105 0000050F E90900                   jmp @@retn
  1106                                  
  1107                                  ;-41   }
  1108                                  
  1109                                  
  1110                                  ;-42   error1("unknown CodeType");
  1111                                  
  1112                                  @@process9:
  1113 00000512 68[3005]                 push process_1
  1114 00000515 E89E14                   call error1
  1115 00000518 83C402                   add  sp, 2
  1116                                  
  1117                                  ;-43 }
  1118                                  
  1119                                  
  1120                                  ;-44 
  1121                                  
  1122                                  
  1123                                  ;-45 int setwflag() {//only Op1 (first operand)
  1124                                  
  1125 0000051B C9                      @@retn: LEAVE
  1126 0000051C C3                       ret
  1127                                  ; ENDP
  1128 0000051D 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1129 00000526 7420616C6C6F776564-
  1130 0000052F 00                 
  1131 00000530 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1132 00000539 6F64655479706500   
  1133                                  
  1134                                  setwflag:  ; *** PROC ***
  1135                                  
  1136                                  ;-46   wflag=0;
  1137                                  
  1138 00000541 66B800000000             mov eax, 0
  1139 00000547 A2[4500]                 mov byte [wflag], al
  1140                                  
  1141                                  ;-47   if (OpSize == 0) {//do not override OpSize
  1142                                  
  1143 0000054A A0[4400]                 mov al, [OpSize]
  1144 0000054D 3C00                     cmp al, 0
  1145 0000054F 0F852100                 jne @@setwflag11
  1146                                  
  1147                                  ;-48     if (Op1 == REG) {
  1148                                  
  1149 00000553 A0[3D00]                 mov al, [Op1]
  1150 00000556 3C02                     cmp al, 2
  1151 00000558 0F851800                 jne @@setwflag12
  1152                                  
  1153                                  ;-49       OpSize=RegType;
  1154                                  
  1155 0000055C A0[4200]                 mov al, [RegType]
  1156 0000055F A2[4400]                 mov byte [OpSize], al
  1157                                  
  1158                                  ;-50       if (RegType == SEGREG) OpSize=WORD;
  1159                                  
  1160 00000562 A0[4200]                 mov al, [RegType]
  1161 00000565 3C04                     cmp al, 4
  1162 00000567 0F850900                 jne @@setwflag13
  1163 0000056B 66B802000000             mov eax, 2
  1164 00000571 A2[4400]                 mov byte [OpSize], al
  1165                                  
  1166                                  ;-51     }
  1167                                  
  1168                                  @@setwflag13:
  1169                                  
  1170                                  ;-52   }
  1171                                  
  1172                                  @@setwflag12:
  1173                                  
  1174                                  ;-53   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1175                                  
  1176                                  @@setwflag11:
  1177 00000574 A0[4400]                 mov al, [OpSize]
  1178 00000577 3C03                     cmp al, 3
  1179 00000579 0F850C00                 jne @@setwflag14
  1180 0000057D E81604                   call gen66h
  1181 00000580 66B801000000             mov eax, 1
  1182 00000586 A2[4500]                 mov byte [wflag], al
  1183                                  
  1184                                  ;-54   if (OpSize  ==  WORD) wflag=1;
  1185                                  
  1186                                  @@setwflag14:
  1187 00000589 A0[4400]                 mov al, [OpSize]
  1188 0000058C 3C02                     cmp al, 2
  1189 0000058E 0F850900                 jne @@setwflag15
  1190 00000592 66B801000000             mov eax, 1
  1191 00000598 A2[4500]                 mov byte [wflag], al
  1192                                  
  1193                                  ;-55 }
  1194                                  
  1195                                  @@setwflag15:
  1196                                  
  1197                                  ;-56 
  1198                                  
  1199                                  
  1200                                  ;-57 int Check2Op(char left, char rigth) {
  1201                                  
  1202 0000059B C3                       ret
  1203                                  ; ENDP
  1204                                  
  1205                                  Check2Op:  ; *** PROC ***
  1206                                  
  1207                                  ;-58 }
  1208                                  
  1209                                  ;Function : Check2Op, Number of local variables: 2
  1210                                  ;   # type sign width line used address name   list of local variables
  1211                                  ;  200 var sign byte    57 NULL bp+4    left
  1212                                  ;  201 var sign byte    57 NULL bp+6    rigth;
  1213 0000059C C8000000                 ENTER  0,0
  1214                                  
  1215                                  ;-59 int checkLeftOp() {
  1216 000005A0 C9                       LEAVE
  1217 000005A1 C3                       ret
  1218                                  ; ENDP
  1219                                  
  1220                                  checkLeftOp:  ; *** PROC ***
  1221                                  
  1222                                  ;-60   getOp();
  1223                                  
  1224 000005A2 E8AE00                   call getOp
  1225                                  
  1226                                  ;-61   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1227                                  
  1228 000005A5 A0[4200]                 mov al, [RegType]
  1229 000005A8 3C04                     cmp al, 4
  1230 000005AA 0F850600                 jne @@checkLeftOp16
  1231 000005AE E8FE14                   call segregerror
  1232 000005B1 E95300                   jmp @@retn
  1233                                  
  1234                                  ;-62   setwflag();
  1235                                  
  1236                                  @@checkLeftOp16:
  1237 000005B4 E88AFF                   call setwflag
  1238                                  
  1239                                  ;-63   if (OpSize == 0) error1("no op size declared");
  1240                                  
  1241 000005B7 A0[4400]                 mov al, [OpSize]
  1242 000005BA 3C00                     cmp al, 0
  1243 000005BC 0F850900                 jne @@checkLeftOp17
  1244 000005C0 68[0806]                 push checkLeftOp_0
  1245 000005C3 E8F013                   call error1
  1246 000005C6 83C402                   add  sp, 2
  1247                                  
  1248                                  ;-64   if (OpSize == RegType) return;
  1249                                  
  1250                                  @@checkLeftOp17:
  1251 000005C9 A0[4400]                 mov al, [OpSize]
  1252 000005CC 3A06[4200]               cmp al, [RegType]
  1253 000005D0 0F850300                 jne @@checkLeftOp18
  1254 000005D4 E93000                   jmp @@retn
  1255                                  
  1256                                  ;-65   if (OpSize){if (Op1 == MEM) return;
  1257                                  
  1258                                  @@checkLeftOp18:
  1259 000005D7 A0[4400]                 mov al, [OpSize]
  1260 000005DA 08C0                     or  al, al
  1261 000005DC 0F841500                 je @@checkLeftOp19
  1262 000005E0 A0[3D00]                 mov al, [Op1]
  1263 000005E3 3C04                     cmp al, 4
  1264 000005E5 0F850300                 jne @@checkLeftOp20
  1265 000005E9 E91B00                   jmp @@retn
  1266                                  
  1267                                  ;-66     error1("Conflict OpSize and RegSize"); }
  1268                                  
  1269                                  @@checkLeftOp20:
  1270 000005EC 68[1C06]                 push checkLeftOp_1
  1271 000005EF E8C413                   call error1
  1272 000005F2 83C402                   add  sp, 2
  1273                                  
  1274                                  ;-67   if (RegType==0) error1("no register defined");
  1275                                  
  1276                                  @@checkLeftOp19:
  1277 000005F5 A0[4200]                 mov al, [RegType]
  1278 000005F8 3C00                     cmp al, 0
  1279 000005FA 0F850900                 jne @@checkLeftOp21
  1280 000005FE 68[3806]                 push checkLeftOp_2
  1281 00000601 E8B213                   call error1
  1282 00000604 83C402                   add  sp, 2
  1283                                  
  1284                                  ;-68 }
  1285                                  
  1286                                  @@checkLeftOp21:
  1287                                  
  1288                                  ;-69 
  1289                                  
  1290                                  
  1291                                  ;-70 int saveLeftOp(){
  1292                                  
  1293                                  @@retn:
  1294 00000607 C3                       ret
  1295                                  ; ENDP
  1296 00000608 6E6F206F702073697A-     checkLeftOp_0 db "no op size declared",0
  1297 00000611 65206465636C617265-
  1298 0000061A 6400               
  1299 0000061C 436F6E666C69637420-     checkLeftOp_1 db "Conflict OpSize and RegSize",0
  1300 00000625 4F7053697A6520616E-
  1301 0000062E 642052656753697A65-
  1302 00000637 00                 
  1303 00000638 6E6F20726567697374-     checkLeftOp_2 db "no register defined",0
  1304 00000641 657220646566696E65-
  1305 0000064A 6400               
  1306                                  
  1307                                  saveLeftOp:  ; *** PROC ***
  1308                                  
  1309                                  ;-71 }
  1310                                  
  1311                                  
  1312                                  ;-72 int checkRightOp(char mode){
  1313                                  
  1314 0000064C C3                       ret
  1315                                  ; ENDP
  1316                                  
  1317                                  checkRightOp:  ; *** PROC ***
  1318                                  
  1319                                  ;-73 }
  1320                                  
  1321                                  ;Function : checkRightOp, Number of local variables: 1
  1322                                  ;   # type sign width line used address name   list of local variables
  1323                                  ;  200 var sign byte    72 NULL bp+4    mode;
  1324 0000064D C8000000                 ENTER  0,0
  1325                                  
  1326                                  ;-74 
  1327                                  
  1328                                  
  1329                                  ;-75 /*        Op      = 0, IMM, REG, ADR, MEM
  1330                                  
  1331                                  
  1332                                  ;-76 IMM       imme    = 0, SymbolInt    
  1333                                  
  1334                                  
  1335                                  ;-77 REG     R RegNo   = 0 - 7
  1336                                  
  1337                                  
  1338                                  ;-78 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  1339                                  
  1340                                  
  1341                                  ;-79 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  1342                                  
  1343                                  
  1344                                  ;-80 MEM       regindexbase = 0 - 7
  1345                                  
  1346                                  
  1347                                  ;-81 
  1348                                  
  1349                                  
  1350                                  ;-82           OpSize  = 0, BYTE, WORD, DWORD (set wflag)
  1351                                  
  1352                                  
  1353                                  ;-83 */
  1354                                  
  1355                                  
  1356                                  ;-84 int getOp() {
  1357 00000651 C9                       LEAVE
  1358 00000652 C3                       ret
  1359                                  ; ENDP
  1360                                  
  1361                                  getOp:  ; *** PROC ***
  1362                                  
  1363                                  ;-85 //set: op1=0,IMM,REG,ADR,MEM
  1364                                  
  1365                                  
  1366                                  ;-86   disp=0; imme=0; regindexbase=0;
  1367                                  
  1368 00000653 66B800000000             mov eax, 0
  1369 00000659 A3[4700]                 mov word [disp], ax
  1370 0000065C 66B800000000             mov eax, 0
  1371 00000662 A3[4900]                 mov word [imme], ax
  1372 00000665 66B800000000             mov eax, 0
  1373 0000066B A2[4600]                 mov byte [regindexbase], al
  1374                                  
  1375                                  ;-87 
  1376                                  
  1377                                  
  1378                                  ;-88   Op1=getOp1();
  1379                                  
  1380 0000066E E8A800                   call getOp1
  1381 00000671 A2[3D00]                 mov byte [Op1], al
  1382                                  
  1383                                  ;-89   if (isToken('[')) {Op1 = MEM; getMEM();  return;}
  1384                                  
  1385 00000674 6A5B                     push 91
  1386 00000676 E88909                   call isToken
  1387 00000679 83C402                   add  sp, 2
  1388 0000067C 08C0                     or  al, al
  1389 0000067E 0F840F00                 je @@getOp22
  1390 00000682 66B804000000             mov eax, 4
  1391 00000688 A2[3D00]                 mov byte [Op1], al
  1392 0000068B E81101                   call getMEM
  1393 0000068E E95200                   jmp @@retn
  1394                                  
  1395                                  ;-90   if (Op1 == 0) error1("Name of operand expected");
  1396                                  
  1397                                  @@getOp22:
  1398 00000691 A0[3D00]                 mov al, [Op1]
  1399 00000694 3C00                     cmp al, 0
  1400 00000696 0F850900                 jne @@getOp23
  1401 0000069A 68[E406]                 push getOp_0
  1402 0000069D E81613                   call error1
  1403 000006A0 83C402                   add  sp, 2
  1404                                  
  1405                                  ;-91   if (Op1 == IMM) {imme=SymbolInt;         return;}
  1406                                  
  1407                                  @@getOp23:
  1408 000006A3 A0[3D00]                 mov al, [Op1]
  1409 000006A6 3C01                     cmp al, 1
  1410 000006A8 0F850900                 jne @@getOp24
  1411 000006AC A1[2600]                 mov ax, [SymbolInt]
  1412 000006AF A3[4900]                 mov word [imme], ax
  1413 000006B2 E92E00                   jmp @@retn
  1414                                  
  1415                                  ;-92   if (Op1 == REG)                          return;
  1416                                  
  1417                                  @@getOp24:
  1418 000006B5 A0[3D00]                 mov al, [Op1]
  1419 000006B8 3C02                     cmp al, 2
  1420 000006BA 0F850300                 jne @@getOp25
  1421 000006BE E92200                   jmp @@retn
  1422                                  
  1423                                  ;-93   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;}
  1424                                  
  1425                                  @@getOp25:
  1426 000006C1 A0[3D00]                 mov al, [Op1]
  1427 000006C4 3C03                     cmp al, 3
  1428 000006C6 0F851000                 jne @@getOp26
  1429 000006CA 8B1E[5400]               mov bx, [LabelIx]
  1430 000006CE D1E3                     shl bx, 1
  1431 000006D0 8B87A37A                 mov ax, [LabelAddr + bx]
  1432 000006D4 A3[4700]                 mov word [disp], ax
  1433 000006D7 E90900                   jmp @@retn
  1434                                  
  1435                                  ;-94   error1("Name of operand expected #1");
  1436                                  
  1437                                  @@getOp26:
  1438 000006DA 68[FD06]                 push getOp_1
  1439 000006DD E8D612                   call error1
  1440 000006E0 83C402                   add  sp, 2
  1441                                  
  1442                                  ;-95 }
  1443                                  
  1444                                  
  1445                                  ;-96 
  1446                                  
  1447                                  
  1448                                  ;-97 int getOp1() {//scan for a single operand
  1449                                  
  1450                                  @@retn:
  1451 000006E3 C3                       ret
  1452                                  ; ENDP
  1453 000006E4 4E616D65206F66206F-     getOp_0 db "Name of operand expected",0
  1454 000006ED 706572616E64206578-
  1455 000006F6 70656374656400     
  1456 000006FD 4E616D65206F66206F-     getOp_1 db "Name of operand expected #1",0
  1457 00000706 706572616E64206578-
  1458 0000070F 706563746564202331-
  1459 00000718 00                 
  1460                                  
  1461                                  getOp1:  ; *** PROC ***
  1462                                  
  1463                                  ;-98 //return:0, IMM, REG, ADR (not MEM)
  1464                                  
  1465                                  
  1466                                  ;-99 //set   :RegType, RegNo by testReg
  1467                                  
  1468                                  
  1469                                  ;-100 //set   :LabelIx by searchLabel
  1470                                  
  1471                                  
  1472                                  ;-101   if (TokeType == 0)      return 0;
  1473                                  
  1474 00000719 A0[3C00]                 mov al, [TokeType]
  1475 0000071C 3C00                     cmp al, 0
  1476 0000071E 0F850900                 jne @@getOp127
  1477 00000722 66B800000000             mov eax, 0
  1478 00000728 E96000                   jmp @@retn
  1479                                  
  1480                                  ;-102   if (TokeType == DIGIT)  return IMM;
  1481                                  
  1482                                  @@getOp127:
  1483 0000072B A0[3C00]                 mov al, [TokeType]
  1484 0000072E 3C01                     cmp al, 1
  1485 00000730 0F850900                 jne @@getOp128
  1486 00000734 66B801000000             mov eax, 1
  1487 0000073A E94E00                   jmp @@retn
  1488                                  
  1489                                  ;-103   if (TokeType == ALNUME) {
  1490                                  
  1491                                  @@getOp128:
  1492 0000073D A0[3C00]                 mov al, [TokeType]
  1493 00000740 3C03                     cmp al, 3
  1494 00000742 0F853C00                 jne @@getOp129
  1495                                  
  1496                                  ;-104     RegNo=testReg();
  1497                                  
  1498 00000746 E8C60B                   call testReg
  1499 00000749 A2[4300]                 mov byte [RegNo], al
  1500                                  
  1501                                  ;-105     if (RegType)          return REG;
  1502                                  
  1503 0000074C A0[4200]                 mov al, [RegType]
  1504 0000074F 08C0                     or  al, al
  1505 00000751 0F840900                 je @@getOp130
  1506 00000755 66B802000000             mov eax, 2
  1507 0000075B E92D00                   jmp @@retn
  1508                                  
  1509                                  ;-106     LabelIx=searchLabel();
  1510                                  
  1511                                  @@getOp130:
  1512 0000075E E80C06                   call searchLabel
  1513 00000761 A3[5400]                 mov word [LabelIx], ax
  1514                                  
  1515                                  ;-107     if (LabelIx)          return ADR;
  1516                                  
  1517 00000764 A1[5400]                 mov ax, [LabelIx]
  1518 00000767 08C0                     or  al, al
  1519 00000769 0F840C00                 je @@getOp131
  1520 0000076D 66B803000000             mov eax, 3
  1521 00000773 E91500                   jmp @@retn
  1522                                  
  1523                                  ;-108     else error1("variable not found"); 
  1524                                  
  1525 00000776 E90900                   jmp @@getOp132
  1526                                  @@getOp131:
  1527 00000779 68[8C07]                 push getOp1_0
  1528 0000077C E83712                   call error1
  1529 0000077F 83C402                   add  sp, 2
  1530                                  
  1531                                  ;-109   }
  1532                                  
  1533                                  @@getOp132:
  1534                                  
  1535                                  ;-110   return 0;
  1536                                  
  1537                                  @@getOp129:
  1538 00000782 66B800000000             mov eax, 0
  1539 00000788 E90000                   jmp @@retn
  1540                                  
  1541                                  ;-111 }
  1542                                  
  1543                                  
  1544                                  ;-112 
  1545                                  
  1546                                  
  1547                                  ;-113 int getMEM() {// e.g. [array+bp+si-4]
  1548                                  
  1549                                  @@retn:
  1550 0000078B C3                       ret
  1551                                  ; ENDP
  1552 0000078C 7661726961626C6520-     getOp1_0 db "variable not found",0
  1553 00000795 6E6F7420666F756E64-
  1554 0000079E 00                 
  1555                                  
  1556                                  getMEM:  ; *** PROC ***
  1557                                  
  1558                                  ;-114 //set: disp, regindexbase, RegType
  1559                                  
  1560                                  
  1561                                  ;-115   char op2;
  1562                                  
  1563                                  
  1564                                  ;-116   disp=0; regindexbase=0; RegType=0;
  1565                                  
  1566                                  ;Function : getMEM, Number of local variables: 1
  1567                                  ;   # type sign width line used address name   list of local variables
  1568                                  ;  200 var sign byte   115 NULL bp-2    op2;
  1569 0000079F C8020000                 ENTER  2,0
  1570 000007A3 66B800000000             mov eax, 0
  1571 000007A9 A3[4700]                 mov word [disp], ax
  1572 000007AC 66B800000000             mov eax, 0
  1573 000007B2 A2[4600]                 mov byte [regindexbase], al
  1574 000007B5 66B800000000             mov eax, 0
  1575 000007BB A2[4200]                 mov byte [RegType], al
  1576                                  
  1577                                  ;-117   do {
  1578                                  
  1579                                  @@getMEM33:
  1580                                  
  1581                                  ;-118     getTokeType();
  1582                                  
  1583 000007BE E8C404                   call getTokeType
  1584                                  
  1585                                  ;-119     op2=getOp1();
  1586                                  
  1587 000007C1 E855FF                   call getOp1
  1588 000007C4 8846FE                   mov byte [bp-2], al
  1589                                  
  1590                                  ;-120     if (op2 ==   0) syntaxerror();
  1591                                  
  1592 000007C7 8A46FE                   mov al, [bp-2]
  1593 000007CA 3C00                     cmp al, 0
  1594 000007CC 0F850300                 jne @@getMEM34
  1595 000007D0 E80313                   call syntaxerror
  1596                                  
  1597                                  ;-121     if (op2 == REG) if (regindexbase) regindexbase=getIndReg2();
  1598                                  
  1599                                  @@getMEM34:
  1600 000007D3 8A46FE                   mov al, [bp-2]
  1601 000007D6 3C02                     cmp al, 2
  1602 000007D8 0F851500                 jne @@getMEM35
  1603 000007DC A0[4600]                 mov al, [regindexbase]
  1604 000007DF 08C0                     or  al, al
  1605 000007E1 0F840900                 je @@getMEM36
  1606 000007E5 E8F300                   call getIndReg2
  1607 000007E8 A2[4600]                 mov byte [regindexbase], al
  1608                                  
  1609                                  ;-122                     else getIndReg1();
  1610                                  
  1611 000007EB E90300                   jmp @@getMEM37
  1612                                  @@getMEM36:
  1613 000007EE E88900                   call getIndReg1
  1614                                  
  1615                                  ;-123     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  1616                                  
  1617                                  @@getMEM37:
  1618                                  @@getMEM35:
  1619 000007F1 8A46FE                   mov al, [bp-2]
  1620 000007F4 3C03                     cmp al, 3
  1621 000007F6 0F851000                 jne @@getMEM38
  1622 000007FA A1[4700]                 mov ax, [disp]
  1623 000007FD 8B1E[5400]               mov bx, [LabelIx]
  1624 00000801 D1E3                     shl bx, 1
  1625 00000803 0387A37A                 add ax, [LabelAddr + bx]
  1626 00000807 A3[4700]                 mov word [disp], ax
  1627                                  
  1628                                  ;-124     if (op2 == IMM) disp=disp+SymbolInt;
  1629                                  
  1630                                  @@getMEM38:
  1631 0000080A 8A46FE                   mov al, [bp-2]
  1632 0000080D 3C01                     cmp al, 1
  1633 0000080F 0F850A00                 jne @@getMEM39
  1634 00000813 A1[4700]                 mov ax, [disp]
  1635 00000816 0306[2600]               add ax, [SymbolInt]
  1636 0000081A A3[4700]                 mov word [disp], ax
  1637                                  
  1638                                  ;-125     if (isToken('-')) {
  1639                                  
  1640                                  @@getMEM39:
  1641 0000081D 6A2D                     push 45
  1642 0000081F E8E007                   call isToken
  1643 00000822 83C402                   add  sp, 2
  1644 00000825 08C0                     or  al, al
  1645 00000827 0F841900                 je @@getMEM40
  1646                                  
  1647                                  ;-126       getTokeType();
  1648                                  
  1649 0000082B E85704                   call getTokeType
  1650                                  
  1651                                  ;-127       if (TokeType != DIGIT) numbererror();
  1652                                  
  1653 0000082E A0[3C00]                 mov al, [TokeType]
  1654 00000831 3C01                     cmp al, 1
  1655 00000833 0F840300                 je  @@getMEM41
  1656 00000837 E83112                   call numbererror
  1657                                  
  1658                                  ;-128       disp = disp - SymbolInt;
  1659                                  
  1660                                  @@getMEM41:
  1661 0000083A A1[4700]                 mov ax, [disp]
  1662 0000083D 2B06[2600]               sub ax, [SymbolInt]
  1663 00000841 A3[4700]                 mov word [disp], ax
  1664                                  
  1665                                  ;-129     }
  1666                                  
  1667                                  
  1668                                  ;-130   } while (isToken('+'));
  1669                                  
  1670                                  @@getMEM40:
  1671 00000844 6A2B                     push 43
  1672 00000846 E8B907                   call isToken
  1673 00000849 83C402                   add  sp, 2
  1674 0000084C 08C0                     or  al, al
  1675 0000084E 0F840300                 je @@getMEM42
  1676 00000852 E969FF                   jmp @@getMEM33
  1677                                  @@getMEM42:
  1678                                  
  1679                                  ;-131   if (isToken(']') == 0) errorexit("] expected");
  1680                                  
  1681 00000855 6A5D                     push 93
  1682 00000857 E8A807                   call isToken
  1683 0000085A 83C402                   add  sp, 2
  1684 0000085D 83F800                   cmp ax, 0
  1685 00000860 0F850900                 jne @@getMEM43
  1686 00000864 68[6F08]                 push getMEM_0
  1687 00000867 E87D12                   call errorexit
  1688 0000086A 83C402                   add  sp, 2
  1689                                  
  1690                                  ;-132 }
  1691                                  
  1692                                  @@getMEM43:
  1693                                  
  1694                                  ;-133 int getIndReg1() {
  1695 0000086D C9                       LEAVE
  1696 0000086E C3                       ret
  1697                                  ; ENDP
  1698 0000086F 5D2065787065637465-     getMEM_0 db "] expected",0
  1699 00000878 6400               
  1700                                  
  1701                                  getIndReg1:  ; *** PROC ***
  1702                                  
  1703                                  ;-134   if (RegType !=WORD) indexerror();
  1704                                  
  1705 0000087A A0[4200]                 mov al, [RegType]
  1706 0000087D 3C02                     cmp al, 2
  1707 0000087F 0F840300                 je  @@getIndReg144
  1708 00000883 E8C411                   call indexerror
  1709                                  
  1710                                  ;-135   if (RegNo==3) regindexbase=7;//BX
  1711                                  
  1712                                  @@getIndReg144:
  1713 00000886 A0[4300]                 mov al, [RegNo]
  1714 00000889 3C03                     cmp al, 3
  1715 0000088B 0F850900                 jne @@getIndReg145
  1716 0000088F 66B807000000             mov eax, 7
  1717 00000895 A2[4600]                 mov byte [regindexbase], al
  1718                                  
  1719                                  ;-136   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  1720                                  
  1721                                  @@getIndReg145:
  1722 00000898 A0[4300]                 mov al, [RegNo]
  1723 0000089B 3C05                     cmp al, 5
  1724 0000089D 0F850900                 jne @@getIndReg146
  1725 000008A1 66B806000000             mov eax, 6
  1726 000008A7 A2[4600]                 mov byte [regindexbase], al
  1727                                  
  1728                                  ;-137   if (RegNo==7) regindexbase=5;//DI
  1729                                  
  1730                                  @@getIndReg146:
  1731 000008AA A0[4300]                 mov al, [RegNo]
  1732 000008AD 3C07                     cmp al, 7
  1733 000008AF 0F850900                 jne @@getIndReg147
  1734 000008B3 66B805000000             mov eax, 5
  1735 000008B9 A2[4600]                 mov byte [regindexbase], al
  1736                                  
  1737                                  ;-138   if (RegNo==6) regindexbase=4;//SI
  1738                                  
  1739                                  @@getIndReg147:
  1740 000008BC A0[4300]                 mov al, [RegNo]
  1741 000008BF 3C06                     cmp al, 6
  1742 000008C1 0F850900                 jne @@getIndReg148
  1743 000008C5 66B804000000             mov eax, 4
  1744 000008CB A2[4600]                 mov byte [regindexbase], al
  1745                                  
  1746                                  ;-139   if (regindexbase==0) indexerror();
  1747                                  
  1748                                  @@getIndReg148:
  1749 000008CE A0[4600]                 mov al, [regindexbase]
  1750 000008D1 3C00                     cmp al, 0
  1751 000008D3 0F850300                 jne @@getIndReg149
  1752 000008D7 E87011                   call indexerror
  1753                                  
  1754                                  ;-140 }
  1755                                  
  1756                                  @@getIndReg149:
  1757                                  
  1758                                  ;-141 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1759                                  
  1760 000008DA C3                       ret
  1761                                  ; ENDP
  1762                                  
  1763                                  getIndReg2:  ; *** PROC ***
  1764                                  ;Function : getIndReg2, Number of local variables: 1
  1765                                  ;   # type sign width line used address name   list of local variables
  1766                                  ;  200 var sign byte   141 NULL bp-2    m;
  1767 000008DB C8020000                 ENTER  2,0
  1768 000008DF 66B804000000             mov eax, 4
  1769 000008E5 8846FE                   mov byte [bp-2], al
  1770                                  
  1771                                  ;-142   if (RegType !=WORD) indexerror();
  1772                                  
  1773 000008E8 A0[4200]                 mov al, [RegType]
  1774 000008EB 3C02                     cmp al, 2
  1775 000008ED 0F840300                 je  @@getIndReg250
  1776 000008F1 E85611                   call indexerror
  1777                                  
  1778                                  ;-143   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  1779                                  
  1780                                  @@getIndReg250:
  1781 000008F4 A0[4300]                 mov al, [RegNo]
  1782 000008F7 3C07                     cmp al, 7
  1783 000008F9 0F852700                 jne @@getIndReg251
  1784 000008FD A0[4600]                 mov al, [regindexbase]
  1785 00000900 3C06                     cmp al, 6
  1786 00000902 0F850C00                 jne @@getIndReg252
  1787 00000906 66B803000000             mov eax, 3
  1788 0000090C 8846FE                   mov byte [bp-2], al
  1789                                  
  1790                                  ;-144            else if (regindexbase==7) m=1;//BX+DI
  1791                                  
  1792 0000090F E91200                   jmp @@getIndReg253
  1793                                  @@getIndReg252:
  1794 00000912 A0[4600]                 mov al, [regindexbase]
  1795 00000915 3C07                     cmp al, 7
  1796 00000917 0F850900                 jne @@getIndReg254
  1797 0000091B 66B801000000             mov eax, 1
  1798 00000921 8846FE                   mov byte [bp-2], al
  1799                                  
  1800                                  ;-145   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  1801                                  
  1802                                  @@getIndReg254:
  1803                                  @@getIndReg253:
  1804                                  @@getIndReg251:
  1805 00000924 A0[4300]                 mov al, [RegNo]
  1806 00000927 3C06                     cmp al, 6
  1807 00000929 0F852700                 jne @@getIndReg255
  1808 0000092D A0[4600]                 mov al, [regindexbase]
  1809 00000930 3C06                     cmp al, 6
  1810 00000932 0F850C00                 jne @@getIndReg256
  1811 00000936 66B802000000             mov eax, 2
  1812 0000093C 8846FE                   mov byte [bp-2], al
  1813                                  
  1814                                  ;-146            else if (regindexbase==7) m=0;//BX+SI
  1815                                  
  1816 0000093F E91200                   jmp @@getIndReg257
  1817                                  @@getIndReg256:
  1818 00000942 A0[4600]                 mov al, [regindexbase]
  1819 00000945 3C07                     cmp al, 7
  1820 00000947 0F850900                 jne @@getIndReg258
  1821 0000094B 66B800000000             mov eax, 0
  1822 00000951 8846FE                   mov byte [bp-2], al
  1823                                  
  1824                                  ;-147   if (m > 3) indexerror();
  1825                                  
  1826                                  @@getIndReg258:
  1827                                  @@getIndReg257:
  1828                                  @@getIndReg255:
  1829 00000954 8A46FE                   mov al, [bp-2]
  1830 00000957 3C03                     cmp al, 3
  1831 00000959 0F8E0300                 jle @@getIndReg259
  1832 0000095D E8EA10                   call indexerror
  1833                                  
  1834                                  ;-148   return m;
  1835                                  
  1836                                  @@getIndReg259:
  1837 00000960 8A46FE                   mov al, [bp-2]
  1838 00000963 E90000                   jmp @@retn
  1839                                  
  1840                                  ;-149 }
  1841                                  
  1842                                  
  1843                                  ;-150 
  1844                                  
  1845                                  
  1846                                  ;-151 // generate code ........................................
  1847                                  
  1848                                  
  1849                                  ;-152 int getCodes() {
  1850                                  
  1851 00000966 C9                      @@retn: LEAVE
  1852 00000967 C3                       ret
  1853                                  ; ENDP
  1854                                  
  1855                                  getCodes:  ; *** PROC ***
  1856                                  
  1857                                  ;-153   OpCodePtr ++; Code1 = *OpCodePtr;
  1858                                  
  1859 00000968 FF06[4D00]               inc  word [OpCodePtr]
  1860 0000096C 8B1E[4D00]               mov bx, [OpCodePtr]
  1861 00000970 8A07                     mov al, [bx]
  1862 00000972 B400                     mov ah, 0
  1863 00000974 A2[3F00]                 mov byte [Code1], al
  1864                                  
  1865                                  ;-154   OpCodePtr ++; Code2 = *OpCodePtr;
  1866                                  
  1867 00000977 FF06[4D00]               inc  word [OpCodePtr]
  1868 0000097B 8B1E[4D00]               mov bx, [OpCodePtr]
  1869 0000097F 8A07                     mov al, [bx]
  1870 00000981 B400                     mov ah, 0
  1871 00000983 A2[4000]                 mov byte [Code2], al
  1872                                  
  1873                                  ;-155   OpCodePtr ++; Code3 = *OpCodePtr;
  1874                                  
  1875 00000986 FF06[4D00]               inc  word [OpCodePtr]
  1876 0000098A 8B1E[4D00]               mov bx, [OpCodePtr]
  1877 0000098E 8A07                     mov al, [bx]
  1878 00000990 B400                     mov ah, 0
  1879 00000992 A2[4100]                 mov byte [Code3], al
  1880                                  
  1881                                  ;-156 }
  1882                                  
  1883                                  
  1884                                  ;-157 int gen66h() {genCode8(0x66);
  1885                                  
  1886 00000995 C3                       ret
  1887                                  ; ENDP
  1888                                  
  1889                                  gen66h:  ; *** PROC ***
  1890 00000996 6A66                     push 102
  1891 00000998 E81F00                   call genCode8
  1892 0000099B 83C402                   add  sp, 2
  1893                                  
  1894                                  ;-158 }
  1895                                  
  1896                                  
  1897                                  ;-159 int genCode(char c, char d) {
  1898                                  
  1899 0000099E C3                       ret
  1900                                  ; ENDP
  1901                                  
  1902                                  genCode:  ; *** PROC ***
  1903                                  
  1904                                  ;-160     c = c + d;
  1905                                  
  1906                                  ;Function : genCode, Number of local variables: 2
  1907                                  ;   # type sign width line used address name   list of local variables
  1908                                  ;  200 var sign byte   159 NULL bp+4    c
  1909                                  ;  201 var sign byte   159 NULL bp+6    d;
  1910 0000099F C8000000                 ENTER  0,0
  1911 000009A3 8A4604                   mov al, [bp+4]
  1912 000009A6 024606                   add al, [bp+6]
  1913 000009A9 884604                   mov byte [bp+4], al
  1914                                  
  1915                                  ;-161     genCode8(c);
  1916                                  
  1917 000009AC 8A4604                   mov al, byte [bp+4]
  1918 000009AF B400                     mov ah, 0
  1919 000009B1 50                       push ax
  1920 000009B2 E80500                   call genCode8
  1921 000009B5 83C402                   add  sp, 2
  1922                                  
  1923                                  ;-162 }
  1924                                  
  1925                                  
  1926                                  ;-163 int genCode8(char c) {
  1927 000009B8 C9                       LEAVE
  1928 000009B9 C3                       ret
  1929                                  ; ENDP
  1930                                  
  1931                                  genCode8:  ; *** PROC ***
  1932                                  
  1933                                  ;-164 //set: BinLen++, OpPrintIndex++
  1934                                  
  1935                                  
  1936                                  ;-165   FileBin[BinLen]=c;
  1937                                  
  1938                                  ;Function : genCode8, Number of local variables: 1
  1939                                  ;   # type sign width line used address name   list of local variables
  1940                                  ;  200 var sign byte   163 NULL bp+4    c;
  1941 000009BA C8000000                 ENTER  0,0
  1942 000009BE 8A4604                   mov al, [bp+4]
  1943 000009C1 8B1E[5600]               mov bx, [BinLen]
  1944 000009C5 88876B7B                 mov [FileBin+bx], al
  1945                                  
  1946                                  ;-166   BinLen++;
  1947                                  
  1948 000009C9 FF06[5600]               inc  word [BinLen]
  1949                                  
  1950                                  ;-167   PC++;
  1951                                  
  1952 000009CD FF06[3700]               inc  word [PC]
  1953                                  
  1954                                  ;-168   if (OpPrintIndex < OPMAXLEN) {
  1955                                  
  1956 000009D1 A1[4B00]                 mov ax, [OpPrintIndex]
  1957 000009D4 83F805                   cmp ax, 5
  1958 000009D7 0F8D0F00                 jge @@genCode860
  1959                                  
  1960                                  ;-169     OpPos[OpPrintIndex]=c;
  1961                                  
  1962 000009DB 8A4604                   mov al, [bp+4]
  1963 000009DE 8B1E[4B00]               mov bx, [OpPrintIndex]
  1964 000009E2 8887B676                 mov [OpPos+bx], al
  1965                                  
  1966                                  ;-170     OpPrintIndex++;
  1967                                  
  1968 000009E6 FF06[4B00]               inc  word [OpPrintIndex]
  1969                                  
  1970                                  ;-171   }
  1971                                  
  1972                                  
  1973                                  ;-172 }
  1974                                  
  1975                                  @@genCode860:
  1976                                  
  1977                                  ;-173 int genCode16(int i) {
  1978 000009EA C9                       LEAVE
  1979 000009EB C3                       ret
  1980                                  ; ENDP
  1981                                  
  1982                                  genCode16:  ; *** PROC ***
  1983                                  
  1984                                  ;-174   genCode8(i); i=i >> 8;
  1985                                  
  1986                                  ;Function : genCode16, Number of local variables: 1
  1987                                  ;   # type sign width line used address name   list of local variables
  1988                                  ;  200 var sign word   173 NULL bp+4    i;
  1989 000009EC C8000000                 ENTER  0,0
  1990 000009F0 FF7604                   push word [bp+4]
  1991 000009F3 E8C4FF                   call genCode8
  1992 000009F6 83C402                   add  sp, 2
  1993 000009F9 8B4604                   mov ax, [bp+4]
  1994 000009FC C1E808                   shr ax, 8
  1995 000009FF 894604                   mov word [bp+4], ax
  1996                                  
  1997                                  ;-175   genCode8(i);
  1998                                  
  1999 00000A02 FF7604                   push word [bp+4]
  2000 00000A05 E8B2FF                   call genCode8
  2001 00000A08 83C402                   add  sp, 2
  2002                                  
  2003                                  ;-176 }
  2004                                  
  2005                                  
  2006                                  ;-177 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  2007 00000A0B C9                       LEAVE
  2008 00000A0C C3                       ret
  2009                                  ; ENDP
  2010                                  
  2011                                  writeEA:  ; *** PROC ***
  2012                                  
  2013                                  ;-178 //mod-byte: mode76, reg/opcode543, r/m210    
  2014                                  
  2015                                  
  2016                                  ;-179   char len;
  2017                                  
  2018                                  
  2019                                  ;-180   len=0;
  2020                                  
  2021                                  ;Function : writeEA, Number of local variables: 2
  2022                                  ;   # type sign width line used address name   list of local variables
  2023                                  ;  200 var sign byte   177 NULL bp+4    xxx
  2024                                  ;  201 var sign byte   179 NULL bp-2    len;
  2025 00000A0D C8020000                 ENTER  2,0
  2026 00000A11 66B800000000             mov eax, 0
  2027 00000A17 8846FE                   mov byte [bp-2], al
  2028                                  
  2029                                  ;-181   prs("\nxxx:"); printhex8a(xxx);
  2030                                  
  2031 00000A1A 68[620B]                 push writeEA_0
  2032 00000A1D E8390E                   call prs
  2033 00000A20 83C402                   add  sp, 2
  2034 00000A23 8A4604                   mov al, byte [bp+4]
  2035 00000A26 B400                     mov ah, 0
  2036 00000A28 50                       push ax
  2037 00000A29 E8D00E                   call printhex8a
  2038 00000A2C 83C402                   add  sp, 2
  2039                                  
  2040                                  ;-182   xxx = xxx << 3;//in reg/opcode field
  2041                                  
  2042 00000A2F 8A4604                   mov al, [bp+4]
  2043 00000A32 C0E003                   shl al, 3
  2044 00000A35 884604                   mov byte [bp+4], al
  2045                                  
  2046                                  ;-183   prs(" xx:"); printhex8a(xxx);
  2047                                  
  2048 00000A38 68[690B]                 push writeEA_1
  2049 00000A3B E81B0E                   call prs
  2050 00000A3E 83C402                   add  sp, 2
  2051 00000A41 8A4604                   mov al, byte [bp+4]
  2052 00000A44 B400                     mov ah, 0
  2053 00000A46 50                       push ax
  2054 00000A47 E8B20E                   call printhex8a
  2055 00000A4A 83C402                   add  sp, 2
  2056                                  
  2057                                  ;-184   if (Op1 ==   0) addrexit();
  2058                                  
  2059 00000A4D A0[3D00]                 mov al, [Op1]
  2060 00000A50 3C00                     cmp al, 0
  2061 00000A52 0F850300                 jne @@writeEA61
  2062 00000A56 E8A510                   call addrexit
  2063                                  
  2064                                  ;-185   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  2065                                  
  2066                                  @@writeEA61:
  2067 00000A59 A0[3D00]                 mov al, [Op1]
  2068 00000A5C 3C02                     cmp al, 2
  2069 00000A5E 0F850E00                 jne @@writeEA62
  2070 00000A62 804E04C0                 or  byte [bp+4], 192
  2071 00000A66 8A4604                   mov al, [bp+4]
  2072 00000A69 0206[4300]               add al, [RegNo]
  2073 00000A6D 884604                   mov byte [bp+4], al
  2074                                  
  2075                                  ;-186   if (Op1 == ADR) {xxx = xxx + 6; len=2; }            
  2076                                  
  2077                                  @@writeEA62:
  2078 00000A70 A0[3D00]                 mov al, [Op1]
  2079 00000A73 3C03                     cmp al, 3
  2080 00000A75 0F851100                 jne @@writeEA63
  2081 00000A79 8A4604                   mov al, [bp+4]
  2082 00000A7C 0406                     add al, 6
  2083 00000A7E 884604                   mov byte [bp+4], al
  2084 00000A81 66B802000000             mov eax, 2
  2085 00000A87 8846FE                   mov byte [bp-2], al
  2086                                  
  2087                                  ;-187   if (Op1 == MEM) {xxx = xxx + regindexbase;   
  2088                                  
  2089                                  @@writeEA63:
  2090 00000A8A A0[3D00]                 mov al, [Op1]
  2091 00000A8D 3C04                     cmp al, 4
  2092 00000A8F 0F859B00                 jne @@writeEA64
  2093 00000A93 8A4604                   mov al, [bp+4]
  2094 00000A96 0206[4600]               add al, [regindexbase]
  2095 00000A9A 884604                   mov byte [bp+4], al
  2096                                  
  2097                                  ;-188   prs(" x:"); printhex8a(xxx);
  2098                                  
  2099 00000A9D 68[6E0B]                 push writeEA_2
  2100 00000AA0 E8B60D                   call prs
  2101 00000AA3 83C402                   add  sp, 2
  2102 00000AA6 8A4604                   mov al, byte [bp+4]
  2103 00000AA9 B400                     mov ah, 0
  2104 00000AAB 50                       push ax
  2105 00000AAC E84D0E                   call printhex8a
  2106 00000AAF 83C402                   add  sp, 2
  2107                                  
  2108                                  ;-189   prs(" Op1:"); printhex8a(Op1);
  2109                                  
  2110 00000AB2 68[720B]                 push writeEA_3
  2111 00000AB5 E8A10D                   call prs
  2112 00000AB8 83C402                   add  sp, 2
  2113 00000ABB A0[3D00]                 mov al, byte [Op1]
  2114 00000ABE B400                     mov ah, 0
  2115 00000AC0 50                       push ax
  2116 00000AC1 E8380E                   call printhex8a
  2117 00000AC4 83C402                   add  sp, 2
  2118                                  
  2119                                  ;-190   prs(" regindexbase:"); printhex8a(regindexbase);
  2120                                  
  2121 00000AC7 68[780B]                 push writeEA_4
  2122 00000ACA E88C0D                   call prs
  2123 00000ACD 83C402                   add  sp, 2
  2124 00000AD0 A0[4600]                 mov al, byte [regindexbase]
  2125 00000AD3 B400                     mov ah, 0
  2126 00000AD5 50                       push ax
  2127 00000AD6 E8230E                   call printhex8a
  2128 00000AD9 83C402                   add  sp, 2
  2129                                  
  2130                                  ;-191     if (regindexbase == 6) {//[BP+00]
  2131                                  
  2132 00000ADC A0[4600]                 mov al, [regindexbase]
  2133 00000ADF 3C06                     cmp al, 6
  2134 00000AE1 0F850D00                 jne @@writeEA65
  2135                                  
  2136                                  ;-192       len=1;
  2137                                  
  2138 00000AE5 66B801000000             mov eax, 1
  2139 00000AEB 8846FE                   mov byte [bp-2], al
  2140                                  
  2141                                  ;-193       xxx |= 0x40;
  2142                                  
  2143 00000AEE 804E0440                 or  byte [bp+4], 64
  2144                                  
  2145                                  ;-194     }
  2146                                  
  2147                                  
  2148                                  ;-195     if (disp) {
  2149                                  
  2150                                  @@writeEA65:
  2151 00000AF2 A1[4700]                 mov ax, [disp]
  2152 00000AF5 08C0                     or  al, al
  2153 00000AF7 0F843300                 je @@writeEA66
  2154                                  
  2155                                  ;-196       disp;
  2156                                  
  2157 00000AFB A1[4700]                 mov ax, [disp]
  2158                                  
  2159                                  ;-197       if(ax > 127) len=2;
  2160                                  
  2161 00000AFE 83F87F                   cmp  ax, 127
  2162 00000B01 0F8E0C00                 jle @@writeEA67
  2163 00000B05 66B802000000             mov eax, 2
  2164 00000B0B 8846FE                   mov byte [bp-2], al
  2165                                  
  2166                                  ;-198       else len=1;
  2167                                  
  2168 00000B0E E90900                   jmp @@writeEA68
  2169                                  @@writeEA67:
  2170 00000B11 66B801000000             mov eax, 1
  2171 00000B17 8846FE                   mov byte [bp-2], al
  2172                                  
  2173                                  ;-199       if (len == 1) xxx |= 0x40;
  2174                                  
  2175                                  @@writeEA68:
  2176 00000B1A 8A46FE                   mov al, [bp-2]
  2177 00000B1D 3C01                     cmp al, 1
  2178 00000B1F 0F850700                 jne @@writeEA69
  2179 00000B23 804E0440                 or  byte [bp+4], 64
  2180                                  
  2181                                  ;-200       else xxx |= 0x80;
  2182                                  
  2183 00000B27 E90400                   jmp @@writeEA70
  2184                                  @@writeEA69:
  2185 00000B2A 804E0480                 or  byte [bp+4], 128
  2186                                  
  2187                                  ;-201     }
  2188                                  
  2189                                  @@writeEA70:
  2190                                  
  2191                                  ;-202   }
  2192                                  
  2193                                  @@writeEA66:
  2194                                  
  2195                                  ;-203   genCode8(xxx);// gen second byte
  2196                                  
  2197                                  @@writeEA64:
  2198 00000B2E 8A4604                   mov al, byte [bp+4]
  2199 00000B31 B400                     mov ah, 0
  2200 00000B33 50                       push ax
  2201 00000B34 E883FE                   call genCode8
  2202 00000B37 83C402                   add  sp, 2
  2203                                  
  2204                                  ;-204   if (len == 1) genCode8 (disp);
  2205                                  
  2206 00000B3A 8A46FE                   mov al, [bp-2]
  2207 00000B3D 3C01                     cmp al, 1
  2208 00000B3F 0F850A00                 jne @@writeEA71
  2209 00000B43 FF36[4700]               push word [disp]
  2210 00000B47 E870FE                   call genCode8
  2211 00000B4A 83C402                   add  sp, 2
  2212                                  
  2213                                  ;-205   if (len == 2) genCode16(disp);
  2214                                  
  2215                                  @@writeEA71:
  2216 00000B4D 8A46FE                   mov al, [bp-2]
  2217 00000B50 3C02                     cmp al, 2
  2218 00000B52 0F850A00                 jne @@writeEA72
  2219 00000B56 FF36[4700]               push word [disp]
  2220 00000B5A E88FFE                   call genCode16
  2221 00000B5D 83C402                   add  sp, 2
  2222                                  
  2223                                  ;-206 }
  2224                                  
  2225                                  @@writeEA72:
  2226                                  
  2227                                  ;-207 
  2228                                  
  2229                                  
  2230                                  ;-208 int testx() { __asm {
  2231 00000B60 C9                       LEAVE
  2232 00000B61 C3                       ret
  2233                                  ; ENDP
  2234 00000B62 5C6E7878783A00          writeEA_0 db "\nxxx:",0
  2235 00000B69 2078783A00              writeEA_1 db " xx:",0
  2236 00000B6E 20783A00                writeEA_2 db " x:",0
  2237 00000B72 204F70313A00            writeEA_3 db " Op1:",0
  2238 00000B78 20726567696E646578-     writeEA_4 db " regindexbase:",0
  2239 00000B81 626173653A00       
  2240                                  
  2241                                  testx:  ; *** PROC ***
  2242                                  
  2243                                  
  2244                                  ;-209 inc byte [Version1]   ;FE 06 [1000]
  2245                                  
  2246 00000B87 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  2247                                  
  2248                                  ;-210 add bx, ax    ;01 C3
  2249                                  
  2250 00000B8B 01C3                    add bx, ax    ;01 C3
  2251                                  
  2252                                  ;-211 add ax, bx    ;01 D8
  2253                                  
  2254 00000B8D 01D8                    add ax, bx    ;01 D8
  2255                                  
  2256                                  ;-212 add word ax, [bx] ;03 07
  2257                                  
  2258 00000B8F 0307                    add word ax, [bx] ;03 07
  2259                                  
  2260                                  ;-213 VA dw 8
  2261                                  
  2262 00000B91 0800                    VA dw 8
  2263                                  
  2264                                  ;-214 mov byte [bp- 4], al ;88 46 FC
  2265                                  
  2266 00000B93 8846FC                  mov byte [bp- 4], al ;88 46 FC
  2267                                  
  2268                                  ;-215 mov      [VA+bx], al ;88 87 [300F]
  2269                                  
  2270 00000B96 8887[910B]              mov      [VA+bx], al ;88 87 [300F]
  2271                                  
  2272                                  ;-216 }  
  2273                                  
  2274                                  
  2275                                  
  2276                                  ;-217 }
  2277                                  
  2278                                  
  2279                                  ;-218 #include "PARSE.C"
  2280                                  
  2281 00000B9A C3                       ret
  2282                                  ; ENDP
  2283                                  ;Use include file: PARSE.C
  2284                                  
  2285                                  ;-1 int parse() {
  2286                                  
  2287                                  
  2288                                  parse:  ; *** PROC ***
  2289                                  
  2290                                  ;-2   LabelNamePtr= &LabelNames;
  2291                                  
  2292 00000B9B B8BB76                   mov ax, LabelNames
  2293 00000B9E A3[5000]                 mov word [LabelNamePtr], ax
  2294                                  
  2295                                  ;-3   do {
  2296                                  
  2297                                  @@parse73:
  2298                                  
  2299                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  2300                                  
  2301 00000BA1 A1[3700]                 mov ax, [PC]
  2302 00000BA4 A3[3900]                 mov word [PCStart], ax
  2303 00000BA7 66B800000000             mov eax, 0
  2304 00000BAD A2[4400]                 mov byte [OpSize], al
  2305 00000BB0 66B800000000             mov eax, 0
  2306 00000BB6 A3[4B00]                 mov word [OpPrintIndex], ax
  2307 00000BB9 66B820000000             mov eax, 32
  2308 00000BBF A2[4F00]                 mov byte [PrintR], al
  2309                                  
  2310                                  ;-5     getLine();
  2311                                  
  2312 00000BC2 E89404                   call getLine
  2313                                  
  2314                                  ;-6     InputPtr = &InputBuf;
  2315                                  
  2316 00000BC5 B86E75                   mov ax, InputBuf
  2317 00000BC8 A3[2800]                 mov word [InputPtr], ax
  2318                                  
  2319                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2320                                  
  2321 00000BCB E8B700                   call getTokeType
  2322                                  
  2323                                  ;-8     if (TokeType == ALNUME) {
  2324                                  
  2325 00000BCE A0[3C00]                 mov al, [TokeType]
  2326 00000BD1 3C03                     cmp al, 3
  2327 00000BD3 0F851300                 jne @@parse74
  2328                                  
  2329                                  ;-9       if (isLabel) { //set in getName
  2330                                  
  2331 00000BD7 A0[3B00]                 mov al, [isLabel]
  2332 00000BDA 08C0                     or  al, al
  2333 00000BDC 0F840A00                 je @@parse75
  2334                                  
  2335                                  ;-10         storeLabel();
  2336                                  
  2337 00000BE0 E84001                   call storeLabel
  2338                                  
  2339                                  ;-11         InputPtr++;//remove :
  2340                                  
  2341 00000BE3 FF06[2800]               inc  word [InputPtr]
  2342                                  
  2343                                  ;-12         getTokeType();
  2344                                  
  2345 00000BE7 E89B00                   call getTokeType
  2346                                  
  2347                                  ;-13       }
  2348                                  
  2349                                  
  2350                                  ;-14     }
  2351                                  
  2352                                  @@parse75:
  2353                                  
  2354                                  ;-15     if (TokeType == ALNUME) {
  2355                                  
  2356                                  @@parse74:
  2357 00000BEA A0[3C00]                 mov al, [TokeType]
  2358 00000BED 3C03                     cmp al, 3
  2359 00000BEF 0F851B00                 jne @@parse76
  2360                                  
  2361                                  ;-16       lookCode();// and OpCodePtr
  2362                                  
  2363 00000BF3 E80F03                   call lookCode
  2364                                  
  2365                                  ;-17       if(CodeType) process();
  2366                                  
  2367 00000BF6 A0[3E00]                 mov al, [CodeType]
  2368 00000BF9 08C0                     or  al, al
  2369 00000BFB 0F840600                 je @@parse77
  2370 00000BFF E80FF8                   call process
  2371                                  
  2372                                  ;-18       else getVariable();
  2373                                  
  2374 00000C02 E90300                   jmp @@parse78
  2375                                  @@parse77:
  2376 00000C05 E8C501                   call getVariable
  2377                                  
  2378                                  ;-19       skipRest();
  2379                                  
  2380                                  @@parse78:
  2381 00000C08 E82504                   call skipRest
  2382                                  
  2383                                  ;-20     }
  2384                                  
  2385                                  
  2386                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2387                                  
  2388 00000C0B E92700                   jmp @@parse79
  2389                                  @@parse76:
  2390 00000C0E A0[3C00]                 mov al, [TokeType]
  2391 00000C11 3C03                     cmp al, 3
  2392 00000C13 0F8E0C00                 jle @@parse80
  2393 00000C17 68[460C]                 push parse_0
  2394 00000C1A E8990D                   call error1
  2395 00000C1D 83C402                   add  sp, 2
  2396                                  
  2397                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2398                                  
  2399 00000C20 E91200                   jmp @@parse81
  2400                                  @@parse80:
  2401 00000C23 A0[3C00]                 mov al, [TokeType]
  2402 00000C26 3C01                     cmp al, 1
  2403 00000C28 0F850900                 jne @@parse82
  2404 00000C2C 68[640C]                 push parse_1
  2405 00000C2F E8840D                   call error1
  2406 00000C32 83C402                   add  sp, 2
  2407                                  
  2408                                  ;-23     printLine();
  2409                                  
  2410                                  @@parse82:
  2411                                  @@parse81:
  2412                                  @@parse79:
  2413 00000C35 E8130B                   call printLine
  2414                                  
  2415                                  ;-24   } while (DOS_NoBytes != 0 );
  2416                                  
  2417 00000C38 A1[3400]                 mov ax, [DOS_NoBytes]
  2418 00000C3B 83F800                   cmp ax, 0
  2419 00000C3E 0F840300                 je  @@parse83
  2420 00000C42 E95CFF                   jmp @@parse73
  2421                                  @@parse83:
  2422                                  
  2423                                  ;-25 }
  2424                                  
  2425                                  
  2426                                  ;-26 // scan code .....................................
  2427                                  
  2428                                  
  2429                                  ;-27 int getTokeType() { char c;
  2430                                  
  2431 00000C45 C3                       ret
  2432                                  ; ENDP
  2433 00000C46 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2434 00000C4F 696E73747275637469-
  2435 00000C58 6F6E20657870656374-
  2436 00000C61 656400             
  2437 00000C64 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2438 00000C6D 616C6C6F7765642040-
  2439 00000C76 207374617274206F66-
  2440 00000C7F 206C696E6500       
  2441                                  
  2442                                  getTokeType:  ; *** PROC ***
  2443                                  
  2444                                  ;-28   skipBlank();
  2445                                  
  2446                                  ;Function : getTokeType, Number of local variables: 1
  2447                                  ;   # type sign width line used address name   list of local variables
  2448                                  ;  200 var sign byte    27 NULL bp-2    c;
  2449 00000C85 C8020000                 ENTER  2,0
  2450 00000C89 E89A04                   call skipBlank
  2451                                  
  2452                                  ;-29   c = *InputPtr;
  2453                                  
  2454 00000C8C 8B1E[2800]               mov bx, [InputPtr]
  2455 00000C90 8A07                     mov al, [bx]
  2456 00000C92 B400                     mov ah, 0
  2457 00000C94 8846FE                   mov byte [bp-2], al
  2458                                  
  2459                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2460                                  
  2461 00000C97 8A46FE                   mov al, [bp-2]
  2462 00000C9A 3C00                     cmp al, 0
  2463 00000C9C 0F850C00                 jne @@getTokeType84
  2464 00000CA0 66B800000000             mov eax, 0
  2465 00000CA6 A2[3C00]                 mov byte [TokeType], al
  2466 00000CA9 E97500                   jmp @@retn
  2467                                  
  2468                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2469                                  
  2470                                  @@getTokeType84:
  2471 00000CAC 8A46FE                   mov al, [bp-2]
  2472 00000CAF 3C3B                     cmp al, 59
  2473 00000CB1 0F850C00                 jne @@getTokeType85
  2474 00000CB5 66B800000000             mov eax, 0
  2475 00000CBB A2[3C00]                 mov byte [TokeType], al
  2476 00000CBE E96000                   jmp @@retn
  2477                                  
  2478                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2479                                  
  2480                                  @@getTokeType85:
  2481 00000CC1 8A46FE                   mov al, byte [bp-2]
  2482 00000CC4 B400                     mov ah, 0
  2483 00000CC6 50                       push ax
  2484 00000CC7 E84013                   call digit
  2485 00000CCA 83C402                   add  sp, 2
  2486 00000CCD 08C0                     or  al, al
  2487 00000CCF 0F841800                 je @@getTokeType86
  2488 00000CD3 8A46FE                   mov al, byte [bp-2]
  2489 00000CD6 B400                     mov ah, 0
  2490 00000CD8 50                       push ax
  2491 00000CD9 E85005                   call getDigit
  2492 00000CDC 83C402                   add  sp, 2
  2493 00000CDF 66B801000000             mov eax, 1
  2494 00000CE5 A2[3C00]                 mov byte [TokeType], al
  2495 00000CE8 E93600                   jmp @@retn
  2496                                  
  2497                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2498                                  
  2499                                  @@getTokeType86:
  2500 00000CEB 8A46FE                   mov al, byte [bp-2]
  2501 00000CEE B400                     mov ah, 0
  2502 00000CF0 50                       push ax
  2503 00000CF1 E85D04                   call letterE
  2504 00000CF4 83C402                   add  sp, 2
  2505 00000CF7 08C0                     or  al, al
  2506 00000CF9 0F841800                 je @@getTokeType87
  2507 00000CFD 8A46FE                   mov al, byte [bp-2]
  2508 00000D00 B400                     mov ah, 0
  2509 00000D02 50                       push ax
  2510 00000D03 E87D05                   call getName
  2511 00000D06 83C402                   add  sp, 2
  2512 00000D09 66B803000000             mov eax, 3
  2513 00000D0F A2[3C00]                 mov byte [TokeType], al
  2514 00000D12 E90C00                   jmp @@retn
  2515                                  
  2516                                  ;-34   TokeType=NOALNUME; return;
  2517                                  
  2518                                  @@getTokeType87:
  2519 00000D15 66B804000000             mov eax, 4
  2520 00000D1B A2[3C00]                 mov byte [TokeType], al
  2521 00000D1E E90000                   jmp @@retn
  2522                                  
  2523                                  ;-35 }
  2524                                  
  2525                                  
  2526                                  ;-36 int storeLabel() {
  2527                                  
  2528 00000D21 C9                      @@retn: LEAVE
  2529 00000D22 C3                       ret
  2530                                  ; ENDP
  2531                                  
  2532                                  storeLabel:  ; *** PROC ***
  2533                                  
  2534                                  ;-37   if(searchLabel()) error1("duplicate label");
  2535                                  
  2536 00000D23 E84700                   call searchLabel
  2537 00000D26 08C0                     or  al, al
  2538 00000D28 0F840900                 je @@storeLabel88
  2539 00000D2C 68[5D0D]                 push storeLabel_0
  2540 00000D2F E8840C                   call error1
  2541 00000D32 83C402                   add  sp, 2
  2542                                  
  2543                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2544                                  
  2545                                  @@storeLabel88:
  2546 00000D35 8D063075                 lea  ax, [Symbol]
  2547 00000D39 50                       push ax
  2548 00000D3A FF36[5000]               push word [LabelNamePtr]
  2549 00000D3E E89012                   call strcpy
  2550 00000D41 83C404                   add  sp, 4
  2551 00000D44 A3[5000]                 mov word [LabelNamePtr], ax
  2552                                  
  2553                                  ;-39   LabelNamePtr++;
  2554                                  
  2555 00000D47 FF06[5000]               inc  word [LabelNamePtr]
  2556                                  
  2557                                  ;-40   LabelMaxIx++;
  2558                                  
  2559 00000D4B FF06[5200]               inc  word [LabelMaxIx]
  2560                                  
  2561                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2562                                  
  2563 00000D4F A1[3700]                 mov ax, [PC]
  2564 00000D52 8B1E[5200]               mov bx, [LabelMaxIx]
  2565 00000D56 D1E3                     shl bx, 1
  2566 00000D58 8987A37A                 mov [LabelAddr+bx], ax
  2567                                  
  2568                                  ;-42 }
  2569                                  
  2570                                  
  2571                                  ;-43 int searchLabel() {
  2572                                  
  2573 00000D5C C3                       ret
  2574                                  ; ENDP
  2575 00000D5D 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2576 00000D66 206C6162656C00     
  2577                                  
  2578                                  searchLabel:  ; *** PROC ***
  2579                                  
  2580                                  ;-44   int LIx; char *p; int j;
  2581                                  
  2582                                  
  2583                                  ;-45   p = &LabelNames;
  2584                                  
  2585                                  ;Function : searchLabel, Number of local variables: 3
  2586                                  ;   # type sign width line used address name   list of local variables
  2587                                  ;  200 var sign word    44 NULL bp-2    LIx
  2588                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2589                                  ;  202 var sign word    44 NULL bp-6    j;
  2590 00000D6D C8060000                 ENTER  6,0
  2591 00000D71 B8BB76                   mov ax, LabelNames
  2592 00000D74 8946FC                   mov word [bp-4], ax
  2593                                  
  2594                                  ;-46   LIx=1;
  2595                                  
  2596 00000D77 66B801000000             mov eax, 1
  2597 00000D7D 8946FE                   mov word [bp-2], ax
  2598                                  
  2599                                  ;-47   while (LIx <= LabelMaxIx) {
  2600                                  
  2601                                  @@searchLabel89:
  2602 00000D80 8B46FE                   mov ax, [bp-2]
  2603 00000D83 3B06[5200]               cmp ax, [LabelMaxIx]
  2604 00000D87 0F8F3700                 jg  @@searchLabel90
  2605                                  
  2606                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2607                                  
  2608 00000D8B 8D063075                 lea  ax, [Symbol]
  2609 00000D8F 50                       push ax
  2610 00000D90 FF76FC                   push word [bp-4]
  2611 00000D93 E8A712                   call eqstr
  2612 00000D96 83C404                   add  sp, 4
  2613 00000D99 08C0                     or  al, al
  2614 00000D9B 0F840600                 je @@searchLabel91
  2615 00000D9F 8B46FE                   mov ax, [bp-2]
  2616 00000DA2 E92600                   jmp @@retn
  2617                                  
  2618                                  ;-49     j=strlen(p);
  2619                                  
  2620                                  @@searchLabel91:
  2621 00000DA5 FF76FC                   push word [bp-4]
  2622 00000DA8 E8FB11                   call strlen
  2623 00000DAB 83C402                   add  sp, 2
  2624 00000DAE 8946FA                   mov word [bp-6], ax
  2625                                  
  2626                                  ;-50     p=p+j; p++; LIx++;
  2627                                  
  2628 00000DB1 8B46FC                   mov ax, [bp-4]
  2629 00000DB4 0346FA                   add ax, [bp-6]
  2630 00000DB7 8946FC                   mov word [bp-4], ax
  2631 00000DBA FF46FC                   inc  word [bp-4]
  2632 00000DBD FF46FE                   inc  word [bp-2]
  2633                                  
  2634                                  ;-51   }
  2635                                  
  2636                                  
  2637                                  ;-52   return 0;
  2638                                  
  2639 00000DC0 EBBE                     jmp @@searchLabel89
  2640                                  @@searchLabel90:
  2641 00000DC2 66B800000000             mov eax, 0
  2642 00000DC8 E90000                   jmp @@retn
  2643                                  
  2644                                  ;-53 }
  2645                                  
  2646                                  
  2647                                  ;-54 int getVariable() { char c;
  2648                                  
  2649 00000DCB C9                      @@retn: LEAVE
  2650 00000DCC C3                       ret
  2651                                  ; ENDP
  2652                                  
  2653                                  getVariable:  ; *** PROC ***
  2654                                  
  2655                                  ;-55   storeLabel();
  2656                                  
  2657                                  ;Function : getVariable, Number of local variables: 1
  2658                                  ;   # type sign width line used address name   list of local variables
  2659                                  ;  200 var sign byte    54 NULL bp-2    c;
  2660 00000DCD C8020000                 ENTER  2,0
  2661 00000DD1 E84FFF                   call storeLabel
  2662                                  
  2663                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2664                                  
  2665 00000DD4 E8AEFE                   call getTokeType
  2666 00000DD7 A0[3C00]                 mov al, [TokeType]
  2667 00000DDA 3C03                     cmp al, 3
  2668 00000DDC 0F85CC00                 jne @@getVariable92
  2669                                  
  2670                                  ;-57     lookCode();
  2671                                  
  2672 00000DE0 E82201                   call lookCode
  2673                                  
  2674                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2675                                  
  2676 00000DE3 A0[3E00]                 mov al, [CodeType]
  2677 00000DE6 3CC8                     cmp al, 200
  2678 00000DE8 0F8D0900                 jge @@getVariable93
  2679 00000DEC 68[B70E]                 push getVariable_0
  2680 00000DEF E8F50C                   call errorexit
  2681 00000DF2 83C402                   add  sp, 2
  2682                                  
  2683                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2684                                  
  2685                                  @@getVariable93:
  2686 00000DF5 A0[3E00]                 mov al, [CodeType]
  2687 00000DF8 3CCF                     cmp al, 207
  2688 00000DFA 0F8E0900                 jle @@getVariable94
  2689 00000DFE 68[CF0E]                 push getVariable_1
  2690 00000E01 E8E30C                   call errorexit
  2691 00000E04 83C402                   add  sp, 2
  2692                                  
  2693                                  ;-60     if (CodeType== 200) {// DB
  2694                                  
  2695                                  @@getVariable94:
  2696 00000E07 A0[3E00]                 mov al, [CodeType]
  2697 00000E0A 3CC8                     cmp al, 200
  2698 00000E0C 0F856A00                 jne @@getVariable95
  2699                                  
  2700                                  ;-61       do { getTokeType();
  2701                                  
  2702                                  @@getVariable96:
  2703 00000E10 E872FE                   call getTokeType
  2704                                  
  2705                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2706                                  
  2707 00000E13 A0[3C00]                 mov al, [TokeType]
  2708 00000E16 3C01                     cmp al, 1
  2709 00000E18 0F850D00                 jne @@getVariable97
  2710 00000E1C FF36[2600]               push word [SymbolInt]
  2711 00000E20 E897FB                   call genCode8
  2712 00000E23 83C402                   add  sp, 2
  2713                                  
  2714                                  ;-63         else {
  2715                                  
  2716 00000E26 E94100                   jmp @@getVariable98
  2717                                  @@getVariable97:
  2718                                  
  2719                                  ;-64           skipBlank();
  2720                                  
  2721 00000E29 E8FA02                   call skipBlank
  2722                                  
  2723                                  ;-65           if (isToken('"')) {
  2724                                  
  2725 00000E2C 6A22                     push 34
  2726 00000E2E E8D101                   call isToken
  2727 00000E31 83C402                   add  sp, 2
  2728 00000E34 08C0                     or  al, al
  2729 00000E36 0F843000                 je @@getVariable99
  2730                                  
  2731                                  ;-66             do { c= *InputPtr;
  2732                                  
  2733                                  @@getVariable100:
  2734 00000E3A 8B1E[2800]               mov bx, [InputPtr]
  2735 00000E3E 8A07                     mov al, [bx]
  2736 00000E40 B400                     mov ah, 0
  2737 00000E42 8846FE                   mov byte [bp-2], al
  2738                                  
  2739                                  ;-67               genCode8(c);
  2740                                  
  2741 00000E45 8A46FE                   mov al, byte [bp-2]
  2742 00000E48 B400                     mov ah, 0
  2743 00000E4A 50                       push ax
  2744 00000E4B E86CFB                   call genCode8
  2745 00000E4E 83C402                   add  sp, 2
  2746                                  
  2747                                  ;-68               InputPtr++;
  2748                                  
  2749 00000E51 FF06[2800]               inc  word [InputPtr]
  2750                                  
  2751                                  ;-69             } while (*InputPtr != '"' );
  2752                                  
  2753 00000E55 8B1E[2800]               mov bx, [InputPtr]
  2754 00000E59 8A07                     mov al, [bx]
  2755 00000E5B B400                     mov ah, 0
  2756 00000E5D 83F822                   cmp ax, 34
  2757 00000E60 0F840200                 je  @@getVariable101
  2758 00000E64 EBD4                     jmp @@getVariable100
  2759                                  @@getVariable101:
  2760                                  
  2761                                  ;-70             InputPtr++;
  2762                                  
  2763 00000E66 FF06[2800]               inc  word [InputPtr]
  2764                                  
  2765                                  ;-71           }
  2766                                  
  2767                                  
  2768                                  ;-72         }
  2769                                  
  2770                                  @@getVariable99:
  2771                                  
  2772                                  ;-73       } while (isToken(','));
  2773                                  
  2774                                  @@getVariable98:
  2775 00000E6A 6A2C                     push 44
  2776 00000E6C E89301                   call isToken
  2777 00000E6F 83C402                   add  sp, 2
  2778 00000E72 08C0                     or  al, al
  2779 00000E74 0F840200                 je @@getVariable102
  2780 00000E78 EB96                     jmp @@getVariable96
  2781                                  @@getVariable102:
  2782                                  
  2783                                  ;-74     }
  2784                                  
  2785                                  
  2786                                  ;-75     if (CodeType== 201) {// DW
  2787                                  
  2788                                  @@getVariable95:
  2789 00000E7A A0[3E00]                 mov al, [CodeType]
  2790 00000E7D 3CC9                     cmp al, 201
  2791 00000E7F 0F852600                 jne @@getVariable103
  2792                                  
  2793                                  ;-76       do { getTokeType();
  2794                                  
  2795                                  @@getVariable104:
  2796 00000E83 E8FFFD                   call getTokeType
  2797                                  
  2798                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2799                                  
  2800 00000E86 A0[3C00]                 mov al, [TokeType]
  2801 00000E89 3C01                     cmp al, 1
  2802 00000E8B 0F850A00                 jne @@getVariable105
  2803 00000E8F FF36[2600]               push word [SymbolInt]
  2804 00000E93 E856FB                   call genCode16
  2805 00000E96 83C402                   add  sp, 2
  2806                                  
  2807                                  ;-78       } while (isToken(','));
  2808                                  
  2809                                  @@getVariable105:
  2810 00000E99 6A2C                     push 44
  2811 00000E9B E86401                   call isToken
  2812 00000E9E 83C402                   add  sp, 2
  2813 00000EA1 08C0                     or  al, al
  2814 00000EA3 0F840200                 je @@getVariable106
  2815 00000EA7 EBDA                     jmp @@getVariable104
  2816                                  @@getVariable106:
  2817                                  
  2818                                  ;-79     }
  2819                                  
  2820                                  
  2821                                  ;-80   }
  2822                                  
  2823                                  @@getVariable103:
  2824                                  
  2825                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2826                                  
  2827 00000EA9 E90900                   jmp @@getVariable107
  2828                                  @@getVariable92:
  2829 00000EAC 68[E70E]                 push getVariable_2
  2830 00000EAF E8350C                   call errorexit
  2831 00000EB2 83C402                   add  sp, 2
  2832                                  
  2833                                  ;-82 }
  2834                                  
  2835                                  @@getVariable107:
  2836                                  
  2837                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2838 00000EB5 C9                       LEAVE
  2839 00000EB6 C3                       ret
  2840                                  ; ENDP
  2841 00000EB7 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2842 00000EC0 422C572C4420657870-
  2843 00000EC9 656374656400       
  2844 00000ECF 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2845 00000ED8 422C572C4420657870-
  2846 00000EE1 656374656400       
  2847 00000EE7 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2848 00000EF0 6F7220524553422C57-
  2849 00000EF9 2C4420657870656374-
  2850 00000F02 656400             
  2851                                  
  2852                                  lookCode:  ; *** PROC ***
  2853                                  
  2854                                  ;-84   CodeType=0;
  2855                                  
  2856 00000F05 66B800000000             mov eax, 0
  2857 00000F0B A2[3E00]                 mov byte [CodeType], al
  2858                                  
  2859                                  ;-85   OpCodePtr= &I_START;
  2860                                  
  2861 00000F0E B8[5C00]                 mov ax, I_START
  2862 00000F11 A3[4D00]                 mov word [OpCodePtr], ax
  2863                                  
  2864                                  ;-86   OpCodePtr++;
  2865                                  
  2866 00000F14 FF06[4D00]               inc  word [OpCodePtr]
  2867                                  
  2868                                  ;-87   do  {
  2869                                  
  2870                                  @@lookCode108:
  2871                                  
  2872                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2873                                  
  2874 00000F18 FF36[4D00]               push word [OpCodePtr]
  2875 00000F1C 8D064F75                 lea  ax, [SymbolUpper]
  2876 00000F20 50                       push ax
  2877 00000F21 E81911                   call eqstr
  2878 00000F24 83C404                   add  sp, 4
  2879 00000F27 08C0                     or  al, al
  2880 00000F29 0F842700                 je @@lookCode109
  2881                                  
  2882                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2883                                  
  2884                                  @@lookCode110:
  2885 00000F2D 8B1E[4D00]               mov bx, [OpCodePtr]
  2886 00000F31 8A07                     mov al, [bx]
  2887 00000F33 B400                     mov ah, 0
  2888 00000F35 83F800                   cmp ax, 0
  2889 00000F38 0F840600                 je  @@lookCode111
  2890 00000F3C FF06[4D00]               inc  word [OpCodePtr]
  2891                                  
  2892                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2893                                  
  2894 00000F40 EBEB                     jmp @@lookCode110
  2895                                  @@lookCode111:
  2896 00000F42 FF06[4D00]               inc  word [OpCodePtr]
  2897 00000F46 8B1E[4D00]               mov bx, [OpCodePtr]
  2898 00000F4A 8A07                     mov al, [bx]
  2899 00000F4C B400                     mov ah, 0
  2900 00000F4E A2[3E00]                 mov byte [CodeType], al
  2901                                  
  2902                                  ;-91       return;
  2903                                  
  2904 00000F51 E92A00                   jmp @@retn
  2905                                  
  2906                                  ;-92     }
  2907                                  
  2908                                  
  2909                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2910                                  
  2911                                  @@lookCode109:
  2912                                  @@lookCode112:
  2913 00000F54 8B1E[4D00]               mov bx, [OpCodePtr]
  2914 00000F58 8A07                     mov al, [bx]
  2915 00000F5A B400                     mov ah, 0
  2916 00000F5C 3DF100                   cmp ax, 241
  2917 00000F5F 0F840600                 je  @@lookCode113
  2918 00000F63 FF06[4D00]               inc  word [OpCodePtr]
  2919                                  
  2920                                  ;-94   OpCodePtr++;
  2921                                  
  2922 00000F67 EBEB                     jmp @@lookCode112
  2923                                  @@lookCode113:
  2924 00000F69 FF06[4D00]               inc  word [OpCodePtr]
  2925                                  
  2926                                  ;-95   } while(*OpCodePtr!=0);
  2927                                  
  2928 00000F6D 8B1E[4D00]               mov bx, [OpCodePtr]
  2929 00000F71 8A07                     mov al, [bx]
  2930 00000F73 B400                     mov ah, 0
  2931 00000F75 83F800                   cmp ax, 0
  2932 00000F78 0F840200                 je  @@lookCode114
  2933 00000F7C EB9A                     jmp @@lookCode108
  2934                                  @@lookCode114:
  2935                                  
  2936                                  ;-96 }
  2937                                  
  2938                                  
  2939                                  ;-97 int getCodeSize() {
  2940                                  
  2941                                  @@retn:
  2942 00000F7E C3                       ret
  2943                                  ; ENDP
  2944                                  
  2945                                  getCodeSize:  ; *** PROC ***
  2946                                  
  2947                                  ;-98   if (TokeType ==ALNUME) {
  2948                                  
  2949 00000F7F A0[3C00]                 mov al, [TokeType]
  2950 00000F82 3C03                     cmp al, 3
  2951 00000F84 0F856000                 jne @@getCodeSize115
  2952                                  
  2953                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2954                                  
  2955 00000F88 68[F20F]                 push getCodeSize_0
  2956 00000F8B 8D064F75                 lea  ax, [SymbolUpper]
  2957 00000F8F 50                       push ax
  2958 00000F90 E8AA10                   call eqstr
  2959 00000F93 83C404                   add  sp, 4
  2960 00000F96 08C0                     or  al, al
  2961 00000F98 0F840C00                 je @@getCodeSize116
  2962 00000F9C E8E6FC                   call getTokeType
  2963 00000F9F 66B801000000             mov eax, 1
  2964 00000FA5 E94900                   jmp @@retn
  2965                                  
  2966                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2967                                  
  2968                                  @@getCodeSize116:
  2969 00000FA8 68[F70F]                 push getCodeSize_1
  2970 00000FAB 8D064F75                 lea  ax, [SymbolUpper]
  2971 00000FAF 50                       push ax
  2972 00000FB0 E88A10                   call eqstr
  2973 00000FB3 83C404                   add  sp, 4
  2974 00000FB6 08C0                     or  al, al
  2975 00000FB8 0F840C00                 je @@getCodeSize117
  2976 00000FBC E8C6FC                   call getTokeType
  2977 00000FBF 66B802000000             mov eax, 2
  2978 00000FC5 E92900                   jmp @@retn
  2979                                  
  2980                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2981                                  
  2982                                  @@getCodeSize117:
  2983 00000FC8 68[FC0F]                 push getCodeSize_2
  2984 00000FCB 8D064F75                 lea  ax, [SymbolUpper]
  2985 00000FCF 50                       push ax
  2986 00000FD0 E86A10                   call eqstr
  2987 00000FD3 83C404                   add  sp, 4
  2988 00000FD6 08C0                     or  al, al
  2989 00000FD8 0F840C00                 je @@getCodeSize118
  2990 00000FDC E8A6FC                   call getTokeType
  2991 00000FDF 66B803000000             mov eax, 3
  2992 00000FE5 E90900                   jmp @@retn
  2993                                  
  2994                                  ;-102   } return 0;
  2995                                  
  2996                                  @@getCodeSize118:
  2997                                  @@getCodeSize115:
  2998 00000FE8 66B800000000             mov eax, 0
  2999 00000FEE E90000                   jmp @@retn
  3000                                  
  3001                                  ;-103 }
  3002                                  
  3003                                  
  3004                                  ;-104 int isToken(char c) {
  3005                                  
  3006                                  @@retn:
  3007 00000FF1 C3                       ret
  3008                                  ; ENDP
  3009 00000FF2 4259544500              getCodeSize_0 db "BYTE",0
  3010 00000FF7 574F524400              getCodeSize_1 db "WORD",0
  3011 00000FFC 44574F524400            getCodeSize_2 db "DWORD",0
  3012                                  
  3013                                  isToken:  ; *** PROC ***
  3014                                  
  3015                                  ;-105   skipBlank();
  3016                                  
  3017                                  ;Function : isToken, Number of local variables: 1
  3018                                  ;   # type sign width line used address name   list of local variables
  3019                                  ;  200 var sign byte   104 NULL bp+4    c;
  3020 00001002 C8000000                 ENTER  0,0
  3021 00001006 E81D01                   call skipBlank
  3022                                  
  3023                                  ;-106   if (*InputPtr == c) {
  3024                                  
  3025 00001009 8B1E[2800]               mov bx, [InputPtr]
  3026 0000100D 8A07                     mov al, [bx]
  3027 0000100F B400                     mov ah, 0
  3028 00001011 3A4604                   cmp al, [bp+4]
  3029 00001014 0F850D00                 jne @@isToken119
  3030                                  
  3031                                  ;-107     InputPtr++; return 1;} return 0;
  3032                                  
  3033 00001018 FF06[2800]               inc  word [InputPtr]
  3034 0000101C 66B801000000             mov eax, 1
  3035 00001022 E90900                   jmp @@retn
  3036                                  @@isToken119:
  3037 00001025 66B800000000             mov eax, 0
  3038 0000102B E90000                   jmp @@retn
  3039                                  
  3040                                  ;-108 }
  3041                                  
  3042                                  
  3043                                  ;-109 int skipRest() {
  3044                                  
  3045 0000102E C9                      @@retn: LEAVE
  3046 0000102F C3                       ret
  3047                                  ; ENDP
  3048                                  
  3049                                  skipRest:  ; *** PROC ***
  3050                                  
  3051                                  ;-110   getTokeType(); if(TokeType!=0)error1("extra char ignored");
  3052                                  
  3053 00001030 E852FC                   call getTokeType
  3054 00001033 A0[3C00]                 mov al, [TokeType]
  3055 00001036 3C00                     cmp al, 0
  3056 00001038 0F840900                 je  @@skipRest120
  3057 0000103C 68[4610]                 push skipRest_0
  3058 0000103F E87409                   call error1
  3059 00001042 83C402                   add  sp, 2
  3060                                  
  3061                                  ;-111 }
  3062                                  
  3063                                  @@skipRest120:
  3064 00001045 C3                       ret
  3065                                  ; ENDP
  3066 00001046 657874726120636861-     skipRest_0 db "extra char ignored",0
  3067 0000104F 722069676E6F726564-
  3068 00001058 00                 
  3069                                  ;Back to main program: AS.C
  3070                                  
  3071                                  ;-219 #include "HELPER.C"
  3072                                  
  3073                                  ;Use include file: HELPER.C
  3074                                  
  3075                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3076                                  
  3077                                  
  3078                                  getLine:  ; *** PROC ***
  3079                                  
  3080                                  ;-2   InputPtr= &InputBuf;
  3081                                  
  3082 00001059 B86E75                   mov ax, InputBuf
  3083 0000105C A3[2800]                 mov word [InputPtr], ax
  3084                                  
  3085                                  ;-3   *InputPtr=0;//if last line is empty
  3086                                  
  3087 0000105F 66B800000000             mov eax, 0
  3088 00001065 8B1E[2800]               mov  bx, [InputPtr]
  3089 00001069 8807                     mov  [bx], al
  3090                                  
  3091                                  ;-4   do {
  3092                                  
  3093                                  @@getLine121:
  3094                                  
  3095                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3096                                  
  3097 0000106B 6A01                     push 1
  3098 0000106D FF36[2A00]               push word [asm_fd]
  3099 00001071 8D06[3600]               lea  ax, [DOS_ByteRead]
  3100 00001075 50                       push ax
  3101 00001076 E85F10                   call readRL
  3102 00001079 83C406                   add  sp, 6
  3103 0000107C A3[3400]                 mov word [DOS_NoBytes], ax
  3104                                  
  3105                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  3106                                  
  3107 0000107F A1[3000]                 mov ax, [DOS_ERR]
  3108 00001082 08C0                     or  al, al
  3109 00001084 0F840900                 je @@getLine122
  3110 00001088 68[D010]                 push getLine_0
  3111 0000108B E8590A                   call errorexit
  3112 0000108E 83C402                   add  sp, 2
  3113                                  
  3114                                  ;-7     if (DOS_NoBytes == 0) return;
  3115                                  
  3116                                  @@getLine122:
  3117 00001091 A1[3400]                 mov ax, [DOS_NoBytes]
  3118 00001094 83F800                   cmp ax, 0
  3119 00001097 0F850300                 jne @@getLine123
  3120 0000109B E93100                   jmp @@retn
  3121                                  
  3122                                  ;-8     *InputPtr = DOS_ByteRead;
  3123                                  
  3124                                  @@getLine123:
  3125 0000109E A0[3600]                 mov al, [DOS_ByteRead]
  3126 000010A1 8B1E[2800]               mov  bx, [InputPtr]
  3127 000010A5 8807                     mov  [bx], al
  3128                                  
  3129                                  ;-9     InputPtr++;
  3130                                  
  3131 000010A7 FF06[2800]               inc  word [InputPtr]
  3132                                  
  3133                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  3134                                  
  3135 000010AB A0[3600]                 mov al, byte [DOS_ByteRead]
  3136 000010AE B400                     mov ah, 0
  3137 000010B0 50                       push ax
  3138 000010B1 E82B00                   call ifEOL
  3139 000010B4 83C402                   add  sp, 2
  3140 000010B7 3C00                     cmp al, 0
  3141 000010B9 0F850200                 jne @@getLine124
  3142 000010BD EBAC                     jmp @@getLine121
  3143                                  @@getLine124:
  3144                                  
  3145                                  ;-11   InputPtr--;
  3146                                  
  3147 000010BF FF0E[2800]               dec  word [InputPtr]
  3148                                  
  3149                                  ;-12   *InputPtr=0;
  3150                                  
  3151 000010C3 66B800000000             mov eax, 0
  3152 000010C9 8B1E[2800]               mov  bx, [InputPtr]
  3153 000010CD 8807                     mov  [bx], al
  3154                                  
  3155                                  ;-13 }
  3156                                  
  3157                                  
  3158                                  ;-14 int ifEOL(char c) {
  3159                                  
  3160                                  @@retn:
  3161 000010CF C3                       ret
  3162                                  ; ENDP
  3163 000010D0 52656164696E672053-     getLine_0 db "Reading Source",0
  3164 000010D9 6F7572636500       
  3165                                  
  3166                                  ifEOL:  ; *** PROC ***
  3167                                  
  3168                                  ;-15   if (c == 10) return 1;
  3169                                  
  3170                                  ;Function : ifEOL, Number of local variables: 1
  3171                                  ;   # type sign width line used address name   list of local variables
  3172                                  ;  200 var sign byte    14 NULL bp+4    c;
  3173 000010DF C8000000                 ENTER  0,0
  3174 000010E3 8A4604                   mov al, [bp+4]
  3175 000010E6 3C0A                     cmp al, 10
  3176 000010E8 0F850900                 jne @@ifEOL125
  3177 000010EC 66B801000000             mov eax, 1
  3178 000010F2 E92F00                   jmp @@retn
  3179                                  
  3180                                  ;-16   if (c == 13) {
  3181                                  
  3182                                  @@ifEOL125:
  3183 000010F5 8A4604                   mov al, [bp+4]
  3184 000010F8 3C0D                     cmp al, 13
  3185 000010FA 0F851D00                 jne @@ifEOL126
  3186                                  
  3187                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3188                                  
  3189 000010FE 6A01                     push 1
  3190 00001100 FF36[2A00]               push word [asm_fd]
  3191 00001104 8D06[3600]               lea  ax, [DOS_ByteRead]
  3192 00001108 50                       push ax
  3193 00001109 E8CC0F                   call readRL
  3194 0000110C 83C406                   add  sp, 6
  3195 0000110F A3[3400]                 mov word [DOS_NoBytes], ax
  3196                                  
  3197                                  ;-18     return 1;}
  3198                                  
  3199 00001112 66B801000000             mov eax, 1
  3200 00001118 E90900                   jmp @@retn
  3201                                  
  3202                                  ;-19   return 0;
  3203                                  
  3204                                  @@ifEOL126:
  3205 0000111B 66B800000000             mov eax, 0
  3206 00001121 E90000                   jmp @@retn
  3207                                  
  3208                                  ;-20 }
  3209                                  
  3210                                  
  3211                                  ;-21 int skipBlank() {
  3212                                  
  3213 00001124 C9                      @@retn: LEAVE
  3214 00001125 C3                       ret
  3215                                  ; ENDP
  3216                                  
  3217                                  skipBlank:  ; *** PROC ***
  3218                                  
  3219                                  ;-22   skipblank1:
  3220                                  
  3221                                  @@skipblank1:
  3222                                  
  3223                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3224                                  
  3225 00001126 8B1E[2800]               mov bx, [InputPtr]
  3226 0000112A 8A07                     mov al, [bx]
  3227 0000112C B400                     mov ah, 0
  3228 0000112E 83F820                   cmp ax, 32
  3229 00001131 0F850600                 jne @@skipBlank127
  3230 00001135 FF06[2800]               inc  word [InputPtr]
  3231 00001139 EBEB                     jmp @@skipblank1
  3232                                  
  3233                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3234                                  
  3235                                  @@skipBlank127:
  3236 0000113B 8B1E[2800]               mov bx, [InputPtr]
  3237 0000113F 8A07                     mov al, [bx]
  3238 00001141 B400                     mov ah, 0
  3239 00001143 83F809                   cmp ax, 9
  3240 00001146 0F850600                 jne @@skipBlank128
  3241 0000114A FF06[2800]               inc  word [InputPtr]
  3242 0000114E EBD6                     jmp @@skipblank1
  3243                                  
  3244                                  ;-25 }
  3245                                  
  3246                                  @@skipBlank128:
  3247                                  
  3248                                  ;-26 int letterE(char c) {
  3249                                  
  3250 00001150 C3                       ret
  3251                                  ; ENDP
  3252                                  
  3253                                  letterE:  ; *** PROC ***
  3254                                  
  3255                                  ;-27   if (c=='_') return 1;
  3256                                  
  3257                                  ;Function : letterE, Number of local variables: 1
  3258                                  ;   # type sign width line used address name   list of local variables
  3259                                  ;  200 var sign byte    26 NULL bp+4    c;
  3260 00001151 C8000000                 ENTER  0,0
  3261 00001155 8A4604                   mov al, [bp+4]
  3262 00001158 3C5F                     cmp al, 95
  3263 0000115A 0F850900                 jne @@letterE129
  3264 0000115E 66B801000000             mov eax, 1
  3265 00001164 E97E00                   jmp @@retn
  3266                                  
  3267                                  ;-28   if (c=='.') return 1;
  3268                                  
  3269                                  @@letterE129:
  3270 00001167 8A4604                   mov al, [bp+4]
  3271 0000116A 3C2E                     cmp al, 46
  3272 0000116C 0F850900                 jne @@letterE130
  3273 00001170 66B801000000             mov eax, 1
  3274 00001176 E96C00                   jmp @@retn
  3275                                  
  3276                                  ;-29   if (c=='?') return 1;
  3277                                  
  3278                                  @@letterE130:
  3279 00001179 8A4604                   mov al, [bp+4]
  3280 0000117C 3C3F                     cmp al, 63
  3281 0000117E 0F850900                 jne @@letterE131
  3282 00001182 66B801000000             mov eax, 1
  3283 00001188 E95A00                   jmp @@retn
  3284                                  
  3285                                  ;-30   if (c=='$') return 1;
  3286                                  
  3287                                  @@letterE131:
  3288 0000118B 8A4604                   mov al, [bp+4]
  3289 0000118E 3C24                     cmp al, 36
  3290 00001190 0F850900                 jne @@letterE132
  3291 00001194 66B801000000             mov eax, 1
  3292 0000119A E94800                   jmp @@retn
  3293                                  
  3294                                  ;-31   if (c> 'z') return 0;
  3295                                  
  3296                                  @@letterE132:
  3297 0000119D 8A4604                   mov al, [bp+4]
  3298 000011A0 3C7A                     cmp al, 122
  3299 000011A2 0F8E0900                 jle @@letterE133
  3300 000011A6 66B800000000             mov eax, 0
  3301 000011AC E93600                   jmp @@retn
  3302                                  
  3303                                  ;-32   if (c< '@') return 0; // at included
  3304                                  
  3305                                  @@letterE133:
  3306 000011AF 8A4604                   mov al, [bp+4]
  3307 000011B2 3C40                     cmp al, 64
  3308 000011B4 0F8D0900                 jge @@letterE134
  3309 000011B8 66B800000000             mov eax, 0
  3310 000011BE E92400                   jmp @@retn
  3311                                  
  3312                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3313                                  
  3314                                  @@letterE134:
  3315 000011C1 8A4604                   mov al, [bp+4]
  3316 000011C4 3C5A                     cmp al, 90
  3317 000011C6 0F8E1200                 jle @@letterE135
  3318 000011CA 8A4604                   mov al, [bp+4]
  3319 000011CD 3C61                     cmp al, 97
  3320 000011CF 0F8D0900                 jge @@letterE136
  3321 000011D3 66B800000000             mov eax, 0
  3322 000011D9 E90900                   jmp @@retn
  3323                                  @@letterE136:
  3324                                  
  3325                                  ;-34   return 1;
  3326                                  
  3327                                  @@letterE135:
  3328 000011DC 66B801000000             mov eax, 1
  3329 000011E2 E90000                   jmp @@retn
  3330                                  
  3331                                  ;-35 }
  3332                                  
  3333                                  
  3334                                  ;-36 int alnumE(char c) {
  3335                                  
  3336 000011E5 C9                      @@retn: LEAVE
  3337 000011E6 C3                       ret
  3338                                  ; ENDP
  3339                                  
  3340                                  alnumE:  ; *** PROC ***
  3341                                  
  3342                                  ;-37   if (digit(c)) return 1;
  3343                                  
  3344                                  ;Function : alnumE, Number of local variables: 1
  3345                                  ;   # type sign width line used address name   list of local variables
  3346                                  ;  200 var sign byte    36 NULL bp+4    c;
  3347 000011E7 C8000000                 ENTER  0,0
  3348 000011EB 8A4604                   mov al, byte [bp+4]
  3349 000011EE B400                     mov ah, 0
  3350 000011F0 50                       push ax
  3351 000011F1 E8160E                   call digit
  3352 000011F4 83C402                   add  sp, 2
  3353 000011F7 08C0                     or  al, al
  3354 000011F9 0F840900                 je @@alnumE137
  3355 000011FD 66B801000000             mov eax, 1
  3356 00001203 E92400                   jmp @@retn
  3357                                  
  3358                                  ;-38   if (letterE(c)) return 1;
  3359                                  
  3360                                  @@alnumE137:
  3361 00001206 8A4604                   mov al, byte [bp+4]
  3362 00001209 B400                     mov ah, 0
  3363 0000120B 50                       push ax
  3364 0000120C E842FF                   call letterE
  3365 0000120F 83C402                   add  sp, 2
  3366 00001212 08C0                     or  al, al
  3367 00001214 0F840900                 je @@alnumE138
  3368 00001218 66B801000000             mov eax, 1
  3369 0000121E E90900                   jmp @@retn
  3370                                  
  3371                                  ;-39   return 0;
  3372                                  
  3373                                  @@alnumE138:
  3374 00001221 66B800000000             mov eax, 0
  3375 00001227 E90000                   jmp @@retn
  3376                                  
  3377                                  ;-40 }
  3378                                  
  3379                                  
  3380                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3381                                  
  3382 0000122A C9                      @@retn: LEAVE
  3383 0000122B C3                       ret
  3384                                  ; ENDP
  3385                                  
  3386                                  getDigit:  ; *** PROC ***
  3387                                  
  3388                                  ;-42   unsigned int CastInt;
  3389                                  
  3390                                  
  3391                                  ;-43   SymbolInt=0;
  3392                                  
  3393                                  ;Function : getDigit, Number of local variables: 2
  3394                                  ;   # type sign width line used address name   list of local variables
  3395                                  ;  200 var unsg byte    41 NULL bp+4    c
  3396                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3397 0000122C C8020000                 ENTER  2,0
  3398 00001230 66B800000000             mov eax, 0
  3399 00001236 A3[2600]                 mov word [SymbolInt], ax
  3400                                  
  3401                                  ;-44   do {
  3402                                  
  3403                                  @@getDigit139:
  3404                                  
  3405                                  ;-45     c-='0';
  3406                                  
  3407 00001239 806E0430                 sub  byte [bp+4], 48
  3408                                  
  3409                                  ;-46     SymbolInt=SymbolInt*10;
  3410                                  
  3411 0000123D A1[2600]                 mov ax, [SymbolInt]
  3412 00001240 66BB0A000000             mov ebx, 10
  3413 00001246 66F7E3                   mul ebx
  3414 00001249 A3[2600]                 mov word [SymbolInt], ax
  3415                                  
  3416                                  ;-47     ax=0; CastInt=c; //cast b2w
  3417                                  
  3418 0000124C B80000                   mov  ax, 0
  3419 0000124F 8A4604                   mov al, [bp+4]
  3420 00001252 8946FE                   mov word [bp-2], ax
  3421                                  
  3422                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3423                                  
  3424 00001255 A1[2600]                 mov ax, [SymbolInt]
  3425 00001258 0346FE                   add ax, [bp-2]
  3426 0000125B A3[2600]                 mov word [SymbolInt], ax
  3427                                  
  3428                                  ;-49     InputPtr++;
  3429                                  
  3430 0000125E FF06[2800]               inc  word [InputPtr]
  3431                                  
  3432                                  ;-50     c = *InputPtr;
  3433                                  
  3434 00001262 8B1E[2800]               mov bx, [InputPtr]
  3435 00001266 8A07                     mov al, [bx]
  3436 00001268 B400                     mov ah, 0
  3437 0000126A 884604                   mov byte [bp+4], al
  3438                                  
  3439                                  ;-51   } while(digit(c));
  3440                                  
  3441 0000126D 8A4604                   mov al, byte [bp+4]
  3442 00001270 B400                     mov ah, 0
  3443 00001272 50                       push ax
  3444 00001273 E8940D                   call digit
  3445 00001276 83C402                   add  sp, 2
  3446 00001279 08C0                     or  al, al
  3447 0000127B 0F840200                 je @@getDigit140
  3448 0000127F EBB8                     jmp @@getDigit139
  3449                                  @@getDigit140:
  3450                                  
  3451                                  ;-52 }
  3452                                  
  3453                                  
  3454                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3455 00001281 C9                       LEAVE
  3456 00001282 C3                       ret
  3457                                  ; ENDP
  3458                                  
  3459                                  getName:  ; *** PROC ***
  3460                                  
  3461                                  ;-54   char *p;
  3462                                  
  3463                                  
  3464                                  ;-55   p = &Symbol;
  3465                                  
  3466                                  ;Function : getName, Number of local variables: 2
  3467                                  ;   # type sign width line used address name   list of local variables
  3468                                  ;  200 var unsg byte    53 NULL bp+4    c
  3469                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3470 00001283 C8020000                 ENTER  2,0
  3471 00001287 B83075                   mov ax, Symbol
  3472 0000128A 8946FE                   mov word [bp-2], ax
  3473                                  
  3474                                  ;-56   *p = c;
  3475                                  
  3476 0000128D 8A4604                   mov al, [bp+4]
  3477 00001290 8B5EFE                   mov  bx, [bp-2]
  3478 00001293 8807                     mov  [bx], al
  3479                                  
  3480                                  ;-57   p++;
  3481                                  
  3482 00001295 FF46FE                   inc  word [bp-2]
  3483                                  
  3484                                  ;-58   while (alnumE(c)) {
  3485                                  
  3486                                  @@getName141:
  3487 00001298 8A4604                   mov al, byte [bp+4]
  3488 0000129B B400                     mov ah, 0
  3489 0000129D 50                       push ax
  3490 0000129E E846FF                   call alnumE
  3491 000012A1 83C402                   add  sp, 2
  3492 000012A4 08C0                     or  al, al
  3493 000012A6 0F841C00                 je @@getName142
  3494                                  
  3495                                  ;-59     InputPtr++;
  3496                                  
  3497 000012AA FF06[2800]               inc  word [InputPtr]
  3498                                  
  3499                                  ;-60     c = *InputPtr;
  3500                                  
  3501 000012AE 8B1E[2800]               mov bx, [InputPtr]
  3502 000012B2 8A07                     mov al, [bx]
  3503 000012B4 B400                     mov ah, 0
  3504 000012B6 884604                   mov byte [bp+4], al
  3505                                  
  3506                                  ;-61     *p = c;
  3507                                  
  3508 000012B9 8A4604                   mov al, [bp+4]
  3509 000012BC 8B5EFE                   mov  bx, [bp-2]
  3510 000012BF 8807                     mov  [bx], al
  3511                                  
  3512                                  ;-62     p++;
  3513                                  
  3514 000012C1 FF46FE                   inc  word [bp-2]
  3515                                  
  3516                                  ;-63   }
  3517                                  
  3518                                  
  3519                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3520                                  
  3521 000012C4 EBD2                     jmp @@getName141
  3522                                  @@getName142:
  3523 000012C6 8A4604                   mov al, [bp+4]
  3524 000012C9 3C3A                     cmp al, 58
  3525 000012CB 0F850C00                 jne @@getName143
  3526 000012CF 66B801000000             mov eax, 1
  3527 000012D5 A2[3B00]                 mov byte [isLabel], al
  3528 000012D8 E90900                   jmp @@getName144
  3529                                  @@getName143:
  3530 000012DB 66B800000000             mov eax, 0
  3531 000012E1 A2[3B00]                 mov byte [isLabel], al
  3532                                  
  3533                                  ;-65   p--;
  3534                                  
  3535                                  @@getName144:
  3536 000012E4 FF4EFE                   dec  word [bp-2]
  3537                                  
  3538                                  ;-66   *p = 0;
  3539                                  
  3540 000012E7 66B800000000             mov eax, 0
  3541 000012ED 8B5EFE                   mov  bx, [bp-2]
  3542 000012F0 8807                     mov  [bx], al
  3543                                  
  3544                                  ;-67   strcpy(SymbolUpper, Symbol);
  3545                                  
  3546 000012F2 8D063075                 lea  ax, [Symbol]
  3547 000012F6 50                       push ax
  3548 000012F7 8D064F75                 lea  ax, [SymbolUpper]
  3549 000012FB 50                       push ax
  3550 000012FC E8D20C                   call strcpy
  3551 000012FF 83C404                   add  sp, 4
  3552                                  
  3553                                  ;-68   toupper(SymbolUpper);
  3554                                  
  3555 00001302 8D064F75                 lea  ax, [SymbolUpper]
  3556 00001306 50                       push ax
  3557 00001307 E8590C                   call toupper
  3558 0000130A 83C402                   add  sp, 2
  3559                                  
  3560                                  ;-69 }
  3561                                  
  3562                                  
  3563                                  ;-70 int testReg() {
  3564 0000130D C9                       LEAVE
  3565 0000130E C3                       ret
  3566                                  ; ENDP
  3567                                  
  3568                                  testReg:  ; *** PROC ***
  3569                                  
  3570                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3571                                  
  3572                                  
  3573                                  ;-72   RegType=0;
  3574                                  
  3575 0000130F 66B800000000             mov eax, 0
  3576 00001315 A2[4200]                 mov byte [RegType], al
  3577                                  
  3578                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3579                                  
  3580 00001318 8D063075                 lea  ax, [Symbol]
  3581 0000131C 50                       push ax
  3582 0000131D E8860C                   call strlen
  3583 00001320 83C402                   add  sp, 2
  3584 00001323 3C02                     cmp al, 2
  3585 00001325 0F8D0900                 jge @@testReg145
  3586 00001329 66B800000000             mov eax, 0
  3587 0000132F E9B603                   jmp @@retn
  3588                                  
  3589                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3590                                  
  3591                                  @@testReg145:
  3592 00001332 8D063075                 lea  ax, [Symbol]
  3593 00001336 50                       push ax
  3594 00001337 E86C0C                   call strlen
  3595 0000133A 83C402                   add  sp, 2
  3596 0000133D 3C03                     cmp al, 3
  3597 0000133F 0F8E0900                 jle @@testReg146
  3598 00001343 66B800000000             mov eax, 0
  3599 00001349 E99C03                   jmp @@retn
  3600                                  
  3601                                  ;-75   RegType=BYTE;
  3602                                  
  3603                                  @@testReg146:
  3604 0000134C 66B801000000             mov eax, 1
  3605 00001352 A2[4200]                 mov byte [RegType], al
  3606                                  
  3607                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3608                                  
  3609 00001355 68[E916]                 push testReg_0
  3610 00001358 8D064F75                 lea  ax, [SymbolUpper]
  3611 0000135C 50                       push ax
  3612 0000135D E8DD0C                   call eqstr
  3613 00001360 83C404                   add  sp, 4
  3614 00001363 08C0                     or  al, al
  3615 00001365 0F840900                 je @@testReg147
  3616 00001369 66B800000000             mov eax, 0
  3617 0000136F E97603                   jmp @@retn
  3618                                  
  3619                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3620                                  
  3621                                  @@testReg147:
  3622 00001372 68[EC16]                 push testReg_1
  3623 00001375 8D064F75                 lea  ax, [SymbolUpper]
  3624 00001379 50                       push ax
  3625 0000137A E8C00C                   call eqstr
  3626 0000137D 83C404                   add  sp, 4
  3627 00001380 08C0                     or  al, al
  3628 00001382 0F840900                 je @@testReg148
  3629 00001386 66B801000000             mov eax, 1
  3630 0000138C E95903                   jmp @@retn
  3631                                  
  3632                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3633                                  
  3634                                  @@testReg148:
  3635 0000138F 68[EF16]                 push testReg_2
  3636 00001392 8D064F75                 lea  ax, [SymbolUpper]
  3637 00001396 50                       push ax
  3638 00001397 E8A30C                   call eqstr
  3639 0000139A 83C404                   add  sp, 4
  3640 0000139D 08C0                     or  al, al
  3641 0000139F 0F840900                 je @@testReg149
  3642 000013A3 66B802000000             mov eax, 2
  3643 000013A9 E93C03                   jmp @@retn
  3644                                  
  3645                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3646                                  
  3647                                  @@testReg149:
  3648 000013AC 68[F216]                 push testReg_3
  3649 000013AF 8D064F75                 lea  ax, [SymbolUpper]
  3650 000013B3 50                       push ax
  3651 000013B4 E8860C                   call eqstr
  3652 000013B7 83C404                   add  sp, 4
  3653 000013BA 08C0                     or  al, al
  3654 000013BC 0F840900                 je @@testReg150
  3655 000013C0 66B803000000             mov eax, 3
  3656 000013C6 E91F03                   jmp @@retn
  3657                                  
  3658                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3659                                  
  3660                                  @@testReg150:
  3661 000013C9 68[F516]                 push testReg_4
  3662 000013CC 8D064F75                 lea  ax, [SymbolUpper]
  3663 000013D0 50                       push ax
  3664 000013D1 E8690C                   call eqstr
  3665 000013D4 83C404                   add  sp, 4
  3666 000013D7 08C0                     or  al, al
  3667 000013D9 0F840900                 je @@testReg151
  3668 000013DD 66B804000000             mov eax, 4
  3669 000013E3 E90203                   jmp @@retn
  3670                                  
  3671                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3672                                  
  3673                                  @@testReg151:
  3674 000013E6 68[F816]                 push testReg_5
  3675 000013E9 8D064F75                 lea  ax, [SymbolUpper]
  3676 000013ED 50                       push ax
  3677 000013EE E84C0C                   call eqstr
  3678 000013F1 83C404                   add  sp, 4
  3679 000013F4 08C0                     or  al, al
  3680 000013F6 0F840900                 je @@testReg152
  3681 000013FA 66B805000000             mov eax, 5
  3682 00001400 E9E502                   jmp @@retn
  3683                                  
  3684                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3685                                  
  3686                                  @@testReg152:
  3687 00001403 68[FB16]                 push testReg_6
  3688 00001406 8D064F75                 lea  ax, [SymbolUpper]
  3689 0000140A 50                       push ax
  3690 0000140B E82F0C                   call eqstr
  3691 0000140E 83C404                   add  sp, 4
  3692 00001411 08C0                     or  al, al
  3693 00001413 0F840900                 je @@testReg153
  3694 00001417 66B806000000             mov eax, 6
  3695 0000141D E9C802                   jmp @@retn
  3696                                  
  3697                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3698                                  
  3699                                  @@testReg153:
  3700 00001420 68[FE16]                 push testReg_7
  3701 00001423 8D064F75                 lea  ax, [SymbolUpper]
  3702 00001427 50                       push ax
  3703 00001428 E8120C                   call eqstr
  3704 0000142B 83C404                   add  sp, 4
  3705 0000142E 08C0                     or  al, al
  3706 00001430 0F840900                 je @@testReg154
  3707 00001434 66B807000000             mov eax, 7
  3708 0000143A E9AB02                   jmp @@retn
  3709                                  
  3710                                  ;-84   RegType=WORD;
  3711                                  
  3712                                  @@testReg154:
  3713 0000143D 66B802000000             mov eax, 2
  3714 00001443 A2[4200]                 mov byte [RegType], al
  3715                                  
  3716                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3717                                  
  3718 00001446 68[0117]                 push testReg_8
  3719 00001449 8D064F75                 lea  ax, [SymbolUpper]
  3720 0000144D 50                       push ax
  3721 0000144E E8EC0B                   call eqstr
  3722 00001451 83C404                   add  sp, 4
  3723 00001454 08C0                     or  al, al
  3724 00001456 0F840900                 je @@testReg155
  3725 0000145A 66B800000000             mov eax, 0
  3726 00001460 E98502                   jmp @@retn
  3727                                  
  3728                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3729                                  
  3730                                  @@testReg155:
  3731 00001463 68[0417]                 push testReg_9
  3732 00001466 8D064F75                 lea  ax, [SymbolUpper]
  3733 0000146A 50                       push ax
  3734 0000146B E8CF0B                   call eqstr
  3735 0000146E 83C404                   add  sp, 4
  3736 00001471 08C0                     or  al, al
  3737 00001473 0F840900                 je @@testReg156
  3738 00001477 66B801000000             mov eax, 1
  3739 0000147D E96802                   jmp @@retn
  3740                                  
  3741                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3742                                  
  3743                                  @@testReg156:
  3744 00001480 68[0717]                 push testReg_10
  3745 00001483 8D064F75                 lea  ax, [SymbolUpper]
  3746 00001487 50                       push ax
  3747 00001488 E8B20B                   call eqstr
  3748 0000148B 83C404                   add  sp, 4
  3749 0000148E 08C0                     or  al, al
  3750 00001490 0F840900                 je @@testReg157
  3751 00001494 66B802000000             mov eax, 2
  3752 0000149A E94B02                   jmp @@retn
  3753                                  
  3754                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3755                                  
  3756                                  @@testReg157:
  3757 0000149D 68[0A17]                 push testReg_11
  3758 000014A0 8D064F75                 lea  ax, [SymbolUpper]
  3759 000014A4 50                       push ax
  3760 000014A5 E8950B                   call eqstr
  3761 000014A8 83C404                   add  sp, 4
  3762 000014AB 08C0                     or  al, al
  3763 000014AD 0F840900                 je @@testReg158
  3764 000014B1 66B803000000             mov eax, 3
  3765 000014B7 E92E02                   jmp @@retn
  3766                                  
  3767                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3768                                  
  3769                                  @@testReg158:
  3770 000014BA 68[0D17]                 push testReg_12
  3771 000014BD 8D064F75                 lea  ax, [SymbolUpper]
  3772 000014C1 50                       push ax
  3773 000014C2 E8780B                   call eqstr
  3774 000014C5 83C404                   add  sp, 4
  3775 000014C8 08C0                     or  al, al
  3776 000014CA 0F840900                 je @@testReg159
  3777 000014CE 66B804000000             mov eax, 4
  3778 000014D4 E91102                   jmp @@retn
  3779                                  
  3780                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3781                                  
  3782                                  @@testReg159:
  3783 000014D7 68[1017]                 push testReg_13
  3784 000014DA 8D064F75                 lea  ax, [SymbolUpper]
  3785 000014DE 50                       push ax
  3786 000014DF E85B0B                   call eqstr
  3787 000014E2 83C404                   add  sp, 4
  3788 000014E5 08C0                     or  al, al
  3789 000014E7 0F840900                 je @@testReg160
  3790 000014EB 66B805000000             mov eax, 5
  3791 000014F1 E9F401                   jmp @@retn
  3792                                  
  3793                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3794                                  
  3795                                  @@testReg160:
  3796 000014F4 68[1317]                 push testReg_14
  3797 000014F7 8D064F75                 lea  ax, [SymbolUpper]
  3798 000014FB 50                       push ax
  3799 000014FC E83E0B                   call eqstr
  3800 000014FF 83C404                   add  sp, 4
  3801 00001502 08C0                     or  al, al
  3802 00001504 0F840900                 je @@testReg161
  3803 00001508 66B806000000             mov eax, 6
  3804 0000150E E9D701                   jmp @@retn
  3805                                  
  3806                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3807                                  
  3808                                  @@testReg161:
  3809 00001511 68[1617]                 push testReg_15
  3810 00001514 8D064F75                 lea  ax, [SymbolUpper]
  3811 00001518 50                       push ax
  3812 00001519 E8210B                   call eqstr
  3813 0000151C 83C404                   add  sp, 4
  3814 0000151F 08C0                     or  al, al
  3815 00001521 0F840900                 je @@testReg162
  3816 00001525 66B807000000             mov eax, 7
  3817 0000152B E9BA01                   jmp @@retn
  3818                                  
  3819                                  ;-93   RegType=SEGREG;
  3820                                  
  3821                                  @@testReg162:
  3822 0000152E 66B804000000             mov eax, 4
  3823 00001534 A2[4200]                 mov byte [RegType], al
  3824                                  
  3825                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3826                                  
  3827 00001537 68[1917]                 push testReg_16
  3828 0000153A 8D064F75                 lea  ax, [SymbolUpper]
  3829 0000153E 50                       push ax
  3830 0000153F E8FB0A                   call eqstr
  3831 00001542 83C404                   add  sp, 4
  3832 00001545 08C0                     or  al, al
  3833 00001547 0F840900                 je @@testReg163
  3834 0000154B 66B800000000             mov eax, 0
  3835 00001551 E99401                   jmp @@retn
  3836                                  
  3837                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3838                                  
  3839                                  @@testReg163:
  3840 00001554 68[1C17]                 push testReg_17
  3841 00001557 8D064F75                 lea  ax, [SymbolUpper]
  3842 0000155B 50                       push ax
  3843 0000155C E8DE0A                   call eqstr
  3844 0000155F 83C404                   add  sp, 4
  3845 00001562 08C0                     or  al, al
  3846 00001564 0F840900                 je @@testReg164
  3847 00001568 66B801000000             mov eax, 1
  3848 0000156E E97701                   jmp @@retn
  3849                                  
  3850                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3851                                  
  3852                                  @@testReg164:
  3853 00001571 68[1F17]                 push testReg_18
  3854 00001574 8D064F75                 lea  ax, [SymbolUpper]
  3855 00001578 50                       push ax
  3856 00001579 E8C10A                   call eqstr
  3857 0000157C 83C404                   add  sp, 4
  3858 0000157F 08C0                     or  al, al
  3859 00001581 0F840900                 je @@testReg165
  3860 00001585 66B802000000             mov eax, 2
  3861 0000158B E95A01                   jmp @@retn
  3862                                  
  3863                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3864                                  
  3865                                  @@testReg165:
  3866 0000158E 68[2217]                 push testReg_19
  3867 00001591 8D064F75                 lea  ax, [SymbolUpper]
  3868 00001595 50                       push ax
  3869 00001596 E8A40A                   call eqstr
  3870 00001599 83C404                   add  sp, 4
  3871 0000159C 08C0                     or  al, al
  3872 0000159E 0F840900                 je @@testReg166
  3873 000015A2 66B803000000             mov eax, 3
  3874 000015A8 E93D01                   jmp @@retn
  3875                                  
  3876                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3877                                  
  3878                                  @@testReg166:
  3879 000015AB 68[2517]                 push testReg_20
  3880 000015AE 8D064F75                 lea  ax, [SymbolUpper]
  3881 000015B2 50                       push ax
  3882 000015B3 E8870A                   call eqstr
  3883 000015B6 83C404                   add  sp, 4
  3884 000015B9 08C0                     or  al, al
  3885 000015BB 0F840900                 je @@testReg167
  3886 000015BF 66B804000000             mov eax, 4
  3887 000015C5 E92001                   jmp @@retn
  3888                                  
  3889                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3890                                  
  3891                                  @@testReg167:
  3892 000015C8 68[2817]                 push testReg_21
  3893 000015CB 8D064F75                 lea  ax, [SymbolUpper]
  3894 000015CF 50                       push ax
  3895 000015D0 E86A0A                   call eqstr
  3896 000015D3 83C404                   add  sp, 4
  3897 000015D6 08C0                     or  al, al
  3898 000015D8 0F840900                 je @@testReg168
  3899 000015DC 66B805000000             mov eax, 5
  3900 000015E2 E90301                   jmp @@retn
  3901                                  
  3902                                  ;-100   RegType=DWORD;
  3903                                  
  3904                                  @@testReg168:
  3905 000015E5 66B803000000             mov eax, 3
  3906 000015EB A2[4200]                 mov byte [RegType], al
  3907                                  
  3908                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3909                                  
  3910 000015EE 68[2B17]                 push testReg_22
  3911 000015F1 8D064F75                 lea  ax, [SymbolUpper]
  3912 000015F5 50                       push ax
  3913 000015F6 E8440A                   call eqstr
  3914 000015F9 83C404                   add  sp, 4
  3915 000015FC 08C0                     or  al, al
  3916 000015FE 0F840900                 je @@testReg169
  3917 00001602 66B800000000             mov eax, 0
  3918 00001608 E9DD00                   jmp @@retn
  3919                                  
  3920                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3921                                  
  3922                                  @@testReg169:
  3923 0000160B 68[2F17]                 push testReg_23
  3924 0000160E 8D064F75                 lea  ax, [SymbolUpper]
  3925 00001612 50                       push ax
  3926 00001613 E8270A                   call eqstr
  3927 00001616 83C404                   add  sp, 4
  3928 00001619 08C0                     or  al, al
  3929 0000161B 0F840900                 je @@testReg170
  3930 0000161F 66B801000000             mov eax, 1
  3931 00001625 E9C000                   jmp @@retn
  3932                                  
  3933                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3934                                  
  3935                                  @@testReg170:
  3936 00001628 68[3317]                 push testReg_24
  3937 0000162B 8D064F75                 lea  ax, [SymbolUpper]
  3938 0000162F 50                       push ax
  3939 00001630 E80A0A                   call eqstr
  3940 00001633 83C404                   add  sp, 4
  3941 00001636 08C0                     or  al, al
  3942 00001638 0F840900                 je @@testReg171
  3943 0000163C 66B802000000             mov eax, 2
  3944 00001642 E9A300                   jmp @@retn
  3945                                  
  3946                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3947                                  
  3948                                  @@testReg171:
  3949 00001645 68[3717]                 push testReg_25
  3950 00001648 8D064F75                 lea  ax, [SymbolUpper]
  3951 0000164C 50                       push ax
  3952 0000164D E8ED09                   call eqstr
  3953 00001650 83C404                   add  sp, 4
  3954 00001653 08C0                     or  al, al
  3955 00001655 0F840900                 je @@testReg172
  3956 00001659 66B803000000             mov eax, 3
  3957 0000165F E98600                   jmp @@retn
  3958                                  
  3959                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3960                                  
  3961                                  @@testReg172:
  3962 00001662 68[3B17]                 push testReg_26
  3963 00001665 8D064F75                 lea  ax, [SymbolUpper]
  3964 00001669 50                       push ax
  3965 0000166A E8D009                   call eqstr
  3966 0000166D 83C404                   add  sp, 4
  3967 00001670 08C0                     or  al, al
  3968 00001672 0F840900                 je @@testReg173
  3969 00001676 66B804000000             mov eax, 4
  3970 0000167C E96900                   jmp @@retn
  3971                                  
  3972                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3973                                  
  3974                                  @@testReg173:
  3975 0000167F 68[3F17]                 push testReg_27
  3976 00001682 8D064F75                 lea  ax, [SymbolUpper]
  3977 00001686 50                       push ax
  3978 00001687 E8B309                   call eqstr
  3979 0000168A 83C404                   add  sp, 4
  3980 0000168D 08C0                     or  al, al
  3981 0000168F 0F840900                 je @@testReg174
  3982 00001693 66B805000000             mov eax, 5
  3983 00001699 E94C00                   jmp @@retn
  3984                                  
  3985                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3986                                  
  3987                                  @@testReg174:
  3988 0000169C 68[4317]                 push testReg_28
  3989 0000169F 8D064F75                 lea  ax, [SymbolUpper]
  3990 000016A3 50                       push ax
  3991 000016A4 E89609                   call eqstr
  3992 000016A7 83C404                   add  sp, 4
  3993 000016AA 08C0                     or  al, al
  3994 000016AC 0F840900                 je @@testReg175
  3995 000016B0 66B806000000             mov eax, 6
  3996 000016B6 E92F00                   jmp @@retn
  3997                                  
  3998                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3999                                  
  4000                                  @@testReg175:
  4001 000016B9 68[4717]                 push testReg_29
  4002 000016BC 8D064F75                 lea  ax, [SymbolUpper]
  4003 000016C0 50                       push ax
  4004 000016C1 E87909                   call eqstr
  4005 000016C4 83C404                   add  sp, 4
  4006 000016C7 08C0                     or  al, al
  4007 000016C9 0F840900                 je @@testReg176
  4008 000016CD 66B807000000             mov eax, 7
  4009 000016D3 E91200                   jmp @@retn
  4010                                  
  4011                                  ;-109   RegType=0; return 0;
  4012                                  
  4013                                  @@testReg176:
  4014 000016D6 66B800000000             mov eax, 0
  4015 000016DC A2[4200]                 mov byte [RegType], al
  4016 000016DF 66B800000000             mov eax, 0
  4017 000016E5 E90000                   jmp @@retn
  4018                                  
  4019                                  ;-110 }
  4020                                  
  4021                                  @@retn:
  4022 000016E8 C3                       ret
  4023                                  ; ENDP
  4024 000016E9 414C00                  testReg_0 db "AL",0
  4025 000016EC 434C00                  testReg_1 db "CL",0
  4026 000016EF 444C00                  testReg_2 db "DL",0
  4027 000016F2 424C00                  testReg_3 db "BL",0
  4028 000016F5 414800                  testReg_4 db "AH",0
  4029 000016F8 434800                  testReg_5 db "CH",0
  4030 000016FB 444800                  testReg_6 db "DH",0
  4031 000016FE 424800                  testReg_7 db "BH",0
  4032 00001701 415800                  testReg_8 db "AX",0
  4033 00001704 435800                  testReg_9 db "CX",0
  4034 00001707 445800                  testReg_10 db "DX",0
  4035 0000170A 425800                  testReg_11 db "BX",0
  4036 0000170D 535000                  testReg_12 db "SP",0
  4037 00001710 425000                  testReg_13 db "BP",0
  4038 00001713 534900                  testReg_14 db "SI",0
  4039 00001716 444900                  testReg_15 db "DI",0
  4040 00001719 455300                  testReg_16 db "ES",0
  4041 0000171C 435300                  testReg_17 db "CS",0
  4042 0000171F 535300                  testReg_18 db "SS",0
  4043 00001722 445300                  testReg_19 db "DS",0
  4044 00001725 465300                  testReg_20 db "FS",0
  4045 00001728 475300                  testReg_21 db "GS",0
  4046 0000172B 45415800                testReg_22 db "EAX",0
  4047 0000172F 45435800                testReg_23 db "ECX",0
  4048 00001733 45445800                testReg_24 db "EDX",0
  4049 00001737 45425800                testReg_25 db "EBX",0
  4050 0000173B 45535000                testReg_26 db "ESP",0
  4051 0000173F 45425000                testReg_27 db "EBP",0
  4052 00001743 45534900                testReg_28 db "ESI",0
  4053 00001747 45444900                testReg_29 db "EDI",0
  4054                                  ;Back to main program: AS.C
  4055                                  
  4056                                  ;-220 #include "OUTPUT.C"
  4057                                  
  4058                                  ;Use include file: OUTPUT.C
  4059                                  
  4060                                  ;-1 int printLine() { int i; char c;
  4061                                  
  4062                                  
  4063                                  printLine:  ; *** PROC ***
  4064                                  
  4065                                  ;-2   prs("\n"); printhex16(PCStart);
  4066                                  
  4067                                  ;Function : printLine, Number of local variables: 2
  4068                                  ;   # type sign width line used address name   list of local variables
  4069                                  ;  200 var sign word     1 NULL bp-2    i
  4070                                  ;  201 var sign byte     1 NULL bp-4    c;
  4071 0000174B C8040000                 ENTER  4,0
  4072 0000174F 68[E017]                 push printLine_0
  4073 00001752 E80401                   call prs
  4074 00001755 83C402                   add  sp, 2
  4075 00001758 FF36[3900]               push word [PCStart]
  4076 0000175C E8EB01                   call printhex16
  4077 0000175F 83C402                   add  sp, 2
  4078                                  
  4079                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  4080                                  
  4081 00001762 A1[4B00]                 mov ax, [OpPrintIndex]
  4082 00001765 83F800                   cmp ax, 0
  4083 00001768 0F850C00                 jne @@printLine177
  4084 0000176C 68[E317]                 push printLine_1
  4085 0000176F E8E700                   call prs
  4086 00001772 83C402                   add  sp, 2
  4087                                  
  4088                                  ;-4   else {
  4089                                  
  4090 00001775 E95B00                   jmp @@printLine178
  4091                                  @@printLine177:
  4092                                  
  4093                                  ;-5     prc(PrintR);
  4094                                  
  4095 00001778 A0[4F00]                 mov al, byte [PrintR]
  4096 0000177B B400                     mov ah, 0
  4097 0000177D 50                       push ax
  4098 0000177E E87700                   call prc
  4099 00001781 83C402                   add  sp, 2
  4100                                  
  4101                                  ;-6     i=0;
  4102                                  
  4103 00001784 66B800000000             mov eax, 0
  4104 0000178A 8946FE                   mov word [bp-2], ax
  4105                                  
  4106                                  ;-7     do {
  4107                                  
  4108                                  @@printLine179:
  4109                                  
  4110                                  ;-8       c=OpPos[i];
  4111                                  
  4112 0000178D 8B5EFE                   mov bx, [bp-2]
  4113 00001790 8A87B676                 mov al, [OpPos + bx]
  4114 00001794 8846FC                   mov byte [bp-4], al
  4115                                  
  4116                                  ;-9       printhex8a(c); prc(' ');
  4117                                  
  4118 00001797 8A46FC                   mov al, byte [bp-4]
  4119 0000179A B400                     mov ah, 0
  4120 0000179C 50                       push ax
  4121 0000179D E85C01                   call printhex8a
  4122 000017A0 83C402                   add  sp, 2
  4123 000017A3 6A20                     push 32
  4124 000017A5 E85000                   call prc
  4125 000017A8 83C402                   add  sp, 2
  4126                                  
  4127                                  ;-10       i++;
  4128                                  
  4129 000017AB FF46FE                   inc  word [bp-2]
  4130                                  
  4131                                  ;-11     } while(i < OpPrintIndex);
  4132                                  
  4133 000017AE 8B46FE                   mov ax, [bp-2]
  4134 000017B1 3B06[4B00]               cmp ax, [OpPrintIndex]
  4135 000017B5 0F8D0200                 jge @@printLine180
  4136 000017B9 EBD2                     jmp @@printLine179
  4137                                  @@printLine180:
  4138                                  
  4139                                  ;-12     do {// fill rest with blank
  4140                                  
  4141                                  @@printLine181:
  4142                                  
  4143                                  ;-13       prs("   ");
  4144                                  
  4145 000017BB 68[F417]                 push printLine_2
  4146 000017BE E89800                   call prs
  4147 000017C1 83C402                   add  sp, 2
  4148                                  
  4149                                  ;-14       i++;
  4150                                  
  4151 000017C4 FF46FE                   inc  word [bp-2]
  4152                                  
  4153                                  ;-15     } while(i < OPMAXLEN);
  4154                                  
  4155 000017C7 8B46FE                   mov ax, [bp-2]
  4156 000017CA 83F805                   cmp ax, 5
  4157 000017CD 0F8D0200                 jge @@printLine182
  4158 000017D1 EBE8                     jmp @@printLine181
  4159                                  @@printLine182:
  4160                                  
  4161                                  ;-16   }
  4162                                  
  4163                                  
  4164                                  ;-17   prscomment(InputBuf);
  4165                                  
  4166                                  @@printLine178:
  4167 000017D3 8D066E75                 lea  ax, [InputBuf]
  4168 000017D7 50                       push ax
  4169 000017D8 E85000                   call prscomment
  4170 000017DB 83C402                   add  sp, 2
  4171                                  
  4172                                  ;-18 }
  4173                                  
  4174                                  
  4175                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4176 000017DE C9                       LEAVE
  4177 000017DF C3                       ret
  4178                                  ; ENDP
  4179 000017E0 5C6E00                  printLine_0 db "\n",0
  4180 000017E3 202020202020202020-     printLine_1 db "                ",0
  4181 000017EC 2020202020202000   
  4182 000017F4 20202000                printLine_2 db "   ",0
  4183                                  
  4184                                  prc:  ; *** PROC ***
  4185                                  ;Function : prc, Number of local variables: 1
  4186                                  ;   # type sign width line used address name   list of local variables
  4187                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4188 000017F8 C8000000                 ENTER  0,0
  4189 000017FC A0[2500]                 mov al, [LIST]
  4190 000017FF 08C0                     or  al, al
  4191 00001801 0F841400                 je @@prc183
  4192 00001805 807E040A                cmp byte [bp+4], 10
  4193 00001809 0F850600                 jne @@prc184
  4194 0000180D B80D00                   mov  ax, 13
  4195 00001810 E81A07                   call writetty
  4196                                  
  4197                                  ;-20      al=c; writetty(); }
  4198                                  
  4199                                  @@prc184:
  4200 00001813 8A4604                   mov  al, [bp+4]
  4201 00001816 E81407                   call writetty
  4202                                  
  4203                                  ;-21    fputcR(c,lst_fd); }
  4204                                  
  4205                                  @@prc183:
  4206 00001819 FF36[2C00]               push word [lst_fd]
  4207 0000181D 8A4604                   mov al, byte [bp+4]
  4208 00001820 B400                     mov ah, 0
  4209 00001822 50                       push ax
  4210 00001823 E8C708                   call fputcR
  4211 00001826 83C404                   add  sp, 4
  4212                                  
  4213                                  ;-22 
  4214                                  
  4215                                  
  4216                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4217 00001829 C9                       LEAVE
  4218 0000182A C3                       ret
  4219                                  ; ENDP
  4220                                  
  4221                                  prscomment:  ; *** PROC ***
  4222                                  
  4223                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4224                                  
  4225                                  ;Function : prscomment, Number of local variables: 2
  4226                                  ;   # type sign width line used address name   list of local variables
  4227                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4228                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4229 0000182B C8020000                 ENTER  2,0
  4230                                  @@prscomment185:
  4231 0000182F 8B5E04                   mov bx, [bp+4]
  4232 00001832 8A07                     mov al, [bx]
  4233 00001834 B400                     mov ah, 0
  4234 00001836 08C0                     or  al, al
  4235 00001838 0F841B00                 je @@prscomment186
  4236 0000183C 8B5E04                   mov bx, [bp+4]
  4237 0000183F 8A07                     mov al, [bx]
  4238 00001841 B400                     mov ah, 0
  4239 00001843 8846FE                   mov byte [bp-2], al
  4240 00001846 8A46FE                   mov al, byte [bp-2]
  4241 00001849 B400                     mov ah, 0
  4242 0000184B 50                       push ax
  4243 0000184C E8A9FF                   call prc
  4244 0000184F 83C402                   add  sp, 2
  4245 00001852 FF4604                   inc  word [bp+4]
  4246                                  
  4247                                  ;-25 }
  4248                                  
  4249 00001855 EBD8                     jmp @@prscomment185
  4250                                  @@prscomment186:
  4251                                  
  4252                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4253 00001857 C9                       LEAVE
  4254 00001858 C3                       ret
  4255                                  ; ENDP
  4256                                  
  4257                                  prs:  ; *** PROC ***
  4258                                  ;Function : prs, Number of local variables: 3
  4259                                  ;   # type sign width line used address name   list of local variables
  4260                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4261                                  ;  201 var unsg byte    26 NULL bp-2    c
  4262                                  ;  202 var sign word    26 NULL bp-4    com;
  4263 00001859 C8040000                 ENTER  4,0
  4264 0000185D 66B800000000             mov eax, 0
  4265 00001863 8946FC                   mov word [bp-4], ax
  4266                                  
  4267                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4268                                  
  4269                                  @@prs187:
  4270 00001866 8B5E04                   mov bx, [bp+4]
  4271 00001869 8A07                     mov al, [bx]
  4272 0000186B B400                     mov ah, 0
  4273 0000186D 08C0                     or  al, al
  4274 0000186F 0F848700                 je @@prs188
  4275 00001873 8B5E04                   mov bx, [bp+4]
  4276 00001876 8A07                     mov al, [bx]
  4277 00001878 B400                     mov ah, 0
  4278 0000187A 8846FE                   mov byte [bp-2], al
  4279 0000187D 8A46FE                   mov al, [bp-2]
  4280 00001880 3C22                     cmp al, 34
  4281 00001882 0F851E00                 jne @@prs189
  4282 00001886 8B46FC                   mov ax, [bp-4]
  4283 00001889 08C0                     or  al, al
  4284 0000188B 0F840C00                 je @@prs190
  4285 0000188F 66B800000000             mov eax, 0
  4286 00001895 8946FC                   mov word [bp-4], ax
  4287 00001898 E90900                   jmp @@prs191
  4288                                  @@prs190:
  4289 0000189B 66B801000000             mov eax, 1
  4290 000018A1 8946FC                   mov word [bp-4], ax
  4291                                  
  4292                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4293                                  
  4294                                  @@prs191:
  4295                                  @@prs189:
  4296 000018A4 8A46FE                   mov al, [bp-2]
  4297 000018A7 3C5C                     cmp al, 92
  4298 000018A9 0F853B00                 jne @@prs192
  4299 000018AD 8B46FC                   mov ax, [bp-4]
  4300 000018B0 83F800                   cmp ax, 0
  4301 000018B3 0F853100                 jne @@prs193
  4302 000018B7 FF4604                   inc  word [bp+4]
  4303 000018BA 8B5E04                   mov bx, [bp+4]
  4304 000018BD 8A07                     mov al, [bx]
  4305 000018BF B400                     mov ah, 0
  4306 000018C1 8846FE                   mov byte [bp-2], al
  4307                                  
  4308                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4309                                  
  4310 000018C4 8A46FE                   mov al, [bp-2]
  4311 000018C7 3C6E                     cmp al, 110
  4312 000018C9 0F850900                 jne @@prs194
  4313 000018CD 66B80A000000             mov eax, 10
  4314 000018D3 8846FE                   mov byte [bp-2], al
  4315                                  @@prs194:
  4316 000018D6 8A46FE                   mov al, [bp-2]
  4317 000018D9 3C74                     cmp al, 116
  4318 000018DB 0F850900                 jne @@prs195
  4319 000018DF 66B809000000             mov eax, 9
  4320 000018E5 8846FE                   mov byte [bp-2], al
  4321                                  @@prs195:
  4322                                  @@prs193:
  4323                                  @@prs192:
  4324 000018E8 8A46FE                   mov al, byte [bp-2]
  4325 000018EB B400                     mov ah, 0
  4326 000018ED 50                       push ax
  4327 000018EE E807FF                   call prc
  4328 000018F1 83C402                   add  sp, 2
  4329 000018F4 FF4604                   inc  word [bp+4]
  4330                                  
  4331                                  ;-30 }
  4332                                  
  4333 000018F7 E96CFF                   jmp @@prs187
  4334                                  @@prs188:
  4335                                  
  4336                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4337 000018FA C9                       LEAVE
  4338 000018FB C3                       ret
  4339                                  ; ENDP
  4340                                  
  4341                                  printhex8a:  ; *** PROC ***
  4342                                  
  4343                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4344                                  
  4345                                  ;Function : printhex8a, Number of local variables: 2
  4346                                  ;   # type sign width line used address name   list of local variables
  4347                                  ;  200 var unsg word    31 NULL bp+4    c
  4348                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4349 000018FC C8020000                 ENTER  2,0
  4350 00001900 8B4604                   mov ax, [bp+4]
  4351 00001903 C1E804                   shr ax, 4
  4352 00001906 8946FE                   mov word [bp-2], ax
  4353 00001909 8346FE30                 add  word [bp-2], 48
  4354 0000190D 8B46FE                   mov ax, [bp-2]
  4355 00001910 83F839                   cmp ax, 57
  4356 00001913 0F8E0400                 jle @@printhex8a196
  4357 00001917 8346FE07                 add  word [bp-2], 7
  4358                                  @@printhex8a196:
  4359 0000191B FF76FE                   push word [bp-2]
  4360 0000191E E8D7FE                   call prc
  4361 00001921 83C402                   add  sp, 2
  4362                                  
  4363                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4364                                  
  4365 00001924 8B4604                   mov ax, [bp+4]
  4366 00001927 83E00F                   and ax, 15
  4367 0000192A 8946FE                   mov word [bp-2], ax
  4368 0000192D 8346FE30                 add  word [bp-2], 48
  4369 00001931 8B46FE                   mov ax, [bp-2]
  4370 00001934 83F839                   cmp ax, 57
  4371 00001937 0F8E0400                 jle @@printhex8a197
  4372 0000193B 8346FE07                 add  word [bp-2], 7
  4373                                  @@printhex8a197:
  4374 0000193F FF76FE                   push word [bp-2]
  4375 00001942 E8B3FE                   call prc
  4376 00001945 83C402                   add  sp, 2
  4377                                  
  4378                                  ;-34 }
  4379                                  
  4380                                  
  4381                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4382 00001948 C9                       LEAVE
  4383 00001949 C3                       ret
  4384                                  ; ENDP
  4385                                  
  4386                                  printhex16:  ; *** PROC ***
  4387                                  
  4388                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4389                                  
  4390                                  ;Function : printhex16, Number of local variables: 2
  4391                                  ;   # type sign width line used address name   list of local variables
  4392                                  ;  200 var unsg word    35 NULL bp+4    i
  4393                                  ;  201 var unsg word    35 NULL bp-2    half;
  4394 0000194A C8020000                 ENTER  2,0
  4395 0000194E 8B4604                   mov ax, [bp+4]
  4396 00001951 C1E808                   shr ax, 8
  4397 00001954 8946FE                   mov word [bp-2], ax
  4398 00001957 FF76FE                   push word [bp-2]
  4399 0000195A E89FFF                   call printhex8a
  4400 0000195D 83C402                   add  sp, 2
  4401 00001960 8B4604                   mov ax, [bp+4]
  4402 00001963 25FF00                   and ax, 255
  4403 00001966 8946FE                   mov word [bp-2], ax
  4404 00001969 FF76FE                   push word [bp-2]
  4405 0000196C E88DFF                   call printhex8a
  4406 0000196F 83C402                   add  sp, 2
  4407                                  
  4408                                  ;-37 }
  4409                                  
  4410                                  
  4411                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4412 00001972 C9                       LEAVE
  4413 00001973 C3                       ret
  4414                                  ; ENDP
  4415                                  
  4416                                  printIntU:  ; *** PROC ***
  4417                                  
  4418                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4419                                  
  4420                                  ;Function : printIntU, Number of local variables: 2
  4421                                  ;   # type sign width line used address name   list of local variables
  4422                                  ;  200 var unsg word    38 NULL bp+4    n
  4423                                  ;  201 var unsg word    38 NULL bp-2    e;
  4424 00001974 C8020000                 ENTER  2,0
  4425 00001978 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4426 0000197C 0F821700                 jb  @@printIntU198
  4427 00001980 8B4604                   mov ax, [bp+4]
  4428 00001983 BB0A00                   mov bx, 10
  4429 00001986 BA0000                   mov dx, 0
  4430 00001989 F7F3                     div bx
  4431 0000198B 8946FE                   mov word [bp-2], ax
  4432                                  
  4433                                  ;-40     printIntU(e); }
  4434                                  
  4435 0000198E FF76FE                   push word [bp-2]
  4436 00001991 E8E0FF                   call printIntU
  4437 00001994 83C402                   add  sp, 2
  4438                                  
  4439                                  ;-41     n = n % 10; //unsigned mod
  4440                                  
  4441                                  @@printIntU198:
  4442 00001997 8B4604                   mov ax, [bp+4]
  4443 0000199A BB0A00                   mov bx, 10
  4444 0000199D BA0000                   mov dx, 0
  4445 000019A0 F7F3                     div bx
  4446 000019A2 89D0                     mov ax, dx
  4447 000019A4 894604                   mov word [bp+4], ax
  4448                                  
  4449                                  ;-42     n += '0'; prc(n);
  4450                                  
  4451 000019A7 83460430                 add  word [bp+4], 48
  4452 000019AB FF7604                   push word [bp+4]
  4453 000019AE E847FE                   call prc
  4454 000019B1 83C402                   add  sp, 2
  4455                                  
  4456                                  ;-43 }
  4457                                  
  4458                                  
  4459                                  ;-44 
  4460                                  
  4461                                  
  4462                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4463 000019B4 C9                       LEAVE
  4464 000019B5 C3                       ret
  4465                                  ; ENDP
  4466                                  
  4467                                  error1:  ; *** PROC ***
  4468                                  ;Function : error1, Number of local variables: 1
  4469                                  ;   # type sign width line used address name   list of local variables
  4470                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4471 000019B6 C8000000                 ENTER  0,0
  4472 000019BA 66B801000000             mov eax, 1
  4473 000019C0 A2[2500]                 mov byte [LIST], al
  4474 000019C3 FF06[3200]               inc  word [ErrorCount]
  4475                                  
  4476                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4477                                  
  4478 000019C7 68[EF19]                 push error1_0
  4479 000019CA E88CFE                   call prs
  4480 000019CD 83C402                   add  sp, 2
  4481 000019D0 FF7604                   push word [bp+4]
  4482 000019D3 E883FE                   call prs
  4483 000019D6 83C402                   add  sp, 2
  4484                                  
  4485                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4486                                  
  4487 000019D9 68[0A1A]                 push error1_1
  4488 000019DC E87AFE                   call prs
  4489 000019DF 83C402                   add  sp, 2
  4490 000019E2 8D063075                 lea  ax, [Symbol]
  4491 000019E6 50                       push ax
  4492 000019E7 E86FFE                   call prs
  4493 000019EA 83C402                   add  sp, 2
  4494                                  
  4495                                  ;-48 int allowederror(){error1("not allowed here"); }
  4496 000019ED C9                       LEAVE
  4497 000019EE C3                       ret
  4498                                  ; ENDP
  4499 000019EF 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4500 000019F8 6E657874206C696E65-
  4501 00001A01 204552524F523A2000 
  4502 00001A0A 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4503 00001A13 2000               
  4504                                  
  4505                                  allowederror:  ; *** PROC ***
  4506 00001A15 68[1F1A]                 push allowederror_0
  4507 00001A18 E89BFF                   call error1
  4508 00001A1B 83C402                   add  sp, 2
  4509                                  
  4510                                  ;-49 int implmerror(){error1("not implemented");}
  4511                                  
  4512 00001A1E C3                       ret
  4513                                  ; ENDP
  4514 00001A1F 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4515 00001A28 6564206865726500   
  4516                                  
  4517                                  implmerror:  ; *** PROC ***
  4518 00001A30 68[3A1A]                 push implmerror_0
  4519 00001A33 E880FF                   call error1
  4520 00001A36 83C402                   add  sp, 2
  4521                                  
  4522                                  ;-50 int indexerror (){error1("invalid index register");}
  4523                                  
  4524 00001A39 C3                       ret
  4525                                  ; ENDP
  4526 00001A3A 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4527 00001A43 6D656E74656400     
  4528                                  
  4529                                  indexerror:  ; *** PROC ***
  4530 00001A4A 68[541A]                 push indexerror_0
  4531 00001A4D E866FF                   call error1
  4532 00001A50 83C402                   add  sp, 2
  4533                                  
  4534                                  ;-51 int numbererror(){error1("number expected");}
  4535                                  
  4536 00001A53 C3                       ret
  4537                                  ; ENDP
  4538 00001A54 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4539 00001A5D 6E6465782072656769-
  4540 00001A66 7374657200         
  4541                                  
  4542                                  numbererror:  ; *** PROC ***
  4543 00001A6B 68[751A]                 push numbererror_0
  4544 00001A6E E845FF                   call error1
  4545 00001A71 83C402                   add  sp, 2
  4546                                  
  4547                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4548                                  
  4549 00001A74 C3                       ret
  4550                                  ; ENDP
  4551 00001A75 6E756D626572206578-     numbererror_0 db "number expected",0
  4552 00001A7E 70656374656400     
  4553                                  
  4554                                  regmemerror:  ; *** PROC ***
  4555 00001A85 68[8F1A]                 push regmemerror_0
  4556 00001A88 E82BFF                   call error1
  4557 00001A8B 83C402                   add  sp, 2
  4558                                  
  4559                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4560                                  
  4561 00001A8E C3                       ret
  4562                                  ; ENDP
  4563 00001A8F 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4564 00001A98 73746572206F72206D-
  4565 00001AA1 656D6F727920616C6C-
  4566 00001AAA 6F77656400         
  4567                                  
  4568                                  segregerror:  ; *** PROC ***
  4569 00001AAF 68[B91A]                 push segregerror_0
  4570 00001AB2 E801FF                   call error1
  4571 00001AB5 83C402                   add  sp, 2
  4572                                  
  4573                                  ;-54 int syntaxerror(){error1("syntax");}
  4574                                  
  4575 00001AB8 C3                       ret
  4576                                  ; ENDP
  4577 00001AB9 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4578 00001AC2 65676973746572206E-
  4579 00001ACB 6F7420616C6C6F7765-
  4580 00001AD4 6400               
  4581                                  
  4582                                  syntaxerror:  ; *** PROC ***
  4583 00001AD6 68[E01A]                 push syntaxerror_0
  4584 00001AD9 E8DAFE                   call error1
  4585 00001ADC 83C402                   add  sp, 2
  4586                                  
  4587                                  ;-55 
  4588                                  
  4589                                  
  4590                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4591                                  
  4592 00001ADF C3                       ret
  4593                                  ; ENDP
  4594 00001AE0 73796E74617800          syntaxerror_0 db "syntax",0
  4595                                  
  4596                                  errorexit:  ; *** PROC ***
  4597                                  ;Function : errorexit, Number of local variables: 1
  4598                                  ;   # type sign width line used address name   list of local variables
  4599                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4600 00001AE7 C8000000                 ENTER  0,0
  4601 00001AEB FF7604                   push word [bp+4]
  4602 00001AEE E8C5FE                   call error1
  4603 00001AF1 83C402                   add  sp, 2
  4604 00001AF4 6A01                     push 1
  4605 00001AF6 E80704                   call end1
  4606 00001AF9 83C402                   add  sp, 2
  4607                                  
  4608                                  ;-57 int addrexit(){errorexit("illegal address");}
  4609 00001AFC C9                       LEAVE
  4610 00001AFD C3                       ret
  4611                                  ; ENDP
  4612                                  
  4613                                  addrexit:  ; *** PROC ***
  4614 00001AFE 68[081B]                 push addrexit_0
  4615 00001B01 E8E3FF                   call errorexit
  4616 00001B04 83C402                   add  sp, 2
  4617                                  
  4618                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4619                                  
  4620 00001B07 C3                       ret
  4621                                  ; ENDP
  4622 00001B08 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4623 00001B11 64647265737300     
  4624                                  
  4625                                  internexit:  ; *** PROC ***
  4626 00001B18 68[221B]                 push internexit_0
  4627 00001B1B E8C9FF                   call errorexit
  4628 00001B1E 83C402                   add  sp, 2
  4629 00001B21 C3                       ret
  4630                                  ; ENDP
  4631 00001B22 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4632 00001B2B 6D70696C6572206572-
  4633 00001B34 726F7200           
  4634                                  ;Back to main program: AS.C
  4635                                  
  4636                                  ;-221 #include "MAIN.C"
  4637                                  
  4638                                  ;Use include file: MAIN.C
  4639                                  
  4640                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4641                                  
  4642                                  
  4643                                  getarg:  ; *** PROC ***
  4644                                  
  4645                                  ;-2   arglen1=*arglen;
  4646                                  
  4647                                  ;Function : getarg, Number of local variables: 3
  4648                                  ;   # type sign width line used address name   list of local variables
  4649                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4650                                  ;  201 var sign word     1 NULL bp-4    i
  4651                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4652 00001B38 C8060000                 ENTER  6,0
  4653 00001B3C 8B1E[5800]               mov bx, [arglen]
  4654 00001B40 8A07                     mov al, [bx]
  4655 00001B42 B400                     mov ah, 0
  4656 00001B44 8946FE                   mov word [bp-2], ax
  4657                                  
  4658                                  ;-3   if (arglen1==0) {
  4659                                  
  4660 00001B47 8B46FE                   mov ax, [bp-2]
  4661 00001B4A 83F800                   cmp ax, 0
  4662 00001B4D 0F851C00                 jne @@getarg199
  4663                                  
  4664                                  ;-4     cputs(Version1);
  4665                                  
  4666 00001B51 8D06[1000]               lea  ax, [Version1]
  4667 00001B55 50                       push ax
  4668 00001B56 E8DC03                   call cputs
  4669 00001B59 83C402                   add  sp, 2
  4670                                  
  4671                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4672                                  
  4673 00001B5C 68[FD1C]                 push getarg_0
  4674 00001B5F E8D303                   call cputs
  4675 00001B62 83C402                   add  sp, 2
  4676                                  
  4677                                  ;-6     exitR(3);
  4678                                  
  4679 00001B65 6A03                     push 3
  4680 00001B67 E8A605                   call exitR
  4681 00001B6A 83C402                   add  sp, 2
  4682                                  
  4683                                  ;-7   }
  4684                                  
  4685                                  
  4686                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4687                                  
  4688                                  @@getarg199:
  4689 00001B6D 8B46FE                   mov ax, [bp-2]
  4690 00001B70 058100                   add ax, 129
  4691 00001B73 8946FC                   mov word [bp-4], ax
  4692 00001B76 66B800000000             mov eax, 0
  4693 00001B7C 8B5EFC                   mov  bx, [bp-4]
  4694 00001B7F 8907                     mov  [bx], ax
  4695 00001B81 FF4EFE                   dec  word [bp-2]
  4696                                  
  4697                                  ;-9   toupper(argv);
  4698                                  
  4699 00001B84 FF36[5A00]               push word [argv]
  4700 00001B88 E8D803                   call toupper
  4701 00001B8B 83C402                   add  sp, 2
  4702                                  
  4703                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4704                                  
  4705 00001B8E FF36[5A00]               push word [argv]
  4706 00001B92 8D06ED75                 lea  ax, [namein]
  4707 00001B96 50                       push ax
  4708 00001B97 E83704                   call strcpy
  4709 00001B9A 83C404                   add  sp, 4
  4710 00001B9D 68[221D]                 push getarg_1
  4711 00001BA0 8D06ED75                 lea  ax, [namein]
  4712 00001BA4 50                       push ax
  4713 00001BA5 E8EA04                   call strcat1
  4714 00001BA8 83C404                   add  sp, 4
  4715                                  
  4716                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4717                                  
  4718 00001BAB FF36[5A00]               push word [argv]
  4719 00001BAF 8D063076                 lea  ax, [namelst]
  4720 00001BB3 50                       push ax
  4721 00001BB4 E81A04                   call strcpy
  4722 00001BB7 83C404                   add  sp, 4
  4723 00001BBA 68[251D]                 push getarg_2
  4724 00001BBD 8D063076                 lea  ax, [namelst]
  4725 00001BC1 50                       push ax
  4726 00001BC2 E8CD04                   call strcat1
  4727 00001BC5 83C404                   add  sp, 4
  4728                                  
  4729                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4730                                  
  4731 00001BC8 FF36[5A00]               push word [argv]
  4732 00001BCC 8D067376                 lea  ax, [namebin]
  4733 00001BD0 50                       push ax
  4734 00001BD1 E8FD03                   call strcpy
  4735 00001BD4 83C404                   add  sp, 4
  4736 00001BD7 68[2A1D]                 push getarg_3
  4737 00001BDA 8D067376                 lea  ax, [namebin]
  4738 00001BDE 50                       push ax
  4739 00001BDF E8B004                   call strcat1
  4740 00001BE2 83C404                   add  sp, 4
  4741                                  
  4742                                  ;-13 
  4743                                  
  4744                                  
  4745                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4746                                  
  4747 00001BE5 66B801000000             mov eax, 1
  4748 00001BEB A2[2500]                 mov byte [LIST], al
  4749 00001BEE 66B800000000             mov eax, 0
  4750 00001BF4 A3[3000]                 mov word [DOS_ERR], ax
  4751 00001BF7 66B800000000             mov eax, 0
  4752 00001BFD A3[3700]                 mov word [PC], ax
  4753 00001C00 66B800000000             mov eax, 0
  4754 00001C06 A3[3200]                 mov word [ErrorCount], ax
  4755                                  
  4756                                  ;-15   asm_fd=openR (namein);
  4757                                  
  4758 00001C09 8D06ED75                 lea  ax, [namein]
  4759 00001C0D 50                       push ax
  4760 00001C0E E8A604                   call openR
  4761 00001C11 83C402                   add  sp, 2
  4762 00001C14 A3[2A00]                 mov word [asm_fd], ax
  4763                                  
  4764                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4765                                  
  4766 00001C17 A1[3000]                 mov ax, [DOS_ERR]
  4767 00001C1A 08C0                     or  al, al
  4768 00001C1C 0F841C00                 je @@getarg200
  4769 00001C20 68[2F1D]                 push getarg_4
  4770 00001C23 E80F03                   call cputs
  4771 00001C26 83C402                   add  sp, 2
  4772 00001C29 8D06ED75                 lea  ax, [namein]
  4773 00001C2D 50                       push ax
  4774 00001C2E E80403                   call cputs
  4775 00001C31 83C402                   add  sp, 2
  4776 00001C34 6A01                     push 1
  4777 00001C36 E8D704                   call exitR
  4778 00001C39 83C402                   add  sp, 2
  4779                                  
  4780                                  ;-17   lst_fd=creatR(namelst);
  4781                                  
  4782                                  @@getarg200:
  4783 00001C3C 8D063076                 lea  ax, [namelst]
  4784 00001C40 50                       push ax
  4785 00001C41 E88204                   call creatR
  4786 00001C44 83C402                   add  sp, 2
  4787 00001C47 A3[2C00]                 mov word [lst_fd], ax
  4788                                  
  4789                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4790                                  
  4791 00001C4A A1[3000]                 mov ax, [DOS_ERR]
  4792 00001C4D 08C0                     or  al, al
  4793 00001C4F 0F841C00                 je @@getarg201
  4794 00001C53 68[451D]                 push getarg_5
  4795 00001C56 E8DC02                   call cputs
  4796 00001C59 83C402                   add  sp, 2
  4797 00001C5C 8D063076                 lea  ax, [namelst]
  4798 00001C60 50                       push ax
  4799 00001C61 E8D102                   call cputs
  4800 00001C64 83C402                   add  sp, 2
  4801 00001C67 6A02                     push 2
  4802 00001C69 E8A404                   call exitR
  4803 00001C6C 83C402                   add  sp, 2
  4804                                  
  4805                                  ;-19   bin_fd=creatR(namebin);
  4806                                  
  4807                                  @@getarg201:
  4808 00001C6F 8D067376                 lea  ax, [namebin]
  4809 00001C73 50                       push ax
  4810 00001C74 E84F04                   call creatR
  4811 00001C77 83C402                   add  sp, 2
  4812 00001C7A A3[2E00]                 mov word [bin_fd], ax
  4813                                  
  4814                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4815                                  
  4816 00001C7D A1[3000]                 mov ax, [DOS_ERR]
  4817 00001C80 08C0                     or  al, al
  4818 00001C82 0F841C00                 je @@getarg202
  4819 00001C86 68[5C1D]                 push getarg_6
  4820 00001C89 E8A902                   call cputs
  4821 00001C8C 83C402                   add  sp, 2
  4822 00001C8F 8D067376                 lea  ax, [namebin]
  4823 00001C93 50                       push ax
  4824 00001C94 E89E02                   call cputs
  4825 00001C97 83C402                   add  sp, 2
  4826 00001C9A 6A02                     push 2
  4827 00001C9C E87104                   call exitR
  4828 00001C9F 83C402                   add  sp, 2
  4829                                  
  4830                                  ;-21   prs(";");prs(Version1);
  4831                                  
  4832                                  @@getarg202:
  4833 00001CA2 68[721D]                 push getarg_7
  4834 00001CA5 E8B1FB                   call prs
  4835 00001CA8 83C402                   add  sp, 2
  4836 00001CAB 8D06[1000]               lea  ax, [Version1]
  4837 00001CAF 50                       push ax
  4838 00001CB0 E8A6FB                   call prs
  4839 00001CB3 83C402                   add  sp, 2
  4840                                  
  4841                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4842                                  
  4843 00001CB6 68[741D]                 push getarg_8
  4844 00001CB9 E89DFB                   call prs
  4845 00001CBC 83C402                   add  sp, 2
  4846 00001CBF 8D06ED75                 lea  ax, [namein]
  4847 00001CC3 50                       push ax
  4848 00001CC4 E892FB                   call prs
  4849 00001CC7 83C402                   add  sp, 2
  4850 00001CCA 68[7F1D]                 push getarg_9
  4851 00001CCD E889FB                   call prs
  4852 00001CD0 83C402                   add  sp, 2
  4853 00001CD3 8D063076                 lea  ax, [namelst]
  4854 00001CD7 50                       push ax
  4855 00001CD8 E87EFB                   call prs
  4856 00001CDB 83C402                   add  sp, 2
  4857                                  
  4858                                  ;-23   prs(", "); prs(namebin);
  4859                                  
  4860 00001CDE 68[8A1D]                 push getarg_10
  4861 00001CE1 E875FB                   call prs
  4862 00001CE4 83C402                   add  sp, 2
  4863 00001CE7 8D067376                 lea  ax, [namebin]
  4864 00001CEB 50                       push ax
  4865 00001CEC E86AFB                   call prs
  4866 00001CEF 83C402                   add  sp, 2
  4867                                  
  4868                                  ;-24   prs("\n");
  4869                                  
  4870 00001CF2 68[8D1D]                 push getarg_11
  4871 00001CF5 E861FB                   call prs
  4872 00001CF8 83C402                   add  sp, 2
  4873                                  
  4874                                  ;-25 }
  4875                                  
  4876                                  
  4877                                  ;-26 int epilog() { int i; int j; char c;
  4878 00001CFB C9                       LEAVE
  4879 00001CFC C3                       ret
  4880                                  ; ENDP
  4881 00001CFD 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4882 00001D06 41532E434F4D206669-
  4883 00001D0F 6C656E616D65205B77-
  4884 00001D18 2F6F202E535D203A20-
  4885 00001D21 00                 
  4886 00001D22 2E5300                  getarg_1 db ".S",0
  4887 00001D25 2E4C535400              getarg_2 db ".LST",0
  4888 00001D2A 2E434F4D00              getarg_3 db ".COM",0
  4889 00001D2F 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4890 00001D38 6C65206D697373696E-
  4891 00001D41 673A2000           
  4892 00001D45 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4893 00001D4E 206E6F742063726561-
  4894 00001D57 74653A2000         
  4895 00001D5C 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4896 00001D65 6E6F74206372656174-
  4897 00001D6E 653A2000           
  4898 00001D72 3B00                    getarg_7 db ";",0
  4899 00001D74 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4900 00001D7D 2000               
  4901 00001D7F 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4902 00001D88 2000               
  4903 00001D8A 2C2000                  getarg_10 db ", ",0
  4904 00001D8D 5C6E00                  getarg_11 db "\n",0
  4905                                  
  4906                                  epilog:  ; *** PROC ***
  4907                                  
  4908                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4909                                  
  4910                                  ;Function : epilog, Number of local variables: 3
  4911                                  ;   # type sign width line used address name   list of local variables
  4912                                  ;  200 var sign word    26 NULL bp-2    i
  4913                                  ;  201 var sign word    26 NULL bp-4    j
  4914                                  ;  202 var sign byte    26 NULL bp-6    c;
  4915 00001D90 C8060000                 ENTER  6,0
  4916 00001D94 68[B91E]                 push epilog_0
  4917 00001D97 E8BFFA                   call prs
  4918 00001D9A 83C402                   add  sp, 2
  4919 00001D9D FF36[3200]               push word [ErrorCount]
  4920 00001DA1 E8D0FB                   call printIntU
  4921 00001DA4 83C402                   add  sp, 2
  4922                                  
  4923                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4924                                  
  4925 00001DA7 A1[3200]                 mov ax, [ErrorCount]
  4926 00001DAA 08C0                     or  al, al
  4927 00001DAC 0F840900                 je @@epilog203
  4928 00001DB0 68[C91E]                 push epilog_1
  4929 00001DB3 E8A3FA                   call prs
  4930 00001DB6 83C402                   add  sp, 2
  4931                                  
  4932                                  ;-29   prs(", Label & Var: ");
  4933                                  
  4934                                  @@epilog203:
  4935 00001DB9 68[D71E]                 push epilog_2
  4936 00001DBC E89AFA                   call prs
  4937 00001DBF 83C402                   add  sp, 2
  4938                                  
  4939                                  ;-30   if (LabelMaxIx) {
  4940                                  
  4941 00001DC2 A1[5200]                 mov ax, [LabelMaxIx]
  4942 00001DC5 08C0                     or  al, al
  4943 00001DC7 0F846900                 je @@epilog204
  4944                                  
  4945                                  ;-31     i = 1;
  4946                                  
  4947 00001DCB 66B801000000             mov eax, 1
  4948 00001DD1 8946FE                   mov word [bp-2], ax
  4949                                  
  4950                                  ;-32     LabelNamePtr= &LabelNames;
  4951                                  
  4952 00001DD4 B8BB76                   mov ax, LabelNames
  4953 00001DD7 A3[5000]                 mov word [LabelNamePtr], ax
  4954                                  
  4955                                  ;-33     do {
  4956                                  
  4957                                  @@epilog205:
  4958                                  
  4959                                  ;-34       prs(LabelNamePtr); prc(' ');
  4960                                  
  4961 00001DDA FF36[5000]               push word [LabelNamePtr]
  4962 00001DDE E878FA                   call prs
  4963 00001DE1 83C402                   add  sp, 2
  4964 00001DE4 6A20                     push 32
  4965 00001DE6 E80FFA                   call prc
  4966 00001DE9 83C402                   add  sp, 2
  4967                                  
  4968                                  ;-35       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4969                                  
  4970 00001DEC 8B5EFE                   mov bx, [bp-2]
  4971 00001DEF D1E3                     shl bx, 1
  4972 00001DF1 8B87A37A                 mov ax, [LabelAddr + bx]
  4973 00001DF5 8946FC                   mov word [bp-4], ax
  4974 00001DF8 FF76FC                   push word [bp-4]
  4975 00001DFB E84CFB                   call printhex16
  4976 00001DFE 83C402                   add  sp, 2
  4977 00001E01 68[E71E]                 push epilog_3
  4978 00001E04 E852FA                   call prs
  4979 00001E07 83C402                   add  sp, 2
  4980                                  
  4981                                  ;-36       j=strlen(LabelNamePtr);//get end of actual name
  4982                                  
  4983 00001E0A FF36[5000]               push word [LabelNamePtr]
  4984 00001E0E E89501                   call strlen
  4985 00001E11 83C402                   add  sp, 2
  4986 00001E14 8946FC                   mov word [bp-4], ax
  4987                                  
  4988                                  ;-37       LabelNamePtr=LabelNamePtr+j;
  4989                                  
  4990 00001E17 A1[5000]                 mov ax, [LabelNamePtr]
  4991 00001E1A 0346FC                   add ax, [bp-4]
  4992 00001E1D A3[5000]                 mov word [LabelNamePtr], ax
  4993                                  
  4994                                  ;-38       LabelNamePtr++;
  4995                                  
  4996 00001E20 FF06[5000]               inc  word [LabelNamePtr]
  4997                                  
  4998                                  ;-39       i++;
  4999                                  
  5000 00001E24 FF46FE                   inc  word [bp-2]
  5001                                  
  5002                                  ;-40     } while (i <= LabelMaxIx);
  5003                                  
  5004 00001E27 8B46FE                   mov ax, [bp-2]
  5005 00001E2A 3B06[5200]               cmp ax, [LabelMaxIx]
  5006 00001E2E 0F8F0200                 jg  @@epilog206
  5007 00001E32 EBA6                     jmp @@epilog205
  5008                                  @@epilog206:
  5009                                  
  5010                                  ;-41   }
  5011                                  
  5012                                  
  5013                                  ;-42   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  5014                                  
  5015                                  @@epilog204:
  5016 00001E34 68[EB1E]                 push epilog_4
  5017 00001E37 E81FFA                   call prs
  5018 00001E3A 83C402                   add  sp, 2
  5019 00001E3D FF36[5600]               push word [BinLen]
  5020 00001E41 E830FB                   call printIntU
  5021 00001E44 83C402                   add  sp, 2
  5022 00001E47 68[F81E]                 push epilog_5
  5023 00001E4A E80CFA                   call prs
  5024 00001E4D 83C402                   add  sp, 2
  5025                                  
  5026                                  ;-43   i=0;
  5027                                  
  5028 00001E50 66B800000000             mov eax, 0
  5029 00001E56 8946FE                   mov word [bp-2], ax
  5030                                  
  5031                                  ;-44   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  5032                                  
  5033                                  @@epilog207:
  5034 00001E59 6A20                     push 32
  5035 00001E5B E89AF9                   call prc
  5036 00001E5E 83C402                   add  sp, 2
  5037 00001E61 8B5EFE                   mov bx, [bp-2]
  5038 00001E64 8A876B7B                 mov al, [FileBin + bx]
  5039 00001E68 8946FC                   mov word [bp-4], ax
  5040 00001E6B FF76FC                   push word [bp-4]
  5041 00001E6E E88BFA                   call printhex8a
  5042 00001E71 83C402                   add  sp, 2
  5043 00001E74 FF46FE                   inc  word [bp-2]
  5044                                  
  5045                                  ;-45   } while (i < BinLen);
  5046                                  
  5047 00001E77 8B46FE                   mov ax, [bp-2]
  5048 00001E7A 3B06[5600]               cmp ax, [BinLen]
  5049 00001E7E 0F8D0200                 jge @@epilog208
  5050 00001E82 EBD5                     jmp @@epilog207
  5051                                  @@epilog208:
  5052                                  
  5053                                  ;-46   i=0;
  5054                                  
  5055 00001E84 66B800000000             mov eax, 0
  5056 00001E8A 8946FE                   mov word [bp-2], ax
  5057                                  
  5058                                  ;-47   do {
  5059                                  
  5060                                  @@epilog209:
  5061                                  
  5062                                  ;-48     c = FileBin[i];
  5063                                  
  5064 00001E8D 8B5EFE                   mov bx, [bp-2]
  5065 00001E90 8A876B7B                 mov al, [FileBin + bx]
  5066 00001E94 8846FA                   mov byte [bp-6], al
  5067                                  
  5068                                  ;-49     fputcR(c, bin_fd);
  5069                                  
  5070 00001E97 FF36[2E00]               push word [bin_fd]
  5071 00001E9B 8A46FA                   mov al, byte [bp-6]
  5072 00001E9E B400                     mov ah, 0
  5073 00001EA0 50                       push ax
  5074 00001EA1 E84902                   call fputcR
  5075 00001EA4 83C404                   add  sp, 4
  5076                                  
  5077                                  ;-50     i++;
  5078                                  
  5079 00001EA7 FF46FE                   inc  word [bp-2]
  5080                                  
  5081                                  ;-51   } while (i < BinLen);
  5082                                  
  5083 00001EAA 8B46FE                   mov ax, [bp-2]
  5084 00001EAD 3B06[5600]               cmp ax, [BinLen]
  5085 00001EB1 0F8D0200                 jge @@epilog210
  5086 00001EB5 EBD6                     jmp @@epilog209
  5087                                  @@epilog210:
  5088                                  
  5089                                  ;-52 }
  5090                                  
  5091                                  
  5092                                  ;-53 int end1(int n) {
  5093 00001EB7 C9                       LEAVE
  5094 00001EB8 C3                       ret
  5095                                  ; ENDP
  5096 00001EB9 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5097 00001EC2 726F72733A2000     
  5098 00001EC9 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5099 00001ED2 2A2A2A2000         
  5100 00001ED7 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  5101 00001EE0 205661723A2000     
  5102 00001EE7 2C202000                epilog_3 db ",  ",0
  5103 00001EEB 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  5104 00001EF4 6C652000           
  5105 00001EF8 2062797465733A00        epilog_5 db " bytes:",0
  5106                                  
  5107                                  end1:  ; *** PROC ***
  5108                                  
  5109                                  ;-54   fcloseR(asm_fd);
  5110                                  
  5111                                  ;Function : end1, Number of local variables: 1
  5112                                  ;   # type sign width line used address name   list of local variables
  5113                                  ;  200 var sign word    53 NULL bp+4    n;
  5114 00001F00 C8000000                 ENTER  0,0
  5115 00001F04 FF36[2A00]               push word [asm_fd]
  5116 00001F08 E8F701                   call fcloseR
  5117 00001F0B 83C402                   add  sp, 2
  5118                                  
  5119                                  ;-55   fcloseR(lst_fd);
  5120                                  
  5121 00001F0E FF36[2C00]               push word [lst_fd]
  5122 00001F12 E8ED01                   call fcloseR
  5123 00001F15 83C402                   add  sp, 2
  5124                                  
  5125                                  ;-56   fcloseR(bin_fd);
  5126                                  
  5127 00001F18 FF36[2E00]               push word [bin_fd]
  5128 00001F1C E8E301                   call fcloseR
  5129 00001F1F 83C402                   add  sp, 2
  5130                                  
  5131                                  ;-57   exitR(n);
  5132                                  
  5133 00001F22 FF7604                   push word [bp+4]
  5134 00001F25 E8E801                   call exitR
  5135 00001F28 83C402                   add  sp, 2
  5136                                  
  5137                                  ;-58 }
  5138 00001F2B C9                       LEAVE
  5139 00001F2C C3                       ret
  5140                                  ; ENDP
  5141                                  ;Back to main program: AS.C
  5142                                   
  5143                                  ; missing functions: 
  5144                                  ; digit
  5145                                  ; strcpy
  5146                                  ; eqstr
  5147                                  ; strlen
  5148                                  ; eqstr
  5149                                  ; eqstr
  5150                                  ; eqstr
  5151                                  ; eqstr
  5152                                  ; readRL
  5153                                  ; readRL
  5154                                  ; digit
  5155                                  ; digit
  5156                                  ; strcpy
  5157                                  ; toupper
  5158                                  ; strlen
  5159                                  ; strlen
  5160                                  ; eqstr
  5161                                  ; eqstr
  5162                                  ; eqstr
  5163                                  ; eqstr
  5164                                  ; eqstr
  5165                                  ; eqstr
  5166                                  ; eqstr
  5167                                  ; eqstr
  5168                                  ; eqstr
  5169                                  ; eqstr
  5170                                  ; eqstr
  5171                                  ; eqstr
  5172                                  ; eqstr
  5173                                  ; eqstr
  5174                                  ; eqstr
  5175                                  ; eqstr
  5176                                  ; eqstr
  5177                                  ; eqstr
  5178                                  ; eqstr
  5179                                  ; eqstr
  5180                                  ; eqstr
  5181                                  ; eqstr
  5182                                  ; eqstr
  5183                                  ; eqstr
  5184                                  ; eqstr
  5185                                  ; eqstr
  5186                                  ; eqstr
  5187                                  ; eqstr
  5188                                  ; eqstr
  5189                                  ; eqstr
  5190                                  ; writetty
  5191                                  ; writetty
  5192                                  ; fputcR
  5193                                  ; cputs
  5194                                  ; cputs
  5195                                  ; exitR
  5196                                  ; toupper
  5197                                  ; strcpy
  5198                                  ; strcat1
  5199                                  ; strcpy
  5200                                  ; strcat1
  5201                                  ; strcpy
  5202                                  ; strcat1
  5203                                  ; openR
  5204                                  ; cputs
  5205                                  ; cputs
  5206                                  ; exitR
  5207                                  ; creatR
  5208                                  ; cputs
  5209                                  ; cputs
  5210                                  ; exitR
  5211                                  ; creatR
  5212                                  ; cputs
  5213                                  ; cputs
  5214                                  ; exitR
  5215                                  ; strlen
  5216                                  ; fputcR
  5217                                  ; fcloseR
  5218                                  ; fcloseR
  5219                                  ; fcloseR
  5220                                  ; exitR
  5221                                  ; Number of unresolved CALLs :   77
  5222                                  ;use archive file: AR.C
  5223                                  
  5224                                  ;-222 // AR.C Archive
  5225                                  
  5226                                  ;Number of CALLs:    2 : writetty
  5227                                  
  5228                                  writetty:  ; *** PROC ***
  5229 00001F2D B40E                     mov  ah, 14
  5230 00001F2F BB0000                   mov  bx, 0
  5231 00001F32 CD10                     int  16
  5232                                  
  5233                                  ;-223 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5234                                  
  5235 00001F34 C3                       ret
  5236                                  ; ENDP
  5237                                  ;Number of CALLs:    8 : cputs
  5238                                  
  5239                                  cputs:  ; *** PROC ***
  5240                                  ;Function : cputs, Number of local variables: 2
  5241                                  ;   # type sign width line used address name   list of local variables
  5242                                  ;  200 ptr sign byte   223 NULL bp+4    s
  5243                                  ;  201 var sign byte   223 NULL bp-2    c;
  5244 00001F35 C8020000                 ENTER  2,0
  5245                                  @@cputs211:
  5246 00001F39 8B5E04                   mov bx, [bp+4]
  5247 00001F3C 8A07                     mov al, [bx]
  5248 00001F3E B400                     mov ah, 0
  5249 00001F40 08C0                     or  al, al
  5250 00001F42 0F841B00                 je @@cputs212
  5251 00001F46 8B5E04                   mov bx, [bp+4]
  5252 00001F49 8A07                     mov al, [bx]
  5253 00001F4B B400                     mov ah, 0
  5254 00001F4D 8846FE                   mov byte [bp-2], al
  5255 00001F50 8A46FE                   mov al, byte [bp-2]
  5256 00001F53 B400                     mov ah, 0
  5257 00001F55 50                       push ax
  5258 00001F56 E8C401                   call putch
  5259 00001F59 83C402                   add  sp, 2
  5260 00001F5C FF4604                   inc  word [bp+4]
  5261 00001F5F EBD8                     jmp @@cputs211
  5262                                  @@cputs212:
  5263                                  
  5264                                  ;-224 int mkneg(int n) { n; __asm {neg ax} }
  5265 00001F61 C9                       LEAVE
  5266 00001F62 C3                       ret
  5267                                  ; ENDP
  5268                                  ;Number of CALLs:    2 : toupper
  5269                                  
  5270                                  toupper:  ; *** PROC ***
  5271                                  ;Function : toupper, Number of local variables: 1
  5272                                  ;   # type sign width line used address name   list of local variables
  5273                                  ;  200 ptr sign byte   224 NULL bp+4    s;
  5274 00001F63 C8000000                 ENTER  0,0
  5275                                  @@toupper213:
  5276 00001F67 8B5E04                   mov bx, [bp+4]
  5277 00001F6A 8A07                     mov al, [bx]
  5278 00001F6C B400                     mov ah, 0
  5279 00001F6E 08C0                     or  al, al
  5280 00001F70 0F843000                 je @@toupper214
  5281 00001F74 8B5E04                   mov bx, [bp+4]
  5282 00001F77 8A07                     mov al, [bx]
  5283 00001F79 B400                     mov ah, 0
  5284 00001F7B 83F861                   cmp ax, 97 ;unsigned : 1
  5285 00001F7E 0F8C1D00                 jl  @@toupper215
  5286 00001F82 8B5E04                   mov bx, [bp+4]
  5287 00001F85 8A07                     mov al, [bx]
  5288 00001F87 B400                     mov ah, 0
  5289 00001F89 83F87A                   cmp ax, 122
  5290 00001F8C 0F8F0F00                 jg  @@toupper216
  5291 00001F90 8B5E04                   mov bx, [bp+4]
  5292 00001F93 8A07                     mov al, [bx]
  5293 00001F95 B400                     mov ah, 0
  5294 00001F97 83E820                   sub ax, 32
  5295 00001F9A 8B5E04                   mov  bx, [bp+4]
  5296 00001F9D 8807                     mov  [bx], al
  5297                                  @@toupper216:
  5298                                  @@toupper215:
  5299 00001F9F FF4604                   inc  word [bp+4]
  5300 00001FA2 EBC3                     jmp @@toupper213
  5301                                  @@toupper214:
  5302                                  
  5303                                  ;-225 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5304                                  
  5305                                  
  5306                                  ;-226 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5307 00001FA4 C9                       LEAVE
  5308 00001FA5 C3                       ret
  5309                                  ; ENDP
  5310                                  ;Number of CALLs:    4 : strlen
  5311                                  
  5312                                  strlen:  ; *** PROC ***
  5313                                  ;Function : strlen, Number of local variables: 2
  5314                                  ;   # type sign width line used address name   list of local variables
  5315                                  ;  200 ptr sign byte   226 NULL bp+4    s
  5316                                  ;  201 var sign word   226 NULL bp-2    c;
  5317 00001FA6 C8020000                 ENTER  2,0
  5318 00001FAA 66B800000000             mov eax, 0
  5319 00001FB0 8946FE                   mov word [bp-2], ax
  5320                                  @@strlen217:
  5321 00001FB3 8B5E04                   mov bx, [bp+4]
  5322 00001FB6 8A07                     mov al, [bx]
  5323 00001FB8 B400                     mov ah, 0
  5324 00001FBA 83F800                   cmp ax, 0
  5325 00001FBD 0F840800                 je  @@strlen218
  5326 00001FC1 FF4604                   inc  word [bp+4]
  5327 00001FC4 FF46FE                   inc  word [bp-2]
  5328 00001FC7 EBEA                     jmp @@strlen217
  5329                                  @@strlen218:
  5330 00001FC9 8B46FE                   mov ax, [bp-2]
  5331 00001FCC E90000                   jmp @@retn
  5332                                  
  5333                                  ;-227 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5334                                  
  5335 00001FCF C9                      @@retn: LEAVE
  5336 00001FD0 C3                       ret
  5337                                  ; ENDP
  5338                                  ;Number of CALLs:    5 : strcpy
  5339                                  
  5340                                  strcpy:  ; *** PROC ***
  5341                                  ;Function : strcpy, Number of local variables: 2
  5342                                  ;   # type sign width line used address name   list of local variables
  5343                                  ;  200 ptr sign byte   227 NULL bp+4    s
  5344                                  ;  201 ptr sign byte   227 NULL bp+6    t;
  5345 00001FD1 C8000000                 ENTER  0,0
  5346                                  @@strcpy219:
  5347 00001FD5 8B5E06                   mov bx, [bp+6]
  5348 00001FD8 8A07                     mov al, [bx]
  5349 00001FDA B400                     mov ah, 0
  5350 00001FDC 8B5E04                   mov  bx, [bp+4]
  5351 00001FDF 8807                     mov  [bx], al
  5352 00001FE1 FF4604                   inc  word [bp+4]
  5353 00001FE4 FF4606                   inc  word [bp+6]
  5354                                  
  5355                                  ;-228   while (*t!=0); *s=0; return s; }
  5356                                  
  5357 00001FE7 8B5E06                   mov bx, [bp+6]
  5358 00001FEA 8A07                     mov al, [bx]
  5359 00001FEC B400                     mov ah, 0
  5360 00001FEE 83F800                   cmp ax, 0
  5361 00001FF1 0F840200                 je  @@strcpy220
  5362 00001FF5 EBDE                     jmp @@strcpy219
  5363                                  @@strcpy220:
  5364 00001FF7 66B800000000             mov eax, 0
  5365 00001FFD 8B5E04                   mov  bx, [bp+4]
  5366 00002000 8807                     mov  [bx], al
  5367 00002002 8B4604                   mov ax, [bp+4]
  5368 00002005 E90000                   jmp @@retn
  5369                                  
  5370                                  ;-229 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5371                                  
  5372 00002008 C9                      @@retn: LEAVE
  5373 00002009 C3                       ret
  5374                                  ; ENDP
  5375                                  ;Number of CALLs:    3 : digit
  5376                                  
  5377                                  digit:  ; *** PROC ***
  5378                                  ;Function : digit, Number of local variables: 1
  5379                                  ;   # type sign width line used address name   list of local variables
  5380                                  ;  200 var sign byte   229 NULL bp+4    c;
  5381 0000200A C8000000                 ENTER  0,0
  5382 0000200E 8A4604                   mov al, [bp+4]
  5383 00002011 3C30                     cmp al, 48
  5384 00002013 0F8D0900                 jge @@digit221
  5385 00002017 66B800000000             mov eax, 0
  5386 0000201D E91B00                   jmp @@retn
  5387                                  @@digit221:
  5388 00002020 8A4604                   mov al, [bp+4]
  5389 00002023 3C39                     cmp al, 57
  5390 00002025 0F8E0900                 jle @@digit222
  5391 00002029 66B800000000             mov eax, 0
  5392 0000202F E90900                   jmp @@retn
  5393                                  @@digit222:
  5394 00002032 66B801000000             mov eax, 1
  5395 00002038 E90000                   jmp @@retn
  5396                                  
  5397                                  ;-230 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5398                                  
  5399 0000203B C9                      @@retn: LEAVE
  5400 0000203C C3                       ret
  5401                                  ; ENDP
  5402                                  ;Number of CALLs:   35 : eqstr
  5403                                  
  5404                                  eqstr:  ; *** PROC ***
  5405                                  ;Function : eqstr, Number of local variables: 2
  5406                                  ;   # type sign width line used address name   list of local variables
  5407                                  ;  200 ptr sign byte   230 NULL bp+4    p
  5408                                  ;  201 ptr sign byte   230 NULL bp+6    q;
  5409 0000203D C8000000                 ENTER  0,0
  5410                                  @@eqstr223:
  5411 00002041 8B5E04                   mov bx, [bp+4]
  5412 00002044 8A07                     mov al, [bx]
  5413 00002046 B400                     mov ah, 0
  5414 00002048 08C0                     or  al, al
  5415 0000204A 0F842300                 je @@eqstr224
  5416                                  
  5417                                  ;-231     if (*p != *q) return 0; p++; q++; }
  5418                                  
  5419 0000204E 8B5E04                   mov bx, [bp+4]
  5420 00002051 8A07                     mov al, [bx]
  5421 00002053 B400                     mov ah, 0
  5422 00002055 8B5E06                   mov bx, [bp+6]
  5423 00002058 3A07                     cmp al, [bx]
  5424 0000205A B400                     mov ah, 0
  5425 0000205C 0F840900                 je  @@eqstr225
  5426 00002060 66B800000000             mov eax, 0
  5427 00002066 E92700                   jmp @@retn
  5428                                  @@eqstr225:
  5429 00002069 FF4604                   inc  word [bp+4]
  5430 0000206C FF4606                   inc  word [bp+6]
  5431                                  
  5432                                  ;-232     if(*q) return 0; return 1; }
  5433                                  
  5434 0000206F EBD0                     jmp @@eqstr223
  5435                                  @@eqstr224:
  5436 00002071 8B5E06                   mov bx, [bp+6]
  5437 00002074 8A07                     mov al, [bx]
  5438 00002076 B400                     mov ah, 0
  5439 00002078 08C0                     or  al, al
  5440 0000207A 0F840900                 je @@eqstr226
  5441 0000207E 66B800000000             mov eax, 0
  5442 00002084 E90900                   jmp @@retn
  5443                                  @@eqstr226:
  5444 00002087 66B801000000             mov eax, 1
  5445 0000208D E90000                   jmp @@retn
  5446                                  
  5447                                  ;-233 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5448                                  
  5449 00002090 C9                      @@retn: LEAVE
  5450 00002091 C3                       ret
  5451                                  ; ENDP
  5452                                  ;Number of CALLs:    3 : strcat1
  5453                                  
  5454                                  strcat1:  ; *** PROC ***
  5455                                  ;Function : strcat1, Number of local variables: 2
  5456                                  ;   # type sign width line used address name   list of local variables
  5457                                  ;  200 ptr sign byte   233 NULL bp+4    s
  5458                                  ;  201 ptr sign byte   233 NULL bp+6    t;
  5459 00002092 C8000000                 ENTER  0,0
  5460                                  @@strcat1227:
  5461 00002096 8B5E04                   mov bx, [bp+4]
  5462 00002099 8A07                     mov al, [bx]
  5463 0000209B B400                     mov ah, 0
  5464 0000209D 83F800                   cmp ax, 0
  5465 000020A0 0F840500                 je  @@strcat1228
  5466 000020A4 FF4604                   inc  word [bp+4]
  5467 000020A7 EBED                     jmp @@strcat1227
  5468                                  @@strcat1228:
  5469 000020A9 FF7606                   push word [bp+6]
  5470 000020AC FF7604                   push word [bp+4]
  5471 000020AF E81FFF                   call strcpy
  5472 000020B2 83C404                   add  sp, 4
  5473                                  
  5474                                  ;-234 int basename(char *s) { char *p; p=0;
  5475 000020B5 C9                       LEAVE
  5476 000020B6 C3                       ret
  5477                                  ; ENDP
  5478                                  ;Number of CALLs:    1 : openR
  5479                                  
  5480                                  openR:  ; *** PROC ***
  5481                                  ;Function : openR, Number of local variables: 1
  5482                                  ;   # type sign width line used address name   list of local variables
  5483                                  ;  200 ptr sign byte   234 NULL bp+4    s;
  5484 000020B7 C8000000                 ENTER  0,0
  5485 000020BB 8B5604                   mov  dx, [bp+4]
  5486 000020BE B8023D                   mov  ax, 15618
  5487 000020C1 E87200                   call DosInt
  5488                                  
  5489                                  ;-235 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5490 000020C4 C9                       LEAVE
  5491 000020C5 C3                       ret
  5492                                  ; ENDP
  5493                                  ;Number of CALLs:    2 : creatR
  5494                                  
  5495                                  creatR:  ; *** PROC ***
  5496                                  ;Function : creatR, Number of local variables: 1
  5497                                  ;   # type sign width line used address name   list of local variables
  5498                                  ;  200 ptr sign byte   235 NULL bp+4    s;
  5499 000020C6 C8000000                 ENTER  0,0
  5500 000020CA 8B5604                   mov  dx, [bp+4]
  5501 000020CD B90000                   mov  cx, 0
  5502 000020D0 B8003C                   mov  ax, 15360
  5503 000020D3 E86000                   call DosInt
  5504                                  
  5505                                  ;-236 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5506 000020D6 C9                       LEAVE
  5507 000020D7 C3                       ret
  5508                                  ; ENDP
  5509                                  ;Number of CALLs:    2 : readRL
  5510                                  
  5511                                  readRL:  ; *** PROC ***
  5512                                  ;Function : readRL, Number of local variables: 3
  5513                                  ;   # type sign width line used address name   list of local variables
  5514                                  ;  200 ptr sign byte   236 NULL bp+4    s
  5515                                  ;  201 var sign word   236 NULL bp+6    fd
  5516                                  ;  202 var sign word   236 NULL bp+8    len;
  5517 000020D8 C8000000                 ENTER  0,0
  5518 000020DC 8B5604                   mov  dx, [bp+4]
  5519 000020DF 8B4E08                   mov  cx, [bp+8]
  5520 000020E2 8B5E06                   mov  bx, [bp+6]
  5521 000020E5 B8003F                   mov  ax, 16128
  5522 000020E8 E84B00                   call DosInt
  5523                                  
  5524                                  ;-237 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5525 000020EB C9                       LEAVE
  5526 000020EC C3                       ret
  5527                                  ; ENDP
  5528                                  ;Number of CALLs:    2 : fputcR
  5529                                  
  5530                                  fputcR:  ; *** PROC ***
  5531                                  ;Function : fputcR, Number of local variables: 2
  5532                                  ;   # type sign width line used address name   list of local variables
  5533                                  ;  200 ptr sign byte   237 NULL bp+4    n
  5534                                  ;  201 var sign word   237 NULL bp+6    fd;
  5535 000020ED C8000000                 ENTER  0,0
  5536 000020F1 8D5604                  lea dx, [bp+4]
  5537                                  
  5538                                  ;-238   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5539                                  
  5540 000020F4 B90100                   mov  cx, 1
  5541 000020F7 8B5E06                   mov  bx, [bp+6]
  5542 000020FA B80040                   mov  ax, 16384
  5543 000020FD E83600                   call DosInt
  5544                                  
  5545                                  ;-239 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5546 00002100 C9                       LEAVE
  5547 00002101 C3                       ret
  5548                                  ; ENDP
  5549                                  ;Number of CALLs:    3 : fcloseR
  5550                                  
  5551                                  fcloseR:  ; *** PROC ***
  5552                                  ;Function : fcloseR, Number of local variables: 1
  5553                                  ;   # type sign width line used address name   list of local variables
  5554                                  ;  200 var sign word   239 NULL bp+4    fd;
  5555 00002102 C8000000                 ENTER  0,0
  5556 00002106 8B5E04                   mov  bx, [bp+4]
  5557 00002109 B8003E                   mov  ax, 15872
  5558 0000210C CD21                     int  33
  5559                                  
  5560                                  ;-240 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5561 0000210E C9                       LEAVE
  5562 0000210F C3                       ret
  5563                                  ; ENDP
  5564                                  ;Number of CALLs:    5 : exitR
  5565                                  
  5566                                  exitR:  ; *** PROC ***
  5567                                  ;Function : exitR, Number of local variables: 1
  5568                                  ;   # type sign width line used address name   list of local variables
  5569                                  ;  200 var sign byte   240 NULL bp+4    c;
  5570 00002110 C8000000                 ENTER  0,0
  5571 00002114 B44C                     mov  ah, 76
  5572 00002116 8A4604                   mov  al, [bp+4]
  5573 00002119 CD21                     int  33
  5574                                  
  5575                                  ;-241 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5576 0000211B C9                       LEAVE
  5577 0000211C C3                       ret
  5578                                  ; ENDP
  5579                                  ;End of archive file. 
  5580                                   
  5581                                  ; missing functions: 
  5582                                  ; putch
  5583                                  ; DosInt
  5584                                  ; DosInt
  5585                                  ; DosInt
  5586                                  ; DosInt
  5587                                  ; Number of unresolved CALLs :    5
  5588                                  ;use archive file: AR.C
  5589                                  
  5590                                  ;-242 // AR.C Archive
  5591                                  
  5592                                  ;Number of CALLs:    1 : putch
  5593                                  
  5594                                  putch:  ; *** PROC ***
  5595                                  ;Function : putch, Number of local variables: 1
  5596                                  ;   # type sign width line used address name   list of local variables
  5597                                  ;  200 var sign byte   242 NULL bp+4    c;
  5598 0000211D C8000000                 ENTER  0,0
  5599 00002121 807E040A                cmp byte [bp+4], 10
  5600 00002125 0F850500                 jne @@putch229
  5601 00002129 B00D                     mov  al, 13
  5602 0000212B E8FFFD                   call writetty
  5603                                  @@putch229:
  5604 0000212E 8A4604                   mov  al, [bp+4]
  5605 00002131 E8F9FD                   call writetty
  5606                                  
  5607                                  ;-243 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5608 00002134 C9                       LEAVE
  5609 00002135 C3                       ret
  5610                                  ; ENDP
  5611                                  ;Number of CALLs:    4 : DosInt
  5612                                  
  5613                                  DosInt:  ; *** PROC ***
  5614 00002136 CD21                     int  33
  5615 00002138 7304                     jae short @@DosInt230
  5616 0000213A FF06[3000]               inc  word [DOS_ERR]
  5617                                  @@DosInt230:
  5618                                  
  5619                                  ;-244 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5620                                  
  5621 0000213E C3                       ret
  5622                                  ; ENDP
  5623                                  ;End of archive file. 
  5624                                   
  5625                                  ; missing functions:  All FUNCTIONs in place
  5626 0000213F E80000                  LastFunctionByt:db 0E8h, 0, 0
  5627 00002142 58                      pop ax
  5628 00002143 C3                      ret
  5629                                   
  5630                                  ;   # type sign width line used  address name   list of global variables
  5631                                  
  5632                                  ;    1 arr sign byte     2    2        0 Version1[20]
  5633                                  ;    2 var sign byte     1    3        0 LIST
  5634                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5635                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5636                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5637                                  ;    6 var unsg word     5   12        0 SymbolInt
  5638                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5639                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5640                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5641                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5642                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5643                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5644                                  ;   13 var sign word    12    4        0 asm_fd
  5645                                  ;   14 var sign word    13    3        0 lst_fd
  5646                                  ;   15 var sign word    14    3        0 bin_fd
  5647                                  ;   16 var sign word    15    6        0 DOS_ERR
  5648                                  ;   17 var sign word    16    4        0 ErrorCount
  5649                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5650                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5651                                  ;   20 var unsg word    20    5        0 PC
  5652                                  ;   21 var unsg word    21    2        0 PCStart
  5653                                  ;   22 var sign byte    22    3        0 isLabel
  5654                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5655                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5656                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5657                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5658                                  ;   27 var sign byte    27   20        0 TokeType
  5659                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5660                                  ;   29 def unsg byte    29    -        0 WORD=2
  5661                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5662                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5663                                  ;   32 def unsg byte    33    -        0 IMM=1
  5664                                  ;   33 def unsg byte    34    -        0 REG=2
  5665                                  ;   34 def unsg byte    35    -        0 ADR=3
  5666                                  ;   35 def unsg byte    36    -        0 MEM=4
  5667                                  ;   36 var sign byte    37   14        0 Op1
  5668                                  ;   37 var sign byte    38   11        0 CodeType
  5669                                  ;   38 var sign byte    39    4        0 Code1
  5670                                  ;   39 var sign byte    40    4        0 Code2
  5671                                  ;   40 var sign byte    41    3        0 Code3
  5672                                  ;   41 var sign byte    42   17        0 RegType
  5673                                  ;   42 var sign byte    43   10        0 RegNo
  5674                                  ;   43 var sign byte    44   10        0 OpSize
  5675                                  ;   44 var sign byte    45    4        0 wflag
  5676                                  ;   45 var sign byte    50   16        0 regindexbase
  5677                                  ;   46 var sign word    51   13        0 disp
  5678                                  ;   47 var sign word    52    2        0 imme
  5679                                  ;   48 def unsg byte    54    -        0 OPMAXLEN=5
  5680                                  ;   49 arr sign byte    55    2    30390 OpPos[5]
  5681                                  ;   50 var sign word    56    6        0 OpPrintIndex
  5682                                  ;   51 ptr sign byte    57   17        0 OpCodePtr
  5683                                  ;   52 var sign byte    58    2        0 PrintR
  5684                                  ;   53 def unsg byte    60    -        0 LABELNAMESMAX=969
  5685                                  ;   54 arr sign byte    61    3    30395 LabelNames[1000]
  5686                                  ;   55 ptr sign byte    62   10        0 LabelNamePtr
  5687                                  ;   56 def unsg byte    63    -        0 LABELADRMAX=100
  5688                                  ;   57 arr unsg word    64    4    31395 LabelAddr[100]
  5689                                  ;   58 var sign word    65    5        0 LabelMaxIx
  5690                                  ;   59 var sign word    66    4        0 LabelIx
  5691                                  ;   60 def unsg byte    68    -        0 FILEBINMAX=1990
  5692                                  ;   61 arr sign byte    69    3    31595 FileBin[2000]
  5693                                  ;   62 var unsg word    70    5        0 BinLen
  5694                                  ;   63 ptr sign byte    72    1        0 arglen
  5695                                  ;   64 ptr sign byte    73    4        0 argv
  5696                                  ;   65 var sign byte     1    1        0 I_START
  5697                                  ;   66 arr sign byte     4 NULL        0 I_PUSHA[9]
  5698                                  ;   67 arr sign byte     5 NULL        0 I_POPA[8]
  5699                                  ;   68 arr sign byte     6 NULL        0 I_NOP[7]
  5700                                  ;   69 arr sign byte     7 NULL        0 I_CBW[7]
  5701                                  ;   70 arr sign byte     8 NULL        0 I_CWDE[8]
  5702                                  ;   71 arr sign byte     9 NULL        0 I_CWD[7]
  5703                                  ;   72 arr sign byte    10 NULL        0 I_CDQ[7]
  5704                                  ;   73 arr sign byte    11 NULL        0 I_WAIT[8]
  5705                                  ;   74 arr sign byte    12 NULL        0 I_PUSHF[9]
  5706                                  ;   75 arr sign byte    13 NULL        0 I_POPF[8]
  5707                                  ;   76 arr sign byte    14 NULL        0 I_SAHF[8]
  5708                                  ;   77 arr sign byte    15 NULL        0 I_LAHF[8]
  5709                                  ;   78 arr sign byte    16 NULL        0 I_MOVSB[9]
  5710                                  ;   79 arr sign byte    17 NULL        0 I_MOVSW[9]
  5711                                  ;   80 arr sign byte    18 NULL        0 I_CMPSB[9]
  5712                                  ;   81 arr sign byte    19 NULL        0 I_CMPSW[9]
  5713                                  ;   82 arr sign byte    20 NULL        0 I_STOSB[9]
  5714                                  ;   83 arr sign byte    21 NULL        0 I_STOSW[9]
  5715                                  ;   84 arr sign byte    22 NULL        0 I_LODSB[9]
  5716                                  ;   85 arr sign byte    23 NULL        0 I_LODSW[9]
  5717                                  ;   86 arr sign byte    24 NULL        0 I_SCASB[9]
  5718                                  ;   87 arr sign byte    25 NULL        0 I_SCASW[9]
  5719                                  ;   88 arr sign byte    26 NULL        0 I_LEAVE[9]
  5720                                  ;   89 arr sign byte    27 NULL        0 I_IRET[8]
  5721                                  ;   90 arr sign byte    28 NULL        0 I_XLAT[8]
  5722                                  ;   91 arr sign byte    29 NULL        0 I_LOCK[8]
  5723                                  ;   92 arr sign byte    30 NULL        0 I_REPNE[9]
  5724                                  ;   93 arr sign byte    31 NULL        0 I_REPNZ[9]
  5725                                  ;   94 arr sign byte    32 NULL        0 I_REPE[8]
  5726                                  ;   95 arr sign byte    33 NULL        0 I_REPZ[8]
  5727                                  ;   96 arr sign byte    34 NULL        0 I_HLT[7]
  5728                                  ;   97 arr sign byte    35 NULL        0 I_CLC[7]
  5729                                  ;   98 arr sign byte    36 NULL        0 I_STC[7]
  5730                                  ;   99 arr sign byte    37 NULL        0 I_CLI[7]
  5731                                  ;  100 arr sign byte    38 NULL        0 I_STI[7]
  5732                                  ;  101 arr sign byte    39 NULL        0 I_CLD[7]
  5733                                  ;  102 arr sign byte    40 NULL        0 I_STD[7]
  5734                                  ;  103 arr sign byte    42 NULL        0 I_INC[9]
  5735                                  ;  104 arr sign byte    43 NULL        0 I_DEC[9]
  5736                                  ;  105 arr sign byte    44 NULL        0 I_NOT[8]
  5737                                  ;  106 arr sign byte    45 NULL        0 I_NEG[8]
  5738                                  ;  107 arr sign byte    46 NULL        0 I_MUL[8]
  5739                                  ;  108 arr sign byte    47 NULL        0 I_IMUL[9]
  5740                                  ;  109 arr sign byte    48 NULL        0 I_DIV[8]
  5741                                  ;  110 arr sign byte    49 NULL        0 I_IDIV[9]
  5742                                  ;  111 arr sign byte    51 NULL        0 I_LES[7]
  5743                                  ;  112 arr sign byte    52 NULL        0 I_LDS[7]
  5744                                  ;  113 arr sign byte    53 NULL        0 I_LEA[7]
  5745                                  ;  114 arr sign byte    55 NULL        0 I_ADD[7]
  5746                                  ;  115 arr sign byte    56 NULL        0 I_OR[6]
  5747                                  ;  116 arr sign byte    57 NULL        0 I_ADC[7]
  5748                                  ;  117 arr sign byte    58 NULL        0 I_SBB[7]
  5749                                  ;  118 arr sign byte    59 NULL        0 I_AND[7]
  5750                                  ;  119 arr sign byte    60 NULL        0 I_SUB[7]
  5751                                  ;  120 arr sign byte    61 NULL        0 I_XOR[7]
  5752                                  ;  121 arr sign byte    62 NULL        0 I_CMP[7]
  5753                                  ;  122 arr sign byte    64 NULL        0 I_MOV[6]
  5754                                  ;  123 arr sign byte    65 NULL        0 I_MOVSX[9]
  5755                                  ;  124 arr sign byte    66 NULL        0 I_MOVZX[9]
  5756                                  ;  125 arr sign byte    68 NULL        0 I_JO[6]
  5757                                  ;  126 arr sign byte    69 NULL        0 I_JNO[7]
  5758                                  ;  127 arr sign byte    70 NULL        0 I_JB[6]
  5759                                  ;  128 arr sign byte    71 NULL        0 I_JC[6]
  5760                                  ;  129 arr sign byte    72 NULL        0 I_JNB[7]
  5761                                  ;  130 arr sign byte    73 NULL        0 I_JAE[7]
  5762                                  ;  131 arr sign byte    74 NULL        0 I_JNC[7]
  5763                                  ;  132 arr sign byte    75 NULL        0 I_JE[6]
  5764                                  ;  133 arr sign byte    76 NULL        0 I_JZ[6]
  5765                                  ;  134 arr sign byte    77 NULL        0 I_JNE[7]
  5766                                  ;  135 arr sign byte    78 NULL        0 I_JNZ[7]
  5767                                  ;  136 arr sign byte    79 NULL        0 I_JBE[7]
  5768                                  ;  137 arr sign byte    80 NULL        0 I_JNA[7]
  5769                                  ;  138 arr sign byte    81 NULL        0 I_JA[6]
  5770                                  ;  139 arr sign byte    82 NULL        0 I_JS[6]
  5771                                  ;  140 arr sign byte    83 NULL        0 I_JNS[7]
  5772                                  ;  141 arr sign byte    84 NULL        0 I_JP[6]
  5773                                  ;  142 arr sign byte    85 NULL        0 I_JPE[7]
  5774                                  ;  143 arr sign byte    86 NULL        0 I_JNP[7]
  5775                                  ;  144 arr sign byte    87 NULL        0 I_JPO[7]
  5776                                  ;  145 arr sign byte    88 NULL        0 I_JL[6]
  5777                                  ;  146 arr sign byte    89 NULL        0 I_JNL[7]
  5778                                  ;  147 arr sign byte    90 NULL        0 I_JGE[7]
  5779                                  ;  148 arr sign byte    91 NULL        0 I_JLE[7]
  5780                                  ;  149 arr sign byte    92 NULL        0 I_JNG[7]
  5781                                  ;  150 arr sign byte    93 NULL        0 I_JG[6]
  5782                                  ;  151 arr sign byte    95 NULL        0 I_JMP[8]
  5783                                  ;  152 arr sign byte    96 NULL        0 I_CALL[9]
  5784                                  ;  153 arr sign byte    98 NULL        0 I_RET[8]
  5785                                  ;  154 arr sign byte    99 NULL        0 I_RETF[9]
  5786                                  ;  155 arr sign byte   101 NULL        0 I_PUSH[8]
  5787                                  ;  156 arr sign byte   102 NULL        0 I_POP[7]
  5788                                  ;  157 arr sign byte   104 NULL        0 I_ROL[7]
  5789                                  ;  158 arr sign byte   105 NULL        0 I_ROR[7]
  5790                                  ;  159 arr sign byte   106 NULL        0 I_RCL[7]
  5791                                  ;  160 arr sign byte   107 NULL        0 I_RCR[7]
  5792                                  ;  161 arr sign byte   108 NULL        0 I_SHL[7]
  5793                                  ;  162 arr sign byte   109 NULL        0 I_SAL[7]
  5794                                  ;  163 arr sign byte   110 NULL        0 I_SHR[7]
  5795                                  ;  164 arr sign byte   111 NULL        0 I_SAR[7]
  5796                                  ;  165 arr sign byte   113 NULL        0 I_INT[8]
  5797                                  ;  166 arr sign byte   114 NULL        0 I_INTO[8]
  5798                                  ;  167 arr sign byte   116 NULL        0 I_IN[7]
  5799                                  ;  168 arr sign byte   117 NULL        0 I_INSB[8]
  5800                                  ;  169 arr sign byte   118 NULL        0 I_INSW[8]
  5801                                  ;  170 arr sign byte   119 NULL        0 I_INSD[8]
  5802                                  ;  171 arr sign byte   120 NULL        0 I_OUT[8]
  5803                                  ;  172 arr sign byte   121 NULL        0 I_OUTSB[8]
  5804                                  ;  173 arr sign byte   122 NULL        0 I_OUTSW[8]
  5805                                  ;  174 arr sign byte   123 NULL        0 I_OUTSD[8]
  5806                                  ;  175 arr sign byte   125 NULL        0 I_XCHG[9]
  5807                                  ;  176 arr sign byte   127 NULL        0 I_LOOPNZ[10]
  5808                                  ;  177 arr sign byte   128 NULL        0 I_LOOPNE[10]
  5809                                  ;  178 arr sign byte   129 NULL        0 I_LOOPZ[9]
  5810                                  ;  179 arr sign byte   130 NULL        0 I_LOOPE[9]
  5811                                  ;  180 arr sign byte   131 NULL        0 I_LOOP[8]
  5812                                  ;  181 arr sign byte   132 NULL        0 I_JCXZ[8]
  5813                                  ;  182 arr sign byte   133 NULL        0 I_JECXZ[9]
  5814                                  ;  183 arr sign byte   135 NULL        0 I_ENTER[9]
  5815                                  ;  184 arr sign byte   137 NULL        0 I_ORG[6]
  5816                                  ;  185 arr sign byte   138 NULL        0 I_DB[5]
  5817                                  ;  186 arr sign byte   139 NULL        0 I_DW[5]
  5818                                  ;  187 arr sign byte   140 NULL        0 I_DD[5]
  5819                                  ;  188 arr sign byte   141 NULL        0 I_RESB[7]
  5820                                  ;  189 arr sign byte   142 NULL        0 I_RESW[7]
  5821                                  ;  190 arr sign byte   143 NULL        0 I_RESD[7]
  5822                                  ;  191 var sign byte   144 NULL        0 I_END
  5823                                  
  5824                                  
  5825                                  ;   # Calls Line Width  Name   list of functions
  5826                                  
  5827                                  ;    0 NULL    1 word   main
  5828                                  ;    1    1    6 word   process
  5829                                  ;    2    1   45 word   setwflag
  5830                                  ;    3 NULL   57 word   Check2Op
  5831                                  ;    4    1   59 word   checkLeftOp
  5832                                  ;    5 NULL   70 word   saveLeftOp
  5833                                  ;    6 NULL   72 word   checkRightOp
  5834                                  ;    7    1   84 word   getOp
  5835                                  ;    8    2   97 word   getOp1
  5836                                  ;    9    1  113 word   getMEM
  5837                                  ;   10    1  133 word   getIndReg1
  5838                                  ;   11    1  141 word   getIndReg2
  5839                                  ;   12    1  152 word   getCodes
  5840                                  ;   13    1  157 word   gen66h
  5841                                  ;   14    3  159 word   genCode
  5842                                  ;   15   11  163 word   genCode8
  5843                                  ;   16    3  173 word   genCode16
  5844                                  ;   17    1  177 word   writeEA
  5845                                  ;   18 NULL  208 word   testx
  5846                                  ;   19    1    1 word   parse
  5847                                  ;   20   12   27 word   getTokeType
  5848                                  ;   21    2   36 word   storeLabel
  5849                                  ;   22    2   43 word   searchLabel
  5850                                  ;   23    1   54 word   getVariable
  5851                                  ;   24    2   83 word   lookCode
  5852                                  ;   25    1   97 word   getCodeSize
  5853                                  ;   26    7  104 word   isToken
  5854                                  ;   27    1  109 word   skipRest
  5855                                  ;   28    1    1 word   getLine
  5856                                  ;   29    1   14 word   ifEOL
  5857                                  ;   30    3   21 word   skipBlank
  5858                                  ;   31    2   26 word   letterE
  5859                                  ;   32    1   36 word   alnumE
  5860                                  ;   33    1   41 word   getDigit
  5861                                  ;   34    1   53 word   getName
  5862                                  ;   35    1   70 word   testReg
  5863                                  ;   36    1    1 word   printLine
  5864                                  ;   37    9   19 word   prc
  5865                                  ;   38    1   23 word   prscomment
  5866                                  ;   39   28   26 word   prs
  5867                                  ;   40    9   31 word   printhex8a
  5868                                  ;   41    2   35 word   printhex16
  5869                                  ;   42    3   38 word   printIntU
  5870                                  ;   43   20   45 word   error1
  5871                                  ;   44 NULL   48 word   allowederror
  5872                                  ;   45 NULL   49 word   implmerror
  5873                                  ;   46    4   50 word   indexerror
  5874                                  ;   47    1   51 word   numbererror
  5875                                  ;   48 NULL   52 word   regmemerror
  5876                                  ;   49    1   53 word   segregerror
  5877                                  ;   50    1   54 word   syntaxerror
  5878                                  ;   51    7   56 word   errorexit
  5879                                  ;   52    1   57 word   addrexit
  5880                                  ;   53 NULL   58 word   internexit
  5881                                  ;   54    1    1 word   getarg
  5882                                  ;   55    1   26 word   epilog
  5883                                  ;   56    2   53 word   end1
  5884                                  ;   57    4  222 word   writetty
  5885                                  ;   58    8  223 word   cputs
  5886                                  ;   59    2  224 word   toupper
  5887                                  ;   60    4  226 word   strlen
  5888                                  ;   61    6  227 word   strcpy
  5889                                  ;   62    3  229 word   digit
  5890                                  ;   63   35  230 word   eqstr
  5891                                  ;   64    3  233 word   strcat1
  5892                                  ;   65    1  234 word   openR
  5893                                  ;   66    2  235 word   creatR
  5894                                  ;   67    2  236 word   readRL
  5895                                  ;   68    2  237 word   fputcR
  5896                                  ;   69    3  239 word   fcloseR
  5897                                  ;   70    5  240 word   exitR
  5898                                  ;   71    1  242 word   putch
  5899                                  ;   72    4  243 word   DosInt
  5900                                  ;   73 NULL  244 word   LastFunctionByt
  5901                                  
  5902                                  ;    #  addr name   list of CALLs
  5903                                  
  5904                                  ;    0     5 getarg
  5905                                  ;    1    12 parse
  5906                                  ;    2    18 epilog
  5907                                  ;    3    25 end1
  5908                                  ;    4  1382 getTokeType
  5909                                  ;    5  1394 getCodeSize
  5910                                  ;    6  1406 getCodes
  5911                                  ;    7  1415 genCode8
  5912                                  ;    8  1424 checkLeftOp
  5913                                  ;    9  1436 genCode
  5914                                  ;   10  1444 genCode
  5915                                  ;   11  1452 genCode
  5916                                  ;   12  1460 writeEA
  5917                                  ;   13  1468 genCode8
  5918                                  ;   14  1477 genCode16
  5919                                  ;   15  1487 genCode8
  5920                                  ;   16  1496 error1
  5921                                  ;   17  1503 error1
  5922                                  ;   18  1519 gen66h
  5923                                  ;   19  1558 getOp
  5924                                  ;   20  1564 segregerror
  5925                                  ;   21  1576 setwflag
  5926                                  ;   22  1585 error1
  5927                                  ;   23  1592 error1
  5928                                  ;   24  1599 error1
  5929                                  ;   25  1641 getOp1
  5930                                  ;   26  1648 isToken
  5931                                  ;   27  1656 getMEM
  5932                                  ;   28  1663 error1
  5933                                  ;   29  1670 error1
  5934                                  ;   30  1684 testReg
  5935                                  ;   31  1692 searchLabel
  5936                                  ;   32  1704 error1
  5937                                  ;   33  1722 getTokeType
  5938                                  ;   34  1734 getOp1
  5939                                  ;   35  1741 syntaxerror
  5940                                  ;   36  1753 getIndReg2
  5941                                  ;   37  1764 getIndReg1
  5942                                  ;   38  1775 isToken
  5943                                  ;   39  1783 getTokeType
  5944                                  ;   40  1795 numbererror
  5945                                  ;   41  1807 isToken
  5946                                  ;   42  1815 isToken
  5947                                  ;   43  1823 errorexit
  5948                                  ;   44  1844 indexerror
  5949                                  ;   45  1855 indexerror
  5950                                  ;   46  1879 indexerror
  5951                                  ;   47  1890 indexerror
  5952                                  ;   48  1917 genCode8
  5953                                  ;   49  1938 genCode8
  5954                                  ;   50  1970 genCode8
  5955                                  ;   51  1979 genCode8
  5956                                  ;   52  2004 prs
  5957                                  ;   53  2008 printhex8a
  5958                                  ;   54  2019 prs
  5959                                  ;   55  2023 printhex8a
  5960                                  ;   56  2034 addrexit
  5961                                  ;   57  2043 prs
  5962                                  ;   58  2047 printhex8a
  5963                                  ;   59  2058 prs
  5964                                  ;   60  2062 printhex8a
  5965                                  ;   61  2073 prs
  5966                                  ;   62  2077 printhex8a
  5967                                  ;   63  2088 genCode8
  5968                                  ;   64  2097 genCode8
  5969                                  ;   65  2106 genCode16
  5970                                  ;   66  2128 getLine
  5971                                  ;   67  2136 getTokeType
  5972                                  ;   68  2148 storeLabel
  5973                                  ;   69  2159 getTokeType
  5974                                  ;   70  2171 lookCode
  5975                                  ;   71  2180 process
  5976                                  ;   72  2188 getVariable
  5977                                  ;   73  2200 skipRest
  5978                                  ;   74  2209 error1
  5979                                  ;   75  2216 error1
  5980                                  ;   76  2223 printLine
  5981                                  ;   77  2247 skipBlank
  5982                                  ;   78  2257 digit
  5983                                  ;   79  2263 getDigit
  5984                                  ;   80  2272 letterE
  5985                                  ;   81  2280 getName
  5986                                  ;   82  2299 searchLabel
  5987                                  ;   83  2311 error1
  5988                                  ;   84  2318 strcpy
  5989                                  ;   85  2345 eqstr
  5990                                  ;   86  2351 strlen
  5991                                  ;   87  2372 storeLabel
  5992                                  ;   88  2383 getTokeType
  5993                                  ;   89  2395 lookCode
  5994                                  ;   90  2404 errorexit
  5995                                  ;   91  2414 errorexit
  5996                                  ;   92  2424 getTokeType
  5997                                  ;   93  2436 genCode8
  5998                                  ;   94  2445 skipBlank
  5999                                  ;   95  2455 isToken
  6000                                  ;   96  2463 genCode8
  6001                                  ;   97  2472 isToken
  6002                                  ;   98  2480 getTokeType
  6003                                  ;   99  2492 genCode16
  6004                                  ;  100  2502 isToken
  6005                                  ;  101  2510 errorexit
  6006                                  ;  102  2529 eqstr
  6007                                  ;  103  2547 eqstr
  6008                                  ;  104  2553 getTokeType
  6009                                  ;  105  2565 eqstr
  6010                                  ;  106  2571 getTokeType
  6011                                  ;  107  2583 eqstr
  6012                                  ;  108  2589 getTokeType
  6013                                  ;  109  2611 skipBlank
  6014                                  ;  110  2630 getTokeType
  6015                                  ;  111  2642 error1
  6016                                  ;  112  2657 readRL
  6017                                  ;  113  2664 errorexit
  6018                                  ;  114  2674 ifEOL
  6019                                  ;  115  2688 readRL
  6020                                  ;  116  2724 digit
  6021                                  ;  117  2730 letterE
  6022                                  ;  118  2757 digit
  6023                                  ;  119  2775 alnumE
  6024                                  ;  120  2782 strcpy
  6025                                  ;  121  2789 toupper
  6026                                  ;  122  2805 strlen
  6027                                  ;  123  2812 strlen
  6028                                  ;  124  2819 eqstr
  6029                                  ;  125  2825 eqstr
  6030                                  ;  126  2831 eqstr
  6031                                  ;  127  2837 eqstr
  6032                                  ;  128  2843 eqstr
  6033                                  ;  129  2849 eqstr
  6034                                  ;  130  2855 eqstr
  6035                                  ;  131  2861 eqstr
  6036                                  ;  132  2867 eqstr
  6037                                  ;  133  2873 eqstr
  6038                                  ;  134  2879 eqstr
  6039                                  ;  135  2885 eqstr
  6040                                  ;  136  2891 eqstr
  6041                                  ;  137  2897 eqstr
  6042                                  ;  138  2903 eqstr
  6043                                  ;  139  2909 eqstr
  6044                                  ;  140  2915 eqstr
  6045                                  ;  141  2921 eqstr
  6046                                  ;  142  2927 eqstr
  6047                                  ;  143  2933 eqstr
  6048                                  ;  144  2939 eqstr
  6049                                  ;  145  2945 eqstr
  6050                                  ;  146  2951 eqstr
  6051                                  ;  147  2957 eqstr
  6052                                  ;  148  2963 eqstr
  6053                                  ;  149  2969 eqstr
  6054                                  ;  150  2975 eqstr
  6055                                  ;  151  2981 eqstr
  6056                                  ;  152  2987 eqstr
  6057                                  ;  153  2993 eqstr
  6058                                  ;  154  3013 prs
  6059                                  ;  155  3017 printhex16
  6060                                  ;  156  3028 prs
  6061                                  ;  157  3032 prc
  6062                                  ;  158  3036 printhex8a
  6063                                  ;  159  3047 prc
  6064                                  ;  160  3051 prs
  6065                                  ;  161  3055 prscomment
  6066                                  ;  162  3072 writetty
  6067                                  ;  163  3081 writetty
  6068                                  ;  164  3090 fputcR
  6069                                  ;  165  3112 prc
  6070                                  ;  166  3128 prc
  6071                                  ;  167  3149 prc
  6072                                  ;  168  3153 prc
  6073                                  ;  169  3175 printhex8a
  6074                                  ;  170  3186 printhex8a
  6075                                  ;  171  3211 printIntU
  6076                                  ;  172  3221 prc
  6077                                  ;  173  3234 prs
  6078                                  ;  174  3238 prs
  6079                                  ;  175  3242 prs
  6080                                  ;  176  3246 prs
  6081                                  ;  177  3263 error1
  6082                                  ;  178  3281 error1
  6083                                  ;  179  3299 error1
  6084                                  ;  180  3318 error1
  6085                                  ;  181  3337 error1
  6086                                  ;  182  3356 error1
  6087                                  ;  183  3375 error1
  6088                                  ;  184  3394 error1
  6089                                  ;  185  3401 end1
  6090                                  ;  186  3415 errorexit
  6091                                  ;  187  3436 errorexit
  6092                                  ;  188  3465 cputs
  6093                                  ;  189  3471 cputs
  6094                                  ;  190  3477 exitR
  6095                                  ;  191  3483 toupper
  6096                                  ;  192  3491 strcpy
  6097                                  ;  193  3498 strcat1
  6098                                  ;  194  3506 strcpy
  6099                                  ;  195  3513 strcat1
  6100                                  ;  196  3521 strcpy
  6101                                  ;  197  3528 strcat1
  6102                                  ;  198  3536 openR
  6103                                  ;  199  3542 cputs
  6104                                  ;  200  3548 cputs
  6105                                  ;  201  3554 exitR
  6106                                  ;  202  3560 creatR
  6107                                  ;  203  3567 cputs
  6108                                  ;  204  3573 cputs
  6109                                  ;  205  3579 exitR
  6110                                  ;  206  3585 creatR
  6111                                  ;  207  3592 cputs
  6112                                  ;  208  3598 cputs
  6113                                  ;  209  3604 exitR
  6114                                  ;  210  3610 prs
  6115                                  ;  211  3614 prs
  6116                                  ;  212  3618 prs
  6117                                  ;  213  3622 prs
  6118                                  ;  214  3626 prs
  6119                                  ;  215  3630 prs
  6120                                  ;  216  3634 prs
  6121                                  ;  217  3638 prs
  6122                                  ;  218  3642 prs
  6123                                  ;  219  3659 prs
  6124                                  ;  220  3663 printIntU
  6125                                  ;  221  3673 prs
  6126                                  ;  222  3677 prs
  6127                                  ;  223  3681 prs
  6128                                  ;  224  3685 prc
  6129                                  ;  225  3689 printhex16
  6130                                  ;  226  3700 prs
  6131                                  ;  227  3704 strlen
  6132                                  ;  228  3711 prs
  6133                                  ;  229  3715 printIntU
  6134                                  ;  230  3725 prs
  6135                                  ;  231  3729 prc
  6136                                  ;  232  3733 printhex8a
  6137                                  ;  233  3744 fputcR
  6138                                  ;  234  3758 fcloseR
  6139                                  ;  235  3766 fcloseR
  6140                                  ;  236  3774 fcloseR
  6141                                  ;  237  3782 exitR
  6142                                  ;  238  3807 putch
  6143                                  ;  239  3875 strcpy
  6144                                  ;  240  3890 DosInt
  6145                                  ;  241  3906 DosInt
  6146                                  ;  242  3929 DosInt
  6147                                  ;  243  3948 DosInt
  6148                                  ;  244  3982 writetty
  6149                                  ;  245  3991 writetty
  6150                                  ;Input: AS.C, List: AS.S,  Lines:  245
  6151                                  ;Glob. variables:  191 max.:  200
  6152                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6153                                  ;Functions      :   74 max.:  300
  6154                                  ;Calls          :  246 max.: 2000, NameField: 4023 max.:    65535
  6155                                  ;Code until     :26009 max.: 30000, free: 3991
  6156                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6157                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
