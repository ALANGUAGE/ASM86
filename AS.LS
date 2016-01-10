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
    11 00000003 E8BF1A                   call getarg
    12 00000006 E8120B                   call parse
    13 00000009 E8111D                   call epilog
    14 0000000C E87E1E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 10.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 10.1.2016",0
    21 00000019 372031302E312E3230-
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
   215                                  ;-48 char reg;               //combination of index and base reg
   216                                  
   217 00000045 00                      reg db 0
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
   900 00000414 E8EE07                   call getTokeType
   901                                  
   902                                  ;-8   OpSize=getCodeSize();
   903                                  
   904 00000417 E8E50A                   call getCodeSize
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
   920 0000042A E8A805                   call genInstruction
   921 0000042D 83C404                   add  sp, 4
   922                                  
   923                                  ;-12     return;
   924                                  
   925 00000430 E9E000                   jmp @@retn
   926                                  
   927                                  ;-13   }
   928                                  
   929                                  
   930                                  ;-14   if (CodeType ==  2) {//inc, dec
   931                                  
   932                                  @@process1:
   933 00000433 A0[3E00]                 mov al, [CodeType]
   934 00000436 3C02                     cmp al, 2
   935 00000438 0F855400                 jne @@process2
   936                                  
   937                                  ;-15     LeftOpwCheck();
   938                                  
   939 0000043C E85501                   call LeftOpwCheck
   940                                  
   941                                  ;-16     	if (Op1 == REG) {
   942                                  
   943 0000043F A0[3D00]                 mov al, [Op1]
   944 00000442 3C02                     cmp al, 2
   945 00000444 0F853400                 jne @@process3
   946                                  
   947                                  ;-17         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short
   948                                  
   949 00000448 A0[3F00]                 mov al, [RegType]
   950 0000044B 3C02                     cmp al, 2
   951 0000044D 0F851100                 jne @@process4
   952 00000451 6A03                     push 3
   953 00000453 A0[4000]                 mov al, byte [RegNo]
   954 00000456 B400                     mov ah, 0
   955 00000458 50                       push ax
   956 00000459 E87905                   call genInstruction
   957 0000045C 83C404                   add  sp, 4
   958 0000045F E9B100                   jmp @@retn
   959                                  
   960                                  ;-18         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; }
   961                                  
   962                                  @@process4:
   963 00000462 A0[3F00]                 mov al, [RegType]
   964 00000465 3C03                     cmp al, 3
   965 00000467 0F851100                 jne @@process5
   966 0000046B 6A03                     push 3
   967 0000046D A0[4000]                 mov al, byte [RegNo]
   968 00000470 B400                     mov ah, 0
   969 00000472 50                       push ax
   970 00000473 E85F05                   call genInstruction
   971 00000476 83C404                   add  sp, 4
   972 00000479 E99700                   jmp @@retn
   973                                  
   974                                  ;-19       }
   975                                  
   976                                  @@process5:
   977                                  
   978                                  ;-20       genInstruction(wflag, 1);
   979                                  
   980                                  @@process3:
   981 0000047C 6A01                     push 1
   982 0000047E A0[4300]                 mov al, byte [wflag]
   983 00000481 B400                     mov ah, 0
   984 00000483 50                       push ax
   985 00000484 E84E05                   call genInstruction
   986 00000487 83C404                   add  sp, 4
   987                                  
   988                                  ;-21       genCodeInREG();
   989                                  
   990 0000048A E87A05                   call genCodeInREG
   991                                  
   992                                  ;-22       return;
   993                                  
   994 0000048D E98300                   jmp @@retn
   995                                  
   996                                  ;-23   }
   997                                  
   998                                  
   999                                  ;-24 
  1000                                  
  1001                                  
  1002                                  ;-25   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
  1003                                  
  1004                                  @@process2:
  1005 00000490 A0[3E00]                 mov al, [CodeType]
  1006 00000493 3C34                     cmp al, 52
  1007 00000495 0F851700                 jne @@process6
  1008                                  
  1009                                  ;-26     LeftOpwCheck();
  1010                                  
  1011 00000499 E8F800                   call LeftOpwCheck
  1012                                  
  1013                                  ;-27     genInstruction(wflag, 1);
  1014                                  
  1015 0000049C 6A01                     push 1
  1016 0000049E A0[4300]                 mov al, byte [wflag]
  1017 000004A1 B400                     mov ah, 0
  1018 000004A3 50                       push ax
  1019 000004A4 E82E05                   call genInstruction
  1020 000004A7 83C404                   add  sp, 4
  1021                                  
  1022                                  ;-28     genCodeInREG();
  1023                                  
  1024 000004AA E85A05                   call genCodeInREG
  1025                                  
  1026                                  ;-29     return;
  1027                                  
  1028 000004AD E96300                   jmp @@retn
  1029                                  
  1030                                  ;-30   }
  1031                                  
  1032                                  
  1033                                  ;-31 
  1034                                  
  1035                                  
  1036                                  ;-32   if (CodeType==  8) {// ret
  1037                                  
  1038                                  @@process6:
  1039 000004B0 A0[3E00]                 mov al, [CodeType]
  1040 000004B3 3C08                     cmp al, 8
  1041 000004B5 0F852D00                 jne @@process7
  1042                                  
  1043                                  ;-33     if (TokeType == DIGIT) {
  1044                                  
  1045 000004B9 A0[3C00]                 mov al, [TokeType]
  1046 000004BC 3C01                     cmp al, 1
  1047 000004BE 0F851700                 jne @@process8
  1048                                  
  1049                                  ;-34       genInstruction(0, 2);
  1050                                  
  1051 000004C2 6A02                     push 2
  1052 000004C4 6A00                     push 0
  1053 000004C6 E80C05                   call genInstruction
  1054 000004C9 83C404                   add  sp, 4
  1055                                  
  1056                                  ;-35       genCode16(SymbolInt);
  1057                                  
  1058 000004CC FF36[2600]               push word [SymbolInt]
  1059 000004D0 E8E104                   call genCode16
  1060 000004D3 83C402                   add  sp, 2
  1061                                  
  1062                                  ;-36       return;
  1063                                  
  1064 000004D6 E93A00                   jmp @@retn
  1065                                  
  1066                                  ;-37     }
  1067                                  
  1068                                  
  1069                                  ;-38     genInstruction(0, 1); return;
  1070                                  
  1071                                  @@process8:
  1072 000004D9 6A01                     push 1
  1073 000004DB 6A00                     push 0
  1074 000004DD E8F504                   call genInstruction
  1075 000004E0 83C404                   add  sp, 4
  1076 000004E3 E92D00                   jmp @@retn
  1077                                  
  1078                                  ;-39   }
  1079                                  
  1080                                  
  1081                                  ;-40 
  1082                                  
  1083                                  
  1084                                  ;-41   if (CodeType==101) {// ORG nn
  1085                                  
  1086                                  @@process7:
  1087 000004E6 A0[3E00]                 mov al, [CodeType]
  1088 000004E9 3C65                     cmp al, 101
  1089 000004EB 0F851B00                 jne @@process9
  1090                                  
  1091                                  ;-42     if (TokeType != DIGIT) error1("only digit allowed");
  1092                                  
  1093 000004EF A0[3C00]                 mov al, [TokeType]
  1094 000004F2 3C01                     cmp al, 1
  1095 000004F4 0F840900                 je  @@process10
  1096 000004F8 68[1505]                 push process_0
  1097 000004FB E84514                   call error1
  1098 000004FE 83C402                   add  sp, 2
  1099                                  
  1100                                  ;-43     PC=SymbolInt;return;
  1101                                  
  1102                                  @@process10:
  1103 00000501 A1[2600]                 mov ax, [SymbolInt]
  1104 00000504 A3[3700]                 mov word [PC], ax
  1105 00000507 E90900                   jmp @@retn
  1106                                  
  1107                                  ;-44   }
  1108                                  
  1109                                  
  1110                                  ;-45   error1("unknown CodeType");
  1111                                  
  1112                                  @@process9:
  1113 0000050A 68[2805]                 push process_1
  1114 0000050D E83314                   call error1
  1115 00000510 83C402                   add  sp, 2
  1116                                  
  1117                                  ;-46 }
  1118                                  
  1119                                  
  1120                                  ;-47 int setwflag() {//only Op1 (first operand)
  1121                                  
  1122 00000513 C9                      @@retn: LEAVE
  1123 00000514 C3                       ret
  1124                                  ; ENDP
  1125 00000515 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1126 0000051E 7420616C6C6F776564-
  1127 00000527 00                 
  1128 00000528 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1129 00000531 6F64655479706500   
  1130                                  
  1131                                  setwflag:  ; *** PROC ***
  1132                                  
  1133                                  ;-48   wflag=0;
  1134                                  
  1135 00000539 66B800000000             mov eax, 0
  1136 0000053F A2[4300]                 mov byte [wflag], al
  1137                                  
  1138                                  ;-49   if (OpSize == 0) {//do not override OpSize
  1139                                  
  1140 00000542 A0[4100]                 mov al, [OpSize]
  1141 00000545 3C00                     cmp al, 0
  1142 00000547 0F852100                 jne @@setwflag11
  1143                                  
  1144                                  ;-50     if (Op1 == REG) {
  1145                                  
  1146 0000054B A0[3D00]                 mov al, [Op1]
  1147 0000054E 3C02                     cmp al, 2
  1148 00000550 0F851800                 jne @@setwflag12
  1149                                  
  1150                                  ;-51       OpSize=RegType;
  1151                                  
  1152 00000554 A0[3F00]                 mov al, [RegType]
  1153 00000557 A2[4100]                 mov byte [OpSize], al
  1154                                  
  1155                                  ;-52       if (RegType == SEGREG) OpSize=WORD;
  1156                                  
  1157 0000055A A0[3F00]                 mov al, [RegType]
  1158 0000055D 3C04                     cmp al, 4
  1159 0000055F 0F850900                 jne @@setwflag13
  1160 00000563 66B802000000             mov eax, 2
  1161 00000569 A2[4100]                 mov byte [OpSize], al
  1162                                  
  1163                                  ;-53     }
  1164                                  
  1165                                  @@setwflag13:
  1166                                  
  1167                                  ;-54   }
  1168                                  
  1169                                  @@setwflag12:
  1170                                  
  1171                                  ;-55   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1172                                  
  1173                                  @@setwflag11:
  1174 0000056C A0[4100]                 mov al, [OpSize]
  1175 0000056F 3C03                     cmp al, 3
  1176 00000571 0F850C00                 jne @@setwflag14
  1177 00000575 E80104                   call gen66h
  1178 00000578 66B801000000             mov eax, 1
  1179 0000057E A2[4300]                 mov byte [wflag], al
  1180                                  
  1181                                  ;-56   if (OpSize  ==  WORD) wflag=1;
  1182                                  
  1183                                  @@setwflag14:
  1184 00000581 A0[4100]                 mov al, [OpSize]
  1185 00000584 3C02                     cmp al, 2
  1186 00000586 0F850900                 jne @@setwflag15
  1187 0000058A 66B801000000             mov eax, 1
  1188 00000590 A2[4300]                 mov byte [wflag], al
  1189                                  
  1190                                  ;-57 }
  1191                                  
  1192                                  @@setwflag15:
  1193                                  
  1194                                  ;-58 //NumOprns==2, seg reg not allowed only mov and push
  1195                                  
  1196                                  
  1197                                  ;-59 //size: reg size or declaration CodeSize
  1198                                  
  1199                                  
  1200                                  ;-60 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
  1201                                  
  1202                                  
  1203                                  ;-61 //2. rm , imm 80
  1204                                  
  1205                                  
  1206                                  ;-62 //2a sign ext 83
  1207                                  
  1208                                  
  1209                                  ;-63 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
  1210                                  
  1211                                  
  1212                                  ;-64 //4. rm , reg 00
  1213                                  
  1214                                  
  1215                                  ;-65 //5. error1(mem2mem)
  1216                                  
  1217                                  
  1218                                  ;-66 
  1219                                  
  1220                                  
  1221                                  ;-67 int LeftOpwCheck() {
  1222                                  
  1223 00000593 C3                       ret
  1224                                  ; ENDP
  1225                                  
  1226                                  LeftOpwCheck:  ; *** PROC ***
  1227                                  
  1228                                  ;-68   getLeftOp();
  1229                                  
  1230 00000594 E8A700                   call getLeftOp
  1231                                  
  1232                                  ;-69   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1233                                  
  1234 00000597 A0[3F00]                 mov al, [RegType]
  1235 0000059A 3C04                     cmp al, 4
  1236 0000059C 0F850600                 jne @@LeftOpwCheck16
  1237 000005A0 E89914                   call segregerror
  1238 000005A3 E95300                   jmp @@retn
  1239                                  
  1240                                  ;-70   setwflag();
  1241                                  
  1242                                  @@LeftOpwCheck16:
  1243 000005A6 E890FF                   call setwflag
  1244                                  
  1245                                  ;-71   if (OpSize == 0) error1("no op size declared");
  1246                                  
  1247 000005A9 A0[4100]                 mov al, [OpSize]
  1248 000005AC 3C00                     cmp al, 0
  1249 000005AE 0F850900                 jne @@LeftOpwCheck17
  1250 000005B2 68[FA05]                 push LeftOpwCheck_0
  1251 000005B5 E88B13                   call error1
  1252 000005B8 83C402                   add  sp, 2
  1253                                  
  1254                                  ;-72   if (OpSize == RegType) return;
  1255                                  
  1256                                  @@LeftOpwCheck17:
  1257 000005BB A0[4100]                 mov al, [OpSize]
  1258 000005BE 3A06[3F00]               cmp al, [RegType]
  1259 000005C2 0F850300                 jne @@LeftOpwCheck18
  1260 000005C6 E93000                   jmp @@retn
  1261                                  
  1262                                  ;-73   if (OpSize){if (Op1 == MEM) return;
  1263                                  
  1264                                  @@LeftOpwCheck18:
  1265 000005C9 A0[4100]                 mov al, [OpSize]
  1266 000005CC 08C0                     or  al, al
  1267 000005CE 0F841500                 je @@LeftOpwCheck19
  1268 000005D2 A0[3D00]                 mov al, [Op1]
  1269 000005D5 3C04                     cmp al, 4
  1270 000005D7 0F850300                 jne @@LeftOpwCheck20
  1271 000005DB E91B00                   jmp @@retn
  1272                                  
  1273                                  ;-74     error1("Conflict OpSize and RegSize"); }
  1274                                  
  1275                                  @@LeftOpwCheck20:
  1276 000005DE 68[0E06]                 push LeftOpwCheck_1
  1277 000005E1 E85F13                   call error1
  1278 000005E4 83C402                   add  sp, 2
  1279                                  
  1280                                  ;-75   if (RegType==0) error1("no register defined");
  1281                                  
  1282                                  @@LeftOpwCheck19:
  1283 000005E7 A0[3F00]                 mov al, [RegType]
  1284 000005EA 3C00                     cmp al, 0
  1285 000005EC 0F850900                 jne @@LeftOpwCheck21
  1286 000005F0 68[2A06]                 push LeftOpwCheck_2
  1287 000005F3 E84D13                   call error1
  1288 000005F6 83C402                   add  sp, 2
  1289                                  
  1290                                  ;-76 }
  1291                                  
  1292                                  @@LeftOpwCheck21:
  1293                                  
  1294                                  ;-77 
  1295                                  
  1296                                  
  1297                                  ;-78 int getLeftOp() {//0,IMM,REG,ADR,MEM(disp,reg,RegType)
  1298                                  
  1299                                  @@retn:
  1300 000005F9 C3                       ret
  1301                                  ; ENDP
  1302 000005FA 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
  1303 00000603 65206465636C617265-
  1304 0000060C 6400               
  1305 0000060E 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
  1306 00000617 4F7053697A6520616E-
  1307 00000620 642052656753697A65-
  1308 00000629 00                 
  1309 0000062A 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
  1310 00000633 657220646566696E65-
  1311 0000063C 6400               
  1312                                  
  1313                                  getLeftOp:  ; *** PROC ***
  1314                                  
  1315                                  ;-79 //set: op1, disp->imm, reg, regt->size
  1316                                  
  1317                                  
  1318                                  ;-80   disp=0; imme=0; reg=0;
  1319                                  
  1320 0000063E 66B800000000             mov eax, 0
  1321 00000644 A3[4600]                 mov word [disp], ax
  1322 00000647 66B800000000             mov eax, 0
  1323 0000064D A3[4800]                 mov word [imme], ax
  1324 00000650 66B800000000             mov eax, 0
  1325 00000656 A2[4500]                 mov byte [reg], al
  1326                                  
  1327                                  ;-81 
  1328                                  
  1329                                  
  1330                                  ;-82   Op1=getOp1();
  1331                                  
  1332 00000659 E8A800                   call getOp1
  1333 0000065C A2[3D00]                 mov byte [Op1], al
  1334                                  
  1335                                  ;-83   if (isToken('[')) {Op1 = MEM; getMEM();  return;} //4
  1336                                  
  1337 0000065F 6A5B                     push 91
  1338 00000661 E81E09                   call isToken
  1339 00000664 83C402                   add  sp, 2
  1340 00000667 08C0                     or  al, al
  1341 00000669 0F840F00                 je @@getLeftOp22
  1342 0000066D 66B804000000             mov eax, 4
  1343 00000673 A2[3D00]                 mov byte [Op1], al
  1344 00000676 E81101                   call getMEM
  1345 00000679 E95200                   jmp @@retn
  1346                                  
  1347                                  ;-84   if (Op1 == 0) error1("Name of operand expected");
  1348                                  
  1349                                  @@getLeftOp22:
  1350 0000067C A0[3D00]                 mov al, [Op1]
  1351 0000067F 3C00                     cmp al, 0
  1352 00000681 0F850900                 jne @@getLeftOp23
  1353 00000685 68[CF06]                 push getLeftOp_0
  1354 00000688 E8B812                   call error1
  1355 0000068B 83C402                   add  sp, 2
  1356                                  
  1357                                  ;-85   if (Op1 == IMM) {imme=SymbolInt;         return;} //1
  1358                                  
  1359                                  @@getLeftOp23:
  1360 0000068E A0[3D00]                 mov al, [Op1]
  1361 00000691 3C01                     cmp al, 1
  1362 00000693 0F850900                 jne @@getLeftOp24
  1363 00000697 A1[2600]                 mov ax, [SymbolInt]
  1364 0000069A A3[4800]                 mov word [imme], ax
  1365 0000069D E92E00                   jmp @@retn
  1366                                  
  1367                                  ;-86   if (Op1 == REG)                          return;  //2
  1368                                  
  1369                                  @@getLeftOp24:
  1370 000006A0 A0[3D00]                 mov al, [Op1]
  1371 000006A3 3C02                     cmp al, 2
  1372 000006A5 0F850300                 jne @@getLeftOp25
  1373 000006A9 E92200                   jmp @@retn
  1374                                  
  1375                                  ;-87   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;} //3
  1376                                  
  1377                                  @@getLeftOp25:
  1378 000006AC A0[3D00]                 mov al, [Op1]
  1379 000006AF 3C03                     cmp al, 3
  1380 000006B1 0F851000                 jne @@getLeftOp26
  1381 000006B5 8B1E[5300]               mov bx, [LabelIx]
  1382 000006B9 D1E3                     shl bx, 1
  1383 000006BB 8B87A37A                 mov ax, [LabelAddr + bx]
  1384 000006BF A3[4600]                 mov word [disp], ax
  1385 000006C2 E90900                   jmp @@retn
  1386                                  
  1387                                  ;-88   error1("Name of operand expected #1");
  1388                                  
  1389                                  @@getLeftOp26:
  1390 000006C5 68[E806]                 push getLeftOp_1
  1391 000006C8 E87812                   call error1
  1392 000006CB 83C402                   add  sp, 2
  1393                                  
  1394                                  ;-89 }
  1395                                  
  1396                                  
  1397                                  ;-90 int getOp1() {//scan for a single operand
  1398                                  
  1399                                  @@retn:
  1400 000006CE C3                       ret
  1401                                  ; ENDP
  1402 000006CF 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
  1403 000006D8 706572616E64206578-
  1404 000006E1 70656374656400     
  1405 000006E8 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
  1406 000006F1 706572616E64206578-
  1407 000006FA 706563746564202331-
  1408 00000703 00                 
  1409                                  
  1410                                  getOp1:  ; *** PROC ***
  1411                                  
  1412                                  ;-91 //return:0, IMM, REG, ADR (not MEM)
  1413                                  
  1414                                  
  1415                                  ;-92 //set   :RegType, RegNo by testReg
  1416                                  
  1417                                  
  1418                                  ;-93 //set   :LabelIx by searchLabel
  1419                                  
  1420                                  
  1421                                  ;-94   if (TokeType == 0)      return 0;
  1422                                  
  1423 00000704 A0[3C00]                 mov al, [TokeType]
  1424 00000707 3C00                     cmp al, 0
  1425 00000709 0F850900                 jne @@getOp127
  1426 0000070D 66B800000000             mov eax, 0
  1427 00000713 E96000                   jmp @@retn
  1428                                  
  1429                                  ;-95   if (TokeType == DIGIT)  return IMM; //1
  1430                                  
  1431                                  @@getOp127:
  1432 00000716 A0[3C00]                 mov al, [TokeType]
  1433 00000719 3C01                     cmp al, 1
  1434 0000071B 0F850900                 jne @@getOp128
  1435 0000071F 66B801000000             mov eax, 1
  1436 00000725 E94E00                   jmp @@retn
  1437                                  
  1438                                  ;-96   if (TokeType == ALNUME) {
  1439                                  
  1440                                  @@getOp128:
  1441 00000728 A0[3C00]                 mov al, [TokeType]
  1442 0000072B 3C03                     cmp al, 3
  1443 0000072D 0F853C00                 jne @@getOp129
  1444                                  
  1445                                  ;-97     RegNo=testReg();
  1446                                  
  1447 00000731 E8680B                   call testReg
  1448 00000734 A2[4000]                 mov byte [RegNo], al
  1449                                  
  1450                                  ;-98     if (RegType)          return REG; //2
  1451                                  
  1452 00000737 A0[3F00]                 mov al, [RegType]
  1453 0000073A 08C0                     or  al, al
  1454 0000073C 0F840900                 je @@getOp130
  1455 00000740 66B802000000             mov eax, 2
  1456 00000746 E92D00                   jmp @@retn
  1457                                  
  1458                                  ;-99     LabelIx=searchLabel();
  1459                                  
  1460                                  @@getOp130:
  1461 00000749 E8A105                   call searchLabel
  1462 0000074C A3[5300]                 mov word [LabelIx], ax
  1463                                  
  1464                                  ;-100     if (LabelIx)          return ADR; //3
  1465                                  
  1466 0000074F A1[5300]                 mov ax, [LabelIx]
  1467 00000752 08C0                     or  al, al
  1468 00000754 0F840C00                 je @@getOp131
  1469 00000758 66B803000000             mov eax, 3
  1470 0000075E E91500                   jmp @@retn
  1471                                  
  1472                                  ;-101     else error1("variable not found"); }
  1473                                  
  1474 00000761 E90900                   jmp @@getOp132
  1475                                  @@getOp131:
  1476 00000764 68[7707]                 push getOp1_0
  1477 00000767 E8D911                   call error1
  1478 0000076A 83C402                   add  sp, 2
  1479                                  @@getOp132:
  1480                                  
  1481                                  ;-102   return 0;
  1482                                  
  1483                                  @@getOp129:
  1484 0000076D 66B800000000             mov eax, 0
  1485 00000773 E90000                   jmp @@retn
  1486                                  
  1487                                  ;-103 }
  1488                                  
  1489                                  
  1490                                  ;-104 int getMEM() {//   e.g. [array+bp+si-4]
  1491                                  
  1492                                  @@retn:
  1493 00000776 C3                       ret
  1494                                  ; ENDP
  1495 00000777 7661726961626C6520-     getOp1_0 db "variable not found",0
  1496 00000780 6E6F7420666F756E64-
  1497 00000789 00                 
  1498                                  
  1499                                  getMEM:  ; *** PROC ***
  1500                                  
  1501                                  ;-105 //set: disp, reg, RegType
  1502                                  
  1503                                  
  1504                                  ;-106   char op2; char r1;
  1505                                  
  1506                                  
  1507                                  ;-107   disp=0; r1=0; RegType=0;
  1508                                  
  1509                                  ;Function : getMEM, Number of local variables: 2
  1510                                  ;   # type sign width line used address name   list of local variables
  1511                                  ;  200 var sign byte   106 NULL bp-2    op2
  1512                                  ;  201 var sign byte   106 NULL bp-4    r1;
  1513 0000078A C8040000                 ENTER  4,0
  1514 0000078E 66B800000000             mov eax, 0
  1515 00000794 A3[4600]                 mov word [disp], ax
  1516 00000797 66B800000000             mov eax, 0
  1517 0000079D 8846FC                   mov byte [bp-4], al
  1518 000007A0 66B800000000             mov eax, 0
  1519 000007A6 A2[3F00]                 mov byte [RegType], al
  1520                                  
  1521                                  ;-108   do {
  1522                                  
  1523                                  @@getMEM33:
  1524                                  
  1525                                  ;-109     getTokeType();
  1526                                  
  1527 000007A9 E85904                   call getTokeType
  1528                                  
  1529                                  ;-110     op2=getOp1();
  1530                                  
  1531 000007AC E855FF                   call getOp1
  1532 000007AF 8846FE                   mov byte [bp-2], al
  1533                                  
  1534                                  ;-111     if (op2 ==   0) syntaxerror();
  1535                                  
  1536 000007B2 8A46FE                   mov al, [bp-2]
  1537 000007B5 3C00                     cmp al, 0
  1538 000007B7 0F850300                 jne @@getMEM34
  1539 000007BB E8A512                   call syntaxerror
  1540                                  
  1541                                  ;-112     if (op2 == IMM) disp=disp+SymbolInt;
  1542                                  
  1543                                  @@getMEM34:
  1544 000007BE 8A46FE                   mov al, [bp-2]
  1545 000007C1 3C01                     cmp al, 1
  1546 000007C3 0F850A00                 jne @@getMEM35
  1547 000007C7 A1[4600]                 mov ax, [disp]
  1548 000007CA 0306[2600]               add ax, [SymbolInt]
  1549 000007CE A3[4600]                 mov word [disp], ax
  1550                                  
  1551                                  ;-113     if (op2 == REG) if (r1) r1=getIndReg2(r1);
  1552                                  
  1553                                  @@getMEM35:
  1554 000007D1 8A46FE                   mov al, [bp-2]
  1555 000007D4 3C02                     cmp al, 2
  1556 000007D6 0F852100                 jne @@getMEM36
  1557 000007DA 8A46FC                   mov al, [bp-4]
  1558 000007DD 08C0                     or  al, al
  1559 000007DF 0F841200                 je @@getMEM37
  1560 000007E3 8A46FC                   mov al, byte [bp-4]
  1561 000007E6 B400                     mov ah, 0
  1562 000007E8 50                       push ax
  1563 000007E9 E80001                   call getIndReg2
  1564 000007EC 83C402                   add  sp, 2
  1565 000007EF 8846FC                   mov byte [bp-4], al
  1566                                  
  1567                                  ;-114                     else    r1=getIndReg1(  );
  1568                                  
  1569 000007F2 E90600                   jmp @@getMEM38
  1570                                  @@getMEM37:
  1571 000007F5 E87F00                   call getIndReg1
  1572 000007F8 8846FC                   mov byte [bp-4], al
  1573                                  
  1574                                  ;-115     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];//is MEM variable
  1575                                  
  1576                                  @@getMEM38:
  1577                                  @@getMEM36:
  1578 000007FB 8A46FE                   mov al, [bp-2]
  1579 000007FE 3C03                     cmp al, 3
  1580 00000800 0F851000                 jne @@getMEM39
  1581 00000804 A1[4600]                 mov ax, [disp]
  1582 00000807 8B1E[5300]               mov bx, [LabelIx]
  1583 0000080B D1E3                     shl bx, 1
  1584 0000080D 0387A37A                 add ax, [LabelAddr + bx]
  1585 00000811 A3[4600]                 mov word [disp], ax
  1586                                  
  1587                                  ;-116     if (isToken('-')) {
  1588                                  
  1589                                  @@getMEM39:
  1590 00000814 6A2D                     push 45
  1591 00000816 E86907                   call isToken
  1592 00000819 83C402                   add  sp, 2
  1593 0000081C 08C0                     or  al, al
  1594 0000081E 0F841900                 je @@getMEM40
  1595                                  
  1596                                  ;-117       getTokeType();
  1597                                  
  1598 00000822 E8E003                   call getTokeType
  1599                                  
  1600                                  ;-118       if (TokeType != DIGIT) numbererror();
  1601                                  
  1602 00000825 A0[3C00]                 mov al, [TokeType]
  1603 00000828 3C01                     cmp al, 1
  1604 0000082A 0F840300                 je  @@getMEM41
  1605 0000082E E8C711                   call numbererror
  1606                                  
  1607                                  ;-119       disp = disp - SymbolInt;
  1608                                  
  1609                                  @@getMEM41:
  1610 00000831 A1[4600]                 mov ax, [disp]
  1611 00000834 2B06[2600]               sub ax, [SymbolInt]
  1612 00000838 A3[4600]                 mov word [disp], ax
  1613                                  
  1614                                  ;-120     }
  1615                                  
  1616                                  
  1617                                  ;-121   } while (isToken('+'));
  1618                                  
  1619                                  @@getMEM40:
  1620 0000083B 6A2B                     push 43
  1621 0000083D E84207                   call isToken
  1622 00000840 83C402                   add  sp, 2
  1623 00000843 08C0                     or  al, al
  1624 00000845 0F840300                 je @@getMEM42
  1625 00000849 E95DFF                   jmp @@getMEM33
  1626                                  @@getMEM42:
  1627                                  
  1628                                  ;-122   if (isToken(']') == 0) errorexit("] expected");
  1629                                  
  1630 0000084C 6A5D                     push 93
  1631 0000084E E83107                   call isToken
  1632 00000851 83C402                   add  sp, 2
  1633 00000854 83F800                   cmp ax, 0
  1634 00000857 0F850900                 jne @@getMEM43
  1635 0000085B 68[6C08]                 push getMEM_0
  1636 0000085E E81312                   call errorexit
  1637 00000861 83C402                   add  sp, 2
  1638                                  
  1639                                  ;-123   reg=r1;
  1640                                  
  1641                                  @@getMEM43:
  1642 00000864 8A46FC                   mov al, [bp-4]
  1643 00000867 A2[4500]                 mov byte [reg], al
  1644                                  
  1645                                  ;-124 }
  1646                                  
  1647                                  
  1648                                  ;-125 int getIndReg1() {char m; m=0;
  1649 0000086A C9                       LEAVE
  1650 0000086B C3                       ret
  1651                                  ; ENDP
  1652 0000086C 5D2065787065637465-     getMEM_0 db "] expected",0
  1653 00000875 6400               
  1654                                  
  1655                                  getIndReg1:  ; *** PROC ***
  1656                                  ;Function : getIndReg1, Number of local variables: 1
  1657                                  ;   # type sign width line used address name   list of local variables
  1658                                  ;  200 var sign byte   125 NULL bp-2    m;
  1659 00000877 C8020000                 ENTER  2,0
  1660 0000087B 66B800000000             mov eax, 0
  1661 00000881 8846FE                   mov byte [bp-2], al
  1662                                  
  1663                                  ;-126   if (RegType !=WORD) indexerror();
  1664                                  
  1665 00000884 A0[3F00]                 mov al, [RegType]
  1666 00000887 3C02                     cmp al, 2
  1667 00000889 0F840300                 je  @@getIndReg144
  1668 0000088D E84711                   call indexerror
  1669                                  
  1670                                  ;-127   if (RegNo==3) m=7;//BX
  1671                                  
  1672                                  @@getIndReg144:
  1673 00000890 A0[4000]                 mov al, [RegNo]
  1674 00000893 3C03                     cmp al, 3
  1675 00000895 0F850900                 jne @@getIndReg145
  1676 00000899 66B807000000             mov eax, 7
  1677 0000089F 8846FE                   mov byte [bp-2], al
  1678                                  
  1679                                  ;-128   if (RegNo==5) m=6;//BP change to BP+0
  1680                                  
  1681                                  @@getIndReg145:
  1682 000008A2 A0[4000]                 mov al, [RegNo]
  1683 000008A5 3C05                     cmp al, 5
  1684 000008A7 0F850900                 jne @@getIndReg146
  1685 000008AB 66B806000000             mov eax, 6
  1686 000008B1 8846FE                   mov byte [bp-2], al
  1687                                  
  1688                                  ;-129   if (RegNo==7) m=5;//DI
  1689                                  
  1690                                  @@getIndReg146:
  1691 000008B4 A0[4000]                 mov al, [RegNo]
  1692 000008B7 3C07                     cmp al, 7
  1693 000008B9 0F850900                 jne @@getIndReg147
  1694 000008BD 66B805000000             mov eax, 5
  1695 000008C3 8846FE                   mov byte [bp-2], al
  1696                                  
  1697                                  ;-130   if (RegNo==6) m=4;//SI
  1698                                  
  1699                                  @@getIndReg147:
  1700 000008C6 A0[4000]                 mov al, [RegNo]
  1701 000008C9 3C06                     cmp al, 6
  1702 000008CB 0F850900                 jne @@getIndReg148
  1703 000008CF 66B804000000             mov eax, 4
  1704 000008D5 8846FE                   mov byte [bp-2], al
  1705                                  
  1706                                  ;-131   if (m    ==0) indexerror();
  1707                                  
  1708                                  @@getIndReg148:
  1709 000008D8 8A46FE                   mov al, [bp-2]
  1710 000008DB 3C00                     cmp al, 0
  1711 000008DD 0F850300                 jne @@getIndReg149
  1712 000008E1 E8F310                   call indexerror
  1713                                  
  1714                                  ;-132   return m;
  1715                                  
  1716                                  @@getIndReg149:
  1717 000008E4 8A46FE                   mov al, [bp-2]
  1718 000008E7 E90000                   jmp @@retn
  1719                                  
  1720                                  ;-133 }
  1721                                  
  1722                                  
  1723                                  ;-134 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1724                                  
  1725 000008EA C9                      @@retn: LEAVE
  1726 000008EB C3                       ret
  1727                                  ; ENDP
  1728                                  
  1729                                  getIndReg2:  ; *** PROC ***
  1730                                  ;Function : getIndReg2, Number of local variables: 2
  1731                                  ;   # type sign width line used address name   list of local variables
  1732                                  ;  200 var sign byte   134 NULL bp+4    r1
  1733                                  ;  201 var sign byte   134 NULL bp-2    m;
  1734 000008EC C8020000                 ENTER  2,0
  1735 000008F0 66B804000000             mov eax, 4
  1736 000008F6 8846FE                   mov byte [bp-2], al
  1737                                  
  1738                                  ;-135   if (RegType !=WORD) indexerror();
  1739                                  
  1740 000008F9 A0[3F00]                 mov al, [RegType]
  1741 000008FC 3C02                     cmp al, 2
  1742 000008FE 0F840300                 je  @@getIndReg250
  1743 00000902 E8D210                   call indexerror
  1744                                  
  1745                                  ;-136   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1746                                  
  1747                                  @@getIndReg250:
  1748 00000905 A0[4000]                 mov al, [RegNo]
  1749 00000908 3C07                     cmp al, 7
  1750 0000090A 0F852700                 jne @@getIndReg251
  1751 0000090E 8A4604                   mov al, [bp+4]
  1752 00000911 3C06                     cmp al, 6
  1753 00000913 0F850C00                 jne @@getIndReg252
  1754 00000917 66B803000000             mov eax, 3
  1755 0000091D 8846FE                   mov byte [bp-2], al
  1756                                  
  1757                                  ;-137            else if (r1==7) m=1;//BX+DI
  1758                                  
  1759 00000920 E91200                   jmp @@getIndReg253
  1760                                  @@getIndReg252:
  1761 00000923 8A4604                   mov al, [bp+4]
  1762 00000926 3C07                     cmp al, 7
  1763 00000928 0F850900                 jne @@getIndReg254
  1764 0000092C 66B801000000             mov eax, 1
  1765 00000932 8846FE                   mov byte [bp-2], al
  1766                                  
  1767                                  ;-138   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1768                                  
  1769                                  @@getIndReg254:
  1770                                  @@getIndReg253:
  1771                                  @@getIndReg251:
  1772 00000935 A0[4000]                 mov al, [RegNo]
  1773 00000938 3C06                     cmp al, 6
  1774 0000093A 0F852700                 jne @@getIndReg255
  1775 0000093E 8A4604                   mov al, [bp+4]
  1776 00000941 3C06                     cmp al, 6
  1777 00000943 0F850C00                 jne @@getIndReg256
  1778 00000947 66B802000000             mov eax, 2
  1779 0000094D 8846FE                   mov byte [bp-2], al
  1780                                  
  1781                                  ;-139            else if (r1==7) m=0;//BX+DI
  1782                                  
  1783 00000950 E91200                   jmp @@getIndReg257
  1784                                  @@getIndReg256:
  1785 00000953 8A4604                   mov al, [bp+4]
  1786 00000956 3C07                     cmp al, 7
  1787 00000958 0F850900                 jne @@getIndReg258
  1788 0000095C 66B800000000             mov eax, 0
  1789 00000962 8846FE                   mov byte [bp-2], al
  1790                                  
  1791                                  ;-140   if (m > 3) indexerror();
  1792                                  
  1793                                  @@getIndReg258:
  1794                                  @@getIndReg257:
  1795                                  @@getIndReg255:
  1796 00000965 8A46FE                   mov al, [bp-2]
  1797 00000968 3C03                     cmp al, 3
  1798 0000096A 0F8E0300                 jle @@getIndReg259
  1799 0000096E E86610                   call indexerror
  1800                                  
  1801                                  ;-141   return m;
  1802                                  
  1803                                  @@getIndReg259:
  1804 00000971 8A46FE                   mov al, [bp-2]
  1805 00000974 E90000                   jmp @@retn
  1806                                  
  1807                                  ;-142 }
  1808                                  
  1809                                  
  1810                                  ;-143 
  1811                                  
  1812                                  
  1813                                  ;-144 // generate code ...........................................................
  1814                                  
  1815                                  
  1816                                  ;-145 int gen66h() {genCode8(0x66);}
  1817                                  
  1818 00000977 C9                      @@retn: LEAVE
  1819 00000978 C3                       ret
  1820                                  ; ENDP
  1821                                  
  1822                                  gen66h:  ; *** PROC ***
  1823 00000979 6A66                     push 102
  1824 0000097B E80400                   call genCode8
  1825 0000097E 83C402                   add  sp, 2
  1826                                  
  1827                                  ;-146 int genCode8(char c) {
  1828                                  
  1829 00000981 C3                       ret
  1830                                  ; ENDP
  1831                                  
  1832                                  genCode8:  ; *** PROC ***
  1833                                  
  1834                                  ;-147 //set: BinLen++, OpPrintIndex++
  1835                                  
  1836                                  
  1837                                  ;-148   FileBin[BinLen]=c;
  1838                                  
  1839                                  ;Function : genCode8, Number of local variables: 1
  1840                                  ;   # type sign width line used address name   list of local variables
  1841                                  ;  200 var sign byte   146 NULL bp+4    c;
  1842 00000982 C8000000                 ENTER  0,0
  1843 00000986 8A4604                   mov al, [bp+4]
  1844 00000989 8B1E[5500]               mov bx, [BinLen]
  1845 0000098D 88876B7B                 mov [FileBin+bx], al
  1846                                  
  1847                                  ;-149   BinLen++;
  1848                                  
  1849 00000991 FF06[5500]               inc  word [BinLen]
  1850                                  
  1851                                  ;-150   PC++;
  1852                                  
  1853 00000995 FF06[3700]               inc  word [PC]
  1854                                  
  1855                                  ;-151   if (OpPrintIndex < OPMAXLEN) {
  1856                                  
  1857 00000999 A1[4A00]                 mov ax, [OpPrintIndex]
  1858 0000099C 83F805                   cmp ax, 5
  1859 0000099F 0F8D0F00                 jge @@genCode860
  1860                                  
  1861                                  ;-152     OpPos[OpPrintIndex]=c;
  1862                                  
  1863 000009A3 8A4604                   mov al, [bp+4]
  1864 000009A6 8B1E[4A00]               mov bx, [OpPrintIndex]
  1865 000009AA 8887B676                 mov [OpPos+bx], al
  1866                                  
  1867                                  ;-153     OpPrintIndex++;
  1868                                  
  1869 000009AE FF06[4A00]               inc  word [OpPrintIndex]
  1870                                  
  1871                                  ;-154   }
  1872                                  
  1873                                  
  1874                                  ;-155 }
  1875                                  
  1876                                  @@genCode860:
  1877                                  
  1878                                  ;-156 int genCode16(int i) {
  1879 000009B2 C9                       LEAVE
  1880 000009B3 C3                       ret
  1881                                  ; ENDP
  1882                                  
  1883                                  genCode16:  ; *** PROC ***
  1884                                  
  1885                                  ;-157   genCode8(i); i=i >> 8;
  1886                                  
  1887                                  ;Function : genCode16, Number of local variables: 1
  1888                                  ;   # type sign width line used address name   list of local variables
  1889                                  ;  200 var sign word   156 NULL bp+4    i;
  1890 000009B4 C8000000                 ENTER  0,0
  1891 000009B8 FF7604                   push word [bp+4]
  1892 000009BB E8C4FF                   call genCode8
  1893 000009BE 83C402                   add  sp, 2
  1894 000009C1 8B4604                   mov ax, [bp+4]
  1895 000009C4 C1E808                   shr ax, 8
  1896 000009C7 894604                   mov word [bp+4], ax
  1897                                  
  1898                                  ;-158   genCode8(i);
  1899                                  
  1900 000009CA FF7604                   push word [bp+4]
  1901 000009CD E8B2FF                   call genCode8
  1902 000009D0 83C402                   add  sp, 2
  1903                                  
  1904                                  ;-159 }
  1905                                  
  1906                                  
  1907                                  ;-160 int genInstruction(char No, int loc) {
  1908 000009D3 C9                       LEAVE
  1909 000009D4 C3                       ret
  1910                                  ; ENDP
  1911                                  
  1912                                  genInstruction:  ; *** PROC ***
  1913                                  
  1914                                  ;-161   char c;//set: OpCodePtr++
  1915                                  
  1916                                  
  1917                                  ;-162   if(loc) OpCodePtr=OpCodePtr+loc;
  1918                                  
  1919                                  ;Function : genInstruction, Number of local variables: 3
  1920                                  ;   # type sign width line used address name   list of local variables
  1921                                  ;  200 var sign byte   160 NULL bp+4    No
  1922                                  ;  201 var sign word   160 NULL bp+6    loc
  1923                                  ;  202 var sign byte   161 NULL bp-2    c;
  1924 000009D5 C8020000                 ENTER  2,0
  1925 000009D9 8B4606                   mov ax, [bp+6]
  1926 000009DC 08C0                     or  al, al
  1927 000009DE 0F840900                 je @@genInstruction61
  1928 000009E2 A1[4C00]                 mov ax, [OpCodePtr]
  1929 000009E5 034606                   add ax, [bp+6]
  1930 000009E8 A3[4C00]                 mov word [OpCodePtr], ax
  1931                                  
  1932                                  ;-163   c= *OpCodePtr + No;
  1933                                  
  1934                                  @@genInstruction61:
  1935 000009EB 8B1E[4C00]               mov bx, [OpCodePtr]
  1936 000009EF 8A07                     mov al, [bx]
  1937 000009F1 B400                     mov ah, 0
  1938 000009F3 024604                   add al, [bp+4]
  1939 000009F6 8846FE                   mov byte [bp-2], al
  1940                                  
  1941                                  ;-164   genCode8(c);
  1942                                  
  1943 000009F9 8A46FE                   mov al, byte [bp-2]
  1944 000009FC B400                     mov ah, 0
  1945 000009FE 50                       push ax
  1946 000009FF E880FF                   call genCode8
  1947 00000A02 83C402                   add  sp, 2
  1948                                  
  1949                                  ;-165 }
  1950                                  
  1951                                  
  1952                                  ;-166 int genCodeInREG() {char x; //get Code for second byte
  1953 00000A05 C9                       LEAVE
  1954 00000A06 C3                       ret
  1955                                  ; ENDP
  1956                                  
  1957                                  genCodeInREG:  ; *** PROC ***
  1958                                  
  1959                                  ;-167   OpCodePtr++;
  1960                                  
  1961                                  ;Function : genCodeInREG, Number of local variables: 1
  1962                                  ;   # type sign width line used address name   list of local variables
  1963                                  ;  200 var sign byte   166 NULL bp-2    x;
  1964 00000A07 C8020000                 ENTER  2,0
  1965 00000A0B FF06[4C00]               inc  word [OpCodePtr]
  1966                                  
  1967                                  ;-168   x= *OpCodePtr;
  1968                                  
  1969 00000A0F 8B1E[4C00]               mov bx, [OpCodePtr]
  1970 00000A13 8A07                     mov al, [bx]
  1971 00000A15 B400                     mov ah, 0
  1972 00000A17 8846FE                   mov byte [bp-2], al
  1973                                  
  1974                                  ;-169   writeEA(x);
  1975                                  
  1976 00000A1A 8A46FE                   mov al, byte [bp-2]
  1977 00000A1D B400                     mov ah, 0
  1978 00000A1F 50                       push ax
  1979 00000A20 E81200                   call writeEA
  1980 00000A23 83C402                   add  sp, 2
  1981                                  
  1982                                  ;-170 }
  1983                                  
  1984                                  
  1985                                  ;-171 int genModRegRM(){ writeEA(reg);//todo
  1986 00000A26 C9                       LEAVE
  1987 00000A27 C3                       ret
  1988                                  ; ENDP
  1989                                  
  1990                                  genModRegRM:  ; *** PROC ***
  1991 00000A28 A0[4500]                 mov al, byte [reg]
  1992 00000A2B B400                     mov ah, 0
  1993 00000A2D 50                       push ax
  1994 00000A2E E80400                   call writeEA
  1995 00000A31 83C402                   add  sp, 2
  1996                                  
  1997                                  ;-172 }
  1998                                  
  1999                                  
  2000                                  ;-173 int writeEA(char xxx) {//need: Op1, disp, RegNo, reg
  2001                                  
  2002 00000A34 C3                       ret
  2003                                  ; ENDP
  2004                                  
  2005                                  writeEA:  ; *** PROC ***
  2006                                  
  2007                                  ;-174   char len;
  2008                                  
  2009                                  
  2010                                  ;-175   len=0;
  2011                                  
  2012                                  ;Function : writeEA, Number of local variables: 2
  2013                                  ;   # type sign width line used address name   list of local variables
  2014                                  ;  200 var sign byte   173 NULL bp+4    xxx
  2015                                  ;  201 var sign byte   174 NULL bp-2    len;
  2016 00000A35 C8020000                 ENTER  2,0
  2017 00000A39 66B800000000             mov eax, 0
  2018 00000A3F 8846FE                   mov byte [bp-2], al
  2019                                  
  2020                                  ;-176   xxx = xxx << 3;//in reg field of mod r/m
  2021                                  
  2022 00000A42 8A4604                   mov al, [bp+4]
  2023 00000A45 C0E003                   shl al, 3
  2024 00000A48 884604                   mov byte [bp+4], al
  2025                                  
  2026                                  ;-177   if (Op1 ==   0) addrexit();
  2027                                  
  2028 00000A4B A0[3D00]                 mov al, [Op1]
  2029 00000A4E 3C00                     cmp al, 0
  2030 00000A50 0F850300                 jne @@writeEA62
  2031 00000A54 E83410                   call addrexit
  2032                                  
  2033                                  ;-178   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}  //2
  2034                                  
  2035                                  @@writeEA62:
  2036 00000A57 A0[3D00]                 mov al, [Op1]
  2037 00000A5A 3C02                     cmp al, 2
  2038 00000A5C 0F850E00                 jne @@writeEA63
  2039 00000A60 804E04C0                 or  byte [bp+4], 192
  2040 00000A64 8A4604                   mov al, [bp+4]
  2041 00000A67 0206[4000]               add al, [RegNo]
  2042 00000A6B 884604                   mov byte [bp+4], al
  2043                                  
  2044                                  ;-179   if (Op1 == ADR) {xxx |= 6; len=2; }                //3
  2045                                  
  2046                                  @@writeEA63:
  2047 00000A6E A0[3D00]                 mov al, [Op1]
  2048 00000A71 3C03                     cmp al, 3
  2049 00000A73 0F850D00                 jne @@writeEA64
  2050 00000A77 804E0406                 or  byte [bp+4], 6
  2051 00000A7B 66B802000000             mov eax, 2
  2052 00000A81 8846FE                   mov byte [bp-2], al
  2053                                  
  2054                                  ;-180   if (Op1 == MEM) { xxx = xxx + reg;                 //4
  2055                                  
  2056                                  @@writeEA64:
  2057 00000A84 A0[3D00]                 mov al, [Op1]
  2058 00000A87 3C04                     cmp al, 4
  2059 00000A89 0F854600                 jne @@writeEA65
  2060 00000A8D 8A4604                   mov al, [bp+4]
  2061 00000A90 0206[4500]               add al, [reg]
  2062 00000A94 884604                   mov byte [bp+4], al
  2063                                  
  2064                                  ;-181     if (disp) {
  2065                                  
  2066 00000A97 A1[4600]                 mov ax, [disp]
  2067 00000A9A 08C0                     or  al, al
  2068 00000A9C 0F843300                 je @@writeEA66
  2069                                  
  2070                                  ;-182       disp;
  2071                                  
  2072 00000AA0 A1[4600]                 mov ax, [disp]
  2073                                  
  2074                                  ;-183       if(ax > 127) len=2;
  2075                                  
  2076 00000AA3 83F87F                   cmp  ax, 127
  2077 00000AA6 0F8E0C00                 jle @@writeEA67
  2078 00000AAA 66B802000000             mov eax, 2
  2079 00000AB0 8846FE                   mov byte [bp-2], al
  2080                                  
  2081                                  ;-184       else len=1;
  2082                                  
  2083 00000AB3 E90900                   jmp @@writeEA68
  2084                                  @@writeEA67:
  2085 00000AB6 66B801000000             mov eax, 1
  2086 00000ABC 8846FE                   mov byte [bp-2], al
  2087                                  
  2088                                  ;-185       if (len == 1) xxx |= 0x40;
  2089                                  
  2090                                  @@writeEA68:
  2091 00000ABF 8A46FE                   mov al, [bp-2]
  2092 00000AC2 3C01                     cmp al, 1
  2093 00000AC4 0F850700                 jne @@writeEA69
  2094 00000AC8 804E0440                 or  byte [bp+4], 64
  2095                                  
  2096                                  ;-186       else xxx |= 0x80;
  2097                                  
  2098 00000ACC E90400                   jmp @@writeEA70
  2099                                  @@writeEA69:
  2100 00000ACF 804E0480                 or  byte [bp+4], 128
  2101                                  
  2102                                  ;-187     }
  2103                                  
  2104                                  @@writeEA70:
  2105                                  
  2106                                  ;-188   }
  2107                                  
  2108                                  @@writeEA66:
  2109                                  
  2110                                  ;-189   genCode8(xxx);// gen second byte
  2111                                  
  2112                                  @@writeEA65:
  2113 00000AD3 8A4604                   mov al, byte [bp+4]
  2114 00000AD6 B400                     mov ah, 0
  2115 00000AD8 50                       push ax
  2116 00000AD9 E8A6FE                   call genCode8
  2117 00000ADC 83C402                   add  sp, 2
  2118                                  
  2119                                  ;-190   if (len == 1) genCode8 (disp);
  2120                                  
  2121 00000ADF 8A46FE                   mov al, [bp-2]
  2122 00000AE2 3C01                     cmp al, 1
  2123 00000AE4 0F850A00                 jne @@writeEA71
  2124 00000AE8 FF36[4600]               push word [disp]
  2125 00000AEC E893FE                   call genCode8
  2126 00000AEF 83C402                   add  sp, 2
  2127                                  
  2128                                  ;-191   if (len == 2) genCode16(disp);
  2129                                  
  2130                                  @@writeEA71:
  2131 00000AF2 8A46FE                   mov al, [bp-2]
  2132 00000AF5 3C02                     cmp al, 2
  2133 00000AF7 0F850A00                 jne @@writeEA72
  2134 00000AFB FF36[4600]               push word [disp]
  2135 00000AFF E8B2FE                   call genCode16
  2136 00000B02 83C402                   add  sp, 2
  2137                                  
  2138                                  ;-192 }
  2139                                  
  2140                                  @@writeEA72:
  2141                                  
  2142                                  ;-193 
  2143                                  
  2144                                  
  2145                                  ;-194 int testx() { __asm {
  2146 00000B05 C9                       LEAVE
  2147 00000B06 C3                       ret
  2148                                  ; ENDP
  2149                                  
  2150                                  testx:  ; *** PROC ***
  2151                                  
  2152                                  
  2153                                  ;-195 inc byte [Version1]   ;FE 06 [1000]
  2154                                  
  2155 00000B07 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  2156                                  
  2157                                  ;-196 add bx, ax    ;01 C3
  2158                                  
  2159 00000B0B 01C3                    add bx, ax    ;01 C3
  2160                                  
  2161                                  ;-197 add ax, bx    ;01 D8
  2162                                  
  2163 00000B0D 01D8                    add ax, bx    ;01 D8
  2164                                  
  2165                                  ;-198 add word ax, [bx] ;03 07
  2166                                  
  2167 00000B0F 0307                    add word ax, [bx] ;03 07
  2168                                  
  2169                                  ;-199 VA dw 8
  2170                                  
  2171 00000B11 0800                    VA dw 8
  2172                                  
  2173                                  ;-200 mov byte [bp- 4], al ;88 46 FC
  2174                                  
  2175 00000B13 8846FC                  mov byte [bp- 4], al ;88 46 FC
  2176                                  
  2177                                  ;-201 mov      [VA+bx], al ;88 87 [300F]
  2178                                  
  2179 00000B16 8887[110B]              mov      [VA+bx], al ;88 87 [300F]
  2180                                  
  2181                                  ;-202 }  }
  2182                                  
  2183                                  
  2184                                  
  2185                                  ;-203 //#include "AS1.C"
  2186                                  
  2187                                  
  2188                                  ;-204 #include "PARSE.C"
  2189                                  
  2190 00000B1A C3                       ret
  2191                                  ; ENDP
  2192                                  ;Use include file: PARSE.C
  2193                                  
  2194                                  ;-1 int parse() {
  2195                                  
  2196                                  
  2197                                  parse:  ; *** PROC ***
  2198                                  
  2199                                  ;-2   LabelNamePtr= &LabelNames;
  2200                                  
  2201 00000B1B B8BB76                   mov ax, LabelNames
  2202 00000B1E A3[4F00]                 mov word [LabelNamePtr], ax
  2203                                  
  2204                                  ;-3   do {
  2205                                  
  2206                                  @@parse73:
  2207                                  
  2208                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  2209                                  
  2210 00000B21 A1[3700]                 mov ax, [PC]
  2211 00000B24 A3[3900]                 mov word [PCStart], ax
  2212 00000B27 66B800000000             mov eax, 0
  2213 00000B2D A2[4100]                 mov byte [OpSize], al
  2214 00000B30 66B800000000             mov eax, 0
  2215 00000B36 A3[4A00]                 mov word [OpPrintIndex], ax
  2216 00000B39 66B820000000             mov eax, 32
  2217 00000B3F A2[4E00]                 mov byte [PrReloc], al
  2218                                  
  2219                                  ;-5     getLine();
  2220                                  
  2221 00000B42 E8A104                   call getLine
  2222                                  
  2223                                  ;-6     InputPtr = &InputBuf;
  2224                                  
  2225 00000B45 B86E75                   mov ax, InputBuf
  2226 00000B48 A3[2800]                 mov word [InputPtr], ax
  2227                                  
  2228                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2229                                  
  2230 00000B4B E8B700                   call getTokeType
  2231                                  
  2232                                  ;-8     if (TokeType == ALNUME) {
  2233                                  
  2234 00000B4E A0[3C00]                 mov al, [TokeType]
  2235 00000B51 3C03                     cmp al, 3
  2236 00000B53 0F851300                 jne @@parse74
  2237                                  
  2238                                  ;-9       if (isLabel) { //set in getName
  2239                                  
  2240 00000B57 A0[3B00]                 mov al, [isLabel]
  2241 00000B5A 08C0                     or  al, al
  2242 00000B5C 0F840A00                 je @@parse75
  2243                                  
  2244                                  ;-10         storeLabel();
  2245                                  
  2246 00000B60 E84001                   call storeLabel
  2247                                  
  2248                                  ;-11         InputPtr++;//remove :
  2249                                  
  2250 00000B63 FF06[2800]               inc  word [InputPtr]
  2251                                  
  2252                                  ;-12         getTokeType();
  2253                                  
  2254 00000B67 E89B00                   call getTokeType
  2255                                  
  2256                                  ;-13       }
  2257                                  
  2258                                  
  2259                                  ;-14     }
  2260                                  
  2261                                  @@parse75:
  2262                                  
  2263                                  ;-15     if (TokeType == ALNUME) {
  2264                                  
  2265                                  @@parse74:
  2266 00000B6A A0[3C00]                 mov al, [TokeType]
  2267 00000B6D 3C03                     cmp al, 3
  2268 00000B6F 0F851B00                 jne @@parse76
  2269                                  
  2270                                  ;-16       lookCode();// and OpCodePtr
  2271                                  
  2272 00000B73 E80F03                   call lookCode
  2273                                  
  2274                                  ;-17       if(CodeType) process();
  2275                                  
  2276 00000B76 A0[3E00]                 mov al, [CodeType]
  2277 00000B79 08C0                     or  al, al
  2278 00000B7B 0F840600                 je @@parse77
  2279 00000B7F E88EF8                   call process
  2280                                  
  2281                                  ;-18       else getVariable();
  2282                                  
  2283 00000B82 E90300                   jmp @@parse78
  2284                                  @@parse77:
  2285 00000B85 E8C501                   call getVariable
  2286                                  
  2287                                  ;-19       skipRest();
  2288                                  
  2289                                  @@parse78:
  2290 00000B88 E82504                   call skipRest
  2291                                  
  2292                                  ;-20     }
  2293                                  
  2294                                  
  2295                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2296                                  
  2297 00000B8B E92700                   jmp @@parse79
  2298                                  @@parse76:
  2299 00000B8E A0[3C00]                 mov al, [TokeType]
  2300 00000B91 3C03                     cmp al, 3
  2301 00000B93 0F8E0C00                 jle @@parse80
  2302 00000B97 68[C60B]                 push parse_0
  2303 00000B9A E8A60D                   call error1
  2304 00000B9D 83C402                   add  sp, 2
  2305                                  
  2306                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2307                                  
  2308 00000BA0 E91200                   jmp @@parse81
  2309                                  @@parse80:
  2310 00000BA3 A0[3C00]                 mov al, [TokeType]
  2311 00000BA6 3C01                     cmp al, 1
  2312 00000BA8 0F850900                 jne @@parse82
  2313 00000BAC 68[E40B]                 push parse_1
  2314 00000BAF E8910D                   call error1
  2315 00000BB2 83C402                   add  sp, 2
  2316                                  
  2317                                  ;-23     printLine();
  2318                                  
  2319                                  @@parse82:
  2320                                  @@parse81:
  2321                                  @@parse79:
  2322 00000BB5 E8200B                   call printLine
  2323                                  
  2324                                  ;-24   } while (DOS_NoBytes != 0 );
  2325                                  
  2326 00000BB8 A1[3400]                 mov ax, [DOS_NoBytes]
  2327 00000BBB 83F800                   cmp ax, 0
  2328 00000BBE 0F840300                 je  @@parse83
  2329 00000BC2 E95CFF                   jmp @@parse73
  2330                                  @@parse83:
  2331                                  
  2332                                  ;-25 }
  2333                                  
  2334                                  
  2335                                  ;-26 // scan code .....................................
  2336                                  
  2337                                  
  2338                                  ;-27 int getTokeType() { char c;
  2339                                  
  2340 00000BC5 C3                       ret
  2341                                  ; ENDP
  2342 00000BC6 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2343 00000BCF 696E73747275637469-
  2344 00000BD8 6F6E20657870656374-
  2345 00000BE1 656400             
  2346 00000BE4 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2347 00000BED 616C6C6F7765642040-
  2348 00000BF6 207374617274206F66-
  2349 00000BFF 206C696E6500       
  2350                                  
  2351                                  getTokeType:  ; *** PROC ***
  2352                                  
  2353                                  ;-28   skipBlank();
  2354                                  
  2355                                  ;Function : getTokeType, Number of local variables: 1
  2356                                  ;   # type sign width line used address name   list of local variables
  2357                                  ;  200 var sign byte    27 NULL bp-2    c;
  2358 00000C05 C8020000                 ENTER  2,0
  2359 00000C09 E8A704                   call skipBlank
  2360                                  
  2361                                  ;-29   c = *InputPtr;
  2362                                  
  2363 00000C0C 8B1E[2800]               mov bx, [InputPtr]
  2364 00000C10 8A07                     mov al, [bx]
  2365 00000C12 B400                     mov ah, 0
  2366 00000C14 8846FE                   mov byte [bp-2], al
  2367                                  
  2368                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2369                                  
  2370 00000C17 8A46FE                   mov al, [bp-2]
  2371 00000C1A 3C00                     cmp al, 0
  2372 00000C1C 0F850C00                 jne @@getTokeType84
  2373 00000C20 66B800000000             mov eax, 0
  2374 00000C26 A2[3C00]                 mov byte [TokeType], al
  2375 00000C29 E97500                   jmp @@retn
  2376                                  
  2377                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2378                                  
  2379                                  @@getTokeType84:
  2380 00000C2C 8A46FE                   mov al, [bp-2]
  2381 00000C2F 3C3B                     cmp al, 59
  2382 00000C31 0F850C00                 jne @@getTokeType85
  2383 00000C35 66B800000000             mov eax, 0
  2384 00000C3B A2[3C00]                 mov byte [TokeType], al
  2385 00000C3E E96000                   jmp @@retn
  2386                                  
  2387                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2388                                  
  2389                                  @@getTokeType85:
  2390 00000C41 8A46FE                   mov al, byte [bp-2]
  2391 00000C44 B400                     mov ah, 0
  2392 00000C46 50                       push ax
  2393 00000C47 E84D13                   call digit
  2394 00000C4A 83C402                   add  sp, 2
  2395 00000C4D 08C0                     or  al, al
  2396 00000C4F 0F841800                 je @@getTokeType86
  2397 00000C53 8A46FE                   mov al, byte [bp-2]
  2398 00000C56 B400                     mov ah, 0
  2399 00000C58 50                       push ax
  2400 00000C59 E85D05                   call getDigit
  2401 00000C5C 83C402                   add  sp, 2
  2402 00000C5F 66B801000000             mov eax, 1
  2403 00000C65 A2[3C00]                 mov byte [TokeType], al
  2404 00000C68 E93600                   jmp @@retn
  2405                                  
  2406                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2407                                  
  2408                                  @@getTokeType86:
  2409 00000C6B 8A46FE                   mov al, byte [bp-2]
  2410 00000C6E B400                     mov ah, 0
  2411 00000C70 50                       push ax
  2412 00000C71 E86A04                   call letterE
  2413 00000C74 83C402                   add  sp, 2
  2414 00000C77 08C0                     or  al, al
  2415 00000C79 0F841800                 je @@getTokeType87
  2416 00000C7D 8A46FE                   mov al, byte [bp-2]
  2417 00000C80 B400                     mov ah, 0
  2418 00000C82 50                       push ax
  2419 00000C83 E88A05                   call getName
  2420 00000C86 83C402                   add  sp, 2
  2421 00000C89 66B803000000             mov eax, 3
  2422 00000C8F A2[3C00]                 mov byte [TokeType], al
  2423 00000C92 E90C00                   jmp @@retn
  2424                                  
  2425                                  ;-34   TokeType=NOALNUME; return;
  2426                                  
  2427                                  @@getTokeType87:
  2428 00000C95 66B804000000             mov eax, 4
  2429 00000C9B A2[3C00]                 mov byte [TokeType], al
  2430 00000C9E E90000                   jmp @@retn
  2431                                  
  2432                                  ;-35 }
  2433                                  
  2434                                  
  2435                                  ;-36 int storeLabel() {
  2436                                  
  2437 00000CA1 C9                      @@retn: LEAVE
  2438 00000CA2 C3                       ret
  2439                                  ; ENDP
  2440                                  
  2441                                  storeLabel:  ; *** PROC ***
  2442                                  
  2443                                  ;-37   if(searchLabel()) error1("duplicate label");
  2444                                  
  2445 00000CA3 E84700                   call searchLabel
  2446 00000CA6 08C0                     or  al, al
  2447 00000CA8 0F840900                 je @@storeLabel88
  2448 00000CAC 68[DD0C]                 push storeLabel_0
  2449 00000CAF E8910C                   call error1
  2450 00000CB2 83C402                   add  sp, 2
  2451                                  
  2452                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2453                                  
  2454                                  @@storeLabel88:
  2455 00000CB5 8D063075                 lea  ax, [Symbol]
  2456 00000CB9 50                       push ax
  2457 00000CBA FF36[4F00]               push word [LabelNamePtr]
  2458 00000CBE E89D12                   call strcpy
  2459 00000CC1 83C404                   add  sp, 4
  2460 00000CC4 A3[4F00]                 mov word [LabelNamePtr], ax
  2461                                  
  2462                                  ;-39   LabelNamePtr++;
  2463                                  
  2464 00000CC7 FF06[4F00]               inc  word [LabelNamePtr]
  2465                                  
  2466                                  ;-40   LabelMaxIx++;
  2467                                  
  2468 00000CCB FF06[5100]               inc  word [LabelMaxIx]
  2469                                  
  2470                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2471                                  
  2472 00000CCF A1[3700]                 mov ax, [PC]
  2473 00000CD2 8B1E[5100]               mov bx, [LabelMaxIx]
  2474 00000CD6 D1E3                     shl bx, 1
  2475 00000CD8 8987A37A                 mov [LabelAddr+bx], ax
  2476                                  
  2477                                  ;-42 }
  2478                                  
  2479                                  
  2480                                  ;-43 int searchLabel() {
  2481                                  
  2482 00000CDC C3                       ret
  2483                                  ; ENDP
  2484 00000CDD 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2485 00000CE6 206C6162656C00     
  2486                                  
  2487                                  searchLabel:  ; *** PROC ***
  2488                                  
  2489                                  ;-44   int LIx; char *p; int j;
  2490                                  
  2491                                  
  2492                                  ;-45   p = &LabelNames;
  2493                                  
  2494                                  ;Function : searchLabel, Number of local variables: 3
  2495                                  ;   # type sign width line used address name   list of local variables
  2496                                  ;  200 var sign word    44 NULL bp-2    LIx
  2497                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2498                                  ;  202 var sign word    44 NULL bp-6    j;
  2499 00000CED C8060000                 ENTER  6,0
  2500 00000CF1 B8BB76                   mov ax, LabelNames
  2501 00000CF4 8946FC                   mov word [bp-4], ax
  2502                                  
  2503                                  ;-46   LIx=1;
  2504                                  
  2505 00000CF7 66B801000000             mov eax, 1
  2506 00000CFD 8946FE                   mov word [bp-2], ax
  2507                                  
  2508                                  ;-47   while (LIx <= LabelMaxIx) {
  2509                                  
  2510                                  @@searchLabel89:
  2511 00000D00 8B46FE                   mov ax, [bp-2]
  2512 00000D03 3B06[5100]               cmp ax, [LabelMaxIx]
  2513 00000D07 0F8F3700                 jg  @@searchLabel90
  2514                                  
  2515                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2516                                  
  2517 00000D0B 8D063075                 lea  ax, [Symbol]
  2518 00000D0F 50                       push ax
  2519 00000D10 FF76FC                   push word [bp-4]
  2520 00000D13 E8B412                   call eqstr
  2521 00000D16 83C404                   add  sp, 4
  2522 00000D19 08C0                     or  al, al
  2523 00000D1B 0F840600                 je @@searchLabel91
  2524 00000D1F 8B46FE                   mov ax, [bp-2]
  2525 00000D22 E92600                   jmp @@retn
  2526                                  
  2527                                  ;-49     j=strlen(p);
  2528                                  
  2529                                  @@searchLabel91:
  2530 00000D25 FF76FC                   push word [bp-4]
  2531 00000D28 E80812                   call strlen
  2532 00000D2B 83C402                   add  sp, 2
  2533 00000D2E 8946FA                   mov word [bp-6], ax
  2534                                  
  2535                                  ;-50     p=p+j; p++; LIx++;
  2536                                  
  2537 00000D31 8B46FC                   mov ax, [bp-4]
  2538 00000D34 0346FA                   add ax, [bp-6]
  2539 00000D37 8946FC                   mov word [bp-4], ax
  2540 00000D3A FF46FC                   inc  word [bp-4]
  2541 00000D3D FF46FE                   inc  word [bp-2]
  2542                                  
  2543                                  ;-51   }
  2544                                  
  2545                                  
  2546                                  ;-52   return 0;
  2547                                  
  2548 00000D40 EBBE                     jmp @@searchLabel89
  2549                                  @@searchLabel90:
  2550 00000D42 66B800000000             mov eax, 0
  2551 00000D48 E90000                   jmp @@retn
  2552                                  
  2553                                  ;-53 }
  2554                                  
  2555                                  
  2556                                  ;-54 int getVariable() { char c;
  2557                                  
  2558 00000D4B C9                      @@retn: LEAVE
  2559 00000D4C C3                       ret
  2560                                  ; ENDP
  2561                                  
  2562                                  getVariable:  ; *** PROC ***
  2563                                  
  2564                                  ;-55   storeLabel();
  2565                                  
  2566                                  ;Function : getVariable, Number of local variables: 1
  2567                                  ;   # type sign width line used address name   list of local variables
  2568                                  ;  200 var sign byte    54 NULL bp-2    c;
  2569 00000D4D C8020000                 ENTER  2,0
  2570 00000D51 E84FFF                   call storeLabel
  2571                                  
  2572                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2573                                  
  2574 00000D54 E8AEFE                   call getTokeType
  2575 00000D57 A0[3C00]                 mov al, [TokeType]
  2576 00000D5A 3C03                     cmp al, 3
  2577 00000D5C 0F85CC00                 jne @@getVariable92
  2578                                  
  2579                                  ;-57     lookCode();
  2580                                  
  2581 00000D60 E82201                   call lookCode
  2582                                  
  2583                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2584                                  
  2585 00000D63 A0[3E00]                 mov al, [CodeType]
  2586 00000D66 3CC8                     cmp al, 200
  2587 00000D68 0F8D0900                 jge @@getVariable93
  2588 00000D6C 68[370E]                 push getVariable_0
  2589 00000D6F E8020D                   call errorexit
  2590 00000D72 83C402                   add  sp, 2
  2591                                  
  2592                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2593                                  
  2594                                  @@getVariable93:
  2595 00000D75 A0[3E00]                 mov al, [CodeType]
  2596 00000D78 3CCF                     cmp al, 207
  2597 00000D7A 0F8E0900                 jle @@getVariable94
  2598 00000D7E 68[4F0E]                 push getVariable_1
  2599 00000D81 E8F00C                   call errorexit
  2600 00000D84 83C402                   add  sp, 2
  2601                                  
  2602                                  ;-60     if (CodeType== 200) {// DB
  2603                                  
  2604                                  @@getVariable94:
  2605 00000D87 A0[3E00]                 mov al, [CodeType]
  2606 00000D8A 3CC8                     cmp al, 200
  2607 00000D8C 0F856A00                 jne @@getVariable95
  2608                                  
  2609                                  ;-61       do { getTokeType();
  2610                                  
  2611                                  @@getVariable96:
  2612 00000D90 E872FE                   call getTokeType
  2613                                  
  2614                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2615                                  
  2616 00000D93 A0[3C00]                 mov al, [TokeType]
  2617 00000D96 3C01                     cmp al, 1
  2618 00000D98 0F850D00                 jne @@getVariable97
  2619 00000D9C FF36[2600]               push word [SymbolInt]
  2620 00000DA0 E8DFFB                   call genCode8
  2621 00000DA3 83C402                   add  sp, 2
  2622                                  
  2623                                  ;-63         else {
  2624                                  
  2625 00000DA6 E94100                   jmp @@getVariable98
  2626                                  @@getVariable97:
  2627                                  
  2628                                  ;-64           skipBlank();
  2629                                  
  2630 00000DA9 E80703                   call skipBlank
  2631                                  
  2632                                  ;-65           if (isToken('"')) {
  2633                                  
  2634 00000DAC 6A22                     push 34
  2635 00000DAE E8D101                   call isToken
  2636 00000DB1 83C402                   add  sp, 2
  2637 00000DB4 08C0                     or  al, al
  2638 00000DB6 0F843000                 je @@getVariable99
  2639                                  
  2640                                  ;-66             do { c= *InputPtr;
  2641                                  
  2642                                  @@getVariable100:
  2643 00000DBA 8B1E[2800]               mov bx, [InputPtr]
  2644 00000DBE 8A07                     mov al, [bx]
  2645 00000DC0 B400                     mov ah, 0
  2646 00000DC2 8846FE                   mov byte [bp-2], al
  2647                                  
  2648                                  ;-67               genCode8(c);
  2649                                  
  2650 00000DC5 8A46FE                   mov al, byte [bp-2]
  2651 00000DC8 B400                     mov ah, 0
  2652 00000DCA 50                       push ax
  2653 00000DCB E8B4FB                   call genCode8
  2654 00000DCE 83C402                   add  sp, 2
  2655                                  
  2656                                  ;-68               InputPtr++;
  2657                                  
  2658 00000DD1 FF06[2800]               inc  word [InputPtr]
  2659                                  
  2660                                  ;-69             } while (*InputPtr != '"' );
  2661                                  
  2662 00000DD5 8B1E[2800]               mov bx, [InputPtr]
  2663 00000DD9 8A07                     mov al, [bx]
  2664 00000DDB B400                     mov ah, 0
  2665 00000DDD 83F822                   cmp ax, 34
  2666 00000DE0 0F840200                 je  @@getVariable101
  2667 00000DE4 EBD4                     jmp @@getVariable100
  2668                                  @@getVariable101:
  2669                                  
  2670                                  ;-70             InputPtr++;
  2671                                  
  2672 00000DE6 FF06[2800]               inc  word [InputPtr]
  2673                                  
  2674                                  ;-71           }
  2675                                  
  2676                                  
  2677                                  ;-72         }
  2678                                  
  2679                                  @@getVariable99:
  2680                                  
  2681                                  ;-73       } while (isToken(','));
  2682                                  
  2683                                  @@getVariable98:
  2684 00000DEA 6A2C                     push 44
  2685 00000DEC E89301                   call isToken
  2686 00000DEF 83C402                   add  sp, 2
  2687 00000DF2 08C0                     or  al, al
  2688 00000DF4 0F840200                 je @@getVariable102
  2689 00000DF8 EB96                     jmp @@getVariable96
  2690                                  @@getVariable102:
  2691                                  
  2692                                  ;-74     }
  2693                                  
  2694                                  
  2695                                  ;-75     if (CodeType== 201) {// DW
  2696                                  
  2697                                  @@getVariable95:
  2698 00000DFA A0[3E00]                 mov al, [CodeType]
  2699 00000DFD 3CC9                     cmp al, 201
  2700 00000DFF 0F852600                 jne @@getVariable103
  2701                                  
  2702                                  ;-76       do { getTokeType();
  2703                                  
  2704                                  @@getVariable104:
  2705 00000E03 E8FFFD                   call getTokeType
  2706                                  
  2707                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2708                                  
  2709 00000E06 A0[3C00]                 mov al, [TokeType]
  2710 00000E09 3C01                     cmp al, 1
  2711 00000E0B 0F850A00                 jne @@getVariable105
  2712 00000E0F FF36[2600]               push word [SymbolInt]
  2713 00000E13 E89EFB                   call genCode16
  2714 00000E16 83C402                   add  sp, 2
  2715                                  
  2716                                  ;-78       } while (isToken(','));
  2717                                  
  2718                                  @@getVariable105:
  2719 00000E19 6A2C                     push 44
  2720 00000E1B E86401                   call isToken
  2721 00000E1E 83C402                   add  sp, 2
  2722 00000E21 08C0                     or  al, al
  2723 00000E23 0F840200                 je @@getVariable106
  2724 00000E27 EBDA                     jmp @@getVariable104
  2725                                  @@getVariable106:
  2726                                  
  2727                                  ;-79     }
  2728                                  
  2729                                  
  2730                                  ;-80   }
  2731                                  
  2732                                  @@getVariable103:
  2733                                  
  2734                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2735                                  
  2736 00000E29 E90900                   jmp @@getVariable107
  2737                                  @@getVariable92:
  2738 00000E2C 68[670E]                 push getVariable_2
  2739 00000E2F E8420C                   call errorexit
  2740 00000E32 83C402                   add  sp, 2
  2741                                  
  2742                                  ;-82 }
  2743                                  
  2744                                  @@getVariable107:
  2745                                  
  2746                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2747 00000E35 C9                       LEAVE
  2748 00000E36 C3                       ret
  2749                                  ; ENDP
  2750 00000E37 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2751 00000E40 422C572C4420657870-
  2752 00000E49 656374656400       
  2753 00000E4F 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2754 00000E58 422C572C4420657870-
  2755 00000E61 656374656400       
  2756 00000E67 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2757 00000E70 6F7220524553422C57-
  2758 00000E79 2C4420657870656374-
  2759 00000E82 656400             
  2760                                  
  2761                                  lookCode:  ; *** PROC ***
  2762                                  
  2763                                  ;-84   CodeType=0;
  2764                                  
  2765 00000E85 66B800000000             mov eax, 0
  2766 00000E8B A2[3E00]                 mov byte [CodeType], al
  2767                                  
  2768                                  ;-85   OpCodePtr= &I_START;
  2769                                  
  2770 00000E8E B8[5B00]                 mov ax, I_START
  2771 00000E91 A3[4C00]                 mov word [OpCodePtr], ax
  2772                                  
  2773                                  ;-86   OpCodePtr++;
  2774                                  
  2775 00000E94 FF06[4C00]               inc  word [OpCodePtr]
  2776                                  
  2777                                  ;-87   do  {
  2778                                  
  2779                                  @@lookCode108:
  2780                                  
  2781                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2782                                  
  2783 00000E98 FF36[4C00]               push word [OpCodePtr]
  2784 00000E9C 8D064F75                 lea  ax, [SymbolUpper]
  2785 00000EA0 50                       push ax
  2786 00000EA1 E82611                   call eqstr
  2787 00000EA4 83C404                   add  sp, 4
  2788 00000EA7 08C0                     or  al, al
  2789 00000EA9 0F842700                 je @@lookCode109
  2790                                  
  2791                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2792                                  
  2793                                  @@lookCode110:
  2794 00000EAD 8B1E[4C00]               mov bx, [OpCodePtr]
  2795 00000EB1 8A07                     mov al, [bx]
  2796 00000EB3 B400                     mov ah, 0
  2797 00000EB5 83F800                   cmp ax, 0
  2798 00000EB8 0F840600                 je  @@lookCode111
  2799 00000EBC FF06[4C00]               inc  word [OpCodePtr]
  2800                                  
  2801                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2802                                  
  2803 00000EC0 EBEB                     jmp @@lookCode110
  2804                                  @@lookCode111:
  2805 00000EC2 FF06[4C00]               inc  word [OpCodePtr]
  2806 00000EC6 8B1E[4C00]               mov bx, [OpCodePtr]
  2807 00000ECA 8A07                     mov al, [bx]
  2808 00000ECC B400                     mov ah, 0
  2809 00000ECE A2[3E00]                 mov byte [CodeType], al
  2810                                  
  2811                                  ;-91       return;
  2812                                  
  2813 00000ED1 E92A00                   jmp @@retn
  2814                                  
  2815                                  ;-92     }
  2816                                  
  2817                                  
  2818                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2819                                  
  2820                                  @@lookCode109:
  2821                                  @@lookCode112:
  2822 00000ED4 8B1E[4C00]               mov bx, [OpCodePtr]
  2823 00000ED8 8A07                     mov al, [bx]
  2824 00000EDA B400                     mov ah, 0
  2825 00000EDC 3DF100                   cmp ax, 241
  2826 00000EDF 0F840600                 je  @@lookCode113
  2827 00000EE3 FF06[4C00]               inc  word [OpCodePtr]
  2828                                  
  2829                                  ;-94   OpCodePtr++;
  2830                                  
  2831 00000EE7 EBEB                     jmp @@lookCode112
  2832                                  @@lookCode113:
  2833 00000EE9 FF06[4C00]               inc  word [OpCodePtr]
  2834                                  
  2835                                  ;-95   } while(*OpCodePtr!=0);
  2836                                  
  2837 00000EED 8B1E[4C00]               mov bx, [OpCodePtr]
  2838 00000EF1 8A07                     mov al, [bx]
  2839 00000EF3 B400                     mov ah, 0
  2840 00000EF5 83F800                   cmp ax, 0
  2841 00000EF8 0F840200                 je  @@lookCode114
  2842 00000EFC EB9A                     jmp @@lookCode108
  2843                                  @@lookCode114:
  2844                                  
  2845                                  ;-96 }
  2846                                  
  2847                                  
  2848                                  ;-97 int getCodeSize() {
  2849                                  
  2850                                  @@retn:
  2851 00000EFE C3                       ret
  2852                                  ; ENDP
  2853                                  
  2854                                  getCodeSize:  ; *** PROC ***
  2855                                  
  2856                                  ;-98   if (TokeType ==ALNUME) {
  2857                                  
  2858 00000EFF A0[3C00]                 mov al, [TokeType]
  2859 00000F02 3C03                     cmp al, 3
  2860 00000F04 0F856000                 jne @@getCodeSize115
  2861                                  
  2862                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2863                                  
  2864 00000F08 68[720F]                 push getCodeSize_0
  2865 00000F0B 8D064F75                 lea  ax, [SymbolUpper]
  2866 00000F0F 50                       push ax
  2867 00000F10 E8B710                   call eqstr
  2868 00000F13 83C404                   add  sp, 4
  2869 00000F16 08C0                     or  al, al
  2870 00000F18 0F840C00                 je @@getCodeSize116
  2871 00000F1C E8E6FC                   call getTokeType
  2872 00000F1F 66B801000000             mov eax, 1
  2873 00000F25 E94900                   jmp @@retn
  2874                                  
  2875                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2876                                  
  2877                                  @@getCodeSize116:
  2878 00000F28 68[770F]                 push getCodeSize_1
  2879 00000F2B 8D064F75                 lea  ax, [SymbolUpper]
  2880 00000F2F 50                       push ax
  2881 00000F30 E89710                   call eqstr
  2882 00000F33 83C404                   add  sp, 4
  2883 00000F36 08C0                     or  al, al
  2884 00000F38 0F840C00                 je @@getCodeSize117
  2885 00000F3C E8C6FC                   call getTokeType
  2886 00000F3F 66B802000000             mov eax, 2
  2887 00000F45 E92900                   jmp @@retn
  2888                                  
  2889                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2890                                  
  2891                                  @@getCodeSize117:
  2892 00000F48 68[7C0F]                 push getCodeSize_2
  2893 00000F4B 8D064F75                 lea  ax, [SymbolUpper]
  2894 00000F4F 50                       push ax
  2895 00000F50 E87710                   call eqstr
  2896 00000F53 83C404                   add  sp, 4
  2897 00000F56 08C0                     or  al, al
  2898 00000F58 0F840C00                 je @@getCodeSize118
  2899 00000F5C E8A6FC                   call getTokeType
  2900 00000F5F 66B803000000             mov eax, 3
  2901 00000F65 E90900                   jmp @@retn
  2902                                  
  2903                                  ;-102   } return 0;
  2904                                  
  2905                                  @@getCodeSize118:
  2906                                  @@getCodeSize115:
  2907 00000F68 66B800000000             mov eax, 0
  2908 00000F6E E90000                   jmp @@retn
  2909                                  
  2910                                  ;-103 }
  2911                                  
  2912                                  
  2913                                  ;-104 int isToken(char c) {
  2914                                  
  2915                                  @@retn:
  2916 00000F71 C3                       ret
  2917                                  ; ENDP
  2918 00000F72 4259544500              getCodeSize_0 db "BYTE",0
  2919 00000F77 574F524400              getCodeSize_1 db "WORD",0
  2920 00000F7C 44574F524400            getCodeSize_2 db "DWORD",0
  2921                                  
  2922                                  isToken:  ; *** PROC ***
  2923                                  
  2924                                  ;-105   skipBlank();
  2925                                  
  2926                                  ;Function : isToken, Number of local variables: 1
  2927                                  ;   # type sign width line used address name   list of local variables
  2928                                  ;  200 var sign byte   104 NULL bp+4    c;
  2929 00000F82 C8000000                 ENTER  0,0
  2930 00000F86 E82A01                   call skipBlank
  2931                                  
  2932                                  ;-106   if (*InputPtr == c) {
  2933                                  
  2934 00000F89 8B1E[2800]               mov bx, [InputPtr]
  2935 00000F8D 8A07                     mov al, [bx]
  2936 00000F8F B400                     mov ah, 0
  2937 00000F91 3A4604                   cmp al, [bp+4]
  2938 00000F94 0F850D00                 jne @@isToken119
  2939                                  
  2940                                  ;-107     InputPtr++; return 1;} return 0;
  2941                                  
  2942 00000F98 FF06[2800]               inc  word [InputPtr]
  2943 00000F9C 66B801000000             mov eax, 1
  2944 00000FA2 E90900                   jmp @@retn
  2945                                  @@isToken119:
  2946 00000FA5 66B800000000             mov eax, 0
  2947 00000FAB E90000                   jmp @@retn
  2948                                  
  2949                                  ;-108 }
  2950                                  
  2951                                  
  2952                                  ;-109 int skipRest() {
  2953                                  
  2954 00000FAE C9                      @@retn: LEAVE
  2955 00000FAF C3                       ret
  2956                                  ; ENDP
  2957                                  
  2958                                  skipRest:  ; *** PROC ***
  2959                                  
  2960                                  ;-110   getTokeType(); if(TokeType!=0)prs("\n; ******** extra char ignored");
  2961                                  
  2962 00000FB0 E852FC                   call getTokeType
  2963 00000FB3 A0[3C00]                 mov al, [TokeType]
  2964 00000FB6 3C00                     cmp al, 0
  2965 00000FB8 0F840900                 je  @@skipRest120
  2966 00000FBC 68[C60F]                 push skipRest_0
  2967 00000FBF E82408                   call prs
  2968 00000FC2 83C402                   add  sp, 2
  2969                                  
  2970                                  ;-111 }
  2971                                  
  2972                                  @@skipRest120:
  2973 00000FC5 C3                       ret
  2974                                  ; ENDP
  2975 00000FC6 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ******** extra char ignored",0
  2976 00000FCF 2A2A2A206578747261-
  2977 00000FD8 20636861722069676E-
  2978 00000FE1 6F72656400         
  2979                                  ;Back to main program: AS.C
  2980                                  
  2981                                  ;-205 #include "HELPER.C"
  2982                                  
  2983                                  ;Use include file: HELPER.C
  2984                                  
  2985                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2986                                  
  2987                                  
  2988                                  getLine:  ; *** PROC ***
  2989                                  
  2990                                  ;-2   InputPtr= &InputBuf;
  2991                                  
  2992 00000FE6 B86E75                   mov ax, InputBuf
  2993 00000FE9 A3[2800]                 mov word [InputPtr], ax
  2994                                  
  2995                                  ;-3   *InputPtr=0;//if last line is empty
  2996                                  
  2997 00000FEC 66B800000000             mov eax, 0
  2998 00000FF2 8B1E[2800]               mov  bx, [InputPtr]
  2999 00000FF6 8807                     mov  [bx], al
  3000                                  
  3001                                  ;-4   do {
  3002                                  
  3003                                  @@getLine121:
  3004                                  
  3005                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3006                                  
  3007 00000FF8 6A01                     push 1
  3008 00000FFA FF36[2A00]               push word [asm_fd]
  3009 00000FFE 8D06[3600]               lea  ax, [DOS_ByteRead]
  3010 00001002 50                       push ax
  3011 00001003 E85F10                   call readRL
  3012 00001006 83C406                   add  sp, 6
  3013 00001009 A3[3400]                 mov word [DOS_NoBytes], ax
  3014                                  
  3015                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  3016                                  
  3017 0000100C A1[3000]                 mov ax, [DOS_ERR]
  3018 0000100F 08C0                     or  al, al
  3019 00001011 0F840900                 je @@getLine122
  3020 00001015 68[5D10]                 push getLine_0
  3021 00001018 E8590A                   call errorexit
  3022 0000101B 83C402                   add  sp, 2
  3023                                  
  3024                                  ;-7     if (DOS_NoBytes == 0) return;
  3025                                  
  3026                                  @@getLine122:
  3027 0000101E A1[3400]                 mov ax, [DOS_NoBytes]
  3028 00001021 83F800                   cmp ax, 0
  3029 00001024 0F850300                 jne @@getLine123
  3030 00001028 E93100                   jmp @@retn
  3031                                  
  3032                                  ;-8     *InputPtr = DOS_ByteRead;
  3033                                  
  3034                                  @@getLine123:
  3035 0000102B A0[3600]                 mov al, [DOS_ByteRead]
  3036 0000102E 8B1E[2800]               mov  bx, [InputPtr]
  3037 00001032 8807                     mov  [bx], al
  3038                                  
  3039                                  ;-9     InputPtr++;
  3040                                  
  3041 00001034 FF06[2800]               inc  word [InputPtr]
  3042                                  
  3043                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  3044                                  
  3045 00001038 A0[3600]                 mov al, byte [DOS_ByteRead]
  3046 0000103B B400                     mov ah, 0
  3047 0000103D 50                       push ax
  3048 0000103E E82B00                   call ifEOL
  3049 00001041 83C402                   add  sp, 2
  3050 00001044 3C00                     cmp al, 0
  3051 00001046 0F850200                 jne @@getLine124
  3052 0000104A EBAC                     jmp @@getLine121
  3053                                  @@getLine124:
  3054                                  
  3055                                  ;-11   InputPtr--;
  3056                                  
  3057 0000104C FF0E[2800]               dec  word [InputPtr]
  3058                                  
  3059                                  ;-12   *InputPtr=0;
  3060                                  
  3061 00001050 66B800000000             mov eax, 0
  3062 00001056 8B1E[2800]               mov  bx, [InputPtr]
  3063 0000105A 8807                     mov  [bx], al
  3064                                  
  3065                                  ;-13 }
  3066                                  
  3067                                  
  3068                                  ;-14 int ifEOL(char c) {
  3069                                  
  3070                                  @@retn:
  3071 0000105C C3                       ret
  3072                                  ; ENDP
  3073 0000105D 52656164696E672053-     getLine_0 db "Reading Source",0
  3074 00001066 6F7572636500       
  3075                                  
  3076                                  ifEOL:  ; *** PROC ***
  3077                                  
  3078                                  ;-15   if (c == 10) return 1;
  3079                                  
  3080                                  ;Function : ifEOL, Number of local variables: 1
  3081                                  ;   # type sign width line used address name   list of local variables
  3082                                  ;  200 var sign byte    14 NULL bp+4    c;
  3083 0000106C C8000000                 ENTER  0,0
  3084 00001070 8A4604                   mov al, [bp+4]
  3085 00001073 3C0A                     cmp al, 10
  3086 00001075 0F850900                 jne @@ifEOL125
  3087 00001079 66B801000000             mov eax, 1
  3088 0000107F E92F00                   jmp @@retn
  3089                                  
  3090                                  ;-16   if (c == 13) {
  3091                                  
  3092                                  @@ifEOL125:
  3093 00001082 8A4604                   mov al, [bp+4]
  3094 00001085 3C0D                     cmp al, 13
  3095 00001087 0F851D00                 jne @@ifEOL126
  3096                                  
  3097                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3098                                  
  3099 0000108B 6A01                     push 1
  3100 0000108D FF36[2A00]               push word [asm_fd]
  3101 00001091 8D06[3600]               lea  ax, [DOS_ByteRead]
  3102 00001095 50                       push ax
  3103 00001096 E8CC0F                   call readRL
  3104 00001099 83C406                   add  sp, 6
  3105 0000109C A3[3400]                 mov word [DOS_NoBytes], ax
  3106                                  
  3107                                  ;-18     return 1;}
  3108                                  
  3109 0000109F 66B801000000             mov eax, 1
  3110 000010A5 E90900                   jmp @@retn
  3111                                  
  3112                                  ;-19   return 0;
  3113                                  
  3114                                  @@ifEOL126:
  3115 000010A8 66B800000000             mov eax, 0
  3116 000010AE E90000                   jmp @@retn
  3117                                  
  3118                                  ;-20 }
  3119                                  
  3120                                  
  3121                                  ;-21 int skipBlank() {
  3122                                  
  3123 000010B1 C9                      @@retn: LEAVE
  3124 000010B2 C3                       ret
  3125                                  ; ENDP
  3126                                  
  3127                                  skipBlank:  ; *** PROC ***
  3128                                  
  3129                                  ;-22   skipblank1:
  3130                                  
  3131                                  @@skipblank1:
  3132                                  
  3133                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3134                                  
  3135 000010B3 8B1E[2800]               mov bx, [InputPtr]
  3136 000010B7 8A07                     mov al, [bx]
  3137 000010B9 B400                     mov ah, 0
  3138 000010BB 83F820                   cmp ax, 32
  3139 000010BE 0F850600                 jne @@skipBlank127
  3140 000010C2 FF06[2800]               inc  word [InputPtr]
  3141 000010C6 EBEB                     jmp @@skipblank1
  3142                                  
  3143                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3144                                  
  3145                                  @@skipBlank127:
  3146 000010C8 8B1E[2800]               mov bx, [InputPtr]
  3147 000010CC 8A07                     mov al, [bx]
  3148 000010CE B400                     mov ah, 0
  3149 000010D0 83F809                   cmp ax, 9
  3150 000010D3 0F850600                 jne @@skipBlank128
  3151 000010D7 FF06[2800]               inc  word [InputPtr]
  3152 000010DB EBD6                     jmp @@skipblank1
  3153                                  
  3154                                  ;-25 }
  3155                                  
  3156                                  @@skipBlank128:
  3157                                  
  3158                                  ;-26 int letterE(char c) {
  3159                                  
  3160 000010DD C3                       ret
  3161                                  ; ENDP
  3162                                  
  3163                                  letterE:  ; *** PROC ***
  3164                                  
  3165                                  ;-27   if (c=='_') return 1;
  3166                                  
  3167                                  ;Function : letterE, Number of local variables: 1
  3168                                  ;   # type sign width line used address name   list of local variables
  3169                                  ;  200 var sign byte    26 NULL bp+4    c;
  3170 000010DE C8000000                 ENTER  0,0
  3171 000010E2 8A4604                   mov al, [bp+4]
  3172 000010E5 3C5F                     cmp al, 95
  3173 000010E7 0F850900                 jne @@letterE129
  3174 000010EB 66B801000000             mov eax, 1
  3175 000010F1 E97E00                   jmp @@retn
  3176                                  
  3177                                  ;-28   if (c=='.') return 1;
  3178                                  
  3179                                  @@letterE129:
  3180 000010F4 8A4604                   mov al, [bp+4]
  3181 000010F7 3C2E                     cmp al, 46
  3182 000010F9 0F850900                 jne @@letterE130
  3183 000010FD 66B801000000             mov eax, 1
  3184 00001103 E96C00                   jmp @@retn
  3185                                  
  3186                                  ;-29   if (c=='?') return 1;
  3187                                  
  3188                                  @@letterE130:
  3189 00001106 8A4604                   mov al, [bp+4]
  3190 00001109 3C3F                     cmp al, 63
  3191 0000110B 0F850900                 jne @@letterE131
  3192 0000110F 66B801000000             mov eax, 1
  3193 00001115 E95A00                   jmp @@retn
  3194                                  
  3195                                  ;-30   if (c=='$') return 1;
  3196                                  
  3197                                  @@letterE131:
  3198 00001118 8A4604                   mov al, [bp+4]
  3199 0000111B 3C24                     cmp al, 36
  3200 0000111D 0F850900                 jne @@letterE132
  3201 00001121 66B801000000             mov eax, 1
  3202 00001127 E94800                   jmp @@retn
  3203                                  
  3204                                  ;-31   if (c> 'z') return 0;
  3205                                  
  3206                                  @@letterE132:
  3207 0000112A 8A4604                   mov al, [bp+4]
  3208 0000112D 3C7A                     cmp al, 122
  3209 0000112F 0F8E0900                 jle @@letterE133
  3210 00001133 66B800000000             mov eax, 0
  3211 00001139 E93600                   jmp @@retn
  3212                                  
  3213                                  ;-32   if (c< '@') return 0; // at included
  3214                                  
  3215                                  @@letterE133:
  3216 0000113C 8A4604                   mov al, [bp+4]
  3217 0000113F 3C40                     cmp al, 64
  3218 00001141 0F8D0900                 jge @@letterE134
  3219 00001145 66B800000000             mov eax, 0
  3220 0000114B E92400                   jmp @@retn
  3221                                  
  3222                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3223                                  
  3224                                  @@letterE134:
  3225 0000114E 8A4604                   mov al, [bp+4]
  3226 00001151 3C5A                     cmp al, 90
  3227 00001153 0F8E1200                 jle @@letterE135
  3228 00001157 8A4604                   mov al, [bp+4]
  3229 0000115A 3C61                     cmp al, 97
  3230 0000115C 0F8D0900                 jge @@letterE136
  3231 00001160 66B800000000             mov eax, 0
  3232 00001166 E90900                   jmp @@retn
  3233                                  @@letterE136:
  3234                                  
  3235                                  ;-34   return 1;
  3236                                  
  3237                                  @@letterE135:
  3238 00001169 66B801000000             mov eax, 1
  3239 0000116F E90000                   jmp @@retn
  3240                                  
  3241                                  ;-35 }
  3242                                  
  3243                                  
  3244                                  ;-36 int alnumE(char c) {
  3245                                  
  3246 00001172 C9                      @@retn: LEAVE
  3247 00001173 C3                       ret
  3248                                  ; ENDP
  3249                                  
  3250                                  alnumE:  ; *** PROC ***
  3251                                  
  3252                                  ;-37   if (digit(c)) return 1;
  3253                                  
  3254                                  ;Function : alnumE, Number of local variables: 1
  3255                                  ;   # type sign width line used address name   list of local variables
  3256                                  ;  200 var sign byte    36 NULL bp+4    c;
  3257 00001174 C8000000                 ENTER  0,0
  3258 00001178 8A4604                   mov al, byte [bp+4]
  3259 0000117B B400                     mov ah, 0
  3260 0000117D 50                       push ax
  3261 0000117E E8160E                   call digit
  3262 00001181 83C402                   add  sp, 2
  3263 00001184 08C0                     or  al, al
  3264 00001186 0F840900                 je @@alnumE137
  3265 0000118A 66B801000000             mov eax, 1
  3266 00001190 E92400                   jmp @@retn
  3267                                  
  3268                                  ;-38   if (letterE(c)) return 1;
  3269                                  
  3270                                  @@alnumE137:
  3271 00001193 8A4604                   mov al, byte [bp+4]
  3272 00001196 B400                     mov ah, 0
  3273 00001198 50                       push ax
  3274 00001199 E842FF                   call letterE
  3275 0000119C 83C402                   add  sp, 2
  3276 0000119F 08C0                     or  al, al
  3277 000011A1 0F840900                 je @@alnumE138
  3278 000011A5 66B801000000             mov eax, 1
  3279 000011AB E90900                   jmp @@retn
  3280                                  
  3281                                  ;-39   return 0;
  3282                                  
  3283                                  @@alnumE138:
  3284 000011AE 66B800000000             mov eax, 0
  3285 000011B4 E90000                   jmp @@retn
  3286                                  
  3287                                  ;-40 }
  3288                                  
  3289                                  
  3290                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3291                                  
  3292 000011B7 C9                      @@retn: LEAVE
  3293 000011B8 C3                       ret
  3294                                  ; ENDP
  3295                                  
  3296                                  getDigit:  ; *** PROC ***
  3297                                  
  3298                                  ;-42   unsigned int CastInt;
  3299                                  
  3300                                  
  3301                                  ;-43   SymbolInt=0;
  3302                                  
  3303                                  ;Function : getDigit, Number of local variables: 2
  3304                                  ;   # type sign width line used address name   list of local variables
  3305                                  ;  200 var unsg byte    41 NULL bp+4    c
  3306                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3307 000011B9 C8020000                 ENTER  2,0
  3308 000011BD 66B800000000             mov eax, 0
  3309 000011C3 A3[2600]                 mov word [SymbolInt], ax
  3310                                  
  3311                                  ;-44   do {
  3312                                  
  3313                                  @@getDigit139:
  3314                                  
  3315                                  ;-45     c-='0';
  3316                                  
  3317 000011C6 806E0430                 sub  byte [bp+4], 48
  3318                                  
  3319                                  ;-46     SymbolInt=SymbolInt*10;
  3320                                  
  3321 000011CA A1[2600]                 mov ax, [SymbolInt]
  3322 000011CD 66BB0A000000             mov ebx, 10
  3323 000011D3 66F7E3                   mul ebx
  3324 000011D6 A3[2600]                 mov word [SymbolInt], ax
  3325                                  
  3326                                  ;-47     ax=0; CastInt=c; //cast b2w
  3327                                  
  3328 000011D9 B80000                   mov  ax, 0
  3329 000011DC 8A4604                   mov al, [bp+4]
  3330 000011DF 8946FE                   mov word [bp-2], ax
  3331                                  
  3332                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3333                                  
  3334 000011E2 A1[2600]                 mov ax, [SymbolInt]
  3335 000011E5 0346FE                   add ax, [bp-2]
  3336 000011E8 A3[2600]                 mov word [SymbolInt], ax
  3337                                  
  3338                                  ;-49     InputPtr++;
  3339                                  
  3340 000011EB FF06[2800]               inc  word [InputPtr]
  3341                                  
  3342                                  ;-50     c = *InputPtr;
  3343                                  
  3344 000011EF 8B1E[2800]               mov bx, [InputPtr]
  3345 000011F3 8A07                     mov al, [bx]
  3346 000011F5 B400                     mov ah, 0
  3347 000011F7 884604                   mov byte [bp+4], al
  3348                                  
  3349                                  ;-51   } while(digit(c));
  3350                                  
  3351 000011FA 8A4604                   mov al, byte [bp+4]
  3352 000011FD B400                     mov ah, 0
  3353 000011FF 50                       push ax
  3354 00001200 E8940D                   call digit
  3355 00001203 83C402                   add  sp, 2
  3356 00001206 08C0                     or  al, al
  3357 00001208 0F840200                 je @@getDigit140
  3358 0000120C EBB8                     jmp @@getDigit139
  3359                                  @@getDigit140:
  3360                                  
  3361                                  ;-52 }
  3362                                  
  3363                                  
  3364                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3365 0000120E C9                       LEAVE
  3366 0000120F C3                       ret
  3367                                  ; ENDP
  3368                                  
  3369                                  getName:  ; *** PROC ***
  3370                                  
  3371                                  ;-54   char *p;
  3372                                  
  3373                                  
  3374                                  ;-55   p = &Symbol;
  3375                                  
  3376                                  ;Function : getName, Number of local variables: 2
  3377                                  ;   # type sign width line used address name   list of local variables
  3378                                  ;  200 var unsg byte    53 NULL bp+4    c
  3379                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3380 00001210 C8020000                 ENTER  2,0
  3381 00001214 B83075                   mov ax, Symbol
  3382 00001217 8946FE                   mov word [bp-2], ax
  3383                                  
  3384                                  ;-56   *p = c;
  3385                                  
  3386 0000121A 8A4604                   mov al, [bp+4]
  3387 0000121D 8B5EFE                   mov  bx, [bp-2]
  3388 00001220 8807                     mov  [bx], al
  3389                                  
  3390                                  ;-57   p++;
  3391                                  
  3392 00001222 FF46FE                   inc  word [bp-2]
  3393                                  
  3394                                  ;-58   while (alnumE(c)) {
  3395                                  
  3396                                  @@getName141:
  3397 00001225 8A4604                   mov al, byte [bp+4]
  3398 00001228 B400                     mov ah, 0
  3399 0000122A 50                       push ax
  3400 0000122B E846FF                   call alnumE
  3401 0000122E 83C402                   add  sp, 2
  3402 00001231 08C0                     or  al, al
  3403 00001233 0F841C00                 je @@getName142
  3404                                  
  3405                                  ;-59     InputPtr++;
  3406                                  
  3407 00001237 FF06[2800]               inc  word [InputPtr]
  3408                                  
  3409                                  ;-60     c = *InputPtr;
  3410                                  
  3411 0000123B 8B1E[2800]               mov bx, [InputPtr]
  3412 0000123F 8A07                     mov al, [bx]
  3413 00001241 B400                     mov ah, 0
  3414 00001243 884604                   mov byte [bp+4], al
  3415                                  
  3416                                  ;-61     *p = c;
  3417                                  
  3418 00001246 8A4604                   mov al, [bp+4]
  3419 00001249 8B5EFE                   mov  bx, [bp-2]
  3420 0000124C 8807                     mov  [bx], al
  3421                                  
  3422                                  ;-62     p++;
  3423                                  
  3424 0000124E FF46FE                   inc  word [bp-2]
  3425                                  
  3426                                  ;-63   }
  3427                                  
  3428                                  
  3429                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3430                                  
  3431 00001251 EBD2                     jmp @@getName141
  3432                                  @@getName142:
  3433 00001253 8A4604                   mov al, [bp+4]
  3434 00001256 3C3A                     cmp al, 58
  3435 00001258 0F850C00                 jne @@getName143
  3436 0000125C 66B801000000             mov eax, 1
  3437 00001262 A2[3B00]                 mov byte [isLabel], al
  3438 00001265 E90900                   jmp @@getName144
  3439                                  @@getName143:
  3440 00001268 66B800000000             mov eax, 0
  3441 0000126E A2[3B00]                 mov byte [isLabel], al
  3442                                  
  3443                                  ;-65   p--;
  3444                                  
  3445                                  @@getName144:
  3446 00001271 FF4EFE                   dec  word [bp-2]
  3447                                  
  3448                                  ;-66   *p = 0;
  3449                                  
  3450 00001274 66B800000000             mov eax, 0
  3451 0000127A 8B5EFE                   mov  bx, [bp-2]
  3452 0000127D 8807                     mov  [bx], al
  3453                                  
  3454                                  ;-67   strcpy(SymbolUpper, Symbol);
  3455                                  
  3456 0000127F 8D063075                 lea  ax, [Symbol]
  3457 00001283 50                       push ax
  3458 00001284 8D064F75                 lea  ax, [SymbolUpper]
  3459 00001288 50                       push ax
  3460 00001289 E8D20C                   call strcpy
  3461 0000128C 83C404                   add  sp, 4
  3462                                  
  3463                                  ;-68   toupper(SymbolUpper);
  3464                                  
  3465 0000128F 8D064F75                 lea  ax, [SymbolUpper]
  3466 00001293 50                       push ax
  3467 00001294 E8590C                   call toupper
  3468 00001297 83C402                   add  sp, 2
  3469                                  
  3470                                  ;-69 }
  3471                                  
  3472                                  
  3473                                  ;-70 int testReg() {
  3474 0000129A C9                       LEAVE
  3475 0000129B C3                       ret
  3476                                  ; ENDP
  3477                                  
  3478                                  testReg:  ; *** PROC ***
  3479                                  
  3480                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3481                                  
  3482                                  
  3483                                  ;-72   RegType=0;
  3484                                  
  3485 0000129C 66B800000000             mov eax, 0
  3486 000012A2 A2[3F00]                 mov byte [RegType], al
  3487                                  
  3488                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3489                                  
  3490 000012A5 8D063075                 lea  ax, [Symbol]
  3491 000012A9 50                       push ax
  3492 000012AA E8860C                   call strlen
  3493 000012AD 83C402                   add  sp, 2
  3494 000012B0 3C02                     cmp al, 2
  3495 000012B2 0F8D0900                 jge @@testReg145
  3496 000012B6 66B800000000             mov eax, 0
  3497 000012BC E9B603                   jmp @@retn
  3498                                  
  3499                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3500                                  
  3501                                  @@testReg145:
  3502 000012BF 8D063075                 lea  ax, [Symbol]
  3503 000012C3 50                       push ax
  3504 000012C4 E86C0C                   call strlen
  3505 000012C7 83C402                   add  sp, 2
  3506 000012CA 3C03                     cmp al, 3
  3507 000012CC 0F8E0900                 jle @@testReg146
  3508 000012D0 66B800000000             mov eax, 0
  3509 000012D6 E99C03                   jmp @@retn
  3510                                  
  3511                                  ;-75   RegType=BYTE;
  3512                                  
  3513                                  @@testReg146:
  3514 000012D9 66B801000000             mov eax, 1
  3515 000012DF A2[3F00]                 mov byte [RegType], al
  3516                                  
  3517                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3518                                  
  3519 000012E2 68[7616]                 push testReg_0
  3520 000012E5 8D064F75                 lea  ax, [SymbolUpper]
  3521 000012E9 50                       push ax
  3522 000012EA E8DD0C                   call eqstr
  3523 000012ED 83C404                   add  sp, 4
  3524 000012F0 08C0                     or  al, al
  3525 000012F2 0F840900                 je @@testReg147
  3526 000012F6 66B800000000             mov eax, 0
  3527 000012FC E97603                   jmp @@retn
  3528                                  
  3529                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3530                                  
  3531                                  @@testReg147:
  3532 000012FF 68[7916]                 push testReg_1
  3533 00001302 8D064F75                 lea  ax, [SymbolUpper]
  3534 00001306 50                       push ax
  3535 00001307 E8C00C                   call eqstr
  3536 0000130A 83C404                   add  sp, 4
  3537 0000130D 08C0                     or  al, al
  3538 0000130F 0F840900                 je @@testReg148
  3539 00001313 66B801000000             mov eax, 1
  3540 00001319 E95903                   jmp @@retn
  3541                                  
  3542                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3543                                  
  3544                                  @@testReg148:
  3545 0000131C 68[7C16]                 push testReg_2
  3546 0000131F 8D064F75                 lea  ax, [SymbolUpper]
  3547 00001323 50                       push ax
  3548 00001324 E8A30C                   call eqstr
  3549 00001327 83C404                   add  sp, 4
  3550 0000132A 08C0                     or  al, al
  3551 0000132C 0F840900                 je @@testReg149
  3552 00001330 66B802000000             mov eax, 2
  3553 00001336 E93C03                   jmp @@retn
  3554                                  
  3555                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3556                                  
  3557                                  @@testReg149:
  3558 00001339 68[7F16]                 push testReg_3
  3559 0000133C 8D064F75                 lea  ax, [SymbolUpper]
  3560 00001340 50                       push ax
  3561 00001341 E8860C                   call eqstr
  3562 00001344 83C404                   add  sp, 4
  3563 00001347 08C0                     or  al, al
  3564 00001349 0F840900                 je @@testReg150
  3565 0000134D 66B803000000             mov eax, 3
  3566 00001353 E91F03                   jmp @@retn
  3567                                  
  3568                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3569                                  
  3570                                  @@testReg150:
  3571 00001356 68[8216]                 push testReg_4
  3572 00001359 8D064F75                 lea  ax, [SymbolUpper]
  3573 0000135D 50                       push ax
  3574 0000135E E8690C                   call eqstr
  3575 00001361 83C404                   add  sp, 4
  3576 00001364 08C0                     or  al, al
  3577 00001366 0F840900                 je @@testReg151
  3578 0000136A 66B804000000             mov eax, 4
  3579 00001370 E90203                   jmp @@retn
  3580                                  
  3581                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3582                                  
  3583                                  @@testReg151:
  3584 00001373 68[8516]                 push testReg_5
  3585 00001376 8D064F75                 lea  ax, [SymbolUpper]
  3586 0000137A 50                       push ax
  3587 0000137B E84C0C                   call eqstr
  3588 0000137E 83C404                   add  sp, 4
  3589 00001381 08C0                     or  al, al
  3590 00001383 0F840900                 je @@testReg152
  3591 00001387 66B805000000             mov eax, 5
  3592 0000138D E9E502                   jmp @@retn
  3593                                  
  3594                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3595                                  
  3596                                  @@testReg152:
  3597 00001390 68[8816]                 push testReg_6
  3598 00001393 8D064F75                 lea  ax, [SymbolUpper]
  3599 00001397 50                       push ax
  3600 00001398 E82F0C                   call eqstr
  3601 0000139B 83C404                   add  sp, 4
  3602 0000139E 08C0                     or  al, al
  3603 000013A0 0F840900                 je @@testReg153
  3604 000013A4 66B806000000             mov eax, 6
  3605 000013AA E9C802                   jmp @@retn
  3606                                  
  3607                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3608                                  
  3609                                  @@testReg153:
  3610 000013AD 68[8B16]                 push testReg_7
  3611 000013B0 8D064F75                 lea  ax, [SymbolUpper]
  3612 000013B4 50                       push ax
  3613 000013B5 E8120C                   call eqstr
  3614 000013B8 83C404                   add  sp, 4
  3615 000013BB 08C0                     or  al, al
  3616 000013BD 0F840900                 je @@testReg154
  3617 000013C1 66B807000000             mov eax, 7
  3618 000013C7 E9AB02                   jmp @@retn
  3619                                  
  3620                                  ;-84   RegType=WORD;
  3621                                  
  3622                                  @@testReg154:
  3623 000013CA 66B802000000             mov eax, 2
  3624 000013D0 A2[3F00]                 mov byte [RegType], al
  3625                                  
  3626                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3627                                  
  3628 000013D3 68[8E16]                 push testReg_8
  3629 000013D6 8D064F75                 lea  ax, [SymbolUpper]
  3630 000013DA 50                       push ax
  3631 000013DB E8EC0B                   call eqstr
  3632 000013DE 83C404                   add  sp, 4
  3633 000013E1 08C0                     or  al, al
  3634 000013E3 0F840900                 je @@testReg155
  3635 000013E7 66B800000000             mov eax, 0
  3636 000013ED E98502                   jmp @@retn
  3637                                  
  3638                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3639                                  
  3640                                  @@testReg155:
  3641 000013F0 68[9116]                 push testReg_9
  3642 000013F3 8D064F75                 lea  ax, [SymbolUpper]
  3643 000013F7 50                       push ax
  3644 000013F8 E8CF0B                   call eqstr
  3645 000013FB 83C404                   add  sp, 4
  3646 000013FE 08C0                     or  al, al
  3647 00001400 0F840900                 je @@testReg156
  3648 00001404 66B801000000             mov eax, 1
  3649 0000140A E96802                   jmp @@retn
  3650                                  
  3651                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3652                                  
  3653                                  @@testReg156:
  3654 0000140D 68[9416]                 push testReg_10
  3655 00001410 8D064F75                 lea  ax, [SymbolUpper]
  3656 00001414 50                       push ax
  3657 00001415 E8B20B                   call eqstr
  3658 00001418 83C404                   add  sp, 4
  3659 0000141B 08C0                     or  al, al
  3660 0000141D 0F840900                 je @@testReg157
  3661 00001421 66B802000000             mov eax, 2
  3662 00001427 E94B02                   jmp @@retn
  3663                                  
  3664                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3665                                  
  3666                                  @@testReg157:
  3667 0000142A 68[9716]                 push testReg_11
  3668 0000142D 8D064F75                 lea  ax, [SymbolUpper]
  3669 00001431 50                       push ax
  3670 00001432 E8950B                   call eqstr
  3671 00001435 83C404                   add  sp, 4
  3672 00001438 08C0                     or  al, al
  3673 0000143A 0F840900                 je @@testReg158
  3674 0000143E 66B803000000             mov eax, 3
  3675 00001444 E92E02                   jmp @@retn
  3676                                  
  3677                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3678                                  
  3679                                  @@testReg158:
  3680 00001447 68[9A16]                 push testReg_12
  3681 0000144A 8D064F75                 lea  ax, [SymbolUpper]
  3682 0000144E 50                       push ax
  3683 0000144F E8780B                   call eqstr
  3684 00001452 83C404                   add  sp, 4
  3685 00001455 08C0                     or  al, al
  3686 00001457 0F840900                 je @@testReg159
  3687 0000145B 66B804000000             mov eax, 4
  3688 00001461 E91102                   jmp @@retn
  3689                                  
  3690                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3691                                  
  3692                                  @@testReg159:
  3693 00001464 68[9D16]                 push testReg_13
  3694 00001467 8D064F75                 lea  ax, [SymbolUpper]
  3695 0000146B 50                       push ax
  3696 0000146C E85B0B                   call eqstr
  3697 0000146F 83C404                   add  sp, 4
  3698 00001472 08C0                     or  al, al
  3699 00001474 0F840900                 je @@testReg160
  3700 00001478 66B805000000             mov eax, 5
  3701 0000147E E9F401                   jmp @@retn
  3702                                  
  3703                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3704                                  
  3705                                  @@testReg160:
  3706 00001481 68[A016]                 push testReg_14
  3707 00001484 8D064F75                 lea  ax, [SymbolUpper]
  3708 00001488 50                       push ax
  3709 00001489 E83E0B                   call eqstr
  3710 0000148C 83C404                   add  sp, 4
  3711 0000148F 08C0                     or  al, al
  3712 00001491 0F840900                 je @@testReg161
  3713 00001495 66B806000000             mov eax, 6
  3714 0000149B E9D701                   jmp @@retn
  3715                                  
  3716                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3717                                  
  3718                                  @@testReg161:
  3719 0000149E 68[A316]                 push testReg_15
  3720 000014A1 8D064F75                 lea  ax, [SymbolUpper]
  3721 000014A5 50                       push ax
  3722 000014A6 E8210B                   call eqstr
  3723 000014A9 83C404                   add  sp, 4
  3724 000014AC 08C0                     or  al, al
  3725 000014AE 0F840900                 je @@testReg162
  3726 000014B2 66B807000000             mov eax, 7
  3727 000014B8 E9BA01                   jmp @@retn
  3728                                  
  3729                                  ;-93   RegType=SEGREG;
  3730                                  
  3731                                  @@testReg162:
  3732 000014BB 66B804000000             mov eax, 4
  3733 000014C1 A2[3F00]                 mov byte [RegType], al
  3734                                  
  3735                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3736                                  
  3737 000014C4 68[A616]                 push testReg_16
  3738 000014C7 8D064F75                 lea  ax, [SymbolUpper]
  3739 000014CB 50                       push ax
  3740 000014CC E8FB0A                   call eqstr
  3741 000014CF 83C404                   add  sp, 4
  3742 000014D2 08C0                     or  al, al
  3743 000014D4 0F840900                 je @@testReg163
  3744 000014D8 66B800000000             mov eax, 0
  3745 000014DE E99401                   jmp @@retn
  3746                                  
  3747                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3748                                  
  3749                                  @@testReg163:
  3750 000014E1 68[A916]                 push testReg_17
  3751 000014E4 8D064F75                 lea  ax, [SymbolUpper]
  3752 000014E8 50                       push ax
  3753 000014E9 E8DE0A                   call eqstr
  3754 000014EC 83C404                   add  sp, 4
  3755 000014EF 08C0                     or  al, al
  3756 000014F1 0F840900                 je @@testReg164
  3757 000014F5 66B801000000             mov eax, 1
  3758 000014FB E97701                   jmp @@retn
  3759                                  
  3760                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3761                                  
  3762                                  @@testReg164:
  3763 000014FE 68[AC16]                 push testReg_18
  3764 00001501 8D064F75                 lea  ax, [SymbolUpper]
  3765 00001505 50                       push ax
  3766 00001506 E8C10A                   call eqstr
  3767 00001509 83C404                   add  sp, 4
  3768 0000150C 08C0                     or  al, al
  3769 0000150E 0F840900                 je @@testReg165
  3770 00001512 66B802000000             mov eax, 2
  3771 00001518 E95A01                   jmp @@retn
  3772                                  
  3773                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3774                                  
  3775                                  @@testReg165:
  3776 0000151B 68[AF16]                 push testReg_19
  3777 0000151E 8D064F75                 lea  ax, [SymbolUpper]
  3778 00001522 50                       push ax
  3779 00001523 E8A40A                   call eqstr
  3780 00001526 83C404                   add  sp, 4
  3781 00001529 08C0                     or  al, al
  3782 0000152B 0F840900                 je @@testReg166
  3783 0000152F 66B803000000             mov eax, 3
  3784 00001535 E93D01                   jmp @@retn
  3785                                  
  3786                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3787                                  
  3788                                  @@testReg166:
  3789 00001538 68[B216]                 push testReg_20
  3790 0000153B 8D064F75                 lea  ax, [SymbolUpper]
  3791 0000153F 50                       push ax
  3792 00001540 E8870A                   call eqstr
  3793 00001543 83C404                   add  sp, 4
  3794 00001546 08C0                     or  al, al
  3795 00001548 0F840900                 je @@testReg167
  3796 0000154C 66B804000000             mov eax, 4
  3797 00001552 E92001                   jmp @@retn
  3798                                  
  3799                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3800                                  
  3801                                  @@testReg167:
  3802 00001555 68[B516]                 push testReg_21
  3803 00001558 8D064F75                 lea  ax, [SymbolUpper]
  3804 0000155C 50                       push ax
  3805 0000155D E86A0A                   call eqstr
  3806 00001560 83C404                   add  sp, 4
  3807 00001563 08C0                     or  al, al
  3808 00001565 0F840900                 je @@testReg168
  3809 00001569 66B805000000             mov eax, 5
  3810 0000156F E90301                   jmp @@retn
  3811                                  
  3812                                  ;-100   RegType=DWORD;
  3813                                  
  3814                                  @@testReg168:
  3815 00001572 66B803000000             mov eax, 3
  3816 00001578 A2[3F00]                 mov byte [RegType], al
  3817                                  
  3818                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3819                                  
  3820 0000157B 68[B816]                 push testReg_22
  3821 0000157E 8D064F75                 lea  ax, [SymbolUpper]
  3822 00001582 50                       push ax
  3823 00001583 E8440A                   call eqstr
  3824 00001586 83C404                   add  sp, 4
  3825 00001589 08C0                     or  al, al
  3826 0000158B 0F840900                 je @@testReg169
  3827 0000158F 66B800000000             mov eax, 0
  3828 00001595 E9DD00                   jmp @@retn
  3829                                  
  3830                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3831                                  
  3832                                  @@testReg169:
  3833 00001598 68[BC16]                 push testReg_23
  3834 0000159B 8D064F75                 lea  ax, [SymbolUpper]
  3835 0000159F 50                       push ax
  3836 000015A0 E8270A                   call eqstr
  3837 000015A3 83C404                   add  sp, 4
  3838 000015A6 08C0                     or  al, al
  3839 000015A8 0F840900                 je @@testReg170
  3840 000015AC 66B801000000             mov eax, 1
  3841 000015B2 E9C000                   jmp @@retn
  3842                                  
  3843                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3844                                  
  3845                                  @@testReg170:
  3846 000015B5 68[C016]                 push testReg_24
  3847 000015B8 8D064F75                 lea  ax, [SymbolUpper]
  3848 000015BC 50                       push ax
  3849 000015BD E80A0A                   call eqstr
  3850 000015C0 83C404                   add  sp, 4
  3851 000015C3 08C0                     or  al, al
  3852 000015C5 0F840900                 je @@testReg171
  3853 000015C9 66B802000000             mov eax, 2
  3854 000015CF E9A300                   jmp @@retn
  3855                                  
  3856                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3857                                  
  3858                                  @@testReg171:
  3859 000015D2 68[C416]                 push testReg_25
  3860 000015D5 8D064F75                 lea  ax, [SymbolUpper]
  3861 000015D9 50                       push ax
  3862 000015DA E8ED09                   call eqstr
  3863 000015DD 83C404                   add  sp, 4
  3864 000015E0 08C0                     or  al, al
  3865 000015E2 0F840900                 je @@testReg172
  3866 000015E6 66B803000000             mov eax, 3
  3867 000015EC E98600                   jmp @@retn
  3868                                  
  3869                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3870                                  
  3871                                  @@testReg172:
  3872 000015EF 68[C816]                 push testReg_26
  3873 000015F2 8D064F75                 lea  ax, [SymbolUpper]
  3874 000015F6 50                       push ax
  3875 000015F7 E8D009                   call eqstr
  3876 000015FA 83C404                   add  sp, 4
  3877 000015FD 08C0                     or  al, al
  3878 000015FF 0F840900                 je @@testReg173
  3879 00001603 66B804000000             mov eax, 4
  3880 00001609 E96900                   jmp @@retn
  3881                                  
  3882                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3883                                  
  3884                                  @@testReg173:
  3885 0000160C 68[CC16]                 push testReg_27
  3886 0000160F 8D064F75                 lea  ax, [SymbolUpper]
  3887 00001613 50                       push ax
  3888 00001614 E8B309                   call eqstr
  3889 00001617 83C404                   add  sp, 4
  3890 0000161A 08C0                     or  al, al
  3891 0000161C 0F840900                 je @@testReg174
  3892 00001620 66B805000000             mov eax, 5
  3893 00001626 E94C00                   jmp @@retn
  3894                                  
  3895                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3896                                  
  3897                                  @@testReg174:
  3898 00001629 68[D016]                 push testReg_28
  3899 0000162C 8D064F75                 lea  ax, [SymbolUpper]
  3900 00001630 50                       push ax
  3901 00001631 E89609                   call eqstr
  3902 00001634 83C404                   add  sp, 4
  3903 00001637 08C0                     or  al, al
  3904 00001639 0F840900                 je @@testReg175
  3905 0000163D 66B806000000             mov eax, 6
  3906 00001643 E92F00                   jmp @@retn
  3907                                  
  3908                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3909                                  
  3910                                  @@testReg175:
  3911 00001646 68[D416]                 push testReg_29
  3912 00001649 8D064F75                 lea  ax, [SymbolUpper]
  3913 0000164D 50                       push ax
  3914 0000164E E87909                   call eqstr
  3915 00001651 83C404                   add  sp, 4
  3916 00001654 08C0                     or  al, al
  3917 00001656 0F840900                 je @@testReg176
  3918 0000165A 66B807000000             mov eax, 7
  3919 00001660 E91200                   jmp @@retn
  3920                                  
  3921                                  ;-109   RegType=0; return 0;
  3922                                  
  3923                                  @@testReg176:
  3924 00001663 66B800000000             mov eax, 0
  3925 00001669 A2[3F00]                 mov byte [RegType], al
  3926 0000166C 66B800000000             mov eax, 0
  3927 00001672 E90000                   jmp @@retn
  3928                                  
  3929                                  ;-110 }
  3930                                  
  3931                                  @@retn:
  3932 00001675 C3                       ret
  3933                                  ; ENDP
  3934 00001676 414C00                  testReg_0 db "AL",0
  3935 00001679 434C00                  testReg_1 db "CL",0
  3936 0000167C 444C00                  testReg_2 db "DL",0
  3937 0000167F 424C00                  testReg_3 db "BL",0
  3938 00001682 414800                  testReg_4 db "AH",0
  3939 00001685 434800                  testReg_5 db "CH",0
  3940 00001688 444800                  testReg_6 db "DH",0
  3941 0000168B 424800                  testReg_7 db "BH",0
  3942 0000168E 415800                  testReg_8 db "AX",0
  3943 00001691 435800                  testReg_9 db "CX",0
  3944 00001694 445800                  testReg_10 db "DX",0
  3945 00001697 425800                  testReg_11 db "BX",0
  3946 0000169A 535000                  testReg_12 db "SP",0
  3947 0000169D 425000                  testReg_13 db "BP",0
  3948 000016A0 534900                  testReg_14 db "SI",0
  3949 000016A3 444900                  testReg_15 db "DI",0
  3950 000016A6 455300                  testReg_16 db "ES",0
  3951 000016A9 435300                  testReg_17 db "CS",0
  3952 000016AC 535300                  testReg_18 db "SS",0
  3953 000016AF 445300                  testReg_19 db "DS",0
  3954 000016B2 465300                  testReg_20 db "FS",0
  3955 000016B5 475300                  testReg_21 db "GS",0
  3956 000016B8 45415800                testReg_22 db "EAX",0
  3957 000016BC 45435800                testReg_23 db "ECX",0
  3958 000016C0 45445800                testReg_24 db "EDX",0
  3959 000016C4 45425800                testReg_25 db "EBX",0
  3960 000016C8 45535000                testReg_26 db "ESP",0
  3961 000016CC 45425000                testReg_27 db "EBP",0
  3962 000016D0 45534900                testReg_28 db "ESI",0
  3963 000016D4 45444900                testReg_29 db "EDI",0
  3964                                  ;Back to main program: AS.C
  3965                                  
  3966                                  ;-206 #include "OUTPUT.C"
  3967                                  
  3968                                  ;Use include file: OUTPUT.C
  3969                                  
  3970                                  ;-1 int printLine() { int i; char c;
  3971                                  
  3972                                  
  3973                                  printLine:  ; *** PROC ***
  3974                                  
  3975                                  ;-2   prs("\n"); printhex16(PCStart);
  3976                                  
  3977                                  ;Function : printLine, Number of local variables: 2
  3978                                  ;   # type sign width line used address name   list of local variables
  3979                                  ;  200 var sign word     1 NULL bp-2    i
  3980                                  ;  201 var sign byte     1 NULL bp-4    c;
  3981 000016D8 C8040000                 ENTER  4,0
  3982 000016DC 68[6D17]                 push printLine_0
  3983 000016DF E80401                   call prs
  3984 000016E2 83C402                   add  sp, 2
  3985 000016E5 FF36[3900]               push word [PCStart]
  3986 000016E9 E8EB01                   call printhex16
  3987 000016EC 83C402                   add  sp, 2
  3988                                  
  3989                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  3990                                  
  3991 000016EF A1[4A00]                 mov ax, [OpPrintIndex]
  3992 000016F2 83F800                   cmp ax, 0
  3993 000016F5 0F850C00                 jne @@printLine177
  3994 000016F9 68[7017]                 push printLine_1
  3995 000016FC E8E700                   call prs
  3996 000016FF 83C402                   add  sp, 2
  3997                                  
  3998                                  ;-4   else {
  3999                                  
  4000 00001702 E95B00                   jmp @@printLine178
  4001                                  @@printLine177:
  4002                                  
  4003                                  ;-5     prc(PrReloc);
  4004                                  
  4005 00001705 A0[4E00]                 mov al, byte [PrReloc]
  4006 00001708 B400                     mov ah, 0
  4007 0000170A 50                       push ax
  4008 0000170B E87700                   call prc
  4009 0000170E 83C402                   add  sp, 2
  4010                                  
  4011                                  ;-6     i=0;
  4012                                  
  4013 00001711 66B800000000             mov eax, 0
  4014 00001717 8946FE                   mov word [bp-2], ax
  4015                                  
  4016                                  ;-7     do {
  4017                                  
  4018                                  @@printLine179:
  4019                                  
  4020                                  ;-8       c=OpPos[i];
  4021                                  
  4022 0000171A 8B5EFE                   mov bx, [bp-2]
  4023 0000171D 8A87B676                 mov al, [OpPos + bx]
  4024 00001721 8846FC                   mov byte [bp-4], al
  4025                                  
  4026                                  ;-9       printhex8a(c); prc(' ');
  4027                                  
  4028 00001724 8A46FC                   mov al, byte [bp-4]
  4029 00001727 B400                     mov ah, 0
  4030 00001729 50                       push ax
  4031 0000172A E85C01                   call printhex8a
  4032 0000172D 83C402                   add  sp, 2
  4033 00001730 6A20                     push 32
  4034 00001732 E85000                   call prc
  4035 00001735 83C402                   add  sp, 2
  4036                                  
  4037                                  ;-10       i++;
  4038                                  
  4039 00001738 FF46FE                   inc  word [bp-2]
  4040                                  
  4041                                  ;-11     } while(i < OpPrintIndex);
  4042                                  
  4043 0000173B 8B46FE                   mov ax, [bp-2]
  4044 0000173E 3B06[4A00]               cmp ax, [OpPrintIndex]
  4045 00001742 0F8D0200                 jge @@printLine180
  4046 00001746 EBD2                     jmp @@printLine179
  4047                                  @@printLine180:
  4048                                  
  4049                                  ;-12     do {// fill rest with blank
  4050                                  
  4051                                  @@printLine181:
  4052                                  
  4053                                  ;-13       prs("   ");
  4054                                  
  4055 00001748 68[8117]                 push printLine_2
  4056 0000174B E89800                   call prs
  4057 0000174E 83C402                   add  sp, 2
  4058                                  
  4059                                  ;-14       i++;
  4060                                  
  4061 00001751 FF46FE                   inc  word [bp-2]
  4062                                  
  4063                                  ;-15     } while(i < OPMAXLEN);
  4064                                  
  4065 00001754 8B46FE                   mov ax, [bp-2]
  4066 00001757 83F805                   cmp ax, 5
  4067 0000175A 0F8D0200                 jge @@printLine182
  4068 0000175E EBE8                     jmp @@printLine181
  4069                                  @@printLine182:
  4070                                  
  4071                                  ;-16   }
  4072                                  
  4073                                  
  4074                                  ;-17   prscomment(InputBuf);
  4075                                  
  4076                                  @@printLine178:
  4077 00001760 8D066E75                 lea  ax, [InputBuf]
  4078 00001764 50                       push ax
  4079 00001765 E85000                   call prscomment
  4080 00001768 83C402                   add  sp, 2
  4081                                  
  4082                                  ;-18 }
  4083                                  
  4084                                  
  4085                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4086 0000176B C9                       LEAVE
  4087 0000176C C3                       ret
  4088                                  ; ENDP
  4089 0000176D 5C6E00                  printLine_0 db "\n",0
  4090 00001770 202020202020202020-     printLine_1 db "                ",0
  4091 00001779 2020202020202000   
  4092 00001781 20202000                printLine_2 db "   ",0
  4093                                  
  4094                                  prc:  ; *** PROC ***
  4095                                  ;Function : prc, Number of local variables: 1
  4096                                  ;   # type sign width line used address name   list of local variables
  4097                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4098 00001785 C8000000                 ENTER  0,0
  4099 00001789 A0[2500]                 mov al, [LIST]
  4100 0000178C 08C0                     or  al, al
  4101 0000178E 0F841400                 je @@prc183
  4102 00001792 807E040A                cmp byte [bp+4], 10
  4103 00001796 0F850600                 jne @@prc184
  4104 0000179A B80D00                   mov  ax, 13
  4105 0000179D E81A07                   call writetty
  4106                                  
  4107                                  ;-20      al=c; writetty(); }
  4108                                  
  4109                                  @@prc184:
  4110 000017A0 8A4604                   mov  al, [bp+4]
  4111 000017A3 E81407                   call writetty
  4112                                  
  4113                                  ;-21    fputcR(c,lst_fd); }
  4114                                  
  4115                                  @@prc183:
  4116 000017A6 FF36[2C00]               push word [lst_fd]
  4117 000017AA 8A4604                   mov al, byte [bp+4]
  4118 000017AD B400                     mov ah, 0
  4119 000017AF 50                       push ax
  4120 000017B0 E8C708                   call fputcR
  4121 000017B3 83C404                   add  sp, 4
  4122                                  
  4123                                  ;-22 
  4124                                  
  4125                                  
  4126                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4127 000017B6 C9                       LEAVE
  4128 000017B7 C3                       ret
  4129                                  ; ENDP
  4130                                  
  4131                                  prscomment:  ; *** PROC ***
  4132                                  
  4133                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4134                                  
  4135                                  ;Function : prscomment, Number of local variables: 2
  4136                                  ;   # type sign width line used address name   list of local variables
  4137                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4138                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4139 000017B8 C8020000                 ENTER  2,0
  4140                                  @@prscomment185:
  4141 000017BC 8B5E04                   mov bx, [bp+4]
  4142 000017BF 8A07                     mov al, [bx]
  4143 000017C1 B400                     mov ah, 0
  4144 000017C3 08C0                     or  al, al
  4145 000017C5 0F841B00                 je @@prscomment186
  4146 000017C9 8B5E04                   mov bx, [bp+4]
  4147 000017CC 8A07                     mov al, [bx]
  4148 000017CE B400                     mov ah, 0
  4149 000017D0 8846FE                   mov byte [bp-2], al
  4150 000017D3 8A46FE                   mov al, byte [bp-2]
  4151 000017D6 B400                     mov ah, 0
  4152 000017D8 50                       push ax
  4153 000017D9 E8A9FF                   call prc
  4154 000017DC 83C402                   add  sp, 2
  4155 000017DF FF4604                   inc  word [bp+4]
  4156                                  
  4157                                  ;-25 }
  4158                                  
  4159 000017E2 EBD8                     jmp @@prscomment185
  4160                                  @@prscomment186:
  4161                                  
  4162                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4163 000017E4 C9                       LEAVE
  4164 000017E5 C3                       ret
  4165                                  ; ENDP
  4166                                  
  4167                                  prs:  ; *** PROC ***
  4168                                  ;Function : prs, Number of local variables: 3
  4169                                  ;   # type sign width line used address name   list of local variables
  4170                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4171                                  ;  201 var unsg byte    26 NULL bp-2    c
  4172                                  ;  202 var sign word    26 NULL bp-4    com;
  4173 000017E6 C8040000                 ENTER  4,0
  4174 000017EA 66B800000000             mov eax, 0
  4175 000017F0 8946FC                   mov word [bp-4], ax
  4176                                  
  4177                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4178                                  
  4179                                  @@prs187:
  4180 000017F3 8B5E04                   mov bx, [bp+4]
  4181 000017F6 8A07                     mov al, [bx]
  4182 000017F8 B400                     mov ah, 0
  4183 000017FA 08C0                     or  al, al
  4184 000017FC 0F848700                 je @@prs188
  4185 00001800 8B5E04                   mov bx, [bp+4]
  4186 00001803 8A07                     mov al, [bx]
  4187 00001805 B400                     mov ah, 0
  4188 00001807 8846FE                   mov byte [bp-2], al
  4189 0000180A 8A46FE                   mov al, [bp-2]
  4190 0000180D 3C22                     cmp al, 34
  4191 0000180F 0F851E00                 jne @@prs189
  4192 00001813 8B46FC                   mov ax, [bp-4]
  4193 00001816 08C0                     or  al, al
  4194 00001818 0F840C00                 je @@prs190
  4195 0000181C 66B800000000             mov eax, 0
  4196 00001822 8946FC                   mov word [bp-4], ax
  4197 00001825 E90900                   jmp @@prs191
  4198                                  @@prs190:
  4199 00001828 66B801000000             mov eax, 1
  4200 0000182E 8946FC                   mov word [bp-4], ax
  4201                                  
  4202                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4203                                  
  4204                                  @@prs191:
  4205                                  @@prs189:
  4206 00001831 8A46FE                   mov al, [bp-2]
  4207 00001834 3C5C                     cmp al, 92
  4208 00001836 0F853B00                 jne @@prs192
  4209 0000183A 8B46FC                   mov ax, [bp-4]
  4210 0000183D 83F800                   cmp ax, 0
  4211 00001840 0F853100                 jne @@prs193
  4212 00001844 FF4604                   inc  word [bp+4]
  4213 00001847 8B5E04                   mov bx, [bp+4]
  4214 0000184A 8A07                     mov al, [bx]
  4215 0000184C B400                     mov ah, 0
  4216 0000184E 8846FE                   mov byte [bp-2], al
  4217                                  
  4218                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4219                                  
  4220 00001851 8A46FE                   mov al, [bp-2]
  4221 00001854 3C6E                     cmp al, 110
  4222 00001856 0F850900                 jne @@prs194
  4223 0000185A 66B80A000000             mov eax, 10
  4224 00001860 8846FE                   mov byte [bp-2], al
  4225                                  @@prs194:
  4226 00001863 8A46FE                   mov al, [bp-2]
  4227 00001866 3C74                     cmp al, 116
  4228 00001868 0F850900                 jne @@prs195
  4229 0000186C 66B809000000             mov eax, 9
  4230 00001872 8846FE                   mov byte [bp-2], al
  4231                                  @@prs195:
  4232                                  @@prs193:
  4233                                  @@prs192:
  4234 00001875 8A46FE                   mov al, byte [bp-2]
  4235 00001878 B400                     mov ah, 0
  4236 0000187A 50                       push ax
  4237 0000187B E807FF                   call prc
  4238 0000187E 83C402                   add  sp, 2
  4239 00001881 FF4604                   inc  word [bp+4]
  4240                                  
  4241                                  ;-30 }
  4242                                  
  4243 00001884 E96CFF                   jmp @@prs187
  4244                                  @@prs188:
  4245                                  
  4246                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4247 00001887 C9                       LEAVE
  4248 00001888 C3                       ret
  4249                                  ; ENDP
  4250                                  
  4251                                  printhex8a:  ; *** PROC ***
  4252                                  
  4253                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4254                                  
  4255                                  ;Function : printhex8a, Number of local variables: 2
  4256                                  ;   # type sign width line used address name   list of local variables
  4257                                  ;  200 var unsg word    31 NULL bp+4    c
  4258                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4259 00001889 C8020000                 ENTER  2,0
  4260 0000188D 8B4604                   mov ax, [bp+4]
  4261 00001890 C1E804                   shr ax, 4
  4262 00001893 8946FE                   mov word [bp-2], ax
  4263 00001896 8346FE30                 add  word [bp-2], 48
  4264 0000189A 8B46FE                   mov ax, [bp-2]
  4265 0000189D 83F839                   cmp ax, 57
  4266 000018A0 0F8E0400                 jle @@printhex8a196
  4267 000018A4 8346FE07                 add  word [bp-2], 7
  4268                                  @@printhex8a196:
  4269 000018A8 FF76FE                   push word [bp-2]
  4270 000018AB E8D7FE                   call prc
  4271 000018AE 83C402                   add  sp, 2
  4272                                  
  4273                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4274                                  
  4275 000018B1 8B4604                   mov ax, [bp+4]
  4276 000018B4 83E00F                   and ax, 15
  4277 000018B7 8946FE                   mov word [bp-2], ax
  4278 000018BA 8346FE30                 add  word [bp-2], 48
  4279 000018BE 8B46FE                   mov ax, [bp-2]
  4280 000018C1 83F839                   cmp ax, 57
  4281 000018C4 0F8E0400                 jle @@printhex8a197
  4282 000018C8 8346FE07                 add  word [bp-2], 7
  4283                                  @@printhex8a197:
  4284 000018CC FF76FE                   push word [bp-2]
  4285 000018CF E8B3FE                   call prc
  4286 000018D2 83C402                   add  sp, 2
  4287                                  
  4288                                  ;-34 }
  4289                                  
  4290                                  
  4291                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4292 000018D5 C9                       LEAVE
  4293 000018D6 C3                       ret
  4294                                  ; ENDP
  4295                                  
  4296                                  printhex16:  ; *** PROC ***
  4297                                  
  4298                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4299                                  
  4300                                  ;Function : printhex16, Number of local variables: 2
  4301                                  ;   # type sign width line used address name   list of local variables
  4302                                  ;  200 var unsg word    35 NULL bp+4    i
  4303                                  ;  201 var unsg word    35 NULL bp-2    half;
  4304 000018D7 C8020000                 ENTER  2,0
  4305 000018DB 8B4604                   mov ax, [bp+4]
  4306 000018DE C1E808                   shr ax, 8
  4307 000018E1 8946FE                   mov word [bp-2], ax
  4308 000018E4 FF76FE                   push word [bp-2]
  4309 000018E7 E89FFF                   call printhex8a
  4310 000018EA 83C402                   add  sp, 2
  4311 000018ED 8B4604                   mov ax, [bp+4]
  4312 000018F0 25FF00                   and ax, 255
  4313 000018F3 8946FE                   mov word [bp-2], ax
  4314 000018F6 FF76FE                   push word [bp-2]
  4315 000018F9 E88DFF                   call printhex8a
  4316 000018FC 83C402                   add  sp, 2
  4317                                  
  4318                                  ;-37 }
  4319                                  
  4320                                  
  4321                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4322 000018FF C9                       LEAVE
  4323 00001900 C3                       ret
  4324                                  ; ENDP
  4325                                  
  4326                                  printIntU:  ; *** PROC ***
  4327                                  
  4328                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4329                                  
  4330                                  ;Function : printIntU, Number of local variables: 2
  4331                                  ;   # type sign width line used address name   list of local variables
  4332                                  ;  200 var unsg word    38 NULL bp+4    n
  4333                                  ;  201 var unsg word    38 NULL bp-2    e;
  4334 00001901 C8020000                 ENTER  2,0
  4335 00001905 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4336 00001909 0F821700                 jb  @@printIntU198
  4337 0000190D 8B4604                   mov ax, [bp+4]
  4338 00001910 BB0A00                   mov bx, 10
  4339 00001913 BA0000                   mov dx, 0
  4340 00001916 F7F3                     div bx
  4341 00001918 8946FE                   mov word [bp-2], ax
  4342                                  
  4343                                  ;-40     printIntU(e); }
  4344                                  
  4345 0000191B FF76FE                   push word [bp-2]
  4346 0000191E E8E0FF                   call printIntU
  4347 00001921 83C402                   add  sp, 2
  4348                                  
  4349                                  ;-41     n = n % 10; //unsigned mod
  4350                                  
  4351                                  @@printIntU198:
  4352 00001924 8B4604                   mov ax, [bp+4]
  4353 00001927 BB0A00                   mov bx, 10
  4354 0000192A BA0000                   mov dx, 0
  4355 0000192D F7F3                     div bx
  4356 0000192F 89D0                     mov ax, dx
  4357 00001931 894604                   mov word [bp+4], ax
  4358                                  
  4359                                  ;-42     n += '0'; prc(n);
  4360                                  
  4361 00001934 83460430                 add  word [bp+4], 48
  4362 00001938 FF7604                   push word [bp+4]
  4363 0000193B E847FE                   call prc
  4364 0000193E 83C402                   add  sp, 2
  4365                                  
  4366                                  ;-43 }
  4367                                  
  4368                                  
  4369                                  ;-44 
  4370                                  
  4371                                  
  4372                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4373 00001941 C9                       LEAVE
  4374 00001942 C3                       ret
  4375                                  ; ENDP
  4376                                  
  4377                                  error1:  ; *** PROC ***
  4378                                  ;Function : error1, Number of local variables: 1
  4379                                  ;   # type sign width line used address name   list of local variables
  4380                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4381 00001943 C8000000                 ENTER  0,0
  4382 00001947 66B801000000             mov eax, 1
  4383 0000194D A2[2500]                 mov byte [LIST], al
  4384 00001950 FF06[3200]               inc  word [ErrorCount]
  4385                                  
  4386                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4387                                  
  4388 00001954 68[7C19]                 push error1_0
  4389 00001957 E88CFE                   call prs
  4390 0000195A 83C402                   add  sp, 2
  4391 0000195D FF7604                   push word [bp+4]
  4392 00001960 E883FE                   call prs
  4393 00001963 83C402                   add  sp, 2
  4394                                  
  4395                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4396                                  
  4397 00001966 68[9719]                 push error1_1
  4398 00001969 E87AFE                   call prs
  4399 0000196C 83C402                   add  sp, 2
  4400 0000196F 8D063075                 lea  ax, [Symbol]
  4401 00001973 50                       push ax
  4402 00001974 E86FFE                   call prs
  4403 00001977 83C402                   add  sp, 2
  4404                                  
  4405                                  ;-48 int allowederror(){error1("not allowed here"); }
  4406 0000197A C9                       LEAVE
  4407 0000197B C3                       ret
  4408                                  ; ENDP
  4409 0000197C 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4410 00001985 6E657874206C696E65-
  4411 0000198E 204552524F523A2000 
  4412 00001997 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4413 000019A0 2000               
  4414                                  
  4415                                  allowederror:  ; *** PROC ***
  4416 000019A2 68[AC19]                 push allowederror_0
  4417 000019A5 E89BFF                   call error1
  4418 000019A8 83C402                   add  sp, 2
  4419                                  
  4420                                  ;-49 int implmerror(){error1("not implemented");}
  4421                                  
  4422 000019AB C3                       ret
  4423                                  ; ENDP
  4424 000019AC 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4425 000019B5 6564206865726500   
  4426                                  
  4427                                  implmerror:  ; *** PROC ***
  4428 000019BD 68[C719]                 push implmerror_0
  4429 000019C0 E880FF                   call error1
  4430 000019C3 83C402                   add  sp, 2
  4431                                  
  4432                                  ;-50 int indexerror (){error1("invalid index register");}
  4433                                  
  4434 000019C6 C3                       ret
  4435                                  ; ENDP
  4436 000019C7 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4437 000019D0 6D656E74656400     
  4438                                  
  4439                                  indexerror:  ; *** PROC ***
  4440 000019D7 68[E119]                 push indexerror_0
  4441 000019DA E866FF                   call error1
  4442 000019DD 83C402                   add  sp, 2
  4443                                  
  4444                                  ;-51 int numbererror(){error1("number expected");}
  4445                                  
  4446 000019E0 C3                       ret
  4447                                  ; ENDP
  4448 000019E1 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4449 000019EA 6E6465782072656769-
  4450 000019F3 7374657200         
  4451                                  
  4452                                  numbererror:  ; *** PROC ***
  4453 000019F8 68[021A]                 push numbererror_0
  4454 000019FB E845FF                   call error1
  4455 000019FE 83C402                   add  sp, 2
  4456                                  
  4457                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4458                                  
  4459 00001A01 C3                       ret
  4460                                  ; ENDP
  4461 00001A02 6E756D626572206578-     numbererror_0 db "number expected",0
  4462 00001A0B 70656374656400     
  4463                                  
  4464                                  regmemerror:  ; *** PROC ***
  4465 00001A12 68[1C1A]                 push regmemerror_0
  4466 00001A15 E82BFF                   call error1
  4467 00001A18 83C402                   add  sp, 2
  4468                                  
  4469                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4470                                  
  4471 00001A1B C3                       ret
  4472                                  ; ENDP
  4473 00001A1C 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4474 00001A25 73746572206F72206D-
  4475 00001A2E 656D6F727920616C6C-
  4476 00001A37 6F77656400         
  4477                                  
  4478                                  segregerror:  ; *** PROC ***
  4479 00001A3C 68[461A]                 push segregerror_0
  4480 00001A3F E801FF                   call error1
  4481 00001A42 83C402                   add  sp, 2
  4482                                  
  4483                                  ;-54 int syntaxerror(){error1("syntax");}
  4484                                  
  4485 00001A45 C3                       ret
  4486                                  ; ENDP
  4487 00001A46 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4488 00001A4F 65676973746572206E-
  4489 00001A58 6F7420616C6C6F7765-
  4490 00001A61 6400               
  4491                                  
  4492                                  syntaxerror:  ; *** PROC ***
  4493 00001A63 68[6D1A]                 push syntaxerror_0
  4494 00001A66 E8DAFE                   call error1
  4495 00001A69 83C402                   add  sp, 2
  4496                                  
  4497                                  ;-55 
  4498                                  
  4499                                  
  4500                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4501                                  
  4502 00001A6C C3                       ret
  4503                                  ; ENDP
  4504 00001A6D 73796E74617800          syntaxerror_0 db "syntax",0
  4505                                  
  4506                                  errorexit:  ; *** PROC ***
  4507                                  ;Function : errorexit, Number of local variables: 1
  4508                                  ;   # type sign width line used address name   list of local variables
  4509                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4510 00001A74 C8000000                 ENTER  0,0
  4511 00001A78 FF7604                   push word [bp+4]
  4512 00001A7B E8C5FE                   call error1
  4513 00001A7E 83C402                   add  sp, 2
  4514 00001A81 6A01                     push 1
  4515 00001A83 E80704                   call end1
  4516 00001A86 83C402                   add  sp, 2
  4517                                  
  4518                                  ;-57 int addrexit(){errorexit("illegal address");}
  4519 00001A89 C9                       LEAVE
  4520 00001A8A C3                       ret
  4521                                  ; ENDP
  4522                                  
  4523                                  addrexit:  ; *** PROC ***
  4524 00001A8B 68[951A]                 push addrexit_0
  4525 00001A8E E8E3FF                   call errorexit
  4526 00001A91 83C402                   add  sp, 2
  4527                                  
  4528                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4529                                  
  4530 00001A94 C3                       ret
  4531                                  ; ENDP
  4532 00001A95 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4533 00001A9E 64647265737300     
  4534                                  
  4535                                  internexit:  ; *** PROC ***
  4536 00001AA5 68[AF1A]                 push internexit_0
  4537 00001AA8 E8C9FF                   call errorexit
  4538 00001AAB 83C402                   add  sp, 2
  4539 00001AAE C3                       ret
  4540                                  ; ENDP
  4541 00001AAF 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4542 00001AB8 6D70696C6572206572-
  4543 00001AC1 726F7200           
  4544                                  ;Back to main program: AS.C
  4545                                  
  4546                                  ;-207 #include "MAIN.C"
  4547                                  
  4548                                  ;Use include file: MAIN.C
  4549                                  
  4550                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4551                                  
  4552                                  
  4553                                  getarg:  ; *** PROC ***
  4554                                  
  4555                                  ;-2   arglen1=*arglen;
  4556                                  
  4557                                  ;Function : getarg, Number of local variables: 3
  4558                                  ;   # type sign width line used address name   list of local variables
  4559                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4560                                  ;  201 var sign word     1 NULL bp-4    i
  4561                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4562 00001AC5 C8060000                 ENTER  6,0
  4563 00001AC9 8B1E[5700]               mov bx, [arglen]
  4564 00001ACD 8A07                     mov al, [bx]
  4565 00001ACF B400                     mov ah, 0
  4566 00001AD1 8946FE                   mov word [bp-2], ax
  4567                                  
  4568                                  ;-3   if (arglen1==0) {
  4569                                  
  4570 00001AD4 8B46FE                   mov ax, [bp-2]
  4571 00001AD7 83F800                   cmp ax, 0
  4572 00001ADA 0F851C00                 jne @@getarg199
  4573                                  
  4574                                  ;-4     cputs(Version1);
  4575                                  
  4576 00001ADE 8D06[1000]               lea  ax, [Version1]
  4577 00001AE2 50                       push ax
  4578 00001AE3 E8DC03                   call cputs
  4579 00001AE6 83C402                   add  sp, 2
  4580                                  
  4581                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4582                                  
  4583 00001AE9 68[8A1C]                 push getarg_0
  4584 00001AEC E8D303                   call cputs
  4585 00001AEF 83C402                   add  sp, 2
  4586                                  
  4587                                  ;-6     exitR(3);
  4588                                  
  4589 00001AF2 6A03                     push 3
  4590 00001AF4 E8A605                   call exitR
  4591 00001AF7 83C402                   add  sp, 2
  4592                                  
  4593                                  ;-7   }
  4594                                  
  4595                                  
  4596                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4597                                  
  4598                                  @@getarg199:
  4599 00001AFA 8B46FE                   mov ax, [bp-2]
  4600 00001AFD 058100                   add ax, 129
  4601 00001B00 8946FC                   mov word [bp-4], ax
  4602 00001B03 66B800000000             mov eax, 0
  4603 00001B09 8B5EFC                   mov  bx, [bp-4]
  4604 00001B0C 8907                     mov  [bx], ax
  4605 00001B0E FF4EFE                   dec  word [bp-2]
  4606                                  
  4607                                  ;-9   toupper(argv);
  4608                                  
  4609 00001B11 FF36[5900]               push word [argv]
  4610 00001B15 E8D803                   call toupper
  4611 00001B18 83C402                   add  sp, 2
  4612                                  
  4613                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4614                                  
  4615 00001B1B FF36[5900]               push word [argv]
  4616 00001B1F 8D06ED75                 lea  ax, [namein]
  4617 00001B23 50                       push ax
  4618 00001B24 E83704                   call strcpy
  4619 00001B27 83C404                   add  sp, 4
  4620 00001B2A 68[AF1C]                 push getarg_1
  4621 00001B2D 8D06ED75                 lea  ax, [namein]
  4622 00001B31 50                       push ax
  4623 00001B32 E8EA04                   call strcat1
  4624 00001B35 83C404                   add  sp, 4
  4625                                  
  4626                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4627                                  
  4628 00001B38 FF36[5900]               push word [argv]
  4629 00001B3C 8D063076                 lea  ax, [namelst]
  4630 00001B40 50                       push ax
  4631 00001B41 E81A04                   call strcpy
  4632 00001B44 83C404                   add  sp, 4
  4633 00001B47 68[B21C]                 push getarg_2
  4634 00001B4A 8D063076                 lea  ax, [namelst]
  4635 00001B4E 50                       push ax
  4636 00001B4F E8CD04                   call strcat1
  4637 00001B52 83C404                   add  sp, 4
  4638                                  
  4639                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4640                                  
  4641 00001B55 FF36[5900]               push word [argv]
  4642 00001B59 8D067376                 lea  ax, [namebin]
  4643 00001B5D 50                       push ax
  4644 00001B5E E8FD03                   call strcpy
  4645 00001B61 83C404                   add  sp, 4
  4646 00001B64 68[B71C]                 push getarg_3
  4647 00001B67 8D067376                 lea  ax, [namebin]
  4648 00001B6B 50                       push ax
  4649 00001B6C E8B004                   call strcat1
  4650 00001B6F 83C404                   add  sp, 4
  4651                                  
  4652                                  ;-13 
  4653                                  
  4654                                  
  4655                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4656                                  
  4657 00001B72 66B801000000             mov eax, 1
  4658 00001B78 A2[2500]                 mov byte [LIST], al
  4659 00001B7B 66B800000000             mov eax, 0
  4660 00001B81 A3[3000]                 mov word [DOS_ERR], ax
  4661 00001B84 66B800000000             mov eax, 0
  4662 00001B8A A3[3700]                 mov word [PC], ax
  4663 00001B8D 66B800000000             mov eax, 0
  4664 00001B93 A3[3200]                 mov word [ErrorCount], ax
  4665                                  
  4666                                  ;-15   asm_fd=openR (namein);
  4667                                  
  4668 00001B96 8D06ED75                 lea  ax, [namein]
  4669 00001B9A 50                       push ax
  4670 00001B9B E8A604                   call openR
  4671 00001B9E 83C402                   add  sp, 2
  4672 00001BA1 A3[2A00]                 mov word [asm_fd], ax
  4673                                  
  4674                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4675                                  
  4676 00001BA4 A1[3000]                 mov ax, [DOS_ERR]
  4677 00001BA7 08C0                     or  al, al
  4678 00001BA9 0F841C00                 je @@getarg200
  4679 00001BAD 68[BC1C]                 push getarg_4
  4680 00001BB0 E80F03                   call cputs
  4681 00001BB3 83C402                   add  sp, 2
  4682 00001BB6 8D06ED75                 lea  ax, [namein]
  4683 00001BBA 50                       push ax
  4684 00001BBB E80403                   call cputs
  4685 00001BBE 83C402                   add  sp, 2
  4686 00001BC1 6A01                     push 1
  4687 00001BC3 E8D704                   call exitR
  4688 00001BC6 83C402                   add  sp, 2
  4689                                  
  4690                                  ;-17   lst_fd=creatR(namelst);
  4691                                  
  4692                                  @@getarg200:
  4693 00001BC9 8D063076                 lea  ax, [namelst]
  4694 00001BCD 50                       push ax
  4695 00001BCE E88204                   call creatR
  4696 00001BD1 83C402                   add  sp, 2
  4697 00001BD4 A3[2C00]                 mov word [lst_fd], ax
  4698                                  
  4699                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4700                                  
  4701 00001BD7 A1[3000]                 mov ax, [DOS_ERR]
  4702 00001BDA 08C0                     or  al, al
  4703 00001BDC 0F841C00                 je @@getarg201
  4704 00001BE0 68[D21C]                 push getarg_5
  4705 00001BE3 E8DC02                   call cputs
  4706 00001BE6 83C402                   add  sp, 2
  4707 00001BE9 8D063076                 lea  ax, [namelst]
  4708 00001BED 50                       push ax
  4709 00001BEE E8D102                   call cputs
  4710 00001BF1 83C402                   add  sp, 2
  4711 00001BF4 6A02                     push 2
  4712 00001BF6 E8A404                   call exitR
  4713 00001BF9 83C402                   add  sp, 2
  4714                                  
  4715                                  ;-19   bin_fd=creatR(namebin);
  4716                                  
  4717                                  @@getarg201:
  4718 00001BFC 8D067376                 lea  ax, [namebin]
  4719 00001C00 50                       push ax
  4720 00001C01 E84F04                   call creatR
  4721 00001C04 83C402                   add  sp, 2
  4722 00001C07 A3[2E00]                 mov word [bin_fd], ax
  4723                                  
  4724                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4725                                  
  4726 00001C0A A1[3000]                 mov ax, [DOS_ERR]
  4727 00001C0D 08C0                     or  al, al
  4728 00001C0F 0F841C00                 je @@getarg202
  4729 00001C13 68[E91C]                 push getarg_6
  4730 00001C16 E8A902                   call cputs
  4731 00001C19 83C402                   add  sp, 2
  4732 00001C1C 8D067376                 lea  ax, [namebin]
  4733 00001C20 50                       push ax
  4734 00001C21 E89E02                   call cputs
  4735 00001C24 83C402                   add  sp, 2
  4736 00001C27 6A02                     push 2
  4737 00001C29 E87104                   call exitR
  4738 00001C2C 83C402                   add  sp, 2
  4739                                  
  4740                                  ;-21   prs(";");prs(Version1);
  4741                                  
  4742                                  @@getarg202:
  4743 00001C2F 68[FF1C]                 push getarg_7
  4744 00001C32 E8B1FB                   call prs
  4745 00001C35 83C402                   add  sp, 2
  4746 00001C38 8D06[1000]               lea  ax, [Version1]
  4747 00001C3C 50                       push ax
  4748 00001C3D E8A6FB                   call prs
  4749 00001C40 83C402                   add  sp, 2
  4750                                  
  4751                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4752                                  
  4753 00001C43 68[011D]                 push getarg_8
  4754 00001C46 E89DFB                   call prs
  4755 00001C49 83C402                   add  sp, 2
  4756 00001C4C 8D06ED75                 lea  ax, [namein]
  4757 00001C50 50                       push ax
  4758 00001C51 E892FB                   call prs
  4759 00001C54 83C402                   add  sp, 2
  4760 00001C57 68[0C1D]                 push getarg_9
  4761 00001C5A E889FB                   call prs
  4762 00001C5D 83C402                   add  sp, 2
  4763 00001C60 8D063076                 lea  ax, [namelst]
  4764 00001C64 50                       push ax
  4765 00001C65 E87EFB                   call prs
  4766 00001C68 83C402                   add  sp, 2
  4767                                  
  4768                                  ;-23   prs(", "); prs(namebin);
  4769                                  
  4770 00001C6B 68[171D]                 push getarg_10
  4771 00001C6E E875FB                   call prs
  4772 00001C71 83C402                   add  sp, 2
  4773 00001C74 8D067376                 lea  ax, [namebin]
  4774 00001C78 50                       push ax
  4775 00001C79 E86AFB                   call prs
  4776 00001C7C 83C402                   add  sp, 2
  4777                                  
  4778                                  ;-24   prs("\n");
  4779                                  
  4780 00001C7F 68[1A1D]                 push getarg_11
  4781 00001C82 E861FB                   call prs
  4782 00001C85 83C402                   add  sp, 2
  4783                                  
  4784                                  ;-25 }
  4785                                  
  4786                                  
  4787                                  ;-26 int epilog() { int i; int j; char c;
  4788 00001C88 C9                       LEAVE
  4789 00001C89 C3                       ret
  4790                                  ; ENDP
  4791 00001C8A 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4792 00001C93 41532E434F4D206669-
  4793 00001C9C 6C656E616D65205B77-
  4794 00001CA5 2F6F202E535D203A20-
  4795 00001CAE 00                 
  4796 00001CAF 2E5300                  getarg_1 db ".S",0
  4797 00001CB2 2E4C535400              getarg_2 db ".LST",0
  4798 00001CB7 2E434F4D00              getarg_3 db ".COM",0
  4799 00001CBC 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4800 00001CC5 6C65206D697373696E-
  4801 00001CCE 673A2000           
  4802 00001CD2 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4803 00001CDB 206E6F742063726561-
  4804 00001CE4 74653A2000         
  4805 00001CE9 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4806 00001CF2 6E6F74206372656174-
  4807 00001CFB 653A2000           
  4808 00001CFF 3B00                    getarg_7 db ";",0
  4809 00001D01 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4810 00001D0A 2000               
  4811 00001D0C 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4812 00001D15 2000               
  4813 00001D17 2C2000                  getarg_10 db ", ",0
  4814 00001D1A 5C6E00                  getarg_11 db "\n",0
  4815                                  
  4816                                  epilog:  ; *** PROC ***
  4817                                  
  4818                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4819                                  
  4820                                  ;Function : epilog, Number of local variables: 3
  4821                                  ;   # type sign width line used address name   list of local variables
  4822                                  ;  200 var sign word    26 NULL bp-2    i
  4823                                  ;  201 var sign word    26 NULL bp-4    j
  4824                                  ;  202 var sign byte    26 NULL bp-6    c;
  4825 00001D1D C8060000                 ENTER  6,0
  4826 00001D21 68[461E]                 push epilog_0
  4827 00001D24 E8BFFA                   call prs
  4828 00001D27 83C402                   add  sp, 2
  4829 00001D2A FF36[3200]               push word [ErrorCount]
  4830 00001D2E E8D0FB                   call printIntU
  4831 00001D31 83C402                   add  sp, 2
  4832                                  
  4833                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4834                                  
  4835 00001D34 A1[3200]                 mov ax, [ErrorCount]
  4836 00001D37 08C0                     or  al, al
  4837 00001D39 0F840900                 je @@epilog203
  4838 00001D3D 68[561E]                 push epilog_1
  4839 00001D40 E8A3FA                   call prs
  4840 00001D43 83C402                   add  sp, 2
  4841                                  
  4842                                  ;-29   prs(", Label & Var: ");
  4843                                  
  4844                                  @@epilog203:
  4845 00001D46 68[641E]                 push epilog_2
  4846 00001D49 E89AFA                   call prs
  4847 00001D4C 83C402                   add  sp, 2
  4848                                  
  4849                                  ;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4850                                  
  4851                                  
  4852                                  ;-31   i= &LabelNames;
  4853                                  
  4854                                  
  4855                                  ;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4856                                  
  4857                                  
  4858                                  ;-33   } while (i < LabelNamePtr); prs("<< \n"); */
  4859                                  
  4860                                  
  4861                                  ;-34   if (LabelMaxIx) {
  4862                                  
  4863 00001D4F A1[5100]                 mov ax, [LabelMaxIx]
  4864 00001D52 08C0                     or  al, al
  4865 00001D54 0F846900                 je @@epilog204
  4866                                  
  4867                                  ;-35     i = 1;
  4868                                  
  4869 00001D58 66B801000000             mov eax, 1
  4870 00001D5E 8946FE                   mov word [bp-2], ax
  4871                                  
  4872                                  ;-36     LabelNamePtr= &LabelNames;
  4873                                  
  4874 00001D61 B8BB76                   mov ax, LabelNames
  4875 00001D64 A3[4F00]                 mov word [LabelNamePtr], ax
  4876                                  
  4877                                  ;-37     do {
  4878                                  
  4879                                  @@epilog205:
  4880                                  
  4881                                  ;-38       prs(LabelNamePtr); prc(' ');
  4882                                  
  4883 00001D67 FF36[4F00]               push word [LabelNamePtr]
  4884 00001D6B E878FA                   call prs
  4885 00001D6E 83C402                   add  sp, 2
  4886 00001D71 6A20                     push 32
  4887 00001D73 E80FFA                   call prc
  4888 00001D76 83C402                   add  sp, 2
  4889                                  
  4890                                  ;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4891                                  
  4892 00001D79 8B5EFE                   mov bx, [bp-2]
  4893 00001D7C D1E3                     shl bx, 1
  4894 00001D7E 8B87A37A                 mov ax, [LabelAddr + bx]
  4895 00001D82 8946FC                   mov word [bp-4], ax
  4896 00001D85 FF76FC                   push word [bp-4]
  4897 00001D88 E84CFB                   call printhex16
  4898 00001D8B 83C402                   add  sp, 2
  4899 00001D8E 68[741E]                 push epilog_3
  4900 00001D91 E852FA                   call prs
  4901 00001D94 83C402                   add  sp, 2
  4902                                  
  4903                                  ;-40       j=strlen(LabelNamePtr);//get end of actual name
  4904                                  
  4905 00001D97 FF36[4F00]               push word [LabelNamePtr]
  4906 00001D9B E89501                   call strlen
  4907 00001D9E 83C402                   add  sp, 2
  4908 00001DA1 8946FC                   mov word [bp-4], ax
  4909                                  
  4910                                  ;-41       LabelNamePtr=LabelNamePtr+j;
  4911                                  
  4912 00001DA4 A1[4F00]                 mov ax, [LabelNamePtr]
  4913 00001DA7 0346FC                   add ax, [bp-4]
  4914 00001DAA A3[4F00]                 mov word [LabelNamePtr], ax
  4915                                  
  4916                                  ;-42       LabelNamePtr++;
  4917                                  
  4918 00001DAD FF06[4F00]               inc  word [LabelNamePtr]
  4919                                  
  4920                                  ;-43       i++;
  4921                                  
  4922 00001DB1 FF46FE                   inc  word [bp-2]
  4923                                  
  4924                                  ;-44     } while (i <= LabelMaxIx);
  4925                                  
  4926 00001DB4 8B46FE                   mov ax, [bp-2]
  4927 00001DB7 3B06[5100]               cmp ax, [LabelMaxIx]
  4928 00001DBB 0F8F0200                 jg  @@epilog206
  4929 00001DBF EBA6                     jmp @@epilog205
  4930                                  @@epilog206:
  4931                                  
  4932                                  ;-45   }
  4933                                  
  4934                                  
  4935                                  ;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4936                                  
  4937                                  @@epilog204:
  4938 00001DC1 68[781E]                 push epilog_4
  4939 00001DC4 E81FFA                   call prs
  4940 00001DC7 83C402                   add  sp, 2
  4941 00001DCA FF36[5500]               push word [BinLen]
  4942 00001DCE E830FB                   call printIntU
  4943 00001DD1 83C402                   add  sp, 2
  4944 00001DD4 68[851E]                 push epilog_5
  4945 00001DD7 E80CFA                   call prs
  4946 00001DDA 83C402                   add  sp, 2
  4947                                  
  4948                                  ;-47   i=0;
  4949                                  
  4950 00001DDD 66B800000000             mov eax, 0
  4951 00001DE3 8946FE                   mov word [bp-2], ax
  4952                                  
  4953                                  ;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4954                                  
  4955                                  @@epilog207:
  4956 00001DE6 6A20                     push 32
  4957 00001DE8 E89AF9                   call prc
  4958 00001DEB 83C402                   add  sp, 2
  4959 00001DEE 8B5EFE                   mov bx, [bp-2]
  4960 00001DF1 8A876B7B                 mov al, [FileBin + bx]
  4961 00001DF5 8946FC                   mov word [bp-4], ax
  4962 00001DF8 FF76FC                   push word [bp-4]
  4963 00001DFB E88BFA                   call printhex8a
  4964 00001DFE 83C402                   add  sp, 2
  4965 00001E01 FF46FE                   inc  word [bp-2]
  4966                                  
  4967                                  ;-49   } while (i < BinLen);
  4968                                  
  4969 00001E04 8B46FE                   mov ax, [bp-2]
  4970 00001E07 3B06[5500]               cmp ax, [BinLen]
  4971 00001E0B 0F8D0200                 jge @@epilog208
  4972 00001E0F EBD5                     jmp @@epilog207
  4973                                  @@epilog208:
  4974                                  
  4975                                  ;-50   i=0;
  4976                                  
  4977 00001E11 66B800000000             mov eax, 0
  4978 00001E17 8946FE                   mov word [bp-2], ax
  4979                                  
  4980                                  ;-51   do {
  4981                                  
  4982                                  @@epilog209:
  4983                                  
  4984                                  ;-52     c = FileBin[i];
  4985                                  
  4986 00001E1A 8B5EFE                   mov bx, [bp-2]
  4987 00001E1D 8A876B7B                 mov al, [FileBin + bx]
  4988 00001E21 8846FA                   mov byte [bp-6], al
  4989                                  
  4990                                  ;-53     fputcR(c, bin_fd);
  4991                                  
  4992 00001E24 FF36[2E00]               push word [bin_fd]
  4993 00001E28 8A46FA                   mov al, byte [bp-6]
  4994 00001E2B B400                     mov ah, 0
  4995 00001E2D 50                       push ax
  4996 00001E2E E84902                   call fputcR
  4997 00001E31 83C404                   add  sp, 4
  4998                                  
  4999                                  ;-54     i++;
  5000                                  
  5001 00001E34 FF46FE                   inc  word [bp-2]
  5002                                  
  5003                                  ;-55   } while (i < BinLen);
  5004                                  
  5005 00001E37 8B46FE                   mov ax, [bp-2]
  5006 00001E3A 3B06[5500]               cmp ax, [BinLen]
  5007 00001E3E 0F8D0200                 jge @@epilog210
  5008 00001E42 EBD6                     jmp @@epilog209
  5009                                  @@epilog210:
  5010                                  
  5011                                  ;-56 }
  5012                                  
  5013                                  
  5014                                  ;-57 int end1(int n) {
  5015 00001E44 C9                       LEAVE
  5016 00001E45 C3                       ret
  5017                                  ; ENDP
  5018 00001E46 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5019 00001E4F 726F72733A2000     
  5020 00001E56 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5021 00001E5F 2A2A2A2000         
  5022 00001E64 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  5023 00001E6D 205661723A2000     
  5024 00001E74 2C202000                epilog_3 db ",  ",0
  5025 00001E78 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  5026 00001E81 6C652000           
  5027 00001E85 2062797465733A00        epilog_5 db " bytes:",0
  5028                                  
  5029                                  end1:  ; *** PROC ***
  5030                                  
  5031                                  ;-58   fcloseR(asm_fd);
  5032                                  
  5033                                  ;Function : end1, Number of local variables: 1
  5034                                  ;   # type sign width line used address name   list of local variables
  5035                                  ;  200 var sign word    57 NULL bp+4    n;
  5036 00001E8D C8000000                 ENTER  0,0
  5037 00001E91 FF36[2A00]               push word [asm_fd]
  5038 00001E95 E8F701                   call fcloseR
  5039 00001E98 83C402                   add  sp, 2
  5040                                  
  5041                                  ;-59   fcloseR(lst_fd);
  5042                                  
  5043 00001E9B FF36[2C00]               push word [lst_fd]
  5044 00001E9F E8ED01                   call fcloseR
  5045 00001EA2 83C402                   add  sp, 2
  5046                                  
  5047                                  ;-60   fcloseR(bin_fd);
  5048                                  
  5049 00001EA5 FF36[2E00]               push word [bin_fd]
  5050 00001EA9 E8E301                   call fcloseR
  5051 00001EAC 83C402                   add  sp, 2
  5052                                  
  5053                                  ;-61   exitR(n);
  5054                                  
  5055 00001EAF FF7604                   push word [bp+4]
  5056 00001EB2 E8E801                   call exitR
  5057 00001EB5 83C402                   add  sp, 2
  5058                                  
  5059                                  ;-62 }
  5060 00001EB8 C9                       LEAVE
  5061 00001EB9 C3                       ret
  5062                                  ; ENDP
  5063                                  ;Back to main program: AS.C
  5064                                   
  5065                                  ; missing functions: 
  5066                                  ; digit
  5067                                  ; strcpy
  5068                                  ; eqstr
  5069                                  ; strlen
  5070                                  ; eqstr
  5071                                  ; eqstr
  5072                                  ; eqstr
  5073                                  ; eqstr
  5074                                  ; readRL
  5075                                  ; readRL
  5076                                  ; digit
  5077                                  ; digit
  5078                                  ; strcpy
  5079                                  ; toupper
  5080                                  ; strlen
  5081                                  ; strlen
  5082                                  ; eqstr
  5083                                  ; eqstr
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
  5112                                  ; writetty
  5113                                  ; writetty
  5114                                  ; fputcR
  5115                                  ; cputs
  5116                                  ; cputs
  5117                                  ; exitR
  5118                                  ; toupper
  5119                                  ; strcpy
  5120                                  ; strcat1
  5121                                  ; strcpy
  5122                                  ; strcat1
  5123                                  ; strcpy
  5124                                  ; strcat1
  5125                                  ; openR
  5126                                  ; cputs
  5127                                  ; cputs
  5128                                  ; exitR
  5129                                  ; creatR
  5130                                  ; cputs
  5131                                  ; cputs
  5132                                  ; exitR
  5133                                  ; creatR
  5134                                  ; cputs
  5135                                  ; cputs
  5136                                  ; exitR
  5137                                  ; strlen
  5138                                  ; fputcR
  5139                                  ; fcloseR
  5140                                  ; fcloseR
  5141                                  ; fcloseR
  5142                                  ; exitR
  5143                                  ; Number of unresolved CALLs :   77
  5144                                  ;use archive file: AR.C
  5145                                  
  5146                                  ;-208 // AR.C Archive
  5147                                  
  5148                                  ;Number of CALLs:    2 : writetty
  5149                                  
  5150                                  writetty:  ; *** PROC ***
  5151 00001EBA B40E                     mov  ah, 14
  5152 00001EBC BB0000                   mov  bx, 0
  5153 00001EBF CD10                     int  16
  5154                                  
  5155                                  ;-209 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5156                                  
  5157 00001EC1 C3                       ret
  5158                                  ; ENDP
  5159                                  ;Number of CALLs:    8 : cputs
  5160                                  
  5161                                  cputs:  ; *** PROC ***
  5162                                  ;Function : cputs, Number of local variables: 2
  5163                                  ;   # type sign width line used address name   list of local variables
  5164                                  ;  200 ptr sign byte   209 NULL bp+4    s
  5165                                  ;  201 var sign byte   209 NULL bp-2    c;
  5166 00001EC2 C8020000                 ENTER  2,0
  5167                                  @@cputs211:
  5168 00001EC6 8B5E04                   mov bx, [bp+4]
  5169 00001EC9 8A07                     mov al, [bx]
  5170 00001ECB B400                     mov ah, 0
  5171 00001ECD 08C0                     or  al, al
  5172 00001ECF 0F841B00                 je @@cputs212
  5173 00001ED3 8B5E04                   mov bx, [bp+4]
  5174 00001ED6 8A07                     mov al, [bx]
  5175 00001ED8 B400                     mov ah, 0
  5176 00001EDA 8846FE                   mov byte [bp-2], al
  5177 00001EDD 8A46FE                   mov al, byte [bp-2]
  5178 00001EE0 B400                     mov ah, 0
  5179 00001EE2 50                       push ax
  5180 00001EE3 E8C401                   call putch
  5181 00001EE6 83C402                   add  sp, 2
  5182 00001EE9 FF4604                   inc  word [bp+4]
  5183 00001EEC EBD8                     jmp @@cputs211
  5184                                  @@cputs212:
  5185                                  
  5186                                  ;-210 int mkneg(int n) { n; __asm {neg ax} }
  5187 00001EEE C9                       LEAVE
  5188 00001EEF C3                       ret
  5189                                  ; ENDP
  5190                                  ;Number of CALLs:    2 : toupper
  5191                                  
  5192                                  toupper:  ; *** PROC ***
  5193                                  ;Function : toupper, Number of local variables: 1
  5194                                  ;   # type sign width line used address name   list of local variables
  5195                                  ;  200 ptr sign byte   210 NULL bp+4    s;
  5196 00001EF0 C8000000                 ENTER  0,0
  5197                                  @@toupper213:
  5198 00001EF4 8B5E04                   mov bx, [bp+4]
  5199 00001EF7 8A07                     mov al, [bx]
  5200 00001EF9 B400                     mov ah, 0
  5201 00001EFB 08C0                     or  al, al
  5202 00001EFD 0F843000                 je @@toupper214
  5203 00001F01 8B5E04                   mov bx, [bp+4]
  5204 00001F04 8A07                     mov al, [bx]
  5205 00001F06 B400                     mov ah, 0
  5206 00001F08 83F861                   cmp ax, 97 ;unsigned : 1
  5207 00001F0B 0F8C1D00                 jl  @@toupper215
  5208 00001F0F 8B5E04                   mov bx, [bp+4]
  5209 00001F12 8A07                     mov al, [bx]
  5210 00001F14 B400                     mov ah, 0
  5211 00001F16 83F87A                   cmp ax, 122
  5212 00001F19 0F8F0F00                 jg  @@toupper216
  5213 00001F1D 8B5E04                   mov bx, [bp+4]
  5214 00001F20 8A07                     mov al, [bx]
  5215 00001F22 B400                     mov ah, 0
  5216 00001F24 83E820                   sub ax, 32
  5217 00001F27 8B5E04                   mov  bx, [bp+4]
  5218 00001F2A 8807                     mov  [bx], al
  5219                                  @@toupper216:
  5220                                  @@toupper215:
  5221 00001F2C FF4604                   inc  word [bp+4]
  5222 00001F2F EBC3                     jmp @@toupper213
  5223                                  @@toupper214:
  5224                                  
  5225                                  ;-211 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5226                                  
  5227                                  
  5228                                  ;-212 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5229 00001F31 C9                       LEAVE
  5230 00001F32 C3                       ret
  5231                                  ; ENDP
  5232                                  ;Number of CALLs:    4 : strlen
  5233                                  
  5234                                  strlen:  ; *** PROC ***
  5235                                  ;Function : strlen, Number of local variables: 2
  5236                                  ;   # type sign width line used address name   list of local variables
  5237                                  ;  200 ptr sign byte   212 NULL bp+4    s
  5238                                  ;  201 var sign word   212 NULL bp-2    c;
  5239 00001F33 C8020000                 ENTER  2,0
  5240 00001F37 66B800000000             mov eax, 0
  5241 00001F3D 8946FE                   mov word [bp-2], ax
  5242                                  @@strlen217:
  5243 00001F40 8B5E04                   mov bx, [bp+4]
  5244 00001F43 8A07                     mov al, [bx]
  5245 00001F45 B400                     mov ah, 0
  5246 00001F47 83F800                   cmp ax, 0
  5247 00001F4A 0F840800                 je  @@strlen218
  5248 00001F4E FF4604                   inc  word [bp+4]
  5249 00001F51 FF46FE                   inc  word [bp-2]
  5250 00001F54 EBEA                     jmp @@strlen217
  5251                                  @@strlen218:
  5252 00001F56 8B46FE                   mov ax, [bp-2]
  5253 00001F59 E90000                   jmp @@retn
  5254                                  
  5255                                  ;-213 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5256                                  
  5257 00001F5C C9                      @@retn: LEAVE
  5258 00001F5D C3                       ret
  5259                                  ; ENDP
  5260                                  ;Number of CALLs:    5 : strcpy
  5261                                  
  5262                                  strcpy:  ; *** PROC ***
  5263                                  ;Function : strcpy, Number of local variables: 2
  5264                                  ;   # type sign width line used address name   list of local variables
  5265                                  ;  200 ptr sign byte   213 NULL bp+4    s
  5266                                  ;  201 ptr sign byte   213 NULL bp+6    t;
  5267 00001F5E C8000000                 ENTER  0,0
  5268                                  @@strcpy219:
  5269 00001F62 8B5E06                   mov bx, [bp+6]
  5270 00001F65 8A07                     mov al, [bx]
  5271 00001F67 B400                     mov ah, 0
  5272 00001F69 8B5E04                   mov  bx, [bp+4]
  5273 00001F6C 8807                     mov  [bx], al
  5274 00001F6E FF4604                   inc  word [bp+4]
  5275 00001F71 FF4606                   inc  word [bp+6]
  5276                                  
  5277                                  ;-214   while (*t!=0); *s=0; return s; }
  5278                                  
  5279 00001F74 8B5E06                   mov bx, [bp+6]
  5280 00001F77 8A07                     mov al, [bx]
  5281 00001F79 B400                     mov ah, 0
  5282 00001F7B 83F800                   cmp ax, 0
  5283 00001F7E 0F840200                 je  @@strcpy220
  5284 00001F82 EBDE                     jmp @@strcpy219
  5285                                  @@strcpy220:
  5286 00001F84 66B800000000             mov eax, 0
  5287 00001F8A 8B5E04                   mov  bx, [bp+4]
  5288 00001F8D 8807                     mov  [bx], al
  5289 00001F8F 8B4604                   mov ax, [bp+4]
  5290 00001F92 E90000                   jmp @@retn
  5291                                  
  5292                                  ;-215 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5293                                  
  5294 00001F95 C9                      @@retn: LEAVE
  5295 00001F96 C3                       ret
  5296                                  ; ENDP
  5297                                  ;Number of CALLs:    3 : digit
  5298                                  
  5299                                  digit:  ; *** PROC ***
  5300                                  ;Function : digit, Number of local variables: 1
  5301                                  ;   # type sign width line used address name   list of local variables
  5302                                  ;  200 var sign byte   215 NULL bp+4    c;
  5303 00001F97 C8000000                 ENTER  0,0
  5304 00001F9B 8A4604                   mov al, [bp+4]
  5305 00001F9E 3C30                     cmp al, 48
  5306 00001FA0 0F8D0900                 jge @@digit221
  5307 00001FA4 66B800000000             mov eax, 0
  5308 00001FAA E91B00                   jmp @@retn
  5309                                  @@digit221:
  5310 00001FAD 8A4604                   mov al, [bp+4]
  5311 00001FB0 3C39                     cmp al, 57
  5312 00001FB2 0F8E0900                 jle @@digit222
  5313 00001FB6 66B800000000             mov eax, 0
  5314 00001FBC E90900                   jmp @@retn
  5315                                  @@digit222:
  5316 00001FBF 66B801000000             mov eax, 1
  5317 00001FC5 E90000                   jmp @@retn
  5318                                  
  5319                                  ;-216 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5320                                  
  5321 00001FC8 C9                      @@retn: LEAVE
  5322 00001FC9 C3                       ret
  5323                                  ; ENDP
  5324                                  ;Number of CALLs:   35 : eqstr
  5325                                  
  5326                                  eqstr:  ; *** PROC ***
  5327                                  ;Function : eqstr, Number of local variables: 2
  5328                                  ;   # type sign width line used address name   list of local variables
  5329                                  ;  200 ptr sign byte   216 NULL bp+4    p
  5330                                  ;  201 ptr sign byte   216 NULL bp+6    q;
  5331 00001FCA C8000000                 ENTER  0,0
  5332                                  @@eqstr223:
  5333 00001FCE 8B5E04                   mov bx, [bp+4]
  5334 00001FD1 8A07                     mov al, [bx]
  5335 00001FD3 B400                     mov ah, 0
  5336 00001FD5 08C0                     or  al, al
  5337 00001FD7 0F842300                 je @@eqstr224
  5338                                  
  5339                                  ;-217     if (*p != *q) return 0; p++; q++; }
  5340                                  
  5341 00001FDB 8B5E04                   mov bx, [bp+4]
  5342 00001FDE 8A07                     mov al, [bx]
  5343 00001FE0 B400                     mov ah, 0
  5344 00001FE2 8B5E06                   mov bx, [bp+6]
  5345 00001FE5 3A07                     cmp al, [bx]
  5346 00001FE7 B400                     mov ah, 0
  5347 00001FE9 0F840900                 je  @@eqstr225
  5348 00001FED 66B800000000             mov eax, 0
  5349 00001FF3 E92700                   jmp @@retn
  5350                                  @@eqstr225:
  5351 00001FF6 FF4604                   inc  word [bp+4]
  5352 00001FF9 FF4606                   inc  word [bp+6]
  5353                                  
  5354                                  ;-218     if(*q) return 0; return 1; }
  5355                                  
  5356 00001FFC EBD0                     jmp @@eqstr223
  5357                                  @@eqstr224:
  5358 00001FFE 8B5E06                   mov bx, [bp+6]
  5359 00002001 8A07                     mov al, [bx]
  5360 00002003 B400                     mov ah, 0
  5361 00002005 08C0                     or  al, al
  5362 00002007 0F840900                 je @@eqstr226
  5363 0000200B 66B800000000             mov eax, 0
  5364 00002011 E90900                   jmp @@retn
  5365                                  @@eqstr226:
  5366 00002014 66B801000000             mov eax, 1
  5367 0000201A E90000                   jmp @@retn
  5368                                  
  5369                                  ;-219 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5370                                  
  5371 0000201D C9                      @@retn: LEAVE
  5372 0000201E C3                       ret
  5373                                  ; ENDP
  5374                                  ;Number of CALLs:    3 : strcat1
  5375                                  
  5376                                  strcat1:  ; *** PROC ***
  5377                                  ;Function : strcat1, Number of local variables: 2
  5378                                  ;   # type sign width line used address name   list of local variables
  5379                                  ;  200 ptr sign byte   219 NULL bp+4    s
  5380                                  ;  201 ptr sign byte   219 NULL bp+6    t;
  5381 0000201F C8000000                 ENTER  0,0
  5382                                  @@strcat1227:
  5383 00002023 8B5E04                   mov bx, [bp+4]
  5384 00002026 8A07                     mov al, [bx]
  5385 00002028 B400                     mov ah, 0
  5386 0000202A 83F800                   cmp ax, 0
  5387 0000202D 0F840500                 je  @@strcat1228
  5388 00002031 FF4604                   inc  word [bp+4]
  5389 00002034 EBED                     jmp @@strcat1227
  5390                                  @@strcat1228:
  5391 00002036 FF7606                   push word [bp+6]
  5392 00002039 FF7604                   push word [bp+4]
  5393 0000203C E81FFF                   call strcpy
  5394 0000203F 83C404                   add  sp, 4
  5395                                  
  5396                                  ;-220 int basename(char *s) { char *p; p=0;
  5397 00002042 C9                       LEAVE
  5398 00002043 C3                       ret
  5399                                  ; ENDP
  5400                                  ;Number of CALLs:    1 : openR
  5401                                  
  5402                                  openR:  ; *** PROC ***
  5403                                  ;Function : openR, Number of local variables: 1
  5404                                  ;   # type sign width line used address name   list of local variables
  5405                                  ;  200 ptr sign byte   220 NULL bp+4    s;
  5406 00002044 C8000000                 ENTER  0,0
  5407 00002048 8B5604                   mov  dx, [bp+4]
  5408 0000204B B8023D                   mov  ax, 15618
  5409 0000204E E87200                   call DosInt
  5410                                  
  5411                                  ;-221 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5412 00002051 C9                       LEAVE
  5413 00002052 C3                       ret
  5414                                  ; ENDP
  5415                                  ;Number of CALLs:    2 : creatR
  5416                                  
  5417                                  creatR:  ; *** PROC ***
  5418                                  ;Function : creatR, Number of local variables: 1
  5419                                  ;   # type sign width line used address name   list of local variables
  5420                                  ;  200 ptr sign byte   221 NULL bp+4    s;
  5421 00002053 C8000000                 ENTER  0,0
  5422 00002057 8B5604                   mov  dx, [bp+4]
  5423 0000205A B90000                   mov  cx, 0
  5424 0000205D B8003C                   mov  ax, 15360
  5425 00002060 E86000                   call DosInt
  5426                                  
  5427                                  ;-222 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5428 00002063 C9                       LEAVE
  5429 00002064 C3                       ret
  5430                                  ; ENDP
  5431                                  ;Number of CALLs:    2 : readRL
  5432                                  
  5433                                  readRL:  ; *** PROC ***
  5434                                  ;Function : readRL, Number of local variables: 3
  5435                                  ;   # type sign width line used address name   list of local variables
  5436                                  ;  200 ptr sign byte   222 NULL bp+4    s
  5437                                  ;  201 var sign word   222 NULL bp+6    fd
  5438                                  ;  202 var sign word   222 NULL bp+8    len;
  5439 00002065 C8000000                 ENTER  0,0
  5440 00002069 8B5604                   mov  dx, [bp+4]
  5441 0000206C 8B4E08                   mov  cx, [bp+8]
  5442 0000206F 8B5E06                   mov  bx, [bp+6]
  5443 00002072 B8003F                   mov  ax, 16128
  5444 00002075 E84B00                   call DosInt
  5445                                  
  5446                                  ;-223 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5447 00002078 C9                       LEAVE
  5448 00002079 C3                       ret
  5449                                  ; ENDP
  5450                                  ;Number of CALLs:    2 : fputcR
  5451                                  
  5452                                  fputcR:  ; *** PROC ***
  5453                                  ;Function : fputcR, Number of local variables: 2
  5454                                  ;   # type sign width line used address name   list of local variables
  5455                                  ;  200 ptr sign byte   223 NULL bp+4    n
  5456                                  ;  201 var sign word   223 NULL bp+6    fd;
  5457 0000207A C8000000                 ENTER  0,0
  5458 0000207E 8D5604                  lea dx, [bp+4]
  5459                                  
  5460                                  ;-224   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5461                                  
  5462 00002081 B90100                   mov  cx, 1
  5463 00002084 8B5E06                   mov  bx, [bp+6]
  5464 00002087 B80040                   mov  ax, 16384
  5465 0000208A E83600                   call DosInt
  5466                                  
  5467                                  ;-225 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5468 0000208D C9                       LEAVE
  5469 0000208E C3                       ret
  5470                                  ; ENDP
  5471                                  ;Number of CALLs:    3 : fcloseR
  5472                                  
  5473                                  fcloseR:  ; *** PROC ***
  5474                                  ;Function : fcloseR, Number of local variables: 1
  5475                                  ;   # type sign width line used address name   list of local variables
  5476                                  ;  200 var sign word   225 NULL bp+4    fd;
  5477 0000208F C8000000                 ENTER  0,0
  5478 00002093 8B5E04                   mov  bx, [bp+4]
  5479 00002096 B8003E                   mov  ax, 15872
  5480 00002099 CD21                     int  33
  5481                                  
  5482                                  ;-226 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5483 0000209B C9                       LEAVE
  5484 0000209C C3                       ret
  5485                                  ; ENDP
  5486                                  ;Number of CALLs:    5 : exitR
  5487                                  
  5488                                  exitR:  ; *** PROC ***
  5489                                  ;Function : exitR, Number of local variables: 1
  5490                                  ;   # type sign width line used address name   list of local variables
  5491                                  ;  200 var sign byte   226 NULL bp+4    c;
  5492 0000209D C8000000                 ENTER  0,0
  5493 000020A1 B44C                     mov  ah, 76
  5494 000020A3 8A4604                   mov  al, [bp+4]
  5495 000020A6 CD21                     int  33
  5496                                  
  5497                                  ;-227 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5498 000020A8 C9                       LEAVE
  5499 000020A9 C3                       ret
  5500                                  ; ENDP
  5501                                  ;End of archive file. 
  5502                                   
  5503                                  ; missing functions: 
  5504                                  ; putch
  5505                                  ; DosInt
  5506                                  ; DosInt
  5507                                  ; DosInt
  5508                                  ; DosInt
  5509                                  ; Number of unresolved CALLs :    5
  5510                                  ;use archive file: AR.C
  5511                                  
  5512                                  ;-228 // AR.C Archive
  5513                                  
  5514                                  ;Number of CALLs:    1 : putch
  5515                                  
  5516                                  putch:  ; *** PROC ***
  5517                                  ;Function : putch, Number of local variables: 1
  5518                                  ;   # type sign width line used address name   list of local variables
  5519                                  ;  200 var sign byte   228 NULL bp+4    c;
  5520 000020AA C8000000                 ENTER  0,0
  5521 000020AE 807E040A                cmp byte [bp+4], 10
  5522 000020B2 0F850500                 jne @@putch229
  5523 000020B6 B00D                     mov  al, 13
  5524 000020B8 E8FFFD                   call writetty
  5525                                  @@putch229:
  5526 000020BB 8A4604                   mov  al, [bp+4]
  5527 000020BE E8F9FD                   call writetty
  5528                                  
  5529                                  ;-229 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5530 000020C1 C9                       LEAVE
  5531 000020C2 C3                       ret
  5532                                  ; ENDP
  5533                                  ;Number of CALLs:    4 : DosInt
  5534                                  
  5535                                  DosInt:  ; *** PROC ***
  5536 000020C3 CD21                     int  33
  5537 000020C5 7304                     jae short @@DosInt230
  5538 000020C7 FF06[3000]               inc  word [DOS_ERR]
  5539                                  @@DosInt230:
  5540                                  
  5541                                  ;-230 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5542                                  
  5543 000020CB C3                       ret
  5544                                  ; ENDP
  5545                                  ;End of archive file. 
  5546                                   
  5547                                  ; missing functions:  All FUNCTIONs in place
  5548 000020CC E80000                  LastFunctionByt:db 0E8h, 0, 0
  5549 000020CF 58                      pop ax
  5550 000020D0 C3                      ret
  5551                                   
  5552                                  ;   # type sign width line used  address name   list of global variables
  5553                                  
  5554                                  ;    1 arr sign byte     2    2        0 Version1[20]
  5555                                  ;    2 var sign byte     1    3        0 LIST
  5556                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5557                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5558                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5559                                  ;    6 var unsg word     5   12        0 SymbolInt
  5560                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5561                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5562                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5563                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5564                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5565                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5566                                  ;   13 var sign word    12    4        0 asm_fd
  5567                                  ;   14 var sign word    13    3        0 lst_fd
  5568                                  ;   15 var sign word    14    3        0 bin_fd
  5569                                  ;   16 var sign word    15    6        0 DOS_ERR
  5570                                  ;   17 var sign word    16    4        0 ErrorCount
  5571                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5572                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5573                                  ;   20 var unsg word    20    5        0 PC
  5574                                  ;   21 var unsg word    21    2        0 PCStart
  5575                                  ;   22 var sign byte    22    3        0 isLabel
  5576                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5577                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5578                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5579                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5580                                  ;   27 var sign byte    27   20        0 TokeType
  5581                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5582                                  ;   29 def unsg byte    29    -        0 WORD=2
  5583                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5584                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5585                                  ;   32 def unsg byte    33    -        0 IMM=1
  5586                                  ;   33 def unsg byte    34    -        0 REG=2
  5587                                  ;   34 def unsg byte    35    -        0 ADR=3
  5588                                  ;   35 def unsg byte    36    -        0 MEM=4
  5589                                  ;   36 var sign byte    37   13        0 Op1
  5590                                  ;   37 var sign byte    38   12        0 CodeType
  5591                                  ;   38 var sign byte    40   17        0 RegType
  5592                                  ;   39 var sign byte    41   10        0 RegNo
  5593                                  ;   40 var sign byte    42   10        0 OpSize
  5594                                  ;   41 var sign byte    44 NULL        0 NumOprns
  5595                                  ;   42 var sign byte    45    5        0 wflag
  5596                                  ;   43 var sign byte    46 NULL        0 dflag
  5597                                  ;   44 var sign byte    48    4        0 reg
  5598                                  ;   45 var sign word    49   13        0 disp
  5599                                  ;   46 var sign word    50    2        0 imme
  5600                                  ;   47 def unsg byte    52    -        0 OPMAXLEN=5
  5601                                  ;   48 arr sign byte    53    2    30390 OpPos[5]
  5602                                  ;   49 var sign word    54    6        0 OpPrintIndex
  5603                                  ;   50 ptr sign byte    55   16        0 OpCodePtr
  5604                                  ;   51 var sign byte    56    2        0 PrReloc
  5605                                  ;   52 def unsg byte    58    -        0 LABELNAMESMAX=969
  5606                                  ;   53 arr sign byte    59    3    30395 LabelNames[1000]
  5607                                  ;   54 ptr sign byte    60   10        0 LabelNamePtr
  5608                                  ;   55 def unsg byte    61    -        0 LABELADRMAX=100
  5609                                  ;   56 arr unsg word    62    4    31395 LabelAddr[100]
  5610                                  ;   57 var sign word    63    5        0 LabelMaxIx
  5611                                  ;   58 var sign word    64    4        0 LabelIx
  5612                                  ;   59 def unsg byte    66    -        0 FILEBINMAX=1990
  5613                                  ;   60 arr sign byte    67    3    31595 FileBin[2000]
  5614                                  ;   61 var unsg word    68    5        0 BinLen
  5615                                  ;   62 ptr sign byte    70    1        0 arglen
  5616                                  ;   63 ptr sign byte    71    4        0 argv
  5617                                  ;   64 var sign byte     1    1        0 I_START
  5618                                  ;   65 arr sign byte     4 NULL        0 I_PUSHA[9]
  5619                                  ;   66 arr sign byte     5 NULL        0 I_POPA[8]
  5620                                  ;   67 arr sign byte     6 NULL        0 I_NOP[7]
  5621                                  ;   68 arr sign byte     7 NULL        0 I_CBW[7]
  5622                                  ;   69 arr sign byte     8 NULL        0 I_CWDE[8]
  5623                                  ;   70 arr sign byte     9 NULL        0 I_CWD[7]
  5624                                  ;   71 arr sign byte    10 NULL        0 I_CDQ[7]
  5625                                  ;   72 arr sign byte    11 NULL        0 I_WAIT[8]
  5626                                  ;   73 arr sign byte    12 NULL        0 I_PUSHF[9]
  5627                                  ;   74 arr sign byte    13 NULL        0 I_POPF[8]
  5628                                  ;   75 arr sign byte    14 NULL        0 I_SAHF[8]
  5629                                  ;   76 arr sign byte    15 NULL        0 I_LAHF[8]
  5630                                  ;   77 arr sign byte    16 NULL        0 I_MOVSB[9]
  5631                                  ;   78 arr sign byte    17 NULL        0 I_MOVSW[9]
  5632                                  ;   79 arr sign byte    18 NULL        0 I_CMPSB[9]
  5633                                  ;   80 arr sign byte    19 NULL        0 I_CMPSW[9]
  5634                                  ;   81 arr sign byte    20 NULL        0 I_STOSB[9]
  5635                                  ;   82 arr sign byte    21 NULL        0 I_STOSW[9]
  5636                                  ;   83 arr sign byte    22 NULL        0 I_LODSB[9]
  5637                                  ;   84 arr sign byte    23 NULL        0 I_LODSW[9]
  5638                                  ;   85 arr sign byte    24 NULL        0 I_SCASB[9]
  5639                                  ;   86 arr sign byte    25 NULL        0 I_SCASW[9]
  5640                                  ;   87 arr sign byte    26 NULL        0 I_LEAVE[9]
  5641                                  ;   88 arr sign byte    27 NULL        0 I_IRET[8]
  5642                                  ;   89 arr sign byte    28 NULL        0 I_XLAT[8]
  5643                                  ;   90 arr sign byte    29 NULL        0 I_LOCK[8]
  5644                                  ;   91 arr sign byte    30 NULL        0 I_REPNE[9]
  5645                                  ;   92 arr sign byte    31 NULL        0 I_REPNZ[9]
  5646                                  ;   93 arr sign byte    32 NULL        0 I_REPE[8]
  5647                                  ;   94 arr sign byte    33 NULL        0 I_REPZ[8]
  5648                                  ;   95 arr sign byte    34 NULL        0 I_HLT[7]
  5649                                  ;   96 arr sign byte    35 NULL        0 I_CLC[7]
  5650                                  ;   97 arr sign byte    36 NULL        0 I_STC[7]
  5651                                  ;   98 arr sign byte    37 NULL        0 I_CLI[7]
  5652                                  ;   99 arr sign byte    38 NULL        0 I_STI[7]
  5653                                  ;  100 arr sign byte    39 NULL        0 I_CLD[7]
  5654                                  ;  101 arr sign byte    40 NULL        0 I_STD[7]
  5655                                  ;  102 arr sign byte    42 NULL        0 I_INC[9]
  5656                                  ;  103 arr sign byte    43 NULL        0 I_DEC[9]
  5657                                  ;  104 arr sign byte    45 NULL        0 I_NOT[8]
  5658                                  ;  105 arr sign byte    46 NULL        0 I_NEG[8]
  5659                                  ;  106 arr sign byte    47 NULL        0 I_MUL[8]
  5660                                  ;  107 arr sign byte    48 NULL        0 I_IMUL[9]
  5661                                  ;  108 arr sign byte    49 NULL        0 I_DIV[8]
  5662                                  ;  109 arr sign byte    50 NULL        0 I_IDIV[9]
  5663                                  ;  110 arr sign byte    52 NULL        0 I_LES[7]
  5664                                  ;  111 arr sign byte    53 NULL        0 I_LDS[7]
  5665                                  ;  112 arr sign byte    54 NULL        0 I_LEA[7]
  5666                                  ;  113 arr sign byte    56 NULL        0 I_ADD[7]
  5667                                  ;  114 arr sign byte    57 NULL        0 I_OR[6]
  5668                                  ;  115 arr sign byte    58 NULL        0 I_ADC[7]
  5669                                  ;  116 arr sign byte    59 NULL        0 I_SBB[7]
  5670                                  ;  117 arr sign byte    60 NULL        0 I_AND[7]
  5671                                  ;  118 arr sign byte    61 NULL        0 I_SUB[7]
  5672                                  ;  119 arr sign byte    62 NULL        0 I_XOR[7]
  5673                                  ;  120 arr sign byte    63 NULL        0 I_CMP[7]
  5674                                  ;  121 arr sign byte    65 NULL        0 I_MOV[6]
  5675                                  ;  122 arr sign byte    66 NULL        0 I_MOVSX[9]
  5676                                  ;  123 arr sign byte    67 NULL        0 I_MOVZX[9]
  5677                                  ;  124 arr sign byte    69 NULL        0 I_JO[6]
  5678                                  ;  125 arr sign byte    70 NULL        0 I_JNO[7]
  5679                                  ;  126 arr sign byte    71 NULL        0 I_JB[6]
  5680                                  ;  127 arr sign byte    72 NULL        0 I_JC[6]
  5681                                  ;  128 arr sign byte    73 NULL        0 I_JNB[7]
  5682                                  ;  129 arr sign byte    74 NULL        0 I_JAE[7]
  5683                                  ;  130 arr sign byte    75 NULL        0 I_JNC[7]
  5684                                  ;  131 arr sign byte    76 NULL        0 I_JE[6]
  5685                                  ;  132 arr sign byte    77 NULL        0 I_JZ[6]
  5686                                  ;  133 arr sign byte    78 NULL        0 I_JNE[7]
  5687                                  ;  134 arr sign byte    79 NULL        0 I_JNZ[7]
  5688                                  ;  135 arr sign byte    80 NULL        0 I_JBE[7]
  5689                                  ;  136 arr sign byte    81 NULL        0 I_JNA[7]
  5690                                  ;  137 arr sign byte    82 NULL        0 I_JA[6]
  5691                                  ;  138 arr sign byte    83 NULL        0 I_JS[6]
  5692                                  ;  139 arr sign byte    84 NULL        0 I_JNS[7]
  5693                                  ;  140 arr sign byte    85 NULL        0 I_JP[6]
  5694                                  ;  141 arr sign byte    86 NULL        0 I_JPE[7]
  5695                                  ;  142 arr sign byte    87 NULL        0 I_JNP[7]
  5696                                  ;  143 arr sign byte    88 NULL        0 I_JPO[7]
  5697                                  ;  144 arr sign byte    89 NULL        0 I_JL[6]
  5698                                  ;  145 arr sign byte    90 NULL        0 I_JNL[7]
  5699                                  ;  146 arr sign byte    91 NULL        0 I_JGE[7]
  5700                                  ;  147 arr sign byte    92 NULL        0 I_JLE[7]
  5701                                  ;  148 arr sign byte    93 NULL        0 I_JNG[7]
  5702                                  ;  149 arr sign byte    94 NULL        0 I_JG[6]
  5703                                  ;  150 arr sign byte    96 NULL        0 I_JMP[8]
  5704                                  ;  151 arr sign byte    97 NULL        0 I_CALL[9]
  5705                                  ;  152 arr sign byte    99 NULL        0 I_RET[8]
  5706                                  ;  153 arr sign byte   100 NULL        0 I_RETF[9]
  5707                                  ;  154 arr sign byte   102 NULL        0 I_PUSH[8]
  5708                                  ;  155 arr sign byte   103 NULL        0 I_POP[7]
  5709                                  ;  156 arr sign byte   105 NULL        0 I_ROL[7]
  5710                                  ;  157 arr sign byte   106 NULL        0 I_ROR[7]
  5711                                  ;  158 arr sign byte   107 NULL        0 I_RCL[7]
  5712                                  ;  159 arr sign byte   108 NULL        0 I_RCR[7]
  5713                                  ;  160 arr sign byte   109 NULL        0 I_SHL[7]
  5714                                  ;  161 arr sign byte   110 NULL        0 I_SAL[7]
  5715                                  ;  162 arr sign byte   111 NULL        0 I_SHR[7]
  5716                                  ;  163 arr sign byte   112 NULL        0 I_SAR[7]
  5717                                  ;  164 arr sign byte   114 NULL        0 I_INT[8]
  5718                                  ;  165 arr sign byte   115 NULL        0 I_INTO[8]
  5719                                  ;  166 arr sign byte   117 NULL        0 I_IN[7]
  5720                                  ;  167 arr sign byte   118 NULL        0 I_INSB[8]
  5721                                  ;  168 arr sign byte   119 NULL        0 I_INSW[8]
  5722                                  ;  169 arr sign byte   120 NULL        0 I_INSD[8]
  5723                                  ;  170 arr sign byte   121 NULL        0 I_OUT[8]
  5724                                  ;  171 arr sign byte   122 NULL        0 I_OUTSB[8]
  5725                                  ;  172 arr sign byte   123 NULL        0 I_OUTSW[8]
  5726                                  ;  173 arr sign byte   124 NULL        0 I_OUTSD[8]
  5727                                  ;  174 arr sign byte   126 NULL        0 I_XCHG[9]
  5728                                  ;  175 arr sign byte   128 NULL        0 I_LOOPNZ[10]
  5729                                  ;  176 arr sign byte   129 NULL        0 I_LOOPNE[10]
  5730                                  ;  177 arr sign byte   130 NULL        0 I_LOOPZ[9]
  5731                                  ;  178 arr sign byte   131 NULL        0 I_LOOPE[9]
  5732                                  ;  179 arr sign byte   132 NULL        0 I_LOOP[8]
  5733                                  ;  180 arr sign byte   133 NULL        0 I_JCXZ[8]
  5734                                  ;  181 arr sign byte   134 NULL        0 I_JECXZ[9]
  5735                                  ;  182 arr sign byte   136 NULL        0 I_ENTER[9]
  5736                                  ;  183 arr sign byte   138 NULL        0 I_ORG[6]
  5737                                  ;  184 arr sign byte   139 NULL        0 I_DB[5]
  5738                                  ;  185 arr sign byte   140 NULL        0 I_DW[5]
  5739                                  ;  186 arr sign byte   141 NULL        0 I_DD[5]
  5740                                  ;  187 arr sign byte   142 NULL        0 I_RESB[7]
  5741                                  ;  188 arr sign byte   143 NULL        0 I_RESW[7]
  5742                                  ;  189 arr sign byte   144 NULL        0 I_RESD[7]
  5743                                  ;  190 var sign byte   145 NULL        0 I_END
  5744                                  
  5745                                  
  5746                                  ;   # Calls Line Width  Name   list of functions
  5747                                  
  5748                                  ;    0 NULL    1 word   main
  5749                                  ;    1    1    6 word   process
  5750                                  ;    2    1   47 word   setwflag
  5751                                  ;    3    2   67 word   LeftOpwCheck
  5752                                  ;    4    1   78 word   getLeftOp
  5753                                  ;    5    2   90 word   getOp1
  5754                                  ;    6    1  104 word   getMEM
  5755                                  ;    7    1  125 word   getIndReg1
  5756                                  ;    8    1  134 word   getIndReg2
  5757                                  ;    9    1  145 word   gen66h
  5758                                  ;   10    8  146 word   genCode8
  5759                                  ;   11    3  156 word   genCode16
  5760                                  ;   12    7  160 word   genInstruction
  5761                                  ;   13    2  166 word   genCodeInREG
  5762                                  ;   14 NULL  171 word   genModRegRM
  5763                                  ;   15    2  173 word   writeEA
  5764                                  ;   16 NULL  194 word   testx
  5765                                  ;   17    1    1 word   parse
  5766                                  ;   18   12   27 word   getTokeType
  5767                                  ;   19    2   36 word   storeLabel
  5768                                  ;   20    2   43 word   searchLabel
  5769                                  ;   21    1   54 word   getVariable
  5770                                  ;   22    2   83 word   lookCode
  5771                                  ;   23    1   97 word   getCodeSize
  5772                                  ;   24    7  104 word   isToken
  5773                                  ;   25    1  109 word   skipRest
  5774                                  ;   26    1    1 word   getLine
  5775                                  ;   27    1   14 word   ifEOL
  5776                                  ;   28    3   21 word   skipBlank
  5777                                  ;   29    2   26 word   letterE
  5778                                  ;   30    1   36 word   alnumE
  5779                                  ;   31    1   41 word   getDigit
  5780                                  ;   32    1   53 word   getName
  5781                                  ;   33    1   70 word   testReg
  5782                                  ;   34    1    1 word   printLine
  5783                                  ;   35    9   19 word   prc
  5784                                  ;   36    1   23 word   prscomment
  5785                                  ;   37   24   26 word   prs
  5786                                  ;   38    4   31 word   printhex8a
  5787                                  ;   39    2   35 word   printhex16
  5788                                  ;   40    3   38 word   printIntU
  5789                                  ;   41   19   45 word   error1
  5790                                  ;   42 NULL   48 word   allowederror
  5791                                  ;   43 NULL   49 word   implmerror
  5792                                  ;   44    4   50 word   indexerror
  5793                                  ;   45    1   51 word   numbererror
  5794                                  ;   46 NULL   52 word   regmemerror
  5795                                  ;   47    1   53 word   segregerror
  5796                                  ;   48    1   54 word   syntaxerror
  5797                                  ;   49    7   56 word   errorexit
  5798                                  ;   50    1   57 word   addrexit
  5799                                  ;   51 NULL   58 word   internexit
  5800                                  ;   52    1    1 word   getarg
  5801                                  ;   53    1   26 word   epilog
  5802                                  ;   54    2   57 word   end1
  5803                                  ;   55    4  208 word   writetty
  5804                                  ;   56    8  209 word   cputs
  5805                                  ;   57    2  210 word   toupper
  5806                                  ;   58    4  212 word   strlen
  5807                                  ;   59    6  213 word   strcpy
  5808                                  ;   60    3  215 word   digit
  5809                                  ;   61   35  216 word   eqstr
  5810                                  ;   62    3  219 word   strcat1
  5811                                  ;   63    1  220 word   openR
  5812                                  ;   64    2  221 word   creatR
  5813                                  ;   65    2  222 word   readRL
  5814                                  ;   66    2  223 word   fputcR
  5815                                  ;   67    3  225 word   fcloseR
  5816                                  ;   68    5  226 word   exitR
  5817                                  ;   69    1  228 word   putch
  5818                                  ;   70    4  229 word   DosInt
  5819                                  ;   71 NULL  230 word   LastFunctionByt
  5820                                  
  5821                                  ;    #  addr name   list of CALLs
  5822                                  
  5823                                  ;    0     5 getarg
  5824                                  ;    1    12 parse
  5825                                  ;    2    18 epilog
  5826                                  ;    3    25 end1
  5827                                  ;    4  1371 getTokeType
  5828                                  ;    5  1383 getCodeSize
  5829                                  ;    6  1395 genInstruction
  5830                                  ;    7  1410 LeftOpwCheck
  5831                                  ;    8  1423 genInstruction
  5832                                  ;    9  1438 genInstruction
  5833                                  ;   10  1453 genInstruction
  5834                                  ;   11  1468 genCodeInREG
  5835                                  ;   12  1481 LeftOpwCheck
  5836                                  ;   13  1494 genInstruction
  5837                                  ;   14  1509 genCodeInREG
  5838                                  ;   15  1522 genInstruction
  5839                                  ;   16  1537 genCode16
  5840                                  ;   17  1547 genInstruction
  5841                                  ;   18  1562 error1
  5842                                  ;   19  1569 error1
  5843                                  ;   20  1585 gen66h
  5844                                  ;   21  1605 getLeftOp
  5845                                  ;   22  1615 segregerror
  5846                                  ;   23  1627 setwflag
  5847                                  ;   24  1636 error1
  5848                                  ;   25  1643 error1
  5849                                  ;   26  1650 error1
  5850                                  ;   27  1667 getOp1
  5851                                  ;   28  1674 isToken
  5852                                  ;   29  1682 getMEM
  5853                                  ;   30  1689 error1
  5854                                  ;   31  1696 error1
  5855                                  ;   32  1710 testReg
  5856                                  ;   33  1718 searchLabel
  5857                                  ;   34  1730 error1
  5858                                  ;   35  1751 getTokeType
  5859                                  ;   36  1763 getOp1
  5860                                  ;   37  1770 syntaxerror
  5861                                  ;   38  1782 getIndReg2
  5862                                  ;   39  1793 getIndReg1
  5863                                  ;   40  1804 isToken
  5864                                  ;   41  1812 getTokeType
  5865                                  ;   42  1824 numbererror
  5866                                  ;   43  1836 isToken
  5867                                  ;   44  1844 isToken
  5868                                  ;   45  1852 errorexit
  5869                                  ;   46  1875 indexerror
  5870                                  ;   47  1886 indexerror
  5871                                  ;   48  1913 indexerror
  5872                                  ;   49  1924 indexerror
  5873                                  ;   50  1942 genCode8
  5874                                  ;   51  1974 genCode8
  5875                                  ;   52  1983 genCode8
  5876                                  ;   53  2016 genCode8
  5877                                  ;   54  2040 writeEA
  5878                                  ;   55  2060 writeEA
  5879                                  ;   56  2084 addrexit
  5880                                  ;   57  2093 genCode8
  5881                                  ;   58  2102 genCode8
  5882                                  ;   59  2111 genCode16
  5883                                  ;   60  2133 getLine
  5884                                  ;   61  2141 getTokeType
  5885                                  ;   62  2153 storeLabel
  5886                                  ;   63  2164 getTokeType
  5887                                  ;   64  2176 lookCode
  5888                                  ;   65  2185 process
  5889                                  ;   66  2193 getVariable
  5890                                  ;   67  2205 skipRest
  5891                                  ;   68  2214 error1
  5892                                  ;   69  2221 error1
  5893                                  ;   70  2228 printLine
  5894                                  ;   71  2252 skipBlank
  5895                                  ;   72  2262 digit
  5896                                  ;   73  2268 getDigit
  5897                                  ;   74  2277 letterE
  5898                                  ;   75  2285 getName
  5899                                  ;   76  2304 searchLabel
  5900                                  ;   77  2316 error1
  5901                                  ;   78  2323 strcpy
  5902                                  ;   79  2350 eqstr
  5903                                  ;   80  2356 strlen
  5904                                  ;   81  2377 storeLabel
  5905                                  ;   82  2388 getTokeType
  5906                                  ;   83  2400 lookCode
  5907                                  ;   84  2409 errorexit
  5908                                  ;   85  2419 errorexit
  5909                                  ;   86  2429 getTokeType
  5910                                  ;   87  2441 genCode8
  5911                                  ;   88  2450 skipBlank
  5912                                  ;   89  2460 isToken
  5913                                  ;   90  2468 genCode8
  5914                                  ;   91  2477 isToken
  5915                                  ;   92  2485 getTokeType
  5916                                  ;   93  2497 genCode16
  5917                                  ;   94  2507 isToken
  5918                                  ;   95  2515 errorexit
  5919                                  ;   96  2534 eqstr
  5920                                  ;   97  2552 eqstr
  5921                                  ;   98  2558 getTokeType
  5922                                  ;   99  2570 eqstr
  5923                                  ;  100  2576 getTokeType
  5924                                  ;  101  2588 eqstr
  5925                                  ;  102  2594 getTokeType
  5926                                  ;  103  2616 skipBlank
  5927                                  ;  104  2635 getTokeType
  5928                                  ;  105  2647 prs
  5929                                  ;  106  2659 readRL
  5930                                  ;  107  2666 errorexit
  5931                                  ;  108  2676 ifEOL
  5932                                  ;  109  2690 readRL
  5933                                  ;  110  2726 digit
  5934                                  ;  111  2732 letterE
  5935                                  ;  112  2759 digit
  5936                                  ;  113  2777 alnumE
  5937                                  ;  114  2784 strcpy
  5938                                  ;  115  2791 toupper
  5939                                  ;  116  2807 strlen
  5940                                  ;  117  2814 strlen
  5941                                  ;  118  2821 eqstr
  5942                                  ;  119  2827 eqstr
  5943                                  ;  120  2833 eqstr
  5944                                  ;  121  2839 eqstr
  5945                                  ;  122  2845 eqstr
  5946                                  ;  123  2851 eqstr
  5947                                  ;  124  2857 eqstr
  5948                                  ;  125  2863 eqstr
  5949                                  ;  126  2869 eqstr
  5950                                  ;  127  2875 eqstr
  5951                                  ;  128  2881 eqstr
  5952                                  ;  129  2887 eqstr
  5953                                  ;  130  2893 eqstr
  5954                                  ;  131  2899 eqstr
  5955                                  ;  132  2905 eqstr
  5956                                  ;  133  2911 eqstr
  5957                                  ;  134  2917 eqstr
  5958                                  ;  135  2923 eqstr
  5959                                  ;  136  2929 eqstr
  5960                                  ;  137  2935 eqstr
  5961                                  ;  138  2941 eqstr
  5962                                  ;  139  2947 eqstr
  5963                                  ;  140  2953 eqstr
  5964                                  ;  141  2959 eqstr
  5965                                  ;  142  2965 eqstr
  5966                                  ;  143  2971 eqstr
  5967                                  ;  144  2977 eqstr
  5968                                  ;  145  2983 eqstr
  5969                                  ;  146  2989 eqstr
  5970                                  ;  147  2995 eqstr
  5971                                  ;  148  3015 prs
  5972                                  ;  149  3019 printhex16
  5973                                  ;  150  3030 prs
  5974                                  ;  151  3034 prc
  5975                                  ;  152  3038 printhex8a
  5976                                  ;  153  3049 prc
  5977                                  ;  154  3053 prs
  5978                                  ;  155  3057 prscomment
  5979                                  ;  156  3074 writetty
  5980                                  ;  157  3083 writetty
  5981                                  ;  158  3092 fputcR
  5982                                  ;  159  3114 prc
  5983                                  ;  160  3130 prc
  5984                                  ;  161  3151 prc
  5985                                  ;  162  3155 prc
  5986                                  ;  163  3177 printhex8a
  5987                                  ;  164  3188 printhex8a
  5988                                  ;  165  3213 printIntU
  5989                                  ;  166  3223 prc
  5990                                  ;  167  3236 prs
  5991                                  ;  168  3240 prs
  5992                                  ;  169  3244 prs
  5993                                  ;  170  3248 prs
  5994                                  ;  171  3265 error1
  5995                                  ;  172  3283 error1
  5996                                  ;  173  3301 error1
  5997                                  ;  174  3320 error1
  5998                                  ;  175  3339 error1
  5999                                  ;  176  3358 error1
  6000                                  ;  177  3377 error1
  6001                                  ;  178  3396 error1
  6002                                  ;  179  3403 end1
  6003                                  ;  180  3417 errorexit
  6004                                  ;  181  3438 errorexit
  6005                                  ;  182  3467 cputs
  6006                                  ;  183  3473 cputs
  6007                                  ;  184  3479 exitR
  6008                                  ;  185  3485 toupper
  6009                                  ;  186  3493 strcpy
  6010                                  ;  187  3500 strcat1
  6011                                  ;  188  3508 strcpy
  6012                                  ;  189  3515 strcat1
  6013                                  ;  190  3523 strcpy
  6014                                  ;  191  3530 strcat1
  6015                                  ;  192  3538 openR
  6016                                  ;  193  3544 cputs
  6017                                  ;  194  3550 cputs
  6018                                  ;  195  3556 exitR
  6019                                  ;  196  3562 creatR
  6020                                  ;  197  3569 cputs
  6021                                  ;  198  3575 cputs
  6022                                  ;  199  3581 exitR
  6023                                  ;  200  3587 creatR
  6024                                  ;  201  3594 cputs
  6025                                  ;  202  3600 cputs
  6026                                  ;  203  3606 exitR
  6027                                  ;  204  3612 prs
  6028                                  ;  205  3616 prs
  6029                                  ;  206  3620 prs
  6030                                  ;  207  3624 prs
  6031                                  ;  208  3628 prs
  6032                                  ;  209  3632 prs
  6033                                  ;  210  3636 prs
  6034                                  ;  211  3640 prs
  6035                                  ;  212  3644 prs
  6036                                  ;  213  3661 prs
  6037                                  ;  214  3665 printIntU
  6038                                  ;  215  3675 prs
  6039                                  ;  216  3679 prs
  6040                                  ;  217  3683 prs
  6041                                  ;  218  3687 prc
  6042                                  ;  219  3691 printhex16
  6043                                  ;  220  3702 prs
  6044                                  ;  221  3706 strlen
  6045                                  ;  222  3713 prs
  6046                                  ;  223  3717 printIntU
  6047                                  ;  224  3727 prs
  6048                                  ;  225  3731 prc
  6049                                  ;  226  3735 printhex8a
  6050                                  ;  227  3746 fputcR
  6051                                  ;  228  3760 fcloseR
  6052                                  ;  229  3768 fcloseR
  6053                                  ;  230  3776 fcloseR
  6054                                  ;  231  3784 exitR
  6055                                  ;  232  3809 putch
  6056                                  ;  233  3877 strcpy
  6057                                  ;  234  3892 DosInt
  6058                                  ;  235  3908 DosInt
  6059                                  ;  236  3931 DosInt
  6060                                  ;  237  3950 DosInt
  6061                                  ;  238  3984 writetty
  6062                                  ;  239  3993 writetty
  6063                                  ;Input: AS.C, List: AS.S,  Lines:  231
  6064                                  ;Glob. variables:  190 max.:  200
  6065                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  6066                                  ;Functions      :   72 max.:  300
  6067                                  ;Calls          :  240 max.: 2000, NameField: 4025 max.:    65535
  6068                                  ;Code until     :26009 max.: 30000, free: 3991
  6069                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6070                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
