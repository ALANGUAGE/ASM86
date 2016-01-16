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
    11 00000003 E8CC1A                   call getarg
    12 00000006 E81F0B                   call parse
    13 00000009 E81E1D                   call epilog
    14 0000000C E88B1E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 15.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 15.1.2016",0
    21 00000019 372031352E312E3230-
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
   182                                  ;-39 
   183                                  
   184                                  
   185                                  ;-40 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   186                                  
   187 0000003F 00                      RegType db 0
   188                                  
   189                                  ;-41 char RegNo;             //0 - 7 AL, CL, ...  by testReg()
   190                                  
   191 00000040 00                      RegNo db 0
   192                                  
   193                                  ;-42 char OpSize;            //0, BYTE, WORD, DWORD
   194                                  
   195 00000041 00                      OpSize db 0
   196                                  
   197                                  ;-43 //char AddrSize;          //67h:
   198                                  
   199                                  
   200                                  ;-44 char NumOprns;          //0-2
   201                                  
   202 00000042 00                      NumOprns db 0
   203                                  
   204                                  ;-45 char wflag;             //0=byte, 1=word/dword
   205                                  
   206 00000043 00                      wflag db 0
   207                                  
   208                                  ;-46 char dflag;             //0=source is reg,  1=dest is reg
   209                                  
   210 00000044 00                      dflag db 0
   211                                  
   212                                  ;-47 //char modrm;           //mod, r/m
   213                                  
   214                                  
   215                                  ;-48 char regindexbase;      //combination of index and base reg
   216                                  
   217 00000045 00                      regindexbase db 0
   218                                  
   219                                  ;-49 int disp;               //displacement      0-8 bytes
   220                                  
   221 00000046 0000                    disp dw 0
   222                                  
   223                                  ;-50 int imme;               //immediate         0-8 bytes
   224                                  
   225 00000048 0000                    imme dw 0
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
   242 0000004A 0000                    OpPrintIndex dw 0
   243                                  
   244                                  ;-55 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   245                                  
   246 0000004C 0000                    OpCodePtr dw 0
   247                                  
   248                                  ;-56 char PrReloc;           //print 'R' if relocative
   249                                  
   250 0000004E 00                      PrReloc db 0
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
   267 0000004F 0000                    LabelNamePtr dw 0
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
   281 00000051 0000                    LabelMaxIx dw 0
   282                                  
   283                                  ;-64 int LabelIx;            //actual number of just searched label
   284                                  
   285 00000053 0000                    LabelIx dw 0
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
   302 00000055 0000                    BinLen dw 0
   303                                  
   304                                  ;-69 
   305                                  
   306                                  
   307                                  ;-70 char *arglen=0x80;      // for main only
   308                                  
   309 00000057 8000                    arglen dw 128
   310                                  
   311                                  ;-71 char *argv=0x82;        // for main only
   312                                  
   313 00000059 8200                    argv dw 130
   314                                  ;Back to main program: AS.C
   315                                  
   316                                  ;-4 #include "OPTABL.C"
   317                                  
   318                                  ;Use include file: OPTABL.C
   319                                  
   320                                  ;-1 char I_START=0xF1;
   321                                  
   322 0000005B F1                      I_START db 241
   323                                  
   324                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   325                                  
   326                                  
   327                                  ;-3 //  1:   1 byte opcode
   328                                  
   329                                  
   330                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   331                                  
   332 0000005C 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   333                                  
   334                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   335                                  
   336 00000065 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   337                                  
   338                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   339                                  
   340 0000006D 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   341                                  
   342                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   343                                  
   344 00000074 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   345                                  
   346                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   347                                  
   348 0000007B 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   349                                  
   350                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   351                                  
   352 00000083 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   353                                  
   354                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   355                                  
   356 0000008A 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   357                                  
   358                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   359                                  
   360 00000091 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   361                                  
   362                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   363                                  
   364 00000099 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   365                                  
   366                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   367                                  
   368 000000A2 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   369                                  
   370                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   371                                  
   372 000000AA 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   373                                  
   374                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   375                                  
   376 000000B2 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   377                                  
   378                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   379                                  
   380 000000BA 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   381                                  
   382                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   383                                  
   384 000000C3 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   385                                  
   386                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   387                                  
   388 000000CC 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   389                                  
   390                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   391                                  
   392 000000D5 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   393                                  
   394                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   395                                  
   396 000000DE 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   397                                  
   398                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   399                                  
   400 000000E7 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   401                                  
   402                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   403                                  
   404 000000F0 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   405                                  
   406                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   407                                  
   408 000000F9 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   409                                  
   410                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   411                                  
   412 00000102 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   413                                  
   414                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   415                                  
   416 0000010B 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   417                                  
   418                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   419                                  
   420 00000114 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   421                                  
   422                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   423                                  
   424 0000011D 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   425                                  
   426                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   427                                  
   428 00000125 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   429                                  
   430                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   431                                  
   432 0000012D 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   433                                  
   434                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   435                                  
   436 00000135 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   437                                  
   438                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   439                                  
   440 0000013E 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   441                                  
   442                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   443                                  
   444 00000147 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   445                                  
   446                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   447                                  
   448 0000014F 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   449                                  
   450                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   451                                  
   452 00000157 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   453                                  
   454                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   455                                  
   456 0000015E 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   457                                  
   458                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   459                                  
   460 00000165 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   461                                  
   462                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   463                                  
   464 0000016C 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   465                                  
   466                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   467                                  
   468 00000173 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   469                                  
   470                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   471                                  
   472 0000017A 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   473                                  
   474                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   475                                  
   476 00000181 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   477                                  
   478                                  ;-41 //  2: inc,dec
   479                                  
   480                                  
   481                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   482                                  
   483 00000188 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   484                                  
   485                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   486                                  
   487 00000191 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   488                                  
   489                                  ;-44 // 52: mem reg 16 bit
   490                                  
   491                                  
   492                                  ;-45 char I_NOT[]=  {'N','O','T',0,         52,0xF6, 2,0xF1};
   493                                  
   494 0000019A 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
   495                                  
   496                                  ;-46 char I_NEG[]=  {'N','E','G',0,         52,0xF6, 3,0xF1};
   497                                  
   498 000001A2 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
   499                                  
   500                                  ;-47 char I_MUL[]=  {'M','U','L',0,         52,0xF6, 4,0xF1};
   501                                  
   502 000001AA 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
   503                                  
   504                                  ;-48 char I_IMUL[]= {'I','M','U','L',0,     52,0xF6, 5,0xF1};//only acc
   505                                  
   506 000001B2 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
   507                                  
   508                                  ;-49 char I_DIV[]=  {'D','I','V',0,         52,0xF6, 6,0xF1};
   509                                  
   510 000001BB 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
   511                                  
   512                                  ;-50 char I_IDIV[]= {'I','D','I','V',0,     52,0xF6, 7,0xF1};
   513                                  
   514 000001C3 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
   515                                  
   516                                  ;-51 //  3: les, lda, lea
   517                                  
   518                                  
   519                                  ;-52 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16
   520                                  
   521 000001CC 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   522                                  
   523                                  ;-53 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16
   524                                  
   525 000001D3 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   526                                  
   527                                  ;-54 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16
   528                                  
   529 000001DA 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   530                                  
   531                                  ;-55 //  4: acc,imm  reg,imm  index,reg
   532                                  
   533                                  
   534                                  ;-56 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   535                                  
   536 000001E1 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   537                                  
   538                                  ;-57 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   539                                  
   540 000001E8 4F52000401F1            I_OR db 79,82,0,4,1,241
   541                                  
   542                                  ;-58 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   543                                  
   544 000001EE 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   545                                  
   546                                  ;-59 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   547                                  
   548 000001F5 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   549                                  
   550                                  ;-60 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   551                                  
   552 000001FC 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   553                                  
   554                                  ;-61 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   555                                  
   556 00000203 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   557                                  
   558                                  ;-62 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   559                                  
   560 0000020A 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   561                                  
   562                                  ;-63 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   563                                  
   564 00000211 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   565                                  
   566                                  ;-64 //  5: mov
   567                                  
   568                                  
   569                                  ;-65 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   570                                  
   571 00000218 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   572                                  
   573                                  ;-66 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   574                                  
   575 0000021E 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   576                                  
   577                                  ;-67 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   578                                  
   579 00000227 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   580                                  
   581                                  ;-68 //  6: single byte relative jump
   582                                  
   583                                  
   584                                  ;-69 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   585                                  
   586 00000230 4A4F000600F1            I_JO db 74,79,0,6,0,241
   587                                  
   588                                  ;-70 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   589                                  
   590 00000236 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   591                                  
   592                                  ;-71 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   593                                  
   594 0000023D 4A42000602F1            I_JB db 74,66,0,6,2,241
   595                                  
   596                                  ;-72 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   597                                  
   598 00000243 4A43000602F1            I_JC db 74,67,0,6,2,241
   599                                  
   600                                  ;-73 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   601                                  
   602 00000249 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   603                                  
   604                                  ;-74 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   605                                  
   606 00000250 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   607                                  
   608                                  ;-75 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   609                                  
   610 00000257 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   611                                  
   612                                  ;-76 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   613                                  
   614 0000025E 4A45000604F1            I_JE db 74,69,0,6,4,241
   615                                  
   616                                  ;-77 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   617                                  
   618 00000264 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   619                                  
   620                                  ;-78 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   621                                  
   622 0000026A 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   623                                  
   624                                  ;-79 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   625                                  
   626 00000271 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   627                                  
   628                                  ;-80 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   629                                  
   630 00000278 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   631                                  
   632                                  ;-81 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   633                                  
   634 0000027F 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   635                                  
   636                                  ;-82 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   637                                  
   638 00000286 4A41000607F1            I_JA db 74,65,0,6,7,241
   639                                  
   640                                  ;-83 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   641                                  
   642 0000028C 4A53000608F1            I_JS db 74,83,0,6,8,241
   643                                  
   644                                  ;-84 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   645                                  
   646 00000292 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   647                                  
   648                                  ;-85 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   649                                  
   650 00000299 4A5000060AF1            I_JP db 74,80,0,6,10,241
   651                                  
   652                                  ;-86 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   653                                  
   654 0000029F 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   655                                  
   656                                  ;-87 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   657                                  
   658 000002A6 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   659                                  
   660                                  ;-88 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   661                                  
   662 000002AD 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   663                                  
   664                                  ;-89 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   665                                  
   666 000002B4 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   667                                  
   668                                  ;-90 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   669                                  
   670 000002BA 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   671                                  
   672                                  ;-91 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   673                                  
   674 000002C1 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   675                                  
   676                                  ;-92 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   677                                  
   678 000002C8 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   679                                  
   680                                  ;-93 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   681                                  
   682 000002CF 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   683                                  
   684                                  ;-94 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   685                                  
   686 000002D6 4A4700060FF1            I_JG db 74,71,0,6,15,241
   687                                  
   688                                  ;-95 //  7: jmp, call
   689                                  
   690                                  
   691                                  ;-96 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   692                                  
   693 000002DC 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   694                                  
   695                                  ;-97 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   696                                  
   697 000002E4 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   698                                  
   699                                  ;-98 //  8: ret
   700                                  
   701                                  
   702                                  ;-99 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   703                                  
   704 000002ED 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   705                                  
   706                                  ;-100 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   707                                  
   708 000002F5 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   709                                  
   710                                  ;-101 //  9: seg, r/m
   711                                  
   712                                  
   713                                  ;-102 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   714                                  
   715 000002FE 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   716                                  
   717                                  ;-103 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   718                                  
   719 00000306 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   720                                  
   721                                  ;-104 //  11: shift, rotates
   722                                  
   723                                  
   724                                  ;-105 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   725                                  
   726 0000030D 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   727                                  
   728                                  ;-106 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   729                                  
   730 00000314 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   731                                  
   732                                  ;-107 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   733                                  
   734 0000031B 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   735                                  
   736                                  ;-108 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   737                                  
   738 00000322 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   739                                  
   740                                  ;-109 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   741                                  
   742 00000329 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   743                                  
   744                                  ;-110 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   745                                  
   746 00000330 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   747                                  
   748                                  ;-111 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   749                                  
   750 00000337 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   751                                  
   752                                  ;-112 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   753                                  
   754 0000033E 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   755                                  
   756                                  ;-113 //  12: int
   757                                  
   758                                  
   759                                  ;-114 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   760                                  
   761 00000345 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   762                                  
   763                                  ;-115 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   764                                  
   765 0000034D 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   766                                  
   767                                  ;-116 //  14: in/out
   768                                  
   769                                  
   770                                  ;-117 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   771                                  
   772 00000355 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   773                                  
   774                                  ;-118 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   775                                  
   776 0000035C 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   777                                  
   778                                  ;-119 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   779                                  
   780 00000364 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   781                                  
   782                                  ;-120 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   783                                  
   784 0000036C 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   785                                  
   786                                  ;-121 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   787                                  
   788 00000374 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   789                                  
   790                                  ;-122 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   791                                  
   792 0000037C 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   793                                  
   794                                  ;-123 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   795                                  
   796 00000384 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   797                                  
   798                                  ;-124 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   799                                  
   800 0000038C 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   801                                  
   802                                  ;-125 //  15: xchg
   803                                  
   804                                  
   805                                  ;-126 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   806                                  
   807 00000394 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   808                                  
   809                                  ;-127 //  16: loop, jcxz
   810                                  
   811                                  
   812                                  ;-128 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   813                                  
   814 0000039D 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   815 000003A6 F1                 
   816                                  
   817                                  ;-129 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   818                                  
   819 000003A7 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   820 000003B0 F1                 
   821                                  
   822                                  ;-130 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   823                                  
   824 000003B1 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   825                                  
   826                                  ;-131 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   827                                  
   828 000003BA 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   829                                  
   830                                  ;-132 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   831                                  
   832 000003C3 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   833                                  
   834                                  ;-133 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   835                                  
   836 000003CB 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   837                                  
   838                                  ;-134 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   839                                  
   840 000003D3 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   841                                  
   842                                  ;-135 //  30: enter
   843                                  
   844                                  
   845                                  ;-136 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   846                                  
   847 000003DC 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   848                                  
   849                                  ;-137 // 100: directives
   850                                  
   851                                  
   852                                  ;-138 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   853                                  
   854 000003E5 4F52470065F1            I_ORG db 79,82,71,0,101,241
   855                                  
   856                                  ;-139 char I_DB[]=   {'D','B',0,            200,        0xF1};
   857                                  
   858 000003EB 444200C8F1              I_DB db 68,66,0,200,241
   859                                  
   860                                  ;-140 char I_DW[]=   {'D','W',0,            201,        0xF1};
   861                                  
   862 000003F0 445700C9F1              I_DW db 68,87,0,201,241
   863                                  
   864                                  ;-141 char I_DD[]=   {'D','D',0,            202,        0xF1};
   865                                  
   866 000003F5 444400CAF1              I_DD db 68,68,0,202,241
   867                                  
   868                                  ;-142 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   869                                  
   870 000003FA 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   871                                  
   872                                  ;-143 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   873                                  
   874 00000401 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   875                                  
   876                                  ;-144 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   877                                  
   878 00000408 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   879                                  
   880                                  ;-145 char I_END=0;// end of table char
   881                                  
   882 0000040F 00                      I_END db 0
   883                                  ;Back to main program: AS.C
   884                                  
   885                                  ;-5 
   886                                  
   887                                  
   888                                  ;-6 int process() { int i; char c;
   889                                  
   890                                  
   891                                  process:  ; *** PROC ***
   892                                  
   893                                  ;-7   getTokeType();
   894                                  
   895                                  ;Function : process, Number of local variables: 2
   896                                  ;   # type sign width line used address name   list of local variables
   897                                  ;  200 var sign word     6 NULL bp-2    i
   898                                  ;  201 var sign byte     6 NULL bp-4    c;
   899 00000410 C8040000                 ENTER  4,0
   900 00000414 E8FB07                   call getTokeType
   901                                  
   902                                  ;-8   OpSize=getCodeSize();////
   903                                  
   904 00000417 E8F20A                   call getCodeSize
   905 0000041A A2[4100]                 mov byte [OpSize], al
   906                                  
   907                                  ;-9 
   908                                  
   909                                  
   910                                  ;-10   if (CodeType ==  1) {//1 byte opcode
   911                                  
   912 0000041D A0[3E00]                 mov al, [CodeType]
   913 00000420 3C01                     cmp al, 1
   914 00000422 0F850D00                 jne @@process1
   915                                  
   916                                  ;-11     genInstruction(0, 1);
   917                                  
   918 00000426 6A01                     push 1
   919 00000428 6A00                     push 0
   920 0000042A E8B505                   call genInstruction
   921 0000042D 83C404                   add  sp, 4
   922                                  
   923                                  ;-12     return;
   924                                  
   925 00000430 E9EA00                   jmp @@retn
   926                                  
   927                                  ;-13   }
   928                                  
   929                                  
   930                                  ;-14   if (CodeType ==  2) {//inc, dec
   931                                  
   932                                  @@process1:
   933 00000433 A0[3E00]                 mov al, [CodeType]
   934 00000436 3C02                     cmp al, 2
   935 00000438 0F855900                 jne @@process2
   936                                  
   937                                  ;-15     checkLeftOp(1);
   938                                  
   939 0000043C 6A01                     push 1
   940 0000043E E86301                   call checkLeftOp
   941 00000441 83C402                   add  sp, 2
   942                                  
   943                                  ;-16     	if (Op1 == REG) {
   944                                  
   945 00000444 A0[3D00]                 mov al, [Op1]
   946 00000447 3C02                     cmp al, 2
   947 00000449 0F853400                 jne @@process3
   948                                  
   949                                  ;-17         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short
   950                                  
   951 0000044D A0[3F00]                 mov al, [RegType]
   952 00000450 3C02                     cmp al, 2
   953 00000452 0F851100                 jne @@process4
   954 00000456 6A03                     push 3
   955 00000458 A0[4000]                 mov al, byte [RegNo]
   956 0000045B B400                     mov ah, 0
   957 0000045D 50                       push ax
   958 0000045E E88105                   call genInstruction
   959 00000461 83C404                   add  sp, 4
   960 00000464 E9B600                   jmp @@retn
   961                                  
   962                                  ;-18         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; }
   963                                  
   964                                  @@process4:
   965 00000467 A0[3F00]                 mov al, [RegType]
   966 0000046A 3C03                     cmp al, 3
   967 0000046C 0F851100                 jne @@process5
   968 00000470 6A03                     push 3
   969 00000472 A0[4000]                 mov al, byte [RegNo]
   970 00000475 B400                     mov ah, 0
   971 00000477 50                       push ax
   972 00000478 E86705                   call genInstruction
   973 0000047B 83C404                   add  sp, 4
   974 0000047E E99C00                   jmp @@retn
   975                                  
   976                                  ;-19       }
   977                                  
   978                                  @@process5:
   979                                  
   980                                  ;-20       genInstruction(wflag, 1);
   981                                  
   982                                  @@process3:
   983 00000481 6A01                     push 1
   984 00000483 A0[4300]                 mov al, byte [wflag]
   985 00000486 B400                     mov ah, 0
   986 00000488 50                       push ax
   987 00000489 E85605                   call genInstruction
   988 0000048C 83C404                   add  sp, 4
   989                                  
   990                                  ;-21       genCodeInREG();
   991                                  
   992 0000048F E88205                   call genCodeInREG
   993                                  
   994                                  ;-22       return;
   995                                  
   996 00000492 E98800                   jmp @@retn
   997                                  
   998                                  ;-23   }
   999                                  
  1000                                  
  1001                                  ;-24 
  1002                                  
  1003                                  
  1004                                  ;-25   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
  1005                                  
  1006                                  @@process2:
  1007 00000495 A0[3E00]                 mov al, [CodeType]
  1008 00000498 3C34                     cmp al, 52
  1009 0000049A 0F851C00                 jne @@process6
  1010                                  
  1011                                  ;-26     checkLeftOp(2);
  1012                                  
  1013 0000049E 6A02                     push 2
  1014 000004A0 E80101                   call checkLeftOp
  1015 000004A3 83C402                   add  sp, 2
  1016                                  
  1017                                  ;-27     genInstruction(wflag, 1);
  1018                                  
  1019 000004A6 6A01                     push 1
  1020 000004A8 A0[4300]                 mov al, byte [wflag]
  1021 000004AB B400                     mov ah, 0
  1022 000004AD 50                       push ax
  1023 000004AE E83105                   call genInstruction
  1024 000004B1 83C404                   add  sp, 4
  1025                                  
  1026                                  ;-28     genCodeInREG();
  1027                                  
  1028 000004B4 E85D05                   call genCodeInREG
  1029                                  
  1030                                  ;-29     return;
  1031                                  
  1032 000004B7 E96300                   jmp @@retn
  1033                                  
  1034                                  ;-30   }
  1035                                  
  1036                                  
  1037                                  ;-31 
  1038                                  
  1039                                  
  1040                                  ;-32   if (CodeType==  8) {// ret
  1041                                  
  1042                                  @@process6:
  1043 000004BA A0[3E00]                 mov al, [CodeType]
  1044 000004BD 3C08                     cmp al, 8
  1045 000004BF 0F852D00                 jne @@process7
  1046                                  
  1047                                  ;-33     if (TokeType == DIGIT) {
  1048                                  
  1049 000004C3 A0[3C00]                 mov al, [TokeType]
  1050 000004C6 3C01                     cmp al, 1
  1051 000004C8 0F851700                 jne @@process8
  1052                                  
  1053                                  ;-34       genInstruction(0, 2);
  1054                                  
  1055 000004CC 6A02                     push 2
  1056 000004CE 6A00                     push 0
  1057 000004D0 E80F05                   call genInstruction
  1058 000004D3 83C404                   add  sp, 4
  1059                                  
  1060                                  ;-35       genCode16(SymbolInt);
  1061                                  
  1062 000004D6 FF36[2600]               push word [SymbolInt]
  1063 000004DA E8E404                   call genCode16
  1064 000004DD 83C402                   add  sp, 2
  1065                                  
  1066                                  ;-36       return;
  1067                                  
  1068 000004E0 E93A00                   jmp @@retn
  1069                                  
  1070                                  ;-37     }
  1071                                  
  1072                                  
  1073                                  ;-38     genInstruction(0, 1); return;
  1074                                  
  1075                                  @@process8:
  1076 000004E3 6A01                     push 1
  1077 000004E5 6A00                     push 0
  1078 000004E7 E8F804                   call genInstruction
  1079 000004EA 83C404                   add  sp, 4
  1080 000004ED E92D00                   jmp @@retn
  1081                                  
  1082                                  ;-39   }
  1083                                  
  1084                                  
  1085                                  ;-40 
  1086                                  
  1087                                  
  1088                                  ;-41   if (CodeType==101) {// ORG nn
  1089                                  
  1090                                  @@process7:
  1091 000004F0 A0[3E00]                 mov al, [CodeType]
  1092 000004F3 3C65                     cmp al, 101
  1093 000004F5 0F851B00                 jne @@process9
  1094                                  
  1095                                  ;-42     if (TokeType != DIGIT) error1("only digit allowed");
  1096                                  
  1097 000004F9 A0[3C00]                 mov al, [TokeType]
  1098 000004FC 3C01                     cmp al, 1
  1099 000004FE 0F840900                 je  @@process10
  1100 00000502 68[1F05]                 push process_0
  1101 00000505 E84814                   call error1
  1102 00000508 83C402                   add  sp, 2
  1103                                  
  1104                                  ;-43     PC=SymbolInt;return;
  1105                                  
  1106                                  @@process10:
  1107 0000050B A1[2600]                 mov ax, [SymbolInt]
  1108 0000050E A3[3700]                 mov word [PC], ax
  1109 00000511 E90900                   jmp @@retn
  1110                                  
  1111                                  ;-44   }
  1112                                  
  1113                                  
  1114                                  ;-45   error1("unknown CodeType");
  1115                                  
  1116                                  @@process9:
  1117 00000514 68[3205]                 push process_1
  1118 00000517 E83614                   call error1
  1119 0000051A 83C402                   add  sp, 2
  1120                                  
  1121                                  ;-46 }
  1122                                  
  1123                                  
  1124                                  ;-47 
  1125                                  
  1126                                  
  1127                                  ;-48 int setwflag() {//only Op1 (first operand)
  1128                                  
  1129 0000051D C9                      @@retn: LEAVE
  1130 0000051E C3                       ret
  1131                                  ; ENDP
  1132 0000051F 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1133 00000528 7420616C6C6F776564-
  1134 00000531 00                 
  1135 00000532 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1136 0000053B 6F64655479706500   
  1137                                  
  1138                                  setwflag:  ; *** PROC ***
  1139                                  
  1140                                  ;-49   wflag=0;
  1141                                  
  1142 00000543 66B800000000             mov eax, 0
  1143 00000549 A2[4300]                 mov byte [wflag], al
  1144                                  
  1145                                  ;-50   if (OpSize == 0) {//do not override OpSize
  1146                                  
  1147 0000054C A0[4100]                 mov al, [OpSize]
  1148 0000054F 3C00                     cmp al, 0
  1149 00000551 0F852100                 jne @@setwflag11
  1150                                  
  1151                                  ;-51     if (Op1 == REG) {
  1152                                  
  1153 00000555 A0[3D00]                 mov al, [Op1]
  1154 00000558 3C02                     cmp al, 2
  1155 0000055A 0F851800                 jne @@setwflag12
  1156                                  
  1157                                  ;-52       OpSize=RegType;
  1158                                  
  1159 0000055E A0[3F00]                 mov al, [RegType]
  1160 00000561 A2[4100]                 mov byte [OpSize], al
  1161                                  
  1162                                  ;-53       if (RegType == SEGREG) OpSize=WORD;
  1163                                  
  1164 00000564 A0[3F00]                 mov al, [RegType]
  1165 00000567 3C04                     cmp al, 4
  1166 00000569 0F850900                 jne @@setwflag13
  1167 0000056D 66B802000000             mov eax, 2
  1168 00000573 A2[4100]                 mov byte [OpSize], al
  1169                                  
  1170                                  ;-54     }
  1171                                  
  1172                                  @@setwflag13:
  1173                                  
  1174                                  ;-55   }
  1175                                  
  1176                                  @@setwflag12:
  1177                                  
  1178                                  ;-56   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1179                                  
  1180                                  @@setwflag11:
  1181 00000576 A0[4100]                 mov al, [OpSize]
  1182 00000579 3C03                     cmp al, 3
  1183 0000057B 0F850C00                 jne @@setwflag14
  1184 0000057F E80404                   call gen66h
  1185 00000582 66B801000000             mov eax, 1
  1186 00000588 A2[4300]                 mov byte [wflag], al
  1187                                  
  1188                                  ;-57   if (OpSize  ==  WORD) wflag=1;
  1189                                  
  1190                                  @@setwflag14:
  1191 0000058B A0[4100]                 mov al, [OpSize]
  1192 0000058E 3C02                     cmp al, 2
  1193 00000590 0F850900                 jne @@setwflag15
  1194 00000594 66B801000000             mov eax, 1
  1195 0000059A A2[4300]                 mov byte [wflag], al
  1196                                  
  1197                                  ;-58 }
  1198                                  
  1199                                  @@setwflag15:
  1200                                  
  1201                                  ;-59 
  1202                                  
  1203                                  
  1204                                  ;-60 int Check2Op(char left, char rigth) {
  1205                                  
  1206 0000059D C3                       ret
  1207                                  ; ENDP
  1208                                  
  1209                                  Check2Op:  ; *** PROC ***
  1210                                  
  1211                                  ;-61 }
  1212                                  
  1213                                  ;Function : Check2Op, Number of local variables: 2
  1214                                  ;   # type sign width line used address name   list of local variables
  1215                                  ;  200 var sign byte    60 NULL bp+4    left
  1216                                  ;  201 var sign byte    60 NULL bp+6    rigth;
  1217 0000059E C8000000                 ENTER  0,0
  1218                                  
  1219                                  ;-62 int checkLeftOp(char mode) {
  1220 000005A2 C9                       LEAVE
  1221 000005A3 C3                       ret
  1222                                  ; ENDP
  1223                                  
  1224                                  checkLeftOp:  ; *** PROC ***
  1225                                  
  1226                                  ;-63   getOp();
  1227                                  
  1228                                  ;Function : checkLeftOp, Number of local variables: 1
  1229                                  ;   # type sign width line used address name   list of local variables
  1230                                  ;  200 var sign byte    62 NULL bp+4    mode;
  1231 000005A4 C8000000                 ENTER  0,0
  1232 000005A8 E8AF00                   call getOp
  1233                                  
  1234                                  ;-64   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1235                                  
  1236 000005AB A0[3F00]                 mov al, [RegType]
  1237 000005AE 3C04                     cmp al, 4
  1238 000005B0 0F850600                 jne @@checkLeftOp16
  1239 000005B4 E89214                   call segregerror
  1240 000005B7 E95300                   jmp @@retn
  1241                                  
  1242                                  ;-65   setwflag();
  1243                                  
  1244                                  @@checkLeftOp16:
  1245 000005BA E886FF                   call setwflag
  1246                                  
  1247                                  ;-66   if (OpSize == 0) error1("no op size declared");
  1248                                  
  1249 000005BD A0[4100]                 mov al, [OpSize]
  1250 000005C0 3C00                     cmp al, 0
  1251 000005C2 0F850900                 jne @@checkLeftOp17
  1252 000005C6 68[0F06]                 push checkLeftOp_0
  1253 000005C9 E88413                   call error1
  1254 000005CC 83C402                   add  sp, 2
  1255                                  
  1256                                  ;-67   if (OpSize == RegType) return;
  1257                                  
  1258                                  @@checkLeftOp17:
  1259 000005CF A0[4100]                 mov al, [OpSize]
  1260 000005D2 3A06[3F00]               cmp al, [RegType]
  1261 000005D6 0F850300                 jne @@checkLeftOp18
  1262 000005DA E93000                   jmp @@retn
  1263                                  
  1264                                  ;-68   if (OpSize){if (Op1 == MEM) return;
  1265                                  
  1266                                  @@checkLeftOp18:
  1267 000005DD A0[4100]                 mov al, [OpSize]
  1268 000005E0 08C0                     or  al, al
  1269 000005E2 0F841500                 je @@checkLeftOp19
  1270 000005E6 A0[3D00]                 mov al, [Op1]
  1271 000005E9 3C04                     cmp al, 4
  1272 000005EB 0F850300                 jne @@checkLeftOp20
  1273 000005EF E91B00                   jmp @@retn
  1274                                  
  1275                                  ;-69     error1("Conflict OpSize and RegSize"); }
  1276                                  
  1277                                  @@checkLeftOp20:
  1278 000005F2 68[2306]                 push checkLeftOp_1
  1279 000005F5 E85813                   call error1
  1280 000005F8 83C402                   add  sp, 2
  1281                                  
  1282                                  ;-70   if (RegType==0) error1("no register defined");
  1283                                  
  1284                                  @@checkLeftOp19:
  1285 000005FB A0[3F00]                 mov al, [RegType]
  1286 000005FE 3C00                     cmp al, 0
  1287 00000600 0F850900                 jne @@checkLeftOp21
  1288 00000604 68[3F06]                 push checkLeftOp_2
  1289 00000607 E84613                   call error1
  1290 0000060A 83C402                   add  sp, 2
  1291                                  
  1292                                  ;-71 }
  1293                                  
  1294                                  @@checkLeftOp21:
  1295                                  
  1296                                  ;-72 
  1297                                  
  1298                                  
  1299                                  ;-73 int saveLeftOp(){
  1300                                  
  1301 0000060D C9                      @@retn: LEAVE
  1302 0000060E C3                       ret
  1303                                  ; ENDP
  1304 0000060F 6E6F206F702073697A-     checkLeftOp_0 db "no op size declared",0
  1305 00000618 65206465636C617265-
  1306 00000621 6400               
  1307 00000623 436F6E666C69637420-     checkLeftOp_1 db "Conflict OpSize and RegSize",0
  1308 0000062C 4F7053697A6520616E-
  1309 00000635 642052656753697A65-
  1310 0000063E 00                 
  1311 0000063F 6E6F20726567697374-     checkLeftOp_2 db "no register defined",0
  1312 00000648 657220646566696E65-
  1313 00000651 6400               
  1314                                  
  1315                                  saveLeftOp:  ; *** PROC ***
  1316                                  
  1317                                  ;-74 }
  1318                                  
  1319                                  
  1320                                  ;-75 int checkRightOp(char mode){
  1321                                  
  1322 00000653 C3                       ret
  1323                                  ; ENDP
  1324                                  
  1325                                  checkRightOp:  ; *** PROC ***
  1326                                  
  1327                                  ;-76 }
  1328                                  
  1329                                  ;Function : checkRightOp, Number of local variables: 1
  1330                                  ;   # type sign width line used address name   list of local variables
  1331                                  ;  200 var sign byte    75 NULL bp+4    mode;
  1332 00000654 C8000000                 ENTER  0,0
  1333                                  
  1334                                  ;-77 
  1335                                  
  1336                                  
  1337                                  ;-78 /*        Op      = 0, IMM, REG, ADR, MEM
  1338                                  
  1339                                  
  1340                                  ;-79 IMM       imme    = 0, SymbolInt    
  1341                                  
  1342                                  
  1343                                  ;-80 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  1344                                  
  1345                                  
  1346                                  ;-81 REG     R RegNo   = 0 - 7
  1347                                  
  1348                                  
  1349                                  ;-82 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  1350                                  
  1351                                  
  1352                                  ;-83 MEM       regindexbase = 0 - 7
  1353                                  
  1354                                  
  1355                                  ;-84 
  1356                                  
  1357                                  
  1358                                  ;-85           OpSize  = 0, BYTE, WORD, DWORD (set wflag)
  1359                                  
  1360                                  
  1361                                  ;-86 */
  1362                                  
  1363                                  
  1364                                  ;-87 int getOp() {
  1365 00000658 C9                       LEAVE
  1366 00000659 C3                       ret
  1367                                  ; ENDP
  1368                                  
  1369                                  getOp:  ; *** PROC ***
  1370                                  
  1371                                  ;-88 //set: op1=0,IMM,REG,ADR,MEM(disp,reg,RegType) 
  1372                                  
  1373                                  
  1374                                  ;-89 //disp->imm, reg, regt->size
  1375                                  
  1376                                  
  1377                                  ;-90   disp=0; imme=0; regindexbase=0;
  1378                                  
  1379 0000065A 66B800000000             mov eax, 0
  1380 00000660 A3[4600]                 mov word [disp], ax
  1381 00000663 66B800000000             mov eax, 0
  1382 00000669 A3[4800]                 mov word [imme], ax
  1383 0000066C 66B800000000             mov eax, 0
  1384 00000672 A2[4500]                 mov byte [regindexbase], al
  1385                                  
  1386                                  ;-91 
  1387                                  
  1388                                  
  1389                                  ;-92   Op1=getOp1();
  1390                                  
  1391 00000675 E8A800                   call getOp1
  1392 00000678 A2[3D00]                 mov byte [Op1], al
  1393                                  
  1394                                  ;-93   if (isToken('[')) {Op1 = MEM; getMEM();  return;} //4
  1395                                  
  1396 0000067B 6A5B                     push 91
  1397 0000067D E80F09                   call isToken
  1398 00000680 83C402                   add  sp, 2
  1399 00000683 08C0                     or  al, al
  1400 00000685 0F840F00                 je @@getOp22
  1401 00000689 66B804000000             mov eax, 4
  1402 0000068F A2[3D00]                 mov byte [Op1], al
  1403 00000692 E81101                   call getMEM
  1404 00000695 E95200                   jmp @@retn
  1405                                  
  1406                                  ;-94   if (Op1 == 0) error1("Name of operand expected");
  1407                                  
  1408                                  @@getOp22:
  1409 00000698 A0[3D00]                 mov al, [Op1]
  1410 0000069B 3C00                     cmp al, 0
  1411 0000069D 0F850900                 jne @@getOp23
  1412 000006A1 68[EB06]                 push getOp_0
  1413 000006A4 E8A912                   call error1
  1414 000006A7 83C402                   add  sp, 2
  1415                                  
  1416                                  ;-95   if (Op1 == IMM) {imme=SymbolInt;         return;} //1
  1417                                  
  1418                                  @@getOp23:
  1419 000006AA A0[3D00]                 mov al, [Op1]
  1420 000006AD 3C01                     cmp al, 1
  1421 000006AF 0F850900                 jne @@getOp24
  1422 000006B3 A1[2600]                 mov ax, [SymbolInt]
  1423 000006B6 A3[4800]                 mov word [imme], ax
  1424 000006B9 E92E00                   jmp @@retn
  1425                                  
  1426                                  ;-96   if (Op1 == REG)                          return;  //2
  1427                                  
  1428                                  @@getOp24:
  1429 000006BC A0[3D00]                 mov al, [Op1]
  1430 000006BF 3C02                     cmp al, 2
  1431 000006C1 0F850300                 jne @@getOp25
  1432 000006C5 E92200                   jmp @@retn
  1433                                  
  1434                                  ;-97   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;} //3
  1435                                  
  1436                                  @@getOp25:
  1437 000006C8 A0[3D00]                 mov al, [Op1]
  1438 000006CB 3C03                     cmp al, 3
  1439 000006CD 0F851000                 jne @@getOp26
  1440 000006D1 8B1E[5300]               mov bx, [LabelIx]
  1441 000006D5 D1E3                     shl bx, 1
  1442 000006D7 8B87A37A                 mov ax, [LabelAddr + bx]
  1443 000006DB A3[4600]                 mov word [disp], ax
  1444 000006DE E90900                   jmp @@retn
  1445                                  
  1446                                  ;-98   error1("Name of operand expected #1");
  1447                                  
  1448                                  @@getOp26:
  1449 000006E1 68[0407]                 push getOp_1
  1450 000006E4 E86912                   call error1
  1451 000006E7 83C402                   add  sp, 2
  1452                                  
  1453                                  ;-99 }
  1454                                  
  1455                                  
  1456                                  ;-100 
  1457                                  
  1458                                  
  1459                                  ;-101 int getOp1() {//scan for a single operand
  1460                                  
  1461                                  @@retn:
  1462 000006EA C3                       ret
  1463                                  ; ENDP
  1464 000006EB 4E616D65206F66206F-     getOp_0 db "Name of operand expected",0
  1465 000006F4 706572616E64206578-
  1466 000006FD 70656374656400     
  1467 00000704 4E616D65206F66206F-     getOp_1 db "Name of operand expected #1",0
  1468 0000070D 706572616E64206578-
  1469 00000716 706563746564202331-
  1470 0000071F 00                 
  1471                                  
  1472                                  getOp1:  ; *** PROC ***
  1473                                  
  1474                                  ;-102 //return:0, IMM, REG, ADR (not MEM)
  1475                                  
  1476                                  
  1477                                  ;-103 //set   :RegType, RegNo by testReg
  1478                                  
  1479                                  
  1480                                  ;-104 //set   :LabelIx by searchLabel
  1481                                  
  1482                                  
  1483                                  ;-105   if (TokeType == 0)      return 0;
  1484                                  
  1485 00000720 A0[3C00]                 mov al, [TokeType]
  1486 00000723 3C00                     cmp al, 0
  1487 00000725 0F850900                 jne @@getOp127
  1488 00000729 66B800000000             mov eax, 0
  1489 0000072F E96000                   jmp @@retn
  1490                                  
  1491                                  ;-106   if (TokeType == DIGIT)  return IMM; //1
  1492                                  
  1493                                  @@getOp127:
  1494 00000732 A0[3C00]                 mov al, [TokeType]
  1495 00000735 3C01                     cmp al, 1
  1496 00000737 0F850900                 jne @@getOp128
  1497 0000073B 66B801000000             mov eax, 1
  1498 00000741 E94E00                   jmp @@retn
  1499                                  
  1500                                  ;-107   if (TokeType == ALNUME) {
  1501                                  
  1502                                  @@getOp128:
  1503 00000744 A0[3C00]                 mov al, [TokeType]
  1504 00000747 3C03                     cmp al, 3
  1505 00000749 0F853C00                 jne @@getOp129
  1506                                  
  1507                                  ;-108     RegNo=testReg();
  1508                                  
  1509 0000074D E8590B                   call testReg
  1510 00000750 A2[4000]                 mov byte [RegNo], al
  1511                                  
  1512                                  ;-109     if (RegType)          return REG; //2
  1513                                  
  1514 00000753 A0[3F00]                 mov al, [RegType]
  1515 00000756 08C0                     or  al, al
  1516 00000758 0F840900                 je @@getOp130
  1517 0000075C 66B802000000             mov eax, 2
  1518 00000762 E92D00                   jmp @@retn
  1519                                  
  1520                                  ;-110     LabelIx=searchLabel();
  1521                                  
  1522                                  @@getOp130:
  1523 00000765 E89205                   call searchLabel
  1524 00000768 A3[5300]                 mov word [LabelIx], ax
  1525                                  
  1526                                  ;-111     if (LabelIx)          return ADR; //3
  1527                                  
  1528 0000076B A1[5300]                 mov ax, [LabelIx]
  1529 0000076E 08C0                     or  al, al
  1530 00000770 0F840C00                 je @@getOp131
  1531 00000774 66B803000000             mov eax, 3
  1532 0000077A E91500                   jmp @@retn
  1533                                  
  1534                                  ;-112     else error1("variable not found"); }
  1535                                  
  1536 0000077D E90900                   jmp @@getOp132
  1537                                  @@getOp131:
  1538 00000780 68[9307]                 push getOp1_0
  1539 00000783 E8CA11                   call error1
  1540 00000786 83C402                   add  sp, 2
  1541                                  @@getOp132:
  1542                                  
  1543                                  ;-113   return 0;
  1544                                  
  1545                                  @@getOp129:
  1546 00000789 66B800000000             mov eax, 0
  1547 0000078F E90000                   jmp @@retn
  1548                                  
  1549                                  ;-114 }
  1550                                  
  1551                                  
  1552                                  ;-115 
  1553                                  
  1554                                  
  1555                                  ;-116 int getMEM() {//   e.g. [array+bp+si-4]
  1556                                  
  1557                                  @@retn:
  1558 00000792 C3                       ret
  1559                                  ; ENDP
  1560 00000793 7661726961626C6520-     getOp1_0 db "variable not found",0
  1561 0000079C 6E6F7420666F756E64-
  1562 000007A5 00                 
  1563                                  
  1564                                  getMEM:  ; *** PROC ***
  1565                                  
  1566                                  ;-117 //set: disp, regindexbase, RegType
  1567                                  
  1568                                  
  1569                                  ;-118   char op2;
  1570                                  
  1571                                  
  1572                                  ;-119   disp=0; regindexbase=0; RegType=0;
  1573                                  
  1574                                  ;Function : getMEM, Number of local variables: 1
  1575                                  ;   # type sign width line used address name   list of local variables
  1576                                  ;  200 var sign byte   118 NULL bp-2    op2;
  1577 000007A6 C8020000                 ENTER  2,0
  1578 000007AA 66B800000000             mov eax, 0
  1579 000007B0 A3[4600]                 mov word [disp], ax
  1580 000007B3 66B800000000             mov eax, 0
  1581 000007B9 A2[4500]                 mov byte [regindexbase], al
  1582 000007BC 66B800000000             mov eax, 0
  1583 000007C2 A2[3F00]                 mov byte [RegType], al
  1584                                  
  1585                                  ;-120   do {
  1586                                  
  1587                                  @@getMEM33:
  1588                                  
  1589                                  ;-121     getTokeType();
  1590                                  
  1591 000007C5 E84A04                   call getTokeType
  1592                                  
  1593                                  ;-122     op2=getOp1();
  1594                                  
  1595 000007C8 E855FF                   call getOp1
  1596 000007CB 8846FE                   mov byte [bp-2], al
  1597                                  
  1598                                  ;-123     if (op2 ==   0) syntaxerror();
  1599                                  
  1600 000007CE 8A46FE                   mov al, [bp-2]
  1601 000007D1 3C00                     cmp al, 0
  1602 000007D3 0F850300                 jne @@getMEM34
  1603 000007D7 E89612                   call syntaxerror
  1604                                  
  1605                                  ;-124     if (op2 == IMM) disp=disp+SymbolInt;
  1606                                  
  1607                                  @@getMEM34:
  1608 000007DA 8A46FE                   mov al, [bp-2]
  1609 000007DD 3C01                     cmp al, 1
  1610 000007DF 0F850A00                 jne @@getMEM35
  1611 000007E3 A1[4600]                 mov ax, [disp]
  1612 000007E6 0306[2600]               add ax, [SymbolInt]
  1613 000007EA A3[4600]                 mov word [disp], ax
  1614                                  
  1615                                  ;-125     if (op2 == REG) if (regindexbase) regindexbase=getIndReg2();
  1616                                  
  1617                                  @@getMEM35:
  1618 000007ED 8A46FE                   mov al, [bp-2]
  1619 000007F0 3C02                     cmp al, 2
  1620 000007F2 0F851800                 jne @@getMEM36
  1621 000007F6 A0[4500]                 mov al, [regindexbase]
  1622 000007F9 08C0                     or  al, al
  1623 000007FB 0F840900                 je @@getMEM37
  1624 000007FF E8F700                   call getIndReg2
  1625 00000802 A2[4500]                 mov byte [regindexbase], al
  1626                                  
  1627                                  ;-126                     else regindexbase=getIndReg1();
  1628                                  
  1629 00000805 E90600                   jmp @@getMEM38
  1630                                  @@getMEM37:
  1631 00000808 E87900                   call getIndReg1
  1632 0000080B A2[4500]                 mov byte [regindexbase], al
  1633                                  
  1634                                  ;-127     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];//is MEM variable
  1635                                  
  1636                                  @@getMEM38:
  1637                                  @@getMEM36:
  1638 0000080E 8A46FE                   mov al, [bp-2]
  1639 00000811 3C03                     cmp al, 3
  1640 00000813 0F851000                 jne @@getMEM39
  1641 00000817 A1[4600]                 mov ax, [disp]
  1642 0000081A 8B1E[5300]               mov bx, [LabelIx]
  1643 0000081E D1E3                     shl bx, 1
  1644 00000820 0387A37A                 add ax, [LabelAddr + bx]
  1645 00000824 A3[4600]                 mov word [disp], ax
  1646                                  
  1647                                  ;-128     if (isToken('-')) {
  1648                                  
  1649                                  @@getMEM39:
  1650 00000827 6A2D                     push 45
  1651 00000829 E86307                   call isToken
  1652 0000082C 83C402                   add  sp, 2
  1653 0000082F 08C0                     or  al, al
  1654 00000831 0F841900                 je @@getMEM40
  1655                                  
  1656                                  ;-129       getTokeType();
  1657                                  
  1658 00000835 E8DA03                   call getTokeType
  1659                                  
  1660                                  ;-130       if (TokeType != DIGIT) numbererror();
  1661                                  
  1662 00000838 A0[3C00]                 mov al, [TokeType]
  1663 0000083B 3C01                     cmp al, 1
  1664 0000083D 0F840300                 je  @@getMEM41
  1665 00000841 E8C111                   call numbererror
  1666                                  
  1667                                  ;-131       disp = disp - SymbolInt;
  1668                                  
  1669                                  @@getMEM41:
  1670 00000844 A1[4600]                 mov ax, [disp]
  1671 00000847 2B06[2600]               sub ax, [SymbolInt]
  1672 0000084B A3[4600]                 mov word [disp], ax
  1673                                  
  1674                                  ;-132     }
  1675                                  
  1676                                  
  1677                                  ;-133   } while (isToken('+'));
  1678                                  
  1679                                  @@getMEM40:
  1680 0000084E 6A2B                     push 43
  1681 00000850 E83C07                   call isToken
  1682 00000853 83C402                   add  sp, 2
  1683 00000856 08C0                     or  al, al
  1684 00000858 0F840300                 je @@getMEM42
  1685 0000085C E966FF                   jmp @@getMEM33
  1686                                  @@getMEM42:
  1687                                  
  1688                                  ;-134   if (isToken(']') == 0) errorexit("] expected");
  1689                                  
  1690 0000085F 6A5D                     push 93
  1691 00000861 E82B07                   call isToken
  1692 00000864 83C402                   add  sp, 2
  1693 00000867 83F800                   cmp ax, 0
  1694 0000086A 0F850900                 jne @@getMEM43
  1695 0000086E 68[7908]                 push getMEM_0
  1696 00000871 E80D12                   call errorexit
  1697 00000874 83C402                   add  sp, 2
  1698                                  
  1699                                  ;-135 }
  1700                                  
  1701                                  @@getMEM43:
  1702                                  
  1703                                  ;-136 int getIndReg1() {char m; m=0;
  1704 00000877 C9                       LEAVE
  1705 00000878 C3                       ret
  1706                                  ; ENDP
  1707 00000879 5D2065787065637465-     getMEM_0 db "] expected",0
  1708 00000882 6400               
  1709                                  
  1710                                  getIndReg1:  ; *** PROC ***
  1711                                  ;Function : getIndReg1, Number of local variables: 1
  1712                                  ;   # type sign width line used address name   list of local variables
  1713                                  ;  200 var sign byte   136 NULL bp-2    m;
  1714 00000884 C8020000                 ENTER  2,0
  1715 00000888 66B800000000             mov eax, 0
  1716 0000088E 8846FE                   mov byte [bp-2], al
  1717                                  
  1718                                  ;-137   if (RegType !=WORD) indexerror();
  1719                                  
  1720 00000891 A0[3F00]                 mov al, [RegType]
  1721 00000894 3C02                     cmp al, 2
  1722 00000896 0F840300                 je  @@getIndReg144
  1723 0000089A E84711                   call indexerror
  1724                                  
  1725                                  ;-138   if (RegNo==3) m=7;//BX
  1726                                  
  1727                                  @@getIndReg144:
  1728 0000089D A0[4000]                 mov al, [RegNo]
  1729 000008A0 3C03                     cmp al, 3
  1730 000008A2 0F850900                 jne @@getIndReg145
  1731 000008A6 66B807000000             mov eax, 7
  1732 000008AC 8846FE                   mov byte [bp-2], al
  1733                                  
  1734                                  ;-139   if (RegNo==5) m=6;//BP change to BP+0
  1735                                  
  1736                                  @@getIndReg145:
  1737 000008AF A0[4000]                 mov al, [RegNo]
  1738 000008B2 3C05                     cmp al, 5
  1739 000008B4 0F850900                 jne @@getIndReg146
  1740 000008B8 66B806000000             mov eax, 6
  1741 000008BE 8846FE                   mov byte [bp-2], al
  1742                                  
  1743                                  ;-140   if (RegNo==7) m=5;//DI
  1744                                  
  1745                                  @@getIndReg146:
  1746 000008C1 A0[4000]                 mov al, [RegNo]
  1747 000008C4 3C07                     cmp al, 7
  1748 000008C6 0F850900                 jne @@getIndReg147
  1749 000008CA 66B805000000             mov eax, 5
  1750 000008D0 8846FE                   mov byte [bp-2], al
  1751                                  
  1752                                  ;-141   if (RegNo==6) m=4;//SI
  1753                                  
  1754                                  @@getIndReg147:
  1755 000008D3 A0[4000]                 mov al, [RegNo]
  1756 000008D6 3C06                     cmp al, 6
  1757 000008D8 0F850900                 jne @@getIndReg148
  1758 000008DC 66B804000000             mov eax, 4
  1759 000008E2 8846FE                   mov byte [bp-2], al
  1760                                  
  1761                                  ;-142   if (m    ==0) indexerror();
  1762                                  
  1763                                  @@getIndReg148:
  1764 000008E5 8A46FE                   mov al, [bp-2]
  1765 000008E8 3C00                     cmp al, 0
  1766 000008EA 0F850300                 jne @@getIndReg149
  1767 000008EE E8F310                   call indexerror
  1768                                  
  1769                                  ;-143   return m;
  1770                                  
  1771                                  @@getIndReg149:
  1772 000008F1 8A46FE                   mov al, [bp-2]
  1773 000008F4 E90000                   jmp @@retn
  1774                                  
  1775                                  ;-144 }
  1776                                  
  1777                                  
  1778                                  ;-145 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1779                                  
  1780 000008F7 C9                      @@retn: LEAVE
  1781 000008F8 C3                       ret
  1782                                  ; ENDP
  1783                                  
  1784                                  getIndReg2:  ; *** PROC ***
  1785                                  ;Function : getIndReg2, Number of local variables: 1
  1786                                  ;   # type sign width line used address name   list of local variables
  1787                                  ;  200 var sign byte   145 NULL bp-2    m;
  1788 000008F9 C8020000                 ENTER  2,0
  1789 000008FD 66B804000000             mov eax, 4
  1790 00000903 8846FE                   mov byte [bp-2], al
  1791                                  
  1792                                  ;-146   if (RegType !=WORD) indexerror();
  1793                                  
  1794 00000906 A0[3F00]                 mov al, [RegType]
  1795 00000909 3C02                     cmp al, 2
  1796 0000090B 0F840300                 je  @@getIndReg250
  1797 0000090F E8D210                   call indexerror
  1798                                  
  1799                                  ;-147   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  1800                                  
  1801                                  @@getIndReg250:
  1802 00000912 A0[4000]                 mov al, [RegNo]
  1803 00000915 3C07                     cmp al, 7
  1804 00000917 0F852700                 jne @@getIndReg251
  1805 0000091B A0[4500]                 mov al, [regindexbase]
  1806 0000091E 3C06                     cmp al, 6
  1807 00000920 0F850C00                 jne @@getIndReg252
  1808 00000924 66B803000000             mov eax, 3
  1809 0000092A 8846FE                   mov byte [bp-2], al
  1810                                  
  1811                                  ;-148            else if (regindexbase==7) m=1;//BX+DI
  1812                                  
  1813 0000092D E91200                   jmp @@getIndReg253
  1814                                  @@getIndReg252:
  1815 00000930 A0[4500]                 mov al, [regindexbase]
  1816 00000933 3C07                     cmp al, 7
  1817 00000935 0F850900                 jne @@getIndReg254
  1818 00000939 66B801000000             mov eax, 1
  1819 0000093F 8846FE                   mov byte [bp-2], al
  1820                                  
  1821                                  ;-149   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  1822                                  
  1823                                  @@getIndReg254:
  1824                                  @@getIndReg253:
  1825                                  @@getIndReg251:
  1826 00000942 A0[4000]                 mov al, [RegNo]
  1827 00000945 3C06                     cmp al, 6
  1828 00000947 0F852700                 jne @@getIndReg255
  1829 0000094B A0[4500]                 mov al, [regindexbase]
  1830 0000094E 3C06                     cmp al, 6
  1831 00000950 0F850C00                 jne @@getIndReg256
  1832 00000954 66B802000000             mov eax, 2
  1833 0000095A 8846FE                   mov byte [bp-2], al
  1834                                  
  1835                                  ;-150            else if (regindexbase==7) m=0;//BX+DI
  1836                                  
  1837 0000095D E91200                   jmp @@getIndReg257
  1838                                  @@getIndReg256:
  1839 00000960 A0[4500]                 mov al, [regindexbase]
  1840 00000963 3C07                     cmp al, 7
  1841 00000965 0F850900                 jne @@getIndReg258
  1842 00000969 66B800000000             mov eax, 0
  1843 0000096F 8846FE                   mov byte [bp-2], al
  1844                                  
  1845                                  ;-151   if (m > 3) indexerror();
  1846                                  
  1847                                  @@getIndReg258:
  1848                                  @@getIndReg257:
  1849                                  @@getIndReg255:
  1850 00000972 8A46FE                   mov al, [bp-2]
  1851 00000975 3C03                     cmp al, 3
  1852 00000977 0F8E0300                 jle @@getIndReg259
  1853 0000097B E86610                   call indexerror
  1854                                  
  1855                                  ;-152   return m;
  1856                                  
  1857                                  @@getIndReg259:
  1858 0000097E 8A46FE                   mov al, [bp-2]
  1859 00000981 E90000                   jmp @@retn
  1860                                  
  1861                                  ;-153 }
  1862                                  
  1863                                  
  1864                                  ;-154 
  1865                                  
  1866                                  
  1867                                  ;-155 // generate code ...........................................................
  1868                                  
  1869                                  
  1870                                  ;-156 int gen66h() {genCode8(0x66);}
  1871                                  
  1872 00000984 C9                      @@retn: LEAVE
  1873 00000985 C3                       ret
  1874                                  ; ENDP
  1875                                  
  1876                                  gen66h:  ; *** PROC ***
  1877 00000986 6A66                     push 102
  1878 00000988 E80400                   call genCode8
  1879 0000098B 83C402                   add  sp, 2
  1880                                  
  1881                                  ;-157 int genCode8(char c) {
  1882                                  
  1883 0000098E C3                       ret
  1884                                  ; ENDP
  1885                                  
  1886                                  genCode8:  ; *** PROC ***
  1887                                  
  1888                                  ;-158 //set: BinLen++, OpPrintIndex++
  1889                                  
  1890                                  
  1891                                  ;-159   FileBin[BinLen]=c;
  1892                                  
  1893                                  ;Function : genCode8, Number of local variables: 1
  1894                                  ;   # type sign width line used address name   list of local variables
  1895                                  ;  200 var sign byte   157 NULL bp+4    c;
  1896 0000098F C8000000                 ENTER  0,0
  1897 00000993 8A4604                   mov al, [bp+4]
  1898 00000996 8B1E[5500]               mov bx, [BinLen]
  1899 0000099A 88876B7B                 mov [FileBin+bx], al
  1900                                  
  1901                                  ;-160   BinLen++;
  1902                                  
  1903 0000099E FF06[5500]               inc  word [BinLen]
  1904                                  
  1905                                  ;-161   PC++;
  1906                                  
  1907 000009A2 FF06[3700]               inc  word [PC]
  1908                                  
  1909                                  ;-162   if (OpPrintIndex < OPMAXLEN) {
  1910                                  
  1911 000009A6 A1[4A00]                 mov ax, [OpPrintIndex]
  1912 000009A9 83F805                   cmp ax, 5
  1913 000009AC 0F8D0F00                 jge @@genCode860
  1914                                  
  1915                                  ;-163     OpPos[OpPrintIndex]=c;
  1916                                  
  1917 000009B0 8A4604                   mov al, [bp+4]
  1918 000009B3 8B1E[4A00]               mov bx, [OpPrintIndex]
  1919 000009B7 8887B676                 mov [OpPos+bx], al
  1920                                  
  1921                                  ;-164     OpPrintIndex++;
  1922                                  
  1923 000009BB FF06[4A00]               inc  word [OpPrintIndex]
  1924                                  
  1925                                  ;-165   }
  1926                                  
  1927                                  
  1928                                  ;-166 }
  1929                                  
  1930                                  @@genCode860:
  1931                                  
  1932                                  ;-167 int genCode16(int i) {
  1933 000009BF C9                       LEAVE
  1934 000009C0 C3                       ret
  1935                                  ; ENDP
  1936                                  
  1937                                  genCode16:  ; *** PROC ***
  1938                                  
  1939                                  ;-168   genCode8(i); i=i >> 8;
  1940                                  
  1941                                  ;Function : genCode16, Number of local variables: 1
  1942                                  ;   # type sign width line used address name   list of local variables
  1943                                  ;  200 var sign word   167 NULL bp+4    i;
  1944 000009C1 C8000000                 ENTER  0,0
  1945 000009C5 FF7604                   push word [bp+4]
  1946 000009C8 E8C4FF                   call genCode8
  1947 000009CB 83C402                   add  sp, 2
  1948 000009CE 8B4604                   mov ax, [bp+4]
  1949 000009D1 C1E808                   shr ax, 8
  1950 000009D4 894604                   mov word [bp+4], ax
  1951                                  
  1952                                  ;-169   genCode8(i);
  1953                                  
  1954 000009D7 FF7604                   push word [bp+4]
  1955 000009DA E8B2FF                   call genCode8
  1956 000009DD 83C402                   add  sp, 2
  1957                                  
  1958                                  ;-170 }
  1959                                  
  1960                                  
  1961                                  ;-171 int genInstruction(char No, int loc) {
  1962 000009E0 C9                       LEAVE
  1963 000009E1 C3                       ret
  1964                                  ; ENDP
  1965                                  
  1966                                  genInstruction:  ; *** PROC ***
  1967                                  
  1968                                  ;-172   char c;//set: OpCodePtr++
  1969                                  
  1970                                  
  1971                                  ;-173   if(loc) OpCodePtr=OpCodePtr+loc;
  1972                                  
  1973                                  ;Function : genInstruction, Number of local variables: 3
  1974                                  ;   # type sign width line used address name   list of local variables
  1975                                  ;  200 var sign byte   171 NULL bp+4    No
  1976                                  ;  201 var sign word   171 NULL bp+6    loc
  1977                                  ;  202 var sign byte   172 NULL bp-2    c;
  1978 000009E2 C8020000                 ENTER  2,0
  1979 000009E6 8B4606                   mov ax, [bp+6]
  1980 000009E9 08C0                     or  al, al
  1981 000009EB 0F840900                 je @@genInstruction61
  1982 000009EF A1[4C00]                 mov ax, [OpCodePtr]
  1983 000009F2 034606                   add ax, [bp+6]
  1984 000009F5 A3[4C00]                 mov word [OpCodePtr], ax
  1985                                  
  1986                                  ;-174   c= *OpCodePtr + No;
  1987                                  
  1988                                  @@genInstruction61:
  1989 000009F8 8B1E[4C00]               mov bx, [OpCodePtr]
  1990 000009FC 8A07                     mov al, [bx]
  1991 000009FE B400                     mov ah, 0
  1992 00000A00 024604                   add al, [bp+4]
  1993 00000A03 8846FE                   mov byte [bp-2], al
  1994                                  
  1995                                  ;-175   genCode8(c);
  1996                                  
  1997 00000A06 8A46FE                   mov al, byte [bp-2]
  1998 00000A09 B400                     mov ah, 0
  1999 00000A0B 50                       push ax
  2000 00000A0C E880FF                   call genCode8
  2001 00000A0F 83C402                   add  sp, 2
  2002                                  
  2003                                  ;-176 }
  2004                                  
  2005                                  
  2006                                  ;-177 int genCodeInREG() {char x; //get Code for second byte
  2007 00000A12 C9                       LEAVE
  2008 00000A13 C3                       ret
  2009                                  ; ENDP
  2010                                  
  2011                                  genCodeInREG:  ; *** PROC ***
  2012                                  
  2013                                  ;-178   OpCodePtr++;
  2014                                  
  2015                                  ;Function : genCodeInREG, Number of local variables: 1
  2016                                  ;   # type sign width line used address name   list of local variables
  2017                                  ;  200 var sign byte   177 NULL bp-2    x;
  2018 00000A14 C8020000                 ENTER  2,0
  2019 00000A18 FF06[4C00]               inc  word [OpCodePtr]
  2020                                  
  2021                                  ;-179   x= *OpCodePtr;
  2022                                  
  2023 00000A1C 8B1E[4C00]               mov bx, [OpCodePtr]
  2024 00000A20 8A07                     mov al, [bx]
  2025 00000A22 B400                     mov ah, 0
  2026 00000A24 8846FE                   mov byte [bp-2], al
  2027                                  
  2028                                  ;-180   writeEA(x);
  2029                                  
  2030 00000A27 8A46FE                   mov al, byte [bp-2]
  2031 00000A2A B400                     mov ah, 0
  2032 00000A2C 50                       push ax
  2033 00000A2D E81200                   call writeEA
  2034 00000A30 83C402                   add  sp, 2
  2035                                  
  2036                                  ;-181 }
  2037                                  
  2038                                  
  2039                                  ;-182 int genModRegRM(){ writeEA(regindexbase);//todo
  2040 00000A33 C9                       LEAVE
  2041 00000A34 C3                       ret
  2042                                  ; ENDP
  2043                                  
  2044                                  genModRegRM:  ; *** PROC ***
  2045 00000A35 A0[4500]                 mov al, byte [regindexbase]
  2046 00000A38 B400                     mov ah, 0
  2047 00000A3A 50                       push ax
  2048 00000A3B E80400                   call writeEA
  2049 00000A3E 83C402                   add  sp, 2
  2050                                  
  2051                                  ;-183 }
  2052                                  
  2053                                  
  2054                                  ;-184 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  2055                                  
  2056 00000A41 C3                       ret
  2057                                  ; ENDP
  2058                                  
  2059                                  writeEA:  ; *** PROC ***
  2060                                  
  2061                                  ;-185   char len;
  2062                                  
  2063                                  
  2064                                  ;-186   len=0;
  2065                                  
  2066                                  ;Function : writeEA, Number of local variables: 2
  2067                                  ;   # type sign width line used address name   list of local variables
  2068                                  ;  200 var sign byte   184 NULL bp+4    xxx
  2069                                  ;  201 var sign byte   185 NULL bp-2    len;
  2070 00000A42 C8020000                 ENTER  2,0
  2071 00000A46 66B800000000             mov eax, 0
  2072 00000A4C 8846FE                   mov byte [bp-2], al
  2073                                  
  2074                                  ;-187   xxx = xxx << 3;//in regindexbase field of mod r/m
  2075                                  
  2076 00000A4F 8A4604                   mov al, [bp+4]
  2077 00000A52 C0E003                   shl al, 3
  2078 00000A55 884604                   mov byte [bp+4], al
  2079                                  
  2080                                  ;-188   if (Op1 ==   0) addrexit();
  2081                                  
  2082 00000A58 A0[3D00]                 mov al, [Op1]
  2083 00000A5B 3C00                     cmp al, 0
  2084 00000A5D 0F850300                 jne @@writeEA62
  2085 00000A61 E83410                   call addrexit
  2086                                  
  2087                                  ;-189   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} //2
  2088                                  
  2089                                  @@writeEA62:
  2090 00000A64 A0[3D00]                 mov al, [Op1]
  2091 00000A67 3C02                     cmp al, 2
  2092 00000A69 0F850E00                 jne @@writeEA63
  2093 00000A6D 804E04C0                 or  byte [bp+4], 192
  2094 00000A71 8A4604                   mov al, [bp+4]
  2095 00000A74 0206[4000]               add al, [RegNo]
  2096 00000A78 884604                   mov byte [bp+4], al
  2097                                  
  2098                                  ;-190   if (Op1 == ADR) {xxx |= 6; len=2; }               //3
  2099                                  
  2100                                  @@writeEA63:
  2101 00000A7B A0[3D00]                 mov al, [Op1]
  2102 00000A7E 3C03                     cmp al, 3
  2103 00000A80 0F850D00                 jne @@writeEA64
  2104 00000A84 804E0406                 or  byte [bp+4], 6
  2105 00000A88 66B802000000             mov eax, 2
  2106 00000A8E 8846FE                   mov byte [bp-2], al
  2107                                  
  2108                                  ;-191   if (Op1 == MEM) { xxx = xxx + regindexbase;       //4
  2109                                  
  2110                                  @@writeEA64:
  2111 00000A91 A0[3D00]                 mov al, [Op1]
  2112 00000A94 3C04                     cmp al, 4
  2113 00000A96 0F854600                 jne @@writeEA65
  2114 00000A9A 8A4604                   mov al, [bp+4]
  2115 00000A9D 0206[4500]               add al, [regindexbase]
  2116 00000AA1 884604                   mov byte [bp+4], al
  2117                                  
  2118                                  ;-192     if (disp) {
  2119                                  
  2120 00000AA4 A1[4600]                 mov ax, [disp]
  2121 00000AA7 08C0                     or  al, al
  2122 00000AA9 0F843300                 je @@writeEA66
  2123                                  
  2124                                  ;-193       disp;
  2125                                  
  2126 00000AAD A1[4600]                 mov ax, [disp]
  2127                                  
  2128                                  ;-194       if(ax > 127) len=2;
  2129                                  
  2130 00000AB0 83F87F                   cmp  ax, 127
  2131 00000AB3 0F8E0C00                 jle @@writeEA67
  2132 00000AB7 66B802000000             mov eax, 2
  2133 00000ABD 8846FE                   mov byte [bp-2], al
  2134                                  
  2135                                  ;-195       else len=1;
  2136                                  
  2137 00000AC0 E90900                   jmp @@writeEA68
  2138                                  @@writeEA67:
  2139 00000AC3 66B801000000             mov eax, 1
  2140 00000AC9 8846FE                   mov byte [bp-2], al
  2141                                  
  2142                                  ;-196       if (len == 1) xxx |= 0x40;
  2143                                  
  2144                                  @@writeEA68:
  2145 00000ACC 8A46FE                   mov al, [bp-2]
  2146 00000ACF 3C01                     cmp al, 1
  2147 00000AD1 0F850700                 jne @@writeEA69
  2148 00000AD5 804E0440                 or  byte [bp+4], 64
  2149                                  
  2150                                  ;-197       else xxx |= 0x80;
  2151                                  
  2152 00000AD9 E90400                   jmp @@writeEA70
  2153                                  @@writeEA69:
  2154 00000ADC 804E0480                 or  byte [bp+4], 128
  2155                                  
  2156                                  ;-198     }
  2157                                  
  2158                                  @@writeEA70:
  2159                                  
  2160                                  ;-199   }
  2161                                  
  2162                                  @@writeEA66:
  2163                                  
  2164                                  ;-200   genCode8(xxx);// gen second byte
  2165                                  
  2166                                  @@writeEA65:
  2167 00000AE0 8A4604                   mov al, byte [bp+4]
  2168 00000AE3 B400                     mov ah, 0
  2169 00000AE5 50                       push ax
  2170 00000AE6 E8A6FE                   call genCode8
  2171 00000AE9 83C402                   add  sp, 2
  2172                                  
  2173                                  ;-201   if (len == 1) genCode8 (disp);
  2174                                  
  2175 00000AEC 8A46FE                   mov al, [bp-2]
  2176 00000AEF 3C01                     cmp al, 1
  2177 00000AF1 0F850A00                 jne @@writeEA71
  2178 00000AF5 FF36[4600]               push word [disp]
  2179 00000AF9 E893FE                   call genCode8
  2180 00000AFC 83C402                   add  sp, 2
  2181                                  
  2182                                  ;-202   if (len == 2) genCode16(disp);
  2183                                  
  2184                                  @@writeEA71:
  2185 00000AFF 8A46FE                   mov al, [bp-2]
  2186 00000B02 3C02                     cmp al, 2
  2187 00000B04 0F850A00                 jne @@writeEA72
  2188 00000B08 FF36[4600]               push word [disp]
  2189 00000B0C E8B2FE                   call genCode16
  2190 00000B0F 83C402                   add  sp, 2
  2191                                  
  2192                                  ;-203 }
  2193                                  
  2194                                  @@writeEA72:
  2195                                  
  2196                                  ;-204 
  2197                                  
  2198                                  
  2199                                  ;-205 int testx() { __asm {
  2200 00000B12 C9                       LEAVE
  2201 00000B13 C3                       ret
  2202                                  ; ENDP
  2203                                  
  2204                                  testx:  ; *** PROC ***
  2205                                  
  2206                                  
  2207                                  ;-206 inc byte [Version1]   ;FE 06 [1000]
  2208                                  
  2209 00000B14 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  2210                                  
  2211                                  ;-207 add bx, ax    ;01 C3
  2212                                  
  2213 00000B18 01C3                    add bx, ax    ;01 C3
  2214                                  
  2215                                  ;-208 add ax, bx    ;01 D8
  2216                                  
  2217 00000B1A 01D8                    add ax, bx    ;01 D8
  2218                                  
  2219                                  ;-209 add word ax, [bx] ;03 07
  2220                                  
  2221 00000B1C 0307                    add word ax, [bx] ;03 07
  2222                                  
  2223                                  ;-210 VA dw 8
  2224                                  
  2225 00000B1E 0800                    VA dw 8
  2226                                  
  2227                                  ;-211 mov byte [bp- 4], al ;88 46 FC
  2228                                  
  2229 00000B20 8846FC                  mov byte [bp- 4], al ;88 46 FC
  2230                                  
  2231                                  ;-212 mov      [VA+bx], al ;88 87 [300F]
  2232                                  
  2233 00000B23 8887[1E0B]              mov      [VA+bx], al ;88 87 [300F]
  2234                                  
  2235                                  ;-213 }  }
  2236                                  
  2237                                  
  2238                                  
  2239                                  ;-214 //#include "AS1.C"
  2240                                  
  2241                                  
  2242                                  ;-215 #include "PARSE.C"
  2243                                  
  2244 00000B27 C3                       ret
  2245                                  ; ENDP
  2246                                  ;Use include file: PARSE.C
  2247                                  
  2248                                  ;-1 int parse() {
  2249                                  
  2250                                  
  2251                                  parse:  ; *** PROC ***
  2252                                  
  2253                                  ;-2   LabelNamePtr= &LabelNames;
  2254                                  
  2255 00000B28 B8BB76                   mov ax, LabelNames
  2256 00000B2B A3[4F00]                 mov word [LabelNamePtr], ax
  2257                                  
  2258                                  ;-3   do {
  2259                                  
  2260                                  @@parse73:
  2261                                  
  2262                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  2263                                  
  2264 00000B2E A1[3700]                 mov ax, [PC]
  2265 00000B31 A3[3900]                 mov word [PCStart], ax
  2266 00000B34 66B800000000             mov eax, 0
  2267 00000B3A A2[4100]                 mov byte [OpSize], al
  2268 00000B3D 66B800000000             mov eax, 0
  2269 00000B43 A3[4A00]                 mov word [OpPrintIndex], ax
  2270 00000B46 66B820000000             mov eax, 32
  2271 00000B4C A2[4E00]                 mov byte [PrReloc], al
  2272                                  
  2273                                  ;-5     getLine();
  2274                                  
  2275 00000B4F E8A104                   call getLine
  2276                                  
  2277                                  ;-6     InputPtr = &InputBuf;
  2278                                  
  2279 00000B52 B86E75                   mov ax, InputBuf
  2280 00000B55 A3[2800]                 mov word [InputPtr], ax
  2281                                  
  2282                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2283                                  
  2284 00000B58 E8B700                   call getTokeType
  2285                                  
  2286                                  ;-8     if (TokeType == ALNUME) {
  2287                                  
  2288 00000B5B A0[3C00]                 mov al, [TokeType]
  2289 00000B5E 3C03                     cmp al, 3
  2290 00000B60 0F851300                 jne @@parse74
  2291                                  
  2292                                  ;-9       if (isLabel) { //set in getName
  2293                                  
  2294 00000B64 A0[3B00]                 mov al, [isLabel]
  2295 00000B67 08C0                     or  al, al
  2296 00000B69 0F840A00                 je @@parse75
  2297                                  
  2298                                  ;-10         storeLabel();
  2299                                  
  2300 00000B6D E84001                   call storeLabel
  2301                                  
  2302                                  ;-11         InputPtr++;//remove :
  2303                                  
  2304 00000B70 FF06[2800]               inc  word [InputPtr]
  2305                                  
  2306                                  ;-12         getTokeType();
  2307                                  
  2308 00000B74 E89B00                   call getTokeType
  2309                                  
  2310                                  ;-13       }
  2311                                  
  2312                                  
  2313                                  ;-14     }
  2314                                  
  2315                                  @@parse75:
  2316                                  
  2317                                  ;-15     if (TokeType == ALNUME) {
  2318                                  
  2319                                  @@parse74:
  2320 00000B77 A0[3C00]                 mov al, [TokeType]
  2321 00000B7A 3C03                     cmp al, 3
  2322 00000B7C 0F851B00                 jne @@parse76
  2323                                  
  2324                                  ;-16       lookCode();// and OpCodePtr
  2325                                  
  2326 00000B80 E80F03                   call lookCode
  2327                                  
  2328                                  ;-17       if(CodeType) process();
  2329                                  
  2330 00000B83 A0[3E00]                 mov al, [CodeType]
  2331 00000B86 08C0                     or  al, al
  2332 00000B88 0F840600                 je @@parse77
  2333 00000B8C E881F8                   call process
  2334                                  
  2335                                  ;-18       else getVariable();
  2336                                  
  2337 00000B8F E90300                   jmp @@parse78
  2338                                  @@parse77:
  2339 00000B92 E8C501                   call getVariable
  2340                                  
  2341                                  ;-19       skipRest();
  2342                                  
  2343                                  @@parse78:
  2344 00000B95 E82504                   call skipRest
  2345                                  
  2346                                  ;-20     }
  2347                                  
  2348                                  
  2349                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2350                                  
  2351 00000B98 E92700                   jmp @@parse79
  2352                                  @@parse76:
  2353 00000B9B A0[3C00]                 mov al, [TokeType]
  2354 00000B9E 3C03                     cmp al, 3
  2355 00000BA0 0F8E0C00                 jle @@parse80
  2356 00000BA4 68[D30B]                 push parse_0
  2357 00000BA7 E8A60D                   call error1
  2358 00000BAA 83C402                   add  sp, 2
  2359                                  
  2360                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2361                                  
  2362 00000BAD E91200                   jmp @@parse81
  2363                                  @@parse80:
  2364 00000BB0 A0[3C00]                 mov al, [TokeType]
  2365 00000BB3 3C01                     cmp al, 1
  2366 00000BB5 0F850900                 jne @@parse82
  2367 00000BB9 68[F10B]                 push parse_1
  2368 00000BBC E8910D                   call error1
  2369 00000BBF 83C402                   add  sp, 2
  2370                                  
  2371                                  ;-23     printLine();
  2372                                  
  2373                                  @@parse82:
  2374                                  @@parse81:
  2375                                  @@parse79:
  2376 00000BC2 E8200B                   call printLine
  2377                                  
  2378                                  ;-24   } while (DOS_NoBytes != 0 );
  2379                                  
  2380 00000BC5 A1[3400]                 mov ax, [DOS_NoBytes]
  2381 00000BC8 83F800                   cmp ax, 0
  2382 00000BCB 0F840300                 je  @@parse83
  2383 00000BCF E95CFF                   jmp @@parse73
  2384                                  @@parse83:
  2385                                  
  2386                                  ;-25 }
  2387                                  
  2388                                  
  2389                                  ;-26 // scan code .....................................
  2390                                  
  2391                                  
  2392                                  ;-27 int getTokeType() { char c;
  2393                                  
  2394 00000BD2 C3                       ret
  2395                                  ; ENDP
  2396 00000BD3 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2397 00000BDC 696E73747275637469-
  2398 00000BE5 6F6E20657870656374-
  2399 00000BEE 656400             
  2400 00000BF1 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2401 00000BFA 616C6C6F7765642040-
  2402 00000C03 207374617274206F66-
  2403 00000C0C 206C696E6500       
  2404                                  
  2405                                  getTokeType:  ; *** PROC ***
  2406                                  
  2407                                  ;-28   skipBlank();
  2408                                  
  2409                                  ;Function : getTokeType, Number of local variables: 1
  2410                                  ;   # type sign width line used address name   list of local variables
  2411                                  ;  200 var sign byte    27 NULL bp-2    c;
  2412 00000C12 C8020000                 ENTER  2,0
  2413 00000C16 E8A704                   call skipBlank
  2414                                  
  2415                                  ;-29   c = *InputPtr;
  2416                                  
  2417 00000C19 8B1E[2800]               mov bx, [InputPtr]
  2418 00000C1D 8A07                     mov al, [bx]
  2419 00000C1F B400                     mov ah, 0
  2420 00000C21 8846FE                   mov byte [bp-2], al
  2421                                  
  2422                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2423                                  
  2424 00000C24 8A46FE                   mov al, [bp-2]
  2425 00000C27 3C00                     cmp al, 0
  2426 00000C29 0F850C00                 jne @@getTokeType84
  2427 00000C2D 66B800000000             mov eax, 0
  2428 00000C33 A2[3C00]                 mov byte [TokeType], al
  2429 00000C36 E97500                   jmp @@retn
  2430                                  
  2431                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2432                                  
  2433                                  @@getTokeType84:
  2434 00000C39 8A46FE                   mov al, [bp-2]
  2435 00000C3C 3C3B                     cmp al, 59
  2436 00000C3E 0F850C00                 jne @@getTokeType85
  2437 00000C42 66B800000000             mov eax, 0
  2438 00000C48 A2[3C00]                 mov byte [TokeType], al
  2439 00000C4B E96000                   jmp @@retn
  2440                                  
  2441                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2442                                  
  2443                                  @@getTokeType85:
  2444 00000C4E 8A46FE                   mov al, byte [bp-2]
  2445 00000C51 B400                     mov ah, 0
  2446 00000C53 50                       push ax
  2447 00000C54 E84D13                   call digit
  2448 00000C57 83C402                   add  sp, 2
  2449 00000C5A 08C0                     or  al, al
  2450 00000C5C 0F841800                 je @@getTokeType86
  2451 00000C60 8A46FE                   mov al, byte [bp-2]
  2452 00000C63 B400                     mov ah, 0
  2453 00000C65 50                       push ax
  2454 00000C66 E85D05                   call getDigit
  2455 00000C69 83C402                   add  sp, 2
  2456 00000C6C 66B801000000             mov eax, 1
  2457 00000C72 A2[3C00]                 mov byte [TokeType], al
  2458 00000C75 E93600                   jmp @@retn
  2459                                  
  2460                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2461                                  
  2462                                  @@getTokeType86:
  2463 00000C78 8A46FE                   mov al, byte [bp-2]
  2464 00000C7B B400                     mov ah, 0
  2465 00000C7D 50                       push ax
  2466 00000C7E E86A04                   call letterE
  2467 00000C81 83C402                   add  sp, 2
  2468 00000C84 08C0                     or  al, al
  2469 00000C86 0F841800                 je @@getTokeType87
  2470 00000C8A 8A46FE                   mov al, byte [bp-2]
  2471 00000C8D B400                     mov ah, 0
  2472 00000C8F 50                       push ax
  2473 00000C90 E88A05                   call getName
  2474 00000C93 83C402                   add  sp, 2
  2475 00000C96 66B803000000             mov eax, 3
  2476 00000C9C A2[3C00]                 mov byte [TokeType], al
  2477 00000C9F E90C00                   jmp @@retn
  2478                                  
  2479                                  ;-34   TokeType=NOALNUME; return;
  2480                                  
  2481                                  @@getTokeType87:
  2482 00000CA2 66B804000000             mov eax, 4
  2483 00000CA8 A2[3C00]                 mov byte [TokeType], al
  2484 00000CAB E90000                   jmp @@retn
  2485                                  
  2486                                  ;-35 }
  2487                                  
  2488                                  
  2489                                  ;-36 int storeLabel() {
  2490                                  
  2491 00000CAE C9                      @@retn: LEAVE
  2492 00000CAF C3                       ret
  2493                                  ; ENDP
  2494                                  
  2495                                  storeLabel:  ; *** PROC ***
  2496                                  
  2497                                  ;-37   if(searchLabel()) error1("duplicate label");
  2498                                  
  2499 00000CB0 E84700                   call searchLabel
  2500 00000CB3 08C0                     or  al, al
  2501 00000CB5 0F840900                 je @@storeLabel88
  2502 00000CB9 68[EA0C]                 push storeLabel_0
  2503 00000CBC E8910C                   call error1
  2504 00000CBF 83C402                   add  sp, 2
  2505                                  
  2506                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2507                                  
  2508                                  @@storeLabel88:
  2509 00000CC2 8D063075                 lea  ax, [Symbol]
  2510 00000CC6 50                       push ax
  2511 00000CC7 FF36[4F00]               push word [LabelNamePtr]
  2512 00000CCB E89D12                   call strcpy
  2513 00000CCE 83C404                   add  sp, 4
  2514 00000CD1 A3[4F00]                 mov word [LabelNamePtr], ax
  2515                                  
  2516                                  ;-39   LabelNamePtr++;
  2517                                  
  2518 00000CD4 FF06[4F00]               inc  word [LabelNamePtr]
  2519                                  
  2520                                  ;-40   LabelMaxIx++;
  2521                                  
  2522 00000CD8 FF06[5100]               inc  word [LabelMaxIx]
  2523                                  
  2524                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2525                                  
  2526 00000CDC A1[3700]                 mov ax, [PC]
  2527 00000CDF 8B1E[5100]               mov bx, [LabelMaxIx]
  2528 00000CE3 D1E3                     shl bx, 1
  2529 00000CE5 8987A37A                 mov [LabelAddr+bx], ax
  2530                                  
  2531                                  ;-42 }
  2532                                  
  2533                                  
  2534                                  ;-43 int searchLabel() {
  2535                                  
  2536 00000CE9 C3                       ret
  2537                                  ; ENDP
  2538 00000CEA 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2539 00000CF3 206C6162656C00     
  2540                                  
  2541                                  searchLabel:  ; *** PROC ***
  2542                                  
  2543                                  ;-44   int LIx; char *p; int j;
  2544                                  
  2545                                  
  2546                                  ;-45   p = &LabelNames;
  2547                                  
  2548                                  ;Function : searchLabel, Number of local variables: 3
  2549                                  ;   # type sign width line used address name   list of local variables
  2550                                  ;  200 var sign word    44 NULL bp-2    LIx
  2551                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2552                                  ;  202 var sign word    44 NULL bp-6    j;
  2553 00000CFA C8060000                 ENTER  6,0
  2554 00000CFE B8BB76                   mov ax, LabelNames
  2555 00000D01 8946FC                   mov word [bp-4], ax
  2556                                  
  2557                                  ;-46   LIx=1;
  2558                                  
  2559 00000D04 66B801000000             mov eax, 1
  2560 00000D0A 8946FE                   mov word [bp-2], ax
  2561                                  
  2562                                  ;-47   while (LIx <= LabelMaxIx) {
  2563                                  
  2564                                  @@searchLabel89:
  2565 00000D0D 8B46FE                   mov ax, [bp-2]
  2566 00000D10 3B06[5100]               cmp ax, [LabelMaxIx]
  2567 00000D14 0F8F3700                 jg  @@searchLabel90
  2568                                  
  2569                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2570                                  
  2571 00000D18 8D063075                 lea  ax, [Symbol]
  2572 00000D1C 50                       push ax
  2573 00000D1D FF76FC                   push word [bp-4]
  2574 00000D20 E8B412                   call eqstr
  2575 00000D23 83C404                   add  sp, 4
  2576 00000D26 08C0                     or  al, al
  2577 00000D28 0F840600                 je @@searchLabel91
  2578 00000D2C 8B46FE                   mov ax, [bp-2]
  2579 00000D2F E92600                   jmp @@retn
  2580                                  
  2581                                  ;-49     j=strlen(p);
  2582                                  
  2583                                  @@searchLabel91:
  2584 00000D32 FF76FC                   push word [bp-4]
  2585 00000D35 E80812                   call strlen
  2586 00000D38 83C402                   add  sp, 2
  2587 00000D3B 8946FA                   mov word [bp-6], ax
  2588                                  
  2589                                  ;-50     p=p+j; p++; LIx++;
  2590                                  
  2591 00000D3E 8B46FC                   mov ax, [bp-4]
  2592 00000D41 0346FA                   add ax, [bp-6]
  2593 00000D44 8946FC                   mov word [bp-4], ax
  2594 00000D47 FF46FC                   inc  word [bp-4]
  2595 00000D4A FF46FE                   inc  word [bp-2]
  2596                                  
  2597                                  ;-51   }
  2598                                  
  2599                                  
  2600                                  ;-52   return 0;
  2601                                  
  2602 00000D4D EBBE                     jmp @@searchLabel89
  2603                                  @@searchLabel90:
  2604 00000D4F 66B800000000             mov eax, 0
  2605 00000D55 E90000                   jmp @@retn
  2606                                  
  2607                                  ;-53 }
  2608                                  
  2609                                  
  2610                                  ;-54 int getVariable() { char c;
  2611                                  
  2612 00000D58 C9                      @@retn: LEAVE
  2613 00000D59 C3                       ret
  2614                                  ; ENDP
  2615                                  
  2616                                  getVariable:  ; *** PROC ***
  2617                                  
  2618                                  ;-55   storeLabel();
  2619                                  
  2620                                  ;Function : getVariable, Number of local variables: 1
  2621                                  ;   # type sign width line used address name   list of local variables
  2622                                  ;  200 var sign byte    54 NULL bp-2    c;
  2623 00000D5A C8020000                 ENTER  2,0
  2624 00000D5E E84FFF                   call storeLabel
  2625                                  
  2626                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2627                                  
  2628 00000D61 E8AEFE                   call getTokeType
  2629 00000D64 A0[3C00]                 mov al, [TokeType]
  2630 00000D67 3C03                     cmp al, 3
  2631 00000D69 0F85CC00                 jne @@getVariable92
  2632                                  
  2633                                  ;-57     lookCode();
  2634                                  
  2635 00000D6D E82201                   call lookCode
  2636                                  
  2637                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2638                                  
  2639 00000D70 A0[3E00]                 mov al, [CodeType]
  2640 00000D73 3CC8                     cmp al, 200
  2641 00000D75 0F8D0900                 jge @@getVariable93
  2642 00000D79 68[440E]                 push getVariable_0
  2643 00000D7C E8020D                   call errorexit
  2644 00000D7F 83C402                   add  sp, 2
  2645                                  
  2646                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2647                                  
  2648                                  @@getVariable93:
  2649 00000D82 A0[3E00]                 mov al, [CodeType]
  2650 00000D85 3CCF                     cmp al, 207
  2651 00000D87 0F8E0900                 jle @@getVariable94
  2652 00000D8B 68[5C0E]                 push getVariable_1
  2653 00000D8E E8F00C                   call errorexit
  2654 00000D91 83C402                   add  sp, 2
  2655                                  
  2656                                  ;-60     if (CodeType== 200) {// DB
  2657                                  
  2658                                  @@getVariable94:
  2659 00000D94 A0[3E00]                 mov al, [CodeType]
  2660 00000D97 3CC8                     cmp al, 200
  2661 00000D99 0F856A00                 jne @@getVariable95
  2662                                  
  2663                                  ;-61       do { getTokeType();
  2664                                  
  2665                                  @@getVariable96:
  2666 00000D9D E872FE                   call getTokeType
  2667                                  
  2668                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2669                                  
  2670 00000DA0 A0[3C00]                 mov al, [TokeType]
  2671 00000DA3 3C01                     cmp al, 1
  2672 00000DA5 0F850D00                 jne @@getVariable97
  2673 00000DA9 FF36[2600]               push word [SymbolInt]
  2674 00000DAD E8DFFB                   call genCode8
  2675 00000DB0 83C402                   add  sp, 2
  2676                                  
  2677                                  ;-63         else {
  2678                                  
  2679 00000DB3 E94100                   jmp @@getVariable98
  2680                                  @@getVariable97:
  2681                                  
  2682                                  ;-64           skipBlank();
  2683                                  
  2684 00000DB6 E80703                   call skipBlank
  2685                                  
  2686                                  ;-65           if (isToken('"')) {
  2687                                  
  2688 00000DB9 6A22                     push 34
  2689 00000DBB E8D101                   call isToken
  2690 00000DBE 83C402                   add  sp, 2
  2691 00000DC1 08C0                     or  al, al
  2692 00000DC3 0F843000                 je @@getVariable99
  2693                                  
  2694                                  ;-66             do { c= *InputPtr;
  2695                                  
  2696                                  @@getVariable100:
  2697 00000DC7 8B1E[2800]               mov bx, [InputPtr]
  2698 00000DCB 8A07                     mov al, [bx]
  2699 00000DCD B400                     mov ah, 0
  2700 00000DCF 8846FE                   mov byte [bp-2], al
  2701                                  
  2702                                  ;-67               genCode8(c);
  2703                                  
  2704 00000DD2 8A46FE                   mov al, byte [bp-2]
  2705 00000DD5 B400                     mov ah, 0
  2706 00000DD7 50                       push ax
  2707 00000DD8 E8B4FB                   call genCode8
  2708 00000DDB 83C402                   add  sp, 2
  2709                                  
  2710                                  ;-68               InputPtr++;
  2711                                  
  2712 00000DDE FF06[2800]               inc  word [InputPtr]
  2713                                  
  2714                                  ;-69             } while (*InputPtr != '"' );
  2715                                  
  2716 00000DE2 8B1E[2800]               mov bx, [InputPtr]
  2717 00000DE6 8A07                     mov al, [bx]
  2718 00000DE8 B400                     mov ah, 0
  2719 00000DEA 83F822                   cmp ax, 34
  2720 00000DED 0F840200                 je  @@getVariable101
  2721 00000DF1 EBD4                     jmp @@getVariable100
  2722                                  @@getVariable101:
  2723                                  
  2724                                  ;-70             InputPtr++;
  2725                                  
  2726 00000DF3 FF06[2800]               inc  word [InputPtr]
  2727                                  
  2728                                  ;-71           }
  2729                                  
  2730                                  
  2731                                  ;-72         }
  2732                                  
  2733                                  @@getVariable99:
  2734                                  
  2735                                  ;-73       } while (isToken(','));
  2736                                  
  2737                                  @@getVariable98:
  2738 00000DF7 6A2C                     push 44
  2739 00000DF9 E89301                   call isToken
  2740 00000DFC 83C402                   add  sp, 2
  2741 00000DFF 08C0                     or  al, al
  2742 00000E01 0F840200                 je @@getVariable102
  2743 00000E05 EB96                     jmp @@getVariable96
  2744                                  @@getVariable102:
  2745                                  
  2746                                  ;-74     }
  2747                                  
  2748                                  
  2749                                  ;-75     if (CodeType== 201) {// DW
  2750                                  
  2751                                  @@getVariable95:
  2752 00000E07 A0[3E00]                 mov al, [CodeType]
  2753 00000E0A 3CC9                     cmp al, 201
  2754 00000E0C 0F852600                 jne @@getVariable103
  2755                                  
  2756                                  ;-76       do { getTokeType();
  2757                                  
  2758                                  @@getVariable104:
  2759 00000E10 E8FFFD                   call getTokeType
  2760                                  
  2761                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2762                                  
  2763 00000E13 A0[3C00]                 mov al, [TokeType]
  2764 00000E16 3C01                     cmp al, 1
  2765 00000E18 0F850A00                 jne @@getVariable105
  2766 00000E1C FF36[2600]               push word [SymbolInt]
  2767 00000E20 E89EFB                   call genCode16
  2768 00000E23 83C402                   add  sp, 2
  2769                                  
  2770                                  ;-78       } while (isToken(','));
  2771                                  
  2772                                  @@getVariable105:
  2773 00000E26 6A2C                     push 44
  2774 00000E28 E86401                   call isToken
  2775 00000E2B 83C402                   add  sp, 2
  2776 00000E2E 08C0                     or  al, al
  2777 00000E30 0F840200                 je @@getVariable106
  2778 00000E34 EBDA                     jmp @@getVariable104
  2779                                  @@getVariable106:
  2780                                  
  2781                                  ;-79     }
  2782                                  
  2783                                  
  2784                                  ;-80   }
  2785                                  
  2786                                  @@getVariable103:
  2787                                  
  2788                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2789                                  
  2790 00000E36 E90900                   jmp @@getVariable107
  2791                                  @@getVariable92:
  2792 00000E39 68[740E]                 push getVariable_2
  2793 00000E3C E8420C                   call errorexit
  2794 00000E3F 83C402                   add  sp, 2
  2795                                  
  2796                                  ;-82 }
  2797                                  
  2798                                  @@getVariable107:
  2799                                  
  2800                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2801 00000E42 C9                       LEAVE
  2802 00000E43 C3                       ret
  2803                                  ; ENDP
  2804 00000E44 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2805 00000E4D 422C572C4420657870-
  2806 00000E56 656374656400       
  2807 00000E5C 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2808 00000E65 422C572C4420657870-
  2809 00000E6E 656374656400       
  2810 00000E74 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2811 00000E7D 6F7220524553422C57-
  2812 00000E86 2C4420657870656374-
  2813 00000E8F 656400             
  2814                                  
  2815                                  lookCode:  ; *** PROC ***
  2816                                  
  2817                                  ;-84   CodeType=0;
  2818                                  
  2819 00000E92 66B800000000             mov eax, 0
  2820 00000E98 A2[3E00]                 mov byte [CodeType], al
  2821                                  
  2822                                  ;-85   OpCodePtr= &I_START;
  2823                                  
  2824 00000E9B B8[5B00]                 mov ax, I_START
  2825 00000E9E A3[4C00]                 mov word [OpCodePtr], ax
  2826                                  
  2827                                  ;-86   OpCodePtr++;
  2828                                  
  2829 00000EA1 FF06[4C00]               inc  word [OpCodePtr]
  2830                                  
  2831                                  ;-87   do  {
  2832                                  
  2833                                  @@lookCode108:
  2834                                  
  2835                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2836                                  
  2837 00000EA5 FF36[4C00]               push word [OpCodePtr]
  2838 00000EA9 8D064F75                 lea  ax, [SymbolUpper]
  2839 00000EAD 50                       push ax
  2840 00000EAE E82611                   call eqstr
  2841 00000EB1 83C404                   add  sp, 4
  2842 00000EB4 08C0                     or  al, al
  2843 00000EB6 0F842700                 je @@lookCode109
  2844                                  
  2845                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2846                                  
  2847                                  @@lookCode110:
  2848 00000EBA 8B1E[4C00]               mov bx, [OpCodePtr]
  2849 00000EBE 8A07                     mov al, [bx]
  2850 00000EC0 B400                     mov ah, 0
  2851 00000EC2 83F800                   cmp ax, 0
  2852 00000EC5 0F840600                 je  @@lookCode111
  2853 00000EC9 FF06[4C00]               inc  word [OpCodePtr]
  2854                                  
  2855                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2856                                  
  2857 00000ECD EBEB                     jmp @@lookCode110
  2858                                  @@lookCode111:
  2859 00000ECF FF06[4C00]               inc  word [OpCodePtr]
  2860 00000ED3 8B1E[4C00]               mov bx, [OpCodePtr]
  2861 00000ED7 8A07                     mov al, [bx]
  2862 00000ED9 B400                     mov ah, 0
  2863 00000EDB A2[3E00]                 mov byte [CodeType], al
  2864                                  
  2865                                  ;-91       return;
  2866                                  
  2867 00000EDE E92A00                   jmp @@retn
  2868                                  
  2869                                  ;-92     }
  2870                                  
  2871                                  
  2872                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2873                                  
  2874                                  @@lookCode109:
  2875                                  @@lookCode112:
  2876 00000EE1 8B1E[4C00]               mov bx, [OpCodePtr]
  2877 00000EE5 8A07                     mov al, [bx]
  2878 00000EE7 B400                     mov ah, 0
  2879 00000EE9 3DF100                   cmp ax, 241
  2880 00000EEC 0F840600                 je  @@lookCode113
  2881 00000EF0 FF06[4C00]               inc  word [OpCodePtr]
  2882                                  
  2883                                  ;-94   OpCodePtr++;
  2884                                  
  2885 00000EF4 EBEB                     jmp @@lookCode112
  2886                                  @@lookCode113:
  2887 00000EF6 FF06[4C00]               inc  word [OpCodePtr]
  2888                                  
  2889                                  ;-95   } while(*OpCodePtr!=0);
  2890                                  
  2891 00000EFA 8B1E[4C00]               mov bx, [OpCodePtr]
  2892 00000EFE 8A07                     mov al, [bx]
  2893 00000F00 B400                     mov ah, 0
  2894 00000F02 83F800                   cmp ax, 0
  2895 00000F05 0F840200                 je  @@lookCode114
  2896 00000F09 EB9A                     jmp @@lookCode108
  2897                                  @@lookCode114:
  2898                                  
  2899                                  ;-96 }
  2900                                  
  2901                                  
  2902                                  ;-97 int getCodeSize() {
  2903                                  
  2904                                  @@retn:
  2905 00000F0B C3                       ret
  2906                                  ; ENDP
  2907                                  
  2908                                  getCodeSize:  ; *** PROC ***
  2909                                  
  2910                                  ;-98   if (TokeType ==ALNUME) {
  2911                                  
  2912 00000F0C A0[3C00]                 mov al, [TokeType]
  2913 00000F0F 3C03                     cmp al, 3
  2914 00000F11 0F856000                 jne @@getCodeSize115
  2915                                  
  2916                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2917                                  
  2918 00000F15 68[7F0F]                 push getCodeSize_0
  2919 00000F18 8D064F75                 lea  ax, [SymbolUpper]
  2920 00000F1C 50                       push ax
  2921 00000F1D E8B710                   call eqstr
  2922 00000F20 83C404                   add  sp, 4
  2923 00000F23 08C0                     or  al, al
  2924 00000F25 0F840C00                 je @@getCodeSize116
  2925 00000F29 E8E6FC                   call getTokeType
  2926 00000F2C 66B801000000             mov eax, 1
  2927 00000F32 E94900                   jmp @@retn
  2928                                  
  2929                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2930                                  
  2931                                  @@getCodeSize116:
  2932 00000F35 68[840F]                 push getCodeSize_1
  2933 00000F38 8D064F75                 lea  ax, [SymbolUpper]
  2934 00000F3C 50                       push ax
  2935 00000F3D E89710                   call eqstr
  2936 00000F40 83C404                   add  sp, 4
  2937 00000F43 08C0                     or  al, al
  2938 00000F45 0F840C00                 je @@getCodeSize117
  2939 00000F49 E8C6FC                   call getTokeType
  2940 00000F4C 66B802000000             mov eax, 2
  2941 00000F52 E92900                   jmp @@retn
  2942                                  
  2943                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2944                                  
  2945                                  @@getCodeSize117:
  2946 00000F55 68[890F]                 push getCodeSize_2
  2947 00000F58 8D064F75                 lea  ax, [SymbolUpper]
  2948 00000F5C 50                       push ax
  2949 00000F5D E87710                   call eqstr
  2950 00000F60 83C404                   add  sp, 4
  2951 00000F63 08C0                     or  al, al
  2952 00000F65 0F840C00                 je @@getCodeSize118
  2953 00000F69 E8A6FC                   call getTokeType
  2954 00000F6C 66B803000000             mov eax, 3
  2955 00000F72 E90900                   jmp @@retn
  2956                                  
  2957                                  ;-102   } return 0;
  2958                                  
  2959                                  @@getCodeSize118:
  2960                                  @@getCodeSize115:
  2961 00000F75 66B800000000             mov eax, 0
  2962 00000F7B E90000                   jmp @@retn
  2963                                  
  2964                                  ;-103 }
  2965                                  
  2966                                  
  2967                                  ;-104 int isToken(char c) {
  2968                                  
  2969                                  @@retn:
  2970 00000F7E C3                       ret
  2971                                  ; ENDP
  2972 00000F7F 4259544500              getCodeSize_0 db "BYTE",0
  2973 00000F84 574F524400              getCodeSize_1 db "WORD",0
  2974 00000F89 44574F524400            getCodeSize_2 db "DWORD",0
  2975                                  
  2976                                  isToken:  ; *** PROC ***
  2977                                  
  2978                                  ;-105   skipBlank();
  2979                                  
  2980                                  ;Function : isToken, Number of local variables: 1
  2981                                  ;   # type sign width line used address name   list of local variables
  2982                                  ;  200 var sign byte   104 NULL bp+4    c;
  2983 00000F8F C8000000                 ENTER  0,0
  2984 00000F93 E82A01                   call skipBlank
  2985                                  
  2986                                  ;-106   if (*InputPtr == c) {
  2987                                  
  2988 00000F96 8B1E[2800]               mov bx, [InputPtr]
  2989 00000F9A 8A07                     mov al, [bx]
  2990 00000F9C B400                     mov ah, 0
  2991 00000F9E 3A4604                   cmp al, [bp+4]
  2992 00000FA1 0F850D00                 jne @@isToken119
  2993                                  
  2994                                  ;-107     InputPtr++; return 1;} return 0;
  2995                                  
  2996 00000FA5 FF06[2800]               inc  word [InputPtr]
  2997 00000FA9 66B801000000             mov eax, 1
  2998 00000FAF E90900                   jmp @@retn
  2999                                  @@isToken119:
  3000 00000FB2 66B800000000             mov eax, 0
  3001 00000FB8 E90000                   jmp @@retn
  3002                                  
  3003                                  ;-108 }
  3004                                  
  3005                                  
  3006                                  ;-109 int skipRest() {
  3007                                  
  3008 00000FBB C9                      @@retn: LEAVE
  3009 00000FBC C3                       ret
  3010                                  ; ENDP
  3011                                  
  3012                                  skipRest:  ; *** PROC ***
  3013                                  
  3014                                  ;-110   getTokeType(); if(TokeType!=0)prs("\n; ******** extra char ignored");
  3015                                  
  3016 00000FBD E852FC                   call getTokeType
  3017 00000FC0 A0[3C00]                 mov al, [TokeType]
  3018 00000FC3 3C00                     cmp al, 0
  3019 00000FC5 0F840900                 je  @@skipRest120
  3020 00000FC9 68[D30F]                 push skipRest_0
  3021 00000FCC E82408                   call prs
  3022 00000FCF 83C402                   add  sp, 2
  3023                                  
  3024                                  ;-111 }
  3025                                  
  3026                                  @@skipRest120:
  3027 00000FD2 C3                       ret
  3028                                  ; ENDP
  3029 00000FD3 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ******** extra char ignored",0
  3030 00000FDC 2A2A2A206578747261-
  3031 00000FE5 20636861722069676E-
  3032 00000FEE 6F72656400         
  3033                                  ;Back to main program: AS.C
  3034                                  
  3035                                  ;-216 #include "HELPER.C"
  3036                                  
  3037                                  ;Use include file: HELPER.C
  3038                                  
  3039                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3040                                  
  3041                                  
  3042                                  getLine:  ; *** PROC ***
  3043                                  
  3044                                  ;-2   InputPtr= &InputBuf;
  3045                                  
  3046 00000FF3 B86E75                   mov ax, InputBuf
  3047 00000FF6 A3[2800]                 mov word [InputPtr], ax
  3048                                  
  3049                                  ;-3   *InputPtr=0;//if last line is empty
  3050                                  
  3051 00000FF9 66B800000000             mov eax, 0
  3052 00000FFF 8B1E[2800]               mov  bx, [InputPtr]
  3053 00001003 8807                     mov  [bx], al
  3054                                  
  3055                                  ;-4   do {
  3056                                  
  3057                                  @@getLine121:
  3058                                  
  3059                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3060                                  
  3061 00001005 6A01                     push 1
  3062 00001007 FF36[2A00]               push word [asm_fd]
  3063 0000100B 8D06[3600]               lea  ax, [DOS_ByteRead]
  3064 0000100F 50                       push ax
  3065 00001010 E85F10                   call readRL
  3066 00001013 83C406                   add  sp, 6
  3067 00001016 A3[3400]                 mov word [DOS_NoBytes], ax
  3068                                  
  3069                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  3070                                  
  3071 00001019 A1[3000]                 mov ax, [DOS_ERR]
  3072 0000101C 08C0                     or  al, al
  3073 0000101E 0F840900                 je @@getLine122
  3074 00001022 68[6A10]                 push getLine_0
  3075 00001025 E8590A                   call errorexit
  3076 00001028 83C402                   add  sp, 2
  3077                                  
  3078                                  ;-7     if (DOS_NoBytes == 0) return;
  3079                                  
  3080                                  @@getLine122:
  3081 0000102B A1[3400]                 mov ax, [DOS_NoBytes]
  3082 0000102E 83F800                   cmp ax, 0
  3083 00001031 0F850300                 jne @@getLine123
  3084 00001035 E93100                   jmp @@retn
  3085                                  
  3086                                  ;-8     *InputPtr = DOS_ByteRead;
  3087                                  
  3088                                  @@getLine123:
  3089 00001038 A0[3600]                 mov al, [DOS_ByteRead]
  3090 0000103B 8B1E[2800]               mov  bx, [InputPtr]
  3091 0000103F 8807                     mov  [bx], al
  3092                                  
  3093                                  ;-9     InputPtr++;
  3094                                  
  3095 00001041 FF06[2800]               inc  word [InputPtr]
  3096                                  
  3097                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  3098                                  
  3099 00001045 A0[3600]                 mov al, byte [DOS_ByteRead]
  3100 00001048 B400                     mov ah, 0
  3101 0000104A 50                       push ax
  3102 0000104B E82B00                   call ifEOL
  3103 0000104E 83C402                   add  sp, 2
  3104 00001051 3C00                     cmp al, 0
  3105 00001053 0F850200                 jne @@getLine124
  3106 00001057 EBAC                     jmp @@getLine121
  3107                                  @@getLine124:
  3108                                  
  3109                                  ;-11   InputPtr--;
  3110                                  
  3111 00001059 FF0E[2800]               dec  word [InputPtr]
  3112                                  
  3113                                  ;-12   *InputPtr=0;
  3114                                  
  3115 0000105D 66B800000000             mov eax, 0
  3116 00001063 8B1E[2800]               mov  bx, [InputPtr]
  3117 00001067 8807                     mov  [bx], al
  3118                                  
  3119                                  ;-13 }
  3120                                  
  3121                                  
  3122                                  ;-14 int ifEOL(char c) {
  3123                                  
  3124                                  @@retn:
  3125 00001069 C3                       ret
  3126                                  ; ENDP
  3127 0000106A 52656164696E672053-     getLine_0 db "Reading Source",0
  3128 00001073 6F7572636500       
  3129                                  
  3130                                  ifEOL:  ; *** PROC ***
  3131                                  
  3132                                  ;-15   if (c == 10) return 1;
  3133                                  
  3134                                  ;Function : ifEOL, Number of local variables: 1
  3135                                  ;   # type sign width line used address name   list of local variables
  3136                                  ;  200 var sign byte    14 NULL bp+4    c;
  3137 00001079 C8000000                 ENTER  0,0
  3138 0000107D 8A4604                   mov al, [bp+4]
  3139 00001080 3C0A                     cmp al, 10
  3140 00001082 0F850900                 jne @@ifEOL125
  3141 00001086 66B801000000             mov eax, 1
  3142 0000108C E92F00                   jmp @@retn
  3143                                  
  3144                                  ;-16   if (c == 13) {
  3145                                  
  3146                                  @@ifEOL125:
  3147 0000108F 8A4604                   mov al, [bp+4]
  3148 00001092 3C0D                     cmp al, 13
  3149 00001094 0F851D00                 jne @@ifEOL126
  3150                                  
  3151                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3152                                  
  3153 00001098 6A01                     push 1
  3154 0000109A FF36[2A00]               push word [asm_fd]
  3155 0000109E 8D06[3600]               lea  ax, [DOS_ByteRead]
  3156 000010A2 50                       push ax
  3157 000010A3 E8CC0F                   call readRL
  3158 000010A6 83C406                   add  sp, 6
  3159 000010A9 A3[3400]                 mov word [DOS_NoBytes], ax
  3160                                  
  3161                                  ;-18     return 1;}
  3162                                  
  3163 000010AC 66B801000000             mov eax, 1
  3164 000010B2 E90900                   jmp @@retn
  3165                                  
  3166                                  ;-19   return 0;
  3167                                  
  3168                                  @@ifEOL126:
  3169 000010B5 66B800000000             mov eax, 0
  3170 000010BB E90000                   jmp @@retn
  3171                                  
  3172                                  ;-20 }
  3173                                  
  3174                                  
  3175                                  ;-21 int skipBlank() {
  3176                                  
  3177 000010BE C9                      @@retn: LEAVE
  3178 000010BF C3                       ret
  3179                                  ; ENDP
  3180                                  
  3181                                  skipBlank:  ; *** PROC ***
  3182                                  
  3183                                  ;-22   skipblank1:
  3184                                  
  3185                                  @@skipblank1:
  3186                                  
  3187                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3188                                  
  3189 000010C0 8B1E[2800]               mov bx, [InputPtr]
  3190 000010C4 8A07                     mov al, [bx]
  3191 000010C6 B400                     mov ah, 0
  3192 000010C8 83F820                   cmp ax, 32
  3193 000010CB 0F850600                 jne @@skipBlank127
  3194 000010CF FF06[2800]               inc  word [InputPtr]
  3195 000010D3 EBEB                     jmp @@skipblank1
  3196                                  
  3197                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3198                                  
  3199                                  @@skipBlank127:
  3200 000010D5 8B1E[2800]               mov bx, [InputPtr]
  3201 000010D9 8A07                     mov al, [bx]
  3202 000010DB B400                     mov ah, 0
  3203 000010DD 83F809                   cmp ax, 9
  3204 000010E0 0F850600                 jne @@skipBlank128
  3205 000010E4 FF06[2800]               inc  word [InputPtr]
  3206 000010E8 EBD6                     jmp @@skipblank1
  3207                                  
  3208                                  ;-25 }
  3209                                  
  3210                                  @@skipBlank128:
  3211                                  
  3212                                  ;-26 int letterE(char c) {
  3213                                  
  3214 000010EA C3                       ret
  3215                                  ; ENDP
  3216                                  
  3217                                  letterE:  ; *** PROC ***
  3218                                  
  3219                                  ;-27   if (c=='_') return 1;
  3220                                  
  3221                                  ;Function : letterE, Number of local variables: 1
  3222                                  ;   # type sign width line used address name   list of local variables
  3223                                  ;  200 var sign byte    26 NULL bp+4    c;
  3224 000010EB C8000000                 ENTER  0,0
  3225 000010EF 8A4604                   mov al, [bp+4]
  3226 000010F2 3C5F                     cmp al, 95
  3227 000010F4 0F850900                 jne @@letterE129
  3228 000010F8 66B801000000             mov eax, 1
  3229 000010FE E97E00                   jmp @@retn
  3230                                  
  3231                                  ;-28   if (c=='.') return 1;
  3232                                  
  3233                                  @@letterE129:
  3234 00001101 8A4604                   mov al, [bp+4]
  3235 00001104 3C2E                     cmp al, 46
  3236 00001106 0F850900                 jne @@letterE130
  3237 0000110A 66B801000000             mov eax, 1
  3238 00001110 E96C00                   jmp @@retn
  3239                                  
  3240                                  ;-29   if (c=='?') return 1;
  3241                                  
  3242                                  @@letterE130:
  3243 00001113 8A4604                   mov al, [bp+4]
  3244 00001116 3C3F                     cmp al, 63
  3245 00001118 0F850900                 jne @@letterE131
  3246 0000111C 66B801000000             mov eax, 1
  3247 00001122 E95A00                   jmp @@retn
  3248                                  
  3249                                  ;-30   if (c=='$') return 1;
  3250                                  
  3251                                  @@letterE131:
  3252 00001125 8A4604                   mov al, [bp+4]
  3253 00001128 3C24                     cmp al, 36
  3254 0000112A 0F850900                 jne @@letterE132
  3255 0000112E 66B801000000             mov eax, 1
  3256 00001134 E94800                   jmp @@retn
  3257                                  
  3258                                  ;-31   if (c> 'z') return 0;
  3259                                  
  3260                                  @@letterE132:
  3261 00001137 8A4604                   mov al, [bp+4]
  3262 0000113A 3C7A                     cmp al, 122
  3263 0000113C 0F8E0900                 jle @@letterE133
  3264 00001140 66B800000000             mov eax, 0
  3265 00001146 E93600                   jmp @@retn
  3266                                  
  3267                                  ;-32   if (c< '@') return 0; // at included
  3268                                  
  3269                                  @@letterE133:
  3270 00001149 8A4604                   mov al, [bp+4]
  3271 0000114C 3C40                     cmp al, 64
  3272 0000114E 0F8D0900                 jge @@letterE134
  3273 00001152 66B800000000             mov eax, 0
  3274 00001158 E92400                   jmp @@retn
  3275                                  
  3276                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3277                                  
  3278                                  @@letterE134:
  3279 0000115B 8A4604                   mov al, [bp+4]
  3280 0000115E 3C5A                     cmp al, 90
  3281 00001160 0F8E1200                 jle @@letterE135
  3282 00001164 8A4604                   mov al, [bp+4]
  3283 00001167 3C61                     cmp al, 97
  3284 00001169 0F8D0900                 jge @@letterE136
  3285 0000116D 66B800000000             mov eax, 0
  3286 00001173 E90900                   jmp @@retn
  3287                                  @@letterE136:
  3288                                  
  3289                                  ;-34   return 1;
  3290                                  
  3291                                  @@letterE135:
  3292 00001176 66B801000000             mov eax, 1
  3293 0000117C E90000                   jmp @@retn
  3294                                  
  3295                                  ;-35 }
  3296                                  
  3297                                  
  3298                                  ;-36 int alnumE(char c) {
  3299                                  
  3300 0000117F C9                      @@retn: LEAVE
  3301 00001180 C3                       ret
  3302                                  ; ENDP
  3303                                  
  3304                                  alnumE:  ; *** PROC ***
  3305                                  
  3306                                  ;-37   if (digit(c)) return 1;
  3307                                  
  3308                                  ;Function : alnumE, Number of local variables: 1
  3309                                  ;   # type sign width line used address name   list of local variables
  3310                                  ;  200 var sign byte    36 NULL bp+4    c;
  3311 00001181 C8000000                 ENTER  0,0
  3312 00001185 8A4604                   mov al, byte [bp+4]
  3313 00001188 B400                     mov ah, 0
  3314 0000118A 50                       push ax
  3315 0000118B E8160E                   call digit
  3316 0000118E 83C402                   add  sp, 2
  3317 00001191 08C0                     or  al, al
  3318 00001193 0F840900                 je @@alnumE137
  3319 00001197 66B801000000             mov eax, 1
  3320 0000119D E92400                   jmp @@retn
  3321                                  
  3322                                  ;-38   if (letterE(c)) return 1;
  3323                                  
  3324                                  @@alnumE137:
  3325 000011A0 8A4604                   mov al, byte [bp+4]
  3326 000011A3 B400                     mov ah, 0
  3327 000011A5 50                       push ax
  3328 000011A6 E842FF                   call letterE
  3329 000011A9 83C402                   add  sp, 2
  3330 000011AC 08C0                     or  al, al
  3331 000011AE 0F840900                 je @@alnumE138
  3332 000011B2 66B801000000             mov eax, 1
  3333 000011B8 E90900                   jmp @@retn
  3334                                  
  3335                                  ;-39   return 0;
  3336                                  
  3337                                  @@alnumE138:
  3338 000011BB 66B800000000             mov eax, 0
  3339 000011C1 E90000                   jmp @@retn
  3340                                  
  3341                                  ;-40 }
  3342                                  
  3343                                  
  3344                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3345                                  
  3346 000011C4 C9                      @@retn: LEAVE
  3347 000011C5 C3                       ret
  3348                                  ; ENDP
  3349                                  
  3350                                  getDigit:  ; *** PROC ***
  3351                                  
  3352                                  ;-42   unsigned int CastInt;
  3353                                  
  3354                                  
  3355                                  ;-43   SymbolInt=0;
  3356                                  
  3357                                  ;Function : getDigit, Number of local variables: 2
  3358                                  ;   # type sign width line used address name   list of local variables
  3359                                  ;  200 var unsg byte    41 NULL bp+4    c
  3360                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3361 000011C6 C8020000                 ENTER  2,0
  3362 000011CA 66B800000000             mov eax, 0
  3363 000011D0 A3[2600]                 mov word [SymbolInt], ax
  3364                                  
  3365                                  ;-44   do {
  3366                                  
  3367                                  @@getDigit139:
  3368                                  
  3369                                  ;-45     c-='0';
  3370                                  
  3371 000011D3 806E0430                 sub  byte [bp+4], 48
  3372                                  
  3373                                  ;-46     SymbolInt=SymbolInt*10;
  3374                                  
  3375 000011D7 A1[2600]                 mov ax, [SymbolInt]
  3376 000011DA 66BB0A000000             mov ebx, 10
  3377 000011E0 66F7E3                   mul ebx
  3378 000011E3 A3[2600]                 mov word [SymbolInt], ax
  3379                                  
  3380                                  ;-47     ax=0; CastInt=c; //cast b2w
  3381                                  
  3382 000011E6 B80000                   mov  ax, 0
  3383 000011E9 8A4604                   mov al, [bp+4]
  3384 000011EC 8946FE                   mov word [bp-2], ax
  3385                                  
  3386                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3387                                  
  3388 000011EF A1[2600]                 mov ax, [SymbolInt]
  3389 000011F2 0346FE                   add ax, [bp-2]
  3390 000011F5 A3[2600]                 mov word [SymbolInt], ax
  3391                                  
  3392                                  ;-49     InputPtr++;
  3393                                  
  3394 000011F8 FF06[2800]               inc  word [InputPtr]
  3395                                  
  3396                                  ;-50     c = *InputPtr;
  3397                                  
  3398 000011FC 8B1E[2800]               mov bx, [InputPtr]
  3399 00001200 8A07                     mov al, [bx]
  3400 00001202 B400                     mov ah, 0
  3401 00001204 884604                   mov byte [bp+4], al
  3402                                  
  3403                                  ;-51   } while(digit(c));
  3404                                  
  3405 00001207 8A4604                   mov al, byte [bp+4]
  3406 0000120A B400                     mov ah, 0
  3407 0000120C 50                       push ax
  3408 0000120D E8940D                   call digit
  3409 00001210 83C402                   add  sp, 2
  3410 00001213 08C0                     or  al, al
  3411 00001215 0F840200                 je @@getDigit140
  3412 00001219 EBB8                     jmp @@getDigit139
  3413                                  @@getDigit140:
  3414                                  
  3415                                  ;-52 }
  3416                                  
  3417                                  
  3418                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3419 0000121B C9                       LEAVE
  3420 0000121C C3                       ret
  3421                                  ; ENDP
  3422                                  
  3423                                  getName:  ; *** PROC ***
  3424                                  
  3425                                  ;-54   char *p;
  3426                                  
  3427                                  
  3428                                  ;-55   p = &Symbol;
  3429                                  
  3430                                  ;Function : getName, Number of local variables: 2
  3431                                  ;   # type sign width line used address name   list of local variables
  3432                                  ;  200 var unsg byte    53 NULL bp+4    c
  3433                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3434 0000121D C8020000                 ENTER  2,0
  3435 00001221 B83075                   mov ax, Symbol
  3436 00001224 8946FE                   mov word [bp-2], ax
  3437                                  
  3438                                  ;-56   *p = c;
  3439                                  
  3440 00001227 8A4604                   mov al, [bp+4]
  3441 0000122A 8B5EFE                   mov  bx, [bp-2]
  3442 0000122D 8807                     mov  [bx], al
  3443                                  
  3444                                  ;-57   p++;
  3445                                  
  3446 0000122F FF46FE                   inc  word [bp-2]
  3447                                  
  3448                                  ;-58   while (alnumE(c)) {
  3449                                  
  3450                                  @@getName141:
  3451 00001232 8A4604                   mov al, byte [bp+4]
  3452 00001235 B400                     mov ah, 0
  3453 00001237 50                       push ax
  3454 00001238 E846FF                   call alnumE
  3455 0000123B 83C402                   add  sp, 2
  3456 0000123E 08C0                     or  al, al
  3457 00001240 0F841C00                 je @@getName142
  3458                                  
  3459                                  ;-59     InputPtr++;
  3460                                  
  3461 00001244 FF06[2800]               inc  word [InputPtr]
  3462                                  
  3463                                  ;-60     c = *InputPtr;
  3464                                  
  3465 00001248 8B1E[2800]               mov bx, [InputPtr]
  3466 0000124C 8A07                     mov al, [bx]
  3467 0000124E B400                     mov ah, 0
  3468 00001250 884604                   mov byte [bp+4], al
  3469                                  
  3470                                  ;-61     *p = c;
  3471                                  
  3472 00001253 8A4604                   mov al, [bp+4]
  3473 00001256 8B5EFE                   mov  bx, [bp-2]
  3474 00001259 8807                     mov  [bx], al
  3475                                  
  3476                                  ;-62     p++;
  3477                                  
  3478 0000125B FF46FE                   inc  word [bp-2]
  3479                                  
  3480                                  ;-63   }
  3481                                  
  3482                                  
  3483                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3484                                  
  3485 0000125E EBD2                     jmp @@getName141
  3486                                  @@getName142:
  3487 00001260 8A4604                   mov al, [bp+4]
  3488 00001263 3C3A                     cmp al, 58
  3489 00001265 0F850C00                 jne @@getName143
  3490 00001269 66B801000000             mov eax, 1
  3491 0000126F A2[3B00]                 mov byte [isLabel], al
  3492 00001272 E90900                   jmp @@getName144
  3493                                  @@getName143:
  3494 00001275 66B800000000             mov eax, 0
  3495 0000127B A2[3B00]                 mov byte [isLabel], al
  3496                                  
  3497                                  ;-65   p--;
  3498                                  
  3499                                  @@getName144:
  3500 0000127E FF4EFE                   dec  word [bp-2]
  3501                                  
  3502                                  ;-66   *p = 0;
  3503                                  
  3504 00001281 66B800000000             mov eax, 0
  3505 00001287 8B5EFE                   mov  bx, [bp-2]
  3506 0000128A 8807                     mov  [bx], al
  3507                                  
  3508                                  ;-67   strcpy(SymbolUpper, Symbol);
  3509                                  
  3510 0000128C 8D063075                 lea  ax, [Symbol]
  3511 00001290 50                       push ax
  3512 00001291 8D064F75                 lea  ax, [SymbolUpper]
  3513 00001295 50                       push ax
  3514 00001296 E8D20C                   call strcpy
  3515 00001299 83C404                   add  sp, 4
  3516                                  
  3517                                  ;-68   toupper(SymbolUpper);
  3518                                  
  3519 0000129C 8D064F75                 lea  ax, [SymbolUpper]
  3520 000012A0 50                       push ax
  3521 000012A1 E8590C                   call toupper
  3522 000012A4 83C402                   add  sp, 2
  3523                                  
  3524                                  ;-69 }
  3525                                  
  3526                                  
  3527                                  ;-70 int testReg() {
  3528 000012A7 C9                       LEAVE
  3529 000012A8 C3                       ret
  3530                                  ; ENDP
  3531                                  
  3532                                  testReg:  ; *** PROC ***
  3533                                  
  3534                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3535                                  
  3536                                  
  3537                                  ;-72   RegType=0;
  3538                                  
  3539 000012A9 66B800000000             mov eax, 0
  3540 000012AF A2[3F00]                 mov byte [RegType], al
  3541                                  
  3542                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3543                                  
  3544 000012B2 8D063075                 lea  ax, [Symbol]
  3545 000012B6 50                       push ax
  3546 000012B7 E8860C                   call strlen
  3547 000012BA 83C402                   add  sp, 2
  3548 000012BD 3C02                     cmp al, 2
  3549 000012BF 0F8D0900                 jge @@testReg145
  3550 000012C3 66B800000000             mov eax, 0
  3551 000012C9 E9B603                   jmp @@retn
  3552                                  
  3553                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3554                                  
  3555                                  @@testReg145:
  3556 000012CC 8D063075                 lea  ax, [Symbol]
  3557 000012D0 50                       push ax
  3558 000012D1 E86C0C                   call strlen
  3559 000012D4 83C402                   add  sp, 2
  3560 000012D7 3C03                     cmp al, 3
  3561 000012D9 0F8E0900                 jle @@testReg146
  3562 000012DD 66B800000000             mov eax, 0
  3563 000012E3 E99C03                   jmp @@retn
  3564                                  
  3565                                  ;-75   RegType=BYTE;
  3566                                  
  3567                                  @@testReg146:
  3568 000012E6 66B801000000             mov eax, 1
  3569 000012EC A2[3F00]                 mov byte [RegType], al
  3570                                  
  3571                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3572                                  
  3573 000012EF 68[8316]                 push testReg_0
  3574 000012F2 8D064F75                 lea  ax, [SymbolUpper]
  3575 000012F6 50                       push ax
  3576 000012F7 E8DD0C                   call eqstr
  3577 000012FA 83C404                   add  sp, 4
  3578 000012FD 08C0                     or  al, al
  3579 000012FF 0F840900                 je @@testReg147
  3580 00001303 66B800000000             mov eax, 0
  3581 00001309 E97603                   jmp @@retn
  3582                                  
  3583                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3584                                  
  3585                                  @@testReg147:
  3586 0000130C 68[8616]                 push testReg_1
  3587 0000130F 8D064F75                 lea  ax, [SymbolUpper]
  3588 00001313 50                       push ax
  3589 00001314 E8C00C                   call eqstr
  3590 00001317 83C404                   add  sp, 4
  3591 0000131A 08C0                     or  al, al
  3592 0000131C 0F840900                 je @@testReg148
  3593 00001320 66B801000000             mov eax, 1
  3594 00001326 E95903                   jmp @@retn
  3595                                  
  3596                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3597                                  
  3598                                  @@testReg148:
  3599 00001329 68[8916]                 push testReg_2
  3600 0000132C 8D064F75                 lea  ax, [SymbolUpper]
  3601 00001330 50                       push ax
  3602 00001331 E8A30C                   call eqstr
  3603 00001334 83C404                   add  sp, 4
  3604 00001337 08C0                     or  al, al
  3605 00001339 0F840900                 je @@testReg149
  3606 0000133D 66B802000000             mov eax, 2
  3607 00001343 E93C03                   jmp @@retn
  3608                                  
  3609                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3610                                  
  3611                                  @@testReg149:
  3612 00001346 68[8C16]                 push testReg_3
  3613 00001349 8D064F75                 lea  ax, [SymbolUpper]
  3614 0000134D 50                       push ax
  3615 0000134E E8860C                   call eqstr
  3616 00001351 83C404                   add  sp, 4
  3617 00001354 08C0                     or  al, al
  3618 00001356 0F840900                 je @@testReg150
  3619 0000135A 66B803000000             mov eax, 3
  3620 00001360 E91F03                   jmp @@retn
  3621                                  
  3622                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3623                                  
  3624                                  @@testReg150:
  3625 00001363 68[8F16]                 push testReg_4
  3626 00001366 8D064F75                 lea  ax, [SymbolUpper]
  3627 0000136A 50                       push ax
  3628 0000136B E8690C                   call eqstr
  3629 0000136E 83C404                   add  sp, 4
  3630 00001371 08C0                     or  al, al
  3631 00001373 0F840900                 je @@testReg151
  3632 00001377 66B804000000             mov eax, 4
  3633 0000137D E90203                   jmp @@retn
  3634                                  
  3635                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3636                                  
  3637                                  @@testReg151:
  3638 00001380 68[9216]                 push testReg_5
  3639 00001383 8D064F75                 lea  ax, [SymbolUpper]
  3640 00001387 50                       push ax
  3641 00001388 E84C0C                   call eqstr
  3642 0000138B 83C404                   add  sp, 4
  3643 0000138E 08C0                     or  al, al
  3644 00001390 0F840900                 je @@testReg152
  3645 00001394 66B805000000             mov eax, 5
  3646 0000139A E9E502                   jmp @@retn
  3647                                  
  3648                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3649                                  
  3650                                  @@testReg152:
  3651 0000139D 68[9516]                 push testReg_6
  3652 000013A0 8D064F75                 lea  ax, [SymbolUpper]
  3653 000013A4 50                       push ax
  3654 000013A5 E82F0C                   call eqstr
  3655 000013A8 83C404                   add  sp, 4
  3656 000013AB 08C0                     or  al, al
  3657 000013AD 0F840900                 je @@testReg153
  3658 000013B1 66B806000000             mov eax, 6
  3659 000013B7 E9C802                   jmp @@retn
  3660                                  
  3661                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3662                                  
  3663                                  @@testReg153:
  3664 000013BA 68[9816]                 push testReg_7
  3665 000013BD 8D064F75                 lea  ax, [SymbolUpper]
  3666 000013C1 50                       push ax
  3667 000013C2 E8120C                   call eqstr
  3668 000013C5 83C404                   add  sp, 4
  3669 000013C8 08C0                     or  al, al
  3670 000013CA 0F840900                 je @@testReg154
  3671 000013CE 66B807000000             mov eax, 7
  3672 000013D4 E9AB02                   jmp @@retn
  3673                                  
  3674                                  ;-84   RegType=WORD;
  3675                                  
  3676                                  @@testReg154:
  3677 000013D7 66B802000000             mov eax, 2
  3678 000013DD A2[3F00]                 mov byte [RegType], al
  3679                                  
  3680                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3681                                  
  3682 000013E0 68[9B16]                 push testReg_8
  3683 000013E3 8D064F75                 lea  ax, [SymbolUpper]
  3684 000013E7 50                       push ax
  3685 000013E8 E8EC0B                   call eqstr
  3686 000013EB 83C404                   add  sp, 4
  3687 000013EE 08C0                     or  al, al
  3688 000013F0 0F840900                 je @@testReg155
  3689 000013F4 66B800000000             mov eax, 0
  3690 000013FA E98502                   jmp @@retn
  3691                                  
  3692                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3693                                  
  3694                                  @@testReg155:
  3695 000013FD 68[9E16]                 push testReg_9
  3696 00001400 8D064F75                 lea  ax, [SymbolUpper]
  3697 00001404 50                       push ax
  3698 00001405 E8CF0B                   call eqstr
  3699 00001408 83C404                   add  sp, 4
  3700 0000140B 08C0                     or  al, al
  3701 0000140D 0F840900                 je @@testReg156
  3702 00001411 66B801000000             mov eax, 1
  3703 00001417 E96802                   jmp @@retn
  3704                                  
  3705                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3706                                  
  3707                                  @@testReg156:
  3708 0000141A 68[A116]                 push testReg_10
  3709 0000141D 8D064F75                 lea  ax, [SymbolUpper]
  3710 00001421 50                       push ax
  3711 00001422 E8B20B                   call eqstr
  3712 00001425 83C404                   add  sp, 4
  3713 00001428 08C0                     or  al, al
  3714 0000142A 0F840900                 je @@testReg157
  3715 0000142E 66B802000000             mov eax, 2
  3716 00001434 E94B02                   jmp @@retn
  3717                                  
  3718                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3719                                  
  3720                                  @@testReg157:
  3721 00001437 68[A416]                 push testReg_11
  3722 0000143A 8D064F75                 lea  ax, [SymbolUpper]
  3723 0000143E 50                       push ax
  3724 0000143F E8950B                   call eqstr
  3725 00001442 83C404                   add  sp, 4
  3726 00001445 08C0                     or  al, al
  3727 00001447 0F840900                 je @@testReg158
  3728 0000144B 66B803000000             mov eax, 3
  3729 00001451 E92E02                   jmp @@retn
  3730                                  
  3731                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3732                                  
  3733                                  @@testReg158:
  3734 00001454 68[A716]                 push testReg_12
  3735 00001457 8D064F75                 lea  ax, [SymbolUpper]
  3736 0000145B 50                       push ax
  3737 0000145C E8780B                   call eqstr
  3738 0000145F 83C404                   add  sp, 4
  3739 00001462 08C0                     or  al, al
  3740 00001464 0F840900                 je @@testReg159
  3741 00001468 66B804000000             mov eax, 4
  3742 0000146E E91102                   jmp @@retn
  3743                                  
  3744                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3745                                  
  3746                                  @@testReg159:
  3747 00001471 68[AA16]                 push testReg_13
  3748 00001474 8D064F75                 lea  ax, [SymbolUpper]
  3749 00001478 50                       push ax
  3750 00001479 E85B0B                   call eqstr
  3751 0000147C 83C404                   add  sp, 4
  3752 0000147F 08C0                     or  al, al
  3753 00001481 0F840900                 je @@testReg160
  3754 00001485 66B805000000             mov eax, 5
  3755 0000148B E9F401                   jmp @@retn
  3756                                  
  3757                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3758                                  
  3759                                  @@testReg160:
  3760 0000148E 68[AD16]                 push testReg_14
  3761 00001491 8D064F75                 lea  ax, [SymbolUpper]
  3762 00001495 50                       push ax
  3763 00001496 E83E0B                   call eqstr
  3764 00001499 83C404                   add  sp, 4
  3765 0000149C 08C0                     or  al, al
  3766 0000149E 0F840900                 je @@testReg161
  3767 000014A2 66B806000000             mov eax, 6
  3768 000014A8 E9D701                   jmp @@retn
  3769                                  
  3770                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3771                                  
  3772                                  @@testReg161:
  3773 000014AB 68[B016]                 push testReg_15
  3774 000014AE 8D064F75                 lea  ax, [SymbolUpper]
  3775 000014B2 50                       push ax
  3776 000014B3 E8210B                   call eqstr
  3777 000014B6 83C404                   add  sp, 4
  3778 000014B9 08C0                     or  al, al
  3779 000014BB 0F840900                 je @@testReg162
  3780 000014BF 66B807000000             mov eax, 7
  3781 000014C5 E9BA01                   jmp @@retn
  3782                                  
  3783                                  ;-93   RegType=SEGREG;
  3784                                  
  3785                                  @@testReg162:
  3786 000014C8 66B804000000             mov eax, 4
  3787 000014CE A2[3F00]                 mov byte [RegType], al
  3788                                  
  3789                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3790                                  
  3791 000014D1 68[B316]                 push testReg_16
  3792 000014D4 8D064F75                 lea  ax, [SymbolUpper]
  3793 000014D8 50                       push ax
  3794 000014D9 E8FB0A                   call eqstr
  3795 000014DC 83C404                   add  sp, 4
  3796 000014DF 08C0                     or  al, al
  3797 000014E1 0F840900                 je @@testReg163
  3798 000014E5 66B800000000             mov eax, 0
  3799 000014EB E99401                   jmp @@retn
  3800                                  
  3801                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3802                                  
  3803                                  @@testReg163:
  3804 000014EE 68[B616]                 push testReg_17
  3805 000014F1 8D064F75                 lea  ax, [SymbolUpper]
  3806 000014F5 50                       push ax
  3807 000014F6 E8DE0A                   call eqstr
  3808 000014F9 83C404                   add  sp, 4
  3809 000014FC 08C0                     or  al, al
  3810 000014FE 0F840900                 je @@testReg164
  3811 00001502 66B801000000             mov eax, 1
  3812 00001508 E97701                   jmp @@retn
  3813                                  
  3814                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3815                                  
  3816                                  @@testReg164:
  3817 0000150B 68[B916]                 push testReg_18
  3818 0000150E 8D064F75                 lea  ax, [SymbolUpper]
  3819 00001512 50                       push ax
  3820 00001513 E8C10A                   call eqstr
  3821 00001516 83C404                   add  sp, 4
  3822 00001519 08C0                     or  al, al
  3823 0000151B 0F840900                 je @@testReg165
  3824 0000151F 66B802000000             mov eax, 2
  3825 00001525 E95A01                   jmp @@retn
  3826                                  
  3827                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3828                                  
  3829                                  @@testReg165:
  3830 00001528 68[BC16]                 push testReg_19
  3831 0000152B 8D064F75                 lea  ax, [SymbolUpper]
  3832 0000152F 50                       push ax
  3833 00001530 E8A40A                   call eqstr
  3834 00001533 83C404                   add  sp, 4
  3835 00001536 08C0                     or  al, al
  3836 00001538 0F840900                 je @@testReg166
  3837 0000153C 66B803000000             mov eax, 3
  3838 00001542 E93D01                   jmp @@retn
  3839                                  
  3840                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3841                                  
  3842                                  @@testReg166:
  3843 00001545 68[BF16]                 push testReg_20
  3844 00001548 8D064F75                 lea  ax, [SymbolUpper]
  3845 0000154C 50                       push ax
  3846 0000154D E8870A                   call eqstr
  3847 00001550 83C404                   add  sp, 4
  3848 00001553 08C0                     or  al, al
  3849 00001555 0F840900                 je @@testReg167
  3850 00001559 66B804000000             mov eax, 4
  3851 0000155F E92001                   jmp @@retn
  3852                                  
  3853                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3854                                  
  3855                                  @@testReg167:
  3856 00001562 68[C216]                 push testReg_21
  3857 00001565 8D064F75                 lea  ax, [SymbolUpper]
  3858 00001569 50                       push ax
  3859 0000156A E86A0A                   call eqstr
  3860 0000156D 83C404                   add  sp, 4
  3861 00001570 08C0                     or  al, al
  3862 00001572 0F840900                 je @@testReg168
  3863 00001576 66B805000000             mov eax, 5
  3864 0000157C E90301                   jmp @@retn
  3865                                  
  3866                                  ;-100   RegType=DWORD;
  3867                                  
  3868                                  @@testReg168:
  3869 0000157F 66B803000000             mov eax, 3
  3870 00001585 A2[3F00]                 mov byte [RegType], al
  3871                                  
  3872                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3873                                  
  3874 00001588 68[C516]                 push testReg_22
  3875 0000158B 8D064F75                 lea  ax, [SymbolUpper]
  3876 0000158F 50                       push ax
  3877 00001590 E8440A                   call eqstr
  3878 00001593 83C404                   add  sp, 4
  3879 00001596 08C0                     or  al, al
  3880 00001598 0F840900                 je @@testReg169
  3881 0000159C 66B800000000             mov eax, 0
  3882 000015A2 E9DD00                   jmp @@retn
  3883                                  
  3884                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3885                                  
  3886                                  @@testReg169:
  3887 000015A5 68[C916]                 push testReg_23
  3888 000015A8 8D064F75                 lea  ax, [SymbolUpper]
  3889 000015AC 50                       push ax
  3890 000015AD E8270A                   call eqstr
  3891 000015B0 83C404                   add  sp, 4
  3892 000015B3 08C0                     or  al, al
  3893 000015B5 0F840900                 je @@testReg170
  3894 000015B9 66B801000000             mov eax, 1
  3895 000015BF E9C000                   jmp @@retn
  3896                                  
  3897                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3898                                  
  3899                                  @@testReg170:
  3900 000015C2 68[CD16]                 push testReg_24
  3901 000015C5 8D064F75                 lea  ax, [SymbolUpper]
  3902 000015C9 50                       push ax
  3903 000015CA E80A0A                   call eqstr
  3904 000015CD 83C404                   add  sp, 4
  3905 000015D0 08C0                     or  al, al
  3906 000015D2 0F840900                 je @@testReg171
  3907 000015D6 66B802000000             mov eax, 2
  3908 000015DC E9A300                   jmp @@retn
  3909                                  
  3910                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3911                                  
  3912                                  @@testReg171:
  3913 000015DF 68[D116]                 push testReg_25
  3914 000015E2 8D064F75                 lea  ax, [SymbolUpper]
  3915 000015E6 50                       push ax
  3916 000015E7 E8ED09                   call eqstr
  3917 000015EA 83C404                   add  sp, 4
  3918 000015ED 08C0                     or  al, al
  3919 000015EF 0F840900                 je @@testReg172
  3920 000015F3 66B803000000             mov eax, 3
  3921 000015F9 E98600                   jmp @@retn
  3922                                  
  3923                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3924                                  
  3925                                  @@testReg172:
  3926 000015FC 68[D516]                 push testReg_26
  3927 000015FF 8D064F75                 lea  ax, [SymbolUpper]
  3928 00001603 50                       push ax
  3929 00001604 E8D009                   call eqstr
  3930 00001607 83C404                   add  sp, 4
  3931 0000160A 08C0                     or  al, al
  3932 0000160C 0F840900                 je @@testReg173
  3933 00001610 66B804000000             mov eax, 4
  3934 00001616 E96900                   jmp @@retn
  3935                                  
  3936                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3937                                  
  3938                                  @@testReg173:
  3939 00001619 68[D916]                 push testReg_27
  3940 0000161C 8D064F75                 lea  ax, [SymbolUpper]
  3941 00001620 50                       push ax
  3942 00001621 E8B309                   call eqstr
  3943 00001624 83C404                   add  sp, 4
  3944 00001627 08C0                     or  al, al
  3945 00001629 0F840900                 je @@testReg174
  3946 0000162D 66B805000000             mov eax, 5
  3947 00001633 E94C00                   jmp @@retn
  3948                                  
  3949                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3950                                  
  3951                                  @@testReg174:
  3952 00001636 68[DD16]                 push testReg_28
  3953 00001639 8D064F75                 lea  ax, [SymbolUpper]
  3954 0000163D 50                       push ax
  3955 0000163E E89609                   call eqstr
  3956 00001641 83C404                   add  sp, 4
  3957 00001644 08C0                     or  al, al
  3958 00001646 0F840900                 je @@testReg175
  3959 0000164A 66B806000000             mov eax, 6
  3960 00001650 E92F00                   jmp @@retn
  3961                                  
  3962                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3963                                  
  3964                                  @@testReg175:
  3965 00001653 68[E116]                 push testReg_29
  3966 00001656 8D064F75                 lea  ax, [SymbolUpper]
  3967 0000165A 50                       push ax
  3968 0000165B E87909                   call eqstr
  3969 0000165E 83C404                   add  sp, 4
  3970 00001661 08C0                     or  al, al
  3971 00001663 0F840900                 je @@testReg176
  3972 00001667 66B807000000             mov eax, 7
  3973 0000166D E91200                   jmp @@retn
  3974                                  
  3975                                  ;-109   RegType=0; return 0;
  3976                                  
  3977                                  @@testReg176:
  3978 00001670 66B800000000             mov eax, 0
  3979 00001676 A2[3F00]                 mov byte [RegType], al
  3980 00001679 66B800000000             mov eax, 0
  3981 0000167F E90000                   jmp @@retn
  3982                                  
  3983                                  ;-110 }
  3984                                  
  3985                                  @@retn:
  3986 00001682 C3                       ret
  3987                                  ; ENDP
  3988 00001683 414C00                  testReg_0 db "AL",0
  3989 00001686 434C00                  testReg_1 db "CL",0
  3990 00001689 444C00                  testReg_2 db "DL",0
  3991 0000168C 424C00                  testReg_3 db "BL",0
  3992 0000168F 414800                  testReg_4 db "AH",0
  3993 00001692 434800                  testReg_5 db "CH",0
  3994 00001695 444800                  testReg_6 db "DH",0
  3995 00001698 424800                  testReg_7 db "BH",0
  3996 0000169B 415800                  testReg_8 db "AX",0
  3997 0000169E 435800                  testReg_9 db "CX",0
  3998 000016A1 445800                  testReg_10 db "DX",0
  3999 000016A4 425800                  testReg_11 db "BX",0
  4000 000016A7 535000                  testReg_12 db "SP",0
  4001 000016AA 425000                  testReg_13 db "BP",0
  4002 000016AD 534900                  testReg_14 db "SI",0
  4003 000016B0 444900                  testReg_15 db "DI",0
  4004 000016B3 455300                  testReg_16 db "ES",0
  4005 000016B6 435300                  testReg_17 db "CS",0
  4006 000016B9 535300                  testReg_18 db "SS",0
  4007 000016BC 445300                  testReg_19 db "DS",0
  4008 000016BF 465300                  testReg_20 db "FS",0
  4009 000016C2 475300                  testReg_21 db "GS",0
  4010 000016C5 45415800                testReg_22 db "EAX",0
  4011 000016C9 45435800                testReg_23 db "ECX",0
  4012 000016CD 45445800                testReg_24 db "EDX",0
  4013 000016D1 45425800                testReg_25 db "EBX",0
  4014 000016D5 45535000                testReg_26 db "ESP",0
  4015 000016D9 45425000                testReg_27 db "EBP",0
  4016 000016DD 45534900                testReg_28 db "ESI",0
  4017 000016E1 45444900                testReg_29 db "EDI",0
  4018                                  ;Back to main program: AS.C
  4019                                  
  4020                                  ;-217 #include "OUTPUT.C"
  4021                                  
  4022                                  ;Use include file: OUTPUT.C
  4023                                  
  4024                                  ;-1 int printLine() { int i; char c;
  4025                                  
  4026                                  
  4027                                  printLine:  ; *** PROC ***
  4028                                  
  4029                                  ;-2   prs("\n"); printhex16(PCStart);
  4030                                  
  4031                                  ;Function : printLine, Number of local variables: 2
  4032                                  ;   # type sign width line used address name   list of local variables
  4033                                  ;  200 var sign word     1 NULL bp-2    i
  4034                                  ;  201 var sign byte     1 NULL bp-4    c;
  4035 000016E5 C8040000                 ENTER  4,0
  4036 000016E9 68[7A17]                 push printLine_0
  4037 000016EC E80401                   call prs
  4038 000016EF 83C402                   add  sp, 2
  4039 000016F2 FF36[3900]               push word [PCStart]
  4040 000016F6 E8EB01                   call printhex16
  4041 000016F9 83C402                   add  sp, 2
  4042                                  
  4043                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  4044                                  
  4045 000016FC A1[4A00]                 mov ax, [OpPrintIndex]
  4046 000016FF 83F800                   cmp ax, 0
  4047 00001702 0F850C00                 jne @@printLine177
  4048 00001706 68[7D17]                 push printLine_1
  4049 00001709 E8E700                   call prs
  4050 0000170C 83C402                   add  sp, 2
  4051                                  
  4052                                  ;-4   else {
  4053                                  
  4054 0000170F E95B00                   jmp @@printLine178
  4055                                  @@printLine177:
  4056                                  
  4057                                  ;-5     prc(PrReloc);
  4058                                  
  4059 00001712 A0[4E00]                 mov al, byte [PrReloc]
  4060 00001715 B400                     mov ah, 0
  4061 00001717 50                       push ax
  4062 00001718 E87700                   call prc
  4063 0000171B 83C402                   add  sp, 2
  4064                                  
  4065                                  ;-6     i=0;
  4066                                  
  4067 0000171E 66B800000000             mov eax, 0
  4068 00001724 8946FE                   mov word [bp-2], ax
  4069                                  
  4070                                  ;-7     do {
  4071                                  
  4072                                  @@printLine179:
  4073                                  
  4074                                  ;-8       c=OpPos[i];
  4075                                  
  4076 00001727 8B5EFE                   mov bx, [bp-2]
  4077 0000172A 8A87B676                 mov al, [OpPos + bx]
  4078 0000172E 8846FC                   mov byte [bp-4], al
  4079                                  
  4080                                  ;-9       printhex8a(c); prc(' ');
  4081                                  
  4082 00001731 8A46FC                   mov al, byte [bp-4]
  4083 00001734 B400                     mov ah, 0
  4084 00001736 50                       push ax
  4085 00001737 E85C01                   call printhex8a
  4086 0000173A 83C402                   add  sp, 2
  4087 0000173D 6A20                     push 32
  4088 0000173F E85000                   call prc
  4089 00001742 83C402                   add  sp, 2
  4090                                  
  4091                                  ;-10       i++;
  4092                                  
  4093 00001745 FF46FE                   inc  word [bp-2]
  4094                                  
  4095                                  ;-11     } while(i < OpPrintIndex);
  4096                                  
  4097 00001748 8B46FE                   mov ax, [bp-2]
  4098 0000174B 3B06[4A00]               cmp ax, [OpPrintIndex]
  4099 0000174F 0F8D0200                 jge @@printLine180
  4100 00001753 EBD2                     jmp @@printLine179
  4101                                  @@printLine180:
  4102                                  
  4103                                  ;-12     do {// fill rest with blank
  4104                                  
  4105                                  @@printLine181:
  4106                                  
  4107                                  ;-13       prs("   ");
  4108                                  
  4109 00001755 68[8E17]                 push printLine_2
  4110 00001758 E89800                   call prs
  4111 0000175B 83C402                   add  sp, 2
  4112                                  
  4113                                  ;-14       i++;
  4114                                  
  4115 0000175E FF46FE                   inc  word [bp-2]
  4116                                  
  4117                                  ;-15     } while(i < OPMAXLEN);
  4118                                  
  4119 00001761 8B46FE                   mov ax, [bp-2]
  4120 00001764 83F805                   cmp ax, 5
  4121 00001767 0F8D0200                 jge @@printLine182
  4122 0000176B EBE8                     jmp @@printLine181
  4123                                  @@printLine182:
  4124                                  
  4125                                  ;-16   }
  4126                                  
  4127                                  
  4128                                  ;-17   prscomment(InputBuf);
  4129                                  
  4130                                  @@printLine178:
  4131 0000176D 8D066E75                 lea  ax, [InputBuf]
  4132 00001771 50                       push ax
  4133 00001772 E85000                   call prscomment
  4134 00001775 83C402                   add  sp, 2
  4135                                  
  4136                                  ;-18 }
  4137                                  
  4138                                  
  4139                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4140 00001778 C9                       LEAVE
  4141 00001779 C3                       ret
  4142                                  ; ENDP
  4143 0000177A 5C6E00                  printLine_0 db "\n",0
  4144 0000177D 202020202020202020-     printLine_1 db "                ",0
  4145 00001786 2020202020202000   
  4146 0000178E 20202000                printLine_2 db "   ",0
  4147                                  
  4148                                  prc:  ; *** PROC ***
  4149                                  ;Function : prc, Number of local variables: 1
  4150                                  ;   # type sign width line used address name   list of local variables
  4151                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4152 00001792 C8000000                 ENTER  0,0
  4153 00001796 A0[2500]                 mov al, [LIST]
  4154 00001799 08C0                     or  al, al
  4155 0000179B 0F841400                 je @@prc183
  4156 0000179F 807E040A                cmp byte [bp+4], 10
  4157 000017A3 0F850600                 jne @@prc184
  4158 000017A7 B80D00                   mov  ax, 13
  4159 000017AA E81A07                   call writetty
  4160                                  
  4161                                  ;-20      al=c; writetty(); }
  4162                                  
  4163                                  @@prc184:
  4164 000017AD 8A4604                   mov  al, [bp+4]
  4165 000017B0 E81407                   call writetty
  4166                                  
  4167                                  ;-21    fputcR(c,lst_fd); }
  4168                                  
  4169                                  @@prc183:
  4170 000017B3 FF36[2C00]               push word [lst_fd]
  4171 000017B7 8A4604                   mov al, byte [bp+4]
  4172 000017BA B400                     mov ah, 0
  4173 000017BC 50                       push ax
  4174 000017BD E8C708                   call fputcR
  4175 000017C0 83C404                   add  sp, 4
  4176                                  
  4177                                  ;-22 
  4178                                  
  4179                                  
  4180                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4181 000017C3 C9                       LEAVE
  4182 000017C4 C3                       ret
  4183                                  ; ENDP
  4184                                  
  4185                                  prscomment:  ; *** PROC ***
  4186                                  
  4187                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4188                                  
  4189                                  ;Function : prscomment, Number of local variables: 2
  4190                                  ;   # type sign width line used address name   list of local variables
  4191                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4192                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4193 000017C5 C8020000                 ENTER  2,0
  4194                                  @@prscomment185:
  4195 000017C9 8B5E04                   mov bx, [bp+4]
  4196 000017CC 8A07                     mov al, [bx]
  4197 000017CE B400                     mov ah, 0
  4198 000017D0 08C0                     or  al, al
  4199 000017D2 0F841B00                 je @@prscomment186
  4200 000017D6 8B5E04                   mov bx, [bp+4]
  4201 000017D9 8A07                     mov al, [bx]
  4202 000017DB B400                     mov ah, 0
  4203 000017DD 8846FE                   mov byte [bp-2], al
  4204 000017E0 8A46FE                   mov al, byte [bp-2]
  4205 000017E3 B400                     mov ah, 0
  4206 000017E5 50                       push ax
  4207 000017E6 E8A9FF                   call prc
  4208 000017E9 83C402                   add  sp, 2
  4209 000017EC FF4604                   inc  word [bp+4]
  4210                                  
  4211                                  ;-25 }
  4212                                  
  4213 000017EF EBD8                     jmp @@prscomment185
  4214                                  @@prscomment186:
  4215                                  
  4216                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4217 000017F1 C9                       LEAVE
  4218 000017F2 C3                       ret
  4219                                  ; ENDP
  4220                                  
  4221                                  prs:  ; *** PROC ***
  4222                                  ;Function : prs, Number of local variables: 3
  4223                                  ;   # type sign width line used address name   list of local variables
  4224                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4225                                  ;  201 var unsg byte    26 NULL bp-2    c
  4226                                  ;  202 var sign word    26 NULL bp-4    com;
  4227 000017F3 C8040000                 ENTER  4,0
  4228 000017F7 66B800000000             mov eax, 0
  4229 000017FD 8946FC                   mov word [bp-4], ax
  4230                                  
  4231                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4232                                  
  4233                                  @@prs187:
  4234 00001800 8B5E04                   mov bx, [bp+4]
  4235 00001803 8A07                     mov al, [bx]
  4236 00001805 B400                     mov ah, 0
  4237 00001807 08C0                     or  al, al
  4238 00001809 0F848700                 je @@prs188
  4239 0000180D 8B5E04                   mov bx, [bp+4]
  4240 00001810 8A07                     mov al, [bx]
  4241 00001812 B400                     mov ah, 0
  4242 00001814 8846FE                   mov byte [bp-2], al
  4243 00001817 8A46FE                   mov al, [bp-2]
  4244 0000181A 3C22                     cmp al, 34
  4245 0000181C 0F851E00                 jne @@prs189
  4246 00001820 8B46FC                   mov ax, [bp-4]
  4247 00001823 08C0                     or  al, al
  4248 00001825 0F840C00                 je @@prs190
  4249 00001829 66B800000000             mov eax, 0
  4250 0000182F 8946FC                   mov word [bp-4], ax
  4251 00001832 E90900                   jmp @@prs191
  4252                                  @@prs190:
  4253 00001835 66B801000000             mov eax, 1
  4254 0000183B 8946FC                   mov word [bp-4], ax
  4255                                  
  4256                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4257                                  
  4258                                  @@prs191:
  4259                                  @@prs189:
  4260 0000183E 8A46FE                   mov al, [bp-2]
  4261 00001841 3C5C                     cmp al, 92
  4262 00001843 0F853B00                 jne @@prs192
  4263 00001847 8B46FC                   mov ax, [bp-4]
  4264 0000184A 83F800                   cmp ax, 0
  4265 0000184D 0F853100                 jne @@prs193
  4266 00001851 FF4604                   inc  word [bp+4]
  4267 00001854 8B5E04                   mov bx, [bp+4]
  4268 00001857 8A07                     mov al, [bx]
  4269 00001859 B400                     mov ah, 0
  4270 0000185B 8846FE                   mov byte [bp-2], al
  4271                                  
  4272                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4273                                  
  4274 0000185E 8A46FE                   mov al, [bp-2]
  4275 00001861 3C6E                     cmp al, 110
  4276 00001863 0F850900                 jne @@prs194
  4277 00001867 66B80A000000             mov eax, 10
  4278 0000186D 8846FE                   mov byte [bp-2], al
  4279                                  @@prs194:
  4280 00001870 8A46FE                   mov al, [bp-2]
  4281 00001873 3C74                     cmp al, 116
  4282 00001875 0F850900                 jne @@prs195
  4283 00001879 66B809000000             mov eax, 9
  4284 0000187F 8846FE                   mov byte [bp-2], al
  4285                                  @@prs195:
  4286                                  @@prs193:
  4287                                  @@prs192:
  4288 00001882 8A46FE                   mov al, byte [bp-2]
  4289 00001885 B400                     mov ah, 0
  4290 00001887 50                       push ax
  4291 00001888 E807FF                   call prc
  4292 0000188B 83C402                   add  sp, 2
  4293 0000188E FF4604                   inc  word [bp+4]
  4294                                  
  4295                                  ;-30 }
  4296                                  
  4297 00001891 E96CFF                   jmp @@prs187
  4298                                  @@prs188:
  4299                                  
  4300                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4301 00001894 C9                       LEAVE
  4302 00001895 C3                       ret
  4303                                  ; ENDP
  4304                                  
  4305                                  printhex8a:  ; *** PROC ***
  4306                                  
  4307                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4308                                  
  4309                                  ;Function : printhex8a, Number of local variables: 2
  4310                                  ;   # type sign width line used address name   list of local variables
  4311                                  ;  200 var unsg word    31 NULL bp+4    c
  4312                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4313 00001896 C8020000                 ENTER  2,0
  4314 0000189A 8B4604                   mov ax, [bp+4]
  4315 0000189D C1E804                   shr ax, 4
  4316 000018A0 8946FE                   mov word [bp-2], ax
  4317 000018A3 8346FE30                 add  word [bp-2], 48
  4318 000018A7 8B46FE                   mov ax, [bp-2]
  4319 000018AA 83F839                   cmp ax, 57
  4320 000018AD 0F8E0400                 jle @@printhex8a196
  4321 000018B1 8346FE07                 add  word [bp-2], 7
  4322                                  @@printhex8a196:
  4323 000018B5 FF76FE                   push word [bp-2]
  4324 000018B8 E8D7FE                   call prc
  4325 000018BB 83C402                   add  sp, 2
  4326                                  
  4327                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4328                                  
  4329 000018BE 8B4604                   mov ax, [bp+4]
  4330 000018C1 83E00F                   and ax, 15
  4331 000018C4 8946FE                   mov word [bp-2], ax
  4332 000018C7 8346FE30                 add  word [bp-2], 48
  4333 000018CB 8B46FE                   mov ax, [bp-2]
  4334 000018CE 83F839                   cmp ax, 57
  4335 000018D1 0F8E0400                 jle @@printhex8a197
  4336 000018D5 8346FE07                 add  word [bp-2], 7
  4337                                  @@printhex8a197:
  4338 000018D9 FF76FE                   push word [bp-2]
  4339 000018DC E8B3FE                   call prc
  4340 000018DF 83C402                   add  sp, 2
  4341                                  
  4342                                  ;-34 }
  4343                                  
  4344                                  
  4345                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4346 000018E2 C9                       LEAVE
  4347 000018E3 C3                       ret
  4348                                  ; ENDP
  4349                                  
  4350                                  printhex16:  ; *** PROC ***
  4351                                  
  4352                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4353                                  
  4354                                  ;Function : printhex16, Number of local variables: 2
  4355                                  ;   # type sign width line used address name   list of local variables
  4356                                  ;  200 var unsg word    35 NULL bp+4    i
  4357                                  ;  201 var unsg word    35 NULL bp-2    half;
  4358 000018E4 C8020000                 ENTER  2,0
  4359 000018E8 8B4604                   mov ax, [bp+4]
  4360 000018EB C1E808                   shr ax, 8
  4361 000018EE 8946FE                   mov word [bp-2], ax
  4362 000018F1 FF76FE                   push word [bp-2]
  4363 000018F4 E89FFF                   call printhex8a
  4364 000018F7 83C402                   add  sp, 2
  4365 000018FA 8B4604                   mov ax, [bp+4]
  4366 000018FD 25FF00                   and ax, 255
  4367 00001900 8946FE                   mov word [bp-2], ax
  4368 00001903 FF76FE                   push word [bp-2]
  4369 00001906 E88DFF                   call printhex8a
  4370 00001909 83C402                   add  sp, 2
  4371                                  
  4372                                  ;-37 }
  4373                                  
  4374                                  
  4375                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4376 0000190C C9                       LEAVE
  4377 0000190D C3                       ret
  4378                                  ; ENDP
  4379                                  
  4380                                  printIntU:  ; *** PROC ***
  4381                                  
  4382                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4383                                  
  4384                                  ;Function : printIntU, Number of local variables: 2
  4385                                  ;   # type sign width line used address name   list of local variables
  4386                                  ;  200 var unsg word    38 NULL bp+4    n
  4387                                  ;  201 var unsg word    38 NULL bp-2    e;
  4388 0000190E C8020000                 ENTER  2,0
  4389 00001912 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4390 00001916 0F821700                 jb  @@printIntU198
  4391 0000191A 8B4604                   mov ax, [bp+4]
  4392 0000191D BB0A00                   mov bx, 10
  4393 00001920 BA0000                   mov dx, 0
  4394 00001923 F7F3                     div bx
  4395 00001925 8946FE                   mov word [bp-2], ax
  4396                                  
  4397                                  ;-40     printIntU(e); }
  4398                                  
  4399 00001928 FF76FE                   push word [bp-2]
  4400 0000192B E8E0FF                   call printIntU
  4401 0000192E 83C402                   add  sp, 2
  4402                                  
  4403                                  ;-41     n = n % 10; //unsigned mod
  4404                                  
  4405                                  @@printIntU198:
  4406 00001931 8B4604                   mov ax, [bp+4]
  4407 00001934 BB0A00                   mov bx, 10
  4408 00001937 BA0000                   mov dx, 0
  4409 0000193A F7F3                     div bx
  4410 0000193C 89D0                     mov ax, dx
  4411 0000193E 894604                   mov word [bp+4], ax
  4412                                  
  4413                                  ;-42     n += '0'; prc(n);
  4414                                  
  4415 00001941 83460430                 add  word [bp+4], 48
  4416 00001945 FF7604                   push word [bp+4]
  4417 00001948 E847FE                   call prc
  4418 0000194B 83C402                   add  sp, 2
  4419                                  
  4420                                  ;-43 }
  4421                                  
  4422                                  
  4423                                  ;-44 
  4424                                  
  4425                                  
  4426                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4427 0000194E C9                       LEAVE
  4428 0000194F C3                       ret
  4429                                  ; ENDP
  4430                                  
  4431                                  error1:  ; *** PROC ***
  4432                                  ;Function : error1, Number of local variables: 1
  4433                                  ;   # type sign width line used address name   list of local variables
  4434                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4435 00001950 C8000000                 ENTER  0,0
  4436 00001954 66B801000000             mov eax, 1
  4437 0000195A A2[2500]                 mov byte [LIST], al
  4438 0000195D FF06[3200]               inc  word [ErrorCount]
  4439                                  
  4440                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4441                                  
  4442 00001961 68[8919]                 push error1_0
  4443 00001964 E88CFE                   call prs
  4444 00001967 83C402                   add  sp, 2
  4445 0000196A FF7604                   push word [bp+4]
  4446 0000196D E883FE                   call prs
  4447 00001970 83C402                   add  sp, 2
  4448                                  
  4449                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4450                                  
  4451 00001973 68[A419]                 push error1_1
  4452 00001976 E87AFE                   call prs
  4453 00001979 83C402                   add  sp, 2
  4454 0000197C 8D063075                 lea  ax, [Symbol]
  4455 00001980 50                       push ax
  4456 00001981 E86FFE                   call prs
  4457 00001984 83C402                   add  sp, 2
  4458                                  
  4459                                  ;-48 int allowederror(){error1("not allowed here"); }
  4460 00001987 C9                       LEAVE
  4461 00001988 C3                       ret
  4462                                  ; ENDP
  4463 00001989 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4464 00001992 6E657874206C696E65-
  4465 0000199B 204552524F523A2000 
  4466 000019A4 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4467 000019AD 2000               
  4468                                  
  4469                                  allowederror:  ; *** PROC ***
  4470 000019AF 68[B919]                 push allowederror_0
  4471 000019B2 E89BFF                   call error1
  4472 000019B5 83C402                   add  sp, 2
  4473                                  
  4474                                  ;-49 int implmerror(){error1("not implemented");}
  4475                                  
  4476 000019B8 C3                       ret
  4477                                  ; ENDP
  4478 000019B9 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4479 000019C2 6564206865726500   
  4480                                  
  4481                                  implmerror:  ; *** PROC ***
  4482 000019CA 68[D419]                 push implmerror_0
  4483 000019CD E880FF                   call error1
  4484 000019D0 83C402                   add  sp, 2
  4485                                  
  4486                                  ;-50 int indexerror (){error1("invalid index register");}
  4487                                  
  4488 000019D3 C3                       ret
  4489                                  ; ENDP
  4490 000019D4 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4491 000019DD 6D656E74656400     
  4492                                  
  4493                                  indexerror:  ; *** PROC ***
  4494 000019E4 68[EE19]                 push indexerror_0
  4495 000019E7 E866FF                   call error1
  4496 000019EA 83C402                   add  sp, 2
  4497                                  
  4498                                  ;-51 int numbererror(){error1("number expected");}
  4499                                  
  4500 000019ED C3                       ret
  4501                                  ; ENDP
  4502 000019EE 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4503 000019F7 6E6465782072656769-
  4504 00001A00 7374657200         
  4505                                  
  4506                                  numbererror:  ; *** PROC ***
  4507 00001A05 68[0F1A]                 push numbererror_0
  4508 00001A08 E845FF                   call error1
  4509 00001A0B 83C402                   add  sp, 2
  4510                                  
  4511                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4512                                  
  4513 00001A0E C3                       ret
  4514                                  ; ENDP
  4515 00001A0F 6E756D626572206578-     numbererror_0 db "number expected",0
  4516 00001A18 70656374656400     
  4517                                  
  4518                                  regmemerror:  ; *** PROC ***
  4519 00001A1F 68[291A]                 push regmemerror_0
  4520 00001A22 E82BFF                   call error1
  4521 00001A25 83C402                   add  sp, 2
  4522                                  
  4523                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4524                                  
  4525 00001A28 C3                       ret
  4526                                  ; ENDP
  4527 00001A29 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4528 00001A32 73746572206F72206D-
  4529 00001A3B 656D6F727920616C6C-
  4530 00001A44 6F77656400         
  4531                                  
  4532                                  segregerror:  ; *** PROC ***
  4533 00001A49 68[531A]                 push segregerror_0
  4534 00001A4C E801FF                   call error1
  4535 00001A4F 83C402                   add  sp, 2
  4536                                  
  4537                                  ;-54 int syntaxerror(){error1("syntax");}
  4538                                  
  4539 00001A52 C3                       ret
  4540                                  ; ENDP
  4541 00001A53 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4542 00001A5C 65676973746572206E-
  4543 00001A65 6F7420616C6C6F7765-
  4544 00001A6E 6400               
  4545                                  
  4546                                  syntaxerror:  ; *** PROC ***
  4547 00001A70 68[7A1A]                 push syntaxerror_0
  4548 00001A73 E8DAFE                   call error1
  4549 00001A76 83C402                   add  sp, 2
  4550                                  
  4551                                  ;-55 
  4552                                  
  4553                                  
  4554                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4555                                  
  4556 00001A79 C3                       ret
  4557                                  ; ENDP
  4558 00001A7A 73796E74617800          syntaxerror_0 db "syntax",0
  4559                                  
  4560                                  errorexit:  ; *** PROC ***
  4561                                  ;Function : errorexit, Number of local variables: 1
  4562                                  ;   # type sign width line used address name   list of local variables
  4563                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4564 00001A81 C8000000                 ENTER  0,0
  4565 00001A85 FF7604                   push word [bp+4]
  4566 00001A88 E8C5FE                   call error1
  4567 00001A8B 83C402                   add  sp, 2
  4568 00001A8E 6A01                     push 1
  4569 00001A90 E80704                   call end1
  4570 00001A93 83C402                   add  sp, 2
  4571                                  
  4572                                  ;-57 int addrexit(){errorexit("illegal address");}
  4573 00001A96 C9                       LEAVE
  4574 00001A97 C3                       ret
  4575                                  ; ENDP
  4576                                  
  4577                                  addrexit:  ; *** PROC ***
  4578 00001A98 68[A21A]                 push addrexit_0
  4579 00001A9B E8E3FF                   call errorexit
  4580 00001A9E 83C402                   add  sp, 2
  4581                                  
  4582                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4583                                  
  4584 00001AA1 C3                       ret
  4585                                  ; ENDP
  4586 00001AA2 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4587 00001AAB 64647265737300     
  4588                                  
  4589                                  internexit:  ; *** PROC ***
  4590 00001AB2 68[BC1A]                 push internexit_0
  4591 00001AB5 E8C9FF                   call errorexit
  4592 00001AB8 83C402                   add  sp, 2
  4593 00001ABB C3                       ret
  4594                                  ; ENDP
  4595 00001ABC 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4596 00001AC5 6D70696C6572206572-
  4597 00001ACE 726F7200           
  4598                                  ;Back to main program: AS.C
  4599                                  
  4600                                  ;-218 #include "MAIN.C"
  4601                                  
  4602                                  ;Use include file: MAIN.C
  4603                                  
  4604                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4605                                  
  4606                                  
  4607                                  getarg:  ; *** PROC ***
  4608                                  
  4609                                  ;-2   arglen1=*arglen;
  4610                                  
  4611                                  ;Function : getarg, Number of local variables: 3
  4612                                  ;   # type sign width line used address name   list of local variables
  4613                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4614                                  ;  201 var sign word     1 NULL bp-4    i
  4615                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4616 00001AD2 C8060000                 ENTER  6,0
  4617 00001AD6 8B1E[5700]               mov bx, [arglen]
  4618 00001ADA 8A07                     mov al, [bx]
  4619 00001ADC B400                     mov ah, 0
  4620 00001ADE 8946FE                   mov word [bp-2], ax
  4621                                  
  4622                                  ;-3   if (arglen1==0) {
  4623                                  
  4624 00001AE1 8B46FE                   mov ax, [bp-2]
  4625 00001AE4 83F800                   cmp ax, 0
  4626 00001AE7 0F851C00                 jne @@getarg199
  4627                                  
  4628                                  ;-4     cputs(Version1);
  4629                                  
  4630 00001AEB 8D06[1000]               lea  ax, [Version1]
  4631 00001AEF 50                       push ax
  4632 00001AF0 E8DC03                   call cputs
  4633 00001AF3 83C402                   add  sp, 2
  4634                                  
  4635                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4636                                  
  4637 00001AF6 68[971C]                 push getarg_0
  4638 00001AF9 E8D303                   call cputs
  4639 00001AFC 83C402                   add  sp, 2
  4640                                  
  4641                                  ;-6     exitR(3);
  4642                                  
  4643 00001AFF 6A03                     push 3
  4644 00001B01 E8A605                   call exitR
  4645 00001B04 83C402                   add  sp, 2
  4646                                  
  4647                                  ;-7   }
  4648                                  
  4649                                  
  4650                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4651                                  
  4652                                  @@getarg199:
  4653 00001B07 8B46FE                   mov ax, [bp-2]
  4654 00001B0A 058100                   add ax, 129
  4655 00001B0D 8946FC                   mov word [bp-4], ax
  4656 00001B10 66B800000000             mov eax, 0
  4657 00001B16 8B5EFC                   mov  bx, [bp-4]
  4658 00001B19 8907                     mov  [bx], ax
  4659 00001B1B FF4EFE                   dec  word [bp-2]
  4660                                  
  4661                                  ;-9   toupper(argv);
  4662                                  
  4663 00001B1E FF36[5900]               push word [argv]
  4664 00001B22 E8D803                   call toupper
  4665 00001B25 83C402                   add  sp, 2
  4666                                  
  4667                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4668                                  
  4669 00001B28 FF36[5900]               push word [argv]
  4670 00001B2C 8D06ED75                 lea  ax, [namein]
  4671 00001B30 50                       push ax
  4672 00001B31 E83704                   call strcpy
  4673 00001B34 83C404                   add  sp, 4
  4674 00001B37 68[BC1C]                 push getarg_1
  4675 00001B3A 8D06ED75                 lea  ax, [namein]
  4676 00001B3E 50                       push ax
  4677 00001B3F E8EA04                   call strcat1
  4678 00001B42 83C404                   add  sp, 4
  4679                                  
  4680                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4681                                  
  4682 00001B45 FF36[5900]               push word [argv]
  4683 00001B49 8D063076                 lea  ax, [namelst]
  4684 00001B4D 50                       push ax
  4685 00001B4E E81A04                   call strcpy
  4686 00001B51 83C404                   add  sp, 4
  4687 00001B54 68[BF1C]                 push getarg_2
  4688 00001B57 8D063076                 lea  ax, [namelst]
  4689 00001B5B 50                       push ax
  4690 00001B5C E8CD04                   call strcat1
  4691 00001B5F 83C404                   add  sp, 4
  4692                                  
  4693                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4694                                  
  4695 00001B62 FF36[5900]               push word [argv]
  4696 00001B66 8D067376                 lea  ax, [namebin]
  4697 00001B6A 50                       push ax
  4698 00001B6B E8FD03                   call strcpy
  4699 00001B6E 83C404                   add  sp, 4
  4700 00001B71 68[C41C]                 push getarg_3
  4701 00001B74 8D067376                 lea  ax, [namebin]
  4702 00001B78 50                       push ax
  4703 00001B79 E8B004                   call strcat1
  4704 00001B7C 83C404                   add  sp, 4
  4705                                  
  4706                                  ;-13 
  4707                                  
  4708                                  
  4709                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4710                                  
  4711 00001B7F 66B801000000             mov eax, 1
  4712 00001B85 A2[2500]                 mov byte [LIST], al
  4713 00001B88 66B800000000             mov eax, 0
  4714 00001B8E A3[3000]                 mov word [DOS_ERR], ax
  4715 00001B91 66B800000000             mov eax, 0
  4716 00001B97 A3[3700]                 mov word [PC], ax
  4717 00001B9A 66B800000000             mov eax, 0
  4718 00001BA0 A3[3200]                 mov word [ErrorCount], ax
  4719                                  
  4720                                  ;-15   asm_fd=openR (namein);
  4721                                  
  4722 00001BA3 8D06ED75                 lea  ax, [namein]
  4723 00001BA7 50                       push ax
  4724 00001BA8 E8A604                   call openR
  4725 00001BAB 83C402                   add  sp, 2
  4726 00001BAE A3[2A00]                 mov word [asm_fd], ax
  4727                                  
  4728                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4729                                  
  4730 00001BB1 A1[3000]                 mov ax, [DOS_ERR]
  4731 00001BB4 08C0                     or  al, al
  4732 00001BB6 0F841C00                 je @@getarg200
  4733 00001BBA 68[C91C]                 push getarg_4
  4734 00001BBD E80F03                   call cputs
  4735 00001BC0 83C402                   add  sp, 2
  4736 00001BC3 8D06ED75                 lea  ax, [namein]
  4737 00001BC7 50                       push ax
  4738 00001BC8 E80403                   call cputs
  4739 00001BCB 83C402                   add  sp, 2
  4740 00001BCE 6A01                     push 1
  4741 00001BD0 E8D704                   call exitR
  4742 00001BD3 83C402                   add  sp, 2
  4743                                  
  4744                                  ;-17   lst_fd=creatR(namelst);
  4745                                  
  4746                                  @@getarg200:
  4747 00001BD6 8D063076                 lea  ax, [namelst]
  4748 00001BDA 50                       push ax
  4749 00001BDB E88204                   call creatR
  4750 00001BDE 83C402                   add  sp, 2
  4751 00001BE1 A3[2C00]                 mov word [lst_fd], ax
  4752                                  
  4753                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4754                                  
  4755 00001BE4 A1[3000]                 mov ax, [DOS_ERR]
  4756 00001BE7 08C0                     or  al, al
  4757 00001BE9 0F841C00                 je @@getarg201
  4758 00001BED 68[DF1C]                 push getarg_5
  4759 00001BF0 E8DC02                   call cputs
  4760 00001BF3 83C402                   add  sp, 2
  4761 00001BF6 8D063076                 lea  ax, [namelst]
  4762 00001BFA 50                       push ax
  4763 00001BFB E8D102                   call cputs
  4764 00001BFE 83C402                   add  sp, 2
  4765 00001C01 6A02                     push 2
  4766 00001C03 E8A404                   call exitR
  4767 00001C06 83C402                   add  sp, 2
  4768                                  
  4769                                  ;-19   bin_fd=creatR(namebin);
  4770                                  
  4771                                  @@getarg201:
  4772 00001C09 8D067376                 lea  ax, [namebin]
  4773 00001C0D 50                       push ax
  4774 00001C0E E84F04                   call creatR
  4775 00001C11 83C402                   add  sp, 2
  4776 00001C14 A3[2E00]                 mov word [bin_fd], ax
  4777                                  
  4778                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4779                                  
  4780 00001C17 A1[3000]                 mov ax, [DOS_ERR]
  4781 00001C1A 08C0                     or  al, al
  4782 00001C1C 0F841C00                 je @@getarg202
  4783 00001C20 68[F61C]                 push getarg_6
  4784 00001C23 E8A902                   call cputs
  4785 00001C26 83C402                   add  sp, 2
  4786 00001C29 8D067376                 lea  ax, [namebin]
  4787 00001C2D 50                       push ax
  4788 00001C2E E89E02                   call cputs
  4789 00001C31 83C402                   add  sp, 2
  4790 00001C34 6A02                     push 2
  4791 00001C36 E87104                   call exitR
  4792 00001C39 83C402                   add  sp, 2
  4793                                  
  4794                                  ;-21   prs(";");prs(Version1);
  4795                                  
  4796                                  @@getarg202:
  4797 00001C3C 68[0C1D]                 push getarg_7
  4798 00001C3F E8B1FB                   call prs
  4799 00001C42 83C402                   add  sp, 2
  4800 00001C45 8D06[1000]               lea  ax, [Version1]
  4801 00001C49 50                       push ax
  4802 00001C4A E8A6FB                   call prs
  4803 00001C4D 83C402                   add  sp, 2
  4804                                  
  4805                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4806                                  
  4807 00001C50 68[0E1D]                 push getarg_8
  4808 00001C53 E89DFB                   call prs
  4809 00001C56 83C402                   add  sp, 2
  4810 00001C59 8D06ED75                 lea  ax, [namein]
  4811 00001C5D 50                       push ax
  4812 00001C5E E892FB                   call prs
  4813 00001C61 83C402                   add  sp, 2
  4814 00001C64 68[191D]                 push getarg_9
  4815 00001C67 E889FB                   call prs
  4816 00001C6A 83C402                   add  sp, 2
  4817 00001C6D 8D063076                 lea  ax, [namelst]
  4818 00001C71 50                       push ax
  4819 00001C72 E87EFB                   call prs
  4820 00001C75 83C402                   add  sp, 2
  4821                                  
  4822                                  ;-23   prs(", "); prs(namebin);
  4823                                  
  4824 00001C78 68[241D]                 push getarg_10
  4825 00001C7B E875FB                   call prs
  4826 00001C7E 83C402                   add  sp, 2
  4827 00001C81 8D067376                 lea  ax, [namebin]
  4828 00001C85 50                       push ax
  4829 00001C86 E86AFB                   call prs
  4830 00001C89 83C402                   add  sp, 2
  4831                                  
  4832                                  ;-24   prs("\n");
  4833                                  
  4834 00001C8C 68[271D]                 push getarg_11
  4835 00001C8F E861FB                   call prs
  4836 00001C92 83C402                   add  sp, 2
  4837                                  
  4838                                  ;-25 }
  4839                                  
  4840                                  
  4841                                  ;-26 int epilog() { int i; int j; char c;
  4842 00001C95 C9                       LEAVE
  4843 00001C96 C3                       ret
  4844                                  ; ENDP
  4845 00001C97 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4846 00001CA0 41532E434F4D206669-
  4847 00001CA9 6C656E616D65205B77-
  4848 00001CB2 2F6F202E535D203A20-
  4849 00001CBB 00                 
  4850 00001CBC 2E5300                  getarg_1 db ".S",0
  4851 00001CBF 2E4C535400              getarg_2 db ".LST",0
  4852 00001CC4 2E434F4D00              getarg_3 db ".COM",0
  4853 00001CC9 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4854 00001CD2 6C65206D697373696E-
  4855 00001CDB 673A2000           
  4856 00001CDF 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4857 00001CE8 206E6F742063726561-
  4858 00001CF1 74653A2000         
  4859 00001CF6 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4860 00001CFF 6E6F74206372656174-
  4861 00001D08 653A2000           
  4862 00001D0C 3B00                    getarg_7 db ";",0
  4863 00001D0E 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4864 00001D17 2000               
  4865 00001D19 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4866 00001D22 2000               
  4867 00001D24 2C2000                  getarg_10 db ", ",0
  4868 00001D27 5C6E00                  getarg_11 db "\n",0
  4869                                  
  4870                                  epilog:  ; *** PROC ***
  4871                                  
  4872                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4873                                  
  4874                                  ;Function : epilog, Number of local variables: 3
  4875                                  ;   # type sign width line used address name   list of local variables
  4876                                  ;  200 var sign word    26 NULL bp-2    i
  4877                                  ;  201 var sign word    26 NULL bp-4    j
  4878                                  ;  202 var sign byte    26 NULL bp-6    c;
  4879 00001D2A C8060000                 ENTER  6,0
  4880 00001D2E 68[531E]                 push epilog_0
  4881 00001D31 E8BFFA                   call prs
  4882 00001D34 83C402                   add  sp, 2
  4883 00001D37 FF36[3200]               push word [ErrorCount]
  4884 00001D3B E8D0FB                   call printIntU
  4885 00001D3E 83C402                   add  sp, 2
  4886                                  
  4887                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4888                                  
  4889 00001D41 A1[3200]                 mov ax, [ErrorCount]
  4890 00001D44 08C0                     or  al, al
  4891 00001D46 0F840900                 je @@epilog203
  4892 00001D4A 68[631E]                 push epilog_1
  4893 00001D4D E8A3FA                   call prs
  4894 00001D50 83C402                   add  sp, 2
  4895                                  
  4896                                  ;-29   prs(", Label & Var: ");
  4897                                  
  4898                                  @@epilog203:
  4899 00001D53 68[711E]                 push epilog_2
  4900 00001D56 E89AFA                   call prs
  4901 00001D59 83C402                   add  sp, 2
  4902                                  
  4903                                  ;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4904                                  
  4905                                  
  4906                                  ;-31   i= &LabelNames;
  4907                                  
  4908                                  
  4909                                  ;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4910                                  
  4911                                  
  4912                                  ;-33   } while (i < LabelNamePtr); prs("<< \n"); */
  4913                                  
  4914                                  
  4915                                  ;-34   if (LabelMaxIx) {
  4916                                  
  4917 00001D5C A1[5100]                 mov ax, [LabelMaxIx]
  4918 00001D5F 08C0                     or  al, al
  4919 00001D61 0F846900                 je @@epilog204
  4920                                  
  4921                                  ;-35     i = 1;
  4922                                  
  4923 00001D65 66B801000000             mov eax, 1
  4924 00001D6B 8946FE                   mov word [bp-2], ax
  4925                                  
  4926                                  ;-36     LabelNamePtr= &LabelNames;
  4927                                  
  4928 00001D6E B8BB76                   mov ax, LabelNames
  4929 00001D71 A3[4F00]                 mov word [LabelNamePtr], ax
  4930                                  
  4931                                  ;-37     do {
  4932                                  
  4933                                  @@epilog205:
  4934                                  
  4935                                  ;-38       prs(LabelNamePtr); prc(' ');
  4936                                  
  4937 00001D74 FF36[4F00]               push word [LabelNamePtr]
  4938 00001D78 E878FA                   call prs
  4939 00001D7B 83C402                   add  sp, 2
  4940 00001D7E 6A20                     push 32
  4941 00001D80 E80FFA                   call prc
  4942 00001D83 83C402                   add  sp, 2
  4943                                  
  4944                                  ;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4945                                  
  4946 00001D86 8B5EFE                   mov bx, [bp-2]
  4947 00001D89 D1E3                     shl bx, 1
  4948 00001D8B 8B87A37A                 mov ax, [LabelAddr + bx]
  4949 00001D8F 8946FC                   mov word [bp-4], ax
  4950 00001D92 FF76FC                   push word [bp-4]
  4951 00001D95 E84CFB                   call printhex16
  4952 00001D98 83C402                   add  sp, 2
  4953 00001D9B 68[811E]                 push epilog_3
  4954 00001D9E E852FA                   call prs
  4955 00001DA1 83C402                   add  sp, 2
  4956                                  
  4957                                  ;-40       j=strlen(LabelNamePtr);//get end of actual name
  4958                                  
  4959 00001DA4 FF36[4F00]               push word [LabelNamePtr]
  4960 00001DA8 E89501                   call strlen
  4961 00001DAB 83C402                   add  sp, 2
  4962 00001DAE 8946FC                   mov word [bp-4], ax
  4963                                  
  4964                                  ;-41       LabelNamePtr=LabelNamePtr+j;
  4965                                  
  4966 00001DB1 A1[4F00]                 mov ax, [LabelNamePtr]
  4967 00001DB4 0346FC                   add ax, [bp-4]
  4968 00001DB7 A3[4F00]                 mov word [LabelNamePtr], ax
  4969                                  
  4970                                  ;-42       LabelNamePtr++;
  4971                                  
  4972 00001DBA FF06[4F00]               inc  word [LabelNamePtr]
  4973                                  
  4974                                  ;-43       i++;
  4975                                  
  4976 00001DBE FF46FE                   inc  word [bp-2]
  4977                                  
  4978                                  ;-44     } while (i <= LabelMaxIx);
  4979                                  
  4980 00001DC1 8B46FE                   mov ax, [bp-2]
  4981 00001DC4 3B06[5100]               cmp ax, [LabelMaxIx]
  4982 00001DC8 0F8F0200                 jg  @@epilog206
  4983 00001DCC EBA6                     jmp @@epilog205
  4984                                  @@epilog206:
  4985                                  
  4986                                  ;-45   }
  4987                                  
  4988                                  
  4989                                  ;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4990                                  
  4991                                  @@epilog204:
  4992 00001DCE 68[851E]                 push epilog_4
  4993 00001DD1 E81FFA                   call prs
  4994 00001DD4 83C402                   add  sp, 2
  4995 00001DD7 FF36[5500]               push word [BinLen]
  4996 00001DDB E830FB                   call printIntU
  4997 00001DDE 83C402                   add  sp, 2
  4998 00001DE1 68[921E]                 push epilog_5
  4999 00001DE4 E80CFA                   call prs
  5000 00001DE7 83C402                   add  sp, 2
  5001                                  
  5002                                  ;-47   i=0;
  5003                                  
  5004 00001DEA 66B800000000             mov eax, 0
  5005 00001DF0 8946FE                   mov word [bp-2], ax
  5006                                  
  5007                                  ;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  5008                                  
  5009                                  @@epilog207:
  5010 00001DF3 6A20                     push 32
  5011 00001DF5 E89AF9                   call prc
  5012 00001DF8 83C402                   add  sp, 2
  5013 00001DFB 8B5EFE                   mov bx, [bp-2]
  5014 00001DFE 8A876B7B                 mov al, [FileBin + bx]
  5015 00001E02 8946FC                   mov word [bp-4], ax
  5016 00001E05 FF76FC                   push word [bp-4]
  5017 00001E08 E88BFA                   call printhex8a
  5018 00001E0B 83C402                   add  sp, 2
  5019 00001E0E FF46FE                   inc  word [bp-2]
  5020                                  
  5021                                  ;-49   } while (i < BinLen);
  5022                                  
  5023 00001E11 8B46FE                   mov ax, [bp-2]
  5024 00001E14 3B06[5500]               cmp ax, [BinLen]
  5025 00001E18 0F8D0200                 jge @@epilog208
  5026 00001E1C EBD5                     jmp @@epilog207
  5027                                  @@epilog208:
  5028                                  
  5029                                  ;-50   i=0;
  5030                                  
  5031 00001E1E 66B800000000             mov eax, 0
  5032 00001E24 8946FE                   mov word [bp-2], ax
  5033                                  
  5034                                  ;-51   do {
  5035                                  
  5036                                  @@epilog209:
  5037                                  
  5038                                  ;-52     c = FileBin[i];
  5039                                  
  5040 00001E27 8B5EFE                   mov bx, [bp-2]
  5041 00001E2A 8A876B7B                 mov al, [FileBin + bx]
  5042 00001E2E 8846FA                   mov byte [bp-6], al
  5043                                  
  5044                                  ;-53     fputcR(c, bin_fd);
  5045                                  
  5046 00001E31 FF36[2E00]               push word [bin_fd]
  5047 00001E35 8A46FA                   mov al, byte [bp-6]
  5048 00001E38 B400                     mov ah, 0
  5049 00001E3A 50                       push ax
  5050 00001E3B E84902                   call fputcR
  5051 00001E3E 83C404                   add  sp, 4
  5052                                  
  5053                                  ;-54     i++;
  5054                                  
  5055 00001E41 FF46FE                   inc  word [bp-2]
  5056                                  
  5057                                  ;-55   } while (i < BinLen);
  5058                                  
  5059 00001E44 8B46FE                   mov ax, [bp-2]
  5060 00001E47 3B06[5500]               cmp ax, [BinLen]
  5061 00001E4B 0F8D0200                 jge @@epilog210
  5062 00001E4F EBD6                     jmp @@epilog209
  5063                                  @@epilog210:
  5064                                  
  5065                                  ;-56 }
  5066                                  
  5067                                  
  5068                                  ;-57 int end1(int n) {
  5069 00001E51 C9                       LEAVE
  5070 00001E52 C3                       ret
  5071                                  ; ENDP
  5072 00001E53 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5073 00001E5C 726F72733A2000     
  5074 00001E63 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5075 00001E6C 2A2A2A2000         
  5076 00001E71 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  5077 00001E7A 205661723A2000     
  5078 00001E81 2C202000                epilog_3 db ",  ",0
  5079 00001E85 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  5080 00001E8E 6C652000           
  5081 00001E92 2062797465733A00        epilog_5 db " bytes:",0
  5082                                  
  5083                                  end1:  ; *** PROC ***
  5084                                  
  5085                                  ;-58   fcloseR(asm_fd);
  5086                                  
  5087                                  ;Function : end1, Number of local variables: 1
  5088                                  ;   # type sign width line used address name   list of local variables
  5089                                  ;  200 var sign word    57 NULL bp+4    n;
  5090 00001E9A C8000000                 ENTER  0,0
  5091 00001E9E FF36[2A00]               push word [asm_fd]
  5092 00001EA2 E8F701                   call fcloseR
  5093 00001EA5 83C402                   add  sp, 2
  5094                                  
  5095                                  ;-59   fcloseR(lst_fd);
  5096                                  
  5097 00001EA8 FF36[2C00]               push word [lst_fd]
  5098 00001EAC E8ED01                   call fcloseR
  5099 00001EAF 83C402                   add  sp, 2
  5100                                  
  5101                                  ;-60   fcloseR(bin_fd);
  5102                                  
  5103 00001EB2 FF36[2E00]               push word [bin_fd]
  5104 00001EB6 E8E301                   call fcloseR
  5105 00001EB9 83C402                   add  sp, 2
  5106                                  
  5107                                  ;-61   exitR(n);
  5108                                  
  5109 00001EBC FF7604                   push word [bp+4]
  5110 00001EBF E8E801                   call exitR
  5111 00001EC2 83C402                   add  sp, 2
  5112                                  
  5113                                  ;-62 }
  5114 00001EC5 C9                       LEAVE
  5115 00001EC6 C3                       ret
  5116                                  ; ENDP
  5117                                  ;Back to main program: AS.C
  5118                                   
  5119                                  ; missing functions: 
  5120                                  ; digit
  5121                                  ; strcpy
  5122                                  ; eqstr
  5123                                  ; strlen
  5124                                  ; eqstr
  5125                                  ; eqstr
  5126                                  ; eqstr
  5127                                  ; eqstr
  5128                                  ; readRL
  5129                                  ; readRL
  5130                                  ; digit
  5131                                  ; digit
  5132                                  ; strcpy
  5133                                  ; toupper
  5134                                  ; strlen
  5135                                  ; strlen
  5136                                  ; eqstr
  5137                                  ; eqstr
  5138                                  ; eqstr
  5139                                  ; eqstr
  5140                                  ; eqstr
  5141                                  ; eqstr
  5142                                  ; eqstr
  5143                                  ; eqstr
  5144                                  ; eqstr
  5145                                  ; eqstr
  5146                                  ; eqstr
  5147                                  ; eqstr
  5148                                  ; eqstr
  5149                                  ; eqstr
  5150                                  ; eqstr
  5151                                  ; eqstr
  5152                                  ; eqstr
  5153                                  ; eqstr
  5154                                  ; eqstr
  5155                                  ; eqstr
  5156                                  ; eqstr
  5157                                  ; eqstr
  5158                                  ; eqstr
  5159                                  ; eqstr
  5160                                  ; eqstr
  5161                                  ; eqstr
  5162                                  ; eqstr
  5163                                  ; eqstr
  5164                                  ; eqstr
  5165                                  ; eqstr
  5166                                  ; writetty
  5167                                  ; writetty
  5168                                  ; fputcR
  5169                                  ; cputs
  5170                                  ; cputs
  5171                                  ; exitR
  5172                                  ; toupper
  5173                                  ; strcpy
  5174                                  ; strcat1
  5175                                  ; strcpy
  5176                                  ; strcat1
  5177                                  ; strcpy
  5178                                  ; strcat1
  5179                                  ; openR
  5180                                  ; cputs
  5181                                  ; cputs
  5182                                  ; exitR
  5183                                  ; creatR
  5184                                  ; cputs
  5185                                  ; cputs
  5186                                  ; exitR
  5187                                  ; creatR
  5188                                  ; cputs
  5189                                  ; cputs
  5190                                  ; exitR
  5191                                  ; strlen
  5192                                  ; fputcR
  5193                                  ; fcloseR
  5194                                  ; fcloseR
  5195                                  ; fcloseR
  5196                                  ; exitR
  5197                                  ; Number of unresolved CALLs :   77
  5198                                  ;use archive file: AR.C
  5199                                  
  5200                                  ;-219 // AR.C Archive
  5201                                  
  5202                                  ;Number of CALLs:    2 : writetty
  5203                                  
  5204                                  writetty:  ; *** PROC ***
  5205 00001EC7 B40E                     mov  ah, 14
  5206 00001EC9 BB0000                   mov  bx, 0
  5207 00001ECC CD10                     int  16
  5208                                  
  5209                                  ;-220 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5210                                  
  5211 00001ECE C3                       ret
  5212                                  ; ENDP
  5213                                  ;Number of CALLs:    8 : cputs
  5214                                  
  5215                                  cputs:  ; *** PROC ***
  5216                                  ;Function : cputs, Number of local variables: 2
  5217                                  ;   # type sign width line used address name   list of local variables
  5218                                  ;  200 ptr sign byte   220 NULL bp+4    s
  5219                                  ;  201 var sign byte   220 NULL bp-2    c;
  5220 00001ECF C8020000                 ENTER  2,0
  5221                                  @@cputs211:
  5222 00001ED3 8B5E04                   mov bx, [bp+4]
  5223 00001ED6 8A07                     mov al, [bx]
  5224 00001ED8 B400                     mov ah, 0
  5225 00001EDA 08C0                     or  al, al
  5226 00001EDC 0F841B00                 je @@cputs212
  5227 00001EE0 8B5E04                   mov bx, [bp+4]
  5228 00001EE3 8A07                     mov al, [bx]
  5229 00001EE5 B400                     mov ah, 0
  5230 00001EE7 8846FE                   mov byte [bp-2], al
  5231 00001EEA 8A46FE                   mov al, byte [bp-2]
  5232 00001EED B400                     mov ah, 0
  5233 00001EEF 50                       push ax
  5234 00001EF0 E8C401                   call putch
  5235 00001EF3 83C402                   add  sp, 2
  5236 00001EF6 FF4604                   inc  word [bp+4]
  5237 00001EF9 EBD8                     jmp @@cputs211
  5238                                  @@cputs212:
  5239                                  
  5240                                  ;-221 int mkneg(int n) { n; __asm {neg ax} }
  5241 00001EFB C9                       LEAVE
  5242 00001EFC C3                       ret
  5243                                  ; ENDP
  5244                                  ;Number of CALLs:    2 : toupper
  5245                                  
  5246                                  toupper:  ; *** PROC ***
  5247                                  ;Function : toupper, Number of local variables: 1
  5248                                  ;   # type sign width line used address name   list of local variables
  5249                                  ;  200 ptr sign byte   221 NULL bp+4    s;
  5250 00001EFD C8000000                 ENTER  0,0
  5251                                  @@toupper213:
  5252 00001F01 8B5E04                   mov bx, [bp+4]
  5253 00001F04 8A07                     mov al, [bx]
  5254 00001F06 B400                     mov ah, 0
  5255 00001F08 08C0                     or  al, al
  5256 00001F0A 0F843000                 je @@toupper214
  5257 00001F0E 8B5E04                   mov bx, [bp+4]
  5258 00001F11 8A07                     mov al, [bx]
  5259 00001F13 B400                     mov ah, 0
  5260 00001F15 83F861                   cmp ax, 97 ;unsigned : 1
  5261 00001F18 0F8C1D00                 jl  @@toupper215
  5262 00001F1C 8B5E04                   mov bx, [bp+4]
  5263 00001F1F 8A07                     mov al, [bx]
  5264 00001F21 B400                     mov ah, 0
  5265 00001F23 83F87A                   cmp ax, 122
  5266 00001F26 0F8F0F00                 jg  @@toupper216
  5267 00001F2A 8B5E04                   mov bx, [bp+4]
  5268 00001F2D 8A07                     mov al, [bx]
  5269 00001F2F B400                     mov ah, 0
  5270 00001F31 83E820                   sub ax, 32
  5271 00001F34 8B5E04                   mov  bx, [bp+4]
  5272 00001F37 8807                     mov  [bx], al
  5273                                  @@toupper216:
  5274                                  @@toupper215:
  5275 00001F39 FF4604                   inc  word [bp+4]
  5276 00001F3C EBC3                     jmp @@toupper213
  5277                                  @@toupper214:
  5278                                  
  5279                                  ;-222 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5280                                  
  5281                                  
  5282                                  ;-223 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5283 00001F3E C9                       LEAVE
  5284 00001F3F C3                       ret
  5285                                  ; ENDP
  5286                                  ;Number of CALLs:    4 : strlen
  5287                                  
  5288                                  strlen:  ; *** PROC ***
  5289                                  ;Function : strlen, Number of local variables: 2
  5290                                  ;   # type sign width line used address name   list of local variables
  5291                                  ;  200 ptr sign byte   223 NULL bp+4    s
  5292                                  ;  201 var sign word   223 NULL bp-2    c;
  5293 00001F40 C8020000                 ENTER  2,0
  5294 00001F44 66B800000000             mov eax, 0
  5295 00001F4A 8946FE                   mov word [bp-2], ax
  5296                                  @@strlen217:
  5297 00001F4D 8B5E04                   mov bx, [bp+4]
  5298 00001F50 8A07                     mov al, [bx]
  5299 00001F52 B400                     mov ah, 0
  5300 00001F54 83F800                   cmp ax, 0
  5301 00001F57 0F840800                 je  @@strlen218
  5302 00001F5B FF4604                   inc  word [bp+4]
  5303 00001F5E FF46FE                   inc  word [bp-2]
  5304 00001F61 EBEA                     jmp @@strlen217
  5305                                  @@strlen218:
  5306 00001F63 8B46FE                   mov ax, [bp-2]
  5307 00001F66 E90000                   jmp @@retn
  5308                                  
  5309                                  ;-224 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5310                                  
  5311 00001F69 C9                      @@retn: LEAVE
  5312 00001F6A C3                       ret
  5313                                  ; ENDP
  5314                                  ;Number of CALLs:    5 : strcpy
  5315                                  
  5316                                  strcpy:  ; *** PROC ***
  5317                                  ;Function : strcpy, Number of local variables: 2
  5318                                  ;   # type sign width line used address name   list of local variables
  5319                                  ;  200 ptr sign byte   224 NULL bp+4    s
  5320                                  ;  201 ptr sign byte   224 NULL bp+6    t;
  5321 00001F6B C8000000                 ENTER  0,0
  5322                                  @@strcpy219:
  5323 00001F6F 8B5E06                   mov bx, [bp+6]
  5324 00001F72 8A07                     mov al, [bx]
  5325 00001F74 B400                     mov ah, 0
  5326 00001F76 8B5E04                   mov  bx, [bp+4]
  5327 00001F79 8807                     mov  [bx], al
  5328 00001F7B FF4604                   inc  word [bp+4]
  5329 00001F7E FF4606                   inc  word [bp+6]
  5330                                  
  5331                                  ;-225   while (*t!=0); *s=0; return s; }
  5332                                  
  5333 00001F81 8B5E06                   mov bx, [bp+6]
  5334 00001F84 8A07                     mov al, [bx]
  5335 00001F86 B400                     mov ah, 0
  5336 00001F88 83F800                   cmp ax, 0
  5337 00001F8B 0F840200                 je  @@strcpy220
  5338 00001F8F EBDE                     jmp @@strcpy219
  5339                                  @@strcpy220:
  5340 00001F91 66B800000000             mov eax, 0
  5341 00001F97 8B5E04                   mov  bx, [bp+4]
  5342 00001F9A 8807                     mov  [bx], al
  5343 00001F9C 8B4604                   mov ax, [bp+4]
  5344 00001F9F E90000                   jmp @@retn
  5345                                  
  5346                                  ;-226 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5347                                  
  5348 00001FA2 C9                      @@retn: LEAVE
  5349 00001FA3 C3                       ret
  5350                                  ; ENDP
  5351                                  ;Number of CALLs:    3 : digit
  5352                                  
  5353                                  digit:  ; *** PROC ***
  5354                                  ;Function : digit, Number of local variables: 1
  5355                                  ;   # type sign width line used address name   list of local variables
  5356                                  ;  200 var sign byte   226 NULL bp+4    c;
  5357 00001FA4 C8000000                 ENTER  0,0
  5358 00001FA8 8A4604                   mov al, [bp+4]
  5359 00001FAB 3C30                     cmp al, 48
  5360 00001FAD 0F8D0900                 jge @@digit221
  5361 00001FB1 66B800000000             mov eax, 0
  5362 00001FB7 E91B00                   jmp @@retn
  5363                                  @@digit221:
  5364 00001FBA 8A4604                   mov al, [bp+4]
  5365 00001FBD 3C39                     cmp al, 57
  5366 00001FBF 0F8E0900                 jle @@digit222
  5367 00001FC3 66B800000000             mov eax, 0
  5368 00001FC9 E90900                   jmp @@retn
  5369                                  @@digit222:
  5370 00001FCC 66B801000000             mov eax, 1
  5371 00001FD2 E90000                   jmp @@retn
  5372                                  
  5373                                  ;-227 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5374                                  
  5375 00001FD5 C9                      @@retn: LEAVE
  5376 00001FD6 C3                       ret
  5377                                  ; ENDP
  5378                                  ;Number of CALLs:   35 : eqstr
  5379                                  
  5380                                  eqstr:  ; *** PROC ***
  5381                                  ;Function : eqstr, Number of local variables: 2
  5382                                  ;   # type sign width line used address name   list of local variables
  5383                                  ;  200 ptr sign byte   227 NULL bp+4    p
  5384                                  ;  201 ptr sign byte   227 NULL bp+6    q;
  5385 00001FD7 C8000000                 ENTER  0,0
  5386                                  @@eqstr223:
  5387 00001FDB 8B5E04                   mov bx, [bp+4]
  5388 00001FDE 8A07                     mov al, [bx]
  5389 00001FE0 B400                     mov ah, 0
  5390 00001FE2 08C0                     or  al, al
  5391 00001FE4 0F842300                 je @@eqstr224
  5392                                  
  5393                                  ;-228     if (*p != *q) return 0; p++; q++; }
  5394                                  
  5395 00001FE8 8B5E04                   mov bx, [bp+4]
  5396 00001FEB 8A07                     mov al, [bx]
  5397 00001FED B400                     mov ah, 0
  5398 00001FEF 8B5E06                   mov bx, [bp+6]
  5399 00001FF2 3A07                     cmp al, [bx]
  5400 00001FF4 B400                     mov ah, 0
  5401 00001FF6 0F840900                 je  @@eqstr225
  5402 00001FFA 66B800000000             mov eax, 0
  5403 00002000 E92700                   jmp @@retn
  5404                                  @@eqstr225:
  5405 00002003 FF4604                   inc  word [bp+4]
  5406 00002006 FF4606                   inc  word [bp+6]
  5407                                  
  5408                                  ;-229     if(*q) return 0; return 1; }
  5409                                  
  5410 00002009 EBD0                     jmp @@eqstr223
  5411                                  @@eqstr224:
  5412 0000200B 8B5E06                   mov bx, [bp+6]
  5413 0000200E 8A07                     mov al, [bx]
  5414 00002010 B400                     mov ah, 0
  5415 00002012 08C0                     or  al, al
  5416 00002014 0F840900                 je @@eqstr226
  5417 00002018 66B800000000             mov eax, 0
  5418 0000201E E90900                   jmp @@retn
  5419                                  @@eqstr226:
  5420 00002021 66B801000000             mov eax, 1
  5421 00002027 E90000                   jmp @@retn
  5422                                  
  5423                                  ;-230 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5424                                  
  5425 0000202A C9                      @@retn: LEAVE
  5426 0000202B C3                       ret
  5427                                  ; ENDP
  5428                                  ;Number of CALLs:    3 : strcat1
  5429                                  
  5430                                  strcat1:  ; *** PROC ***
  5431                                  ;Function : strcat1, Number of local variables: 2
  5432                                  ;   # type sign width line used address name   list of local variables
  5433                                  ;  200 ptr sign byte   230 NULL bp+4    s
  5434                                  ;  201 ptr sign byte   230 NULL bp+6    t;
  5435 0000202C C8000000                 ENTER  0,0
  5436                                  @@strcat1227:
  5437 00002030 8B5E04                   mov bx, [bp+4]
  5438 00002033 8A07                     mov al, [bx]
  5439 00002035 B400                     mov ah, 0
  5440 00002037 83F800                   cmp ax, 0
  5441 0000203A 0F840500                 je  @@strcat1228
  5442 0000203E FF4604                   inc  word [bp+4]
  5443 00002041 EBED                     jmp @@strcat1227
  5444                                  @@strcat1228:
  5445 00002043 FF7606                   push word [bp+6]
  5446 00002046 FF7604                   push word [bp+4]
  5447 00002049 E81FFF                   call strcpy
  5448 0000204C 83C404                   add  sp, 4
  5449                                  
  5450                                  ;-231 int basename(char *s) { char *p; p=0;
  5451 0000204F C9                       LEAVE
  5452 00002050 C3                       ret
  5453                                  ; ENDP
  5454                                  ;Number of CALLs:    1 : openR
  5455                                  
  5456                                  openR:  ; *** PROC ***
  5457                                  ;Function : openR, Number of local variables: 1
  5458                                  ;   # type sign width line used address name   list of local variables
  5459                                  ;  200 ptr sign byte   231 NULL bp+4    s;
  5460 00002051 C8000000                 ENTER  0,0
  5461 00002055 8B5604                   mov  dx, [bp+4]
  5462 00002058 B8023D                   mov  ax, 15618
  5463 0000205B E87200                   call DosInt
  5464                                  
  5465                                  ;-232 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5466 0000205E C9                       LEAVE
  5467 0000205F C3                       ret
  5468                                  ; ENDP
  5469                                  ;Number of CALLs:    2 : creatR
  5470                                  
  5471                                  creatR:  ; *** PROC ***
  5472                                  ;Function : creatR, Number of local variables: 1
  5473                                  ;   # type sign width line used address name   list of local variables
  5474                                  ;  200 ptr sign byte   232 NULL bp+4    s;
  5475 00002060 C8000000                 ENTER  0,0
  5476 00002064 8B5604                   mov  dx, [bp+4]
  5477 00002067 B90000                   mov  cx, 0
  5478 0000206A B8003C                   mov  ax, 15360
  5479 0000206D E86000                   call DosInt
  5480                                  
  5481                                  ;-233 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5482 00002070 C9                       LEAVE
  5483 00002071 C3                       ret
  5484                                  ; ENDP
  5485                                  ;Number of CALLs:    2 : readRL
  5486                                  
  5487                                  readRL:  ; *** PROC ***
  5488                                  ;Function : readRL, Number of local variables: 3
  5489                                  ;   # type sign width line used address name   list of local variables
  5490                                  ;  200 ptr sign byte   233 NULL bp+4    s
  5491                                  ;  201 var sign word   233 NULL bp+6    fd
  5492                                  ;  202 var sign word   233 NULL bp+8    len;
  5493 00002072 C8000000                 ENTER  0,0
  5494 00002076 8B5604                   mov  dx, [bp+4]
  5495 00002079 8B4E08                   mov  cx, [bp+8]
  5496 0000207C 8B5E06                   mov  bx, [bp+6]
  5497 0000207F B8003F                   mov  ax, 16128
  5498 00002082 E84B00                   call DosInt
  5499                                  
  5500                                  ;-234 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5501 00002085 C9                       LEAVE
  5502 00002086 C3                       ret
  5503                                  ; ENDP
  5504                                  ;Number of CALLs:    2 : fputcR
  5505                                  
  5506                                  fputcR:  ; *** PROC ***
  5507                                  ;Function : fputcR, Number of local variables: 2
  5508                                  ;   # type sign width line used address name   list of local variables
  5509                                  ;  200 ptr sign byte   234 NULL bp+4    n
  5510                                  ;  201 var sign word   234 NULL bp+6    fd;
  5511 00002087 C8000000                 ENTER  0,0
  5512 0000208B 8D5604                  lea dx, [bp+4]
  5513                                  
  5514                                  ;-235   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5515                                  
  5516 0000208E B90100                   mov  cx, 1
  5517 00002091 8B5E06                   mov  bx, [bp+6]
  5518 00002094 B80040                   mov  ax, 16384
  5519 00002097 E83600                   call DosInt
  5520                                  
  5521                                  ;-236 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5522 0000209A C9                       LEAVE
  5523 0000209B C3                       ret
  5524                                  ; ENDP
  5525                                  ;Number of CALLs:    3 : fcloseR
  5526                                  
  5527                                  fcloseR:  ; *** PROC ***
  5528                                  ;Function : fcloseR, Number of local variables: 1
  5529                                  ;   # type sign width line used address name   list of local variables
  5530                                  ;  200 var sign word   236 NULL bp+4    fd;
  5531 0000209C C8000000                 ENTER  0,0
  5532 000020A0 8B5E04                   mov  bx, [bp+4]
  5533 000020A3 B8003E                   mov  ax, 15872
  5534 000020A6 CD21                     int  33
  5535                                  
  5536                                  ;-237 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5537 000020A8 C9                       LEAVE
  5538 000020A9 C3                       ret
  5539                                  ; ENDP
  5540                                  ;Number of CALLs:    5 : exitR
  5541                                  
  5542                                  exitR:  ; *** PROC ***
  5543                                  ;Function : exitR, Number of local variables: 1
  5544                                  ;   # type sign width line used address name   list of local variables
  5545                                  ;  200 var sign byte   237 NULL bp+4    c;
  5546 000020AA C8000000                 ENTER  0,0
  5547 000020AE B44C                     mov  ah, 76
  5548 000020B0 8A4604                   mov  al, [bp+4]
  5549 000020B3 CD21                     int  33
  5550                                  
  5551                                  ;-238 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5552 000020B5 C9                       LEAVE
  5553 000020B6 C3                       ret
  5554                                  ; ENDP
  5555                                  ;End of archive file. 
  5556                                   
  5557                                  ; missing functions: 
  5558                                  ; putch
  5559                                  ; DosInt
  5560                                  ; DosInt
  5561                                  ; DosInt
  5562                                  ; DosInt
  5563                                  ; Number of unresolved CALLs :    5
  5564                                  ;use archive file: AR.C
  5565                                  
  5566                                  ;-239 // AR.C Archive
  5567                                  
  5568                                  ;Number of CALLs:    1 : putch
  5569                                  
  5570                                  putch:  ; *** PROC ***
  5571                                  ;Function : putch, Number of local variables: 1
  5572                                  ;   # type sign width line used address name   list of local variables
  5573                                  ;  200 var sign byte   239 NULL bp+4    c;
  5574 000020B7 C8000000                 ENTER  0,0
  5575 000020BB 807E040A                cmp byte [bp+4], 10
  5576 000020BF 0F850500                 jne @@putch229
  5577 000020C3 B00D                     mov  al, 13
  5578 000020C5 E8FFFD                   call writetty
  5579                                  @@putch229:
  5580 000020C8 8A4604                   mov  al, [bp+4]
  5581 000020CB E8F9FD                   call writetty
  5582                                  
  5583                                  ;-240 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5584 000020CE C9                       LEAVE
  5585 000020CF C3                       ret
  5586                                  ; ENDP
  5587                                  ;Number of CALLs:    4 : DosInt
  5588                                  
  5589                                  DosInt:  ; *** PROC ***
  5590 000020D0 CD21                     int  33
  5591 000020D2 7304                     jae short @@DosInt230
  5592 000020D4 FF06[3000]               inc  word [DOS_ERR]
  5593                                  @@DosInt230:
  5594                                  
  5595                                  ;-241 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5596                                  
  5597 000020D8 C3                       ret
  5598                                  ; ENDP
  5599                                  ;End of archive file. 
  5600                                   
  5601                                  ; missing functions:  All FUNCTIONs in place
  5602 000020D9 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5603 000020DC 58                      pop ax
  5604 000020DD C3                      ret
  5605                                   
  5606                                  ;   # type sign width line used  address name   list of global variables
  5607                                  
  5608                                  ;    1 arr sign byte     2    2        0 Version1[20]
  5609                                  ;    2 var sign byte     1    3        0 LIST
  5610                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5611                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5612                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5613                                  ;    6 var unsg word     5   12        0 SymbolInt
  5614                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5615                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5616                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5617                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5618                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5619                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5620                                  ;   13 var sign word    12    4        0 asm_fd
  5621                                  ;   14 var sign word    13    3        0 lst_fd
  5622                                  ;   15 var sign word    14    3        0 bin_fd
  5623                                  ;   16 var sign word    15    6        0 DOS_ERR
  5624                                  ;   17 var sign word    16    4        0 ErrorCount
  5625                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5626                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5627                                  ;   20 var unsg word    20    5        0 PC
  5628                                  ;   21 var unsg word    21    2        0 PCStart
  5629                                  ;   22 var sign byte    22    3        0 isLabel
  5630                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5631                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5632                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5633                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5634                                  ;   27 var sign byte    27   20        0 TokeType
  5635                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5636                                  ;   29 def unsg byte    29    -        0 WORD=2
  5637                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5638                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5639                                  ;   32 def unsg byte    33    -        0 IMM=1
  5640                                  ;   33 def unsg byte    34    -        0 REG=2
  5641                                  ;   34 def unsg byte    35    -        0 ADR=3
  5642                                  ;   35 def unsg byte    36    -        0 MEM=4
  5643                                  ;   36 var sign byte    37   13        0 Op1
  5644                                  ;   37 var sign byte    38   12        0 CodeType
  5645                                  ;   38 var sign byte    40   17        0 RegType
  5646                                  ;   39 var sign byte    41   10        0 RegNo
  5647                                  ;   40 var sign byte    42   10        0 OpSize
  5648                                  ;   41 var sign byte    44 NULL        0 NumOprns
  5649                                  ;   42 var sign byte    45    5        0 wflag
  5650                                  ;   43 var sign byte    46 NULL        0 dflag
  5651                                  ;   44 var sign byte    48   11        0 regindexbase
  5652                                  ;   45 var sign word    49   13        0 disp
  5653                                  ;   46 var sign word    50    2        0 imme
  5654                                  ;   47 def unsg byte    52    -        0 OPMAXLEN=5
  5655                                  ;   48 arr sign byte    53    2    30390 OpPos[5]
  5656                                  ;   49 var sign word    54    6        0 OpPrintIndex
  5657                                  ;   50 ptr sign byte    55   16        0 OpCodePtr
  5658                                  ;   51 var sign byte    56    2        0 PrReloc
  5659                                  ;   52 def unsg byte    58    -        0 LABELNAMESMAX=969
  5660                                  ;   53 arr sign byte    59    3    30395 LabelNames[1000]
  5661                                  ;   54 ptr sign byte    60   10        0 LabelNamePtr
  5662                                  ;   55 def unsg byte    61    -        0 LABELADRMAX=100
  5663                                  ;   56 arr unsg word    62    4    31395 LabelAddr[100]
  5664                                  ;   57 var sign word    63    5        0 LabelMaxIx
  5665                                  ;   58 var sign word    64    4        0 LabelIx
  5666                                  ;   59 def unsg byte    66    -        0 FILEBINMAX=1990
  5667                                  ;   60 arr sign byte    67    3    31595 FileBin[2000]
  5668                                  ;   61 var unsg word    68    5        0 BinLen
  5669                                  ;   62 ptr sign byte    70    1        0 arglen
  5670                                  ;   63 ptr sign byte    71    4        0 argv
  5671                                  ;   64 var sign byte     1    1        0 I_START
  5672                                  ;   65 arr sign byte     4 NULL        0 I_PUSHA[9]
  5673                                  ;   66 arr sign byte     5 NULL        0 I_POPA[8]
  5674                                  ;   67 arr sign byte     6 NULL        0 I_NOP[7]
  5675                                  ;   68 arr sign byte     7 NULL        0 I_CBW[7]
  5676                                  ;   69 arr sign byte     8 NULL        0 I_CWDE[8]
  5677                                  ;   70 arr sign byte     9 NULL        0 I_CWD[7]
  5678                                  ;   71 arr sign byte    10 NULL        0 I_CDQ[7]
  5679                                  ;   72 arr sign byte    11 NULL        0 I_WAIT[8]
  5680                                  ;   73 arr sign byte    12 NULL        0 I_PUSHF[9]
  5681                                  ;   74 arr sign byte    13 NULL        0 I_POPF[8]
  5682                                  ;   75 arr sign byte    14 NULL        0 I_SAHF[8]
  5683                                  ;   76 arr sign byte    15 NULL        0 I_LAHF[8]
  5684                                  ;   77 arr sign byte    16 NULL        0 I_MOVSB[9]
  5685                                  ;   78 arr sign byte    17 NULL        0 I_MOVSW[9]
  5686                                  ;   79 arr sign byte    18 NULL        0 I_CMPSB[9]
  5687                                  ;   80 arr sign byte    19 NULL        0 I_CMPSW[9]
  5688                                  ;   81 arr sign byte    20 NULL        0 I_STOSB[9]
  5689                                  ;   82 arr sign byte    21 NULL        0 I_STOSW[9]
  5690                                  ;   83 arr sign byte    22 NULL        0 I_LODSB[9]
  5691                                  ;   84 arr sign byte    23 NULL        0 I_LODSW[9]
  5692                                  ;   85 arr sign byte    24 NULL        0 I_SCASB[9]
  5693                                  ;   86 arr sign byte    25 NULL        0 I_SCASW[9]
  5694                                  ;   87 arr sign byte    26 NULL        0 I_LEAVE[9]
  5695                                  ;   88 arr sign byte    27 NULL        0 I_IRET[8]
  5696                                  ;   89 arr sign byte    28 NULL        0 I_XLAT[8]
  5697                                  ;   90 arr sign byte    29 NULL        0 I_LOCK[8]
  5698                                  ;   91 arr sign byte    30 NULL        0 I_REPNE[9]
  5699                                  ;   92 arr sign byte    31 NULL        0 I_REPNZ[9]
  5700                                  ;   93 arr sign byte    32 NULL        0 I_REPE[8]
  5701                                  ;   94 arr sign byte    33 NULL        0 I_REPZ[8]
  5702                                  ;   95 arr sign byte    34 NULL        0 I_HLT[7]
  5703                                  ;   96 arr sign byte    35 NULL        0 I_CLC[7]
  5704                                  ;   97 arr sign byte    36 NULL        0 I_STC[7]
  5705                                  ;   98 arr sign byte    37 NULL        0 I_CLI[7]
  5706                                  ;   99 arr sign byte    38 NULL        0 I_STI[7]
  5707                                  ;  100 arr sign byte    39 NULL        0 I_CLD[7]
  5708                                  ;  101 arr sign byte    40 NULL        0 I_STD[7]
  5709                                  ;  102 arr sign byte    42 NULL        0 I_INC[9]
  5710                                  ;  103 arr sign byte    43 NULL        0 I_DEC[9]
  5711                                  ;  104 arr sign byte    45 NULL        0 I_NOT[8]
  5712                                  ;  105 arr sign byte    46 NULL        0 I_NEG[8]
  5713                                  ;  106 arr sign byte    47 NULL        0 I_MUL[8]
  5714                                  ;  107 arr sign byte    48 NULL        0 I_IMUL[9]
  5715                                  ;  108 arr sign byte    49 NULL        0 I_DIV[8]
  5716                                  ;  109 arr sign byte    50 NULL        0 I_IDIV[9]
  5717                                  ;  110 arr sign byte    52 NULL        0 I_LES[7]
  5718                                  ;  111 arr sign byte    53 NULL        0 I_LDS[7]
  5719                                  ;  112 arr sign byte    54 NULL        0 I_LEA[7]
  5720                                  ;  113 arr sign byte    56 NULL        0 I_ADD[7]
  5721                                  ;  114 arr sign byte    57 NULL        0 I_OR[6]
  5722                                  ;  115 arr sign byte    58 NULL        0 I_ADC[7]
  5723                                  ;  116 arr sign byte    59 NULL        0 I_SBB[7]
  5724                                  ;  117 arr sign byte    60 NULL        0 I_AND[7]
  5725                                  ;  118 arr sign byte    61 NULL        0 I_SUB[7]
  5726                                  ;  119 arr sign byte    62 NULL        0 I_XOR[7]
  5727                                  ;  120 arr sign byte    63 NULL        0 I_CMP[7]
  5728                                  ;  121 arr sign byte    65 NULL        0 I_MOV[6]
  5729                                  ;  122 arr sign byte    66 NULL        0 I_MOVSX[9]
  5730                                  ;  123 arr sign byte    67 NULL        0 I_MOVZX[9]
  5731                                  ;  124 arr sign byte    69 NULL        0 I_JO[6]
  5732                                  ;  125 arr sign byte    70 NULL        0 I_JNO[7]
  5733                                  ;  126 arr sign byte    71 NULL        0 I_JB[6]
  5734                                  ;  127 arr sign byte    72 NULL        0 I_JC[6]
  5735                                  ;  128 arr sign byte    73 NULL        0 I_JNB[7]
  5736                                  ;  129 arr sign byte    74 NULL        0 I_JAE[7]
  5737                                  ;  130 arr sign byte    75 NULL        0 I_JNC[7]
  5738                                  ;  131 arr sign byte    76 NULL        0 I_JE[6]
  5739                                  ;  132 arr sign byte    77 NULL        0 I_JZ[6]
  5740                                  ;  133 arr sign byte    78 NULL        0 I_JNE[7]
  5741                                  ;  134 arr sign byte    79 NULL        0 I_JNZ[7]
  5742                                  ;  135 arr sign byte    80 NULL        0 I_JBE[7]
  5743                                  ;  136 arr sign byte    81 NULL        0 I_JNA[7]
  5744                                  ;  137 arr sign byte    82 NULL        0 I_JA[6]
  5745                                  ;  138 arr sign byte    83 NULL        0 I_JS[6]
  5746                                  ;  139 arr sign byte    84 NULL        0 I_JNS[7]
  5747                                  ;  140 arr sign byte    85 NULL        0 I_JP[6]
  5748                                  ;  141 arr sign byte    86 NULL        0 I_JPE[7]
  5749                                  ;  142 arr sign byte    87 NULL        0 I_JNP[7]
  5750                                  ;  143 arr sign byte    88 NULL        0 I_JPO[7]
  5751                                  ;  144 arr sign byte    89 NULL        0 I_JL[6]
  5752                                  ;  145 arr sign byte    90 NULL        0 I_JNL[7]
  5753                                  ;  146 arr sign byte    91 NULL        0 I_JGE[7]
  5754                                  ;  147 arr sign byte    92 NULL        0 I_JLE[7]
  5755                                  ;  148 arr sign byte    93 NULL        0 I_JNG[7]
  5756                                  ;  149 arr sign byte    94 NULL        0 I_JG[6]
  5757                                  ;  150 arr sign byte    96 NULL        0 I_JMP[8]
  5758                                  ;  151 arr sign byte    97 NULL        0 I_CALL[9]
  5759                                  ;  152 arr sign byte    99 NULL        0 I_RET[8]
  5760                                  ;  153 arr sign byte   100 NULL        0 I_RETF[9]
  5761                                  ;  154 arr sign byte   102 NULL        0 I_PUSH[8]
  5762                                  ;  155 arr sign byte   103 NULL        0 I_POP[7]
  5763                                  ;  156 arr sign byte   105 NULL        0 I_ROL[7]
  5764                                  ;  157 arr sign byte   106 NULL        0 I_ROR[7]
  5765                                  ;  158 arr sign byte   107 NULL        0 I_RCL[7]
  5766                                  ;  159 arr sign byte   108 NULL        0 I_RCR[7]
  5767                                  ;  160 arr sign byte   109 NULL        0 I_SHL[7]
  5768                                  ;  161 arr sign byte   110 NULL        0 I_SAL[7]
  5769                                  ;  162 arr sign byte   111 NULL        0 I_SHR[7]
  5770                                  ;  163 arr sign byte   112 NULL        0 I_SAR[7]
  5771                                  ;  164 arr sign byte   114 NULL        0 I_INT[8]
  5772                                  ;  165 arr sign byte   115 NULL        0 I_INTO[8]
  5773                                  ;  166 arr sign byte   117 NULL        0 I_IN[7]
  5774                                  ;  167 arr sign byte   118 NULL        0 I_INSB[8]
  5775                                  ;  168 arr sign byte   119 NULL        0 I_INSW[8]
  5776                                  ;  169 arr sign byte   120 NULL        0 I_INSD[8]
  5777                                  ;  170 arr sign byte   121 NULL        0 I_OUT[8]
  5778                                  ;  171 arr sign byte   122 NULL        0 I_OUTSB[8]
  5779                                  ;  172 arr sign byte   123 NULL        0 I_OUTSW[8]
  5780                                  ;  173 arr sign byte   124 NULL        0 I_OUTSD[8]
  5781                                  ;  174 arr sign byte   126 NULL        0 I_XCHG[9]
  5782                                  ;  175 arr sign byte   128 NULL        0 I_LOOPNZ[10]
  5783                                  ;  176 arr sign byte   129 NULL        0 I_LOOPNE[10]
  5784                                  ;  177 arr sign byte   130 NULL        0 I_LOOPZ[9]
  5785                                  ;  178 arr sign byte   131 NULL        0 I_LOOPE[9]
  5786                                  ;  179 arr sign byte   132 NULL        0 I_LOOP[8]
  5787                                  ;  180 arr sign byte   133 NULL        0 I_JCXZ[8]
  5788                                  ;  181 arr sign byte   134 NULL        0 I_JECXZ[9]
  5789                                  ;  182 arr sign byte   136 NULL        0 I_ENTER[9]
  5790                                  ;  183 arr sign byte   138 NULL        0 I_ORG[6]
  5791                                  ;  184 arr sign byte   139 NULL        0 I_DB[5]
  5792                                  ;  185 arr sign byte   140 NULL        0 I_DW[5]
  5793                                  ;  186 arr sign byte   141 NULL        0 I_DD[5]
  5794                                  ;  187 arr sign byte   142 NULL        0 I_RESB[7]
  5795                                  ;  188 arr sign byte   143 NULL        0 I_RESW[7]
  5796                                  ;  189 arr sign byte   144 NULL        0 I_RESD[7]
  5797                                  ;  190 var sign byte   145 NULL        0 I_END
  5798                                  
  5799                                  
  5800                                  ;   # Calls Line Width  Name   list of functions
  5801                                  
  5802                                  ;    0 NULL    1 word   main
  5803                                  ;    1    1    6 word   process
  5804                                  ;    2    1   48 word   setwflag
  5805                                  ;    3 NULL   60 word   Check2Op
  5806                                  ;    4    2   62 word   checkLeftOp
  5807                                  ;    5 NULL   73 word   saveLeftOp
  5808                                  ;    6 NULL   75 word   checkRightOp
  5809                                  ;    7    1   87 word   getOp
  5810                                  ;    8    2  101 word   getOp1
  5811                                  ;    9    1  116 word   getMEM
  5812                                  ;   10    1  136 word   getIndReg1
  5813                                  ;   11    1  145 word   getIndReg2
  5814                                  ;   12    1  156 word   gen66h
  5815                                  ;   13    8  157 word   genCode8
  5816                                  ;   14    3  167 word   genCode16
  5817                                  ;   15    7  171 word   genInstruction
  5818                                  ;   16    2  177 word   genCodeInREG
  5819                                  ;   17 NULL  182 word   genModRegRM
  5820                                  ;   18    2  184 word   writeEA
  5821                                  ;   19 NULL  205 word   testx
  5822                                  ;   20    1    1 word   parse
  5823                                  ;   21   12   27 word   getTokeType
  5824                                  ;   22    2   36 word   storeLabel
  5825                                  ;   23    2   43 word   searchLabel
  5826                                  ;   24    1   54 word   getVariable
  5827                                  ;   25    2   83 word   lookCode
  5828                                  ;   26    1   97 word   getCodeSize
  5829                                  ;   27    7  104 word   isToken
  5830                                  ;   28    1  109 word   skipRest
  5831                                  ;   29    1    1 word   getLine
  5832                                  ;   30    1   14 word   ifEOL
  5833                                  ;   31    3   21 word   skipBlank
  5834                                  ;   32    2   26 word   letterE
  5835                                  ;   33    1   36 word   alnumE
  5836                                  ;   34    1   41 word   getDigit
  5837                                  ;   35    1   53 word   getName
  5838                                  ;   36    1   70 word   testReg
  5839                                  ;   37    1    1 word   printLine
  5840                                  ;   38    9   19 word   prc
  5841                                  ;   39    1   23 word   prscomment
  5842                                  ;   40   24   26 word   prs
  5843                                  ;   41    4   31 word   printhex8a
  5844                                  ;   42    2   35 word   printhex16
  5845                                  ;   43    3   38 word   printIntU
  5846                                  ;   44   19   45 word   error1
  5847                                  ;   45 NULL   48 word   allowederror
  5848                                  ;   46 NULL   49 word   implmerror
  5849                                  ;   47    4   50 word   indexerror
  5850                                  ;   48    1   51 word   numbererror
  5851                                  ;   49 NULL   52 word   regmemerror
  5852                                  ;   50    1   53 word   segregerror
  5853                                  ;   51    1   54 word   syntaxerror
  5854                                  ;   52    7   56 word   errorexit
  5855                                  ;   53    1   57 word   addrexit
  5856                                  ;   54 NULL   58 word   internexit
  5857                                  ;   55    1    1 word   getarg
  5858                                  ;   56    1   26 word   epilog
  5859                                  ;   57    2   57 word   end1
  5860                                  ;   58    4  219 word   writetty
  5861                                  ;   59    8  220 word   cputs
  5862                                  ;   60    2  221 word   toupper
  5863                                  ;   61    4  223 word   strlen
  5864                                  ;   62    6  224 word   strcpy
  5865                                  ;   63    3  226 word   digit
  5866                                  ;   64   35  227 word   eqstr
  5867                                  ;   65    3  230 word   strcat1
  5868                                  ;   66    1  231 word   openR
  5869                                  ;   67    2  232 word   creatR
  5870                                  ;   68    2  233 word   readRL
  5871                                  ;   69    2  234 word   fputcR
  5872                                  ;   70    3  236 word   fcloseR
  5873                                  ;   71    5  237 word   exitR
  5874                                  ;   72    1  239 word   putch
  5875                                  ;   73    4  240 word   DosInt
  5876                                  ;   74 NULL  241 word   LastFunctionByt
  5877                                  
  5878                                  ;    #  addr name   list of CALLs
  5879                                  
  5880                                  ;    0     5 getarg
  5881                                  ;    1    12 parse
  5882                                  ;    2    18 epilog
  5883                                  ;    3    25 end1
  5884                                  ;    4  1380 getTokeType
  5885                                  ;    5  1392 getCodeSize
  5886                                  ;    6  1404 genInstruction
  5887                                  ;    7  1419 checkLeftOp
  5888                                  ;    8  1431 genInstruction
  5889                                  ;    9  1446 genInstruction
  5890                                  ;   10  1461 genInstruction
  5891                                  ;   11  1476 genCodeInREG
  5892                                  ;   12  1489 checkLeftOp
  5893                                  ;   13  1501 genInstruction
  5894                                  ;   14  1516 genCodeInREG
  5895                                  ;   15  1529 genInstruction
  5896                                  ;   16  1544 genCode16
  5897                                  ;   17  1554 genInstruction
  5898                                  ;   18  1569 error1
  5899                                  ;   19  1576 error1
  5900                                  ;   20  1592 gen66h
  5901                                  ;   21  1636 getOp
  5902                                  ;   22  1642 segregerror
  5903                                  ;   23  1654 setwflag
  5904                                  ;   24  1663 error1
  5905                                  ;   25  1670 error1
  5906                                  ;   26  1677 error1
  5907                                  ;   27  1719 getOp1
  5908                                  ;   28  1726 isToken
  5909                                  ;   29  1734 getMEM
  5910                                  ;   30  1741 error1
  5911                                  ;   31  1748 error1
  5912                                  ;   32  1762 testReg
  5913                                  ;   33  1770 searchLabel
  5914                                  ;   34  1782 error1
  5915                                  ;   35  1800 getTokeType
  5916                                  ;   36  1812 getOp1
  5917                                  ;   37  1819 syntaxerror
  5918                                  ;   38  1831 getIndReg2
  5919                                  ;   39  1842 getIndReg1
  5920                                  ;   40  1853 isToken
  5921                                  ;   41  1861 getTokeType
  5922                                  ;   42  1873 numbererror
  5923                                  ;   43  1885 isToken
  5924                                  ;   44  1893 isToken
  5925                                  ;   45  1901 errorexit
  5926                                  ;   46  1924 indexerror
  5927                                  ;   47  1935 indexerror
  5928                                  ;   48  1959 indexerror
  5929                                  ;   49  1970 indexerror
  5930                                  ;   50  1988 genCode8
  5931                                  ;   51  2020 genCode8
  5932                                  ;   52  2029 genCode8
  5933                                  ;   53  2062 genCode8
  5934                                  ;   54  2086 writeEA
  5935                                  ;   55  2106 writeEA
  5936                                  ;   56  2130 addrexit
  5937                                  ;   57  2139 genCode8
  5938                                  ;   58  2148 genCode8
  5939                                  ;   59  2157 genCode16
  5940                                  ;   60  2179 getLine
  5941                                  ;   61  2187 getTokeType
  5942                                  ;   62  2199 storeLabel
  5943                                  ;   63  2210 getTokeType
  5944                                  ;   64  2222 lookCode
  5945                                  ;   65  2231 process
  5946                                  ;   66  2239 getVariable
  5947                                  ;   67  2251 skipRest
  5948                                  ;   68  2260 error1
  5949                                  ;   69  2267 error1
  5950                                  ;   70  2274 printLine
  5951                                  ;   71  2298 skipBlank
  5952                                  ;   72  2308 digit
  5953                                  ;   73  2314 getDigit
  5954                                  ;   74  2323 letterE
  5955                                  ;   75  2331 getName
  5956                                  ;   76  2350 searchLabel
  5957                                  ;   77  2362 error1
  5958                                  ;   78  2369 strcpy
  5959                                  ;   79  2396 eqstr
  5960                                  ;   80  2402 strlen
  5961                                  ;   81  2423 storeLabel
  5962                                  ;   82  2434 getTokeType
  5963                                  ;   83  2446 lookCode
  5964                                  ;   84  2455 errorexit
  5965                                  ;   85  2465 errorexit
  5966                                  ;   86  2475 getTokeType
  5967                                  ;   87  2487 genCode8
  5968                                  ;   88  2496 skipBlank
  5969                                  ;   89  2506 isToken
  5970                                  ;   90  2514 genCode8
  5971                                  ;   91  2523 isToken
  5972                                  ;   92  2531 getTokeType
  5973                                  ;   93  2543 genCode16
  5974                                  ;   94  2553 isToken
  5975                                  ;   95  2561 errorexit
  5976                                  ;   96  2580 eqstr
  5977                                  ;   97  2598 eqstr
  5978                                  ;   98  2604 getTokeType
  5979                                  ;   99  2616 eqstr
  5980                                  ;  100  2622 getTokeType
  5981                                  ;  101  2634 eqstr
  5982                                  ;  102  2640 getTokeType
  5983                                  ;  103  2662 skipBlank
  5984                                  ;  104  2681 getTokeType
  5985                                  ;  105  2693 prs
  5986                                  ;  106  2705 readRL
  5987                                  ;  107  2712 errorexit
  5988                                  ;  108  2722 ifEOL
  5989                                  ;  109  2736 readRL
  5990                                  ;  110  2772 digit
  5991                                  ;  111  2778 letterE
  5992                                  ;  112  2805 digit
  5993                                  ;  113  2823 alnumE
  5994                                  ;  114  2830 strcpy
  5995                                  ;  115  2837 toupper
  5996                                  ;  116  2853 strlen
  5997                                  ;  117  2860 strlen
  5998                                  ;  118  2867 eqstr
  5999                                  ;  119  2873 eqstr
  6000                                  ;  120  2879 eqstr
  6001                                  ;  121  2885 eqstr
  6002                                  ;  122  2891 eqstr
  6003                                  ;  123  2897 eqstr
  6004                                  ;  124  2903 eqstr
  6005                                  ;  125  2909 eqstr
  6006                                  ;  126  2915 eqstr
  6007                                  ;  127  2921 eqstr
  6008                                  ;  128  2927 eqstr
  6009                                  ;  129  2933 eqstr
  6010                                  ;  130  2939 eqstr
  6011                                  ;  131  2945 eqstr
  6012                                  ;  132  2951 eqstr
  6013                                  ;  133  2957 eqstr
  6014                                  ;  134  2963 eqstr
  6015                                  ;  135  2969 eqstr
  6016                                  ;  136  2975 eqstr
  6017                                  ;  137  2981 eqstr
  6018                                  ;  138  2987 eqstr
  6019                                  ;  139  2993 eqstr
  6020                                  ;  140  2999 eqstr
  6021                                  ;  141  3005 eqstr
  6022                                  ;  142  3011 eqstr
  6023                                  ;  143  3017 eqstr
  6024                                  ;  144  3023 eqstr
  6025                                  ;  145  3029 eqstr
  6026                                  ;  146  3035 eqstr
  6027                                  ;  147  3041 eqstr
  6028                                  ;  148  3061 prs
  6029                                  ;  149  3065 printhex16
  6030                                  ;  150  3076 prs
  6031                                  ;  151  3080 prc
  6032                                  ;  152  3084 printhex8a
  6033                                  ;  153  3095 prc
  6034                                  ;  154  3099 prs
  6035                                  ;  155  3103 prscomment
  6036                                  ;  156  3120 writetty
  6037                                  ;  157  3129 writetty
  6038                                  ;  158  3138 fputcR
  6039                                  ;  159  3160 prc
  6040                                  ;  160  3176 prc
  6041                                  ;  161  3197 prc
  6042                                  ;  162  3201 prc
  6043                                  ;  163  3223 printhex8a
  6044                                  ;  164  3234 printhex8a
  6045                                  ;  165  3259 printIntU
  6046                                  ;  166  3269 prc
  6047                                  ;  167  3282 prs
  6048                                  ;  168  3286 prs
  6049                                  ;  169  3290 prs
  6050                                  ;  170  3294 prs
  6051                                  ;  171  3311 error1
  6052                                  ;  172  3329 error1
  6053                                  ;  173  3347 error1
  6054                                  ;  174  3366 error1
  6055                                  ;  175  3385 error1
  6056                                  ;  176  3404 error1
  6057                                  ;  177  3423 error1
  6058                                  ;  178  3442 error1
  6059                                  ;  179  3449 end1
  6060                                  ;  180  3463 errorexit
  6061                                  ;  181  3484 errorexit
  6062                                  ;  182  3513 cputs
  6063                                  ;  183  3519 cputs
  6064                                  ;  184  3525 exitR
  6065                                  ;  185  3531 toupper
  6066                                  ;  186  3539 strcpy
  6067                                  ;  187  3546 strcat1
  6068                                  ;  188  3554 strcpy
  6069                                  ;  189  3561 strcat1
  6070                                  ;  190  3569 strcpy
  6071                                  ;  191  3576 strcat1
  6072                                  ;  192  3584 openR
  6073                                  ;  193  3590 cputs
  6074                                  ;  194  3596 cputs
  6075                                  ;  195  3602 exitR
  6076                                  ;  196  3608 creatR
  6077                                  ;  197  3615 cputs
  6078                                  ;  198  3621 cputs
  6079                                  ;  199  3627 exitR
  6080                                  ;  200  3633 creatR
  6081                                  ;  201  3640 cputs
  6082                                  ;  202  3646 cputs
  6083                                  ;  203  3652 exitR
  6084                                  ;  204  3658 prs
  6085                                  ;  205  3662 prs
  6086                                  ;  206  3666 prs
  6087                                  ;  207  3670 prs
  6088                                  ;  208  3674 prs
  6089                                  ;  209  3678 prs
  6090                                  ;  210  3682 prs
  6091                                  ;  211  3686 prs
  6092                                  ;  212  3690 prs
  6093                                  ;  213  3707 prs
  6094                                  ;  214  3711 printIntU
  6095                                  ;  215  3721 prs
  6096                                  ;  216  3725 prs
  6097                                  ;  217  3729 prs
  6098                                  ;  218  3733 prc
  6099                                  ;  219  3737 printhex16
  6100                                  ;  220  3748 prs
  6101                                  ;  221  3752 strlen
  6102                                  ;  222  3759 prs
  6103                                  ;  223  3763 printIntU
  6104                                  ;  224  3773 prs
  6105                                  ;  225  3777 prc
  6106                                  ;  226  3781 printhex8a
  6107                                  ;  227  3792 fputcR
  6108                                  ;  228  3806 fcloseR
  6109                                  ;  229  3814 fcloseR
  6110                                  ;  230  3822 fcloseR
  6111                                  ;  231  3830 exitR
  6112                                  ;  232  3855 putch
  6113                                  ;  233  3923 strcpy
  6114                                  ;  234  3938 DosInt
  6115                                  ;  235  3954 DosInt
  6116                                  ;  236  3977 DosInt
  6117                                  ;  237  3996 DosInt
  6118                                  ;  238  4030 writetty
  6119                                  ;  239  4039 writetty
  6120                                  ;Input: AS.C, List: AS.S,  Lines:  242
  6121                                  ;Glob. variables:  190 max.:  200
  6122                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  6123                                  ;Functions      :   75 max.:  300
  6124                                  ;Calls          :  240 max.: 2000, NameField: 4071 max.:    65535
  6125                                  ;Code until     :26009 max.: 30000, free: 3991
  6126                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6127                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
