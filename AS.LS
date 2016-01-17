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
    11 00000003 E88A1A                   call getarg
    12 00000006 E8EA0A                   call parse
    13 00000009 E8DC1C                   call epilog
    14 0000000C E8491E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 17.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 17.1.2016",0
    21 00000019 372031372E312E3230-
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
   904 00000415 E8C507                   call getTokeType
   905                                  
   906                                  ;-8   OpSize=getCodeSize();
   907                                  
   908 00000418 E8BC0A                   call getCodeSize
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
  1097 00000503 E80814                   call error1
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
  1114 00000515 E8F613                   call error1
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
  1231 000005AE E85614                   call segregerror
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
  1245 000005C3 E84813                   call error1
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
  1271 000005EF E81C13                   call error1
  1272 000005F2 83C402                   add  sp, 2
  1273                                  
  1274                                  ;-67   if (RegType==0) error1("no register defined");
  1275                                  
  1276                                  @@checkLeftOp19:
  1277 000005F5 A0[4200]                 mov al, [RegType]
  1278 000005F8 3C00                     cmp al, 0
  1279 000005FA 0F850900                 jne @@checkLeftOp21
  1280 000005FE 68[3806]                 push checkLeftOp_2
  1281 00000601 E80A13                   call error1
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
  1386 00000676 E8E108                   call isToken
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
  1402 0000069D E86E12                   call error1
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
  1439 000006DD E82E12                   call error1
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
  1498 00000746 E81E0B                   call testReg
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
  1512 0000075E E86405                   call searchLabel
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
  1528 0000077C E88F11                   call error1
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
  1583 000007BE E81C04                   call getTokeType
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
  1595 000007D0 E85B12                   call syntaxerror
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
  1642 0000081F E83807                   call isToken
  1643 00000822 83C402                   add  sp, 2
  1644 00000825 08C0                     or  al, al
  1645 00000827 0F841900                 je @@getMEM40
  1646                                  
  1647                                  ;-126       getTokeType();
  1648                                  
  1649 0000082B E8AF03                   call getTokeType
  1650                                  
  1651                                  ;-127       if (TokeType != DIGIT) numbererror();
  1652                                  
  1653 0000082E A0[3C00]                 mov al, [TokeType]
  1654 00000831 3C01                     cmp al, 1
  1655 00000833 0F840300                 je  @@getMEM41
  1656 00000837 E88911                   call numbererror
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
  1672 00000846 E81107                   call isToken
  1673 00000849 83C402                   add  sp, 2
  1674 0000084C 08C0                     or  al, al
  1675 0000084E 0F840300                 je @@getMEM42
  1676 00000852 E969FF                   jmp @@getMEM33
  1677                                  @@getMEM42:
  1678                                  
  1679                                  ;-131   if (isToken(']') == 0) errorexit("] expected");
  1680                                  
  1681 00000855 6A5D                     push 93
  1682 00000857 E80007                   call isToken
  1683 0000085A 83C402                   add  sp, 2
  1684 0000085D 83F800                   cmp ax, 0
  1685 00000860 0F850900                 jne @@getMEM43
  1686 00000864 68[6F08]                 push getMEM_0
  1687 00000867 E8D511                   call errorexit
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
  1708 00000883 E81C11                   call indexerror
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
  1752 000008D7 E8C810                   call indexerror
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
  1776 000008F1 E8AE10                   call indexerror
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
  1832 0000095D E84210                   call indexerror
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
  1857                                  ;-153   OpCodePtr ++;
  1858                                  
  1859 00000968 FF06[4D00]               inc  word [OpCodePtr]
  1860                                  
  1861                                  ;-154   Code1 = *OpCodePtr;
  1862                                  
  1863 0000096C 8B1E[4D00]               mov bx, [OpCodePtr]
  1864 00000970 8A07                     mov al, [bx]
  1865 00000972 B400                     mov ah, 0
  1866 00000974 A2[3F00]                 mov byte [Code1], al
  1867                                  
  1868                                  ;-155   OpCodePtr ++;
  1869                                  
  1870 00000977 FF06[4D00]               inc  word [OpCodePtr]
  1871                                  
  1872                                  ;-156   Code2 = *OpCodePtr;
  1873                                  
  1874 0000097B 8B1E[4D00]               mov bx, [OpCodePtr]
  1875 0000097F 8A07                     mov al, [bx]
  1876 00000981 B400                     mov ah, 0
  1877 00000983 A2[4000]                 mov byte [Code2], al
  1878                                  
  1879                                  ;-157   OpCodePtr ++;
  1880                                  
  1881 00000986 FF06[4D00]               inc  word [OpCodePtr]
  1882                                  
  1883                                  ;-158   Code3 = *OpCodePtr;
  1884                                  
  1885 0000098A 8B1E[4D00]               mov bx, [OpCodePtr]
  1886 0000098E 8A07                     mov al, [bx]
  1887 00000990 B400                     mov ah, 0
  1888 00000992 A2[4100]                 mov byte [Code3], al
  1889                                  
  1890                                  ;-159 }
  1891                                  
  1892                                  
  1893                                  ;-160 int gen66h() {genCode8(0x66);
  1894                                  
  1895 00000995 C3                       ret
  1896                                  ; ENDP
  1897                                  
  1898                                  gen66h:  ; *** PROC ***
  1899 00000996 6A66                     push 102
  1900 00000998 E81F00                   call genCode8
  1901 0000099B 83C402                   add  sp, 2
  1902                                  
  1903                                  ;-161 }
  1904                                  
  1905                                  
  1906                                  ;-162 int genCode(char c, char d) {
  1907                                  
  1908 0000099E C3                       ret
  1909                                  ; ENDP
  1910                                  
  1911                                  genCode:  ; *** PROC ***
  1912                                  
  1913                                  ;-163     c = c + d;
  1914                                  
  1915                                  ;Function : genCode, Number of local variables: 2
  1916                                  ;   # type sign width line used address name   list of local variables
  1917                                  ;  200 var sign byte   162 NULL bp+4    c
  1918                                  ;  201 var sign byte   162 NULL bp+6    d;
  1919 0000099F C8000000                 ENTER  0,0
  1920 000009A3 8A4604                   mov al, [bp+4]
  1921 000009A6 024606                   add al, [bp+6]
  1922 000009A9 884604                   mov byte [bp+4], al
  1923                                  
  1924                                  ;-164     genCode8(c);
  1925                                  
  1926 000009AC 8A4604                   mov al, byte [bp+4]
  1927 000009AF B400                     mov ah, 0
  1928 000009B1 50                       push ax
  1929 000009B2 E80500                   call genCode8
  1930 000009B5 83C402                   add  sp, 2
  1931                                  
  1932                                  ;-165 }
  1933                                  
  1934                                  
  1935                                  ;-166 int genCode8(char c) {
  1936 000009B8 C9                       LEAVE
  1937 000009B9 C3                       ret
  1938                                  ; ENDP
  1939                                  
  1940                                  genCode8:  ; *** PROC ***
  1941                                  
  1942                                  ;-167 //set: BinLen++, OpPrintIndex++
  1943                                  
  1944                                  
  1945                                  ;-168   FileBin[BinLen]=c;
  1946                                  
  1947                                  ;Function : genCode8, Number of local variables: 1
  1948                                  ;   # type sign width line used address name   list of local variables
  1949                                  ;  200 var sign byte   166 NULL bp+4    c;
  1950 000009BA C8000000                 ENTER  0,0
  1951 000009BE 8A4604                   mov al, [bp+4]
  1952 000009C1 8B1E[5600]               mov bx, [BinLen]
  1953 000009C5 88876B7B                 mov [FileBin+bx], al
  1954                                  
  1955                                  ;-169   BinLen++;
  1956                                  
  1957 000009C9 FF06[5600]               inc  word [BinLen]
  1958                                  
  1959                                  ;-170   PC++;
  1960                                  
  1961 000009CD FF06[3700]               inc  word [PC]
  1962                                  
  1963                                  ;-171   if (OpPrintIndex < OPMAXLEN) {
  1964                                  
  1965 000009D1 A1[4B00]                 mov ax, [OpPrintIndex]
  1966 000009D4 83F805                   cmp ax, 5
  1967 000009D7 0F8D0F00                 jge @@genCode860
  1968                                  
  1969                                  ;-172     OpPos[OpPrintIndex]=c;
  1970                                  
  1971 000009DB 8A4604                   mov al, [bp+4]
  1972 000009DE 8B1E[4B00]               mov bx, [OpPrintIndex]
  1973 000009E2 8887B676                 mov [OpPos+bx], al
  1974                                  
  1975                                  ;-173     OpPrintIndex++;
  1976                                  
  1977 000009E6 FF06[4B00]               inc  word [OpPrintIndex]
  1978                                  
  1979                                  ;-174   }
  1980                                  
  1981                                  
  1982                                  ;-175 }
  1983                                  
  1984                                  @@genCode860:
  1985                                  
  1986                                  ;-176 int genCode16(int i) {
  1987 000009EA C9                       LEAVE
  1988 000009EB C3                       ret
  1989                                  ; ENDP
  1990                                  
  1991                                  genCode16:  ; *** PROC ***
  1992                                  
  1993                                  ;-177   genCode8(i); i=i >> 8;
  1994                                  
  1995                                  ;Function : genCode16, Number of local variables: 1
  1996                                  ;   # type sign width line used address name   list of local variables
  1997                                  ;  200 var sign word   176 NULL bp+4    i;
  1998 000009EC C8000000                 ENTER  0,0
  1999 000009F0 FF7604                   push word [bp+4]
  2000 000009F3 E8C4FF                   call genCode8
  2001 000009F6 83C402                   add  sp, 2
  2002 000009F9 8B4604                   mov ax, [bp+4]
  2003 000009FC C1E808                   shr ax, 8
  2004 000009FF 894604                   mov word [bp+4], ax
  2005                                  
  2006                                  ;-178   genCode8(i);
  2007                                  
  2008 00000A02 FF7604                   push word [bp+4]
  2009 00000A05 E8B2FF                   call genCode8
  2010 00000A08 83C402                   add  sp, 2
  2011                                  
  2012                                  ;-179 }
  2013                                  
  2014                                  
  2015                                  ;-180 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  2016 00000A0B C9                       LEAVE
  2017 00000A0C C3                       ret
  2018                                  ; ENDP
  2019                                  
  2020                                  writeEA:  ; *** PROC ***
  2021                                  
  2022                                  ;-181   char len;
  2023                                  
  2024                                  
  2025                                  ;-182   len=0;
  2026                                  
  2027                                  ;Function : writeEA, Number of local variables: 2
  2028                                  ;   # type sign width line used address name   list of local variables
  2029                                  ;  200 var sign byte   180 NULL bp+4    xxx
  2030                                  ;  201 var sign byte   181 NULL bp-2    len;
  2031 00000A0D C8020000                 ENTER  2,0
  2032 00000A11 66B800000000             mov eax, 0
  2033 00000A17 8846FE                   mov byte [bp-2], al
  2034                                  
  2035                                  ;-183   xxx = xxx << 3;//in regindexbase field of mod r/m
  2036                                  
  2037 00000A1A 8A4604                   mov al, [bp+4]
  2038 00000A1D C0E003                   shl al, 3
  2039 00000A20 884604                   mov byte [bp+4], al
  2040                                  
  2041                                  ;-184   if (Op1 ==   0) addrexit();
  2042                                  
  2043 00000A23 A0[3D00]                 mov al, [Op1]
  2044 00000A26 3C00                     cmp al, 0
  2045 00000A28 0F850300                 jne @@writeEA61
  2046 00000A2C E82710                   call addrexit
  2047                                  
  2048                                  ;-185   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} //2
  2049                                  
  2050                                  @@writeEA61:
  2051 00000A2F A0[3D00]                 mov al, [Op1]
  2052 00000A32 3C02                     cmp al, 2
  2053 00000A34 0F850E00                 jne @@writeEA62
  2054 00000A38 804E04C0                 or  byte [bp+4], 192
  2055 00000A3C 8A4604                   mov al, [bp+4]
  2056 00000A3F 0206[4300]               add al, [RegNo]
  2057 00000A43 884604                   mov byte [bp+4], al
  2058                                  
  2059                                  ;-186   if (Op1 == ADR) {xxx |= 6; len=2; }               //3
  2060                                  
  2061                                  @@writeEA62:
  2062 00000A46 A0[3D00]                 mov al, [Op1]
  2063 00000A49 3C03                     cmp al, 3
  2064 00000A4B 0F850D00                 jne @@writeEA63
  2065 00000A4F 804E0406                 or  byte [bp+4], 6
  2066 00000A53 66B802000000             mov eax, 2
  2067 00000A59 8846FE                   mov byte [bp-2], al
  2068                                  
  2069                                  ;-187   if (Op1 == MEM) { xxx = xxx + regindexbase;       //4
  2070                                  
  2071                                  @@writeEA63:
  2072 00000A5C A0[3D00]                 mov al, [Op1]
  2073 00000A5F 3C04                     cmp al, 4
  2074 00000A61 0F854600                 jne @@writeEA64
  2075 00000A65 8A4604                   mov al, [bp+4]
  2076 00000A68 0206[4600]               add al, [regindexbase]
  2077 00000A6C 884604                   mov byte [bp+4], al
  2078                                  
  2079                                  ;-188     if (disp) {
  2080                                  
  2081 00000A6F A1[4700]                 mov ax, [disp]
  2082 00000A72 08C0                     or  al, al
  2083 00000A74 0F843300                 je @@writeEA65
  2084                                  
  2085                                  ;-189       disp;
  2086                                  
  2087 00000A78 A1[4700]                 mov ax, [disp]
  2088                                  
  2089                                  ;-190       if(ax > 127) len=2;
  2090                                  
  2091 00000A7B 83F87F                   cmp  ax, 127
  2092 00000A7E 0F8E0C00                 jle @@writeEA66
  2093 00000A82 66B802000000             mov eax, 2
  2094 00000A88 8846FE                   mov byte [bp-2], al
  2095                                  
  2096                                  ;-191       else len=1;
  2097                                  
  2098 00000A8B E90900                   jmp @@writeEA67
  2099                                  @@writeEA66:
  2100 00000A8E 66B801000000             mov eax, 1
  2101 00000A94 8846FE                   mov byte [bp-2], al
  2102                                  
  2103                                  ;-192       if (len == 1) xxx |= 0x40;
  2104                                  
  2105                                  @@writeEA67:
  2106 00000A97 8A46FE                   mov al, [bp-2]
  2107 00000A9A 3C01                     cmp al, 1
  2108 00000A9C 0F850700                 jne @@writeEA68
  2109 00000AA0 804E0440                 or  byte [bp+4], 64
  2110                                  
  2111                                  ;-193       else xxx |= 0x80;
  2112                                  
  2113 00000AA4 E90400                   jmp @@writeEA69
  2114                                  @@writeEA68:
  2115 00000AA7 804E0480                 or  byte [bp+4], 128
  2116                                  
  2117                                  ;-194     }
  2118                                  
  2119                                  @@writeEA69:
  2120                                  
  2121                                  ;-195   }
  2122                                  
  2123                                  @@writeEA65:
  2124                                  
  2125                                  ;-196   genCode8(xxx);// gen second byte
  2126                                  
  2127                                  @@writeEA64:
  2128 00000AAB 8A4604                   mov al, byte [bp+4]
  2129 00000AAE B400                     mov ah, 0
  2130 00000AB0 50                       push ax
  2131 00000AB1 E806FF                   call genCode8
  2132 00000AB4 83C402                   add  sp, 2
  2133                                  
  2134                                  ;-197   if (len == 1) genCode8 (disp);
  2135                                  
  2136 00000AB7 8A46FE                   mov al, [bp-2]
  2137 00000ABA 3C01                     cmp al, 1
  2138 00000ABC 0F850A00                 jne @@writeEA70
  2139 00000AC0 FF36[4700]               push word [disp]
  2140 00000AC4 E8F3FE                   call genCode8
  2141 00000AC7 83C402                   add  sp, 2
  2142                                  
  2143                                  ;-198   if (len == 2) genCode16(disp);
  2144                                  
  2145                                  @@writeEA70:
  2146 00000ACA 8A46FE                   mov al, [bp-2]
  2147 00000ACD 3C02                     cmp al, 2
  2148 00000ACF 0F850A00                 jne @@writeEA71
  2149 00000AD3 FF36[4700]               push word [disp]
  2150 00000AD7 E812FF                   call genCode16
  2151 00000ADA 83C402                   add  sp, 2
  2152                                  
  2153                                  ;-199 }
  2154                                  
  2155                                  @@writeEA71:
  2156                                  
  2157                                  ;-200 
  2158                                  
  2159                                  
  2160                                  ;-201 int testx() { __asm {
  2161 00000ADD C9                       LEAVE
  2162 00000ADE C3                       ret
  2163                                  ; ENDP
  2164                                  
  2165                                  testx:  ; *** PROC ***
  2166                                  
  2167                                  
  2168                                  ;-202 inc byte [Version1]   ;FE 06 [1000]
  2169                                  
  2170 00000ADF FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  2171                                  
  2172                                  ;-203 add bx, ax    ;01 C3
  2173                                  
  2174 00000AE3 01C3                    add bx, ax    ;01 C3
  2175                                  
  2176                                  ;-204 add ax, bx    ;01 D8
  2177                                  
  2178 00000AE5 01D8                    add ax, bx    ;01 D8
  2179                                  
  2180                                  ;-205 add word ax, [bx] ;03 07
  2181                                  
  2182 00000AE7 0307                    add word ax, [bx] ;03 07
  2183                                  
  2184                                  ;-206 VA dw 8
  2185                                  
  2186 00000AE9 0800                    VA dw 8
  2187                                  
  2188                                  ;-207 mov byte [bp- 4], al ;88 46 FC
  2189                                  
  2190 00000AEB 8846FC                  mov byte [bp- 4], al ;88 46 FC
  2191                                  
  2192                                  ;-208 mov      [VA+bx], al ;88 87 [300F]
  2193                                  
  2194 00000AEE 8887[E90A]              mov      [VA+bx], al ;88 87 [300F]
  2195                                  
  2196                                  ;-209 }  
  2197                                  
  2198                                  
  2199                                  
  2200                                  ;-210 }
  2201                                  
  2202                                  
  2203                                  ;-211 #include "PARSE.C"
  2204                                  
  2205 00000AF2 C3                       ret
  2206                                  ; ENDP
  2207                                  ;Use include file: PARSE.C
  2208                                  
  2209                                  ;-1 int parse() {
  2210                                  
  2211                                  
  2212                                  parse:  ; *** PROC ***
  2213                                  
  2214                                  ;-2   LabelNamePtr= &LabelNames;
  2215                                  
  2216 00000AF3 B8BB76                   mov ax, LabelNames
  2217 00000AF6 A3[5000]                 mov word [LabelNamePtr], ax
  2218                                  
  2219                                  ;-3   do {
  2220                                  
  2221                                  @@parse72:
  2222                                  
  2223                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  2224                                  
  2225 00000AF9 A1[3700]                 mov ax, [PC]
  2226 00000AFC A3[3900]                 mov word [PCStart], ax
  2227 00000AFF 66B800000000             mov eax, 0
  2228 00000B05 A2[4400]                 mov byte [OpSize], al
  2229 00000B08 66B800000000             mov eax, 0
  2230 00000B0E A3[4B00]                 mov word [OpPrintIndex], ax
  2231 00000B11 66B820000000             mov eax, 32
  2232 00000B17 A2[4F00]                 mov byte [PrintR], al
  2233                                  
  2234                                  ;-5     getLine();
  2235                                  
  2236 00000B1A E89404                   call getLine
  2237                                  
  2238                                  ;-6     InputPtr = &InputBuf;
  2239                                  
  2240 00000B1D B86E75                   mov ax, InputBuf
  2241 00000B20 A3[2800]                 mov word [InputPtr], ax
  2242                                  
  2243                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2244                                  
  2245 00000B23 E8B700                   call getTokeType
  2246                                  
  2247                                  ;-8     if (TokeType == ALNUME) {
  2248                                  
  2249 00000B26 A0[3C00]                 mov al, [TokeType]
  2250 00000B29 3C03                     cmp al, 3
  2251 00000B2B 0F851300                 jne @@parse73
  2252                                  
  2253                                  ;-9       if (isLabel) { //set in getName
  2254                                  
  2255 00000B2F A0[3B00]                 mov al, [isLabel]
  2256 00000B32 08C0                     or  al, al
  2257 00000B34 0F840A00                 je @@parse74
  2258                                  
  2259                                  ;-10         storeLabel();
  2260                                  
  2261 00000B38 E84001                   call storeLabel
  2262                                  
  2263                                  ;-11         InputPtr++;//remove :
  2264                                  
  2265 00000B3B FF06[2800]               inc  word [InputPtr]
  2266                                  
  2267                                  ;-12         getTokeType();
  2268                                  
  2269 00000B3F E89B00                   call getTokeType
  2270                                  
  2271                                  ;-13       }
  2272                                  
  2273                                  
  2274                                  ;-14     }
  2275                                  
  2276                                  @@parse74:
  2277                                  
  2278                                  ;-15     if (TokeType == ALNUME) {
  2279                                  
  2280                                  @@parse73:
  2281 00000B42 A0[3C00]                 mov al, [TokeType]
  2282 00000B45 3C03                     cmp al, 3
  2283 00000B47 0F851B00                 jne @@parse75
  2284                                  
  2285                                  ;-16       lookCode();// and OpCodePtr
  2286                                  
  2287 00000B4B E80F03                   call lookCode
  2288                                  
  2289                                  ;-17       if(CodeType) process();
  2290                                  
  2291 00000B4E A0[3E00]                 mov al, [CodeType]
  2292 00000B51 08C0                     or  al, al
  2293 00000B53 0F840600                 je @@parse76
  2294 00000B57 E8B7F8                   call process
  2295                                  
  2296                                  ;-18       else getVariable();
  2297                                  
  2298 00000B5A E90300                   jmp @@parse77
  2299                                  @@parse76:
  2300 00000B5D E8C501                   call getVariable
  2301                                  
  2302                                  ;-19       skipRest();
  2303                                  
  2304                                  @@parse77:
  2305 00000B60 E82504                   call skipRest
  2306                                  
  2307                                  ;-20     }
  2308                                  
  2309                                  
  2310                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2311                                  
  2312 00000B63 E92700                   jmp @@parse78
  2313                                  @@parse75:
  2314 00000B66 A0[3C00]                 mov al, [TokeType]
  2315 00000B69 3C03                     cmp al, 3
  2316 00000B6B 0F8E0C00                 jle @@parse79
  2317 00000B6F 68[9E0B]                 push parse_0
  2318 00000B72 E8990D                   call error1
  2319 00000B75 83C402                   add  sp, 2
  2320                                  
  2321                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2322                                  
  2323 00000B78 E91200                   jmp @@parse80
  2324                                  @@parse79:
  2325 00000B7B A0[3C00]                 mov al, [TokeType]
  2326 00000B7E 3C01                     cmp al, 1
  2327 00000B80 0F850900                 jne @@parse81
  2328 00000B84 68[BC0B]                 push parse_1
  2329 00000B87 E8840D                   call error1
  2330 00000B8A 83C402                   add  sp, 2
  2331                                  
  2332                                  ;-23     printLine();
  2333                                  
  2334                                  @@parse81:
  2335                                  @@parse80:
  2336                                  @@parse78:
  2337 00000B8D E8130B                   call printLine
  2338                                  
  2339                                  ;-24   } while (DOS_NoBytes != 0 );
  2340                                  
  2341 00000B90 A1[3400]                 mov ax, [DOS_NoBytes]
  2342 00000B93 83F800                   cmp ax, 0
  2343 00000B96 0F840300                 je  @@parse82
  2344 00000B9A E95CFF                   jmp @@parse72
  2345                                  @@parse82:
  2346                                  
  2347                                  ;-25 }
  2348                                  
  2349                                  
  2350                                  ;-26 // scan code .....................................
  2351                                  
  2352                                  
  2353                                  ;-27 int getTokeType() { char c;
  2354                                  
  2355 00000B9D C3                       ret
  2356                                  ; ENDP
  2357 00000B9E 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2358 00000BA7 696E73747275637469-
  2359 00000BB0 6F6E20657870656374-
  2360 00000BB9 656400             
  2361 00000BBC 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2362 00000BC5 616C6C6F7765642040-
  2363 00000BCE 207374617274206F66-
  2364 00000BD7 206C696E6500       
  2365                                  
  2366                                  getTokeType:  ; *** PROC ***
  2367                                  
  2368                                  ;-28   skipBlank();
  2369                                  
  2370                                  ;Function : getTokeType, Number of local variables: 1
  2371                                  ;   # type sign width line used address name   list of local variables
  2372                                  ;  200 var sign byte    27 NULL bp-2    c;
  2373 00000BDD C8020000                 ENTER  2,0
  2374 00000BE1 E89A04                   call skipBlank
  2375                                  
  2376                                  ;-29   c = *InputPtr;
  2377                                  
  2378 00000BE4 8B1E[2800]               mov bx, [InputPtr]
  2379 00000BE8 8A07                     mov al, [bx]
  2380 00000BEA B400                     mov ah, 0
  2381 00000BEC 8846FE                   mov byte [bp-2], al
  2382                                  
  2383                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2384                                  
  2385 00000BEF 8A46FE                   mov al, [bp-2]
  2386 00000BF2 3C00                     cmp al, 0
  2387 00000BF4 0F850C00                 jne @@getTokeType83
  2388 00000BF8 66B800000000             mov eax, 0
  2389 00000BFE A2[3C00]                 mov byte [TokeType], al
  2390 00000C01 E97500                   jmp @@retn
  2391                                  
  2392                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2393                                  
  2394                                  @@getTokeType83:
  2395 00000C04 8A46FE                   mov al, [bp-2]
  2396 00000C07 3C3B                     cmp al, 59
  2397 00000C09 0F850C00                 jne @@getTokeType84
  2398 00000C0D 66B800000000             mov eax, 0
  2399 00000C13 A2[3C00]                 mov byte [TokeType], al
  2400 00000C16 E96000                   jmp @@retn
  2401                                  
  2402                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2403                                  
  2404                                  @@getTokeType84:
  2405 00000C19 8A46FE                   mov al, byte [bp-2]
  2406 00000C1C B400                     mov ah, 0
  2407 00000C1E 50                       push ax
  2408 00000C1F E84013                   call digit
  2409 00000C22 83C402                   add  sp, 2
  2410 00000C25 08C0                     or  al, al
  2411 00000C27 0F841800                 je @@getTokeType85
  2412 00000C2B 8A46FE                   mov al, byte [bp-2]
  2413 00000C2E B400                     mov ah, 0
  2414 00000C30 50                       push ax
  2415 00000C31 E85005                   call getDigit
  2416 00000C34 83C402                   add  sp, 2
  2417 00000C37 66B801000000             mov eax, 1
  2418 00000C3D A2[3C00]                 mov byte [TokeType], al
  2419 00000C40 E93600                   jmp @@retn
  2420                                  
  2421                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2422                                  
  2423                                  @@getTokeType85:
  2424 00000C43 8A46FE                   mov al, byte [bp-2]
  2425 00000C46 B400                     mov ah, 0
  2426 00000C48 50                       push ax
  2427 00000C49 E85D04                   call letterE
  2428 00000C4C 83C402                   add  sp, 2
  2429 00000C4F 08C0                     or  al, al
  2430 00000C51 0F841800                 je @@getTokeType86
  2431 00000C55 8A46FE                   mov al, byte [bp-2]
  2432 00000C58 B400                     mov ah, 0
  2433 00000C5A 50                       push ax
  2434 00000C5B E87D05                   call getName
  2435 00000C5E 83C402                   add  sp, 2
  2436 00000C61 66B803000000             mov eax, 3
  2437 00000C67 A2[3C00]                 mov byte [TokeType], al
  2438 00000C6A E90C00                   jmp @@retn
  2439                                  
  2440                                  ;-34   TokeType=NOALNUME; return;
  2441                                  
  2442                                  @@getTokeType86:
  2443 00000C6D 66B804000000             mov eax, 4
  2444 00000C73 A2[3C00]                 mov byte [TokeType], al
  2445 00000C76 E90000                   jmp @@retn
  2446                                  
  2447                                  ;-35 }
  2448                                  
  2449                                  
  2450                                  ;-36 int storeLabel() {
  2451                                  
  2452 00000C79 C9                      @@retn: LEAVE
  2453 00000C7A C3                       ret
  2454                                  ; ENDP
  2455                                  
  2456                                  storeLabel:  ; *** PROC ***
  2457                                  
  2458                                  ;-37   if(searchLabel()) error1("duplicate label");
  2459                                  
  2460 00000C7B E84700                   call searchLabel
  2461 00000C7E 08C0                     or  al, al
  2462 00000C80 0F840900                 je @@storeLabel87
  2463 00000C84 68[B50C]                 push storeLabel_0
  2464 00000C87 E8840C                   call error1
  2465 00000C8A 83C402                   add  sp, 2
  2466                                  
  2467                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2468                                  
  2469                                  @@storeLabel87:
  2470 00000C8D 8D063075                 lea  ax, [Symbol]
  2471 00000C91 50                       push ax
  2472 00000C92 FF36[5000]               push word [LabelNamePtr]
  2473 00000C96 E89012                   call strcpy
  2474 00000C99 83C404                   add  sp, 4
  2475 00000C9C A3[5000]                 mov word [LabelNamePtr], ax
  2476                                  
  2477                                  ;-39   LabelNamePtr++;
  2478                                  
  2479 00000C9F FF06[5000]               inc  word [LabelNamePtr]
  2480                                  
  2481                                  ;-40   LabelMaxIx++;
  2482                                  
  2483 00000CA3 FF06[5200]               inc  word [LabelMaxIx]
  2484                                  
  2485                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2486                                  
  2487 00000CA7 A1[3700]                 mov ax, [PC]
  2488 00000CAA 8B1E[5200]               mov bx, [LabelMaxIx]
  2489 00000CAE D1E3                     shl bx, 1
  2490 00000CB0 8987A37A                 mov [LabelAddr+bx], ax
  2491                                  
  2492                                  ;-42 }
  2493                                  
  2494                                  
  2495                                  ;-43 int searchLabel() {
  2496                                  
  2497 00000CB4 C3                       ret
  2498                                  ; ENDP
  2499 00000CB5 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2500 00000CBE 206C6162656C00     
  2501                                  
  2502                                  searchLabel:  ; *** PROC ***
  2503                                  
  2504                                  ;-44   int LIx; char *p; int j;
  2505                                  
  2506                                  
  2507                                  ;-45   p = &LabelNames;
  2508                                  
  2509                                  ;Function : searchLabel, Number of local variables: 3
  2510                                  ;   # type sign width line used address name   list of local variables
  2511                                  ;  200 var sign word    44 NULL bp-2    LIx
  2512                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2513                                  ;  202 var sign word    44 NULL bp-6    j;
  2514 00000CC5 C8060000                 ENTER  6,0
  2515 00000CC9 B8BB76                   mov ax, LabelNames
  2516 00000CCC 8946FC                   mov word [bp-4], ax
  2517                                  
  2518                                  ;-46   LIx=1;
  2519                                  
  2520 00000CCF 66B801000000             mov eax, 1
  2521 00000CD5 8946FE                   mov word [bp-2], ax
  2522                                  
  2523                                  ;-47   while (LIx <= LabelMaxIx) {
  2524                                  
  2525                                  @@searchLabel88:
  2526 00000CD8 8B46FE                   mov ax, [bp-2]
  2527 00000CDB 3B06[5200]               cmp ax, [LabelMaxIx]
  2528 00000CDF 0F8F3700                 jg  @@searchLabel89
  2529                                  
  2530                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2531                                  
  2532 00000CE3 8D063075                 lea  ax, [Symbol]
  2533 00000CE7 50                       push ax
  2534 00000CE8 FF76FC                   push word [bp-4]
  2535 00000CEB E8A712                   call eqstr
  2536 00000CEE 83C404                   add  sp, 4
  2537 00000CF1 08C0                     or  al, al
  2538 00000CF3 0F840600                 je @@searchLabel90
  2539 00000CF7 8B46FE                   mov ax, [bp-2]
  2540 00000CFA E92600                   jmp @@retn
  2541                                  
  2542                                  ;-49     j=strlen(p);
  2543                                  
  2544                                  @@searchLabel90:
  2545 00000CFD FF76FC                   push word [bp-4]
  2546 00000D00 E8FB11                   call strlen
  2547 00000D03 83C402                   add  sp, 2
  2548 00000D06 8946FA                   mov word [bp-6], ax
  2549                                  
  2550                                  ;-50     p=p+j; p++; LIx++;
  2551                                  
  2552 00000D09 8B46FC                   mov ax, [bp-4]
  2553 00000D0C 0346FA                   add ax, [bp-6]
  2554 00000D0F 8946FC                   mov word [bp-4], ax
  2555 00000D12 FF46FC                   inc  word [bp-4]
  2556 00000D15 FF46FE                   inc  word [bp-2]
  2557                                  
  2558                                  ;-51   }
  2559                                  
  2560                                  
  2561                                  ;-52   return 0;
  2562                                  
  2563 00000D18 EBBE                     jmp @@searchLabel88
  2564                                  @@searchLabel89:
  2565 00000D1A 66B800000000             mov eax, 0
  2566 00000D20 E90000                   jmp @@retn
  2567                                  
  2568                                  ;-53 }
  2569                                  
  2570                                  
  2571                                  ;-54 int getVariable() { char c;
  2572                                  
  2573 00000D23 C9                      @@retn: LEAVE
  2574 00000D24 C3                       ret
  2575                                  ; ENDP
  2576                                  
  2577                                  getVariable:  ; *** PROC ***
  2578                                  
  2579                                  ;-55   storeLabel();
  2580                                  
  2581                                  ;Function : getVariable, Number of local variables: 1
  2582                                  ;   # type sign width line used address name   list of local variables
  2583                                  ;  200 var sign byte    54 NULL bp-2    c;
  2584 00000D25 C8020000                 ENTER  2,0
  2585 00000D29 E84FFF                   call storeLabel
  2586                                  
  2587                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2588                                  
  2589 00000D2C E8AEFE                   call getTokeType
  2590 00000D2F A0[3C00]                 mov al, [TokeType]
  2591 00000D32 3C03                     cmp al, 3
  2592 00000D34 0F85CC00                 jne @@getVariable91
  2593                                  
  2594                                  ;-57     lookCode();
  2595                                  
  2596 00000D38 E82201                   call lookCode
  2597                                  
  2598                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2599                                  
  2600 00000D3B A0[3E00]                 mov al, [CodeType]
  2601 00000D3E 3CC8                     cmp al, 200
  2602 00000D40 0F8D0900                 jge @@getVariable92
  2603 00000D44 68[0F0E]                 push getVariable_0
  2604 00000D47 E8F50C                   call errorexit
  2605 00000D4A 83C402                   add  sp, 2
  2606                                  
  2607                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2608                                  
  2609                                  @@getVariable92:
  2610 00000D4D A0[3E00]                 mov al, [CodeType]
  2611 00000D50 3CCF                     cmp al, 207
  2612 00000D52 0F8E0900                 jle @@getVariable93
  2613 00000D56 68[270E]                 push getVariable_1
  2614 00000D59 E8E30C                   call errorexit
  2615 00000D5C 83C402                   add  sp, 2
  2616                                  
  2617                                  ;-60     if (CodeType== 200) {// DB
  2618                                  
  2619                                  @@getVariable93:
  2620 00000D5F A0[3E00]                 mov al, [CodeType]
  2621 00000D62 3CC8                     cmp al, 200
  2622 00000D64 0F856A00                 jne @@getVariable94
  2623                                  
  2624                                  ;-61       do { getTokeType();
  2625                                  
  2626                                  @@getVariable95:
  2627 00000D68 E872FE                   call getTokeType
  2628                                  
  2629                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2630                                  
  2631 00000D6B A0[3C00]                 mov al, [TokeType]
  2632 00000D6E 3C01                     cmp al, 1
  2633 00000D70 0F850D00                 jne @@getVariable96
  2634 00000D74 FF36[2600]               push word [SymbolInt]
  2635 00000D78 E83FFC                   call genCode8
  2636 00000D7B 83C402                   add  sp, 2
  2637                                  
  2638                                  ;-63         else {
  2639                                  
  2640 00000D7E E94100                   jmp @@getVariable97
  2641                                  @@getVariable96:
  2642                                  
  2643                                  ;-64           skipBlank();
  2644                                  
  2645 00000D81 E8FA02                   call skipBlank
  2646                                  
  2647                                  ;-65           if (isToken('"')) {
  2648                                  
  2649 00000D84 6A22                     push 34
  2650 00000D86 E8D101                   call isToken
  2651 00000D89 83C402                   add  sp, 2
  2652 00000D8C 08C0                     or  al, al
  2653 00000D8E 0F843000                 je @@getVariable98
  2654                                  
  2655                                  ;-66             do { c= *InputPtr;
  2656                                  
  2657                                  @@getVariable99:
  2658 00000D92 8B1E[2800]               mov bx, [InputPtr]
  2659 00000D96 8A07                     mov al, [bx]
  2660 00000D98 B400                     mov ah, 0
  2661 00000D9A 8846FE                   mov byte [bp-2], al
  2662                                  
  2663                                  ;-67               genCode8(c);
  2664                                  
  2665 00000D9D 8A46FE                   mov al, byte [bp-2]
  2666 00000DA0 B400                     mov ah, 0
  2667 00000DA2 50                       push ax
  2668 00000DA3 E814FC                   call genCode8
  2669 00000DA6 83C402                   add  sp, 2
  2670                                  
  2671                                  ;-68               InputPtr++;
  2672                                  
  2673 00000DA9 FF06[2800]               inc  word [InputPtr]
  2674                                  
  2675                                  ;-69             } while (*InputPtr != '"' );
  2676                                  
  2677 00000DAD 8B1E[2800]               mov bx, [InputPtr]
  2678 00000DB1 8A07                     mov al, [bx]
  2679 00000DB3 B400                     mov ah, 0
  2680 00000DB5 83F822                   cmp ax, 34
  2681 00000DB8 0F840200                 je  @@getVariable100
  2682 00000DBC EBD4                     jmp @@getVariable99
  2683                                  @@getVariable100:
  2684                                  
  2685                                  ;-70             InputPtr++;
  2686                                  
  2687 00000DBE FF06[2800]               inc  word [InputPtr]
  2688                                  
  2689                                  ;-71           }
  2690                                  
  2691                                  
  2692                                  ;-72         }
  2693                                  
  2694                                  @@getVariable98:
  2695                                  
  2696                                  ;-73       } while (isToken(','));
  2697                                  
  2698                                  @@getVariable97:
  2699 00000DC2 6A2C                     push 44
  2700 00000DC4 E89301                   call isToken
  2701 00000DC7 83C402                   add  sp, 2
  2702 00000DCA 08C0                     or  al, al
  2703 00000DCC 0F840200                 je @@getVariable101
  2704 00000DD0 EB96                     jmp @@getVariable95
  2705                                  @@getVariable101:
  2706                                  
  2707                                  ;-74     }
  2708                                  
  2709                                  
  2710                                  ;-75     if (CodeType== 201) {// DW
  2711                                  
  2712                                  @@getVariable94:
  2713 00000DD2 A0[3E00]                 mov al, [CodeType]
  2714 00000DD5 3CC9                     cmp al, 201
  2715 00000DD7 0F852600                 jne @@getVariable102
  2716                                  
  2717                                  ;-76       do { getTokeType();
  2718                                  
  2719                                  @@getVariable103:
  2720 00000DDB E8FFFD                   call getTokeType
  2721                                  
  2722                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2723                                  
  2724 00000DDE A0[3C00]                 mov al, [TokeType]
  2725 00000DE1 3C01                     cmp al, 1
  2726 00000DE3 0F850A00                 jne @@getVariable104
  2727 00000DE7 FF36[2600]               push word [SymbolInt]
  2728 00000DEB E8FEFB                   call genCode16
  2729 00000DEE 83C402                   add  sp, 2
  2730                                  
  2731                                  ;-78       } while (isToken(','));
  2732                                  
  2733                                  @@getVariable104:
  2734 00000DF1 6A2C                     push 44
  2735 00000DF3 E86401                   call isToken
  2736 00000DF6 83C402                   add  sp, 2
  2737 00000DF9 08C0                     or  al, al
  2738 00000DFB 0F840200                 je @@getVariable105
  2739 00000DFF EBDA                     jmp @@getVariable103
  2740                                  @@getVariable105:
  2741                                  
  2742                                  ;-79     }
  2743                                  
  2744                                  
  2745                                  ;-80   }
  2746                                  
  2747                                  @@getVariable102:
  2748                                  
  2749                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2750                                  
  2751 00000E01 E90900                   jmp @@getVariable106
  2752                                  @@getVariable91:
  2753 00000E04 68[3F0E]                 push getVariable_2
  2754 00000E07 E8350C                   call errorexit
  2755 00000E0A 83C402                   add  sp, 2
  2756                                  
  2757                                  ;-82 }
  2758                                  
  2759                                  @@getVariable106:
  2760                                  
  2761                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2762 00000E0D C9                       LEAVE
  2763 00000E0E C3                       ret
  2764                                  ; ENDP
  2765 00000E0F 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2766 00000E18 422C572C4420657870-
  2767 00000E21 656374656400       
  2768 00000E27 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2769 00000E30 422C572C4420657870-
  2770 00000E39 656374656400       
  2771 00000E3F 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2772 00000E48 6F7220524553422C57-
  2773 00000E51 2C4420657870656374-
  2774 00000E5A 656400             
  2775                                  
  2776                                  lookCode:  ; *** PROC ***
  2777                                  
  2778                                  ;-84   CodeType=0;
  2779                                  
  2780 00000E5D 66B800000000             mov eax, 0
  2781 00000E63 A2[3E00]                 mov byte [CodeType], al
  2782                                  
  2783                                  ;-85   OpCodePtr= &I_START;
  2784                                  
  2785 00000E66 B8[5C00]                 mov ax, I_START
  2786 00000E69 A3[4D00]                 mov word [OpCodePtr], ax
  2787                                  
  2788                                  ;-86   OpCodePtr++;
  2789                                  
  2790 00000E6C FF06[4D00]               inc  word [OpCodePtr]
  2791                                  
  2792                                  ;-87   do  {
  2793                                  
  2794                                  @@lookCode107:
  2795                                  
  2796                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2797                                  
  2798 00000E70 FF36[4D00]               push word [OpCodePtr]
  2799 00000E74 8D064F75                 lea  ax, [SymbolUpper]
  2800 00000E78 50                       push ax
  2801 00000E79 E81911                   call eqstr
  2802 00000E7C 83C404                   add  sp, 4
  2803 00000E7F 08C0                     or  al, al
  2804 00000E81 0F842700                 je @@lookCode108
  2805                                  
  2806                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2807                                  
  2808                                  @@lookCode109:
  2809 00000E85 8B1E[4D00]               mov bx, [OpCodePtr]
  2810 00000E89 8A07                     mov al, [bx]
  2811 00000E8B B400                     mov ah, 0
  2812 00000E8D 83F800                   cmp ax, 0
  2813 00000E90 0F840600                 je  @@lookCode110
  2814 00000E94 FF06[4D00]               inc  word [OpCodePtr]
  2815                                  
  2816                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2817                                  
  2818 00000E98 EBEB                     jmp @@lookCode109
  2819                                  @@lookCode110:
  2820 00000E9A FF06[4D00]               inc  word [OpCodePtr]
  2821 00000E9E 8B1E[4D00]               mov bx, [OpCodePtr]
  2822 00000EA2 8A07                     mov al, [bx]
  2823 00000EA4 B400                     mov ah, 0
  2824 00000EA6 A2[3E00]                 mov byte [CodeType], al
  2825                                  
  2826                                  ;-91       return;
  2827                                  
  2828 00000EA9 E92A00                   jmp @@retn
  2829                                  
  2830                                  ;-92     }
  2831                                  
  2832                                  
  2833                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2834                                  
  2835                                  @@lookCode108:
  2836                                  @@lookCode111:
  2837 00000EAC 8B1E[4D00]               mov bx, [OpCodePtr]
  2838 00000EB0 8A07                     mov al, [bx]
  2839 00000EB2 B400                     mov ah, 0
  2840 00000EB4 3DF100                   cmp ax, 241
  2841 00000EB7 0F840600                 je  @@lookCode112
  2842 00000EBB FF06[4D00]               inc  word [OpCodePtr]
  2843                                  
  2844                                  ;-94   OpCodePtr++;
  2845                                  
  2846 00000EBF EBEB                     jmp @@lookCode111
  2847                                  @@lookCode112:
  2848 00000EC1 FF06[4D00]               inc  word [OpCodePtr]
  2849                                  
  2850                                  ;-95   } while(*OpCodePtr!=0);
  2851                                  
  2852 00000EC5 8B1E[4D00]               mov bx, [OpCodePtr]
  2853 00000EC9 8A07                     mov al, [bx]
  2854 00000ECB B400                     mov ah, 0
  2855 00000ECD 83F800                   cmp ax, 0
  2856 00000ED0 0F840200                 je  @@lookCode113
  2857 00000ED4 EB9A                     jmp @@lookCode107
  2858                                  @@lookCode113:
  2859                                  
  2860                                  ;-96 }
  2861                                  
  2862                                  
  2863                                  ;-97 int getCodeSize() {
  2864                                  
  2865                                  @@retn:
  2866 00000ED6 C3                       ret
  2867                                  ; ENDP
  2868                                  
  2869                                  getCodeSize:  ; *** PROC ***
  2870                                  
  2871                                  ;-98   if (TokeType ==ALNUME) {
  2872                                  
  2873 00000ED7 A0[3C00]                 mov al, [TokeType]
  2874 00000EDA 3C03                     cmp al, 3
  2875 00000EDC 0F856000                 jne @@getCodeSize114
  2876                                  
  2877                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2878                                  
  2879 00000EE0 68[4A0F]                 push getCodeSize_0
  2880 00000EE3 8D064F75                 lea  ax, [SymbolUpper]
  2881 00000EE7 50                       push ax
  2882 00000EE8 E8AA10                   call eqstr
  2883 00000EEB 83C404                   add  sp, 4
  2884 00000EEE 08C0                     or  al, al
  2885 00000EF0 0F840C00                 je @@getCodeSize115
  2886 00000EF4 E8E6FC                   call getTokeType
  2887 00000EF7 66B801000000             mov eax, 1
  2888 00000EFD E94900                   jmp @@retn
  2889                                  
  2890                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2891                                  
  2892                                  @@getCodeSize115:
  2893 00000F00 68[4F0F]                 push getCodeSize_1
  2894 00000F03 8D064F75                 lea  ax, [SymbolUpper]
  2895 00000F07 50                       push ax
  2896 00000F08 E88A10                   call eqstr
  2897 00000F0B 83C404                   add  sp, 4
  2898 00000F0E 08C0                     or  al, al
  2899 00000F10 0F840C00                 je @@getCodeSize116
  2900 00000F14 E8C6FC                   call getTokeType
  2901 00000F17 66B802000000             mov eax, 2
  2902 00000F1D E92900                   jmp @@retn
  2903                                  
  2904                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2905                                  
  2906                                  @@getCodeSize116:
  2907 00000F20 68[540F]                 push getCodeSize_2
  2908 00000F23 8D064F75                 lea  ax, [SymbolUpper]
  2909 00000F27 50                       push ax
  2910 00000F28 E86A10                   call eqstr
  2911 00000F2B 83C404                   add  sp, 4
  2912 00000F2E 08C0                     or  al, al
  2913 00000F30 0F840C00                 je @@getCodeSize117
  2914 00000F34 E8A6FC                   call getTokeType
  2915 00000F37 66B803000000             mov eax, 3
  2916 00000F3D E90900                   jmp @@retn
  2917                                  
  2918                                  ;-102   } return 0;
  2919                                  
  2920                                  @@getCodeSize117:
  2921                                  @@getCodeSize114:
  2922 00000F40 66B800000000             mov eax, 0
  2923 00000F46 E90000                   jmp @@retn
  2924                                  
  2925                                  ;-103 }
  2926                                  
  2927                                  
  2928                                  ;-104 int isToken(char c) {
  2929                                  
  2930                                  @@retn:
  2931 00000F49 C3                       ret
  2932                                  ; ENDP
  2933 00000F4A 4259544500              getCodeSize_0 db "BYTE",0
  2934 00000F4F 574F524400              getCodeSize_1 db "WORD",0
  2935 00000F54 44574F524400            getCodeSize_2 db "DWORD",0
  2936                                  
  2937                                  isToken:  ; *** PROC ***
  2938                                  
  2939                                  ;-105   skipBlank();
  2940                                  
  2941                                  ;Function : isToken, Number of local variables: 1
  2942                                  ;   # type sign width line used address name   list of local variables
  2943                                  ;  200 var sign byte   104 NULL bp+4    c;
  2944 00000F5A C8000000                 ENTER  0,0
  2945 00000F5E E81D01                   call skipBlank
  2946                                  
  2947                                  ;-106   if (*InputPtr == c) {
  2948                                  
  2949 00000F61 8B1E[2800]               mov bx, [InputPtr]
  2950 00000F65 8A07                     mov al, [bx]
  2951 00000F67 B400                     mov ah, 0
  2952 00000F69 3A4604                   cmp al, [bp+4]
  2953 00000F6C 0F850D00                 jne @@isToken118
  2954                                  
  2955                                  ;-107     InputPtr++; return 1;} return 0;
  2956                                  
  2957 00000F70 FF06[2800]               inc  word [InputPtr]
  2958 00000F74 66B801000000             mov eax, 1
  2959 00000F7A E90900                   jmp @@retn
  2960                                  @@isToken118:
  2961 00000F7D 66B800000000             mov eax, 0
  2962 00000F83 E90000                   jmp @@retn
  2963                                  
  2964                                  ;-108 }
  2965                                  
  2966                                  
  2967                                  ;-109 int skipRest() {
  2968                                  
  2969 00000F86 C9                      @@retn: LEAVE
  2970 00000F87 C3                       ret
  2971                                  ; ENDP
  2972                                  
  2973                                  skipRest:  ; *** PROC ***
  2974                                  
  2975                                  ;-110   getTokeType(); if(TokeType!=0)error1("extra char ignored");
  2976                                  
  2977 00000F88 E852FC                   call getTokeType
  2978 00000F8B A0[3C00]                 mov al, [TokeType]
  2979 00000F8E 3C00                     cmp al, 0
  2980 00000F90 0F840900                 je  @@skipRest119
  2981 00000F94 68[9E0F]                 push skipRest_0
  2982 00000F97 E87409                   call error1
  2983 00000F9A 83C402                   add  sp, 2
  2984                                  
  2985                                  ;-111 }
  2986                                  
  2987                                  @@skipRest119:
  2988 00000F9D C3                       ret
  2989                                  ; ENDP
  2990 00000F9E 657874726120636861-     skipRest_0 db "extra char ignored",0
  2991 00000FA7 722069676E6F726564-
  2992 00000FB0 00                 
  2993                                  ;Back to main program: AS.C
  2994                                  
  2995                                  ;-212 #include "HELPER.C"
  2996                                  
  2997                                  ;Use include file: HELPER.C
  2998                                  
  2999                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3000                                  
  3001                                  
  3002                                  getLine:  ; *** PROC ***
  3003                                  
  3004                                  ;-2   InputPtr= &InputBuf;
  3005                                  
  3006 00000FB1 B86E75                   mov ax, InputBuf
  3007 00000FB4 A3[2800]                 mov word [InputPtr], ax
  3008                                  
  3009                                  ;-3   *InputPtr=0;//if last line is empty
  3010                                  
  3011 00000FB7 66B800000000             mov eax, 0
  3012 00000FBD 8B1E[2800]               mov  bx, [InputPtr]
  3013 00000FC1 8807                     mov  [bx], al
  3014                                  
  3015                                  ;-4   do {
  3016                                  
  3017                                  @@getLine120:
  3018                                  
  3019                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3020                                  
  3021 00000FC3 6A01                     push 1
  3022 00000FC5 FF36[2A00]               push word [asm_fd]
  3023 00000FC9 8D06[3600]               lea  ax, [DOS_ByteRead]
  3024 00000FCD 50                       push ax
  3025 00000FCE E85F10                   call readRL
  3026 00000FD1 83C406                   add  sp, 6
  3027 00000FD4 A3[3400]                 mov word [DOS_NoBytes], ax
  3028                                  
  3029                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  3030                                  
  3031 00000FD7 A1[3000]                 mov ax, [DOS_ERR]
  3032 00000FDA 08C0                     or  al, al
  3033 00000FDC 0F840900                 je @@getLine121
  3034 00000FE0 68[2810]                 push getLine_0
  3035 00000FE3 E8590A                   call errorexit
  3036 00000FE6 83C402                   add  sp, 2
  3037                                  
  3038                                  ;-7     if (DOS_NoBytes == 0) return;
  3039                                  
  3040                                  @@getLine121:
  3041 00000FE9 A1[3400]                 mov ax, [DOS_NoBytes]
  3042 00000FEC 83F800                   cmp ax, 0
  3043 00000FEF 0F850300                 jne @@getLine122
  3044 00000FF3 E93100                   jmp @@retn
  3045                                  
  3046                                  ;-8     *InputPtr = DOS_ByteRead;
  3047                                  
  3048                                  @@getLine122:
  3049 00000FF6 A0[3600]                 mov al, [DOS_ByteRead]
  3050 00000FF9 8B1E[2800]               mov  bx, [InputPtr]
  3051 00000FFD 8807                     mov  [bx], al
  3052                                  
  3053                                  ;-9     InputPtr++;
  3054                                  
  3055 00000FFF FF06[2800]               inc  word [InputPtr]
  3056                                  
  3057                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  3058                                  
  3059 00001003 A0[3600]                 mov al, byte [DOS_ByteRead]
  3060 00001006 B400                     mov ah, 0
  3061 00001008 50                       push ax
  3062 00001009 E82B00                   call ifEOL
  3063 0000100C 83C402                   add  sp, 2
  3064 0000100F 3C00                     cmp al, 0
  3065 00001011 0F850200                 jne @@getLine123
  3066 00001015 EBAC                     jmp @@getLine120
  3067                                  @@getLine123:
  3068                                  
  3069                                  ;-11   InputPtr--;
  3070                                  
  3071 00001017 FF0E[2800]               dec  word [InputPtr]
  3072                                  
  3073                                  ;-12   *InputPtr=0;
  3074                                  
  3075 0000101B 66B800000000             mov eax, 0
  3076 00001021 8B1E[2800]               mov  bx, [InputPtr]
  3077 00001025 8807                     mov  [bx], al
  3078                                  
  3079                                  ;-13 }
  3080                                  
  3081                                  
  3082                                  ;-14 int ifEOL(char c) {
  3083                                  
  3084                                  @@retn:
  3085 00001027 C3                       ret
  3086                                  ; ENDP
  3087 00001028 52656164696E672053-     getLine_0 db "Reading Source",0
  3088 00001031 6F7572636500       
  3089                                  
  3090                                  ifEOL:  ; *** PROC ***
  3091                                  
  3092                                  ;-15   if (c == 10) return 1;
  3093                                  
  3094                                  ;Function : ifEOL, Number of local variables: 1
  3095                                  ;   # type sign width line used address name   list of local variables
  3096                                  ;  200 var sign byte    14 NULL bp+4    c;
  3097 00001037 C8000000                 ENTER  0,0
  3098 0000103B 8A4604                   mov al, [bp+4]
  3099 0000103E 3C0A                     cmp al, 10
  3100 00001040 0F850900                 jne @@ifEOL124
  3101 00001044 66B801000000             mov eax, 1
  3102 0000104A E92F00                   jmp @@retn
  3103                                  
  3104                                  ;-16   if (c == 13) {
  3105                                  
  3106                                  @@ifEOL124:
  3107 0000104D 8A4604                   mov al, [bp+4]
  3108 00001050 3C0D                     cmp al, 13
  3109 00001052 0F851D00                 jne @@ifEOL125
  3110                                  
  3111                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3112                                  
  3113 00001056 6A01                     push 1
  3114 00001058 FF36[2A00]               push word [asm_fd]
  3115 0000105C 8D06[3600]               lea  ax, [DOS_ByteRead]
  3116 00001060 50                       push ax
  3117 00001061 E8CC0F                   call readRL
  3118 00001064 83C406                   add  sp, 6
  3119 00001067 A3[3400]                 mov word [DOS_NoBytes], ax
  3120                                  
  3121                                  ;-18     return 1;}
  3122                                  
  3123 0000106A 66B801000000             mov eax, 1
  3124 00001070 E90900                   jmp @@retn
  3125                                  
  3126                                  ;-19   return 0;
  3127                                  
  3128                                  @@ifEOL125:
  3129 00001073 66B800000000             mov eax, 0
  3130 00001079 E90000                   jmp @@retn
  3131                                  
  3132                                  ;-20 }
  3133                                  
  3134                                  
  3135                                  ;-21 int skipBlank() {
  3136                                  
  3137 0000107C C9                      @@retn: LEAVE
  3138 0000107D C3                       ret
  3139                                  ; ENDP
  3140                                  
  3141                                  skipBlank:  ; *** PROC ***
  3142                                  
  3143                                  ;-22   skipblank1:
  3144                                  
  3145                                  @@skipblank1:
  3146                                  
  3147                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3148                                  
  3149 0000107E 8B1E[2800]               mov bx, [InputPtr]
  3150 00001082 8A07                     mov al, [bx]
  3151 00001084 B400                     mov ah, 0
  3152 00001086 83F820                   cmp ax, 32
  3153 00001089 0F850600                 jne @@skipBlank126
  3154 0000108D FF06[2800]               inc  word [InputPtr]
  3155 00001091 EBEB                     jmp @@skipblank1
  3156                                  
  3157                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3158                                  
  3159                                  @@skipBlank126:
  3160 00001093 8B1E[2800]               mov bx, [InputPtr]
  3161 00001097 8A07                     mov al, [bx]
  3162 00001099 B400                     mov ah, 0
  3163 0000109B 83F809                   cmp ax, 9
  3164 0000109E 0F850600                 jne @@skipBlank127
  3165 000010A2 FF06[2800]               inc  word [InputPtr]
  3166 000010A6 EBD6                     jmp @@skipblank1
  3167                                  
  3168                                  ;-25 }
  3169                                  
  3170                                  @@skipBlank127:
  3171                                  
  3172                                  ;-26 int letterE(char c) {
  3173                                  
  3174 000010A8 C3                       ret
  3175                                  ; ENDP
  3176                                  
  3177                                  letterE:  ; *** PROC ***
  3178                                  
  3179                                  ;-27   if (c=='_') return 1;
  3180                                  
  3181                                  ;Function : letterE, Number of local variables: 1
  3182                                  ;   # type sign width line used address name   list of local variables
  3183                                  ;  200 var sign byte    26 NULL bp+4    c;
  3184 000010A9 C8000000                 ENTER  0,0
  3185 000010AD 8A4604                   mov al, [bp+4]
  3186 000010B0 3C5F                     cmp al, 95
  3187 000010B2 0F850900                 jne @@letterE128
  3188 000010B6 66B801000000             mov eax, 1
  3189 000010BC E97E00                   jmp @@retn
  3190                                  
  3191                                  ;-28   if (c=='.') return 1;
  3192                                  
  3193                                  @@letterE128:
  3194 000010BF 8A4604                   mov al, [bp+4]
  3195 000010C2 3C2E                     cmp al, 46
  3196 000010C4 0F850900                 jne @@letterE129
  3197 000010C8 66B801000000             mov eax, 1
  3198 000010CE E96C00                   jmp @@retn
  3199                                  
  3200                                  ;-29   if (c=='?') return 1;
  3201                                  
  3202                                  @@letterE129:
  3203 000010D1 8A4604                   mov al, [bp+4]
  3204 000010D4 3C3F                     cmp al, 63
  3205 000010D6 0F850900                 jne @@letterE130
  3206 000010DA 66B801000000             mov eax, 1
  3207 000010E0 E95A00                   jmp @@retn
  3208                                  
  3209                                  ;-30   if (c=='$') return 1;
  3210                                  
  3211                                  @@letterE130:
  3212 000010E3 8A4604                   mov al, [bp+4]
  3213 000010E6 3C24                     cmp al, 36
  3214 000010E8 0F850900                 jne @@letterE131
  3215 000010EC 66B801000000             mov eax, 1
  3216 000010F2 E94800                   jmp @@retn
  3217                                  
  3218                                  ;-31   if (c> 'z') return 0;
  3219                                  
  3220                                  @@letterE131:
  3221 000010F5 8A4604                   mov al, [bp+4]
  3222 000010F8 3C7A                     cmp al, 122
  3223 000010FA 0F8E0900                 jle @@letterE132
  3224 000010FE 66B800000000             mov eax, 0
  3225 00001104 E93600                   jmp @@retn
  3226                                  
  3227                                  ;-32   if (c< '@') return 0; // at included
  3228                                  
  3229                                  @@letterE132:
  3230 00001107 8A4604                   mov al, [bp+4]
  3231 0000110A 3C40                     cmp al, 64
  3232 0000110C 0F8D0900                 jge @@letterE133
  3233 00001110 66B800000000             mov eax, 0
  3234 00001116 E92400                   jmp @@retn
  3235                                  
  3236                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3237                                  
  3238                                  @@letterE133:
  3239 00001119 8A4604                   mov al, [bp+4]
  3240 0000111C 3C5A                     cmp al, 90
  3241 0000111E 0F8E1200                 jle @@letterE134
  3242 00001122 8A4604                   mov al, [bp+4]
  3243 00001125 3C61                     cmp al, 97
  3244 00001127 0F8D0900                 jge @@letterE135
  3245 0000112B 66B800000000             mov eax, 0
  3246 00001131 E90900                   jmp @@retn
  3247                                  @@letterE135:
  3248                                  
  3249                                  ;-34   return 1;
  3250                                  
  3251                                  @@letterE134:
  3252 00001134 66B801000000             mov eax, 1
  3253 0000113A E90000                   jmp @@retn
  3254                                  
  3255                                  ;-35 }
  3256                                  
  3257                                  
  3258                                  ;-36 int alnumE(char c) {
  3259                                  
  3260 0000113D C9                      @@retn: LEAVE
  3261 0000113E C3                       ret
  3262                                  ; ENDP
  3263                                  
  3264                                  alnumE:  ; *** PROC ***
  3265                                  
  3266                                  ;-37   if (digit(c)) return 1;
  3267                                  
  3268                                  ;Function : alnumE, Number of local variables: 1
  3269                                  ;   # type sign width line used address name   list of local variables
  3270                                  ;  200 var sign byte    36 NULL bp+4    c;
  3271 0000113F C8000000                 ENTER  0,0
  3272 00001143 8A4604                   mov al, byte [bp+4]
  3273 00001146 B400                     mov ah, 0
  3274 00001148 50                       push ax
  3275 00001149 E8160E                   call digit
  3276 0000114C 83C402                   add  sp, 2
  3277 0000114F 08C0                     or  al, al
  3278 00001151 0F840900                 je @@alnumE136
  3279 00001155 66B801000000             mov eax, 1
  3280 0000115B E92400                   jmp @@retn
  3281                                  
  3282                                  ;-38   if (letterE(c)) return 1;
  3283                                  
  3284                                  @@alnumE136:
  3285 0000115E 8A4604                   mov al, byte [bp+4]
  3286 00001161 B400                     mov ah, 0
  3287 00001163 50                       push ax
  3288 00001164 E842FF                   call letterE
  3289 00001167 83C402                   add  sp, 2
  3290 0000116A 08C0                     or  al, al
  3291 0000116C 0F840900                 je @@alnumE137
  3292 00001170 66B801000000             mov eax, 1
  3293 00001176 E90900                   jmp @@retn
  3294                                  
  3295                                  ;-39   return 0;
  3296                                  
  3297                                  @@alnumE137:
  3298 00001179 66B800000000             mov eax, 0
  3299 0000117F E90000                   jmp @@retn
  3300                                  
  3301                                  ;-40 }
  3302                                  
  3303                                  
  3304                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3305                                  
  3306 00001182 C9                      @@retn: LEAVE
  3307 00001183 C3                       ret
  3308                                  ; ENDP
  3309                                  
  3310                                  getDigit:  ; *** PROC ***
  3311                                  
  3312                                  ;-42   unsigned int CastInt;
  3313                                  
  3314                                  
  3315                                  ;-43   SymbolInt=0;
  3316                                  
  3317                                  ;Function : getDigit, Number of local variables: 2
  3318                                  ;   # type sign width line used address name   list of local variables
  3319                                  ;  200 var unsg byte    41 NULL bp+4    c
  3320                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3321 00001184 C8020000                 ENTER  2,0
  3322 00001188 66B800000000             mov eax, 0
  3323 0000118E A3[2600]                 mov word [SymbolInt], ax
  3324                                  
  3325                                  ;-44   do {
  3326                                  
  3327                                  @@getDigit138:
  3328                                  
  3329                                  ;-45     c-='0';
  3330                                  
  3331 00001191 806E0430                 sub  byte [bp+4], 48
  3332                                  
  3333                                  ;-46     SymbolInt=SymbolInt*10;
  3334                                  
  3335 00001195 A1[2600]                 mov ax, [SymbolInt]
  3336 00001198 66BB0A000000             mov ebx, 10
  3337 0000119E 66F7E3                   mul ebx
  3338 000011A1 A3[2600]                 mov word [SymbolInt], ax
  3339                                  
  3340                                  ;-47     ax=0; CastInt=c; //cast b2w
  3341                                  
  3342 000011A4 B80000                   mov  ax, 0
  3343 000011A7 8A4604                   mov al, [bp+4]
  3344 000011AA 8946FE                   mov word [bp-2], ax
  3345                                  
  3346                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3347                                  
  3348 000011AD A1[2600]                 mov ax, [SymbolInt]
  3349 000011B0 0346FE                   add ax, [bp-2]
  3350 000011B3 A3[2600]                 mov word [SymbolInt], ax
  3351                                  
  3352                                  ;-49     InputPtr++;
  3353                                  
  3354 000011B6 FF06[2800]               inc  word [InputPtr]
  3355                                  
  3356                                  ;-50     c = *InputPtr;
  3357                                  
  3358 000011BA 8B1E[2800]               mov bx, [InputPtr]
  3359 000011BE 8A07                     mov al, [bx]
  3360 000011C0 B400                     mov ah, 0
  3361 000011C2 884604                   mov byte [bp+4], al
  3362                                  
  3363                                  ;-51   } while(digit(c));
  3364                                  
  3365 000011C5 8A4604                   mov al, byte [bp+4]
  3366 000011C8 B400                     mov ah, 0
  3367 000011CA 50                       push ax
  3368 000011CB E8940D                   call digit
  3369 000011CE 83C402                   add  sp, 2
  3370 000011D1 08C0                     or  al, al
  3371 000011D3 0F840200                 je @@getDigit139
  3372 000011D7 EBB8                     jmp @@getDigit138
  3373                                  @@getDigit139:
  3374                                  
  3375                                  ;-52 }
  3376                                  
  3377                                  
  3378                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3379 000011D9 C9                       LEAVE
  3380 000011DA C3                       ret
  3381                                  ; ENDP
  3382                                  
  3383                                  getName:  ; *** PROC ***
  3384                                  
  3385                                  ;-54   char *p;
  3386                                  
  3387                                  
  3388                                  ;-55   p = &Symbol;
  3389                                  
  3390                                  ;Function : getName, Number of local variables: 2
  3391                                  ;   # type sign width line used address name   list of local variables
  3392                                  ;  200 var unsg byte    53 NULL bp+4    c
  3393                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3394 000011DB C8020000                 ENTER  2,0
  3395 000011DF B83075                   mov ax, Symbol
  3396 000011E2 8946FE                   mov word [bp-2], ax
  3397                                  
  3398                                  ;-56   *p = c;
  3399                                  
  3400 000011E5 8A4604                   mov al, [bp+4]
  3401 000011E8 8B5EFE                   mov  bx, [bp-2]
  3402 000011EB 8807                     mov  [bx], al
  3403                                  
  3404                                  ;-57   p++;
  3405                                  
  3406 000011ED FF46FE                   inc  word [bp-2]
  3407                                  
  3408                                  ;-58   while (alnumE(c)) {
  3409                                  
  3410                                  @@getName140:
  3411 000011F0 8A4604                   mov al, byte [bp+4]
  3412 000011F3 B400                     mov ah, 0
  3413 000011F5 50                       push ax
  3414 000011F6 E846FF                   call alnumE
  3415 000011F9 83C402                   add  sp, 2
  3416 000011FC 08C0                     or  al, al
  3417 000011FE 0F841C00                 je @@getName141
  3418                                  
  3419                                  ;-59     InputPtr++;
  3420                                  
  3421 00001202 FF06[2800]               inc  word [InputPtr]
  3422                                  
  3423                                  ;-60     c = *InputPtr;
  3424                                  
  3425 00001206 8B1E[2800]               mov bx, [InputPtr]
  3426 0000120A 8A07                     mov al, [bx]
  3427 0000120C B400                     mov ah, 0
  3428 0000120E 884604                   mov byte [bp+4], al
  3429                                  
  3430                                  ;-61     *p = c;
  3431                                  
  3432 00001211 8A4604                   mov al, [bp+4]
  3433 00001214 8B5EFE                   mov  bx, [bp-2]
  3434 00001217 8807                     mov  [bx], al
  3435                                  
  3436                                  ;-62     p++;
  3437                                  
  3438 00001219 FF46FE                   inc  word [bp-2]
  3439                                  
  3440                                  ;-63   }
  3441                                  
  3442                                  
  3443                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3444                                  
  3445 0000121C EBD2                     jmp @@getName140
  3446                                  @@getName141:
  3447 0000121E 8A4604                   mov al, [bp+4]
  3448 00001221 3C3A                     cmp al, 58
  3449 00001223 0F850C00                 jne @@getName142
  3450 00001227 66B801000000             mov eax, 1
  3451 0000122D A2[3B00]                 mov byte [isLabel], al
  3452 00001230 E90900                   jmp @@getName143
  3453                                  @@getName142:
  3454 00001233 66B800000000             mov eax, 0
  3455 00001239 A2[3B00]                 mov byte [isLabel], al
  3456                                  
  3457                                  ;-65   p--;
  3458                                  
  3459                                  @@getName143:
  3460 0000123C FF4EFE                   dec  word [bp-2]
  3461                                  
  3462                                  ;-66   *p = 0;
  3463                                  
  3464 0000123F 66B800000000             mov eax, 0
  3465 00001245 8B5EFE                   mov  bx, [bp-2]
  3466 00001248 8807                     mov  [bx], al
  3467                                  
  3468                                  ;-67   strcpy(SymbolUpper, Symbol);
  3469                                  
  3470 0000124A 8D063075                 lea  ax, [Symbol]
  3471 0000124E 50                       push ax
  3472 0000124F 8D064F75                 lea  ax, [SymbolUpper]
  3473 00001253 50                       push ax
  3474 00001254 E8D20C                   call strcpy
  3475 00001257 83C404                   add  sp, 4
  3476                                  
  3477                                  ;-68   toupper(SymbolUpper);
  3478                                  
  3479 0000125A 8D064F75                 lea  ax, [SymbolUpper]
  3480 0000125E 50                       push ax
  3481 0000125F E8590C                   call toupper
  3482 00001262 83C402                   add  sp, 2
  3483                                  
  3484                                  ;-69 }
  3485                                  
  3486                                  
  3487                                  ;-70 int testReg() {
  3488 00001265 C9                       LEAVE
  3489 00001266 C3                       ret
  3490                                  ; ENDP
  3491                                  
  3492                                  testReg:  ; *** PROC ***
  3493                                  
  3494                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3495                                  
  3496                                  
  3497                                  ;-72   RegType=0;
  3498                                  
  3499 00001267 66B800000000             mov eax, 0
  3500 0000126D A2[4200]                 mov byte [RegType], al
  3501                                  
  3502                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3503                                  
  3504 00001270 8D063075                 lea  ax, [Symbol]
  3505 00001274 50                       push ax
  3506 00001275 E8860C                   call strlen
  3507 00001278 83C402                   add  sp, 2
  3508 0000127B 3C02                     cmp al, 2
  3509 0000127D 0F8D0900                 jge @@testReg144
  3510 00001281 66B800000000             mov eax, 0
  3511 00001287 E9B603                   jmp @@retn
  3512                                  
  3513                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3514                                  
  3515                                  @@testReg144:
  3516 0000128A 8D063075                 lea  ax, [Symbol]
  3517 0000128E 50                       push ax
  3518 0000128F E86C0C                   call strlen
  3519 00001292 83C402                   add  sp, 2
  3520 00001295 3C03                     cmp al, 3
  3521 00001297 0F8E0900                 jle @@testReg145
  3522 0000129B 66B800000000             mov eax, 0
  3523 000012A1 E99C03                   jmp @@retn
  3524                                  
  3525                                  ;-75   RegType=BYTE;
  3526                                  
  3527                                  @@testReg145:
  3528 000012A4 66B801000000             mov eax, 1
  3529 000012AA A2[4200]                 mov byte [RegType], al
  3530                                  
  3531                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3532                                  
  3533 000012AD 68[4116]                 push testReg_0
  3534 000012B0 8D064F75                 lea  ax, [SymbolUpper]
  3535 000012B4 50                       push ax
  3536 000012B5 E8DD0C                   call eqstr
  3537 000012B8 83C404                   add  sp, 4
  3538 000012BB 08C0                     or  al, al
  3539 000012BD 0F840900                 je @@testReg146
  3540 000012C1 66B800000000             mov eax, 0
  3541 000012C7 E97603                   jmp @@retn
  3542                                  
  3543                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3544                                  
  3545                                  @@testReg146:
  3546 000012CA 68[4416]                 push testReg_1
  3547 000012CD 8D064F75                 lea  ax, [SymbolUpper]
  3548 000012D1 50                       push ax
  3549 000012D2 E8C00C                   call eqstr
  3550 000012D5 83C404                   add  sp, 4
  3551 000012D8 08C0                     or  al, al
  3552 000012DA 0F840900                 je @@testReg147
  3553 000012DE 66B801000000             mov eax, 1
  3554 000012E4 E95903                   jmp @@retn
  3555                                  
  3556                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3557                                  
  3558                                  @@testReg147:
  3559 000012E7 68[4716]                 push testReg_2
  3560 000012EA 8D064F75                 lea  ax, [SymbolUpper]
  3561 000012EE 50                       push ax
  3562 000012EF E8A30C                   call eqstr
  3563 000012F2 83C404                   add  sp, 4
  3564 000012F5 08C0                     or  al, al
  3565 000012F7 0F840900                 je @@testReg148
  3566 000012FB 66B802000000             mov eax, 2
  3567 00001301 E93C03                   jmp @@retn
  3568                                  
  3569                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3570                                  
  3571                                  @@testReg148:
  3572 00001304 68[4A16]                 push testReg_3
  3573 00001307 8D064F75                 lea  ax, [SymbolUpper]
  3574 0000130B 50                       push ax
  3575 0000130C E8860C                   call eqstr
  3576 0000130F 83C404                   add  sp, 4
  3577 00001312 08C0                     or  al, al
  3578 00001314 0F840900                 je @@testReg149
  3579 00001318 66B803000000             mov eax, 3
  3580 0000131E E91F03                   jmp @@retn
  3581                                  
  3582                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3583                                  
  3584                                  @@testReg149:
  3585 00001321 68[4D16]                 push testReg_4
  3586 00001324 8D064F75                 lea  ax, [SymbolUpper]
  3587 00001328 50                       push ax
  3588 00001329 E8690C                   call eqstr
  3589 0000132C 83C404                   add  sp, 4
  3590 0000132F 08C0                     or  al, al
  3591 00001331 0F840900                 je @@testReg150
  3592 00001335 66B804000000             mov eax, 4
  3593 0000133B E90203                   jmp @@retn
  3594                                  
  3595                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3596                                  
  3597                                  @@testReg150:
  3598 0000133E 68[5016]                 push testReg_5
  3599 00001341 8D064F75                 lea  ax, [SymbolUpper]
  3600 00001345 50                       push ax
  3601 00001346 E84C0C                   call eqstr
  3602 00001349 83C404                   add  sp, 4
  3603 0000134C 08C0                     or  al, al
  3604 0000134E 0F840900                 je @@testReg151
  3605 00001352 66B805000000             mov eax, 5
  3606 00001358 E9E502                   jmp @@retn
  3607                                  
  3608                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3609                                  
  3610                                  @@testReg151:
  3611 0000135B 68[5316]                 push testReg_6
  3612 0000135E 8D064F75                 lea  ax, [SymbolUpper]
  3613 00001362 50                       push ax
  3614 00001363 E82F0C                   call eqstr
  3615 00001366 83C404                   add  sp, 4
  3616 00001369 08C0                     or  al, al
  3617 0000136B 0F840900                 je @@testReg152
  3618 0000136F 66B806000000             mov eax, 6
  3619 00001375 E9C802                   jmp @@retn
  3620                                  
  3621                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3622                                  
  3623                                  @@testReg152:
  3624 00001378 68[5616]                 push testReg_7
  3625 0000137B 8D064F75                 lea  ax, [SymbolUpper]
  3626 0000137F 50                       push ax
  3627 00001380 E8120C                   call eqstr
  3628 00001383 83C404                   add  sp, 4
  3629 00001386 08C0                     or  al, al
  3630 00001388 0F840900                 je @@testReg153
  3631 0000138C 66B807000000             mov eax, 7
  3632 00001392 E9AB02                   jmp @@retn
  3633                                  
  3634                                  ;-84   RegType=WORD;
  3635                                  
  3636                                  @@testReg153:
  3637 00001395 66B802000000             mov eax, 2
  3638 0000139B A2[4200]                 mov byte [RegType], al
  3639                                  
  3640                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3641                                  
  3642 0000139E 68[5916]                 push testReg_8
  3643 000013A1 8D064F75                 lea  ax, [SymbolUpper]
  3644 000013A5 50                       push ax
  3645 000013A6 E8EC0B                   call eqstr
  3646 000013A9 83C404                   add  sp, 4
  3647 000013AC 08C0                     or  al, al
  3648 000013AE 0F840900                 je @@testReg154
  3649 000013B2 66B800000000             mov eax, 0
  3650 000013B8 E98502                   jmp @@retn
  3651                                  
  3652                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3653                                  
  3654                                  @@testReg154:
  3655 000013BB 68[5C16]                 push testReg_9
  3656 000013BE 8D064F75                 lea  ax, [SymbolUpper]
  3657 000013C2 50                       push ax
  3658 000013C3 E8CF0B                   call eqstr
  3659 000013C6 83C404                   add  sp, 4
  3660 000013C9 08C0                     or  al, al
  3661 000013CB 0F840900                 je @@testReg155
  3662 000013CF 66B801000000             mov eax, 1
  3663 000013D5 E96802                   jmp @@retn
  3664                                  
  3665                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3666                                  
  3667                                  @@testReg155:
  3668 000013D8 68[5F16]                 push testReg_10
  3669 000013DB 8D064F75                 lea  ax, [SymbolUpper]
  3670 000013DF 50                       push ax
  3671 000013E0 E8B20B                   call eqstr
  3672 000013E3 83C404                   add  sp, 4
  3673 000013E6 08C0                     or  al, al
  3674 000013E8 0F840900                 je @@testReg156
  3675 000013EC 66B802000000             mov eax, 2
  3676 000013F2 E94B02                   jmp @@retn
  3677                                  
  3678                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3679                                  
  3680                                  @@testReg156:
  3681 000013F5 68[6216]                 push testReg_11
  3682 000013F8 8D064F75                 lea  ax, [SymbolUpper]
  3683 000013FC 50                       push ax
  3684 000013FD E8950B                   call eqstr
  3685 00001400 83C404                   add  sp, 4
  3686 00001403 08C0                     or  al, al
  3687 00001405 0F840900                 je @@testReg157
  3688 00001409 66B803000000             mov eax, 3
  3689 0000140F E92E02                   jmp @@retn
  3690                                  
  3691                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3692                                  
  3693                                  @@testReg157:
  3694 00001412 68[6516]                 push testReg_12
  3695 00001415 8D064F75                 lea  ax, [SymbolUpper]
  3696 00001419 50                       push ax
  3697 0000141A E8780B                   call eqstr
  3698 0000141D 83C404                   add  sp, 4
  3699 00001420 08C0                     or  al, al
  3700 00001422 0F840900                 je @@testReg158
  3701 00001426 66B804000000             mov eax, 4
  3702 0000142C E91102                   jmp @@retn
  3703                                  
  3704                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3705                                  
  3706                                  @@testReg158:
  3707 0000142F 68[6816]                 push testReg_13
  3708 00001432 8D064F75                 lea  ax, [SymbolUpper]
  3709 00001436 50                       push ax
  3710 00001437 E85B0B                   call eqstr
  3711 0000143A 83C404                   add  sp, 4
  3712 0000143D 08C0                     or  al, al
  3713 0000143F 0F840900                 je @@testReg159
  3714 00001443 66B805000000             mov eax, 5
  3715 00001449 E9F401                   jmp @@retn
  3716                                  
  3717                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3718                                  
  3719                                  @@testReg159:
  3720 0000144C 68[6B16]                 push testReg_14
  3721 0000144F 8D064F75                 lea  ax, [SymbolUpper]
  3722 00001453 50                       push ax
  3723 00001454 E83E0B                   call eqstr
  3724 00001457 83C404                   add  sp, 4
  3725 0000145A 08C0                     or  al, al
  3726 0000145C 0F840900                 je @@testReg160
  3727 00001460 66B806000000             mov eax, 6
  3728 00001466 E9D701                   jmp @@retn
  3729                                  
  3730                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3731                                  
  3732                                  @@testReg160:
  3733 00001469 68[6E16]                 push testReg_15
  3734 0000146C 8D064F75                 lea  ax, [SymbolUpper]
  3735 00001470 50                       push ax
  3736 00001471 E8210B                   call eqstr
  3737 00001474 83C404                   add  sp, 4
  3738 00001477 08C0                     or  al, al
  3739 00001479 0F840900                 je @@testReg161
  3740 0000147D 66B807000000             mov eax, 7
  3741 00001483 E9BA01                   jmp @@retn
  3742                                  
  3743                                  ;-93   RegType=SEGREG;
  3744                                  
  3745                                  @@testReg161:
  3746 00001486 66B804000000             mov eax, 4
  3747 0000148C A2[4200]                 mov byte [RegType], al
  3748                                  
  3749                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3750                                  
  3751 0000148F 68[7116]                 push testReg_16
  3752 00001492 8D064F75                 lea  ax, [SymbolUpper]
  3753 00001496 50                       push ax
  3754 00001497 E8FB0A                   call eqstr
  3755 0000149A 83C404                   add  sp, 4
  3756 0000149D 08C0                     or  al, al
  3757 0000149F 0F840900                 je @@testReg162
  3758 000014A3 66B800000000             mov eax, 0
  3759 000014A9 E99401                   jmp @@retn
  3760                                  
  3761                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3762                                  
  3763                                  @@testReg162:
  3764 000014AC 68[7416]                 push testReg_17
  3765 000014AF 8D064F75                 lea  ax, [SymbolUpper]
  3766 000014B3 50                       push ax
  3767 000014B4 E8DE0A                   call eqstr
  3768 000014B7 83C404                   add  sp, 4
  3769 000014BA 08C0                     or  al, al
  3770 000014BC 0F840900                 je @@testReg163
  3771 000014C0 66B801000000             mov eax, 1
  3772 000014C6 E97701                   jmp @@retn
  3773                                  
  3774                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3775                                  
  3776                                  @@testReg163:
  3777 000014C9 68[7716]                 push testReg_18
  3778 000014CC 8D064F75                 lea  ax, [SymbolUpper]
  3779 000014D0 50                       push ax
  3780 000014D1 E8C10A                   call eqstr
  3781 000014D4 83C404                   add  sp, 4
  3782 000014D7 08C0                     or  al, al
  3783 000014D9 0F840900                 je @@testReg164
  3784 000014DD 66B802000000             mov eax, 2
  3785 000014E3 E95A01                   jmp @@retn
  3786                                  
  3787                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3788                                  
  3789                                  @@testReg164:
  3790 000014E6 68[7A16]                 push testReg_19
  3791 000014E9 8D064F75                 lea  ax, [SymbolUpper]
  3792 000014ED 50                       push ax
  3793 000014EE E8A40A                   call eqstr
  3794 000014F1 83C404                   add  sp, 4
  3795 000014F4 08C0                     or  al, al
  3796 000014F6 0F840900                 je @@testReg165
  3797 000014FA 66B803000000             mov eax, 3
  3798 00001500 E93D01                   jmp @@retn
  3799                                  
  3800                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3801                                  
  3802                                  @@testReg165:
  3803 00001503 68[7D16]                 push testReg_20
  3804 00001506 8D064F75                 lea  ax, [SymbolUpper]
  3805 0000150A 50                       push ax
  3806 0000150B E8870A                   call eqstr
  3807 0000150E 83C404                   add  sp, 4
  3808 00001511 08C0                     or  al, al
  3809 00001513 0F840900                 je @@testReg166
  3810 00001517 66B804000000             mov eax, 4
  3811 0000151D E92001                   jmp @@retn
  3812                                  
  3813                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3814                                  
  3815                                  @@testReg166:
  3816 00001520 68[8016]                 push testReg_21
  3817 00001523 8D064F75                 lea  ax, [SymbolUpper]
  3818 00001527 50                       push ax
  3819 00001528 E86A0A                   call eqstr
  3820 0000152B 83C404                   add  sp, 4
  3821 0000152E 08C0                     or  al, al
  3822 00001530 0F840900                 je @@testReg167
  3823 00001534 66B805000000             mov eax, 5
  3824 0000153A E90301                   jmp @@retn
  3825                                  
  3826                                  ;-100   RegType=DWORD;
  3827                                  
  3828                                  @@testReg167:
  3829 0000153D 66B803000000             mov eax, 3
  3830 00001543 A2[4200]                 mov byte [RegType], al
  3831                                  
  3832                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3833                                  
  3834 00001546 68[8316]                 push testReg_22
  3835 00001549 8D064F75                 lea  ax, [SymbolUpper]
  3836 0000154D 50                       push ax
  3837 0000154E E8440A                   call eqstr
  3838 00001551 83C404                   add  sp, 4
  3839 00001554 08C0                     or  al, al
  3840 00001556 0F840900                 je @@testReg168
  3841 0000155A 66B800000000             mov eax, 0
  3842 00001560 E9DD00                   jmp @@retn
  3843                                  
  3844                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3845                                  
  3846                                  @@testReg168:
  3847 00001563 68[8716]                 push testReg_23
  3848 00001566 8D064F75                 lea  ax, [SymbolUpper]
  3849 0000156A 50                       push ax
  3850 0000156B E8270A                   call eqstr
  3851 0000156E 83C404                   add  sp, 4
  3852 00001571 08C0                     or  al, al
  3853 00001573 0F840900                 je @@testReg169
  3854 00001577 66B801000000             mov eax, 1
  3855 0000157D E9C000                   jmp @@retn
  3856                                  
  3857                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3858                                  
  3859                                  @@testReg169:
  3860 00001580 68[8B16]                 push testReg_24
  3861 00001583 8D064F75                 lea  ax, [SymbolUpper]
  3862 00001587 50                       push ax
  3863 00001588 E80A0A                   call eqstr
  3864 0000158B 83C404                   add  sp, 4
  3865 0000158E 08C0                     or  al, al
  3866 00001590 0F840900                 je @@testReg170
  3867 00001594 66B802000000             mov eax, 2
  3868 0000159A E9A300                   jmp @@retn
  3869                                  
  3870                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3871                                  
  3872                                  @@testReg170:
  3873 0000159D 68[8F16]                 push testReg_25
  3874 000015A0 8D064F75                 lea  ax, [SymbolUpper]
  3875 000015A4 50                       push ax
  3876 000015A5 E8ED09                   call eqstr
  3877 000015A8 83C404                   add  sp, 4
  3878 000015AB 08C0                     or  al, al
  3879 000015AD 0F840900                 je @@testReg171
  3880 000015B1 66B803000000             mov eax, 3
  3881 000015B7 E98600                   jmp @@retn
  3882                                  
  3883                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3884                                  
  3885                                  @@testReg171:
  3886 000015BA 68[9316]                 push testReg_26
  3887 000015BD 8D064F75                 lea  ax, [SymbolUpper]
  3888 000015C1 50                       push ax
  3889 000015C2 E8D009                   call eqstr
  3890 000015C5 83C404                   add  sp, 4
  3891 000015C8 08C0                     or  al, al
  3892 000015CA 0F840900                 je @@testReg172
  3893 000015CE 66B804000000             mov eax, 4
  3894 000015D4 E96900                   jmp @@retn
  3895                                  
  3896                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3897                                  
  3898                                  @@testReg172:
  3899 000015D7 68[9716]                 push testReg_27
  3900 000015DA 8D064F75                 lea  ax, [SymbolUpper]
  3901 000015DE 50                       push ax
  3902 000015DF E8B309                   call eqstr
  3903 000015E2 83C404                   add  sp, 4
  3904 000015E5 08C0                     or  al, al
  3905 000015E7 0F840900                 je @@testReg173
  3906 000015EB 66B805000000             mov eax, 5
  3907 000015F1 E94C00                   jmp @@retn
  3908                                  
  3909                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3910                                  
  3911                                  @@testReg173:
  3912 000015F4 68[9B16]                 push testReg_28
  3913 000015F7 8D064F75                 lea  ax, [SymbolUpper]
  3914 000015FB 50                       push ax
  3915 000015FC E89609                   call eqstr
  3916 000015FF 83C404                   add  sp, 4
  3917 00001602 08C0                     or  al, al
  3918 00001604 0F840900                 je @@testReg174
  3919 00001608 66B806000000             mov eax, 6
  3920 0000160E E92F00                   jmp @@retn
  3921                                  
  3922                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3923                                  
  3924                                  @@testReg174:
  3925 00001611 68[9F16]                 push testReg_29
  3926 00001614 8D064F75                 lea  ax, [SymbolUpper]
  3927 00001618 50                       push ax
  3928 00001619 E87909                   call eqstr
  3929 0000161C 83C404                   add  sp, 4
  3930 0000161F 08C0                     or  al, al
  3931 00001621 0F840900                 je @@testReg175
  3932 00001625 66B807000000             mov eax, 7
  3933 0000162B E91200                   jmp @@retn
  3934                                  
  3935                                  ;-109   RegType=0; return 0;
  3936                                  
  3937                                  @@testReg175:
  3938 0000162E 66B800000000             mov eax, 0
  3939 00001634 A2[4200]                 mov byte [RegType], al
  3940 00001637 66B800000000             mov eax, 0
  3941 0000163D E90000                   jmp @@retn
  3942                                  
  3943                                  ;-110 }
  3944                                  
  3945                                  @@retn:
  3946 00001640 C3                       ret
  3947                                  ; ENDP
  3948 00001641 414C00                  testReg_0 db "AL",0
  3949 00001644 434C00                  testReg_1 db "CL",0
  3950 00001647 444C00                  testReg_2 db "DL",0
  3951 0000164A 424C00                  testReg_3 db "BL",0
  3952 0000164D 414800                  testReg_4 db "AH",0
  3953 00001650 434800                  testReg_5 db "CH",0
  3954 00001653 444800                  testReg_6 db "DH",0
  3955 00001656 424800                  testReg_7 db "BH",0
  3956 00001659 415800                  testReg_8 db "AX",0
  3957 0000165C 435800                  testReg_9 db "CX",0
  3958 0000165F 445800                  testReg_10 db "DX",0
  3959 00001662 425800                  testReg_11 db "BX",0
  3960 00001665 535000                  testReg_12 db "SP",0
  3961 00001668 425000                  testReg_13 db "BP",0
  3962 0000166B 534900                  testReg_14 db "SI",0
  3963 0000166E 444900                  testReg_15 db "DI",0
  3964 00001671 455300                  testReg_16 db "ES",0
  3965 00001674 435300                  testReg_17 db "CS",0
  3966 00001677 535300                  testReg_18 db "SS",0
  3967 0000167A 445300                  testReg_19 db "DS",0
  3968 0000167D 465300                  testReg_20 db "FS",0
  3969 00001680 475300                  testReg_21 db "GS",0
  3970 00001683 45415800                testReg_22 db "EAX",0
  3971 00001687 45435800                testReg_23 db "ECX",0
  3972 0000168B 45445800                testReg_24 db "EDX",0
  3973 0000168F 45425800                testReg_25 db "EBX",0
  3974 00001693 45535000                testReg_26 db "ESP",0
  3975 00001697 45425000                testReg_27 db "EBP",0
  3976 0000169B 45534900                testReg_28 db "ESI",0
  3977 0000169F 45444900                testReg_29 db "EDI",0
  3978                                  ;Back to main program: AS.C
  3979                                  
  3980                                  ;-213 #include "OUTPUT.C"
  3981                                  
  3982                                  ;Use include file: OUTPUT.C
  3983                                  
  3984                                  ;-1 int printLine() { int i; char c;
  3985                                  
  3986                                  
  3987                                  printLine:  ; *** PROC ***
  3988                                  
  3989                                  ;-2   prs("\n"); printhex16(PCStart);
  3990                                  
  3991                                  ;Function : printLine, Number of local variables: 2
  3992                                  ;   # type sign width line used address name   list of local variables
  3993                                  ;  200 var sign word     1 NULL bp-2    i
  3994                                  ;  201 var sign byte     1 NULL bp-4    c;
  3995 000016A3 C8040000                 ENTER  4,0
  3996 000016A7 68[3817]                 push printLine_0
  3997 000016AA E80401                   call prs
  3998 000016AD 83C402                   add  sp, 2
  3999 000016B0 FF36[3900]               push word [PCStart]
  4000 000016B4 E8EB01                   call printhex16
  4001 000016B7 83C402                   add  sp, 2
  4002                                  
  4003                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  4004                                  
  4005 000016BA A1[4B00]                 mov ax, [OpPrintIndex]
  4006 000016BD 83F800                   cmp ax, 0
  4007 000016C0 0F850C00                 jne @@printLine176
  4008 000016C4 68[3B17]                 push printLine_1
  4009 000016C7 E8E700                   call prs
  4010 000016CA 83C402                   add  sp, 2
  4011                                  
  4012                                  ;-4   else {
  4013                                  
  4014 000016CD E95B00                   jmp @@printLine177
  4015                                  @@printLine176:
  4016                                  
  4017                                  ;-5     prc(PrintR);
  4018                                  
  4019 000016D0 A0[4F00]                 mov al, byte [PrintR]
  4020 000016D3 B400                     mov ah, 0
  4021 000016D5 50                       push ax
  4022 000016D6 E87700                   call prc
  4023 000016D9 83C402                   add  sp, 2
  4024                                  
  4025                                  ;-6     i=0;
  4026                                  
  4027 000016DC 66B800000000             mov eax, 0
  4028 000016E2 8946FE                   mov word [bp-2], ax
  4029                                  
  4030                                  ;-7     do {
  4031                                  
  4032                                  @@printLine178:
  4033                                  
  4034                                  ;-8       c=OpPos[i];
  4035                                  
  4036 000016E5 8B5EFE                   mov bx, [bp-2]
  4037 000016E8 8A87B676                 mov al, [OpPos + bx]
  4038 000016EC 8846FC                   mov byte [bp-4], al
  4039                                  
  4040                                  ;-9       printhex8a(c); prc(' ');
  4041                                  
  4042 000016EF 8A46FC                   mov al, byte [bp-4]
  4043 000016F2 B400                     mov ah, 0
  4044 000016F4 50                       push ax
  4045 000016F5 E85C01                   call printhex8a
  4046 000016F8 83C402                   add  sp, 2
  4047 000016FB 6A20                     push 32
  4048 000016FD E85000                   call prc
  4049 00001700 83C402                   add  sp, 2
  4050                                  
  4051                                  ;-10       i++;
  4052                                  
  4053 00001703 FF46FE                   inc  word [bp-2]
  4054                                  
  4055                                  ;-11     } while(i < OpPrintIndex);
  4056                                  
  4057 00001706 8B46FE                   mov ax, [bp-2]
  4058 00001709 3B06[4B00]               cmp ax, [OpPrintIndex]
  4059 0000170D 0F8D0200                 jge @@printLine179
  4060 00001711 EBD2                     jmp @@printLine178
  4061                                  @@printLine179:
  4062                                  
  4063                                  ;-12     do {// fill rest with blank
  4064                                  
  4065                                  @@printLine180:
  4066                                  
  4067                                  ;-13       prs("   ");
  4068                                  
  4069 00001713 68[4C17]                 push printLine_2
  4070 00001716 E89800                   call prs
  4071 00001719 83C402                   add  sp, 2
  4072                                  
  4073                                  ;-14       i++;
  4074                                  
  4075 0000171C FF46FE                   inc  word [bp-2]
  4076                                  
  4077                                  ;-15     } while(i < OPMAXLEN);
  4078                                  
  4079 0000171F 8B46FE                   mov ax, [bp-2]
  4080 00001722 83F805                   cmp ax, 5
  4081 00001725 0F8D0200                 jge @@printLine181
  4082 00001729 EBE8                     jmp @@printLine180
  4083                                  @@printLine181:
  4084                                  
  4085                                  ;-16   }
  4086                                  
  4087                                  
  4088                                  ;-17   prscomment(InputBuf);
  4089                                  
  4090                                  @@printLine177:
  4091 0000172B 8D066E75                 lea  ax, [InputBuf]
  4092 0000172F 50                       push ax
  4093 00001730 E85000                   call prscomment
  4094 00001733 83C402                   add  sp, 2
  4095                                  
  4096                                  ;-18 }
  4097                                  
  4098                                  
  4099                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4100 00001736 C9                       LEAVE
  4101 00001737 C3                       ret
  4102                                  ; ENDP
  4103 00001738 5C6E00                  printLine_0 db "\n",0
  4104 0000173B 202020202020202020-     printLine_1 db "                ",0
  4105 00001744 2020202020202000   
  4106 0000174C 20202000                printLine_2 db "   ",0
  4107                                  
  4108                                  prc:  ; *** PROC ***
  4109                                  ;Function : prc, Number of local variables: 1
  4110                                  ;   # type sign width line used address name   list of local variables
  4111                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4112 00001750 C8000000                 ENTER  0,0
  4113 00001754 A0[2500]                 mov al, [LIST]
  4114 00001757 08C0                     or  al, al
  4115 00001759 0F841400                 je @@prc182
  4116 0000175D 807E040A                cmp byte [bp+4], 10
  4117 00001761 0F850600                 jne @@prc183
  4118 00001765 B80D00                   mov  ax, 13
  4119 00001768 E81A07                   call writetty
  4120                                  
  4121                                  ;-20      al=c; writetty(); }
  4122                                  
  4123                                  @@prc183:
  4124 0000176B 8A4604                   mov  al, [bp+4]
  4125 0000176E E81407                   call writetty
  4126                                  
  4127                                  ;-21    fputcR(c,lst_fd); }
  4128                                  
  4129                                  @@prc182:
  4130 00001771 FF36[2C00]               push word [lst_fd]
  4131 00001775 8A4604                   mov al, byte [bp+4]
  4132 00001778 B400                     mov ah, 0
  4133 0000177A 50                       push ax
  4134 0000177B E8C708                   call fputcR
  4135 0000177E 83C404                   add  sp, 4
  4136                                  
  4137                                  ;-22 
  4138                                  
  4139                                  
  4140                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4141 00001781 C9                       LEAVE
  4142 00001782 C3                       ret
  4143                                  ; ENDP
  4144                                  
  4145                                  prscomment:  ; *** PROC ***
  4146                                  
  4147                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4148                                  
  4149                                  ;Function : prscomment, Number of local variables: 2
  4150                                  ;   # type sign width line used address name   list of local variables
  4151                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4152                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4153 00001783 C8020000                 ENTER  2,0
  4154                                  @@prscomment184:
  4155 00001787 8B5E04                   mov bx, [bp+4]
  4156 0000178A 8A07                     mov al, [bx]
  4157 0000178C B400                     mov ah, 0
  4158 0000178E 08C0                     or  al, al
  4159 00001790 0F841B00                 je @@prscomment185
  4160 00001794 8B5E04                   mov bx, [bp+4]
  4161 00001797 8A07                     mov al, [bx]
  4162 00001799 B400                     mov ah, 0
  4163 0000179B 8846FE                   mov byte [bp-2], al
  4164 0000179E 8A46FE                   mov al, byte [bp-2]
  4165 000017A1 B400                     mov ah, 0
  4166 000017A3 50                       push ax
  4167 000017A4 E8A9FF                   call prc
  4168 000017A7 83C402                   add  sp, 2
  4169 000017AA FF4604                   inc  word [bp+4]
  4170                                  
  4171                                  ;-25 }
  4172                                  
  4173 000017AD EBD8                     jmp @@prscomment184
  4174                                  @@prscomment185:
  4175                                  
  4176                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4177 000017AF C9                       LEAVE
  4178 000017B0 C3                       ret
  4179                                  ; ENDP
  4180                                  
  4181                                  prs:  ; *** PROC ***
  4182                                  ;Function : prs, Number of local variables: 3
  4183                                  ;   # type sign width line used address name   list of local variables
  4184                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4185                                  ;  201 var unsg byte    26 NULL bp-2    c
  4186                                  ;  202 var sign word    26 NULL bp-4    com;
  4187 000017B1 C8040000                 ENTER  4,0
  4188 000017B5 66B800000000             mov eax, 0
  4189 000017BB 8946FC                   mov word [bp-4], ax
  4190                                  
  4191                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4192                                  
  4193                                  @@prs186:
  4194 000017BE 8B5E04                   mov bx, [bp+4]
  4195 000017C1 8A07                     mov al, [bx]
  4196 000017C3 B400                     mov ah, 0
  4197 000017C5 08C0                     or  al, al
  4198 000017C7 0F848700                 je @@prs187
  4199 000017CB 8B5E04                   mov bx, [bp+4]
  4200 000017CE 8A07                     mov al, [bx]
  4201 000017D0 B400                     mov ah, 0
  4202 000017D2 8846FE                   mov byte [bp-2], al
  4203 000017D5 8A46FE                   mov al, [bp-2]
  4204 000017D8 3C22                     cmp al, 34
  4205 000017DA 0F851E00                 jne @@prs188
  4206 000017DE 8B46FC                   mov ax, [bp-4]
  4207 000017E1 08C0                     or  al, al
  4208 000017E3 0F840C00                 je @@prs189
  4209 000017E7 66B800000000             mov eax, 0
  4210 000017ED 8946FC                   mov word [bp-4], ax
  4211 000017F0 E90900                   jmp @@prs190
  4212                                  @@prs189:
  4213 000017F3 66B801000000             mov eax, 1
  4214 000017F9 8946FC                   mov word [bp-4], ax
  4215                                  
  4216                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4217                                  
  4218                                  @@prs190:
  4219                                  @@prs188:
  4220 000017FC 8A46FE                   mov al, [bp-2]
  4221 000017FF 3C5C                     cmp al, 92
  4222 00001801 0F853B00                 jne @@prs191
  4223 00001805 8B46FC                   mov ax, [bp-4]
  4224 00001808 83F800                   cmp ax, 0
  4225 0000180B 0F853100                 jne @@prs192
  4226 0000180F FF4604                   inc  word [bp+4]
  4227 00001812 8B5E04                   mov bx, [bp+4]
  4228 00001815 8A07                     mov al, [bx]
  4229 00001817 B400                     mov ah, 0
  4230 00001819 8846FE                   mov byte [bp-2], al
  4231                                  
  4232                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4233                                  
  4234 0000181C 8A46FE                   mov al, [bp-2]
  4235 0000181F 3C6E                     cmp al, 110
  4236 00001821 0F850900                 jne @@prs193
  4237 00001825 66B80A000000             mov eax, 10
  4238 0000182B 8846FE                   mov byte [bp-2], al
  4239                                  @@prs193:
  4240 0000182E 8A46FE                   mov al, [bp-2]
  4241 00001831 3C74                     cmp al, 116
  4242 00001833 0F850900                 jne @@prs194
  4243 00001837 66B809000000             mov eax, 9
  4244 0000183D 8846FE                   mov byte [bp-2], al
  4245                                  @@prs194:
  4246                                  @@prs192:
  4247                                  @@prs191:
  4248 00001840 8A46FE                   mov al, byte [bp-2]
  4249 00001843 B400                     mov ah, 0
  4250 00001845 50                       push ax
  4251 00001846 E807FF                   call prc
  4252 00001849 83C402                   add  sp, 2
  4253 0000184C FF4604                   inc  word [bp+4]
  4254                                  
  4255                                  ;-30 }
  4256                                  
  4257 0000184F E96CFF                   jmp @@prs186
  4258                                  @@prs187:
  4259                                  
  4260                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4261 00001852 C9                       LEAVE
  4262 00001853 C3                       ret
  4263                                  ; ENDP
  4264                                  
  4265                                  printhex8a:  ; *** PROC ***
  4266                                  
  4267                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4268                                  
  4269                                  ;Function : printhex8a, Number of local variables: 2
  4270                                  ;   # type sign width line used address name   list of local variables
  4271                                  ;  200 var unsg word    31 NULL bp+4    c
  4272                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4273 00001854 C8020000                 ENTER  2,0
  4274 00001858 8B4604                   mov ax, [bp+4]
  4275 0000185B C1E804                   shr ax, 4
  4276 0000185E 8946FE                   mov word [bp-2], ax
  4277 00001861 8346FE30                 add  word [bp-2], 48
  4278 00001865 8B46FE                   mov ax, [bp-2]
  4279 00001868 83F839                   cmp ax, 57
  4280 0000186B 0F8E0400                 jle @@printhex8a195
  4281 0000186F 8346FE07                 add  word [bp-2], 7
  4282                                  @@printhex8a195:
  4283 00001873 FF76FE                   push word [bp-2]
  4284 00001876 E8D7FE                   call prc
  4285 00001879 83C402                   add  sp, 2
  4286                                  
  4287                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4288                                  
  4289 0000187C 8B4604                   mov ax, [bp+4]
  4290 0000187F 83E00F                   and ax, 15
  4291 00001882 8946FE                   mov word [bp-2], ax
  4292 00001885 8346FE30                 add  word [bp-2], 48
  4293 00001889 8B46FE                   mov ax, [bp-2]
  4294 0000188C 83F839                   cmp ax, 57
  4295 0000188F 0F8E0400                 jle @@printhex8a196
  4296 00001893 8346FE07                 add  word [bp-2], 7
  4297                                  @@printhex8a196:
  4298 00001897 FF76FE                   push word [bp-2]
  4299 0000189A E8B3FE                   call prc
  4300 0000189D 83C402                   add  sp, 2
  4301                                  
  4302                                  ;-34 }
  4303                                  
  4304                                  
  4305                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4306 000018A0 C9                       LEAVE
  4307 000018A1 C3                       ret
  4308                                  ; ENDP
  4309                                  
  4310                                  printhex16:  ; *** PROC ***
  4311                                  
  4312                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4313                                  
  4314                                  ;Function : printhex16, Number of local variables: 2
  4315                                  ;   # type sign width line used address name   list of local variables
  4316                                  ;  200 var unsg word    35 NULL bp+4    i
  4317                                  ;  201 var unsg word    35 NULL bp-2    half;
  4318 000018A2 C8020000                 ENTER  2,0
  4319 000018A6 8B4604                   mov ax, [bp+4]
  4320 000018A9 C1E808                   shr ax, 8
  4321 000018AC 8946FE                   mov word [bp-2], ax
  4322 000018AF FF76FE                   push word [bp-2]
  4323 000018B2 E89FFF                   call printhex8a
  4324 000018B5 83C402                   add  sp, 2
  4325 000018B8 8B4604                   mov ax, [bp+4]
  4326 000018BB 25FF00                   and ax, 255
  4327 000018BE 8946FE                   mov word [bp-2], ax
  4328 000018C1 FF76FE                   push word [bp-2]
  4329 000018C4 E88DFF                   call printhex8a
  4330 000018C7 83C402                   add  sp, 2
  4331                                  
  4332                                  ;-37 }
  4333                                  
  4334                                  
  4335                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4336 000018CA C9                       LEAVE
  4337 000018CB C3                       ret
  4338                                  ; ENDP
  4339                                  
  4340                                  printIntU:  ; *** PROC ***
  4341                                  
  4342                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4343                                  
  4344                                  ;Function : printIntU, Number of local variables: 2
  4345                                  ;   # type sign width line used address name   list of local variables
  4346                                  ;  200 var unsg word    38 NULL bp+4    n
  4347                                  ;  201 var unsg word    38 NULL bp-2    e;
  4348 000018CC C8020000                 ENTER  2,0
  4349 000018D0 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4350 000018D4 0F821700                 jb  @@printIntU197
  4351 000018D8 8B4604                   mov ax, [bp+4]
  4352 000018DB BB0A00                   mov bx, 10
  4353 000018DE BA0000                   mov dx, 0
  4354 000018E1 F7F3                     div bx
  4355 000018E3 8946FE                   mov word [bp-2], ax
  4356                                  
  4357                                  ;-40     printIntU(e); }
  4358                                  
  4359 000018E6 FF76FE                   push word [bp-2]
  4360 000018E9 E8E0FF                   call printIntU
  4361 000018EC 83C402                   add  sp, 2
  4362                                  
  4363                                  ;-41     n = n % 10; //unsigned mod
  4364                                  
  4365                                  @@printIntU197:
  4366 000018EF 8B4604                   mov ax, [bp+4]
  4367 000018F2 BB0A00                   mov bx, 10
  4368 000018F5 BA0000                   mov dx, 0
  4369 000018F8 F7F3                     div bx
  4370 000018FA 89D0                     mov ax, dx
  4371 000018FC 894604                   mov word [bp+4], ax
  4372                                  
  4373                                  ;-42     n += '0'; prc(n);
  4374                                  
  4375 000018FF 83460430                 add  word [bp+4], 48
  4376 00001903 FF7604                   push word [bp+4]
  4377 00001906 E847FE                   call prc
  4378 00001909 83C402                   add  sp, 2
  4379                                  
  4380                                  ;-43 }
  4381                                  
  4382                                  
  4383                                  ;-44 
  4384                                  
  4385                                  
  4386                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4387 0000190C C9                       LEAVE
  4388 0000190D C3                       ret
  4389                                  ; ENDP
  4390                                  
  4391                                  error1:  ; *** PROC ***
  4392                                  ;Function : error1, Number of local variables: 1
  4393                                  ;   # type sign width line used address name   list of local variables
  4394                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4395 0000190E C8000000                 ENTER  0,0
  4396 00001912 66B801000000             mov eax, 1
  4397 00001918 A2[2500]                 mov byte [LIST], al
  4398 0000191B FF06[3200]               inc  word [ErrorCount]
  4399                                  
  4400                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4401                                  
  4402 0000191F 68[4719]                 push error1_0
  4403 00001922 E88CFE                   call prs
  4404 00001925 83C402                   add  sp, 2
  4405 00001928 FF7604                   push word [bp+4]
  4406 0000192B E883FE                   call prs
  4407 0000192E 83C402                   add  sp, 2
  4408                                  
  4409                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4410                                  
  4411 00001931 68[6219]                 push error1_1
  4412 00001934 E87AFE                   call prs
  4413 00001937 83C402                   add  sp, 2
  4414 0000193A 8D063075                 lea  ax, [Symbol]
  4415 0000193E 50                       push ax
  4416 0000193F E86FFE                   call prs
  4417 00001942 83C402                   add  sp, 2
  4418                                  
  4419                                  ;-48 int allowederror(){error1("not allowed here"); }
  4420 00001945 C9                       LEAVE
  4421 00001946 C3                       ret
  4422                                  ; ENDP
  4423 00001947 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4424 00001950 6E657874206C696E65-
  4425 00001959 204552524F523A2000 
  4426 00001962 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4427 0000196B 2000               
  4428                                  
  4429                                  allowederror:  ; *** PROC ***
  4430 0000196D 68[7719]                 push allowederror_0
  4431 00001970 E89BFF                   call error1
  4432 00001973 83C402                   add  sp, 2
  4433                                  
  4434                                  ;-49 int implmerror(){error1("not implemented");}
  4435                                  
  4436 00001976 C3                       ret
  4437                                  ; ENDP
  4438 00001977 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4439 00001980 6564206865726500   
  4440                                  
  4441                                  implmerror:  ; *** PROC ***
  4442 00001988 68[9219]                 push implmerror_0
  4443 0000198B E880FF                   call error1
  4444 0000198E 83C402                   add  sp, 2
  4445                                  
  4446                                  ;-50 int indexerror (){error1("invalid index register");}
  4447                                  
  4448 00001991 C3                       ret
  4449                                  ; ENDP
  4450 00001992 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4451 0000199B 6D656E74656400     
  4452                                  
  4453                                  indexerror:  ; *** PROC ***
  4454 000019A2 68[AC19]                 push indexerror_0
  4455 000019A5 E866FF                   call error1
  4456 000019A8 83C402                   add  sp, 2
  4457                                  
  4458                                  ;-51 int numbererror(){error1("number expected");}
  4459                                  
  4460 000019AB C3                       ret
  4461                                  ; ENDP
  4462 000019AC 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4463 000019B5 6E6465782072656769-
  4464 000019BE 7374657200         
  4465                                  
  4466                                  numbererror:  ; *** PROC ***
  4467 000019C3 68[CD19]                 push numbererror_0
  4468 000019C6 E845FF                   call error1
  4469 000019C9 83C402                   add  sp, 2
  4470                                  
  4471                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4472                                  
  4473 000019CC C3                       ret
  4474                                  ; ENDP
  4475 000019CD 6E756D626572206578-     numbererror_0 db "number expected",0
  4476 000019D6 70656374656400     
  4477                                  
  4478                                  regmemerror:  ; *** PROC ***
  4479 000019DD 68[E719]                 push regmemerror_0
  4480 000019E0 E82BFF                   call error1
  4481 000019E3 83C402                   add  sp, 2
  4482                                  
  4483                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4484                                  
  4485 000019E6 C3                       ret
  4486                                  ; ENDP
  4487 000019E7 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4488 000019F0 73746572206F72206D-
  4489 000019F9 656D6F727920616C6C-
  4490 00001A02 6F77656400         
  4491                                  
  4492                                  segregerror:  ; *** PROC ***
  4493 00001A07 68[111A]                 push segregerror_0
  4494 00001A0A E801FF                   call error1
  4495 00001A0D 83C402                   add  sp, 2
  4496                                  
  4497                                  ;-54 int syntaxerror(){error1("syntax");}
  4498                                  
  4499 00001A10 C3                       ret
  4500                                  ; ENDP
  4501 00001A11 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4502 00001A1A 65676973746572206E-
  4503 00001A23 6F7420616C6C6F7765-
  4504 00001A2C 6400               
  4505                                  
  4506                                  syntaxerror:  ; *** PROC ***
  4507 00001A2E 68[381A]                 push syntaxerror_0
  4508 00001A31 E8DAFE                   call error1
  4509 00001A34 83C402                   add  sp, 2
  4510                                  
  4511                                  ;-55 
  4512                                  
  4513                                  
  4514                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4515                                  
  4516 00001A37 C3                       ret
  4517                                  ; ENDP
  4518 00001A38 73796E74617800          syntaxerror_0 db "syntax",0
  4519                                  
  4520                                  errorexit:  ; *** PROC ***
  4521                                  ;Function : errorexit, Number of local variables: 1
  4522                                  ;   # type sign width line used address name   list of local variables
  4523                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4524 00001A3F C8000000                 ENTER  0,0
  4525 00001A43 FF7604                   push word [bp+4]
  4526 00001A46 E8C5FE                   call error1
  4527 00001A49 83C402                   add  sp, 2
  4528 00001A4C 6A01                     push 1
  4529 00001A4E E80704                   call end1
  4530 00001A51 83C402                   add  sp, 2
  4531                                  
  4532                                  ;-57 int addrexit(){errorexit("illegal address");}
  4533 00001A54 C9                       LEAVE
  4534 00001A55 C3                       ret
  4535                                  ; ENDP
  4536                                  
  4537                                  addrexit:  ; *** PROC ***
  4538 00001A56 68[601A]                 push addrexit_0
  4539 00001A59 E8E3FF                   call errorexit
  4540 00001A5C 83C402                   add  sp, 2
  4541                                  
  4542                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4543                                  
  4544 00001A5F C3                       ret
  4545                                  ; ENDP
  4546 00001A60 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4547 00001A69 64647265737300     
  4548                                  
  4549                                  internexit:  ; *** PROC ***
  4550 00001A70 68[7A1A]                 push internexit_0
  4551 00001A73 E8C9FF                   call errorexit
  4552 00001A76 83C402                   add  sp, 2
  4553 00001A79 C3                       ret
  4554                                  ; ENDP
  4555 00001A7A 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4556 00001A83 6D70696C6572206572-
  4557 00001A8C 726F7200           
  4558                                  ;Back to main program: AS.C
  4559                                  
  4560                                  ;-214 #include "MAIN.C"
  4561                                  
  4562                                  ;Use include file: MAIN.C
  4563                                  
  4564                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4565                                  
  4566                                  
  4567                                  getarg:  ; *** PROC ***
  4568                                  
  4569                                  ;-2   arglen1=*arglen;
  4570                                  
  4571                                  ;Function : getarg, Number of local variables: 3
  4572                                  ;   # type sign width line used address name   list of local variables
  4573                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4574                                  ;  201 var sign word     1 NULL bp-4    i
  4575                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4576 00001A90 C8060000                 ENTER  6,0
  4577 00001A94 8B1E[5800]               mov bx, [arglen]
  4578 00001A98 8A07                     mov al, [bx]
  4579 00001A9A B400                     mov ah, 0
  4580 00001A9C 8946FE                   mov word [bp-2], ax
  4581                                  
  4582                                  ;-3   if (arglen1==0) {
  4583                                  
  4584 00001A9F 8B46FE                   mov ax, [bp-2]
  4585 00001AA2 83F800                   cmp ax, 0
  4586 00001AA5 0F851C00                 jne @@getarg198
  4587                                  
  4588                                  ;-4     cputs(Version1);
  4589                                  
  4590 00001AA9 8D06[1000]               lea  ax, [Version1]
  4591 00001AAD 50                       push ax
  4592 00001AAE E8DC03                   call cputs
  4593 00001AB1 83C402                   add  sp, 2
  4594                                  
  4595                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4596                                  
  4597 00001AB4 68[551C]                 push getarg_0
  4598 00001AB7 E8D303                   call cputs
  4599 00001ABA 83C402                   add  sp, 2
  4600                                  
  4601                                  ;-6     exitR(3);
  4602                                  
  4603 00001ABD 6A03                     push 3
  4604 00001ABF E8A605                   call exitR
  4605 00001AC2 83C402                   add  sp, 2
  4606                                  
  4607                                  ;-7   }
  4608                                  
  4609                                  
  4610                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4611                                  
  4612                                  @@getarg198:
  4613 00001AC5 8B46FE                   mov ax, [bp-2]
  4614 00001AC8 058100                   add ax, 129
  4615 00001ACB 8946FC                   mov word [bp-4], ax
  4616 00001ACE 66B800000000             mov eax, 0
  4617 00001AD4 8B5EFC                   mov  bx, [bp-4]
  4618 00001AD7 8907                     mov  [bx], ax
  4619 00001AD9 FF4EFE                   dec  word [bp-2]
  4620                                  
  4621                                  ;-9   toupper(argv);
  4622                                  
  4623 00001ADC FF36[5A00]               push word [argv]
  4624 00001AE0 E8D803                   call toupper
  4625 00001AE3 83C402                   add  sp, 2
  4626                                  
  4627                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4628                                  
  4629 00001AE6 FF36[5A00]               push word [argv]
  4630 00001AEA 8D06ED75                 lea  ax, [namein]
  4631 00001AEE 50                       push ax
  4632 00001AEF E83704                   call strcpy
  4633 00001AF2 83C404                   add  sp, 4
  4634 00001AF5 68[7A1C]                 push getarg_1
  4635 00001AF8 8D06ED75                 lea  ax, [namein]
  4636 00001AFC 50                       push ax
  4637 00001AFD E8EA04                   call strcat1
  4638 00001B00 83C404                   add  sp, 4
  4639                                  
  4640                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4641                                  
  4642 00001B03 FF36[5A00]               push word [argv]
  4643 00001B07 8D063076                 lea  ax, [namelst]
  4644 00001B0B 50                       push ax
  4645 00001B0C E81A04                   call strcpy
  4646 00001B0F 83C404                   add  sp, 4
  4647 00001B12 68[7D1C]                 push getarg_2
  4648 00001B15 8D063076                 lea  ax, [namelst]
  4649 00001B19 50                       push ax
  4650 00001B1A E8CD04                   call strcat1
  4651 00001B1D 83C404                   add  sp, 4
  4652                                  
  4653                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4654                                  
  4655 00001B20 FF36[5A00]               push word [argv]
  4656 00001B24 8D067376                 lea  ax, [namebin]
  4657 00001B28 50                       push ax
  4658 00001B29 E8FD03                   call strcpy
  4659 00001B2C 83C404                   add  sp, 4
  4660 00001B2F 68[821C]                 push getarg_3
  4661 00001B32 8D067376                 lea  ax, [namebin]
  4662 00001B36 50                       push ax
  4663 00001B37 E8B004                   call strcat1
  4664 00001B3A 83C404                   add  sp, 4
  4665                                  
  4666                                  ;-13 
  4667                                  
  4668                                  
  4669                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4670                                  
  4671 00001B3D 66B801000000             mov eax, 1
  4672 00001B43 A2[2500]                 mov byte [LIST], al
  4673 00001B46 66B800000000             mov eax, 0
  4674 00001B4C A3[3000]                 mov word [DOS_ERR], ax
  4675 00001B4F 66B800000000             mov eax, 0
  4676 00001B55 A3[3700]                 mov word [PC], ax
  4677 00001B58 66B800000000             mov eax, 0
  4678 00001B5E A3[3200]                 mov word [ErrorCount], ax
  4679                                  
  4680                                  ;-15   asm_fd=openR (namein);
  4681                                  
  4682 00001B61 8D06ED75                 lea  ax, [namein]
  4683 00001B65 50                       push ax
  4684 00001B66 E8A604                   call openR
  4685 00001B69 83C402                   add  sp, 2
  4686 00001B6C A3[2A00]                 mov word [asm_fd], ax
  4687                                  
  4688                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4689                                  
  4690 00001B6F A1[3000]                 mov ax, [DOS_ERR]
  4691 00001B72 08C0                     or  al, al
  4692 00001B74 0F841C00                 je @@getarg199
  4693 00001B78 68[871C]                 push getarg_4
  4694 00001B7B E80F03                   call cputs
  4695 00001B7E 83C402                   add  sp, 2
  4696 00001B81 8D06ED75                 lea  ax, [namein]
  4697 00001B85 50                       push ax
  4698 00001B86 E80403                   call cputs
  4699 00001B89 83C402                   add  sp, 2
  4700 00001B8C 6A01                     push 1
  4701 00001B8E E8D704                   call exitR
  4702 00001B91 83C402                   add  sp, 2
  4703                                  
  4704                                  ;-17   lst_fd=creatR(namelst);
  4705                                  
  4706                                  @@getarg199:
  4707 00001B94 8D063076                 lea  ax, [namelst]
  4708 00001B98 50                       push ax
  4709 00001B99 E88204                   call creatR
  4710 00001B9C 83C402                   add  sp, 2
  4711 00001B9F A3[2C00]                 mov word [lst_fd], ax
  4712                                  
  4713                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4714                                  
  4715 00001BA2 A1[3000]                 mov ax, [DOS_ERR]
  4716 00001BA5 08C0                     or  al, al
  4717 00001BA7 0F841C00                 je @@getarg200
  4718 00001BAB 68[9D1C]                 push getarg_5
  4719 00001BAE E8DC02                   call cputs
  4720 00001BB1 83C402                   add  sp, 2
  4721 00001BB4 8D063076                 lea  ax, [namelst]
  4722 00001BB8 50                       push ax
  4723 00001BB9 E8D102                   call cputs
  4724 00001BBC 83C402                   add  sp, 2
  4725 00001BBF 6A02                     push 2
  4726 00001BC1 E8A404                   call exitR
  4727 00001BC4 83C402                   add  sp, 2
  4728                                  
  4729                                  ;-19   bin_fd=creatR(namebin);
  4730                                  
  4731                                  @@getarg200:
  4732 00001BC7 8D067376                 lea  ax, [namebin]
  4733 00001BCB 50                       push ax
  4734 00001BCC E84F04                   call creatR
  4735 00001BCF 83C402                   add  sp, 2
  4736 00001BD2 A3[2E00]                 mov word [bin_fd], ax
  4737                                  
  4738                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4739                                  
  4740 00001BD5 A1[3000]                 mov ax, [DOS_ERR]
  4741 00001BD8 08C0                     or  al, al
  4742 00001BDA 0F841C00                 je @@getarg201
  4743 00001BDE 68[B41C]                 push getarg_6
  4744 00001BE1 E8A902                   call cputs
  4745 00001BE4 83C402                   add  sp, 2
  4746 00001BE7 8D067376                 lea  ax, [namebin]
  4747 00001BEB 50                       push ax
  4748 00001BEC E89E02                   call cputs
  4749 00001BEF 83C402                   add  sp, 2
  4750 00001BF2 6A02                     push 2
  4751 00001BF4 E87104                   call exitR
  4752 00001BF7 83C402                   add  sp, 2
  4753                                  
  4754                                  ;-21   prs(";");prs(Version1);
  4755                                  
  4756                                  @@getarg201:
  4757 00001BFA 68[CA1C]                 push getarg_7
  4758 00001BFD E8B1FB                   call prs
  4759 00001C00 83C402                   add  sp, 2
  4760 00001C03 8D06[1000]               lea  ax, [Version1]
  4761 00001C07 50                       push ax
  4762 00001C08 E8A6FB                   call prs
  4763 00001C0B 83C402                   add  sp, 2
  4764                                  
  4765                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4766                                  
  4767 00001C0E 68[CC1C]                 push getarg_8
  4768 00001C11 E89DFB                   call prs
  4769 00001C14 83C402                   add  sp, 2
  4770 00001C17 8D06ED75                 lea  ax, [namein]
  4771 00001C1B 50                       push ax
  4772 00001C1C E892FB                   call prs
  4773 00001C1F 83C402                   add  sp, 2
  4774 00001C22 68[D71C]                 push getarg_9
  4775 00001C25 E889FB                   call prs
  4776 00001C28 83C402                   add  sp, 2
  4777 00001C2B 8D063076                 lea  ax, [namelst]
  4778 00001C2F 50                       push ax
  4779 00001C30 E87EFB                   call prs
  4780 00001C33 83C402                   add  sp, 2
  4781                                  
  4782                                  ;-23   prs(", "); prs(namebin);
  4783                                  
  4784 00001C36 68[E21C]                 push getarg_10
  4785 00001C39 E875FB                   call prs
  4786 00001C3C 83C402                   add  sp, 2
  4787 00001C3F 8D067376                 lea  ax, [namebin]
  4788 00001C43 50                       push ax
  4789 00001C44 E86AFB                   call prs
  4790 00001C47 83C402                   add  sp, 2
  4791                                  
  4792                                  ;-24   prs("\n");
  4793                                  
  4794 00001C4A 68[E51C]                 push getarg_11
  4795 00001C4D E861FB                   call prs
  4796 00001C50 83C402                   add  sp, 2
  4797                                  
  4798                                  ;-25 }
  4799                                  
  4800                                  
  4801                                  ;-26 int epilog() { int i; int j; char c;
  4802 00001C53 C9                       LEAVE
  4803 00001C54 C3                       ret
  4804                                  ; ENDP
  4805 00001C55 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4806 00001C5E 41532E434F4D206669-
  4807 00001C67 6C656E616D65205B77-
  4808 00001C70 2F6F202E535D203A20-
  4809 00001C79 00                 
  4810 00001C7A 2E5300                  getarg_1 db ".S",0
  4811 00001C7D 2E4C535400              getarg_2 db ".LST",0
  4812 00001C82 2E434F4D00              getarg_3 db ".COM",0
  4813 00001C87 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4814 00001C90 6C65206D697373696E-
  4815 00001C99 673A2000           
  4816 00001C9D 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4817 00001CA6 206E6F742063726561-
  4818 00001CAF 74653A2000         
  4819 00001CB4 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4820 00001CBD 6E6F74206372656174-
  4821 00001CC6 653A2000           
  4822 00001CCA 3B00                    getarg_7 db ";",0
  4823 00001CCC 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4824 00001CD5 2000               
  4825 00001CD7 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4826 00001CE0 2000               
  4827 00001CE2 2C2000                  getarg_10 db ", ",0
  4828 00001CE5 5C6E00                  getarg_11 db "\n",0
  4829                                  
  4830                                  epilog:  ; *** PROC ***
  4831                                  
  4832                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4833                                  
  4834                                  ;Function : epilog, Number of local variables: 3
  4835                                  ;   # type sign width line used address name   list of local variables
  4836                                  ;  200 var sign word    26 NULL bp-2    i
  4837                                  ;  201 var sign word    26 NULL bp-4    j
  4838                                  ;  202 var sign byte    26 NULL bp-6    c;
  4839 00001CE8 C8060000                 ENTER  6,0
  4840 00001CEC 68[111E]                 push epilog_0
  4841 00001CEF E8BFFA                   call prs
  4842 00001CF2 83C402                   add  sp, 2
  4843 00001CF5 FF36[3200]               push word [ErrorCount]
  4844 00001CF9 E8D0FB                   call printIntU
  4845 00001CFC 83C402                   add  sp, 2
  4846                                  
  4847                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4848                                  
  4849 00001CFF A1[3200]                 mov ax, [ErrorCount]
  4850 00001D02 08C0                     or  al, al
  4851 00001D04 0F840900                 je @@epilog202
  4852 00001D08 68[211E]                 push epilog_1
  4853 00001D0B E8A3FA                   call prs
  4854 00001D0E 83C402                   add  sp, 2
  4855                                  
  4856                                  ;-29   prs(", Label & Var: ");
  4857                                  
  4858                                  @@epilog202:
  4859 00001D11 68[2F1E]                 push epilog_2
  4860 00001D14 E89AFA                   call prs
  4861 00001D17 83C402                   add  sp, 2
  4862                                  
  4863                                  ;-30   if (LabelMaxIx) {
  4864                                  
  4865 00001D1A A1[5200]                 mov ax, [LabelMaxIx]
  4866 00001D1D 08C0                     or  al, al
  4867 00001D1F 0F846900                 je @@epilog203
  4868                                  
  4869                                  ;-31     i = 1;
  4870                                  
  4871 00001D23 66B801000000             mov eax, 1
  4872 00001D29 8946FE                   mov word [bp-2], ax
  4873                                  
  4874                                  ;-32     LabelNamePtr= &LabelNames;
  4875                                  
  4876 00001D2C B8BB76                   mov ax, LabelNames
  4877 00001D2F A3[5000]                 mov word [LabelNamePtr], ax
  4878                                  
  4879                                  ;-33     do {
  4880                                  
  4881                                  @@epilog204:
  4882                                  
  4883                                  ;-34       prs(LabelNamePtr); prc(' ');
  4884                                  
  4885 00001D32 FF36[5000]               push word [LabelNamePtr]
  4886 00001D36 E878FA                   call prs
  4887 00001D39 83C402                   add  sp, 2
  4888 00001D3C 6A20                     push 32
  4889 00001D3E E80FFA                   call prc
  4890 00001D41 83C402                   add  sp, 2
  4891                                  
  4892                                  ;-35       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4893                                  
  4894 00001D44 8B5EFE                   mov bx, [bp-2]
  4895 00001D47 D1E3                     shl bx, 1
  4896 00001D49 8B87A37A                 mov ax, [LabelAddr + bx]
  4897 00001D4D 8946FC                   mov word [bp-4], ax
  4898 00001D50 FF76FC                   push word [bp-4]
  4899 00001D53 E84CFB                   call printhex16
  4900 00001D56 83C402                   add  sp, 2
  4901 00001D59 68[3F1E]                 push epilog_3
  4902 00001D5C E852FA                   call prs
  4903 00001D5F 83C402                   add  sp, 2
  4904                                  
  4905                                  ;-36       j=strlen(LabelNamePtr);//get end of actual name
  4906                                  
  4907 00001D62 FF36[5000]               push word [LabelNamePtr]
  4908 00001D66 E89501                   call strlen
  4909 00001D69 83C402                   add  sp, 2
  4910 00001D6C 8946FC                   mov word [bp-4], ax
  4911                                  
  4912                                  ;-37       LabelNamePtr=LabelNamePtr+j;
  4913                                  
  4914 00001D6F A1[5000]                 mov ax, [LabelNamePtr]
  4915 00001D72 0346FC                   add ax, [bp-4]
  4916 00001D75 A3[5000]                 mov word [LabelNamePtr], ax
  4917                                  
  4918                                  ;-38       LabelNamePtr++;
  4919                                  
  4920 00001D78 FF06[5000]               inc  word [LabelNamePtr]
  4921                                  
  4922                                  ;-39       i++;
  4923                                  
  4924 00001D7C FF46FE                   inc  word [bp-2]
  4925                                  
  4926                                  ;-40     } while (i <= LabelMaxIx);
  4927                                  
  4928 00001D7F 8B46FE                   mov ax, [bp-2]
  4929 00001D82 3B06[5200]               cmp ax, [LabelMaxIx]
  4930 00001D86 0F8F0200                 jg  @@epilog205
  4931 00001D8A EBA6                     jmp @@epilog204
  4932                                  @@epilog205:
  4933                                  
  4934                                  ;-41   }
  4935                                  
  4936                                  
  4937                                  ;-42   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4938                                  
  4939                                  @@epilog203:
  4940 00001D8C 68[431E]                 push epilog_4
  4941 00001D8F E81FFA                   call prs
  4942 00001D92 83C402                   add  sp, 2
  4943 00001D95 FF36[5600]               push word [BinLen]
  4944 00001D99 E830FB                   call printIntU
  4945 00001D9C 83C402                   add  sp, 2
  4946 00001D9F 68[501E]                 push epilog_5
  4947 00001DA2 E80CFA                   call prs
  4948 00001DA5 83C402                   add  sp, 2
  4949                                  
  4950                                  ;-43   i=0;
  4951                                  
  4952 00001DA8 66B800000000             mov eax, 0
  4953 00001DAE 8946FE                   mov word [bp-2], ax
  4954                                  
  4955                                  ;-44   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4956                                  
  4957                                  @@epilog206:
  4958 00001DB1 6A20                     push 32
  4959 00001DB3 E89AF9                   call prc
  4960 00001DB6 83C402                   add  sp, 2
  4961 00001DB9 8B5EFE                   mov bx, [bp-2]
  4962 00001DBC 8A876B7B                 mov al, [FileBin + bx]
  4963 00001DC0 8946FC                   mov word [bp-4], ax
  4964 00001DC3 FF76FC                   push word [bp-4]
  4965 00001DC6 E88BFA                   call printhex8a
  4966 00001DC9 83C402                   add  sp, 2
  4967 00001DCC FF46FE                   inc  word [bp-2]
  4968                                  
  4969                                  ;-45   } while (i < BinLen);
  4970                                  
  4971 00001DCF 8B46FE                   mov ax, [bp-2]
  4972 00001DD2 3B06[5600]               cmp ax, [BinLen]
  4973 00001DD6 0F8D0200                 jge @@epilog207
  4974 00001DDA EBD5                     jmp @@epilog206
  4975                                  @@epilog207:
  4976                                  
  4977                                  ;-46   i=0;
  4978                                  
  4979 00001DDC 66B800000000             mov eax, 0
  4980 00001DE2 8946FE                   mov word [bp-2], ax
  4981                                  
  4982                                  ;-47   do {
  4983                                  
  4984                                  @@epilog208:
  4985                                  
  4986                                  ;-48     c = FileBin[i];
  4987                                  
  4988 00001DE5 8B5EFE                   mov bx, [bp-2]
  4989 00001DE8 8A876B7B                 mov al, [FileBin + bx]
  4990 00001DEC 8846FA                   mov byte [bp-6], al
  4991                                  
  4992                                  ;-49     fputcR(c, bin_fd);
  4993                                  
  4994 00001DEF FF36[2E00]               push word [bin_fd]
  4995 00001DF3 8A46FA                   mov al, byte [bp-6]
  4996 00001DF6 B400                     mov ah, 0
  4997 00001DF8 50                       push ax
  4998 00001DF9 E84902                   call fputcR
  4999 00001DFC 83C404                   add  sp, 4
  5000                                  
  5001                                  ;-50     i++;
  5002                                  
  5003 00001DFF FF46FE                   inc  word [bp-2]
  5004                                  
  5005                                  ;-51   } while (i < BinLen);
  5006                                  
  5007 00001E02 8B46FE                   mov ax, [bp-2]
  5008 00001E05 3B06[5600]               cmp ax, [BinLen]
  5009 00001E09 0F8D0200                 jge @@epilog209
  5010 00001E0D EBD6                     jmp @@epilog208
  5011                                  @@epilog209:
  5012                                  
  5013                                  ;-52 }
  5014                                  
  5015                                  
  5016                                  ;-53 int end1(int n) {
  5017 00001E0F C9                       LEAVE
  5018 00001E10 C3                       ret
  5019                                  ; ENDP
  5020 00001E11 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5021 00001E1A 726F72733A2000     
  5022 00001E21 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5023 00001E2A 2A2A2A2000         
  5024 00001E2F 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  5025 00001E38 205661723A2000     
  5026 00001E3F 2C202000                epilog_3 db ",  ",0
  5027 00001E43 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  5028 00001E4C 6C652000           
  5029 00001E50 2062797465733A00        epilog_5 db " bytes:",0
  5030                                  
  5031                                  end1:  ; *** PROC ***
  5032                                  
  5033                                  ;-54   fcloseR(asm_fd);
  5034                                  
  5035                                  ;Function : end1, Number of local variables: 1
  5036                                  ;   # type sign width line used address name   list of local variables
  5037                                  ;  200 var sign word    53 NULL bp+4    n;
  5038 00001E58 C8000000                 ENTER  0,0
  5039 00001E5C FF36[2A00]               push word [asm_fd]
  5040 00001E60 E8F701                   call fcloseR
  5041 00001E63 83C402                   add  sp, 2
  5042                                  
  5043                                  ;-55   fcloseR(lst_fd);
  5044                                  
  5045 00001E66 FF36[2C00]               push word [lst_fd]
  5046 00001E6A E8ED01                   call fcloseR
  5047 00001E6D 83C402                   add  sp, 2
  5048                                  
  5049                                  ;-56   fcloseR(bin_fd);
  5050                                  
  5051 00001E70 FF36[2E00]               push word [bin_fd]
  5052 00001E74 E8E301                   call fcloseR
  5053 00001E77 83C402                   add  sp, 2
  5054                                  
  5055                                  ;-57   exitR(n);
  5056                                  
  5057 00001E7A FF7604                   push word [bp+4]
  5058 00001E7D E8E801                   call exitR
  5059 00001E80 83C402                   add  sp, 2
  5060                                  
  5061                                  ;-58 }
  5062 00001E83 C9                       LEAVE
  5063 00001E84 C3                       ret
  5064                                  ; ENDP
  5065                                  ;Back to main program: AS.C
  5066                                   
  5067                                  ; missing functions: 
  5068                                  ; digit
  5069                                  ; strcpy
  5070                                  ; eqstr
  5071                                  ; strlen
  5072                                  ; eqstr
  5073                                  ; eqstr
  5074                                  ; eqstr
  5075                                  ; eqstr
  5076                                  ; readRL
  5077                                  ; readRL
  5078                                  ; digit
  5079                                  ; digit
  5080                                  ; strcpy
  5081                                  ; toupper
  5082                                  ; strlen
  5083                                  ; strlen
  5084                                  ; eqstr
  5085                                  ; eqstr
  5086                                  ; eqstr
  5087                                  ; eqstr
  5088                                  ; eqstr
  5089                                  ; eqstr
  5090                                  ; eqstr
  5091                                  ; eqstr
  5092                                  ; eqstr
  5093                                  ; eqstr
  5094                                  ; eqstr
  5095                                  ; eqstr
  5096                                  ; eqstr
  5097                                  ; eqstr
  5098                                  ; eqstr
  5099                                  ; eqstr
  5100                                  ; eqstr
  5101                                  ; eqstr
  5102                                  ; eqstr
  5103                                  ; eqstr
  5104                                  ; eqstr
  5105                                  ; eqstr
  5106                                  ; eqstr
  5107                                  ; eqstr
  5108                                  ; eqstr
  5109                                  ; eqstr
  5110                                  ; eqstr
  5111                                  ; eqstr
  5112                                  ; eqstr
  5113                                  ; eqstr
  5114                                  ; writetty
  5115                                  ; writetty
  5116                                  ; fputcR
  5117                                  ; cputs
  5118                                  ; cputs
  5119                                  ; exitR
  5120                                  ; toupper
  5121                                  ; strcpy
  5122                                  ; strcat1
  5123                                  ; strcpy
  5124                                  ; strcat1
  5125                                  ; strcpy
  5126                                  ; strcat1
  5127                                  ; openR
  5128                                  ; cputs
  5129                                  ; cputs
  5130                                  ; exitR
  5131                                  ; creatR
  5132                                  ; cputs
  5133                                  ; cputs
  5134                                  ; exitR
  5135                                  ; creatR
  5136                                  ; cputs
  5137                                  ; cputs
  5138                                  ; exitR
  5139                                  ; strlen
  5140                                  ; fputcR
  5141                                  ; fcloseR
  5142                                  ; fcloseR
  5143                                  ; fcloseR
  5144                                  ; exitR
  5145                                  ; Number of unresolved CALLs :   77
  5146                                  ;use archive file: AR.C
  5147                                  
  5148                                  ;-215 // AR.C Archive
  5149                                  
  5150                                  ;Number of CALLs:    2 : writetty
  5151                                  
  5152                                  writetty:  ; *** PROC ***
  5153 00001E85 B40E                     mov  ah, 14
  5154 00001E87 BB0000                   mov  bx, 0
  5155 00001E8A CD10                     int  16
  5156                                  
  5157                                  ;-216 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5158                                  
  5159 00001E8C C3                       ret
  5160                                  ; ENDP
  5161                                  ;Number of CALLs:    8 : cputs
  5162                                  
  5163                                  cputs:  ; *** PROC ***
  5164                                  ;Function : cputs, Number of local variables: 2
  5165                                  ;   # type sign width line used address name   list of local variables
  5166                                  ;  200 ptr sign byte   216 NULL bp+4    s
  5167                                  ;  201 var sign byte   216 NULL bp-2    c;
  5168 00001E8D C8020000                 ENTER  2,0
  5169                                  @@cputs210:
  5170 00001E91 8B5E04                   mov bx, [bp+4]
  5171 00001E94 8A07                     mov al, [bx]
  5172 00001E96 B400                     mov ah, 0
  5173 00001E98 08C0                     or  al, al
  5174 00001E9A 0F841B00                 je @@cputs211
  5175 00001E9E 8B5E04                   mov bx, [bp+4]
  5176 00001EA1 8A07                     mov al, [bx]
  5177 00001EA3 B400                     mov ah, 0
  5178 00001EA5 8846FE                   mov byte [bp-2], al
  5179 00001EA8 8A46FE                   mov al, byte [bp-2]
  5180 00001EAB B400                     mov ah, 0
  5181 00001EAD 50                       push ax
  5182 00001EAE E8C401                   call putch
  5183 00001EB1 83C402                   add  sp, 2
  5184 00001EB4 FF4604                   inc  word [bp+4]
  5185 00001EB7 EBD8                     jmp @@cputs210
  5186                                  @@cputs211:
  5187                                  
  5188                                  ;-217 int mkneg(int n) { n; __asm {neg ax} }
  5189 00001EB9 C9                       LEAVE
  5190 00001EBA C3                       ret
  5191                                  ; ENDP
  5192                                  ;Number of CALLs:    2 : toupper
  5193                                  
  5194                                  toupper:  ; *** PROC ***
  5195                                  ;Function : toupper, Number of local variables: 1
  5196                                  ;   # type sign width line used address name   list of local variables
  5197                                  ;  200 ptr sign byte   217 NULL bp+4    s;
  5198 00001EBB C8000000                 ENTER  0,0
  5199                                  @@toupper212:
  5200 00001EBF 8B5E04                   mov bx, [bp+4]
  5201 00001EC2 8A07                     mov al, [bx]
  5202 00001EC4 B400                     mov ah, 0
  5203 00001EC6 08C0                     or  al, al
  5204 00001EC8 0F843000                 je @@toupper213
  5205 00001ECC 8B5E04                   mov bx, [bp+4]
  5206 00001ECF 8A07                     mov al, [bx]
  5207 00001ED1 B400                     mov ah, 0
  5208 00001ED3 83F861                   cmp ax, 97 ;unsigned : 1
  5209 00001ED6 0F8C1D00                 jl  @@toupper214
  5210 00001EDA 8B5E04                   mov bx, [bp+4]
  5211 00001EDD 8A07                     mov al, [bx]
  5212 00001EDF B400                     mov ah, 0
  5213 00001EE1 83F87A                   cmp ax, 122
  5214 00001EE4 0F8F0F00                 jg  @@toupper215
  5215 00001EE8 8B5E04                   mov bx, [bp+4]
  5216 00001EEB 8A07                     mov al, [bx]
  5217 00001EED B400                     mov ah, 0
  5218 00001EEF 83E820                   sub ax, 32
  5219 00001EF2 8B5E04                   mov  bx, [bp+4]
  5220 00001EF5 8807                     mov  [bx], al
  5221                                  @@toupper215:
  5222                                  @@toupper214:
  5223 00001EF7 FF4604                   inc  word [bp+4]
  5224 00001EFA EBC3                     jmp @@toupper212
  5225                                  @@toupper213:
  5226                                  
  5227                                  ;-218 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5228                                  
  5229                                  
  5230                                  ;-219 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5231 00001EFC C9                       LEAVE
  5232 00001EFD C3                       ret
  5233                                  ; ENDP
  5234                                  ;Number of CALLs:    4 : strlen
  5235                                  
  5236                                  strlen:  ; *** PROC ***
  5237                                  ;Function : strlen, Number of local variables: 2
  5238                                  ;   # type sign width line used address name   list of local variables
  5239                                  ;  200 ptr sign byte   219 NULL bp+4    s
  5240                                  ;  201 var sign word   219 NULL bp-2    c;
  5241 00001EFE C8020000                 ENTER  2,0
  5242 00001F02 66B800000000             mov eax, 0
  5243 00001F08 8946FE                   mov word [bp-2], ax
  5244                                  @@strlen216:
  5245 00001F0B 8B5E04                   mov bx, [bp+4]
  5246 00001F0E 8A07                     mov al, [bx]
  5247 00001F10 B400                     mov ah, 0
  5248 00001F12 83F800                   cmp ax, 0
  5249 00001F15 0F840800                 je  @@strlen217
  5250 00001F19 FF4604                   inc  word [bp+4]
  5251 00001F1C FF46FE                   inc  word [bp-2]
  5252 00001F1F EBEA                     jmp @@strlen216
  5253                                  @@strlen217:
  5254 00001F21 8B46FE                   mov ax, [bp-2]
  5255 00001F24 E90000                   jmp @@retn
  5256                                  
  5257                                  ;-220 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5258                                  
  5259 00001F27 C9                      @@retn: LEAVE
  5260 00001F28 C3                       ret
  5261                                  ; ENDP
  5262                                  ;Number of CALLs:    5 : strcpy
  5263                                  
  5264                                  strcpy:  ; *** PROC ***
  5265                                  ;Function : strcpy, Number of local variables: 2
  5266                                  ;   # type sign width line used address name   list of local variables
  5267                                  ;  200 ptr sign byte   220 NULL bp+4    s
  5268                                  ;  201 ptr sign byte   220 NULL bp+6    t;
  5269 00001F29 C8000000                 ENTER  0,0
  5270                                  @@strcpy218:
  5271 00001F2D 8B5E06                   mov bx, [bp+6]
  5272 00001F30 8A07                     mov al, [bx]
  5273 00001F32 B400                     mov ah, 0
  5274 00001F34 8B5E04                   mov  bx, [bp+4]
  5275 00001F37 8807                     mov  [bx], al
  5276 00001F39 FF4604                   inc  word [bp+4]
  5277 00001F3C FF4606                   inc  word [bp+6]
  5278                                  
  5279                                  ;-221   while (*t!=0); *s=0; return s; }
  5280                                  
  5281 00001F3F 8B5E06                   mov bx, [bp+6]
  5282 00001F42 8A07                     mov al, [bx]
  5283 00001F44 B400                     mov ah, 0
  5284 00001F46 83F800                   cmp ax, 0
  5285 00001F49 0F840200                 je  @@strcpy219
  5286 00001F4D EBDE                     jmp @@strcpy218
  5287                                  @@strcpy219:
  5288 00001F4F 66B800000000             mov eax, 0
  5289 00001F55 8B5E04                   mov  bx, [bp+4]
  5290 00001F58 8807                     mov  [bx], al
  5291 00001F5A 8B4604                   mov ax, [bp+4]
  5292 00001F5D E90000                   jmp @@retn
  5293                                  
  5294                                  ;-222 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5295                                  
  5296 00001F60 C9                      @@retn: LEAVE
  5297 00001F61 C3                       ret
  5298                                  ; ENDP
  5299                                  ;Number of CALLs:    3 : digit
  5300                                  
  5301                                  digit:  ; *** PROC ***
  5302                                  ;Function : digit, Number of local variables: 1
  5303                                  ;   # type sign width line used address name   list of local variables
  5304                                  ;  200 var sign byte   222 NULL bp+4    c;
  5305 00001F62 C8000000                 ENTER  0,0
  5306 00001F66 8A4604                   mov al, [bp+4]
  5307 00001F69 3C30                     cmp al, 48
  5308 00001F6B 0F8D0900                 jge @@digit220
  5309 00001F6F 66B800000000             mov eax, 0
  5310 00001F75 E91B00                   jmp @@retn
  5311                                  @@digit220:
  5312 00001F78 8A4604                   mov al, [bp+4]
  5313 00001F7B 3C39                     cmp al, 57
  5314 00001F7D 0F8E0900                 jle @@digit221
  5315 00001F81 66B800000000             mov eax, 0
  5316 00001F87 E90900                   jmp @@retn
  5317                                  @@digit221:
  5318 00001F8A 66B801000000             mov eax, 1
  5319 00001F90 E90000                   jmp @@retn
  5320                                  
  5321                                  ;-223 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5322                                  
  5323 00001F93 C9                      @@retn: LEAVE
  5324 00001F94 C3                       ret
  5325                                  ; ENDP
  5326                                  ;Number of CALLs:   35 : eqstr
  5327                                  
  5328                                  eqstr:  ; *** PROC ***
  5329                                  ;Function : eqstr, Number of local variables: 2
  5330                                  ;   # type sign width line used address name   list of local variables
  5331                                  ;  200 ptr sign byte   223 NULL bp+4    p
  5332                                  ;  201 ptr sign byte   223 NULL bp+6    q;
  5333 00001F95 C8000000                 ENTER  0,0
  5334                                  @@eqstr222:
  5335 00001F99 8B5E04                   mov bx, [bp+4]
  5336 00001F9C 8A07                     mov al, [bx]
  5337 00001F9E B400                     mov ah, 0
  5338 00001FA0 08C0                     or  al, al
  5339 00001FA2 0F842300                 je @@eqstr223
  5340                                  
  5341                                  ;-224     if (*p != *q) return 0; p++; q++; }
  5342                                  
  5343 00001FA6 8B5E04                   mov bx, [bp+4]
  5344 00001FA9 8A07                     mov al, [bx]
  5345 00001FAB B400                     mov ah, 0
  5346 00001FAD 8B5E06                   mov bx, [bp+6]
  5347 00001FB0 3A07                     cmp al, [bx]
  5348 00001FB2 B400                     mov ah, 0
  5349 00001FB4 0F840900                 je  @@eqstr224
  5350 00001FB8 66B800000000             mov eax, 0
  5351 00001FBE E92700                   jmp @@retn
  5352                                  @@eqstr224:
  5353 00001FC1 FF4604                   inc  word [bp+4]
  5354 00001FC4 FF4606                   inc  word [bp+6]
  5355                                  
  5356                                  ;-225     if(*q) return 0; return 1; }
  5357                                  
  5358 00001FC7 EBD0                     jmp @@eqstr222
  5359                                  @@eqstr223:
  5360 00001FC9 8B5E06                   mov bx, [bp+6]
  5361 00001FCC 8A07                     mov al, [bx]
  5362 00001FCE B400                     mov ah, 0
  5363 00001FD0 08C0                     or  al, al
  5364 00001FD2 0F840900                 je @@eqstr225
  5365 00001FD6 66B800000000             mov eax, 0
  5366 00001FDC E90900                   jmp @@retn
  5367                                  @@eqstr225:
  5368 00001FDF 66B801000000             mov eax, 1
  5369 00001FE5 E90000                   jmp @@retn
  5370                                  
  5371                                  ;-226 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5372                                  
  5373 00001FE8 C9                      @@retn: LEAVE
  5374 00001FE9 C3                       ret
  5375                                  ; ENDP
  5376                                  ;Number of CALLs:    3 : strcat1
  5377                                  
  5378                                  strcat1:  ; *** PROC ***
  5379                                  ;Function : strcat1, Number of local variables: 2
  5380                                  ;   # type sign width line used address name   list of local variables
  5381                                  ;  200 ptr sign byte   226 NULL bp+4    s
  5382                                  ;  201 ptr sign byte   226 NULL bp+6    t;
  5383 00001FEA C8000000                 ENTER  0,0
  5384                                  @@strcat1226:
  5385 00001FEE 8B5E04                   mov bx, [bp+4]
  5386 00001FF1 8A07                     mov al, [bx]
  5387 00001FF3 B400                     mov ah, 0
  5388 00001FF5 83F800                   cmp ax, 0
  5389 00001FF8 0F840500                 je  @@strcat1227
  5390 00001FFC FF4604                   inc  word [bp+4]
  5391 00001FFF EBED                     jmp @@strcat1226
  5392                                  @@strcat1227:
  5393 00002001 FF7606                   push word [bp+6]
  5394 00002004 FF7604                   push word [bp+4]
  5395 00002007 E81FFF                   call strcpy
  5396 0000200A 83C404                   add  sp, 4
  5397                                  
  5398                                  ;-227 int basename(char *s) { char *p; p=0;
  5399 0000200D C9                       LEAVE
  5400 0000200E C3                       ret
  5401                                  ; ENDP
  5402                                  ;Number of CALLs:    1 : openR
  5403                                  
  5404                                  openR:  ; *** PROC ***
  5405                                  ;Function : openR, Number of local variables: 1
  5406                                  ;   # type sign width line used address name   list of local variables
  5407                                  ;  200 ptr sign byte   227 NULL bp+4    s;
  5408 0000200F C8000000                 ENTER  0,0
  5409 00002013 8B5604                   mov  dx, [bp+4]
  5410 00002016 B8023D                   mov  ax, 15618
  5411 00002019 E87200                   call DosInt
  5412                                  
  5413                                  ;-228 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5414 0000201C C9                       LEAVE
  5415 0000201D C3                       ret
  5416                                  ; ENDP
  5417                                  ;Number of CALLs:    2 : creatR
  5418                                  
  5419                                  creatR:  ; *** PROC ***
  5420                                  ;Function : creatR, Number of local variables: 1
  5421                                  ;   # type sign width line used address name   list of local variables
  5422                                  ;  200 ptr sign byte   228 NULL bp+4    s;
  5423 0000201E C8000000                 ENTER  0,0
  5424 00002022 8B5604                   mov  dx, [bp+4]
  5425 00002025 B90000                   mov  cx, 0
  5426 00002028 B8003C                   mov  ax, 15360
  5427 0000202B E86000                   call DosInt
  5428                                  
  5429                                  ;-229 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5430 0000202E C9                       LEAVE
  5431 0000202F C3                       ret
  5432                                  ; ENDP
  5433                                  ;Number of CALLs:    2 : readRL
  5434                                  
  5435                                  readRL:  ; *** PROC ***
  5436                                  ;Function : readRL, Number of local variables: 3
  5437                                  ;   # type sign width line used address name   list of local variables
  5438                                  ;  200 ptr sign byte   229 NULL bp+4    s
  5439                                  ;  201 var sign word   229 NULL bp+6    fd
  5440                                  ;  202 var sign word   229 NULL bp+8    len;
  5441 00002030 C8000000                 ENTER  0,0
  5442 00002034 8B5604                   mov  dx, [bp+4]
  5443 00002037 8B4E08                   mov  cx, [bp+8]
  5444 0000203A 8B5E06                   mov  bx, [bp+6]
  5445 0000203D B8003F                   mov  ax, 16128
  5446 00002040 E84B00                   call DosInt
  5447                                  
  5448                                  ;-230 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5449 00002043 C9                       LEAVE
  5450 00002044 C3                       ret
  5451                                  ; ENDP
  5452                                  ;Number of CALLs:    2 : fputcR
  5453                                  
  5454                                  fputcR:  ; *** PROC ***
  5455                                  ;Function : fputcR, Number of local variables: 2
  5456                                  ;   # type sign width line used address name   list of local variables
  5457                                  ;  200 ptr sign byte   230 NULL bp+4    n
  5458                                  ;  201 var sign word   230 NULL bp+6    fd;
  5459 00002045 C8000000                 ENTER  0,0
  5460 00002049 8D5604                  lea dx, [bp+4]
  5461                                  
  5462                                  ;-231   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5463                                  
  5464 0000204C B90100                   mov  cx, 1
  5465 0000204F 8B5E06                   mov  bx, [bp+6]
  5466 00002052 B80040                   mov  ax, 16384
  5467 00002055 E83600                   call DosInt
  5468                                  
  5469                                  ;-232 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5470 00002058 C9                       LEAVE
  5471 00002059 C3                       ret
  5472                                  ; ENDP
  5473                                  ;Number of CALLs:    3 : fcloseR
  5474                                  
  5475                                  fcloseR:  ; *** PROC ***
  5476                                  ;Function : fcloseR, Number of local variables: 1
  5477                                  ;   # type sign width line used address name   list of local variables
  5478                                  ;  200 var sign word   232 NULL bp+4    fd;
  5479 0000205A C8000000                 ENTER  0,0
  5480 0000205E 8B5E04                   mov  bx, [bp+4]
  5481 00002061 B8003E                   mov  ax, 15872
  5482 00002064 CD21                     int  33
  5483                                  
  5484                                  ;-233 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5485 00002066 C9                       LEAVE
  5486 00002067 C3                       ret
  5487                                  ; ENDP
  5488                                  ;Number of CALLs:    5 : exitR
  5489                                  
  5490                                  exitR:  ; *** PROC ***
  5491                                  ;Function : exitR, Number of local variables: 1
  5492                                  ;   # type sign width line used address name   list of local variables
  5493                                  ;  200 var sign byte   233 NULL bp+4    c;
  5494 00002068 C8000000                 ENTER  0,0
  5495 0000206C B44C                     mov  ah, 76
  5496 0000206E 8A4604                   mov  al, [bp+4]
  5497 00002071 CD21                     int  33
  5498                                  
  5499                                  ;-234 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5500 00002073 C9                       LEAVE
  5501 00002074 C3                       ret
  5502                                  ; ENDP
  5503                                  ;End of archive file. 
  5504                                   
  5505                                  ; missing functions: 
  5506                                  ; putch
  5507                                  ; DosInt
  5508                                  ; DosInt
  5509                                  ; DosInt
  5510                                  ; DosInt
  5511                                  ; Number of unresolved CALLs :    5
  5512                                  ;use archive file: AR.C
  5513                                  
  5514                                  ;-235 // AR.C Archive
  5515                                  
  5516                                  ;Number of CALLs:    1 : putch
  5517                                  
  5518                                  putch:  ; *** PROC ***
  5519                                  ;Function : putch, Number of local variables: 1
  5520                                  ;   # type sign width line used address name   list of local variables
  5521                                  ;  200 var sign byte   235 NULL bp+4    c;
  5522 00002075 C8000000                 ENTER  0,0
  5523 00002079 807E040A                cmp byte [bp+4], 10
  5524 0000207D 0F850500                 jne @@putch228
  5525 00002081 B00D                     mov  al, 13
  5526 00002083 E8FFFD                   call writetty
  5527                                  @@putch228:
  5528 00002086 8A4604                   mov  al, [bp+4]
  5529 00002089 E8F9FD                   call writetty
  5530                                  
  5531                                  ;-236 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5532 0000208C C9                       LEAVE
  5533 0000208D C3                       ret
  5534                                  ; ENDP
  5535                                  ;Number of CALLs:    4 : DosInt
  5536                                  
  5537                                  DosInt:  ; *** PROC ***
  5538 0000208E CD21                     int  33
  5539 00002090 7304                     jae short @@DosInt229
  5540 00002092 FF06[3000]               inc  word [DOS_ERR]
  5541                                  @@DosInt229:
  5542                                  
  5543                                  ;-237 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5544                                  
  5545 00002096 C3                       ret
  5546                                  ; ENDP
  5547                                  ;End of archive file. 
  5548                                   
  5549                                  ; missing functions:  All FUNCTIONs in place
  5550 00002097 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5551 0000209A 58                      pop ax
  5552 0000209B C3                      ret
  5553                                   
  5554                                  ;   # type sign width line used  address name   list of global variables
  5555                                  
  5556                                  ;    1 arr sign byte     2    2        0 Version1[20]
  5557                                  ;    2 var sign byte     1    3        0 LIST
  5558                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5559                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5560                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5561                                  ;    6 var unsg word     5   12        0 SymbolInt
  5562                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5563                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5564                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5565                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5566                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5567                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5568                                  ;   13 var sign word    12    4        0 asm_fd
  5569                                  ;   14 var sign word    13    3        0 lst_fd
  5570                                  ;   15 var sign word    14    3        0 bin_fd
  5571                                  ;   16 var sign word    15    6        0 DOS_ERR
  5572                                  ;   17 var sign word    16    4        0 ErrorCount
  5573                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5574                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5575                                  ;   20 var unsg word    20    5        0 PC
  5576                                  ;   21 var unsg word    21    2        0 PCStart
  5577                                  ;   22 var sign byte    22    3        0 isLabel
  5578                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5579                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5580                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5581                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5582                                  ;   27 var sign byte    27   20        0 TokeType
  5583                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5584                                  ;   29 def unsg byte    29    -        0 WORD=2
  5585                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5586                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5587                                  ;   32 def unsg byte    33    -        0 IMM=1
  5588                                  ;   33 def unsg byte    34    -        0 REG=2
  5589                                  ;   34 def unsg byte    35    -        0 ADR=3
  5590                                  ;   35 def unsg byte    36    -        0 MEM=4
  5591                                  ;   36 var sign byte    37   13        0 Op1
  5592                                  ;   37 var sign byte    38   11        0 CodeType
  5593                                  ;   38 var sign byte    39    4        0 Code1
  5594                                  ;   39 var sign byte    40    4        0 Code2
  5595                                  ;   40 var sign byte    41    3        0 Code3
  5596                                  ;   41 var sign byte    42   17        0 RegType
  5597                                  ;   42 var sign byte    43   10        0 RegNo
  5598                                  ;   43 var sign byte    44   10        0 OpSize
  5599                                  ;   44 var sign byte    45    4        0 wflag
  5600                                  ;   45 var sign byte    50   14        0 regindexbase
  5601                                  ;   46 var sign word    51   13        0 disp
  5602                                  ;   47 var sign word    52    2        0 imme
  5603                                  ;   48 def unsg byte    54    -        0 OPMAXLEN=5
  5604                                  ;   49 arr sign byte    55    2    30390 OpPos[5]
  5605                                  ;   50 var sign word    56    6        0 OpPrintIndex
  5606                                  ;   51 ptr sign byte    57   17        0 OpCodePtr
  5607                                  ;   52 var sign byte    58    2        0 PrintR
  5608                                  ;   53 def unsg byte    60    -        0 LABELNAMESMAX=969
  5609                                  ;   54 arr sign byte    61    3    30395 LabelNames[1000]
  5610                                  ;   55 ptr sign byte    62   10        0 LabelNamePtr
  5611                                  ;   56 def unsg byte    63    -        0 LABELADRMAX=100
  5612                                  ;   57 arr unsg word    64    4    31395 LabelAddr[100]
  5613                                  ;   58 var sign word    65    5        0 LabelMaxIx
  5614                                  ;   59 var sign word    66    4        0 LabelIx
  5615                                  ;   60 def unsg byte    68    -        0 FILEBINMAX=1990
  5616                                  ;   61 arr sign byte    69    3    31595 FileBin[2000]
  5617                                  ;   62 var unsg word    70    5        0 BinLen
  5618                                  ;   63 ptr sign byte    72    1        0 arglen
  5619                                  ;   64 ptr sign byte    73    4        0 argv
  5620                                  ;   65 var sign byte     1    1        0 I_START
  5621                                  ;   66 arr sign byte     4 NULL        0 I_PUSHA[9]
  5622                                  ;   67 arr sign byte     5 NULL        0 I_POPA[8]
  5623                                  ;   68 arr sign byte     6 NULL        0 I_NOP[7]
  5624                                  ;   69 arr sign byte     7 NULL        0 I_CBW[7]
  5625                                  ;   70 arr sign byte     8 NULL        0 I_CWDE[8]
  5626                                  ;   71 arr sign byte     9 NULL        0 I_CWD[7]
  5627                                  ;   72 arr sign byte    10 NULL        0 I_CDQ[7]
  5628                                  ;   73 arr sign byte    11 NULL        0 I_WAIT[8]
  5629                                  ;   74 arr sign byte    12 NULL        0 I_PUSHF[9]
  5630                                  ;   75 arr sign byte    13 NULL        0 I_POPF[8]
  5631                                  ;   76 arr sign byte    14 NULL        0 I_SAHF[8]
  5632                                  ;   77 arr sign byte    15 NULL        0 I_LAHF[8]
  5633                                  ;   78 arr sign byte    16 NULL        0 I_MOVSB[9]
  5634                                  ;   79 arr sign byte    17 NULL        0 I_MOVSW[9]
  5635                                  ;   80 arr sign byte    18 NULL        0 I_CMPSB[9]
  5636                                  ;   81 arr sign byte    19 NULL        0 I_CMPSW[9]
  5637                                  ;   82 arr sign byte    20 NULL        0 I_STOSB[9]
  5638                                  ;   83 arr sign byte    21 NULL        0 I_STOSW[9]
  5639                                  ;   84 arr sign byte    22 NULL        0 I_LODSB[9]
  5640                                  ;   85 arr sign byte    23 NULL        0 I_LODSW[9]
  5641                                  ;   86 arr sign byte    24 NULL        0 I_SCASB[9]
  5642                                  ;   87 arr sign byte    25 NULL        0 I_SCASW[9]
  5643                                  ;   88 arr sign byte    26 NULL        0 I_LEAVE[9]
  5644                                  ;   89 arr sign byte    27 NULL        0 I_IRET[8]
  5645                                  ;   90 arr sign byte    28 NULL        0 I_XLAT[8]
  5646                                  ;   91 arr sign byte    29 NULL        0 I_LOCK[8]
  5647                                  ;   92 arr sign byte    30 NULL        0 I_REPNE[9]
  5648                                  ;   93 arr sign byte    31 NULL        0 I_REPNZ[9]
  5649                                  ;   94 arr sign byte    32 NULL        0 I_REPE[8]
  5650                                  ;   95 arr sign byte    33 NULL        0 I_REPZ[8]
  5651                                  ;   96 arr sign byte    34 NULL        0 I_HLT[7]
  5652                                  ;   97 arr sign byte    35 NULL        0 I_CLC[7]
  5653                                  ;   98 arr sign byte    36 NULL        0 I_STC[7]
  5654                                  ;   99 arr sign byte    37 NULL        0 I_CLI[7]
  5655                                  ;  100 arr sign byte    38 NULL        0 I_STI[7]
  5656                                  ;  101 arr sign byte    39 NULL        0 I_CLD[7]
  5657                                  ;  102 arr sign byte    40 NULL        0 I_STD[7]
  5658                                  ;  103 arr sign byte    42 NULL        0 I_INC[9]
  5659                                  ;  104 arr sign byte    43 NULL        0 I_DEC[9]
  5660                                  ;  105 arr sign byte    44 NULL        0 I_NOT[8]
  5661                                  ;  106 arr sign byte    45 NULL        0 I_NEG[8]
  5662                                  ;  107 arr sign byte    46 NULL        0 I_MUL[8]
  5663                                  ;  108 arr sign byte    47 NULL        0 I_IMUL[9]
  5664                                  ;  109 arr sign byte    48 NULL        0 I_DIV[8]
  5665                                  ;  110 arr sign byte    49 NULL        0 I_IDIV[9]
  5666                                  ;  111 arr sign byte    51 NULL        0 I_LES[7]
  5667                                  ;  112 arr sign byte    52 NULL        0 I_LDS[7]
  5668                                  ;  113 arr sign byte    53 NULL        0 I_LEA[7]
  5669                                  ;  114 arr sign byte    55 NULL        0 I_ADD[7]
  5670                                  ;  115 arr sign byte    56 NULL        0 I_OR[6]
  5671                                  ;  116 arr sign byte    57 NULL        0 I_ADC[7]
  5672                                  ;  117 arr sign byte    58 NULL        0 I_SBB[7]
  5673                                  ;  118 arr sign byte    59 NULL        0 I_AND[7]
  5674                                  ;  119 arr sign byte    60 NULL        0 I_SUB[7]
  5675                                  ;  120 arr sign byte    61 NULL        0 I_XOR[7]
  5676                                  ;  121 arr sign byte    62 NULL        0 I_CMP[7]
  5677                                  ;  122 arr sign byte    64 NULL        0 I_MOV[6]
  5678                                  ;  123 arr sign byte    65 NULL        0 I_MOVSX[9]
  5679                                  ;  124 arr sign byte    66 NULL        0 I_MOVZX[9]
  5680                                  ;  125 arr sign byte    68 NULL        0 I_JO[6]
  5681                                  ;  126 arr sign byte    69 NULL        0 I_JNO[7]
  5682                                  ;  127 arr sign byte    70 NULL        0 I_JB[6]
  5683                                  ;  128 arr sign byte    71 NULL        0 I_JC[6]
  5684                                  ;  129 arr sign byte    72 NULL        0 I_JNB[7]
  5685                                  ;  130 arr sign byte    73 NULL        0 I_JAE[7]
  5686                                  ;  131 arr sign byte    74 NULL        0 I_JNC[7]
  5687                                  ;  132 arr sign byte    75 NULL        0 I_JE[6]
  5688                                  ;  133 arr sign byte    76 NULL        0 I_JZ[6]
  5689                                  ;  134 arr sign byte    77 NULL        0 I_JNE[7]
  5690                                  ;  135 arr sign byte    78 NULL        0 I_JNZ[7]
  5691                                  ;  136 arr sign byte    79 NULL        0 I_JBE[7]
  5692                                  ;  137 arr sign byte    80 NULL        0 I_JNA[7]
  5693                                  ;  138 arr sign byte    81 NULL        0 I_JA[6]
  5694                                  ;  139 arr sign byte    82 NULL        0 I_JS[6]
  5695                                  ;  140 arr sign byte    83 NULL        0 I_JNS[7]
  5696                                  ;  141 arr sign byte    84 NULL        0 I_JP[6]
  5697                                  ;  142 arr sign byte    85 NULL        0 I_JPE[7]
  5698                                  ;  143 arr sign byte    86 NULL        0 I_JNP[7]
  5699                                  ;  144 arr sign byte    87 NULL        0 I_JPO[7]
  5700                                  ;  145 arr sign byte    88 NULL        0 I_JL[6]
  5701                                  ;  146 arr sign byte    89 NULL        0 I_JNL[7]
  5702                                  ;  147 arr sign byte    90 NULL        0 I_JGE[7]
  5703                                  ;  148 arr sign byte    91 NULL        0 I_JLE[7]
  5704                                  ;  149 arr sign byte    92 NULL        0 I_JNG[7]
  5705                                  ;  150 arr sign byte    93 NULL        0 I_JG[6]
  5706                                  ;  151 arr sign byte    95 NULL        0 I_JMP[8]
  5707                                  ;  152 arr sign byte    96 NULL        0 I_CALL[9]
  5708                                  ;  153 arr sign byte    98 NULL        0 I_RET[8]
  5709                                  ;  154 arr sign byte    99 NULL        0 I_RETF[9]
  5710                                  ;  155 arr sign byte   101 NULL        0 I_PUSH[8]
  5711                                  ;  156 arr sign byte   102 NULL        0 I_POP[7]
  5712                                  ;  157 arr sign byte   104 NULL        0 I_ROL[7]
  5713                                  ;  158 arr sign byte   105 NULL        0 I_ROR[7]
  5714                                  ;  159 arr sign byte   106 NULL        0 I_RCL[7]
  5715                                  ;  160 arr sign byte   107 NULL        0 I_RCR[7]
  5716                                  ;  161 arr sign byte   108 NULL        0 I_SHL[7]
  5717                                  ;  162 arr sign byte   109 NULL        0 I_SAL[7]
  5718                                  ;  163 arr sign byte   110 NULL        0 I_SHR[7]
  5719                                  ;  164 arr sign byte   111 NULL        0 I_SAR[7]
  5720                                  ;  165 arr sign byte   113 NULL        0 I_INT[8]
  5721                                  ;  166 arr sign byte   114 NULL        0 I_INTO[8]
  5722                                  ;  167 arr sign byte   116 NULL        0 I_IN[7]
  5723                                  ;  168 arr sign byte   117 NULL        0 I_INSB[8]
  5724                                  ;  169 arr sign byte   118 NULL        0 I_INSW[8]
  5725                                  ;  170 arr sign byte   119 NULL        0 I_INSD[8]
  5726                                  ;  171 arr sign byte   120 NULL        0 I_OUT[8]
  5727                                  ;  172 arr sign byte   121 NULL        0 I_OUTSB[8]
  5728                                  ;  173 arr sign byte   122 NULL        0 I_OUTSW[8]
  5729                                  ;  174 arr sign byte   123 NULL        0 I_OUTSD[8]
  5730                                  ;  175 arr sign byte   125 NULL        0 I_XCHG[9]
  5731                                  ;  176 arr sign byte   127 NULL        0 I_LOOPNZ[10]
  5732                                  ;  177 arr sign byte   128 NULL        0 I_LOOPNE[10]
  5733                                  ;  178 arr sign byte   129 NULL        0 I_LOOPZ[9]
  5734                                  ;  179 arr sign byte   130 NULL        0 I_LOOPE[9]
  5735                                  ;  180 arr sign byte   131 NULL        0 I_LOOP[8]
  5736                                  ;  181 arr sign byte   132 NULL        0 I_JCXZ[8]
  5737                                  ;  182 arr sign byte   133 NULL        0 I_JECXZ[9]
  5738                                  ;  183 arr sign byte   135 NULL        0 I_ENTER[9]
  5739                                  ;  184 arr sign byte   137 NULL        0 I_ORG[6]
  5740                                  ;  185 arr sign byte   138 NULL        0 I_DB[5]
  5741                                  ;  186 arr sign byte   139 NULL        0 I_DW[5]
  5742                                  ;  187 arr sign byte   140 NULL        0 I_DD[5]
  5743                                  ;  188 arr sign byte   141 NULL        0 I_RESB[7]
  5744                                  ;  189 arr sign byte   142 NULL        0 I_RESW[7]
  5745                                  ;  190 arr sign byte   143 NULL        0 I_RESD[7]
  5746                                  ;  191 var sign byte   144 NULL        0 I_END
  5747                                  
  5748                                  
  5749                                  ;   # Calls Line Width  Name   list of functions
  5750                                  
  5751                                  ;    0 NULL    1 word   main
  5752                                  ;    1    1    6 word   process
  5753                                  ;    2    1   45 word   setwflag
  5754                                  ;    3 NULL   57 word   Check2Op
  5755                                  ;    4    1   59 word   checkLeftOp
  5756                                  ;    5 NULL   70 word   saveLeftOp
  5757                                  ;    6 NULL   72 word   checkRightOp
  5758                                  ;    7    1   84 word   getOp
  5759                                  ;    8    2   97 word   getOp1
  5760                                  ;    9    1  113 word   getMEM
  5761                                  ;   10    1  133 word   getIndReg1
  5762                                  ;   11    1  141 word   getIndReg2
  5763                                  ;   12    1  152 word   getCodes
  5764                                  ;   13    1  160 word   gen66h
  5765                                  ;   14    3  162 word   genCode
  5766                                  ;   15   11  166 word   genCode8
  5767                                  ;   16    3  176 word   genCode16
  5768                                  ;   17    1  180 word   writeEA
  5769                                  ;   18 NULL  201 word   testx
  5770                                  ;   19    1    1 word   parse
  5771                                  ;   20   12   27 word   getTokeType
  5772                                  ;   21    2   36 word   storeLabel
  5773                                  ;   22    2   43 word   searchLabel
  5774                                  ;   23    1   54 word   getVariable
  5775                                  ;   24    2   83 word   lookCode
  5776                                  ;   25    1   97 word   getCodeSize
  5777                                  ;   26    7  104 word   isToken
  5778                                  ;   27    1  109 word   skipRest
  5779                                  ;   28    1    1 word   getLine
  5780                                  ;   29    1   14 word   ifEOL
  5781                                  ;   30    3   21 word   skipBlank
  5782                                  ;   31    2   26 word   letterE
  5783                                  ;   32    1   36 word   alnumE
  5784                                  ;   33    1   41 word   getDigit
  5785                                  ;   34    1   53 word   getName
  5786                                  ;   35    1   70 word   testReg
  5787                                  ;   36    1    1 word   printLine
  5788                                  ;   37    9   19 word   prc
  5789                                  ;   38    1   23 word   prscomment
  5790                                  ;   39   23   26 word   prs
  5791                                  ;   40    4   31 word   printhex8a
  5792                                  ;   41    2   35 word   printhex16
  5793                                  ;   42    3   38 word   printIntU
  5794                                  ;   43   20   45 word   error1
  5795                                  ;   44 NULL   48 word   allowederror
  5796                                  ;   45 NULL   49 word   implmerror
  5797                                  ;   46    4   50 word   indexerror
  5798                                  ;   47    1   51 word   numbererror
  5799                                  ;   48 NULL   52 word   regmemerror
  5800                                  ;   49    1   53 word   segregerror
  5801                                  ;   50    1   54 word   syntaxerror
  5802                                  ;   51    7   56 word   errorexit
  5803                                  ;   52    1   57 word   addrexit
  5804                                  ;   53 NULL   58 word   internexit
  5805                                  ;   54    1    1 word   getarg
  5806                                  ;   55    1   26 word   epilog
  5807                                  ;   56    2   53 word   end1
  5808                                  ;   57    4  215 word   writetty
  5809                                  ;   58    8  216 word   cputs
  5810                                  ;   59    2  217 word   toupper
  5811                                  ;   60    4  219 word   strlen
  5812                                  ;   61    6  220 word   strcpy
  5813                                  ;   62    3  222 word   digit
  5814                                  ;   63   35  223 word   eqstr
  5815                                  ;   64    3  226 word   strcat1
  5816                                  ;   65    1  227 word   openR
  5817                                  ;   66    2  228 word   creatR
  5818                                  ;   67    2  229 word   readRL
  5819                                  ;   68    2  230 word   fputcR
  5820                                  ;   69    3  232 word   fcloseR
  5821                                  ;   70    5  233 word   exitR
  5822                                  ;   71    1  235 word   putch
  5823                                  ;   72    4  236 word   DosInt
  5824                                  ;   73 NULL  237 word   LastFunctionByt
  5825                                  
  5826                                  ;    #  addr name   list of CALLs
  5827                                  
  5828                                  ;    0     5 getarg
  5829                                  ;    1    12 parse
  5830                                  ;    2    18 epilog
  5831                                  ;    3    25 end1
  5832                                  ;    4  1382 getTokeType
  5833                                  ;    5  1394 getCodeSize
  5834                                  ;    6  1406 getCodes
  5835                                  ;    7  1415 genCode8
  5836                                  ;    8  1424 checkLeftOp
  5837                                  ;    9  1436 genCode
  5838                                  ;   10  1444 genCode
  5839                                  ;   11  1452 genCode
  5840                                  ;   12  1460 writeEA
  5841                                  ;   13  1468 genCode8
  5842                                  ;   14  1477 genCode16
  5843                                  ;   15  1487 genCode8
  5844                                  ;   16  1496 error1
  5845                                  ;   17  1503 error1
  5846                                  ;   18  1519 gen66h
  5847                                  ;   19  1558 getOp
  5848                                  ;   20  1564 segregerror
  5849                                  ;   21  1576 setwflag
  5850                                  ;   22  1585 error1
  5851                                  ;   23  1592 error1
  5852                                  ;   24  1599 error1
  5853                                  ;   25  1641 getOp1
  5854                                  ;   26  1648 isToken
  5855                                  ;   27  1656 getMEM
  5856                                  ;   28  1663 error1
  5857                                  ;   29  1670 error1
  5858                                  ;   30  1684 testReg
  5859                                  ;   31  1692 searchLabel
  5860                                  ;   32  1704 error1
  5861                                  ;   33  1722 getTokeType
  5862                                  ;   34  1734 getOp1
  5863                                  ;   35  1741 syntaxerror
  5864                                  ;   36  1753 getIndReg2
  5865                                  ;   37  1764 getIndReg1
  5866                                  ;   38  1775 isToken
  5867                                  ;   39  1783 getTokeType
  5868                                  ;   40  1795 numbererror
  5869                                  ;   41  1807 isToken
  5870                                  ;   42  1815 isToken
  5871                                  ;   43  1823 errorexit
  5872                                  ;   44  1844 indexerror
  5873                                  ;   45  1855 indexerror
  5874                                  ;   46  1879 indexerror
  5875                                  ;   47  1890 indexerror
  5876                                  ;   48  1917 genCode8
  5877                                  ;   49  1938 genCode8
  5878                                  ;   50  1970 genCode8
  5879                                  ;   51  1979 genCode8
  5880                                  ;   52  2004 addrexit
  5881                                  ;   53  2013 genCode8
  5882                                  ;   54  2022 genCode8
  5883                                  ;   55  2031 genCode16
  5884                                  ;   56  2053 getLine
  5885                                  ;   57  2061 getTokeType
  5886                                  ;   58  2073 storeLabel
  5887                                  ;   59  2084 getTokeType
  5888                                  ;   60  2096 lookCode
  5889                                  ;   61  2105 process
  5890                                  ;   62  2113 getVariable
  5891                                  ;   63  2125 skipRest
  5892                                  ;   64  2134 error1
  5893                                  ;   65  2141 error1
  5894                                  ;   66  2148 printLine
  5895                                  ;   67  2172 skipBlank
  5896                                  ;   68  2182 digit
  5897                                  ;   69  2188 getDigit
  5898                                  ;   70  2197 letterE
  5899                                  ;   71  2205 getName
  5900                                  ;   72  2224 searchLabel
  5901                                  ;   73  2236 error1
  5902                                  ;   74  2243 strcpy
  5903                                  ;   75  2270 eqstr
  5904                                  ;   76  2276 strlen
  5905                                  ;   77  2297 storeLabel
  5906                                  ;   78  2308 getTokeType
  5907                                  ;   79  2320 lookCode
  5908                                  ;   80  2329 errorexit
  5909                                  ;   81  2339 errorexit
  5910                                  ;   82  2349 getTokeType
  5911                                  ;   83  2361 genCode8
  5912                                  ;   84  2370 skipBlank
  5913                                  ;   85  2380 isToken
  5914                                  ;   86  2388 genCode8
  5915                                  ;   87  2397 isToken
  5916                                  ;   88  2405 getTokeType
  5917                                  ;   89  2417 genCode16
  5918                                  ;   90  2427 isToken
  5919                                  ;   91  2435 errorexit
  5920                                  ;   92  2454 eqstr
  5921                                  ;   93  2472 eqstr
  5922                                  ;   94  2478 getTokeType
  5923                                  ;   95  2490 eqstr
  5924                                  ;   96  2496 getTokeType
  5925                                  ;   97  2508 eqstr
  5926                                  ;   98  2514 getTokeType
  5927                                  ;   99  2536 skipBlank
  5928                                  ;  100  2555 getTokeType
  5929                                  ;  101  2567 error1
  5930                                  ;  102  2582 readRL
  5931                                  ;  103  2589 errorexit
  5932                                  ;  104  2599 ifEOL
  5933                                  ;  105  2613 readRL
  5934                                  ;  106  2649 digit
  5935                                  ;  107  2655 letterE
  5936                                  ;  108  2682 digit
  5937                                  ;  109  2700 alnumE
  5938                                  ;  110  2707 strcpy
  5939                                  ;  111  2714 toupper
  5940                                  ;  112  2730 strlen
  5941                                  ;  113  2737 strlen
  5942                                  ;  114  2744 eqstr
  5943                                  ;  115  2750 eqstr
  5944                                  ;  116  2756 eqstr
  5945                                  ;  117  2762 eqstr
  5946                                  ;  118  2768 eqstr
  5947                                  ;  119  2774 eqstr
  5948                                  ;  120  2780 eqstr
  5949                                  ;  121  2786 eqstr
  5950                                  ;  122  2792 eqstr
  5951                                  ;  123  2798 eqstr
  5952                                  ;  124  2804 eqstr
  5953                                  ;  125  2810 eqstr
  5954                                  ;  126  2816 eqstr
  5955                                  ;  127  2822 eqstr
  5956                                  ;  128  2828 eqstr
  5957                                  ;  129  2834 eqstr
  5958                                  ;  130  2840 eqstr
  5959                                  ;  131  2846 eqstr
  5960                                  ;  132  2852 eqstr
  5961                                  ;  133  2858 eqstr
  5962                                  ;  134  2864 eqstr
  5963                                  ;  135  2870 eqstr
  5964                                  ;  136  2876 eqstr
  5965                                  ;  137  2882 eqstr
  5966                                  ;  138  2888 eqstr
  5967                                  ;  139  2894 eqstr
  5968                                  ;  140  2900 eqstr
  5969                                  ;  141  2906 eqstr
  5970                                  ;  142  2912 eqstr
  5971                                  ;  143  2918 eqstr
  5972                                  ;  144  2938 prs
  5973                                  ;  145  2942 printhex16
  5974                                  ;  146  2953 prs
  5975                                  ;  147  2957 prc
  5976                                  ;  148  2961 printhex8a
  5977                                  ;  149  2972 prc
  5978                                  ;  150  2976 prs
  5979                                  ;  151  2980 prscomment
  5980                                  ;  152  2997 writetty
  5981                                  ;  153  3006 writetty
  5982                                  ;  154  3015 fputcR
  5983                                  ;  155  3037 prc
  5984                                  ;  156  3053 prc
  5985                                  ;  157  3074 prc
  5986                                  ;  158  3078 prc
  5987                                  ;  159  3100 printhex8a
  5988                                  ;  160  3111 printhex8a
  5989                                  ;  161  3136 printIntU
  5990                                  ;  162  3146 prc
  5991                                  ;  163  3159 prs
  5992                                  ;  164  3163 prs
  5993                                  ;  165  3167 prs
  5994                                  ;  166  3171 prs
  5995                                  ;  167  3188 error1
  5996                                  ;  168  3206 error1
  5997                                  ;  169  3224 error1
  5998                                  ;  170  3243 error1
  5999                                  ;  171  3262 error1
  6000                                  ;  172  3281 error1
  6001                                  ;  173  3300 error1
  6002                                  ;  174  3319 error1
  6003                                  ;  175  3326 end1
  6004                                  ;  176  3340 errorexit
  6005                                  ;  177  3361 errorexit
  6006                                  ;  178  3390 cputs
  6007                                  ;  179  3396 cputs
  6008                                  ;  180  3402 exitR
  6009                                  ;  181  3408 toupper
  6010                                  ;  182  3416 strcpy
  6011                                  ;  183  3423 strcat1
  6012                                  ;  184  3431 strcpy
  6013                                  ;  185  3438 strcat1
  6014                                  ;  186  3446 strcpy
  6015                                  ;  187  3453 strcat1
  6016                                  ;  188  3461 openR
  6017                                  ;  189  3467 cputs
  6018                                  ;  190  3473 cputs
  6019                                  ;  191  3479 exitR
  6020                                  ;  192  3485 creatR
  6021                                  ;  193  3492 cputs
  6022                                  ;  194  3498 cputs
  6023                                  ;  195  3504 exitR
  6024                                  ;  196  3510 creatR
  6025                                  ;  197  3517 cputs
  6026                                  ;  198  3523 cputs
  6027                                  ;  199  3529 exitR
  6028                                  ;  200  3535 prs
  6029                                  ;  201  3539 prs
  6030                                  ;  202  3543 prs
  6031                                  ;  203  3547 prs
  6032                                  ;  204  3551 prs
  6033                                  ;  205  3555 prs
  6034                                  ;  206  3559 prs
  6035                                  ;  207  3563 prs
  6036                                  ;  208  3567 prs
  6037                                  ;  209  3584 prs
  6038                                  ;  210  3588 printIntU
  6039                                  ;  211  3598 prs
  6040                                  ;  212  3602 prs
  6041                                  ;  213  3606 prs
  6042                                  ;  214  3610 prc
  6043                                  ;  215  3614 printhex16
  6044                                  ;  216  3625 prs
  6045                                  ;  217  3629 strlen
  6046                                  ;  218  3636 prs
  6047                                  ;  219  3640 printIntU
  6048                                  ;  220  3650 prs
  6049                                  ;  221  3654 prc
  6050                                  ;  222  3658 printhex8a
  6051                                  ;  223  3669 fputcR
  6052                                  ;  224  3683 fcloseR
  6053                                  ;  225  3691 fcloseR
  6054                                  ;  226  3699 fcloseR
  6055                                  ;  227  3707 exitR
  6056                                  ;  228  3732 putch
  6057                                  ;  229  3800 strcpy
  6058                                  ;  230  3815 DosInt
  6059                                  ;  231  3831 DosInt
  6060                                  ;  232  3854 DosInt
  6061                                  ;  233  3873 DosInt
  6062                                  ;  234  3907 writetty
  6063                                  ;  235  3916 writetty
  6064                                  ;Input: AS.C, List: AS.S,  Lines:  238
  6065                                  ;Glob. variables:  191 max.:  200
  6066                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6067                                  ;Functions      :   74 max.:  300
  6068                                  ;Calls          :  236 max.: 2000, NameField: 3948 max.:    65535
  6069                                  ;Code until     :26009 max.: 30000, free: 3991
  6070                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6071                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
